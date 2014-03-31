package ro.kuberam.libs.java.crypto.junit.digest;

import java.io.InputStream;

import org.junit.Assert;
import org.junit.Test;

import ro.kuberam.libs.java.crypto.digest.Hash;
import ro.kuberam.tests.junit.BaseTest;

public class HashBinaryWithSha384 extends BaseTest {

	@Test
	public void hashBinaryWithSha384() throws Exception {
		InputStream input = getClass().getResourceAsStream("../../resources/keystore");
		String result = Hash.hashBinary(input, "SHA-384", "base64");		

		Assert.assertTrue(result.equals("DcQ3caBftiQCIQn96Pr8PC2vzs17Re0tZ8/CZnOoucu/N+818uqAXxR7l9oxYgoW"));
	}
}
