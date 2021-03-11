# Prototype - 5.	Evaluationg and Testing Redis cache on localhost computer
# using Docker containers.
 
import redis

#For production, I will use GitHub Repository Secrects
#Connecting to local Redis Cache using Docker Container
#REDIS_PORT = 6379
#REDIS_HOST = '127.0.0.1'

#r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

#For production, I will use GitHub Repository Secrects
#Connecting to Azure Redis Cache
REDIS_PORT = 6380
REDIS_HOST = 'nsc-redis-dev-usw2-tuesday.redis.cache.windows.net'
REDIS_KEY = ''

r = redis.StrictRedis(host=REDIS_HOST, port=6380, db=0, password=REDIS_KEY, ssl=True)

print("Ping returned : " + str(r.ping()))
print("SET Message: " + str(r.set("Message01", "Hello World")))
print("GET Message: " + (r.get("Message01")).decode("utf-8"))