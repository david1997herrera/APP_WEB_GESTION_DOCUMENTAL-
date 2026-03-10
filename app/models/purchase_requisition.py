from datetime import datetime
from app.config import db


class PurchaseRequisition(db.Model):
    __tablename__ = 'purchase_requisitions'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)

    amount = db.Column(db.Numeric(12, 2), nullable=True)

    status = db.Column(
        db.String(20),
        nullable=False,
        default='enviada',
    )  # enviada, revisada, aprobada

    requester_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    # Usuario al que va dirigida la requisición (revisor/aprobador principal)
    target_user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    reviewer_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    approver_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    reviewed_at = db.Column(db.DateTime, nullable=True)
    approved_at = db.Column(db.DateTime, nullable=True)

    requester = db.relationship('User', foreign_keys=[requester_id], backref='purchase_requisitions')
    target_user = db.relationship('User', foreign_keys=[target_user_id])
    reviewer = db.relationship('User', foreign_keys=[reviewer_id])
    approver = db.relationship('User', foreign_keys=[approver_id])

    def get_status_badge_class(self) -> str:
        mapping = {
            'enviada': 'bg-secondary',
            'revisada': 'bg-info',
            'aprobada': 'bg-success',
        }
        return mapping.get(self.status, 'bg-secondary')

    def __repr__(self):
        return f'<PurchaseRequisition {self.title}>'

