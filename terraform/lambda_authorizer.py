import json
import os
ALLOWED_TOKENS = set(os.environ.get("ALLOWED_TOKENS", "").split(","))  # set via env var
def lambda_handler(event, context):
    # For HTTP API (APIGWv2) the incoming payload is request context
    try:
        token = None
        # header may be "authorization" or "Authorization"
        headers = event.get('headers') or {}
        auth_header = headers.get('authorization') or headers.get('Authorization')
        if auth_header:
            # expected "Bearer <token>"
            parts = auth_header.split()
            if len(parts) == 2 and parts[0].lower() == 'bearer':
                token = parts[1]
        if not token:
            return generate_policy(False)
        if token in ALLOWED_TOKENS:
            # return allow policy for APIGW custom authorizer format (v2 may differ)
            return generate_policy(True, principal_id="user")
        else:
            return generate_policy(False)
    except Exception as e:
        print("Error in authorizer:", e)
        return generate_policy(False)
def generate_policy(allow, principal_id="anonymous"):
    effect = "Allow" if allow else "Deny"
    return {
        "principalId": principal_id,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": effect,
                    "Resource": ["*"]
                }
            ]
        },
        "context": {
          "role": "user" if allow else "anonymous"
        }
    }