package models

type Avatar struct {
	ID     uint   `gorm:"primaryKey" json:"id"`
	UserID uint   `gorm:"not null" json:"user_id"`
	Path   string `gorm:"not null" json:"path"`
}
