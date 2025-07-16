package api

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func init() {
	gin.SetMode(gin.TestMode)
}

func getTestContext(method, path string, body []byte, token string) (*gin.Context, *httptest.ResponseRecorder) {
	rec := httptest.NewRecorder()
	req := httptest.NewRequest(method, path, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	ctx, _ := gin.CreateTestContext(rec)
	ctx.Request = req

	if token != "" {
		ctx.Set("jwt", token)
	} else {
		ctx.Set("jwt", "")
	}
	return ctx, rec
}

func TestCreateProfile_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("POST", "/profile", nil, "")
	CreateProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestCreateProfile_InvalidJSON(t *testing.T) {
	ctx, rec := getTestContext("POST", "/profile", []byte(`{invalid json}`), "validtoken")
	CreateProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetProfile_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("GET", "/profile", nil, "")
	GetProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetProfile_InvalidUserID(t *testing.T) {
	ctx, rec := getTestContext("GET", "/profile?user_id=abc", nil, "validtoken")
	GetProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400 for invalid user_id, got %d", rec.Code)
	}
}

func TestUpdateProfile_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("PATCH", "/profile", nil, "")
	UpdateProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestUpdateProfile_InvalidJSON(t *testing.T) {
	ctx, rec := getTestContext("PATCH", "/profile", []byte(`{name:bad}`), "validtoken")
	UpdateProfile(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestUpdateInterests_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("PUT", "/interests", nil, "")
	UpdateInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestUpdateInterests_InvalidJSON(t *testing.T) {
	ctx, rec := getTestContext("PUT", "/interests", []byte(`not a json`), "validtoken")
	UpdateInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetInterests_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("GET", "/interests", nil, "")
	GetInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetInterests_InvalidUserID(t *testing.T) {
	ctx, rec := getTestContext("GET", "/interests?user_id=xyz", nil, "validtoken")
	GetInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetAllInterests_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("GET", "/interests/cats", nil, "")
	GetAllInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetUsersByInterests_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("GET", "/interests/all?page_num=1&interests=book", nil, "")
	GetUsersByInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetUsersByInterests_InvalidPageNum(t *testing.T) {
	ctx, rec := getTestContext("GET", "/interests/all?page_num=0&interests=book", nil, "validtoken")
	GetUsersByInterests(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400 for invalid page_num, got %d", rec.Code)
	}
}

func TestUpdateAvatar_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("PUT", "/avatar", nil, "")

	rec.Code = 0
	UpdateAvatar(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}

func TestGetAvatar_NoJWT(t *testing.T) {
	ctx, rec := getTestContext("GET", "/avatar", nil, "")
	GetAvatar(ctx)
	if rec.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", rec.Code)
	}
}
