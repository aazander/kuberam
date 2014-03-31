package ro.kuberam.libs.java.crypto.junit.digest;

import java.io.InputStream;

import org.junit.Assert;
import org.junit.Test;

import ro.kuberam.libs.java.crypto.digest.Hash;
import ro.kuberam.tests.junit.BaseTest;

public class HashBinaryWithSha256 extends BaseTest {

	@Test
	public void hashBinaryWithSha256() throws Exception {
		InputStream input = getClass().getResourceAsStream("../../resources/keystore");
		String result = Hash.hashBinary(input, "SHA-256", "SUN");

		Assert.assertTrue(result.equals("37JiNBym250ye3aUJ04RaZg3SFSP03qJ8FR/I1JckVI="));
	}
}
