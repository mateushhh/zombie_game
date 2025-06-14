# Network
HOST = "127.0.0.1"
PORT = 2137

# Game settings
SERVER_TICK_RATE = 0.01  # sekundy (np. 0.02 dla 50Hz)
MIN_PLAYERS_TO_START = 2
GAME_COUNTDOWN_SECONDS = 5
MAP_MIN_X, MAP_MAX_X = 30, 400
MAP_MIN_Y, MAP_MAX_Y = 30, 265
ATTACK_RANGE_SQ = 15 ** 2
GAME_DURATION_SECONDS = 180

# Players roles
ROLE_HUMAN = 0
ROLE_ZOMBIE = 1

# Message prefixes
MSG_PREFIX_JOIN_CONFIRMATION = "J"

MSG_PREFIX_GAME_TIMER = "T"
MSG_CLIENT_JOIN_REQUEST = "/join"
MSG_CLIENT_READY = "/ready"
MSG_CLIENT_POSITION_UPDATE = "P"
MSG_CLIENT_COLLISION = "C"
MSG_PREFIX_PLAYER_STATE_UPDATE = "P"
MSG_PREFIX_GAME_OVER = "G"
MSG_PREFIX_LOBBY ="L"
MSG_CLIENT_LEFT = "/left"
MSG_PREFIX_START_GAME = "S"

# Logging
LOG_FORMAT = '%(asctime)s - %(threadName)s - %(levelname)s - %(module)s - %(message)s'