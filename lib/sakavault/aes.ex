defmodule SakaVault.AES do
  @moduledoc false

  # Use AES 256 Bit Keys for Encryption.
  @mode :aes_gcm
  @aad "AES256GCM"

  def encrypt(plain_text, key) do
    secret_key = :base64.decode(key)
    initial_vector = :crypto.strong_rand_bytes(16)

    {cipher, tag} =
      :crypto.block_encrypt(
        @mode,
        secret_key,
        initial_vector,
        {@aad, to_string(plain_text), 16}
      )

    initial_vector <> tag <> cipher
  end

  def decrypt(cipher_text, key) do
    secret_key = :base64.decode(key)

    <<
      initial_vector::binary-16,
      tag::binary-16,
      cipher_text::binary
    >> = cipher_text

    :crypto.block_decrypt(
      @mode,
      secret_key,
      initial_vector,
      {@aad, cipher_text, tag}
    )
  end
end
