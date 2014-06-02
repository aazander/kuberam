package ro.kuberam.libs.java.ftclient.SFTP;

import org.apache.commons.io.IOUtils;
import org.junit.Assert;
import org.junit.Test;

import ro.kuberam.libs.java.ftclient.Disconnect;
import ro.kuberam.libs.java.ftclient.FTClientAbstractTest;
import ro.kuberam.libs.java.ftclient.StoreResource;

import com.jcraft.jsch.Session;

public class CreateDirectoryTest extends FTClientAbstractTest {

	@Test
	public void listResourcesFromSftpServer() throws Exception {

		Session remoteConnection = initializeSftpConnection(
				connectionProperties.getProperty("sftp-server-connection-url"),
				IOUtils.toString(getClass().getResourceAsStream("../sftp-private-key")));
		String remoteResourcePath = sftpTmpDirPath + "/tempFolder" + System.currentTimeMillis() + "/";
		Boolean stored = StoreResource.storeResource(remoteConnection, remoteResourcePath, null);
		Disconnect.disconnect(remoteConnection);
		Assert.assertTrue(stored);

	}
}
