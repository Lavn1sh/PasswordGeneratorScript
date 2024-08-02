# PasswordGeneratorScript
A very simple password generator script for bash designed for **Arch based systems**.
The ``password_generator.sh`` script checks if you have **OpenSSL** in your Arch based system and installs it if it is not installed.Then it generates passwords according to the user's needs with OpenSSL.
The ``openssl_password_gen.sh`` can also be used to generate password in any UNIX based system if you already have OpenSSL installed. You can check if OpenSSL is installed with ``openssl version`` command.
# Steps
1. Clone the repository to your machine.
2. ``cd`` into the **PasswordGeneratorScript** directory.
3. Make the script executable with ``chmod +x password_generator.sh``.
4. Execute the script with ``./password_generator.sh``
- **Note** : You can execute the ``openssl_password_gen.sh`` script similarly in case of non Arch based distros.