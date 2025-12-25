"""
Configuration file for the application
"""

import os
from urllib.parse import quote_plus
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    """Base configuration"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Database configuration - loaded from .env file or environment variables
    DB_USER = os.environ.get('DB_USER', 'root')
    DB_PASSWORD = os.environ.get('DB_PASSWORD')  # Must be set in .env file
    DB_HOST = os.environ.get('DB_HOST', 'localhost')
    DB_NAME = os.environ.get('DB_NAME', 'musicwrappeddatabase')
    
    # Validate that password is set
    if not DB_PASSWORD:
        raise ValueError(
            "Database password not found! Please create a .env file with DB_PASSWORD.\n"
            "See .env.example for reference."
        )
    
    # URL-encode the password to handle special characters like @, !, etc.
    ENCODED_PASSWORD = quote_plus(DB_PASSWORD)
    
    SQLALCHEMY_DATABASE_URI = f'mysql+pymysql://{DB_USER}:{ENCODED_PASSWORD}@{DB_HOST}/{DB_NAME}'
    SQLALCHEMY_ECHO = False
    
    # User roles
    ROLE_ADMIN = 'Administrator'
    ROLE_CONTENT_MANAGER = 'Content_Manager'
    ROLE_DATA_ANALYST = 'Data_Analyst'
    ROLE_END_USER = 'End_User'
    ROLE_ARTIST = 'Artist'
    
    # MySQL User Credentials (from users.sql)
    MYSQL_USER_PASSWORDS = {
        'End_User': os.environ.get('END_USER_PASSWORD', 'MWB_End_User'),
        'Content_Manager': os.environ.get('CONTENT_MANAGER_PASSWORD', 'MWB_Content_Manager'),
        'Data_Analyst': os.environ.get('DATA_ANALYST_PASSWORD', 'MWB_Data_Analyst'),
        'Artist': os.environ.get('ARTIST_PASSWORD', 'MWB_Artist'),
        'Administrator': os.environ.get('ADMINISTRATOR_PASSWORD', 'MWB_Admin')
    }
    
    @staticmethod
    def get_db_uri_for_role(role):
        """Get database URI for a specific role using MySQL users from users.sql"""
        from urllib.parse import quote_plus
        password = Config.MYSQL_USER_PASSWORDS.get(role, Config.MYSQL_USER_PASSWORDS['End_User'])
        encoded_password = quote_plus(password)
        return f'mysql+pymysql://{role}:{encoded_password}@{Config.DB_HOST}/{Config.DB_NAME}'
