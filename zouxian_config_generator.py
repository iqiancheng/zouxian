import plistlib
import base64
import hashlib
from uuid import uuid4

def read_file(filename):
    with open(filename, 'r') as f:
        return f.read()

def create_mobileconfig():
    zouxian_script = read_file('zouxian.sh')
    launchd_plist = read_file('cat.me0w.zouxian.plist')

    # Generate content hashes for version control
    script_hash = hashlib.md5(zouxian_script.encode()).hexdigest()
    plist_hash = hashlib.md5(launchd_plist.encode()).hexdigest()

    profile = {
        'PayloadContent': [
            {
                'PayloadType': 'com.apple.ManagedClient.preferences',
                'PayloadVersion': 1,
                'PayloadIdentifier': f'cat.me0w.zouxian.script.{uuid4()}',
                'PayloadUUID': str(uuid4()),
                'PayloadEnabled': True,
                'PayloadDisplayName': 'Zouxian Apple Intelligence Script',
                'PayloadContent': {
                    'com.apple.sh': {
                        'Forced': [
                            {
                                'mcx_preference_settings': {
                                    'ZouxianAppleIntelligenceScript': base64.b64encode(zouxian_script.encode()).decode(),
                                    'ZouxianScriptVersion': script_hash  # Add version control
                                }
                            }
                        ]
                    }
                }
            },
            {
                'PayloadType': 'com.apple.ManagedClient.preferences',
                'PayloadVersion': 1,
                'PayloadIdentifier': f'cat.me0w.zouxian.launchd.{uuid4()}',
                'PayloadUUID': str(uuid4()),
                'PayloadEnabled': True,
                'PayloadDisplayName': 'Zouxian Apple Intelligence LaunchD',
                'PayloadContent': {
                    'com.apple.launchd': {
                        'Forced': [
                            {
                                'mcx_preference_settings': {
                                    'ZouxianAppleIntelligenceLaunchD': base64.b64encode(launchd_plist.encode()).decode(),
                                    'ZouxianLaunchDVersion': plist_hash  # Add version control
                                }
                            }
                        ]
                    }
                }
            },
            {
                'PayloadType': 'com.apple.mcx.FileVault2',
                'PayloadVersion': 1,
                'PayloadIdentifier': f'cat.me0w.zouxian.files.{uuid4()}',
                'PayloadUUID': str(uuid4()),
                'PayloadEnabled': True,
                'PayloadDisplayName': 'Zouxian Apple Intelligence File Placement',
                'Payload': [
                    {
                        'Path': '/usr/local/bin/zouxian',
                        'Content': base64.b64encode(zouxian_script.encode()).decode(),
                        'Mode': '0755',
                        'CheckPeriodic': True,  # Enable periodic checks
                        'Hash': script_hash,  # Add hash for version control
                    },
                    {
                        'Path': '/Library/LaunchDaemons/cat.me0w.zouxian.plist',
                        'Content': base64.b64encode(launchd_plist.encode()).decode(),
                        'Mode': '0644',
                        'CheckPeriodic': True,  # Enable periodic checks
                        'Hash': plist_hash,  # Add hash for version control
                    }
                ]
            }
        ],
        'PayloadDisplayName': 'Zouxian Apple Intelligence Configuration',
        'PayloadDescription': 'Enables Apple Intelligence and Xcode LLM features on China models of Mac',
        'PayloadIdentifier': f'cat.me0w.zouxian.configuration.{uuid4()}',
        'PayloadRemovalDisallowed': False,
        'PayloadType': 'Configuration',
        'PayloadUUID': str(uuid4()),
        'PayloadVersion': 1,
    }

    with open('zouxian.mobileconfig', 'wb') as f:
        plistlib.dump(profile, f)

if __name__ == '__main__':
    create_mobileconfig()