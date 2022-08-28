extends Node

enum PadType {NONE, PKCS7}

var S_BOX = [
	PackedByteArray([0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76]),
	PackedByteArray([0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0]),
	PackedByteArray([0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15]),
	PackedByteArray([0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75]),
	PackedByteArray([0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84]),
	PackedByteArray([0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf]),
	PackedByteArray([0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8]),
	PackedByteArray([0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2]),
	PackedByteArray([0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73]),
	PackedByteArray([0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb]),
	PackedByteArray([0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79]),
	PackedByteArray([0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08]),
	PackedByteArray([0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a]),
	PackedByteArray([0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e]),
	PackedByteArray([0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf]),
	PackedByteArray([0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16])
]

var S_BOX_INVERSE = [
	PackedByteArray([0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb]),
	PackedByteArray([0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb]),
	PackedByteArray([0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e]),
	PackedByteArray([0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25]),
	PackedByteArray([0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92]),
	PackedByteArray([0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84]),
	PackedByteArray([0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06]),
	PackedByteArray([0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b]),
	PackedByteArray([0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73]),
	PackedByteArray([0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e]),
	PackedByteArray([0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b]),
	PackedByteArray([0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4]),
	PackedByteArray([0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f]),
	PackedByteArray([0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef]),
	PackedByteArray([0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61]),
	PackedByteArray([0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d])
]
	
var MIX_MATRIX = [
	PackedByteArray([0x02, 0x03, 0x01, 0x01]),
	PackedByteArray([0x01, 0x02, 0x03, 0x01]),
	PackedByteArray([0x01, 0x01, 0x02, 0x03]),
	PackedByteArray([0x03, 0x01, 0x01, 0x02])
]

var MIX_MATRIX_INVERSE = [
	PackedByteArray([0x0E, 0x0B, 0x0D, 0x09]),
	PackedByteArray([0x09, 0x0E, 0x0B, 0x0D]),
	PackedByteArray([0x0D, 0x09, 0x0E, 0x0B]),
	PackedByteArray([0x0B, 0x0D, 0x09, 0x0E])
]

var RCI = PackedByteArray([
	0x01, 0x02, 0x04, 0x08,
	0x10, 0x20, 0x40, 0x80,
	0x1B, 0x36
])

func rand_bytes(size):
	if typeof(size) != TYPE_INT:
		printerr("Size must be an integer")
		return null
	elif size < 0:
		printerr("Size must be positive")
		return null
	var bytes = PackedByteArray()
	bytes.resize(size)
	for i in range(size):
		bytes[i] = randi() % 256
	return bytes

func encrypt(plaintext, key, iv = null, pad_type = PadType.PKCS7):
	plaintext = _to_raw_array(plaintext)
	if plaintext == null:
		printerr("Invalid plaintext format")
		return null
	
	match pad_type:
		PadType.NONE:
			if plaintext.size() % 16 != 0:
				printerr("Invalid plaintext size. Must be multiple of 16 bytes for no padding")
				return null
		PadType.PKCS7:
			var padding = 16 - (plaintext.size() % 16)
			for i in range(padding):
				plaintext.append(padding)
		_:
			printerr("Invalid pad type selected")
			return null
	
	key = _format_key(key)
	if key == null:
		return null
	
	if iv != null:
		iv = _format_iv(iv)
		if iv == null:
			return null
	
	var keys = _key_schedule(key)
	var ciphertext = PackedByteArray()
	for i in range(plaintext.size() / 16):
		var block = plaintext.subarray(i * 16, i * 16 + 15)
		if iv != null:
			for j in range(16):
				block[j] ^= iv[j]
		block = _encrypt_block(block, keys)
		ciphertext.append_array(block)
		if iv != null:
			iv = block
	return ciphertext

func decrypt(ciphertext, key, iv = null, pad_type = PadType.PKCS7):
	ciphertext = _to_raw_array(ciphertext)
	if ciphertext == null:
		printerr("Invalid ciphertext format")
		return null
	elif ciphertext.size() % 16 != 0:
		printerr("Invalid ciphertext size. Must be multiple of 16 bytes")
		return null
	
	key = _format_key(key)
	if key == null:
		return null
	
	if iv != null:
		iv = _format_iv(iv)
		if iv == null:
			return null
	
	if not PadType.values().has(pad_type):
		print(PadType.keys())
		printerr("Invalid pad type selected")
		return null
	
	var keys = _key_schedule(key)
	var plaintext = PackedByteArray()
	for i in range(ciphertext.size() / 16):
		var cipherblock = ciphertext.subarray(i * 16, i * 16 + 15)
		var plainblock = _decrypt_block(cipherblock, keys)
		if iv != null:
			for j in range(16):
				plainblock[j] ^= iv[j]
			iv = cipherblock
		plaintext.append_array(plainblock)
	match pad_type:
		PadType.NONE:
			pass
		PadType.PKCS7:
			var padding_value = plaintext[plaintext.size() - 1]
			if padding_value < 1 or padding_value > 16:
				printerr("Error detected while decrypting: invalid padding value")
				return null
			var padding = plaintext.subarray(plaintext.size() - padding_value, plaintext.size() - 1)
			for i in padding:
				if i != padding_value:
					printerr("Error detected while decrypting: inconsistent padding value")
					return null
			plaintext = plaintext.subarray(0, plaintext.size() - padding_value - 1)
		_:
			printerr("Invalid pad type selected")
			return null
	return plaintext

func _encrypt_block(block, keys):
	block = [
		PackedByteArray([block[0x00], block[0x01], block[0x02], block[0x03]]),
		PackedByteArray([block[0x04], block[0x05], block[0x06], block[0x07]]),
		PackedByteArray([block[0x08], block[0x09], block[0x0a], block[0x0b]]),
		PackedByteArray([block[0x0c], block[0x0d], block[0x0e], block[0x0f]])
	]
	
	for i in range(4):
		for j in range(4):
			block[i][j] ^= keys[0][i][j]
	
	for rnd in range(1, keys.size()):
		
		# SubBytes
		
		for i in range(4):
			for j in range(4):
				block[i][j] = _sub(block[i][j], S_BOX)
		
		# ShiftRows
		
		for i in range(1, 4):
			var new_row = PackedByteArray()
			new_row.resize(4)
			for j in range(4):
				new_row[j] = block[(j + i) % 4][i]
			for j in range(4):
				block[j][i] = new_row[j]
		
		# MixColumns
		
		if rnd != keys.size() - 1:
			_mix_columns(block, MIX_MATRIX)
		
		# AddRoundKey
		
		for i in range(4):
			for j in range(4):
				block[i][j] ^= keys[rnd][i][j]
	
	var cipherblock = block[0]
	for i in range(1, 4):
		cipherblock.append_array(block[i])
	return cipherblock

func _decrypt_block(block, keys):
	block = [
		PackedByteArray([block[0x00], block[0x01], block[0x02], block[0x03]]),
		PackedByteArray([block[0x04], block[0x05], block[0x06], block[0x07]]),
		PackedByteArray([block[0x08], block[0x09], block[0x0a], block[0x0b]]),
		PackedByteArray([block[0x0c], block[0x0d], block[0x0e], block[0x0f]])
	]
	
	for rnd in range(keys.size() - 1, 0, -1):
		
		# AddRoundKey
		
		for i in range(4):
			for j in range(4):
				block[i][j] ^= keys[rnd][i][j]
		
		# MixColumns
		
		if rnd != keys.size() - 1:
			_mix_columns(block, MIX_MATRIX_INVERSE)
		
		# ShiftRows
		
		for i in range(1, 4):
			var new_row = PackedByteArray()
			new_row.resize(4)
			for j in range(4):
				new_row[j] = block[(j - i + 4) % 4][i]
			for j in range(4):
				block[j][i] = new_row[j]
		
		# SubBytes
		
		for i in range(4):
			for j in range(4):
				block[i][j] = _sub(block[i][j], S_BOX_INVERSE)
	
	for i in range(4):
		for j in range(4):
			block[i][j] ^= keys[0][i][j]
	
	var plainblock = PackedByteArray(block[0])
	for i in range(1, 4):
		plainblock.append_array(block[i])
	return plainblock

func _key_schedule(key):
	var key_width = key.size() / 4
	var rounds = key_width + 6
	var expansions = ceil(4.0 * (rounds + 1) / key_width)
	var words = []
	for i in range(key_width):
		words.append(PackedByteArray([key[i*4], key[i*4 + 1], key[i*4 + 2], key[i*4 + 3]]))
	for i in range(1, expansions):
		var exp_prev = words[words.size() - key_width]
		var word = words[words.size() - 1]
		var temp = word[0]
		for j in range(3):
			word[j] = word[j + 1]
		word[3] = temp
		for j in range(4):
			word[j] = _sub(word[j], S_BOX) ^ exp_prev[j]
		word[0] ^= RCI[i - 1]
		words.append(word)
		for j in range(1, key_width):
			word = words[words.size() - 1]
			if key_width > 6 and j % 4 == 0:
				for k in range(4):
					word[k] = _sub(word[k], S_BOX)
			for k in range(4):
				word[k] ^= words[words.size() - key_width][k]
			words.append(word)
	var keys = []
	for i in range(rounds + 1):
		var key_rnd = [words[i * 4]]
		for j in range(1, 4):
			key_rnd.append(words[i*4 + j])
		keys.append(key_rnd)
	return keys

func _sub(byte, s_box):
	return s_box[byte / 16][byte % 16]

func _mix_columns(block, mix_matrix):
	for i in range(4):
		var new_column = PackedByteArray()
		new_column.resize(4)
		for j in range(4):
			var sum = 0;
			for k in range(4):
				sum ^= _gmul(block[i][k], mix_matrix[j][k])
			new_column[j] = sum
		block[i] = new_column

func _gmul(a, b):
	var p = 0
	for counter in range(8):
		if b & 1 != 0:
			p ^= a
		var high_bit_set = a & 0x80 != 0
		a = (a << 1) & 0xff
		if high_bit_set:
			a ^= 0x1b
		b >>= 1
	return p

func _format_key(key):
	key = _to_raw_array(key)
	if key == null:
		printerr("Invalid key format")
		return null
	elif [16, 24, 32].find(key.size()) == -1:
		printerr("Invalid key size. Key must be 128/192/256 bits (16/24/32 bytes)")
		return null
	return key

func _format_iv(iv):
	iv = _to_raw_array(iv)
	if iv == null:
		printerr("Invalid iv format")
		return null
	elif iv.size() != 16:
		printerr("Invalid IV size. IV for AES CBC mode must be 128 bits (16 bytes)")
		return null
	return iv

func _to_raw_array(object):
	match typeof(object):
		TYPE_PACKED_BYTE_ARRAY:
			return object
		TYPE_ARRAY:
			return PackedByteArray(object)
		TYPE_STRING:
			return object.to_utf8()
		_:
			return null
