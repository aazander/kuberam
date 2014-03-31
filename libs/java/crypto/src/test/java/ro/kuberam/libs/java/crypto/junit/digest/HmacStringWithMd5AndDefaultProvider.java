package ro.kuberam.libs.java.crypto.junit.digest;

import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.Test;

import ro.kuberam.libs.java.crypto.digest.Hmac;
import ro.kuberam.tests.junit.BaseTest;

public class HmacStringWithMd5AndDefaultProvider extends BaseTest {

	@Test
	public void hmacStringWithMd5() throws Exception {
		String input = "Short string for tests.";
		InputStream secretKeyIs = getClass().getResourceAsStream("../../resources/private-key.pem");
		String secretKey = IOUtils.toString(secretKeyIs);

		String result = Hmac.hmac(input, secretKey, "HMAC-MD5", "");

		Assert.assertTrue(result
				.equals("l4MY6Yosjo7W60VJeXB/PQ=="));
	}
}
