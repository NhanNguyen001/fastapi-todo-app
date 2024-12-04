"""Create test column for User column

Revision ID: 13fcf33e3197
Revises: 1e458ba90866
Create Date: 2024-12-04 10:19:58.916187

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "13fcf33e3197"
down_revision: Union[str, None] = "1e458ba90866"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("users", sa.Column("test", sa.String(), nullable=True))


def downgrade() -> None:
    op.drop_column("users", "test")
