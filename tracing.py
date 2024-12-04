from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.resources import Resource
from opentelemetry.trace.status import Status, StatusCode
from contextvars import ContextVar
from fastapi import Request
import logging
import time
import json

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Context variable to store request ID
request_id_ctx = ContextVar("request_id", default=None)

def setup_tracing(app, service_name="fastapi-todo-app"):
    """Setup OpenTelemetry tracing with OTLP exporter"""
    
    # Create a TracerProvider
    provider = TracerProvider(
        resource=Resource.create({
            "service.name": service_name,
            "service.namespace": "todo-app",
            "service.version": "1.0.0"
        })
    )
    
    # Create and add OTLP exporter
    otlp_exporter = OTLPSpanExporter(
        endpoint="http://tempo:4317",  # Tempo OTLP gRPC endpoint
        insecure=True
    )
    provider.add_span_processor(BatchSpanProcessor(otlp_exporter))
    
    # Set the TracerProvider
    trace.set_tracer_provider(provider)
    
    # Instrument FastAPI
    FastAPIInstrumentor.instrument_app(app)

async def request_lifecycle_middleware(request: Request, call_next):
    """Middleware to log request lifecycle events"""
    
    # Get current tracer
    tracer = trace.get_tracer(__name__)
    
    with tracer.start_as_current_span("http_request") as span:
        start_time = time.time()
        
        # Extract request details
        method = request.method
        url = str(request.url)
        client_host = request.client.host if request.client else "unknown"
        
        # Add request details to span
        span.set_attribute("http.method", method)
        span.set_attribute("http.url", url)
        span.set_attribute("http.client_ip", client_host)
        
        # Log request start
        logger.info(f"Request started: {method} {url} from {client_host}")
        
        try:
            # Get request body if available
            if request.method in ["POST", "PUT", "PATCH"]:
                body = await request.body()
                if body:
                    try:
                        body_str = body.decode()
                        span.set_attribute("http.request_body", body_str)
                        logger.info(f"Request body: {body_str}")
                    except:
                        pass
            
            # Process request
            response = await call_next(request)
            
            # Calculate duration
            duration = time.time() - start_time
            
            # Add response details to span
            span.set_attribute("http.status_code", response.status_code)
            span.set_attribute("http.duration", duration)
            
            # Log response
            logger.info(
                f"Request completed: {method} {url} - "
                f"Status: {response.status_code} - "
                f"Duration: {duration:.3f}s"
            )
            
            return response
            
        except Exception as e:
            # Log error and add to span
            error_msg = str(e)
            logger.error(f"Request failed: {method} {url} - Error: {error_msg}")
            
            span.set_status(Status(StatusCode.ERROR))
            span.record_exception(e)
            
            raise

def get_request_id():
    """Get the current request ID"""
    return request_id_ctx.get() 