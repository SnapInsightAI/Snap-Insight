import os
import requests
from dotenv import load_dotenv
import base64

CATEGORIES = {
    "Food and Cooking": {
        "subcategories": [
            "Recipe suggestions based on ingredients",
            "Nutritional information",
            "Cooking techniques and tips",
            "Dietary advice and meal planning"
        ],
        "triggers": [
            "Raw ingredients (vegetables, fruits, meat, spices)",
            "Cooked dishes",
            "Kitchen utensils and appliances",
            "Recipe books or cooking instructions"
        ]
    },
    "Travel and Tourism": {
        "subcategories": [
            "Information on landmarks and tourist attractions",
            "Nearby hotels, restaurants, and activities",
            "Local customs and travel tips",
            "Historical facts about the location"
        ],
        "triggers": [
            "Famous landmarks and monuments",
            "Natural landscapes (mountains, beaches, forests)",
            "Travel gear (luggage, passports, maps)",
            "Tourist activities (sightseeing, local events)"
        ]
    },
    "Health and Fitness": {
        "subcategories": [
            "Workout routines and exercises",
            "Nutritional advice and meal plans",
            "Fitness tips and motivational content",
            "Equipment usage guides"
        ],
        "triggers": [
            "Gym equipment (dumbbells, treadmills, yoga mats)",
            "Sports gear (running shoes, jerseys, balls)",
            "Workout environments (gyms, parks, home workout spaces)",
            "Healthy foods and supplements"
        ]
    },
    "Gardening and Plants": {
        "subcategories": [
            "Plant identification and care instructions",
            "Gardening tips and techniques",
            "Information on plant species and growth conditions",
            "Pest control and disease management"
        ],
        "triggers": [
            "Plants and flowers",
            "Gardening tools (shovels, pots, watering cans)",
            "Garden layouts and designs",
            "Pests and plant diseases"
        ]
    },
    "Pet Care": {
        "subcategories": [
            "Pet care tips and feeding schedules",
            "Information about different breeds",
            "Training and behavior advice",
            "Health and wellness tips for pets"
        ],
        "triggers": [
            "Pets (dogs, cats, birds, fish)",
            "Pet accessories (leashes, collars, toys)",
            "Pet food and treats",
            "Pet grooming supplies"
        ]
    },
    "Home Improvement and DIY": {
        "subcategories": [
            "Step-by-step guides for home improvement projects",
            "Tool and material recommendations",
            "DIY tips and techniques",
            "Safety guidelines"
        ],
        "triggers": [
            "Construction tools (hammers, drills, saws)",
            "Building materials (wood, bricks, paint)",
            "Home renovation projects",
            "DIY crafts and projects"
        ]
    },
    "Fashion and Clothing": {
        "subcategories": [
            "Outfit suggestions and styling tips",
            "Information about fashion trends",
            "Care instructions for different fabrics",
            "Personalization based on user preferences"
        ],
        "triggers": [
            "Clothing items (shirts, dresses, shoes)",
            "Accessories (jewelry, hats, bags)",
            "Fashion magazines and lookbooks",
            "Wardrobe setups"
        ]
    },
    "Technology and Gadgets": {
        "subcategories": [
            "Reviews and comparisons of gadgets",
            "Tips for using and maintaining devices",
            "Information on software and apps",
            "Troubleshooting guides"
        ],
        "triggers": [
            "Electronic devices (smartphones, laptops, tablets)",
            "Gadgets (smartwatches, headphones, cameras)",
            "Tech accessories (chargers, cases, cables)",
            "User manuals and tech guides"
        ]
    },
    "Art and Crafts": {
        "subcategories": [
            "Craft project ideas and instructions",
            "Art techniques and tips",
            "Information on art supplies",
            "Inspiration and creativity prompts"
        ],
        "triggers": [
            "Art supplies (paintbrushes, canvases, clay)",
            "Finished artworks (paintings, sculptures, crafts)",
            "Craft materials (paper, glue, scissors)",
            "Workspaces for art and crafting"
        ]
    },
    "Educational Content": {
        "subcategories": [
            "Study tips and educational resources",
            "Information about different subjects",
            "Language learning aids",
            "Skill development guides"
        ],
        "triggers": [
            "Books and textbooks",
            "Study spaces (desks, computers, notebooks)",
            "Educational tools (calculators, whiteboards, flashcards)",
            "Learning environments (classrooms, libraries)"
        ]
    },
    "Home Décor": {
        "subcategories": [
            "Interior design tips and ideas",
            "Furniture and decor recommendations",
            "DIY home decor projects",
            "Color scheme and styling advice"
        ],
        "triggers": [
            "Furniture (sofas, tables, chairs)",
            "Decor items (vases, paintings, lamps)",
            "Room setups (living rooms, bedrooms, kitchens)",
            "Design elements (color schemes, patterns)"
        ]
    },
    "Automotive": {
        "subcategories": [
            "Car maintenance and repair tips",
            "Reviews and comparisons of vehicles",
            "Driving tips and safety guidelines",
            "Information about automotive technology"
        ],
        "triggers": [
            "Cars and motorcycles",
            "Automotive tools (wrenches, jacks, tire gauges)",
            "Car interiors (dashboards, seats, controls)",
            "Maintenance activities (oil changes, tire rotations)"
        ]
    },
    "Outdoor Activities": {
        "subcategories": [
            "Camping and hiking tips",
            "Information about outdoor gear",
            "Safety guidelines for outdoor activities",
            "Tips for different weather conditions"
        ],
        "triggers": [
            "Camping gear (tents, backpacks, sleeping bags)",
            "Hiking trails and natural scenery",
            "Outdoor sports equipment (bikes, kayaks, climbing gear)",
            "Outdoor clothing and footwear"
        ]
    },
    "Events and Entertainment": {
        "subcategories": [
            "Information about local events and festivals",
            "Movie and book recommendations",
            "Entertainment tips and trends",
            "Event planning guides"
        ],
        "triggers": [
            "Event setups (stages, decorations, seating)",
            "Entertainment media (movies, books, games)",
            "Party supplies (balloons, streamers, cakes)",
            "Performance activities (concerts, theater, sports events)"
        ]
    },
    "Financial Advice": {
        "subcategories": [
            "Budgeting and saving tips",
            "Investment advice",
            "Information about financial products",
            "Tips for managing debt"
        ],
        "triggers": [
            "Financial documents (bank statements, credit cards, bills)",
            "Money-related items (cash, coins, wallets)",
            "Financial tools (calculators, spreadsheets, apps)",
            "Investment symbols (stock charts, real estate)"
        ]
    }
}

# Function to call Gemini API and process the response
def getCatImgData(prompt: str, image_bytes: bytes):
    # Load environment variables from .env file
    load_dotenv(dotenv_path='app/.env')
    
    GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
    base64_image = base64.b64encode(image_bytes).decode("utf-8")
    
    parts = [{"text": "Analyze the given image and determine its category. Then, identify the subcategory and its subsequent trigger point, followed by a detailed description."
        }]
    
    for category, details in CATEGORIES.items():
        parts.append({"text": category})
        for subcategory in details["subcategories"]:
            parts.append({"text": subcategory})
        for trigger in details["triggers"]:
            parts.append({"text": trigger})
    
    parts.append({
        "inline_data": {
            "mime_type": "image/jpeg",
            "data": base64_image
        }
    })
    
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={GOOGLE_API_KEY}"
    headers = {
        'Content-Type': 'application/json',
    }
    
    data = {
        "contents": [
            {
                "parts": parts
            }
        ]
    }
    
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.text}

# Function to send a conversation turn to the API
def sendConversationTurn(conversation_history):
    # Load environment variables from .env file
    load_dotenv(dotenv_path='app/.env')

    # Get the API key from the environment
    GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
    
    API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={GOOGLE_API_KEY}"

    headers = {
        'Content-Type': 'application/json',
    }
    
    data = {
        "contents": conversation_history
    }
    
    response = requests.post(API_URL, headers=headers, json=data)
    
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.text}