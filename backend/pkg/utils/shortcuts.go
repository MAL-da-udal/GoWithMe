package utils

import (
	"errors"
	"github.com/golang-jwt/jwt/v5"
)

var (
	ErrClaimDoesNotExists error = errors.New("claim does not exists")
	ErrClaimIsNotNumeric  error = errors.New("claim is not numeric value")
	ErrClaimIsNotString   error = errors.New("claim is not string value")
)

func GetIntFromClaims(claims jwt.MapClaims, key string) (int, error) {
	if num, exists := claims[key]; exists {
		if val, ok := num.(float64); ok {
			return int(val), nil
		} else {
			return 0, ErrClaimIsNotNumeric
		}
	} else {
		return 0, ErrClaimDoesNotExists
	}
}

func GetStringFromClaims(claims jwt.MapClaims, key string) (string, error) {
	if str, exists := claims[key]; exists {
		if val, ok := str.(string); ok {
			return val, nil
		} else {
			return "", ErrClaimIsNotString
		}
	} else {
		return "", ErrClaimDoesNotExists
	}
}
