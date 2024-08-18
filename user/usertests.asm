
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	906080e7          	jalr	-1786(ra) # 5916 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	8f4080e7          	jalr	-1804(ra) # 5916 <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	dc250513          	addi	a0,a0,-574 # 5e00 <malloc+0x102>
      46:	00006097          	auipc	ra,0x6
      4a:	c00080e7          	jalr	-1024(ra) # 5c46 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	886080e7          	jalr	-1914(ra) # 58d6 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000b797          	auipc	a5,0xb
      5c:	97078793          	addi	a5,a5,-1680 # a9c8 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	07868693          	addi	a3,a3,120 # d0d8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	da050513          	addi	a0,a0,-608 # 5e20 <malloc+0x122>
      88:	00006097          	auipc	ra,0x6
      8c:	bbe080e7          	jalr	-1090(ra) # 5c46 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	844080e7          	jalr	-1980(ra) # 58d6 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	d9050513          	addi	a0,a0,-624 # 5e38 <malloc+0x13a>
      b0:	00006097          	auipc	ra,0x6
      b4:	866080e7          	jalr	-1946(ra) # 5916 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	842080e7          	jalr	-1982(ra) # 58fe <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	d9250513          	addi	a0,a0,-622 # 5e58 <malloc+0x15a>
      ce:	00006097          	auipc	ra,0x6
      d2:	848080e7          	jalr	-1976(ra) # 5916 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	d5a50513          	addi	a0,a0,-678 # 5e40 <malloc+0x142>
      ee:	00006097          	auipc	ra,0x6
      f2:	b58080e7          	jalr	-1192(ra) # 5c46 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	7de080e7          	jalr	2014(ra) # 58d6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	d6650513          	addi	a0,a0,-666 # 5e68 <malloc+0x16a>
     10a:	00006097          	auipc	ra,0x6
     10e:	b3c080e7          	jalr	-1220(ra) # 5c46 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	7c2080e7          	jalr	1986(ra) # 58d6 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	d6450513          	addi	a0,a0,-668 # 5e90 <malloc+0x192>
     134:	00005097          	auipc	ra,0x5
     138:	7f2080e7          	jalr	2034(ra) # 5926 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	d5050513          	addi	a0,a0,-688 # 5e90 <malloc+0x192>
     148:	00005097          	auipc	ra,0x5
     14c:	7ce080e7          	jalr	1998(ra) # 5916 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	d4c58593          	addi	a1,a1,-692 # 5ea0 <malloc+0x1a2>
     15c:	00005097          	auipc	ra,0x5
     160:	79a080e7          	jalr	1946(ra) # 58f6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	d2850513          	addi	a0,a0,-728 # 5e90 <malloc+0x192>
     170:	00005097          	auipc	ra,0x5
     174:	7a6080e7          	jalr	1958(ra) # 5916 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	d2c58593          	addi	a1,a1,-724 # 5ea8 <malloc+0x1aa>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	770080e7          	jalr	1904(ra) # 58f6 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	cfc50513          	addi	a0,a0,-772 # 5e90 <malloc+0x192>
     19c:	00005097          	auipc	ra,0x5
     1a0:	78a080e7          	jalr	1930(ra) # 5926 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	758080e7          	jalr	1880(ra) # 58fe <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	74e080e7          	jalr	1870(ra) # 58fe <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	ce650513          	addi	a0,a0,-794 # 5eb0 <malloc+0x1b2>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a74080e7          	jalr	-1420(ra) # 5c46 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	6fa080e7          	jalr	1786(ra) # 58d6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	706080e7          	jalr	1798(ra) # 5916 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	6e6080e7          	jalr	1766(ra) # 58fe <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	6e0080e7          	jalr	1760(ra) # 5926 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	c5c50513          	addi	a0,a0,-932 # 5ed8 <malloc+0x1da>
     284:	00005097          	auipc	ra,0x5
     288:	6a2080e7          	jalr	1698(ra) # 5926 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	c48a8a93          	addi	s5,s5,-952 # 5ed8 <malloc+0x1da>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	e40a0a13          	addi	s4,s4,-448 # d0d8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x37>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	66a080e7          	jalr	1642(ra) # 5916 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	638080e7          	jalr	1592(ra) # 58f6 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	624080e7          	jalr	1572(ra) # 58f6 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	61e080e7          	jalr	1566(ra) # 58fe <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	63c080e7          	jalr	1596(ra) # 5926 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	bd650513          	addi	a0,a0,-1066 # 5ee8 <malloc+0x1ea>
     31a:	00006097          	auipc	ra,0x6
     31e:	92c080e7          	jalr	-1748(ra) # 5c46 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	5b2080e7          	jalr	1458(ra) # 58d6 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	bd450513          	addi	a0,a0,-1068 # 5f08 <malloc+0x20a>
     33c:	00006097          	auipc	ra,0x6
     340:	90a080e7          	jalr	-1782(ra) # 5c46 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	590080e7          	jalr	1424(ra) # 58d6 <exit>

000000000000034e <copyin>:
{
     34e:	715d                	addi	sp,sp,-80
     350:	e486                	sd	ra,72(sp)
     352:	e0a2                	sd	s0,64(sp)
     354:	fc26                	sd	s1,56(sp)
     356:	f84a                	sd	s2,48(sp)
     358:	f44e                	sd	s3,40(sp)
     35a:	f052                	sd	s4,32(sp)
     35c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     35e:	4785                	li	a5,1
     360:	07fe                	slli	a5,a5,0x1f
     362:	fcf43023          	sd	a5,-64(s0)
     366:	57fd                	li	a5,-1
     368:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     370:	00006a17          	auipc	s4,0x6
     374:	bb0a0a13          	addi	s4,s4,-1104 # 5f20 <malloc+0x222>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	594080e7          	jalr	1428(ra) # 5916 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	562080e7          	jalr	1378(ra) # 58f6 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	55c080e7          	jalr	1372(ra) # 58fe <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	57a080e7          	jalr	1402(ra) # 5926 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	53c080e7          	jalr	1340(ra) # 58f6 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	addi	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	51c080e7          	jalr	1308(ra) # 58e6 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	518080e7          	jalr	1304(ra) # 58f6 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	510080e7          	jalr	1296(ra) # 58fe <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	504080e7          	jalr	1284(ra) # 58fe <close>
  for(int ai = 0; ai < 2; ai++){
     402:	0921                	addi	s2,s2,8
     404:	fd040793          	addi	a5,s0,-48
     408:	f6f918e3          	bne	s2,a5,378 <copyin+0x2a>
}
     40c:	60a6                	ld	ra,72(sp)
     40e:	6406                	ld	s0,64(sp)
     410:	74e2                	ld	s1,56(sp)
     412:	7942                	ld	s2,48(sp)
     414:	79a2                	ld	s3,40(sp)
     416:	7a02                	ld	s4,32(sp)
     418:	6161                	addi	sp,sp,80
     41a:	8082                	ret
      printf("open(copyin1) failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	b0c50513          	addi	a0,a0,-1268 # 5f28 <malloc+0x22a>
     424:	00006097          	auipc	ra,0x6
     428:	822080e7          	jalr	-2014(ra) # 5c46 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	4a8080e7          	jalr	1192(ra) # 58d6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	b0650513          	addi	a0,a0,-1274 # 5f40 <malloc+0x242>
     442:	00006097          	auipc	ra,0x6
     446:	804080e7          	jalr	-2044(ra) # 5c46 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	48a080e7          	jalr	1162(ra) # 58d6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	b1850513          	addi	a0,a0,-1256 # 5f70 <malloc+0x272>
     460:	00005097          	auipc	ra,0x5
     464:	7e6080e7          	jalr	2022(ra) # 5c46 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	46c080e7          	jalr	1132(ra) # 58d6 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	b2e50513          	addi	a0,a0,-1234 # 5fa0 <malloc+0x2a2>
     47a:	00005097          	auipc	ra,0x5
     47e:	7cc080e7          	jalr	1996(ra) # 5c46 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	452080e7          	jalr	1106(ra) # 58d6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	b2050513          	addi	a0,a0,-1248 # 5fb0 <malloc+0x2b2>
     498:	00005097          	auipc	ra,0x5
     49c:	7ae080e7          	jalr	1966(ra) # 5c46 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	434080e7          	jalr	1076(ra) # 58d6 <exit>

00000000000004aa <copyout>:
{
     4aa:	711d                	addi	sp,sp,-96
     4ac:	ec86                	sd	ra,88(sp)
     4ae:	e8a2                	sd	s0,80(sp)
     4b0:	e4a6                	sd	s1,72(sp)
     4b2:	e0ca                	sd	s2,64(sp)
     4b4:	fc4e                	sd	s3,56(sp)
     4b6:	f852                	sd	s4,48(sp)
     4b8:	f456                	sd	s5,40(sp)
     4ba:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4bc:	4785                	li	a5,1
     4be:	07fe                	slli	a5,a5,0x1f
     4c0:	faf43823          	sd	a5,-80(s0)
     4c4:	57fd                	li	a5,-1
     4c6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ca:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4ce:	00006a17          	auipc	s4,0x6
     4d2:	b12a0a13          	addi	s4,s4,-1262 # 5fe0 <malloc+0x2e2>
    n = write(fds[1], "x", 1);
     4d6:	00006a97          	auipc	s5,0x6
     4da:	9d2a8a93          	addi	s5,s5,-1582 # 5ea8 <malloc+0x1aa>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	430080e7          	jalr	1072(ra) # 5916 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	3f6080e7          	jalr	1014(ra) # 58ee <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	3f8080e7          	jalr	1016(ra) # 58fe <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	addi	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	3d4080e7          	jalr	980(ra) # 58e6 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	3d0080e7          	jalr	976(ra) # 58f6 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	3b2080e7          	jalr	946(ra) # 58ee <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	3b2080e7          	jalr	946(ra) # 58fe <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	3a6080e7          	jalr	934(ra) # 58fe <close>
  for(int ai = 0; ai < 2; ai++){
     560:	0921                	addi	s2,s2,8
     562:	fc040793          	addi	a5,s0,-64
     566:	f6f91ce3          	bne	s2,a5,4de <copyout+0x34>
}
     56a:	60e6                	ld	ra,88(sp)
     56c:	6446                	ld	s0,80(sp)
     56e:	64a6                	ld	s1,72(sp)
     570:	6906                	ld	s2,64(sp)
     572:	79e2                	ld	s3,56(sp)
     574:	7a42                	ld	s4,48(sp)
     576:	7aa2                	ld	s5,40(sp)
     578:	6125                	addi	sp,sp,96
     57a:	8082                	ret
      printf("open(README) failed\n");
     57c:	00006517          	auipc	a0,0x6
     580:	a6c50513          	addi	a0,a0,-1428 # 5fe8 <malloc+0x2ea>
     584:	00005097          	auipc	ra,0x5
     588:	6c2080e7          	jalr	1730(ra) # 5c46 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	348080e7          	jalr	840(ra) # 58d6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00006517          	auipc	a0,0x6
     59e:	a6650513          	addi	a0,a0,-1434 # 6000 <malloc+0x302>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	6a4080e7          	jalr	1700(ra) # 5c46 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	32a080e7          	jalr	810(ra) # 58d6 <exit>
      printf("pipe() failed\n");
     5b4:	00006517          	auipc	a0,0x6
     5b8:	9ec50513          	addi	a0,a0,-1556 # 5fa0 <malloc+0x2a2>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	68a080e7          	jalr	1674(ra) # 5c46 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	310080e7          	jalr	784(ra) # 58d6 <exit>
      printf("pipe write failed\n");
     5ce:	00006517          	auipc	a0,0x6
     5d2:	a6250513          	addi	a0,a0,-1438 # 6030 <malloc+0x332>
     5d6:	00005097          	auipc	ra,0x5
     5da:	670080e7          	jalr	1648(ra) # 5c46 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	2f6080e7          	jalr	758(ra) # 58d6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00006517          	auipc	a0,0x6
     5f0:	a5c50513          	addi	a0,a0,-1444 # 6048 <malloc+0x34a>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	652080e7          	jalr	1618(ra) # 5c46 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	2d8080e7          	jalr	728(ra) # 58d6 <exit>

0000000000000606 <truncate1>:
{
     606:	711d                	addi	sp,sp,-96
     608:	ec86                	sd	ra,88(sp)
     60a:	e8a2                	sd	s0,80(sp)
     60c:	e4a6                	sd	s1,72(sp)
     60e:	e0ca                	sd	s2,64(sp)
     610:	fc4e                	sd	s3,56(sp)
     612:	f852                	sd	s4,48(sp)
     614:	f456                	sd	s5,40(sp)
     616:	1080                	addi	s0,sp,96
     618:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61a:	00006517          	auipc	a0,0x6
     61e:	87650513          	addi	a0,a0,-1930 # 5e90 <malloc+0x192>
     622:	00005097          	auipc	ra,0x5
     626:	304080e7          	jalr	772(ra) # 5926 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00006517          	auipc	a0,0x6
     632:	86250513          	addi	a0,a0,-1950 # 5e90 <malloc+0x192>
     636:	00005097          	auipc	ra,0x5
     63a:	2e0080e7          	jalr	736(ra) # 5916 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00006597          	auipc	a1,0x6
     646:	85e58593          	addi	a1,a1,-1954 # 5ea0 <malloc+0x1a2>
     64a:	00005097          	auipc	ra,0x5
     64e:	2ac080e7          	jalr	684(ra) # 58f6 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	2aa080e7          	jalr	682(ra) # 58fe <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00006517          	auipc	a0,0x6
     662:	83250513          	addi	a0,a0,-1998 # 5e90 <malloc+0x192>
     666:	00005097          	auipc	ra,0x5
     66a:	2b0080e7          	jalr	688(ra) # 5916 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	addi	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	276080e7          	jalr	630(ra) # 58ee <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00006517          	auipc	a0,0x6
     68e:	80650513          	addi	a0,a0,-2042 # 5e90 <malloc+0x192>
     692:	00005097          	auipc	ra,0x5
     696:	284080e7          	jalr	644(ra) # 5916 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	7f250513          	addi	a0,a0,2034 # 5e90 <malloc+0x192>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	270080e7          	jalr	624(ra) # 5916 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	236080e7          	jalr	566(ra) # 58ee <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	220080e7          	jalr	544(ra) # 58ee <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00006597          	auipc	a1,0x6
     6e0:	9fc58593          	addi	a1,a1,-1540 # 60d8 <malloc+0x3da>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	210080e7          	jalr	528(ra) # 58f6 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	addi	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	1f6080e7          	jalr	502(ra) # 58ee <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	addi	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	1de080e7          	jalr	478(ra) # 58ee <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	77250513          	addi	a0,a0,1906 # 5e90 <malloc+0x192>
     726:	00005097          	auipc	ra,0x5
     72a:	200080e7          	jalr	512(ra) # 5926 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	1ce080e7          	jalr	462(ra) # 58fe <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	1c4080e7          	jalr	452(ra) # 58fe <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	1ba080e7          	jalr	442(ra) # 58fe <close>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     75e:	862a                	mv	a2,a0
     760:	85d6                	mv	a1,s5
     762:	00006517          	auipc	a0,0x6
     766:	91650513          	addi	a0,a0,-1770 # 6078 <malloc+0x37a>
     76a:	00005097          	auipc	ra,0x5
     76e:	4dc080e7          	jalr	1244(ra) # 5c46 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	162080e7          	jalr	354(ra) # 58d6 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00006517          	auipc	a0,0x6
     782:	91a50513          	addi	a0,a0,-1766 # 6098 <malloc+0x39a>
     786:	00005097          	auipc	ra,0x5
     78a:	4c0080e7          	jalr	1216(ra) # 5c46 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00006517          	auipc	a0,0x6
     796:	91650513          	addi	a0,a0,-1770 # 60a8 <malloc+0x3aa>
     79a:	00005097          	auipc	ra,0x5
     79e:	4ac080e7          	jalr	1196(ra) # 5c46 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	132080e7          	jalr	306(ra) # 58d6 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00006517          	auipc	a0,0x6
     7b2:	91a50513          	addi	a0,a0,-1766 # 60c8 <malloc+0x3ca>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	490080e7          	jalr	1168(ra) # 5c46 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00006517          	auipc	a0,0x6
     7c6:	8e650513          	addi	a0,a0,-1818 # 60a8 <malloc+0x3aa>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	47c080e7          	jalr	1148(ra) # 5c46 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	102080e7          	jalr	258(ra) # 58d6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00006517          	auipc	a0,0x6
     7e4:	90050513          	addi	a0,a0,-1792 # 60e0 <malloc+0x3e2>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	45e080e7          	jalr	1118(ra) # 5c46 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	0e4080e7          	jalr	228(ra) # 58d6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00006517          	auipc	a0,0x6
     802:	90250513          	addi	a0,a0,-1790 # 6100 <malloc+0x402>
     806:	00005097          	auipc	ra,0x5
     80a:	440080e7          	jalr	1088(ra) # 5c46 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	0c6080e7          	jalr	198(ra) # 58d6 <exit>

0000000000000818 <writetest>:
{
     818:	7139                	addi	sp,sp,-64
     81a:	fc06                	sd	ra,56(sp)
     81c:	f822                	sd	s0,48(sp)
     81e:	f426                	sd	s1,40(sp)
     820:	f04a                	sd	s2,32(sp)
     822:	ec4e                	sd	s3,24(sp)
     824:	e852                	sd	s4,16(sp)
     826:	e456                	sd	s5,8(sp)
     828:	e05a                	sd	s6,0(sp)
     82a:	0080                	addi	s0,sp,64
     82c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     82e:	20200593          	li	a1,514
     832:	00006517          	auipc	a0,0x6
     836:	8ee50513          	addi	a0,a0,-1810 # 6120 <malloc+0x422>
     83a:	00005097          	auipc	ra,0x5
     83e:	0dc080e7          	jalr	220(ra) # 5916 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00006997          	auipc	s3,0x6
     84e:	8fe98993          	addi	s3,s3,-1794 # 6148 <malloc+0x44a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00006a97          	auipc	s5,0x6
     856:	92ea8a93          	addi	s5,s5,-1746 # 6180 <malloc+0x482>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	092080e7          	jalr	146(ra) # 58f6 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	07e080e7          	jalr	126(ra) # 58f6 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addiw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	070080e7          	jalr	112(ra) # 58fe <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00006517          	auipc	a0,0x6
     89c:	88850513          	addi	a0,a0,-1912 # 6120 <malloc+0x422>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	076080e7          	jalr	118(ra) # 5916 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000d597          	auipc	a1,0xd
     8b6:	82658593          	addi	a1,a1,-2010 # d0d8 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	034080e7          	jalr	52(ra) # 58ee <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	032080e7          	jalr	50(ra) # 58fe <close>
  if(unlink("small") < 0){
     8d4:	00006517          	auipc	a0,0x6
     8d8:	84c50513          	addi	a0,a0,-1972 # 6120 <malloc+0x422>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	04a080e7          	jalr	74(ra) # 5926 <unlink>
     8e4:	0a054463          	bltz	a0,98c <writetest+0x174>
}
     8e8:	70e2                	ld	ra,56(sp)
     8ea:	7442                	ld	s0,48(sp)
     8ec:	74a2                	ld	s1,40(sp)
     8ee:	7902                	ld	s2,32(sp)
     8f0:	69e2                	ld	s3,24(sp)
     8f2:	6a42                	ld	s4,16(sp)
     8f4:	6aa2                	ld	s5,8(sp)
     8f6:	6b02                	ld	s6,0(sp)
     8f8:	6121                	addi	sp,sp,64
     8fa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fc:	85da                	mv	a1,s6
     8fe:	00006517          	auipc	a0,0x6
     902:	82a50513          	addi	a0,a0,-2006 # 6128 <malloc+0x42a>
     906:	00005097          	auipc	ra,0x5
     90a:	340080e7          	jalr	832(ra) # 5c46 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	fc6080e7          	jalr	-58(ra) # 58d6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00006517          	auipc	a0,0x6
     920:	83c50513          	addi	a0,a0,-1988 # 6158 <malloc+0x45a>
     924:	00005097          	auipc	ra,0x5
     928:	322080e7          	jalr	802(ra) # 5c46 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	fa8080e7          	jalr	-88(ra) # 58d6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00006517          	auipc	a0,0x6
     93e:	85650513          	addi	a0,a0,-1962 # 6190 <malloc+0x492>
     942:	00005097          	auipc	ra,0x5
     946:	304080e7          	jalr	772(ra) # 5c46 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	f8a080e7          	jalr	-118(ra) # 58d6 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00006517          	auipc	a0,0x6
     95a:	86250513          	addi	a0,a0,-1950 # 61b8 <malloc+0x4ba>
     95e:	00005097          	auipc	ra,0x5
     962:	2e8080e7          	jalr	744(ra) # 5c46 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	f6e080e7          	jalr	-146(ra) # 58d6 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00006517          	auipc	a0,0x6
     976:	86650513          	addi	a0,a0,-1946 # 61d8 <malloc+0x4da>
     97a:	00005097          	auipc	ra,0x5
     97e:	2cc080e7          	jalr	716(ra) # 5c46 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	f52080e7          	jalr	-174(ra) # 58d6 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00006517          	auipc	a0,0x6
     992:	86250513          	addi	a0,a0,-1950 # 61f0 <malloc+0x4f2>
     996:	00005097          	auipc	ra,0x5
     99a:	2b0080e7          	jalr	688(ra) # 5c46 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	f36080e7          	jalr	-202(ra) # 58d6 <exit>

00000000000009a8 <writebig>:
{
     9a8:	7139                	addi	sp,sp,-64
     9aa:	fc06                	sd	ra,56(sp)
     9ac:	f822                	sd	s0,48(sp)
     9ae:	f426                	sd	s1,40(sp)
     9b0:	f04a                	sd	s2,32(sp)
     9b2:	ec4e                	sd	s3,24(sp)
     9b4:	e852                	sd	s4,16(sp)
     9b6:	e456                	sd	s5,8(sp)
     9b8:	0080                	addi	s0,sp,64
     9ba:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9bc:	20200593          	li	a1,514
     9c0:	00006517          	auipc	a0,0x6
     9c4:	85050513          	addi	a0,a0,-1968 # 6210 <malloc+0x512>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	f4e080e7          	jalr	-178(ra) # 5916 <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000c917          	auipc	s2,0xc
     9d8:	70490913          	addi	s2,s2,1796 # d0d8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	6a41                	lui	s4,0x10
     9de:	10ba0a13          	addi	s4,s4,267 # 1010b <__BSS_END__+0x23>
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb2>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	f04080e7          	jalr	-252(ra) # 58f6 <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3e>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	ef4080e7          	jalr	-268(ra) # 58fe <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00005517          	auipc	a0,0x5
     a18:	7fc50513          	addi	a0,a0,2044 # 6210 <malloc+0x512>
     a1c:	00005097          	auipc	ra,0x5
     a20:	efa080e7          	jalr	-262(ra) # 5916 <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000c917          	auipc	s2,0xc
     a2c:	6b090913          	addi	s2,s2,1712 # d0d8 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	eb2080e7          	jalr	-334(ra) # 58ee <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x108>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x160>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17e>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	7bc50513          	addi	a0,a0,1980 # 6218 <malloc+0x51a>
     a64:	00005097          	auipc	ra,0x5
     a68:	1e2080e7          	jalr	482(ra) # 5c46 <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	e68080e7          	jalr	-408(ra) # 58d6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00005517          	auipc	a0,0x5
     a7e:	7be50513          	addi	a0,a0,1982 # 6238 <malloc+0x53a>
     a82:	00005097          	auipc	ra,0x5
     a86:	1c4080e7          	jalr	452(ra) # 5c46 <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	e4a080e7          	jalr	-438(ra) # 58d6 <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00005517          	auipc	a0,0x5
     a9a:	7ca50513          	addi	a0,a0,1994 # 6260 <malloc+0x562>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	1a8080e7          	jalr	424(ra) # 5c46 <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	e2e080e7          	jalr	-466(ra) # 58d6 <exit>
      if(n == MAXFILE - 1){
     ab0:	67c1                	lui	a5,0x10
     ab2:	10a78793          	addi	a5,a5,266 # 1010a <__BSS_END__+0x22>
     ab6:	02f48a63          	beq	s1,a5,aea <writebig+0x142>
  close(fd);
     aba:	854e                	mv	a0,s3
     abc:	00005097          	auipc	ra,0x5
     ac0:	e42080e7          	jalr	-446(ra) # 58fe <close>
  if(unlink("big") < 0){
     ac4:	00005517          	auipc	a0,0x5
     ac8:	74c50513          	addi	a0,a0,1868 # 6210 <malloc+0x512>
     acc:	00005097          	auipc	ra,0x5
     ad0:	e5a080e7          	jalr	-422(ra) # 5926 <unlink>
     ad4:	06054863          	bltz	a0,b44 <writebig+0x19c>
}
     ad8:	70e2                	ld	ra,56(sp)
     ada:	7442                	ld	s0,48(sp)
     adc:	74a2                	ld	s1,40(sp)
     ade:	7902                	ld	s2,32(sp)
     ae0:	69e2                	ld	s3,24(sp)
     ae2:	6a42                	ld	s4,16(sp)
     ae4:	6aa2                	ld	s5,8(sp)
     ae6:	6121                	addi	sp,sp,64
     ae8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aea:	863e                	mv	a2,a5
     aec:	85d6                	mv	a1,s5
     aee:	00005517          	auipc	a0,0x5
     af2:	79250513          	addi	a0,a0,1938 # 6280 <malloc+0x582>
     af6:	00005097          	auipc	ra,0x5
     afa:	150080e7          	jalr	336(ra) # 5c46 <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	dd6080e7          	jalr	-554(ra) # 58d6 <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	79c50513          	addi	a0,a0,1948 # 62a8 <malloc+0x5aa>
     b14:	00005097          	auipc	ra,0x5
     b18:	132080e7          	jalr	306(ra) # 5c46 <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	db8080e7          	jalr	-584(ra) # 58d6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00005517          	auipc	a0,0x5
     b2e:	79650513          	addi	a0,a0,1942 # 62c0 <malloc+0x5c2>
     b32:	00005097          	auipc	ra,0x5
     b36:	114080e7          	jalr	276(ra) # 5c46 <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	d9a080e7          	jalr	-614(ra) # 58d6 <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00005517          	auipc	a0,0x5
     b4a:	7a250513          	addi	a0,a0,1954 # 62e8 <malloc+0x5ea>
     b4e:	00005097          	auipc	ra,0x5
     b52:	0f8080e7          	jalr	248(ra) # 5c46 <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	d7e080e7          	jalr	-642(ra) # 58d6 <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	78c50513          	addi	a0,a0,1932 # 6300 <malloc+0x602>
     b7c:	00005097          	auipc	ra,0x5
     b80:	d9a080e7          	jalr	-614(ra) # 5916 <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00005597          	auipc	a1,0x5
     b90:	7a458593          	addi	a1,a1,1956 # 6330 <malloc+0x632>
     b94:	00005097          	auipc	ra,0x5
     b98:	d62080e7          	jalr	-670(ra) # 58f6 <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	d60080e7          	jalr	-672(ra) # 58fe <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	75850513          	addi	a0,a0,1880 # 6300 <malloc+0x602>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	d66080e7          	jalr	-666(ra) # 5916 <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	74250513          	addi	a0,a0,1858 # 6300 <malloc+0x602>
     bc6:	00005097          	auipc	ra,0x5
     bca:	d60080e7          	jalr	-672(ra) # 5926 <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	72c50513          	addi	a0,a0,1836 # 6300 <malloc+0x602>
     bdc:	00005097          	auipc	ra,0x5
     be0:	d3a080e7          	jalr	-710(ra) # 5916 <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00005597          	auipc	a1,0x5
     bec:	79058593          	addi	a1,a1,1936 # 6378 <malloc+0x67a>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	d06080e7          	jalr	-762(ra) # 58f6 <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	d04080e7          	jalr	-764(ra) # 58fe <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000c597          	auipc	a1,0xc
     c08:	4d458593          	addi	a1,a1,1236 # d0d8 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	ce0080e7          	jalr	-800(ra) # 58ee <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000c717          	auipc	a4,0xc
     c20:	4bc74703          	lbu	a4,1212(a4) # d0d8 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000c597          	auipc	a1,0xc
     c32:	4aa58593          	addi	a1,a1,1194 # d0d8 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	cbe080e7          	jalr	-834(ra) # 58f6 <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	cb6080e7          	jalr	-842(ra) # 58fe <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	6b050513          	addi	a0,a0,1712 # 6300 <malloc+0x602>
     c58:	00005097          	auipc	ra,0x5
     c5c:	cce080e7          	jalr	-818(ra) # 5926 <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00005517          	auipc	a0,0x5
     c74:	6a050513          	addi	a0,a0,1696 # 6310 <malloc+0x612>
     c78:	00005097          	auipc	ra,0x5
     c7c:	fce080e7          	jalr	-50(ra) # 5c46 <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	c54080e7          	jalr	-940(ra) # 58d6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00005517          	auipc	a0,0x5
     c90:	6ac50513          	addi	a0,a0,1708 # 6338 <malloc+0x63a>
     c94:	00005097          	auipc	ra,0x5
     c98:	fb2080e7          	jalr	-78(ra) # 5c46 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	c38080e7          	jalr	-968(ra) # 58d6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	6b050513          	addi	a0,a0,1712 # 6358 <malloc+0x65a>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	f96080e7          	jalr	-106(ra) # 5c46 <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	c1c080e7          	jalr	-996(ra) # 58d6 <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00005517          	auipc	a0,0x5
     cc8:	6bc50513          	addi	a0,a0,1724 # 6380 <malloc+0x682>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	f7a080e7          	jalr	-134(ra) # 5c46 <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	c00080e7          	jalr	-1024(ra) # 58d6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00005517          	auipc	a0,0x5
     ce4:	6c050513          	addi	a0,a0,1728 # 63a0 <malloc+0x6a2>
     ce8:	00005097          	auipc	ra,0x5
     cec:	f5e080e7          	jalr	-162(ra) # 5c46 <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	be4080e7          	jalr	-1052(ra) # 58d6 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00005517          	auipc	a0,0x5
     d00:	6c450513          	addi	a0,a0,1732 # 63c0 <malloc+0x6c2>
     d04:	00005097          	auipc	ra,0x5
     d08:	f42080e7          	jalr	-190(ra) # 5c46 <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	bc8080e7          	jalr	-1080(ra) # 58d6 <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00005517          	auipc	a0,0x5
     d28:	6bc50513          	addi	a0,a0,1724 # 63e0 <malloc+0x6e2>
     d2c:	00005097          	auipc	ra,0x5
     d30:	bfa080e7          	jalr	-1030(ra) # 5926 <unlink>
  unlink("lf2");
     d34:	00005517          	auipc	a0,0x5
     d38:	6b450513          	addi	a0,a0,1716 # 63e8 <malloc+0x6ea>
     d3c:	00005097          	auipc	ra,0x5
     d40:	bea080e7          	jalr	-1046(ra) # 5926 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00005517          	auipc	a0,0x5
     d4c:	69850513          	addi	a0,a0,1688 # 63e0 <malloc+0x6e2>
     d50:	00005097          	auipc	ra,0x5
     d54:	bc6080e7          	jalr	-1082(ra) # 5916 <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	5d058593          	addi	a1,a1,1488 # 6330 <malloc+0x632>
     d68:	00005097          	auipc	ra,0x5
     d6c:	b8e080e7          	jalr	-1138(ra) # 58f6 <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	b86080e7          	jalr	-1146(ra) # 58fe <close>
  if(link("lf1", "lf2") < 0){
     d80:	00005597          	auipc	a1,0x5
     d84:	66858593          	addi	a1,a1,1640 # 63e8 <malloc+0x6ea>
     d88:	00005517          	auipc	a0,0x5
     d8c:	65850513          	addi	a0,a0,1624 # 63e0 <malloc+0x6e2>
     d90:	00005097          	auipc	ra,0x5
     d94:	ba6080e7          	jalr	-1114(ra) # 5936 <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	64450513          	addi	a0,a0,1604 # 63e0 <malloc+0x6e2>
     da4:	00005097          	auipc	ra,0x5
     da8:	b82080e7          	jalr	-1150(ra) # 5926 <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	63250513          	addi	a0,a0,1586 # 63e0 <malloc+0x6e2>
     db6:	00005097          	auipc	ra,0x5
     dba:	b60080e7          	jalr	-1184(ra) # 5916 <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	62450513          	addi	a0,a0,1572 # 63e8 <malloc+0x6ea>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	b4a080e7          	jalr	-1206(ra) # 5916 <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000c597          	auipc	a1,0xc
     de0:	2fc58593          	addi	a1,a1,764 # d0d8 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	b0a080e7          	jalr	-1270(ra) # 58ee <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	b0a080e7          	jalr	-1270(ra) # 58fe <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	5ec58593          	addi	a1,a1,1516 # 63e8 <malloc+0x6ea>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	b30080e7          	jalr	-1232(ra) # 5936 <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	5d650513          	addi	a0,a0,1494 # 63e8 <malloc+0x6ea>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	b0c080e7          	jalr	-1268(ra) # 5926 <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	5be58593          	addi	a1,a1,1470 # 63e0 <malloc+0x6e2>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	5be50513          	addi	a0,a0,1470 # 63e8 <malloc+0x6ea>
     e32:	00005097          	auipc	ra,0x5
     e36:	b04080e7          	jalr	-1276(ra) # 5936 <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	5a258593          	addi	a1,a1,1442 # 63e0 <malloc+0x6e2>
     e46:	00005517          	auipc	a0,0x5
     e4a:	6aa50513          	addi	a0,a0,1706 # 64f0 <malloc+0x7f2>
     e4e:	00005097          	auipc	ra,0x5
     e52:	ae8080e7          	jalr	-1304(ra) # 5936 <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	58850513          	addi	a0,a0,1416 # 63f0 <malloc+0x6f2>
     e70:	00005097          	auipc	ra,0x5
     e74:	dd6080e7          	jalr	-554(ra) # 5c46 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	a5c080e7          	jalr	-1444(ra) # 58d6 <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	58450513          	addi	a0,a0,1412 # 6408 <malloc+0x70a>
     e8c:	00005097          	auipc	ra,0x5
     e90:	dba080e7          	jalr	-582(ra) # 5c46 <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	a40080e7          	jalr	-1472(ra) # 58d6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	58050513          	addi	a0,a0,1408 # 6420 <malloc+0x722>
     ea8:	00005097          	auipc	ra,0x5
     eac:	d9e080e7          	jalr	-610(ra) # 5c46 <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00005097          	auipc	ra,0x5
     eb6:	a24080e7          	jalr	-1500(ra) # 58d6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	58450513          	addi	a0,a0,1412 # 6440 <malloc+0x742>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	d82080e7          	jalr	-638(ra) # 5c46 <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00005097          	auipc	ra,0x5
     ed2:	a08080e7          	jalr	-1528(ra) # 58d6 <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	59850513          	addi	a0,a0,1432 # 6470 <malloc+0x772>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	d66080e7          	jalr	-666(ra) # 5c46 <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00005097          	auipc	ra,0x5
     eee:	9ec080e7          	jalr	-1556(ra) # 58d6 <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	59450513          	addi	a0,a0,1428 # 6488 <malloc+0x78a>
     efc:	00005097          	auipc	ra,0x5
     f00:	d4a080e7          	jalr	-694(ra) # 5c46 <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00005097          	auipc	ra,0x5
     f0a:	9d0080e7          	jalr	-1584(ra) # 58d6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	59050513          	addi	a0,a0,1424 # 64a0 <malloc+0x7a2>
     f18:	00005097          	auipc	ra,0x5
     f1c:	d2e080e7          	jalr	-722(ra) # 5c46 <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00005097          	auipc	ra,0x5
     f26:	9b4080e7          	jalr	-1612(ra) # 58d6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	59c50513          	addi	a0,a0,1436 # 64c8 <malloc+0x7ca>
     f34:	00005097          	auipc	ra,0x5
     f38:	d12080e7          	jalr	-750(ra) # 5c46 <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00005097          	auipc	ra,0x5
     f42:	998080e7          	jalr	-1640(ra) # 58d6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	5b050513          	addi	a0,a0,1456 # 64f8 <malloc+0x7fa>
     f50:	00005097          	auipc	ra,0x5
     f54:	cf6080e7          	jalr	-778(ra) # 5c46 <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00005097          	auipc	ra,0x5
     f5e:	97c080e7          	jalr	-1668(ra) # 58d6 <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	5a050513          	addi	a0,a0,1440 # 6518 <malloc+0x81a>
     f80:	00005097          	auipc	ra,0x5
     f84:	9a6080e7          	jalr	-1626(ra) # 5926 <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	58c50513          	addi	a0,a0,1420 # 6518 <malloc+0x81a>
     f94:	00005097          	auipc	ra,0x5
     f98:	982080e7          	jalr	-1662(ra) # 5916 <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00005097          	auipc	ra,0x5
     fa4:	95e080e7          	jalr	-1698(ra) # 58fe <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	56aa0a13          	addi	s4,s4,1386 # 6518 <malloc+0x81a>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9571b          	sraiw	a4,s2,0x1f
     fc2:	01a7571b          	srliw	a4,a4,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00005097          	auipc	ra,0x5
     ff2:	948080e7          	jalr	-1720(ra) # 5936 <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	51850513          	addi	a0,a0,1304 # 6518 <malloc+0x81a>
    1008:	00005097          	auipc	ra,0x5
    100c:	91e080e7          	jalr	-1762(ra) # 5926 <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d71b          	sraiw	a4,s1,0x1f
    1020:	01a7571b          	srliw	a4,a4,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00005097          	auipc	ra,0x5
    104e:	8dc080e7          	jalr	-1828(ra) # 5926 <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	4b050513          	addi	a0,a0,1200 # 6520 <malloc+0x822>
    1078:	00005097          	auipc	ra,0x5
    107c:	bce080e7          	jalr	-1074(ra) # 5c46 <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00005097          	auipc	ra,0x5
    1086:	854080e7          	jalr	-1964(ra) # 58d6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	4b050513          	addi	a0,a0,1200 # 6540 <malloc+0x842>
    1098:	00005097          	auipc	ra,0x5
    109c:	bae080e7          	jalr	-1106(ra) # 5c46 <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00005097          	auipc	ra,0x5
    10a6:	834080e7          	jalr	-1996(ra) # 58d6 <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	4b450513          	addi	a0,a0,1204 # 6560 <malloc+0x862>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	b92080e7          	jalr	-1134(ra) # 5c46 <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00005097          	auipc	ra,0x5
    10c2:	818080e7          	jalr	-2024(ra) # 58d6 <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	4a298993          	addi	s3,s3,1186 # 6580 <malloc+0x882>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00005097          	auipc	ra,0x5
    10f6:	844080e7          	jalr	-1980(ra) # 5936 <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	47650513          	addi	a0,a0,1142 # 6590 <malloc+0x892>
    1122:	00005097          	auipc	ra,0x5
    1126:	b24080e7          	jalr	-1244(ra) # 5c46 <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	7aa080e7          	jalr	1962(ra) # 58d6 <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	eaeb14b7          	lui	s1,0xeaeb1
    1146:	b5b48493          	addi	s1,s1,-1189 # ffffffffeaeb0b5b <__BSS_END__+0xffffffffeaea0a73>
    114a:	04d2                	slli	s1,s1,0x14
    114c:	048d                	addi	s1,s1,3
    114e:	04b2                	slli	s1,s1,0xc
    1150:	f5e48493          	addi	s1,s1,-162
    1154:	fd840593          	addi	a1,s0,-40
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	7b4080e7          	jalr	1972(ra) # 590e <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1162:	8526                	mv	a0,s1
    1164:	00004097          	auipc	ra,0x4
    1168:	782080e7          	jalr	1922(ra) # 58e6 <pipe>

  exit(0);
    116c:	4501                	li	a0,0
    116e:	00004097          	auipc	ra,0x4
    1172:	768080e7          	jalr	1896(ra) # 58d6 <exit>

0000000000001176 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1176:	7139                	addi	sp,sp,-64
    1178:	fc06                	sd	ra,56(sp)
    117a:	f822                	sd	s0,48(sp)
    117c:	f426                	sd	s1,40(sp)
    117e:	f04a                	sd	s2,32(sp)
    1180:	ec4e                	sd	s3,24(sp)
    1182:	0080                	addi	s0,sp,64
    1184:	64b1                	lui	s1,0xc
    1186:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1988>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    118a:	597d                	li	s2,-1
    118c:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1190:	00005997          	auipc	s3,0x5
    1194:	ca898993          	addi	s3,s3,-856 # 5e38 <malloc+0x13a>
    argv[0] = (char*)0xffffffff;
    1198:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119c:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11a0:	fc040593          	addi	a1,s0,-64
    11a4:	854e                	mv	a0,s3
    11a6:	00004097          	auipc	ra,0x4
    11aa:	768080e7          	jalr	1896(ra) # 590e <exec>
  for(int i = 0; i < 50000; i++){
    11ae:	34fd                	addiw	s1,s1,-1
    11b0:	f4e5                	bnez	s1,1198 <badarg+0x22>
  }
  
  exit(0);
    11b2:	4501                	li	a0,0
    11b4:	00004097          	auipc	ra,0x4
    11b8:	722080e7          	jalr	1826(ra) # 58d6 <exit>

00000000000011bc <copyinstr2>:
{
    11bc:	7155                	addi	sp,sp,-208
    11be:	e586                	sd	ra,200(sp)
    11c0:	e1a2                	sd	s0,192(sp)
    11c2:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c4:	f6840793          	addi	a5,s0,-152
    11c8:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11cc:	07800713          	li	a4,120
    11d0:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d4:	0785                	addi	a5,a5,1
    11d6:	fed79de3          	bne	a5,a3,11d0 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11da:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11de:	f6840513          	addi	a0,s0,-152
    11e2:	00004097          	auipc	ra,0x4
    11e6:	744080e7          	jalr	1860(ra) # 5926 <unlink>
  if(ret != -1){
    11ea:	57fd                	li	a5,-1
    11ec:	0ef51063          	bne	a0,a5,12cc <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11f0:	20100593          	li	a1,513
    11f4:	f6840513          	addi	a0,s0,-152
    11f8:	00004097          	auipc	ra,0x4
    11fc:	71e080e7          	jalr	1822(ra) # 5916 <open>
  if(fd != -1){
    1200:	57fd                	li	a5,-1
    1202:	0ef51563          	bne	a0,a5,12ec <copyinstr2+0x130>
  ret = link(b, b);
    1206:	f6840593          	addi	a1,s0,-152
    120a:	852e                	mv	a0,a1
    120c:	00004097          	auipc	ra,0x4
    1210:	72a080e7          	jalr	1834(ra) # 5936 <link>
  if(ret != -1){
    1214:	57fd                	li	a5,-1
    1216:	0ef51b63          	bne	a0,a5,130c <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    121a:	00006797          	auipc	a5,0x6
    121e:	56e78793          	addi	a5,a5,1390 # 7788 <malloc+0x1a8a>
    1222:	f4f43c23          	sd	a5,-168(s0)
    1226:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    122a:	f5840593          	addi	a1,s0,-168
    122e:	f6840513          	addi	a0,s0,-152
    1232:	00004097          	auipc	ra,0x4
    1236:	6dc080e7          	jalr	1756(ra) # 590e <exec>
  if(ret != -1){
    123a:	57fd                	li	a5,-1
    123c:	0ef51963          	bne	a0,a5,132e <copyinstr2+0x172>
  int pid = fork();
    1240:	00004097          	auipc	ra,0x4
    1244:	68e080e7          	jalr	1678(ra) # 58ce <fork>
  if(pid < 0){
    1248:	10054363          	bltz	a0,134e <copyinstr2+0x192>
  if(pid == 0){
    124c:	12051463          	bnez	a0,1374 <copyinstr2+0x1b8>
    1250:	00008797          	auipc	a5,0x8
    1254:	77078793          	addi	a5,a5,1904 # 99c0 <big.0>
    1258:	00009697          	auipc	a3,0x9
    125c:	76868693          	addi	a3,a3,1896 # a9c0 <__global_pointer$+0x90c>
      big[i] = 'x';
    1260:	07800713          	li	a4,120
    1264:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1268:	0785                	addi	a5,a5,1
    126a:	fed79de3          	bne	a5,a3,1264 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126e:	00009797          	auipc	a5,0x9
    1272:	74078923          	sb	zero,1874(a5) # a9c0 <__global_pointer$+0x90c>
    char *args2[] = { big, big, big, 0 };
    1276:	00007797          	auipc	a5,0x7
    127a:	f5a78793          	addi	a5,a5,-166 # 81d0 <malloc+0x24d2>
    127e:	6390                	ld	a2,0(a5)
    1280:	6794                	ld	a3,8(a5)
    1282:	6b98                	ld	a4,16(a5)
    1284:	6f9c                	ld	a5,24(a5)
    1286:	f2c43823          	sd	a2,-208(s0)
    128a:	f2d43c23          	sd	a3,-200(s0)
    128e:	f4e43023          	sd	a4,-192(s0)
    1292:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1296:	f3040593          	addi	a1,s0,-208
    129a:	00005517          	auipc	a0,0x5
    129e:	b9e50513          	addi	a0,a0,-1122 # 5e38 <malloc+0x13a>
    12a2:	00004097          	auipc	ra,0x4
    12a6:	66c080e7          	jalr	1644(ra) # 590e <exec>
    if(ret != -1){
    12aa:	57fd                	li	a5,-1
    12ac:	0af50e63          	beq	a0,a5,1368 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12b0:	55fd                	li	a1,-1
    12b2:	00005517          	auipc	a0,0x5
    12b6:	38650513          	addi	a0,a0,902 # 6638 <malloc+0x93a>
    12ba:	00005097          	auipc	ra,0x5
    12be:	98c080e7          	jalr	-1652(ra) # 5c46 <printf>
      exit(1);
    12c2:	4505                	li	a0,1
    12c4:	00004097          	auipc	ra,0x4
    12c8:	612080e7          	jalr	1554(ra) # 58d6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12cc:	862a                	mv	a2,a0
    12ce:	f6840593          	addi	a1,s0,-152
    12d2:	00005517          	auipc	a0,0x5
    12d6:	2de50513          	addi	a0,a0,734 # 65b0 <malloc+0x8b2>
    12da:	00005097          	auipc	ra,0x5
    12de:	96c080e7          	jalr	-1684(ra) # 5c46 <printf>
    exit(1);
    12e2:	4505                	li	a0,1
    12e4:	00004097          	auipc	ra,0x4
    12e8:	5f2080e7          	jalr	1522(ra) # 58d6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ec:	862a                	mv	a2,a0
    12ee:	f6840593          	addi	a1,s0,-152
    12f2:	00005517          	auipc	a0,0x5
    12f6:	2de50513          	addi	a0,a0,734 # 65d0 <malloc+0x8d2>
    12fa:	00005097          	auipc	ra,0x5
    12fe:	94c080e7          	jalr	-1716(ra) # 5c46 <printf>
    exit(1);
    1302:	4505                	li	a0,1
    1304:	00004097          	auipc	ra,0x4
    1308:	5d2080e7          	jalr	1490(ra) # 58d6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130c:	86aa                	mv	a3,a0
    130e:	f6840613          	addi	a2,s0,-152
    1312:	85b2                	mv	a1,a2
    1314:	00005517          	auipc	a0,0x5
    1318:	2dc50513          	addi	a0,a0,732 # 65f0 <malloc+0x8f2>
    131c:	00005097          	auipc	ra,0x5
    1320:	92a080e7          	jalr	-1750(ra) # 5c46 <printf>
    exit(1);
    1324:	4505                	li	a0,1
    1326:	00004097          	auipc	ra,0x4
    132a:	5b0080e7          	jalr	1456(ra) # 58d6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132e:	567d                	li	a2,-1
    1330:	f6840593          	addi	a1,s0,-152
    1334:	00005517          	auipc	a0,0x5
    1338:	2e450513          	addi	a0,a0,740 # 6618 <malloc+0x91a>
    133c:	00005097          	auipc	ra,0x5
    1340:	90a080e7          	jalr	-1782(ra) # 5c46 <printf>
    exit(1);
    1344:	4505                	li	a0,1
    1346:	00004097          	auipc	ra,0x4
    134a:	590080e7          	jalr	1424(ra) # 58d6 <exit>
    printf("fork failed\n");
    134e:	00005517          	auipc	a0,0x5
    1352:	76250513          	addi	a0,a0,1890 # 6ab0 <malloc+0xdb2>
    1356:	00005097          	auipc	ra,0x5
    135a:	8f0080e7          	jalr	-1808(ra) # 5c46 <printf>
    exit(1);
    135e:	4505                	li	a0,1
    1360:	00004097          	auipc	ra,0x4
    1364:	576080e7          	jalr	1398(ra) # 58d6 <exit>
    exit(747); // OK
    1368:	2eb00513          	li	a0,747
    136c:	00004097          	auipc	ra,0x4
    1370:	56a080e7          	jalr	1386(ra) # 58d6 <exit>
  int st = 0;
    1374:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1378:	f5440513          	addi	a0,s0,-172
    137c:	00004097          	auipc	ra,0x4
    1380:	562080e7          	jalr	1378(ra) # 58de <wait>
  if(st != 747){
    1384:	f5442703          	lw	a4,-172(s0)
    1388:	2eb00793          	li	a5,747
    138c:	00f71663          	bne	a4,a5,1398 <copyinstr2+0x1dc>
}
    1390:	60ae                	ld	ra,200(sp)
    1392:	640e                	ld	s0,192(sp)
    1394:	6169                	addi	sp,sp,208
    1396:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1398:	00005517          	auipc	a0,0x5
    139c:	2c850513          	addi	a0,a0,712 # 6660 <malloc+0x962>
    13a0:	00005097          	auipc	ra,0x5
    13a4:	8a6080e7          	jalr	-1882(ra) # 5c46 <printf>
    exit(1);
    13a8:	4505                	li	a0,1
    13aa:	00004097          	auipc	ra,0x4
    13ae:	52c080e7          	jalr	1324(ra) # 58d6 <exit>

00000000000013b2 <truncate3>:
{
    13b2:	7159                	addi	sp,sp,-112
    13b4:	f486                	sd	ra,104(sp)
    13b6:	f0a2                	sd	s0,96(sp)
    13b8:	e8ca                	sd	s2,80(sp)
    13ba:	1880                	addi	s0,sp,112
    13bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13be:	60100593          	li	a1,1537
    13c2:	00005517          	auipc	a0,0x5
    13c6:	ace50513          	addi	a0,a0,-1330 # 5e90 <malloc+0x192>
    13ca:	00004097          	auipc	ra,0x4
    13ce:	54c080e7          	jalr	1356(ra) # 5916 <open>
    13d2:	00004097          	auipc	ra,0x4
    13d6:	52c080e7          	jalr	1324(ra) # 58fe <close>
  pid = fork();
    13da:	00004097          	auipc	ra,0x4
    13de:	4f4080e7          	jalr	1268(ra) # 58ce <fork>
  if(pid < 0){
    13e2:	08054463          	bltz	a0,146a <truncate3+0xb8>
  if(pid == 0){
    13e6:	e16d                	bnez	a0,14c8 <truncate3+0x116>
    13e8:	eca6                	sd	s1,88(sp)
    13ea:	e4ce                	sd	s3,72(sp)
    13ec:	e0d2                	sd	s4,64(sp)
    13ee:	fc56                	sd	s5,56(sp)
    13f0:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f4:	00005a17          	auipc	s4,0x5
    13f8:	a9ca0a13          	addi	s4,s4,-1380 # 5e90 <malloc+0x192>
      int n = write(fd, "1234567890", 10);
    13fc:	00005a97          	auipc	s5,0x5
    1400:	2c4a8a93          	addi	s5,s5,708 # 66c0 <malloc+0x9c2>
      int fd = open("truncfile", O_WRONLY);
    1404:	4585                	li	a1,1
    1406:	8552                	mv	a0,s4
    1408:	00004097          	auipc	ra,0x4
    140c:	50e080e7          	jalr	1294(ra) # 5916 <open>
    1410:	84aa                	mv	s1,a0
      if(fd < 0){
    1412:	06054e63          	bltz	a0,148e <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    1416:	4629                	li	a2,10
    1418:	85d6                	mv	a1,s5
    141a:	00004097          	auipc	ra,0x4
    141e:	4dc080e7          	jalr	1244(ra) # 58f6 <write>
      if(n != 10){
    1422:	47a9                	li	a5,10
    1424:	08f51363          	bne	a0,a5,14aa <truncate3+0xf8>
      close(fd);
    1428:	8526                	mv	a0,s1
    142a:	00004097          	auipc	ra,0x4
    142e:	4d4080e7          	jalr	1236(ra) # 58fe <close>
      fd = open("truncfile", O_RDONLY);
    1432:	4581                	li	a1,0
    1434:	8552                	mv	a0,s4
    1436:	00004097          	auipc	ra,0x4
    143a:	4e0080e7          	jalr	1248(ra) # 5916 <open>
    143e:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1440:	02000613          	li	a2,32
    1444:	f9840593          	addi	a1,s0,-104
    1448:	00004097          	auipc	ra,0x4
    144c:	4a6080e7          	jalr	1190(ra) # 58ee <read>
      close(fd);
    1450:	8526                	mv	a0,s1
    1452:	00004097          	auipc	ra,0x4
    1456:	4ac080e7          	jalr	1196(ra) # 58fe <close>
    for(int i = 0; i < 100; i++){
    145a:	39fd                	addiw	s3,s3,-1
    145c:	fa0994e3          	bnez	s3,1404 <truncate3+0x52>
    exit(0);
    1460:	4501                	li	a0,0
    1462:	00004097          	auipc	ra,0x4
    1466:	474080e7          	jalr	1140(ra) # 58d6 <exit>
    146a:	eca6                	sd	s1,88(sp)
    146c:	e4ce                	sd	s3,72(sp)
    146e:	e0d2                	sd	s4,64(sp)
    1470:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1472:	85ca                	mv	a1,s2
    1474:	00005517          	auipc	a0,0x5
    1478:	21c50513          	addi	a0,a0,540 # 6690 <malloc+0x992>
    147c:	00004097          	auipc	ra,0x4
    1480:	7ca080e7          	jalr	1994(ra) # 5c46 <printf>
    exit(1);
    1484:	4505                	li	a0,1
    1486:	00004097          	auipc	ra,0x4
    148a:	450080e7          	jalr	1104(ra) # 58d6 <exit>
        printf("%s: open failed\n", s);
    148e:	85ca                	mv	a1,s2
    1490:	00005517          	auipc	a0,0x5
    1494:	21850513          	addi	a0,a0,536 # 66a8 <malloc+0x9aa>
    1498:	00004097          	auipc	ra,0x4
    149c:	7ae080e7          	jalr	1966(ra) # 5c46 <printf>
        exit(1);
    14a0:	4505                	li	a0,1
    14a2:	00004097          	auipc	ra,0x4
    14a6:	434080e7          	jalr	1076(ra) # 58d6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14aa:	862a                	mv	a2,a0
    14ac:	85ca                	mv	a1,s2
    14ae:	00005517          	auipc	a0,0x5
    14b2:	22250513          	addi	a0,a0,546 # 66d0 <malloc+0x9d2>
    14b6:	00004097          	auipc	ra,0x4
    14ba:	790080e7          	jalr	1936(ra) # 5c46 <printf>
        exit(1);
    14be:	4505                	li	a0,1
    14c0:	00004097          	auipc	ra,0x4
    14c4:	416080e7          	jalr	1046(ra) # 58d6 <exit>
    14c8:	eca6                	sd	s1,88(sp)
    14ca:	e4ce                	sd	s3,72(sp)
    14cc:	e0d2                	sd	s4,64(sp)
    14ce:	fc56                	sd	s5,56(sp)
    14d0:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d4:	00005a17          	auipc	s4,0x5
    14d8:	9bca0a13          	addi	s4,s4,-1604 # 5e90 <malloc+0x192>
    int n = write(fd, "xxx", 3);
    14dc:	00005a97          	auipc	s5,0x5
    14e0:	214a8a93          	addi	s5,s5,532 # 66f0 <malloc+0x9f2>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14e4:	60100593          	li	a1,1537
    14e8:	8552                	mv	a0,s4
    14ea:	00004097          	auipc	ra,0x4
    14ee:	42c080e7          	jalr	1068(ra) # 5916 <open>
    14f2:	84aa                	mv	s1,a0
    if(fd < 0){
    14f4:	04054763          	bltz	a0,1542 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    14f8:	460d                	li	a2,3
    14fa:	85d6                	mv	a1,s5
    14fc:	00004097          	auipc	ra,0x4
    1500:	3fa080e7          	jalr	1018(ra) # 58f6 <write>
    if(n != 3){
    1504:	478d                	li	a5,3
    1506:	04f51c63          	bne	a0,a5,155e <truncate3+0x1ac>
    close(fd);
    150a:	8526                	mv	a0,s1
    150c:	00004097          	auipc	ra,0x4
    1510:	3f2080e7          	jalr	1010(ra) # 58fe <close>
  for(int i = 0; i < 150; i++){
    1514:	39fd                	addiw	s3,s3,-1
    1516:	fc0997e3          	bnez	s3,14e4 <truncate3+0x132>
  wait(&xstatus);
    151a:	fbc40513          	addi	a0,s0,-68
    151e:	00004097          	auipc	ra,0x4
    1522:	3c0080e7          	jalr	960(ra) # 58de <wait>
  unlink("truncfile");
    1526:	00005517          	auipc	a0,0x5
    152a:	96a50513          	addi	a0,a0,-1686 # 5e90 <malloc+0x192>
    152e:	00004097          	auipc	ra,0x4
    1532:	3f8080e7          	jalr	1016(ra) # 5926 <unlink>
  exit(xstatus);
    1536:	fbc42503          	lw	a0,-68(s0)
    153a:	00004097          	auipc	ra,0x4
    153e:	39c080e7          	jalr	924(ra) # 58d6 <exit>
      printf("%s: open failed\n", s);
    1542:	85ca                	mv	a1,s2
    1544:	00005517          	auipc	a0,0x5
    1548:	16450513          	addi	a0,a0,356 # 66a8 <malloc+0x9aa>
    154c:	00004097          	auipc	ra,0x4
    1550:	6fa080e7          	jalr	1786(ra) # 5c46 <printf>
      exit(1);
    1554:	4505                	li	a0,1
    1556:	00004097          	auipc	ra,0x4
    155a:	380080e7          	jalr	896(ra) # 58d6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    155e:	862a                	mv	a2,a0
    1560:	85ca                	mv	a1,s2
    1562:	00005517          	auipc	a0,0x5
    1566:	19650513          	addi	a0,a0,406 # 66f8 <malloc+0x9fa>
    156a:	00004097          	auipc	ra,0x4
    156e:	6dc080e7          	jalr	1756(ra) # 5c46 <printf>
      exit(1);
    1572:	4505                	li	a0,1
    1574:	00004097          	auipc	ra,0x4
    1578:	362080e7          	jalr	866(ra) # 58d6 <exit>

000000000000157c <exectest>:
{
    157c:	715d                	addi	sp,sp,-80
    157e:	e486                	sd	ra,72(sp)
    1580:	e0a2                	sd	s0,64(sp)
    1582:	f84a                	sd	s2,48(sp)
    1584:	0880                	addi	s0,sp,80
    1586:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1588:	00005797          	auipc	a5,0x5
    158c:	8b078793          	addi	a5,a5,-1872 # 5e38 <malloc+0x13a>
    1590:	fcf43023          	sd	a5,-64(s0)
    1594:	00005797          	auipc	a5,0x5
    1598:	18478793          	addi	a5,a5,388 # 6718 <malloc+0xa1a>
    159c:	fcf43423          	sd	a5,-56(s0)
    15a0:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a4:	00005517          	auipc	a0,0x5
    15a8:	17c50513          	addi	a0,a0,380 # 6720 <malloc+0xa22>
    15ac:	00004097          	auipc	ra,0x4
    15b0:	37a080e7          	jalr	890(ra) # 5926 <unlink>
  pid = fork();
    15b4:	00004097          	auipc	ra,0x4
    15b8:	31a080e7          	jalr	794(ra) # 58ce <fork>
  if(pid < 0) {
    15bc:	04054763          	bltz	a0,160a <exectest+0x8e>
    15c0:	fc26                	sd	s1,56(sp)
    15c2:	84aa                	mv	s1,a0
  if(pid == 0) {
    15c4:	ed41                	bnez	a0,165c <exectest+0xe0>
    close(1);
    15c6:	4505                	li	a0,1
    15c8:	00004097          	auipc	ra,0x4
    15cc:	336080e7          	jalr	822(ra) # 58fe <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15d0:	20100593          	li	a1,513
    15d4:	00005517          	auipc	a0,0x5
    15d8:	14c50513          	addi	a0,a0,332 # 6720 <malloc+0xa22>
    15dc:	00004097          	auipc	ra,0x4
    15e0:	33a080e7          	jalr	826(ra) # 5916 <open>
    if(fd < 0) {
    15e4:	04054263          	bltz	a0,1628 <exectest+0xac>
    if(fd != 1) {
    15e8:	4785                	li	a5,1
    15ea:	04f50d63          	beq	a0,a5,1644 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    15ee:	85ca                	mv	a1,s2
    15f0:	00005517          	auipc	a0,0x5
    15f4:	15050513          	addi	a0,a0,336 # 6740 <malloc+0xa42>
    15f8:	00004097          	auipc	ra,0x4
    15fc:	64e080e7          	jalr	1614(ra) # 5c46 <printf>
      exit(1);
    1600:	4505                	li	a0,1
    1602:	00004097          	auipc	ra,0x4
    1606:	2d4080e7          	jalr	724(ra) # 58d6 <exit>
    160a:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	08250513          	addi	a0,a0,130 # 6690 <malloc+0x992>
    1616:	00004097          	auipc	ra,0x4
    161a:	630080e7          	jalr	1584(ra) # 5c46 <printf>
     exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	2b6080e7          	jalr	694(ra) # 58d6 <exit>
      printf("%s: create failed\n", s);
    1628:	85ca                	mv	a1,s2
    162a:	00005517          	auipc	a0,0x5
    162e:	0fe50513          	addi	a0,a0,254 # 6728 <malloc+0xa2a>
    1632:	00004097          	auipc	ra,0x4
    1636:	614080e7          	jalr	1556(ra) # 5c46 <printf>
      exit(1);
    163a:	4505                	li	a0,1
    163c:	00004097          	auipc	ra,0x4
    1640:	29a080e7          	jalr	666(ra) # 58d6 <exit>
    if(exec("echo", echoargv) < 0){
    1644:	fc040593          	addi	a1,s0,-64
    1648:	00004517          	auipc	a0,0x4
    164c:	7f050513          	addi	a0,a0,2032 # 5e38 <malloc+0x13a>
    1650:	00004097          	auipc	ra,0x4
    1654:	2be080e7          	jalr	702(ra) # 590e <exec>
    1658:	02054163          	bltz	a0,167a <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    165c:	fdc40513          	addi	a0,s0,-36
    1660:	00004097          	auipc	ra,0x4
    1664:	27e080e7          	jalr	638(ra) # 58de <wait>
    1668:	02951763          	bne	a0,s1,1696 <exectest+0x11a>
  if(xstatus != 0)
    166c:	fdc42503          	lw	a0,-36(s0)
    1670:	cd0d                	beqz	a0,16aa <exectest+0x12e>
    exit(xstatus);
    1672:	00004097          	auipc	ra,0x4
    1676:	264080e7          	jalr	612(ra) # 58d6 <exit>
      printf("%s: exec echo failed\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	0d450513          	addi	a0,a0,212 # 6750 <malloc+0xa52>
    1684:	00004097          	auipc	ra,0x4
    1688:	5c2080e7          	jalr	1474(ra) # 5c46 <printf>
      exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	248080e7          	jalr	584(ra) # 58d6 <exit>
    printf("%s: wait failed!\n", s);
    1696:	85ca                	mv	a1,s2
    1698:	00005517          	auipc	a0,0x5
    169c:	0d050513          	addi	a0,a0,208 # 6768 <malloc+0xa6a>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	5a6080e7          	jalr	1446(ra) # 5c46 <printf>
    16a8:	b7d1                	j	166c <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    16aa:	4581                	li	a1,0
    16ac:	00005517          	auipc	a0,0x5
    16b0:	07450513          	addi	a0,a0,116 # 6720 <malloc+0xa22>
    16b4:	00004097          	auipc	ra,0x4
    16b8:	262080e7          	jalr	610(ra) # 5916 <open>
  if(fd < 0) {
    16bc:	02054a63          	bltz	a0,16f0 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    16c0:	4609                	li	a2,2
    16c2:	fb840593          	addi	a1,s0,-72
    16c6:	00004097          	auipc	ra,0x4
    16ca:	228080e7          	jalr	552(ra) # 58ee <read>
    16ce:	4789                	li	a5,2
    16d0:	02f50e63          	beq	a0,a5,170c <exectest+0x190>
    printf("%s: read failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	b0250513          	addi	a0,a0,-1278 # 61d8 <malloc+0x4da>
    16de:	00004097          	auipc	ra,0x4
    16e2:	568080e7          	jalr	1384(ra) # 5c46 <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	1ee080e7          	jalr	494(ra) # 58d6 <exit>
    printf("%s: open failed\n", s);
    16f0:	85ca                	mv	a1,s2
    16f2:	00005517          	auipc	a0,0x5
    16f6:	fb650513          	addi	a0,a0,-74 # 66a8 <malloc+0x9aa>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	54c080e7          	jalr	1356(ra) # 5c46 <printf>
    exit(1);
    1702:	4505                	li	a0,1
    1704:	00004097          	auipc	ra,0x4
    1708:	1d2080e7          	jalr	466(ra) # 58d6 <exit>
  unlink("echo-ok");
    170c:	00005517          	auipc	a0,0x5
    1710:	01450513          	addi	a0,a0,20 # 6720 <malloc+0xa22>
    1714:	00004097          	auipc	ra,0x4
    1718:	212080e7          	jalr	530(ra) # 5926 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    171c:	fb844703          	lbu	a4,-72(s0)
    1720:	04f00793          	li	a5,79
    1724:	00f71863          	bne	a4,a5,1734 <exectest+0x1b8>
    1728:	fb944703          	lbu	a4,-71(s0)
    172c:	04b00793          	li	a5,75
    1730:	02f70063          	beq	a4,a5,1750 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	04a50513          	addi	a0,a0,74 # 6780 <malloc+0xa82>
    173e:	00004097          	auipc	ra,0x4
    1742:	508080e7          	jalr	1288(ra) # 5c46 <printf>
    exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	18e080e7          	jalr	398(ra) # 58d6 <exit>
    exit(0);
    1750:	4501                	li	a0,0
    1752:	00004097          	auipc	ra,0x4
    1756:	184080e7          	jalr	388(ra) # 58d6 <exit>

000000000000175a <pipe1>:
{
    175a:	711d                	addi	sp,sp,-96
    175c:	ec86                	sd	ra,88(sp)
    175e:	e8a2                	sd	s0,80(sp)
    1760:	fc4e                	sd	s3,56(sp)
    1762:	1080                	addi	s0,sp,96
    1764:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    1766:	fa840513          	addi	a0,s0,-88
    176a:	00004097          	auipc	ra,0x4
    176e:	17c080e7          	jalr	380(ra) # 58e6 <pipe>
    1772:	ed3d                	bnez	a0,17f0 <pipe1+0x96>
    1774:	e4a6                	sd	s1,72(sp)
    1776:	f852                	sd	s4,48(sp)
    1778:	84aa                	mv	s1,a0
  pid = fork();
    177a:	00004097          	auipc	ra,0x4
    177e:	154080e7          	jalr	340(ra) # 58ce <fork>
    1782:	8a2a                	mv	s4,a0
  if(pid == 0){
    1784:	c951                	beqz	a0,1818 <pipe1+0xbe>
  } else if(pid > 0){
    1786:	18a05b63          	blez	a0,191c <pipe1+0x1c2>
    178a:	e0ca                	sd	s2,64(sp)
    178c:	f456                	sd	s5,40(sp)
    close(fds[1]);
    178e:	fac42503          	lw	a0,-84(s0)
    1792:	00004097          	auipc	ra,0x4
    1796:	16c080e7          	jalr	364(ra) # 58fe <close>
    total = 0;
    179a:	8a26                	mv	s4,s1
    cc = 1;
    179c:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    179e:	0000ca97          	auipc	s5,0xc
    17a2:	93aa8a93          	addi	s5,s5,-1734 # d0d8 <buf>
    17a6:	864a                	mv	a2,s2
    17a8:	85d6                	mv	a1,s5
    17aa:	fa842503          	lw	a0,-88(s0)
    17ae:	00004097          	auipc	ra,0x4
    17b2:	140080e7          	jalr	320(ra) # 58ee <read>
    17b6:	10a05a63          	blez	a0,18ca <pipe1+0x170>
      for(i = 0; i < n; i++){
    17ba:	0000c717          	auipc	a4,0xc
    17be:	91e70713          	addi	a4,a4,-1762 # d0d8 <buf>
    17c2:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17c6:	00074683          	lbu	a3,0(a4)
    17ca:	0ff4f793          	zext.b	a5,s1
    17ce:	2485                	addiw	s1,s1,1
    17d0:	0cf69b63          	bne	a3,a5,18a6 <pipe1+0x14c>
      for(i = 0; i < n; i++){
    17d4:	0705                	addi	a4,a4,1
    17d6:	fec498e3          	bne	s1,a2,17c6 <pipe1+0x6c>
      total += n;
    17da:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17de:	0019179b          	slliw	a5,s2,0x1
    17e2:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    17e6:	670d                	lui	a4,0x3
    17e8:	fb277fe3          	bgeu	a4,s2,17a6 <pipe1+0x4c>
        cc = sizeof(buf);
    17ec:	690d                	lui	s2,0x3
    17ee:	bf65                	j	17a6 <pipe1+0x4c>
    17f0:	e4a6                	sd	s1,72(sp)
    17f2:	e0ca                	sd	s2,64(sp)
    17f4:	f852                	sd	s4,48(sp)
    17f6:	f456                	sd	s5,40(sp)
    17f8:	f05a                	sd	s6,32(sp)
    17fa:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    17fc:	85ce                	mv	a1,s3
    17fe:	00005517          	auipc	a0,0x5
    1802:	f9a50513          	addi	a0,a0,-102 # 6798 <malloc+0xa9a>
    1806:	00004097          	auipc	ra,0x4
    180a:	440080e7          	jalr	1088(ra) # 5c46 <printf>
    exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	0c6080e7          	jalr	198(ra) # 58d6 <exit>
    1818:	e0ca                	sd	s2,64(sp)
    181a:	f456                	sd	s5,40(sp)
    181c:	f05a                	sd	s6,32(sp)
    181e:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1820:	fa842503          	lw	a0,-88(s0)
    1824:	00004097          	auipc	ra,0x4
    1828:	0da080e7          	jalr	218(ra) # 58fe <close>
    for(n = 0; n < N; n++){
    182c:	0000cb17          	auipc	s6,0xc
    1830:	8acb0b13          	addi	s6,s6,-1876 # d0d8 <buf>
    1834:	416004bb          	negw	s1,s6
    1838:	0ff4f493          	zext.b	s1,s1
    183c:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1840:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1842:	6a85                	lui	s5,0x1
    1844:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7b>
{
    1848:	87da                	mv	a5,s6
        buf[i] = seq++;
    184a:	0097873b          	addw	a4,a5,s1
    184e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1852:	0785                	addi	a5,a5,1
    1854:	ff279be3          	bne	a5,s2,184a <pipe1+0xf0>
    1858:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    185c:	40900613          	li	a2,1033
    1860:	85de                	mv	a1,s7
    1862:	fac42503          	lw	a0,-84(s0)
    1866:	00004097          	auipc	ra,0x4
    186a:	090080e7          	jalr	144(ra) # 58f6 <write>
    186e:	40900793          	li	a5,1033
    1872:	00f51c63          	bne	a0,a5,188a <pipe1+0x130>
    for(n = 0; n < N; n++){
    1876:	24a5                	addiw	s1,s1,9
    1878:	0ff4f493          	zext.b	s1,s1
    187c:	fd5a16e3          	bne	s4,s5,1848 <pipe1+0xee>
    exit(0);
    1880:	4501                	li	a0,0
    1882:	00004097          	auipc	ra,0x4
    1886:	054080e7          	jalr	84(ra) # 58d6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    188a:	85ce                	mv	a1,s3
    188c:	00005517          	auipc	a0,0x5
    1890:	f2450513          	addi	a0,a0,-220 # 67b0 <malloc+0xab2>
    1894:	00004097          	auipc	ra,0x4
    1898:	3b2080e7          	jalr	946(ra) # 5c46 <printf>
        exit(1);
    189c:	4505                	li	a0,1
    189e:	00004097          	auipc	ra,0x4
    18a2:	038080e7          	jalr	56(ra) # 58d6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    18a6:	85ce                	mv	a1,s3
    18a8:	00005517          	auipc	a0,0x5
    18ac:	f2050513          	addi	a0,a0,-224 # 67c8 <malloc+0xaca>
    18b0:	00004097          	auipc	ra,0x4
    18b4:	396080e7          	jalr	918(ra) # 5c46 <printf>
          return;
    18b8:	64a6                	ld	s1,72(sp)
    18ba:	6906                	ld	s2,64(sp)
    18bc:	7a42                	ld	s4,48(sp)
    18be:	7aa2                	ld	s5,40(sp)
}
    18c0:	60e6                	ld	ra,88(sp)
    18c2:	6446                	ld	s0,80(sp)
    18c4:	79e2                	ld	s3,56(sp)
    18c6:	6125                	addi	sp,sp,96
    18c8:	8082                	ret
    if(total != N * SZ){
    18ca:	6785                	lui	a5,0x1
    18cc:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7b>
    18d0:	02fa0263          	beq	s4,a5,18f4 <pipe1+0x19a>
    18d4:	f05a                	sd	s6,32(sp)
    18d6:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    18d8:	85d2                	mv	a1,s4
    18da:	00005517          	auipc	a0,0x5
    18de:	f0650513          	addi	a0,a0,-250 # 67e0 <malloc+0xae2>
    18e2:	00004097          	auipc	ra,0x4
    18e6:	364080e7          	jalr	868(ra) # 5c46 <printf>
      exit(1);
    18ea:	4505                	li	a0,1
    18ec:	00004097          	auipc	ra,0x4
    18f0:	fea080e7          	jalr	-22(ra) # 58d6 <exit>
    18f4:	f05a                	sd	s6,32(sp)
    18f6:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    18f8:	fa842503          	lw	a0,-88(s0)
    18fc:	00004097          	auipc	ra,0x4
    1900:	002080e7          	jalr	2(ra) # 58fe <close>
    wait(&xstatus);
    1904:	fa440513          	addi	a0,s0,-92
    1908:	00004097          	auipc	ra,0x4
    190c:	fd6080e7          	jalr	-42(ra) # 58de <wait>
    exit(xstatus);
    1910:	fa442503          	lw	a0,-92(s0)
    1914:	00004097          	auipc	ra,0x4
    1918:	fc2080e7          	jalr	-62(ra) # 58d6 <exit>
    191c:	e0ca                	sd	s2,64(sp)
    191e:	f456                	sd	s5,40(sp)
    1920:	f05a                	sd	s6,32(sp)
    1922:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1924:	85ce                	mv	a1,s3
    1926:	00005517          	auipc	a0,0x5
    192a:	eda50513          	addi	a0,a0,-294 # 6800 <malloc+0xb02>
    192e:	00004097          	auipc	ra,0x4
    1932:	318080e7          	jalr	792(ra) # 5c46 <printf>
    exit(1);
    1936:	4505                	li	a0,1
    1938:	00004097          	auipc	ra,0x4
    193c:	f9e080e7          	jalr	-98(ra) # 58d6 <exit>

0000000000001940 <exitwait>:
{
    1940:	7139                	addi	sp,sp,-64
    1942:	fc06                	sd	ra,56(sp)
    1944:	f822                	sd	s0,48(sp)
    1946:	f426                	sd	s1,40(sp)
    1948:	f04a                	sd	s2,32(sp)
    194a:	ec4e                	sd	s3,24(sp)
    194c:	e852                	sd	s4,16(sp)
    194e:	0080                	addi	s0,sp,64
    1950:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1952:	4901                	li	s2,0
    1954:	06400993          	li	s3,100
    pid = fork();
    1958:	00004097          	auipc	ra,0x4
    195c:	f76080e7          	jalr	-138(ra) # 58ce <fork>
    1960:	84aa                	mv	s1,a0
    if(pid < 0){
    1962:	02054a63          	bltz	a0,1996 <exitwait+0x56>
    if(pid){
    1966:	c151                	beqz	a0,19ea <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1968:	fcc40513          	addi	a0,s0,-52
    196c:	00004097          	auipc	ra,0x4
    1970:	f72080e7          	jalr	-142(ra) # 58de <wait>
    1974:	02951f63          	bne	a0,s1,19b2 <exitwait+0x72>
      if(i != xstate) {
    1978:	fcc42783          	lw	a5,-52(s0)
    197c:	05279963          	bne	a5,s2,19ce <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1980:	2905                	addiw	s2,s2,1 # 3001 <iputtest+0x2d>
    1982:	fd391be3          	bne	s2,s3,1958 <exitwait+0x18>
}
    1986:	70e2                	ld	ra,56(sp)
    1988:	7442                	ld	s0,48(sp)
    198a:	74a2                	ld	s1,40(sp)
    198c:	7902                	ld	s2,32(sp)
    198e:	69e2                	ld	s3,24(sp)
    1990:	6a42                	ld	s4,16(sp)
    1992:	6121                	addi	sp,sp,64
    1994:	8082                	ret
      printf("%s: fork failed\n", s);
    1996:	85d2                	mv	a1,s4
    1998:	00005517          	auipc	a0,0x5
    199c:	cf850513          	addi	a0,a0,-776 # 6690 <malloc+0x992>
    19a0:	00004097          	auipc	ra,0x4
    19a4:	2a6080e7          	jalr	678(ra) # 5c46 <printf>
      exit(1);
    19a8:	4505                	li	a0,1
    19aa:	00004097          	auipc	ra,0x4
    19ae:	f2c080e7          	jalr	-212(ra) # 58d6 <exit>
        printf("%s: wait wrong pid\n", s);
    19b2:	85d2                	mv	a1,s4
    19b4:	00005517          	auipc	a0,0x5
    19b8:	e6450513          	addi	a0,a0,-412 # 6818 <malloc+0xb1a>
    19bc:	00004097          	auipc	ra,0x4
    19c0:	28a080e7          	jalr	650(ra) # 5c46 <printf>
        exit(1);
    19c4:	4505                	li	a0,1
    19c6:	00004097          	auipc	ra,0x4
    19ca:	f10080e7          	jalr	-240(ra) # 58d6 <exit>
        printf("%s: wait wrong exit status\n", s);
    19ce:	85d2                	mv	a1,s4
    19d0:	00005517          	auipc	a0,0x5
    19d4:	e6050513          	addi	a0,a0,-416 # 6830 <malloc+0xb32>
    19d8:	00004097          	auipc	ra,0x4
    19dc:	26e080e7          	jalr	622(ra) # 5c46 <printf>
        exit(1);
    19e0:	4505                	li	a0,1
    19e2:	00004097          	auipc	ra,0x4
    19e6:	ef4080e7          	jalr	-268(ra) # 58d6 <exit>
      exit(i);
    19ea:	854a                	mv	a0,s2
    19ec:	00004097          	auipc	ra,0x4
    19f0:	eea080e7          	jalr	-278(ra) # 58d6 <exit>

00000000000019f4 <twochildren>:
{
    19f4:	1101                	addi	sp,sp,-32
    19f6:	ec06                	sd	ra,24(sp)
    19f8:	e822                	sd	s0,16(sp)
    19fa:	e426                	sd	s1,8(sp)
    19fc:	e04a                	sd	s2,0(sp)
    19fe:	1000                	addi	s0,sp,32
    1a00:	892a                	mv	s2,a0
    1a02:	3e800493          	li	s1,1000
    int pid1 = fork();
    1a06:	00004097          	auipc	ra,0x4
    1a0a:	ec8080e7          	jalr	-312(ra) # 58ce <fork>
    if(pid1 < 0){
    1a0e:	02054c63          	bltz	a0,1a46 <twochildren+0x52>
    if(pid1 == 0){
    1a12:	c921                	beqz	a0,1a62 <twochildren+0x6e>
      int pid2 = fork();
    1a14:	00004097          	auipc	ra,0x4
    1a18:	eba080e7          	jalr	-326(ra) # 58ce <fork>
      if(pid2 < 0){
    1a1c:	04054763          	bltz	a0,1a6a <twochildren+0x76>
      if(pid2 == 0){
    1a20:	c13d                	beqz	a0,1a86 <twochildren+0x92>
        wait(0);
    1a22:	4501                	li	a0,0
    1a24:	00004097          	auipc	ra,0x4
    1a28:	eba080e7          	jalr	-326(ra) # 58de <wait>
        wait(0);
    1a2c:	4501                	li	a0,0
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	eb0080e7          	jalr	-336(ra) # 58de <wait>
  for(int i = 0; i < 1000; i++){
    1a36:	34fd                	addiw	s1,s1,-1
    1a38:	f4f9                	bnez	s1,1a06 <twochildren+0x12>
}
    1a3a:	60e2                	ld	ra,24(sp)
    1a3c:	6442                	ld	s0,16(sp)
    1a3e:	64a2                	ld	s1,8(sp)
    1a40:	6902                	ld	s2,0(sp)
    1a42:	6105                	addi	sp,sp,32
    1a44:	8082                	ret
      printf("%s: fork failed\n", s);
    1a46:	85ca                	mv	a1,s2
    1a48:	00005517          	auipc	a0,0x5
    1a4c:	c4850513          	addi	a0,a0,-952 # 6690 <malloc+0x992>
    1a50:	00004097          	auipc	ra,0x4
    1a54:	1f6080e7          	jalr	502(ra) # 5c46 <printf>
      exit(1);
    1a58:	4505                	li	a0,1
    1a5a:	00004097          	auipc	ra,0x4
    1a5e:	e7c080e7          	jalr	-388(ra) # 58d6 <exit>
      exit(0);
    1a62:	00004097          	auipc	ra,0x4
    1a66:	e74080e7          	jalr	-396(ra) # 58d6 <exit>
        printf("%s: fork failed\n", s);
    1a6a:	85ca                	mv	a1,s2
    1a6c:	00005517          	auipc	a0,0x5
    1a70:	c2450513          	addi	a0,a0,-988 # 6690 <malloc+0x992>
    1a74:	00004097          	auipc	ra,0x4
    1a78:	1d2080e7          	jalr	466(ra) # 5c46 <printf>
        exit(1);
    1a7c:	4505                	li	a0,1
    1a7e:	00004097          	auipc	ra,0x4
    1a82:	e58080e7          	jalr	-424(ra) # 58d6 <exit>
        exit(0);
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	e50080e7          	jalr	-432(ra) # 58d6 <exit>

0000000000001a8e <forkfork>:
{
    1a8e:	7179                	addi	sp,sp,-48
    1a90:	f406                	sd	ra,40(sp)
    1a92:	f022                	sd	s0,32(sp)
    1a94:	ec26                	sd	s1,24(sp)
    1a96:	1800                	addi	s0,sp,48
    1a98:	84aa                	mv	s1,a0
    int pid = fork();
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	e34080e7          	jalr	-460(ra) # 58ce <fork>
    if(pid < 0){
    1aa2:	04054163          	bltz	a0,1ae4 <forkfork+0x56>
    if(pid == 0){
    1aa6:	cd29                	beqz	a0,1b00 <forkfork+0x72>
    int pid = fork();
    1aa8:	00004097          	auipc	ra,0x4
    1aac:	e26080e7          	jalr	-474(ra) # 58ce <fork>
    if(pid < 0){
    1ab0:	02054a63          	bltz	a0,1ae4 <forkfork+0x56>
    if(pid == 0){
    1ab4:	c531                	beqz	a0,1b00 <forkfork+0x72>
    wait(&xstatus);
    1ab6:	fdc40513          	addi	a0,s0,-36
    1aba:	00004097          	auipc	ra,0x4
    1abe:	e24080e7          	jalr	-476(ra) # 58de <wait>
    if(xstatus != 0) {
    1ac2:	fdc42783          	lw	a5,-36(s0)
    1ac6:	ebbd                	bnez	a5,1b3c <forkfork+0xae>
    wait(&xstatus);
    1ac8:	fdc40513          	addi	a0,s0,-36
    1acc:	00004097          	auipc	ra,0x4
    1ad0:	e12080e7          	jalr	-494(ra) # 58de <wait>
    if(xstatus != 0) {
    1ad4:	fdc42783          	lw	a5,-36(s0)
    1ad8:	e3b5                	bnez	a5,1b3c <forkfork+0xae>
}
    1ada:	70a2                	ld	ra,40(sp)
    1adc:	7402                	ld	s0,32(sp)
    1ade:	64e2                	ld	s1,24(sp)
    1ae0:	6145                	addi	sp,sp,48
    1ae2:	8082                	ret
      printf("%s: fork failed", s);
    1ae4:	85a6                	mv	a1,s1
    1ae6:	00005517          	auipc	a0,0x5
    1aea:	d6a50513          	addi	a0,a0,-662 # 6850 <malloc+0xb52>
    1aee:	00004097          	auipc	ra,0x4
    1af2:	158080e7          	jalr	344(ra) # 5c46 <printf>
      exit(1);
    1af6:	4505                	li	a0,1
    1af8:	00004097          	auipc	ra,0x4
    1afc:	dde080e7          	jalr	-546(ra) # 58d6 <exit>
{
    1b00:	0c800493          	li	s1,200
        int pid1 = fork();
    1b04:	00004097          	auipc	ra,0x4
    1b08:	dca080e7          	jalr	-566(ra) # 58ce <fork>
        if(pid1 < 0){
    1b0c:	00054f63          	bltz	a0,1b2a <forkfork+0x9c>
        if(pid1 == 0){
    1b10:	c115                	beqz	a0,1b34 <forkfork+0xa6>
        wait(0);
    1b12:	4501                	li	a0,0
    1b14:	00004097          	auipc	ra,0x4
    1b18:	dca080e7          	jalr	-566(ra) # 58de <wait>
      for(int j = 0; j < 200; j++){
    1b1c:	34fd                	addiw	s1,s1,-1
    1b1e:	f0fd                	bnez	s1,1b04 <forkfork+0x76>
      exit(0);
    1b20:	4501                	li	a0,0
    1b22:	00004097          	auipc	ra,0x4
    1b26:	db4080e7          	jalr	-588(ra) # 58d6 <exit>
          exit(1);
    1b2a:	4505                	li	a0,1
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	daa080e7          	jalr	-598(ra) # 58d6 <exit>
          exit(0);
    1b34:	00004097          	auipc	ra,0x4
    1b38:	da2080e7          	jalr	-606(ra) # 58d6 <exit>
      printf("%s: fork in child failed", s);
    1b3c:	85a6                	mv	a1,s1
    1b3e:	00005517          	auipc	a0,0x5
    1b42:	d2250513          	addi	a0,a0,-734 # 6860 <malloc+0xb62>
    1b46:	00004097          	auipc	ra,0x4
    1b4a:	100080e7          	jalr	256(ra) # 5c46 <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	00004097          	auipc	ra,0x4
    1b54:	d86080e7          	jalr	-634(ra) # 58d6 <exit>

0000000000001b58 <reparent2>:
{
    1b58:	1101                	addi	sp,sp,-32
    1b5a:	ec06                	sd	ra,24(sp)
    1b5c:	e822                	sd	s0,16(sp)
    1b5e:	e426                	sd	s1,8(sp)
    1b60:	1000                	addi	s0,sp,32
    1b62:	32000493          	li	s1,800
    int pid1 = fork();
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	d68080e7          	jalr	-664(ra) # 58ce <fork>
    if(pid1 < 0){
    1b6e:	00054f63          	bltz	a0,1b8c <reparent2+0x34>
    if(pid1 == 0){
    1b72:	c915                	beqz	a0,1ba6 <reparent2+0x4e>
    wait(0);
    1b74:	4501                	li	a0,0
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	d68080e7          	jalr	-664(ra) # 58de <wait>
  for(int i = 0; i < 800; i++){
    1b7e:	34fd                	addiw	s1,s1,-1
    1b80:	f0fd                	bnez	s1,1b66 <reparent2+0xe>
  exit(0);
    1b82:	4501                	li	a0,0
    1b84:	00004097          	auipc	ra,0x4
    1b88:	d52080e7          	jalr	-686(ra) # 58d6 <exit>
      printf("fork failed\n");
    1b8c:	00005517          	auipc	a0,0x5
    1b90:	f2450513          	addi	a0,a0,-220 # 6ab0 <malloc+0xdb2>
    1b94:	00004097          	auipc	ra,0x4
    1b98:	0b2080e7          	jalr	178(ra) # 5c46 <printf>
      exit(1);
    1b9c:	4505                	li	a0,1
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	d38080e7          	jalr	-712(ra) # 58d6 <exit>
      fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	d28080e7          	jalr	-728(ra) # 58ce <fork>
      fork();
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	d20080e7          	jalr	-736(ra) # 58ce <fork>
      exit(0);
    1bb6:	4501                	li	a0,0
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	d1e080e7          	jalr	-738(ra) # 58d6 <exit>

0000000000001bc0 <createdelete>:
{
    1bc0:	7175                	addi	sp,sp,-144
    1bc2:	e506                	sd	ra,136(sp)
    1bc4:	e122                	sd	s0,128(sp)
    1bc6:	fca6                	sd	s1,120(sp)
    1bc8:	f8ca                	sd	s2,112(sp)
    1bca:	f4ce                	sd	s3,104(sp)
    1bcc:	f0d2                	sd	s4,96(sp)
    1bce:	ecd6                	sd	s5,88(sp)
    1bd0:	e8da                	sd	s6,80(sp)
    1bd2:	e4de                	sd	s7,72(sp)
    1bd4:	e0e2                	sd	s8,64(sp)
    1bd6:	fc66                	sd	s9,56(sp)
    1bd8:	0900                	addi	s0,sp,144
    1bda:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bdc:	4901                	li	s2,0
    1bde:	4991                	li	s3,4
    pid = fork();
    1be0:	00004097          	auipc	ra,0x4
    1be4:	cee080e7          	jalr	-786(ra) # 58ce <fork>
    1be8:	84aa                	mv	s1,a0
    if(pid < 0){
    1bea:	02054f63          	bltz	a0,1c28 <createdelete+0x68>
    if(pid == 0){
    1bee:	c939                	beqz	a0,1c44 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bf0:	2905                	addiw	s2,s2,1
    1bf2:	ff3917e3          	bne	s2,s3,1be0 <createdelete+0x20>
    1bf6:	4491                	li	s1,4
    wait(&xstatus);
    1bf8:	f7c40513          	addi	a0,s0,-132
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	ce2080e7          	jalr	-798(ra) # 58de <wait>
    if(xstatus != 0)
    1c04:	f7c42903          	lw	s2,-132(s0)
    1c08:	0e091263          	bnez	s2,1cec <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1c0c:	34fd                	addiw	s1,s1,-1
    1c0e:	f4ed                	bnez	s1,1bf8 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1c10:	f8040123          	sb	zero,-126(s0)
    1c14:	03000993          	li	s3,48
    1c18:	5a7d                	li	s4,-1
    1c1a:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1c1e:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c20:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1c22:	07400a93          	li	s5,116
    1c26:	a28d                	j	1d88 <createdelete+0x1c8>
      printf("fork failed\n", s);
    1c28:	85e6                	mv	a1,s9
    1c2a:	00005517          	auipc	a0,0x5
    1c2e:	e8650513          	addi	a0,a0,-378 # 6ab0 <malloc+0xdb2>
    1c32:	00004097          	auipc	ra,0x4
    1c36:	014080e7          	jalr	20(ra) # 5c46 <printf>
      exit(1);
    1c3a:	4505                	li	a0,1
    1c3c:	00004097          	auipc	ra,0x4
    1c40:	c9a080e7          	jalr	-870(ra) # 58d6 <exit>
      name[0] = 'p' + pi;
    1c44:	0709091b          	addiw	s2,s2,112
    1c48:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c4c:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c50:	4951                	li	s2,20
    1c52:	a015                	j	1c76 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c54:	85e6                	mv	a1,s9
    1c56:	00005517          	auipc	a0,0x5
    1c5a:	ad250513          	addi	a0,a0,-1326 # 6728 <malloc+0xa2a>
    1c5e:	00004097          	auipc	ra,0x4
    1c62:	fe8080e7          	jalr	-24(ra) # 5c46 <printf>
          exit(1);
    1c66:	4505                	li	a0,1
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	c6e080e7          	jalr	-914(ra) # 58d6 <exit>
      for(i = 0; i < N; i++){
    1c70:	2485                	addiw	s1,s1,1
    1c72:	07248863          	beq	s1,s2,1ce2 <createdelete+0x122>
        name[1] = '0' + i;
    1c76:	0304879b          	addiw	a5,s1,48
    1c7a:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c7e:	20200593          	li	a1,514
    1c82:	f8040513          	addi	a0,s0,-128
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	c90080e7          	jalr	-880(ra) # 5916 <open>
        if(fd < 0){
    1c8e:	fc0543e3          	bltz	a0,1c54 <createdelete+0x94>
        close(fd);
    1c92:	00004097          	auipc	ra,0x4
    1c96:	c6c080e7          	jalr	-916(ra) # 58fe <close>
        if(i > 0 && (i % 2 ) == 0){
    1c9a:	12905763          	blez	s1,1dc8 <createdelete+0x208>
    1c9e:	0014f793          	andi	a5,s1,1
    1ca2:	f7f9                	bnez	a5,1c70 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1ca4:	01f4d79b          	srliw	a5,s1,0x1f
    1ca8:	9fa5                	addw	a5,a5,s1
    1caa:	4017d79b          	sraiw	a5,a5,0x1
    1cae:	0307879b          	addiw	a5,a5,48
    1cb2:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1cb6:	f8040513          	addi	a0,s0,-128
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	c6c080e7          	jalr	-916(ra) # 5926 <unlink>
    1cc2:	fa0557e3          	bgez	a0,1c70 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cc6:	85e6                	mv	a1,s9
    1cc8:	00005517          	auipc	a0,0x5
    1ccc:	bb850513          	addi	a0,a0,-1096 # 6880 <malloc+0xb82>
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	f76080e7          	jalr	-138(ra) # 5c46 <printf>
            exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	bfc080e7          	jalr	-1028(ra) # 58d6 <exit>
      exit(0);
    1ce2:	4501                	li	a0,0
    1ce4:	00004097          	auipc	ra,0x4
    1ce8:	bf2080e7          	jalr	-1038(ra) # 58d6 <exit>
      exit(1);
    1cec:	4505                	li	a0,1
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	be8080e7          	jalr	-1048(ra) # 58d6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cf6:	f8040613          	addi	a2,s0,-128
    1cfa:	85e6                	mv	a1,s9
    1cfc:	00005517          	auipc	a0,0x5
    1d00:	b9c50513          	addi	a0,a0,-1124 # 6898 <malloc+0xb9a>
    1d04:	00004097          	auipc	ra,0x4
    1d08:	f42080e7          	jalr	-190(ra) # 5c46 <printf>
        exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	bc8080e7          	jalr	-1080(ra) # 58d6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d16:	034bff63          	bgeu	s7,s4,1d54 <createdelete+0x194>
      if(fd >= 0)
    1d1a:	02055863          	bgez	a0,1d4a <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1d1e:	2485                	addiw	s1,s1,1
    1d20:	0ff4f493          	zext.b	s1,s1
    1d24:	05548a63          	beq	s1,s5,1d78 <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1d28:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d2c:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d30:	4581                	li	a1,0
    1d32:	f8040513          	addi	a0,s0,-128
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	be0080e7          	jalr	-1056(ra) # 5916 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d3e:	00090463          	beqz	s2,1d46 <createdelete+0x186>
    1d42:	fd2b5ae3          	bge	s6,s2,1d16 <createdelete+0x156>
    1d46:	fa0548e3          	bltz	a0,1cf6 <createdelete+0x136>
        close(fd);
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	bb4080e7          	jalr	-1100(ra) # 58fe <close>
    1d52:	b7f1                	j	1d1e <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d54:	fc0545e3          	bltz	a0,1d1e <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d58:	f8040613          	addi	a2,s0,-128
    1d5c:	85e6                	mv	a1,s9
    1d5e:	00005517          	auipc	a0,0x5
    1d62:	b6250513          	addi	a0,a0,-1182 # 68c0 <malloc+0xbc2>
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	ee0080e7          	jalr	-288(ra) # 5c46 <printf>
        exit(1);
    1d6e:	4505                	li	a0,1
    1d70:	00004097          	auipc	ra,0x4
    1d74:	b66080e7          	jalr	-1178(ra) # 58d6 <exit>
  for(i = 0; i < N; i++){
    1d78:	2905                	addiw	s2,s2,1
    1d7a:	2a05                	addiw	s4,s4,1
    1d7c:	2985                	addiw	s3,s3,1
    1d7e:	0ff9f993          	zext.b	s3,s3
    1d82:	47d1                	li	a5,20
    1d84:	02f90a63          	beq	s2,a5,1db8 <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1d88:	84e2                	mv	s1,s8
    1d8a:	bf79                	j	1d28 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d8c:	2905                	addiw	s2,s2,1
    1d8e:	0ff97913          	zext.b	s2,s2
    1d92:	2985                	addiw	s3,s3,1
    1d94:	0ff9f993          	zext.b	s3,s3
    1d98:	03490a63          	beq	s2,s4,1dcc <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d9c:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d9e:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1da2:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1da6:	f8040513          	addi	a0,s0,-128
    1daa:	00004097          	auipc	ra,0x4
    1dae:	b7c080e7          	jalr	-1156(ra) # 5926 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1db2:	34fd                	addiw	s1,s1,-1
    1db4:	f4ed                	bnez	s1,1d9e <createdelete+0x1de>
    1db6:	bfd9                	j	1d8c <createdelete+0x1cc>
    1db8:	03000993          	li	s3,48
    1dbc:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1dc0:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1dc2:	08400a13          	li	s4,132
    1dc6:	bfd9                	j	1d9c <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1dc8:	2485                	addiw	s1,s1,1
    1dca:	b575                	j	1c76 <createdelete+0xb6>
}
    1dcc:	60aa                	ld	ra,136(sp)
    1dce:	640a                	ld	s0,128(sp)
    1dd0:	74e6                	ld	s1,120(sp)
    1dd2:	7946                	ld	s2,112(sp)
    1dd4:	79a6                	ld	s3,104(sp)
    1dd6:	7a06                	ld	s4,96(sp)
    1dd8:	6ae6                	ld	s5,88(sp)
    1dda:	6b46                	ld	s6,80(sp)
    1ddc:	6ba6                	ld	s7,72(sp)
    1dde:	6c06                	ld	s8,64(sp)
    1de0:	7ce2                	ld	s9,56(sp)
    1de2:	6149                	addi	sp,sp,144
    1de4:	8082                	ret

0000000000001de6 <linkunlink>:
{
    1de6:	711d                	addi	sp,sp,-96
    1de8:	ec86                	sd	ra,88(sp)
    1dea:	e8a2                	sd	s0,80(sp)
    1dec:	e4a6                	sd	s1,72(sp)
    1dee:	e0ca                	sd	s2,64(sp)
    1df0:	fc4e                	sd	s3,56(sp)
    1df2:	f852                	sd	s4,48(sp)
    1df4:	f456                	sd	s5,40(sp)
    1df6:	f05a                	sd	s6,32(sp)
    1df8:	ec5e                	sd	s7,24(sp)
    1dfa:	e862                	sd	s8,16(sp)
    1dfc:	e466                	sd	s9,8(sp)
    1dfe:	1080                	addi	s0,sp,96
    1e00:	84aa                	mv	s1,a0
  unlink("x");
    1e02:	00004517          	auipc	a0,0x4
    1e06:	0a650513          	addi	a0,a0,166 # 5ea8 <malloc+0x1aa>
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	b1c080e7          	jalr	-1252(ra) # 5926 <unlink>
  pid = fork();
    1e12:	00004097          	auipc	ra,0x4
    1e16:	abc080e7          	jalr	-1348(ra) # 58ce <fork>
  if(pid < 0){
    1e1a:	02054b63          	bltz	a0,1e50 <linkunlink+0x6a>
    1e1e:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1e20:	06100913          	li	s2,97
    1e24:	c111                	beqz	a0,1e28 <linkunlink+0x42>
    1e26:	4905                	li	s2,1
    1e28:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e2c:	41c65a37          	lui	s4,0x41c65
    1e30:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <__BSS_END__+0x41c54d85>
    1e34:	698d                	lui	s3,0x3
    1e36:	0399899b          	addiw	s3,s3,57 # 3039 <iputtest+0x65>
    if((x % 3) == 0){
    1e3a:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1e3c:	4b85                	li	s7,1
      unlink("x");
    1e3e:	00004b17          	auipc	s6,0x4
    1e42:	06ab0b13          	addi	s6,s6,106 # 5ea8 <malloc+0x1aa>
      link("cat", "x");
    1e46:	00005c17          	auipc	s8,0x5
    1e4a:	aa2c0c13          	addi	s8,s8,-1374 # 68e8 <malloc+0xbea>
    1e4e:	a825                	j	1e86 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e50:	85a6                	mv	a1,s1
    1e52:	00005517          	auipc	a0,0x5
    1e56:	83e50513          	addi	a0,a0,-1986 # 6690 <malloc+0x992>
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	dec080e7          	jalr	-532(ra) # 5c46 <printf>
    exit(1);
    1e62:	4505                	li	a0,1
    1e64:	00004097          	auipc	ra,0x4
    1e68:	a72080e7          	jalr	-1422(ra) # 58d6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e6c:	20200593          	li	a1,514
    1e70:	855a                	mv	a0,s6
    1e72:	00004097          	auipc	ra,0x4
    1e76:	aa4080e7          	jalr	-1372(ra) # 5916 <open>
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	a84080e7          	jalr	-1404(ra) # 58fe <close>
  for(i = 0; i < 100; i++){
    1e82:	34fd                	addiw	s1,s1,-1
    1e84:	c895                	beqz	s1,1eb8 <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    1e86:	034907bb          	mulw	a5,s2,s4
    1e8a:	013787bb          	addw	a5,a5,s3
    1e8e:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1e92:	0357f7bb          	remuw	a5,a5,s5
    1e96:	2781                	sext.w	a5,a5
    1e98:	dbf1                	beqz	a5,1e6c <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e9a:	01778863          	beq	a5,s7,1eaa <linkunlink+0xc4>
      unlink("x");
    1e9e:	855a                	mv	a0,s6
    1ea0:	00004097          	auipc	ra,0x4
    1ea4:	a86080e7          	jalr	-1402(ra) # 5926 <unlink>
    1ea8:	bfe9                	j	1e82 <linkunlink+0x9c>
      link("cat", "x");
    1eaa:	85da                	mv	a1,s6
    1eac:	8562                	mv	a0,s8
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	a88080e7          	jalr	-1400(ra) # 5936 <link>
    1eb6:	b7f1                	j	1e82 <linkunlink+0x9c>
  if(pid)
    1eb8:	020c8463          	beqz	s9,1ee0 <linkunlink+0xfa>
    wait(0);
    1ebc:	4501                	li	a0,0
    1ebe:	00004097          	auipc	ra,0x4
    1ec2:	a20080e7          	jalr	-1504(ra) # 58de <wait>
}
    1ec6:	60e6                	ld	ra,88(sp)
    1ec8:	6446                	ld	s0,80(sp)
    1eca:	64a6                	ld	s1,72(sp)
    1ecc:	6906                	ld	s2,64(sp)
    1ece:	79e2                	ld	s3,56(sp)
    1ed0:	7a42                	ld	s4,48(sp)
    1ed2:	7aa2                	ld	s5,40(sp)
    1ed4:	7b02                	ld	s6,32(sp)
    1ed6:	6be2                	ld	s7,24(sp)
    1ed8:	6c42                	ld	s8,16(sp)
    1eda:	6ca2                	ld	s9,8(sp)
    1edc:	6125                	addi	sp,sp,96
    1ede:	8082                	ret
    exit(0);
    1ee0:	4501                	li	a0,0
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	9f4080e7          	jalr	-1548(ra) # 58d6 <exit>

0000000000001eea <manywrites>:
{
    1eea:	711d                	addi	sp,sp,-96
    1eec:	ec86                	sd	ra,88(sp)
    1eee:	e8a2                	sd	s0,80(sp)
    1ef0:	e4a6                	sd	s1,72(sp)
    1ef2:	e0ca                	sd	s2,64(sp)
    1ef4:	fc4e                	sd	s3,56(sp)
    1ef6:	f456                	sd	s5,40(sp)
    1ef8:	1080                	addi	s0,sp,96
    1efa:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	4981                	li	s3,0
    1efe:	4911                	li	s2,4
    int pid = fork();
    1f00:	00004097          	auipc	ra,0x4
    1f04:	9ce080e7          	jalr	-1586(ra) # 58ce <fork>
    1f08:	84aa                	mv	s1,a0
    if(pid < 0){
    1f0a:	02054d63          	bltz	a0,1f44 <manywrites+0x5a>
    if(pid == 0){
    1f0e:	c939                	beqz	a0,1f64 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    1f10:	2985                	addiw	s3,s3,1
    1f12:	ff2997e3          	bne	s3,s2,1f00 <manywrites+0x16>
    1f16:	f852                	sd	s4,48(sp)
    1f18:	f05a                	sd	s6,32(sp)
    1f1a:	ec5e                	sd	s7,24(sp)
    1f1c:	4491                	li	s1,4
    int st = 0;
    1f1e:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f22:	fa840513          	addi	a0,s0,-88
    1f26:	00004097          	auipc	ra,0x4
    1f2a:	9b8080e7          	jalr	-1608(ra) # 58de <wait>
    if(st != 0)
    1f2e:	fa842503          	lw	a0,-88(s0)
    1f32:	10051463          	bnez	a0,203a <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    1f36:	34fd                	addiw	s1,s1,-1
    1f38:	f0fd                	bnez	s1,1f1e <manywrites+0x34>
  exit(0);
    1f3a:	4501                	li	a0,0
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	99a080e7          	jalr	-1638(ra) # 58d6 <exit>
    1f44:	f852                	sd	s4,48(sp)
    1f46:	f05a                	sd	s6,32(sp)
    1f48:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1f4a:	00005517          	auipc	a0,0x5
    1f4e:	b6650513          	addi	a0,a0,-1178 # 6ab0 <malloc+0xdb2>
    1f52:	00004097          	auipc	ra,0x4
    1f56:	cf4080e7          	jalr	-780(ra) # 5c46 <printf>
      exit(1);
    1f5a:	4505                	li	a0,1
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	97a080e7          	jalr	-1670(ra) # 58d6 <exit>
    1f64:	f852                	sd	s4,48(sp)
    1f66:	f05a                	sd	s6,32(sp)
    1f68:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1f6a:	06200793          	li	a5,98
    1f6e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f72:	0619879b          	addiw	a5,s3,97
    1f76:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f7a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f7e:	fa840513          	addi	a0,s0,-88
    1f82:	00004097          	auipc	ra,0x4
    1f86:	9a4080e7          	jalr	-1628(ra) # 5926 <unlink>
    1f8a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f8c:	0000bb17          	auipc	s6,0xb
    1f90:	14cb0b13          	addi	s6,s6,332 # d0d8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f94:	8a26                	mv	s4,s1
    1f96:	0209ce63          	bltz	s3,1fd2 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    1f9a:	20200593          	li	a1,514
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00004097          	auipc	ra,0x4
    1fa6:	974080e7          	jalr	-1676(ra) # 5916 <open>
    1faa:	892a                	mv	s2,a0
          if(fd < 0){
    1fac:	04054763          	bltz	a0,1ffa <manywrites+0x110>
          int cc = write(fd, buf, sz);
    1fb0:	660d                	lui	a2,0x3
    1fb2:	85da                	mv	a1,s6
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	942080e7          	jalr	-1726(ra) # 58f6 <write>
          if(cc != sz){
    1fbc:	678d                	lui	a5,0x3
    1fbe:	04f51e63          	bne	a0,a5,201a <manywrites+0x130>
          close(fd);
    1fc2:	854a                	mv	a0,s2
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	93a080e7          	jalr	-1734(ra) # 58fe <close>
        for(int i = 0; i < ci+1; i++){
    1fcc:	2a05                	addiw	s4,s4,1
    1fce:	fd49d6e3          	bge	s3,s4,1f9a <manywrites+0xb0>
        unlink(name);
    1fd2:	fa840513          	addi	a0,s0,-88
    1fd6:	00004097          	auipc	ra,0x4
    1fda:	950080e7          	jalr	-1712(ra) # 5926 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fde:	3bfd                	addiw	s7,s7,-1
    1fe0:	fa0b9ae3          	bnez	s7,1f94 <manywrites+0xaa>
      unlink(name);
    1fe4:	fa840513          	addi	a0,s0,-88
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	93e080e7          	jalr	-1730(ra) # 5926 <unlink>
      exit(0);
    1ff0:	4501                	li	a0,0
    1ff2:	00004097          	auipc	ra,0x4
    1ff6:	8e4080e7          	jalr	-1820(ra) # 58d6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1ffa:	fa840613          	addi	a2,s0,-88
    1ffe:	85d6                	mv	a1,s5
    2000:	00005517          	auipc	a0,0x5
    2004:	8f050513          	addi	a0,a0,-1808 # 68f0 <malloc+0xbf2>
    2008:	00004097          	auipc	ra,0x4
    200c:	c3e080e7          	jalr	-962(ra) # 5c46 <printf>
            exit(1);
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	8c4080e7          	jalr	-1852(ra) # 58d6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    201a:	86aa                	mv	a3,a0
    201c:	660d                	lui	a2,0x3
    201e:	85d6                	mv	a1,s5
    2020:	00004517          	auipc	a0,0x4
    2024:	ee850513          	addi	a0,a0,-280 # 5f08 <malloc+0x20a>
    2028:	00004097          	auipc	ra,0x4
    202c:	c1e080e7          	jalr	-994(ra) # 5c46 <printf>
            exit(1);
    2030:	4505                	li	a0,1
    2032:	00004097          	auipc	ra,0x4
    2036:	8a4080e7          	jalr	-1884(ra) # 58d6 <exit>
      exit(st);
    203a:	00004097          	auipc	ra,0x4
    203e:	89c080e7          	jalr	-1892(ra) # 58d6 <exit>

0000000000002042 <forktest>:
{
    2042:	7179                	addi	sp,sp,-48
    2044:	f406                	sd	ra,40(sp)
    2046:	f022                	sd	s0,32(sp)
    2048:	ec26                	sd	s1,24(sp)
    204a:	e84a                	sd	s2,16(sp)
    204c:	e44e                	sd	s3,8(sp)
    204e:	1800                	addi	s0,sp,48
    2050:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2052:	4481                	li	s1,0
    2054:	3e800913          	li	s2,1000
    pid = fork();
    2058:	00004097          	auipc	ra,0x4
    205c:	876080e7          	jalr	-1930(ra) # 58ce <fork>
    if(pid < 0)
    2060:	08054263          	bltz	a0,20e4 <forktest+0xa2>
    if(pid == 0)
    2064:	c115                	beqz	a0,2088 <forktest+0x46>
  for(n=0; n<N; n++){
    2066:	2485                	addiw	s1,s1,1
    2068:	ff2498e3          	bne	s1,s2,2058 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    206c:	85ce                	mv	a1,s3
    206e:	00005517          	auipc	a0,0x5
    2072:	8e250513          	addi	a0,a0,-1822 # 6950 <malloc+0xc52>
    2076:	00004097          	auipc	ra,0x4
    207a:	bd0080e7          	jalr	-1072(ra) # 5c46 <printf>
    exit(1);
    207e:	4505                	li	a0,1
    2080:	00004097          	auipc	ra,0x4
    2084:	856080e7          	jalr	-1962(ra) # 58d6 <exit>
      exit(0);
    2088:	00004097          	auipc	ra,0x4
    208c:	84e080e7          	jalr	-1970(ra) # 58d6 <exit>
    printf("%s: no fork at all!\n", s);
    2090:	85ce                	mv	a1,s3
    2092:	00005517          	auipc	a0,0x5
    2096:	87650513          	addi	a0,a0,-1930 # 6908 <malloc+0xc0a>
    209a:	00004097          	auipc	ra,0x4
    209e:	bac080e7          	jalr	-1108(ra) # 5c46 <printf>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	00004097          	auipc	ra,0x4
    20a8:	832080e7          	jalr	-1998(ra) # 58d6 <exit>
      printf("%s: wait stopped early\n", s);
    20ac:	85ce                	mv	a1,s3
    20ae:	00005517          	auipc	a0,0x5
    20b2:	87250513          	addi	a0,a0,-1934 # 6920 <malloc+0xc22>
    20b6:	00004097          	auipc	ra,0x4
    20ba:	b90080e7          	jalr	-1136(ra) # 5c46 <printf>
      exit(1);
    20be:	4505                	li	a0,1
    20c0:	00004097          	auipc	ra,0x4
    20c4:	816080e7          	jalr	-2026(ra) # 58d6 <exit>
    printf("%s: wait got too many\n", s);
    20c8:	85ce                	mv	a1,s3
    20ca:	00005517          	auipc	a0,0x5
    20ce:	86e50513          	addi	a0,a0,-1938 # 6938 <malloc+0xc3a>
    20d2:	00004097          	auipc	ra,0x4
    20d6:	b74080e7          	jalr	-1164(ra) # 5c46 <printf>
    exit(1);
    20da:	4505                	li	a0,1
    20dc:	00003097          	auipc	ra,0x3
    20e0:	7fa080e7          	jalr	2042(ra) # 58d6 <exit>
  if (n == 0) {
    20e4:	d4d5                	beqz	s1,2090 <forktest+0x4e>
  for(; n > 0; n--){
    20e6:	00905b63          	blez	s1,20fc <forktest+0xba>
    if(wait(0) < 0){
    20ea:	4501                	li	a0,0
    20ec:	00003097          	auipc	ra,0x3
    20f0:	7f2080e7          	jalr	2034(ra) # 58de <wait>
    20f4:	fa054ce3          	bltz	a0,20ac <forktest+0x6a>
  for(; n > 0; n--){
    20f8:	34fd                	addiw	s1,s1,-1
    20fa:	f8e5                	bnez	s1,20ea <forktest+0xa8>
  if(wait(0) != -1){
    20fc:	4501                	li	a0,0
    20fe:	00003097          	auipc	ra,0x3
    2102:	7e0080e7          	jalr	2016(ra) # 58de <wait>
    2106:	57fd                	li	a5,-1
    2108:	fcf510e3          	bne	a0,a5,20c8 <forktest+0x86>
}
    210c:	70a2                	ld	ra,40(sp)
    210e:	7402                	ld	s0,32(sp)
    2110:	64e2                	ld	s1,24(sp)
    2112:	6942                	ld	s2,16(sp)
    2114:	69a2                	ld	s3,8(sp)
    2116:	6145                	addi	sp,sp,48
    2118:	8082                	ret

000000000000211a <kernmem>:
{
    211a:	715d                	addi	sp,sp,-80
    211c:	e486                	sd	ra,72(sp)
    211e:	e0a2                	sd	s0,64(sp)
    2120:	fc26                	sd	s1,56(sp)
    2122:	f84a                	sd	s2,48(sp)
    2124:	f44e                	sd	s3,40(sp)
    2126:	f052                	sd	s4,32(sp)
    2128:	ec56                	sd	s5,24(sp)
    212a:	0880                	addi	s0,sp,80
    212c:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    212e:	4485                	li	s1,1
    2130:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2132:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2134:	69b1                	lui	s3,0xc
    2136:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1988>
    213a:	1003d937          	lui	s2,0x1003d
    213e:	090e                	slli	s2,s2,0x3
    2140:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002d398>
    pid = fork();
    2144:	00003097          	auipc	ra,0x3
    2148:	78a080e7          	jalr	1930(ra) # 58ce <fork>
    if(pid < 0){
    214c:	02054963          	bltz	a0,217e <kernmem+0x64>
    if(pid == 0){
    2150:	c529                	beqz	a0,219a <kernmem+0x80>
    wait(&xstatus);
    2152:	fbc40513          	addi	a0,s0,-68
    2156:	00003097          	auipc	ra,0x3
    215a:	788080e7          	jalr	1928(ra) # 58de <wait>
    if(xstatus != -1)  // did kernel kill child?
    215e:	fbc42783          	lw	a5,-68(s0)
    2162:	05479d63          	bne	a5,s4,21bc <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2166:	94ce                	add	s1,s1,s3
    2168:	fd249ee3          	bne	s1,s2,2144 <kernmem+0x2a>
}
    216c:	60a6                	ld	ra,72(sp)
    216e:	6406                	ld	s0,64(sp)
    2170:	74e2                	ld	s1,56(sp)
    2172:	7942                	ld	s2,48(sp)
    2174:	79a2                	ld	s3,40(sp)
    2176:	7a02                	ld	s4,32(sp)
    2178:	6ae2                	ld	s5,24(sp)
    217a:	6161                	addi	sp,sp,80
    217c:	8082                	ret
      printf("%s: fork failed\n", s);
    217e:	85d6                	mv	a1,s5
    2180:	00004517          	auipc	a0,0x4
    2184:	51050513          	addi	a0,a0,1296 # 6690 <malloc+0x992>
    2188:	00004097          	auipc	ra,0x4
    218c:	abe080e7          	jalr	-1346(ra) # 5c46 <printf>
      exit(1);
    2190:	4505                	li	a0,1
    2192:	00003097          	auipc	ra,0x3
    2196:	744080e7          	jalr	1860(ra) # 58d6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    219a:	0004c683          	lbu	a3,0(s1)
    219e:	8626                	mv	a2,s1
    21a0:	85d6                	mv	a1,s5
    21a2:	00004517          	auipc	a0,0x4
    21a6:	7d650513          	addi	a0,a0,2006 # 6978 <malloc+0xc7a>
    21aa:	00004097          	auipc	ra,0x4
    21ae:	a9c080e7          	jalr	-1380(ra) # 5c46 <printf>
      exit(1);
    21b2:	4505                	li	a0,1
    21b4:	00003097          	auipc	ra,0x3
    21b8:	722080e7          	jalr	1826(ra) # 58d6 <exit>
      exit(1);
    21bc:	4505                	li	a0,1
    21be:	00003097          	auipc	ra,0x3
    21c2:	718080e7          	jalr	1816(ra) # 58d6 <exit>

00000000000021c6 <MAXVAplus>:
{
    21c6:	7179                	addi	sp,sp,-48
    21c8:	f406                	sd	ra,40(sp)
    21ca:	f022                	sd	s0,32(sp)
    21cc:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    21ce:	4785                	li	a5,1
    21d0:	179a                	slli	a5,a5,0x26
    21d2:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    21d6:	fd843783          	ld	a5,-40(s0)
    21da:	c3a1                	beqz	a5,221a <MAXVAplus+0x54>
    21dc:	ec26                	sd	s1,24(sp)
    21de:	e84a                	sd	s2,16(sp)
    21e0:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21e2:	54fd                	li	s1,-1
    pid = fork();
    21e4:	00003097          	auipc	ra,0x3
    21e8:	6ea080e7          	jalr	1770(ra) # 58ce <fork>
    if(pid < 0){
    21ec:	02054b63          	bltz	a0,2222 <MAXVAplus+0x5c>
    if(pid == 0){
    21f0:	c539                	beqz	a0,223e <MAXVAplus+0x78>
    wait(&xstatus);
    21f2:	fd440513          	addi	a0,s0,-44
    21f6:	00003097          	auipc	ra,0x3
    21fa:	6e8080e7          	jalr	1768(ra) # 58de <wait>
    if(xstatus != -1)  // did kernel kill child?
    21fe:	fd442783          	lw	a5,-44(s0)
    2202:	06979463          	bne	a5,s1,226a <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2206:	fd843783          	ld	a5,-40(s0)
    220a:	0786                	slli	a5,a5,0x1
    220c:	fcf43c23          	sd	a5,-40(s0)
    2210:	fd843783          	ld	a5,-40(s0)
    2214:	fbe1                	bnez	a5,21e4 <MAXVAplus+0x1e>
    2216:	64e2                	ld	s1,24(sp)
    2218:	6942                	ld	s2,16(sp)
}
    221a:	70a2                	ld	ra,40(sp)
    221c:	7402                	ld	s0,32(sp)
    221e:	6145                	addi	sp,sp,48
    2220:	8082                	ret
      printf("%s: fork failed\n", s);
    2222:	85ca                	mv	a1,s2
    2224:	00004517          	auipc	a0,0x4
    2228:	46c50513          	addi	a0,a0,1132 # 6690 <malloc+0x992>
    222c:	00004097          	auipc	ra,0x4
    2230:	a1a080e7          	jalr	-1510(ra) # 5c46 <printf>
      exit(1);
    2234:	4505                	li	a0,1
    2236:	00003097          	auipc	ra,0x3
    223a:	6a0080e7          	jalr	1696(ra) # 58d6 <exit>
      *(char*)a = 99;
    223e:	fd843783          	ld	a5,-40(s0)
    2242:	06300713          	li	a4,99
    2246:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x2c>
      printf("%s: oops wrote %x\n", s, a);
    224a:	fd843603          	ld	a2,-40(s0)
    224e:	85ca                	mv	a1,s2
    2250:	00004517          	auipc	a0,0x4
    2254:	74850513          	addi	a0,a0,1864 # 6998 <malloc+0xc9a>
    2258:	00004097          	auipc	ra,0x4
    225c:	9ee080e7          	jalr	-1554(ra) # 5c46 <printf>
      exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	674080e7          	jalr	1652(ra) # 58d6 <exit>
      exit(1);
    226a:	4505                	li	a0,1
    226c:	00003097          	auipc	ra,0x3
    2270:	66a080e7          	jalr	1642(ra) # 58d6 <exit>

0000000000002274 <bigargtest>:
{
    2274:	7179                	addi	sp,sp,-48
    2276:	f406                	sd	ra,40(sp)
    2278:	f022                	sd	s0,32(sp)
    227a:	ec26                	sd	s1,24(sp)
    227c:	1800                	addi	s0,sp,48
    227e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2280:	00004517          	auipc	a0,0x4
    2284:	73050513          	addi	a0,a0,1840 # 69b0 <malloc+0xcb2>
    2288:	00003097          	auipc	ra,0x3
    228c:	69e080e7          	jalr	1694(ra) # 5926 <unlink>
  pid = fork();
    2290:	00003097          	auipc	ra,0x3
    2294:	63e080e7          	jalr	1598(ra) # 58ce <fork>
  if(pid == 0){
    2298:	c121                	beqz	a0,22d8 <bigargtest+0x64>
  } else if(pid < 0){
    229a:	0a054063          	bltz	a0,233a <bigargtest+0xc6>
  wait(&xstatus);
    229e:	fdc40513          	addi	a0,s0,-36
    22a2:	00003097          	auipc	ra,0x3
    22a6:	63c080e7          	jalr	1596(ra) # 58de <wait>
  if(xstatus != 0)
    22aa:	fdc42503          	lw	a0,-36(s0)
    22ae:	e545                	bnez	a0,2356 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    22b0:	4581                	li	a1,0
    22b2:	00004517          	auipc	a0,0x4
    22b6:	6fe50513          	addi	a0,a0,1790 # 69b0 <malloc+0xcb2>
    22ba:	00003097          	auipc	ra,0x3
    22be:	65c080e7          	jalr	1628(ra) # 5916 <open>
  if(fd < 0){
    22c2:	08054e63          	bltz	a0,235e <bigargtest+0xea>
  close(fd);
    22c6:	00003097          	auipc	ra,0x3
    22ca:	638080e7          	jalr	1592(ra) # 58fe <close>
}
    22ce:	70a2                	ld	ra,40(sp)
    22d0:	7402                	ld	s0,32(sp)
    22d2:	64e2                	ld	s1,24(sp)
    22d4:	6145                	addi	sp,sp,48
    22d6:	8082                	ret
    22d8:	00007797          	auipc	a5,0x7
    22dc:	5e878793          	addi	a5,a5,1512 # 98c0 <args.1>
    22e0:	00007697          	auipc	a3,0x7
    22e4:	6d868693          	addi	a3,a3,1752 # 99b8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22e8:	00004717          	auipc	a4,0x4
    22ec:	6d870713          	addi	a4,a4,1752 # 69c0 <malloc+0xcc2>
    22f0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22f2:	07a1                	addi	a5,a5,8
    22f4:	fed79ee3          	bne	a5,a3,22f0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22f8:	00007597          	auipc	a1,0x7
    22fc:	5c858593          	addi	a1,a1,1480 # 98c0 <args.1>
    2300:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2304:	00004517          	auipc	a0,0x4
    2308:	b3450513          	addi	a0,a0,-1228 # 5e38 <malloc+0x13a>
    230c:	00003097          	auipc	ra,0x3
    2310:	602080e7          	jalr	1538(ra) # 590e <exec>
    fd = open("bigarg-ok", O_CREATE);
    2314:	20000593          	li	a1,512
    2318:	00004517          	auipc	a0,0x4
    231c:	69850513          	addi	a0,a0,1688 # 69b0 <malloc+0xcb2>
    2320:	00003097          	auipc	ra,0x3
    2324:	5f6080e7          	jalr	1526(ra) # 5916 <open>
    close(fd);
    2328:	00003097          	auipc	ra,0x3
    232c:	5d6080e7          	jalr	1494(ra) # 58fe <close>
    exit(0);
    2330:	4501                	li	a0,0
    2332:	00003097          	auipc	ra,0x3
    2336:	5a4080e7          	jalr	1444(ra) # 58d6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    233a:	85a6                	mv	a1,s1
    233c:	00004517          	auipc	a0,0x4
    2340:	76450513          	addi	a0,a0,1892 # 6aa0 <malloc+0xda2>
    2344:	00004097          	auipc	ra,0x4
    2348:	902080e7          	jalr	-1790(ra) # 5c46 <printf>
    exit(1);
    234c:	4505                	li	a0,1
    234e:	00003097          	auipc	ra,0x3
    2352:	588080e7          	jalr	1416(ra) # 58d6 <exit>
    exit(xstatus);
    2356:	00003097          	auipc	ra,0x3
    235a:	580080e7          	jalr	1408(ra) # 58d6 <exit>
    printf("%s: bigarg test failed!\n", s);
    235e:	85a6                	mv	a1,s1
    2360:	00004517          	auipc	a0,0x4
    2364:	76050513          	addi	a0,a0,1888 # 6ac0 <malloc+0xdc2>
    2368:	00004097          	auipc	ra,0x4
    236c:	8de080e7          	jalr	-1826(ra) # 5c46 <printf>
    exit(1);
    2370:	4505                	li	a0,1
    2372:	00003097          	auipc	ra,0x3
    2376:	564080e7          	jalr	1380(ra) # 58d6 <exit>

000000000000237a <stacktest>:
{
    237a:	7179                	addi	sp,sp,-48
    237c:	f406                	sd	ra,40(sp)
    237e:	f022                	sd	s0,32(sp)
    2380:	ec26                	sd	s1,24(sp)
    2382:	1800                	addi	s0,sp,48
    2384:	84aa                	mv	s1,a0
  pid = fork();
    2386:	00003097          	auipc	ra,0x3
    238a:	548080e7          	jalr	1352(ra) # 58ce <fork>
  if(pid == 0) {
    238e:	c115                	beqz	a0,23b2 <stacktest+0x38>
  } else if(pid < 0){
    2390:	04054463          	bltz	a0,23d8 <stacktest+0x5e>
  wait(&xstatus);
    2394:	fdc40513          	addi	a0,s0,-36
    2398:	00003097          	auipc	ra,0x3
    239c:	546080e7          	jalr	1350(ra) # 58de <wait>
  if(xstatus == -1)  // kernel killed child?
    23a0:	fdc42503          	lw	a0,-36(s0)
    23a4:	57fd                	li	a5,-1
    23a6:	04f50763          	beq	a0,a5,23f4 <stacktest+0x7a>
    exit(xstatus);
    23aa:	00003097          	auipc	ra,0x3
    23ae:	52c080e7          	jalr	1324(ra) # 58d6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    23b2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    23b4:	77fd                	lui	a5,0xfffff
    23b6:	97ba                	add	a5,a5,a4
    23b8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xfffffffffffeef18>
    23bc:	85a6                	mv	a1,s1
    23be:	00004517          	auipc	a0,0x4
    23c2:	72250513          	addi	a0,a0,1826 # 6ae0 <malloc+0xde2>
    23c6:	00004097          	auipc	ra,0x4
    23ca:	880080e7          	jalr	-1920(ra) # 5c46 <printf>
    exit(1);
    23ce:	4505                	li	a0,1
    23d0:	00003097          	auipc	ra,0x3
    23d4:	506080e7          	jalr	1286(ra) # 58d6 <exit>
    printf("%s: fork failed\n", s);
    23d8:	85a6                	mv	a1,s1
    23da:	00004517          	auipc	a0,0x4
    23de:	2b650513          	addi	a0,a0,694 # 6690 <malloc+0x992>
    23e2:	00004097          	auipc	ra,0x4
    23e6:	864080e7          	jalr	-1948(ra) # 5c46 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	00003097          	auipc	ra,0x3
    23f0:	4ea080e7          	jalr	1258(ra) # 58d6 <exit>
    exit(0);
    23f4:	4501                	li	a0,0
    23f6:	00003097          	auipc	ra,0x3
    23fa:	4e0080e7          	jalr	1248(ra) # 58d6 <exit>

00000000000023fe <copyinstr3>:
{
    23fe:	7179                	addi	sp,sp,-48
    2400:	f406                	sd	ra,40(sp)
    2402:	f022                	sd	s0,32(sp)
    2404:	ec26                	sd	s1,24(sp)
    2406:	1800                	addi	s0,sp,48
  sbrk(8192);
    2408:	6509                	lui	a0,0x2
    240a:	00003097          	auipc	ra,0x3
    240e:	554080e7          	jalr	1364(ra) # 595e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2412:	4501                	li	a0,0
    2414:	00003097          	auipc	ra,0x3
    2418:	54a080e7          	jalr	1354(ra) # 595e <sbrk>
  if((top % PGSIZE) != 0){
    241c:	03451793          	slli	a5,a0,0x34
    2420:	e3c9                	bnez	a5,24a2 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2422:	4501                	li	a0,0
    2424:	00003097          	auipc	ra,0x3
    2428:	53a080e7          	jalr	1338(ra) # 595e <sbrk>
  if(top % PGSIZE){
    242c:	03451793          	slli	a5,a0,0x34
    2430:	e3d9                	bnez	a5,24b6 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2432:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x115>
  *b = 'x';
    2436:	07800793          	li	a5,120
    243a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    243e:	8526                	mv	a0,s1
    2440:	00003097          	auipc	ra,0x3
    2444:	4e6080e7          	jalr	1254(ra) # 5926 <unlink>
  if(ret != -1){
    2448:	57fd                	li	a5,-1
    244a:	08f51363          	bne	a0,a5,24d0 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    244e:	20100593          	li	a1,513
    2452:	8526                	mv	a0,s1
    2454:	00003097          	auipc	ra,0x3
    2458:	4c2080e7          	jalr	1218(ra) # 5916 <open>
  if(fd != -1){
    245c:	57fd                	li	a5,-1
    245e:	08f51863          	bne	a0,a5,24ee <copyinstr3+0xf0>
  ret = link(b, b);
    2462:	85a6                	mv	a1,s1
    2464:	8526                	mv	a0,s1
    2466:	00003097          	auipc	ra,0x3
    246a:	4d0080e7          	jalr	1232(ra) # 5936 <link>
  if(ret != -1){
    246e:	57fd                	li	a5,-1
    2470:	08f51e63          	bne	a0,a5,250c <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2474:	00005797          	auipc	a5,0x5
    2478:	31478793          	addi	a5,a5,788 # 7788 <malloc+0x1a8a>
    247c:	fcf43823          	sd	a5,-48(s0)
    2480:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2484:	fd040593          	addi	a1,s0,-48
    2488:	8526                	mv	a0,s1
    248a:	00003097          	auipc	ra,0x3
    248e:	484080e7          	jalr	1156(ra) # 590e <exec>
  if(ret != -1){
    2492:	57fd                	li	a5,-1
    2494:	08f51c63          	bne	a0,a5,252c <copyinstr3+0x12e>
}
    2498:	70a2                	ld	ra,40(sp)
    249a:	7402                	ld	s0,32(sp)
    249c:	64e2                	ld	s1,24(sp)
    249e:	6145                	addi	sp,sp,48
    24a0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    24a2:	0347d513          	srli	a0,a5,0x34
    24a6:	6785                	lui	a5,0x1
    24a8:	40a7853b          	subw	a0,a5,a0
    24ac:	00003097          	auipc	ra,0x3
    24b0:	4b2080e7          	jalr	1202(ra) # 595e <sbrk>
    24b4:	b7bd                	j	2422 <copyinstr3+0x24>
    printf("oops\n");
    24b6:	00004517          	auipc	a0,0x4
    24ba:	65250513          	addi	a0,a0,1618 # 6b08 <malloc+0xe0a>
    24be:	00003097          	auipc	ra,0x3
    24c2:	788080e7          	jalr	1928(ra) # 5c46 <printf>
    exit(1);
    24c6:	4505                	li	a0,1
    24c8:	00003097          	auipc	ra,0x3
    24cc:	40e080e7          	jalr	1038(ra) # 58d6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    24d0:	862a                	mv	a2,a0
    24d2:	85a6                	mv	a1,s1
    24d4:	00004517          	auipc	a0,0x4
    24d8:	0dc50513          	addi	a0,a0,220 # 65b0 <malloc+0x8b2>
    24dc:	00003097          	auipc	ra,0x3
    24e0:	76a080e7          	jalr	1898(ra) # 5c46 <printf>
    exit(1);
    24e4:	4505                	li	a0,1
    24e6:	00003097          	auipc	ra,0x3
    24ea:	3f0080e7          	jalr	1008(ra) # 58d6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24ee:	862a                	mv	a2,a0
    24f0:	85a6                	mv	a1,s1
    24f2:	00004517          	auipc	a0,0x4
    24f6:	0de50513          	addi	a0,a0,222 # 65d0 <malloc+0x8d2>
    24fa:	00003097          	auipc	ra,0x3
    24fe:	74c080e7          	jalr	1868(ra) # 5c46 <printf>
    exit(1);
    2502:	4505                	li	a0,1
    2504:	00003097          	auipc	ra,0x3
    2508:	3d2080e7          	jalr	978(ra) # 58d6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    250c:	86aa                	mv	a3,a0
    250e:	8626                	mv	a2,s1
    2510:	85a6                	mv	a1,s1
    2512:	00004517          	auipc	a0,0x4
    2516:	0de50513          	addi	a0,a0,222 # 65f0 <malloc+0x8f2>
    251a:	00003097          	auipc	ra,0x3
    251e:	72c080e7          	jalr	1836(ra) # 5c46 <printf>
    exit(1);
    2522:	4505                	li	a0,1
    2524:	00003097          	auipc	ra,0x3
    2528:	3b2080e7          	jalr	946(ra) # 58d6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    252c:	567d                	li	a2,-1
    252e:	85a6                	mv	a1,s1
    2530:	00004517          	auipc	a0,0x4
    2534:	0e850513          	addi	a0,a0,232 # 6618 <malloc+0x91a>
    2538:	00003097          	auipc	ra,0x3
    253c:	70e080e7          	jalr	1806(ra) # 5c46 <printf>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	00003097          	auipc	ra,0x3
    2546:	394080e7          	jalr	916(ra) # 58d6 <exit>

000000000000254a <rwsbrk>:
{
    254a:	1101                	addi	sp,sp,-32
    254c:	ec06                	sd	ra,24(sp)
    254e:	e822                	sd	s0,16(sp)
    2550:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2552:	6509                	lui	a0,0x2
    2554:	00003097          	auipc	ra,0x3
    2558:	40a080e7          	jalr	1034(ra) # 595e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    255c:	57fd                	li	a5,-1
    255e:	06f50463          	beq	a0,a5,25c6 <rwsbrk+0x7c>
    2562:	e426                	sd	s1,8(sp)
    2564:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2566:	7579                	lui	a0,0xffffe
    2568:	00003097          	auipc	ra,0x3
    256c:	3f6080e7          	jalr	1014(ra) # 595e <sbrk>
    2570:	57fd                	li	a5,-1
    2572:	06f50963          	beq	a0,a5,25e4 <rwsbrk+0x9a>
    2576:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2578:	20100593          	li	a1,513
    257c:	00004517          	auipc	a0,0x4
    2580:	5cc50513          	addi	a0,a0,1484 # 6b48 <malloc+0xe4a>
    2584:	00003097          	auipc	ra,0x3
    2588:	392080e7          	jalr	914(ra) # 5916 <open>
    258c:	892a                	mv	s2,a0
  if(fd < 0){
    258e:	06054963          	bltz	a0,2600 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    2592:	6785                	lui	a5,0x1
    2594:	94be                	add	s1,s1,a5
    2596:	40000613          	li	a2,1024
    259a:	85a6                	mv	a1,s1
    259c:	00003097          	auipc	ra,0x3
    25a0:	35a080e7          	jalr	858(ra) # 58f6 <write>
    25a4:	862a                	mv	a2,a0
  if(n >= 0){
    25a6:	06054a63          	bltz	a0,261a <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    25aa:	85a6                	mv	a1,s1
    25ac:	00004517          	auipc	a0,0x4
    25b0:	5bc50513          	addi	a0,a0,1468 # 6b68 <malloc+0xe6a>
    25b4:	00003097          	auipc	ra,0x3
    25b8:	692080e7          	jalr	1682(ra) # 5c46 <printf>
    exit(1);
    25bc:	4505                	li	a0,1
    25be:	00003097          	auipc	ra,0x3
    25c2:	318080e7          	jalr	792(ra) # 58d6 <exit>
    25c6:	e426                	sd	s1,8(sp)
    25c8:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    25ca:	00004517          	auipc	a0,0x4
    25ce:	54650513          	addi	a0,a0,1350 # 6b10 <malloc+0xe12>
    25d2:	00003097          	auipc	ra,0x3
    25d6:	674080e7          	jalr	1652(ra) # 5c46 <printf>
    exit(1);
    25da:	4505                	li	a0,1
    25dc:	00003097          	auipc	ra,0x3
    25e0:	2fa080e7          	jalr	762(ra) # 58d6 <exit>
    25e4:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    25e6:	00004517          	auipc	a0,0x4
    25ea:	54250513          	addi	a0,a0,1346 # 6b28 <malloc+0xe2a>
    25ee:	00003097          	auipc	ra,0x3
    25f2:	658080e7          	jalr	1624(ra) # 5c46 <printf>
    exit(1);
    25f6:	4505                	li	a0,1
    25f8:	00003097          	auipc	ra,0x3
    25fc:	2de080e7          	jalr	734(ra) # 58d6 <exit>
    printf("open(rwsbrk) failed\n");
    2600:	00004517          	auipc	a0,0x4
    2604:	55050513          	addi	a0,a0,1360 # 6b50 <malloc+0xe52>
    2608:	00003097          	auipc	ra,0x3
    260c:	63e080e7          	jalr	1598(ra) # 5c46 <printf>
    exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	2c4080e7          	jalr	708(ra) # 58d6 <exit>
  close(fd);
    261a:	854a                	mv	a0,s2
    261c:	00003097          	auipc	ra,0x3
    2620:	2e2080e7          	jalr	738(ra) # 58fe <close>
  unlink("rwsbrk");
    2624:	00004517          	auipc	a0,0x4
    2628:	52450513          	addi	a0,a0,1316 # 6b48 <malloc+0xe4a>
    262c:	00003097          	auipc	ra,0x3
    2630:	2fa080e7          	jalr	762(ra) # 5926 <unlink>
  fd = open("README", O_RDONLY);
    2634:	4581                	li	a1,0
    2636:	00004517          	auipc	a0,0x4
    263a:	9aa50513          	addi	a0,a0,-1622 # 5fe0 <malloc+0x2e2>
    263e:	00003097          	auipc	ra,0x3
    2642:	2d8080e7          	jalr	728(ra) # 5916 <open>
    2646:	892a                	mv	s2,a0
  if(fd < 0){
    2648:	02054963          	bltz	a0,267a <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    264c:	4629                	li	a2,10
    264e:	85a6                	mv	a1,s1
    2650:	00003097          	auipc	ra,0x3
    2654:	29e080e7          	jalr	670(ra) # 58ee <read>
    2658:	862a                	mv	a2,a0
  if(n >= 0){
    265a:	02054d63          	bltz	a0,2694 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    265e:	85a6                	mv	a1,s1
    2660:	00004517          	auipc	a0,0x4
    2664:	53850513          	addi	a0,a0,1336 # 6b98 <malloc+0xe9a>
    2668:	00003097          	auipc	ra,0x3
    266c:	5de080e7          	jalr	1502(ra) # 5c46 <printf>
    exit(1);
    2670:	4505                	li	a0,1
    2672:	00003097          	auipc	ra,0x3
    2676:	264080e7          	jalr	612(ra) # 58d6 <exit>
    printf("open(rwsbrk) failed\n");
    267a:	00004517          	auipc	a0,0x4
    267e:	4d650513          	addi	a0,a0,1238 # 6b50 <malloc+0xe52>
    2682:	00003097          	auipc	ra,0x3
    2686:	5c4080e7          	jalr	1476(ra) # 5c46 <printf>
    exit(1);
    268a:	4505                	li	a0,1
    268c:	00003097          	auipc	ra,0x3
    2690:	24a080e7          	jalr	586(ra) # 58d6 <exit>
  close(fd);
    2694:	854a                	mv	a0,s2
    2696:	00003097          	auipc	ra,0x3
    269a:	268080e7          	jalr	616(ra) # 58fe <close>
  exit(0);
    269e:	4501                	li	a0,0
    26a0:	00003097          	auipc	ra,0x3
    26a4:	236080e7          	jalr	566(ra) # 58d6 <exit>

00000000000026a8 <sbrkbasic>:
{
    26a8:	7139                	addi	sp,sp,-64
    26aa:	fc06                	sd	ra,56(sp)
    26ac:	f822                	sd	s0,48(sp)
    26ae:	ec4e                	sd	s3,24(sp)
    26b0:	0080                	addi	s0,sp,64
    26b2:	89aa                	mv	s3,a0
  pid = fork();
    26b4:	00003097          	auipc	ra,0x3
    26b8:	21a080e7          	jalr	538(ra) # 58ce <fork>
  if(pid < 0){
    26bc:	02054f63          	bltz	a0,26fa <sbrkbasic+0x52>
  if(pid == 0){
    26c0:	e52d                	bnez	a0,272a <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    26c2:	40000537          	lui	a0,0x40000
    26c6:	00003097          	auipc	ra,0x3
    26ca:	298080e7          	jalr	664(ra) # 595e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    26ce:	57fd                	li	a5,-1
    26d0:	04f50563          	beq	a0,a5,271a <sbrkbasic+0x72>
    26d4:	f426                	sd	s1,40(sp)
    26d6:	f04a                	sd	s2,32(sp)
    26d8:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    26da:	400007b7          	lui	a5,0x40000
    26de:	97aa                	add	a5,a5,a0
      *b = 99;
    26e0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    26e4:	6705                	lui	a4,0x1
      *b = 99;
    26e6:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3ffeff18>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26ea:	953a                	add	a0,a0,a4
    26ec:	fef51de3          	bne	a0,a5,26e6 <sbrkbasic+0x3e>
    exit(1);
    26f0:	4505                	li	a0,1
    26f2:	00003097          	auipc	ra,0x3
    26f6:	1e4080e7          	jalr	484(ra) # 58d6 <exit>
    26fa:	f426                	sd	s1,40(sp)
    26fc:	f04a                	sd	s2,32(sp)
    26fe:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2700:	00004517          	auipc	a0,0x4
    2704:	4c050513          	addi	a0,a0,1216 # 6bc0 <malloc+0xec2>
    2708:	00003097          	auipc	ra,0x3
    270c:	53e080e7          	jalr	1342(ra) # 5c46 <printf>
    exit(1);
    2710:	4505                	li	a0,1
    2712:	00003097          	auipc	ra,0x3
    2716:	1c4080e7          	jalr	452(ra) # 58d6 <exit>
    271a:	f426                	sd	s1,40(sp)
    271c:	f04a                	sd	s2,32(sp)
    271e:	e852                	sd	s4,16(sp)
      exit(0);
    2720:	4501                	li	a0,0
    2722:	00003097          	auipc	ra,0x3
    2726:	1b4080e7          	jalr	436(ra) # 58d6 <exit>
  wait(&xstatus);
    272a:	fcc40513          	addi	a0,s0,-52
    272e:	00003097          	auipc	ra,0x3
    2732:	1b0080e7          	jalr	432(ra) # 58de <wait>
  if(xstatus == 1){
    2736:	fcc42703          	lw	a4,-52(s0)
    273a:	4785                	li	a5,1
    273c:	02f70063          	beq	a4,a5,275c <sbrkbasic+0xb4>
    2740:	f426                	sd	s1,40(sp)
    2742:	f04a                	sd	s2,32(sp)
    2744:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2746:	4501                	li	a0,0
    2748:	00003097          	auipc	ra,0x3
    274c:	216080e7          	jalr	534(ra) # 595e <sbrk>
    2750:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2752:	4901                	li	s2,0
    2754:	6a05                	lui	s4,0x1
    2756:	388a0a13          	addi	s4,s4,904 # 1388 <copyinstr2+0x1cc>
    275a:	a01d                	j	2780 <sbrkbasic+0xd8>
    275c:	f426                	sd	s1,40(sp)
    275e:	f04a                	sd	s2,32(sp)
    2760:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2762:	85ce                	mv	a1,s3
    2764:	00004517          	auipc	a0,0x4
    2768:	47c50513          	addi	a0,a0,1148 # 6be0 <malloc+0xee2>
    276c:	00003097          	auipc	ra,0x3
    2770:	4da080e7          	jalr	1242(ra) # 5c46 <printf>
    exit(1);
    2774:	4505                	li	a0,1
    2776:	00003097          	auipc	ra,0x3
    277a:	160080e7          	jalr	352(ra) # 58d6 <exit>
    277e:	84be                	mv	s1,a5
    b = sbrk(1);
    2780:	4505                	li	a0,1
    2782:	00003097          	auipc	ra,0x3
    2786:	1dc080e7          	jalr	476(ra) # 595e <sbrk>
    if(b != a){
    278a:	04951c63          	bne	a0,s1,27e2 <sbrkbasic+0x13a>
    *b = 1;
    278e:	4785                	li	a5,1
    2790:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2794:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2798:	2905                	addiw	s2,s2,1
    279a:	ff4912e3          	bne	s2,s4,277e <sbrkbasic+0xd6>
  pid = fork();
    279e:	00003097          	auipc	ra,0x3
    27a2:	130080e7          	jalr	304(ra) # 58ce <fork>
    27a6:	892a                	mv	s2,a0
  if(pid < 0){
    27a8:	04054e63          	bltz	a0,2804 <sbrkbasic+0x15c>
  c = sbrk(1);
    27ac:	4505                	li	a0,1
    27ae:	00003097          	auipc	ra,0x3
    27b2:	1b0080e7          	jalr	432(ra) # 595e <sbrk>
  c = sbrk(1);
    27b6:	4505                	li	a0,1
    27b8:	00003097          	auipc	ra,0x3
    27bc:	1a6080e7          	jalr	422(ra) # 595e <sbrk>
  if(c != a + 1){
    27c0:	0489                	addi	s1,s1,2
    27c2:	04a48f63          	beq	s1,a0,2820 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    27c6:	85ce                	mv	a1,s3
    27c8:	00004517          	auipc	a0,0x4
    27cc:	47850513          	addi	a0,a0,1144 # 6c40 <malloc+0xf42>
    27d0:	00003097          	auipc	ra,0x3
    27d4:	476080e7          	jalr	1142(ra) # 5c46 <printf>
    exit(1);
    27d8:	4505                	li	a0,1
    27da:	00003097          	auipc	ra,0x3
    27de:	0fc080e7          	jalr	252(ra) # 58d6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    27e2:	872a                	mv	a4,a0
    27e4:	86a6                	mv	a3,s1
    27e6:	864a                	mv	a2,s2
    27e8:	85ce                	mv	a1,s3
    27ea:	00004517          	auipc	a0,0x4
    27ee:	41650513          	addi	a0,a0,1046 # 6c00 <malloc+0xf02>
    27f2:	00003097          	auipc	ra,0x3
    27f6:	454080e7          	jalr	1108(ra) # 5c46 <printf>
      exit(1);
    27fa:	4505                	li	a0,1
    27fc:	00003097          	auipc	ra,0x3
    2800:	0da080e7          	jalr	218(ra) # 58d6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2804:	85ce                	mv	a1,s3
    2806:	00004517          	auipc	a0,0x4
    280a:	41a50513          	addi	a0,a0,1050 # 6c20 <malloc+0xf22>
    280e:	00003097          	auipc	ra,0x3
    2812:	438080e7          	jalr	1080(ra) # 5c46 <printf>
    exit(1);
    2816:	4505                	li	a0,1
    2818:	00003097          	auipc	ra,0x3
    281c:	0be080e7          	jalr	190(ra) # 58d6 <exit>
  if(pid == 0)
    2820:	00091763          	bnez	s2,282e <sbrkbasic+0x186>
    exit(0);
    2824:	4501                	li	a0,0
    2826:	00003097          	auipc	ra,0x3
    282a:	0b0080e7          	jalr	176(ra) # 58d6 <exit>
  wait(&xstatus);
    282e:	fcc40513          	addi	a0,s0,-52
    2832:	00003097          	auipc	ra,0x3
    2836:	0ac080e7          	jalr	172(ra) # 58de <wait>
  exit(xstatus);
    283a:	fcc42503          	lw	a0,-52(s0)
    283e:	00003097          	auipc	ra,0x3
    2842:	098080e7          	jalr	152(ra) # 58d6 <exit>

0000000000002846 <sbrkmuch>:
{
    2846:	7179                	addi	sp,sp,-48
    2848:	f406                	sd	ra,40(sp)
    284a:	f022                	sd	s0,32(sp)
    284c:	ec26                	sd	s1,24(sp)
    284e:	e84a                	sd	s2,16(sp)
    2850:	e44e                	sd	s3,8(sp)
    2852:	e052                	sd	s4,0(sp)
    2854:	1800                	addi	s0,sp,48
    2856:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2858:	4501                	li	a0,0
    285a:	00003097          	auipc	ra,0x3
    285e:	104080e7          	jalr	260(ra) # 595e <sbrk>
    2862:	892a                	mv	s2,a0
  a = sbrk(0);
    2864:	4501                	li	a0,0
    2866:	00003097          	auipc	ra,0x3
    286a:	0f8080e7          	jalr	248(ra) # 595e <sbrk>
    286e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2870:	06400537          	lui	a0,0x6400
    2874:	9d05                	subw	a0,a0,s1
    2876:	00003097          	auipc	ra,0x3
    287a:	0e8080e7          	jalr	232(ra) # 595e <sbrk>
  if (p != a) {
    287e:	0ca49863          	bne	s1,a0,294e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2882:	4501                	li	a0,0
    2884:	00003097          	auipc	ra,0x3
    2888:	0da080e7          	jalr	218(ra) # 595e <sbrk>
    288c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    288e:	00a4f963          	bgeu	s1,a0,28a0 <sbrkmuch+0x5a>
    *pp = 1;
    2892:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2894:	6705                	lui	a4,0x1
    *pp = 1;
    2896:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    289a:	94ba                	add	s1,s1,a4
    289c:	fef4ede3          	bltu	s1,a5,2896 <sbrkmuch+0x50>
  *lastaddr = 99;
    28a0:	064007b7          	lui	a5,0x6400
    28a4:	06300713          	li	a4,99
    28a8:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63eff17>
  a = sbrk(0);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	0b0080e7          	jalr	176(ra) # 595e <sbrk>
    28b6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    28b8:	757d                	lui	a0,0xfffff
    28ba:	00003097          	auipc	ra,0x3
    28be:	0a4080e7          	jalr	164(ra) # 595e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    28c2:	57fd                	li	a5,-1
    28c4:	0af50363          	beq	a0,a5,296a <sbrkmuch+0x124>
  c = sbrk(0);
    28c8:	4501                	li	a0,0
    28ca:	00003097          	auipc	ra,0x3
    28ce:	094080e7          	jalr	148(ra) # 595e <sbrk>
  if(c != a - PGSIZE){
    28d2:	77fd                	lui	a5,0xfffff
    28d4:	97a6                	add	a5,a5,s1
    28d6:	0af51863          	bne	a0,a5,2986 <sbrkmuch+0x140>
  a = sbrk(0);
    28da:	4501                	li	a0,0
    28dc:	00003097          	auipc	ra,0x3
    28e0:	082080e7          	jalr	130(ra) # 595e <sbrk>
    28e4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    28e6:	6505                	lui	a0,0x1
    28e8:	00003097          	auipc	ra,0x3
    28ec:	076080e7          	jalr	118(ra) # 595e <sbrk>
    28f0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    28f2:	0aa49a63          	bne	s1,a0,29a6 <sbrkmuch+0x160>
    28f6:	4501                	li	a0,0
    28f8:	00003097          	auipc	ra,0x3
    28fc:	066080e7          	jalr	102(ra) # 595e <sbrk>
    2900:	6785                	lui	a5,0x1
    2902:	97a6                	add	a5,a5,s1
    2904:	0af51163          	bne	a0,a5,29a6 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2908:	064007b7          	lui	a5,0x6400
    290c:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63eff17>
    2910:	06300793          	li	a5,99
    2914:	0af70963          	beq	a4,a5,29c6 <sbrkmuch+0x180>
  a = sbrk(0);
    2918:	4501                	li	a0,0
    291a:	00003097          	auipc	ra,0x3
    291e:	044080e7          	jalr	68(ra) # 595e <sbrk>
    2922:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2924:	4501                	li	a0,0
    2926:	00003097          	auipc	ra,0x3
    292a:	038080e7          	jalr	56(ra) # 595e <sbrk>
    292e:	40a9053b          	subw	a0,s2,a0
    2932:	00003097          	auipc	ra,0x3
    2936:	02c080e7          	jalr	44(ra) # 595e <sbrk>
  if(c != a){
    293a:	0aa49463          	bne	s1,a0,29e2 <sbrkmuch+0x19c>
}
    293e:	70a2                	ld	ra,40(sp)
    2940:	7402                	ld	s0,32(sp)
    2942:	64e2                	ld	s1,24(sp)
    2944:	6942                	ld	s2,16(sp)
    2946:	69a2                	ld	s3,8(sp)
    2948:	6a02                	ld	s4,0(sp)
    294a:	6145                	addi	sp,sp,48
    294c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    294e:	85ce                	mv	a1,s3
    2950:	00004517          	auipc	a0,0x4
    2954:	31050513          	addi	a0,a0,784 # 6c60 <malloc+0xf62>
    2958:	00003097          	auipc	ra,0x3
    295c:	2ee080e7          	jalr	750(ra) # 5c46 <printf>
    exit(1);
    2960:	4505                	li	a0,1
    2962:	00003097          	auipc	ra,0x3
    2966:	f74080e7          	jalr	-140(ra) # 58d6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    296a:	85ce                	mv	a1,s3
    296c:	00004517          	auipc	a0,0x4
    2970:	33c50513          	addi	a0,a0,828 # 6ca8 <malloc+0xfaa>
    2974:	00003097          	auipc	ra,0x3
    2978:	2d2080e7          	jalr	722(ra) # 5c46 <printf>
    exit(1);
    297c:	4505                	li	a0,1
    297e:	00003097          	auipc	ra,0x3
    2982:	f58080e7          	jalr	-168(ra) # 58d6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2986:	86aa                	mv	a3,a0
    2988:	8626                	mv	a2,s1
    298a:	85ce                	mv	a1,s3
    298c:	00004517          	auipc	a0,0x4
    2990:	33c50513          	addi	a0,a0,828 # 6cc8 <malloc+0xfca>
    2994:	00003097          	auipc	ra,0x3
    2998:	2b2080e7          	jalr	690(ra) # 5c46 <printf>
    exit(1);
    299c:	4505                	li	a0,1
    299e:	00003097          	auipc	ra,0x3
    29a2:	f38080e7          	jalr	-200(ra) # 58d6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    29a6:	86d2                	mv	a3,s4
    29a8:	8626                	mv	a2,s1
    29aa:	85ce                	mv	a1,s3
    29ac:	00004517          	auipc	a0,0x4
    29b0:	35c50513          	addi	a0,a0,860 # 6d08 <malloc+0x100a>
    29b4:	00003097          	auipc	ra,0x3
    29b8:	292080e7          	jalr	658(ra) # 5c46 <printf>
    exit(1);
    29bc:	4505                	li	a0,1
    29be:	00003097          	auipc	ra,0x3
    29c2:	f18080e7          	jalr	-232(ra) # 58d6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    29c6:	85ce                	mv	a1,s3
    29c8:	00004517          	auipc	a0,0x4
    29cc:	37050513          	addi	a0,a0,880 # 6d38 <malloc+0x103a>
    29d0:	00003097          	auipc	ra,0x3
    29d4:	276080e7          	jalr	630(ra) # 5c46 <printf>
    exit(1);
    29d8:	4505                	li	a0,1
    29da:	00003097          	auipc	ra,0x3
    29de:	efc080e7          	jalr	-260(ra) # 58d6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    29e2:	86aa                	mv	a3,a0
    29e4:	8626                	mv	a2,s1
    29e6:	85ce                	mv	a1,s3
    29e8:	00004517          	auipc	a0,0x4
    29ec:	38850513          	addi	a0,a0,904 # 6d70 <malloc+0x1072>
    29f0:	00003097          	auipc	ra,0x3
    29f4:	256080e7          	jalr	598(ra) # 5c46 <printf>
    exit(1);
    29f8:	4505                	li	a0,1
    29fa:	00003097          	auipc	ra,0x3
    29fe:	edc080e7          	jalr	-292(ra) # 58d6 <exit>

0000000000002a02 <sbrkarg>:
{
    2a02:	7179                	addi	sp,sp,-48
    2a04:	f406                	sd	ra,40(sp)
    2a06:	f022                	sd	s0,32(sp)
    2a08:	ec26                	sd	s1,24(sp)
    2a0a:	e84a                	sd	s2,16(sp)
    2a0c:	e44e                	sd	s3,8(sp)
    2a0e:	1800                	addi	s0,sp,48
    2a10:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2a12:	6505                	lui	a0,0x1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	f4a080e7          	jalr	-182(ra) # 595e <sbrk>
    2a1c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2a1e:	20100593          	li	a1,513
    2a22:	00004517          	auipc	a0,0x4
    2a26:	37650513          	addi	a0,a0,886 # 6d98 <malloc+0x109a>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	eec080e7          	jalr	-276(ra) # 5916 <open>
    2a32:	84aa                	mv	s1,a0
  unlink("sbrk");
    2a34:	00004517          	auipc	a0,0x4
    2a38:	36450513          	addi	a0,a0,868 # 6d98 <malloc+0x109a>
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	eea080e7          	jalr	-278(ra) # 5926 <unlink>
  if(fd < 0)  {
    2a44:	0404c163          	bltz	s1,2a86 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2a48:	6605                	lui	a2,0x1
    2a4a:	85ca                	mv	a1,s2
    2a4c:	8526                	mv	a0,s1
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	ea8080e7          	jalr	-344(ra) # 58f6 <write>
    2a56:	04054663          	bltz	a0,2aa2 <sbrkarg+0xa0>
  close(fd);
    2a5a:	8526                	mv	a0,s1
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	ea2080e7          	jalr	-350(ra) # 58fe <close>
  a = sbrk(PGSIZE);
    2a64:	6505                	lui	a0,0x1
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	ef8080e7          	jalr	-264(ra) # 595e <sbrk>
  if(pipe((int *) a) != 0){
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	e78080e7          	jalr	-392(ra) # 58e6 <pipe>
    2a76:	e521                	bnez	a0,2abe <sbrkarg+0xbc>
}
    2a78:	70a2                	ld	ra,40(sp)
    2a7a:	7402                	ld	s0,32(sp)
    2a7c:	64e2                	ld	s1,24(sp)
    2a7e:	6942                	ld	s2,16(sp)
    2a80:	69a2                	ld	s3,8(sp)
    2a82:	6145                	addi	sp,sp,48
    2a84:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a86:	85ce                	mv	a1,s3
    2a88:	00004517          	auipc	a0,0x4
    2a8c:	31850513          	addi	a0,a0,792 # 6da0 <malloc+0x10a2>
    2a90:	00003097          	auipc	ra,0x3
    2a94:	1b6080e7          	jalr	438(ra) # 5c46 <printf>
    exit(1);
    2a98:	4505                	li	a0,1
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	e3c080e7          	jalr	-452(ra) # 58d6 <exit>
    printf("%s: write sbrk failed\n", s);
    2aa2:	85ce                	mv	a1,s3
    2aa4:	00004517          	auipc	a0,0x4
    2aa8:	31450513          	addi	a0,a0,788 # 6db8 <malloc+0x10ba>
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	19a080e7          	jalr	410(ra) # 5c46 <printf>
    exit(1);
    2ab4:	4505                	li	a0,1
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	e20080e7          	jalr	-480(ra) # 58d6 <exit>
    printf("%s: pipe() failed\n", s);
    2abe:	85ce                	mv	a1,s3
    2ac0:	00004517          	auipc	a0,0x4
    2ac4:	cd850513          	addi	a0,a0,-808 # 6798 <malloc+0xa9a>
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	17e080e7          	jalr	382(ra) # 5c46 <printf>
    exit(1);
    2ad0:	4505                	li	a0,1
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	e04080e7          	jalr	-508(ra) # 58d6 <exit>

0000000000002ada <argptest>:
{
    2ada:	1101                	addi	sp,sp,-32
    2adc:	ec06                	sd	ra,24(sp)
    2ade:	e822                	sd	s0,16(sp)
    2ae0:	e426                	sd	s1,8(sp)
    2ae2:	e04a                	sd	s2,0(sp)
    2ae4:	1000                	addi	s0,sp,32
    2ae6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ae8:	4581                	li	a1,0
    2aea:	00004517          	auipc	a0,0x4
    2aee:	2e650513          	addi	a0,a0,742 # 6dd0 <malloc+0x10d2>
    2af2:	00003097          	auipc	ra,0x3
    2af6:	e24080e7          	jalr	-476(ra) # 5916 <open>
  if (fd < 0) {
    2afa:	02054b63          	bltz	a0,2b30 <argptest+0x56>
    2afe:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2b00:	4501                	li	a0,0
    2b02:	00003097          	auipc	ra,0x3
    2b06:	e5c080e7          	jalr	-420(ra) # 595e <sbrk>
    2b0a:	567d                	li	a2,-1
    2b0c:	fff50593          	addi	a1,a0,-1
    2b10:	8526                	mv	a0,s1
    2b12:	00003097          	auipc	ra,0x3
    2b16:	ddc080e7          	jalr	-548(ra) # 58ee <read>
  close(fd);
    2b1a:	8526                	mv	a0,s1
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	de2080e7          	jalr	-542(ra) # 58fe <close>
}
    2b24:	60e2                	ld	ra,24(sp)
    2b26:	6442                	ld	s0,16(sp)
    2b28:	64a2                	ld	s1,8(sp)
    2b2a:	6902                	ld	s2,0(sp)
    2b2c:	6105                	addi	sp,sp,32
    2b2e:	8082                	ret
    printf("%s: open failed\n", s);
    2b30:	85ca                	mv	a1,s2
    2b32:	00004517          	auipc	a0,0x4
    2b36:	b7650513          	addi	a0,a0,-1162 # 66a8 <malloc+0x9aa>
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	10c080e7          	jalr	268(ra) # 5c46 <printf>
    exit(1);
    2b42:	4505                	li	a0,1
    2b44:	00003097          	auipc	ra,0x3
    2b48:	d92080e7          	jalr	-622(ra) # 58d6 <exit>

0000000000002b4c <sbrkbugs>:
{
    2b4c:	1141                	addi	sp,sp,-16
    2b4e:	e406                	sd	ra,8(sp)
    2b50:	e022                	sd	s0,0(sp)
    2b52:	0800                	addi	s0,sp,16
  int pid = fork();
    2b54:	00003097          	auipc	ra,0x3
    2b58:	d7a080e7          	jalr	-646(ra) # 58ce <fork>
  if(pid < 0){
    2b5c:	02054263          	bltz	a0,2b80 <sbrkbugs+0x34>
  if(pid == 0){
    2b60:	ed0d                	bnez	a0,2b9a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b62:	00003097          	auipc	ra,0x3
    2b66:	dfc080e7          	jalr	-516(ra) # 595e <sbrk>
    sbrk(-sz);
    2b6a:	40a0053b          	negw	a0,a0
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	df0080e7          	jalr	-528(ra) # 595e <sbrk>
    exit(0);
    2b76:	4501                	li	a0,0
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	d5e080e7          	jalr	-674(ra) # 58d6 <exit>
    printf("fork failed\n");
    2b80:	00004517          	auipc	a0,0x4
    2b84:	f3050513          	addi	a0,a0,-208 # 6ab0 <malloc+0xdb2>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	0be080e7          	jalr	190(ra) # 5c46 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	d44080e7          	jalr	-700(ra) # 58d6 <exit>
  wait(0);
    2b9a:	4501                	li	a0,0
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	d42080e7          	jalr	-702(ra) # 58de <wait>
  pid = fork();
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	d2a080e7          	jalr	-726(ra) # 58ce <fork>
  if(pid < 0){
    2bac:	02054563          	bltz	a0,2bd6 <sbrkbugs+0x8a>
  if(pid == 0){
    2bb0:	e121                	bnez	a0,2bf0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	dac080e7          	jalr	-596(ra) # 595e <sbrk>
    sbrk(-(sz - 3500));
    2bba:	6785                	lui	a5,0x1
    2bbc:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x96>
    2bc0:	40a7853b          	subw	a0,a5,a0
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	d9a080e7          	jalr	-614(ra) # 595e <sbrk>
    exit(0);
    2bcc:	4501                	li	a0,0
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	d08080e7          	jalr	-760(ra) # 58d6 <exit>
    printf("fork failed\n");
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	eda50513          	addi	a0,a0,-294 # 6ab0 <malloc+0xdb2>
    2bde:	00003097          	auipc	ra,0x3
    2be2:	068080e7          	jalr	104(ra) # 5c46 <printf>
    exit(1);
    2be6:	4505                	li	a0,1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	cee080e7          	jalr	-786(ra) # 58d6 <exit>
  wait(0);
    2bf0:	4501                	li	a0,0
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	cec080e7          	jalr	-788(ra) # 58de <wait>
  pid = fork();
    2bfa:	00003097          	auipc	ra,0x3
    2bfe:	cd4080e7          	jalr	-812(ra) # 58ce <fork>
  if(pid < 0){
    2c02:	02054a63          	bltz	a0,2c36 <sbrkbugs+0xea>
  if(pid == 0){
    2c06:	e529                	bnez	a0,2c50 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	d56080e7          	jalr	-682(ra) # 595e <sbrk>
    2c10:	67ad                	lui	a5,0xb
    2c12:	8007879b          	addiw	a5,a5,-2048 # a800 <__global_pointer$+0x74c>
    2c16:	40a7853b          	subw	a0,a5,a0
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	d44080e7          	jalr	-700(ra) # 595e <sbrk>
    sbrk(-10);
    2c22:	5559                	li	a0,-10
    2c24:	00003097          	auipc	ra,0x3
    2c28:	d3a080e7          	jalr	-710(ra) # 595e <sbrk>
    exit(0);
    2c2c:	4501                	li	a0,0
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	ca8080e7          	jalr	-856(ra) # 58d6 <exit>
    printf("fork failed\n");
    2c36:	00004517          	auipc	a0,0x4
    2c3a:	e7a50513          	addi	a0,a0,-390 # 6ab0 <malloc+0xdb2>
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	008080e7          	jalr	8(ra) # 5c46 <printf>
    exit(1);
    2c46:	4505                	li	a0,1
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	c8e080e7          	jalr	-882(ra) # 58d6 <exit>
  wait(0);
    2c50:	4501                	li	a0,0
    2c52:	00003097          	auipc	ra,0x3
    2c56:	c8c080e7          	jalr	-884(ra) # 58de <wait>
  exit(0);
    2c5a:	4501                	li	a0,0
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	c7a080e7          	jalr	-902(ra) # 58d6 <exit>

0000000000002c64 <sbrklast>:
{
    2c64:	7179                	addi	sp,sp,-48
    2c66:	f406                	sd	ra,40(sp)
    2c68:	f022                	sd	s0,32(sp)
    2c6a:	ec26                	sd	s1,24(sp)
    2c6c:	e84a                	sd	s2,16(sp)
    2c6e:	e44e                	sd	s3,8(sp)
    2c70:	e052                	sd	s4,0(sp)
    2c72:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c74:	4501                	li	a0,0
    2c76:	00003097          	auipc	ra,0x3
    2c7a:	ce8080e7          	jalr	-792(ra) # 595e <sbrk>
  if((top % 4096) != 0)
    2c7e:	03451793          	slli	a5,a0,0x34
    2c82:	ebd9                	bnez	a5,2d18 <sbrklast+0xb4>
  sbrk(4096);
    2c84:	6505                	lui	a0,0x1
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	cd8080e7          	jalr	-808(ra) # 595e <sbrk>
  sbrk(10);
    2c8e:	4529                	li	a0,10
    2c90:	00003097          	auipc	ra,0x3
    2c94:	cce080e7          	jalr	-818(ra) # 595e <sbrk>
  sbrk(-20);
    2c98:	5531                	li	a0,-20
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	cc4080e7          	jalr	-828(ra) # 595e <sbrk>
  top = (uint64) sbrk(0);
    2ca2:	4501                	li	a0,0
    2ca4:	00003097          	auipc	ra,0x3
    2ca8:	cba080e7          	jalr	-838(ra) # 595e <sbrk>
    2cac:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2cae:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x5e>
  p[0] = 'x';
    2cb2:	07800a13          	li	s4,120
    2cb6:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2cba:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2cbe:	20200593          	li	a1,514
    2cc2:	854a                	mv	a0,s2
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	c52080e7          	jalr	-942(ra) # 5916 <open>
    2ccc:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2cce:	4605                	li	a2,1
    2cd0:	85ca                	mv	a1,s2
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	c24080e7          	jalr	-988(ra) # 58f6 <write>
  close(fd);
    2cda:	854e                	mv	a0,s3
    2cdc:	00003097          	auipc	ra,0x3
    2ce0:	c22080e7          	jalr	-990(ra) # 58fe <close>
  fd = open(p, O_RDWR);
    2ce4:	4589                	li	a1,2
    2ce6:	854a                	mv	a0,s2
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	c2e080e7          	jalr	-978(ra) # 5916 <open>
  p[0] = '\0';
    2cf0:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2cf4:	4605                	li	a2,1
    2cf6:	85ca                	mv	a1,s2
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	bf6080e7          	jalr	-1034(ra) # 58ee <read>
  if(p[0] != 'x')
    2d00:	fc04c783          	lbu	a5,-64(s1)
    2d04:	03479463          	bne	a5,s4,2d2c <sbrklast+0xc8>
}
    2d08:	70a2                	ld	ra,40(sp)
    2d0a:	7402                	ld	s0,32(sp)
    2d0c:	64e2                	ld	s1,24(sp)
    2d0e:	6942                	ld	s2,16(sp)
    2d10:	69a2                	ld	s3,8(sp)
    2d12:	6a02                	ld	s4,0(sp)
    2d14:	6145                	addi	sp,sp,48
    2d16:	8082                	ret
    sbrk(4096 - (top % 4096));
    2d18:	0347d513          	srli	a0,a5,0x34
    2d1c:	6785                	lui	a5,0x1
    2d1e:	40a7853b          	subw	a0,a5,a0
    2d22:	00003097          	auipc	ra,0x3
    2d26:	c3c080e7          	jalr	-964(ra) # 595e <sbrk>
    2d2a:	bfa9                	j	2c84 <sbrklast+0x20>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	ba8080e7          	jalr	-1112(ra) # 58d6 <exit>

0000000000002d36 <sbrk8000>:
{
    2d36:	1141                	addi	sp,sp,-16
    2d38:	e406                	sd	ra,8(sp)
    2d3a:	e022                	sd	s0,0(sp)
    2d3c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2d3e:	80000537          	lui	a0,0x80000
    2d42:	0511                	addi	a0,a0,4 # ffffffff80000004 <__BSS_END__+0xffffffff7ffeff1c>
    2d44:	00003097          	auipc	ra,0x3
    2d48:	c1a080e7          	jalr	-998(ra) # 595e <sbrk>
  volatile char *top = sbrk(0);
    2d4c:	4501                	li	a0,0
    2d4e:	00003097          	auipc	ra,0x3
    2d52:	c10080e7          	jalr	-1008(ra) # 595e <sbrk>
  *(top-1) = *(top-1) + 1;
    2d56:	fff54783          	lbu	a5,-1(a0)
    2d5a:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0x9f>
    2d5c:	0ff7f793          	zext.b	a5,a5
    2d60:	fef50fa3          	sb	a5,-1(a0)
}
    2d64:	60a2                	ld	ra,8(sp)
    2d66:	6402                	ld	s0,0(sp)
    2d68:	0141                	addi	sp,sp,16
    2d6a:	8082                	ret

0000000000002d6c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d6c:	715d                	addi	sp,sp,-80
    2d6e:	e486                	sd	ra,72(sp)
    2d70:	e0a2                	sd	s0,64(sp)
    2d72:	fc26                	sd	s1,56(sp)
    2d74:	f84a                	sd	s2,48(sp)
    2d76:	f44e                	sd	s3,40(sp)
    2d78:	f052                	sd	s4,32(sp)
    2d7a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d7c:	4901                	li	s2,0
    2d7e:	49bd                	li	s3,15
    int pid = fork();
    2d80:	00003097          	auipc	ra,0x3
    2d84:	b4e080e7          	jalr	-1202(ra) # 58ce <fork>
    2d88:	84aa                	mv	s1,a0
    if(pid < 0){
    2d8a:	02054063          	bltz	a0,2daa <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d8e:	c91d                	beqz	a0,2dc4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d90:	4501                	li	a0,0
    2d92:	00003097          	auipc	ra,0x3
    2d96:	b4c080e7          	jalr	-1204(ra) # 58de <wait>
  for(int avail = 0; avail < 15; avail++){
    2d9a:	2905                	addiw	s2,s2,1
    2d9c:	ff3912e3          	bne	s2,s3,2d80 <execout+0x14>
    }
  }

  exit(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	b34080e7          	jalr	-1228(ra) # 58d6 <exit>
      printf("fork failed\n");
    2daa:	00004517          	auipc	a0,0x4
    2dae:	d0650513          	addi	a0,a0,-762 # 6ab0 <malloc+0xdb2>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	e94080e7          	jalr	-364(ra) # 5c46 <printf>
      exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	b1a080e7          	jalr	-1254(ra) # 58d6 <exit>
        if(a == 0xffffffffffffffffLL)
    2dc4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2dc6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2dc8:	6505                	lui	a0,0x1
    2dca:	00003097          	auipc	ra,0x3
    2dce:	b94080e7          	jalr	-1132(ra) # 595e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2dd2:	01350763          	beq	a0,s3,2de0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2dd6:	6785                	lui	a5,0x1
    2dd8:	97aa                	add	a5,a5,a0
    2dda:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9d>
      while(1){
    2dde:	b7ed                	j	2dc8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2de0:	01205a63          	blez	s2,2df4 <execout+0x88>
        sbrk(-4096);
    2de4:	757d                	lui	a0,0xfffff
    2de6:	00003097          	auipc	ra,0x3
    2dea:	b78080e7          	jalr	-1160(ra) # 595e <sbrk>
      for(int i = 0; i < avail; i++)
    2dee:	2485                	addiw	s1,s1,1
    2df0:	ff249ae3          	bne	s1,s2,2de4 <execout+0x78>
      close(1);
    2df4:	4505                	li	a0,1
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	b08080e7          	jalr	-1272(ra) # 58fe <close>
      char *args[] = { "echo", "x", 0 };
    2dfe:	00003517          	auipc	a0,0x3
    2e02:	03a50513          	addi	a0,a0,58 # 5e38 <malloc+0x13a>
    2e06:	faa43c23          	sd	a0,-72(s0)
    2e0a:	00003797          	auipc	a5,0x3
    2e0e:	09e78793          	addi	a5,a5,158 # 5ea8 <malloc+0x1aa>
    2e12:	fcf43023          	sd	a5,-64(s0)
    2e16:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2e1a:	fb840593          	addi	a1,s0,-72
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	af0080e7          	jalr	-1296(ra) # 590e <exec>
      exit(0);
    2e26:	4501                	li	a0,0
    2e28:	00003097          	auipc	ra,0x3
    2e2c:	aae080e7          	jalr	-1362(ra) # 58d6 <exit>

0000000000002e30 <fourteen>:
{
    2e30:	1101                	addi	sp,sp,-32
    2e32:	ec06                	sd	ra,24(sp)
    2e34:	e822                	sd	s0,16(sp)
    2e36:	e426                	sd	s1,8(sp)
    2e38:	1000                	addi	s0,sp,32
    2e3a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	16c50513          	addi	a0,a0,364 # 6fa8 <malloc+0x12aa>
    2e44:	00003097          	auipc	ra,0x3
    2e48:	afa080e7          	jalr	-1286(ra) # 593e <mkdir>
    2e4c:	e165                	bnez	a0,2f2c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2e4e:	00004517          	auipc	a0,0x4
    2e52:	fb250513          	addi	a0,a0,-78 # 6e00 <malloc+0x1102>
    2e56:	00003097          	auipc	ra,0x3
    2e5a:	ae8080e7          	jalr	-1304(ra) # 593e <mkdir>
    2e5e:	e56d                	bnez	a0,2f48 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e60:	20000593          	li	a1,512
    2e64:	00004517          	auipc	a0,0x4
    2e68:	ff450513          	addi	a0,a0,-12 # 6e58 <malloc+0x115a>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	aaa080e7          	jalr	-1366(ra) # 5916 <open>
  if(fd < 0){
    2e74:	0e054863          	bltz	a0,2f64 <fourteen+0x134>
  close(fd);
    2e78:	00003097          	auipc	ra,0x3
    2e7c:	a86080e7          	jalr	-1402(ra) # 58fe <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e80:	4581                	li	a1,0
    2e82:	00004517          	auipc	a0,0x4
    2e86:	04e50513          	addi	a0,a0,78 # 6ed0 <malloc+0x11d2>
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	a8c080e7          	jalr	-1396(ra) # 5916 <open>
  if(fd < 0){
    2e92:	0e054763          	bltz	a0,2f80 <fourteen+0x150>
  close(fd);
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	a68080e7          	jalr	-1432(ra) # 58fe <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e9e:	00004517          	auipc	a0,0x4
    2ea2:	0a250513          	addi	a0,a0,162 # 6f40 <malloc+0x1242>
    2ea6:	00003097          	auipc	ra,0x3
    2eaa:	a98080e7          	jalr	-1384(ra) # 593e <mkdir>
    2eae:	c57d                	beqz	a0,2f9c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2eb0:	00004517          	auipc	a0,0x4
    2eb4:	0e850513          	addi	a0,a0,232 # 6f98 <malloc+0x129a>
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	a86080e7          	jalr	-1402(ra) # 593e <mkdir>
    2ec0:	cd65                	beqz	a0,2fb8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	0d650513          	addi	a0,a0,214 # 6f98 <malloc+0x129a>
    2eca:	00003097          	auipc	ra,0x3
    2ece:	a5c080e7          	jalr	-1444(ra) # 5926 <unlink>
  unlink("12345678901234/12345678901234");
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	06e50513          	addi	a0,a0,110 # 6f40 <malloc+0x1242>
    2eda:	00003097          	auipc	ra,0x3
    2ede:	a4c080e7          	jalr	-1460(ra) # 5926 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2ee2:	00004517          	auipc	a0,0x4
    2ee6:	fee50513          	addi	a0,a0,-18 # 6ed0 <malloc+0x11d2>
    2eea:	00003097          	auipc	ra,0x3
    2eee:	a3c080e7          	jalr	-1476(ra) # 5926 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ef2:	00004517          	auipc	a0,0x4
    2ef6:	f6650513          	addi	a0,a0,-154 # 6e58 <malloc+0x115a>
    2efa:	00003097          	auipc	ra,0x3
    2efe:	a2c080e7          	jalr	-1492(ra) # 5926 <unlink>
  unlink("12345678901234/123456789012345");
    2f02:	00004517          	auipc	a0,0x4
    2f06:	efe50513          	addi	a0,a0,-258 # 6e00 <malloc+0x1102>
    2f0a:	00003097          	auipc	ra,0x3
    2f0e:	a1c080e7          	jalr	-1508(ra) # 5926 <unlink>
  unlink("12345678901234");
    2f12:	00004517          	auipc	a0,0x4
    2f16:	09650513          	addi	a0,a0,150 # 6fa8 <malloc+0x12aa>
    2f1a:	00003097          	auipc	ra,0x3
    2f1e:	a0c080e7          	jalr	-1524(ra) # 5926 <unlink>
}
    2f22:	60e2                	ld	ra,24(sp)
    2f24:	6442                	ld	s0,16(sp)
    2f26:	64a2                	ld	s1,8(sp)
    2f28:	6105                	addi	sp,sp,32
    2f2a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2f2c:	85a6                	mv	a1,s1
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	eaa50513          	addi	a0,a0,-342 # 6dd8 <malloc+0x10da>
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	d10080e7          	jalr	-752(ra) # 5c46 <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00003097          	auipc	ra,0x3
    2f44:	996080e7          	jalr	-1642(ra) # 58d6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2f48:	85a6                	mv	a1,s1
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	ed650513          	addi	a0,a0,-298 # 6e20 <malloc+0x1122>
    2f52:	00003097          	auipc	ra,0x3
    2f56:	cf4080e7          	jalr	-780(ra) # 5c46 <printf>
    exit(1);
    2f5a:	4505                	li	a0,1
    2f5c:	00003097          	auipc	ra,0x3
    2f60:	97a080e7          	jalr	-1670(ra) # 58d6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f64:	85a6                	mv	a1,s1
    2f66:	00004517          	auipc	a0,0x4
    2f6a:	f2250513          	addi	a0,a0,-222 # 6e88 <malloc+0x118a>
    2f6e:	00003097          	auipc	ra,0x3
    2f72:	cd8080e7          	jalr	-808(ra) # 5c46 <printf>
    exit(1);
    2f76:	4505                	li	a0,1
    2f78:	00003097          	auipc	ra,0x3
    2f7c:	95e080e7          	jalr	-1698(ra) # 58d6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f80:	85a6                	mv	a1,s1
    2f82:	00004517          	auipc	a0,0x4
    2f86:	f7e50513          	addi	a0,a0,-130 # 6f00 <malloc+0x1202>
    2f8a:	00003097          	auipc	ra,0x3
    2f8e:	cbc080e7          	jalr	-836(ra) # 5c46 <printf>
    exit(1);
    2f92:	4505                	li	a0,1
    2f94:	00003097          	auipc	ra,0x3
    2f98:	942080e7          	jalr	-1726(ra) # 58d6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f9c:	85a6                	mv	a1,s1
    2f9e:	00004517          	auipc	a0,0x4
    2fa2:	fc250513          	addi	a0,a0,-62 # 6f60 <malloc+0x1262>
    2fa6:	00003097          	auipc	ra,0x3
    2faa:	ca0080e7          	jalr	-864(ra) # 5c46 <printf>
    exit(1);
    2fae:	4505                	li	a0,1
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	926080e7          	jalr	-1754(ra) # 58d6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2fb8:	85a6                	mv	a1,s1
    2fba:	00004517          	auipc	a0,0x4
    2fbe:	ffe50513          	addi	a0,a0,-2 # 6fb8 <malloc+0x12ba>
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	c84080e7          	jalr	-892(ra) # 5c46 <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	00003097          	auipc	ra,0x3
    2fd0:	90a080e7          	jalr	-1782(ra) # 58d6 <exit>

0000000000002fd4 <iputtest>:
{
    2fd4:	1101                	addi	sp,sp,-32
    2fd6:	ec06                	sd	ra,24(sp)
    2fd8:	e822                	sd	s0,16(sp)
    2fda:	e426                	sd	s1,8(sp)
    2fdc:	1000                	addi	s0,sp,32
    2fde:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2fe0:	00004517          	auipc	a0,0x4
    2fe4:	01050513          	addi	a0,a0,16 # 6ff0 <malloc+0x12f2>
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	956080e7          	jalr	-1706(ra) # 593e <mkdir>
    2ff0:	04054563          	bltz	a0,303a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ff4:	00004517          	auipc	a0,0x4
    2ff8:	ffc50513          	addi	a0,a0,-4 # 6ff0 <malloc+0x12f2>
    2ffc:	00003097          	auipc	ra,0x3
    3000:	94a080e7          	jalr	-1718(ra) # 5946 <chdir>
    3004:	04054963          	bltz	a0,3056 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3008:	00004517          	auipc	a0,0x4
    300c:	02850513          	addi	a0,a0,40 # 7030 <malloc+0x1332>
    3010:	00003097          	auipc	ra,0x3
    3014:	916080e7          	jalr	-1770(ra) # 5926 <unlink>
    3018:	04054d63          	bltz	a0,3072 <iputtest+0x9e>
  if(chdir("/") < 0){
    301c:	00004517          	auipc	a0,0x4
    3020:	04450513          	addi	a0,a0,68 # 7060 <malloc+0x1362>
    3024:	00003097          	auipc	ra,0x3
    3028:	922080e7          	jalr	-1758(ra) # 5946 <chdir>
    302c:	06054163          	bltz	a0,308e <iputtest+0xba>
}
    3030:	60e2                	ld	ra,24(sp)
    3032:	6442                	ld	s0,16(sp)
    3034:	64a2                	ld	s1,8(sp)
    3036:	6105                	addi	sp,sp,32
    3038:	8082                	ret
    printf("%s: mkdir failed\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	fbc50513          	addi	a0,a0,-68 # 6ff8 <malloc+0x12fa>
    3044:	00003097          	auipc	ra,0x3
    3048:	c02080e7          	jalr	-1022(ra) # 5c46 <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00003097          	auipc	ra,0x3
    3052:	888080e7          	jalr	-1912(ra) # 58d6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3056:	85a6                	mv	a1,s1
    3058:	00004517          	auipc	a0,0x4
    305c:	fb850513          	addi	a0,a0,-72 # 7010 <malloc+0x1312>
    3060:	00003097          	auipc	ra,0x3
    3064:	be6080e7          	jalr	-1050(ra) # 5c46 <printf>
    exit(1);
    3068:	4505                	li	a0,1
    306a:	00003097          	auipc	ra,0x3
    306e:	86c080e7          	jalr	-1940(ra) # 58d6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3072:	85a6                	mv	a1,s1
    3074:	00004517          	auipc	a0,0x4
    3078:	fcc50513          	addi	a0,a0,-52 # 7040 <malloc+0x1342>
    307c:	00003097          	auipc	ra,0x3
    3080:	bca080e7          	jalr	-1078(ra) # 5c46 <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	00003097          	auipc	ra,0x3
    308a:	850080e7          	jalr	-1968(ra) # 58d6 <exit>
    printf("%s: chdir / failed\n", s);
    308e:	85a6                	mv	a1,s1
    3090:	00004517          	auipc	a0,0x4
    3094:	fd850513          	addi	a0,a0,-40 # 7068 <malloc+0x136a>
    3098:	00003097          	auipc	ra,0x3
    309c:	bae080e7          	jalr	-1106(ra) # 5c46 <printf>
    exit(1);
    30a0:	4505                	li	a0,1
    30a2:	00003097          	auipc	ra,0x3
    30a6:	834080e7          	jalr	-1996(ra) # 58d6 <exit>

00000000000030aa <exitiputtest>:
{
    30aa:	7179                	addi	sp,sp,-48
    30ac:	f406                	sd	ra,40(sp)
    30ae:	f022                	sd	s0,32(sp)
    30b0:	ec26                	sd	s1,24(sp)
    30b2:	1800                	addi	s0,sp,48
    30b4:	84aa                	mv	s1,a0
  pid = fork();
    30b6:	00003097          	auipc	ra,0x3
    30ba:	818080e7          	jalr	-2024(ra) # 58ce <fork>
  if(pid < 0){
    30be:	04054663          	bltz	a0,310a <exitiputtest+0x60>
  if(pid == 0){
    30c2:	ed45                	bnez	a0,317a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    30c4:	00004517          	auipc	a0,0x4
    30c8:	f2c50513          	addi	a0,a0,-212 # 6ff0 <malloc+0x12f2>
    30cc:	00003097          	auipc	ra,0x3
    30d0:	872080e7          	jalr	-1934(ra) # 593e <mkdir>
    30d4:	04054963          	bltz	a0,3126 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    30d8:	00004517          	auipc	a0,0x4
    30dc:	f1850513          	addi	a0,a0,-232 # 6ff0 <malloc+0x12f2>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	866080e7          	jalr	-1946(ra) # 5946 <chdir>
    30e8:	04054d63          	bltz	a0,3142 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    30ec:	00004517          	auipc	a0,0x4
    30f0:	f4450513          	addi	a0,a0,-188 # 7030 <malloc+0x1332>
    30f4:	00003097          	auipc	ra,0x3
    30f8:	832080e7          	jalr	-1998(ra) # 5926 <unlink>
    30fc:	06054163          	bltz	a0,315e <exitiputtest+0xb4>
    exit(0);
    3100:	4501                	li	a0,0
    3102:	00002097          	auipc	ra,0x2
    3106:	7d4080e7          	jalr	2004(ra) # 58d6 <exit>
    printf("%s: fork failed\n", s);
    310a:	85a6                	mv	a1,s1
    310c:	00003517          	auipc	a0,0x3
    3110:	58450513          	addi	a0,a0,1412 # 6690 <malloc+0x992>
    3114:	00003097          	auipc	ra,0x3
    3118:	b32080e7          	jalr	-1230(ra) # 5c46 <printf>
    exit(1);
    311c:	4505                	li	a0,1
    311e:	00002097          	auipc	ra,0x2
    3122:	7b8080e7          	jalr	1976(ra) # 58d6 <exit>
      printf("%s: mkdir failed\n", s);
    3126:	85a6                	mv	a1,s1
    3128:	00004517          	auipc	a0,0x4
    312c:	ed050513          	addi	a0,a0,-304 # 6ff8 <malloc+0x12fa>
    3130:	00003097          	auipc	ra,0x3
    3134:	b16080e7          	jalr	-1258(ra) # 5c46 <printf>
      exit(1);
    3138:	4505                	li	a0,1
    313a:	00002097          	auipc	ra,0x2
    313e:	79c080e7          	jalr	1948(ra) # 58d6 <exit>
      printf("%s: child chdir failed\n", s);
    3142:	85a6                	mv	a1,s1
    3144:	00004517          	auipc	a0,0x4
    3148:	f3c50513          	addi	a0,a0,-196 # 7080 <malloc+0x1382>
    314c:	00003097          	auipc	ra,0x3
    3150:	afa080e7          	jalr	-1286(ra) # 5c46 <printf>
      exit(1);
    3154:	4505                	li	a0,1
    3156:	00002097          	auipc	ra,0x2
    315a:	780080e7          	jalr	1920(ra) # 58d6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    315e:	85a6                	mv	a1,s1
    3160:	00004517          	auipc	a0,0x4
    3164:	ee050513          	addi	a0,a0,-288 # 7040 <malloc+0x1342>
    3168:	00003097          	auipc	ra,0x3
    316c:	ade080e7          	jalr	-1314(ra) # 5c46 <printf>
      exit(1);
    3170:	4505                	li	a0,1
    3172:	00002097          	auipc	ra,0x2
    3176:	764080e7          	jalr	1892(ra) # 58d6 <exit>
  wait(&xstatus);
    317a:	fdc40513          	addi	a0,s0,-36
    317e:	00002097          	auipc	ra,0x2
    3182:	760080e7          	jalr	1888(ra) # 58de <wait>
  exit(xstatus);
    3186:	fdc42503          	lw	a0,-36(s0)
    318a:	00002097          	auipc	ra,0x2
    318e:	74c080e7          	jalr	1868(ra) # 58d6 <exit>

0000000000003192 <dirtest>:
{
    3192:	1101                	addi	sp,sp,-32
    3194:	ec06                	sd	ra,24(sp)
    3196:	e822                	sd	s0,16(sp)
    3198:	e426                	sd	s1,8(sp)
    319a:	1000                	addi	s0,sp,32
    319c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    319e:	00004517          	auipc	a0,0x4
    31a2:	efa50513          	addi	a0,a0,-262 # 7098 <malloc+0x139a>
    31a6:	00002097          	auipc	ra,0x2
    31aa:	798080e7          	jalr	1944(ra) # 593e <mkdir>
    31ae:	04054563          	bltz	a0,31f8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    31b2:	00004517          	auipc	a0,0x4
    31b6:	ee650513          	addi	a0,a0,-282 # 7098 <malloc+0x139a>
    31ba:	00002097          	auipc	ra,0x2
    31be:	78c080e7          	jalr	1932(ra) # 5946 <chdir>
    31c2:	04054963          	bltz	a0,3214 <dirtest+0x82>
  if(chdir("..") < 0){
    31c6:	00004517          	auipc	a0,0x4
    31ca:	ef250513          	addi	a0,a0,-270 # 70b8 <malloc+0x13ba>
    31ce:	00002097          	auipc	ra,0x2
    31d2:	778080e7          	jalr	1912(ra) # 5946 <chdir>
    31d6:	04054d63          	bltz	a0,3230 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    31da:	00004517          	auipc	a0,0x4
    31de:	ebe50513          	addi	a0,a0,-322 # 7098 <malloc+0x139a>
    31e2:	00002097          	auipc	ra,0x2
    31e6:	744080e7          	jalr	1860(ra) # 5926 <unlink>
    31ea:	06054163          	bltz	a0,324c <dirtest+0xba>
}
    31ee:	60e2                	ld	ra,24(sp)
    31f0:	6442                	ld	s0,16(sp)
    31f2:	64a2                	ld	s1,8(sp)
    31f4:	6105                	addi	sp,sp,32
    31f6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    31f8:	85a6                	mv	a1,s1
    31fa:	00004517          	auipc	a0,0x4
    31fe:	dfe50513          	addi	a0,a0,-514 # 6ff8 <malloc+0x12fa>
    3202:	00003097          	auipc	ra,0x3
    3206:	a44080e7          	jalr	-1468(ra) # 5c46 <printf>
    exit(1);
    320a:	4505                	li	a0,1
    320c:	00002097          	auipc	ra,0x2
    3210:	6ca080e7          	jalr	1738(ra) # 58d6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3214:	85a6                	mv	a1,s1
    3216:	00004517          	auipc	a0,0x4
    321a:	e8a50513          	addi	a0,a0,-374 # 70a0 <malloc+0x13a2>
    321e:	00003097          	auipc	ra,0x3
    3222:	a28080e7          	jalr	-1496(ra) # 5c46 <printf>
    exit(1);
    3226:	4505                	li	a0,1
    3228:	00002097          	auipc	ra,0x2
    322c:	6ae080e7          	jalr	1710(ra) # 58d6 <exit>
    printf("%s: chdir .. failed\n", s);
    3230:	85a6                	mv	a1,s1
    3232:	00004517          	auipc	a0,0x4
    3236:	e8e50513          	addi	a0,a0,-370 # 70c0 <malloc+0x13c2>
    323a:	00003097          	auipc	ra,0x3
    323e:	a0c080e7          	jalr	-1524(ra) # 5c46 <printf>
    exit(1);
    3242:	4505                	li	a0,1
    3244:	00002097          	auipc	ra,0x2
    3248:	692080e7          	jalr	1682(ra) # 58d6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    324c:	85a6                	mv	a1,s1
    324e:	00004517          	auipc	a0,0x4
    3252:	e8a50513          	addi	a0,a0,-374 # 70d8 <malloc+0x13da>
    3256:	00003097          	auipc	ra,0x3
    325a:	9f0080e7          	jalr	-1552(ra) # 5c46 <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	00002097          	auipc	ra,0x2
    3264:	676080e7          	jalr	1654(ra) # 58d6 <exit>

0000000000003268 <subdir>:
{
    3268:	1101                	addi	sp,sp,-32
    326a:	ec06                	sd	ra,24(sp)
    326c:	e822                	sd	s0,16(sp)
    326e:	e426                	sd	s1,8(sp)
    3270:	e04a                	sd	s2,0(sp)
    3272:	1000                	addi	s0,sp,32
    3274:	892a                	mv	s2,a0
  unlink("ff");
    3276:	00004517          	auipc	a0,0x4
    327a:	faa50513          	addi	a0,a0,-86 # 7220 <malloc+0x1522>
    327e:	00002097          	auipc	ra,0x2
    3282:	6a8080e7          	jalr	1704(ra) # 5926 <unlink>
  if(mkdir("dd") != 0){
    3286:	00004517          	auipc	a0,0x4
    328a:	e6a50513          	addi	a0,a0,-406 # 70f0 <malloc+0x13f2>
    328e:	00002097          	auipc	ra,0x2
    3292:	6b0080e7          	jalr	1712(ra) # 593e <mkdir>
    3296:	38051663          	bnez	a0,3622 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    329a:	20200593          	li	a1,514
    329e:	00004517          	auipc	a0,0x4
    32a2:	e7250513          	addi	a0,a0,-398 # 7110 <malloc+0x1412>
    32a6:	00002097          	auipc	ra,0x2
    32aa:	670080e7          	jalr	1648(ra) # 5916 <open>
    32ae:	84aa                	mv	s1,a0
  if(fd < 0){
    32b0:	38054763          	bltz	a0,363e <subdir+0x3d6>
  write(fd, "ff", 2);
    32b4:	4609                	li	a2,2
    32b6:	00004597          	auipc	a1,0x4
    32ba:	f6a58593          	addi	a1,a1,-150 # 7220 <malloc+0x1522>
    32be:	00002097          	auipc	ra,0x2
    32c2:	638080e7          	jalr	1592(ra) # 58f6 <write>
  close(fd);
    32c6:	8526                	mv	a0,s1
    32c8:	00002097          	auipc	ra,0x2
    32cc:	636080e7          	jalr	1590(ra) # 58fe <close>
  if(unlink("dd") >= 0){
    32d0:	00004517          	auipc	a0,0x4
    32d4:	e2050513          	addi	a0,a0,-480 # 70f0 <malloc+0x13f2>
    32d8:	00002097          	auipc	ra,0x2
    32dc:	64e080e7          	jalr	1614(ra) # 5926 <unlink>
    32e0:	36055d63          	bgez	a0,365a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    32e4:	00004517          	auipc	a0,0x4
    32e8:	e8450513          	addi	a0,a0,-380 # 7168 <malloc+0x146a>
    32ec:	00002097          	auipc	ra,0x2
    32f0:	652080e7          	jalr	1618(ra) # 593e <mkdir>
    32f4:	38051163          	bnez	a0,3676 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    32f8:	20200593          	li	a1,514
    32fc:	00004517          	auipc	a0,0x4
    3300:	e9450513          	addi	a0,a0,-364 # 7190 <malloc+0x1492>
    3304:	00002097          	auipc	ra,0x2
    3308:	612080e7          	jalr	1554(ra) # 5916 <open>
    330c:	84aa                	mv	s1,a0
  if(fd < 0){
    330e:	38054263          	bltz	a0,3692 <subdir+0x42a>
  write(fd, "FF", 2);
    3312:	4609                	li	a2,2
    3314:	00004597          	auipc	a1,0x4
    3318:	eac58593          	addi	a1,a1,-340 # 71c0 <malloc+0x14c2>
    331c:	00002097          	auipc	ra,0x2
    3320:	5da080e7          	jalr	1498(ra) # 58f6 <write>
  close(fd);
    3324:	8526                	mv	a0,s1
    3326:	00002097          	auipc	ra,0x2
    332a:	5d8080e7          	jalr	1496(ra) # 58fe <close>
  fd = open("dd/dd/../ff", 0);
    332e:	4581                	li	a1,0
    3330:	00004517          	auipc	a0,0x4
    3334:	e9850513          	addi	a0,a0,-360 # 71c8 <malloc+0x14ca>
    3338:	00002097          	auipc	ra,0x2
    333c:	5de080e7          	jalr	1502(ra) # 5916 <open>
    3340:	84aa                	mv	s1,a0
  if(fd < 0){
    3342:	36054663          	bltz	a0,36ae <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3346:	660d                	lui	a2,0x3
    3348:	0000a597          	auipc	a1,0xa
    334c:	d9058593          	addi	a1,a1,-624 # d0d8 <buf>
    3350:	00002097          	auipc	ra,0x2
    3354:	59e080e7          	jalr	1438(ra) # 58ee <read>
  if(cc != 2 || buf[0] != 'f'){
    3358:	4789                	li	a5,2
    335a:	36f51863          	bne	a0,a5,36ca <subdir+0x462>
    335e:	0000a717          	auipc	a4,0xa
    3362:	d7a74703          	lbu	a4,-646(a4) # d0d8 <buf>
    3366:	06600793          	li	a5,102
    336a:	36f71063          	bne	a4,a5,36ca <subdir+0x462>
  close(fd);
    336e:	8526                	mv	a0,s1
    3370:	00002097          	auipc	ra,0x2
    3374:	58e080e7          	jalr	1422(ra) # 58fe <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3378:	00004597          	auipc	a1,0x4
    337c:	ea058593          	addi	a1,a1,-352 # 7218 <malloc+0x151a>
    3380:	00004517          	auipc	a0,0x4
    3384:	e1050513          	addi	a0,a0,-496 # 7190 <malloc+0x1492>
    3388:	00002097          	auipc	ra,0x2
    338c:	5ae080e7          	jalr	1454(ra) # 5936 <link>
    3390:	34051b63          	bnez	a0,36e6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3394:	00004517          	auipc	a0,0x4
    3398:	dfc50513          	addi	a0,a0,-516 # 7190 <malloc+0x1492>
    339c:	00002097          	auipc	ra,0x2
    33a0:	58a080e7          	jalr	1418(ra) # 5926 <unlink>
    33a4:	34051f63          	bnez	a0,3702 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    33a8:	4581                	li	a1,0
    33aa:	00004517          	auipc	a0,0x4
    33ae:	de650513          	addi	a0,a0,-538 # 7190 <malloc+0x1492>
    33b2:	00002097          	auipc	ra,0x2
    33b6:	564080e7          	jalr	1380(ra) # 5916 <open>
    33ba:	36055263          	bgez	a0,371e <subdir+0x4b6>
  if(chdir("dd") != 0){
    33be:	00004517          	auipc	a0,0x4
    33c2:	d3250513          	addi	a0,a0,-718 # 70f0 <malloc+0x13f2>
    33c6:	00002097          	auipc	ra,0x2
    33ca:	580080e7          	jalr	1408(ra) # 5946 <chdir>
    33ce:	36051663          	bnez	a0,373a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    33d2:	00004517          	auipc	a0,0x4
    33d6:	ede50513          	addi	a0,a0,-290 # 72b0 <malloc+0x15b2>
    33da:	00002097          	auipc	ra,0x2
    33de:	56c080e7          	jalr	1388(ra) # 5946 <chdir>
    33e2:	36051a63          	bnez	a0,3756 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    33e6:	00004517          	auipc	a0,0x4
    33ea:	efa50513          	addi	a0,a0,-262 # 72e0 <malloc+0x15e2>
    33ee:	00002097          	auipc	ra,0x2
    33f2:	558080e7          	jalr	1368(ra) # 5946 <chdir>
    33f6:	36051e63          	bnez	a0,3772 <subdir+0x50a>
  if(chdir("./..") != 0){
    33fa:	00004517          	auipc	a0,0x4
    33fe:	f1650513          	addi	a0,a0,-234 # 7310 <malloc+0x1612>
    3402:	00002097          	auipc	ra,0x2
    3406:	544080e7          	jalr	1348(ra) # 5946 <chdir>
    340a:	38051263          	bnez	a0,378e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    340e:	4581                	li	a1,0
    3410:	00004517          	auipc	a0,0x4
    3414:	e0850513          	addi	a0,a0,-504 # 7218 <malloc+0x151a>
    3418:	00002097          	auipc	ra,0x2
    341c:	4fe080e7          	jalr	1278(ra) # 5916 <open>
    3420:	84aa                	mv	s1,a0
  if(fd < 0){
    3422:	38054463          	bltz	a0,37aa <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3426:	660d                	lui	a2,0x3
    3428:	0000a597          	auipc	a1,0xa
    342c:	cb058593          	addi	a1,a1,-848 # d0d8 <buf>
    3430:	00002097          	auipc	ra,0x2
    3434:	4be080e7          	jalr	1214(ra) # 58ee <read>
    3438:	4789                	li	a5,2
    343a:	38f51663          	bne	a0,a5,37c6 <subdir+0x55e>
  close(fd);
    343e:	8526                	mv	a0,s1
    3440:	00002097          	auipc	ra,0x2
    3444:	4be080e7          	jalr	1214(ra) # 58fe <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3448:	4581                	li	a1,0
    344a:	00004517          	auipc	a0,0x4
    344e:	d4650513          	addi	a0,a0,-698 # 7190 <malloc+0x1492>
    3452:	00002097          	auipc	ra,0x2
    3456:	4c4080e7          	jalr	1220(ra) # 5916 <open>
    345a:	38055463          	bgez	a0,37e2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    345e:	20200593          	li	a1,514
    3462:	00004517          	auipc	a0,0x4
    3466:	f3e50513          	addi	a0,a0,-194 # 73a0 <malloc+0x16a2>
    346a:	00002097          	auipc	ra,0x2
    346e:	4ac080e7          	jalr	1196(ra) # 5916 <open>
    3472:	38055663          	bgez	a0,37fe <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3476:	20200593          	li	a1,514
    347a:	00004517          	auipc	a0,0x4
    347e:	f5650513          	addi	a0,a0,-170 # 73d0 <malloc+0x16d2>
    3482:	00002097          	auipc	ra,0x2
    3486:	494080e7          	jalr	1172(ra) # 5916 <open>
    348a:	38055863          	bgez	a0,381a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    348e:	20000593          	li	a1,512
    3492:	00004517          	auipc	a0,0x4
    3496:	c5e50513          	addi	a0,a0,-930 # 70f0 <malloc+0x13f2>
    349a:	00002097          	auipc	ra,0x2
    349e:	47c080e7          	jalr	1148(ra) # 5916 <open>
    34a2:	38055a63          	bgez	a0,3836 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    34a6:	4589                	li	a1,2
    34a8:	00004517          	auipc	a0,0x4
    34ac:	c4850513          	addi	a0,a0,-952 # 70f0 <malloc+0x13f2>
    34b0:	00002097          	auipc	ra,0x2
    34b4:	466080e7          	jalr	1126(ra) # 5916 <open>
    34b8:	38055d63          	bgez	a0,3852 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    34bc:	4585                	li	a1,1
    34be:	00004517          	auipc	a0,0x4
    34c2:	c3250513          	addi	a0,a0,-974 # 70f0 <malloc+0x13f2>
    34c6:	00002097          	auipc	ra,0x2
    34ca:	450080e7          	jalr	1104(ra) # 5916 <open>
    34ce:	3a055063          	bgez	a0,386e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    34d2:	00004597          	auipc	a1,0x4
    34d6:	f8e58593          	addi	a1,a1,-114 # 7460 <malloc+0x1762>
    34da:	00004517          	auipc	a0,0x4
    34de:	ec650513          	addi	a0,a0,-314 # 73a0 <malloc+0x16a2>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	454080e7          	jalr	1108(ra) # 5936 <link>
    34ea:	3a050063          	beqz	a0,388a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    34ee:	00004597          	auipc	a1,0x4
    34f2:	f7258593          	addi	a1,a1,-142 # 7460 <malloc+0x1762>
    34f6:	00004517          	auipc	a0,0x4
    34fa:	eda50513          	addi	a0,a0,-294 # 73d0 <malloc+0x16d2>
    34fe:	00002097          	auipc	ra,0x2
    3502:	438080e7          	jalr	1080(ra) # 5936 <link>
    3506:	3a050063          	beqz	a0,38a6 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    350a:	00004597          	auipc	a1,0x4
    350e:	d0e58593          	addi	a1,a1,-754 # 7218 <malloc+0x151a>
    3512:	00004517          	auipc	a0,0x4
    3516:	bfe50513          	addi	a0,a0,-1026 # 7110 <malloc+0x1412>
    351a:	00002097          	auipc	ra,0x2
    351e:	41c080e7          	jalr	1052(ra) # 5936 <link>
    3522:	3a050063          	beqz	a0,38c2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3526:	00004517          	auipc	a0,0x4
    352a:	e7a50513          	addi	a0,a0,-390 # 73a0 <malloc+0x16a2>
    352e:	00002097          	auipc	ra,0x2
    3532:	410080e7          	jalr	1040(ra) # 593e <mkdir>
    3536:	3a050463          	beqz	a0,38de <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    353a:	00004517          	auipc	a0,0x4
    353e:	e9650513          	addi	a0,a0,-362 # 73d0 <malloc+0x16d2>
    3542:	00002097          	auipc	ra,0x2
    3546:	3fc080e7          	jalr	1020(ra) # 593e <mkdir>
    354a:	3a050863          	beqz	a0,38fa <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    354e:	00004517          	auipc	a0,0x4
    3552:	cca50513          	addi	a0,a0,-822 # 7218 <malloc+0x151a>
    3556:	00002097          	auipc	ra,0x2
    355a:	3e8080e7          	jalr	1000(ra) # 593e <mkdir>
    355e:	3a050c63          	beqz	a0,3916 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3562:	00004517          	auipc	a0,0x4
    3566:	e6e50513          	addi	a0,a0,-402 # 73d0 <malloc+0x16d2>
    356a:	00002097          	auipc	ra,0x2
    356e:	3bc080e7          	jalr	956(ra) # 5926 <unlink>
    3572:	3c050063          	beqz	a0,3932 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3576:	00004517          	auipc	a0,0x4
    357a:	e2a50513          	addi	a0,a0,-470 # 73a0 <malloc+0x16a2>
    357e:	00002097          	auipc	ra,0x2
    3582:	3a8080e7          	jalr	936(ra) # 5926 <unlink>
    3586:	3c050463          	beqz	a0,394e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    358a:	00004517          	auipc	a0,0x4
    358e:	b8650513          	addi	a0,a0,-1146 # 7110 <malloc+0x1412>
    3592:	00002097          	auipc	ra,0x2
    3596:	3b4080e7          	jalr	948(ra) # 5946 <chdir>
    359a:	3c050863          	beqz	a0,396a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    359e:	00004517          	auipc	a0,0x4
    35a2:	01250513          	addi	a0,a0,18 # 75b0 <malloc+0x18b2>
    35a6:	00002097          	auipc	ra,0x2
    35aa:	3a0080e7          	jalr	928(ra) # 5946 <chdir>
    35ae:	3c050c63          	beqz	a0,3986 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    35b2:	00004517          	auipc	a0,0x4
    35b6:	c6650513          	addi	a0,a0,-922 # 7218 <malloc+0x151a>
    35ba:	00002097          	auipc	ra,0x2
    35be:	36c080e7          	jalr	876(ra) # 5926 <unlink>
    35c2:	3e051063          	bnez	a0,39a2 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    35c6:	00004517          	auipc	a0,0x4
    35ca:	b4a50513          	addi	a0,a0,-1206 # 7110 <malloc+0x1412>
    35ce:	00002097          	auipc	ra,0x2
    35d2:	358080e7          	jalr	856(ra) # 5926 <unlink>
    35d6:	3e051463          	bnez	a0,39be <subdir+0x756>
  if(unlink("dd") == 0){
    35da:	00004517          	auipc	a0,0x4
    35de:	b1650513          	addi	a0,a0,-1258 # 70f0 <malloc+0x13f2>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	344080e7          	jalr	836(ra) # 5926 <unlink>
    35ea:	3e050863          	beqz	a0,39da <subdir+0x772>
  if(unlink("dd/dd") < 0){
    35ee:	00004517          	auipc	a0,0x4
    35f2:	03250513          	addi	a0,a0,50 # 7620 <malloc+0x1922>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	330080e7          	jalr	816(ra) # 5926 <unlink>
    35fe:	3e054c63          	bltz	a0,39f6 <subdir+0x78e>
  if(unlink("dd") < 0){
    3602:	00004517          	auipc	a0,0x4
    3606:	aee50513          	addi	a0,a0,-1298 # 70f0 <malloc+0x13f2>
    360a:	00002097          	auipc	ra,0x2
    360e:	31c080e7          	jalr	796(ra) # 5926 <unlink>
    3612:	40054063          	bltz	a0,3a12 <subdir+0x7aa>
}
    3616:	60e2                	ld	ra,24(sp)
    3618:	6442                	ld	s0,16(sp)
    361a:	64a2                	ld	s1,8(sp)
    361c:	6902                	ld	s2,0(sp)
    361e:	6105                	addi	sp,sp,32
    3620:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3622:	85ca                	mv	a1,s2
    3624:	00004517          	auipc	a0,0x4
    3628:	ad450513          	addi	a0,a0,-1324 # 70f8 <malloc+0x13fa>
    362c:	00002097          	auipc	ra,0x2
    3630:	61a080e7          	jalr	1562(ra) # 5c46 <printf>
    exit(1);
    3634:	4505                	li	a0,1
    3636:	00002097          	auipc	ra,0x2
    363a:	2a0080e7          	jalr	672(ra) # 58d6 <exit>
    printf("%s: create dd/ff failed\n", s);
    363e:	85ca                	mv	a1,s2
    3640:	00004517          	auipc	a0,0x4
    3644:	ad850513          	addi	a0,a0,-1320 # 7118 <malloc+0x141a>
    3648:	00002097          	auipc	ra,0x2
    364c:	5fe080e7          	jalr	1534(ra) # 5c46 <printf>
    exit(1);
    3650:	4505                	li	a0,1
    3652:	00002097          	auipc	ra,0x2
    3656:	284080e7          	jalr	644(ra) # 58d6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    365a:	85ca                	mv	a1,s2
    365c:	00004517          	auipc	a0,0x4
    3660:	adc50513          	addi	a0,a0,-1316 # 7138 <malloc+0x143a>
    3664:	00002097          	auipc	ra,0x2
    3668:	5e2080e7          	jalr	1506(ra) # 5c46 <printf>
    exit(1);
    366c:	4505                	li	a0,1
    366e:	00002097          	auipc	ra,0x2
    3672:	268080e7          	jalr	616(ra) # 58d6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3676:	85ca                	mv	a1,s2
    3678:	00004517          	auipc	a0,0x4
    367c:	af850513          	addi	a0,a0,-1288 # 7170 <malloc+0x1472>
    3680:	00002097          	auipc	ra,0x2
    3684:	5c6080e7          	jalr	1478(ra) # 5c46 <printf>
    exit(1);
    3688:	4505                	li	a0,1
    368a:	00002097          	auipc	ra,0x2
    368e:	24c080e7          	jalr	588(ra) # 58d6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3692:	85ca                	mv	a1,s2
    3694:	00004517          	auipc	a0,0x4
    3698:	b0c50513          	addi	a0,a0,-1268 # 71a0 <malloc+0x14a2>
    369c:	00002097          	auipc	ra,0x2
    36a0:	5aa080e7          	jalr	1450(ra) # 5c46 <printf>
    exit(1);
    36a4:	4505                	li	a0,1
    36a6:	00002097          	auipc	ra,0x2
    36aa:	230080e7          	jalr	560(ra) # 58d6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    36ae:	85ca                	mv	a1,s2
    36b0:	00004517          	auipc	a0,0x4
    36b4:	b2850513          	addi	a0,a0,-1240 # 71d8 <malloc+0x14da>
    36b8:	00002097          	auipc	ra,0x2
    36bc:	58e080e7          	jalr	1422(ra) # 5c46 <printf>
    exit(1);
    36c0:	4505                	li	a0,1
    36c2:	00002097          	auipc	ra,0x2
    36c6:	214080e7          	jalr	532(ra) # 58d6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    36ca:	85ca                	mv	a1,s2
    36cc:	00004517          	auipc	a0,0x4
    36d0:	b2c50513          	addi	a0,a0,-1236 # 71f8 <malloc+0x14fa>
    36d4:	00002097          	auipc	ra,0x2
    36d8:	572080e7          	jalr	1394(ra) # 5c46 <printf>
    exit(1);
    36dc:	4505                	li	a0,1
    36de:	00002097          	auipc	ra,0x2
    36e2:	1f8080e7          	jalr	504(ra) # 58d6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    36e6:	85ca                	mv	a1,s2
    36e8:	00004517          	auipc	a0,0x4
    36ec:	b4050513          	addi	a0,a0,-1216 # 7228 <malloc+0x152a>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	556080e7          	jalr	1366(ra) # 5c46 <printf>
    exit(1);
    36f8:	4505                	li	a0,1
    36fa:	00002097          	auipc	ra,0x2
    36fe:	1dc080e7          	jalr	476(ra) # 58d6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3702:	85ca                	mv	a1,s2
    3704:	00004517          	auipc	a0,0x4
    3708:	b4c50513          	addi	a0,a0,-1204 # 7250 <malloc+0x1552>
    370c:	00002097          	auipc	ra,0x2
    3710:	53a080e7          	jalr	1338(ra) # 5c46 <printf>
    exit(1);
    3714:	4505                	li	a0,1
    3716:	00002097          	auipc	ra,0x2
    371a:	1c0080e7          	jalr	448(ra) # 58d6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    371e:	85ca                	mv	a1,s2
    3720:	00004517          	auipc	a0,0x4
    3724:	b5050513          	addi	a0,a0,-1200 # 7270 <malloc+0x1572>
    3728:	00002097          	auipc	ra,0x2
    372c:	51e080e7          	jalr	1310(ra) # 5c46 <printf>
    exit(1);
    3730:	4505                	li	a0,1
    3732:	00002097          	auipc	ra,0x2
    3736:	1a4080e7          	jalr	420(ra) # 58d6 <exit>
    printf("%s: chdir dd failed\n", s);
    373a:	85ca                	mv	a1,s2
    373c:	00004517          	auipc	a0,0x4
    3740:	b5c50513          	addi	a0,a0,-1188 # 7298 <malloc+0x159a>
    3744:	00002097          	auipc	ra,0x2
    3748:	502080e7          	jalr	1282(ra) # 5c46 <printf>
    exit(1);
    374c:	4505                	li	a0,1
    374e:	00002097          	auipc	ra,0x2
    3752:	188080e7          	jalr	392(ra) # 58d6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3756:	85ca                	mv	a1,s2
    3758:	00004517          	auipc	a0,0x4
    375c:	b6850513          	addi	a0,a0,-1176 # 72c0 <malloc+0x15c2>
    3760:	00002097          	auipc	ra,0x2
    3764:	4e6080e7          	jalr	1254(ra) # 5c46 <printf>
    exit(1);
    3768:	4505                	li	a0,1
    376a:	00002097          	auipc	ra,0x2
    376e:	16c080e7          	jalr	364(ra) # 58d6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3772:	85ca                	mv	a1,s2
    3774:	00004517          	auipc	a0,0x4
    3778:	b7c50513          	addi	a0,a0,-1156 # 72f0 <malloc+0x15f2>
    377c:	00002097          	auipc	ra,0x2
    3780:	4ca080e7          	jalr	1226(ra) # 5c46 <printf>
    exit(1);
    3784:	4505                	li	a0,1
    3786:	00002097          	auipc	ra,0x2
    378a:	150080e7          	jalr	336(ra) # 58d6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    378e:	85ca                	mv	a1,s2
    3790:	00004517          	auipc	a0,0x4
    3794:	b8850513          	addi	a0,a0,-1144 # 7318 <malloc+0x161a>
    3798:	00002097          	auipc	ra,0x2
    379c:	4ae080e7          	jalr	1198(ra) # 5c46 <printf>
    exit(1);
    37a0:	4505                	li	a0,1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	134080e7          	jalr	308(ra) # 58d6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    37aa:	85ca                	mv	a1,s2
    37ac:	00004517          	auipc	a0,0x4
    37b0:	b8450513          	addi	a0,a0,-1148 # 7330 <malloc+0x1632>
    37b4:	00002097          	auipc	ra,0x2
    37b8:	492080e7          	jalr	1170(ra) # 5c46 <printf>
    exit(1);
    37bc:	4505                	li	a0,1
    37be:	00002097          	auipc	ra,0x2
    37c2:	118080e7          	jalr	280(ra) # 58d6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    37c6:	85ca                	mv	a1,s2
    37c8:	00004517          	auipc	a0,0x4
    37cc:	b8850513          	addi	a0,a0,-1144 # 7350 <malloc+0x1652>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	476080e7          	jalr	1142(ra) # 5c46 <printf>
    exit(1);
    37d8:	4505                	li	a0,1
    37da:	00002097          	auipc	ra,0x2
    37de:	0fc080e7          	jalr	252(ra) # 58d6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    37e2:	85ca                	mv	a1,s2
    37e4:	00004517          	auipc	a0,0x4
    37e8:	b8c50513          	addi	a0,a0,-1140 # 7370 <malloc+0x1672>
    37ec:	00002097          	auipc	ra,0x2
    37f0:	45a080e7          	jalr	1114(ra) # 5c46 <printf>
    exit(1);
    37f4:	4505                	li	a0,1
    37f6:	00002097          	auipc	ra,0x2
    37fa:	0e0080e7          	jalr	224(ra) # 58d6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    37fe:	85ca                	mv	a1,s2
    3800:	00004517          	auipc	a0,0x4
    3804:	bb050513          	addi	a0,a0,-1104 # 73b0 <malloc+0x16b2>
    3808:	00002097          	auipc	ra,0x2
    380c:	43e080e7          	jalr	1086(ra) # 5c46 <printf>
    exit(1);
    3810:	4505                	li	a0,1
    3812:	00002097          	auipc	ra,0x2
    3816:	0c4080e7          	jalr	196(ra) # 58d6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    381a:	85ca                	mv	a1,s2
    381c:	00004517          	auipc	a0,0x4
    3820:	bc450513          	addi	a0,a0,-1084 # 73e0 <malloc+0x16e2>
    3824:	00002097          	auipc	ra,0x2
    3828:	422080e7          	jalr	1058(ra) # 5c46 <printf>
    exit(1);
    382c:	4505                	li	a0,1
    382e:	00002097          	auipc	ra,0x2
    3832:	0a8080e7          	jalr	168(ra) # 58d6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3836:	85ca                	mv	a1,s2
    3838:	00004517          	auipc	a0,0x4
    383c:	bc850513          	addi	a0,a0,-1080 # 7400 <malloc+0x1702>
    3840:	00002097          	auipc	ra,0x2
    3844:	406080e7          	jalr	1030(ra) # 5c46 <printf>
    exit(1);
    3848:	4505                	li	a0,1
    384a:	00002097          	auipc	ra,0x2
    384e:	08c080e7          	jalr	140(ra) # 58d6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3852:	85ca                	mv	a1,s2
    3854:	00004517          	auipc	a0,0x4
    3858:	bcc50513          	addi	a0,a0,-1076 # 7420 <malloc+0x1722>
    385c:	00002097          	auipc	ra,0x2
    3860:	3ea080e7          	jalr	1002(ra) # 5c46 <printf>
    exit(1);
    3864:	4505                	li	a0,1
    3866:	00002097          	auipc	ra,0x2
    386a:	070080e7          	jalr	112(ra) # 58d6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    386e:	85ca                	mv	a1,s2
    3870:	00004517          	auipc	a0,0x4
    3874:	bd050513          	addi	a0,a0,-1072 # 7440 <malloc+0x1742>
    3878:	00002097          	auipc	ra,0x2
    387c:	3ce080e7          	jalr	974(ra) # 5c46 <printf>
    exit(1);
    3880:	4505                	li	a0,1
    3882:	00002097          	auipc	ra,0x2
    3886:	054080e7          	jalr	84(ra) # 58d6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    388a:	85ca                	mv	a1,s2
    388c:	00004517          	auipc	a0,0x4
    3890:	be450513          	addi	a0,a0,-1052 # 7470 <malloc+0x1772>
    3894:	00002097          	auipc	ra,0x2
    3898:	3b2080e7          	jalr	946(ra) # 5c46 <printf>
    exit(1);
    389c:	4505                	li	a0,1
    389e:	00002097          	auipc	ra,0x2
    38a2:	038080e7          	jalr	56(ra) # 58d6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    38a6:	85ca                	mv	a1,s2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	bf050513          	addi	a0,a0,-1040 # 7498 <malloc+0x179a>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	396080e7          	jalr	918(ra) # 5c46 <printf>
    exit(1);
    38b8:	4505                	li	a0,1
    38ba:	00002097          	auipc	ra,0x2
    38be:	01c080e7          	jalr	28(ra) # 58d6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	bfc50513          	addi	a0,a0,-1028 # 74c0 <malloc+0x17c2>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	37a080e7          	jalr	890(ra) # 5c46 <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	000080e7          	jalr	ra # 58d6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    38de:	85ca                	mv	a1,s2
    38e0:	00004517          	auipc	a0,0x4
    38e4:	c0850513          	addi	a0,a0,-1016 # 74e8 <malloc+0x17ea>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	35e080e7          	jalr	862(ra) # 5c46 <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	fe4080e7          	jalr	-28(ra) # 58d6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    38fa:	85ca                	mv	a1,s2
    38fc:	00004517          	auipc	a0,0x4
    3900:	c0c50513          	addi	a0,a0,-1012 # 7508 <malloc+0x180a>
    3904:	00002097          	auipc	ra,0x2
    3908:	342080e7          	jalr	834(ra) # 5c46 <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	fc8080e7          	jalr	-56(ra) # 58d6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3916:	85ca                	mv	a1,s2
    3918:	00004517          	auipc	a0,0x4
    391c:	c1050513          	addi	a0,a0,-1008 # 7528 <malloc+0x182a>
    3920:	00002097          	auipc	ra,0x2
    3924:	326080e7          	jalr	806(ra) # 5c46 <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	fac080e7          	jalr	-84(ra) # 58d6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3932:	85ca                	mv	a1,s2
    3934:	00004517          	auipc	a0,0x4
    3938:	c1c50513          	addi	a0,a0,-996 # 7550 <malloc+0x1852>
    393c:	00002097          	auipc	ra,0x2
    3940:	30a080e7          	jalr	778(ra) # 5c46 <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	f90080e7          	jalr	-112(ra) # 58d6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    394e:	85ca                	mv	a1,s2
    3950:	00004517          	auipc	a0,0x4
    3954:	c2050513          	addi	a0,a0,-992 # 7570 <malloc+0x1872>
    3958:	00002097          	auipc	ra,0x2
    395c:	2ee080e7          	jalr	750(ra) # 5c46 <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	f74080e7          	jalr	-140(ra) # 58d6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    396a:	85ca                	mv	a1,s2
    396c:	00004517          	auipc	a0,0x4
    3970:	c2450513          	addi	a0,a0,-988 # 7590 <malloc+0x1892>
    3974:	00002097          	auipc	ra,0x2
    3978:	2d2080e7          	jalr	722(ra) # 5c46 <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	f58080e7          	jalr	-168(ra) # 58d6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3986:	85ca                	mv	a1,s2
    3988:	00004517          	auipc	a0,0x4
    398c:	c3050513          	addi	a0,a0,-976 # 75b8 <malloc+0x18ba>
    3990:	00002097          	auipc	ra,0x2
    3994:	2b6080e7          	jalr	694(ra) # 5c46 <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	f3c080e7          	jalr	-196(ra) # 58d6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    39a2:	85ca                	mv	a1,s2
    39a4:	00004517          	auipc	a0,0x4
    39a8:	8ac50513          	addi	a0,a0,-1876 # 7250 <malloc+0x1552>
    39ac:	00002097          	auipc	ra,0x2
    39b0:	29a080e7          	jalr	666(ra) # 5c46 <printf>
    exit(1);
    39b4:	4505                	li	a0,1
    39b6:	00002097          	auipc	ra,0x2
    39ba:	f20080e7          	jalr	-224(ra) # 58d6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    39be:	85ca                	mv	a1,s2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	c1850513          	addi	a0,a0,-1000 # 75d8 <malloc+0x18da>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	27e080e7          	jalr	638(ra) # 5c46 <printf>
    exit(1);
    39d0:	4505                	li	a0,1
    39d2:	00002097          	auipc	ra,0x2
    39d6:	f04080e7          	jalr	-252(ra) # 58d6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    39da:	85ca                	mv	a1,s2
    39dc:	00004517          	auipc	a0,0x4
    39e0:	c1c50513          	addi	a0,a0,-996 # 75f8 <malloc+0x18fa>
    39e4:	00002097          	auipc	ra,0x2
    39e8:	262080e7          	jalr	610(ra) # 5c46 <printf>
    exit(1);
    39ec:	4505                	li	a0,1
    39ee:	00002097          	auipc	ra,0x2
    39f2:	ee8080e7          	jalr	-280(ra) # 58d6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    39f6:	85ca                	mv	a1,s2
    39f8:	00004517          	auipc	a0,0x4
    39fc:	c3050513          	addi	a0,a0,-976 # 7628 <malloc+0x192a>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	246080e7          	jalr	582(ra) # 5c46 <printf>
    exit(1);
    3a08:	4505                	li	a0,1
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	ecc080e7          	jalr	-308(ra) # 58d6 <exit>
    printf("%s: unlink dd failed\n", s);
    3a12:	85ca                	mv	a1,s2
    3a14:	00004517          	auipc	a0,0x4
    3a18:	c3450513          	addi	a0,a0,-972 # 7648 <malloc+0x194a>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	22a080e7          	jalr	554(ra) # 5c46 <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	eb0080e7          	jalr	-336(ra) # 58d6 <exit>

0000000000003a2e <rmdot>:
{
    3a2e:	1101                	addi	sp,sp,-32
    3a30:	ec06                	sd	ra,24(sp)
    3a32:	e822                	sd	s0,16(sp)
    3a34:	e426                	sd	s1,8(sp)
    3a36:	1000                	addi	s0,sp,32
    3a38:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3a3a:	00004517          	auipc	a0,0x4
    3a3e:	c2650513          	addi	a0,a0,-986 # 7660 <malloc+0x1962>
    3a42:	00002097          	auipc	ra,0x2
    3a46:	efc080e7          	jalr	-260(ra) # 593e <mkdir>
    3a4a:	e549                	bnez	a0,3ad4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3a4c:	00004517          	auipc	a0,0x4
    3a50:	c1450513          	addi	a0,a0,-1004 # 7660 <malloc+0x1962>
    3a54:	00002097          	auipc	ra,0x2
    3a58:	ef2080e7          	jalr	-270(ra) # 5946 <chdir>
    3a5c:	e951                	bnez	a0,3af0 <rmdot+0xc2>
  if(unlink(".") == 0){
    3a5e:	00003517          	auipc	a0,0x3
    3a62:	a9250513          	addi	a0,a0,-1390 # 64f0 <malloc+0x7f2>
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	ec0080e7          	jalr	-320(ra) # 5926 <unlink>
    3a6e:	cd59                	beqz	a0,3b0c <rmdot+0xde>
  if(unlink("..") == 0){
    3a70:	00003517          	auipc	a0,0x3
    3a74:	64850513          	addi	a0,a0,1608 # 70b8 <malloc+0x13ba>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	eae080e7          	jalr	-338(ra) # 5926 <unlink>
    3a80:	c545                	beqz	a0,3b28 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a82:	00003517          	auipc	a0,0x3
    3a86:	5de50513          	addi	a0,a0,1502 # 7060 <malloc+0x1362>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	ebc080e7          	jalr	-324(ra) # 5946 <chdir>
    3a92:	e94d                	bnez	a0,3b44 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a94:	00004517          	auipc	a0,0x4
    3a98:	c3450513          	addi	a0,a0,-972 # 76c8 <malloc+0x19ca>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	e8a080e7          	jalr	-374(ra) # 5926 <unlink>
    3aa4:	cd55                	beqz	a0,3b60 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	c4a50513          	addi	a0,a0,-950 # 76f0 <malloc+0x19f2>
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	e78080e7          	jalr	-392(ra) # 5926 <unlink>
    3ab6:	c179                	beqz	a0,3b7c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3ab8:	00004517          	auipc	a0,0x4
    3abc:	ba850513          	addi	a0,a0,-1112 # 7660 <malloc+0x1962>
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	e66080e7          	jalr	-410(ra) # 5926 <unlink>
    3ac8:	e961                	bnez	a0,3b98 <rmdot+0x16a>
}
    3aca:	60e2                	ld	ra,24(sp)
    3acc:	6442                	ld	s0,16(sp)
    3ace:	64a2                	ld	s1,8(sp)
    3ad0:	6105                	addi	sp,sp,32
    3ad2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3ad4:	85a6                	mv	a1,s1
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	b9250513          	addi	a0,a0,-1134 # 7668 <malloc+0x196a>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	168080e7          	jalr	360(ra) # 5c46 <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	dee080e7          	jalr	-530(ra) # 58d6 <exit>
    printf("%s: chdir dots failed\n", s);
    3af0:	85a6                	mv	a1,s1
    3af2:	00004517          	auipc	a0,0x4
    3af6:	b8e50513          	addi	a0,a0,-1138 # 7680 <malloc+0x1982>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	14c080e7          	jalr	332(ra) # 5c46 <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	dd2080e7          	jalr	-558(ra) # 58d6 <exit>
    printf("%s: rm . worked!\n", s);
    3b0c:	85a6                	mv	a1,s1
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	b8a50513          	addi	a0,a0,-1142 # 7698 <malloc+0x199a>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	130080e7          	jalr	304(ra) # 5c46 <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	db6080e7          	jalr	-586(ra) # 58d6 <exit>
    printf("%s: rm .. worked!\n", s);
    3b28:	85a6                	mv	a1,s1
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	b8650513          	addi	a0,a0,-1146 # 76b0 <malloc+0x19b2>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	114080e7          	jalr	276(ra) # 5c46 <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	d9a080e7          	jalr	-614(ra) # 58d6 <exit>
    printf("%s: chdir / failed\n", s);
    3b44:	85a6                	mv	a1,s1
    3b46:	00003517          	auipc	a0,0x3
    3b4a:	52250513          	addi	a0,a0,1314 # 7068 <malloc+0x136a>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	0f8080e7          	jalr	248(ra) # 5c46 <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	d7e080e7          	jalr	-642(ra) # 58d6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b60:	85a6                	mv	a1,s1
    3b62:	00004517          	auipc	a0,0x4
    3b66:	b6e50513          	addi	a0,a0,-1170 # 76d0 <malloc+0x19d2>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	0dc080e7          	jalr	220(ra) # 5c46 <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	d62080e7          	jalr	-670(ra) # 58d6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b7c:	85a6                	mv	a1,s1
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	b7a50513          	addi	a0,a0,-1158 # 76f8 <malloc+0x19fa>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	0c0080e7          	jalr	192(ra) # 5c46 <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	d46080e7          	jalr	-698(ra) # 58d6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3b98:	85a6                	mv	a1,s1
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	b7e50513          	addi	a0,a0,-1154 # 7718 <malloc+0x1a1a>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	0a4080e7          	jalr	164(ra) # 5c46 <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	d2a080e7          	jalr	-726(ra) # 58d6 <exit>

0000000000003bb4 <dirfile>:
{
    3bb4:	1101                	addi	sp,sp,-32
    3bb6:	ec06                	sd	ra,24(sp)
    3bb8:	e822                	sd	s0,16(sp)
    3bba:	e426                	sd	s1,8(sp)
    3bbc:	e04a                	sd	s2,0(sp)
    3bbe:	1000                	addi	s0,sp,32
    3bc0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3bc2:	20000593          	li	a1,512
    3bc6:	00004517          	auipc	a0,0x4
    3bca:	b7250513          	addi	a0,a0,-1166 # 7738 <malloc+0x1a3a>
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	d48080e7          	jalr	-696(ra) # 5916 <open>
  if(fd < 0){
    3bd6:	0e054d63          	bltz	a0,3cd0 <dirfile+0x11c>
  close(fd);
    3bda:	00002097          	auipc	ra,0x2
    3bde:	d24080e7          	jalr	-732(ra) # 58fe <close>
  if(chdir("dirfile") == 0){
    3be2:	00004517          	auipc	a0,0x4
    3be6:	b5650513          	addi	a0,a0,-1194 # 7738 <malloc+0x1a3a>
    3bea:	00002097          	auipc	ra,0x2
    3bee:	d5c080e7          	jalr	-676(ra) # 5946 <chdir>
    3bf2:	cd6d                	beqz	a0,3cec <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3bf4:	4581                	li	a1,0
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	b8a50513          	addi	a0,a0,-1142 # 7780 <malloc+0x1a82>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	d18080e7          	jalr	-744(ra) # 5916 <open>
  if(fd >= 0){
    3c06:	10055163          	bgez	a0,3d08 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3c0a:	20000593          	li	a1,512
    3c0e:	00004517          	auipc	a0,0x4
    3c12:	b7250513          	addi	a0,a0,-1166 # 7780 <malloc+0x1a82>
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	d00080e7          	jalr	-768(ra) # 5916 <open>
  if(fd >= 0){
    3c1e:	10055363          	bgez	a0,3d24 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3c22:	00004517          	auipc	a0,0x4
    3c26:	b5e50513          	addi	a0,a0,-1186 # 7780 <malloc+0x1a82>
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	d14080e7          	jalr	-748(ra) # 593e <mkdir>
    3c32:	10050763          	beqz	a0,3d40 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3c36:	00004517          	auipc	a0,0x4
    3c3a:	b4a50513          	addi	a0,a0,-1206 # 7780 <malloc+0x1a82>
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	ce8080e7          	jalr	-792(ra) # 5926 <unlink>
    3c46:	10050b63          	beqz	a0,3d5c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3c4a:	00004597          	auipc	a1,0x4
    3c4e:	b3658593          	addi	a1,a1,-1226 # 7780 <malloc+0x1a82>
    3c52:	00002517          	auipc	a0,0x2
    3c56:	38e50513          	addi	a0,a0,910 # 5fe0 <malloc+0x2e2>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	cdc080e7          	jalr	-804(ra) # 5936 <link>
    3c62:	10050b63          	beqz	a0,3d78 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c66:	00004517          	auipc	a0,0x4
    3c6a:	ad250513          	addi	a0,a0,-1326 # 7738 <malloc+0x1a3a>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	cb8080e7          	jalr	-840(ra) # 5926 <unlink>
    3c76:	10051f63          	bnez	a0,3d94 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c7a:	4589                	li	a1,2
    3c7c:	00003517          	auipc	a0,0x3
    3c80:	87450513          	addi	a0,a0,-1932 # 64f0 <malloc+0x7f2>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	c92080e7          	jalr	-878(ra) # 5916 <open>
  if(fd >= 0){
    3c8c:	12055263          	bgez	a0,3db0 <dirfile+0x1fc>
  fd = open(".", 0);
    3c90:	4581                	li	a1,0
    3c92:	00003517          	auipc	a0,0x3
    3c96:	85e50513          	addi	a0,a0,-1954 # 64f0 <malloc+0x7f2>
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	c7c080e7          	jalr	-900(ra) # 5916 <open>
    3ca2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3ca4:	4605                	li	a2,1
    3ca6:	00002597          	auipc	a1,0x2
    3caa:	20258593          	addi	a1,a1,514 # 5ea8 <malloc+0x1aa>
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	c48080e7          	jalr	-952(ra) # 58f6 <write>
    3cb6:	10a04b63          	bgtz	a0,3dcc <dirfile+0x218>
  close(fd);
    3cba:	8526                	mv	a0,s1
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	c42080e7          	jalr	-958(ra) # 58fe <close>
}
    3cc4:	60e2                	ld	ra,24(sp)
    3cc6:	6442                	ld	s0,16(sp)
    3cc8:	64a2                	ld	s1,8(sp)
    3cca:	6902                	ld	s2,0(sp)
    3ccc:	6105                	addi	sp,sp,32
    3cce:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3cd0:	85ca                	mv	a1,s2
    3cd2:	00004517          	auipc	a0,0x4
    3cd6:	a6e50513          	addi	a0,a0,-1426 # 7740 <malloc+0x1a42>
    3cda:	00002097          	auipc	ra,0x2
    3cde:	f6c080e7          	jalr	-148(ra) # 5c46 <printf>
    exit(1);
    3ce2:	4505                	li	a0,1
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	bf2080e7          	jalr	-1038(ra) # 58d6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3cec:	85ca                	mv	a1,s2
    3cee:	00004517          	auipc	a0,0x4
    3cf2:	a7250513          	addi	a0,a0,-1422 # 7760 <malloc+0x1a62>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	f50080e7          	jalr	-176(ra) # 5c46 <printf>
    exit(1);
    3cfe:	4505                	li	a0,1
    3d00:	00002097          	auipc	ra,0x2
    3d04:	bd6080e7          	jalr	-1066(ra) # 58d6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3d08:	85ca                	mv	a1,s2
    3d0a:	00004517          	auipc	a0,0x4
    3d0e:	a8650513          	addi	a0,a0,-1402 # 7790 <malloc+0x1a92>
    3d12:	00002097          	auipc	ra,0x2
    3d16:	f34080e7          	jalr	-204(ra) # 5c46 <printf>
    exit(1);
    3d1a:	4505                	li	a0,1
    3d1c:	00002097          	auipc	ra,0x2
    3d20:	bba080e7          	jalr	-1094(ra) # 58d6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3d24:	85ca                	mv	a1,s2
    3d26:	00004517          	auipc	a0,0x4
    3d2a:	a6a50513          	addi	a0,a0,-1430 # 7790 <malloc+0x1a92>
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	f18080e7          	jalr	-232(ra) # 5c46 <printf>
    exit(1);
    3d36:	4505                	li	a0,1
    3d38:	00002097          	auipc	ra,0x2
    3d3c:	b9e080e7          	jalr	-1122(ra) # 58d6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3d40:	85ca                	mv	a1,s2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	a7650513          	addi	a0,a0,-1418 # 77b8 <malloc+0x1aba>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	efc080e7          	jalr	-260(ra) # 5c46 <printf>
    exit(1);
    3d52:	4505                	li	a0,1
    3d54:	00002097          	auipc	ra,0x2
    3d58:	b82080e7          	jalr	-1150(ra) # 58d6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3d5c:	85ca                	mv	a1,s2
    3d5e:	00004517          	auipc	a0,0x4
    3d62:	a8250513          	addi	a0,a0,-1406 # 77e0 <malloc+0x1ae2>
    3d66:	00002097          	auipc	ra,0x2
    3d6a:	ee0080e7          	jalr	-288(ra) # 5c46 <printf>
    exit(1);
    3d6e:	4505                	li	a0,1
    3d70:	00002097          	auipc	ra,0x2
    3d74:	b66080e7          	jalr	-1178(ra) # 58d6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d78:	85ca                	mv	a1,s2
    3d7a:	00004517          	auipc	a0,0x4
    3d7e:	a8e50513          	addi	a0,a0,-1394 # 7808 <malloc+0x1b0a>
    3d82:	00002097          	auipc	ra,0x2
    3d86:	ec4080e7          	jalr	-316(ra) # 5c46 <printf>
    exit(1);
    3d8a:	4505                	li	a0,1
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	b4a080e7          	jalr	-1206(ra) # 58d6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d94:	85ca                	mv	a1,s2
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	a9a50513          	addi	a0,a0,-1382 # 7830 <malloc+0x1b32>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	ea8080e7          	jalr	-344(ra) # 5c46 <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00002097          	auipc	ra,0x2
    3dac:	b2e080e7          	jalr	-1234(ra) # 58d6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3db0:	85ca                	mv	a1,s2
    3db2:	00004517          	auipc	a0,0x4
    3db6:	a9e50513          	addi	a0,a0,-1378 # 7850 <malloc+0x1b52>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	e8c080e7          	jalr	-372(ra) # 5c46 <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	b12080e7          	jalr	-1262(ra) # 58d6 <exit>
    printf("%s: write . succeeded!\n", s);
    3dcc:	85ca                	mv	a1,s2
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	aaa50513          	addi	a0,a0,-1366 # 7878 <malloc+0x1b7a>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	e70080e7          	jalr	-400(ra) # 5c46 <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	af6080e7          	jalr	-1290(ra) # 58d6 <exit>

0000000000003de8 <iref>:
{
    3de8:	7139                	addi	sp,sp,-64
    3dea:	fc06                	sd	ra,56(sp)
    3dec:	f822                	sd	s0,48(sp)
    3dee:	f426                	sd	s1,40(sp)
    3df0:	f04a                	sd	s2,32(sp)
    3df2:	ec4e                	sd	s3,24(sp)
    3df4:	e852                	sd	s4,16(sp)
    3df6:	e456                	sd	s5,8(sp)
    3df8:	e05a                	sd	s6,0(sp)
    3dfa:	0080                	addi	s0,sp,64
    3dfc:	8b2a                	mv	s6,a0
    3dfe:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3e02:	00004a17          	auipc	s4,0x4
    3e06:	a8ea0a13          	addi	s4,s4,-1394 # 7890 <malloc+0x1b92>
    mkdir("");
    3e0a:	00003497          	auipc	s1,0x3
    3e0e:	58e48493          	addi	s1,s1,1422 # 7398 <malloc+0x169a>
    link("README", "");
    3e12:	00002a97          	auipc	s5,0x2
    3e16:	1cea8a93          	addi	s5,s5,462 # 5fe0 <malloc+0x2e2>
    fd = open("xx", O_CREATE);
    3e1a:	00004997          	auipc	s3,0x4
    3e1e:	96e98993          	addi	s3,s3,-1682 # 7788 <malloc+0x1a8a>
    3e22:	a891                	j	3e76 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3e24:	85da                	mv	a1,s6
    3e26:	00004517          	auipc	a0,0x4
    3e2a:	a7250513          	addi	a0,a0,-1422 # 7898 <malloc+0x1b9a>
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	e18080e7          	jalr	-488(ra) # 5c46 <printf>
      exit(1);
    3e36:	4505                	li	a0,1
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	a9e080e7          	jalr	-1378(ra) # 58d6 <exit>
      printf("%s: chdir irefd failed\n", s);
    3e40:	85da                	mv	a1,s6
    3e42:	00004517          	auipc	a0,0x4
    3e46:	a6e50513          	addi	a0,a0,-1426 # 78b0 <malloc+0x1bb2>
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	dfc080e7          	jalr	-516(ra) # 5c46 <printf>
      exit(1);
    3e52:	4505                	li	a0,1
    3e54:	00002097          	auipc	ra,0x2
    3e58:	a82080e7          	jalr	-1406(ra) # 58d6 <exit>
      close(fd);
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	aa2080e7          	jalr	-1374(ra) # 58fe <close>
    3e64:	a889                	j	3eb6 <iref+0xce>
    unlink("xx");
    3e66:	854e                	mv	a0,s3
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	abe080e7          	jalr	-1346(ra) # 5926 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e70:	397d                	addiw	s2,s2,-1
    3e72:	06090063          	beqz	s2,3ed2 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e76:	8552                	mv	a0,s4
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	ac6080e7          	jalr	-1338(ra) # 593e <mkdir>
    3e80:	f155                	bnez	a0,3e24 <iref+0x3c>
    if(chdir("irefd") != 0){
    3e82:	8552                	mv	a0,s4
    3e84:	00002097          	auipc	ra,0x2
    3e88:	ac2080e7          	jalr	-1342(ra) # 5946 <chdir>
    3e8c:	f955                	bnez	a0,3e40 <iref+0x58>
    mkdir("");
    3e8e:	8526                	mv	a0,s1
    3e90:	00002097          	auipc	ra,0x2
    3e94:	aae080e7          	jalr	-1362(ra) # 593e <mkdir>
    link("README", "");
    3e98:	85a6                	mv	a1,s1
    3e9a:	8556                	mv	a0,s5
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	a9a080e7          	jalr	-1382(ra) # 5936 <link>
    fd = open("", O_CREATE);
    3ea4:	20000593          	li	a1,512
    3ea8:	8526                	mv	a0,s1
    3eaa:	00002097          	auipc	ra,0x2
    3eae:	a6c080e7          	jalr	-1428(ra) # 5916 <open>
    if(fd >= 0)
    3eb2:	fa0555e3          	bgez	a0,3e5c <iref+0x74>
    fd = open("xx", O_CREATE);
    3eb6:	20000593          	li	a1,512
    3eba:	854e                	mv	a0,s3
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	a5a080e7          	jalr	-1446(ra) # 5916 <open>
    if(fd >= 0)
    3ec4:	fa0541e3          	bltz	a0,3e66 <iref+0x7e>
      close(fd);
    3ec8:	00002097          	auipc	ra,0x2
    3ecc:	a36080e7          	jalr	-1482(ra) # 58fe <close>
    3ed0:	bf59                	j	3e66 <iref+0x7e>
    3ed2:	03300493          	li	s1,51
    chdir("..");
    3ed6:	00003997          	auipc	s3,0x3
    3eda:	1e298993          	addi	s3,s3,482 # 70b8 <malloc+0x13ba>
    unlink("irefd");
    3ede:	00004917          	auipc	s2,0x4
    3ee2:	9b290913          	addi	s2,s2,-1614 # 7890 <malloc+0x1b92>
    chdir("..");
    3ee6:	854e                	mv	a0,s3
    3ee8:	00002097          	auipc	ra,0x2
    3eec:	a5e080e7          	jalr	-1442(ra) # 5946 <chdir>
    unlink("irefd");
    3ef0:	854a                	mv	a0,s2
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	a34080e7          	jalr	-1484(ra) # 5926 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3efa:	34fd                	addiw	s1,s1,-1
    3efc:	f4ed                	bnez	s1,3ee6 <iref+0xfe>
  chdir("/");
    3efe:	00003517          	auipc	a0,0x3
    3f02:	16250513          	addi	a0,a0,354 # 7060 <malloc+0x1362>
    3f06:	00002097          	auipc	ra,0x2
    3f0a:	a40080e7          	jalr	-1472(ra) # 5946 <chdir>
}
    3f0e:	70e2                	ld	ra,56(sp)
    3f10:	7442                	ld	s0,48(sp)
    3f12:	74a2                	ld	s1,40(sp)
    3f14:	7902                	ld	s2,32(sp)
    3f16:	69e2                	ld	s3,24(sp)
    3f18:	6a42                	ld	s4,16(sp)
    3f1a:	6aa2                	ld	s5,8(sp)
    3f1c:	6b02                	ld	s6,0(sp)
    3f1e:	6121                	addi	sp,sp,64
    3f20:	8082                	ret

0000000000003f22 <openiputtest>:
{
    3f22:	7179                	addi	sp,sp,-48
    3f24:	f406                	sd	ra,40(sp)
    3f26:	f022                	sd	s0,32(sp)
    3f28:	ec26                	sd	s1,24(sp)
    3f2a:	1800                	addi	s0,sp,48
    3f2c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	99a50513          	addi	a0,a0,-1638 # 78c8 <malloc+0x1bca>
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	a08080e7          	jalr	-1528(ra) # 593e <mkdir>
    3f3e:	04054263          	bltz	a0,3f82 <openiputtest+0x60>
  pid = fork();
    3f42:	00002097          	auipc	ra,0x2
    3f46:	98c080e7          	jalr	-1652(ra) # 58ce <fork>
  if(pid < 0){
    3f4a:	04054a63          	bltz	a0,3f9e <openiputtest+0x7c>
  if(pid == 0){
    3f4e:	e93d                	bnez	a0,3fc4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3f50:	4589                	li	a1,2
    3f52:	00004517          	auipc	a0,0x4
    3f56:	97650513          	addi	a0,a0,-1674 # 78c8 <malloc+0x1bca>
    3f5a:	00002097          	auipc	ra,0x2
    3f5e:	9bc080e7          	jalr	-1604(ra) # 5916 <open>
    if(fd >= 0){
    3f62:	04054c63          	bltz	a0,3fba <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f66:	85a6                	mv	a1,s1
    3f68:	00004517          	auipc	a0,0x4
    3f6c:	98050513          	addi	a0,a0,-1664 # 78e8 <malloc+0x1bea>
    3f70:	00002097          	auipc	ra,0x2
    3f74:	cd6080e7          	jalr	-810(ra) # 5c46 <printf>
      exit(1);
    3f78:	4505                	li	a0,1
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	95c080e7          	jalr	-1700(ra) # 58d6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f82:	85a6                	mv	a1,s1
    3f84:	00004517          	auipc	a0,0x4
    3f88:	94c50513          	addi	a0,a0,-1716 # 78d0 <malloc+0x1bd2>
    3f8c:	00002097          	auipc	ra,0x2
    3f90:	cba080e7          	jalr	-838(ra) # 5c46 <printf>
    exit(1);
    3f94:	4505                	li	a0,1
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	940080e7          	jalr	-1728(ra) # 58d6 <exit>
    printf("%s: fork failed\n", s);
    3f9e:	85a6                	mv	a1,s1
    3fa0:	00002517          	auipc	a0,0x2
    3fa4:	6f050513          	addi	a0,a0,1776 # 6690 <malloc+0x992>
    3fa8:	00002097          	auipc	ra,0x2
    3fac:	c9e080e7          	jalr	-866(ra) # 5c46 <printf>
    exit(1);
    3fb0:	4505                	li	a0,1
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	924080e7          	jalr	-1756(ra) # 58d6 <exit>
    exit(0);
    3fba:	4501                	li	a0,0
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	91a080e7          	jalr	-1766(ra) # 58d6 <exit>
  sleep(1);
    3fc4:	4505                	li	a0,1
    3fc6:	00002097          	auipc	ra,0x2
    3fca:	9a0080e7          	jalr	-1632(ra) # 5966 <sleep>
  if(unlink("oidir") != 0){
    3fce:	00004517          	auipc	a0,0x4
    3fd2:	8fa50513          	addi	a0,a0,-1798 # 78c8 <malloc+0x1bca>
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	950080e7          	jalr	-1712(ra) # 5926 <unlink>
    3fde:	cd19                	beqz	a0,3ffc <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3fe0:	85a6                	mv	a1,s1
    3fe2:	00003517          	auipc	a0,0x3
    3fe6:	89e50513          	addi	a0,a0,-1890 # 6880 <malloc+0xb82>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	c5c080e7          	jalr	-932(ra) # 5c46 <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	8e2080e7          	jalr	-1822(ra) # 58d6 <exit>
  wait(&xstatus);
    3ffc:	fdc40513          	addi	a0,s0,-36
    4000:	00002097          	auipc	ra,0x2
    4004:	8de080e7          	jalr	-1826(ra) # 58de <wait>
  exit(xstatus);
    4008:	fdc42503          	lw	a0,-36(s0)
    400c:	00002097          	auipc	ra,0x2
    4010:	8ca080e7          	jalr	-1846(ra) # 58d6 <exit>

0000000000004014 <forkforkfork>:
{
    4014:	1101                	addi	sp,sp,-32
    4016:	ec06                	sd	ra,24(sp)
    4018:	e822                	sd	s0,16(sp)
    401a:	e426                	sd	s1,8(sp)
    401c:	1000                	addi	s0,sp,32
    401e:	84aa                	mv	s1,a0
  unlink("stopforking");
    4020:	00004517          	auipc	a0,0x4
    4024:	8f050513          	addi	a0,a0,-1808 # 7910 <malloc+0x1c12>
    4028:	00002097          	auipc	ra,0x2
    402c:	8fe080e7          	jalr	-1794(ra) # 5926 <unlink>
  int pid = fork();
    4030:	00002097          	auipc	ra,0x2
    4034:	89e080e7          	jalr	-1890(ra) # 58ce <fork>
  if(pid < 0){
    4038:	04054563          	bltz	a0,4082 <forkforkfork+0x6e>
  if(pid == 0){
    403c:	c12d                	beqz	a0,409e <forkforkfork+0x8a>
  sleep(20); // two seconds
    403e:	4551                	li	a0,20
    4040:	00002097          	auipc	ra,0x2
    4044:	926080e7          	jalr	-1754(ra) # 5966 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4048:	20200593          	li	a1,514
    404c:	00004517          	auipc	a0,0x4
    4050:	8c450513          	addi	a0,a0,-1852 # 7910 <malloc+0x1c12>
    4054:	00002097          	auipc	ra,0x2
    4058:	8c2080e7          	jalr	-1854(ra) # 5916 <open>
    405c:	00002097          	auipc	ra,0x2
    4060:	8a2080e7          	jalr	-1886(ra) # 58fe <close>
  wait(0);
    4064:	4501                	li	a0,0
    4066:	00002097          	auipc	ra,0x2
    406a:	878080e7          	jalr	-1928(ra) # 58de <wait>
  sleep(10); // one second
    406e:	4529                	li	a0,10
    4070:	00002097          	auipc	ra,0x2
    4074:	8f6080e7          	jalr	-1802(ra) # 5966 <sleep>
}
    4078:	60e2                	ld	ra,24(sp)
    407a:	6442                	ld	s0,16(sp)
    407c:	64a2                	ld	s1,8(sp)
    407e:	6105                	addi	sp,sp,32
    4080:	8082                	ret
    printf("%s: fork failed", s);
    4082:	85a6                	mv	a1,s1
    4084:	00002517          	auipc	a0,0x2
    4088:	7cc50513          	addi	a0,a0,1996 # 6850 <malloc+0xb52>
    408c:	00002097          	auipc	ra,0x2
    4090:	bba080e7          	jalr	-1094(ra) # 5c46 <printf>
    exit(1);
    4094:	4505                	li	a0,1
    4096:	00002097          	auipc	ra,0x2
    409a:	840080e7          	jalr	-1984(ra) # 58d6 <exit>
      int fd = open("stopforking", 0);
    409e:	00004497          	auipc	s1,0x4
    40a2:	87248493          	addi	s1,s1,-1934 # 7910 <malloc+0x1c12>
    40a6:	4581                	li	a1,0
    40a8:	8526                	mv	a0,s1
    40aa:	00002097          	auipc	ra,0x2
    40ae:	86c080e7          	jalr	-1940(ra) # 5916 <open>
      if(fd >= 0){
    40b2:	02055763          	bgez	a0,40e0 <forkforkfork+0xcc>
      if(fork() < 0){
    40b6:	00002097          	auipc	ra,0x2
    40ba:	818080e7          	jalr	-2024(ra) # 58ce <fork>
    40be:	fe0554e3          	bgez	a0,40a6 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    40c2:	20200593          	li	a1,514
    40c6:	00004517          	auipc	a0,0x4
    40ca:	84a50513          	addi	a0,a0,-1974 # 7910 <malloc+0x1c12>
    40ce:	00002097          	auipc	ra,0x2
    40d2:	848080e7          	jalr	-1976(ra) # 5916 <open>
    40d6:	00002097          	auipc	ra,0x2
    40da:	828080e7          	jalr	-2008(ra) # 58fe <close>
    40de:	b7e1                	j	40a6 <forkforkfork+0x92>
        exit(0);
    40e0:	4501                	li	a0,0
    40e2:	00001097          	auipc	ra,0x1
    40e6:	7f4080e7          	jalr	2036(ra) # 58d6 <exit>

00000000000040ea <killstatus>:
{
    40ea:	7139                	addi	sp,sp,-64
    40ec:	fc06                	sd	ra,56(sp)
    40ee:	f822                	sd	s0,48(sp)
    40f0:	f426                	sd	s1,40(sp)
    40f2:	f04a                	sd	s2,32(sp)
    40f4:	ec4e                	sd	s3,24(sp)
    40f6:	e852                	sd	s4,16(sp)
    40f8:	0080                	addi	s0,sp,64
    40fa:	8a2a                	mv	s4,a0
    40fc:	06400913          	li	s2,100
    if(xst != -1) {
    4100:	59fd                	li	s3,-1
    int pid1 = fork();
    4102:	00001097          	auipc	ra,0x1
    4106:	7cc080e7          	jalr	1996(ra) # 58ce <fork>
    410a:	84aa                	mv	s1,a0
    if(pid1 < 0){
    410c:	02054f63          	bltz	a0,414a <killstatus+0x60>
    if(pid1 == 0){
    4110:	c939                	beqz	a0,4166 <killstatus+0x7c>
    sleep(1);
    4112:	4505                	li	a0,1
    4114:	00002097          	auipc	ra,0x2
    4118:	852080e7          	jalr	-1966(ra) # 5966 <sleep>
    kill(pid1);
    411c:	8526                	mv	a0,s1
    411e:	00001097          	auipc	ra,0x1
    4122:	7e8080e7          	jalr	2024(ra) # 5906 <kill>
    wait(&xst);
    4126:	fcc40513          	addi	a0,s0,-52
    412a:	00001097          	auipc	ra,0x1
    412e:	7b4080e7          	jalr	1972(ra) # 58de <wait>
    if(xst != -1) {
    4132:	fcc42783          	lw	a5,-52(s0)
    4136:	03379d63          	bne	a5,s3,4170 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    413a:	397d                	addiw	s2,s2,-1
    413c:	fc0913e3          	bnez	s2,4102 <killstatus+0x18>
  exit(0);
    4140:	4501                	li	a0,0
    4142:	00001097          	auipc	ra,0x1
    4146:	794080e7          	jalr	1940(ra) # 58d6 <exit>
      printf("%s: fork failed\n", s);
    414a:	85d2                	mv	a1,s4
    414c:	00002517          	auipc	a0,0x2
    4150:	54450513          	addi	a0,a0,1348 # 6690 <malloc+0x992>
    4154:	00002097          	auipc	ra,0x2
    4158:	af2080e7          	jalr	-1294(ra) # 5c46 <printf>
      exit(1);
    415c:	4505                	li	a0,1
    415e:	00001097          	auipc	ra,0x1
    4162:	778080e7          	jalr	1912(ra) # 58d6 <exit>
        getpid();
    4166:	00001097          	auipc	ra,0x1
    416a:	7f0080e7          	jalr	2032(ra) # 5956 <getpid>
      while(1) {
    416e:	bfe5                	j	4166 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4170:	85d2                	mv	a1,s4
    4172:	00003517          	auipc	a0,0x3
    4176:	7ae50513          	addi	a0,a0,1966 # 7920 <malloc+0x1c22>
    417a:	00002097          	auipc	ra,0x2
    417e:	acc080e7          	jalr	-1332(ra) # 5c46 <printf>
       exit(1);
    4182:	4505                	li	a0,1
    4184:	00001097          	auipc	ra,0x1
    4188:	752080e7          	jalr	1874(ra) # 58d6 <exit>

000000000000418c <preempt>:
{
    418c:	7139                	addi	sp,sp,-64
    418e:	fc06                	sd	ra,56(sp)
    4190:	f822                	sd	s0,48(sp)
    4192:	f426                	sd	s1,40(sp)
    4194:	f04a                	sd	s2,32(sp)
    4196:	ec4e                	sd	s3,24(sp)
    4198:	e852                	sd	s4,16(sp)
    419a:	0080                	addi	s0,sp,64
    419c:	892a                	mv	s2,a0
  pid1 = fork();
    419e:	00001097          	auipc	ra,0x1
    41a2:	730080e7          	jalr	1840(ra) # 58ce <fork>
  if(pid1 < 0) {
    41a6:	00054563          	bltz	a0,41b0 <preempt+0x24>
    41aa:	84aa                	mv	s1,a0
  if(pid1 == 0)
    41ac:	e105                	bnez	a0,41cc <preempt+0x40>
    for(;;)
    41ae:	a001                	j	41ae <preempt+0x22>
    printf("%s: fork failed", s);
    41b0:	85ca                	mv	a1,s2
    41b2:	00002517          	auipc	a0,0x2
    41b6:	69e50513          	addi	a0,a0,1694 # 6850 <malloc+0xb52>
    41ba:	00002097          	auipc	ra,0x2
    41be:	a8c080e7          	jalr	-1396(ra) # 5c46 <printf>
    exit(1);
    41c2:	4505                	li	a0,1
    41c4:	00001097          	auipc	ra,0x1
    41c8:	712080e7          	jalr	1810(ra) # 58d6 <exit>
  pid2 = fork();
    41cc:	00001097          	auipc	ra,0x1
    41d0:	702080e7          	jalr	1794(ra) # 58ce <fork>
    41d4:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    41d6:	00054463          	bltz	a0,41de <preempt+0x52>
  if(pid2 == 0)
    41da:	e105                	bnez	a0,41fa <preempt+0x6e>
    for(;;)
    41dc:	a001                	j	41dc <preempt+0x50>
    printf("%s: fork failed\n", s);
    41de:	85ca                	mv	a1,s2
    41e0:	00002517          	auipc	a0,0x2
    41e4:	4b050513          	addi	a0,a0,1200 # 6690 <malloc+0x992>
    41e8:	00002097          	auipc	ra,0x2
    41ec:	a5e080e7          	jalr	-1442(ra) # 5c46 <printf>
    exit(1);
    41f0:	4505                	li	a0,1
    41f2:	00001097          	auipc	ra,0x1
    41f6:	6e4080e7          	jalr	1764(ra) # 58d6 <exit>
  pipe(pfds);
    41fa:	fc840513          	addi	a0,s0,-56
    41fe:	00001097          	auipc	ra,0x1
    4202:	6e8080e7          	jalr	1768(ra) # 58e6 <pipe>
  pid3 = fork();
    4206:	00001097          	auipc	ra,0x1
    420a:	6c8080e7          	jalr	1736(ra) # 58ce <fork>
    420e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4210:	02054e63          	bltz	a0,424c <preempt+0xc0>
  if(pid3 == 0){
    4214:	e525                	bnez	a0,427c <preempt+0xf0>
    close(pfds[0]);
    4216:	fc842503          	lw	a0,-56(s0)
    421a:	00001097          	auipc	ra,0x1
    421e:	6e4080e7          	jalr	1764(ra) # 58fe <close>
    if(write(pfds[1], "x", 1) != 1)
    4222:	4605                	li	a2,1
    4224:	00002597          	auipc	a1,0x2
    4228:	c8458593          	addi	a1,a1,-892 # 5ea8 <malloc+0x1aa>
    422c:	fcc42503          	lw	a0,-52(s0)
    4230:	00001097          	auipc	ra,0x1
    4234:	6c6080e7          	jalr	1734(ra) # 58f6 <write>
    4238:	4785                	li	a5,1
    423a:	02f51763          	bne	a0,a5,4268 <preempt+0xdc>
    close(pfds[1]);
    423e:	fcc42503          	lw	a0,-52(s0)
    4242:	00001097          	auipc	ra,0x1
    4246:	6bc080e7          	jalr	1724(ra) # 58fe <close>
    for(;;)
    424a:	a001                	j	424a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    424c:	85ca                	mv	a1,s2
    424e:	00002517          	auipc	a0,0x2
    4252:	44250513          	addi	a0,a0,1090 # 6690 <malloc+0x992>
    4256:	00002097          	auipc	ra,0x2
    425a:	9f0080e7          	jalr	-1552(ra) # 5c46 <printf>
     exit(1);
    425e:	4505                	li	a0,1
    4260:	00001097          	auipc	ra,0x1
    4264:	676080e7          	jalr	1654(ra) # 58d6 <exit>
      printf("%s: preempt write error", s);
    4268:	85ca                	mv	a1,s2
    426a:	00003517          	auipc	a0,0x3
    426e:	6d650513          	addi	a0,a0,1750 # 7940 <malloc+0x1c42>
    4272:	00002097          	auipc	ra,0x2
    4276:	9d4080e7          	jalr	-1580(ra) # 5c46 <printf>
    427a:	b7d1                	j	423e <preempt+0xb2>
  close(pfds[1]);
    427c:	fcc42503          	lw	a0,-52(s0)
    4280:	00001097          	auipc	ra,0x1
    4284:	67e080e7          	jalr	1662(ra) # 58fe <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4288:	660d                	lui	a2,0x3
    428a:	00009597          	auipc	a1,0x9
    428e:	e4e58593          	addi	a1,a1,-434 # d0d8 <buf>
    4292:	fc842503          	lw	a0,-56(s0)
    4296:	00001097          	auipc	ra,0x1
    429a:	658080e7          	jalr	1624(ra) # 58ee <read>
    429e:	4785                	li	a5,1
    42a0:	02f50363          	beq	a0,a5,42c6 <preempt+0x13a>
    printf("%s: preempt read error", s);
    42a4:	85ca                	mv	a1,s2
    42a6:	00003517          	auipc	a0,0x3
    42aa:	6b250513          	addi	a0,a0,1714 # 7958 <malloc+0x1c5a>
    42ae:	00002097          	auipc	ra,0x2
    42b2:	998080e7          	jalr	-1640(ra) # 5c46 <printf>
}
    42b6:	70e2                	ld	ra,56(sp)
    42b8:	7442                	ld	s0,48(sp)
    42ba:	74a2                	ld	s1,40(sp)
    42bc:	7902                	ld	s2,32(sp)
    42be:	69e2                	ld	s3,24(sp)
    42c0:	6a42                	ld	s4,16(sp)
    42c2:	6121                	addi	sp,sp,64
    42c4:	8082                	ret
  close(pfds[0]);
    42c6:	fc842503          	lw	a0,-56(s0)
    42ca:	00001097          	auipc	ra,0x1
    42ce:	634080e7          	jalr	1588(ra) # 58fe <close>
  printf("kill... ");
    42d2:	00003517          	auipc	a0,0x3
    42d6:	69e50513          	addi	a0,a0,1694 # 7970 <malloc+0x1c72>
    42da:	00002097          	auipc	ra,0x2
    42de:	96c080e7          	jalr	-1684(ra) # 5c46 <printf>
  kill(pid1);
    42e2:	8526                	mv	a0,s1
    42e4:	00001097          	auipc	ra,0x1
    42e8:	622080e7          	jalr	1570(ra) # 5906 <kill>
  kill(pid2);
    42ec:	854e                	mv	a0,s3
    42ee:	00001097          	auipc	ra,0x1
    42f2:	618080e7          	jalr	1560(ra) # 5906 <kill>
  kill(pid3);
    42f6:	8552                	mv	a0,s4
    42f8:	00001097          	auipc	ra,0x1
    42fc:	60e080e7          	jalr	1550(ra) # 5906 <kill>
  printf("wait... ");
    4300:	00003517          	auipc	a0,0x3
    4304:	68050513          	addi	a0,a0,1664 # 7980 <malloc+0x1c82>
    4308:	00002097          	auipc	ra,0x2
    430c:	93e080e7          	jalr	-1730(ra) # 5c46 <printf>
  wait(0);
    4310:	4501                	li	a0,0
    4312:	00001097          	auipc	ra,0x1
    4316:	5cc080e7          	jalr	1484(ra) # 58de <wait>
  wait(0);
    431a:	4501                	li	a0,0
    431c:	00001097          	auipc	ra,0x1
    4320:	5c2080e7          	jalr	1474(ra) # 58de <wait>
  wait(0);
    4324:	4501                	li	a0,0
    4326:	00001097          	auipc	ra,0x1
    432a:	5b8080e7          	jalr	1464(ra) # 58de <wait>
    432e:	b761                	j	42b6 <preempt+0x12a>

0000000000004330 <reparent>:
{
    4330:	7179                	addi	sp,sp,-48
    4332:	f406                	sd	ra,40(sp)
    4334:	f022                	sd	s0,32(sp)
    4336:	ec26                	sd	s1,24(sp)
    4338:	e84a                	sd	s2,16(sp)
    433a:	e44e                	sd	s3,8(sp)
    433c:	e052                	sd	s4,0(sp)
    433e:	1800                	addi	s0,sp,48
    4340:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4342:	00001097          	auipc	ra,0x1
    4346:	614080e7          	jalr	1556(ra) # 5956 <getpid>
    434a:	8a2a                	mv	s4,a0
    434c:	0c800913          	li	s2,200
    int pid = fork();
    4350:	00001097          	auipc	ra,0x1
    4354:	57e080e7          	jalr	1406(ra) # 58ce <fork>
    4358:	84aa                	mv	s1,a0
    if(pid < 0){
    435a:	02054263          	bltz	a0,437e <reparent+0x4e>
    if(pid){
    435e:	cd21                	beqz	a0,43b6 <reparent+0x86>
      if(wait(0) != pid){
    4360:	4501                	li	a0,0
    4362:	00001097          	auipc	ra,0x1
    4366:	57c080e7          	jalr	1404(ra) # 58de <wait>
    436a:	02951863          	bne	a0,s1,439a <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    436e:	397d                	addiw	s2,s2,-1
    4370:	fe0910e3          	bnez	s2,4350 <reparent+0x20>
  exit(0);
    4374:	4501                	li	a0,0
    4376:	00001097          	auipc	ra,0x1
    437a:	560080e7          	jalr	1376(ra) # 58d6 <exit>
      printf("%s: fork failed\n", s);
    437e:	85ce                	mv	a1,s3
    4380:	00002517          	auipc	a0,0x2
    4384:	31050513          	addi	a0,a0,784 # 6690 <malloc+0x992>
    4388:	00002097          	auipc	ra,0x2
    438c:	8be080e7          	jalr	-1858(ra) # 5c46 <printf>
      exit(1);
    4390:	4505                	li	a0,1
    4392:	00001097          	auipc	ra,0x1
    4396:	544080e7          	jalr	1348(ra) # 58d6 <exit>
        printf("%s: wait wrong pid\n", s);
    439a:	85ce                	mv	a1,s3
    439c:	00002517          	auipc	a0,0x2
    43a0:	47c50513          	addi	a0,a0,1148 # 6818 <malloc+0xb1a>
    43a4:	00002097          	auipc	ra,0x2
    43a8:	8a2080e7          	jalr	-1886(ra) # 5c46 <printf>
        exit(1);
    43ac:	4505                	li	a0,1
    43ae:	00001097          	auipc	ra,0x1
    43b2:	528080e7          	jalr	1320(ra) # 58d6 <exit>
      int pid2 = fork();
    43b6:	00001097          	auipc	ra,0x1
    43ba:	518080e7          	jalr	1304(ra) # 58ce <fork>
      if(pid2 < 0){
    43be:	00054763          	bltz	a0,43cc <reparent+0x9c>
      exit(0);
    43c2:	4501                	li	a0,0
    43c4:	00001097          	auipc	ra,0x1
    43c8:	512080e7          	jalr	1298(ra) # 58d6 <exit>
        kill(master_pid);
    43cc:	8552                	mv	a0,s4
    43ce:	00001097          	auipc	ra,0x1
    43d2:	538080e7          	jalr	1336(ra) # 5906 <kill>
        exit(1);
    43d6:	4505                	li	a0,1
    43d8:	00001097          	auipc	ra,0x1
    43dc:	4fe080e7          	jalr	1278(ra) # 58d6 <exit>

00000000000043e0 <sbrkfail>:
{
    43e0:	7119                	addi	sp,sp,-128
    43e2:	fc86                	sd	ra,120(sp)
    43e4:	f8a2                	sd	s0,112(sp)
    43e6:	f4a6                	sd	s1,104(sp)
    43e8:	f0ca                	sd	s2,96(sp)
    43ea:	ecce                	sd	s3,88(sp)
    43ec:	e8d2                	sd	s4,80(sp)
    43ee:	e4d6                	sd	s5,72(sp)
    43f0:	0100                	addi	s0,sp,128
    43f2:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    43f4:	fb040513          	addi	a0,s0,-80
    43f8:	00001097          	auipc	ra,0x1
    43fc:	4ee080e7          	jalr	1262(ra) # 58e6 <pipe>
    4400:	e901                	bnez	a0,4410 <sbrkfail+0x30>
    4402:	f8040493          	addi	s1,s0,-128
    4406:	fa840993          	addi	s3,s0,-88
    440a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    440c:	5a7d                	li	s4,-1
    440e:	a085                	j	446e <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4410:	85d6                	mv	a1,s5
    4412:	00002517          	auipc	a0,0x2
    4416:	38650513          	addi	a0,a0,902 # 6798 <malloc+0xa9a>
    441a:	00002097          	auipc	ra,0x2
    441e:	82c080e7          	jalr	-2004(ra) # 5c46 <printf>
    exit(1);
    4422:	4505                	li	a0,1
    4424:	00001097          	auipc	ra,0x1
    4428:	4b2080e7          	jalr	1202(ra) # 58d6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    442c:	00001097          	auipc	ra,0x1
    4430:	532080e7          	jalr	1330(ra) # 595e <sbrk>
    4434:	064007b7          	lui	a5,0x6400
    4438:	40a7853b          	subw	a0,a5,a0
    443c:	00001097          	auipc	ra,0x1
    4440:	522080e7          	jalr	1314(ra) # 595e <sbrk>
      write(fds[1], "x", 1);
    4444:	4605                	li	a2,1
    4446:	00002597          	auipc	a1,0x2
    444a:	a6258593          	addi	a1,a1,-1438 # 5ea8 <malloc+0x1aa>
    444e:	fb442503          	lw	a0,-76(s0)
    4452:	00001097          	auipc	ra,0x1
    4456:	4a4080e7          	jalr	1188(ra) # 58f6 <write>
      for(;;) sleep(1000);
    445a:	3e800513          	li	a0,1000
    445e:	00001097          	auipc	ra,0x1
    4462:	508080e7          	jalr	1288(ra) # 5966 <sleep>
    4466:	bfd5                	j	445a <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4468:	0911                	addi	s2,s2,4
    446a:	03390563          	beq	s2,s3,4494 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    446e:	00001097          	auipc	ra,0x1
    4472:	460080e7          	jalr	1120(ra) # 58ce <fork>
    4476:	00a92023          	sw	a0,0(s2)
    447a:	d94d                	beqz	a0,442c <sbrkfail+0x4c>
    if(pids[i] != -1)
    447c:	ff4506e3          	beq	a0,s4,4468 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4480:	4605                	li	a2,1
    4482:	faf40593          	addi	a1,s0,-81
    4486:	fb042503          	lw	a0,-80(s0)
    448a:	00001097          	auipc	ra,0x1
    448e:	464080e7          	jalr	1124(ra) # 58ee <read>
    4492:	bfd9                	j	4468 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4494:	6505                	lui	a0,0x1
    4496:	00001097          	auipc	ra,0x1
    449a:	4c8080e7          	jalr	1224(ra) # 595e <sbrk>
    449e:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    44a0:	597d                	li	s2,-1
    44a2:	a021                	j	44aa <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    44a4:	0491                	addi	s1,s1,4
    44a6:	01348f63          	beq	s1,s3,44c4 <sbrkfail+0xe4>
    if(pids[i] == -1)
    44aa:	4088                	lw	a0,0(s1)
    44ac:	ff250ce3          	beq	a0,s2,44a4 <sbrkfail+0xc4>
    kill(pids[i]);
    44b0:	00001097          	auipc	ra,0x1
    44b4:	456080e7          	jalr	1110(ra) # 5906 <kill>
    wait(0);
    44b8:	4501                	li	a0,0
    44ba:	00001097          	auipc	ra,0x1
    44be:	424080e7          	jalr	1060(ra) # 58de <wait>
    44c2:	b7cd                	j	44a4 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    44c4:	57fd                	li	a5,-1
    44c6:	04fa0163          	beq	s4,a5,4508 <sbrkfail+0x128>
  pid = fork();
    44ca:	00001097          	auipc	ra,0x1
    44ce:	404080e7          	jalr	1028(ra) # 58ce <fork>
    44d2:	84aa                	mv	s1,a0
  if(pid < 0){
    44d4:	04054863          	bltz	a0,4524 <sbrkfail+0x144>
  if(pid == 0){
    44d8:	c525                	beqz	a0,4540 <sbrkfail+0x160>
  wait(&xstatus);
    44da:	fbc40513          	addi	a0,s0,-68
    44de:	00001097          	auipc	ra,0x1
    44e2:	400080e7          	jalr	1024(ra) # 58de <wait>
  if(xstatus != -1 && xstatus != 2)
    44e6:	fbc42783          	lw	a5,-68(s0)
    44ea:	577d                	li	a4,-1
    44ec:	00e78563          	beq	a5,a4,44f6 <sbrkfail+0x116>
    44f0:	4709                	li	a4,2
    44f2:	08e79d63          	bne	a5,a4,458c <sbrkfail+0x1ac>
}
    44f6:	70e6                	ld	ra,120(sp)
    44f8:	7446                	ld	s0,112(sp)
    44fa:	74a6                	ld	s1,104(sp)
    44fc:	7906                	ld	s2,96(sp)
    44fe:	69e6                	ld	s3,88(sp)
    4500:	6a46                	ld	s4,80(sp)
    4502:	6aa6                	ld	s5,72(sp)
    4504:	6109                	addi	sp,sp,128
    4506:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4508:	85d6                	mv	a1,s5
    450a:	00003517          	auipc	a0,0x3
    450e:	48650513          	addi	a0,a0,1158 # 7990 <malloc+0x1c92>
    4512:	00001097          	auipc	ra,0x1
    4516:	734080e7          	jalr	1844(ra) # 5c46 <printf>
    exit(1);
    451a:	4505                	li	a0,1
    451c:	00001097          	auipc	ra,0x1
    4520:	3ba080e7          	jalr	954(ra) # 58d6 <exit>
    printf("%s: fork failed\n", s);
    4524:	85d6                	mv	a1,s5
    4526:	00002517          	auipc	a0,0x2
    452a:	16a50513          	addi	a0,a0,362 # 6690 <malloc+0x992>
    452e:	00001097          	auipc	ra,0x1
    4532:	718080e7          	jalr	1816(ra) # 5c46 <printf>
    exit(1);
    4536:	4505                	li	a0,1
    4538:	00001097          	auipc	ra,0x1
    453c:	39e080e7          	jalr	926(ra) # 58d6 <exit>
    a = sbrk(0);
    4540:	4501                	li	a0,0
    4542:	00001097          	auipc	ra,0x1
    4546:	41c080e7          	jalr	1052(ra) # 595e <sbrk>
    454a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    454c:	3e800537          	lui	a0,0x3e800
    4550:	00001097          	auipc	ra,0x1
    4554:	40e080e7          	jalr	1038(ra) # 595e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4558:	87ca                	mv	a5,s2
    455a:	3e800737          	lui	a4,0x3e800
    455e:	993a                	add	s2,s2,a4
    4560:	6705                	lui	a4,0x1
      n += *(a+i);
    4562:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63eff18>
    4566:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4568:	97ba                	add	a5,a5,a4
    456a:	fef91ce3          	bne	s2,a5,4562 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    456e:	8626                	mv	a2,s1
    4570:	85d6                	mv	a1,s5
    4572:	00003517          	auipc	a0,0x3
    4576:	43e50513          	addi	a0,a0,1086 # 79b0 <malloc+0x1cb2>
    457a:	00001097          	auipc	ra,0x1
    457e:	6cc080e7          	jalr	1740(ra) # 5c46 <printf>
    exit(1);
    4582:	4505                	li	a0,1
    4584:	00001097          	auipc	ra,0x1
    4588:	352080e7          	jalr	850(ra) # 58d6 <exit>
    exit(1);
    458c:	4505                	li	a0,1
    458e:	00001097          	auipc	ra,0x1
    4592:	348080e7          	jalr	840(ra) # 58d6 <exit>

0000000000004596 <mem>:
{
    4596:	7139                	addi	sp,sp,-64
    4598:	fc06                	sd	ra,56(sp)
    459a:	f822                	sd	s0,48(sp)
    459c:	f426                	sd	s1,40(sp)
    459e:	f04a                	sd	s2,32(sp)
    45a0:	ec4e                	sd	s3,24(sp)
    45a2:	0080                	addi	s0,sp,64
    45a4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    45a6:	00001097          	auipc	ra,0x1
    45aa:	328080e7          	jalr	808(ra) # 58ce <fork>
    m1 = 0;
    45ae:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    45b0:	6909                	lui	s2,0x2
    45b2:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x69>
  if((pid = fork()) == 0){
    45b6:	c115                	beqz	a0,45da <mem+0x44>
    wait(&xstatus);
    45b8:	fcc40513          	addi	a0,s0,-52
    45bc:	00001097          	auipc	ra,0x1
    45c0:	322080e7          	jalr	802(ra) # 58de <wait>
    if(xstatus == -1){
    45c4:	fcc42503          	lw	a0,-52(s0)
    45c8:	57fd                	li	a5,-1
    45ca:	06f50363          	beq	a0,a5,4630 <mem+0x9a>
    exit(xstatus);
    45ce:	00001097          	auipc	ra,0x1
    45d2:	308080e7          	jalr	776(ra) # 58d6 <exit>
      *(char**)m2 = m1;
    45d6:	e104                	sd	s1,0(a0)
      m1 = m2;
    45d8:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    45da:	854a                	mv	a0,s2
    45dc:	00001097          	auipc	ra,0x1
    45e0:	722080e7          	jalr	1826(ra) # 5cfe <malloc>
    45e4:	f96d                	bnez	a0,45d6 <mem+0x40>
    while(m1){
    45e6:	c881                	beqz	s1,45f6 <mem+0x60>
      m2 = *(char**)m1;
    45e8:	8526                	mv	a0,s1
    45ea:	6084                	ld	s1,0(s1)
      free(m1);
    45ec:	00001097          	auipc	ra,0x1
    45f0:	690080e7          	jalr	1680(ra) # 5c7c <free>
    while(m1){
    45f4:	f8f5                	bnez	s1,45e8 <mem+0x52>
    m1 = malloc(1024*20);
    45f6:	6515                	lui	a0,0x5
    45f8:	00001097          	auipc	ra,0x1
    45fc:	706080e7          	jalr	1798(ra) # 5cfe <malloc>
    if(m1 == 0){
    4600:	c911                	beqz	a0,4614 <mem+0x7e>
    free(m1);
    4602:	00001097          	auipc	ra,0x1
    4606:	67a080e7          	jalr	1658(ra) # 5c7c <free>
    exit(0);
    460a:	4501                	li	a0,0
    460c:	00001097          	auipc	ra,0x1
    4610:	2ca080e7          	jalr	714(ra) # 58d6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4614:	85ce                	mv	a1,s3
    4616:	00003517          	auipc	a0,0x3
    461a:	3ca50513          	addi	a0,a0,970 # 79e0 <malloc+0x1ce2>
    461e:	00001097          	auipc	ra,0x1
    4622:	628080e7          	jalr	1576(ra) # 5c46 <printf>
      exit(1);
    4626:	4505                	li	a0,1
    4628:	00001097          	auipc	ra,0x1
    462c:	2ae080e7          	jalr	686(ra) # 58d6 <exit>
      exit(0);
    4630:	4501                	li	a0,0
    4632:	00001097          	auipc	ra,0x1
    4636:	2a4080e7          	jalr	676(ra) # 58d6 <exit>

000000000000463a <sharedfd>:
{
    463a:	7159                	addi	sp,sp,-112
    463c:	f486                	sd	ra,104(sp)
    463e:	f0a2                	sd	s0,96(sp)
    4640:	e0d2                	sd	s4,64(sp)
    4642:	1880                	addi	s0,sp,112
    4644:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4646:	00003517          	auipc	a0,0x3
    464a:	3ba50513          	addi	a0,a0,954 # 7a00 <malloc+0x1d02>
    464e:	00001097          	auipc	ra,0x1
    4652:	2d8080e7          	jalr	728(ra) # 5926 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4656:	20200593          	li	a1,514
    465a:	00003517          	auipc	a0,0x3
    465e:	3a650513          	addi	a0,a0,934 # 7a00 <malloc+0x1d02>
    4662:	00001097          	auipc	ra,0x1
    4666:	2b4080e7          	jalr	692(ra) # 5916 <open>
  if(fd < 0){
    466a:	06054063          	bltz	a0,46ca <sharedfd+0x90>
    466e:	eca6                	sd	s1,88(sp)
    4670:	e8ca                	sd	s2,80(sp)
    4672:	e4ce                	sd	s3,72(sp)
    4674:	fc56                	sd	s5,56(sp)
    4676:	f85a                	sd	s6,48(sp)
    4678:	f45e                	sd	s7,40(sp)
    467a:	892a                	mv	s2,a0
  pid = fork();
    467c:	00001097          	auipc	ra,0x1
    4680:	252080e7          	jalr	594(ra) # 58ce <fork>
    4684:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4686:	07000593          	li	a1,112
    468a:	e119                	bnez	a0,4690 <sharedfd+0x56>
    468c:	06300593          	li	a1,99
    4690:	4629                	li	a2,10
    4692:	fa040513          	addi	a0,s0,-96
    4696:	00001097          	auipc	ra,0x1
    469a:	046080e7          	jalr	70(ra) # 56dc <memset>
    469e:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    46a2:	4629                	li	a2,10
    46a4:	fa040593          	addi	a1,s0,-96
    46a8:	854a                	mv	a0,s2
    46aa:	00001097          	auipc	ra,0x1
    46ae:	24c080e7          	jalr	588(ra) # 58f6 <write>
    46b2:	47a9                	li	a5,10
    46b4:	02f51f63          	bne	a0,a5,46f2 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    46b8:	34fd                	addiw	s1,s1,-1
    46ba:	f4e5                	bnez	s1,46a2 <sharedfd+0x68>
  if(pid == 0) {
    46bc:	04099963          	bnez	s3,470e <sharedfd+0xd4>
    exit(0);
    46c0:	4501                	li	a0,0
    46c2:	00001097          	auipc	ra,0x1
    46c6:	214080e7          	jalr	532(ra) # 58d6 <exit>
    46ca:	eca6                	sd	s1,88(sp)
    46cc:	e8ca                	sd	s2,80(sp)
    46ce:	e4ce                	sd	s3,72(sp)
    46d0:	fc56                	sd	s5,56(sp)
    46d2:	f85a                	sd	s6,48(sp)
    46d4:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    46d6:	85d2                	mv	a1,s4
    46d8:	00003517          	auipc	a0,0x3
    46dc:	33850513          	addi	a0,a0,824 # 7a10 <malloc+0x1d12>
    46e0:	00001097          	auipc	ra,0x1
    46e4:	566080e7          	jalr	1382(ra) # 5c46 <printf>
    exit(1);
    46e8:	4505                	li	a0,1
    46ea:	00001097          	auipc	ra,0x1
    46ee:	1ec080e7          	jalr	492(ra) # 58d6 <exit>
      printf("%s: write sharedfd failed\n", s);
    46f2:	85d2                	mv	a1,s4
    46f4:	00003517          	auipc	a0,0x3
    46f8:	34450513          	addi	a0,a0,836 # 7a38 <malloc+0x1d3a>
    46fc:	00001097          	auipc	ra,0x1
    4700:	54a080e7          	jalr	1354(ra) # 5c46 <printf>
      exit(1);
    4704:	4505                	li	a0,1
    4706:	00001097          	auipc	ra,0x1
    470a:	1d0080e7          	jalr	464(ra) # 58d6 <exit>
    wait(&xstatus);
    470e:	f9c40513          	addi	a0,s0,-100
    4712:	00001097          	auipc	ra,0x1
    4716:	1cc080e7          	jalr	460(ra) # 58de <wait>
    if(xstatus != 0)
    471a:	f9c42983          	lw	s3,-100(s0)
    471e:	00098763          	beqz	s3,472c <sharedfd+0xf2>
      exit(xstatus);
    4722:	854e                	mv	a0,s3
    4724:	00001097          	auipc	ra,0x1
    4728:	1b2080e7          	jalr	434(ra) # 58d6 <exit>
  close(fd);
    472c:	854a                	mv	a0,s2
    472e:	00001097          	auipc	ra,0x1
    4732:	1d0080e7          	jalr	464(ra) # 58fe <close>
  fd = open("sharedfd", 0);
    4736:	4581                	li	a1,0
    4738:	00003517          	auipc	a0,0x3
    473c:	2c850513          	addi	a0,a0,712 # 7a00 <malloc+0x1d02>
    4740:	00001097          	auipc	ra,0x1
    4744:	1d6080e7          	jalr	470(ra) # 5916 <open>
    4748:	8baa                	mv	s7,a0
  nc = np = 0;
    474a:	8ace                	mv	s5,s3
  if(fd < 0){
    474c:	02054563          	bltz	a0,4776 <sharedfd+0x13c>
    4750:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4754:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4758:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    475c:	4629                	li	a2,10
    475e:	fa040593          	addi	a1,s0,-96
    4762:	855e                	mv	a0,s7
    4764:	00001097          	auipc	ra,0x1
    4768:	18a080e7          	jalr	394(ra) # 58ee <read>
    476c:	02a05f63          	blez	a0,47aa <sharedfd+0x170>
    4770:	fa040793          	addi	a5,s0,-96
    4774:	a01d                	j	479a <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4776:	85d2                	mv	a1,s4
    4778:	00003517          	auipc	a0,0x3
    477c:	2e050513          	addi	a0,a0,736 # 7a58 <malloc+0x1d5a>
    4780:	00001097          	auipc	ra,0x1
    4784:	4c6080e7          	jalr	1222(ra) # 5c46 <printf>
    exit(1);
    4788:	4505                	li	a0,1
    478a:	00001097          	auipc	ra,0x1
    478e:	14c080e7          	jalr	332(ra) # 58d6 <exit>
        nc++;
    4792:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4794:	0785                	addi	a5,a5,1
    4796:	fd2783e3          	beq	a5,s2,475c <sharedfd+0x122>
      if(buf[i] == 'c')
    479a:	0007c703          	lbu	a4,0(a5)
    479e:	fe970ae3          	beq	a4,s1,4792 <sharedfd+0x158>
      if(buf[i] == 'p')
    47a2:	ff6719e3          	bne	a4,s6,4794 <sharedfd+0x15a>
        np++;
    47a6:	2a85                	addiw	s5,s5,1
    47a8:	b7f5                	j	4794 <sharedfd+0x15a>
  close(fd);
    47aa:	855e                	mv	a0,s7
    47ac:	00001097          	auipc	ra,0x1
    47b0:	152080e7          	jalr	338(ra) # 58fe <close>
  unlink("sharedfd");
    47b4:	00003517          	auipc	a0,0x3
    47b8:	24c50513          	addi	a0,a0,588 # 7a00 <malloc+0x1d02>
    47bc:	00001097          	auipc	ra,0x1
    47c0:	16a080e7          	jalr	362(ra) # 5926 <unlink>
  if(nc == N*SZ && np == N*SZ){
    47c4:	6789                	lui	a5,0x2
    47c6:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x68>
    47ca:	00f99763          	bne	s3,a5,47d8 <sharedfd+0x19e>
    47ce:	6789                	lui	a5,0x2
    47d0:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x68>
    47d4:	02fa8063          	beq	s5,a5,47f4 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    47d8:	85d2                	mv	a1,s4
    47da:	00003517          	auipc	a0,0x3
    47de:	2a650513          	addi	a0,a0,678 # 7a80 <malloc+0x1d82>
    47e2:	00001097          	auipc	ra,0x1
    47e6:	464080e7          	jalr	1124(ra) # 5c46 <printf>
    exit(1);
    47ea:	4505                	li	a0,1
    47ec:	00001097          	auipc	ra,0x1
    47f0:	0ea080e7          	jalr	234(ra) # 58d6 <exit>
    exit(0);
    47f4:	4501                	li	a0,0
    47f6:	00001097          	auipc	ra,0x1
    47fa:	0e0080e7          	jalr	224(ra) # 58d6 <exit>

00000000000047fe <fourfiles>:
{
    47fe:	7135                	addi	sp,sp,-160
    4800:	ed06                	sd	ra,152(sp)
    4802:	e922                	sd	s0,144(sp)
    4804:	e526                	sd	s1,136(sp)
    4806:	e14a                	sd	s2,128(sp)
    4808:	fcce                	sd	s3,120(sp)
    480a:	f8d2                	sd	s4,112(sp)
    480c:	f4d6                	sd	s5,104(sp)
    480e:	f0da                	sd	s6,96(sp)
    4810:	ecde                	sd	s7,88(sp)
    4812:	e8e2                	sd	s8,80(sp)
    4814:	e4e6                	sd	s9,72(sp)
    4816:	e0ea                	sd	s10,64(sp)
    4818:	fc6e                	sd	s11,56(sp)
    481a:	1100                	addi	s0,sp,160
    481c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    481e:	00003797          	auipc	a5,0x3
    4822:	27a78793          	addi	a5,a5,634 # 7a98 <malloc+0x1d9a>
    4826:	f6f43823          	sd	a5,-144(s0)
    482a:	00003797          	auipc	a5,0x3
    482e:	27678793          	addi	a5,a5,630 # 7aa0 <malloc+0x1da2>
    4832:	f6f43c23          	sd	a5,-136(s0)
    4836:	00003797          	auipc	a5,0x3
    483a:	27278793          	addi	a5,a5,626 # 7aa8 <malloc+0x1daa>
    483e:	f8f43023          	sd	a5,-128(s0)
    4842:	00003797          	auipc	a5,0x3
    4846:	26e78793          	addi	a5,a5,622 # 7ab0 <malloc+0x1db2>
    484a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    484e:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4852:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4854:	4481                	li	s1,0
    4856:	4a11                	li	s4,4
    fname = names[pi];
    4858:	00093983          	ld	s3,0(s2)
    unlink(fname);
    485c:	854e                	mv	a0,s3
    485e:	00001097          	auipc	ra,0x1
    4862:	0c8080e7          	jalr	200(ra) # 5926 <unlink>
    pid = fork();
    4866:	00001097          	auipc	ra,0x1
    486a:	068080e7          	jalr	104(ra) # 58ce <fork>
    if(pid < 0){
    486e:	04054063          	bltz	a0,48ae <fourfiles+0xb0>
    if(pid == 0){
    4872:	cd21                	beqz	a0,48ca <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4874:	2485                	addiw	s1,s1,1
    4876:	0921                	addi	s2,s2,8
    4878:	ff4490e3          	bne	s1,s4,4858 <fourfiles+0x5a>
    487c:	4491                	li	s1,4
    wait(&xstatus);
    487e:	f6c40513          	addi	a0,s0,-148
    4882:	00001097          	auipc	ra,0x1
    4886:	05c080e7          	jalr	92(ra) # 58de <wait>
    if(xstatus != 0)
    488a:	f6c42a83          	lw	s5,-148(s0)
    488e:	0c0a9863          	bnez	s5,495e <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4892:	34fd                	addiw	s1,s1,-1
    4894:	f4ed                	bnez	s1,487e <fourfiles+0x80>
    4896:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    489a:	00009a17          	auipc	s4,0x9
    489e:	83ea0a13          	addi	s4,s4,-1986 # d0d8 <buf>
    if(total != N*SZ){
    48a2:	6d05                	lui	s10,0x1
    48a4:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x16>
  for(i = 0; i < NCHILD; i++){
    48a8:	03400d93          	li	s11,52
    48ac:	a22d                	j	49d6 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    48ae:	85e6                	mv	a1,s9
    48b0:	00002517          	auipc	a0,0x2
    48b4:	20050513          	addi	a0,a0,512 # 6ab0 <malloc+0xdb2>
    48b8:	00001097          	auipc	ra,0x1
    48bc:	38e080e7          	jalr	910(ra) # 5c46 <printf>
      exit(1);
    48c0:	4505                	li	a0,1
    48c2:	00001097          	auipc	ra,0x1
    48c6:	014080e7          	jalr	20(ra) # 58d6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    48ca:	20200593          	li	a1,514
    48ce:	854e                	mv	a0,s3
    48d0:	00001097          	auipc	ra,0x1
    48d4:	046080e7          	jalr	70(ra) # 5916 <open>
    48d8:	892a                	mv	s2,a0
      if(fd < 0){
    48da:	04054763          	bltz	a0,4928 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    48de:	1f400613          	li	a2,500
    48e2:	0304859b          	addiw	a1,s1,48
    48e6:	00008517          	auipc	a0,0x8
    48ea:	7f250513          	addi	a0,a0,2034 # d0d8 <buf>
    48ee:	00001097          	auipc	ra,0x1
    48f2:	dee080e7          	jalr	-530(ra) # 56dc <memset>
    48f6:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    48f8:	00008997          	auipc	s3,0x8
    48fc:	7e098993          	addi	s3,s3,2016 # d0d8 <buf>
    4900:	1f400613          	li	a2,500
    4904:	85ce                	mv	a1,s3
    4906:	854a                	mv	a0,s2
    4908:	00001097          	auipc	ra,0x1
    490c:	fee080e7          	jalr	-18(ra) # 58f6 <write>
    4910:	85aa                	mv	a1,a0
    4912:	1f400793          	li	a5,500
    4916:	02f51763          	bne	a0,a5,4944 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    491a:	34fd                	addiw	s1,s1,-1
    491c:	f0f5                	bnez	s1,4900 <fourfiles+0x102>
      exit(0);
    491e:	4501                	li	a0,0
    4920:	00001097          	auipc	ra,0x1
    4924:	fb6080e7          	jalr	-74(ra) # 58d6 <exit>
        printf("create failed\n", s);
    4928:	85e6                	mv	a1,s9
    492a:	00003517          	auipc	a0,0x3
    492e:	18e50513          	addi	a0,a0,398 # 7ab8 <malloc+0x1dba>
    4932:	00001097          	auipc	ra,0x1
    4936:	314080e7          	jalr	788(ra) # 5c46 <printf>
        exit(1);
    493a:	4505                	li	a0,1
    493c:	00001097          	auipc	ra,0x1
    4940:	f9a080e7          	jalr	-102(ra) # 58d6 <exit>
          printf("write failed %d\n", n);
    4944:	00003517          	auipc	a0,0x3
    4948:	18450513          	addi	a0,a0,388 # 7ac8 <malloc+0x1dca>
    494c:	00001097          	auipc	ra,0x1
    4950:	2fa080e7          	jalr	762(ra) # 5c46 <printf>
          exit(1);
    4954:	4505                	li	a0,1
    4956:	00001097          	auipc	ra,0x1
    495a:	f80080e7          	jalr	-128(ra) # 58d6 <exit>
      exit(xstatus);
    495e:	8556                	mv	a0,s5
    4960:	00001097          	auipc	ra,0x1
    4964:	f76080e7          	jalr	-138(ra) # 58d6 <exit>
          printf("wrong char\n", s);
    4968:	85e6                	mv	a1,s9
    496a:	00003517          	auipc	a0,0x3
    496e:	17650513          	addi	a0,a0,374 # 7ae0 <malloc+0x1de2>
    4972:	00001097          	auipc	ra,0x1
    4976:	2d4080e7          	jalr	724(ra) # 5c46 <printf>
          exit(1);
    497a:	4505                	li	a0,1
    497c:	00001097          	auipc	ra,0x1
    4980:	f5a080e7          	jalr	-166(ra) # 58d6 <exit>
      total += n;
    4984:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4988:	660d                	lui	a2,0x3
    498a:	85d2                	mv	a1,s4
    498c:	854e                	mv	a0,s3
    498e:	00001097          	auipc	ra,0x1
    4992:	f60080e7          	jalr	-160(ra) # 58ee <read>
    4996:	02a05063          	blez	a0,49b6 <fourfiles+0x1b8>
    499a:	00008797          	auipc	a5,0x8
    499e:	73e78793          	addi	a5,a5,1854 # d0d8 <buf>
    49a2:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    49a6:	0007c703          	lbu	a4,0(a5)
    49aa:	fa971fe3          	bne	a4,s1,4968 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    49ae:	0785                	addi	a5,a5,1
    49b0:	fed79be3          	bne	a5,a3,49a6 <fourfiles+0x1a8>
    49b4:	bfc1                	j	4984 <fourfiles+0x186>
    close(fd);
    49b6:	854e                	mv	a0,s3
    49b8:	00001097          	auipc	ra,0x1
    49bc:	f46080e7          	jalr	-186(ra) # 58fe <close>
    if(total != N*SZ){
    49c0:	03a91863          	bne	s2,s10,49f0 <fourfiles+0x1f2>
    unlink(fname);
    49c4:	8562                	mv	a0,s8
    49c6:	00001097          	auipc	ra,0x1
    49ca:	f60080e7          	jalr	-160(ra) # 5926 <unlink>
  for(i = 0; i < NCHILD; i++){
    49ce:	0ba1                	addi	s7,s7,8
    49d0:	2b05                	addiw	s6,s6,1
    49d2:	03bb0d63          	beq	s6,s11,4a0c <fourfiles+0x20e>
    fname = names[i];
    49d6:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    49da:	4581                	li	a1,0
    49dc:	8562                	mv	a0,s8
    49de:	00001097          	auipc	ra,0x1
    49e2:	f38080e7          	jalr	-200(ra) # 5916 <open>
    49e6:	89aa                	mv	s3,a0
    total = 0;
    49e8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    49ea:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    49ee:	bf69                	j	4988 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    49f0:	85ca                	mv	a1,s2
    49f2:	00003517          	auipc	a0,0x3
    49f6:	0fe50513          	addi	a0,a0,254 # 7af0 <malloc+0x1df2>
    49fa:	00001097          	auipc	ra,0x1
    49fe:	24c080e7          	jalr	588(ra) # 5c46 <printf>
      exit(1);
    4a02:	4505                	li	a0,1
    4a04:	00001097          	auipc	ra,0x1
    4a08:	ed2080e7          	jalr	-302(ra) # 58d6 <exit>
}
    4a0c:	60ea                	ld	ra,152(sp)
    4a0e:	644a                	ld	s0,144(sp)
    4a10:	64aa                	ld	s1,136(sp)
    4a12:	690a                	ld	s2,128(sp)
    4a14:	79e6                	ld	s3,120(sp)
    4a16:	7a46                	ld	s4,112(sp)
    4a18:	7aa6                	ld	s5,104(sp)
    4a1a:	7b06                	ld	s6,96(sp)
    4a1c:	6be6                	ld	s7,88(sp)
    4a1e:	6c46                	ld	s8,80(sp)
    4a20:	6ca6                	ld	s9,72(sp)
    4a22:	6d06                	ld	s10,64(sp)
    4a24:	7de2                	ld	s11,56(sp)
    4a26:	610d                	addi	sp,sp,160
    4a28:	8082                	ret

0000000000004a2a <concreate>:
{
    4a2a:	7135                	addi	sp,sp,-160
    4a2c:	ed06                	sd	ra,152(sp)
    4a2e:	e922                	sd	s0,144(sp)
    4a30:	e526                	sd	s1,136(sp)
    4a32:	e14a                	sd	s2,128(sp)
    4a34:	fcce                	sd	s3,120(sp)
    4a36:	f8d2                	sd	s4,112(sp)
    4a38:	f4d6                	sd	s5,104(sp)
    4a3a:	f0da                	sd	s6,96(sp)
    4a3c:	ecde                	sd	s7,88(sp)
    4a3e:	1100                	addi	s0,sp,160
    4a40:	89aa                	mv	s3,a0
  file[0] = 'C';
    4a42:	04300793          	li	a5,67
    4a46:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4a4a:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4a4e:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4a50:	4b0d                	li	s6,3
    4a52:	4a85                	li	s5,1
      link("C0", file);
    4a54:	00003b97          	auipc	s7,0x3
    4a58:	0b4b8b93          	addi	s7,s7,180 # 7b08 <malloc+0x1e0a>
  for(i = 0; i < N; i++){
    4a5c:	02800a13          	li	s4,40
    4a60:	acc9                	j	4d32 <concreate+0x308>
      link("C0", file);
    4a62:	fa840593          	addi	a1,s0,-88
    4a66:	855e                	mv	a0,s7
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	ece080e7          	jalr	-306(ra) # 5936 <link>
    if(pid == 0) {
    4a70:	a465                	j	4d18 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4a72:	4795                	li	a5,5
    4a74:	02f9693b          	remw	s2,s2,a5
    4a78:	4785                	li	a5,1
    4a7a:	02f90b63          	beq	s2,a5,4ab0 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a7e:	20200593          	li	a1,514
    4a82:	fa840513          	addi	a0,s0,-88
    4a86:	00001097          	auipc	ra,0x1
    4a8a:	e90080e7          	jalr	-368(ra) # 5916 <open>
      if(fd < 0){
    4a8e:	26055c63          	bgez	a0,4d06 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4a92:	fa840593          	addi	a1,s0,-88
    4a96:	00003517          	auipc	a0,0x3
    4a9a:	07a50513          	addi	a0,a0,122 # 7b10 <malloc+0x1e12>
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	1a8080e7          	jalr	424(ra) # 5c46 <printf>
        exit(1);
    4aa6:	4505                	li	a0,1
    4aa8:	00001097          	auipc	ra,0x1
    4aac:	e2e080e7          	jalr	-466(ra) # 58d6 <exit>
      link("C0", file);
    4ab0:	fa840593          	addi	a1,s0,-88
    4ab4:	00003517          	auipc	a0,0x3
    4ab8:	05450513          	addi	a0,a0,84 # 7b08 <malloc+0x1e0a>
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	e7a080e7          	jalr	-390(ra) # 5936 <link>
      exit(0);
    4ac4:	4501                	li	a0,0
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	e10080e7          	jalr	-496(ra) # 58d6 <exit>
        exit(1);
    4ace:	4505                	li	a0,1
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	e06080e7          	jalr	-506(ra) # 58d6 <exit>
  memset(fa, 0, sizeof(fa));
    4ad8:	02800613          	li	a2,40
    4adc:	4581                	li	a1,0
    4ade:	f8040513          	addi	a0,s0,-128
    4ae2:	00001097          	auipc	ra,0x1
    4ae6:	bfa080e7          	jalr	-1030(ra) # 56dc <memset>
  fd = open(".", 0);
    4aea:	4581                	li	a1,0
    4aec:	00002517          	auipc	a0,0x2
    4af0:	a0450513          	addi	a0,a0,-1532 # 64f0 <malloc+0x7f2>
    4af4:	00001097          	auipc	ra,0x1
    4af8:	e22080e7          	jalr	-478(ra) # 5916 <open>
    4afc:	892a                	mv	s2,a0
  n = 0;
    4afe:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4b00:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4b04:	02700b13          	li	s6,39
      fa[i] = 1;
    4b08:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4b0a:	4641                	li	a2,16
    4b0c:	f7040593          	addi	a1,s0,-144
    4b10:	854a                	mv	a0,s2
    4b12:	00001097          	auipc	ra,0x1
    4b16:	ddc080e7          	jalr	-548(ra) # 58ee <read>
    4b1a:	08a05263          	blez	a0,4b9e <concreate+0x174>
    if(de.inum == 0)
    4b1e:	f7045783          	lhu	a5,-144(s0)
    4b22:	d7e5                	beqz	a5,4b0a <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4b24:	f7244783          	lbu	a5,-142(s0)
    4b28:	ff4791e3          	bne	a5,s4,4b0a <concreate+0xe0>
    4b2c:	f7444783          	lbu	a5,-140(s0)
    4b30:	ffe9                	bnez	a5,4b0a <concreate+0xe0>
      i = de.name[1] - '0';
    4b32:	f7344783          	lbu	a5,-141(s0)
    4b36:	fd07879b          	addiw	a5,a5,-48
    4b3a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4b3e:	02eb6063          	bltu	s6,a4,4b5e <concreate+0x134>
      if(fa[i]){
    4b42:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x4e>
    4b46:	97a2                	add	a5,a5,s0
    4b48:	fd07c783          	lbu	a5,-48(a5)
    4b4c:	eb8d                	bnez	a5,4b7e <concreate+0x154>
      fa[i] = 1;
    4b4e:	fb070793          	addi	a5,a4,-80
    4b52:	00878733          	add	a4,a5,s0
    4b56:	fd770823          	sb	s7,-48(a4)
      n++;
    4b5a:	2a85                	addiw	s5,s5,1
    4b5c:	b77d                	j	4b0a <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4b5e:	f7240613          	addi	a2,s0,-142
    4b62:	85ce                	mv	a1,s3
    4b64:	00003517          	auipc	a0,0x3
    4b68:	fcc50513          	addi	a0,a0,-52 # 7b30 <malloc+0x1e32>
    4b6c:	00001097          	auipc	ra,0x1
    4b70:	0da080e7          	jalr	218(ra) # 5c46 <printf>
        exit(1);
    4b74:	4505                	li	a0,1
    4b76:	00001097          	auipc	ra,0x1
    4b7a:	d60080e7          	jalr	-672(ra) # 58d6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b7e:	f7240613          	addi	a2,s0,-142
    4b82:	85ce                	mv	a1,s3
    4b84:	00003517          	auipc	a0,0x3
    4b88:	fcc50513          	addi	a0,a0,-52 # 7b50 <malloc+0x1e52>
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	0ba080e7          	jalr	186(ra) # 5c46 <printf>
        exit(1);
    4b94:	4505                	li	a0,1
    4b96:	00001097          	auipc	ra,0x1
    4b9a:	d40080e7          	jalr	-704(ra) # 58d6 <exit>
  close(fd);
    4b9e:	854a                	mv	a0,s2
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	d5e080e7          	jalr	-674(ra) # 58fe <close>
  if(n != N){
    4ba8:	02800793          	li	a5,40
    4bac:	00fa9763          	bne	s5,a5,4bba <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4bb0:	4a8d                	li	s5,3
    4bb2:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4bb4:	02800a13          	li	s4,40
    4bb8:	a8c9                	j	4c8a <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4bba:	85ce                	mv	a1,s3
    4bbc:	00003517          	auipc	a0,0x3
    4bc0:	fbc50513          	addi	a0,a0,-68 # 7b78 <malloc+0x1e7a>
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	082080e7          	jalr	130(ra) # 5c46 <printf>
    exit(1);
    4bcc:	4505                	li	a0,1
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	d08080e7          	jalr	-760(ra) # 58d6 <exit>
      printf("%s: fork failed\n", s);
    4bd6:	85ce                	mv	a1,s3
    4bd8:	00002517          	auipc	a0,0x2
    4bdc:	ab850513          	addi	a0,a0,-1352 # 6690 <malloc+0x992>
    4be0:	00001097          	auipc	ra,0x1
    4be4:	066080e7          	jalr	102(ra) # 5c46 <printf>
      exit(1);
    4be8:	4505                	li	a0,1
    4bea:	00001097          	auipc	ra,0x1
    4bee:	cec080e7          	jalr	-788(ra) # 58d6 <exit>
      close(open(file, 0));
    4bf2:	4581                	li	a1,0
    4bf4:	fa840513          	addi	a0,s0,-88
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	d1e080e7          	jalr	-738(ra) # 5916 <open>
    4c00:	00001097          	auipc	ra,0x1
    4c04:	cfe080e7          	jalr	-770(ra) # 58fe <close>
      close(open(file, 0));
    4c08:	4581                	li	a1,0
    4c0a:	fa840513          	addi	a0,s0,-88
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	d08080e7          	jalr	-760(ra) # 5916 <open>
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	ce8080e7          	jalr	-792(ra) # 58fe <close>
      close(open(file, 0));
    4c1e:	4581                	li	a1,0
    4c20:	fa840513          	addi	a0,s0,-88
    4c24:	00001097          	auipc	ra,0x1
    4c28:	cf2080e7          	jalr	-782(ra) # 5916 <open>
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	cd2080e7          	jalr	-814(ra) # 58fe <close>
      close(open(file, 0));
    4c34:	4581                	li	a1,0
    4c36:	fa840513          	addi	a0,s0,-88
    4c3a:	00001097          	auipc	ra,0x1
    4c3e:	cdc080e7          	jalr	-804(ra) # 5916 <open>
    4c42:	00001097          	auipc	ra,0x1
    4c46:	cbc080e7          	jalr	-836(ra) # 58fe <close>
      close(open(file, 0));
    4c4a:	4581                	li	a1,0
    4c4c:	fa840513          	addi	a0,s0,-88
    4c50:	00001097          	auipc	ra,0x1
    4c54:	cc6080e7          	jalr	-826(ra) # 5916 <open>
    4c58:	00001097          	auipc	ra,0x1
    4c5c:	ca6080e7          	jalr	-858(ra) # 58fe <close>
      close(open(file, 0));
    4c60:	4581                	li	a1,0
    4c62:	fa840513          	addi	a0,s0,-88
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	cb0080e7          	jalr	-848(ra) # 5916 <open>
    4c6e:	00001097          	auipc	ra,0x1
    4c72:	c90080e7          	jalr	-880(ra) # 58fe <close>
    if(pid == 0)
    4c76:	08090363          	beqz	s2,4cfc <concreate+0x2d2>
      wait(0);
    4c7a:	4501                	li	a0,0
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	c62080e7          	jalr	-926(ra) # 58de <wait>
  for(i = 0; i < N; i++){
    4c84:	2485                	addiw	s1,s1,1
    4c86:	0f448563          	beq	s1,s4,4d70 <concreate+0x346>
    file[1] = '0' + i;
    4c8a:	0304879b          	addiw	a5,s1,48
    4c8e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c92:	00001097          	auipc	ra,0x1
    4c96:	c3c080e7          	jalr	-964(ra) # 58ce <fork>
    4c9a:	892a                	mv	s2,a0
    if(pid < 0){
    4c9c:	f2054de3          	bltz	a0,4bd6 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4ca0:	0354e73b          	remw	a4,s1,s5
    4ca4:	00a767b3          	or	a5,a4,a0
    4ca8:	2781                	sext.w	a5,a5
    4caa:	d7a1                	beqz	a5,4bf2 <concreate+0x1c8>
    4cac:	01671363          	bne	a4,s6,4cb2 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4cb0:	f129                	bnez	a0,4bf2 <concreate+0x1c8>
      unlink(file);
    4cb2:	fa840513          	addi	a0,s0,-88
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	c70080e7          	jalr	-912(ra) # 5926 <unlink>
      unlink(file);
    4cbe:	fa840513          	addi	a0,s0,-88
    4cc2:	00001097          	auipc	ra,0x1
    4cc6:	c64080e7          	jalr	-924(ra) # 5926 <unlink>
      unlink(file);
    4cca:	fa840513          	addi	a0,s0,-88
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	c58080e7          	jalr	-936(ra) # 5926 <unlink>
      unlink(file);
    4cd6:	fa840513          	addi	a0,s0,-88
    4cda:	00001097          	auipc	ra,0x1
    4cde:	c4c080e7          	jalr	-948(ra) # 5926 <unlink>
      unlink(file);
    4ce2:	fa840513          	addi	a0,s0,-88
    4ce6:	00001097          	auipc	ra,0x1
    4cea:	c40080e7          	jalr	-960(ra) # 5926 <unlink>
      unlink(file);
    4cee:	fa840513          	addi	a0,s0,-88
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	c34080e7          	jalr	-972(ra) # 5926 <unlink>
    4cfa:	bfb5                	j	4c76 <concreate+0x24c>
      exit(0);
    4cfc:	4501                	li	a0,0
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	bd8080e7          	jalr	-1064(ra) # 58d6 <exit>
      close(fd);
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	bf8080e7          	jalr	-1032(ra) # 58fe <close>
    if(pid == 0) {
    4d0e:	bb5d                	j	4ac4 <concreate+0x9a>
      close(fd);
    4d10:	00001097          	auipc	ra,0x1
    4d14:	bee080e7          	jalr	-1042(ra) # 58fe <close>
      wait(&xstatus);
    4d18:	f6c40513          	addi	a0,s0,-148
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	bc2080e7          	jalr	-1086(ra) # 58de <wait>
      if(xstatus != 0)
    4d24:	f6c42483          	lw	s1,-148(s0)
    4d28:	da0493e3          	bnez	s1,4ace <concreate+0xa4>
  for(i = 0; i < N; i++){
    4d2c:	2905                	addiw	s2,s2,1
    4d2e:	db4905e3          	beq	s2,s4,4ad8 <concreate+0xae>
    file[1] = '0' + i;
    4d32:	0309079b          	addiw	a5,s2,48
    4d36:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4d3a:	fa840513          	addi	a0,s0,-88
    4d3e:	00001097          	auipc	ra,0x1
    4d42:	be8080e7          	jalr	-1048(ra) # 5926 <unlink>
    pid = fork();
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	b88080e7          	jalr	-1144(ra) # 58ce <fork>
    if(pid && (i % 3) == 1){
    4d4e:	d20502e3          	beqz	a0,4a72 <concreate+0x48>
    4d52:	036967bb          	remw	a5,s2,s6
    4d56:	d15786e3          	beq	a5,s5,4a62 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4d5a:	20200593          	li	a1,514
    4d5e:	fa840513          	addi	a0,s0,-88
    4d62:	00001097          	auipc	ra,0x1
    4d66:	bb4080e7          	jalr	-1100(ra) # 5916 <open>
      if(fd < 0){
    4d6a:	fa0553e3          	bgez	a0,4d10 <concreate+0x2e6>
    4d6e:	b315                	j	4a92 <concreate+0x68>
}
    4d70:	60ea                	ld	ra,152(sp)
    4d72:	644a                	ld	s0,144(sp)
    4d74:	64aa                	ld	s1,136(sp)
    4d76:	690a                	ld	s2,128(sp)
    4d78:	79e6                	ld	s3,120(sp)
    4d7a:	7a46                	ld	s4,112(sp)
    4d7c:	7aa6                	ld	s5,104(sp)
    4d7e:	7b06                	ld	s6,96(sp)
    4d80:	6be6                	ld	s7,88(sp)
    4d82:	610d                	addi	sp,sp,160
    4d84:	8082                	ret

0000000000004d86 <bigfile>:
{
    4d86:	7139                	addi	sp,sp,-64
    4d88:	fc06                	sd	ra,56(sp)
    4d8a:	f822                	sd	s0,48(sp)
    4d8c:	f426                	sd	s1,40(sp)
    4d8e:	f04a                	sd	s2,32(sp)
    4d90:	ec4e                	sd	s3,24(sp)
    4d92:	e852                	sd	s4,16(sp)
    4d94:	e456                	sd	s5,8(sp)
    4d96:	0080                	addi	s0,sp,64
    4d98:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d9a:	00003517          	auipc	a0,0x3
    4d9e:	e1650513          	addi	a0,a0,-490 # 7bb0 <malloc+0x1eb2>
    4da2:	00001097          	auipc	ra,0x1
    4da6:	b84080e7          	jalr	-1148(ra) # 5926 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4daa:	20200593          	li	a1,514
    4dae:	00003517          	auipc	a0,0x3
    4db2:	e0250513          	addi	a0,a0,-510 # 7bb0 <malloc+0x1eb2>
    4db6:	00001097          	auipc	ra,0x1
    4dba:	b60080e7          	jalr	-1184(ra) # 5916 <open>
    4dbe:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4dc0:	4481                	li	s1,0
    memset(buf, i, SZ);
    4dc2:	00008917          	auipc	s2,0x8
    4dc6:	31690913          	addi	s2,s2,790 # d0d8 <buf>
  for(i = 0; i < N; i++){
    4dca:	4a51                	li	s4,20
  if(fd < 0){
    4dcc:	0a054063          	bltz	a0,4e6c <bigfile+0xe6>
    memset(buf, i, SZ);
    4dd0:	25800613          	li	a2,600
    4dd4:	85a6                	mv	a1,s1
    4dd6:	854a                	mv	a0,s2
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	904080e7          	jalr	-1788(ra) # 56dc <memset>
    if(write(fd, buf, SZ) != SZ){
    4de0:	25800613          	li	a2,600
    4de4:	85ca                	mv	a1,s2
    4de6:	854e                	mv	a0,s3
    4de8:	00001097          	auipc	ra,0x1
    4dec:	b0e080e7          	jalr	-1266(ra) # 58f6 <write>
    4df0:	25800793          	li	a5,600
    4df4:	08f51a63          	bne	a0,a5,4e88 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4df8:	2485                	addiw	s1,s1,1
    4dfa:	fd449be3          	bne	s1,s4,4dd0 <bigfile+0x4a>
  close(fd);
    4dfe:	854e                	mv	a0,s3
    4e00:	00001097          	auipc	ra,0x1
    4e04:	afe080e7          	jalr	-1282(ra) # 58fe <close>
  fd = open("bigfile.dat", 0);
    4e08:	4581                	li	a1,0
    4e0a:	00003517          	auipc	a0,0x3
    4e0e:	da650513          	addi	a0,a0,-602 # 7bb0 <malloc+0x1eb2>
    4e12:	00001097          	auipc	ra,0x1
    4e16:	b04080e7          	jalr	-1276(ra) # 5916 <open>
    4e1a:	8a2a                	mv	s4,a0
  total = 0;
    4e1c:	4981                	li	s3,0
  for(i = 0; ; i++){
    4e1e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4e20:	00008917          	auipc	s2,0x8
    4e24:	2b890913          	addi	s2,s2,696 # d0d8 <buf>
  if(fd < 0){
    4e28:	06054e63          	bltz	a0,4ea4 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4e2c:	12c00613          	li	a2,300
    4e30:	85ca                	mv	a1,s2
    4e32:	8552                	mv	a0,s4
    4e34:	00001097          	auipc	ra,0x1
    4e38:	aba080e7          	jalr	-1350(ra) # 58ee <read>
    if(cc < 0){
    4e3c:	08054263          	bltz	a0,4ec0 <bigfile+0x13a>
    if(cc == 0)
    4e40:	c971                	beqz	a0,4f14 <bigfile+0x18e>
    if(cc != SZ/2){
    4e42:	12c00793          	li	a5,300
    4e46:	08f51b63          	bne	a0,a5,4edc <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4e4a:	01f4d79b          	srliw	a5,s1,0x1f
    4e4e:	9fa5                	addw	a5,a5,s1
    4e50:	4017d79b          	sraiw	a5,a5,0x1
    4e54:	00094703          	lbu	a4,0(s2)
    4e58:	0af71063          	bne	a4,a5,4ef8 <bigfile+0x172>
    4e5c:	12b94703          	lbu	a4,299(s2)
    4e60:	08f71c63          	bne	a4,a5,4ef8 <bigfile+0x172>
    total += cc;
    4e64:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e68:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e6a:	b7c9                	j	4e2c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e6c:	85d6                	mv	a1,s5
    4e6e:	00003517          	auipc	a0,0x3
    4e72:	d5250513          	addi	a0,a0,-686 # 7bc0 <malloc+0x1ec2>
    4e76:	00001097          	auipc	ra,0x1
    4e7a:	dd0080e7          	jalr	-560(ra) # 5c46 <printf>
    exit(1);
    4e7e:	4505                	li	a0,1
    4e80:	00001097          	auipc	ra,0x1
    4e84:	a56080e7          	jalr	-1450(ra) # 58d6 <exit>
      printf("%s: write bigfile failed\n", s);
    4e88:	85d6                	mv	a1,s5
    4e8a:	00003517          	auipc	a0,0x3
    4e8e:	d5650513          	addi	a0,a0,-682 # 7be0 <malloc+0x1ee2>
    4e92:	00001097          	auipc	ra,0x1
    4e96:	db4080e7          	jalr	-588(ra) # 5c46 <printf>
      exit(1);
    4e9a:	4505                	li	a0,1
    4e9c:	00001097          	auipc	ra,0x1
    4ea0:	a3a080e7          	jalr	-1478(ra) # 58d6 <exit>
    printf("%s: cannot open bigfile\n", s);
    4ea4:	85d6                	mv	a1,s5
    4ea6:	00003517          	auipc	a0,0x3
    4eaa:	d5a50513          	addi	a0,a0,-678 # 7c00 <malloc+0x1f02>
    4eae:	00001097          	auipc	ra,0x1
    4eb2:	d98080e7          	jalr	-616(ra) # 5c46 <printf>
    exit(1);
    4eb6:	4505                	li	a0,1
    4eb8:	00001097          	auipc	ra,0x1
    4ebc:	a1e080e7          	jalr	-1506(ra) # 58d6 <exit>
      printf("%s: read bigfile failed\n", s);
    4ec0:	85d6                	mv	a1,s5
    4ec2:	00003517          	auipc	a0,0x3
    4ec6:	d5e50513          	addi	a0,a0,-674 # 7c20 <malloc+0x1f22>
    4eca:	00001097          	auipc	ra,0x1
    4ece:	d7c080e7          	jalr	-644(ra) # 5c46 <printf>
      exit(1);
    4ed2:	4505                	li	a0,1
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	a02080e7          	jalr	-1534(ra) # 58d6 <exit>
      printf("%s: short read bigfile\n", s);
    4edc:	85d6                	mv	a1,s5
    4ede:	00003517          	auipc	a0,0x3
    4ee2:	d6250513          	addi	a0,a0,-670 # 7c40 <malloc+0x1f42>
    4ee6:	00001097          	auipc	ra,0x1
    4eea:	d60080e7          	jalr	-672(ra) # 5c46 <printf>
      exit(1);
    4eee:	4505                	li	a0,1
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	9e6080e7          	jalr	-1562(ra) # 58d6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4ef8:	85d6                	mv	a1,s5
    4efa:	00003517          	auipc	a0,0x3
    4efe:	d5e50513          	addi	a0,a0,-674 # 7c58 <malloc+0x1f5a>
    4f02:	00001097          	auipc	ra,0x1
    4f06:	d44080e7          	jalr	-700(ra) # 5c46 <printf>
      exit(1);
    4f0a:	4505                	li	a0,1
    4f0c:	00001097          	auipc	ra,0x1
    4f10:	9ca080e7          	jalr	-1590(ra) # 58d6 <exit>
  close(fd);
    4f14:	8552                	mv	a0,s4
    4f16:	00001097          	auipc	ra,0x1
    4f1a:	9e8080e7          	jalr	-1560(ra) # 58fe <close>
  if(total != N*SZ){
    4f1e:	678d                	lui	a5,0x3
    4f20:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0xb0>
    4f24:	02f99363          	bne	s3,a5,4f4a <bigfile+0x1c4>
  unlink("bigfile.dat");
    4f28:	00003517          	auipc	a0,0x3
    4f2c:	c8850513          	addi	a0,a0,-888 # 7bb0 <malloc+0x1eb2>
    4f30:	00001097          	auipc	ra,0x1
    4f34:	9f6080e7          	jalr	-1546(ra) # 5926 <unlink>
}
    4f38:	70e2                	ld	ra,56(sp)
    4f3a:	7442                	ld	s0,48(sp)
    4f3c:	74a2                	ld	s1,40(sp)
    4f3e:	7902                	ld	s2,32(sp)
    4f40:	69e2                	ld	s3,24(sp)
    4f42:	6a42                	ld	s4,16(sp)
    4f44:	6aa2                	ld	s5,8(sp)
    4f46:	6121                	addi	sp,sp,64
    4f48:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4f4a:	85d6                	mv	a1,s5
    4f4c:	00003517          	auipc	a0,0x3
    4f50:	d2c50513          	addi	a0,a0,-724 # 7c78 <malloc+0x1f7a>
    4f54:	00001097          	auipc	ra,0x1
    4f58:	cf2080e7          	jalr	-782(ra) # 5c46 <printf>
    exit(1);
    4f5c:	4505                	li	a0,1
    4f5e:	00001097          	auipc	ra,0x1
    4f62:	978080e7          	jalr	-1672(ra) # 58d6 <exit>

0000000000004f66 <fsfull>:
{
    4f66:	7135                	addi	sp,sp,-160
    4f68:	ed06                	sd	ra,152(sp)
    4f6a:	e922                	sd	s0,144(sp)
    4f6c:	e526                	sd	s1,136(sp)
    4f6e:	e14a                	sd	s2,128(sp)
    4f70:	fcce                	sd	s3,120(sp)
    4f72:	f8d2                	sd	s4,112(sp)
    4f74:	f4d6                	sd	s5,104(sp)
    4f76:	f0da                	sd	s6,96(sp)
    4f78:	ecde                	sd	s7,88(sp)
    4f7a:	e8e2                	sd	s8,80(sp)
    4f7c:	e4e6                	sd	s9,72(sp)
    4f7e:	e0ea                	sd	s10,64(sp)
    4f80:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    4f82:	00003517          	auipc	a0,0x3
    4f86:	d1650513          	addi	a0,a0,-746 # 7c98 <malloc+0x1f9a>
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	cbc080e7          	jalr	-836(ra) # 5c46 <printf>
  for(nfiles = 0; ; nfiles++){
    4f92:	4481                	li	s1,0
    name[0] = 'f';
    4f94:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f98:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f9c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4fa0:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4fa2:	00003c97          	auipc	s9,0x3
    4fa6:	d06c8c93          	addi	s9,s9,-762 # 7ca8 <malloc+0x1faa>
    name[0] = 'f';
    4faa:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4fae:	0384c7bb          	divw	a5,s1,s8
    4fb2:	0307879b          	addiw	a5,a5,48
    4fb6:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4fba:	0384e7bb          	remw	a5,s1,s8
    4fbe:	0377c7bb          	divw	a5,a5,s7
    4fc2:	0307879b          	addiw	a5,a5,48
    4fc6:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4fca:	0374e7bb          	remw	a5,s1,s7
    4fce:	0367c7bb          	divw	a5,a5,s6
    4fd2:	0307879b          	addiw	a5,a5,48
    4fd6:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4fda:	0364e7bb          	remw	a5,s1,s6
    4fde:	0307879b          	addiw	a5,a5,48
    4fe2:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4fe6:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4fea:	f6040593          	addi	a1,s0,-160
    4fee:	8566                	mv	a0,s9
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	c56080e7          	jalr	-938(ra) # 5c46 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ff8:	20200593          	li	a1,514
    4ffc:	f6040513          	addi	a0,s0,-160
    5000:	00001097          	auipc	ra,0x1
    5004:	916080e7          	jalr	-1770(ra) # 5916 <open>
    5008:	892a                	mv	s2,a0
    if(fd < 0){
    500a:	0a055563          	bgez	a0,50b4 <fsfull+0x14e>
      printf("open %s failed\n", name);
    500e:	f6040593          	addi	a1,s0,-160
    5012:	00003517          	auipc	a0,0x3
    5016:	ca650513          	addi	a0,a0,-858 # 7cb8 <malloc+0x1fba>
    501a:	00001097          	auipc	ra,0x1
    501e:	c2c080e7          	jalr	-980(ra) # 5c46 <printf>
  while(nfiles >= 0){
    5022:	0604c363          	bltz	s1,5088 <fsfull+0x122>
    name[0] = 'f';
    5026:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    502a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    502e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5032:	4929                	li	s2,10
  while(nfiles >= 0){
    5034:	5afd                	li	s5,-1
    name[0] = 'f';
    5036:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    503a:	0344c7bb          	divw	a5,s1,s4
    503e:	0307879b          	addiw	a5,a5,48
    5042:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5046:	0344e7bb          	remw	a5,s1,s4
    504a:	0337c7bb          	divw	a5,a5,s3
    504e:	0307879b          	addiw	a5,a5,48
    5052:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5056:	0334e7bb          	remw	a5,s1,s3
    505a:	0327c7bb          	divw	a5,a5,s2
    505e:	0307879b          	addiw	a5,a5,48
    5062:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5066:	0324e7bb          	remw	a5,s1,s2
    506a:	0307879b          	addiw	a5,a5,48
    506e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5072:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5076:	f6040513          	addi	a0,s0,-160
    507a:	00001097          	auipc	ra,0x1
    507e:	8ac080e7          	jalr	-1876(ra) # 5926 <unlink>
    nfiles--;
    5082:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5084:	fb5499e3          	bne	s1,s5,5036 <fsfull+0xd0>
  printf("fsfull test finished\n");
    5088:	00003517          	auipc	a0,0x3
    508c:	c5050513          	addi	a0,a0,-944 # 7cd8 <malloc+0x1fda>
    5090:	00001097          	auipc	ra,0x1
    5094:	bb6080e7          	jalr	-1098(ra) # 5c46 <printf>
}
    5098:	60ea                	ld	ra,152(sp)
    509a:	644a                	ld	s0,144(sp)
    509c:	64aa                	ld	s1,136(sp)
    509e:	690a                	ld	s2,128(sp)
    50a0:	79e6                	ld	s3,120(sp)
    50a2:	7a46                	ld	s4,112(sp)
    50a4:	7aa6                	ld	s5,104(sp)
    50a6:	7b06                	ld	s6,96(sp)
    50a8:	6be6                	ld	s7,88(sp)
    50aa:	6c46                	ld	s8,80(sp)
    50ac:	6ca6                	ld	s9,72(sp)
    50ae:	6d06                	ld	s10,64(sp)
    50b0:	610d                	addi	sp,sp,160
    50b2:	8082                	ret
    int total = 0;
    50b4:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    50b6:	00008a97          	auipc	s5,0x8
    50ba:	022a8a93          	addi	s5,s5,34 # d0d8 <buf>
      if(cc < BSIZE)
    50be:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    50c2:	40000613          	li	a2,1024
    50c6:	85d6                	mv	a1,s5
    50c8:	854a                	mv	a0,s2
    50ca:	00001097          	auipc	ra,0x1
    50ce:	82c080e7          	jalr	-2004(ra) # 58f6 <write>
      if(cc < BSIZE)
    50d2:	00aa5563          	bge	s4,a0,50dc <fsfull+0x176>
      total += cc;
    50d6:	00a989bb          	addw	s3,s3,a0
    while(1){
    50da:	b7e5                	j	50c2 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    50dc:	85ce                	mv	a1,s3
    50de:	00003517          	auipc	a0,0x3
    50e2:	bea50513          	addi	a0,a0,-1046 # 7cc8 <malloc+0x1fca>
    50e6:	00001097          	auipc	ra,0x1
    50ea:	b60080e7          	jalr	-1184(ra) # 5c46 <printf>
    close(fd);
    50ee:	854a                	mv	a0,s2
    50f0:	00001097          	auipc	ra,0x1
    50f4:	80e080e7          	jalr	-2034(ra) # 58fe <close>
    if(total == 0)
    50f8:	f20985e3          	beqz	s3,5022 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    50fc:	2485                	addiw	s1,s1,1
    50fe:	b575                	j	4faa <fsfull+0x44>

0000000000005100 <badwrite>:
{
    5100:	7179                	addi	sp,sp,-48
    5102:	f406                	sd	ra,40(sp)
    5104:	f022                	sd	s0,32(sp)
    5106:	ec26                	sd	s1,24(sp)
    5108:	e84a                	sd	s2,16(sp)
    510a:	e44e                	sd	s3,8(sp)
    510c:	e052                	sd	s4,0(sp)
    510e:	1800                	addi	s0,sp,48
  unlink("junk");
    5110:	00003517          	auipc	a0,0x3
    5114:	be050513          	addi	a0,a0,-1056 # 7cf0 <malloc+0x1ff2>
    5118:	00001097          	auipc	ra,0x1
    511c:	80e080e7          	jalr	-2034(ra) # 5926 <unlink>
    5120:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    5124:	00003997          	auipc	s3,0x3
    5128:	bcc98993          	addi	s3,s3,-1076 # 7cf0 <malloc+0x1ff2>
    write(fd, (char*)0xffffffffffL, 1);
    512c:	5a7d                	li	s4,-1
    512e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    5132:	20100593          	li	a1,513
    5136:	854e                	mv	a0,s3
    5138:	00000097          	auipc	ra,0x0
    513c:	7de080e7          	jalr	2014(ra) # 5916 <open>
    5140:	84aa                	mv	s1,a0
    if(fd < 0){
    5142:	06054b63          	bltz	a0,51b8 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    5146:	4605                	li	a2,1
    5148:	85d2                	mv	a1,s4
    514a:	00000097          	auipc	ra,0x0
    514e:	7ac080e7          	jalr	1964(ra) # 58f6 <write>
    close(fd);
    5152:	8526                	mv	a0,s1
    5154:	00000097          	auipc	ra,0x0
    5158:	7aa080e7          	jalr	1962(ra) # 58fe <close>
    unlink("junk");
    515c:	854e                	mv	a0,s3
    515e:	00000097          	auipc	ra,0x0
    5162:	7c8080e7          	jalr	1992(ra) # 5926 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5166:	397d                	addiw	s2,s2,-1
    5168:	fc0915e3          	bnez	s2,5132 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    516c:	20100593          	li	a1,513
    5170:	00003517          	auipc	a0,0x3
    5174:	b8050513          	addi	a0,a0,-1152 # 7cf0 <malloc+0x1ff2>
    5178:	00000097          	auipc	ra,0x0
    517c:	79e080e7          	jalr	1950(ra) # 5916 <open>
    5180:	84aa                	mv	s1,a0
  if(fd < 0){
    5182:	04054863          	bltz	a0,51d2 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5186:	4605                	li	a2,1
    5188:	00001597          	auipc	a1,0x1
    518c:	d2058593          	addi	a1,a1,-736 # 5ea8 <malloc+0x1aa>
    5190:	00000097          	auipc	ra,0x0
    5194:	766080e7          	jalr	1894(ra) # 58f6 <write>
    5198:	4785                	li	a5,1
    519a:	04f50963          	beq	a0,a5,51ec <badwrite+0xec>
    printf("write failed\n");
    519e:	00003517          	auipc	a0,0x3
    51a2:	b7250513          	addi	a0,a0,-1166 # 7d10 <malloc+0x2012>
    51a6:	00001097          	auipc	ra,0x1
    51aa:	aa0080e7          	jalr	-1376(ra) # 5c46 <printf>
    exit(1);
    51ae:	4505                	li	a0,1
    51b0:	00000097          	auipc	ra,0x0
    51b4:	726080e7          	jalr	1830(ra) # 58d6 <exit>
      printf("open junk failed\n");
    51b8:	00003517          	auipc	a0,0x3
    51bc:	b4050513          	addi	a0,a0,-1216 # 7cf8 <malloc+0x1ffa>
    51c0:	00001097          	auipc	ra,0x1
    51c4:	a86080e7          	jalr	-1402(ra) # 5c46 <printf>
      exit(1);
    51c8:	4505                	li	a0,1
    51ca:	00000097          	auipc	ra,0x0
    51ce:	70c080e7          	jalr	1804(ra) # 58d6 <exit>
    printf("open junk failed\n");
    51d2:	00003517          	auipc	a0,0x3
    51d6:	b2650513          	addi	a0,a0,-1242 # 7cf8 <malloc+0x1ffa>
    51da:	00001097          	auipc	ra,0x1
    51de:	a6c080e7          	jalr	-1428(ra) # 5c46 <printf>
    exit(1);
    51e2:	4505                	li	a0,1
    51e4:	00000097          	auipc	ra,0x0
    51e8:	6f2080e7          	jalr	1778(ra) # 58d6 <exit>
  close(fd);
    51ec:	8526                	mv	a0,s1
    51ee:	00000097          	auipc	ra,0x0
    51f2:	710080e7          	jalr	1808(ra) # 58fe <close>
  unlink("junk");
    51f6:	00003517          	auipc	a0,0x3
    51fa:	afa50513          	addi	a0,a0,-1286 # 7cf0 <malloc+0x1ff2>
    51fe:	00000097          	auipc	ra,0x0
    5202:	728080e7          	jalr	1832(ra) # 5926 <unlink>
  exit(0);
    5206:	4501                	li	a0,0
    5208:	00000097          	auipc	ra,0x0
    520c:	6ce080e7          	jalr	1742(ra) # 58d6 <exit>

0000000000005210 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5210:	7139                	addi	sp,sp,-64
    5212:	fc06                	sd	ra,56(sp)
    5214:	f822                	sd	s0,48(sp)
    5216:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5218:	fc840513          	addi	a0,s0,-56
    521c:	00000097          	auipc	ra,0x0
    5220:	6ca080e7          	jalr	1738(ra) # 58e6 <pipe>
    5224:	06054a63          	bltz	a0,5298 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5228:	00000097          	auipc	ra,0x0
    522c:	6a6080e7          	jalr	1702(ra) # 58ce <fork>

  if(pid < 0){
    5230:	08054463          	bltz	a0,52b8 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5234:	e55d                	bnez	a0,52e2 <countfree+0xd2>
    5236:	f426                	sd	s1,40(sp)
    5238:	f04a                	sd	s2,32(sp)
    523a:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    523c:	fc842503          	lw	a0,-56(s0)
    5240:	00000097          	auipc	ra,0x0
    5244:	6be080e7          	jalr	1726(ra) # 58fe <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5248:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    524a:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    524c:	00001997          	auipc	s3,0x1
    5250:	c5c98993          	addi	s3,s3,-932 # 5ea8 <malloc+0x1aa>
      uint64 a = (uint64) sbrk(4096);
    5254:	6505                	lui	a0,0x1
    5256:	00000097          	auipc	ra,0x0
    525a:	708080e7          	jalr	1800(ra) # 595e <sbrk>
      if(a == 0xffffffffffffffff){
    525e:	07250d63          	beq	a0,s2,52d8 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    5262:	6785                	lui	a5,0x1
    5264:	97aa                	add	a5,a5,a0
    5266:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    526a:	8626                	mv	a2,s1
    526c:	85ce                	mv	a1,s3
    526e:	fcc42503          	lw	a0,-52(s0)
    5272:	00000097          	auipc	ra,0x0
    5276:	684080e7          	jalr	1668(ra) # 58f6 <write>
    527a:	fc950de3          	beq	a0,s1,5254 <countfree+0x44>
        printf("write() failed in countfree()\n");
    527e:	00003517          	auipc	a0,0x3
    5282:	ae250513          	addi	a0,a0,-1310 # 7d60 <malloc+0x2062>
    5286:	00001097          	auipc	ra,0x1
    528a:	9c0080e7          	jalr	-1600(ra) # 5c46 <printf>
        exit(1);
    528e:	4505                	li	a0,1
    5290:	00000097          	auipc	ra,0x0
    5294:	646080e7          	jalr	1606(ra) # 58d6 <exit>
    5298:	f426                	sd	s1,40(sp)
    529a:	f04a                	sd	s2,32(sp)
    529c:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    529e:	00003517          	auipc	a0,0x3
    52a2:	a8250513          	addi	a0,a0,-1406 # 7d20 <malloc+0x2022>
    52a6:	00001097          	auipc	ra,0x1
    52aa:	9a0080e7          	jalr	-1632(ra) # 5c46 <printf>
    exit(1);
    52ae:	4505                	li	a0,1
    52b0:	00000097          	auipc	ra,0x0
    52b4:	626080e7          	jalr	1574(ra) # 58d6 <exit>
    52b8:	f426                	sd	s1,40(sp)
    52ba:	f04a                	sd	s2,32(sp)
    52bc:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    52be:	00003517          	auipc	a0,0x3
    52c2:	a8250513          	addi	a0,a0,-1406 # 7d40 <malloc+0x2042>
    52c6:	00001097          	auipc	ra,0x1
    52ca:	980080e7          	jalr	-1664(ra) # 5c46 <printf>
    exit(1);
    52ce:	4505                	li	a0,1
    52d0:	00000097          	auipc	ra,0x0
    52d4:	606080e7          	jalr	1542(ra) # 58d6 <exit>
      }
    }

    exit(0);
    52d8:	4501                	li	a0,0
    52da:	00000097          	auipc	ra,0x0
    52de:	5fc080e7          	jalr	1532(ra) # 58d6 <exit>
    52e2:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    52e4:	fcc42503          	lw	a0,-52(s0)
    52e8:	00000097          	auipc	ra,0x0
    52ec:	616080e7          	jalr	1558(ra) # 58fe <close>

  int n = 0;
    52f0:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    52f2:	4605                	li	a2,1
    52f4:	fc740593          	addi	a1,s0,-57
    52f8:	fc842503          	lw	a0,-56(s0)
    52fc:	00000097          	auipc	ra,0x0
    5300:	5f2080e7          	jalr	1522(ra) # 58ee <read>
    if(cc < 0){
    5304:	00054563          	bltz	a0,530e <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5308:	c115                	beqz	a0,532c <countfree+0x11c>
      break;
    n += 1;
    530a:	2485                	addiw	s1,s1,1
  while(1){
    530c:	b7dd                	j	52f2 <countfree+0xe2>
    530e:	f04a                	sd	s2,32(sp)
    5310:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    5312:	00003517          	auipc	a0,0x3
    5316:	a6e50513          	addi	a0,a0,-1426 # 7d80 <malloc+0x2082>
    531a:	00001097          	auipc	ra,0x1
    531e:	92c080e7          	jalr	-1748(ra) # 5c46 <printf>
      exit(1);
    5322:	4505                	li	a0,1
    5324:	00000097          	auipc	ra,0x0
    5328:	5b2080e7          	jalr	1458(ra) # 58d6 <exit>
  }

  close(fds[0]);
    532c:	fc842503          	lw	a0,-56(s0)
    5330:	00000097          	auipc	ra,0x0
    5334:	5ce080e7          	jalr	1486(ra) # 58fe <close>
  wait((int*)0);
    5338:	4501                	li	a0,0
    533a:	00000097          	auipc	ra,0x0
    533e:	5a4080e7          	jalr	1444(ra) # 58de <wait>
  
  return n;
}
    5342:	8526                	mv	a0,s1
    5344:	74a2                	ld	s1,40(sp)
    5346:	70e2                	ld	ra,56(sp)
    5348:	7442                	ld	s0,48(sp)
    534a:	6121                	addi	sp,sp,64
    534c:	8082                	ret

000000000000534e <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    534e:	7179                	addi	sp,sp,-48
    5350:	f406                	sd	ra,40(sp)
    5352:	f022                	sd	s0,32(sp)
    5354:	ec26                	sd	s1,24(sp)
    5356:	e84a                	sd	s2,16(sp)
    5358:	1800                	addi	s0,sp,48
    535a:	84aa                	mv	s1,a0
    535c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    535e:	00003517          	auipc	a0,0x3
    5362:	a4250513          	addi	a0,a0,-1470 # 7da0 <malloc+0x20a2>
    5366:	00001097          	auipc	ra,0x1
    536a:	8e0080e7          	jalr	-1824(ra) # 5c46 <printf>
  if((pid = fork()) < 0) {
    536e:	00000097          	auipc	ra,0x0
    5372:	560080e7          	jalr	1376(ra) # 58ce <fork>
    5376:	02054e63          	bltz	a0,53b2 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    537a:	c929                	beqz	a0,53cc <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    537c:	fdc40513          	addi	a0,s0,-36
    5380:	00000097          	auipc	ra,0x0
    5384:	55e080e7          	jalr	1374(ra) # 58de <wait>
    if(xstatus != 0) 
    5388:	fdc42783          	lw	a5,-36(s0)
    538c:	c7b9                	beqz	a5,53da <run+0x8c>
      printf("FAILED\n");
    538e:	00003517          	auipc	a0,0x3
    5392:	a3a50513          	addi	a0,a0,-1478 # 7dc8 <malloc+0x20ca>
    5396:	00001097          	auipc	ra,0x1
    539a:	8b0080e7          	jalr	-1872(ra) # 5c46 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    539e:	fdc42503          	lw	a0,-36(s0)
  }
}
    53a2:	00153513          	seqz	a0,a0
    53a6:	70a2                	ld	ra,40(sp)
    53a8:	7402                	ld	s0,32(sp)
    53aa:	64e2                	ld	s1,24(sp)
    53ac:	6942                	ld	s2,16(sp)
    53ae:	6145                	addi	sp,sp,48
    53b0:	8082                	ret
    printf("runtest: fork error\n");
    53b2:	00003517          	auipc	a0,0x3
    53b6:	9fe50513          	addi	a0,a0,-1538 # 7db0 <malloc+0x20b2>
    53ba:	00001097          	auipc	ra,0x1
    53be:	88c080e7          	jalr	-1908(ra) # 5c46 <printf>
    exit(1);
    53c2:	4505                	li	a0,1
    53c4:	00000097          	auipc	ra,0x0
    53c8:	512080e7          	jalr	1298(ra) # 58d6 <exit>
    f(s);
    53cc:	854a                	mv	a0,s2
    53ce:	9482                	jalr	s1
    exit(0);
    53d0:	4501                	li	a0,0
    53d2:	00000097          	auipc	ra,0x0
    53d6:	504080e7          	jalr	1284(ra) # 58d6 <exit>
      printf("OK\n");
    53da:	00003517          	auipc	a0,0x3
    53de:	9f650513          	addi	a0,a0,-1546 # 7dd0 <malloc+0x20d2>
    53e2:	00001097          	auipc	ra,0x1
    53e6:	864080e7          	jalr	-1948(ra) # 5c46 <printf>
    53ea:	bf55                	j	539e <run+0x50>

00000000000053ec <main>:

int
main(int argc, char *argv[])
{
    53ec:	bd010113          	addi	sp,sp,-1072
    53f0:	42113423          	sd	ra,1064(sp)
    53f4:	42813023          	sd	s0,1056(sp)
    53f8:	41313423          	sd	s3,1032(sp)
    53fc:	43010413          	addi	s0,sp,1072
    5400:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5402:	4789                	li	a5,2
    5404:	0af50a63          	beq	a0,a5,54b8 <main+0xcc>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5408:	4785                	li	a5,1
    540a:	16a7c263          	blt	a5,a0,556e <main+0x182>
  char *justone = 0;
    540e:	4981                	li	s3,0
    5410:	40913c23          	sd	s1,1048(sp)
    5414:	41213823          	sd	s2,1040(sp)
    5418:	41413023          	sd	s4,1024(sp)
    541c:	3f513c23          	sd	s5,1016(sp)
    5420:	3f613823          	sd	s6,1008(sp)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5424:	00003797          	auipc	a5,0x3
    5428:	dcc78793          	addi	a5,a5,-564 # 81f0 <malloc+0x24f2>
    542c:	bd040713          	addi	a4,s0,-1072
    5430:	00003317          	auipc	t1,0x3
    5434:	1b030313          	addi	t1,t1,432 # 85e0 <malloc+0x28e2>
    5438:	0007b883          	ld	a7,0(a5)
    543c:	0087b803          	ld	a6,8(a5)
    5440:	6b88                	ld	a0,16(a5)
    5442:	6f8c                	ld	a1,24(a5)
    5444:	7390                	ld	a2,32(a5)
    5446:	7794                	ld	a3,40(a5)
    5448:	01173023          	sd	a7,0(a4)
    544c:	01073423          	sd	a6,8(a4)
    5450:	eb08                	sd	a0,16(a4)
    5452:	ef0c                	sd	a1,24(a4)
    5454:	f310                	sd	a2,32(a4)
    5456:	f714                	sd	a3,40(a4)
    5458:	03078793          	addi	a5,a5,48
    545c:	03070713          	addi	a4,a4,48
    5460:	fc679ce3          	bne	a5,t1,5438 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5464:	00003517          	auipc	a0,0x3
    5468:	a2c50513          	addi	a0,a0,-1492 # 7e90 <malloc+0x2192>
    546c:	00000097          	auipc	ra,0x0
    5470:	7da080e7          	jalr	2010(ra) # 5c46 <printf>
  int free0 = countfree();
    5474:	00000097          	auipc	ra,0x0
    5478:	d9c080e7          	jalr	-612(ra) # 5210 <countfree>
    547c:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    547e:	bd843903          	ld	s2,-1064(s0)
    5482:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5486:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5488:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    548a:	14091163          	bnez	s2,55cc <main+0x1e0>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    548e:	00000097          	auipc	ra,0x0
    5492:	d82080e7          	jalr	-638(ra) # 5210 <countfree>
    5496:	85aa                	mv	a1,a0
    5498:	17555b63          	bge	a0,s5,560e <main+0x222>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    549c:	8656                	mv	a2,s5
    549e:	00003517          	auipc	a0,0x3
    54a2:	9aa50513          	addi	a0,a0,-1622 # 7e48 <malloc+0x214a>
    54a6:	00000097          	auipc	ra,0x0
    54aa:	7a0080e7          	jalr	1952(ra) # 5c46 <printf>
    exit(1);
    54ae:	4505                	li	a0,1
    54b0:	00000097          	auipc	ra,0x0
    54b4:	426080e7          	jalr	1062(ra) # 58d6 <exit>
    54b8:	40913c23          	sd	s1,1048(sp)
    54bc:	41213823          	sd	s2,1040(sp)
    54c0:	41413023          	sd	s4,1024(sp)
    54c4:	3f513c23          	sd	s5,1016(sp)
    54c8:	3f613823          	sd	s6,1008(sp)
    54cc:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    54ce:	00003597          	auipc	a1,0x3
    54d2:	90a58593          	addi	a1,a1,-1782 # 7dd8 <malloc+0x20da>
    54d6:	6488                	ld	a0,8(s1)
    54d8:	00000097          	auipc	ra,0x0
    54dc:	1ae080e7          	jalr	430(ra) # 5686 <strcmp>
    54e0:	e525                	bnez	a0,5548 <main+0x15c>
    continuous = 1;
    54e2:	4985                	li	s3,1
  } tests[] = {
    54e4:	00003797          	auipc	a5,0x3
    54e8:	d0c78793          	addi	a5,a5,-756 # 81f0 <malloc+0x24f2>
    54ec:	bd040713          	addi	a4,s0,-1072
    54f0:	00003317          	auipc	t1,0x3
    54f4:	0f030313          	addi	t1,t1,240 # 85e0 <malloc+0x28e2>
    54f8:	0007b883          	ld	a7,0(a5)
    54fc:	0087b803          	ld	a6,8(a5)
    5500:	6b88                	ld	a0,16(a5)
    5502:	6f8c                	ld	a1,24(a5)
    5504:	7390                	ld	a2,32(a5)
    5506:	7794                	ld	a3,40(a5)
    5508:	01173023          	sd	a7,0(a4)
    550c:	01073423          	sd	a6,8(a4)
    5510:	eb08                	sd	a0,16(a4)
    5512:	ef0c                	sd	a1,24(a4)
    5514:	f310                	sd	a2,32(a4)
    5516:	f714                	sd	a3,40(a4)
    5518:	03078793          	addi	a5,a5,48
    551c:	03070713          	addi	a4,a4,48
    5520:	fc679ce3          	bne	a5,t1,54f8 <main+0x10c>
    printf("continuous usertests starting\n");
    5524:	00003517          	auipc	a0,0x3
    5528:	98450513          	addi	a0,a0,-1660 # 7ea8 <malloc+0x21aa>
    552c:	00000097          	auipc	ra,0x0
    5530:	71a080e7          	jalr	1818(ra) # 5c46 <printf>
        printf("SOME TESTS FAILED\n");
    5534:	00003a97          	auipc	s5,0x3
    5538:	8fca8a93          	addi	s5,s5,-1796 # 7e30 <malloc+0x2132>
        if(continuous != 2)
    553c:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    553e:	00003b17          	auipc	s6,0x3
    5542:	8d2b0b13          	addi	s6,s6,-1838 # 7e10 <malloc+0x2112>
    5546:	a8f5                	j	5642 <main+0x256>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5548:	00003597          	auipc	a1,0x3
    554c:	89858593          	addi	a1,a1,-1896 # 7de0 <malloc+0x20e2>
    5550:	6488                	ld	a0,8(s1)
    5552:	00000097          	auipc	ra,0x0
    5556:	134080e7          	jalr	308(ra) # 5686 <strcmp>
    555a:	d549                	beqz	a0,54e4 <main+0xf8>
  } else if(argc == 2 && argv[1][0] != '-'){
    555c:	0084b983          	ld	s3,8(s1)
    5560:	0009c703          	lbu	a4,0(s3)
    5564:	02d00793          	li	a5,45
    5568:	eaf71ee3          	bne	a4,a5,5424 <main+0x38>
    556c:	a819                	j	5582 <main+0x196>
    556e:	40913c23          	sd	s1,1048(sp)
    5572:	41213823          	sd	s2,1040(sp)
    5576:	41413023          	sd	s4,1024(sp)
    557a:	3f513c23          	sd	s5,1016(sp)
    557e:	3f613823          	sd	s6,1008(sp)
    printf("Usage: usertests [-c] [testname]\n");
    5582:	00003517          	auipc	a0,0x3
    5586:	86650513          	addi	a0,a0,-1946 # 7de8 <malloc+0x20ea>
    558a:	00000097          	auipc	ra,0x0
    558e:	6bc080e7          	jalr	1724(ra) # 5c46 <printf>
    exit(1);
    5592:	4505                	li	a0,1
    5594:	00000097          	auipc	ra,0x0
    5598:	342080e7          	jalr	834(ra) # 58d6 <exit>
          exit(1);
    559c:	4505                	li	a0,1
    559e:	00000097          	auipc	ra,0x0
    55a2:	338080e7          	jalr	824(ra) # 58d6 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55a6:	40a905bb          	subw	a1,s2,a0
    55aa:	855a                	mv	a0,s6
    55ac:	00000097          	auipc	ra,0x0
    55b0:	69a080e7          	jalr	1690(ra) # 5c46 <printf>
        if(continuous != 2)
    55b4:	09498763          	beq	s3,s4,5642 <main+0x256>
          exit(1);
    55b8:	4505                	li	a0,1
    55ba:	00000097          	auipc	ra,0x0
    55be:	31c080e7          	jalr	796(ra) # 58d6 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    55c2:	04c1                	addi	s1,s1,16
    55c4:	0084b903          	ld	s2,8(s1)
    55c8:	02090463          	beqz	s2,55f0 <main+0x204>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55cc:	00098963          	beqz	s3,55de <main+0x1f2>
    55d0:	85ce                	mv	a1,s3
    55d2:	854a                	mv	a0,s2
    55d4:	00000097          	auipc	ra,0x0
    55d8:	0b2080e7          	jalr	178(ra) # 5686 <strcmp>
    55dc:	f17d                	bnez	a0,55c2 <main+0x1d6>
      if(!run(t->f, t->s))
    55de:	85ca                	mv	a1,s2
    55e0:	6088                	ld	a0,0(s1)
    55e2:	00000097          	auipc	ra,0x0
    55e6:	d6c080e7          	jalr	-660(ra) # 534e <run>
    55ea:	fd61                	bnez	a0,55c2 <main+0x1d6>
        fail = 1;
    55ec:	8a5a                	mv	s4,s6
    55ee:	bfd1                	j	55c2 <main+0x1d6>
  if(fail){
    55f0:	e80a0fe3          	beqz	s4,548e <main+0xa2>
    printf("SOME TESTS FAILED\n");
    55f4:	00003517          	auipc	a0,0x3
    55f8:	83c50513          	addi	a0,a0,-1988 # 7e30 <malloc+0x2132>
    55fc:	00000097          	auipc	ra,0x0
    5600:	64a080e7          	jalr	1610(ra) # 5c46 <printf>
    exit(1);
    5604:	4505                	li	a0,1
    5606:	00000097          	auipc	ra,0x0
    560a:	2d0080e7          	jalr	720(ra) # 58d6 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    560e:	00003517          	auipc	a0,0x3
    5612:	86a50513          	addi	a0,a0,-1942 # 7e78 <malloc+0x217a>
    5616:	00000097          	auipc	ra,0x0
    561a:	630080e7          	jalr	1584(ra) # 5c46 <printf>
    exit(0);
    561e:	4501                	li	a0,0
    5620:	00000097          	auipc	ra,0x0
    5624:	2b6080e7          	jalr	694(ra) # 58d6 <exit>
        printf("SOME TESTS FAILED\n");
    5628:	8556                	mv	a0,s5
    562a:	00000097          	auipc	ra,0x0
    562e:	61c080e7          	jalr	1564(ra) # 5c46 <printf>
        if(continuous != 2)
    5632:	f74995e3          	bne	s3,s4,559c <main+0x1b0>
      int free1 = countfree();
    5636:	00000097          	auipc	ra,0x0
    563a:	bda080e7          	jalr	-1062(ra) # 5210 <countfree>
      if(free1 < free0){
    563e:	f72544e3          	blt	a0,s2,55a6 <main+0x1ba>
      int free0 = countfree();
    5642:	00000097          	auipc	ra,0x0
    5646:	bce080e7          	jalr	-1074(ra) # 5210 <countfree>
    564a:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    564c:	bd843583          	ld	a1,-1064(s0)
    5650:	d1fd                	beqz	a1,5636 <main+0x24a>
    5652:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    5656:	6088                	ld	a0,0(s1)
    5658:	00000097          	auipc	ra,0x0
    565c:	cf6080e7          	jalr	-778(ra) # 534e <run>
    5660:	d561                	beqz	a0,5628 <main+0x23c>
      for (struct test *t = tests; t->s != 0; t++) {
    5662:	04c1                	addi	s1,s1,16
    5664:	648c                	ld	a1,8(s1)
    5666:	f9e5                	bnez	a1,5656 <main+0x26a>
    5668:	b7f9                	j	5636 <main+0x24a>

000000000000566a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    566a:	1141                	addi	sp,sp,-16
    566c:	e422                	sd	s0,8(sp)
    566e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5670:	87aa                	mv	a5,a0
    5672:	0585                	addi	a1,a1,1
    5674:	0785                	addi	a5,a5,1
    5676:	fff5c703          	lbu	a4,-1(a1)
    567a:	fee78fa3          	sb	a4,-1(a5)
    567e:	fb75                	bnez	a4,5672 <strcpy+0x8>
    ;
  return os;
}
    5680:	6422                	ld	s0,8(sp)
    5682:	0141                	addi	sp,sp,16
    5684:	8082                	ret

0000000000005686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5686:	1141                	addi	sp,sp,-16
    5688:	e422                	sd	s0,8(sp)
    568a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    568c:	00054783          	lbu	a5,0(a0)
    5690:	cb91                	beqz	a5,56a4 <strcmp+0x1e>
    5692:	0005c703          	lbu	a4,0(a1)
    5696:	00f71763          	bne	a4,a5,56a4 <strcmp+0x1e>
    p++, q++;
    569a:	0505                	addi	a0,a0,1
    569c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    569e:	00054783          	lbu	a5,0(a0)
    56a2:	fbe5                	bnez	a5,5692 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    56a4:	0005c503          	lbu	a0,0(a1)
}
    56a8:	40a7853b          	subw	a0,a5,a0
    56ac:	6422                	ld	s0,8(sp)
    56ae:	0141                	addi	sp,sp,16
    56b0:	8082                	ret

00000000000056b2 <strlen>:

uint
strlen(const char *s)
{
    56b2:	1141                	addi	sp,sp,-16
    56b4:	e422                	sd	s0,8(sp)
    56b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    56b8:	00054783          	lbu	a5,0(a0)
    56bc:	cf91                	beqz	a5,56d8 <strlen+0x26>
    56be:	0505                	addi	a0,a0,1
    56c0:	87aa                	mv	a5,a0
    56c2:	86be                	mv	a3,a5
    56c4:	0785                	addi	a5,a5,1
    56c6:	fff7c703          	lbu	a4,-1(a5)
    56ca:	ff65                	bnez	a4,56c2 <strlen+0x10>
    56cc:	40a6853b          	subw	a0,a3,a0
    56d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    56d2:	6422                	ld	s0,8(sp)
    56d4:	0141                	addi	sp,sp,16
    56d6:	8082                	ret
  for(n = 0; s[n]; n++)
    56d8:	4501                	li	a0,0
    56da:	bfe5                	j	56d2 <strlen+0x20>

00000000000056dc <memset>:

void*
memset(void *dst, int c, uint n)
{
    56dc:	1141                	addi	sp,sp,-16
    56de:	e422                	sd	s0,8(sp)
    56e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    56e2:	ca19                	beqz	a2,56f8 <memset+0x1c>
    56e4:	87aa                	mv	a5,a0
    56e6:	1602                	slli	a2,a2,0x20
    56e8:	9201                	srli	a2,a2,0x20
    56ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    56ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    56f2:	0785                	addi	a5,a5,1
    56f4:	fee79de3          	bne	a5,a4,56ee <memset+0x12>
  }
  return dst;
}
    56f8:	6422                	ld	s0,8(sp)
    56fa:	0141                	addi	sp,sp,16
    56fc:	8082                	ret

00000000000056fe <strchr>:

char*
strchr(const char *s, char c)
{
    56fe:	1141                	addi	sp,sp,-16
    5700:	e422                	sd	s0,8(sp)
    5702:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5704:	00054783          	lbu	a5,0(a0)
    5708:	cb99                	beqz	a5,571e <strchr+0x20>
    if(*s == c)
    570a:	00f58763          	beq	a1,a5,5718 <strchr+0x1a>
  for(; *s; s++)
    570e:	0505                	addi	a0,a0,1
    5710:	00054783          	lbu	a5,0(a0)
    5714:	fbfd                	bnez	a5,570a <strchr+0xc>
      return (char*)s;
  return 0;
    5716:	4501                	li	a0,0
}
    5718:	6422                	ld	s0,8(sp)
    571a:	0141                	addi	sp,sp,16
    571c:	8082                	ret
  return 0;
    571e:	4501                	li	a0,0
    5720:	bfe5                	j	5718 <strchr+0x1a>

0000000000005722 <gets>:

char*
gets(char *buf, int max)
{
    5722:	711d                	addi	sp,sp,-96
    5724:	ec86                	sd	ra,88(sp)
    5726:	e8a2                	sd	s0,80(sp)
    5728:	e4a6                	sd	s1,72(sp)
    572a:	e0ca                	sd	s2,64(sp)
    572c:	fc4e                	sd	s3,56(sp)
    572e:	f852                	sd	s4,48(sp)
    5730:	f456                	sd	s5,40(sp)
    5732:	f05a                	sd	s6,32(sp)
    5734:	ec5e                	sd	s7,24(sp)
    5736:	1080                	addi	s0,sp,96
    5738:	8baa                	mv	s7,a0
    573a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    573c:	892a                	mv	s2,a0
    573e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5740:	4aa9                	li	s5,10
    5742:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5744:	89a6                	mv	s3,s1
    5746:	2485                	addiw	s1,s1,1
    5748:	0344d863          	bge	s1,s4,5778 <gets+0x56>
    cc = read(0, &c, 1);
    574c:	4605                	li	a2,1
    574e:	faf40593          	addi	a1,s0,-81
    5752:	4501                	li	a0,0
    5754:	00000097          	auipc	ra,0x0
    5758:	19a080e7          	jalr	410(ra) # 58ee <read>
    if(cc < 1)
    575c:	00a05e63          	blez	a0,5778 <gets+0x56>
    buf[i++] = c;
    5760:	faf44783          	lbu	a5,-81(s0)
    5764:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5768:	01578763          	beq	a5,s5,5776 <gets+0x54>
    576c:	0905                	addi	s2,s2,1
    576e:	fd679be3          	bne	a5,s6,5744 <gets+0x22>
    buf[i++] = c;
    5772:	89a6                	mv	s3,s1
    5774:	a011                	j	5778 <gets+0x56>
    5776:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5778:	99de                	add	s3,s3,s7
    577a:	00098023          	sb	zero,0(s3)
  return buf;
}
    577e:	855e                	mv	a0,s7
    5780:	60e6                	ld	ra,88(sp)
    5782:	6446                	ld	s0,80(sp)
    5784:	64a6                	ld	s1,72(sp)
    5786:	6906                	ld	s2,64(sp)
    5788:	79e2                	ld	s3,56(sp)
    578a:	7a42                	ld	s4,48(sp)
    578c:	7aa2                	ld	s5,40(sp)
    578e:	7b02                	ld	s6,32(sp)
    5790:	6be2                	ld	s7,24(sp)
    5792:	6125                	addi	sp,sp,96
    5794:	8082                	ret

0000000000005796 <stat>:

int
stat(const char *n, struct stat *st)
{
    5796:	1101                	addi	sp,sp,-32
    5798:	ec06                	sd	ra,24(sp)
    579a:	e822                	sd	s0,16(sp)
    579c:	e04a                	sd	s2,0(sp)
    579e:	1000                	addi	s0,sp,32
    57a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    57a2:	4581                	li	a1,0
    57a4:	00000097          	auipc	ra,0x0
    57a8:	172080e7          	jalr	370(ra) # 5916 <open>
  if(fd < 0)
    57ac:	02054663          	bltz	a0,57d8 <stat+0x42>
    57b0:	e426                	sd	s1,8(sp)
    57b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    57b4:	85ca                	mv	a1,s2
    57b6:	00000097          	auipc	ra,0x0
    57ba:	178080e7          	jalr	376(ra) # 592e <fstat>
    57be:	892a                	mv	s2,a0
  close(fd);
    57c0:	8526                	mv	a0,s1
    57c2:	00000097          	auipc	ra,0x0
    57c6:	13c080e7          	jalr	316(ra) # 58fe <close>
  return r;
    57ca:	64a2                	ld	s1,8(sp)
}
    57cc:	854a                	mv	a0,s2
    57ce:	60e2                	ld	ra,24(sp)
    57d0:	6442                	ld	s0,16(sp)
    57d2:	6902                	ld	s2,0(sp)
    57d4:	6105                	addi	sp,sp,32
    57d6:	8082                	ret
    return -1;
    57d8:	597d                	li	s2,-1
    57da:	bfcd                	j	57cc <stat+0x36>

00000000000057dc <atoi>:

int
atoi(const char *s)
{
    57dc:	1141                	addi	sp,sp,-16
    57de:	e422                	sd	s0,8(sp)
    57e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    57e2:	00054683          	lbu	a3,0(a0)
    57e6:	fd06879b          	addiw	a5,a3,-48
    57ea:	0ff7f793          	zext.b	a5,a5
    57ee:	4625                	li	a2,9
    57f0:	02f66863          	bltu	a2,a5,5820 <atoi+0x44>
    57f4:	872a                	mv	a4,a0
  n = 0;
    57f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    57f8:	0705                	addi	a4,a4,1
    57fa:	0025179b          	slliw	a5,a0,0x2
    57fe:	9fa9                	addw	a5,a5,a0
    5800:	0017979b          	slliw	a5,a5,0x1
    5804:	9fb5                	addw	a5,a5,a3
    5806:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    580a:	00074683          	lbu	a3,0(a4)
    580e:	fd06879b          	addiw	a5,a3,-48
    5812:	0ff7f793          	zext.b	a5,a5
    5816:	fef671e3          	bgeu	a2,a5,57f8 <atoi+0x1c>
  return n;
}
    581a:	6422                	ld	s0,8(sp)
    581c:	0141                	addi	sp,sp,16
    581e:	8082                	ret
  n = 0;
    5820:	4501                	li	a0,0
    5822:	bfe5                	j	581a <atoi+0x3e>

0000000000005824 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5824:	1141                	addi	sp,sp,-16
    5826:	e422                	sd	s0,8(sp)
    5828:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    582a:	02b57463          	bgeu	a0,a1,5852 <memmove+0x2e>
    while(n-- > 0)
    582e:	00c05f63          	blez	a2,584c <memmove+0x28>
    5832:	1602                	slli	a2,a2,0x20
    5834:	9201                	srli	a2,a2,0x20
    5836:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    583a:	872a                	mv	a4,a0
      *dst++ = *src++;
    583c:	0585                	addi	a1,a1,1
    583e:	0705                	addi	a4,a4,1
    5840:	fff5c683          	lbu	a3,-1(a1)
    5844:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5848:	fef71ae3          	bne	a4,a5,583c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    584c:	6422                	ld	s0,8(sp)
    584e:	0141                	addi	sp,sp,16
    5850:	8082                	ret
    dst += n;
    5852:	00c50733          	add	a4,a0,a2
    src += n;
    5856:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5858:	fec05ae3          	blez	a2,584c <memmove+0x28>
    585c:	fff6079b          	addiw	a5,a2,-1 # 2fff <iputtest+0x2b>
    5860:	1782                	slli	a5,a5,0x20
    5862:	9381                	srli	a5,a5,0x20
    5864:	fff7c793          	not	a5,a5
    5868:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    586a:	15fd                	addi	a1,a1,-1
    586c:	177d                	addi	a4,a4,-1
    586e:	0005c683          	lbu	a3,0(a1)
    5872:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5876:	fee79ae3          	bne	a5,a4,586a <memmove+0x46>
    587a:	bfc9                	j	584c <memmove+0x28>

000000000000587c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    587c:	1141                	addi	sp,sp,-16
    587e:	e422                	sd	s0,8(sp)
    5880:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5882:	ca05                	beqz	a2,58b2 <memcmp+0x36>
    5884:	fff6069b          	addiw	a3,a2,-1
    5888:	1682                	slli	a3,a3,0x20
    588a:	9281                	srli	a3,a3,0x20
    588c:	0685                	addi	a3,a3,1
    588e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5890:	00054783          	lbu	a5,0(a0)
    5894:	0005c703          	lbu	a4,0(a1)
    5898:	00e79863          	bne	a5,a4,58a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    589c:	0505                	addi	a0,a0,1
    p2++;
    589e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    58a0:	fed518e3          	bne	a0,a3,5890 <memcmp+0x14>
  }
  return 0;
    58a4:	4501                	li	a0,0
    58a6:	a019                	j	58ac <memcmp+0x30>
      return *p1 - *p2;
    58a8:	40e7853b          	subw	a0,a5,a4
}
    58ac:	6422                	ld	s0,8(sp)
    58ae:	0141                	addi	sp,sp,16
    58b0:	8082                	ret
  return 0;
    58b2:	4501                	li	a0,0
    58b4:	bfe5                	j	58ac <memcmp+0x30>

00000000000058b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    58b6:	1141                	addi	sp,sp,-16
    58b8:	e406                	sd	ra,8(sp)
    58ba:	e022                	sd	s0,0(sp)
    58bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    58be:	00000097          	auipc	ra,0x0
    58c2:	f66080e7          	jalr	-154(ra) # 5824 <memmove>
}
    58c6:	60a2                	ld	ra,8(sp)
    58c8:	6402                	ld	s0,0(sp)
    58ca:	0141                	addi	sp,sp,16
    58cc:	8082                	ret

00000000000058ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    58ce:	4885                	li	a7,1
 ecall
    58d0:	00000073          	ecall
 ret
    58d4:	8082                	ret

00000000000058d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    58d6:	4889                	li	a7,2
 ecall
    58d8:	00000073          	ecall
 ret
    58dc:	8082                	ret

00000000000058de <wait>:
.global wait
wait:
 li a7, SYS_wait
    58de:	488d                	li	a7,3
 ecall
    58e0:	00000073          	ecall
 ret
    58e4:	8082                	ret

00000000000058e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    58e6:	4891                	li	a7,4
 ecall
    58e8:	00000073          	ecall
 ret
    58ec:	8082                	ret

00000000000058ee <read>:
.global read
read:
 li a7, SYS_read
    58ee:	4895                	li	a7,5
 ecall
    58f0:	00000073          	ecall
 ret
    58f4:	8082                	ret

00000000000058f6 <write>:
.global write
write:
 li a7, SYS_write
    58f6:	48c1                	li	a7,16
 ecall
    58f8:	00000073          	ecall
 ret
    58fc:	8082                	ret

00000000000058fe <close>:
.global close
close:
 li a7, SYS_close
    58fe:	48d5                	li	a7,21
 ecall
    5900:	00000073          	ecall
 ret
    5904:	8082                	ret

0000000000005906 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5906:	4899                	li	a7,6
 ecall
    5908:	00000073          	ecall
 ret
    590c:	8082                	ret

000000000000590e <exec>:
.global exec
exec:
 li a7, SYS_exec
    590e:	489d                	li	a7,7
 ecall
    5910:	00000073          	ecall
 ret
    5914:	8082                	ret

0000000000005916 <open>:
.global open
open:
 li a7, SYS_open
    5916:	48bd                	li	a7,15
 ecall
    5918:	00000073          	ecall
 ret
    591c:	8082                	ret

000000000000591e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    591e:	48c5                	li	a7,17
 ecall
    5920:	00000073          	ecall
 ret
    5924:	8082                	ret

0000000000005926 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5926:	48c9                	li	a7,18
 ecall
    5928:	00000073          	ecall
 ret
    592c:	8082                	ret

000000000000592e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    592e:	48a1                	li	a7,8
 ecall
    5930:	00000073          	ecall
 ret
    5934:	8082                	ret

0000000000005936 <link>:
.global link
link:
 li a7, SYS_link
    5936:	48cd                	li	a7,19
 ecall
    5938:	00000073          	ecall
 ret
    593c:	8082                	ret

000000000000593e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    593e:	48d1                	li	a7,20
 ecall
    5940:	00000073          	ecall
 ret
    5944:	8082                	ret

0000000000005946 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5946:	48a5                	li	a7,9
 ecall
    5948:	00000073          	ecall
 ret
    594c:	8082                	ret

000000000000594e <dup>:
.global dup
dup:
 li a7, SYS_dup
    594e:	48a9                	li	a7,10
 ecall
    5950:	00000073          	ecall
 ret
    5954:	8082                	ret

0000000000005956 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5956:	48ad                	li	a7,11
 ecall
    5958:	00000073          	ecall
 ret
    595c:	8082                	ret

000000000000595e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    595e:	48b1                	li	a7,12
 ecall
    5960:	00000073          	ecall
 ret
    5964:	8082                	ret

0000000000005966 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5966:	48b5                	li	a7,13
 ecall
    5968:	00000073          	ecall
 ret
    596c:	8082                	ret

000000000000596e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    596e:	48b9                	li	a7,14
 ecall
    5970:	00000073          	ecall
 ret
    5974:	8082                	ret

0000000000005976 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    5976:	48d9                	li	a7,22
 ecall
    5978:	00000073          	ecall
 ret
    597c:	8082                	ret

000000000000597e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    597e:	1101                	addi	sp,sp,-32
    5980:	ec06                	sd	ra,24(sp)
    5982:	e822                	sd	s0,16(sp)
    5984:	1000                	addi	s0,sp,32
    5986:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    598a:	4605                	li	a2,1
    598c:	fef40593          	addi	a1,s0,-17
    5990:	00000097          	auipc	ra,0x0
    5994:	f66080e7          	jalr	-154(ra) # 58f6 <write>
}
    5998:	60e2                	ld	ra,24(sp)
    599a:	6442                	ld	s0,16(sp)
    599c:	6105                	addi	sp,sp,32
    599e:	8082                	ret

00000000000059a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    59a0:	7139                	addi	sp,sp,-64
    59a2:	fc06                	sd	ra,56(sp)
    59a4:	f822                	sd	s0,48(sp)
    59a6:	f426                	sd	s1,40(sp)
    59a8:	0080                	addi	s0,sp,64
    59aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    59ac:	c299                	beqz	a3,59b2 <printint+0x12>
    59ae:	0805cb63          	bltz	a1,5a44 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    59b2:	2581                	sext.w	a1,a1
  neg = 0;
    59b4:	4881                	li	a7,0
    59b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    59ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    59bc:	2601                	sext.w	a2,a2
    59be:	00003517          	auipc	a0,0x3
    59c2:	c7a50513          	addi	a0,a0,-902 # 8638 <digits>
    59c6:	883a                	mv	a6,a4
    59c8:	2705                	addiw	a4,a4,1
    59ca:	02c5f7bb          	remuw	a5,a1,a2
    59ce:	1782                	slli	a5,a5,0x20
    59d0:	9381                	srli	a5,a5,0x20
    59d2:	97aa                	add	a5,a5,a0
    59d4:	0007c783          	lbu	a5,0(a5)
    59d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    59dc:	0005879b          	sext.w	a5,a1
    59e0:	02c5d5bb          	divuw	a1,a1,a2
    59e4:	0685                	addi	a3,a3,1
    59e6:	fec7f0e3          	bgeu	a5,a2,59c6 <printint+0x26>
  if(neg)
    59ea:	00088c63          	beqz	a7,5a02 <printint+0x62>
    buf[i++] = '-';
    59ee:	fd070793          	addi	a5,a4,-48
    59f2:	00878733          	add	a4,a5,s0
    59f6:	02d00793          	li	a5,45
    59fa:	fef70823          	sb	a5,-16(a4)
    59fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5a02:	02e05c63          	blez	a4,5a3a <printint+0x9a>
    5a06:	f04a                	sd	s2,32(sp)
    5a08:	ec4e                	sd	s3,24(sp)
    5a0a:	fc040793          	addi	a5,s0,-64
    5a0e:	00e78933          	add	s2,a5,a4
    5a12:	fff78993          	addi	s3,a5,-1
    5a16:	99ba                	add	s3,s3,a4
    5a18:	377d                	addiw	a4,a4,-1
    5a1a:	1702                	slli	a4,a4,0x20
    5a1c:	9301                	srli	a4,a4,0x20
    5a1e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5a22:	fff94583          	lbu	a1,-1(s2)
    5a26:	8526                	mv	a0,s1
    5a28:	00000097          	auipc	ra,0x0
    5a2c:	f56080e7          	jalr	-170(ra) # 597e <putc>
  while(--i >= 0)
    5a30:	197d                	addi	s2,s2,-1
    5a32:	ff3918e3          	bne	s2,s3,5a22 <printint+0x82>
    5a36:	7902                	ld	s2,32(sp)
    5a38:	69e2                	ld	s3,24(sp)
}
    5a3a:	70e2                	ld	ra,56(sp)
    5a3c:	7442                	ld	s0,48(sp)
    5a3e:	74a2                	ld	s1,40(sp)
    5a40:	6121                	addi	sp,sp,64
    5a42:	8082                	ret
    x = -xx;
    5a44:	40b005bb          	negw	a1,a1
    neg = 1;
    5a48:	4885                	li	a7,1
    x = -xx;
    5a4a:	b7b5                	j	59b6 <printint+0x16>

0000000000005a4c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5a4c:	715d                	addi	sp,sp,-80
    5a4e:	e486                	sd	ra,72(sp)
    5a50:	e0a2                	sd	s0,64(sp)
    5a52:	f84a                	sd	s2,48(sp)
    5a54:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5a56:	0005c903          	lbu	s2,0(a1)
    5a5a:	1a090a63          	beqz	s2,5c0e <vprintf+0x1c2>
    5a5e:	fc26                	sd	s1,56(sp)
    5a60:	f44e                	sd	s3,40(sp)
    5a62:	f052                	sd	s4,32(sp)
    5a64:	ec56                	sd	s5,24(sp)
    5a66:	e85a                	sd	s6,16(sp)
    5a68:	e45e                	sd	s7,8(sp)
    5a6a:	8aaa                	mv	s5,a0
    5a6c:	8bb2                	mv	s7,a2
    5a6e:	00158493          	addi	s1,a1,1
  state = 0;
    5a72:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a74:	02500a13          	li	s4,37
    5a78:	4b55                	li	s6,21
    5a7a:	a839                	j	5a98 <vprintf+0x4c>
        putc(fd, c);
    5a7c:	85ca                	mv	a1,s2
    5a7e:	8556                	mv	a0,s5
    5a80:	00000097          	auipc	ra,0x0
    5a84:	efe080e7          	jalr	-258(ra) # 597e <putc>
    5a88:	a019                	j	5a8e <vprintf+0x42>
    } else if(state == '%'){
    5a8a:	01498d63          	beq	s3,s4,5aa4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5a8e:	0485                	addi	s1,s1,1
    5a90:	fff4c903          	lbu	s2,-1(s1)
    5a94:	16090763          	beqz	s2,5c02 <vprintf+0x1b6>
    if(state == 0){
    5a98:	fe0999e3          	bnez	s3,5a8a <vprintf+0x3e>
      if(c == '%'){
    5a9c:	ff4910e3          	bne	s2,s4,5a7c <vprintf+0x30>
        state = '%';
    5aa0:	89d2                	mv	s3,s4
    5aa2:	b7f5                	j	5a8e <vprintf+0x42>
      if(c == 'd'){
    5aa4:	13490463          	beq	s2,s4,5bcc <vprintf+0x180>
    5aa8:	f9d9079b          	addiw	a5,s2,-99
    5aac:	0ff7f793          	zext.b	a5,a5
    5ab0:	12fb6763          	bltu	s6,a5,5bde <vprintf+0x192>
    5ab4:	f9d9079b          	addiw	a5,s2,-99
    5ab8:	0ff7f713          	zext.b	a4,a5
    5abc:	12eb6163          	bltu	s6,a4,5bde <vprintf+0x192>
    5ac0:	00271793          	slli	a5,a4,0x2
    5ac4:	00003717          	auipc	a4,0x3
    5ac8:	b1c70713          	addi	a4,a4,-1252 # 85e0 <malloc+0x28e2>
    5acc:	97ba                	add	a5,a5,a4
    5ace:	439c                	lw	a5,0(a5)
    5ad0:	97ba                	add	a5,a5,a4
    5ad2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5ad4:	008b8913          	addi	s2,s7,8
    5ad8:	4685                	li	a3,1
    5ada:	4629                	li	a2,10
    5adc:	000ba583          	lw	a1,0(s7)
    5ae0:	8556                	mv	a0,s5
    5ae2:	00000097          	auipc	ra,0x0
    5ae6:	ebe080e7          	jalr	-322(ra) # 59a0 <printint>
    5aea:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5aec:	4981                	li	s3,0
    5aee:	b745                	j	5a8e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5af0:	008b8913          	addi	s2,s7,8
    5af4:	4681                	li	a3,0
    5af6:	4629                	li	a2,10
    5af8:	000ba583          	lw	a1,0(s7)
    5afc:	8556                	mv	a0,s5
    5afe:	00000097          	auipc	ra,0x0
    5b02:	ea2080e7          	jalr	-350(ra) # 59a0 <printint>
    5b06:	8bca                	mv	s7,s2
      state = 0;
    5b08:	4981                	li	s3,0
    5b0a:	b751                	j	5a8e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5b0c:	008b8913          	addi	s2,s7,8
    5b10:	4681                	li	a3,0
    5b12:	4641                	li	a2,16
    5b14:	000ba583          	lw	a1,0(s7)
    5b18:	8556                	mv	a0,s5
    5b1a:	00000097          	auipc	ra,0x0
    5b1e:	e86080e7          	jalr	-378(ra) # 59a0 <printint>
    5b22:	8bca                	mv	s7,s2
      state = 0;
    5b24:	4981                	li	s3,0
    5b26:	b7a5                	j	5a8e <vprintf+0x42>
    5b28:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5b2a:	008b8c13          	addi	s8,s7,8
    5b2e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5b32:	03000593          	li	a1,48
    5b36:	8556                	mv	a0,s5
    5b38:	00000097          	auipc	ra,0x0
    5b3c:	e46080e7          	jalr	-442(ra) # 597e <putc>
  putc(fd, 'x');
    5b40:	07800593          	li	a1,120
    5b44:	8556                	mv	a0,s5
    5b46:	00000097          	auipc	ra,0x0
    5b4a:	e38080e7          	jalr	-456(ra) # 597e <putc>
    5b4e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b50:	00003b97          	auipc	s7,0x3
    5b54:	ae8b8b93          	addi	s7,s7,-1304 # 8638 <digits>
    5b58:	03c9d793          	srli	a5,s3,0x3c
    5b5c:	97de                	add	a5,a5,s7
    5b5e:	0007c583          	lbu	a1,0(a5)
    5b62:	8556                	mv	a0,s5
    5b64:	00000097          	auipc	ra,0x0
    5b68:	e1a080e7          	jalr	-486(ra) # 597e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b6c:	0992                	slli	s3,s3,0x4
    5b6e:	397d                	addiw	s2,s2,-1
    5b70:	fe0914e3          	bnez	s2,5b58 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5b74:	8be2                	mv	s7,s8
      state = 0;
    5b76:	4981                	li	s3,0
    5b78:	6c02                	ld	s8,0(sp)
    5b7a:	bf11                	j	5a8e <vprintf+0x42>
        s = va_arg(ap, char*);
    5b7c:	008b8993          	addi	s3,s7,8
    5b80:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5b84:	02090163          	beqz	s2,5ba6 <vprintf+0x15a>
        while(*s != 0){
    5b88:	00094583          	lbu	a1,0(s2)
    5b8c:	c9a5                	beqz	a1,5bfc <vprintf+0x1b0>
          putc(fd, *s);
    5b8e:	8556                	mv	a0,s5
    5b90:	00000097          	auipc	ra,0x0
    5b94:	dee080e7          	jalr	-530(ra) # 597e <putc>
          s++;
    5b98:	0905                	addi	s2,s2,1
        while(*s != 0){
    5b9a:	00094583          	lbu	a1,0(s2)
    5b9e:	f9e5                	bnez	a1,5b8e <vprintf+0x142>
        s = va_arg(ap, char*);
    5ba0:	8bce                	mv	s7,s3
      state = 0;
    5ba2:	4981                	li	s3,0
    5ba4:	b5ed                	j	5a8e <vprintf+0x42>
          s = "(null)";
    5ba6:	00002917          	auipc	s2,0x2
    5baa:	62290913          	addi	s2,s2,1570 # 81c8 <malloc+0x24ca>
        while(*s != 0){
    5bae:	02800593          	li	a1,40
    5bb2:	bff1                	j	5b8e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5bb4:	008b8913          	addi	s2,s7,8
    5bb8:	000bc583          	lbu	a1,0(s7)
    5bbc:	8556                	mv	a0,s5
    5bbe:	00000097          	auipc	ra,0x0
    5bc2:	dc0080e7          	jalr	-576(ra) # 597e <putc>
    5bc6:	8bca                	mv	s7,s2
      state = 0;
    5bc8:	4981                	li	s3,0
    5bca:	b5d1                	j	5a8e <vprintf+0x42>
        putc(fd, c);
    5bcc:	02500593          	li	a1,37
    5bd0:	8556                	mv	a0,s5
    5bd2:	00000097          	auipc	ra,0x0
    5bd6:	dac080e7          	jalr	-596(ra) # 597e <putc>
      state = 0;
    5bda:	4981                	li	s3,0
    5bdc:	bd4d                	j	5a8e <vprintf+0x42>
        putc(fd, '%');
    5bde:	02500593          	li	a1,37
    5be2:	8556                	mv	a0,s5
    5be4:	00000097          	auipc	ra,0x0
    5be8:	d9a080e7          	jalr	-614(ra) # 597e <putc>
        putc(fd, c);
    5bec:	85ca                	mv	a1,s2
    5bee:	8556                	mv	a0,s5
    5bf0:	00000097          	auipc	ra,0x0
    5bf4:	d8e080e7          	jalr	-626(ra) # 597e <putc>
      state = 0;
    5bf8:	4981                	li	s3,0
    5bfa:	bd51                	j	5a8e <vprintf+0x42>
        s = va_arg(ap, char*);
    5bfc:	8bce                	mv	s7,s3
      state = 0;
    5bfe:	4981                	li	s3,0
    5c00:	b579                	j	5a8e <vprintf+0x42>
    5c02:	74e2                	ld	s1,56(sp)
    5c04:	79a2                	ld	s3,40(sp)
    5c06:	7a02                	ld	s4,32(sp)
    5c08:	6ae2                	ld	s5,24(sp)
    5c0a:	6b42                	ld	s6,16(sp)
    5c0c:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5c0e:	60a6                	ld	ra,72(sp)
    5c10:	6406                	ld	s0,64(sp)
    5c12:	7942                	ld	s2,48(sp)
    5c14:	6161                	addi	sp,sp,80
    5c16:	8082                	ret

0000000000005c18 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5c18:	715d                	addi	sp,sp,-80
    5c1a:	ec06                	sd	ra,24(sp)
    5c1c:	e822                	sd	s0,16(sp)
    5c1e:	1000                	addi	s0,sp,32
    5c20:	e010                	sd	a2,0(s0)
    5c22:	e414                	sd	a3,8(s0)
    5c24:	e818                	sd	a4,16(s0)
    5c26:	ec1c                	sd	a5,24(s0)
    5c28:	03043023          	sd	a6,32(s0)
    5c2c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5c30:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5c34:	8622                	mv	a2,s0
    5c36:	00000097          	auipc	ra,0x0
    5c3a:	e16080e7          	jalr	-490(ra) # 5a4c <vprintf>
}
    5c3e:	60e2                	ld	ra,24(sp)
    5c40:	6442                	ld	s0,16(sp)
    5c42:	6161                	addi	sp,sp,80
    5c44:	8082                	ret

0000000000005c46 <printf>:

void
printf(const char *fmt, ...)
{
    5c46:	711d                	addi	sp,sp,-96
    5c48:	ec06                	sd	ra,24(sp)
    5c4a:	e822                	sd	s0,16(sp)
    5c4c:	1000                	addi	s0,sp,32
    5c4e:	e40c                	sd	a1,8(s0)
    5c50:	e810                	sd	a2,16(s0)
    5c52:	ec14                	sd	a3,24(s0)
    5c54:	f018                	sd	a4,32(s0)
    5c56:	f41c                	sd	a5,40(s0)
    5c58:	03043823          	sd	a6,48(s0)
    5c5c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5c60:	00840613          	addi	a2,s0,8
    5c64:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c68:	85aa                	mv	a1,a0
    5c6a:	4505                	li	a0,1
    5c6c:	00000097          	auipc	ra,0x0
    5c70:	de0080e7          	jalr	-544(ra) # 5a4c <vprintf>
}
    5c74:	60e2                	ld	ra,24(sp)
    5c76:	6442                	ld	s0,16(sp)
    5c78:	6125                	addi	sp,sp,96
    5c7a:	8082                	ret

0000000000005c7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c7c:	1141                	addi	sp,sp,-16
    5c7e:	e422                	sd	s0,8(sp)
    5c80:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c82:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c86:	00004797          	auipc	a5,0x4
    5c8a:	c327b783          	ld	a5,-974(a5) # 98b8 <freep>
    5c8e:	a02d                	j	5cb8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c90:	4618                	lw	a4,8(a2)
    5c92:	9f2d                	addw	a4,a4,a1
    5c94:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c98:	6398                	ld	a4,0(a5)
    5c9a:	6310                	ld	a2,0(a4)
    5c9c:	a83d                	j	5cda <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c9e:	ff852703          	lw	a4,-8(a0)
    5ca2:	9f31                	addw	a4,a4,a2
    5ca4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5ca6:	ff053683          	ld	a3,-16(a0)
    5caa:	a091                	j	5cee <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5cac:	6398                	ld	a4,0(a5)
    5cae:	00e7e463          	bltu	a5,a4,5cb6 <free+0x3a>
    5cb2:	00e6ea63          	bltu	a3,a4,5cc6 <free+0x4a>
{
    5cb6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5cb8:	fed7fae3          	bgeu	a5,a3,5cac <free+0x30>
    5cbc:	6398                	ld	a4,0(a5)
    5cbe:	00e6e463          	bltu	a3,a4,5cc6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5cc2:	fee7eae3          	bltu	a5,a4,5cb6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5cc6:	ff852583          	lw	a1,-8(a0)
    5cca:	6390                	ld	a2,0(a5)
    5ccc:	02059813          	slli	a6,a1,0x20
    5cd0:	01c85713          	srli	a4,a6,0x1c
    5cd4:	9736                	add	a4,a4,a3
    5cd6:	fae60de3          	beq	a2,a4,5c90 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5cda:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5cde:	4790                	lw	a2,8(a5)
    5ce0:	02061593          	slli	a1,a2,0x20
    5ce4:	01c5d713          	srli	a4,a1,0x1c
    5ce8:	973e                	add	a4,a4,a5
    5cea:	fae68ae3          	beq	a3,a4,5c9e <free+0x22>
    p->s.ptr = bp->s.ptr;
    5cee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5cf0:	00004717          	auipc	a4,0x4
    5cf4:	bcf73423          	sd	a5,-1080(a4) # 98b8 <freep>
}
    5cf8:	6422                	ld	s0,8(sp)
    5cfa:	0141                	addi	sp,sp,16
    5cfc:	8082                	ret

0000000000005cfe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5cfe:	7139                	addi	sp,sp,-64
    5d00:	fc06                	sd	ra,56(sp)
    5d02:	f822                	sd	s0,48(sp)
    5d04:	f426                	sd	s1,40(sp)
    5d06:	ec4e                	sd	s3,24(sp)
    5d08:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5d0a:	02051493          	slli	s1,a0,0x20
    5d0e:	9081                	srli	s1,s1,0x20
    5d10:	04bd                	addi	s1,s1,15
    5d12:	8091                	srli	s1,s1,0x4
    5d14:	0014899b          	addiw	s3,s1,1
    5d18:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5d1a:	00004517          	auipc	a0,0x4
    5d1e:	b9e53503          	ld	a0,-1122(a0) # 98b8 <freep>
    5d22:	c915                	beqz	a0,5d56 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d26:	4798                	lw	a4,8(a5)
    5d28:	08977e63          	bgeu	a4,s1,5dc4 <malloc+0xc6>
    5d2c:	f04a                	sd	s2,32(sp)
    5d2e:	e852                	sd	s4,16(sp)
    5d30:	e456                	sd	s5,8(sp)
    5d32:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5d34:	8a4e                	mv	s4,s3
    5d36:	0009871b          	sext.w	a4,s3
    5d3a:	6685                	lui	a3,0x1
    5d3c:	00d77363          	bgeu	a4,a3,5d42 <malloc+0x44>
    5d40:	6a05                	lui	s4,0x1
    5d42:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5d46:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5d4a:	00004917          	auipc	s2,0x4
    5d4e:	b6e90913          	addi	s2,s2,-1170 # 98b8 <freep>
  if(p == (char*)-1)
    5d52:	5afd                	li	s5,-1
    5d54:	a091                	j	5d98 <malloc+0x9a>
    5d56:	f04a                	sd	s2,32(sp)
    5d58:	e852                	sd	s4,16(sp)
    5d5a:	e456                	sd	s5,8(sp)
    5d5c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5d5e:	0000a797          	auipc	a5,0xa
    5d62:	37a78793          	addi	a5,a5,890 # 100d8 <base>
    5d66:	00004717          	auipc	a4,0x4
    5d6a:	b4f73923          	sd	a5,-1198(a4) # 98b8 <freep>
    5d6e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d70:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d74:	b7c1                	j	5d34 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    5d76:	6398                	ld	a4,0(a5)
    5d78:	e118                	sd	a4,0(a0)
    5d7a:	a08d                	j	5ddc <malloc+0xde>
  hp->s.size = nu;
    5d7c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d80:	0541                	addi	a0,a0,16
    5d82:	00000097          	auipc	ra,0x0
    5d86:	efa080e7          	jalr	-262(ra) # 5c7c <free>
  return freep;
    5d8a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d8e:	c13d                	beqz	a0,5df4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d92:	4798                	lw	a4,8(a5)
    5d94:	02977463          	bgeu	a4,s1,5dbc <malloc+0xbe>
    if(p == freep)
    5d98:	00093703          	ld	a4,0(s2)
    5d9c:	853e                	mv	a0,a5
    5d9e:	fef719e3          	bne	a4,a5,5d90 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    5da2:	8552                	mv	a0,s4
    5da4:	00000097          	auipc	ra,0x0
    5da8:	bba080e7          	jalr	-1094(ra) # 595e <sbrk>
  if(p == (char*)-1)
    5dac:	fd5518e3          	bne	a0,s5,5d7c <malloc+0x7e>
        return 0;
    5db0:	4501                	li	a0,0
    5db2:	7902                	ld	s2,32(sp)
    5db4:	6a42                	ld	s4,16(sp)
    5db6:	6aa2                	ld	s5,8(sp)
    5db8:	6b02                	ld	s6,0(sp)
    5dba:	a03d                	j	5de8 <malloc+0xea>
    5dbc:	7902                	ld	s2,32(sp)
    5dbe:	6a42                	ld	s4,16(sp)
    5dc0:	6aa2                	ld	s5,8(sp)
    5dc2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5dc4:	fae489e3          	beq	s1,a4,5d76 <malloc+0x78>
        p->s.size -= nunits;
    5dc8:	4137073b          	subw	a4,a4,s3
    5dcc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5dce:	02071693          	slli	a3,a4,0x20
    5dd2:	01c6d713          	srli	a4,a3,0x1c
    5dd6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5dd8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5ddc:	00004717          	auipc	a4,0x4
    5de0:	aca73e23          	sd	a0,-1316(a4) # 98b8 <freep>
      return (void*)(p + 1);
    5de4:	01078513          	addi	a0,a5,16
  }
}
    5de8:	70e2                	ld	ra,56(sp)
    5dea:	7442                	ld	s0,48(sp)
    5dec:	74a2                	ld	s1,40(sp)
    5dee:	69e2                	ld	s3,24(sp)
    5df0:	6121                	addi	sp,sp,64
    5df2:	8082                	ret
    5df4:	7902                	ld	s2,32(sp)
    5df6:	6a42                	ld	s4,16(sp)
    5df8:	6aa2                	ld	s5,8(sp)
    5dfa:	6b02                	ld	s6,0(sp)
    5dfc:	b7f5                	j	5de8 <malloc+0xea>
