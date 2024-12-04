"""Create phone number for User column

Revision ID: 1e458ba90866
Revises: 
Create Date: 2024-11-23 16:38:25.803953

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.engine.reflection import Inspector


# revision identifiers, used by Alembic.
revision: str = "1e458ba90866"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create an inspector to check if column exists
    conn = op.get_bind()
    inspector = Inspector.from_engine(conn)
    columns = [col["name"] for col in inspector.get_columns("users")]

    # Only add the column if it doesn't exist
    if "phone_number" not in columns:
        op.add_column("users", sa.Column("phone_number", sa.String(), nullable=True))


def downgrade() -> None:
    # Try to drop the column, ignore if it doesn't exist
    try:
        op.drop_column("users", "phone_number")
    except Exception:
        pass
