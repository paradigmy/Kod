import java.util.UUID;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.time.StopWatch;

public class shatest {

private static final int TIMES = 1_000_000;
private static final String UUID_STRING = UUID.randomUUID().toString();

public static void main(String[] args) {
System.out.println(generateStringToHash());
System.out.println("MD5: " + md5());
System.out.println("SHA-1: " + sha1());
System.out.println("SHA-256: " + sha256());
System.out.println("SHA-512: " + sha512());
}

public static long md5() {
StopWatch watch = new StopWatch();
watch.start();
for (int i = 0; i < TIMES; i++) {
DigestUtils.md5Hex(generateStringToHash());
}
watch.stop();
System.out.println(DigestUtils.md5Hex(generateStringToHash()));
return watch.getTime();
}

public static long sha1() {
StopWatch watch = new StopWatch();
watch.start();
for (int i = 0; i < TIMES; i++) {
DigestUtils.sha1Hex(generateStringToHash());
}
watch.stop();
System.out.println(DigestUtils.sha1Hex(generateStringToHash()));
return watch.getTime();
}

public static long sha256() {
StopWatch watch = new StopWatch();
watch.start();
for (int i = 0; i < TIMES; i++) {
DigestUtils.sha256Hex(generateStringToHash());
}
watch.stop();
System.out.println(DigestUtils.sha256Hex(generateStringToHash()));
return watch.getTime();
}

public static long sha512() {
StopWatch watch = new StopWatch();
watch.start();
for (int i = 0; i < TIMES; i++) {
DigestUtils.sha512Hex(generateStringToHash());
}
watch.stop();
System.out.println(DigestUtils.sha512Hex(generateStringToHash()));
return watch.getTime();
}

public static String generateStringToHash() {
return UUID.randomUUID().toString() + System.currentTimeMillis();
}
}