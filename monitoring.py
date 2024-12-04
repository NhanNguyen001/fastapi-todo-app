import time
import logging
from typing import Callable
from fastapi import Request, Response, FastAPI
from starlette.middleware.base import BaseHTTPMiddleware
from datetime import datetime
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from prometheus_fastapi_instrumentator import Instrumentator, metrics

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter(
    'app_request_count',
    'Application Request Count',
    ['method', 'endpoint', 'status_code']
)

REQUEST_LATENCY = Histogram(
    'app_request_latency_seconds',
    'Application Request Latency',
    ['method', 'endpoint']
)

ERROR_COUNT = Counter(
    'app_error_count',
    'Application Error Count',
    ['method', 'endpoint', 'error_type']
)

# Initialize instrumentator globally
instrumentator = Instrumentator(
    should_group_status_codes=False,
    should_ignore_untemplated=True,
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/metrics"],
    inprogress_name="fastapi_requests_inprogress",
    inprogress_labels=True,
)

# Configure default metrics
instrumentator.add(
    metrics.request_size(
        should_include_handler=True,
        should_include_method=True,
        should_include_status=True,
        metric_namespace="fastapi",
        metric_subsystem="requests",
    )
).add(
    metrics.response_size(
        should_include_handler=True,
        should_include_method=True,
        should_include_status=True,
        metric_namespace="fastapi",
        metric_subsystem="responses",
    )
).add(
    metrics.latency(
        should_include_handler=True,
        should_include_method=True,
        should_include_status=True,
        metric_namespace="fastapi",
        metric_subsystem="requests",
    )
).add(
    metrics.requests(
        should_include_handler=True,
        should_include_method=True,
        should_include_status=True,
        metric_namespace="fastapi",
        metric_subsystem="requests",
    )
)

def metrics_endpoint():
    """Generate Prometheus metrics response."""
    return Response(
        generate_latest(),
        media_type=CONTENT_TYPE_LATEST
    )

class MonitoringMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        start_time = time.time()
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        method = request.method
        path = request.url.path
        
        try:
            # Process the request
            response = await call_next(request)
            
            # Calculate response time
            process_time = time.time() - start_time
            
            # Update Prometheus metrics
            REQUEST_COUNT.labels(
                method=method,
                endpoint=path,
                status_code=response.status_code
            ).inc()
            
            REQUEST_LATENCY.labels(
                method=method,
                endpoint=path
            ).observe(process_time)
            
            # Log successful request
            logger.info(
                f"[{timestamp}] {method} {path} "
                f"- Status: {response.status_code} "
                f"- Time: {process_time:.3f}s"
            )
            
            return response
            
        except Exception as e:
            # Update error metrics
            ERROR_COUNT.labels(
                method=method,
                endpoint=path,
                error_type=type(e).__name__
            ).inc()
            
            # Log error
            logger.error(
                f"[{timestamp}] {method} {path} "
                f"- Error: {str(e)}"
            )
            raise

def setup_monitoring(app: FastAPI):
    """Setup Prometheus monitoring with FastAPI instrumentator"""
    
    # Instrument app
    instrumentator.instrument(app)

    # Add metrics endpoint
    app.get("/metrics", include_in_schema=True, tags=["monitoring"])(metrics_endpoint) 