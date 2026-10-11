#!/usr/bin/env python3
import os
import json
import time

STATE_DIR = os.path.expanduser("~/.local/share/study-timer")
os.makedirs(STATE_DIR, exist_ok=True)

def _get_path(service):
    return os.path.join(STATE_DIR, f"{service}_lockout.json")

def _load_state(service):
    path = _get_path(service)
    if not os.path.exists(path):
        return {"attempts_left": 3, "lockout_until": 0}
    try:
        with open(path, "r") as f:
            return json.load(f)
    except Exception:
        return {"attempts_left": 3, "lockout_until": 0}

def _save_state(service, state):
    path = _get_path(service)
    with open(path, "w") as f:
        json.dump(state, f, indent=2)

def check_lockout(service):
    """
    Returns (is_locked_out, minutes_remaining)
    """
    state = _load_state(service)
    now = time.time()
    lockout_until = state.get("lockout_until", 0)
    
    if lockout_until > now:
        rem_seconds = lockout_until - now
        rem_minutes = int(rem_seconds // 60) + 1
        return True, rem_minutes
    
    # If lockout expired, reset attempts to 3
    if lockout_until != 0 and lockout_until <= now:
        state["attempts_left"] = 3
        state["lockout_until"] = 0
        _save_state(service, state)
        
    return False, 0

def get_attempts_left(service):
    state = _load_state(service)
    return state.get("attempts_left", 3)

def record_failure(service):
    """
    Decrements attempts. If 0, applies 30-minute (1800s) lockout.
    Returns (attempts_left, is_locked_out)
    """
    state = _load_state(service)
    attempts = state.get("attempts_left", 3) - 1
    
    if attempts <= 0:
        state["attempts_left"] = 0
        state["lockout_until"] = time.time() + 1800  # 30 minutes
        _save_state(service, state)
        return 0, True
    else:
        state["attempts_left"] = attempts
        _save_state(service, state)
        return attempts, False

def record_success(service):
    state = {"attempts_left": 3, "lockout_until": 0}
    _save_state(service, state)
