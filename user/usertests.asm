
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
      14:	91a080e7          	jalr	-1766(ra) # 592a <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	908080e7          	jalr	-1784(ra) # 592a <open>
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
      42:	de250513          	addi	a0,a0,-542 # 5e20 <malloc+0x106>
      46:	00006097          	auipc	ra,0x6
      4a:	c1c080e7          	jalr	-996(ra) # 5c62 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	89a080e7          	jalr	-1894(ra) # 58ea <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000b797          	auipc	a5,0xb
      5c:	9b078793          	addi	a5,a5,-1616 # aa08 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	0b868693          	addi	a3,a3,184 # d118 <buf>
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
      84:	dc050513          	addi	a0,a0,-576 # 5e40 <malloc+0x126>
      88:	00006097          	auipc	ra,0x6
      8c:	bda080e7          	jalr	-1062(ra) # 5c62 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	858080e7          	jalr	-1960(ra) # 58ea <exit>

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
      ac:	db050513          	addi	a0,a0,-592 # 5e58 <malloc+0x13e>
      b0:	00006097          	auipc	ra,0x6
      b4:	87a080e7          	jalr	-1926(ra) # 592a <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	856080e7          	jalr	-1962(ra) # 5912 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	db250513          	addi	a0,a0,-590 # 5e78 <malloc+0x15e>
      ce:	00006097          	auipc	ra,0x6
      d2:	85c080e7          	jalr	-1956(ra) # 592a <open>
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
      ea:	d7a50513          	addi	a0,a0,-646 # 5e60 <malloc+0x146>
      ee:	00006097          	auipc	ra,0x6
      f2:	b74080e7          	jalr	-1164(ra) # 5c62 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	7f2080e7          	jalr	2034(ra) # 58ea <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	d8650513          	addi	a0,a0,-634 # 5e88 <malloc+0x16e>
     10a:	00006097          	auipc	ra,0x6
     10e:	b58080e7          	jalr	-1192(ra) # 5c62 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	7d6080e7          	jalr	2006(ra) # 58ea <exit>

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
     130:	d8450513          	addi	a0,a0,-636 # 5eb0 <malloc+0x196>
     134:	00006097          	auipc	ra,0x6
     138:	806080e7          	jalr	-2042(ra) # 593a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	d7050513          	addi	a0,a0,-656 # 5eb0 <malloc+0x196>
     148:	00005097          	auipc	ra,0x5
     14c:	7e2080e7          	jalr	2018(ra) # 592a <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	d6c58593          	addi	a1,a1,-660 # 5ec0 <malloc+0x1a6>
     15c:	00005097          	auipc	ra,0x5
     160:	7ae080e7          	jalr	1966(ra) # 590a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	d4850513          	addi	a0,a0,-696 # 5eb0 <malloc+0x196>
     170:	00005097          	auipc	ra,0x5
     174:	7ba080e7          	jalr	1978(ra) # 592a <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	d4c58593          	addi	a1,a1,-692 # 5ec8 <malloc+0x1ae>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	784080e7          	jalr	1924(ra) # 590a <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	d1c50513          	addi	a0,a0,-740 # 5eb0 <malloc+0x196>
     19c:	00005097          	auipc	ra,0x5
     1a0:	79e080e7          	jalr	1950(ra) # 593a <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	76c080e7          	jalr	1900(ra) # 5912 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	762080e7          	jalr	1890(ra) # 5912 <close>
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
     1ce:	d0650513          	addi	a0,a0,-762 # 5ed0 <malloc+0x1b6>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a90080e7          	jalr	-1392(ra) # 5c62 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	70e080e7          	jalr	1806(ra) # 58ea <exit>

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
     214:	71a080e7          	jalr	1818(ra) # 592a <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	6fa080e7          	jalr	1786(ra) # 5912 <close>
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
     24a:	6f4080e7          	jalr	1780(ra) # 593a <unlink>
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
     280:	c7c50513          	addi	a0,a0,-900 # 5ef8 <malloc+0x1de>
     284:	00005097          	auipc	ra,0x5
     288:	6b6080e7          	jalr	1718(ra) # 593a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	c68a8a93          	addi	s5,s5,-920 # 5ef8 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	e80a0a13          	addi	s4,s4,-384 # d118 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x39>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	67e080e7          	jalr	1662(ra) # 592a <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	64c080e7          	jalr	1612(ra) # 590a <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	638080e7          	jalr	1592(ra) # 590a <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	632080e7          	jalr	1586(ra) # 5912 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	650080e7          	jalr	1616(ra) # 593a <unlink>
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
     316:	bf650513          	addi	a0,a0,-1034 # 5f08 <malloc+0x1ee>
     31a:	00006097          	auipc	ra,0x6
     31e:	948080e7          	jalr	-1720(ra) # 5c62 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	5c6080e7          	jalr	1478(ra) # 58ea <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	bf450513          	addi	a0,a0,-1036 # 5f28 <malloc+0x20e>
     33c:	00006097          	auipc	ra,0x6
     340:	926080e7          	jalr	-1754(ra) # 5c62 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	5a4080e7          	jalr	1444(ra) # 58ea <exit>

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
     374:	bd0a0a13          	addi	s4,s4,-1072 # 5f40 <malloc+0x226>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	5a8080e7          	jalr	1448(ra) # 592a <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	576080e7          	jalr	1398(ra) # 590a <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	570080e7          	jalr	1392(ra) # 5912 <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	58e080e7          	jalr	1422(ra) # 593a <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	550080e7          	jalr	1360(ra) # 590a <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	addi	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	530080e7          	jalr	1328(ra) # 58fa <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	52c080e7          	jalr	1324(ra) # 590a <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	524080e7          	jalr	1316(ra) # 5912 <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	518080e7          	jalr	1304(ra) # 5912 <close>
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
     420:	b2c50513          	addi	a0,a0,-1236 # 5f48 <malloc+0x22e>
     424:	00006097          	auipc	ra,0x6
     428:	83e080e7          	jalr	-1986(ra) # 5c62 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	4bc080e7          	jalr	1212(ra) # 58ea <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	b2650513          	addi	a0,a0,-1242 # 5f60 <malloc+0x246>
     442:	00006097          	auipc	ra,0x6
     446:	820080e7          	jalr	-2016(ra) # 5c62 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	49e080e7          	jalr	1182(ra) # 58ea <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	b3850513          	addi	a0,a0,-1224 # 5f90 <malloc+0x276>
     460:	00006097          	auipc	ra,0x6
     464:	802080e7          	jalr	-2046(ra) # 5c62 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	480080e7          	jalr	1152(ra) # 58ea <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	b4e50513          	addi	a0,a0,-1202 # 5fc0 <malloc+0x2a6>
     47a:	00005097          	auipc	ra,0x5
     47e:	7e8080e7          	jalr	2024(ra) # 5c62 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	466080e7          	jalr	1126(ra) # 58ea <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	b4050513          	addi	a0,a0,-1216 # 5fd0 <malloc+0x2b6>
     498:	00005097          	auipc	ra,0x5
     49c:	7ca080e7          	jalr	1994(ra) # 5c62 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	448080e7          	jalr	1096(ra) # 58ea <exit>

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
     4d2:	b32a0a13          	addi	s4,s4,-1230 # 6000 <malloc+0x2e6>
    n = write(fds[1], "x", 1);
     4d6:	00006a97          	auipc	s5,0x6
     4da:	9f2a8a93          	addi	s5,s5,-1550 # 5ec8 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	444080e7          	jalr	1092(ra) # 592a <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	40a080e7          	jalr	1034(ra) # 5902 <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	40c080e7          	jalr	1036(ra) # 5912 <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	addi	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	3e8080e7          	jalr	1000(ra) # 58fa <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	3e4080e7          	jalr	996(ra) # 590a <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	3c6080e7          	jalr	966(ra) # 5902 <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	3c6080e7          	jalr	966(ra) # 5912 <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	3ba080e7          	jalr	954(ra) # 5912 <close>
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
     580:	a8c50513          	addi	a0,a0,-1396 # 6008 <malloc+0x2ee>
     584:	00005097          	auipc	ra,0x5
     588:	6de080e7          	jalr	1758(ra) # 5c62 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	35c080e7          	jalr	860(ra) # 58ea <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00006517          	auipc	a0,0x6
     59e:	a8650513          	addi	a0,a0,-1402 # 6020 <malloc+0x306>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	6c0080e7          	jalr	1728(ra) # 5c62 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	33e080e7          	jalr	830(ra) # 58ea <exit>
      printf("pipe() failed\n");
     5b4:	00006517          	auipc	a0,0x6
     5b8:	a0c50513          	addi	a0,a0,-1524 # 5fc0 <malloc+0x2a6>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	6a6080e7          	jalr	1702(ra) # 5c62 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	324080e7          	jalr	804(ra) # 58ea <exit>
      printf("pipe write failed\n");
     5ce:	00006517          	auipc	a0,0x6
     5d2:	a8250513          	addi	a0,a0,-1406 # 6050 <malloc+0x336>
     5d6:	00005097          	auipc	ra,0x5
     5da:	68c080e7          	jalr	1676(ra) # 5c62 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	30a080e7          	jalr	778(ra) # 58ea <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00006517          	auipc	a0,0x6
     5f0:	a7c50513          	addi	a0,a0,-1412 # 6068 <malloc+0x34e>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	66e080e7          	jalr	1646(ra) # 5c62 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	2ec080e7          	jalr	748(ra) # 58ea <exit>

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
     61e:	89650513          	addi	a0,a0,-1898 # 5eb0 <malloc+0x196>
     622:	00005097          	auipc	ra,0x5
     626:	318080e7          	jalr	792(ra) # 593a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00006517          	auipc	a0,0x6
     632:	88250513          	addi	a0,a0,-1918 # 5eb0 <malloc+0x196>
     636:	00005097          	auipc	ra,0x5
     63a:	2f4080e7          	jalr	756(ra) # 592a <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00006597          	auipc	a1,0x6
     646:	87e58593          	addi	a1,a1,-1922 # 5ec0 <malloc+0x1a6>
     64a:	00005097          	auipc	ra,0x5
     64e:	2c0080e7          	jalr	704(ra) # 590a <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	2be080e7          	jalr	702(ra) # 5912 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00006517          	auipc	a0,0x6
     662:	85250513          	addi	a0,a0,-1966 # 5eb0 <malloc+0x196>
     666:	00005097          	auipc	ra,0x5
     66a:	2c4080e7          	jalr	708(ra) # 592a <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	addi	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	28a080e7          	jalr	650(ra) # 5902 <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00006517          	auipc	a0,0x6
     68e:	82650513          	addi	a0,a0,-2010 # 5eb0 <malloc+0x196>
     692:	00005097          	auipc	ra,0x5
     696:	298080e7          	jalr	664(ra) # 592a <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00006517          	auipc	a0,0x6
     6a2:	81250513          	addi	a0,a0,-2030 # 5eb0 <malloc+0x196>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	284080e7          	jalr	644(ra) # 592a <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	24a080e7          	jalr	586(ra) # 5902 <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	234080e7          	jalr	564(ra) # 5902 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00006597          	auipc	a1,0x6
     6e0:	a1c58593          	addi	a1,a1,-1508 # 60f8 <malloc+0x3de>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	224080e7          	jalr	548(ra) # 590a <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	addi	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	20a080e7          	jalr	522(ra) # 5902 <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	addi	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	1f2080e7          	jalr	498(ra) # 5902 <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	79250513          	addi	a0,a0,1938 # 5eb0 <malloc+0x196>
     726:	00005097          	auipc	ra,0x5
     72a:	214080e7          	jalr	532(ra) # 593a <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	1e2080e7          	jalr	482(ra) # 5912 <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	1d8080e7          	jalr	472(ra) # 5912 <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	1ce080e7          	jalr	462(ra) # 5912 <close>
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
     766:	93650513          	addi	a0,a0,-1738 # 6098 <malloc+0x37e>
     76a:	00005097          	auipc	ra,0x5
     76e:	4f8080e7          	jalr	1272(ra) # 5c62 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	176080e7          	jalr	374(ra) # 58ea <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00006517          	auipc	a0,0x6
     782:	93a50513          	addi	a0,a0,-1734 # 60b8 <malloc+0x39e>
     786:	00005097          	auipc	ra,0x5
     78a:	4dc080e7          	jalr	1244(ra) # 5c62 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00006517          	auipc	a0,0x6
     796:	93650513          	addi	a0,a0,-1738 # 60c8 <malloc+0x3ae>
     79a:	00005097          	auipc	ra,0x5
     79e:	4c8080e7          	jalr	1224(ra) # 5c62 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	146080e7          	jalr	326(ra) # 58ea <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00006517          	auipc	a0,0x6
     7b2:	93a50513          	addi	a0,a0,-1734 # 60e8 <malloc+0x3ce>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	4ac080e7          	jalr	1196(ra) # 5c62 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00006517          	auipc	a0,0x6
     7c6:	90650513          	addi	a0,a0,-1786 # 60c8 <malloc+0x3ae>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	498080e7          	jalr	1176(ra) # 5c62 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	116080e7          	jalr	278(ra) # 58ea <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00006517          	auipc	a0,0x6
     7e4:	92050513          	addi	a0,a0,-1760 # 6100 <malloc+0x3e6>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	47a080e7          	jalr	1146(ra) # 5c62 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	0f8080e7          	jalr	248(ra) # 58ea <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00006517          	auipc	a0,0x6
     802:	92250513          	addi	a0,a0,-1758 # 6120 <malloc+0x406>
     806:	00005097          	auipc	ra,0x5
     80a:	45c080e7          	jalr	1116(ra) # 5c62 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	0da080e7          	jalr	218(ra) # 58ea <exit>

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
     836:	90e50513          	addi	a0,a0,-1778 # 6140 <malloc+0x426>
     83a:	00005097          	auipc	ra,0x5
     83e:	0f0080e7          	jalr	240(ra) # 592a <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00006997          	auipc	s3,0x6
     84e:	91e98993          	addi	s3,s3,-1762 # 6168 <malloc+0x44e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00006a97          	auipc	s5,0x6
     856:	94ea8a93          	addi	s5,s5,-1714 # 61a0 <malloc+0x486>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	0a6080e7          	jalr	166(ra) # 590a <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	092080e7          	jalr	146(ra) # 590a <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addiw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	084080e7          	jalr	132(ra) # 5912 <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00006517          	auipc	a0,0x6
     89c:	8a850513          	addi	a0,a0,-1880 # 6140 <malloc+0x426>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	08a080e7          	jalr	138(ra) # 592a <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000d597          	auipc	a1,0xd
     8b6:	86658593          	addi	a1,a1,-1946 # d118 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	048080e7          	jalr	72(ra) # 5902 <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	046080e7          	jalr	70(ra) # 5912 <close>
  if(unlink("small") < 0){
     8d4:	00006517          	auipc	a0,0x6
     8d8:	86c50513          	addi	a0,a0,-1940 # 6140 <malloc+0x426>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	05e080e7          	jalr	94(ra) # 593a <unlink>
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
     902:	84a50513          	addi	a0,a0,-1974 # 6148 <malloc+0x42e>
     906:	00005097          	auipc	ra,0x5
     90a:	35c080e7          	jalr	860(ra) # 5c62 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	fda080e7          	jalr	-38(ra) # 58ea <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00006517          	auipc	a0,0x6
     920:	85c50513          	addi	a0,a0,-1956 # 6178 <malloc+0x45e>
     924:	00005097          	auipc	ra,0x5
     928:	33e080e7          	jalr	830(ra) # 5c62 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	fbc080e7          	jalr	-68(ra) # 58ea <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00006517          	auipc	a0,0x6
     93e:	87650513          	addi	a0,a0,-1930 # 61b0 <malloc+0x496>
     942:	00005097          	auipc	ra,0x5
     946:	320080e7          	jalr	800(ra) # 5c62 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	f9e080e7          	jalr	-98(ra) # 58ea <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00006517          	auipc	a0,0x6
     95a:	88250513          	addi	a0,a0,-1918 # 61d8 <malloc+0x4be>
     95e:	00005097          	auipc	ra,0x5
     962:	304080e7          	jalr	772(ra) # 5c62 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	f82080e7          	jalr	-126(ra) # 58ea <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00006517          	auipc	a0,0x6
     976:	88650513          	addi	a0,a0,-1914 # 61f8 <malloc+0x4de>
     97a:	00005097          	auipc	ra,0x5
     97e:	2e8080e7          	jalr	744(ra) # 5c62 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	f66080e7          	jalr	-154(ra) # 58ea <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00006517          	auipc	a0,0x6
     992:	88250513          	addi	a0,a0,-1918 # 6210 <malloc+0x4f6>
     996:	00005097          	auipc	ra,0x5
     99a:	2cc080e7          	jalr	716(ra) # 5c62 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	f4a080e7          	jalr	-182(ra) # 58ea <exit>

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
     9c4:	87050513          	addi	a0,a0,-1936 # 6230 <malloc+0x516>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	f62080e7          	jalr	-158(ra) # 592a <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000c917          	auipc	s2,0xc
     9d8:	74490913          	addi	s2,s2,1860 # d118 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	10c00a13          	li	s4,268
  if(fd < 0){
     9e0:	06054c63          	bltz	a0,a58 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9e8:	40000613          	li	a2,1024
     9ec:	85ca                	mv	a1,s2
     9ee:	854e                	mv	a0,s3
     9f0:	00005097          	auipc	ra,0x5
     9f4:	f1a080e7          	jalr	-230(ra) # 590a <write>
     9f8:	40000793          	li	a5,1024
     9fc:	06f51c63          	bne	a0,a5,a74 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a00:	2485                	addiw	s1,s1,1
     a02:	ff4491e3          	bne	s1,s4,9e4 <writebig+0x3c>
  close(fd);
     a06:	854e                	mv	a0,s3
     a08:	00005097          	auipc	ra,0x5
     a0c:	f0a080e7          	jalr	-246(ra) # 5912 <close>
  fd = open("big", O_RDONLY);
     a10:	4581                	li	a1,0
     a12:	00006517          	auipc	a0,0x6
     a16:	81e50513          	addi	a0,a0,-2018 # 6230 <malloc+0x516>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	f10080e7          	jalr	-240(ra) # 592a <open>
     a22:	89aa                	mv	s3,a0
  n = 0;
     a24:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a26:	0000c917          	auipc	s2,0xc
     a2a:	6f290913          	addi	s2,s2,1778 # d118 <buf>
  if(fd < 0){
     a2e:	06054263          	bltz	a0,a92 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a32:	40000613          	li	a2,1024
     a36:	85ca                	mv	a1,s2
     a38:	854e                	mv	a0,s3
     a3a:	00005097          	auipc	ra,0x5
     a3e:	ec8080e7          	jalr	-312(ra) # 5902 <read>
    if(i == 0){
     a42:	c535                	beqz	a0,aae <writebig+0x106>
    } else if(i != BSIZE){
     a44:	40000793          	li	a5,1024
     a48:	0af51f63          	bne	a0,a5,b06 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4c:	00092683          	lw	a3,0(s2)
     a50:	0c969a63          	bne	a3,s1,b24 <writebig+0x17c>
    n++;
     a54:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a56:	bff1                	j	a32 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a58:	85d6                	mv	a1,s5
     a5a:	00005517          	auipc	a0,0x5
     a5e:	7de50513          	addi	a0,a0,2014 # 6238 <malloc+0x51e>
     a62:	00005097          	auipc	ra,0x5
     a66:	200080e7          	jalr	512(ra) # 5c62 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	00005097          	auipc	ra,0x5
     a70:	e7e080e7          	jalr	-386(ra) # 58ea <exit>
      printf("%s: error: write big file failed\n", s, i);
     a74:	8626                	mv	a2,s1
     a76:	85d6                	mv	a1,s5
     a78:	00005517          	auipc	a0,0x5
     a7c:	7e050513          	addi	a0,a0,2016 # 6258 <malloc+0x53e>
     a80:	00005097          	auipc	ra,0x5
     a84:	1e2080e7          	jalr	482(ra) # 5c62 <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	e60080e7          	jalr	-416(ra) # 58ea <exit>
    printf("%s: error: open big failed!\n", s);
     a92:	85d6                	mv	a1,s5
     a94:	00005517          	auipc	a0,0x5
     a98:	7ec50513          	addi	a0,a0,2028 # 6280 <malloc+0x566>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	1c6080e7          	jalr	454(ra) # 5c62 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	e44080e7          	jalr	-444(ra) # 58ea <exit>
      if(n == MAXFILE - 1){
     aae:	10b00793          	li	a5,267
     ab2:	02f48a63          	beq	s1,a5,ae6 <writebig+0x13e>
  close(fd);
     ab6:	854e                	mv	a0,s3
     ab8:	00005097          	auipc	ra,0x5
     abc:	e5a080e7          	jalr	-422(ra) # 5912 <close>
  if(unlink("big") < 0){
     ac0:	00005517          	auipc	a0,0x5
     ac4:	77050513          	addi	a0,a0,1904 # 6230 <malloc+0x516>
     ac8:	00005097          	auipc	ra,0x5
     acc:	e72080e7          	jalr	-398(ra) # 593a <unlink>
     ad0:	06054963          	bltz	a0,b42 <writebig+0x19a>
}
     ad4:	70e2                	ld	ra,56(sp)
     ad6:	7442                	ld	s0,48(sp)
     ad8:	74a2                	ld	s1,40(sp)
     ada:	7902                	ld	s2,32(sp)
     adc:	69e2                	ld	s3,24(sp)
     ade:	6a42                	ld	s4,16(sp)
     ae0:	6aa2                	ld	s5,8(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae6:	10b00613          	li	a2,267
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	7b450513          	addi	a0,a0,1972 # 62a0 <malloc+0x586>
     af4:	00005097          	auipc	ra,0x5
     af8:	16e080e7          	jalr	366(ra) # 5c62 <printf>
        exit(1);
     afc:	4505                	li	a0,1
     afe:	00005097          	auipc	ra,0x5
     b02:	dec080e7          	jalr	-532(ra) # 58ea <exit>
      printf("%s: read failed %d\n", s, i);
     b06:	862a                	mv	a2,a0
     b08:	85d6                	mv	a1,s5
     b0a:	00005517          	auipc	a0,0x5
     b0e:	7be50513          	addi	a0,a0,1982 # 62c8 <malloc+0x5ae>
     b12:	00005097          	auipc	ra,0x5
     b16:	150080e7          	jalr	336(ra) # 5c62 <printf>
      exit(1);
     b1a:	4505                	li	a0,1
     b1c:	00005097          	auipc	ra,0x5
     b20:	dce080e7          	jalr	-562(ra) # 58ea <exit>
      printf("%s: read content of block %d is %d\n", s,
     b24:	8626                	mv	a2,s1
     b26:	85d6                	mv	a1,s5
     b28:	00005517          	auipc	a0,0x5
     b2c:	7b850513          	addi	a0,a0,1976 # 62e0 <malloc+0x5c6>
     b30:	00005097          	auipc	ra,0x5
     b34:	132080e7          	jalr	306(ra) # 5c62 <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	db0080e7          	jalr	-592(ra) # 58ea <exit>
    printf("%s: unlink big failed\n", s);
     b42:	85d6                	mv	a1,s5
     b44:	00005517          	auipc	a0,0x5
     b48:	7c450513          	addi	a0,a0,1988 # 6308 <malloc+0x5ee>
     b4c:	00005097          	auipc	ra,0x5
     b50:	116080e7          	jalr	278(ra) # 5c62 <printf>
    exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	d94080e7          	jalr	-620(ra) # 58ea <exit>

0000000000000b5e <unlinkread>:
{
     b5e:	7179                	addi	sp,sp,-48
     b60:	f406                	sd	ra,40(sp)
     b62:	f022                	sd	s0,32(sp)
     b64:	ec26                	sd	s1,24(sp)
     b66:	e84a                	sd	s2,16(sp)
     b68:	e44e                	sd	s3,8(sp)
     b6a:	1800                	addi	s0,sp,48
     b6c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b6e:	20200593          	li	a1,514
     b72:	00005517          	auipc	a0,0x5
     b76:	7ae50513          	addi	a0,a0,1966 # 6320 <malloc+0x606>
     b7a:	00005097          	auipc	ra,0x5
     b7e:	db0080e7          	jalr	-592(ra) # 592a <open>
  if(fd < 0){
     b82:	0e054563          	bltz	a0,c6c <unlinkread+0x10e>
     b86:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b88:	4615                	li	a2,5
     b8a:	00005597          	auipc	a1,0x5
     b8e:	7c658593          	addi	a1,a1,1990 # 6350 <malloc+0x636>
     b92:	00005097          	auipc	ra,0x5
     b96:	d78080e7          	jalr	-648(ra) # 590a <write>
  close(fd);
     b9a:	8526                	mv	a0,s1
     b9c:	00005097          	auipc	ra,0x5
     ba0:	d76080e7          	jalr	-650(ra) # 5912 <close>
  fd = open("unlinkread", O_RDWR);
     ba4:	4589                	li	a1,2
     ba6:	00005517          	auipc	a0,0x5
     baa:	77a50513          	addi	a0,a0,1914 # 6320 <malloc+0x606>
     bae:	00005097          	auipc	ra,0x5
     bb2:	d7c080e7          	jalr	-644(ra) # 592a <open>
     bb6:	84aa                	mv	s1,a0
  if(fd < 0){
     bb8:	0c054863          	bltz	a0,c88 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbc:	00005517          	auipc	a0,0x5
     bc0:	76450513          	addi	a0,a0,1892 # 6320 <malloc+0x606>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	d76080e7          	jalr	-650(ra) # 593a <unlink>
     bcc:	ed61                	bnez	a0,ca4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bce:	20200593          	li	a1,514
     bd2:	00005517          	auipc	a0,0x5
     bd6:	74e50513          	addi	a0,a0,1870 # 6320 <malloc+0x606>
     bda:	00005097          	auipc	ra,0x5
     bde:	d50080e7          	jalr	-688(ra) # 592a <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	7b258593          	addi	a1,a1,1970 # 6398 <malloc+0x67e>
     bee:	00005097          	auipc	ra,0x5
     bf2:	d1c080e7          	jalr	-740(ra) # 590a <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	00005097          	auipc	ra,0x5
     bfc:	d1a080e7          	jalr	-742(ra) # 5912 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c00:	660d                	lui	a2,0x3
     c02:	0000c597          	auipc	a1,0xc
     c06:	51658593          	addi	a1,a1,1302 # d118 <buf>
     c0a:	8526                	mv	a0,s1
     c0c:	00005097          	auipc	ra,0x5
     c10:	cf6080e7          	jalr	-778(ra) # 5902 <read>
     c14:	4795                	li	a5,5
     c16:	0af51563          	bne	a0,a5,cc0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1a:	0000c717          	auipc	a4,0xc
     c1e:	4fe74703          	lbu	a4,1278(a4) # d118 <buf>
     c22:	06800793          	li	a5,104
     c26:	0af71b63          	bne	a4,a5,cdc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2a:	4629                	li	a2,10
     c2c:	0000c597          	auipc	a1,0xc
     c30:	4ec58593          	addi	a1,a1,1260 # d118 <buf>
     c34:	8526                	mv	a0,s1
     c36:	00005097          	auipc	ra,0x5
     c3a:	cd4080e7          	jalr	-812(ra) # 590a <write>
     c3e:	47a9                	li	a5,10
     c40:	0af51c63          	bne	a0,a5,cf8 <unlinkread+0x19a>
  close(fd);
     c44:	8526                	mv	a0,s1
     c46:	00005097          	auipc	ra,0x5
     c4a:	ccc080e7          	jalr	-820(ra) # 5912 <close>
  unlink("unlinkread");
     c4e:	00005517          	auipc	a0,0x5
     c52:	6d250513          	addi	a0,a0,1746 # 6320 <malloc+0x606>
     c56:	00005097          	auipc	ra,0x5
     c5a:	ce4080e7          	jalr	-796(ra) # 593a <unlink>
}
     c5e:	70a2                	ld	ra,40(sp)
     c60:	7402                	ld	s0,32(sp)
     c62:	64e2                	ld	s1,24(sp)
     c64:	6942                	ld	s2,16(sp)
     c66:	69a2                	ld	s3,8(sp)
     c68:	6145                	addi	sp,sp,48
     c6a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	6c250513          	addi	a0,a0,1730 # 6330 <malloc+0x616>
     c76:	00005097          	auipc	ra,0x5
     c7a:	fec080e7          	jalr	-20(ra) # 5c62 <printf>
    exit(1);
     c7e:	4505                	li	a0,1
     c80:	00005097          	auipc	ra,0x5
     c84:	c6a080e7          	jalr	-918(ra) # 58ea <exit>
    printf("%s: open unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	6ce50513          	addi	a0,a0,1742 # 6358 <malloc+0x63e>
     c92:	00005097          	auipc	ra,0x5
     c96:	fd0080e7          	jalr	-48(ra) # 5c62 <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00005097          	auipc	ra,0x5
     ca0:	c4e080e7          	jalr	-946(ra) # 58ea <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	6d250513          	addi	a0,a0,1746 # 6378 <malloc+0x65e>
     cae:	00005097          	auipc	ra,0x5
     cb2:	fb4080e7          	jalr	-76(ra) # 5c62 <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00005097          	auipc	ra,0x5
     cbc:	c32080e7          	jalr	-974(ra) # 58ea <exit>
    printf("%s: unlinkread read failed", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	6de50513          	addi	a0,a0,1758 # 63a0 <malloc+0x686>
     cca:	00005097          	auipc	ra,0x5
     cce:	f98080e7          	jalr	-104(ra) # 5c62 <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	c16080e7          	jalr	-1002(ra) # 58ea <exit>
    printf("%s: unlinkread wrong data\n", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	6e250513          	addi	a0,a0,1762 # 63c0 <malloc+0x6a6>
     ce6:	00005097          	auipc	ra,0x5
     cea:	f7c080e7          	jalr	-132(ra) # 5c62 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	bfa080e7          	jalr	-1030(ra) # 58ea <exit>
    printf("%s: unlinkread write failed\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	6e650513          	addi	a0,a0,1766 # 63e0 <malloc+0x6c6>
     d02:	00005097          	auipc	ra,0x5
     d06:	f60080e7          	jalr	-160(ra) # 5c62 <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	bde080e7          	jalr	-1058(ra) # 58ea <exit>

0000000000000d14 <linktest>:
{
     d14:	1101                	addi	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	892a                	mv	s2,a0
  unlink("lf1");
     d22:	00005517          	auipc	a0,0x5
     d26:	6de50513          	addi	a0,a0,1758 # 6400 <malloc+0x6e6>
     d2a:	00005097          	auipc	ra,0x5
     d2e:	c10080e7          	jalr	-1008(ra) # 593a <unlink>
  unlink("lf2");
     d32:	00005517          	auipc	a0,0x5
     d36:	6d650513          	addi	a0,a0,1750 # 6408 <malloc+0x6ee>
     d3a:	00005097          	auipc	ra,0x5
     d3e:	c00080e7          	jalr	-1024(ra) # 593a <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d42:	20200593          	li	a1,514
     d46:	00005517          	auipc	a0,0x5
     d4a:	6ba50513          	addi	a0,a0,1722 # 6400 <malloc+0x6e6>
     d4e:	00005097          	auipc	ra,0x5
     d52:	bdc080e7          	jalr	-1060(ra) # 592a <open>
  if(fd < 0){
     d56:	10054763          	bltz	a0,e64 <linktest+0x150>
     d5a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5c:	4615                	li	a2,5
     d5e:	00005597          	auipc	a1,0x5
     d62:	5f258593          	addi	a1,a1,1522 # 6350 <malloc+0x636>
     d66:	00005097          	auipc	ra,0x5
     d6a:	ba4080e7          	jalr	-1116(ra) # 590a <write>
     d6e:	4795                	li	a5,5
     d70:	10f51863          	bne	a0,a5,e80 <linktest+0x16c>
  close(fd);
     d74:	8526                	mv	a0,s1
     d76:	00005097          	auipc	ra,0x5
     d7a:	b9c080e7          	jalr	-1124(ra) # 5912 <close>
  if(link("lf1", "lf2") < 0){
     d7e:	00005597          	auipc	a1,0x5
     d82:	68a58593          	addi	a1,a1,1674 # 6408 <malloc+0x6ee>
     d86:	00005517          	auipc	a0,0x5
     d8a:	67a50513          	addi	a0,a0,1658 # 6400 <malloc+0x6e6>
     d8e:	00005097          	auipc	ra,0x5
     d92:	bbc080e7          	jalr	-1092(ra) # 594a <link>
     d96:	10054363          	bltz	a0,e9c <linktest+0x188>
  unlink("lf1");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	66650513          	addi	a0,a0,1638 # 6400 <malloc+0x6e6>
     da2:	00005097          	auipc	ra,0x5
     da6:	b98080e7          	jalr	-1128(ra) # 593a <unlink>
  if(open("lf1", 0) >= 0){
     daa:	4581                	li	a1,0
     dac:	00005517          	auipc	a0,0x5
     db0:	65450513          	addi	a0,a0,1620 # 6400 <malloc+0x6e6>
     db4:	00005097          	auipc	ra,0x5
     db8:	b76080e7          	jalr	-1162(ra) # 592a <open>
     dbc:	0e055e63          	bgez	a0,eb8 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc0:	4581                	li	a1,0
     dc2:	00005517          	auipc	a0,0x5
     dc6:	64650513          	addi	a0,a0,1606 # 6408 <malloc+0x6ee>
     dca:	00005097          	auipc	ra,0x5
     dce:	b60080e7          	jalr	-1184(ra) # 592a <open>
     dd2:	84aa                	mv	s1,a0
  if(fd < 0){
     dd4:	10054063          	bltz	a0,ed4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dd8:	660d                	lui	a2,0x3
     dda:	0000c597          	auipc	a1,0xc
     dde:	33e58593          	addi	a1,a1,830 # d118 <buf>
     de2:	00005097          	auipc	ra,0x5
     de6:	b20080e7          	jalr	-1248(ra) # 5902 <read>
     dea:	4795                	li	a5,5
     dec:	10f51263          	bne	a0,a5,ef0 <linktest+0x1dc>
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00005097          	auipc	ra,0x5
     df6:	b20080e7          	jalr	-1248(ra) # 5912 <close>
  if(link("lf2", "lf2") >= 0){
     dfa:	00005597          	auipc	a1,0x5
     dfe:	60e58593          	addi	a1,a1,1550 # 6408 <malloc+0x6ee>
     e02:	852e                	mv	a0,a1
     e04:	00005097          	auipc	ra,0x5
     e08:	b46080e7          	jalr	-1210(ra) # 594a <link>
     e0c:	10055063          	bgez	a0,f0c <linktest+0x1f8>
  unlink("lf2");
     e10:	00005517          	auipc	a0,0x5
     e14:	5f850513          	addi	a0,a0,1528 # 6408 <malloc+0x6ee>
     e18:	00005097          	auipc	ra,0x5
     e1c:	b22080e7          	jalr	-1246(ra) # 593a <unlink>
  if(link("lf2", "lf1") >= 0){
     e20:	00005597          	auipc	a1,0x5
     e24:	5e058593          	addi	a1,a1,1504 # 6400 <malloc+0x6e6>
     e28:	00005517          	auipc	a0,0x5
     e2c:	5e050513          	addi	a0,a0,1504 # 6408 <malloc+0x6ee>
     e30:	00005097          	auipc	ra,0x5
     e34:	b1a080e7          	jalr	-1254(ra) # 594a <link>
     e38:	0e055863          	bgez	a0,f28 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	5c458593          	addi	a1,a1,1476 # 6400 <malloc+0x6e6>
     e44:	00005517          	auipc	a0,0x5
     e48:	6cc50513          	addi	a0,a0,1740 # 6510 <malloc+0x7f6>
     e4c:	00005097          	auipc	ra,0x5
     e50:	afe080e7          	jalr	-1282(ra) # 594a <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x230>
}
     e58:	60e2                	ld	ra,24(sp)
     e5a:	6442                	ld	s0,16(sp)
     e5c:	64a2                	ld	s1,8(sp)
     e5e:	6902                	ld	s2,0(sp)
     e60:	6105                	addi	sp,sp,32
     e62:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e64:	85ca                	mv	a1,s2
     e66:	00005517          	auipc	a0,0x5
     e6a:	5aa50513          	addi	a0,a0,1450 # 6410 <malloc+0x6f6>
     e6e:	00005097          	auipc	ra,0x5
     e72:	df4080e7          	jalr	-524(ra) # 5c62 <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00005097          	auipc	ra,0x5
     e7c:	a72080e7          	jalr	-1422(ra) # 58ea <exit>
    printf("%s: write lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	5a650513          	addi	a0,a0,1446 # 6428 <malloc+0x70e>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	dd8080e7          	jalr	-552(ra) # 5c62 <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00005097          	auipc	ra,0x5
     e98:	a56080e7          	jalr	-1450(ra) # 58ea <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	5a250513          	addi	a0,a0,1442 # 6440 <malloc+0x726>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	dbc080e7          	jalr	-580(ra) # 5c62 <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00005097          	auipc	ra,0x5
     eb4:	a3a080e7          	jalr	-1478(ra) # 58ea <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	5a650513          	addi	a0,a0,1446 # 6460 <malloc+0x746>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	da0080e7          	jalr	-608(ra) # 5c62 <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00005097          	auipc	ra,0x5
     ed0:	a1e080e7          	jalr	-1506(ra) # 58ea <exit>
    printf("%s: open lf2 failed\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	5ba50513          	addi	a0,a0,1466 # 6490 <malloc+0x776>
     ede:	00005097          	auipc	ra,0x5
     ee2:	d84080e7          	jalr	-636(ra) # 5c62 <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00005097          	auipc	ra,0x5
     eec:	a02080e7          	jalr	-1534(ra) # 58ea <exit>
    printf("%s: read lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	5b650513          	addi	a0,a0,1462 # 64a8 <malloc+0x78e>
     efa:	00005097          	auipc	ra,0x5
     efe:	d68080e7          	jalr	-664(ra) # 5c62 <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00005097          	auipc	ra,0x5
     f08:	9e6080e7          	jalr	-1562(ra) # 58ea <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	5b250513          	addi	a0,a0,1458 # 64c0 <malloc+0x7a6>
     f16:	00005097          	auipc	ra,0x5
     f1a:	d4c080e7          	jalr	-692(ra) # 5c62 <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00005097          	auipc	ra,0x5
     f24:	9ca080e7          	jalr	-1590(ra) # 58ea <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	5be50513          	addi	a0,a0,1470 # 64e8 <malloc+0x7ce>
     f32:	00005097          	auipc	ra,0x5
     f36:	d30080e7          	jalr	-720(ra) # 5c62 <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00005097          	auipc	ra,0x5
     f40:	9ae080e7          	jalr	-1618(ra) # 58ea <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	5d250513          	addi	a0,a0,1490 # 6518 <malloc+0x7fe>
     f4e:	00005097          	auipc	ra,0x5
     f52:	d14080e7          	jalr	-748(ra) # 5c62 <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00005097          	auipc	ra,0x5
     f5c:	992080e7          	jalr	-1646(ra) # 58ea <exit>

0000000000000f60 <bigdir>:
{
     f60:	715d                	addi	sp,sp,-80
     f62:	e486                	sd	ra,72(sp)
     f64:	e0a2                	sd	s0,64(sp)
     f66:	fc26                	sd	s1,56(sp)
     f68:	f84a                	sd	s2,48(sp)
     f6a:	f44e                	sd	s3,40(sp)
     f6c:	f052                	sd	s4,32(sp)
     f6e:	ec56                	sd	s5,24(sp)
     f70:	e85a                	sd	s6,16(sp)
     f72:	0880                	addi	s0,sp,80
     f74:	89aa                	mv	s3,a0
  unlink("bd");
     f76:	00005517          	auipc	a0,0x5
     f7a:	5c250513          	addi	a0,a0,1474 # 6538 <malloc+0x81e>
     f7e:	00005097          	auipc	ra,0x5
     f82:	9bc080e7          	jalr	-1604(ra) # 593a <unlink>
  fd = open("bd", O_CREATE);
     f86:	20000593          	li	a1,512
     f8a:	00005517          	auipc	a0,0x5
     f8e:	5ae50513          	addi	a0,a0,1454 # 6538 <malloc+0x81e>
     f92:	00005097          	auipc	ra,0x5
     f96:	998080e7          	jalr	-1640(ra) # 592a <open>
  if(fd < 0){
     f9a:	0c054963          	bltz	a0,106c <bigdir+0x10c>
  close(fd);
     f9e:	00005097          	auipc	ra,0x5
     fa2:	974080e7          	jalr	-1676(ra) # 5912 <close>
  for(i = 0; i < N; i++){
     fa6:	4901                	li	s2,0
    name[0] = 'x';
     fa8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fac:	00005a17          	auipc	s4,0x5
     fb0:	58ca0a13          	addi	s4,s4,1420 # 6538 <malloc+0x81e>
  for(i = 0; i < N; i++){
     fb4:	1f400b13          	li	s6,500
    name[0] = 'x';
     fb8:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbc:	41f9571b          	sraiw	a4,s2,0x1f
     fc0:	01a7571b          	srliw	a4,a4,0x1a
     fc4:	012707bb          	addw	a5,a4,s2
     fc8:	4067d69b          	sraiw	a3,a5,0x6
     fcc:	0306869b          	addiw	a3,a3,48
     fd0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd4:	03f7f793          	andi	a5,a5,63
     fd8:	9f99                	subw	a5,a5,a4
     fda:	0307879b          	addiw	a5,a5,48
     fde:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe2:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe6:	fb040593          	addi	a1,s0,-80
     fea:	8552                	mv	a0,s4
     fec:	00005097          	auipc	ra,0x5
     ff0:	95e080e7          	jalr	-1698(ra) # 594a <link>
     ff4:	84aa                	mv	s1,a0
     ff6:	e949                	bnez	a0,1088 <bigdir+0x128>
  for(i = 0; i < N; i++){
     ff8:	2905                	addiw	s2,s2,1
     ffa:	fb691fe3          	bne	s2,s6,fb8 <bigdir+0x58>
  unlink("bd");
     ffe:	00005517          	auipc	a0,0x5
    1002:	53a50513          	addi	a0,a0,1338 # 6538 <malloc+0x81e>
    1006:	00005097          	auipc	ra,0x5
    100a:	934080e7          	jalr	-1740(ra) # 593a <unlink>
    name[0] = 'x';
    100e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1012:	1f400a13          	li	s4,500
    name[0] = 'x';
    1016:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101a:	41f4d71b          	sraiw	a4,s1,0x1f
    101e:	01a7571b          	srliw	a4,a4,0x1a
    1022:	009707bb          	addw	a5,a4,s1
    1026:	4067d69b          	sraiw	a3,a5,0x6
    102a:	0306869b          	addiw	a3,a3,48
    102e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1032:	03f7f793          	andi	a5,a5,63
    1036:	9f99                	subw	a5,a5,a4
    1038:	0307879b          	addiw	a5,a5,48
    103c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1040:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1044:	fb040513          	addi	a0,s0,-80
    1048:	00005097          	auipc	ra,0x5
    104c:	8f2080e7          	jalr	-1806(ra) # 593a <unlink>
    1050:	ed21                	bnez	a0,10a8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1052:	2485                	addiw	s1,s1,1
    1054:	fd4491e3          	bne	s1,s4,1016 <bigdir+0xb6>
}
    1058:	60a6                	ld	ra,72(sp)
    105a:	6406                	ld	s0,64(sp)
    105c:	74e2                	ld	s1,56(sp)
    105e:	7942                	ld	s2,48(sp)
    1060:	79a2                	ld	s3,40(sp)
    1062:	7a02                	ld	s4,32(sp)
    1064:	6ae2                	ld	s5,24(sp)
    1066:	6b42                	ld	s6,16(sp)
    1068:	6161                	addi	sp,sp,80
    106a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106c:	85ce                	mv	a1,s3
    106e:	00005517          	auipc	a0,0x5
    1072:	4d250513          	addi	a0,a0,1234 # 6540 <malloc+0x826>
    1076:	00005097          	auipc	ra,0x5
    107a:	bec080e7          	jalr	-1044(ra) # 5c62 <printf>
    exit(1);
    107e:	4505                	li	a0,1
    1080:	00005097          	auipc	ra,0x5
    1084:	86a080e7          	jalr	-1942(ra) # 58ea <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1088:	fb040613          	addi	a2,s0,-80
    108c:	85ce                	mv	a1,s3
    108e:	00005517          	auipc	a0,0x5
    1092:	4d250513          	addi	a0,a0,1234 # 6560 <malloc+0x846>
    1096:	00005097          	auipc	ra,0x5
    109a:	bcc080e7          	jalr	-1076(ra) # 5c62 <printf>
      exit(1);
    109e:	4505                	li	a0,1
    10a0:	00005097          	auipc	ra,0x5
    10a4:	84a080e7          	jalr	-1974(ra) # 58ea <exit>
      printf("%s: bigdir unlink failed", s);
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	4d650513          	addi	a0,a0,1238 # 6580 <malloc+0x866>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	bb0080e7          	jalr	-1104(ra) # 5c62 <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00005097          	auipc	ra,0x5
    10c0:	82e080e7          	jalr	-2002(ra) # 58ea <exit>

00000000000010c4 <validatetest>:
{
    10c4:	7139                	addi	sp,sp,-64
    10c6:	fc06                	sd	ra,56(sp)
    10c8:	f822                	sd	s0,48(sp)
    10ca:	f426                	sd	s1,40(sp)
    10cc:	f04a                	sd	s2,32(sp)
    10ce:	ec4e                	sd	s3,24(sp)
    10d0:	e852                	sd	s4,16(sp)
    10d2:	e456                	sd	s5,8(sp)
    10d4:	e05a                	sd	s6,0(sp)
    10d6:	0080                	addi	s0,sp,64
    10d8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10da:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10dc:	00005997          	auipc	s3,0x5
    10e0:	4c498993          	addi	s3,s3,1220 # 65a0 <malloc+0x886>
    10e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e6:	6a85                	lui	s5,0x1
    10e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ec:	85a6                	mv	a1,s1
    10ee:	854e                	mv	a0,s3
    10f0:	00005097          	auipc	ra,0x5
    10f4:	85a080e7          	jalr	-1958(ra) # 594a <link>
    10f8:	01251f63          	bne	a0,s2,1116 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	94d6                	add	s1,s1,s5
    10fe:	ff4497e3          	bne	s1,s4,10ec <validatetest+0x28>
}
    1102:	70e2                	ld	ra,56(sp)
    1104:	7442                	ld	s0,48(sp)
    1106:	74a2                	ld	s1,40(sp)
    1108:	7902                	ld	s2,32(sp)
    110a:	69e2                	ld	s3,24(sp)
    110c:	6a42                	ld	s4,16(sp)
    110e:	6aa2                	ld	s5,8(sp)
    1110:	6b02                	ld	s6,0(sp)
    1112:	6121                	addi	sp,sp,64
    1114:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1116:	85da                	mv	a1,s6
    1118:	00005517          	auipc	a0,0x5
    111c:	49850513          	addi	a0,a0,1176 # 65b0 <malloc+0x896>
    1120:	00005097          	auipc	ra,0x5
    1124:	b42080e7          	jalr	-1214(ra) # 5c62 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00004097          	auipc	ra,0x4
    112e:	7c0080e7          	jalr	1984(ra) # 58ea <exit>

0000000000001132 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1132:	7179                	addi	sp,sp,-48
    1134:	f406                	sd	ra,40(sp)
    1136:	f022                	sd	s0,32(sp)
    1138:	ec26                	sd	s1,24(sp)
    113a:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113c:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1140:	eaeb14b7          	lui	s1,0xeaeb1
    1144:	b5b48493          	addi	s1,s1,-1189 # ffffffffeaeb0b5b <__BSS_END__+0xffffffffeaea0a33>
    1148:	04d2                	slli	s1,s1,0x14
    114a:	048d                	addi	s1,s1,3
    114c:	04b2                	slli	s1,s1,0xc
    114e:	f5e48493          	addi	s1,s1,-162
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	7ca080e7          	jalr	1994(ra) # 5922 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	798080e7          	jalr	1944(ra) # 58fa <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	77e080e7          	jalr	1918(ra) # 58ea <exit>

0000000000001174 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1174:	7139                	addi	sp,sp,-64
    1176:	fc06                	sd	ra,56(sp)
    1178:	f822                	sd	s0,48(sp)
    117a:	f426                	sd	s1,40(sp)
    117c:	f04a                	sd	s2,32(sp)
    117e:	ec4e                	sd	s3,24(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	64b1                	lui	s1,0xc
    1184:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1948>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	cca98993          	addi	s3,s3,-822 # 5e58 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	77e080e7          	jalr	1918(ra) # 5922 <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	738080e7          	jalr	1848(ra) # 58ea <exit>

00000000000011ba <copyinstr2>:
{
    11ba:	7155                	addi	sp,sp,-208
    11bc:	e586                	sd	ra,200(sp)
    11be:	e1a2                	sd	s0,192(sp)
    11c0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c2:	f6840793          	addi	a5,s0,-152
    11c6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11ca:	07800713          	li	a4,120
    11ce:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d2:	0785                	addi	a5,a5,1
    11d4:	fed79de3          	bne	a5,a3,11ce <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11dc:	f6840513          	addi	a0,s0,-152
    11e0:	00004097          	auipc	ra,0x4
    11e4:	75a080e7          	jalr	1882(ra) # 593a <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	734080e7          	jalr	1844(ra) # 592a <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	740080e7          	jalr	1856(ra) # 594a <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	59078793          	addi	a5,a5,1424 # 77a8 <malloc+0x1a8e>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	6f2080e7          	jalr	1778(ra) # 5922 <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	6a4080e7          	jalr	1700(ra) # 58e2 <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00008797          	auipc	a5,0x8
    1252:	7b278793          	addi	a5,a5,1970 # 9a00 <big.0>
    1256:	00009697          	auipc	a3,0x9
    125a:	7aa68693          	addi	a3,a3,1962 # aa00 <__global_pointer$+0x90c>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00009797          	auipc	a5,0x9
    1270:	78078a23          	sb	zero,1940(a5) # aa00 <__global_pointer$+0x90c>
    char *args2[] = { big, big, big, 0 };
    1274:	00007797          	auipc	a5,0x7
    1278:	f7c78793          	addi	a5,a5,-132 # 81f0 <malloc+0x24d6>
    127c:	6390                	ld	a2,0(a5)
    127e:	6794                	ld	a3,8(a5)
    1280:	6b98                	ld	a4,16(a5)
    1282:	6f9c                	ld	a5,24(a5)
    1284:	f2c43823          	sd	a2,-208(s0)
    1288:	f2d43c23          	sd	a3,-200(s0)
    128c:	f4e43023          	sd	a4,-192(s0)
    1290:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1294:	f3040593          	addi	a1,s0,-208
    1298:	00005517          	auipc	a0,0x5
    129c:	bc050513          	addi	a0,a0,-1088 # 5e58 <malloc+0x13e>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	682080e7          	jalr	1666(ra) # 5922 <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	3a850513          	addi	a0,a0,936 # 6658 <malloc+0x93e>
    12b8:	00005097          	auipc	ra,0x5
    12bc:	9aa080e7          	jalr	-1622(ra) # 5c62 <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	628080e7          	jalr	1576(ra) # 58ea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	30050513          	addi	a0,a0,768 # 65d0 <malloc+0x8b6>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	98a080e7          	jalr	-1654(ra) # 5c62 <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	608080e7          	jalr	1544(ra) # 58ea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	30050513          	addi	a0,a0,768 # 65f0 <malloc+0x8d6>
    12f8:	00005097          	auipc	ra,0x5
    12fc:	96a080e7          	jalr	-1686(ra) # 5c62 <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	5e8080e7          	jalr	1512(ra) # 58ea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	2fe50513          	addi	a0,a0,766 # 6610 <malloc+0x8f6>
    131a:	00005097          	auipc	ra,0x5
    131e:	948080e7          	jalr	-1720(ra) # 5c62 <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	5c6080e7          	jalr	1478(ra) # 58ea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	30650513          	addi	a0,a0,774 # 6638 <malloc+0x91e>
    133a:	00005097          	auipc	ra,0x5
    133e:	928080e7          	jalr	-1752(ra) # 5c62 <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	5a6080e7          	jalr	1446(ra) # 58ea <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	78450513          	addi	a0,a0,1924 # 6ad0 <malloc+0xdb6>
    1354:	00005097          	auipc	ra,0x5
    1358:	90e080e7          	jalr	-1778(ra) # 5c62 <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	58c080e7          	jalr	1420(ra) # 58ea <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	580080e7          	jalr	1408(ra) # 58ea <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	578080e7          	jalr	1400(ra) # 58f2 <wait>
  if(st != 747){
    1382:	f5442703          	lw	a4,-172(s0)
    1386:	2eb00793          	li	a5,747
    138a:	00f71663          	bne	a4,a5,1396 <copyinstr2+0x1dc>
}
    138e:	60ae                	ld	ra,200(sp)
    1390:	640e                	ld	s0,192(sp)
    1392:	6169                	addi	sp,sp,208
    1394:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1396:	00005517          	auipc	a0,0x5
    139a:	2ea50513          	addi	a0,a0,746 # 6680 <malloc+0x966>
    139e:	00005097          	auipc	ra,0x5
    13a2:	8c4080e7          	jalr	-1852(ra) # 5c62 <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	542080e7          	jalr	1346(ra) # 58ea <exit>

00000000000013b0 <truncate3>:
{
    13b0:	7159                	addi	sp,sp,-112
    13b2:	f486                	sd	ra,104(sp)
    13b4:	f0a2                	sd	s0,96(sp)
    13b6:	e8ca                	sd	s2,80(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	af050513          	addi	a0,a0,-1296 # 5eb0 <malloc+0x196>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	562080e7          	jalr	1378(ra) # 592a <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	542080e7          	jalr	1346(ra) # 5912 <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	50a080e7          	jalr	1290(ra) # 58e2 <fork>
  if(pid < 0){
    13e0:	08054463          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e16d                	bnez	a0,14c6 <truncate3+0x116>
    13e6:	eca6                	sd	s1,88(sp)
    13e8:	e4ce                	sd	s3,72(sp)
    13ea:	e0d2                	sd	s4,64(sp)
    13ec:	fc56                	sd	s5,56(sp)
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00005a17          	auipc	s4,0x5
    13f6:	abea0a13          	addi	s4,s4,-1346 # 5eb0 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	2e6a8a93          	addi	s5,s5,742 # 66e0 <malloc+0x9c6>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	524080e7          	jalr	1316(ra) # 592a <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054e63          	bltz	a0,148c <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	4f2080e7          	jalr	1266(ra) # 590a <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	08f51363          	bne	a0,a5,14a8 <truncate3+0xf8>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	4ea080e7          	jalr	1258(ra) # 5912 <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	4f6080e7          	jalr	1270(ra) # 592a <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	4bc080e7          	jalr	1212(ra) # 5902 <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	4c2080e7          	jalr	1218(ra) # 5912 <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	48a080e7          	jalr	1162(ra) # 58ea <exit>
    1468:	eca6                	sd	s1,88(sp)
    146a:	e4ce                	sd	s3,72(sp)
    146c:	e0d2                	sd	s4,64(sp)
    146e:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1470:	85ca                	mv	a1,s2
    1472:	00005517          	auipc	a0,0x5
    1476:	23e50513          	addi	a0,a0,574 # 66b0 <malloc+0x996>
    147a:	00004097          	auipc	ra,0x4
    147e:	7e8080e7          	jalr	2024(ra) # 5c62 <printf>
    exit(1);
    1482:	4505                	li	a0,1
    1484:	00004097          	auipc	ra,0x4
    1488:	466080e7          	jalr	1126(ra) # 58ea <exit>
        printf("%s: open failed\n", s);
    148c:	85ca                	mv	a1,s2
    148e:	00005517          	auipc	a0,0x5
    1492:	23a50513          	addi	a0,a0,570 # 66c8 <malloc+0x9ae>
    1496:	00004097          	auipc	ra,0x4
    149a:	7cc080e7          	jalr	1996(ra) # 5c62 <printf>
        exit(1);
    149e:	4505                	li	a0,1
    14a0:	00004097          	auipc	ra,0x4
    14a4:	44a080e7          	jalr	1098(ra) # 58ea <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a8:	862a                	mv	a2,a0
    14aa:	85ca                	mv	a1,s2
    14ac:	00005517          	auipc	a0,0x5
    14b0:	24450513          	addi	a0,a0,580 # 66f0 <malloc+0x9d6>
    14b4:	00004097          	auipc	ra,0x4
    14b8:	7ae080e7          	jalr	1966(ra) # 5c62 <printf>
        exit(1);
    14bc:	4505                	li	a0,1
    14be:	00004097          	auipc	ra,0x4
    14c2:	42c080e7          	jalr	1068(ra) # 58ea <exit>
    14c6:	eca6                	sd	s1,88(sp)
    14c8:	e4ce                	sd	s3,72(sp)
    14ca:	e0d2                	sd	s4,64(sp)
    14cc:	fc56                	sd	s5,56(sp)
    14ce:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	00005a17          	auipc	s4,0x5
    14d6:	9dea0a13          	addi	s4,s4,-1570 # 5eb0 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    14da:	00005a97          	auipc	s5,0x5
    14de:	236a8a93          	addi	s5,s5,566 # 6710 <malloc+0x9f6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14e2:	60100593          	li	a1,1537
    14e6:	8552                	mv	a0,s4
    14e8:	00004097          	auipc	ra,0x4
    14ec:	442080e7          	jalr	1090(ra) # 592a <open>
    14f0:	84aa                	mv	s1,a0
    if(fd < 0){
    14f2:	04054763          	bltz	a0,1540 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    14f6:	460d                	li	a2,3
    14f8:	85d6                	mv	a1,s5
    14fa:	00004097          	auipc	ra,0x4
    14fe:	410080e7          	jalr	1040(ra) # 590a <write>
    if(n != 3){
    1502:	478d                	li	a5,3
    1504:	04f51c63          	bne	a0,a5,155c <truncate3+0x1ac>
    close(fd);
    1508:	8526                	mv	a0,s1
    150a:	00004097          	auipc	ra,0x4
    150e:	408080e7          	jalr	1032(ra) # 5912 <close>
  for(int i = 0; i < 150; i++){
    1512:	39fd                	addiw	s3,s3,-1
    1514:	fc0997e3          	bnez	s3,14e2 <truncate3+0x132>
  wait(&xstatus);
    1518:	fbc40513          	addi	a0,s0,-68
    151c:	00004097          	auipc	ra,0x4
    1520:	3d6080e7          	jalr	982(ra) # 58f2 <wait>
  unlink("truncfile");
    1524:	00005517          	auipc	a0,0x5
    1528:	98c50513          	addi	a0,a0,-1652 # 5eb0 <malloc+0x196>
    152c:	00004097          	auipc	ra,0x4
    1530:	40e080e7          	jalr	1038(ra) # 593a <unlink>
  exit(xstatus);
    1534:	fbc42503          	lw	a0,-68(s0)
    1538:	00004097          	auipc	ra,0x4
    153c:	3b2080e7          	jalr	946(ra) # 58ea <exit>
      printf("%s: open failed\n", s);
    1540:	85ca                	mv	a1,s2
    1542:	00005517          	auipc	a0,0x5
    1546:	18650513          	addi	a0,a0,390 # 66c8 <malloc+0x9ae>
    154a:	00004097          	auipc	ra,0x4
    154e:	718080e7          	jalr	1816(ra) # 5c62 <printf>
      exit(1);
    1552:	4505                	li	a0,1
    1554:	00004097          	auipc	ra,0x4
    1558:	396080e7          	jalr	918(ra) # 58ea <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    155c:	862a                	mv	a2,a0
    155e:	85ca                	mv	a1,s2
    1560:	00005517          	auipc	a0,0x5
    1564:	1b850513          	addi	a0,a0,440 # 6718 <malloc+0x9fe>
    1568:	00004097          	auipc	ra,0x4
    156c:	6fa080e7          	jalr	1786(ra) # 5c62 <printf>
      exit(1);
    1570:	4505                	li	a0,1
    1572:	00004097          	auipc	ra,0x4
    1576:	378080e7          	jalr	888(ra) # 58ea <exit>

000000000000157a <exectest>:
{
    157a:	715d                	addi	sp,sp,-80
    157c:	e486                	sd	ra,72(sp)
    157e:	e0a2                	sd	s0,64(sp)
    1580:	f84a                	sd	s2,48(sp)
    1582:	0880                	addi	s0,sp,80
    1584:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1586:	00005797          	auipc	a5,0x5
    158a:	8d278793          	addi	a5,a5,-1838 # 5e58 <malloc+0x13e>
    158e:	fcf43023          	sd	a5,-64(s0)
    1592:	00005797          	auipc	a5,0x5
    1596:	1a678793          	addi	a5,a5,422 # 6738 <malloc+0xa1e>
    159a:	fcf43423          	sd	a5,-56(s0)
    159e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a2:	00005517          	auipc	a0,0x5
    15a6:	19e50513          	addi	a0,a0,414 # 6740 <malloc+0xa26>
    15aa:	00004097          	auipc	ra,0x4
    15ae:	390080e7          	jalr	912(ra) # 593a <unlink>
  pid = fork();
    15b2:	00004097          	auipc	ra,0x4
    15b6:	330080e7          	jalr	816(ra) # 58e2 <fork>
  if(pid < 0) {
    15ba:	04054763          	bltz	a0,1608 <exectest+0x8e>
    15be:	fc26                	sd	s1,56(sp)
    15c0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15c2:	ed41                	bnez	a0,165a <exectest+0xe0>
    close(1);
    15c4:	4505                	li	a0,1
    15c6:	00004097          	auipc	ra,0x4
    15ca:	34c080e7          	jalr	844(ra) # 5912 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15ce:	20100593          	li	a1,513
    15d2:	00005517          	auipc	a0,0x5
    15d6:	16e50513          	addi	a0,a0,366 # 6740 <malloc+0xa26>
    15da:	00004097          	auipc	ra,0x4
    15de:	350080e7          	jalr	848(ra) # 592a <open>
    if(fd < 0) {
    15e2:	04054263          	bltz	a0,1626 <exectest+0xac>
    if(fd != 1) {
    15e6:	4785                	li	a5,1
    15e8:	04f50d63          	beq	a0,a5,1642 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    15ec:	85ca                	mv	a1,s2
    15ee:	00005517          	auipc	a0,0x5
    15f2:	17250513          	addi	a0,a0,370 # 6760 <malloc+0xa46>
    15f6:	00004097          	auipc	ra,0x4
    15fa:	66c080e7          	jalr	1644(ra) # 5c62 <printf>
      exit(1);
    15fe:	4505                	li	a0,1
    1600:	00004097          	auipc	ra,0x4
    1604:	2ea080e7          	jalr	746(ra) # 58ea <exit>
    1608:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    160a:	85ca                	mv	a1,s2
    160c:	00005517          	auipc	a0,0x5
    1610:	0a450513          	addi	a0,a0,164 # 66b0 <malloc+0x996>
    1614:	00004097          	auipc	ra,0x4
    1618:	64e080e7          	jalr	1614(ra) # 5c62 <printf>
     exit(1);
    161c:	4505                	li	a0,1
    161e:	00004097          	auipc	ra,0x4
    1622:	2cc080e7          	jalr	716(ra) # 58ea <exit>
      printf("%s: create failed\n", s);
    1626:	85ca                	mv	a1,s2
    1628:	00005517          	auipc	a0,0x5
    162c:	12050513          	addi	a0,a0,288 # 6748 <malloc+0xa2e>
    1630:	00004097          	auipc	ra,0x4
    1634:	632080e7          	jalr	1586(ra) # 5c62 <printf>
      exit(1);
    1638:	4505                	li	a0,1
    163a:	00004097          	auipc	ra,0x4
    163e:	2b0080e7          	jalr	688(ra) # 58ea <exit>
    if(exec("echo", echoargv) < 0){
    1642:	fc040593          	addi	a1,s0,-64
    1646:	00005517          	auipc	a0,0x5
    164a:	81250513          	addi	a0,a0,-2030 # 5e58 <malloc+0x13e>
    164e:	00004097          	auipc	ra,0x4
    1652:	2d4080e7          	jalr	724(ra) # 5922 <exec>
    1656:	02054163          	bltz	a0,1678 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    165a:	fdc40513          	addi	a0,s0,-36
    165e:	00004097          	auipc	ra,0x4
    1662:	294080e7          	jalr	660(ra) # 58f2 <wait>
    1666:	02951763          	bne	a0,s1,1694 <exectest+0x11a>
  if(xstatus != 0)
    166a:	fdc42503          	lw	a0,-36(s0)
    166e:	cd0d                	beqz	a0,16a8 <exectest+0x12e>
    exit(xstatus);
    1670:	00004097          	auipc	ra,0x4
    1674:	27a080e7          	jalr	634(ra) # 58ea <exit>
      printf("%s: exec echo failed\n", s);
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	0f650513          	addi	a0,a0,246 # 6770 <malloc+0xa56>
    1682:	00004097          	auipc	ra,0x4
    1686:	5e0080e7          	jalr	1504(ra) # 5c62 <printf>
      exit(1);
    168a:	4505                	li	a0,1
    168c:	00004097          	auipc	ra,0x4
    1690:	25e080e7          	jalr	606(ra) # 58ea <exit>
    printf("%s: wait failed!\n", s);
    1694:	85ca                	mv	a1,s2
    1696:	00005517          	auipc	a0,0x5
    169a:	0f250513          	addi	a0,a0,242 # 6788 <malloc+0xa6e>
    169e:	00004097          	auipc	ra,0x4
    16a2:	5c4080e7          	jalr	1476(ra) # 5c62 <printf>
    16a6:	b7d1                	j	166a <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    16a8:	4581                	li	a1,0
    16aa:	00005517          	auipc	a0,0x5
    16ae:	09650513          	addi	a0,a0,150 # 6740 <malloc+0xa26>
    16b2:	00004097          	auipc	ra,0x4
    16b6:	278080e7          	jalr	632(ra) # 592a <open>
  if(fd < 0) {
    16ba:	02054a63          	bltz	a0,16ee <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    16be:	4609                	li	a2,2
    16c0:	fb840593          	addi	a1,s0,-72
    16c4:	00004097          	auipc	ra,0x4
    16c8:	23e080e7          	jalr	574(ra) # 5902 <read>
    16cc:	4789                	li	a5,2
    16ce:	02f50e63          	beq	a0,a5,170a <exectest+0x190>
    printf("%s: read failed\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	b2450513          	addi	a0,a0,-1244 # 61f8 <malloc+0x4de>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	586080e7          	jalr	1414(ra) # 5c62 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	204080e7          	jalr	516(ra) # 58ea <exit>
    printf("%s: open failed\n", s);
    16ee:	85ca                	mv	a1,s2
    16f0:	00005517          	auipc	a0,0x5
    16f4:	fd850513          	addi	a0,a0,-40 # 66c8 <malloc+0x9ae>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	56a080e7          	jalr	1386(ra) # 5c62 <printf>
    exit(1);
    1700:	4505                	li	a0,1
    1702:	00004097          	auipc	ra,0x4
    1706:	1e8080e7          	jalr	488(ra) # 58ea <exit>
  unlink("echo-ok");
    170a:	00005517          	auipc	a0,0x5
    170e:	03650513          	addi	a0,a0,54 # 6740 <malloc+0xa26>
    1712:	00004097          	auipc	ra,0x4
    1716:	228080e7          	jalr	552(ra) # 593a <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    171a:	fb844703          	lbu	a4,-72(s0)
    171e:	04f00793          	li	a5,79
    1722:	00f71863          	bne	a4,a5,1732 <exectest+0x1b8>
    1726:	fb944703          	lbu	a4,-71(s0)
    172a:	04b00793          	li	a5,75
    172e:	02f70063          	beq	a4,a5,174e <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1732:	85ca                	mv	a1,s2
    1734:	00005517          	auipc	a0,0x5
    1738:	06c50513          	addi	a0,a0,108 # 67a0 <malloc+0xa86>
    173c:	00004097          	auipc	ra,0x4
    1740:	526080e7          	jalr	1318(ra) # 5c62 <printf>
    exit(1);
    1744:	4505                	li	a0,1
    1746:	00004097          	auipc	ra,0x4
    174a:	1a4080e7          	jalr	420(ra) # 58ea <exit>
    exit(0);
    174e:	4501                	li	a0,0
    1750:	00004097          	auipc	ra,0x4
    1754:	19a080e7          	jalr	410(ra) # 58ea <exit>

0000000000001758 <pipe1>:
{
    1758:	711d                	addi	sp,sp,-96
    175a:	ec86                	sd	ra,88(sp)
    175c:	e8a2                	sd	s0,80(sp)
    175e:	fc4e                	sd	s3,56(sp)
    1760:	1080                	addi	s0,sp,96
    1762:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    1764:	fa840513          	addi	a0,s0,-88
    1768:	00004097          	auipc	ra,0x4
    176c:	192080e7          	jalr	402(ra) # 58fa <pipe>
    1770:	ed3d                	bnez	a0,17ee <pipe1+0x96>
    1772:	e4a6                	sd	s1,72(sp)
    1774:	f852                	sd	s4,48(sp)
    1776:	84aa                	mv	s1,a0
  pid = fork();
    1778:	00004097          	auipc	ra,0x4
    177c:	16a080e7          	jalr	362(ra) # 58e2 <fork>
    1780:	8a2a                	mv	s4,a0
  if(pid == 0){
    1782:	c951                	beqz	a0,1816 <pipe1+0xbe>
  } else if(pid > 0){
    1784:	18a05b63          	blez	a0,191a <pipe1+0x1c2>
    1788:	e0ca                	sd	s2,64(sp)
    178a:	f456                	sd	s5,40(sp)
    close(fds[1]);
    178c:	fac42503          	lw	a0,-84(s0)
    1790:	00004097          	auipc	ra,0x4
    1794:	182080e7          	jalr	386(ra) # 5912 <close>
    total = 0;
    1798:	8a26                	mv	s4,s1
    cc = 1;
    179a:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    179c:	0000ca97          	auipc	s5,0xc
    17a0:	97ca8a93          	addi	s5,s5,-1668 # d118 <buf>
    17a4:	864a                	mv	a2,s2
    17a6:	85d6                	mv	a1,s5
    17a8:	fa842503          	lw	a0,-88(s0)
    17ac:	00004097          	auipc	ra,0x4
    17b0:	156080e7          	jalr	342(ra) # 5902 <read>
    17b4:	10a05a63          	blez	a0,18c8 <pipe1+0x170>
      for(i = 0; i < n; i++){
    17b8:	0000c717          	auipc	a4,0xc
    17bc:	96070713          	addi	a4,a4,-1696 # d118 <buf>
    17c0:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17c4:	00074683          	lbu	a3,0(a4)
    17c8:	0ff4f793          	zext.b	a5,s1
    17cc:	2485                	addiw	s1,s1,1
    17ce:	0cf69b63          	bne	a3,a5,18a4 <pipe1+0x14c>
      for(i = 0; i < n; i++){
    17d2:	0705                	addi	a4,a4,1
    17d4:	fec498e3          	bne	s1,a2,17c4 <pipe1+0x6c>
      total += n;
    17d8:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17dc:	0019179b          	slliw	a5,s2,0x1
    17e0:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    17e4:	670d                	lui	a4,0x3
    17e6:	fb277fe3          	bgeu	a4,s2,17a4 <pipe1+0x4c>
        cc = sizeof(buf);
    17ea:	690d                	lui	s2,0x3
    17ec:	bf65                	j	17a4 <pipe1+0x4c>
    17ee:	e4a6                	sd	s1,72(sp)
    17f0:	e0ca                	sd	s2,64(sp)
    17f2:	f852                	sd	s4,48(sp)
    17f4:	f456                	sd	s5,40(sp)
    17f6:	f05a                	sd	s6,32(sp)
    17f8:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    17fa:	85ce                	mv	a1,s3
    17fc:	00005517          	auipc	a0,0x5
    1800:	fbc50513          	addi	a0,a0,-68 # 67b8 <malloc+0xa9e>
    1804:	00004097          	auipc	ra,0x4
    1808:	45e080e7          	jalr	1118(ra) # 5c62 <printf>
    exit(1);
    180c:	4505                	li	a0,1
    180e:	00004097          	auipc	ra,0x4
    1812:	0dc080e7          	jalr	220(ra) # 58ea <exit>
    1816:	e0ca                	sd	s2,64(sp)
    1818:	f456                	sd	s5,40(sp)
    181a:	f05a                	sd	s6,32(sp)
    181c:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    181e:	fa842503          	lw	a0,-88(s0)
    1822:	00004097          	auipc	ra,0x4
    1826:	0f0080e7          	jalr	240(ra) # 5912 <close>
    for(n = 0; n < N; n++){
    182a:	0000cb17          	auipc	s6,0xc
    182e:	8eeb0b13          	addi	s6,s6,-1810 # d118 <buf>
    1832:	416004bb          	negw	s1,s6
    1836:	0ff4f493          	zext.b	s1,s1
    183a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    183e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1840:	6a85                	lui	s5,0x1
    1842:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7d>
{
    1846:	87da                	mv	a5,s6
        buf[i] = seq++;
    1848:	0097873b          	addw	a4,a5,s1
    184c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1850:	0785                	addi	a5,a5,1
    1852:	ff279be3          	bne	a5,s2,1848 <pipe1+0xf0>
    1856:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    185a:	40900613          	li	a2,1033
    185e:	85de                	mv	a1,s7
    1860:	fac42503          	lw	a0,-84(s0)
    1864:	00004097          	auipc	ra,0x4
    1868:	0a6080e7          	jalr	166(ra) # 590a <write>
    186c:	40900793          	li	a5,1033
    1870:	00f51c63          	bne	a0,a5,1888 <pipe1+0x130>
    for(n = 0; n < N; n++){
    1874:	24a5                	addiw	s1,s1,9
    1876:	0ff4f493          	zext.b	s1,s1
    187a:	fd5a16e3          	bne	s4,s5,1846 <pipe1+0xee>
    exit(0);
    187e:	4501                	li	a0,0
    1880:	00004097          	auipc	ra,0x4
    1884:	06a080e7          	jalr	106(ra) # 58ea <exit>
        printf("%s: pipe1 oops 1\n", s);
    1888:	85ce                	mv	a1,s3
    188a:	00005517          	auipc	a0,0x5
    188e:	f4650513          	addi	a0,a0,-186 # 67d0 <malloc+0xab6>
    1892:	00004097          	auipc	ra,0x4
    1896:	3d0080e7          	jalr	976(ra) # 5c62 <printf>
        exit(1);
    189a:	4505                	li	a0,1
    189c:	00004097          	auipc	ra,0x4
    18a0:	04e080e7          	jalr	78(ra) # 58ea <exit>
          printf("%s: pipe1 oops 2\n", s);
    18a4:	85ce                	mv	a1,s3
    18a6:	00005517          	auipc	a0,0x5
    18aa:	f4250513          	addi	a0,a0,-190 # 67e8 <malloc+0xace>
    18ae:	00004097          	auipc	ra,0x4
    18b2:	3b4080e7          	jalr	948(ra) # 5c62 <printf>
          return;
    18b6:	64a6                	ld	s1,72(sp)
    18b8:	6906                	ld	s2,64(sp)
    18ba:	7a42                	ld	s4,48(sp)
    18bc:	7aa2                	ld	s5,40(sp)
}
    18be:	60e6                	ld	ra,88(sp)
    18c0:	6446                	ld	s0,80(sp)
    18c2:	79e2                	ld	s3,56(sp)
    18c4:	6125                	addi	sp,sp,96
    18c6:	8082                	ret
    if(total != N * SZ){
    18c8:	6785                	lui	a5,0x1
    18ca:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7d>
    18ce:	02fa0263          	beq	s4,a5,18f2 <pipe1+0x19a>
    18d2:	f05a                	sd	s6,32(sp)
    18d4:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    18d6:	85d2                	mv	a1,s4
    18d8:	00005517          	auipc	a0,0x5
    18dc:	f2850513          	addi	a0,a0,-216 # 6800 <malloc+0xae6>
    18e0:	00004097          	auipc	ra,0x4
    18e4:	382080e7          	jalr	898(ra) # 5c62 <printf>
      exit(1);
    18e8:	4505                	li	a0,1
    18ea:	00004097          	auipc	ra,0x4
    18ee:	000080e7          	jalr	ra # 58ea <exit>
    18f2:	f05a                	sd	s6,32(sp)
    18f4:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    18f6:	fa842503          	lw	a0,-88(s0)
    18fa:	00004097          	auipc	ra,0x4
    18fe:	018080e7          	jalr	24(ra) # 5912 <close>
    wait(&xstatus);
    1902:	fa440513          	addi	a0,s0,-92
    1906:	00004097          	auipc	ra,0x4
    190a:	fec080e7          	jalr	-20(ra) # 58f2 <wait>
    exit(xstatus);
    190e:	fa442503          	lw	a0,-92(s0)
    1912:	00004097          	auipc	ra,0x4
    1916:	fd8080e7          	jalr	-40(ra) # 58ea <exit>
    191a:	e0ca                	sd	s2,64(sp)
    191c:	f456                	sd	s5,40(sp)
    191e:	f05a                	sd	s6,32(sp)
    1920:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1922:	85ce                	mv	a1,s3
    1924:	00005517          	auipc	a0,0x5
    1928:	efc50513          	addi	a0,a0,-260 # 6820 <malloc+0xb06>
    192c:	00004097          	auipc	ra,0x4
    1930:	336080e7          	jalr	822(ra) # 5c62 <printf>
    exit(1);
    1934:	4505                	li	a0,1
    1936:	00004097          	auipc	ra,0x4
    193a:	fb4080e7          	jalr	-76(ra) # 58ea <exit>

000000000000193e <exitwait>:
{
    193e:	7139                	addi	sp,sp,-64
    1940:	fc06                	sd	ra,56(sp)
    1942:	f822                	sd	s0,48(sp)
    1944:	f426                	sd	s1,40(sp)
    1946:	f04a                	sd	s2,32(sp)
    1948:	ec4e                	sd	s3,24(sp)
    194a:	e852                	sd	s4,16(sp)
    194c:	0080                	addi	s0,sp,64
    194e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1950:	4901                	li	s2,0
    1952:	06400993          	li	s3,100
    pid = fork();
    1956:	00004097          	auipc	ra,0x4
    195a:	f8c080e7          	jalr	-116(ra) # 58e2 <fork>
    195e:	84aa                	mv	s1,a0
    if(pid < 0){
    1960:	02054a63          	bltz	a0,1994 <exitwait+0x56>
    if(pid){
    1964:	c151                	beqz	a0,19e8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1966:	fcc40513          	addi	a0,s0,-52
    196a:	00004097          	auipc	ra,0x4
    196e:	f88080e7          	jalr	-120(ra) # 58f2 <wait>
    1972:	02951f63          	bne	a0,s1,19b0 <exitwait+0x72>
      if(i != xstate) {
    1976:	fcc42783          	lw	a5,-52(s0)
    197a:	05279963          	bne	a5,s2,19cc <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    197e:	2905                	addiw	s2,s2,1 # 3001 <iputtest+0x2f>
    1980:	fd391be3          	bne	s2,s3,1956 <exitwait+0x18>
}
    1984:	70e2                	ld	ra,56(sp)
    1986:	7442                	ld	s0,48(sp)
    1988:	74a2                	ld	s1,40(sp)
    198a:	7902                	ld	s2,32(sp)
    198c:	69e2                	ld	s3,24(sp)
    198e:	6a42                	ld	s4,16(sp)
    1990:	6121                	addi	sp,sp,64
    1992:	8082                	ret
      printf("%s: fork failed\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	d1a50513          	addi	a0,a0,-742 # 66b0 <malloc+0x996>
    199e:	00004097          	auipc	ra,0x4
    19a2:	2c4080e7          	jalr	708(ra) # 5c62 <printf>
      exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	f42080e7          	jalr	-190(ra) # 58ea <exit>
        printf("%s: wait wrong pid\n", s);
    19b0:	85d2                	mv	a1,s4
    19b2:	00005517          	auipc	a0,0x5
    19b6:	e8650513          	addi	a0,a0,-378 # 6838 <malloc+0xb1e>
    19ba:	00004097          	auipc	ra,0x4
    19be:	2a8080e7          	jalr	680(ra) # 5c62 <printf>
        exit(1);
    19c2:	4505                	li	a0,1
    19c4:	00004097          	auipc	ra,0x4
    19c8:	f26080e7          	jalr	-218(ra) # 58ea <exit>
        printf("%s: wait wrong exit status\n", s);
    19cc:	85d2                	mv	a1,s4
    19ce:	00005517          	auipc	a0,0x5
    19d2:	e8250513          	addi	a0,a0,-382 # 6850 <malloc+0xb36>
    19d6:	00004097          	auipc	ra,0x4
    19da:	28c080e7          	jalr	652(ra) # 5c62 <printf>
        exit(1);
    19de:	4505                	li	a0,1
    19e0:	00004097          	auipc	ra,0x4
    19e4:	f0a080e7          	jalr	-246(ra) # 58ea <exit>
      exit(i);
    19e8:	854a                	mv	a0,s2
    19ea:	00004097          	auipc	ra,0x4
    19ee:	f00080e7          	jalr	-256(ra) # 58ea <exit>

00000000000019f2 <twochildren>:
{
    19f2:	1101                	addi	sp,sp,-32
    19f4:	ec06                	sd	ra,24(sp)
    19f6:	e822                	sd	s0,16(sp)
    19f8:	e426                	sd	s1,8(sp)
    19fa:	e04a                	sd	s2,0(sp)
    19fc:	1000                	addi	s0,sp,32
    19fe:	892a                	mv	s2,a0
    1a00:	3e800493          	li	s1,1000
    int pid1 = fork();
    1a04:	00004097          	auipc	ra,0x4
    1a08:	ede080e7          	jalr	-290(ra) # 58e2 <fork>
    if(pid1 < 0){
    1a0c:	02054c63          	bltz	a0,1a44 <twochildren+0x52>
    if(pid1 == 0){
    1a10:	c921                	beqz	a0,1a60 <twochildren+0x6e>
      int pid2 = fork();
    1a12:	00004097          	auipc	ra,0x4
    1a16:	ed0080e7          	jalr	-304(ra) # 58e2 <fork>
      if(pid2 < 0){
    1a1a:	04054763          	bltz	a0,1a68 <twochildren+0x76>
      if(pid2 == 0){
    1a1e:	c13d                	beqz	a0,1a84 <twochildren+0x92>
        wait(0);
    1a20:	4501                	li	a0,0
    1a22:	00004097          	auipc	ra,0x4
    1a26:	ed0080e7          	jalr	-304(ra) # 58f2 <wait>
        wait(0);
    1a2a:	4501                	li	a0,0
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	ec6080e7          	jalr	-314(ra) # 58f2 <wait>
  for(int i = 0; i < 1000; i++){
    1a34:	34fd                	addiw	s1,s1,-1
    1a36:	f4f9                	bnez	s1,1a04 <twochildren+0x12>
}
    1a38:	60e2                	ld	ra,24(sp)
    1a3a:	6442                	ld	s0,16(sp)
    1a3c:	64a2                	ld	s1,8(sp)
    1a3e:	6902                	ld	s2,0(sp)
    1a40:	6105                	addi	sp,sp,32
    1a42:	8082                	ret
      printf("%s: fork failed\n", s);
    1a44:	85ca                	mv	a1,s2
    1a46:	00005517          	auipc	a0,0x5
    1a4a:	c6a50513          	addi	a0,a0,-918 # 66b0 <malloc+0x996>
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	214080e7          	jalr	532(ra) # 5c62 <printf>
      exit(1);
    1a56:	4505                	li	a0,1
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	e92080e7          	jalr	-366(ra) # 58ea <exit>
      exit(0);
    1a60:	00004097          	auipc	ra,0x4
    1a64:	e8a080e7          	jalr	-374(ra) # 58ea <exit>
        printf("%s: fork failed\n", s);
    1a68:	85ca                	mv	a1,s2
    1a6a:	00005517          	auipc	a0,0x5
    1a6e:	c4650513          	addi	a0,a0,-954 # 66b0 <malloc+0x996>
    1a72:	00004097          	auipc	ra,0x4
    1a76:	1f0080e7          	jalr	496(ra) # 5c62 <printf>
        exit(1);
    1a7a:	4505                	li	a0,1
    1a7c:	00004097          	auipc	ra,0x4
    1a80:	e6e080e7          	jalr	-402(ra) # 58ea <exit>
        exit(0);
    1a84:	00004097          	auipc	ra,0x4
    1a88:	e66080e7          	jalr	-410(ra) # 58ea <exit>

0000000000001a8c <forkfork>:
{
    1a8c:	7179                	addi	sp,sp,-48
    1a8e:	f406                	sd	ra,40(sp)
    1a90:	f022                	sd	s0,32(sp)
    1a92:	ec26                	sd	s1,24(sp)
    1a94:	1800                	addi	s0,sp,48
    1a96:	84aa                	mv	s1,a0
    int pid = fork();
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	e4a080e7          	jalr	-438(ra) # 58e2 <fork>
    if(pid < 0){
    1aa0:	04054163          	bltz	a0,1ae2 <forkfork+0x56>
    if(pid == 0){
    1aa4:	cd29                	beqz	a0,1afe <forkfork+0x72>
    int pid = fork();
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	e3c080e7          	jalr	-452(ra) # 58e2 <fork>
    if(pid < 0){
    1aae:	02054a63          	bltz	a0,1ae2 <forkfork+0x56>
    if(pid == 0){
    1ab2:	c531                	beqz	a0,1afe <forkfork+0x72>
    wait(&xstatus);
    1ab4:	fdc40513          	addi	a0,s0,-36
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	e3a080e7          	jalr	-454(ra) # 58f2 <wait>
    if(xstatus != 0) {
    1ac0:	fdc42783          	lw	a5,-36(s0)
    1ac4:	ebbd                	bnez	a5,1b3a <forkfork+0xae>
    wait(&xstatus);
    1ac6:	fdc40513          	addi	a0,s0,-36
    1aca:	00004097          	auipc	ra,0x4
    1ace:	e28080e7          	jalr	-472(ra) # 58f2 <wait>
    if(xstatus != 0) {
    1ad2:	fdc42783          	lw	a5,-36(s0)
    1ad6:	e3b5                	bnez	a5,1b3a <forkfork+0xae>
}
    1ad8:	70a2                	ld	ra,40(sp)
    1ada:	7402                	ld	s0,32(sp)
    1adc:	64e2                	ld	s1,24(sp)
    1ade:	6145                	addi	sp,sp,48
    1ae0:	8082                	ret
      printf("%s: fork failed", s);
    1ae2:	85a6                	mv	a1,s1
    1ae4:	00005517          	auipc	a0,0x5
    1ae8:	d8c50513          	addi	a0,a0,-628 # 6870 <malloc+0xb56>
    1aec:	00004097          	auipc	ra,0x4
    1af0:	176080e7          	jalr	374(ra) # 5c62 <printf>
      exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	df4080e7          	jalr	-524(ra) # 58ea <exit>
{
    1afe:	0c800493          	li	s1,200
        int pid1 = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	de0080e7          	jalr	-544(ra) # 58e2 <fork>
        if(pid1 < 0){
    1b0a:	00054f63          	bltz	a0,1b28 <forkfork+0x9c>
        if(pid1 == 0){
    1b0e:	c115                	beqz	a0,1b32 <forkfork+0xa6>
        wait(0);
    1b10:	4501                	li	a0,0
    1b12:	00004097          	auipc	ra,0x4
    1b16:	de0080e7          	jalr	-544(ra) # 58f2 <wait>
      for(int j = 0; j < 200; j++){
    1b1a:	34fd                	addiw	s1,s1,-1
    1b1c:	f0fd                	bnez	s1,1b02 <forkfork+0x76>
      exit(0);
    1b1e:	4501                	li	a0,0
    1b20:	00004097          	auipc	ra,0x4
    1b24:	dca080e7          	jalr	-566(ra) # 58ea <exit>
          exit(1);
    1b28:	4505                	li	a0,1
    1b2a:	00004097          	auipc	ra,0x4
    1b2e:	dc0080e7          	jalr	-576(ra) # 58ea <exit>
          exit(0);
    1b32:	00004097          	auipc	ra,0x4
    1b36:	db8080e7          	jalr	-584(ra) # 58ea <exit>
      printf("%s: fork in child failed", s);
    1b3a:	85a6                	mv	a1,s1
    1b3c:	00005517          	auipc	a0,0x5
    1b40:	d4450513          	addi	a0,a0,-700 # 6880 <malloc+0xb66>
    1b44:	00004097          	auipc	ra,0x4
    1b48:	11e080e7          	jalr	286(ra) # 5c62 <printf>
      exit(1);
    1b4c:	4505                	li	a0,1
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	d9c080e7          	jalr	-612(ra) # 58ea <exit>

0000000000001b56 <reparent2>:
{
    1b56:	1101                	addi	sp,sp,-32
    1b58:	ec06                	sd	ra,24(sp)
    1b5a:	e822                	sd	s0,16(sp)
    1b5c:	e426                	sd	s1,8(sp)
    1b5e:	1000                	addi	s0,sp,32
    1b60:	32000493          	li	s1,800
    int pid1 = fork();
    1b64:	00004097          	auipc	ra,0x4
    1b68:	d7e080e7          	jalr	-642(ra) # 58e2 <fork>
    if(pid1 < 0){
    1b6c:	00054f63          	bltz	a0,1b8a <reparent2+0x34>
    if(pid1 == 0){
    1b70:	c915                	beqz	a0,1ba4 <reparent2+0x4e>
    wait(0);
    1b72:	4501                	li	a0,0
    1b74:	00004097          	auipc	ra,0x4
    1b78:	d7e080e7          	jalr	-642(ra) # 58f2 <wait>
  for(int i = 0; i < 800; i++){
    1b7c:	34fd                	addiw	s1,s1,-1
    1b7e:	f0fd                	bnez	s1,1b64 <reparent2+0xe>
  exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	d68080e7          	jalr	-664(ra) # 58ea <exit>
      printf("fork failed\n");
    1b8a:	00005517          	auipc	a0,0x5
    1b8e:	f4650513          	addi	a0,a0,-186 # 6ad0 <malloc+0xdb6>
    1b92:	00004097          	auipc	ra,0x4
    1b96:	0d0080e7          	jalr	208(ra) # 5c62 <printf>
      exit(1);
    1b9a:	4505                	li	a0,1
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	d4e080e7          	jalr	-690(ra) # 58ea <exit>
      fork();
    1ba4:	00004097          	auipc	ra,0x4
    1ba8:	d3e080e7          	jalr	-706(ra) # 58e2 <fork>
      fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	d36080e7          	jalr	-714(ra) # 58e2 <fork>
      exit(0);
    1bb4:	4501                	li	a0,0
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	d34080e7          	jalr	-716(ra) # 58ea <exit>

0000000000001bbe <createdelete>:
{
    1bbe:	7175                	addi	sp,sp,-144
    1bc0:	e506                	sd	ra,136(sp)
    1bc2:	e122                	sd	s0,128(sp)
    1bc4:	fca6                	sd	s1,120(sp)
    1bc6:	f8ca                	sd	s2,112(sp)
    1bc8:	f4ce                	sd	s3,104(sp)
    1bca:	f0d2                	sd	s4,96(sp)
    1bcc:	ecd6                	sd	s5,88(sp)
    1bce:	e8da                	sd	s6,80(sp)
    1bd0:	e4de                	sd	s7,72(sp)
    1bd2:	e0e2                	sd	s8,64(sp)
    1bd4:	fc66                	sd	s9,56(sp)
    1bd6:	0900                	addi	s0,sp,144
    1bd8:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bda:	4901                	li	s2,0
    1bdc:	4991                	li	s3,4
    pid = fork();
    1bde:	00004097          	auipc	ra,0x4
    1be2:	d04080e7          	jalr	-764(ra) # 58e2 <fork>
    1be6:	84aa                	mv	s1,a0
    if(pid < 0){
    1be8:	02054f63          	bltz	a0,1c26 <createdelete+0x68>
    if(pid == 0){
    1bec:	c939                	beqz	a0,1c42 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bee:	2905                	addiw	s2,s2,1
    1bf0:	ff3917e3          	bne	s2,s3,1bde <createdelete+0x20>
    1bf4:	4491                	li	s1,4
    wait(&xstatus);
    1bf6:	f7c40513          	addi	a0,s0,-132
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	cf8080e7          	jalr	-776(ra) # 58f2 <wait>
    if(xstatus != 0)
    1c02:	f7c42903          	lw	s2,-132(s0)
    1c06:	0e091263          	bnez	s2,1cea <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1c0a:	34fd                	addiw	s1,s1,-1
    1c0c:	f4ed                	bnez	s1,1bf6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1c0e:	f8040123          	sb	zero,-126(s0)
    1c12:	03000993          	li	s3,48
    1c16:	5a7d                	li	s4,-1
    1c18:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1c1c:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c1e:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1c20:	07400a93          	li	s5,116
    1c24:	a28d                	j	1d86 <createdelete+0x1c8>
      printf("fork failed\n", s);
    1c26:	85e6                	mv	a1,s9
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	ea850513          	addi	a0,a0,-344 # 6ad0 <malloc+0xdb6>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	032080e7          	jalr	50(ra) # 5c62 <printf>
      exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00004097          	auipc	ra,0x4
    1c3e:	cb0080e7          	jalr	-848(ra) # 58ea <exit>
      name[0] = 'p' + pi;
    1c42:	0709091b          	addiw	s2,s2,112
    1c46:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c4a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c4e:	4951                	li	s2,20
    1c50:	a015                	j	1c74 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c52:	85e6                	mv	a1,s9
    1c54:	00005517          	auipc	a0,0x5
    1c58:	af450513          	addi	a0,a0,-1292 # 6748 <malloc+0xa2e>
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	006080e7          	jalr	6(ra) # 5c62 <printf>
          exit(1);
    1c64:	4505                	li	a0,1
    1c66:	00004097          	auipc	ra,0x4
    1c6a:	c84080e7          	jalr	-892(ra) # 58ea <exit>
      for(i = 0; i < N; i++){
    1c6e:	2485                	addiw	s1,s1,1
    1c70:	07248863          	beq	s1,s2,1ce0 <createdelete+0x122>
        name[1] = '0' + i;
    1c74:	0304879b          	addiw	a5,s1,48
    1c78:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c7c:	20200593          	li	a1,514
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	ca6080e7          	jalr	-858(ra) # 592a <open>
        if(fd < 0){
    1c8c:	fc0543e3          	bltz	a0,1c52 <createdelete+0x94>
        close(fd);
    1c90:	00004097          	auipc	ra,0x4
    1c94:	c82080e7          	jalr	-894(ra) # 5912 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c98:	12905763          	blez	s1,1dc6 <createdelete+0x208>
    1c9c:	0014f793          	andi	a5,s1,1
    1ca0:	f7f9                	bnez	a5,1c6e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1ca2:	01f4d79b          	srliw	a5,s1,0x1f
    1ca6:	9fa5                	addw	a5,a5,s1
    1ca8:	4017d79b          	sraiw	a5,a5,0x1
    1cac:	0307879b          	addiw	a5,a5,48
    1cb0:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1cb4:	f8040513          	addi	a0,s0,-128
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	c82080e7          	jalr	-894(ra) # 593a <unlink>
    1cc0:	fa0557e3          	bgez	a0,1c6e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	bda50513          	addi	a0,a0,-1062 # 68a0 <malloc+0xb86>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	f94080e7          	jalr	-108(ra) # 5c62 <printf>
            exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	c12080e7          	jalr	-1006(ra) # 58ea <exit>
      exit(0);
    1ce0:	4501                	li	a0,0
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	c08080e7          	jalr	-1016(ra) # 58ea <exit>
      exit(1);
    1cea:	4505                	li	a0,1
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	bfe080e7          	jalr	-1026(ra) # 58ea <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cf4:	f8040613          	addi	a2,s0,-128
    1cf8:	85e6                	mv	a1,s9
    1cfa:	00005517          	auipc	a0,0x5
    1cfe:	bbe50513          	addi	a0,a0,-1090 # 68b8 <malloc+0xb9e>
    1d02:	00004097          	auipc	ra,0x4
    1d06:	f60080e7          	jalr	-160(ra) # 5c62 <printf>
        exit(1);
    1d0a:	4505                	li	a0,1
    1d0c:	00004097          	auipc	ra,0x4
    1d10:	bde080e7          	jalr	-1058(ra) # 58ea <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	034bff63          	bgeu	s7,s4,1d52 <createdelete+0x194>
      if(fd >= 0)
    1d18:	02055863          	bgez	a0,1d48 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1d1c:	2485                	addiw	s1,s1,1
    1d1e:	0ff4f493          	zext.b	s1,s1
    1d22:	05548a63          	beq	s1,s5,1d76 <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1d26:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d2a:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d2e:	4581                	li	a1,0
    1d30:	f8040513          	addi	a0,s0,-128
    1d34:	00004097          	auipc	ra,0x4
    1d38:	bf6080e7          	jalr	-1034(ra) # 592a <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d3c:	00090463          	beqz	s2,1d44 <createdelete+0x186>
    1d40:	fd2b5ae3          	bge	s6,s2,1d14 <createdelete+0x156>
    1d44:	fa0548e3          	bltz	a0,1cf4 <createdelete+0x136>
        close(fd);
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	bca080e7          	jalr	-1078(ra) # 5912 <close>
    1d50:	b7f1                	j	1d1c <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d52:	fc0545e3          	bltz	a0,1d1c <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d56:	f8040613          	addi	a2,s0,-128
    1d5a:	85e6                	mv	a1,s9
    1d5c:	00005517          	auipc	a0,0x5
    1d60:	b8450513          	addi	a0,a0,-1148 # 68e0 <malloc+0xbc6>
    1d64:	00004097          	auipc	ra,0x4
    1d68:	efe080e7          	jalr	-258(ra) # 5c62 <printf>
        exit(1);
    1d6c:	4505                	li	a0,1
    1d6e:	00004097          	auipc	ra,0x4
    1d72:	b7c080e7          	jalr	-1156(ra) # 58ea <exit>
  for(i = 0; i < N; i++){
    1d76:	2905                	addiw	s2,s2,1
    1d78:	2a05                	addiw	s4,s4,1
    1d7a:	2985                	addiw	s3,s3,1
    1d7c:	0ff9f993          	zext.b	s3,s3
    1d80:	47d1                	li	a5,20
    1d82:	02f90a63          	beq	s2,a5,1db6 <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1d86:	84e2                	mv	s1,s8
    1d88:	bf79                	j	1d26 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d8a:	2905                	addiw	s2,s2,1
    1d8c:	0ff97913          	zext.b	s2,s2
    1d90:	2985                	addiw	s3,s3,1
    1d92:	0ff9f993          	zext.b	s3,s3
    1d96:	03490a63          	beq	s2,s4,1dca <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d9a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d9c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1da0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1da4:	f8040513          	addi	a0,s0,-128
    1da8:	00004097          	auipc	ra,0x4
    1dac:	b92080e7          	jalr	-1134(ra) # 593a <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1db0:	34fd                	addiw	s1,s1,-1
    1db2:	f4ed                	bnez	s1,1d9c <createdelete+0x1de>
    1db4:	bfd9                	j	1d8a <createdelete+0x1cc>
    1db6:	03000993          	li	s3,48
    1dba:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1dbe:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1dc0:	08400a13          	li	s4,132
    1dc4:	bfd9                	j	1d9a <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1dc6:	2485                	addiw	s1,s1,1
    1dc8:	b575                	j	1c74 <createdelete+0xb6>
}
    1dca:	60aa                	ld	ra,136(sp)
    1dcc:	640a                	ld	s0,128(sp)
    1dce:	74e6                	ld	s1,120(sp)
    1dd0:	7946                	ld	s2,112(sp)
    1dd2:	79a6                	ld	s3,104(sp)
    1dd4:	7a06                	ld	s4,96(sp)
    1dd6:	6ae6                	ld	s5,88(sp)
    1dd8:	6b46                	ld	s6,80(sp)
    1dda:	6ba6                	ld	s7,72(sp)
    1ddc:	6c06                	ld	s8,64(sp)
    1dde:	7ce2                	ld	s9,56(sp)
    1de0:	6149                	addi	sp,sp,144
    1de2:	8082                	ret

0000000000001de4 <linkunlink>:
{
    1de4:	711d                	addi	sp,sp,-96
    1de6:	ec86                	sd	ra,88(sp)
    1de8:	e8a2                	sd	s0,80(sp)
    1dea:	e4a6                	sd	s1,72(sp)
    1dec:	e0ca                	sd	s2,64(sp)
    1dee:	fc4e                	sd	s3,56(sp)
    1df0:	f852                	sd	s4,48(sp)
    1df2:	f456                	sd	s5,40(sp)
    1df4:	f05a                	sd	s6,32(sp)
    1df6:	ec5e                	sd	s7,24(sp)
    1df8:	e862                	sd	s8,16(sp)
    1dfa:	e466                	sd	s9,8(sp)
    1dfc:	1080                	addi	s0,sp,96
    1dfe:	84aa                	mv	s1,a0
  unlink("x");
    1e00:	00004517          	auipc	a0,0x4
    1e04:	0c850513          	addi	a0,a0,200 # 5ec8 <malloc+0x1ae>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	b32080e7          	jalr	-1230(ra) # 593a <unlink>
  pid = fork();
    1e10:	00004097          	auipc	ra,0x4
    1e14:	ad2080e7          	jalr	-1326(ra) # 58e2 <fork>
  if(pid < 0){
    1e18:	02054b63          	bltz	a0,1e4e <linkunlink+0x6a>
    1e1c:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1e1e:	06100913          	li	s2,97
    1e22:	c111                	beqz	a0,1e26 <linkunlink+0x42>
    1e24:	4905                	li	s2,1
    1e26:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e2a:	41c65a37          	lui	s4,0x41c65
    1e2e:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <__BSS_END__+0x41c54d45>
    1e32:	698d                	lui	s3,0x3
    1e34:	0399899b          	addiw	s3,s3,57 # 3039 <iputtest+0x67>
    if((x % 3) == 0){
    1e38:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1e3a:	4b85                	li	s7,1
      unlink("x");
    1e3c:	00004b17          	auipc	s6,0x4
    1e40:	08cb0b13          	addi	s6,s6,140 # 5ec8 <malloc+0x1ae>
      link("cat", "x");
    1e44:	00005c17          	auipc	s8,0x5
    1e48:	ac4c0c13          	addi	s8,s8,-1340 # 6908 <malloc+0xbee>
    1e4c:	a825                	j	1e84 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e4e:	85a6                	mv	a1,s1
    1e50:	00005517          	auipc	a0,0x5
    1e54:	86050513          	addi	a0,a0,-1952 # 66b0 <malloc+0x996>
    1e58:	00004097          	auipc	ra,0x4
    1e5c:	e0a080e7          	jalr	-502(ra) # 5c62 <printf>
    exit(1);
    1e60:	4505                	li	a0,1
    1e62:	00004097          	auipc	ra,0x4
    1e66:	a88080e7          	jalr	-1400(ra) # 58ea <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e6a:	20200593          	li	a1,514
    1e6e:	855a                	mv	a0,s6
    1e70:	00004097          	auipc	ra,0x4
    1e74:	aba080e7          	jalr	-1350(ra) # 592a <open>
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	a9a080e7          	jalr	-1382(ra) # 5912 <close>
  for(i = 0; i < 100; i++){
    1e80:	34fd                	addiw	s1,s1,-1
    1e82:	c895                	beqz	s1,1eb6 <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    1e84:	034907bb          	mulw	a5,s2,s4
    1e88:	013787bb          	addw	a5,a5,s3
    1e8c:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1e90:	0357f7bb          	remuw	a5,a5,s5
    1e94:	2781                	sext.w	a5,a5
    1e96:	dbf1                	beqz	a5,1e6a <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e98:	01778863          	beq	a5,s7,1ea8 <linkunlink+0xc4>
      unlink("x");
    1e9c:	855a                	mv	a0,s6
    1e9e:	00004097          	auipc	ra,0x4
    1ea2:	a9c080e7          	jalr	-1380(ra) # 593a <unlink>
    1ea6:	bfe9                	j	1e80 <linkunlink+0x9c>
      link("cat", "x");
    1ea8:	85da                	mv	a1,s6
    1eaa:	8562                	mv	a0,s8
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	a9e080e7          	jalr	-1378(ra) # 594a <link>
    1eb4:	b7f1                	j	1e80 <linkunlink+0x9c>
  if(pid)
    1eb6:	020c8463          	beqz	s9,1ede <linkunlink+0xfa>
    wait(0);
    1eba:	4501                	li	a0,0
    1ebc:	00004097          	auipc	ra,0x4
    1ec0:	a36080e7          	jalr	-1482(ra) # 58f2 <wait>
}
    1ec4:	60e6                	ld	ra,88(sp)
    1ec6:	6446                	ld	s0,80(sp)
    1ec8:	64a6                	ld	s1,72(sp)
    1eca:	6906                	ld	s2,64(sp)
    1ecc:	79e2                	ld	s3,56(sp)
    1ece:	7a42                	ld	s4,48(sp)
    1ed0:	7aa2                	ld	s5,40(sp)
    1ed2:	7b02                	ld	s6,32(sp)
    1ed4:	6be2                	ld	s7,24(sp)
    1ed6:	6c42                	ld	s8,16(sp)
    1ed8:	6ca2                	ld	s9,8(sp)
    1eda:	6125                	addi	sp,sp,96
    1edc:	8082                	ret
    exit(0);
    1ede:	4501                	li	a0,0
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	a0a080e7          	jalr	-1526(ra) # 58ea <exit>

0000000000001ee8 <manywrites>:
{
    1ee8:	711d                	addi	sp,sp,-96
    1eea:	ec86                	sd	ra,88(sp)
    1eec:	e8a2                	sd	s0,80(sp)
    1eee:	e4a6                	sd	s1,72(sp)
    1ef0:	e0ca                	sd	s2,64(sp)
    1ef2:	fc4e                	sd	s3,56(sp)
    1ef4:	f456                	sd	s5,40(sp)
    1ef6:	1080                	addi	s0,sp,96
    1ef8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1efa:	4981                	li	s3,0
    1efc:	4911                	li	s2,4
    int pid = fork();
    1efe:	00004097          	auipc	ra,0x4
    1f02:	9e4080e7          	jalr	-1564(ra) # 58e2 <fork>
    1f06:	84aa                	mv	s1,a0
    if(pid < 0){
    1f08:	02054d63          	bltz	a0,1f42 <manywrites+0x5a>
    if(pid == 0){
    1f0c:	c939                	beqz	a0,1f62 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    1f0e:	2985                	addiw	s3,s3,1
    1f10:	ff2997e3          	bne	s3,s2,1efe <manywrites+0x16>
    1f14:	f852                	sd	s4,48(sp)
    1f16:	f05a                	sd	s6,32(sp)
    1f18:	ec5e                	sd	s7,24(sp)
    1f1a:	4491                	li	s1,4
    int st = 0;
    1f1c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f20:	fa840513          	addi	a0,s0,-88
    1f24:	00004097          	auipc	ra,0x4
    1f28:	9ce080e7          	jalr	-1586(ra) # 58f2 <wait>
    if(st != 0)
    1f2c:	fa842503          	lw	a0,-88(s0)
    1f30:	10051463          	bnez	a0,2038 <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    1f34:	34fd                	addiw	s1,s1,-1
    1f36:	f0fd                	bnez	s1,1f1c <manywrites+0x34>
  exit(0);
    1f38:	4501                	li	a0,0
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	9b0080e7          	jalr	-1616(ra) # 58ea <exit>
    1f42:	f852                	sd	s4,48(sp)
    1f44:	f05a                	sd	s6,32(sp)
    1f46:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1f48:	00005517          	auipc	a0,0x5
    1f4c:	b8850513          	addi	a0,a0,-1144 # 6ad0 <malloc+0xdb6>
    1f50:	00004097          	auipc	ra,0x4
    1f54:	d12080e7          	jalr	-750(ra) # 5c62 <printf>
      exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00004097          	auipc	ra,0x4
    1f5e:	990080e7          	jalr	-1648(ra) # 58ea <exit>
    1f62:	f852                	sd	s4,48(sp)
    1f64:	f05a                	sd	s6,32(sp)
    1f66:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1f68:	06200793          	li	a5,98
    1f6c:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f70:	0619879b          	addiw	a5,s3,97
    1f74:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f78:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f7c:	fa840513          	addi	a0,s0,-88
    1f80:	00004097          	auipc	ra,0x4
    1f84:	9ba080e7          	jalr	-1606(ra) # 593a <unlink>
    1f88:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f8a:	0000bb17          	auipc	s6,0xb
    1f8e:	18eb0b13          	addi	s6,s6,398 # d118 <buf>
        for(int i = 0; i < ci+1; i++){
    1f92:	8a26                	mv	s4,s1
    1f94:	0209ce63          	bltz	s3,1fd0 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    1f98:	20200593          	li	a1,514
    1f9c:	fa840513          	addi	a0,s0,-88
    1fa0:	00004097          	auipc	ra,0x4
    1fa4:	98a080e7          	jalr	-1654(ra) # 592a <open>
    1fa8:	892a                	mv	s2,a0
          if(fd < 0){
    1faa:	04054763          	bltz	a0,1ff8 <manywrites+0x110>
          int cc = write(fd, buf, sz);
    1fae:	660d                	lui	a2,0x3
    1fb0:	85da                	mv	a1,s6
    1fb2:	00004097          	auipc	ra,0x4
    1fb6:	958080e7          	jalr	-1704(ra) # 590a <write>
          if(cc != sz){
    1fba:	678d                	lui	a5,0x3
    1fbc:	04f51e63          	bne	a0,a5,2018 <manywrites+0x130>
          close(fd);
    1fc0:	854a                	mv	a0,s2
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	950080e7          	jalr	-1712(ra) # 5912 <close>
        for(int i = 0; i < ci+1; i++){
    1fca:	2a05                	addiw	s4,s4,1
    1fcc:	fd49d6e3          	bge	s3,s4,1f98 <manywrites+0xb0>
        unlink(name);
    1fd0:	fa840513          	addi	a0,s0,-88
    1fd4:	00004097          	auipc	ra,0x4
    1fd8:	966080e7          	jalr	-1690(ra) # 593a <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fdc:	3bfd                	addiw	s7,s7,-1
    1fde:	fa0b9ae3          	bnez	s7,1f92 <manywrites+0xaa>
      unlink(name);
    1fe2:	fa840513          	addi	a0,s0,-88
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	954080e7          	jalr	-1708(ra) # 593a <unlink>
      exit(0);
    1fee:	4501                	li	a0,0
    1ff0:	00004097          	auipc	ra,0x4
    1ff4:	8fa080e7          	jalr	-1798(ra) # 58ea <exit>
            printf("%s: cannot create %s\n", s, name);
    1ff8:	fa840613          	addi	a2,s0,-88
    1ffc:	85d6                	mv	a1,s5
    1ffe:	00005517          	auipc	a0,0x5
    2002:	91250513          	addi	a0,a0,-1774 # 6910 <malloc+0xbf6>
    2006:	00004097          	auipc	ra,0x4
    200a:	c5c080e7          	jalr	-932(ra) # 5c62 <printf>
            exit(1);
    200e:	4505                	li	a0,1
    2010:	00004097          	auipc	ra,0x4
    2014:	8da080e7          	jalr	-1830(ra) # 58ea <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2018:	86aa                	mv	a3,a0
    201a:	660d                	lui	a2,0x3
    201c:	85d6                	mv	a1,s5
    201e:	00004517          	auipc	a0,0x4
    2022:	f0a50513          	addi	a0,a0,-246 # 5f28 <malloc+0x20e>
    2026:	00004097          	auipc	ra,0x4
    202a:	c3c080e7          	jalr	-964(ra) # 5c62 <printf>
            exit(1);
    202e:	4505                	li	a0,1
    2030:	00004097          	auipc	ra,0x4
    2034:	8ba080e7          	jalr	-1862(ra) # 58ea <exit>
      exit(st);
    2038:	00004097          	auipc	ra,0x4
    203c:	8b2080e7          	jalr	-1870(ra) # 58ea <exit>

0000000000002040 <forktest>:
{
    2040:	7179                	addi	sp,sp,-48
    2042:	f406                	sd	ra,40(sp)
    2044:	f022                	sd	s0,32(sp)
    2046:	ec26                	sd	s1,24(sp)
    2048:	e84a                	sd	s2,16(sp)
    204a:	e44e                	sd	s3,8(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2050:	4481                	li	s1,0
    2052:	3e800913          	li	s2,1000
    pid = fork();
    2056:	00004097          	auipc	ra,0x4
    205a:	88c080e7          	jalr	-1908(ra) # 58e2 <fork>
    if(pid < 0)
    205e:	08054263          	bltz	a0,20e2 <forktest+0xa2>
    if(pid == 0)
    2062:	c115                	beqz	a0,2086 <forktest+0x46>
  for(n=0; n<N; n++){
    2064:	2485                	addiw	s1,s1,1
    2066:	ff2498e3          	bne	s1,s2,2056 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    206a:	85ce                	mv	a1,s3
    206c:	00005517          	auipc	a0,0x5
    2070:	90450513          	addi	a0,a0,-1788 # 6970 <malloc+0xc56>
    2074:	00004097          	auipc	ra,0x4
    2078:	bee080e7          	jalr	-1042(ra) # 5c62 <printf>
    exit(1);
    207c:	4505                	li	a0,1
    207e:	00004097          	auipc	ra,0x4
    2082:	86c080e7          	jalr	-1940(ra) # 58ea <exit>
      exit(0);
    2086:	00004097          	auipc	ra,0x4
    208a:	864080e7          	jalr	-1948(ra) # 58ea <exit>
    printf("%s: no fork at all!\n", s);
    208e:	85ce                	mv	a1,s3
    2090:	00005517          	auipc	a0,0x5
    2094:	89850513          	addi	a0,a0,-1896 # 6928 <malloc+0xc0e>
    2098:	00004097          	auipc	ra,0x4
    209c:	bca080e7          	jalr	-1078(ra) # 5c62 <printf>
    exit(1);
    20a0:	4505                	li	a0,1
    20a2:	00004097          	auipc	ra,0x4
    20a6:	848080e7          	jalr	-1976(ra) # 58ea <exit>
      printf("%s: wait stopped early\n", s);
    20aa:	85ce                	mv	a1,s3
    20ac:	00005517          	auipc	a0,0x5
    20b0:	89450513          	addi	a0,a0,-1900 # 6940 <malloc+0xc26>
    20b4:	00004097          	auipc	ra,0x4
    20b8:	bae080e7          	jalr	-1106(ra) # 5c62 <printf>
      exit(1);
    20bc:	4505                	li	a0,1
    20be:	00004097          	auipc	ra,0x4
    20c2:	82c080e7          	jalr	-2004(ra) # 58ea <exit>
    printf("%s: wait got too many\n", s);
    20c6:	85ce                	mv	a1,s3
    20c8:	00005517          	auipc	a0,0x5
    20cc:	89050513          	addi	a0,a0,-1904 # 6958 <malloc+0xc3e>
    20d0:	00004097          	auipc	ra,0x4
    20d4:	b92080e7          	jalr	-1134(ra) # 5c62 <printf>
    exit(1);
    20d8:	4505                	li	a0,1
    20da:	00004097          	auipc	ra,0x4
    20de:	810080e7          	jalr	-2032(ra) # 58ea <exit>
  if (n == 0) {
    20e2:	d4d5                	beqz	s1,208e <forktest+0x4e>
  for(; n > 0; n--){
    20e4:	00905b63          	blez	s1,20fa <forktest+0xba>
    if(wait(0) < 0){
    20e8:	4501                	li	a0,0
    20ea:	00004097          	auipc	ra,0x4
    20ee:	808080e7          	jalr	-2040(ra) # 58f2 <wait>
    20f2:	fa054ce3          	bltz	a0,20aa <forktest+0x6a>
  for(; n > 0; n--){
    20f6:	34fd                	addiw	s1,s1,-1
    20f8:	f8e5                	bnez	s1,20e8 <forktest+0xa8>
  if(wait(0) != -1){
    20fa:	4501                	li	a0,0
    20fc:	00003097          	auipc	ra,0x3
    2100:	7f6080e7          	jalr	2038(ra) # 58f2 <wait>
    2104:	57fd                	li	a5,-1
    2106:	fcf510e3          	bne	a0,a5,20c6 <forktest+0x86>
}
    210a:	70a2                	ld	ra,40(sp)
    210c:	7402                	ld	s0,32(sp)
    210e:	64e2                	ld	s1,24(sp)
    2110:	6942                	ld	s2,16(sp)
    2112:	69a2                	ld	s3,8(sp)
    2114:	6145                	addi	sp,sp,48
    2116:	8082                	ret

0000000000002118 <kernmem>:
{
    2118:	715d                	addi	sp,sp,-80
    211a:	e486                	sd	ra,72(sp)
    211c:	e0a2                	sd	s0,64(sp)
    211e:	fc26                	sd	s1,56(sp)
    2120:	f84a                	sd	s2,48(sp)
    2122:	f44e                	sd	s3,40(sp)
    2124:	f052                	sd	s4,32(sp)
    2126:	ec56                	sd	s5,24(sp)
    2128:	0880                	addi	s0,sp,80
    212a:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    212c:	4485                	li	s1,1
    212e:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2130:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2132:	69b1                	lui	s3,0xc
    2134:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1948>
    2138:	1003d937          	lui	s2,0x1003d
    213c:	090e                	slli	s2,s2,0x3
    213e:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002d358>
    pid = fork();
    2142:	00003097          	auipc	ra,0x3
    2146:	7a0080e7          	jalr	1952(ra) # 58e2 <fork>
    if(pid < 0){
    214a:	02054963          	bltz	a0,217c <kernmem+0x64>
    if(pid == 0){
    214e:	c529                	beqz	a0,2198 <kernmem+0x80>
    wait(&xstatus);
    2150:	fbc40513          	addi	a0,s0,-68
    2154:	00003097          	auipc	ra,0x3
    2158:	79e080e7          	jalr	1950(ra) # 58f2 <wait>
    if(xstatus != -1)  // did kernel kill child?
    215c:	fbc42783          	lw	a5,-68(s0)
    2160:	05479d63          	bne	a5,s4,21ba <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2164:	94ce                	add	s1,s1,s3
    2166:	fd249ee3          	bne	s1,s2,2142 <kernmem+0x2a>
}
    216a:	60a6                	ld	ra,72(sp)
    216c:	6406                	ld	s0,64(sp)
    216e:	74e2                	ld	s1,56(sp)
    2170:	7942                	ld	s2,48(sp)
    2172:	79a2                	ld	s3,40(sp)
    2174:	7a02                	ld	s4,32(sp)
    2176:	6ae2                	ld	s5,24(sp)
    2178:	6161                	addi	sp,sp,80
    217a:	8082                	ret
      printf("%s: fork failed\n", s);
    217c:	85d6                	mv	a1,s5
    217e:	00004517          	auipc	a0,0x4
    2182:	53250513          	addi	a0,a0,1330 # 66b0 <malloc+0x996>
    2186:	00004097          	auipc	ra,0x4
    218a:	adc080e7          	jalr	-1316(ra) # 5c62 <printf>
      exit(1);
    218e:	4505                	li	a0,1
    2190:	00003097          	auipc	ra,0x3
    2194:	75a080e7          	jalr	1882(ra) # 58ea <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2198:	0004c683          	lbu	a3,0(s1)
    219c:	8626                	mv	a2,s1
    219e:	85d6                	mv	a1,s5
    21a0:	00004517          	auipc	a0,0x4
    21a4:	7f850513          	addi	a0,a0,2040 # 6998 <malloc+0xc7e>
    21a8:	00004097          	auipc	ra,0x4
    21ac:	aba080e7          	jalr	-1350(ra) # 5c62 <printf>
      exit(1);
    21b0:	4505                	li	a0,1
    21b2:	00003097          	auipc	ra,0x3
    21b6:	738080e7          	jalr	1848(ra) # 58ea <exit>
      exit(1);
    21ba:	4505                	li	a0,1
    21bc:	00003097          	auipc	ra,0x3
    21c0:	72e080e7          	jalr	1838(ra) # 58ea <exit>

00000000000021c4 <MAXVAplus>:
{
    21c4:	7179                	addi	sp,sp,-48
    21c6:	f406                	sd	ra,40(sp)
    21c8:	f022                	sd	s0,32(sp)
    21ca:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    21cc:	4785                	li	a5,1
    21ce:	179a                	slli	a5,a5,0x26
    21d0:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    21d4:	fd843783          	ld	a5,-40(s0)
    21d8:	c3a1                	beqz	a5,2218 <MAXVAplus+0x54>
    21da:	ec26                	sd	s1,24(sp)
    21dc:	e84a                	sd	s2,16(sp)
    21de:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21e0:	54fd                	li	s1,-1
    pid = fork();
    21e2:	00003097          	auipc	ra,0x3
    21e6:	700080e7          	jalr	1792(ra) # 58e2 <fork>
    if(pid < 0){
    21ea:	02054b63          	bltz	a0,2220 <MAXVAplus+0x5c>
    if(pid == 0){
    21ee:	c539                	beqz	a0,223c <MAXVAplus+0x78>
    wait(&xstatus);
    21f0:	fd440513          	addi	a0,s0,-44
    21f4:	00003097          	auipc	ra,0x3
    21f8:	6fe080e7          	jalr	1790(ra) # 58f2 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21fc:	fd442783          	lw	a5,-44(s0)
    2200:	06979463          	bne	a5,s1,2268 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2204:	fd843783          	ld	a5,-40(s0)
    2208:	0786                	slli	a5,a5,0x1
    220a:	fcf43c23          	sd	a5,-40(s0)
    220e:	fd843783          	ld	a5,-40(s0)
    2212:	fbe1                	bnez	a5,21e2 <MAXVAplus+0x1e>
    2214:	64e2                	ld	s1,24(sp)
    2216:	6942                	ld	s2,16(sp)
}
    2218:	70a2                	ld	ra,40(sp)
    221a:	7402                	ld	s0,32(sp)
    221c:	6145                	addi	sp,sp,48
    221e:	8082                	ret
      printf("%s: fork failed\n", s);
    2220:	85ca                	mv	a1,s2
    2222:	00004517          	auipc	a0,0x4
    2226:	48e50513          	addi	a0,a0,1166 # 66b0 <malloc+0x996>
    222a:	00004097          	auipc	ra,0x4
    222e:	a38080e7          	jalr	-1480(ra) # 5c62 <printf>
      exit(1);
    2232:	4505                	li	a0,1
    2234:	00003097          	auipc	ra,0x3
    2238:	6b6080e7          	jalr	1718(ra) # 58ea <exit>
      *(char*)a = 99;
    223c:	fd843783          	ld	a5,-40(s0)
    2240:	06300713          	li	a4,99
    2244:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x2e>
      printf("%s: oops wrote %x\n", s, a);
    2248:	fd843603          	ld	a2,-40(s0)
    224c:	85ca                	mv	a1,s2
    224e:	00004517          	auipc	a0,0x4
    2252:	76a50513          	addi	a0,a0,1898 # 69b8 <malloc+0xc9e>
    2256:	00004097          	auipc	ra,0x4
    225a:	a0c080e7          	jalr	-1524(ra) # 5c62 <printf>
      exit(1);
    225e:	4505                	li	a0,1
    2260:	00003097          	auipc	ra,0x3
    2264:	68a080e7          	jalr	1674(ra) # 58ea <exit>
      exit(1);
    2268:	4505                	li	a0,1
    226a:	00003097          	auipc	ra,0x3
    226e:	680080e7          	jalr	1664(ra) # 58ea <exit>

0000000000002272 <bigargtest>:
{
    2272:	7179                	addi	sp,sp,-48
    2274:	f406                	sd	ra,40(sp)
    2276:	f022                	sd	s0,32(sp)
    2278:	ec26                	sd	s1,24(sp)
    227a:	1800                	addi	s0,sp,48
    227c:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    227e:	00004517          	auipc	a0,0x4
    2282:	75250513          	addi	a0,a0,1874 # 69d0 <malloc+0xcb6>
    2286:	00003097          	auipc	ra,0x3
    228a:	6b4080e7          	jalr	1716(ra) # 593a <unlink>
  pid = fork();
    228e:	00003097          	auipc	ra,0x3
    2292:	654080e7          	jalr	1620(ra) # 58e2 <fork>
  if(pid == 0){
    2296:	c121                	beqz	a0,22d6 <bigargtest+0x64>
  } else if(pid < 0){
    2298:	0a054063          	bltz	a0,2338 <bigargtest+0xc6>
  wait(&xstatus);
    229c:	fdc40513          	addi	a0,s0,-36
    22a0:	00003097          	auipc	ra,0x3
    22a4:	652080e7          	jalr	1618(ra) # 58f2 <wait>
  if(xstatus != 0)
    22a8:	fdc42503          	lw	a0,-36(s0)
    22ac:	e545                	bnez	a0,2354 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    22ae:	4581                	li	a1,0
    22b0:	00004517          	auipc	a0,0x4
    22b4:	72050513          	addi	a0,a0,1824 # 69d0 <malloc+0xcb6>
    22b8:	00003097          	auipc	ra,0x3
    22bc:	672080e7          	jalr	1650(ra) # 592a <open>
  if(fd < 0){
    22c0:	08054e63          	bltz	a0,235c <bigargtest+0xea>
  close(fd);
    22c4:	00003097          	auipc	ra,0x3
    22c8:	64e080e7          	jalr	1614(ra) # 5912 <close>
}
    22cc:	70a2                	ld	ra,40(sp)
    22ce:	7402                	ld	s0,32(sp)
    22d0:	64e2                	ld	s1,24(sp)
    22d2:	6145                	addi	sp,sp,48
    22d4:	8082                	ret
    22d6:	00007797          	auipc	a5,0x7
    22da:	62a78793          	addi	a5,a5,1578 # 9900 <args.1>
    22de:	00007697          	auipc	a3,0x7
    22e2:	71a68693          	addi	a3,a3,1818 # 99f8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22e6:	00004717          	auipc	a4,0x4
    22ea:	6fa70713          	addi	a4,a4,1786 # 69e0 <malloc+0xcc6>
    22ee:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22f0:	07a1                	addi	a5,a5,8
    22f2:	fed79ee3          	bne	a5,a3,22ee <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22f6:	00007597          	auipc	a1,0x7
    22fa:	60a58593          	addi	a1,a1,1546 # 9900 <args.1>
    22fe:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2302:	00004517          	auipc	a0,0x4
    2306:	b5650513          	addi	a0,a0,-1194 # 5e58 <malloc+0x13e>
    230a:	00003097          	auipc	ra,0x3
    230e:	618080e7          	jalr	1560(ra) # 5922 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2312:	20000593          	li	a1,512
    2316:	00004517          	auipc	a0,0x4
    231a:	6ba50513          	addi	a0,a0,1722 # 69d0 <malloc+0xcb6>
    231e:	00003097          	auipc	ra,0x3
    2322:	60c080e7          	jalr	1548(ra) # 592a <open>
    close(fd);
    2326:	00003097          	auipc	ra,0x3
    232a:	5ec080e7          	jalr	1516(ra) # 5912 <close>
    exit(0);
    232e:	4501                	li	a0,0
    2330:	00003097          	auipc	ra,0x3
    2334:	5ba080e7          	jalr	1466(ra) # 58ea <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2338:	85a6                	mv	a1,s1
    233a:	00004517          	auipc	a0,0x4
    233e:	78650513          	addi	a0,a0,1926 # 6ac0 <malloc+0xda6>
    2342:	00004097          	auipc	ra,0x4
    2346:	920080e7          	jalr	-1760(ra) # 5c62 <printf>
    exit(1);
    234a:	4505                	li	a0,1
    234c:	00003097          	auipc	ra,0x3
    2350:	59e080e7          	jalr	1438(ra) # 58ea <exit>
    exit(xstatus);
    2354:	00003097          	auipc	ra,0x3
    2358:	596080e7          	jalr	1430(ra) # 58ea <exit>
    printf("%s: bigarg test failed!\n", s);
    235c:	85a6                	mv	a1,s1
    235e:	00004517          	auipc	a0,0x4
    2362:	78250513          	addi	a0,a0,1922 # 6ae0 <malloc+0xdc6>
    2366:	00004097          	auipc	ra,0x4
    236a:	8fc080e7          	jalr	-1796(ra) # 5c62 <printf>
    exit(1);
    236e:	4505                	li	a0,1
    2370:	00003097          	auipc	ra,0x3
    2374:	57a080e7          	jalr	1402(ra) # 58ea <exit>

0000000000002378 <stacktest>:
{
    2378:	7179                	addi	sp,sp,-48
    237a:	f406                	sd	ra,40(sp)
    237c:	f022                	sd	s0,32(sp)
    237e:	ec26                	sd	s1,24(sp)
    2380:	1800                	addi	s0,sp,48
    2382:	84aa                	mv	s1,a0
  pid = fork();
    2384:	00003097          	auipc	ra,0x3
    2388:	55e080e7          	jalr	1374(ra) # 58e2 <fork>
  if(pid == 0) {
    238c:	c115                	beqz	a0,23b0 <stacktest+0x38>
  } else if(pid < 0){
    238e:	04054463          	bltz	a0,23d6 <stacktest+0x5e>
  wait(&xstatus);
    2392:	fdc40513          	addi	a0,s0,-36
    2396:	00003097          	auipc	ra,0x3
    239a:	55c080e7          	jalr	1372(ra) # 58f2 <wait>
  if(xstatus == -1)  // kernel killed child?
    239e:	fdc42503          	lw	a0,-36(s0)
    23a2:	57fd                	li	a5,-1
    23a4:	04f50763          	beq	a0,a5,23f2 <stacktest+0x7a>
    exit(xstatus);
    23a8:	00003097          	auipc	ra,0x3
    23ac:	542080e7          	jalr	1346(ra) # 58ea <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    23b0:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    23b2:	77fd                	lui	a5,0xfffff
    23b4:	97ba                	add	a5,a5,a4
    23b6:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xfffffffffffeeed8>
    23ba:	85a6                	mv	a1,s1
    23bc:	00004517          	auipc	a0,0x4
    23c0:	74450513          	addi	a0,a0,1860 # 6b00 <malloc+0xde6>
    23c4:	00004097          	auipc	ra,0x4
    23c8:	89e080e7          	jalr	-1890(ra) # 5c62 <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	51c080e7          	jalr	1308(ra) # 58ea <exit>
    printf("%s: fork failed\n", s);
    23d6:	85a6                	mv	a1,s1
    23d8:	00004517          	auipc	a0,0x4
    23dc:	2d850513          	addi	a0,a0,728 # 66b0 <malloc+0x996>
    23e0:	00004097          	auipc	ra,0x4
    23e4:	882080e7          	jalr	-1918(ra) # 5c62 <printf>
    exit(1);
    23e8:	4505                	li	a0,1
    23ea:	00003097          	auipc	ra,0x3
    23ee:	500080e7          	jalr	1280(ra) # 58ea <exit>
    exit(0);
    23f2:	4501                	li	a0,0
    23f4:	00003097          	auipc	ra,0x3
    23f8:	4f6080e7          	jalr	1270(ra) # 58ea <exit>

00000000000023fc <copyinstr3>:
{
    23fc:	7179                	addi	sp,sp,-48
    23fe:	f406                	sd	ra,40(sp)
    2400:	f022                	sd	s0,32(sp)
    2402:	ec26                	sd	s1,24(sp)
    2404:	1800                	addi	s0,sp,48
  sbrk(8192);
    2406:	6509                	lui	a0,0x2
    2408:	00003097          	auipc	ra,0x3
    240c:	56a080e7          	jalr	1386(ra) # 5972 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2410:	4501                	li	a0,0
    2412:	00003097          	auipc	ra,0x3
    2416:	560080e7          	jalr	1376(ra) # 5972 <sbrk>
  if((top % PGSIZE) != 0){
    241a:	03451793          	slli	a5,a0,0x34
    241e:	e3c9                	bnez	a5,24a0 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2420:	4501                	li	a0,0
    2422:	00003097          	auipc	ra,0x3
    2426:	550080e7          	jalr	1360(ra) # 5972 <sbrk>
  if(top % PGSIZE){
    242a:	03451793          	slli	a5,a0,0x34
    242e:	e3d9                	bnez	a5,24b4 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2430:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x117>
  *b = 'x';
    2434:	07800793          	li	a5,120
    2438:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    243c:	8526                	mv	a0,s1
    243e:	00003097          	auipc	ra,0x3
    2442:	4fc080e7          	jalr	1276(ra) # 593a <unlink>
  if(ret != -1){
    2446:	57fd                	li	a5,-1
    2448:	08f51363          	bne	a0,a5,24ce <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    244c:	20100593          	li	a1,513
    2450:	8526                	mv	a0,s1
    2452:	00003097          	auipc	ra,0x3
    2456:	4d8080e7          	jalr	1240(ra) # 592a <open>
  if(fd != -1){
    245a:	57fd                	li	a5,-1
    245c:	08f51863          	bne	a0,a5,24ec <copyinstr3+0xf0>
  ret = link(b, b);
    2460:	85a6                	mv	a1,s1
    2462:	8526                	mv	a0,s1
    2464:	00003097          	auipc	ra,0x3
    2468:	4e6080e7          	jalr	1254(ra) # 594a <link>
  if(ret != -1){
    246c:	57fd                	li	a5,-1
    246e:	08f51e63          	bne	a0,a5,250a <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2472:	00005797          	auipc	a5,0x5
    2476:	33678793          	addi	a5,a5,822 # 77a8 <malloc+0x1a8e>
    247a:	fcf43823          	sd	a5,-48(s0)
    247e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2482:	fd040593          	addi	a1,s0,-48
    2486:	8526                	mv	a0,s1
    2488:	00003097          	auipc	ra,0x3
    248c:	49a080e7          	jalr	1178(ra) # 5922 <exec>
  if(ret != -1){
    2490:	57fd                	li	a5,-1
    2492:	08f51c63          	bne	a0,a5,252a <copyinstr3+0x12e>
}
    2496:	70a2                	ld	ra,40(sp)
    2498:	7402                	ld	s0,32(sp)
    249a:	64e2                	ld	s1,24(sp)
    249c:	6145                	addi	sp,sp,48
    249e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    24a0:	0347d513          	srli	a0,a5,0x34
    24a4:	6785                	lui	a5,0x1
    24a6:	40a7853b          	subw	a0,a5,a0
    24aa:	00003097          	auipc	ra,0x3
    24ae:	4c8080e7          	jalr	1224(ra) # 5972 <sbrk>
    24b2:	b7bd                	j	2420 <copyinstr3+0x24>
    printf("oops\n");
    24b4:	00004517          	auipc	a0,0x4
    24b8:	67450513          	addi	a0,a0,1652 # 6b28 <malloc+0xe0e>
    24bc:	00003097          	auipc	ra,0x3
    24c0:	7a6080e7          	jalr	1958(ra) # 5c62 <printf>
    exit(1);
    24c4:	4505                	li	a0,1
    24c6:	00003097          	auipc	ra,0x3
    24ca:	424080e7          	jalr	1060(ra) # 58ea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    24ce:	862a                	mv	a2,a0
    24d0:	85a6                	mv	a1,s1
    24d2:	00004517          	auipc	a0,0x4
    24d6:	0fe50513          	addi	a0,a0,254 # 65d0 <malloc+0x8b6>
    24da:	00003097          	auipc	ra,0x3
    24de:	788080e7          	jalr	1928(ra) # 5c62 <printf>
    exit(1);
    24e2:	4505                	li	a0,1
    24e4:	00003097          	auipc	ra,0x3
    24e8:	406080e7          	jalr	1030(ra) # 58ea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24ec:	862a                	mv	a2,a0
    24ee:	85a6                	mv	a1,s1
    24f0:	00004517          	auipc	a0,0x4
    24f4:	10050513          	addi	a0,a0,256 # 65f0 <malloc+0x8d6>
    24f8:	00003097          	auipc	ra,0x3
    24fc:	76a080e7          	jalr	1898(ra) # 5c62 <printf>
    exit(1);
    2500:	4505                	li	a0,1
    2502:	00003097          	auipc	ra,0x3
    2506:	3e8080e7          	jalr	1000(ra) # 58ea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    250a:	86aa                	mv	a3,a0
    250c:	8626                	mv	a2,s1
    250e:	85a6                	mv	a1,s1
    2510:	00004517          	auipc	a0,0x4
    2514:	10050513          	addi	a0,a0,256 # 6610 <malloc+0x8f6>
    2518:	00003097          	auipc	ra,0x3
    251c:	74a080e7          	jalr	1866(ra) # 5c62 <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	3c8080e7          	jalr	968(ra) # 58ea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    252a:	567d                	li	a2,-1
    252c:	85a6                	mv	a1,s1
    252e:	00004517          	auipc	a0,0x4
    2532:	10a50513          	addi	a0,a0,266 # 6638 <malloc+0x91e>
    2536:	00003097          	auipc	ra,0x3
    253a:	72c080e7          	jalr	1836(ra) # 5c62 <printf>
    exit(1);
    253e:	4505                	li	a0,1
    2540:	00003097          	auipc	ra,0x3
    2544:	3aa080e7          	jalr	938(ra) # 58ea <exit>

0000000000002548 <rwsbrk>:
{
    2548:	1101                	addi	sp,sp,-32
    254a:	ec06                	sd	ra,24(sp)
    254c:	e822                	sd	s0,16(sp)
    254e:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2550:	6509                	lui	a0,0x2
    2552:	00003097          	auipc	ra,0x3
    2556:	420080e7          	jalr	1056(ra) # 5972 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    255a:	57fd                	li	a5,-1
    255c:	06f50463          	beq	a0,a5,25c4 <rwsbrk+0x7c>
    2560:	e426                	sd	s1,8(sp)
    2562:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2564:	7579                	lui	a0,0xffffe
    2566:	00003097          	auipc	ra,0x3
    256a:	40c080e7          	jalr	1036(ra) # 5972 <sbrk>
    256e:	57fd                	li	a5,-1
    2570:	06f50963          	beq	a0,a5,25e2 <rwsbrk+0x9a>
    2574:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2576:	20100593          	li	a1,513
    257a:	00004517          	auipc	a0,0x4
    257e:	5ee50513          	addi	a0,a0,1518 # 6b68 <malloc+0xe4e>
    2582:	00003097          	auipc	ra,0x3
    2586:	3a8080e7          	jalr	936(ra) # 592a <open>
    258a:	892a                	mv	s2,a0
  if(fd < 0){
    258c:	06054963          	bltz	a0,25fe <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    2590:	6785                	lui	a5,0x1
    2592:	94be                	add	s1,s1,a5
    2594:	40000613          	li	a2,1024
    2598:	85a6                	mv	a1,s1
    259a:	00003097          	auipc	ra,0x3
    259e:	370080e7          	jalr	880(ra) # 590a <write>
    25a2:	862a                	mv	a2,a0
  if(n >= 0){
    25a4:	06054a63          	bltz	a0,2618 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    25a8:	85a6                	mv	a1,s1
    25aa:	00004517          	auipc	a0,0x4
    25ae:	5de50513          	addi	a0,a0,1502 # 6b88 <malloc+0xe6e>
    25b2:	00003097          	auipc	ra,0x3
    25b6:	6b0080e7          	jalr	1712(ra) # 5c62 <printf>
    exit(1);
    25ba:	4505                	li	a0,1
    25bc:	00003097          	auipc	ra,0x3
    25c0:	32e080e7          	jalr	814(ra) # 58ea <exit>
    25c4:	e426                	sd	s1,8(sp)
    25c6:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    25c8:	00004517          	auipc	a0,0x4
    25cc:	56850513          	addi	a0,a0,1384 # 6b30 <malloc+0xe16>
    25d0:	00003097          	auipc	ra,0x3
    25d4:	692080e7          	jalr	1682(ra) # 5c62 <printf>
    exit(1);
    25d8:	4505                	li	a0,1
    25da:	00003097          	auipc	ra,0x3
    25de:	310080e7          	jalr	784(ra) # 58ea <exit>
    25e2:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    25e4:	00004517          	auipc	a0,0x4
    25e8:	56450513          	addi	a0,a0,1380 # 6b48 <malloc+0xe2e>
    25ec:	00003097          	auipc	ra,0x3
    25f0:	676080e7          	jalr	1654(ra) # 5c62 <printf>
    exit(1);
    25f4:	4505                	li	a0,1
    25f6:	00003097          	auipc	ra,0x3
    25fa:	2f4080e7          	jalr	756(ra) # 58ea <exit>
    printf("open(rwsbrk) failed\n");
    25fe:	00004517          	auipc	a0,0x4
    2602:	57250513          	addi	a0,a0,1394 # 6b70 <malloc+0xe56>
    2606:	00003097          	auipc	ra,0x3
    260a:	65c080e7          	jalr	1628(ra) # 5c62 <printf>
    exit(1);
    260e:	4505                	li	a0,1
    2610:	00003097          	auipc	ra,0x3
    2614:	2da080e7          	jalr	730(ra) # 58ea <exit>
  close(fd);
    2618:	854a                	mv	a0,s2
    261a:	00003097          	auipc	ra,0x3
    261e:	2f8080e7          	jalr	760(ra) # 5912 <close>
  unlink("rwsbrk");
    2622:	00004517          	auipc	a0,0x4
    2626:	54650513          	addi	a0,a0,1350 # 6b68 <malloc+0xe4e>
    262a:	00003097          	auipc	ra,0x3
    262e:	310080e7          	jalr	784(ra) # 593a <unlink>
  fd = open("README", O_RDONLY);
    2632:	4581                	li	a1,0
    2634:	00004517          	auipc	a0,0x4
    2638:	9cc50513          	addi	a0,a0,-1588 # 6000 <malloc+0x2e6>
    263c:	00003097          	auipc	ra,0x3
    2640:	2ee080e7          	jalr	750(ra) # 592a <open>
    2644:	892a                	mv	s2,a0
  if(fd < 0){
    2646:	02054963          	bltz	a0,2678 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    264a:	4629                	li	a2,10
    264c:	85a6                	mv	a1,s1
    264e:	00003097          	auipc	ra,0x3
    2652:	2b4080e7          	jalr	692(ra) # 5902 <read>
    2656:	862a                	mv	a2,a0
  if(n >= 0){
    2658:	02054d63          	bltz	a0,2692 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    265c:	85a6                	mv	a1,s1
    265e:	00004517          	auipc	a0,0x4
    2662:	55a50513          	addi	a0,a0,1370 # 6bb8 <malloc+0xe9e>
    2666:	00003097          	auipc	ra,0x3
    266a:	5fc080e7          	jalr	1532(ra) # 5c62 <printf>
    exit(1);
    266e:	4505                	li	a0,1
    2670:	00003097          	auipc	ra,0x3
    2674:	27a080e7          	jalr	634(ra) # 58ea <exit>
    printf("open(rwsbrk) failed\n");
    2678:	00004517          	auipc	a0,0x4
    267c:	4f850513          	addi	a0,a0,1272 # 6b70 <malloc+0xe56>
    2680:	00003097          	auipc	ra,0x3
    2684:	5e2080e7          	jalr	1506(ra) # 5c62 <printf>
    exit(1);
    2688:	4505                	li	a0,1
    268a:	00003097          	auipc	ra,0x3
    268e:	260080e7          	jalr	608(ra) # 58ea <exit>
  close(fd);
    2692:	854a                	mv	a0,s2
    2694:	00003097          	auipc	ra,0x3
    2698:	27e080e7          	jalr	638(ra) # 5912 <close>
  exit(0);
    269c:	4501                	li	a0,0
    269e:	00003097          	auipc	ra,0x3
    26a2:	24c080e7          	jalr	588(ra) # 58ea <exit>

00000000000026a6 <sbrkbasic>:
{
    26a6:	7139                	addi	sp,sp,-64
    26a8:	fc06                	sd	ra,56(sp)
    26aa:	f822                	sd	s0,48(sp)
    26ac:	ec4e                	sd	s3,24(sp)
    26ae:	0080                	addi	s0,sp,64
    26b0:	89aa                	mv	s3,a0
  pid = fork();
    26b2:	00003097          	auipc	ra,0x3
    26b6:	230080e7          	jalr	560(ra) # 58e2 <fork>
  if(pid < 0){
    26ba:	02054f63          	bltz	a0,26f8 <sbrkbasic+0x52>
  if(pid == 0){
    26be:	e52d                	bnez	a0,2728 <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    26c0:	40000537          	lui	a0,0x40000
    26c4:	00003097          	auipc	ra,0x3
    26c8:	2ae080e7          	jalr	686(ra) # 5972 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    26cc:	57fd                	li	a5,-1
    26ce:	04f50563          	beq	a0,a5,2718 <sbrkbasic+0x72>
    26d2:	f426                	sd	s1,40(sp)
    26d4:	f04a                	sd	s2,32(sp)
    26d6:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    26d8:	400007b7          	lui	a5,0x40000
    26dc:	97aa                	add	a5,a5,a0
      *b = 99;
    26de:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    26e2:	6705                	lui	a4,0x1
      *b = 99;
    26e4:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3ffefed8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26e8:	953a                	add	a0,a0,a4
    26ea:	fef51de3          	bne	a0,a5,26e4 <sbrkbasic+0x3e>
    exit(1);
    26ee:	4505                	li	a0,1
    26f0:	00003097          	auipc	ra,0x3
    26f4:	1fa080e7          	jalr	506(ra) # 58ea <exit>
    26f8:	f426                	sd	s1,40(sp)
    26fa:	f04a                	sd	s2,32(sp)
    26fc:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    26fe:	00004517          	auipc	a0,0x4
    2702:	4e250513          	addi	a0,a0,1250 # 6be0 <malloc+0xec6>
    2706:	00003097          	auipc	ra,0x3
    270a:	55c080e7          	jalr	1372(ra) # 5c62 <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	1da080e7          	jalr	474(ra) # 58ea <exit>
    2718:	f426                	sd	s1,40(sp)
    271a:	f04a                	sd	s2,32(sp)
    271c:	e852                	sd	s4,16(sp)
      exit(0);
    271e:	4501                	li	a0,0
    2720:	00003097          	auipc	ra,0x3
    2724:	1ca080e7          	jalr	458(ra) # 58ea <exit>
  wait(&xstatus);
    2728:	fcc40513          	addi	a0,s0,-52
    272c:	00003097          	auipc	ra,0x3
    2730:	1c6080e7          	jalr	454(ra) # 58f2 <wait>
  if(xstatus == 1){
    2734:	fcc42703          	lw	a4,-52(s0)
    2738:	4785                	li	a5,1
    273a:	02f70063          	beq	a4,a5,275a <sbrkbasic+0xb4>
    273e:	f426                	sd	s1,40(sp)
    2740:	f04a                	sd	s2,32(sp)
    2742:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2744:	4501                	li	a0,0
    2746:	00003097          	auipc	ra,0x3
    274a:	22c080e7          	jalr	556(ra) # 5972 <sbrk>
    274e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2750:	4901                	li	s2,0
    2752:	6a05                	lui	s4,0x1
    2754:	388a0a13          	addi	s4,s4,904 # 1388 <copyinstr2+0x1ce>
    2758:	a01d                	j	277e <sbrkbasic+0xd8>
    275a:	f426                	sd	s1,40(sp)
    275c:	f04a                	sd	s2,32(sp)
    275e:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2760:	85ce                	mv	a1,s3
    2762:	00004517          	auipc	a0,0x4
    2766:	49e50513          	addi	a0,a0,1182 # 6c00 <malloc+0xee6>
    276a:	00003097          	auipc	ra,0x3
    276e:	4f8080e7          	jalr	1272(ra) # 5c62 <printf>
    exit(1);
    2772:	4505                	li	a0,1
    2774:	00003097          	auipc	ra,0x3
    2778:	176080e7          	jalr	374(ra) # 58ea <exit>
    277c:	84be                	mv	s1,a5
    b = sbrk(1);
    277e:	4505                	li	a0,1
    2780:	00003097          	auipc	ra,0x3
    2784:	1f2080e7          	jalr	498(ra) # 5972 <sbrk>
    if(b != a){
    2788:	04951c63          	bne	a0,s1,27e0 <sbrkbasic+0x13a>
    *b = 1;
    278c:	4785                	li	a5,1
    278e:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2792:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2796:	2905                	addiw	s2,s2,1
    2798:	ff4912e3          	bne	s2,s4,277c <sbrkbasic+0xd6>
  pid = fork();
    279c:	00003097          	auipc	ra,0x3
    27a0:	146080e7          	jalr	326(ra) # 58e2 <fork>
    27a4:	892a                	mv	s2,a0
  if(pid < 0){
    27a6:	04054e63          	bltz	a0,2802 <sbrkbasic+0x15c>
  c = sbrk(1);
    27aa:	4505                	li	a0,1
    27ac:	00003097          	auipc	ra,0x3
    27b0:	1c6080e7          	jalr	454(ra) # 5972 <sbrk>
  c = sbrk(1);
    27b4:	4505                	li	a0,1
    27b6:	00003097          	auipc	ra,0x3
    27ba:	1bc080e7          	jalr	444(ra) # 5972 <sbrk>
  if(c != a + 1){
    27be:	0489                	addi	s1,s1,2
    27c0:	04a48f63          	beq	s1,a0,281e <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    27c4:	85ce                	mv	a1,s3
    27c6:	00004517          	auipc	a0,0x4
    27ca:	49a50513          	addi	a0,a0,1178 # 6c60 <malloc+0xf46>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	494080e7          	jalr	1172(ra) # 5c62 <printf>
    exit(1);
    27d6:	4505                	li	a0,1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	112080e7          	jalr	274(ra) # 58ea <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    27e0:	872a                	mv	a4,a0
    27e2:	86a6                	mv	a3,s1
    27e4:	864a                	mv	a2,s2
    27e6:	85ce                	mv	a1,s3
    27e8:	00004517          	auipc	a0,0x4
    27ec:	43850513          	addi	a0,a0,1080 # 6c20 <malloc+0xf06>
    27f0:	00003097          	auipc	ra,0x3
    27f4:	472080e7          	jalr	1138(ra) # 5c62 <printf>
      exit(1);
    27f8:	4505                	li	a0,1
    27fa:	00003097          	auipc	ra,0x3
    27fe:	0f0080e7          	jalr	240(ra) # 58ea <exit>
    printf("%s: sbrk test fork failed\n", s);
    2802:	85ce                	mv	a1,s3
    2804:	00004517          	auipc	a0,0x4
    2808:	43c50513          	addi	a0,a0,1084 # 6c40 <malloc+0xf26>
    280c:	00003097          	auipc	ra,0x3
    2810:	456080e7          	jalr	1110(ra) # 5c62 <printf>
    exit(1);
    2814:	4505                	li	a0,1
    2816:	00003097          	auipc	ra,0x3
    281a:	0d4080e7          	jalr	212(ra) # 58ea <exit>
  if(pid == 0)
    281e:	00091763          	bnez	s2,282c <sbrkbasic+0x186>
    exit(0);
    2822:	4501                	li	a0,0
    2824:	00003097          	auipc	ra,0x3
    2828:	0c6080e7          	jalr	198(ra) # 58ea <exit>
  wait(&xstatus);
    282c:	fcc40513          	addi	a0,s0,-52
    2830:	00003097          	auipc	ra,0x3
    2834:	0c2080e7          	jalr	194(ra) # 58f2 <wait>
  exit(xstatus);
    2838:	fcc42503          	lw	a0,-52(s0)
    283c:	00003097          	auipc	ra,0x3
    2840:	0ae080e7          	jalr	174(ra) # 58ea <exit>

0000000000002844 <sbrkmuch>:
{
    2844:	7179                	addi	sp,sp,-48
    2846:	f406                	sd	ra,40(sp)
    2848:	f022                	sd	s0,32(sp)
    284a:	ec26                	sd	s1,24(sp)
    284c:	e84a                	sd	s2,16(sp)
    284e:	e44e                	sd	s3,8(sp)
    2850:	e052                	sd	s4,0(sp)
    2852:	1800                	addi	s0,sp,48
    2854:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2856:	4501                	li	a0,0
    2858:	00003097          	auipc	ra,0x3
    285c:	11a080e7          	jalr	282(ra) # 5972 <sbrk>
    2860:	892a                	mv	s2,a0
  a = sbrk(0);
    2862:	4501                	li	a0,0
    2864:	00003097          	auipc	ra,0x3
    2868:	10e080e7          	jalr	270(ra) # 5972 <sbrk>
    286c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    286e:	06400537          	lui	a0,0x6400
    2872:	9d05                	subw	a0,a0,s1
    2874:	00003097          	auipc	ra,0x3
    2878:	0fe080e7          	jalr	254(ra) # 5972 <sbrk>
  if (p != a) {
    287c:	0ca49863          	bne	s1,a0,294c <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2880:	4501                	li	a0,0
    2882:	00003097          	auipc	ra,0x3
    2886:	0f0080e7          	jalr	240(ra) # 5972 <sbrk>
    288a:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    288c:	00a4f963          	bgeu	s1,a0,289e <sbrkmuch+0x5a>
    *pp = 1;
    2890:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2892:	6705                	lui	a4,0x1
    *pp = 1;
    2894:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2898:	94ba                	add	s1,s1,a4
    289a:	fef4ede3          	bltu	s1,a5,2894 <sbrkmuch+0x50>
  *lastaddr = 99;
    289e:	064007b7          	lui	a5,0x6400
    28a2:	06300713          	li	a4,99
    28a6:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63efed7>
  a = sbrk(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	0c6080e7          	jalr	198(ra) # 5972 <sbrk>
    28b4:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    28b6:	757d                	lui	a0,0xfffff
    28b8:	00003097          	auipc	ra,0x3
    28bc:	0ba080e7          	jalr	186(ra) # 5972 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    28c0:	57fd                	li	a5,-1
    28c2:	0af50363          	beq	a0,a5,2968 <sbrkmuch+0x124>
  c = sbrk(0);
    28c6:	4501                	li	a0,0
    28c8:	00003097          	auipc	ra,0x3
    28cc:	0aa080e7          	jalr	170(ra) # 5972 <sbrk>
  if(c != a - PGSIZE){
    28d0:	77fd                	lui	a5,0xfffff
    28d2:	97a6                	add	a5,a5,s1
    28d4:	0af51863          	bne	a0,a5,2984 <sbrkmuch+0x140>
  a = sbrk(0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	098080e7          	jalr	152(ra) # 5972 <sbrk>
    28e2:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    28e4:	6505                	lui	a0,0x1
    28e6:	00003097          	auipc	ra,0x3
    28ea:	08c080e7          	jalr	140(ra) # 5972 <sbrk>
    28ee:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    28f0:	0aa49a63          	bne	s1,a0,29a4 <sbrkmuch+0x160>
    28f4:	4501                	li	a0,0
    28f6:	00003097          	auipc	ra,0x3
    28fa:	07c080e7          	jalr	124(ra) # 5972 <sbrk>
    28fe:	6785                	lui	a5,0x1
    2900:	97a6                	add	a5,a5,s1
    2902:	0af51163          	bne	a0,a5,29a4 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2906:	064007b7          	lui	a5,0x6400
    290a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63efed7>
    290e:	06300793          	li	a5,99
    2912:	0af70963          	beq	a4,a5,29c4 <sbrkmuch+0x180>
  a = sbrk(0);
    2916:	4501                	li	a0,0
    2918:	00003097          	auipc	ra,0x3
    291c:	05a080e7          	jalr	90(ra) # 5972 <sbrk>
    2920:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2922:	4501                	li	a0,0
    2924:	00003097          	auipc	ra,0x3
    2928:	04e080e7          	jalr	78(ra) # 5972 <sbrk>
    292c:	40a9053b          	subw	a0,s2,a0
    2930:	00003097          	auipc	ra,0x3
    2934:	042080e7          	jalr	66(ra) # 5972 <sbrk>
  if(c != a){
    2938:	0aa49463          	bne	s1,a0,29e0 <sbrkmuch+0x19c>
}
    293c:	70a2                	ld	ra,40(sp)
    293e:	7402                	ld	s0,32(sp)
    2940:	64e2                	ld	s1,24(sp)
    2942:	6942                	ld	s2,16(sp)
    2944:	69a2                	ld	s3,8(sp)
    2946:	6a02                	ld	s4,0(sp)
    2948:	6145                	addi	sp,sp,48
    294a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    294c:	85ce                	mv	a1,s3
    294e:	00004517          	auipc	a0,0x4
    2952:	33250513          	addi	a0,a0,818 # 6c80 <malloc+0xf66>
    2956:	00003097          	auipc	ra,0x3
    295a:	30c080e7          	jalr	780(ra) # 5c62 <printf>
    exit(1);
    295e:	4505                	li	a0,1
    2960:	00003097          	auipc	ra,0x3
    2964:	f8a080e7          	jalr	-118(ra) # 58ea <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2968:	85ce                	mv	a1,s3
    296a:	00004517          	auipc	a0,0x4
    296e:	35e50513          	addi	a0,a0,862 # 6cc8 <malloc+0xfae>
    2972:	00003097          	auipc	ra,0x3
    2976:	2f0080e7          	jalr	752(ra) # 5c62 <printf>
    exit(1);
    297a:	4505                	li	a0,1
    297c:	00003097          	auipc	ra,0x3
    2980:	f6e080e7          	jalr	-146(ra) # 58ea <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2984:	86aa                	mv	a3,a0
    2986:	8626                	mv	a2,s1
    2988:	85ce                	mv	a1,s3
    298a:	00004517          	auipc	a0,0x4
    298e:	35e50513          	addi	a0,a0,862 # 6ce8 <malloc+0xfce>
    2992:	00003097          	auipc	ra,0x3
    2996:	2d0080e7          	jalr	720(ra) # 5c62 <printf>
    exit(1);
    299a:	4505                	li	a0,1
    299c:	00003097          	auipc	ra,0x3
    29a0:	f4e080e7          	jalr	-178(ra) # 58ea <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    29a4:	86d2                	mv	a3,s4
    29a6:	8626                	mv	a2,s1
    29a8:	85ce                	mv	a1,s3
    29aa:	00004517          	auipc	a0,0x4
    29ae:	37e50513          	addi	a0,a0,894 # 6d28 <malloc+0x100e>
    29b2:	00003097          	auipc	ra,0x3
    29b6:	2b0080e7          	jalr	688(ra) # 5c62 <printf>
    exit(1);
    29ba:	4505                	li	a0,1
    29bc:	00003097          	auipc	ra,0x3
    29c0:	f2e080e7          	jalr	-210(ra) # 58ea <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    29c4:	85ce                	mv	a1,s3
    29c6:	00004517          	auipc	a0,0x4
    29ca:	39250513          	addi	a0,a0,914 # 6d58 <malloc+0x103e>
    29ce:	00003097          	auipc	ra,0x3
    29d2:	294080e7          	jalr	660(ra) # 5c62 <printf>
    exit(1);
    29d6:	4505                	li	a0,1
    29d8:	00003097          	auipc	ra,0x3
    29dc:	f12080e7          	jalr	-238(ra) # 58ea <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    29e0:	86aa                	mv	a3,a0
    29e2:	8626                	mv	a2,s1
    29e4:	85ce                	mv	a1,s3
    29e6:	00004517          	auipc	a0,0x4
    29ea:	3aa50513          	addi	a0,a0,938 # 6d90 <malloc+0x1076>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	274080e7          	jalr	628(ra) # 5c62 <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	ef2080e7          	jalr	-270(ra) # 58ea <exit>

0000000000002a00 <sbrkarg>:
{
    2a00:	7179                	addi	sp,sp,-48
    2a02:	f406                	sd	ra,40(sp)
    2a04:	f022                	sd	s0,32(sp)
    2a06:	ec26                	sd	s1,24(sp)
    2a08:	e84a                	sd	s2,16(sp)
    2a0a:	e44e                	sd	s3,8(sp)
    2a0c:	1800                	addi	s0,sp,48
    2a0e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2a10:	6505                	lui	a0,0x1
    2a12:	00003097          	auipc	ra,0x3
    2a16:	f60080e7          	jalr	-160(ra) # 5972 <sbrk>
    2a1a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2a1c:	20100593          	li	a1,513
    2a20:	00004517          	auipc	a0,0x4
    2a24:	39850513          	addi	a0,a0,920 # 6db8 <malloc+0x109e>
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	f02080e7          	jalr	-254(ra) # 592a <open>
    2a30:	84aa                	mv	s1,a0
  unlink("sbrk");
    2a32:	00004517          	auipc	a0,0x4
    2a36:	38650513          	addi	a0,a0,902 # 6db8 <malloc+0x109e>
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	f00080e7          	jalr	-256(ra) # 593a <unlink>
  if(fd < 0)  {
    2a42:	0404c163          	bltz	s1,2a84 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2a46:	6605                	lui	a2,0x1
    2a48:	85ca                	mv	a1,s2
    2a4a:	8526                	mv	a0,s1
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	ebe080e7          	jalr	-322(ra) # 590a <write>
    2a54:	04054663          	bltz	a0,2aa0 <sbrkarg+0xa0>
  close(fd);
    2a58:	8526                	mv	a0,s1
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	eb8080e7          	jalr	-328(ra) # 5912 <close>
  a = sbrk(PGSIZE);
    2a62:	6505                	lui	a0,0x1
    2a64:	00003097          	auipc	ra,0x3
    2a68:	f0e080e7          	jalr	-242(ra) # 5972 <sbrk>
  if(pipe((int *) a) != 0){
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	e8e080e7          	jalr	-370(ra) # 58fa <pipe>
    2a74:	e521                	bnez	a0,2abc <sbrkarg+0xbc>
}
    2a76:	70a2                	ld	ra,40(sp)
    2a78:	7402                	ld	s0,32(sp)
    2a7a:	64e2                	ld	s1,24(sp)
    2a7c:	6942                	ld	s2,16(sp)
    2a7e:	69a2                	ld	s3,8(sp)
    2a80:	6145                	addi	sp,sp,48
    2a82:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a84:	85ce                	mv	a1,s3
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	33a50513          	addi	a0,a0,826 # 6dc0 <malloc+0x10a6>
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	1d4080e7          	jalr	468(ra) # 5c62 <printf>
    exit(1);
    2a96:	4505                	li	a0,1
    2a98:	00003097          	auipc	ra,0x3
    2a9c:	e52080e7          	jalr	-430(ra) # 58ea <exit>
    printf("%s: write sbrk failed\n", s);
    2aa0:	85ce                	mv	a1,s3
    2aa2:	00004517          	auipc	a0,0x4
    2aa6:	33650513          	addi	a0,a0,822 # 6dd8 <malloc+0x10be>
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	1b8080e7          	jalr	440(ra) # 5c62 <printf>
    exit(1);
    2ab2:	4505                	li	a0,1
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	e36080e7          	jalr	-458(ra) # 58ea <exit>
    printf("%s: pipe() failed\n", s);
    2abc:	85ce                	mv	a1,s3
    2abe:	00004517          	auipc	a0,0x4
    2ac2:	cfa50513          	addi	a0,a0,-774 # 67b8 <malloc+0xa9e>
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	19c080e7          	jalr	412(ra) # 5c62 <printf>
    exit(1);
    2ace:	4505                	li	a0,1
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	e1a080e7          	jalr	-486(ra) # 58ea <exit>

0000000000002ad8 <argptest>:
{
    2ad8:	1101                	addi	sp,sp,-32
    2ada:	ec06                	sd	ra,24(sp)
    2adc:	e822                	sd	s0,16(sp)
    2ade:	e426                	sd	s1,8(sp)
    2ae0:	e04a                	sd	s2,0(sp)
    2ae2:	1000                	addi	s0,sp,32
    2ae4:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ae6:	4581                	li	a1,0
    2ae8:	00004517          	auipc	a0,0x4
    2aec:	30850513          	addi	a0,a0,776 # 6df0 <malloc+0x10d6>
    2af0:	00003097          	auipc	ra,0x3
    2af4:	e3a080e7          	jalr	-454(ra) # 592a <open>
  if (fd < 0) {
    2af8:	02054b63          	bltz	a0,2b2e <argptest+0x56>
    2afc:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2afe:	4501                	li	a0,0
    2b00:	00003097          	auipc	ra,0x3
    2b04:	e72080e7          	jalr	-398(ra) # 5972 <sbrk>
    2b08:	567d                	li	a2,-1
    2b0a:	fff50593          	addi	a1,a0,-1
    2b0e:	8526                	mv	a0,s1
    2b10:	00003097          	auipc	ra,0x3
    2b14:	df2080e7          	jalr	-526(ra) # 5902 <read>
  close(fd);
    2b18:	8526                	mv	a0,s1
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	df8080e7          	jalr	-520(ra) # 5912 <close>
}
    2b22:	60e2                	ld	ra,24(sp)
    2b24:	6442                	ld	s0,16(sp)
    2b26:	64a2                	ld	s1,8(sp)
    2b28:	6902                	ld	s2,0(sp)
    2b2a:	6105                	addi	sp,sp,32
    2b2c:	8082                	ret
    printf("%s: open failed\n", s);
    2b2e:	85ca                	mv	a1,s2
    2b30:	00004517          	auipc	a0,0x4
    2b34:	b9850513          	addi	a0,a0,-1128 # 66c8 <malloc+0x9ae>
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	12a080e7          	jalr	298(ra) # 5c62 <printf>
    exit(1);
    2b40:	4505                	li	a0,1
    2b42:	00003097          	auipc	ra,0x3
    2b46:	da8080e7          	jalr	-600(ra) # 58ea <exit>

0000000000002b4a <sbrkbugs>:
{
    2b4a:	1141                	addi	sp,sp,-16
    2b4c:	e406                	sd	ra,8(sp)
    2b4e:	e022                	sd	s0,0(sp)
    2b50:	0800                	addi	s0,sp,16
  int pid = fork();
    2b52:	00003097          	auipc	ra,0x3
    2b56:	d90080e7          	jalr	-624(ra) # 58e2 <fork>
  if(pid < 0){
    2b5a:	02054263          	bltz	a0,2b7e <sbrkbugs+0x34>
  if(pid == 0){
    2b5e:	ed0d                	bnez	a0,2b98 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b60:	00003097          	auipc	ra,0x3
    2b64:	e12080e7          	jalr	-494(ra) # 5972 <sbrk>
    sbrk(-sz);
    2b68:	40a0053b          	negw	a0,a0
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	e06080e7          	jalr	-506(ra) # 5972 <sbrk>
    exit(0);
    2b74:	4501                	li	a0,0
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	d74080e7          	jalr	-652(ra) # 58ea <exit>
    printf("fork failed\n");
    2b7e:	00004517          	auipc	a0,0x4
    2b82:	f5250513          	addi	a0,a0,-174 # 6ad0 <malloc+0xdb6>
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	0dc080e7          	jalr	220(ra) # 5c62 <printf>
    exit(1);
    2b8e:	4505                	li	a0,1
    2b90:	00003097          	auipc	ra,0x3
    2b94:	d5a080e7          	jalr	-678(ra) # 58ea <exit>
  wait(0);
    2b98:	4501                	li	a0,0
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	d58080e7          	jalr	-680(ra) # 58f2 <wait>
  pid = fork();
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	d40080e7          	jalr	-704(ra) # 58e2 <fork>
  if(pid < 0){
    2baa:	02054563          	bltz	a0,2bd4 <sbrkbugs+0x8a>
  if(pid == 0){
    2bae:	e121                	bnez	a0,2bee <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	dc2080e7          	jalr	-574(ra) # 5972 <sbrk>
    sbrk(-(sz - 3500));
    2bb8:	6785                	lui	a5,0x1
    2bba:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x98>
    2bbe:	40a7853b          	subw	a0,a5,a0
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	db0080e7          	jalr	-592(ra) # 5972 <sbrk>
    exit(0);
    2bca:	4501                	li	a0,0
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	d1e080e7          	jalr	-738(ra) # 58ea <exit>
    printf("fork failed\n");
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	efc50513          	addi	a0,a0,-260 # 6ad0 <malloc+0xdb6>
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	086080e7          	jalr	134(ra) # 5c62 <printf>
    exit(1);
    2be4:	4505                	li	a0,1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	d04080e7          	jalr	-764(ra) # 58ea <exit>
  wait(0);
    2bee:	4501                	li	a0,0
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	d02080e7          	jalr	-766(ra) # 58f2 <wait>
  pid = fork();
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	cea080e7          	jalr	-790(ra) # 58e2 <fork>
  if(pid < 0){
    2c00:	02054a63          	bltz	a0,2c34 <sbrkbugs+0xea>
  if(pid == 0){
    2c04:	e529                	bnez	a0,2c4e <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	d6c080e7          	jalr	-660(ra) # 5972 <sbrk>
    2c0e:	67ad                	lui	a5,0xb
    2c10:	8007879b          	addiw	a5,a5,-2048 # a800 <__global_pointer$+0x70c>
    2c14:	40a7853b          	subw	a0,a5,a0
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	d5a080e7          	jalr	-678(ra) # 5972 <sbrk>
    sbrk(-10);
    2c20:	5559                	li	a0,-10
    2c22:	00003097          	auipc	ra,0x3
    2c26:	d50080e7          	jalr	-688(ra) # 5972 <sbrk>
    exit(0);
    2c2a:	4501                	li	a0,0
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	cbe080e7          	jalr	-834(ra) # 58ea <exit>
    printf("fork failed\n");
    2c34:	00004517          	auipc	a0,0x4
    2c38:	e9c50513          	addi	a0,a0,-356 # 6ad0 <malloc+0xdb6>
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	026080e7          	jalr	38(ra) # 5c62 <printf>
    exit(1);
    2c44:	4505                	li	a0,1
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	ca4080e7          	jalr	-860(ra) # 58ea <exit>
  wait(0);
    2c4e:	4501                	li	a0,0
    2c50:	00003097          	auipc	ra,0x3
    2c54:	ca2080e7          	jalr	-862(ra) # 58f2 <wait>
  exit(0);
    2c58:	4501                	li	a0,0
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	c90080e7          	jalr	-880(ra) # 58ea <exit>

0000000000002c62 <sbrklast>:
{
    2c62:	7179                	addi	sp,sp,-48
    2c64:	f406                	sd	ra,40(sp)
    2c66:	f022                	sd	s0,32(sp)
    2c68:	ec26                	sd	s1,24(sp)
    2c6a:	e84a                	sd	s2,16(sp)
    2c6c:	e44e                	sd	s3,8(sp)
    2c6e:	e052                	sd	s4,0(sp)
    2c70:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c72:	4501                	li	a0,0
    2c74:	00003097          	auipc	ra,0x3
    2c78:	cfe080e7          	jalr	-770(ra) # 5972 <sbrk>
  if((top % 4096) != 0)
    2c7c:	03451793          	slli	a5,a0,0x34
    2c80:	ebd9                	bnez	a5,2d16 <sbrklast+0xb4>
  sbrk(4096);
    2c82:	6505                	lui	a0,0x1
    2c84:	00003097          	auipc	ra,0x3
    2c88:	cee080e7          	jalr	-786(ra) # 5972 <sbrk>
  sbrk(10);
    2c8c:	4529                	li	a0,10
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	ce4080e7          	jalr	-796(ra) # 5972 <sbrk>
  sbrk(-20);
    2c96:	5531                	li	a0,-20
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	cda080e7          	jalr	-806(ra) # 5972 <sbrk>
  top = (uint64) sbrk(0);
    2ca0:	4501                	li	a0,0
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	cd0080e7          	jalr	-816(ra) # 5972 <sbrk>
    2caa:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2cac:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x60>
  p[0] = 'x';
    2cb0:	07800a13          	li	s4,120
    2cb4:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2cb8:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2cbc:	20200593          	li	a1,514
    2cc0:	854a                	mv	a0,s2
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	c68080e7          	jalr	-920(ra) # 592a <open>
    2cca:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ccc:	4605                	li	a2,1
    2cce:	85ca                	mv	a1,s2
    2cd0:	00003097          	auipc	ra,0x3
    2cd4:	c3a080e7          	jalr	-966(ra) # 590a <write>
  close(fd);
    2cd8:	854e                	mv	a0,s3
    2cda:	00003097          	auipc	ra,0x3
    2cde:	c38080e7          	jalr	-968(ra) # 5912 <close>
  fd = open(p, O_RDWR);
    2ce2:	4589                	li	a1,2
    2ce4:	854a                	mv	a0,s2
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	c44080e7          	jalr	-956(ra) # 592a <open>
  p[0] = '\0';
    2cee:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2cf2:	4605                	li	a2,1
    2cf4:	85ca                	mv	a1,s2
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	c0c080e7          	jalr	-1012(ra) # 5902 <read>
  if(p[0] != 'x')
    2cfe:	fc04c783          	lbu	a5,-64(s1)
    2d02:	03479463          	bne	a5,s4,2d2a <sbrklast+0xc8>
}
    2d06:	70a2                	ld	ra,40(sp)
    2d08:	7402                	ld	s0,32(sp)
    2d0a:	64e2                	ld	s1,24(sp)
    2d0c:	6942                	ld	s2,16(sp)
    2d0e:	69a2                	ld	s3,8(sp)
    2d10:	6a02                	ld	s4,0(sp)
    2d12:	6145                	addi	sp,sp,48
    2d14:	8082                	ret
    sbrk(4096 - (top % 4096));
    2d16:	0347d513          	srli	a0,a5,0x34
    2d1a:	6785                	lui	a5,0x1
    2d1c:	40a7853b          	subw	a0,a5,a0
    2d20:	00003097          	auipc	ra,0x3
    2d24:	c52080e7          	jalr	-942(ra) # 5972 <sbrk>
    2d28:	bfa9                	j	2c82 <sbrklast+0x20>
    exit(1);
    2d2a:	4505                	li	a0,1
    2d2c:	00003097          	auipc	ra,0x3
    2d30:	bbe080e7          	jalr	-1090(ra) # 58ea <exit>

0000000000002d34 <sbrk8000>:
{
    2d34:	1141                	addi	sp,sp,-16
    2d36:	e406                	sd	ra,8(sp)
    2d38:	e022                	sd	s0,0(sp)
    2d3a:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2d3c:	80000537          	lui	a0,0x80000
    2d40:	0511                	addi	a0,a0,4 # ffffffff80000004 <__BSS_END__+0xffffffff7ffefedc>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	c30080e7          	jalr	-976(ra) # 5972 <sbrk>
  volatile char *top = sbrk(0);
    2d4a:	4501                	li	a0,0
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	c26080e7          	jalr	-986(ra) # 5972 <sbrk>
  *(top-1) = *(top-1) + 1;
    2d54:	fff54783          	lbu	a5,-1(a0)
    2d58:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0xa1>
    2d5a:	0ff7f793          	zext.b	a5,a5
    2d5e:	fef50fa3          	sb	a5,-1(a0)
}
    2d62:	60a2                	ld	ra,8(sp)
    2d64:	6402                	ld	s0,0(sp)
    2d66:	0141                	addi	sp,sp,16
    2d68:	8082                	ret

0000000000002d6a <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d6a:	715d                	addi	sp,sp,-80
    2d6c:	e486                	sd	ra,72(sp)
    2d6e:	e0a2                	sd	s0,64(sp)
    2d70:	fc26                	sd	s1,56(sp)
    2d72:	f84a                	sd	s2,48(sp)
    2d74:	f44e                	sd	s3,40(sp)
    2d76:	f052                	sd	s4,32(sp)
    2d78:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d7a:	4901                	li	s2,0
    2d7c:	49bd                	li	s3,15
    int pid = fork();
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	b64080e7          	jalr	-1180(ra) # 58e2 <fork>
    2d86:	84aa                	mv	s1,a0
    if(pid < 0){
    2d88:	02054063          	bltz	a0,2da8 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d8c:	c91d                	beqz	a0,2dc2 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d8e:	4501                	li	a0,0
    2d90:	00003097          	auipc	ra,0x3
    2d94:	b62080e7          	jalr	-1182(ra) # 58f2 <wait>
  for(int avail = 0; avail < 15; avail++){
    2d98:	2905                	addiw	s2,s2,1
    2d9a:	ff3912e3          	bne	s2,s3,2d7e <execout+0x14>
    }
  }

  exit(0);
    2d9e:	4501                	li	a0,0
    2da0:	00003097          	auipc	ra,0x3
    2da4:	b4a080e7          	jalr	-1206(ra) # 58ea <exit>
      printf("fork failed\n");
    2da8:	00004517          	auipc	a0,0x4
    2dac:	d2850513          	addi	a0,a0,-728 # 6ad0 <malloc+0xdb6>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	eb2080e7          	jalr	-334(ra) # 5c62 <printf>
      exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	b30080e7          	jalr	-1232(ra) # 58ea <exit>
        if(a == 0xffffffffffffffffLL)
    2dc2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2dc4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2dc6:	6505                	lui	a0,0x1
    2dc8:	00003097          	auipc	ra,0x3
    2dcc:	baa080e7          	jalr	-1110(ra) # 5972 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2dd0:	01350763          	beq	a0,s3,2dde <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2dd4:	6785                	lui	a5,0x1
    2dd6:	97aa                	add	a5,a5,a0
    2dd8:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9f>
      while(1){
    2ddc:	b7ed                	j	2dc6 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2dde:	01205a63          	blez	s2,2df2 <execout+0x88>
        sbrk(-4096);
    2de2:	757d                	lui	a0,0xfffff
    2de4:	00003097          	auipc	ra,0x3
    2de8:	b8e080e7          	jalr	-1138(ra) # 5972 <sbrk>
      for(int i = 0; i < avail; i++)
    2dec:	2485                	addiw	s1,s1,1
    2dee:	ff249ae3          	bne	s1,s2,2de2 <execout+0x78>
      close(1);
    2df2:	4505                	li	a0,1
    2df4:	00003097          	auipc	ra,0x3
    2df8:	b1e080e7          	jalr	-1250(ra) # 5912 <close>
      char *args[] = { "echo", "x", 0 };
    2dfc:	00003517          	auipc	a0,0x3
    2e00:	05c50513          	addi	a0,a0,92 # 5e58 <malloc+0x13e>
    2e04:	faa43c23          	sd	a0,-72(s0)
    2e08:	00003797          	auipc	a5,0x3
    2e0c:	0c078793          	addi	a5,a5,192 # 5ec8 <malloc+0x1ae>
    2e10:	fcf43023          	sd	a5,-64(s0)
    2e14:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2e18:	fb840593          	addi	a1,s0,-72
    2e1c:	00003097          	auipc	ra,0x3
    2e20:	b06080e7          	jalr	-1274(ra) # 5922 <exec>
      exit(0);
    2e24:	4501                	li	a0,0
    2e26:	00003097          	auipc	ra,0x3
    2e2a:	ac4080e7          	jalr	-1340(ra) # 58ea <exit>

0000000000002e2e <fourteen>:
{
    2e2e:	1101                	addi	sp,sp,-32
    2e30:	ec06                	sd	ra,24(sp)
    2e32:	e822                	sd	s0,16(sp)
    2e34:	e426                	sd	s1,8(sp)
    2e36:	1000                	addi	s0,sp,32
    2e38:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2e3a:	00004517          	auipc	a0,0x4
    2e3e:	18e50513          	addi	a0,a0,398 # 6fc8 <malloc+0x12ae>
    2e42:	00003097          	auipc	ra,0x3
    2e46:	b10080e7          	jalr	-1264(ra) # 5952 <mkdir>
    2e4a:	e165                	bnez	a0,2f2a <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2e4c:	00004517          	auipc	a0,0x4
    2e50:	fd450513          	addi	a0,a0,-44 # 6e20 <malloc+0x1106>
    2e54:	00003097          	auipc	ra,0x3
    2e58:	afe080e7          	jalr	-1282(ra) # 5952 <mkdir>
    2e5c:	e56d                	bnez	a0,2f46 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e5e:	20000593          	li	a1,512
    2e62:	00004517          	auipc	a0,0x4
    2e66:	01650513          	addi	a0,a0,22 # 6e78 <malloc+0x115e>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	ac0080e7          	jalr	-1344(ra) # 592a <open>
  if(fd < 0){
    2e72:	0e054863          	bltz	a0,2f62 <fourteen+0x134>
  close(fd);
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	a9c080e7          	jalr	-1380(ra) # 5912 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e7e:	4581                	li	a1,0
    2e80:	00004517          	auipc	a0,0x4
    2e84:	07050513          	addi	a0,a0,112 # 6ef0 <malloc+0x11d6>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	aa2080e7          	jalr	-1374(ra) # 592a <open>
  if(fd < 0){
    2e90:	0e054763          	bltz	a0,2f7e <fourteen+0x150>
  close(fd);
    2e94:	00003097          	auipc	ra,0x3
    2e98:	a7e080e7          	jalr	-1410(ra) # 5912 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	0c450513          	addi	a0,a0,196 # 6f60 <malloc+0x1246>
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	aae080e7          	jalr	-1362(ra) # 5952 <mkdir>
    2eac:	c57d                	beqz	a0,2f9a <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2eae:	00004517          	auipc	a0,0x4
    2eb2:	10a50513          	addi	a0,a0,266 # 6fb8 <malloc+0x129e>
    2eb6:	00003097          	auipc	ra,0x3
    2eba:	a9c080e7          	jalr	-1380(ra) # 5952 <mkdir>
    2ebe:	cd65                	beqz	a0,2fb6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2ec0:	00004517          	auipc	a0,0x4
    2ec4:	0f850513          	addi	a0,a0,248 # 6fb8 <malloc+0x129e>
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	a72080e7          	jalr	-1422(ra) # 593a <unlink>
  unlink("12345678901234/12345678901234");
    2ed0:	00004517          	auipc	a0,0x4
    2ed4:	09050513          	addi	a0,a0,144 # 6f60 <malloc+0x1246>
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	a62080e7          	jalr	-1438(ra) # 593a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2ee0:	00004517          	auipc	a0,0x4
    2ee4:	01050513          	addi	a0,a0,16 # 6ef0 <malloc+0x11d6>
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	a52080e7          	jalr	-1454(ra) # 593a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ef0:	00004517          	auipc	a0,0x4
    2ef4:	f8850513          	addi	a0,a0,-120 # 6e78 <malloc+0x115e>
    2ef8:	00003097          	auipc	ra,0x3
    2efc:	a42080e7          	jalr	-1470(ra) # 593a <unlink>
  unlink("12345678901234/123456789012345");
    2f00:	00004517          	auipc	a0,0x4
    2f04:	f2050513          	addi	a0,a0,-224 # 6e20 <malloc+0x1106>
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	a32080e7          	jalr	-1486(ra) # 593a <unlink>
  unlink("12345678901234");
    2f10:	00004517          	auipc	a0,0x4
    2f14:	0b850513          	addi	a0,a0,184 # 6fc8 <malloc+0x12ae>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	a22080e7          	jalr	-1502(ra) # 593a <unlink>
}
    2f20:	60e2                	ld	ra,24(sp)
    2f22:	6442                	ld	s0,16(sp)
    2f24:	64a2                	ld	s1,8(sp)
    2f26:	6105                	addi	sp,sp,32
    2f28:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2f2a:	85a6                	mv	a1,s1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	ecc50513          	addi	a0,a0,-308 # 6df8 <malloc+0x10de>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	d2e080e7          	jalr	-722(ra) # 5c62 <printf>
    exit(1);
    2f3c:	4505                	li	a0,1
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	9ac080e7          	jalr	-1620(ra) # 58ea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2f46:	85a6                	mv	a1,s1
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	ef850513          	addi	a0,a0,-264 # 6e40 <malloc+0x1126>
    2f50:	00003097          	auipc	ra,0x3
    2f54:	d12080e7          	jalr	-750(ra) # 5c62 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	00003097          	auipc	ra,0x3
    2f5e:	990080e7          	jalr	-1648(ra) # 58ea <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f62:	85a6                	mv	a1,s1
    2f64:	00004517          	auipc	a0,0x4
    2f68:	f4450513          	addi	a0,a0,-188 # 6ea8 <malloc+0x118e>
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	cf6080e7          	jalr	-778(ra) # 5c62 <printf>
    exit(1);
    2f74:	4505                	li	a0,1
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	974080e7          	jalr	-1676(ra) # 58ea <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f7e:	85a6                	mv	a1,s1
    2f80:	00004517          	auipc	a0,0x4
    2f84:	fa050513          	addi	a0,a0,-96 # 6f20 <malloc+0x1206>
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	cda080e7          	jalr	-806(ra) # 5c62 <printf>
    exit(1);
    2f90:	4505                	li	a0,1
    2f92:	00003097          	auipc	ra,0x3
    2f96:	958080e7          	jalr	-1704(ra) # 58ea <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f9a:	85a6                	mv	a1,s1
    2f9c:	00004517          	auipc	a0,0x4
    2fa0:	fe450513          	addi	a0,a0,-28 # 6f80 <malloc+0x1266>
    2fa4:	00003097          	auipc	ra,0x3
    2fa8:	cbe080e7          	jalr	-834(ra) # 5c62 <printf>
    exit(1);
    2fac:	4505                	li	a0,1
    2fae:	00003097          	auipc	ra,0x3
    2fb2:	93c080e7          	jalr	-1732(ra) # 58ea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2fb6:	85a6                	mv	a1,s1
    2fb8:	00004517          	auipc	a0,0x4
    2fbc:	02050513          	addi	a0,a0,32 # 6fd8 <malloc+0x12be>
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	ca2080e7          	jalr	-862(ra) # 5c62 <printf>
    exit(1);
    2fc8:	4505                	li	a0,1
    2fca:	00003097          	auipc	ra,0x3
    2fce:	920080e7          	jalr	-1760(ra) # 58ea <exit>

0000000000002fd2 <iputtest>:
{
    2fd2:	1101                	addi	sp,sp,-32
    2fd4:	ec06                	sd	ra,24(sp)
    2fd6:	e822                	sd	s0,16(sp)
    2fd8:	e426                	sd	s1,8(sp)
    2fda:	1000                	addi	s0,sp,32
    2fdc:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	03250513          	addi	a0,a0,50 # 7010 <malloc+0x12f6>
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	96c080e7          	jalr	-1684(ra) # 5952 <mkdir>
    2fee:	04054563          	bltz	a0,3038 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ff2:	00004517          	auipc	a0,0x4
    2ff6:	01e50513          	addi	a0,a0,30 # 7010 <malloc+0x12f6>
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	960080e7          	jalr	-1696(ra) # 595a <chdir>
    3002:	04054963          	bltz	a0,3054 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3006:	00004517          	auipc	a0,0x4
    300a:	04a50513          	addi	a0,a0,74 # 7050 <malloc+0x1336>
    300e:	00003097          	auipc	ra,0x3
    3012:	92c080e7          	jalr	-1748(ra) # 593a <unlink>
    3016:	04054d63          	bltz	a0,3070 <iputtest+0x9e>
  if(chdir("/") < 0){
    301a:	00004517          	auipc	a0,0x4
    301e:	06650513          	addi	a0,a0,102 # 7080 <malloc+0x1366>
    3022:	00003097          	auipc	ra,0x3
    3026:	938080e7          	jalr	-1736(ra) # 595a <chdir>
    302a:	06054163          	bltz	a0,308c <iputtest+0xba>
}
    302e:	60e2                	ld	ra,24(sp)
    3030:	6442                	ld	s0,16(sp)
    3032:	64a2                	ld	s1,8(sp)
    3034:	6105                	addi	sp,sp,32
    3036:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3038:	85a6                	mv	a1,s1
    303a:	00004517          	auipc	a0,0x4
    303e:	fde50513          	addi	a0,a0,-34 # 7018 <malloc+0x12fe>
    3042:	00003097          	auipc	ra,0x3
    3046:	c20080e7          	jalr	-992(ra) # 5c62 <printf>
    exit(1);
    304a:	4505                	li	a0,1
    304c:	00003097          	auipc	ra,0x3
    3050:	89e080e7          	jalr	-1890(ra) # 58ea <exit>
    printf("%s: chdir iputdir failed\n", s);
    3054:	85a6                	mv	a1,s1
    3056:	00004517          	auipc	a0,0x4
    305a:	fda50513          	addi	a0,a0,-38 # 7030 <malloc+0x1316>
    305e:	00003097          	auipc	ra,0x3
    3062:	c04080e7          	jalr	-1020(ra) # 5c62 <printf>
    exit(1);
    3066:	4505                	li	a0,1
    3068:	00003097          	auipc	ra,0x3
    306c:	882080e7          	jalr	-1918(ra) # 58ea <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3070:	85a6                	mv	a1,s1
    3072:	00004517          	auipc	a0,0x4
    3076:	fee50513          	addi	a0,a0,-18 # 7060 <malloc+0x1346>
    307a:	00003097          	auipc	ra,0x3
    307e:	be8080e7          	jalr	-1048(ra) # 5c62 <printf>
    exit(1);
    3082:	4505                	li	a0,1
    3084:	00003097          	auipc	ra,0x3
    3088:	866080e7          	jalr	-1946(ra) # 58ea <exit>
    printf("%s: chdir / failed\n", s);
    308c:	85a6                	mv	a1,s1
    308e:	00004517          	auipc	a0,0x4
    3092:	ffa50513          	addi	a0,a0,-6 # 7088 <malloc+0x136e>
    3096:	00003097          	auipc	ra,0x3
    309a:	bcc080e7          	jalr	-1076(ra) # 5c62 <printf>
    exit(1);
    309e:	4505                	li	a0,1
    30a0:	00003097          	auipc	ra,0x3
    30a4:	84a080e7          	jalr	-1974(ra) # 58ea <exit>

00000000000030a8 <exitiputtest>:
{
    30a8:	7179                	addi	sp,sp,-48
    30aa:	f406                	sd	ra,40(sp)
    30ac:	f022                	sd	s0,32(sp)
    30ae:	ec26                	sd	s1,24(sp)
    30b0:	1800                	addi	s0,sp,48
    30b2:	84aa                	mv	s1,a0
  pid = fork();
    30b4:	00003097          	auipc	ra,0x3
    30b8:	82e080e7          	jalr	-2002(ra) # 58e2 <fork>
  if(pid < 0){
    30bc:	04054663          	bltz	a0,3108 <exitiputtest+0x60>
  if(pid == 0){
    30c0:	ed45                	bnez	a0,3178 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    30c2:	00004517          	auipc	a0,0x4
    30c6:	f4e50513          	addi	a0,a0,-178 # 7010 <malloc+0x12f6>
    30ca:	00003097          	auipc	ra,0x3
    30ce:	888080e7          	jalr	-1912(ra) # 5952 <mkdir>
    30d2:	04054963          	bltz	a0,3124 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    30d6:	00004517          	auipc	a0,0x4
    30da:	f3a50513          	addi	a0,a0,-198 # 7010 <malloc+0x12f6>
    30de:	00003097          	auipc	ra,0x3
    30e2:	87c080e7          	jalr	-1924(ra) # 595a <chdir>
    30e6:	04054d63          	bltz	a0,3140 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    30ea:	00004517          	auipc	a0,0x4
    30ee:	f6650513          	addi	a0,a0,-154 # 7050 <malloc+0x1336>
    30f2:	00003097          	auipc	ra,0x3
    30f6:	848080e7          	jalr	-1976(ra) # 593a <unlink>
    30fa:	06054163          	bltz	a0,315c <exitiputtest+0xb4>
    exit(0);
    30fe:	4501                	li	a0,0
    3100:	00002097          	auipc	ra,0x2
    3104:	7ea080e7          	jalr	2026(ra) # 58ea <exit>
    printf("%s: fork failed\n", s);
    3108:	85a6                	mv	a1,s1
    310a:	00003517          	auipc	a0,0x3
    310e:	5a650513          	addi	a0,a0,1446 # 66b0 <malloc+0x996>
    3112:	00003097          	auipc	ra,0x3
    3116:	b50080e7          	jalr	-1200(ra) # 5c62 <printf>
    exit(1);
    311a:	4505                	li	a0,1
    311c:	00002097          	auipc	ra,0x2
    3120:	7ce080e7          	jalr	1998(ra) # 58ea <exit>
      printf("%s: mkdir failed\n", s);
    3124:	85a6                	mv	a1,s1
    3126:	00004517          	auipc	a0,0x4
    312a:	ef250513          	addi	a0,a0,-270 # 7018 <malloc+0x12fe>
    312e:	00003097          	auipc	ra,0x3
    3132:	b34080e7          	jalr	-1228(ra) # 5c62 <printf>
      exit(1);
    3136:	4505                	li	a0,1
    3138:	00002097          	auipc	ra,0x2
    313c:	7b2080e7          	jalr	1970(ra) # 58ea <exit>
      printf("%s: child chdir failed\n", s);
    3140:	85a6                	mv	a1,s1
    3142:	00004517          	auipc	a0,0x4
    3146:	f5e50513          	addi	a0,a0,-162 # 70a0 <malloc+0x1386>
    314a:	00003097          	auipc	ra,0x3
    314e:	b18080e7          	jalr	-1256(ra) # 5c62 <printf>
      exit(1);
    3152:	4505                	li	a0,1
    3154:	00002097          	auipc	ra,0x2
    3158:	796080e7          	jalr	1942(ra) # 58ea <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    315c:	85a6                	mv	a1,s1
    315e:	00004517          	auipc	a0,0x4
    3162:	f0250513          	addi	a0,a0,-254 # 7060 <malloc+0x1346>
    3166:	00003097          	auipc	ra,0x3
    316a:	afc080e7          	jalr	-1284(ra) # 5c62 <printf>
      exit(1);
    316e:	4505                	li	a0,1
    3170:	00002097          	auipc	ra,0x2
    3174:	77a080e7          	jalr	1914(ra) # 58ea <exit>
  wait(&xstatus);
    3178:	fdc40513          	addi	a0,s0,-36
    317c:	00002097          	auipc	ra,0x2
    3180:	776080e7          	jalr	1910(ra) # 58f2 <wait>
  exit(xstatus);
    3184:	fdc42503          	lw	a0,-36(s0)
    3188:	00002097          	auipc	ra,0x2
    318c:	762080e7          	jalr	1890(ra) # 58ea <exit>

0000000000003190 <dirtest>:
{
    3190:	1101                	addi	sp,sp,-32
    3192:	ec06                	sd	ra,24(sp)
    3194:	e822                	sd	s0,16(sp)
    3196:	e426                	sd	s1,8(sp)
    3198:	1000                	addi	s0,sp,32
    319a:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    319c:	00004517          	auipc	a0,0x4
    31a0:	f1c50513          	addi	a0,a0,-228 # 70b8 <malloc+0x139e>
    31a4:	00002097          	auipc	ra,0x2
    31a8:	7ae080e7          	jalr	1966(ra) # 5952 <mkdir>
    31ac:	04054563          	bltz	a0,31f6 <dirtest+0x66>
  if(chdir("dir0") < 0){
    31b0:	00004517          	auipc	a0,0x4
    31b4:	f0850513          	addi	a0,a0,-248 # 70b8 <malloc+0x139e>
    31b8:	00002097          	auipc	ra,0x2
    31bc:	7a2080e7          	jalr	1954(ra) # 595a <chdir>
    31c0:	04054963          	bltz	a0,3212 <dirtest+0x82>
  if(chdir("..") < 0){
    31c4:	00004517          	auipc	a0,0x4
    31c8:	f1450513          	addi	a0,a0,-236 # 70d8 <malloc+0x13be>
    31cc:	00002097          	auipc	ra,0x2
    31d0:	78e080e7          	jalr	1934(ra) # 595a <chdir>
    31d4:	04054d63          	bltz	a0,322e <dirtest+0x9e>
  if(unlink("dir0") < 0){
    31d8:	00004517          	auipc	a0,0x4
    31dc:	ee050513          	addi	a0,a0,-288 # 70b8 <malloc+0x139e>
    31e0:	00002097          	auipc	ra,0x2
    31e4:	75a080e7          	jalr	1882(ra) # 593a <unlink>
    31e8:	06054163          	bltz	a0,324a <dirtest+0xba>
}
    31ec:	60e2                	ld	ra,24(sp)
    31ee:	6442                	ld	s0,16(sp)
    31f0:	64a2                	ld	s1,8(sp)
    31f2:	6105                	addi	sp,sp,32
    31f4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    31f6:	85a6                	mv	a1,s1
    31f8:	00004517          	auipc	a0,0x4
    31fc:	e2050513          	addi	a0,a0,-480 # 7018 <malloc+0x12fe>
    3200:	00003097          	auipc	ra,0x3
    3204:	a62080e7          	jalr	-1438(ra) # 5c62 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	00002097          	auipc	ra,0x2
    320e:	6e0080e7          	jalr	1760(ra) # 58ea <exit>
    printf("%s: chdir dir0 failed\n", s);
    3212:	85a6                	mv	a1,s1
    3214:	00004517          	auipc	a0,0x4
    3218:	eac50513          	addi	a0,a0,-340 # 70c0 <malloc+0x13a6>
    321c:	00003097          	auipc	ra,0x3
    3220:	a46080e7          	jalr	-1466(ra) # 5c62 <printf>
    exit(1);
    3224:	4505                	li	a0,1
    3226:	00002097          	auipc	ra,0x2
    322a:	6c4080e7          	jalr	1732(ra) # 58ea <exit>
    printf("%s: chdir .. failed\n", s);
    322e:	85a6                	mv	a1,s1
    3230:	00004517          	auipc	a0,0x4
    3234:	eb050513          	addi	a0,a0,-336 # 70e0 <malloc+0x13c6>
    3238:	00003097          	auipc	ra,0x3
    323c:	a2a080e7          	jalr	-1494(ra) # 5c62 <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	00002097          	auipc	ra,0x2
    3246:	6a8080e7          	jalr	1704(ra) # 58ea <exit>
    printf("%s: unlink dir0 failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	eac50513          	addi	a0,a0,-340 # 70f8 <malloc+0x13de>
    3254:	00003097          	auipc	ra,0x3
    3258:	a0e080e7          	jalr	-1522(ra) # 5c62 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	00002097          	auipc	ra,0x2
    3262:	68c080e7          	jalr	1676(ra) # 58ea <exit>

0000000000003266 <subdir>:
{
    3266:	1101                	addi	sp,sp,-32
    3268:	ec06                	sd	ra,24(sp)
    326a:	e822                	sd	s0,16(sp)
    326c:	e426                	sd	s1,8(sp)
    326e:	e04a                	sd	s2,0(sp)
    3270:	1000                	addi	s0,sp,32
    3272:	892a                	mv	s2,a0
  unlink("ff");
    3274:	00004517          	auipc	a0,0x4
    3278:	fcc50513          	addi	a0,a0,-52 # 7240 <malloc+0x1526>
    327c:	00002097          	auipc	ra,0x2
    3280:	6be080e7          	jalr	1726(ra) # 593a <unlink>
  if(mkdir("dd") != 0){
    3284:	00004517          	auipc	a0,0x4
    3288:	e8c50513          	addi	a0,a0,-372 # 7110 <malloc+0x13f6>
    328c:	00002097          	auipc	ra,0x2
    3290:	6c6080e7          	jalr	1734(ra) # 5952 <mkdir>
    3294:	38051663          	bnez	a0,3620 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3298:	20200593          	li	a1,514
    329c:	00004517          	auipc	a0,0x4
    32a0:	e9450513          	addi	a0,a0,-364 # 7130 <malloc+0x1416>
    32a4:	00002097          	auipc	ra,0x2
    32a8:	686080e7          	jalr	1670(ra) # 592a <open>
    32ac:	84aa                	mv	s1,a0
  if(fd < 0){
    32ae:	38054763          	bltz	a0,363c <subdir+0x3d6>
  write(fd, "ff", 2);
    32b2:	4609                	li	a2,2
    32b4:	00004597          	auipc	a1,0x4
    32b8:	f8c58593          	addi	a1,a1,-116 # 7240 <malloc+0x1526>
    32bc:	00002097          	auipc	ra,0x2
    32c0:	64e080e7          	jalr	1614(ra) # 590a <write>
  close(fd);
    32c4:	8526                	mv	a0,s1
    32c6:	00002097          	auipc	ra,0x2
    32ca:	64c080e7          	jalr	1612(ra) # 5912 <close>
  if(unlink("dd") >= 0){
    32ce:	00004517          	auipc	a0,0x4
    32d2:	e4250513          	addi	a0,a0,-446 # 7110 <malloc+0x13f6>
    32d6:	00002097          	auipc	ra,0x2
    32da:	664080e7          	jalr	1636(ra) # 593a <unlink>
    32de:	36055d63          	bgez	a0,3658 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    32e2:	00004517          	auipc	a0,0x4
    32e6:	ea650513          	addi	a0,a0,-346 # 7188 <malloc+0x146e>
    32ea:	00002097          	auipc	ra,0x2
    32ee:	668080e7          	jalr	1640(ra) # 5952 <mkdir>
    32f2:	38051163          	bnez	a0,3674 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    32f6:	20200593          	li	a1,514
    32fa:	00004517          	auipc	a0,0x4
    32fe:	eb650513          	addi	a0,a0,-330 # 71b0 <malloc+0x1496>
    3302:	00002097          	auipc	ra,0x2
    3306:	628080e7          	jalr	1576(ra) # 592a <open>
    330a:	84aa                	mv	s1,a0
  if(fd < 0){
    330c:	38054263          	bltz	a0,3690 <subdir+0x42a>
  write(fd, "FF", 2);
    3310:	4609                	li	a2,2
    3312:	00004597          	auipc	a1,0x4
    3316:	ece58593          	addi	a1,a1,-306 # 71e0 <malloc+0x14c6>
    331a:	00002097          	auipc	ra,0x2
    331e:	5f0080e7          	jalr	1520(ra) # 590a <write>
  close(fd);
    3322:	8526                	mv	a0,s1
    3324:	00002097          	auipc	ra,0x2
    3328:	5ee080e7          	jalr	1518(ra) # 5912 <close>
  fd = open("dd/dd/../ff", 0);
    332c:	4581                	li	a1,0
    332e:	00004517          	auipc	a0,0x4
    3332:	eba50513          	addi	a0,a0,-326 # 71e8 <malloc+0x14ce>
    3336:	00002097          	auipc	ra,0x2
    333a:	5f4080e7          	jalr	1524(ra) # 592a <open>
    333e:	84aa                	mv	s1,a0
  if(fd < 0){
    3340:	36054663          	bltz	a0,36ac <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3344:	660d                	lui	a2,0x3
    3346:	0000a597          	auipc	a1,0xa
    334a:	dd258593          	addi	a1,a1,-558 # d118 <buf>
    334e:	00002097          	auipc	ra,0x2
    3352:	5b4080e7          	jalr	1460(ra) # 5902 <read>
  if(cc != 2 || buf[0] != 'f'){
    3356:	4789                	li	a5,2
    3358:	36f51863          	bne	a0,a5,36c8 <subdir+0x462>
    335c:	0000a717          	auipc	a4,0xa
    3360:	dbc74703          	lbu	a4,-580(a4) # d118 <buf>
    3364:	06600793          	li	a5,102
    3368:	36f71063          	bne	a4,a5,36c8 <subdir+0x462>
  close(fd);
    336c:	8526                	mv	a0,s1
    336e:	00002097          	auipc	ra,0x2
    3372:	5a4080e7          	jalr	1444(ra) # 5912 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3376:	00004597          	auipc	a1,0x4
    337a:	ec258593          	addi	a1,a1,-318 # 7238 <malloc+0x151e>
    337e:	00004517          	auipc	a0,0x4
    3382:	e3250513          	addi	a0,a0,-462 # 71b0 <malloc+0x1496>
    3386:	00002097          	auipc	ra,0x2
    338a:	5c4080e7          	jalr	1476(ra) # 594a <link>
    338e:	34051b63          	bnez	a0,36e4 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3392:	00004517          	auipc	a0,0x4
    3396:	e1e50513          	addi	a0,a0,-482 # 71b0 <malloc+0x1496>
    339a:	00002097          	auipc	ra,0x2
    339e:	5a0080e7          	jalr	1440(ra) # 593a <unlink>
    33a2:	34051f63          	bnez	a0,3700 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    33a6:	4581                	li	a1,0
    33a8:	00004517          	auipc	a0,0x4
    33ac:	e0850513          	addi	a0,a0,-504 # 71b0 <malloc+0x1496>
    33b0:	00002097          	auipc	ra,0x2
    33b4:	57a080e7          	jalr	1402(ra) # 592a <open>
    33b8:	36055263          	bgez	a0,371c <subdir+0x4b6>
  if(chdir("dd") != 0){
    33bc:	00004517          	auipc	a0,0x4
    33c0:	d5450513          	addi	a0,a0,-684 # 7110 <malloc+0x13f6>
    33c4:	00002097          	auipc	ra,0x2
    33c8:	596080e7          	jalr	1430(ra) # 595a <chdir>
    33cc:	36051663          	bnez	a0,3738 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    33d0:	00004517          	auipc	a0,0x4
    33d4:	f0050513          	addi	a0,a0,-256 # 72d0 <malloc+0x15b6>
    33d8:	00002097          	auipc	ra,0x2
    33dc:	582080e7          	jalr	1410(ra) # 595a <chdir>
    33e0:	36051a63          	bnez	a0,3754 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    33e4:	00004517          	auipc	a0,0x4
    33e8:	f1c50513          	addi	a0,a0,-228 # 7300 <malloc+0x15e6>
    33ec:	00002097          	auipc	ra,0x2
    33f0:	56e080e7          	jalr	1390(ra) # 595a <chdir>
    33f4:	36051e63          	bnez	a0,3770 <subdir+0x50a>
  if(chdir("./..") != 0){
    33f8:	00004517          	auipc	a0,0x4
    33fc:	f3850513          	addi	a0,a0,-200 # 7330 <malloc+0x1616>
    3400:	00002097          	auipc	ra,0x2
    3404:	55a080e7          	jalr	1370(ra) # 595a <chdir>
    3408:	38051263          	bnez	a0,378c <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    340c:	4581                	li	a1,0
    340e:	00004517          	auipc	a0,0x4
    3412:	e2a50513          	addi	a0,a0,-470 # 7238 <malloc+0x151e>
    3416:	00002097          	auipc	ra,0x2
    341a:	514080e7          	jalr	1300(ra) # 592a <open>
    341e:	84aa                	mv	s1,a0
  if(fd < 0){
    3420:	38054463          	bltz	a0,37a8 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3424:	660d                	lui	a2,0x3
    3426:	0000a597          	auipc	a1,0xa
    342a:	cf258593          	addi	a1,a1,-782 # d118 <buf>
    342e:	00002097          	auipc	ra,0x2
    3432:	4d4080e7          	jalr	1236(ra) # 5902 <read>
    3436:	4789                	li	a5,2
    3438:	38f51663          	bne	a0,a5,37c4 <subdir+0x55e>
  close(fd);
    343c:	8526                	mv	a0,s1
    343e:	00002097          	auipc	ra,0x2
    3442:	4d4080e7          	jalr	1236(ra) # 5912 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3446:	4581                	li	a1,0
    3448:	00004517          	auipc	a0,0x4
    344c:	d6850513          	addi	a0,a0,-664 # 71b0 <malloc+0x1496>
    3450:	00002097          	auipc	ra,0x2
    3454:	4da080e7          	jalr	1242(ra) # 592a <open>
    3458:	38055463          	bgez	a0,37e0 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    345c:	20200593          	li	a1,514
    3460:	00004517          	auipc	a0,0x4
    3464:	f6050513          	addi	a0,a0,-160 # 73c0 <malloc+0x16a6>
    3468:	00002097          	auipc	ra,0x2
    346c:	4c2080e7          	jalr	1218(ra) # 592a <open>
    3470:	38055663          	bgez	a0,37fc <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3474:	20200593          	li	a1,514
    3478:	00004517          	auipc	a0,0x4
    347c:	f7850513          	addi	a0,a0,-136 # 73f0 <malloc+0x16d6>
    3480:	00002097          	auipc	ra,0x2
    3484:	4aa080e7          	jalr	1194(ra) # 592a <open>
    3488:	38055863          	bgez	a0,3818 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    348c:	20000593          	li	a1,512
    3490:	00004517          	auipc	a0,0x4
    3494:	c8050513          	addi	a0,a0,-896 # 7110 <malloc+0x13f6>
    3498:	00002097          	auipc	ra,0x2
    349c:	492080e7          	jalr	1170(ra) # 592a <open>
    34a0:	38055a63          	bgez	a0,3834 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    34a4:	4589                	li	a1,2
    34a6:	00004517          	auipc	a0,0x4
    34aa:	c6a50513          	addi	a0,a0,-918 # 7110 <malloc+0x13f6>
    34ae:	00002097          	auipc	ra,0x2
    34b2:	47c080e7          	jalr	1148(ra) # 592a <open>
    34b6:	38055d63          	bgez	a0,3850 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    34ba:	4585                	li	a1,1
    34bc:	00004517          	auipc	a0,0x4
    34c0:	c5450513          	addi	a0,a0,-940 # 7110 <malloc+0x13f6>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	466080e7          	jalr	1126(ra) # 592a <open>
    34cc:	3a055063          	bgez	a0,386c <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    34d0:	00004597          	auipc	a1,0x4
    34d4:	fb058593          	addi	a1,a1,-80 # 7480 <malloc+0x1766>
    34d8:	00004517          	auipc	a0,0x4
    34dc:	ee850513          	addi	a0,a0,-280 # 73c0 <malloc+0x16a6>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	46a080e7          	jalr	1130(ra) # 594a <link>
    34e8:	3a050063          	beqz	a0,3888 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    34ec:	00004597          	auipc	a1,0x4
    34f0:	f9458593          	addi	a1,a1,-108 # 7480 <malloc+0x1766>
    34f4:	00004517          	auipc	a0,0x4
    34f8:	efc50513          	addi	a0,a0,-260 # 73f0 <malloc+0x16d6>
    34fc:	00002097          	auipc	ra,0x2
    3500:	44e080e7          	jalr	1102(ra) # 594a <link>
    3504:	3a050063          	beqz	a0,38a4 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3508:	00004597          	auipc	a1,0x4
    350c:	d3058593          	addi	a1,a1,-720 # 7238 <malloc+0x151e>
    3510:	00004517          	auipc	a0,0x4
    3514:	c2050513          	addi	a0,a0,-992 # 7130 <malloc+0x1416>
    3518:	00002097          	auipc	ra,0x2
    351c:	432080e7          	jalr	1074(ra) # 594a <link>
    3520:	3a050063          	beqz	a0,38c0 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3524:	00004517          	auipc	a0,0x4
    3528:	e9c50513          	addi	a0,a0,-356 # 73c0 <malloc+0x16a6>
    352c:	00002097          	auipc	ra,0x2
    3530:	426080e7          	jalr	1062(ra) # 5952 <mkdir>
    3534:	3a050463          	beqz	a0,38dc <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3538:	00004517          	auipc	a0,0x4
    353c:	eb850513          	addi	a0,a0,-328 # 73f0 <malloc+0x16d6>
    3540:	00002097          	auipc	ra,0x2
    3544:	412080e7          	jalr	1042(ra) # 5952 <mkdir>
    3548:	3a050863          	beqz	a0,38f8 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    354c:	00004517          	auipc	a0,0x4
    3550:	cec50513          	addi	a0,a0,-788 # 7238 <malloc+0x151e>
    3554:	00002097          	auipc	ra,0x2
    3558:	3fe080e7          	jalr	1022(ra) # 5952 <mkdir>
    355c:	3a050c63          	beqz	a0,3914 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3560:	00004517          	auipc	a0,0x4
    3564:	e9050513          	addi	a0,a0,-368 # 73f0 <malloc+0x16d6>
    3568:	00002097          	auipc	ra,0x2
    356c:	3d2080e7          	jalr	978(ra) # 593a <unlink>
    3570:	3c050063          	beqz	a0,3930 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3574:	00004517          	auipc	a0,0x4
    3578:	e4c50513          	addi	a0,a0,-436 # 73c0 <malloc+0x16a6>
    357c:	00002097          	auipc	ra,0x2
    3580:	3be080e7          	jalr	958(ra) # 593a <unlink>
    3584:	3c050463          	beqz	a0,394c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3588:	00004517          	auipc	a0,0x4
    358c:	ba850513          	addi	a0,a0,-1112 # 7130 <malloc+0x1416>
    3590:	00002097          	auipc	ra,0x2
    3594:	3ca080e7          	jalr	970(ra) # 595a <chdir>
    3598:	3c050863          	beqz	a0,3968 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    359c:	00004517          	auipc	a0,0x4
    35a0:	03450513          	addi	a0,a0,52 # 75d0 <malloc+0x18b6>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	3b6080e7          	jalr	950(ra) # 595a <chdir>
    35ac:	3c050c63          	beqz	a0,3984 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    35b0:	00004517          	auipc	a0,0x4
    35b4:	c8850513          	addi	a0,a0,-888 # 7238 <malloc+0x151e>
    35b8:	00002097          	auipc	ra,0x2
    35bc:	382080e7          	jalr	898(ra) # 593a <unlink>
    35c0:	3e051063          	bnez	a0,39a0 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    35c4:	00004517          	auipc	a0,0x4
    35c8:	b6c50513          	addi	a0,a0,-1172 # 7130 <malloc+0x1416>
    35cc:	00002097          	auipc	ra,0x2
    35d0:	36e080e7          	jalr	878(ra) # 593a <unlink>
    35d4:	3e051463          	bnez	a0,39bc <subdir+0x756>
  if(unlink("dd") == 0){
    35d8:	00004517          	auipc	a0,0x4
    35dc:	b3850513          	addi	a0,a0,-1224 # 7110 <malloc+0x13f6>
    35e0:	00002097          	auipc	ra,0x2
    35e4:	35a080e7          	jalr	858(ra) # 593a <unlink>
    35e8:	3e050863          	beqz	a0,39d8 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    35ec:	00004517          	auipc	a0,0x4
    35f0:	05450513          	addi	a0,a0,84 # 7640 <malloc+0x1926>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	346080e7          	jalr	838(ra) # 593a <unlink>
    35fc:	3e054c63          	bltz	a0,39f4 <subdir+0x78e>
  if(unlink("dd") < 0){
    3600:	00004517          	auipc	a0,0x4
    3604:	b1050513          	addi	a0,a0,-1264 # 7110 <malloc+0x13f6>
    3608:	00002097          	auipc	ra,0x2
    360c:	332080e7          	jalr	818(ra) # 593a <unlink>
    3610:	40054063          	bltz	a0,3a10 <subdir+0x7aa>
}
    3614:	60e2                	ld	ra,24(sp)
    3616:	6442                	ld	s0,16(sp)
    3618:	64a2                	ld	s1,8(sp)
    361a:	6902                	ld	s2,0(sp)
    361c:	6105                	addi	sp,sp,32
    361e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3620:	85ca                	mv	a1,s2
    3622:	00004517          	auipc	a0,0x4
    3626:	af650513          	addi	a0,a0,-1290 # 7118 <malloc+0x13fe>
    362a:	00002097          	auipc	ra,0x2
    362e:	638080e7          	jalr	1592(ra) # 5c62 <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	00002097          	auipc	ra,0x2
    3638:	2b6080e7          	jalr	694(ra) # 58ea <exit>
    printf("%s: create dd/ff failed\n", s);
    363c:	85ca                	mv	a1,s2
    363e:	00004517          	auipc	a0,0x4
    3642:	afa50513          	addi	a0,a0,-1286 # 7138 <malloc+0x141e>
    3646:	00002097          	auipc	ra,0x2
    364a:	61c080e7          	jalr	1564(ra) # 5c62 <printf>
    exit(1);
    364e:	4505                	li	a0,1
    3650:	00002097          	auipc	ra,0x2
    3654:	29a080e7          	jalr	666(ra) # 58ea <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3658:	85ca                	mv	a1,s2
    365a:	00004517          	auipc	a0,0x4
    365e:	afe50513          	addi	a0,a0,-1282 # 7158 <malloc+0x143e>
    3662:	00002097          	auipc	ra,0x2
    3666:	600080e7          	jalr	1536(ra) # 5c62 <printf>
    exit(1);
    366a:	4505                	li	a0,1
    366c:	00002097          	auipc	ra,0x2
    3670:	27e080e7          	jalr	638(ra) # 58ea <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3674:	85ca                	mv	a1,s2
    3676:	00004517          	auipc	a0,0x4
    367a:	b1a50513          	addi	a0,a0,-1254 # 7190 <malloc+0x1476>
    367e:	00002097          	auipc	ra,0x2
    3682:	5e4080e7          	jalr	1508(ra) # 5c62 <printf>
    exit(1);
    3686:	4505                	li	a0,1
    3688:	00002097          	auipc	ra,0x2
    368c:	262080e7          	jalr	610(ra) # 58ea <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3690:	85ca                	mv	a1,s2
    3692:	00004517          	auipc	a0,0x4
    3696:	b2e50513          	addi	a0,a0,-1234 # 71c0 <malloc+0x14a6>
    369a:	00002097          	auipc	ra,0x2
    369e:	5c8080e7          	jalr	1480(ra) # 5c62 <printf>
    exit(1);
    36a2:	4505                	li	a0,1
    36a4:	00002097          	auipc	ra,0x2
    36a8:	246080e7          	jalr	582(ra) # 58ea <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    36ac:	85ca                	mv	a1,s2
    36ae:	00004517          	auipc	a0,0x4
    36b2:	b4a50513          	addi	a0,a0,-1206 # 71f8 <malloc+0x14de>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	5ac080e7          	jalr	1452(ra) # 5c62 <printf>
    exit(1);
    36be:	4505                	li	a0,1
    36c0:	00002097          	auipc	ra,0x2
    36c4:	22a080e7          	jalr	554(ra) # 58ea <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    36c8:	85ca                	mv	a1,s2
    36ca:	00004517          	auipc	a0,0x4
    36ce:	b4e50513          	addi	a0,a0,-1202 # 7218 <malloc+0x14fe>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	590080e7          	jalr	1424(ra) # 5c62 <printf>
    exit(1);
    36da:	4505                	li	a0,1
    36dc:	00002097          	auipc	ra,0x2
    36e0:	20e080e7          	jalr	526(ra) # 58ea <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    36e4:	85ca                	mv	a1,s2
    36e6:	00004517          	auipc	a0,0x4
    36ea:	b6250513          	addi	a0,a0,-1182 # 7248 <malloc+0x152e>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	574080e7          	jalr	1396(ra) # 5c62 <printf>
    exit(1);
    36f6:	4505                	li	a0,1
    36f8:	00002097          	auipc	ra,0x2
    36fc:	1f2080e7          	jalr	498(ra) # 58ea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3700:	85ca                	mv	a1,s2
    3702:	00004517          	auipc	a0,0x4
    3706:	b6e50513          	addi	a0,a0,-1170 # 7270 <malloc+0x1556>
    370a:	00002097          	auipc	ra,0x2
    370e:	558080e7          	jalr	1368(ra) # 5c62 <printf>
    exit(1);
    3712:	4505                	li	a0,1
    3714:	00002097          	auipc	ra,0x2
    3718:	1d6080e7          	jalr	470(ra) # 58ea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    371c:	85ca                	mv	a1,s2
    371e:	00004517          	auipc	a0,0x4
    3722:	b7250513          	addi	a0,a0,-1166 # 7290 <malloc+0x1576>
    3726:	00002097          	auipc	ra,0x2
    372a:	53c080e7          	jalr	1340(ra) # 5c62 <printf>
    exit(1);
    372e:	4505                	li	a0,1
    3730:	00002097          	auipc	ra,0x2
    3734:	1ba080e7          	jalr	442(ra) # 58ea <exit>
    printf("%s: chdir dd failed\n", s);
    3738:	85ca                	mv	a1,s2
    373a:	00004517          	auipc	a0,0x4
    373e:	b7e50513          	addi	a0,a0,-1154 # 72b8 <malloc+0x159e>
    3742:	00002097          	auipc	ra,0x2
    3746:	520080e7          	jalr	1312(ra) # 5c62 <printf>
    exit(1);
    374a:	4505                	li	a0,1
    374c:	00002097          	auipc	ra,0x2
    3750:	19e080e7          	jalr	414(ra) # 58ea <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3754:	85ca                	mv	a1,s2
    3756:	00004517          	auipc	a0,0x4
    375a:	b8a50513          	addi	a0,a0,-1142 # 72e0 <malloc+0x15c6>
    375e:	00002097          	auipc	ra,0x2
    3762:	504080e7          	jalr	1284(ra) # 5c62 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	00002097          	auipc	ra,0x2
    376c:	182080e7          	jalr	386(ra) # 58ea <exit>
    printf("chdir dd/../../dd failed\n", s);
    3770:	85ca                	mv	a1,s2
    3772:	00004517          	auipc	a0,0x4
    3776:	b9e50513          	addi	a0,a0,-1122 # 7310 <malloc+0x15f6>
    377a:	00002097          	auipc	ra,0x2
    377e:	4e8080e7          	jalr	1256(ra) # 5c62 <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00002097          	auipc	ra,0x2
    3788:	166080e7          	jalr	358(ra) # 58ea <exit>
    printf("%s: chdir ./.. failed\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00004517          	auipc	a0,0x4
    3792:	baa50513          	addi	a0,a0,-1110 # 7338 <malloc+0x161e>
    3796:	00002097          	auipc	ra,0x2
    379a:	4cc080e7          	jalr	1228(ra) # 5c62 <printf>
    exit(1);
    379e:	4505                	li	a0,1
    37a0:	00002097          	auipc	ra,0x2
    37a4:	14a080e7          	jalr	330(ra) # 58ea <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    37a8:	85ca                	mv	a1,s2
    37aa:	00004517          	auipc	a0,0x4
    37ae:	ba650513          	addi	a0,a0,-1114 # 7350 <malloc+0x1636>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	4b0080e7          	jalr	1200(ra) # 5c62 <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	12e080e7          	jalr	302(ra) # 58ea <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    37c4:	85ca                	mv	a1,s2
    37c6:	00004517          	auipc	a0,0x4
    37ca:	baa50513          	addi	a0,a0,-1110 # 7370 <malloc+0x1656>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	494080e7          	jalr	1172(ra) # 5c62 <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	00002097          	auipc	ra,0x2
    37dc:	112080e7          	jalr	274(ra) # 58ea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00004517          	auipc	a0,0x4
    37e6:	bae50513          	addi	a0,a0,-1106 # 7390 <malloc+0x1676>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	478080e7          	jalr	1144(ra) # 5c62 <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	0f6080e7          	jalr	246(ra) # 58ea <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    37fc:	85ca                	mv	a1,s2
    37fe:	00004517          	auipc	a0,0x4
    3802:	bd250513          	addi	a0,a0,-1070 # 73d0 <malloc+0x16b6>
    3806:	00002097          	auipc	ra,0x2
    380a:	45c080e7          	jalr	1116(ra) # 5c62 <printf>
    exit(1);
    380e:	4505                	li	a0,1
    3810:	00002097          	auipc	ra,0x2
    3814:	0da080e7          	jalr	218(ra) # 58ea <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00004517          	auipc	a0,0x4
    381e:	be650513          	addi	a0,a0,-1050 # 7400 <malloc+0x16e6>
    3822:	00002097          	auipc	ra,0x2
    3826:	440080e7          	jalr	1088(ra) # 5c62 <printf>
    exit(1);
    382a:	4505                	li	a0,1
    382c:	00002097          	auipc	ra,0x2
    3830:	0be080e7          	jalr	190(ra) # 58ea <exit>
    printf("%s: create dd succeeded!\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00004517          	auipc	a0,0x4
    383a:	bea50513          	addi	a0,a0,-1046 # 7420 <malloc+0x1706>
    383e:	00002097          	auipc	ra,0x2
    3842:	424080e7          	jalr	1060(ra) # 5c62 <printf>
    exit(1);
    3846:	4505                	li	a0,1
    3848:	00002097          	auipc	ra,0x2
    384c:	0a2080e7          	jalr	162(ra) # 58ea <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3850:	85ca                	mv	a1,s2
    3852:	00004517          	auipc	a0,0x4
    3856:	bee50513          	addi	a0,a0,-1042 # 7440 <malloc+0x1726>
    385a:	00002097          	auipc	ra,0x2
    385e:	408080e7          	jalr	1032(ra) # 5c62 <printf>
    exit(1);
    3862:	4505                	li	a0,1
    3864:	00002097          	auipc	ra,0x2
    3868:	086080e7          	jalr	134(ra) # 58ea <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    386c:	85ca                	mv	a1,s2
    386e:	00004517          	auipc	a0,0x4
    3872:	bf250513          	addi	a0,a0,-1038 # 7460 <malloc+0x1746>
    3876:	00002097          	auipc	ra,0x2
    387a:	3ec080e7          	jalr	1004(ra) # 5c62 <printf>
    exit(1);
    387e:	4505                	li	a0,1
    3880:	00002097          	auipc	ra,0x2
    3884:	06a080e7          	jalr	106(ra) # 58ea <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3888:	85ca                	mv	a1,s2
    388a:	00004517          	auipc	a0,0x4
    388e:	c0650513          	addi	a0,a0,-1018 # 7490 <malloc+0x1776>
    3892:	00002097          	auipc	ra,0x2
    3896:	3d0080e7          	jalr	976(ra) # 5c62 <printf>
    exit(1);
    389a:	4505                	li	a0,1
    389c:	00002097          	auipc	ra,0x2
    38a0:	04e080e7          	jalr	78(ra) # 58ea <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    38a4:	85ca                	mv	a1,s2
    38a6:	00004517          	auipc	a0,0x4
    38aa:	c1250513          	addi	a0,a0,-1006 # 74b8 <malloc+0x179e>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	3b4080e7          	jalr	948(ra) # 5c62 <printf>
    exit(1);
    38b6:	4505                	li	a0,1
    38b8:	00002097          	auipc	ra,0x2
    38bc:	032080e7          	jalr	50(ra) # 58ea <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    38c0:	85ca                	mv	a1,s2
    38c2:	00004517          	auipc	a0,0x4
    38c6:	c1e50513          	addi	a0,a0,-994 # 74e0 <malloc+0x17c6>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	398080e7          	jalr	920(ra) # 5c62 <printf>
    exit(1);
    38d2:	4505                	li	a0,1
    38d4:	00002097          	auipc	ra,0x2
    38d8:	016080e7          	jalr	22(ra) # 58ea <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    38dc:	85ca                	mv	a1,s2
    38de:	00004517          	auipc	a0,0x4
    38e2:	c2a50513          	addi	a0,a0,-982 # 7508 <malloc+0x17ee>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	37c080e7          	jalr	892(ra) # 5c62 <printf>
    exit(1);
    38ee:	4505                	li	a0,1
    38f0:	00002097          	auipc	ra,0x2
    38f4:	ffa080e7          	jalr	-6(ra) # 58ea <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    38f8:	85ca                	mv	a1,s2
    38fa:	00004517          	auipc	a0,0x4
    38fe:	c2e50513          	addi	a0,a0,-978 # 7528 <malloc+0x180e>
    3902:	00002097          	auipc	ra,0x2
    3906:	360080e7          	jalr	864(ra) # 5c62 <printf>
    exit(1);
    390a:	4505                	li	a0,1
    390c:	00002097          	auipc	ra,0x2
    3910:	fde080e7          	jalr	-34(ra) # 58ea <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3914:	85ca                	mv	a1,s2
    3916:	00004517          	auipc	a0,0x4
    391a:	c3250513          	addi	a0,a0,-974 # 7548 <malloc+0x182e>
    391e:	00002097          	auipc	ra,0x2
    3922:	344080e7          	jalr	836(ra) # 5c62 <printf>
    exit(1);
    3926:	4505                	li	a0,1
    3928:	00002097          	auipc	ra,0x2
    392c:	fc2080e7          	jalr	-62(ra) # 58ea <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3930:	85ca                	mv	a1,s2
    3932:	00004517          	auipc	a0,0x4
    3936:	c3e50513          	addi	a0,a0,-962 # 7570 <malloc+0x1856>
    393a:	00002097          	auipc	ra,0x2
    393e:	328080e7          	jalr	808(ra) # 5c62 <printf>
    exit(1);
    3942:	4505                	li	a0,1
    3944:	00002097          	auipc	ra,0x2
    3948:	fa6080e7          	jalr	-90(ra) # 58ea <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    394c:	85ca                	mv	a1,s2
    394e:	00004517          	auipc	a0,0x4
    3952:	c4250513          	addi	a0,a0,-958 # 7590 <malloc+0x1876>
    3956:	00002097          	auipc	ra,0x2
    395a:	30c080e7          	jalr	780(ra) # 5c62 <printf>
    exit(1);
    395e:	4505                	li	a0,1
    3960:	00002097          	auipc	ra,0x2
    3964:	f8a080e7          	jalr	-118(ra) # 58ea <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3968:	85ca                	mv	a1,s2
    396a:	00004517          	auipc	a0,0x4
    396e:	c4650513          	addi	a0,a0,-954 # 75b0 <malloc+0x1896>
    3972:	00002097          	auipc	ra,0x2
    3976:	2f0080e7          	jalr	752(ra) # 5c62 <printf>
    exit(1);
    397a:	4505                	li	a0,1
    397c:	00002097          	auipc	ra,0x2
    3980:	f6e080e7          	jalr	-146(ra) # 58ea <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3984:	85ca                	mv	a1,s2
    3986:	00004517          	auipc	a0,0x4
    398a:	c5250513          	addi	a0,a0,-942 # 75d8 <malloc+0x18be>
    398e:	00002097          	auipc	ra,0x2
    3992:	2d4080e7          	jalr	724(ra) # 5c62 <printf>
    exit(1);
    3996:	4505                	li	a0,1
    3998:	00002097          	auipc	ra,0x2
    399c:	f52080e7          	jalr	-174(ra) # 58ea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    39a0:	85ca                	mv	a1,s2
    39a2:	00004517          	auipc	a0,0x4
    39a6:	8ce50513          	addi	a0,a0,-1842 # 7270 <malloc+0x1556>
    39aa:	00002097          	auipc	ra,0x2
    39ae:	2b8080e7          	jalr	696(ra) # 5c62 <printf>
    exit(1);
    39b2:	4505                	li	a0,1
    39b4:	00002097          	auipc	ra,0x2
    39b8:	f36080e7          	jalr	-202(ra) # 58ea <exit>
    printf("%s: unlink dd/ff failed\n", s);
    39bc:	85ca                	mv	a1,s2
    39be:	00004517          	auipc	a0,0x4
    39c2:	c3a50513          	addi	a0,a0,-966 # 75f8 <malloc+0x18de>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	29c080e7          	jalr	668(ra) # 5c62 <printf>
    exit(1);
    39ce:	4505                	li	a0,1
    39d0:	00002097          	auipc	ra,0x2
    39d4:	f1a080e7          	jalr	-230(ra) # 58ea <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    39d8:	85ca                	mv	a1,s2
    39da:	00004517          	auipc	a0,0x4
    39de:	c3e50513          	addi	a0,a0,-962 # 7618 <malloc+0x18fe>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	280080e7          	jalr	640(ra) # 5c62 <printf>
    exit(1);
    39ea:	4505                	li	a0,1
    39ec:	00002097          	auipc	ra,0x2
    39f0:	efe080e7          	jalr	-258(ra) # 58ea <exit>
    printf("%s: unlink dd/dd failed\n", s);
    39f4:	85ca                	mv	a1,s2
    39f6:	00004517          	auipc	a0,0x4
    39fa:	c5250513          	addi	a0,a0,-942 # 7648 <malloc+0x192e>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	264080e7          	jalr	612(ra) # 5c62 <printf>
    exit(1);
    3a06:	4505                	li	a0,1
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	ee2080e7          	jalr	-286(ra) # 58ea <exit>
    printf("%s: unlink dd failed\n", s);
    3a10:	85ca                	mv	a1,s2
    3a12:	00004517          	auipc	a0,0x4
    3a16:	c5650513          	addi	a0,a0,-938 # 7668 <malloc+0x194e>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	248080e7          	jalr	584(ra) # 5c62 <printf>
    exit(1);
    3a22:	4505                	li	a0,1
    3a24:	00002097          	auipc	ra,0x2
    3a28:	ec6080e7          	jalr	-314(ra) # 58ea <exit>

0000000000003a2c <rmdot>:
{
    3a2c:	1101                	addi	sp,sp,-32
    3a2e:	ec06                	sd	ra,24(sp)
    3a30:	e822                	sd	s0,16(sp)
    3a32:	e426                	sd	s1,8(sp)
    3a34:	1000                	addi	s0,sp,32
    3a36:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3a38:	00004517          	auipc	a0,0x4
    3a3c:	c4850513          	addi	a0,a0,-952 # 7680 <malloc+0x1966>
    3a40:	00002097          	auipc	ra,0x2
    3a44:	f12080e7          	jalr	-238(ra) # 5952 <mkdir>
    3a48:	e549                	bnez	a0,3ad2 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	c3650513          	addi	a0,a0,-970 # 7680 <malloc+0x1966>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	f08080e7          	jalr	-248(ra) # 595a <chdir>
    3a5a:	e951                	bnez	a0,3aee <rmdot+0xc2>
  if(unlink(".") == 0){
    3a5c:	00003517          	auipc	a0,0x3
    3a60:	ab450513          	addi	a0,a0,-1356 # 6510 <malloc+0x7f6>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	ed6080e7          	jalr	-298(ra) # 593a <unlink>
    3a6c:	cd59                	beqz	a0,3b0a <rmdot+0xde>
  if(unlink("..") == 0){
    3a6e:	00003517          	auipc	a0,0x3
    3a72:	66a50513          	addi	a0,a0,1642 # 70d8 <malloc+0x13be>
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	ec4080e7          	jalr	-316(ra) # 593a <unlink>
    3a7e:	c545                	beqz	a0,3b26 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a80:	00003517          	auipc	a0,0x3
    3a84:	60050513          	addi	a0,a0,1536 # 7080 <malloc+0x1366>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	ed2080e7          	jalr	-302(ra) # 595a <chdir>
    3a90:	e94d                	bnez	a0,3b42 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a92:	00004517          	auipc	a0,0x4
    3a96:	c5650513          	addi	a0,a0,-938 # 76e8 <malloc+0x19ce>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	ea0080e7          	jalr	-352(ra) # 593a <unlink>
    3aa2:	cd55                	beqz	a0,3b5e <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	c6c50513          	addi	a0,a0,-916 # 7710 <malloc+0x19f6>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	e8e080e7          	jalr	-370(ra) # 593a <unlink>
    3ab4:	c179                	beqz	a0,3b7a <rmdot+0x14e>
  if(unlink("dots") != 0){
    3ab6:	00004517          	auipc	a0,0x4
    3aba:	bca50513          	addi	a0,a0,-1078 # 7680 <malloc+0x1966>
    3abe:	00002097          	auipc	ra,0x2
    3ac2:	e7c080e7          	jalr	-388(ra) # 593a <unlink>
    3ac6:	e961                	bnez	a0,3b96 <rmdot+0x16a>
}
    3ac8:	60e2                	ld	ra,24(sp)
    3aca:	6442                	ld	s0,16(sp)
    3acc:	64a2                	ld	s1,8(sp)
    3ace:	6105                	addi	sp,sp,32
    3ad0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3ad2:	85a6                	mv	a1,s1
    3ad4:	00004517          	auipc	a0,0x4
    3ad8:	bb450513          	addi	a0,a0,-1100 # 7688 <malloc+0x196e>
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	186080e7          	jalr	390(ra) # 5c62 <printf>
    exit(1);
    3ae4:	4505                	li	a0,1
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	e04080e7          	jalr	-508(ra) # 58ea <exit>
    printf("%s: chdir dots failed\n", s);
    3aee:	85a6                	mv	a1,s1
    3af0:	00004517          	auipc	a0,0x4
    3af4:	bb050513          	addi	a0,a0,-1104 # 76a0 <malloc+0x1986>
    3af8:	00002097          	auipc	ra,0x2
    3afc:	16a080e7          	jalr	362(ra) # 5c62 <printf>
    exit(1);
    3b00:	4505                	li	a0,1
    3b02:	00002097          	auipc	ra,0x2
    3b06:	de8080e7          	jalr	-536(ra) # 58ea <exit>
    printf("%s: rm . worked!\n", s);
    3b0a:	85a6                	mv	a1,s1
    3b0c:	00004517          	auipc	a0,0x4
    3b10:	bac50513          	addi	a0,a0,-1108 # 76b8 <malloc+0x199e>
    3b14:	00002097          	auipc	ra,0x2
    3b18:	14e080e7          	jalr	334(ra) # 5c62 <printf>
    exit(1);
    3b1c:	4505                	li	a0,1
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	dcc080e7          	jalr	-564(ra) # 58ea <exit>
    printf("%s: rm .. worked!\n", s);
    3b26:	85a6                	mv	a1,s1
    3b28:	00004517          	auipc	a0,0x4
    3b2c:	ba850513          	addi	a0,a0,-1112 # 76d0 <malloc+0x19b6>
    3b30:	00002097          	auipc	ra,0x2
    3b34:	132080e7          	jalr	306(ra) # 5c62 <printf>
    exit(1);
    3b38:	4505                	li	a0,1
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	db0080e7          	jalr	-592(ra) # 58ea <exit>
    printf("%s: chdir / failed\n", s);
    3b42:	85a6                	mv	a1,s1
    3b44:	00003517          	auipc	a0,0x3
    3b48:	54450513          	addi	a0,a0,1348 # 7088 <malloc+0x136e>
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	116080e7          	jalr	278(ra) # 5c62 <printf>
    exit(1);
    3b54:	4505                	li	a0,1
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	d94080e7          	jalr	-620(ra) # 58ea <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b5e:	85a6                	mv	a1,s1
    3b60:	00004517          	auipc	a0,0x4
    3b64:	b9050513          	addi	a0,a0,-1136 # 76f0 <malloc+0x19d6>
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	0fa080e7          	jalr	250(ra) # 5c62 <printf>
    exit(1);
    3b70:	4505                	li	a0,1
    3b72:	00002097          	auipc	ra,0x2
    3b76:	d78080e7          	jalr	-648(ra) # 58ea <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b7a:	85a6                	mv	a1,s1
    3b7c:	00004517          	auipc	a0,0x4
    3b80:	b9c50513          	addi	a0,a0,-1124 # 7718 <malloc+0x19fe>
    3b84:	00002097          	auipc	ra,0x2
    3b88:	0de080e7          	jalr	222(ra) # 5c62 <printf>
    exit(1);
    3b8c:	4505                	li	a0,1
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	d5c080e7          	jalr	-676(ra) # 58ea <exit>
    printf("%s: unlink dots failed!\n", s);
    3b96:	85a6                	mv	a1,s1
    3b98:	00004517          	auipc	a0,0x4
    3b9c:	ba050513          	addi	a0,a0,-1120 # 7738 <malloc+0x1a1e>
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	0c2080e7          	jalr	194(ra) # 5c62 <printf>
    exit(1);
    3ba8:	4505                	li	a0,1
    3baa:	00002097          	auipc	ra,0x2
    3bae:	d40080e7          	jalr	-704(ra) # 58ea <exit>

0000000000003bb2 <dirfile>:
{
    3bb2:	1101                	addi	sp,sp,-32
    3bb4:	ec06                	sd	ra,24(sp)
    3bb6:	e822                	sd	s0,16(sp)
    3bb8:	e426                	sd	s1,8(sp)
    3bba:	e04a                	sd	s2,0(sp)
    3bbc:	1000                	addi	s0,sp,32
    3bbe:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3bc0:	20000593          	li	a1,512
    3bc4:	00004517          	auipc	a0,0x4
    3bc8:	b9450513          	addi	a0,a0,-1132 # 7758 <malloc+0x1a3e>
    3bcc:	00002097          	auipc	ra,0x2
    3bd0:	d5e080e7          	jalr	-674(ra) # 592a <open>
  if(fd < 0){
    3bd4:	0e054d63          	bltz	a0,3cce <dirfile+0x11c>
  close(fd);
    3bd8:	00002097          	auipc	ra,0x2
    3bdc:	d3a080e7          	jalr	-710(ra) # 5912 <close>
  if(chdir("dirfile") == 0){
    3be0:	00004517          	auipc	a0,0x4
    3be4:	b7850513          	addi	a0,a0,-1160 # 7758 <malloc+0x1a3e>
    3be8:	00002097          	auipc	ra,0x2
    3bec:	d72080e7          	jalr	-654(ra) # 595a <chdir>
    3bf0:	cd6d                	beqz	a0,3cea <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3bf2:	4581                	li	a1,0
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	bac50513          	addi	a0,a0,-1108 # 77a0 <malloc+0x1a86>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	d2e080e7          	jalr	-722(ra) # 592a <open>
  if(fd >= 0){
    3c04:	10055163          	bgez	a0,3d06 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3c08:	20000593          	li	a1,512
    3c0c:	00004517          	auipc	a0,0x4
    3c10:	b9450513          	addi	a0,a0,-1132 # 77a0 <malloc+0x1a86>
    3c14:	00002097          	auipc	ra,0x2
    3c18:	d16080e7          	jalr	-746(ra) # 592a <open>
  if(fd >= 0){
    3c1c:	10055363          	bgez	a0,3d22 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3c20:	00004517          	auipc	a0,0x4
    3c24:	b8050513          	addi	a0,a0,-1152 # 77a0 <malloc+0x1a86>
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	d2a080e7          	jalr	-726(ra) # 5952 <mkdir>
    3c30:	10050763          	beqz	a0,3d3e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3c34:	00004517          	auipc	a0,0x4
    3c38:	b6c50513          	addi	a0,a0,-1172 # 77a0 <malloc+0x1a86>
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	cfe080e7          	jalr	-770(ra) # 593a <unlink>
    3c44:	10050b63          	beqz	a0,3d5a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3c48:	00004597          	auipc	a1,0x4
    3c4c:	b5858593          	addi	a1,a1,-1192 # 77a0 <malloc+0x1a86>
    3c50:	00002517          	auipc	a0,0x2
    3c54:	3b050513          	addi	a0,a0,944 # 6000 <malloc+0x2e6>
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	cf2080e7          	jalr	-782(ra) # 594a <link>
    3c60:	10050b63          	beqz	a0,3d76 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c64:	00004517          	auipc	a0,0x4
    3c68:	af450513          	addi	a0,a0,-1292 # 7758 <malloc+0x1a3e>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	cce080e7          	jalr	-818(ra) # 593a <unlink>
    3c74:	10051f63          	bnez	a0,3d92 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c78:	4589                	li	a1,2
    3c7a:	00003517          	auipc	a0,0x3
    3c7e:	89650513          	addi	a0,a0,-1898 # 6510 <malloc+0x7f6>
    3c82:	00002097          	auipc	ra,0x2
    3c86:	ca8080e7          	jalr	-856(ra) # 592a <open>
  if(fd >= 0){
    3c8a:	12055263          	bgez	a0,3dae <dirfile+0x1fc>
  fd = open(".", 0);
    3c8e:	4581                	li	a1,0
    3c90:	00003517          	auipc	a0,0x3
    3c94:	88050513          	addi	a0,a0,-1920 # 6510 <malloc+0x7f6>
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	c92080e7          	jalr	-878(ra) # 592a <open>
    3ca0:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3ca2:	4605                	li	a2,1
    3ca4:	00002597          	auipc	a1,0x2
    3ca8:	22458593          	addi	a1,a1,548 # 5ec8 <malloc+0x1ae>
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	c5e080e7          	jalr	-930(ra) # 590a <write>
    3cb4:	10a04b63          	bgtz	a0,3dca <dirfile+0x218>
  close(fd);
    3cb8:	8526                	mv	a0,s1
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	c58080e7          	jalr	-936(ra) # 5912 <close>
}
    3cc2:	60e2                	ld	ra,24(sp)
    3cc4:	6442                	ld	s0,16(sp)
    3cc6:	64a2                	ld	s1,8(sp)
    3cc8:	6902                	ld	s2,0(sp)
    3cca:	6105                	addi	sp,sp,32
    3ccc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3cce:	85ca                	mv	a1,s2
    3cd0:	00004517          	auipc	a0,0x4
    3cd4:	a9050513          	addi	a0,a0,-1392 # 7760 <malloc+0x1a46>
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	f8a080e7          	jalr	-118(ra) # 5c62 <printf>
    exit(1);
    3ce0:	4505                	li	a0,1
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	c08080e7          	jalr	-1016(ra) # 58ea <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3cea:	85ca                	mv	a1,s2
    3cec:	00004517          	auipc	a0,0x4
    3cf0:	a9450513          	addi	a0,a0,-1388 # 7780 <malloc+0x1a66>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	f6e080e7          	jalr	-146(ra) # 5c62 <printf>
    exit(1);
    3cfc:	4505                	li	a0,1
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	bec080e7          	jalr	-1044(ra) # 58ea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3d06:	85ca                	mv	a1,s2
    3d08:	00004517          	auipc	a0,0x4
    3d0c:	aa850513          	addi	a0,a0,-1368 # 77b0 <malloc+0x1a96>
    3d10:	00002097          	auipc	ra,0x2
    3d14:	f52080e7          	jalr	-174(ra) # 5c62 <printf>
    exit(1);
    3d18:	4505                	li	a0,1
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	bd0080e7          	jalr	-1072(ra) # 58ea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3d22:	85ca                	mv	a1,s2
    3d24:	00004517          	auipc	a0,0x4
    3d28:	a8c50513          	addi	a0,a0,-1396 # 77b0 <malloc+0x1a96>
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	f36080e7          	jalr	-202(ra) # 5c62 <printf>
    exit(1);
    3d34:	4505                	li	a0,1
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	bb4080e7          	jalr	-1100(ra) # 58ea <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3d3e:	85ca                	mv	a1,s2
    3d40:	00004517          	auipc	a0,0x4
    3d44:	a9850513          	addi	a0,a0,-1384 # 77d8 <malloc+0x1abe>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	f1a080e7          	jalr	-230(ra) # 5c62 <printf>
    exit(1);
    3d50:	4505                	li	a0,1
    3d52:	00002097          	auipc	ra,0x2
    3d56:	b98080e7          	jalr	-1128(ra) # 58ea <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3d5a:	85ca                	mv	a1,s2
    3d5c:	00004517          	auipc	a0,0x4
    3d60:	aa450513          	addi	a0,a0,-1372 # 7800 <malloc+0x1ae6>
    3d64:	00002097          	auipc	ra,0x2
    3d68:	efe080e7          	jalr	-258(ra) # 5c62 <printf>
    exit(1);
    3d6c:	4505                	li	a0,1
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	b7c080e7          	jalr	-1156(ra) # 58ea <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d76:	85ca                	mv	a1,s2
    3d78:	00004517          	auipc	a0,0x4
    3d7c:	ab050513          	addi	a0,a0,-1360 # 7828 <malloc+0x1b0e>
    3d80:	00002097          	auipc	ra,0x2
    3d84:	ee2080e7          	jalr	-286(ra) # 5c62 <printf>
    exit(1);
    3d88:	4505                	li	a0,1
    3d8a:	00002097          	auipc	ra,0x2
    3d8e:	b60080e7          	jalr	-1184(ra) # 58ea <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d92:	85ca                	mv	a1,s2
    3d94:	00004517          	auipc	a0,0x4
    3d98:	abc50513          	addi	a0,a0,-1348 # 7850 <malloc+0x1b36>
    3d9c:	00002097          	auipc	ra,0x2
    3da0:	ec6080e7          	jalr	-314(ra) # 5c62 <printf>
    exit(1);
    3da4:	4505                	li	a0,1
    3da6:	00002097          	auipc	ra,0x2
    3daa:	b44080e7          	jalr	-1212(ra) # 58ea <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3dae:	85ca                	mv	a1,s2
    3db0:	00004517          	auipc	a0,0x4
    3db4:	ac050513          	addi	a0,a0,-1344 # 7870 <malloc+0x1b56>
    3db8:	00002097          	auipc	ra,0x2
    3dbc:	eaa080e7          	jalr	-342(ra) # 5c62 <printf>
    exit(1);
    3dc0:	4505                	li	a0,1
    3dc2:	00002097          	auipc	ra,0x2
    3dc6:	b28080e7          	jalr	-1240(ra) # 58ea <exit>
    printf("%s: write . succeeded!\n", s);
    3dca:	85ca                	mv	a1,s2
    3dcc:	00004517          	auipc	a0,0x4
    3dd0:	acc50513          	addi	a0,a0,-1332 # 7898 <malloc+0x1b7e>
    3dd4:	00002097          	auipc	ra,0x2
    3dd8:	e8e080e7          	jalr	-370(ra) # 5c62 <printf>
    exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	00002097          	auipc	ra,0x2
    3de2:	b0c080e7          	jalr	-1268(ra) # 58ea <exit>

0000000000003de6 <iref>:
{
    3de6:	7139                	addi	sp,sp,-64
    3de8:	fc06                	sd	ra,56(sp)
    3dea:	f822                	sd	s0,48(sp)
    3dec:	f426                	sd	s1,40(sp)
    3dee:	f04a                	sd	s2,32(sp)
    3df0:	ec4e                	sd	s3,24(sp)
    3df2:	e852                	sd	s4,16(sp)
    3df4:	e456                	sd	s5,8(sp)
    3df6:	e05a                	sd	s6,0(sp)
    3df8:	0080                	addi	s0,sp,64
    3dfa:	8b2a                	mv	s6,a0
    3dfc:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3e00:	00004a17          	auipc	s4,0x4
    3e04:	ab0a0a13          	addi	s4,s4,-1360 # 78b0 <malloc+0x1b96>
    mkdir("");
    3e08:	00003497          	auipc	s1,0x3
    3e0c:	5b048493          	addi	s1,s1,1456 # 73b8 <malloc+0x169e>
    link("README", "");
    3e10:	00002a97          	auipc	s5,0x2
    3e14:	1f0a8a93          	addi	s5,s5,496 # 6000 <malloc+0x2e6>
    fd = open("xx", O_CREATE);
    3e18:	00004997          	auipc	s3,0x4
    3e1c:	99098993          	addi	s3,s3,-1648 # 77a8 <malloc+0x1a8e>
    3e20:	a891                	j	3e74 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3e22:	85da                	mv	a1,s6
    3e24:	00004517          	auipc	a0,0x4
    3e28:	a9450513          	addi	a0,a0,-1388 # 78b8 <malloc+0x1b9e>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	e36080e7          	jalr	-458(ra) # 5c62 <printf>
      exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	ab4080e7          	jalr	-1356(ra) # 58ea <exit>
      printf("%s: chdir irefd failed\n", s);
    3e3e:	85da                	mv	a1,s6
    3e40:	00004517          	auipc	a0,0x4
    3e44:	a9050513          	addi	a0,a0,-1392 # 78d0 <malloc+0x1bb6>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	e1a080e7          	jalr	-486(ra) # 5c62 <printf>
      exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	a98080e7          	jalr	-1384(ra) # 58ea <exit>
      close(fd);
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	ab8080e7          	jalr	-1352(ra) # 5912 <close>
    3e62:	a889                	j	3eb4 <iref+0xce>
    unlink("xx");
    3e64:	854e                	mv	a0,s3
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	ad4080e7          	jalr	-1324(ra) # 593a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e6e:	397d                	addiw	s2,s2,-1
    3e70:	06090063          	beqz	s2,3ed0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e74:	8552                	mv	a0,s4
    3e76:	00002097          	auipc	ra,0x2
    3e7a:	adc080e7          	jalr	-1316(ra) # 5952 <mkdir>
    3e7e:	f155                	bnez	a0,3e22 <iref+0x3c>
    if(chdir("irefd") != 0){
    3e80:	8552                	mv	a0,s4
    3e82:	00002097          	auipc	ra,0x2
    3e86:	ad8080e7          	jalr	-1320(ra) # 595a <chdir>
    3e8a:	f955                	bnez	a0,3e3e <iref+0x58>
    mkdir("");
    3e8c:	8526                	mv	a0,s1
    3e8e:	00002097          	auipc	ra,0x2
    3e92:	ac4080e7          	jalr	-1340(ra) # 5952 <mkdir>
    link("README", "");
    3e96:	85a6                	mv	a1,s1
    3e98:	8556                	mv	a0,s5
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	ab0080e7          	jalr	-1360(ra) # 594a <link>
    fd = open("", O_CREATE);
    3ea2:	20000593          	li	a1,512
    3ea6:	8526                	mv	a0,s1
    3ea8:	00002097          	auipc	ra,0x2
    3eac:	a82080e7          	jalr	-1406(ra) # 592a <open>
    if(fd >= 0)
    3eb0:	fa0555e3          	bgez	a0,3e5a <iref+0x74>
    fd = open("xx", O_CREATE);
    3eb4:	20000593          	li	a1,512
    3eb8:	854e                	mv	a0,s3
    3eba:	00002097          	auipc	ra,0x2
    3ebe:	a70080e7          	jalr	-1424(ra) # 592a <open>
    if(fd >= 0)
    3ec2:	fa0541e3          	bltz	a0,3e64 <iref+0x7e>
      close(fd);
    3ec6:	00002097          	auipc	ra,0x2
    3eca:	a4c080e7          	jalr	-1460(ra) # 5912 <close>
    3ece:	bf59                	j	3e64 <iref+0x7e>
    3ed0:	03300493          	li	s1,51
    chdir("..");
    3ed4:	00003997          	auipc	s3,0x3
    3ed8:	20498993          	addi	s3,s3,516 # 70d8 <malloc+0x13be>
    unlink("irefd");
    3edc:	00004917          	auipc	s2,0x4
    3ee0:	9d490913          	addi	s2,s2,-1580 # 78b0 <malloc+0x1b96>
    chdir("..");
    3ee4:	854e                	mv	a0,s3
    3ee6:	00002097          	auipc	ra,0x2
    3eea:	a74080e7          	jalr	-1420(ra) # 595a <chdir>
    unlink("irefd");
    3eee:	854a                	mv	a0,s2
    3ef0:	00002097          	auipc	ra,0x2
    3ef4:	a4a080e7          	jalr	-1462(ra) # 593a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ef8:	34fd                	addiw	s1,s1,-1
    3efa:	f4ed                	bnez	s1,3ee4 <iref+0xfe>
  chdir("/");
    3efc:	00003517          	auipc	a0,0x3
    3f00:	18450513          	addi	a0,a0,388 # 7080 <malloc+0x1366>
    3f04:	00002097          	auipc	ra,0x2
    3f08:	a56080e7          	jalr	-1450(ra) # 595a <chdir>
}
    3f0c:	70e2                	ld	ra,56(sp)
    3f0e:	7442                	ld	s0,48(sp)
    3f10:	74a2                	ld	s1,40(sp)
    3f12:	7902                	ld	s2,32(sp)
    3f14:	69e2                	ld	s3,24(sp)
    3f16:	6a42                	ld	s4,16(sp)
    3f18:	6aa2                	ld	s5,8(sp)
    3f1a:	6b02                	ld	s6,0(sp)
    3f1c:	6121                	addi	sp,sp,64
    3f1e:	8082                	ret

0000000000003f20 <openiputtest>:
{
    3f20:	7179                	addi	sp,sp,-48
    3f22:	f406                	sd	ra,40(sp)
    3f24:	f022                	sd	s0,32(sp)
    3f26:	ec26                	sd	s1,24(sp)
    3f28:	1800                	addi	s0,sp,48
    3f2a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3f2c:	00004517          	auipc	a0,0x4
    3f30:	9bc50513          	addi	a0,a0,-1604 # 78e8 <malloc+0x1bce>
    3f34:	00002097          	auipc	ra,0x2
    3f38:	a1e080e7          	jalr	-1506(ra) # 5952 <mkdir>
    3f3c:	04054263          	bltz	a0,3f80 <openiputtest+0x60>
  pid = fork();
    3f40:	00002097          	auipc	ra,0x2
    3f44:	9a2080e7          	jalr	-1630(ra) # 58e2 <fork>
  if(pid < 0){
    3f48:	04054a63          	bltz	a0,3f9c <openiputtest+0x7c>
  if(pid == 0){
    3f4c:	e93d                	bnez	a0,3fc2 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3f4e:	4589                	li	a1,2
    3f50:	00004517          	auipc	a0,0x4
    3f54:	99850513          	addi	a0,a0,-1640 # 78e8 <malloc+0x1bce>
    3f58:	00002097          	auipc	ra,0x2
    3f5c:	9d2080e7          	jalr	-1582(ra) # 592a <open>
    if(fd >= 0){
    3f60:	04054c63          	bltz	a0,3fb8 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f64:	85a6                	mv	a1,s1
    3f66:	00004517          	auipc	a0,0x4
    3f6a:	9a250513          	addi	a0,a0,-1630 # 7908 <malloc+0x1bee>
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	cf4080e7          	jalr	-780(ra) # 5c62 <printf>
      exit(1);
    3f76:	4505                	li	a0,1
    3f78:	00002097          	auipc	ra,0x2
    3f7c:	972080e7          	jalr	-1678(ra) # 58ea <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f80:	85a6                	mv	a1,s1
    3f82:	00004517          	auipc	a0,0x4
    3f86:	96e50513          	addi	a0,a0,-1682 # 78f0 <malloc+0x1bd6>
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	cd8080e7          	jalr	-808(ra) # 5c62 <printf>
    exit(1);
    3f92:	4505                	li	a0,1
    3f94:	00002097          	auipc	ra,0x2
    3f98:	956080e7          	jalr	-1706(ra) # 58ea <exit>
    printf("%s: fork failed\n", s);
    3f9c:	85a6                	mv	a1,s1
    3f9e:	00002517          	auipc	a0,0x2
    3fa2:	71250513          	addi	a0,a0,1810 # 66b0 <malloc+0x996>
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	cbc080e7          	jalr	-836(ra) # 5c62 <printf>
    exit(1);
    3fae:	4505                	li	a0,1
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	93a080e7          	jalr	-1734(ra) # 58ea <exit>
    exit(0);
    3fb8:	4501                	li	a0,0
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	930080e7          	jalr	-1744(ra) # 58ea <exit>
  sleep(1);
    3fc2:	4505                	li	a0,1
    3fc4:	00002097          	auipc	ra,0x2
    3fc8:	9b6080e7          	jalr	-1610(ra) # 597a <sleep>
  if(unlink("oidir") != 0){
    3fcc:	00004517          	auipc	a0,0x4
    3fd0:	91c50513          	addi	a0,a0,-1764 # 78e8 <malloc+0x1bce>
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	966080e7          	jalr	-1690(ra) # 593a <unlink>
    3fdc:	cd19                	beqz	a0,3ffa <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3fde:	85a6                	mv	a1,s1
    3fe0:	00003517          	auipc	a0,0x3
    3fe4:	8c050513          	addi	a0,a0,-1856 # 68a0 <malloc+0xb86>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	c7a080e7          	jalr	-902(ra) # 5c62 <printf>
    exit(1);
    3ff0:	4505                	li	a0,1
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	8f8080e7          	jalr	-1800(ra) # 58ea <exit>
  wait(&xstatus);
    3ffa:	fdc40513          	addi	a0,s0,-36
    3ffe:	00002097          	auipc	ra,0x2
    4002:	8f4080e7          	jalr	-1804(ra) # 58f2 <wait>
  exit(xstatus);
    4006:	fdc42503          	lw	a0,-36(s0)
    400a:	00002097          	auipc	ra,0x2
    400e:	8e0080e7          	jalr	-1824(ra) # 58ea <exit>

0000000000004012 <forkforkfork>:
{
    4012:	1101                	addi	sp,sp,-32
    4014:	ec06                	sd	ra,24(sp)
    4016:	e822                	sd	s0,16(sp)
    4018:	e426                	sd	s1,8(sp)
    401a:	1000                	addi	s0,sp,32
    401c:	84aa                	mv	s1,a0
  unlink("stopforking");
    401e:	00004517          	auipc	a0,0x4
    4022:	91250513          	addi	a0,a0,-1774 # 7930 <malloc+0x1c16>
    4026:	00002097          	auipc	ra,0x2
    402a:	914080e7          	jalr	-1772(ra) # 593a <unlink>
  int pid = fork();
    402e:	00002097          	auipc	ra,0x2
    4032:	8b4080e7          	jalr	-1868(ra) # 58e2 <fork>
  if(pid < 0){
    4036:	04054563          	bltz	a0,4080 <forkforkfork+0x6e>
  if(pid == 0){
    403a:	c12d                	beqz	a0,409c <forkforkfork+0x8a>
  sleep(20); // two seconds
    403c:	4551                	li	a0,20
    403e:	00002097          	auipc	ra,0x2
    4042:	93c080e7          	jalr	-1732(ra) # 597a <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4046:	20200593          	li	a1,514
    404a:	00004517          	auipc	a0,0x4
    404e:	8e650513          	addi	a0,a0,-1818 # 7930 <malloc+0x1c16>
    4052:	00002097          	auipc	ra,0x2
    4056:	8d8080e7          	jalr	-1832(ra) # 592a <open>
    405a:	00002097          	auipc	ra,0x2
    405e:	8b8080e7          	jalr	-1864(ra) # 5912 <close>
  wait(0);
    4062:	4501                	li	a0,0
    4064:	00002097          	auipc	ra,0x2
    4068:	88e080e7          	jalr	-1906(ra) # 58f2 <wait>
  sleep(10); // one second
    406c:	4529                	li	a0,10
    406e:	00002097          	auipc	ra,0x2
    4072:	90c080e7          	jalr	-1780(ra) # 597a <sleep>
}
    4076:	60e2                	ld	ra,24(sp)
    4078:	6442                	ld	s0,16(sp)
    407a:	64a2                	ld	s1,8(sp)
    407c:	6105                	addi	sp,sp,32
    407e:	8082                	ret
    printf("%s: fork failed", s);
    4080:	85a6                	mv	a1,s1
    4082:	00002517          	auipc	a0,0x2
    4086:	7ee50513          	addi	a0,a0,2030 # 6870 <malloc+0xb56>
    408a:	00002097          	auipc	ra,0x2
    408e:	bd8080e7          	jalr	-1064(ra) # 5c62 <printf>
    exit(1);
    4092:	4505                	li	a0,1
    4094:	00002097          	auipc	ra,0x2
    4098:	856080e7          	jalr	-1962(ra) # 58ea <exit>
      int fd = open("stopforking", 0);
    409c:	00004497          	auipc	s1,0x4
    40a0:	89448493          	addi	s1,s1,-1900 # 7930 <malloc+0x1c16>
    40a4:	4581                	li	a1,0
    40a6:	8526                	mv	a0,s1
    40a8:	00002097          	auipc	ra,0x2
    40ac:	882080e7          	jalr	-1918(ra) # 592a <open>
      if(fd >= 0){
    40b0:	02055763          	bgez	a0,40de <forkforkfork+0xcc>
      if(fork() < 0){
    40b4:	00002097          	auipc	ra,0x2
    40b8:	82e080e7          	jalr	-2002(ra) # 58e2 <fork>
    40bc:	fe0554e3          	bgez	a0,40a4 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    40c0:	20200593          	li	a1,514
    40c4:	00004517          	auipc	a0,0x4
    40c8:	86c50513          	addi	a0,a0,-1940 # 7930 <malloc+0x1c16>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	85e080e7          	jalr	-1954(ra) # 592a <open>
    40d4:	00002097          	auipc	ra,0x2
    40d8:	83e080e7          	jalr	-1986(ra) # 5912 <close>
    40dc:	b7e1                	j	40a4 <forkforkfork+0x92>
        exit(0);
    40de:	4501                	li	a0,0
    40e0:	00002097          	auipc	ra,0x2
    40e4:	80a080e7          	jalr	-2038(ra) # 58ea <exit>

00000000000040e8 <killstatus>:
{
    40e8:	7139                	addi	sp,sp,-64
    40ea:	fc06                	sd	ra,56(sp)
    40ec:	f822                	sd	s0,48(sp)
    40ee:	f426                	sd	s1,40(sp)
    40f0:	f04a                	sd	s2,32(sp)
    40f2:	ec4e                	sd	s3,24(sp)
    40f4:	e852                	sd	s4,16(sp)
    40f6:	0080                	addi	s0,sp,64
    40f8:	8a2a                	mv	s4,a0
    40fa:	06400913          	li	s2,100
    if(xst != -1) {
    40fe:	59fd                	li	s3,-1
    int pid1 = fork();
    4100:	00001097          	auipc	ra,0x1
    4104:	7e2080e7          	jalr	2018(ra) # 58e2 <fork>
    4108:	84aa                	mv	s1,a0
    if(pid1 < 0){
    410a:	02054f63          	bltz	a0,4148 <killstatus+0x60>
    if(pid1 == 0){
    410e:	c939                	beqz	a0,4164 <killstatus+0x7c>
    sleep(1);
    4110:	4505                	li	a0,1
    4112:	00002097          	auipc	ra,0x2
    4116:	868080e7          	jalr	-1944(ra) # 597a <sleep>
    kill(pid1);
    411a:	8526                	mv	a0,s1
    411c:	00001097          	auipc	ra,0x1
    4120:	7fe080e7          	jalr	2046(ra) # 591a <kill>
    wait(&xst);
    4124:	fcc40513          	addi	a0,s0,-52
    4128:	00001097          	auipc	ra,0x1
    412c:	7ca080e7          	jalr	1994(ra) # 58f2 <wait>
    if(xst != -1) {
    4130:	fcc42783          	lw	a5,-52(s0)
    4134:	03379d63          	bne	a5,s3,416e <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4138:	397d                	addiw	s2,s2,-1
    413a:	fc0913e3          	bnez	s2,4100 <killstatus+0x18>
  exit(0);
    413e:	4501                	li	a0,0
    4140:	00001097          	auipc	ra,0x1
    4144:	7aa080e7          	jalr	1962(ra) # 58ea <exit>
      printf("%s: fork failed\n", s);
    4148:	85d2                	mv	a1,s4
    414a:	00002517          	auipc	a0,0x2
    414e:	56650513          	addi	a0,a0,1382 # 66b0 <malloc+0x996>
    4152:	00002097          	auipc	ra,0x2
    4156:	b10080e7          	jalr	-1264(ra) # 5c62 <printf>
      exit(1);
    415a:	4505                	li	a0,1
    415c:	00001097          	auipc	ra,0x1
    4160:	78e080e7          	jalr	1934(ra) # 58ea <exit>
        getpid();
    4164:	00002097          	auipc	ra,0x2
    4168:	806080e7          	jalr	-2042(ra) # 596a <getpid>
      while(1) {
    416c:	bfe5                	j	4164 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    416e:	85d2                	mv	a1,s4
    4170:	00003517          	auipc	a0,0x3
    4174:	7d050513          	addi	a0,a0,2000 # 7940 <malloc+0x1c26>
    4178:	00002097          	auipc	ra,0x2
    417c:	aea080e7          	jalr	-1302(ra) # 5c62 <printf>
       exit(1);
    4180:	4505                	li	a0,1
    4182:	00001097          	auipc	ra,0x1
    4186:	768080e7          	jalr	1896(ra) # 58ea <exit>

000000000000418a <preempt>:
{
    418a:	7139                	addi	sp,sp,-64
    418c:	fc06                	sd	ra,56(sp)
    418e:	f822                	sd	s0,48(sp)
    4190:	f426                	sd	s1,40(sp)
    4192:	f04a                	sd	s2,32(sp)
    4194:	ec4e                	sd	s3,24(sp)
    4196:	e852                	sd	s4,16(sp)
    4198:	0080                	addi	s0,sp,64
    419a:	892a                	mv	s2,a0
  pid1 = fork();
    419c:	00001097          	auipc	ra,0x1
    41a0:	746080e7          	jalr	1862(ra) # 58e2 <fork>
  if(pid1 < 0) {
    41a4:	00054563          	bltz	a0,41ae <preempt+0x24>
    41a8:	84aa                	mv	s1,a0
  if(pid1 == 0)
    41aa:	e105                	bnez	a0,41ca <preempt+0x40>
    for(;;)
    41ac:	a001                	j	41ac <preempt+0x22>
    printf("%s: fork failed", s);
    41ae:	85ca                	mv	a1,s2
    41b0:	00002517          	auipc	a0,0x2
    41b4:	6c050513          	addi	a0,a0,1728 # 6870 <malloc+0xb56>
    41b8:	00002097          	auipc	ra,0x2
    41bc:	aaa080e7          	jalr	-1366(ra) # 5c62 <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00001097          	auipc	ra,0x1
    41c6:	728080e7          	jalr	1832(ra) # 58ea <exit>
  pid2 = fork();
    41ca:	00001097          	auipc	ra,0x1
    41ce:	718080e7          	jalr	1816(ra) # 58e2 <fork>
    41d2:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    41d4:	00054463          	bltz	a0,41dc <preempt+0x52>
  if(pid2 == 0)
    41d8:	e105                	bnez	a0,41f8 <preempt+0x6e>
    for(;;)
    41da:	a001                	j	41da <preempt+0x50>
    printf("%s: fork failed\n", s);
    41dc:	85ca                	mv	a1,s2
    41de:	00002517          	auipc	a0,0x2
    41e2:	4d250513          	addi	a0,a0,1234 # 66b0 <malloc+0x996>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	a7c080e7          	jalr	-1412(ra) # 5c62 <printf>
    exit(1);
    41ee:	4505                	li	a0,1
    41f0:	00001097          	auipc	ra,0x1
    41f4:	6fa080e7          	jalr	1786(ra) # 58ea <exit>
  pipe(pfds);
    41f8:	fc840513          	addi	a0,s0,-56
    41fc:	00001097          	auipc	ra,0x1
    4200:	6fe080e7          	jalr	1790(ra) # 58fa <pipe>
  pid3 = fork();
    4204:	00001097          	auipc	ra,0x1
    4208:	6de080e7          	jalr	1758(ra) # 58e2 <fork>
    420c:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    420e:	02054e63          	bltz	a0,424a <preempt+0xc0>
  if(pid3 == 0){
    4212:	e525                	bnez	a0,427a <preempt+0xf0>
    close(pfds[0]);
    4214:	fc842503          	lw	a0,-56(s0)
    4218:	00001097          	auipc	ra,0x1
    421c:	6fa080e7          	jalr	1786(ra) # 5912 <close>
    if(write(pfds[1], "x", 1) != 1)
    4220:	4605                	li	a2,1
    4222:	00002597          	auipc	a1,0x2
    4226:	ca658593          	addi	a1,a1,-858 # 5ec8 <malloc+0x1ae>
    422a:	fcc42503          	lw	a0,-52(s0)
    422e:	00001097          	auipc	ra,0x1
    4232:	6dc080e7          	jalr	1756(ra) # 590a <write>
    4236:	4785                	li	a5,1
    4238:	02f51763          	bne	a0,a5,4266 <preempt+0xdc>
    close(pfds[1]);
    423c:	fcc42503          	lw	a0,-52(s0)
    4240:	00001097          	auipc	ra,0x1
    4244:	6d2080e7          	jalr	1746(ra) # 5912 <close>
    for(;;)
    4248:	a001                	j	4248 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    424a:	85ca                	mv	a1,s2
    424c:	00002517          	auipc	a0,0x2
    4250:	46450513          	addi	a0,a0,1124 # 66b0 <malloc+0x996>
    4254:	00002097          	auipc	ra,0x2
    4258:	a0e080e7          	jalr	-1522(ra) # 5c62 <printf>
     exit(1);
    425c:	4505                	li	a0,1
    425e:	00001097          	auipc	ra,0x1
    4262:	68c080e7          	jalr	1676(ra) # 58ea <exit>
      printf("%s: preempt write error", s);
    4266:	85ca                	mv	a1,s2
    4268:	00003517          	auipc	a0,0x3
    426c:	6f850513          	addi	a0,a0,1784 # 7960 <malloc+0x1c46>
    4270:	00002097          	auipc	ra,0x2
    4274:	9f2080e7          	jalr	-1550(ra) # 5c62 <printf>
    4278:	b7d1                	j	423c <preempt+0xb2>
  close(pfds[1]);
    427a:	fcc42503          	lw	a0,-52(s0)
    427e:	00001097          	auipc	ra,0x1
    4282:	694080e7          	jalr	1684(ra) # 5912 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4286:	660d                	lui	a2,0x3
    4288:	00009597          	auipc	a1,0x9
    428c:	e9058593          	addi	a1,a1,-368 # d118 <buf>
    4290:	fc842503          	lw	a0,-56(s0)
    4294:	00001097          	auipc	ra,0x1
    4298:	66e080e7          	jalr	1646(ra) # 5902 <read>
    429c:	4785                	li	a5,1
    429e:	02f50363          	beq	a0,a5,42c4 <preempt+0x13a>
    printf("%s: preempt read error", s);
    42a2:	85ca                	mv	a1,s2
    42a4:	00003517          	auipc	a0,0x3
    42a8:	6d450513          	addi	a0,a0,1748 # 7978 <malloc+0x1c5e>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	9b6080e7          	jalr	-1610(ra) # 5c62 <printf>
}
    42b4:	70e2                	ld	ra,56(sp)
    42b6:	7442                	ld	s0,48(sp)
    42b8:	74a2                	ld	s1,40(sp)
    42ba:	7902                	ld	s2,32(sp)
    42bc:	69e2                	ld	s3,24(sp)
    42be:	6a42                	ld	s4,16(sp)
    42c0:	6121                	addi	sp,sp,64
    42c2:	8082                	ret
  close(pfds[0]);
    42c4:	fc842503          	lw	a0,-56(s0)
    42c8:	00001097          	auipc	ra,0x1
    42cc:	64a080e7          	jalr	1610(ra) # 5912 <close>
  printf("kill... ");
    42d0:	00003517          	auipc	a0,0x3
    42d4:	6c050513          	addi	a0,a0,1728 # 7990 <malloc+0x1c76>
    42d8:	00002097          	auipc	ra,0x2
    42dc:	98a080e7          	jalr	-1654(ra) # 5c62 <printf>
  kill(pid1);
    42e0:	8526                	mv	a0,s1
    42e2:	00001097          	auipc	ra,0x1
    42e6:	638080e7          	jalr	1592(ra) # 591a <kill>
  kill(pid2);
    42ea:	854e                	mv	a0,s3
    42ec:	00001097          	auipc	ra,0x1
    42f0:	62e080e7          	jalr	1582(ra) # 591a <kill>
  kill(pid3);
    42f4:	8552                	mv	a0,s4
    42f6:	00001097          	auipc	ra,0x1
    42fa:	624080e7          	jalr	1572(ra) # 591a <kill>
  printf("wait... ");
    42fe:	00003517          	auipc	a0,0x3
    4302:	6a250513          	addi	a0,a0,1698 # 79a0 <malloc+0x1c86>
    4306:	00002097          	auipc	ra,0x2
    430a:	95c080e7          	jalr	-1700(ra) # 5c62 <printf>
  wait(0);
    430e:	4501                	li	a0,0
    4310:	00001097          	auipc	ra,0x1
    4314:	5e2080e7          	jalr	1506(ra) # 58f2 <wait>
  wait(0);
    4318:	4501                	li	a0,0
    431a:	00001097          	auipc	ra,0x1
    431e:	5d8080e7          	jalr	1496(ra) # 58f2 <wait>
  wait(0);
    4322:	4501                	li	a0,0
    4324:	00001097          	auipc	ra,0x1
    4328:	5ce080e7          	jalr	1486(ra) # 58f2 <wait>
    432c:	b761                	j	42b4 <preempt+0x12a>

000000000000432e <reparent>:
{
    432e:	7179                	addi	sp,sp,-48
    4330:	f406                	sd	ra,40(sp)
    4332:	f022                	sd	s0,32(sp)
    4334:	ec26                	sd	s1,24(sp)
    4336:	e84a                	sd	s2,16(sp)
    4338:	e44e                	sd	s3,8(sp)
    433a:	e052                	sd	s4,0(sp)
    433c:	1800                	addi	s0,sp,48
    433e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4340:	00001097          	auipc	ra,0x1
    4344:	62a080e7          	jalr	1578(ra) # 596a <getpid>
    4348:	8a2a                	mv	s4,a0
    434a:	0c800913          	li	s2,200
    int pid = fork();
    434e:	00001097          	auipc	ra,0x1
    4352:	594080e7          	jalr	1428(ra) # 58e2 <fork>
    4356:	84aa                	mv	s1,a0
    if(pid < 0){
    4358:	02054263          	bltz	a0,437c <reparent+0x4e>
    if(pid){
    435c:	cd21                	beqz	a0,43b4 <reparent+0x86>
      if(wait(0) != pid){
    435e:	4501                	li	a0,0
    4360:	00001097          	auipc	ra,0x1
    4364:	592080e7          	jalr	1426(ra) # 58f2 <wait>
    4368:	02951863          	bne	a0,s1,4398 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    436c:	397d                	addiw	s2,s2,-1
    436e:	fe0910e3          	bnez	s2,434e <reparent+0x20>
  exit(0);
    4372:	4501                	li	a0,0
    4374:	00001097          	auipc	ra,0x1
    4378:	576080e7          	jalr	1398(ra) # 58ea <exit>
      printf("%s: fork failed\n", s);
    437c:	85ce                	mv	a1,s3
    437e:	00002517          	auipc	a0,0x2
    4382:	33250513          	addi	a0,a0,818 # 66b0 <malloc+0x996>
    4386:	00002097          	auipc	ra,0x2
    438a:	8dc080e7          	jalr	-1828(ra) # 5c62 <printf>
      exit(1);
    438e:	4505                	li	a0,1
    4390:	00001097          	auipc	ra,0x1
    4394:	55a080e7          	jalr	1370(ra) # 58ea <exit>
        printf("%s: wait wrong pid\n", s);
    4398:	85ce                	mv	a1,s3
    439a:	00002517          	auipc	a0,0x2
    439e:	49e50513          	addi	a0,a0,1182 # 6838 <malloc+0xb1e>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	8c0080e7          	jalr	-1856(ra) # 5c62 <printf>
        exit(1);
    43aa:	4505                	li	a0,1
    43ac:	00001097          	auipc	ra,0x1
    43b0:	53e080e7          	jalr	1342(ra) # 58ea <exit>
      int pid2 = fork();
    43b4:	00001097          	auipc	ra,0x1
    43b8:	52e080e7          	jalr	1326(ra) # 58e2 <fork>
      if(pid2 < 0){
    43bc:	00054763          	bltz	a0,43ca <reparent+0x9c>
      exit(0);
    43c0:	4501                	li	a0,0
    43c2:	00001097          	auipc	ra,0x1
    43c6:	528080e7          	jalr	1320(ra) # 58ea <exit>
        kill(master_pid);
    43ca:	8552                	mv	a0,s4
    43cc:	00001097          	auipc	ra,0x1
    43d0:	54e080e7          	jalr	1358(ra) # 591a <kill>
        exit(1);
    43d4:	4505                	li	a0,1
    43d6:	00001097          	auipc	ra,0x1
    43da:	514080e7          	jalr	1300(ra) # 58ea <exit>

00000000000043de <sbrkfail>:
{
    43de:	7119                	addi	sp,sp,-128
    43e0:	fc86                	sd	ra,120(sp)
    43e2:	f8a2                	sd	s0,112(sp)
    43e4:	f4a6                	sd	s1,104(sp)
    43e6:	f0ca                	sd	s2,96(sp)
    43e8:	ecce                	sd	s3,88(sp)
    43ea:	e8d2                	sd	s4,80(sp)
    43ec:	e4d6                	sd	s5,72(sp)
    43ee:	0100                	addi	s0,sp,128
    43f0:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    43f2:	fb040513          	addi	a0,s0,-80
    43f6:	00001097          	auipc	ra,0x1
    43fa:	504080e7          	jalr	1284(ra) # 58fa <pipe>
    43fe:	e901                	bnez	a0,440e <sbrkfail+0x30>
    4400:	f8040493          	addi	s1,s0,-128
    4404:	fa840993          	addi	s3,s0,-88
    4408:	8926                	mv	s2,s1
    if(pids[i] != -1)
    440a:	5a7d                	li	s4,-1
    440c:	a085                	j	446c <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    440e:	85d6                	mv	a1,s5
    4410:	00002517          	auipc	a0,0x2
    4414:	3a850513          	addi	a0,a0,936 # 67b8 <malloc+0xa9e>
    4418:	00002097          	auipc	ra,0x2
    441c:	84a080e7          	jalr	-1974(ra) # 5c62 <printf>
    exit(1);
    4420:	4505                	li	a0,1
    4422:	00001097          	auipc	ra,0x1
    4426:	4c8080e7          	jalr	1224(ra) # 58ea <exit>
      sbrk(BIG - (uint64)sbrk(0));
    442a:	00001097          	auipc	ra,0x1
    442e:	548080e7          	jalr	1352(ra) # 5972 <sbrk>
    4432:	064007b7          	lui	a5,0x6400
    4436:	40a7853b          	subw	a0,a5,a0
    443a:	00001097          	auipc	ra,0x1
    443e:	538080e7          	jalr	1336(ra) # 5972 <sbrk>
      write(fds[1], "x", 1);
    4442:	4605                	li	a2,1
    4444:	00002597          	auipc	a1,0x2
    4448:	a8458593          	addi	a1,a1,-1404 # 5ec8 <malloc+0x1ae>
    444c:	fb442503          	lw	a0,-76(s0)
    4450:	00001097          	auipc	ra,0x1
    4454:	4ba080e7          	jalr	1210(ra) # 590a <write>
      for(;;) sleep(1000);
    4458:	3e800513          	li	a0,1000
    445c:	00001097          	auipc	ra,0x1
    4460:	51e080e7          	jalr	1310(ra) # 597a <sleep>
    4464:	bfd5                	j	4458 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4466:	0911                	addi	s2,s2,4
    4468:	03390563          	beq	s2,s3,4492 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    446c:	00001097          	auipc	ra,0x1
    4470:	476080e7          	jalr	1142(ra) # 58e2 <fork>
    4474:	00a92023          	sw	a0,0(s2)
    4478:	d94d                	beqz	a0,442a <sbrkfail+0x4c>
    if(pids[i] != -1)
    447a:	ff4506e3          	beq	a0,s4,4466 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    447e:	4605                	li	a2,1
    4480:	faf40593          	addi	a1,s0,-81
    4484:	fb042503          	lw	a0,-80(s0)
    4488:	00001097          	auipc	ra,0x1
    448c:	47a080e7          	jalr	1146(ra) # 5902 <read>
    4490:	bfd9                	j	4466 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4492:	6505                	lui	a0,0x1
    4494:	00001097          	auipc	ra,0x1
    4498:	4de080e7          	jalr	1246(ra) # 5972 <sbrk>
    449c:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    449e:	597d                	li	s2,-1
    44a0:	a021                	j	44a8 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    44a2:	0491                	addi	s1,s1,4
    44a4:	01348f63          	beq	s1,s3,44c2 <sbrkfail+0xe4>
    if(pids[i] == -1)
    44a8:	4088                	lw	a0,0(s1)
    44aa:	ff250ce3          	beq	a0,s2,44a2 <sbrkfail+0xc4>
    kill(pids[i]);
    44ae:	00001097          	auipc	ra,0x1
    44b2:	46c080e7          	jalr	1132(ra) # 591a <kill>
    wait(0);
    44b6:	4501                	li	a0,0
    44b8:	00001097          	auipc	ra,0x1
    44bc:	43a080e7          	jalr	1082(ra) # 58f2 <wait>
    44c0:	b7cd                	j	44a2 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    44c2:	57fd                	li	a5,-1
    44c4:	04fa0163          	beq	s4,a5,4506 <sbrkfail+0x128>
  pid = fork();
    44c8:	00001097          	auipc	ra,0x1
    44cc:	41a080e7          	jalr	1050(ra) # 58e2 <fork>
    44d0:	84aa                	mv	s1,a0
  if(pid < 0){
    44d2:	04054863          	bltz	a0,4522 <sbrkfail+0x144>
  if(pid == 0){
    44d6:	c525                	beqz	a0,453e <sbrkfail+0x160>
  wait(&xstatus);
    44d8:	fbc40513          	addi	a0,s0,-68
    44dc:	00001097          	auipc	ra,0x1
    44e0:	416080e7          	jalr	1046(ra) # 58f2 <wait>
  if(xstatus != -1 && xstatus != 2)
    44e4:	fbc42783          	lw	a5,-68(s0)
    44e8:	577d                	li	a4,-1
    44ea:	00e78563          	beq	a5,a4,44f4 <sbrkfail+0x116>
    44ee:	4709                	li	a4,2
    44f0:	08e79d63          	bne	a5,a4,458a <sbrkfail+0x1ac>
}
    44f4:	70e6                	ld	ra,120(sp)
    44f6:	7446                	ld	s0,112(sp)
    44f8:	74a6                	ld	s1,104(sp)
    44fa:	7906                	ld	s2,96(sp)
    44fc:	69e6                	ld	s3,88(sp)
    44fe:	6a46                	ld	s4,80(sp)
    4500:	6aa6                	ld	s5,72(sp)
    4502:	6109                	addi	sp,sp,128
    4504:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4506:	85d6                	mv	a1,s5
    4508:	00003517          	auipc	a0,0x3
    450c:	4a850513          	addi	a0,a0,1192 # 79b0 <malloc+0x1c96>
    4510:	00001097          	auipc	ra,0x1
    4514:	752080e7          	jalr	1874(ra) # 5c62 <printf>
    exit(1);
    4518:	4505                	li	a0,1
    451a:	00001097          	auipc	ra,0x1
    451e:	3d0080e7          	jalr	976(ra) # 58ea <exit>
    printf("%s: fork failed\n", s);
    4522:	85d6                	mv	a1,s5
    4524:	00002517          	auipc	a0,0x2
    4528:	18c50513          	addi	a0,a0,396 # 66b0 <malloc+0x996>
    452c:	00001097          	auipc	ra,0x1
    4530:	736080e7          	jalr	1846(ra) # 5c62 <printf>
    exit(1);
    4534:	4505                	li	a0,1
    4536:	00001097          	auipc	ra,0x1
    453a:	3b4080e7          	jalr	948(ra) # 58ea <exit>
    a = sbrk(0);
    453e:	4501                	li	a0,0
    4540:	00001097          	auipc	ra,0x1
    4544:	432080e7          	jalr	1074(ra) # 5972 <sbrk>
    4548:	892a                	mv	s2,a0
    sbrk(10*BIG);
    454a:	3e800537          	lui	a0,0x3e800
    454e:	00001097          	auipc	ra,0x1
    4552:	424080e7          	jalr	1060(ra) # 5972 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4556:	87ca                	mv	a5,s2
    4558:	3e800737          	lui	a4,0x3e800
    455c:	993a                	add	s2,s2,a4
    455e:	6705                	lui	a4,0x1
      n += *(a+i);
    4560:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63efed8>
    4564:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4566:	97ba                	add	a5,a5,a4
    4568:	fef91ce3          	bne	s2,a5,4560 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    456c:	8626                	mv	a2,s1
    456e:	85d6                	mv	a1,s5
    4570:	00003517          	auipc	a0,0x3
    4574:	46050513          	addi	a0,a0,1120 # 79d0 <malloc+0x1cb6>
    4578:	00001097          	auipc	ra,0x1
    457c:	6ea080e7          	jalr	1770(ra) # 5c62 <printf>
    exit(1);
    4580:	4505                	li	a0,1
    4582:	00001097          	auipc	ra,0x1
    4586:	368080e7          	jalr	872(ra) # 58ea <exit>
    exit(1);
    458a:	4505                	li	a0,1
    458c:	00001097          	auipc	ra,0x1
    4590:	35e080e7          	jalr	862(ra) # 58ea <exit>

0000000000004594 <mem>:
{
    4594:	7139                	addi	sp,sp,-64
    4596:	fc06                	sd	ra,56(sp)
    4598:	f822                	sd	s0,48(sp)
    459a:	f426                	sd	s1,40(sp)
    459c:	f04a                	sd	s2,32(sp)
    459e:	ec4e                	sd	s3,24(sp)
    45a0:	0080                	addi	s0,sp,64
    45a2:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    45a4:	00001097          	auipc	ra,0x1
    45a8:	33e080e7          	jalr	830(ra) # 58e2 <fork>
    m1 = 0;
    45ac:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    45ae:	6909                	lui	s2,0x2
    45b0:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x6b>
  if((pid = fork()) == 0){
    45b4:	c115                	beqz	a0,45d8 <mem+0x44>
    wait(&xstatus);
    45b6:	fcc40513          	addi	a0,s0,-52
    45ba:	00001097          	auipc	ra,0x1
    45be:	338080e7          	jalr	824(ra) # 58f2 <wait>
    if(xstatus == -1){
    45c2:	fcc42503          	lw	a0,-52(s0)
    45c6:	57fd                	li	a5,-1
    45c8:	06f50363          	beq	a0,a5,462e <mem+0x9a>
    exit(xstatus);
    45cc:	00001097          	auipc	ra,0x1
    45d0:	31e080e7          	jalr	798(ra) # 58ea <exit>
      *(char**)m2 = m1;
    45d4:	e104                	sd	s1,0(a0)
      m1 = m2;
    45d6:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    45d8:	854a                	mv	a0,s2
    45da:	00001097          	auipc	ra,0x1
    45de:	740080e7          	jalr	1856(ra) # 5d1a <malloc>
    45e2:	f96d                	bnez	a0,45d4 <mem+0x40>
    while(m1){
    45e4:	c881                	beqz	s1,45f4 <mem+0x60>
      m2 = *(char**)m1;
    45e6:	8526                	mv	a0,s1
    45e8:	6084                	ld	s1,0(s1)
      free(m1);
    45ea:	00001097          	auipc	ra,0x1
    45ee:	6ae080e7          	jalr	1710(ra) # 5c98 <free>
    while(m1){
    45f2:	f8f5                	bnez	s1,45e6 <mem+0x52>
    m1 = malloc(1024*20);
    45f4:	6515                	lui	a0,0x5
    45f6:	00001097          	auipc	ra,0x1
    45fa:	724080e7          	jalr	1828(ra) # 5d1a <malloc>
    if(m1 == 0){
    45fe:	c911                	beqz	a0,4612 <mem+0x7e>
    free(m1);
    4600:	00001097          	auipc	ra,0x1
    4604:	698080e7          	jalr	1688(ra) # 5c98 <free>
    exit(0);
    4608:	4501                	li	a0,0
    460a:	00001097          	auipc	ra,0x1
    460e:	2e0080e7          	jalr	736(ra) # 58ea <exit>
      printf("couldn't allocate mem?!!\n", s);
    4612:	85ce                	mv	a1,s3
    4614:	00003517          	auipc	a0,0x3
    4618:	3ec50513          	addi	a0,a0,1004 # 7a00 <malloc+0x1ce6>
    461c:	00001097          	auipc	ra,0x1
    4620:	646080e7          	jalr	1606(ra) # 5c62 <printf>
      exit(1);
    4624:	4505                	li	a0,1
    4626:	00001097          	auipc	ra,0x1
    462a:	2c4080e7          	jalr	708(ra) # 58ea <exit>
      exit(0);
    462e:	4501                	li	a0,0
    4630:	00001097          	auipc	ra,0x1
    4634:	2ba080e7          	jalr	698(ra) # 58ea <exit>

0000000000004638 <sharedfd>:
{
    4638:	7159                	addi	sp,sp,-112
    463a:	f486                	sd	ra,104(sp)
    463c:	f0a2                	sd	s0,96(sp)
    463e:	e0d2                	sd	s4,64(sp)
    4640:	1880                	addi	s0,sp,112
    4642:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4644:	00003517          	auipc	a0,0x3
    4648:	3dc50513          	addi	a0,a0,988 # 7a20 <malloc+0x1d06>
    464c:	00001097          	auipc	ra,0x1
    4650:	2ee080e7          	jalr	750(ra) # 593a <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4654:	20200593          	li	a1,514
    4658:	00003517          	auipc	a0,0x3
    465c:	3c850513          	addi	a0,a0,968 # 7a20 <malloc+0x1d06>
    4660:	00001097          	auipc	ra,0x1
    4664:	2ca080e7          	jalr	714(ra) # 592a <open>
  if(fd < 0){
    4668:	06054063          	bltz	a0,46c8 <sharedfd+0x90>
    466c:	eca6                	sd	s1,88(sp)
    466e:	e8ca                	sd	s2,80(sp)
    4670:	e4ce                	sd	s3,72(sp)
    4672:	fc56                	sd	s5,56(sp)
    4674:	f85a                	sd	s6,48(sp)
    4676:	f45e                	sd	s7,40(sp)
    4678:	892a                	mv	s2,a0
  pid = fork();
    467a:	00001097          	auipc	ra,0x1
    467e:	268080e7          	jalr	616(ra) # 58e2 <fork>
    4682:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4684:	07000593          	li	a1,112
    4688:	e119                	bnez	a0,468e <sharedfd+0x56>
    468a:	06300593          	li	a1,99
    468e:	4629                	li	a2,10
    4690:	fa040513          	addi	a0,s0,-96
    4694:	00001097          	auipc	ra,0x1
    4698:	046080e7          	jalr	70(ra) # 56da <memset>
    469c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    46a0:	4629                	li	a2,10
    46a2:	fa040593          	addi	a1,s0,-96
    46a6:	854a                	mv	a0,s2
    46a8:	00001097          	auipc	ra,0x1
    46ac:	262080e7          	jalr	610(ra) # 590a <write>
    46b0:	47a9                	li	a5,10
    46b2:	02f51f63          	bne	a0,a5,46f0 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    46b6:	34fd                	addiw	s1,s1,-1
    46b8:	f4e5                	bnez	s1,46a0 <sharedfd+0x68>
  if(pid == 0) {
    46ba:	04099963          	bnez	s3,470c <sharedfd+0xd4>
    exit(0);
    46be:	4501                	li	a0,0
    46c0:	00001097          	auipc	ra,0x1
    46c4:	22a080e7          	jalr	554(ra) # 58ea <exit>
    46c8:	eca6                	sd	s1,88(sp)
    46ca:	e8ca                	sd	s2,80(sp)
    46cc:	e4ce                	sd	s3,72(sp)
    46ce:	fc56                	sd	s5,56(sp)
    46d0:	f85a                	sd	s6,48(sp)
    46d2:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    46d4:	85d2                	mv	a1,s4
    46d6:	00003517          	auipc	a0,0x3
    46da:	35a50513          	addi	a0,a0,858 # 7a30 <malloc+0x1d16>
    46de:	00001097          	auipc	ra,0x1
    46e2:	584080e7          	jalr	1412(ra) # 5c62 <printf>
    exit(1);
    46e6:	4505                	li	a0,1
    46e8:	00001097          	auipc	ra,0x1
    46ec:	202080e7          	jalr	514(ra) # 58ea <exit>
      printf("%s: write sharedfd failed\n", s);
    46f0:	85d2                	mv	a1,s4
    46f2:	00003517          	auipc	a0,0x3
    46f6:	36650513          	addi	a0,a0,870 # 7a58 <malloc+0x1d3e>
    46fa:	00001097          	auipc	ra,0x1
    46fe:	568080e7          	jalr	1384(ra) # 5c62 <printf>
      exit(1);
    4702:	4505                	li	a0,1
    4704:	00001097          	auipc	ra,0x1
    4708:	1e6080e7          	jalr	486(ra) # 58ea <exit>
    wait(&xstatus);
    470c:	f9c40513          	addi	a0,s0,-100
    4710:	00001097          	auipc	ra,0x1
    4714:	1e2080e7          	jalr	482(ra) # 58f2 <wait>
    if(xstatus != 0)
    4718:	f9c42983          	lw	s3,-100(s0)
    471c:	00098763          	beqz	s3,472a <sharedfd+0xf2>
      exit(xstatus);
    4720:	854e                	mv	a0,s3
    4722:	00001097          	auipc	ra,0x1
    4726:	1c8080e7          	jalr	456(ra) # 58ea <exit>
  close(fd);
    472a:	854a                	mv	a0,s2
    472c:	00001097          	auipc	ra,0x1
    4730:	1e6080e7          	jalr	486(ra) # 5912 <close>
  fd = open("sharedfd", 0);
    4734:	4581                	li	a1,0
    4736:	00003517          	auipc	a0,0x3
    473a:	2ea50513          	addi	a0,a0,746 # 7a20 <malloc+0x1d06>
    473e:	00001097          	auipc	ra,0x1
    4742:	1ec080e7          	jalr	492(ra) # 592a <open>
    4746:	8baa                	mv	s7,a0
  nc = np = 0;
    4748:	8ace                	mv	s5,s3
  if(fd < 0){
    474a:	02054563          	bltz	a0,4774 <sharedfd+0x13c>
    474e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4752:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4756:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    475a:	4629                	li	a2,10
    475c:	fa040593          	addi	a1,s0,-96
    4760:	855e                	mv	a0,s7
    4762:	00001097          	auipc	ra,0x1
    4766:	1a0080e7          	jalr	416(ra) # 5902 <read>
    476a:	02a05f63          	blez	a0,47a8 <sharedfd+0x170>
    476e:	fa040793          	addi	a5,s0,-96
    4772:	a01d                	j	4798 <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4774:	85d2                	mv	a1,s4
    4776:	00003517          	auipc	a0,0x3
    477a:	30250513          	addi	a0,a0,770 # 7a78 <malloc+0x1d5e>
    477e:	00001097          	auipc	ra,0x1
    4782:	4e4080e7          	jalr	1252(ra) # 5c62 <printf>
    exit(1);
    4786:	4505                	li	a0,1
    4788:	00001097          	auipc	ra,0x1
    478c:	162080e7          	jalr	354(ra) # 58ea <exit>
        nc++;
    4790:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4792:	0785                	addi	a5,a5,1
    4794:	fd2783e3          	beq	a5,s2,475a <sharedfd+0x122>
      if(buf[i] == 'c')
    4798:	0007c703          	lbu	a4,0(a5)
    479c:	fe970ae3          	beq	a4,s1,4790 <sharedfd+0x158>
      if(buf[i] == 'p')
    47a0:	ff6719e3          	bne	a4,s6,4792 <sharedfd+0x15a>
        np++;
    47a4:	2a85                	addiw	s5,s5,1
    47a6:	b7f5                	j	4792 <sharedfd+0x15a>
  close(fd);
    47a8:	855e                	mv	a0,s7
    47aa:	00001097          	auipc	ra,0x1
    47ae:	168080e7          	jalr	360(ra) # 5912 <close>
  unlink("sharedfd");
    47b2:	00003517          	auipc	a0,0x3
    47b6:	26e50513          	addi	a0,a0,622 # 7a20 <malloc+0x1d06>
    47ba:	00001097          	auipc	ra,0x1
    47be:	180080e7          	jalr	384(ra) # 593a <unlink>
  if(nc == N*SZ && np == N*SZ){
    47c2:	6789                	lui	a5,0x2
    47c4:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x6a>
    47c8:	00f99763          	bne	s3,a5,47d6 <sharedfd+0x19e>
    47cc:	6789                	lui	a5,0x2
    47ce:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x6a>
    47d2:	02fa8063          	beq	s5,a5,47f2 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    47d6:	85d2                	mv	a1,s4
    47d8:	00003517          	auipc	a0,0x3
    47dc:	2c850513          	addi	a0,a0,712 # 7aa0 <malloc+0x1d86>
    47e0:	00001097          	auipc	ra,0x1
    47e4:	482080e7          	jalr	1154(ra) # 5c62 <printf>
    exit(1);
    47e8:	4505                	li	a0,1
    47ea:	00001097          	auipc	ra,0x1
    47ee:	100080e7          	jalr	256(ra) # 58ea <exit>
    exit(0);
    47f2:	4501                	li	a0,0
    47f4:	00001097          	auipc	ra,0x1
    47f8:	0f6080e7          	jalr	246(ra) # 58ea <exit>

00000000000047fc <fourfiles>:
{
    47fc:	7135                	addi	sp,sp,-160
    47fe:	ed06                	sd	ra,152(sp)
    4800:	e922                	sd	s0,144(sp)
    4802:	e526                	sd	s1,136(sp)
    4804:	e14a                	sd	s2,128(sp)
    4806:	fcce                	sd	s3,120(sp)
    4808:	f8d2                	sd	s4,112(sp)
    480a:	f4d6                	sd	s5,104(sp)
    480c:	f0da                	sd	s6,96(sp)
    480e:	ecde                	sd	s7,88(sp)
    4810:	e8e2                	sd	s8,80(sp)
    4812:	e4e6                	sd	s9,72(sp)
    4814:	e0ea                	sd	s10,64(sp)
    4816:	fc6e                	sd	s11,56(sp)
    4818:	1100                	addi	s0,sp,160
    481a:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    481c:	00003797          	auipc	a5,0x3
    4820:	29c78793          	addi	a5,a5,668 # 7ab8 <malloc+0x1d9e>
    4824:	f6f43823          	sd	a5,-144(s0)
    4828:	00003797          	auipc	a5,0x3
    482c:	29878793          	addi	a5,a5,664 # 7ac0 <malloc+0x1da6>
    4830:	f6f43c23          	sd	a5,-136(s0)
    4834:	00003797          	auipc	a5,0x3
    4838:	29478793          	addi	a5,a5,660 # 7ac8 <malloc+0x1dae>
    483c:	f8f43023          	sd	a5,-128(s0)
    4840:	00003797          	auipc	a5,0x3
    4844:	29078793          	addi	a5,a5,656 # 7ad0 <malloc+0x1db6>
    4848:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    484c:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4850:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4852:	4481                	li	s1,0
    4854:	4a11                	li	s4,4
    fname = names[pi];
    4856:	00093983          	ld	s3,0(s2)
    unlink(fname);
    485a:	854e                	mv	a0,s3
    485c:	00001097          	auipc	ra,0x1
    4860:	0de080e7          	jalr	222(ra) # 593a <unlink>
    pid = fork();
    4864:	00001097          	auipc	ra,0x1
    4868:	07e080e7          	jalr	126(ra) # 58e2 <fork>
    if(pid < 0){
    486c:	04054063          	bltz	a0,48ac <fourfiles+0xb0>
    if(pid == 0){
    4870:	cd21                	beqz	a0,48c8 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4872:	2485                	addiw	s1,s1,1
    4874:	0921                	addi	s2,s2,8
    4876:	ff4490e3          	bne	s1,s4,4856 <fourfiles+0x5a>
    487a:	4491                	li	s1,4
    wait(&xstatus);
    487c:	f6c40513          	addi	a0,s0,-148
    4880:	00001097          	auipc	ra,0x1
    4884:	072080e7          	jalr	114(ra) # 58f2 <wait>
    if(xstatus != 0)
    4888:	f6c42a83          	lw	s5,-148(s0)
    488c:	0c0a9863          	bnez	s5,495c <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4890:	34fd                	addiw	s1,s1,-1
    4892:	f4ed                	bnez	s1,487c <fourfiles+0x80>
    4894:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4898:	00009a17          	auipc	s4,0x9
    489c:	880a0a13          	addi	s4,s4,-1920 # d118 <buf>
    if(total != N*SZ){
    48a0:	6d05                	lui	s10,0x1
    48a2:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x18>
  for(i = 0; i < NCHILD; i++){
    48a6:	03400d93          	li	s11,52
    48aa:	a22d                	j	49d4 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    48ac:	85e6                	mv	a1,s9
    48ae:	00002517          	auipc	a0,0x2
    48b2:	22250513          	addi	a0,a0,546 # 6ad0 <malloc+0xdb6>
    48b6:	00001097          	auipc	ra,0x1
    48ba:	3ac080e7          	jalr	940(ra) # 5c62 <printf>
      exit(1);
    48be:	4505                	li	a0,1
    48c0:	00001097          	auipc	ra,0x1
    48c4:	02a080e7          	jalr	42(ra) # 58ea <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    48c8:	20200593          	li	a1,514
    48cc:	854e                	mv	a0,s3
    48ce:	00001097          	auipc	ra,0x1
    48d2:	05c080e7          	jalr	92(ra) # 592a <open>
    48d6:	892a                	mv	s2,a0
      if(fd < 0){
    48d8:	04054763          	bltz	a0,4926 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    48dc:	1f400613          	li	a2,500
    48e0:	0304859b          	addiw	a1,s1,48
    48e4:	00009517          	auipc	a0,0x9
    48e8:	83450513          	addi	a0,a0,-1996 # d118 <buf>
    48ec:	00001097          	auipc	ra,0x1
    48f0:	dee080e7          	jalr	-530(ra) # 56da <memset>
    48f4:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    48f6:	00009997          	auipc	s3,0x9
    48fa:	82298993          	addi	s3,s3,-2014 # d118 <buf>
    48fe:	1f400613          	li	a2,500
    4902:	85ce                	mv	a1,s3
    4904:	854a                	mv	a0,s2
    4906:	00001097          	auipc	ra,0x1
    490a:	004080e7          	jalr	4(ra) # 590a <write>
    490e:	85aa                	mv	a1,a0
    4910:	1f400793          	li	a5,500
    4914:	02f51763          	bne	a0,a5,4942 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4918:	34fd                	addiw	s1,s1,-1
    491a:	f0f5                	bnez	s1,48fe <fourfiles+0x102>
      exit(0);
    491c:	4501                	li	a0,0
    491e:	00001097          	auipc	ra,0x1
    4922:	fcc080e7          	jalr	-52(ra) # 58ea <exit>
        printf("create failed\n", s);
    4926:	85e6                	mv	a1,s9
    4928:	00003517          	auipc	a0,0x3
    492c:	1b050513          	addi	a0,a0,432 # 7ad8 <malloc+0x1dbe>
    4930:	00001097          	auipc	ra,0x1
    4934:	332080e7          	jalr	818(ra) # 5c62 <printf>
        exit(1);
    4938:	4505                	li	a0,1
    493a:	00001097          	auipc	ra,0x1
    493e:	fb0080e7          	jalr	-80(ra) # 58ea <exit>
          printf("write failed %d\n", n);
    4942:	00003517          	auipc	a0,0x3
    4946:	1a650513          	addi	a0,a0,422 # 7ae8 <malloc+0x1dce>
    494a:	00001097          	auipc	ra,0x1
    494e:	318080e7          	jalr	792(ra) # 5c62 <printf>
          exit(1);
    4952:	4505                	li	a0,1
    4954:	00001097          	auipc	ra,0x1
    4958:	f96080e7          	jalr	-106(ra) # 58ea <exit>
      exit(xstatus);
    495c:	8556                	mv	a0,s5
    495e:	00001097          	auipc	ra,0x1
    4962:	f8c080e7          	jalr	-116(ra) # 58ea <exit>
          printf("wrong char\n", s);
    4966:	85e6                	mv	a1,s9
    4968:	00003517          	auipc	a0,0x3
    496c:	19850513          	addi	a0,a0,408 # 7b00 <malloc+0x1de6>
    4970:	00001097          	auipc	ra,0x1
    4974:	2f2080e7          	jalr	754(ra) # 5c62 <printf>
          exit(1);
    4978:	4505                	li	a0,1
    497a:	00001097          	auipc	ra,0x1
    497e:	f70080e7          	jalr	-144(ra) # 58ea <exit>
      total += n;
    4982:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4986:	660d                	lui	a2,0x3
    4988:	85d2                	mv	a1,s4
    498a:	854e                	mv	a0,s3
    498c:	00001097          	auipc	ra,0x1
    4990:	f76080e7          	jalr	-138(ra) # 5902 <read>
    4994:	02a05063          	blez	a0,49b4 <fourfiles+0x1b8>
    4998:	00008797          	auipc	a5,0x8
    499c:	78078793          	addi	a5,a5,1920 # d118 <buf>
    49a0:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    49a4:	0007c703          	lbu	a4,0(a5)
    49a8:	fa971fe3          	bne	a4,s1,4966 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    49ac:	0785                	addi	a5,a5,1
    49ae:	fed79be3          	bne	a5,a3,49a4 <fourfiles+0x1a8>
    49b2:	bfc1                	j	4982 <fourfiles+0x186>
    close(fd);
    49b4:	854e                	mv	a0,s3
    49b6:	00001097          	auipc	ra,0x1
    49ba:	f5c080e7          	jalr	-164(ra) # 5912 <close>
    if(total != N*SZ){
    49be:	03a91863          	bne	s2,s10,49ee <fourfiles+0x1f2>
    unlink(fname);
    49c2:	8562                	mv	a0,s8
    49c4:	00001097          	auipc	ra,0x1
    49c8:	f76080e7          	jalr	-138(ra) # 593a <unlink>
  for(i = 0; i < NCHILD; i++){
    49cc:	0ba1                	addi	s7,s7,8
    49ce:	2b05                	addiw	s6,s6,1
    49d0:	03bb0d63          	beq	s6,s11,4a0a <fourfiles+0x20e>
    fname = names[i];
    49d4:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    49d8:	4581                	li	a1,0
    49da:	8562                	mv	a0,s8
    49dc:	00001097          	auipc	ra,0x1
    49e0:	f4e080e7          	jalr	-178(ra) # 592a <open>
    49e4:	89aa                	mv	s3,a0
    total = 0;
    49e6:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    49e8:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    49ec:	bf69                	j	4986 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    49ee:	85ca                	mv	a1,s2
    49f0:	00003517          	auipc	a0,0x3
    49f4:	12050513          	addi	a0,a0,288 # 7b10 <malloc+0x1df6>
    49f8:	00001097          	auipc	ra,0x1
    49fc:	26a080e7          	jalr	618(ra) # 5c62 <printf>
      exit(1);
    4a00:	4505                	li	a0,1
    4a02:	00001097          	auipc	ra,0x1
    4a06:	ee8080e7          	jalr	-280(ra) # 58ea <exit>
}
    4a0a:	60ea                	ld	ra,152(sp)
    4a0c:	644a                	ld	s0,144(sp)
    4a0e:	64aa                	ld	s1,136(sp)
    4a10:	690a                	ld	s2,128(sp)
    4a12:	79e6                	ld	s3,120(sp)
    4a14:	7a46                	ld	s4,112(sp)
    4a16:	7aa6                	ld	s5,104(sp)
    4a18:	7b06                	ld	s6,96(sp)
    4a1a:	6be6                	ld	s7,88(sp)
    4a1c:	6c46                	ld	s8,80(sp)
    4a1e:	6ca6                	ld	s9,72(sp)
    4a20:	6d06                	ld	s10,64(sp)
    4a22:	7de2                	ld	s11,56(sp)
    4a24:	610d                	addi	sp,sp,160
    4a26:	8082                	ret

0000000000004a28 <concreate>:
{
    4a28:	7135                	addi	sp,sp,-160
    4a2a:	ed06                	sd	ra,152(sp)
    4a2c:	e922                	sd	s0,144(sp)
    4a2e:	e526                	sd	s1,136(sp)
    4a30:	e14a                	sd	s2,128(sp)
    4a32:	fcce                	sd	s3,120(sp)
    4a34:	f8d2                	sd	s4,112(sp)
    4a36:	f4d6                	sd	s5,104(sp)
    4a38:	f0da                	sd	s6,96(sp)
    4a3a:	ecde                	sd	s7,88(sp)
    4a3c:	1100                	addi	s0,sp,160
    4a3e:	89aa                	mv	s3,a0
  file[0] = 'C';
    4a40:	04300793          	li	a5,67
    4a44:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4a48:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4a4c:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4a4e:	4b0d                	li	s6,3
    4a50:	4a85                	li	s5,1
      link("C0", file);
    4a52:	00003b97          	auipc	s7,0x3
    4a56:	0d6b8b93          	addi	s7,s7,214 # 7b28 <malloc+0x1e0e>
  for(i = 0; i < N; i++){
    4a5a:	02800a13          	li	s4,40
    4a5e:	acc9                	j	4d30 <concreate+0x308>
      link("C0", file);
    4a60:	fa840593          	addi	a1,s0,-88
    4a64:	855e                	mv	a0,s7
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	ee4080e7          	jalr	-284(ra) # 594a <link>
    if(pid == 0) {
    4a6e:	a465                	j	4d16 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4a70:	4795                	li	a5,5
    4a72:	02f9693b          	remw	s2,s2,a5
    4a76:	4785                	li	a5,1
    4a78:	02f90b63          	beq	s2,a5,4aae <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a7c:	20200593          	li	a1,514
    4a80:	fa840513          	addi	a0,s0,-88
    4a84:	00001097          	auipc	ra,0x1
    4a88:	ea6080e7          	jalr	-346(ra) # 592a <open>
      if(fd < 0){
    4a8c:	26055c63          	bgez	a0,4d04 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4a90:	fa840593          	addi	a1,s0,-88
    4a94:	00003517          	auipc	a0,0x3
    4a98:	09c50513          	addi	a0,a0,156 # 7b30 <malloc+0x1e16>
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	1c6080e7          	jalr	454(ra) # 5c62 <printf>
        exit(1);
    4aa4:	4505                	li	a0,1
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	e44080e7          	jalr	-444(ra) # 58ea <exit>
      link("C0", file);
    4aae:	fa840593          	addi	a1,s0,-88
    4ab2:	00003517          	auipc	a0,0x3
    4ab6:	07650513          	addi	a0,a0,118 # 7b28 <malloc+0x1e0e>
    4aba:	00001097          	auipc	ra,0x1
    4abe:	e90080e7          	jalr	-368(ra) # 594a <link>
      exit(0);
    4ac2:	4501                	li	a0,0
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	e26080e7          	jalr	-474(ra) # 58ea <exit>
        exit(1);
    4acc:	4505                	li	a0,1
    4ace:	00001097          	auipc	ra,0x1
    4ad2:	e1c080e7          	jalr	-484(ra) # 58ea <exit>
  memset(fa, 0, sizeof(fa));
    4ad6:	02800613          	li	a2,40
    4ada:	4581                	li	a1,0
    4adc:	f8040513          	addi	a0,s0,-128
    4ae0:	00001097          	auipc	ra,0x1
    4ae4:	bfa080e7          	jalr	-1030(ra) # 56da <memset>
  fd = open(".", 0);
    4ae8:	4581                	li	a1,0
    4aea:	00002517          	auipc	a0,0x2
    4aee:	a2650513          	addi	a0,a0,-1498 # 6510 <malloc+0x7f6>
    4af2:	00001097          	auipc	ra,0x1
    4af6:	e38080e7          	jalr	-456(ra) # 592a <open>
    4afa:	892a                	mv	s2,a0
  n = 0;
    4afc:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4afe:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4b02:	02700b13          	li	s6,39
      fa[i] = 1;
    4b06:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4b08:	4641                	li	a2,16
    4b0a:	f7040593          	addi	a1,s0,-144
    4b0e:	854a                	mv	a0,s2
    4b10:	00001097          	auipc	ra,0x1
    4b14:	df2080e7          	jalr	-526(ra) # 5902 <read>
    4b18:	08a05263          	blez	a0,4b9c <concreate+0x174>
    if(de.inum == 0)
    4b1c:	f7045783          	lhu	a5,-144(s0)
    4b20:	d7e5                	beqz	a5,4b08 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4b22:	f7244783          	lbu	a5,-142(s0)
    4b26:	ff4791e3          	bne	a5,s4,4b08 <concreate+0xe0>
    4b2a:	f7444783          	lbu	a5,-140(s0)
    4b2e:	ffe9                	bnez	a5,4b08 <concreate+0xe0>
      i = de.name[1] - '0';
    4b30:	f7344783          	lbu	a5,-141(s0)
    4b34:	fd07879b          	addiw	a5,a5,-48
    4b38:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4b3c:	02eb6063          	bltu	s6,a4,4b5c <concreate+0x134>
      if(fa[i]){
    4b40:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x50>
    4b44:	97a2                	add	a5,a5,s0
    4b46:	fd07c783          	lbu	a5,-48(a5)
    4b4a:	eb8d                	bnez	a5,4b7c <concreate+0x154>
      fa[i] = 1;
    4b4c:	fb070793          	addi	a5,a4,-80
    4b50:	00878733          	add	a4,a5,s0
    4b54:	fd770823          	sb	s7,-48(a4)
      n++;
    4b58:	2a85                	addiw	s5,s5,1
    4b5a:	b77d                	j	4b08 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4b5c:	f7240613          	addi	a2,s0,-142
    4b60:	85ce                	mv	a1,s3
    4b62:	00003517          	auipc	a0,0x3
    4b66:	fee50513          	addi	a0,a0,-18 # 7b50 <malloc+0x1e36>
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	0f8080e7          	jalr	248(ra) # 5c62 <printf>
        exit(1);
    4b72:	4505                	li	a0,1
    4b74:	00001097          	auipc	ra,0x1
    4b78:	d76080e7          	jalr	-650(ra) # 58ea <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b7c:	f7240613          	addi	a2,s0,-142
    4b80:	85ce                	mv	a1,s3
    4b82:	00003517          	auipc	a0,0x3
    4b86:	fee50513          	addi	a0,a0,-18 # 7b70 <malloc+0x1e56>
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	0d8080e7          	jalr	216(ra) # 5c62 <printf>
        exit(1);
    4b92:	4505                	li	a0,1
    4b94:	00001097          	auipc	ra,0x1
    4b98:	d56080e7          	jalr	-682(ra) # 58ea <exit>
  close(fd);
    4b9c:	854a                	mv	a0,s2
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	d74080e7          	jalr	-652(ra) # 5912 <close>
  if(n != N){
    4ba6:	02800793          	li	a5,40
    4baa:	00fa9763          	bne	s5,a5,4bb8 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4bae:	4a8d                	li	s5,3
    4bb0:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4bb2:	02800a13          	li	s4,40
    4bb6:	a8c9                	j	4c88 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4bb8:	85ce                	mv	a1,s3
    4bba:	00003517          	auipc	a0,0x3
    4bbe:	fde50513          	addi	a0,a0,-34 # 7b98 <malloc+0x1e7e>
    4bc2:	00001097          	auipc	ra,0x1
    4bc6:	0a0080e7          	jalr	160(ra) # 5c62 <printf>
    exit(1);
    4bca:	4505                	li	a0,1
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	d1e080e7          	jalr	-738(ra) # 58ea <exit>
      printf("%s: fork failed\n", s);
    4bd4:	85ce                	mv	a1,s3
    4bd6:	00002517          	auipc	a0,0x2
    4bda:	ada50513          	addi	a0,a0,-1318 # 66b0 <malloc+0x996>
    4bde:	00001097          	auipc	ra,0x1
    4be2:	084080e7          	jalr	132(ra) # 5c62 <printf>
      exit(1);
    4be6:	4505                	li	a0,1
    4be8:	00001097          	auipc	ra,0x1
    4bec:	d02080e7          	jalr	-766(ra) # 58ea <exit>
      close(open(file, 0));
    4bf0:	4581                	li	a1,0
    4bf2:	fa840513          	addi	a0,s0,-88
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	d34080e7          	jalr	-716(ra) # 592a <open>
    4bfe:	00001097          	auipc	ra,0x1
    4c02:	d14080e7          	jalr	-748(ra) # 5912 <close>
      close(open(file, 0));
    4c06:	4581                	li	a1,0
    4c08:	fa840513          	addi	a0,s0,-88
    4c0c:	00001097          	auipc	ra,0x1
    4c10:	d1e080e7          	jalr	-738(ra) # 592a <open>
    4c14:	00001097          	auipc	ra,0x1
    4c18:	cfe080e7          	jalr	-770(ra) # 5912 <close>
      close(open(file, 0));
    4c1c:	4581                	li	a1,0
    4c1e:	fa840513          	addi	a0,s0,-88
    4c22:	00001097          	auipc	ra,0x1
    4c26:	d08080e7          	jalr	-760(ra) # 592a <open>
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	ce8080e7          	jalr	-792(ra) # 5912 <close>
      close(open(file, 0));
    4c32:	4581                	li	a1,0
    4c34:	fa840513          	addi	a0,s0,-88
    4c38:	00001097          	auipc	ra,0x1
    4c3c:	cf2080e7          	jalr	-782(ra) # 592a <open>
    4c40:	00001097          	auipc	ra,0x1
    4c44:	cd2080e7          	jalr	-814(ra) # 5912 <close>
      close(open(file, 0));
    4c48:	4581                	li	a1,0
    4c4a:	fa840513          	addi	a0,s0,-88
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	cdc080e7          	jalr	-804(ra) # 592a <open>
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	cbc080e7          	jalr	-836(ra) # 5912 <close>
      close(open(file, 0));
    4c5e:	4581                	li	a1,0
    4c60:	fa840513          	addi	a0,s0,-88
    4c64:	00001097          	auipc	ra,0x1
    4c68:	cc6080e7          	jalr	-826(ra) # 592a <open>
    4c6c:	00001097          	auipc	ra,0x1
    4c70:	ca6080e7          	jalr	-858(ra) # 5912 <close>
    if(pid == 0)
    4c74:	08090363          	beqz	s2,4cfa <concreate+0x2d2>
      wait(0);
    4c78:	4501                	li	a0,0
    4c7a:	00001097          	auipc	ra,0x1
    4c7e:	c78080e7          	jalr	-904(ra) # 58f2 <wait>
  for(i = 0; i < N; i++){
    4c82:	2485                	addiw	s1,s1,1
    4c84:	0f448563          	beq	s1,s4,4d6e <concreate+0x346>
    file[1] = '0' + i;
    4c88:	0304879b          	addiw	a5,s1,48
    4c8c:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c90:	00001097          	auipc	ra,0x1
    4c94:	c52080e7          	jalr	-942(ra) # 58e2 <fork>
    4c98:	892a                	mv	s2,a0
    if(pid < 0){
    4c9a:	f2054de3          	bltz	a0,4bd4 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4c9e:	0354e73b          	remw	a4,s1,s5
    4ca2:	00a767b3          	or	a5,a4,a0
    4ca6:	2781                	sext.w	a5,a5
    4ca8:	d7a1                	beqz	a5,4bf0 <concreate+0x1c8>
    4caa:	01671363          	bne	a4,s6,4cb0 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4cae:	f129                	bnez	a0,4bf0 <concreate+0x1c8>
      unlink(file);
    4cb0:	fa840513          	addi	a0,s0,-88
    4cb4:	00001097          	auipc	ra,0x1
    4cb8:	c86080e7          	jalr	-890(ra) # 593a <unlink>
      unlink(file);
    4cbc:	fa840513          	addi	a0,s0,-88
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	c7a080e7          	jalr	-902(ra) # 593a <unlink>
      unlink(file);
    4cc8:	fa840513          	addi	a0,s0,-88
    4ccc:	00001097          	auipc	ra,0x1
    4cd0:	c6e080e7          	jalr	-914(ra) # 593a <unlink>
      unlink(file);
    4cd4:	fa840513          	addi	a0,s0,-88
    4cd8:	00001097          	auipc	ra,0x1
    4cdc:	c62080e7          	jalr	-926(ra) # 593a <unlink>
      unlink(file);
    4ce0:	fa840513          	addi	a0,s0,-88
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	c56080e7          	jalr	-938(ra) # 593a <unlink>
      unlink(file);
    4cec:	fa840513          	addi	a0,s0,-88
    4cf0:	00001097          	auipc	ra,0x1
    4cf4:	c4a080e7          	jalr	-950(ra) # 593a <unlink>
    4cf8:	bfb5                	j	4c74 <concreate+0x24c>
      exit(0);
    4cfa:	4501                	li	a0,0
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	bee080e7          	jalr	-1042(ra) # 58ea <exit>
      close(fd);
    4d04:	00001097          	auipc	ra,0x1
    4d08:	c0e080e7          	jalr	-1010(ra) # 5912 <close>
    if(pid == 0) {
    4d0c:	bb5d                	j	4ac2 <concreate+0x9a>
      close(fd);
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	c04080e7          	jalr	-1020(ra) # 5912 <close>
      wait(&xstatus);
    4d16:	f6c40513          	addi	a0,s0,-148
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	bd8080e7          	jalr	-1064(ra) # 58f2 <wait>
      if(xstatus != 0)
    4d22:	f6c42483          	lw	s1,-148(s0)
    4d26:	da0493e3          	bnez	s1,4acc <concreate+0xa4>
  for(i = 0; i < N; i++){
    4d2a:	2905                	addiw	s2,s2,1
    4d2c:	db4905e3          	beq	s2,s4,4ad6 <concreate+0xae>
    file[1] = '0' + i;
    4d30:	0309079b          	addiw	a5,s2,48
    4d34:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4d38:	fa840513          	addi	a0,s0,-88
    4d3c:	00001097          	auipc	ra,0x1
    4d40:	bfe080e7          	jalr	-1026(ra) # 593a <unlink>
    pid = fork();
    4d44:	00001097          	auipc	ra,0x1
    4d48:	b9e080e7          	jalr	-1122(ra) # 58e2 <fork>
    if(pid && (i % 3) == 1){
    4d4c:	d20502e3          	beqz	a0,4a70 <concreate+0x48>
    4d50:	036967bb          	remw	a5,s2,s6
    4d54:	d15786e3          	beq	a5,s5,4a60 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4d58:	20200593          	li	a1,514
    4d5c:	fa840513          	addi	a0,s0,-88
    4d60:	00001097          	auipc	ra,0x1
    4d64:	bca080e7          	jalr	-1078(ra) # 592a <open>
      if(fd < 0){
    4d68:	fa0553e3          	bgez	a0,4d0e <concreate+0x2e6>
    4d6c:	b315                	j	4a90 <concreate+0x68>
}
    4d6e:	60ea                	ld	ra,152(sp)
    4d70:	644a                	ld	s0,144(sp)
    4d72:	64aa                	ld	s1,136(sp)
    4d74:	690a                	ld	s2,128(sp)
    4d76:	79e6                	ld	s3,120(sp)
    4d78:	7a46                	ld	s4,112(sp)
    4d7a:	7aa6                	ld	s5,104(sp)
    4d7c:	7b06                	ld	s6,96(sp)
    4d7e:	6be6                	ld	s7,88(sp)
    4d80:	610d                	addi	sp,sp,160
    4d82:	8082                	ret

0000000000004d84 <bigfile>:
{
    4d84:	7139                	addi	sp,sp,-64
    4d86:	fc06                	sd	ra,56(sp)
    4d88:	f822                	sd	s0,48(sp)
    4d8a:	f426                	sd	s1,40(sp)
    4d8c:	f04a                	sd	s2,32(sp)
    4d8e:	ec4e                	sd	s3,24(sp)
    4d90:	e852                	sd	s4,16(sp)
    4d92:	e456                	sd	s5,8(sp)
    4d94:	0080                	addi	s0,sp,64
    4d96:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d98:	00003517          	auipc	a0,0x3
    4d9c:	e3850513          	addi	a0,a0,-456 # 7bd0 <malloc+0x1eb6>
    4da0:	00001097          	auipc	ra,0x1
    4da4:	b9a080e7          	jalr	-1126(ra) # 593a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4da8:	20200593          	li	a1,514
    4dac:	00003517          	auipc	a0,0x3
    4db0:	e2450513          	addi	a0,a0,-476 # 7bd0 <malloc+0x1eb6>
    4db4:	00001097          	auipc	ra,0x1
    4db8:	b76080e7          	jalr	-1162(ra) # 592a <open>
    4dbc:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4dbe:	4481                	li	s1,0
    memset(buf, i, SZ);
    4dc0:	00008917          	auipc	s2,0x8
    4dc4:	35890913          	addi	s2,s2,856 # d118 <buf>
  for(i = 0; i < N; i++){
    4dc8:	4a51                	li	s4,20
  if(fd < 0){
    4dca:	0a054063          	bltz	a0,4e6a <bigfile+0xe6>
    memset(buf, i, SZ);
    4dce:	25800613          	li	a2,600
    4dd2:	85a6                	mv	a1,s1
    4dd4:	854a                	mv	a0,s2
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	904080e7          	jalr	-1788(ra) # 56da <memset>
    if(write(fd, buf, SZ) != SZ){
    4dde:	25800613          	li	a2,600
    4de2:	85ca                	mv	a1,s2
    4de4:	854e                	mv	a0,s3
    4de6:	00001097          	auipc	ra,0x1
    4dea:	b24080e7          	jalr	-1244(ra) # 590a <write>
    4dee:	25800793          	li	a5,600
    4df2:	08f51a63          	bne	a0,a5,4e86 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4df6:	2485                	addiw	s1,s1,1
    4df8:	fd449be3          	bne	s1,s4,4dce <bigfile+0x4a>
  close(fd);
    4dfc:	854e                	mv	a0,s3
    4dfe:	00001097          	auipc	ra,0x1
    4e02:	b14080e7          	jalr	-1260(ra) # 5912 <close>
  fd = open("bigfile.dat", 0);
    4e06:	4581                	li	a1,0
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	dc850513          	addi	a0,a0,-568 # 7bd0 <malloc+0x1eb6>
    4e10:	00001097          	auipc	ra,0x1
    4e14:	b1a080e7          	jalr	-1254(ra) # 592a <open>
    4e18:	8a2a                	mv	s4,a0
  total = 0;
    4e1a:	4981                	li	s3,0
  for(i = 0; ; i++){
    4e1c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4e1e:	00008917          	auipc	s2,0x8
    4e22:	2fa90913          	addi	s2,s2,762 # d118 <buf>
  if(fd < 0){
    4e26:	06054e63          	bltz	a0,4ea2 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4e2a:	12c00613          	li	a2,300
    4e2e:	85ca                	mv	a1,s2
    4e30:	8552                	mv	a0,s4
    4e32:	00001097          	auipc	ra,0x1
    4e36:	ad0080e7          	jalr	-1328(ra) # 5902 <read>
    if(cc < 0){
    4e3a:	08054263          	bltz	a0,4ebe <bigfile+0x13a>
    if(cc == 0)
    4e3e:	c971                	beqz	a0,4f12 <bigfile+0x18e>
    if(cc != SZ/2){
    4e40:	12c00793          	li	a5,300
    4e44:	08f51b63          	bne	a0,a5,4eda <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4e48:	01f4d79b          	srliw	a5,s1,0x1f
    4e4c:	9fa5                	addw	a5,a5,s1
    4e4e:	4017d79b          	sraiw	a5,a5,0x1
    4e52:	00094703          	lbu	a4,0(s2)
    4e56:	0af71063          	bne	a4,a5,4ef6 <bigfile+0x172>
    4e5a:	12b94703          	lbu	a4,299(s2)
    4e5e:	08f71c63          	bne	a4,a5,4ef6 <bigfile+0x172>
    total += cc;
    4e62:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e66:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e68:	b7c9                	j	4e2a <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e6a:	85d6                	mv	a1,s5
    4e6c:	00003517          	auipc	a0,0x3
    4e70:	d7450513          	addi	a0,a0,-652 # 7be0 <malloc+0x1ec6>
    4e74:	00001097          	auipc	ra,0x1
    4e78:	dee080e7          	jalr	-530(ra) # 5c62 <printf>
    exit(1);
    4e7c:	4505                	li	a0,1
    4e7e:	00001097          	auipc	ra,0x1
    4e82:	a6c080e7          	jalr	-1428(ra) # 58ea <exit>
      printf("%s: write bigfile failed\n", s);
    4e86:	85d6                	mv	a1,s5
    4e88:	00003517          	auipc	a0,0x3
    4e8c:	d7850513          	addi	a0,a0,-648 # 7c00 <malloc+0x1ee6>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	dd2080e7          	jalr	-558(ra) # 5c62 <printf>
      exit(1);
    4e98:	4505                	li	a0,1
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	a50080e7          	jalr	-1456(ra) # 58ea <exit>
    printf("%s: cannot open bigfile\n", s);
    4ea2:	85d6                	mv	a1,s5
    4ea4:	00003517          	auipc	a0,0x3
    4ea8:	d7c50513          	addi	a0,a0,-644 # 7c20 <malloc+0x1f06>
    4eac:	00001097          	auipc	ra,0x1
    4eb0:	db6080e7          	jalr	-586(ra) # 5c62 <printf>
    exit(1);
    4eb4:	4505                	li	a0,1
    4eb6:	00001097          	auipc	ra,0x1
    4eba:	a34080e7          	jalr	-1484(ra) # 58ea <exit>
      printf("%s: read bigfile failed\n", s);
    4ebe:	85d6                	mv	a1,s5
    4ec0:	00003517          	auipc	a0,0x3
    4ec4:	d8050513          	addi	a0,a0,-640 # 7c40 <malloc+0x1f26>
    4ec8:	00001097          	auipc	ra,0x1
    4ecc:	d9a080e7          	jalr	-614(ra) # 5c62 <printf>
      exit(1);
    4ed0:	4505                	li	a0,1
    4ed2:	00001097          	auipc	ra,0x1
    4ed6:	a18080e7          	jalr	-1512(ra) # 58ea <exit>
      printf("%s: short read bigfile\n", s);
    4eda:	85d6                	mv	a1,s5
    4edc:	00003517          	auipc	a0,0x3
    4ee0:	d8450513          	addi	a0,a0,-636 # 7c60 <malloc+0x1f46>
    4ee4:	00001097          	auipc	ra,0x1
    4ee8:	d7e080e7          	jalr	-642(ra) # 5c62 <printf>
      exit(1);
    4eec:	4505                	li	a0,1
    4eee:	00001097          	auipc	ra,0x1
    4ef2:	9fc080e7          	jalr	-1540(ra) # 58ea <exit>
      printf("%s: read bigfile wrong data\n", s);
    4ef6:	85d6                	mv	a1,s5
    4ef8:	00003517          	auipc	a0,0x3
    4efc:	d8050513          	addi	a0,a0,-640 # 7c78 <malloc+0x1f5e>
    4f00:	00001097          	auipc	ra,0x1
    4f04:	d62080e7          	jalr	-670(ra) # 5c62 <printf>
      exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	9e0080e7          	jalr	-1568(ra) # 58ea <exit>
  close(fd);
    4f12:	8552                	mv	a0,s4
    4f14:	00001097          	auipc	ra,0x1
    4f18:	9fe080e7          	jalr	-1538(ra) # 5912 <close>
  if(total != N*SZ){
    4f1c:	678d                	lui	a5,0x3
    4f1e:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0xb2>
    4f22:	02f99363          	bne	s3,a5,4f48 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4f26:	00003517          	auipc	a0,0x3
    4f2a:	caa50513          	addi	a0,a0,-854 # 7bd0 <malloc+0x1eb6>
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	a0c080e7          	jalr	-1524(ra) # 593a <unlink>
}
    4f36:	70e2                	ld	ra,56(sp)
    4f38:	7442                	ld	s0,48(sp)
    4f3a:	74a2                	ld	s1,40(sp)
    4f3c:	7902                	ld	s2,32(sp)
    4f3e:	69e2                	ld	s3,24(sp)
    4f40:	6a42                	ld	s4,16(sp)
    4f42:	6aa2                	ld	s5,8(sp)
    4f44:	6121                	addi	sp,sp,64
    4f46:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4f48:	85d6                	mv	a1,s5
    4f4a:	00003517          	auipc	a0,0x3
    4f4e:	d4e50513          	addi	a0,a0,-690 # 7c98 <malloc+0x1f7e>
    4f52:	00001097          	auipc	ra,0x1
    4f56:	d10080e7          	jalr	-752(ra) # 5c62 <printf>
    exit(1);
    4f5a:	4505                	li	a0,1
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	98e080e7          	jalr	-1650(ra) # 58ea <exit>

0000000000004f64 <fsfull>:
{
    4f64:	7135                	addi	sp,sp,-160
    4f66:	ed06                	sd	ra,152(sp)
    4f68:	e922                	sd	s0,144(sp)
    4f6a:	e526                	sd	s1,136(sp)
    4f6c:	e14a                	sd	s2,128(sp)
    4f6e:	fcce                	sd	s3,120(sp)
    4f70:	f8d2                	sd	s4,112(sp)
    4f72:	f4d6                	sd	s5,104(sp)
    4f74:	f0da                	sd	s6,96(sp)
    4f76:	ecde                	sd	s7,88(sp)
    4f78:	e8e2                	sd	s8,80(sp)
    4f7a:	e4e6                	sd	s9,72(sp)
    4f7c:	e0ea                	sd	s10,64(sp)
    4f7e:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    4f80:	00003517          	auipc	a0,0x3
    4f84:	d3850513          	addi	a0,a0,-712 # 7cb8 <malloc+0x1f9e>
    4f88:	00001097          	auipc	ra,0x1
    4f8c:	cda080e7          	jalr	-806(ra) # 5c62 <printf>
  for(nfiles = 0; ; nfiles++){
    4f90:	4481                	li	s1,0
    name[0] = 'f';
    4f92:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f96:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f9a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f9e:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4fa0:	00003c97          	auipc	s9,0x3
    4fa4:	d28c8c93          	addi	s9,s9,-728 # 7cc8 <malloc+0x1fae>
    name[0] = 'f';
    4fa8:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4fac:	0384c7bb          	divw	a5,s1,s8
    4fb0:	0307879b          	addiw	a5,a5,48
    4fb4:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4fb8:	0384e7bb          	remw	a5,s1,s8
    4fbc:	0377c7bb          	divw	a5,a5,s7
    4fc0:	0307879b          	addiw	a5,a5,48
    4fc4:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4fc8:	0374e7bb          	remw	a5,s1,s7
    4fcc:	0367c7bb          	divw	a5,a5,s6
    4fd0:	0307879b          	addiw	a5,a5,48
    4fd4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4fd8:	0364e7bb          	remw	a5,s1,s6
    4fdc:	0307879b          	addiw	a5,a5,48
    4fe0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4fe4:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4fe8:	f6040593          	addi	a1,s0,-160
    4fec:	8566                	mv	a0,s9
    4fee:	00001097          	auipc	ra,0x1
    4ff2:	c74080e7          	jalr	-908(ra) # 5c62 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ff6:	20200593          	li	a1,514
    4ffa:	f6040513          	addi	a0,s0,-160
    4ffe:	00001097          	auipc	ra,0x1
    5002:	92c080e7          	jalr	-1748(ra) # 592a <open>
    5006:	892a                	mv	s2,a0
    if(fd < 0){
    5008:	0a055563          	bgez	a0,50b2 <fsfull+0x14e>
      printf("open %s failed\n", name);
    500c:	f6040593          	addi	a1,s0,-160
    5010:	00003517          	auipc	a0,0x3
    5014:	cc850513          	addi	a0,a0,-824 # 7cd8 <malloc+0x1fbe>
    5018:	00001097          	auipc	ra,0x1
    501c:	c4a080e7          	jalr	-950(ra) # 5c62 <printf>
  while(nfiles >= 0){
    5020:	0604c363          	bltz	s1,5086 <fsfull+0x122>
    name[0] = 'f';
    5024:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5028:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    502c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5030:	4929                	li	s2,10
  while(nfiles >= 0){
    5032:	5afd                	li	s5,-1
    name[0] = 'f';
    5034:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5038:	0344c7bb          	divw	a5,s1,s4
    503c:	0307879b          	addiw	a5,a5,48
    5040:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5044:	0344e7bb          	remw	a5,s1,s4
    5048:	0337c7bb          	divw	a5,a5,s3
    504c:	0307879b          	addiw	a5,a5,48
    5050:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5054:	0334e7bb          	remw	a5,s1,s3
    5058:	0327c7bb          	divw	a5,a5,s2
    505c:	0307879b          	addiw	a5,a5,48
    5060:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5064:	0324e7bb          	remw	a5,s1,s2
    5068:	0307879b          	addiw	a5,a5,48
    506c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5070:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5074:	f6040513          	addi	a0,s0,-160
    5078:	00001097          	auipc	ra,0x1
    507c:	8c2080e7          	jalr	-1854(ra) # 593a <unlink>
    nfiles--;
    5080:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5082:	fb5499e3          	bne	s1,s5,5034 <fsfull+0xd0>
  printf("fsfull test finished\n");
    5086:	00003517          	auipc	a0,0x3
    508a:	c7250513          	addi	a0,a0,-910 # 7cf8 <malloc+0x1fde>
    508e:	00001097          	auipc	ra,0x1
    5092:	bd4080e7          	jalr	-1068(ra) # 5c62 <printf>
}
    5096:	60ea                	ld	ra,152(sp)
    5098:	644a                	ld	s0,144(sp)
    509a:	64aa                	ld	s1,136(sp)
    509c:	690a                	ld	s2,128(sp)
    509e:	79e6                	ld	s3,120(sp)
    50a0:	7a46                	ld	s4,112(sp)
    50a2:	7aa6                	ld	s5,104(sp)
    50a4:	7b06                	ld	s6,96(sp)
    50a6:	6be6                	ld	s7,88(sp)
    50a8:	6c46                	ld	s8,80(sp)
    50aa:	6ca6                	ld	s9,72(sp)
    50ac:	6d06                	ld	s10,64(sp)
    50ae:	610d                	addi	sp,sp,160
    50b0:	8082                	ret
    int total = 0;
    50b2:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    50b4:	00008a97          	auipc	s5,0x8
    50b8:	064a8a93          	addi	s5,s5,100 # d118 <buf>
      if(cc < BSIZE)
    50bc:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    50c0:	40000613          	li	a2,1024
    50c4:	85d6                	mv	a1,s5
    50c6:	854a                	mv	a0,s2
    50c8:	00001097          	auipc	ra,0x1
    50cc:	842080e7          	jalr	-1982(ra) # 590a <write>
      if(cc < BSIZE)
    50d0:	00aa5563          	bge	s4,a0,50da <fsfull+0x176>
      total += cc;
    50d4:	00a989bb          	addw	s3,s3,a0
    while(1){
    50d8:	b7e5                	j	50c0 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    50da:	85ce                	mv	a1,s3
    50dc:	00003517          	auipc	a0,0x3
    50e0:	c0c50513          	addi	a0,a0,-1012 # 7ce8 <malloc+0x1fce>
    50e4:	00001097          	auipc	ra,0x1
    50e8:	b7e080e7          	jalr	-1154(ra) # 5c62 <printf>
    close(fd);
    50ec:	854a                	mv	a0,s2
    50ee:	00001097          	auipc	ra,0x1
    50f2:	824080e7          	jalr	-2012(ra) # 5912 <close>
    if(total == 0)
    50f6:	f20985e3          	beqz	s3,5020 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    50fa:	2485                	addiw	s1,s1,1
    50fc:	b575                	j	4fa8 <fsfull+0x44>

00000000000050fe <badwrite>:
{
    50fe:	7179                	addi	sp,sp,-48
    5100:	f406                	sd	ra,40(sp)
    5102:	f022                	sd	s0,32(sp)
    5104:	ec26                	sd	s1,24(sp)
    5106:	e84a                	sd	s2,16(sp)
    5108:	e44e                	sd	s3,8(sp)
    510a:	e052                	sd	s4,0(sp)
    510c:	1800                	addi	s0,sp,48
  unlink("junk");
    510e:	00003517          	auipc	a0,0x3
    5112:	c0250513          	addi	a0,a0,-1022 # 7d10 <malloc+0x1ff6>
    5116:	00001097          	auipc	ra,0x1
    511a:	824080e7          	jalr	-2012(ra) # 593a <unlink>
    511e:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    5122:	00003997          	auipc	s3,0x3
    5126:	bee98993          	addi	s3,s3,-1042 # 7d10 <malloc+0x1ff6>
    write(fd, (char*)0xffffffffffL, 1);
    512a:	5a7d                	li	s4,-1
    512c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    5130:	20100593          	li	a1,513
    5134:	854e                	mv	a0,s3
    5136:	00000097          	auipc	ra,0x0
    513a:	7f4080e7          	jalr	2036(ra) # 592a <open>
    513e:	84aa                	mv	s1,a0
    if(fd < 0){
    5140:	06054b63          	bltz	a0,51b6 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    5144:	4605                	li	a2,1
    5146:	85d2                	mv	a1,s4
    5148:	00000097          	auipc	ra,0x0
    514c:	7c2080e7          	jalr	1986(ra) # 590a <write>
    close(fd);
    5150:	8526                	mv	a0,s1
    5152:	00000097          	auipc	ra,0x0
    5156:	7c0080e7          	jalr	1984(ra) # 5912 <close>
    unlink("junk");
    515a:	854e                	mv	a0,s3
    515c:	00000097          	auipc	ra,0x0
    5160:	7de080e7          	jalr	2014(ra) # 593a <unlink>
  for(int i = 0; i < assumed_free; i++){
    5164:	397d                	addiw	s2,s2,-1
    5166:	fc0915e3          	bnez	s2,5130 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    516a:	20100593          	li	a1,513
    516e:	00003517          	auipc	a0,0x3
    5172:	ba250513          	addi	a0,a0,-1118 # 7d10 <malloc+0x1ff6>
    5176:	00000097          	auipc	ra,0x0
    517a:	7b4080e7          	jalr	1972(ra) # 592a <open>
    517e:	84aa                	mv	s1,a0
  if(fd < 0){
    5180:	04054863          	bltz	a0,51d0 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5184:	4605                	li	a2,1
    5186:	00001597          	auipc	a1,0x1
    518a:	d4258593          	addi	a1,a1,-702 # 5ec8 <malloc+0x1ae>
    518e:	00000097          	auipc	ra,0x0
    5192:	77c080e7          	jalr	1916(ra) # 590a <write>
    5196:	4785                	li	a5,1
    5198:	04f50963          	beq	a0,a5,51ea <badwrite+0xec>
    printf("write failed\n");
    519c:	00003517          	auipc	a0,0x3
    51a0:	b9450513          	addi	a0,a0,-1132 # 7d30 <malloc+0x2016>
    51a4:	00001097          	auipc	ra,0x1
    51a8:	abe080e7          	jalr	-1346(ra) # 5c62 <printf>
    exit(1);
    51ac:	4505                	li	a0,1
    51ae:	00000097          	auipc	ra,0x0
    51b2:	73c080e7          	jalr	1852(ra) # 58ea <exit>
      printf("open junk failed\n");
    51b6:	00003517          	auipc	a0,0x3
    51ba:	b6250513          	addi	a0,a0,-1182 # 7d18 <malloc+0x1ffe>
    51be:	00001097          	auipc	ra,0x1
    51c2:	aa4080e7          	jalr	-1372(ra) # 5c62 <printf>
      exit(1);
    51c6:	4505                	li	a0,1
    51c8:	00000097          	auipc	ra,0x0
    51cc:	722080e7          	jalr	1826(ra) # 58ea <exit>
    printf("open junk failed\n");
    51d0:	00003517          	auipc	a0,0x3
    51d4:	b4850513          	addi	a0,a0,-1208 # 7d18 <malloc+0x1ffe>
    51d8:	00001097          	auipc	ra,0x1
    51dc:	a8a080e7          	jalr	-1398(ra) # 5c62 <printf>
    exit(1);
    51e0:	4505                	li	a0,1
    51e2:	00000097          	auipc	ra,0x0
    51e6:	708080e7          	jalr	1800(ra) # 58ea <exit>
  close(fd);
    51ea:	8526                	mv	a0,s1
    51ec:	00000097          	auipc	ra,0x0
    51f0:	726080e7          	jalr	1830(ra) # 5912 <close>
  unlink("junk");
    51f4:	00003517          	auipc	a0,0x3
    51f8:	b1c50513          	addi	a0,a0,-1252 # 7d10 <malloc+0x1ff6>
    51fc:	00000097          	auipc	ra,0x0
    5200:	73e080e7          	jalr	1854(ra) # 593a <unlink>
  exit(0);
    5204:	4501                	li	a0,0
    5206:	00000097          	auipc	ra,0x0
    520a:	6e4080e7          	jalr	1764(ra) # 58ea <exit>

000000000000520e <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    520e:	7139                	addi	sp,sp,-64
    5210:	fc06                	sd	ra,56(sp)
    5212:	f822                	sd	s0,48(sp)
    5214:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5216:	fc840513          	addi	a0,s0,-56
    521a:	00000097          	auipc	ra,0x0
    521e:	6e0080e7          	jalr	1760(ra) # 58fa <pipe>
    5222:	06054a63          	bltz	a0,5296 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5226:	00000097          	auipc	ra,0x0
    522a:	6bc080e7          	jalr	1724(ra) # 58e2 <fork>

  if(pid < 0){
    522e:	08054463          	bltz	a0,52b6 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5232:	e55d                	bnez	a0,52e0 <countfree+0xd2>
    5234:	f426                	sd	s1,40(sp)
    5236:	f04a                	sd	s2,32(sp)
    5238:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    523a:	fc842503          	lw	a0,-56(s0)
    523e:	00000097          	auipc	ra,0x0
    5242:	6d4080e7          	jalr	1748(ra) # 5912 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5246:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5248:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    524a:	00001997          	auipc	s3,0x1
    524e:	c7e98993          	addi	s3,s3,-898 # 5ec8 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    5252:	6505                	lui	a0,0x1
    5254:	00000097          	auipc	ra,0x0
    5258:	71e080e7          	jalr	1822(ra) # 5972 <sbrk>
      if(a == 0xffffffffffffffff){
    525c:	07250d63          	beq	a0,s2,52d6 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    5260:	6785                	lui	a5,0x1
    5262:	97aa                	add	a5,a5,a0
    5264:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9f>
      if(write(fds[1], "x", 1) != 1){
    5268:	8626                	mv	a2,s1
    526a:	85ce                	mv	a1,s3
    526c:	fcc42503          	lw	a0,-52(s0)
    5270:	00000097          	auipc	ra,0x0
    5274:	69a080e7          	jalr	1690(ra) # 590a <write>
    5278:	fc950de3          	beq	a0,s1,5252 <countfree+0x44>
        printf("write() failed in countfree()\n");
    527c:	00003517          	auipc	a0,0x3
    5280:	b0450513          	addi	a0,a0,-1276 # 7d80 <malloc+0x2066>
    5284:	00001097          	auipc	ra,0x1
    5288:	9de080e7          	jalr	-1570(ra) # 5c62 <printf>
        exit(1);
    528c:	4505                	li	a0,1
    528e:	00000097          	auipc	ra,0x0
    5292:	65c080e7          	jalr	1628(ra) # 58ea <exit>
    5296:	f426                	sd	s1,40(sp)
    5298:	f04a                	sd	s2,32(sp)
    529a:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    529c:	00003517          	auipc	a0,0x3
    52a0:	aa450513          	addi	a0,a0,-1372 # 7d40 <malloc+0x2026>
    52a4:	00001097          	auipc	ra,0x1
    52a8:	9be080e7          	jalr	-1602(ra) # 5c62 <printf>
    exit(1);
    52ac:	4505                	li	a0,1
    52ae:	00000097          	auipc	ra,0x0
    52b2:	63c080e7          	jalr	1596(ra) # 58ea <exit>
    52b6:	f426                	sd	s1,40(sp)
    52b8:	f04a                	sd	s2,32(sp)
    52ba:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    52bc:	00003517          	auipc	a0,0x3
    52c0:	aa450513          	addi	a0,a0,-1372 # 7d60 <malloc+0x2046>
    52c4:	00001097          	auipc	ra,0x1
    52c8:	99e080e7          	jalr	-1634(ra) # 5c62 <printf>
    exit(1);
    52cc:	4505                	li	a0,1
    52ce:	00000097          	auipc	ra,0x0
    52d2:	61c080e7          	jalr	1564(ra) # 58ea <exit>
      }
    }

    exit(0);
    52d6:	4501                	li	a0,0
    52d8:	00000097          	auipc	ra,0x0
    52dc:	612080e7          	jalr	1554(ra) # 58ea <exit>
    52e0:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    52e2:	fcc42503          	lw	a0,-52(s0)
    52e6:	00000097          	auipc	ra,0x0
    52ea:	62c080e7          	jalr	1580(ra) # 5912 <close>

  int n = 0;
    52ee:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    52f0:	4605                	li	a2,1
    52f2:	fc740593          	addi	a1,s0,-57
    52f6:	fc842503          	lw	a0,-56(s0)
    52fa:	00000097          	auipc	ra,0x0
    52fe:	608080e7          	jalr	1544(ra) # 5902 <read>
    if(cc < 0){
    5302:	00054563          	bltz	a0,530c <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5306:	c115                	beqz	a0,532a <countfree+0x11c>
      break;
    n += 1;
    5308:	2485                	addiw	s1,s1,1
  while(1){
    530a:	b7dd                	j	52f0 <countfree+0xe2>
    530c:	f04a                	sd	s2,32(sp)
    530e:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    5310:	00003517          	auipc	a0,0x3
    5314:	a9050513          	addi	a0,a0,-1392 # 7da0 <malloc+0x2086>
    5318:	00001097          	auipc	ra,0x1
    531c:	94a080e7          	jalr	-1718(ra) # 5c62 <printf>
      exit(1);
    5320:	4505                	li	a0,1
    5322:	00000097          	auipc	ra,0x0
    5326:	5c8080e7          	jalr	1480(ra) # 58ea <exit>
  }

  close(fds[0]);
    532a:	fc842503          	lw	a0,-56(s0)
    532e:	00000097          	auipc	ra,0x0
    5332:	5e4080e7          	jalr	1508(ra) # 5912 <close>
  wait((int*)0);
    5336:	4501                	li	a0,0
    5338:	00000097          	auipc	ra,0x0
    533c:	5ba080e7          	jalr	1466(ra) # 58f2 <wait>
  
  return n;
}
    5340:	8526                	mv	a0,s1
    5342:	74a2                	ld	s1,40(sp)
    5344:	70e2                	ld	ra,56(sp)
    5346:	7442                	ld	s0,48(sp)
    5348:	6121                	addi	sp,sp,64
    534a:	8082                	ret

000000000000534c <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    534c:	7179                	addi	sp,sp,-48
    534e:	f406                	sd	ra,40(sp)
    5350:	f022                	sd	s0,32(sp)
    5352:	ec26                	sd	s1,24(sp)
    5354:	e84a                	sd	s2,16(sp)
    5356:	1800                	addi	s0,sp,48
    5358:	84aa                	mv	s1,a0
    535a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    535c:	00003517          	auipc	a0,0x3
    5360:	a6450513          	addi	a0,a0,-1436 # 7dc0 <malloc+0x20a6>
    5364:	00001097          	auipc	ra,0x1
    5368:	8fe080e7          	jalr	-1794(ra) # 5c62 <printf>
  if((pid = fork()) < 0) {
    536c:	00000097          	auipc	ra,0x0
    5370:	576080e7          	jalr	1398(ra) # 58e2 <fork>
    5374:	02054e63          	bltz	a0,53b0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5378:	c929                	beqz	a0,53ca <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    537a:	fdc40513          	addi	a0,s0,-36
    537e:	00000097          	auipc	ra,0x0
    5382:	574080e7          	jalr	1396(ra) # 58f2 <wait>
    if(xstatus != 0) 
    5386:	fdc42783          	lw	a5,-36(s0)
    538a:	c7b9                	beqz	a5,53d8 <run+0x8c>
      printf("FAILED\n");
    538c:	00003517          	auipc	a0,0x3
    5390:	a5c50513          	addi	a0,a0,-1444 # 7de8 <malloc+0x20ce>
    5394:	00001097          	auipc	ra,0x1
    5398:	8ce080e7          	jalr	-1842(ra) # 5c62 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    539c:	fdc42503          	lw	a0,-36(s0)
  }
}
    53a0:	00153513          	seqz	a0,a0
    53a4:	70a2                	ld	ra,40(sp)
    53a6:	7402                	ld	s0,32(sp)
    53a8:	64e2                	ld	s1,24(sp)
    53aa:	6942                	ld	s2,16(sp)
    53ac:	6145                	addi	sp,sp,48
    53ae:	8082                	ret
    printf("runtest: fork error\n");
    53b0:	00003517          	auipc	a0,0x3
    53b4:	a2050513          	addi	a0,a0,-1504 # 7dd0 <malloc+0x20b6>
    53b8:	00001097          	auipc	ra,0x1
    53bc:	8aa080e7          	jalr	-1878(ra) # 5c62 <printf>
    exit(1);
    53c0:	4505                	li	a0,1
    53c2:	00000097          	auipc	ra,0x0
    53c6:	528080e7          	jalr	1320(ra) # 58ea <exit>
    f(s);
    53ca:	854a                	mv	a0,s2
    53cc:	9482                	jalr	s1
    exit(0);
    53ce:	4501                	li	a0,0
    53d0:	00000097          	auipc	ra,0x0
    53d4:	51a080e7          	jalr	1306(ra) # 58ea <exit>
      printf("OK\n");
    53d8:	00003517          	auipc	a0,0x3
    53dc:	a1850513          	addi	a0,a0,-1512 # 7df0 <malloc+0x20d6>
    53e0:	00001097          	auipc	ra,0x1
    53e4:	882080e7          	jalr	-1918(ra) # 5c62 <printf>
    53e8:	bf55                	j	539c <run+0x50>

00000000000053ea <main>:

int
main(int argc, char *argv[])
{
    53ea:	bd010113          	addi	sp,sp,-1072
    53ee:	42113423          	sd	ra,1064(sp)
    53f2:	42813023          	sd	s0,1056(sp)
    53f6:	41313423          	sd	s3,1032(sp)
    53fa:	43010413          	addi	s0,sp,1072
    53fe:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5400:	4789                	li	a5,2
    5402:	0af50a63          	beq	a0,a5,54b6 <main+0xcc>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5406:	4785                	li	a5,1
    5408:	16a7c263          	blt	a5,a0,556c <main+0x182>
  char *justone = 0;
    540c:	4981                	li	s3,0
    540e:	40913c23          	sd	s1,1048(sp)
    5412:	41213823          	sd	s2,1040(sp)
    5416:	41413023          	sd	s4,1024(sp)
    541a:	3f513c23          	sd	s5,1016(sp)
    541e:	3f613823          	sd	s6,1008(sp)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5422:	00003797          	auipc	a5,0x3
    5426:	dee78793          	addi	a5,a5,-530 # 8210 <malloc+0x24f6>
    542a:	bd040713          	addi	a4,s0,-1072
    542e:	00003317          	auipc	t1,0x3
    5432:	1d230313          	addi	t1,t1,466 # 8600 <malloc+0x28e6>
    5436:	0007b883          	ld	a7,0(a5)
    543a:	0087b803          	ld	a6,8(a5)
    543e:	6b88                	ld	a0,16(a5)
    5440:	6f8c                	ld	a1,24(a5)
    5442:	7390                	ld	a2,32(a5)
    5444:	7794                	ld	a3,40(a5)
    5446:	01173023          	sd	a7,0(a4)
    544a:	01073423          	sd	a6,8(a4)
    544e:	eb08                	sd	a0,16(a4)
    5450:	ef0c                	sd	a1,24(a4)
    5452:	f310                	sd	a2,32(a4)
    5454:	f714                	sd	a3,40(a4)
    5456:	03078793          	addi	a5,a5,48
    545a:	03070713          	addi	a4,a4,48
    545e:	fc679ce3          	bne	a5,t1,5436 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5462:	00003517          	auipc	a0,0x3
    5466:	a4e50513          	addi	a0,a0,-1458 # 7eb0 <malloc+0x2196>
    546a:	00000097          	auipc	ra,0x0
    546e:	7f8080e7          	jalr	2040(ra) # 5c62 <printf>
  int free0 = countfree();
    5472:	00000097          	auipc	ra,0x0
    5476:	d9c080e7          	jalr	-612(ra) # 520e <countfree>
    547a:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    547c:	bd843903          	ld	s2,-1064(s0)
    5480:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5484:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5486:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    5488:	14091163          	bnez	s2,55ca <main+0x1e0>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    548c:	00000097          	auipc	ra,0x0
    5490:	d82080e7          	jalr	-638(ra) # 520e <countfree>
    5494:	85aa                	mv	a1,a0
    5496:	17555b63          	bge	a0,s5,560c <main+0x222>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    549a:	8656                	mv	a2,s5
    549c:	00003517          	auipc	a0,0x3
    54a0:	9cc50513          	addi	a0,a0,-1588 # 7e68 <malloc+0x214e>
    54a4:	00000097          	auipc	ra,0x0
    54a8:	7be080e7          	jalr	1982(ra) # 5c62 <printf>
    exit(1);
    54ac:	4505                	li	a0,1
    54ae:	00000097          	auipc	ra,0x0
    54b2:	43c080e7          	jalr	1084(ra) # 58ea <exit>
    54b6:	40913c23          	sd	s1,1048(sp)
    54ba:	41213823          	sd	s2,1040(sp)
    54be:	41413023          	sd	s4,1024(sp)
    54c2:	3f513c23          	sd	s5,1016(sp)
    54c6:	3f613823          	sd	s6,1008(sp)
    54ca:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    54cc:	00003597          	auipc	a1,0x3
    54d0:	92c58593          	addi	a1,a1,-1748 # 7df8 <malloc+0x20de>
    54d4:	6488                	ld	a0,8(s1)
    54d6:	00000097          	auipc	ra,0x0
    54da:	1ae080e7          	jalr	430(ra) # 5684 <strcmp>
    54de:	e525                	bnez	a0,5546 <main+0x15c>
    continuous = 1;
    54e0:	4985                	li	s3,1
  } tests[] = {
    54e2:	00003797          	auipc	a5,0x3
    54e6:	d2e78793          	addi	a5,a5,-722 # 8210 <malloc+0x24f6>
    54ea:	bd040713          	addi	a4,s0,-1072
    54ee:	00003317          	auipc	t1,0x3
    54f2:	11230313          	addi	t1,t1,274 # 8600 <malloc+0x28e6>
    54f6:	0007b883          	ld	a7,0(a5)
    54fa:	0087b803          	ld	a6,8(a5)
    54fe:	6b88                	ld	a0,16(a5)
    5500:	6f8c                	ld	a1,24(a5)
    5502:	7390                	ld	a2,32(a5)
    5504:	7794                	ld	a3,40(a5)
    5506:	01173023          	sd	a7,0(a4)
    550a:	01073423          	sd	a6,8(a4)
    550e:	eb08                	sd	a0,16(a4)
    5510:	ef0c                	sd	a1,24(a4)
    5512:	f310                	sd	a2,32(a4)
    5514:	f714                	sd	a3,40(a4)
    5516:	03078793          	addi	a5,a5,48
    551a:	03070713          	addi	a4,a4,48
    551e:	fc679ce3          	bne	a5,t1,54f6 <main+0x10c>
    printf("continuous usertests starting\n");
    5522:	00003517          	auipc	a0,0x3
    5526:	9a650513          	addi	a0,a0,-1626 # 7ec8 <malloc+0x21ae>
    552a:	00000097          	auipc	ra,0x0
    552e:	738080e7          	jalr	1848(ra) # 5c62 <printf>
        printf("SOME TESTS FAILED\n");
    5532:	00003a97          	auipc	s5,0x3
    5536:	91ea8a93          	addi	s5,s5,-1762 # 7e50 <malloc+0x2136>
        if(continuous != 2)
    553a:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    553c:	00003b17          	auipc	s6,0x3
    5540:	8f4b0b13          	addi	s6,s6,-1804 # 7e30 <malloc+0x2116>
    5544:	a8f5                	j	5640 <main+0x256>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5546:	00003597          	auipc	a1,0x3
    554a:	8ba58593          	addi	a1,a1,-1862 # 7e00 <malloc+0x20e6>
    554e:	6488                	ld	a0,8(s1)
    5550:	00000097          	auipc	ra,0x0
    5554:	134080e7          	jalr	308(ra) # 5684 <strcmp>
    5558:	d549                	beqz	a0,54e2 <main+0xf8>
  } else if(argc == 2 && argv[1][0] != '-'){
    555a:	0084b983          	ld	s3,8(s1)
    555e:	0009c703          	lbu	a4,0(s3)
    5562:	02d00793          	li	a5,45
    5566:	eaf71ee3          	bne	a4,a5,5422 <main+0x38>
    556a:	a819                	j	5580 <main+0x196>
    556c:	40913c23          	sd	s1,1048(sp)
    5570:	41213823          	sd	s2,1040(sp)
    5574:	41413023          	sd	s4,1024(sp)
    5578:	3f513c23          	sd	s5,1016(sp)
    557c:	3f613823          	sd	s6,1008(sp)
    printf("Usage: usertests [-c] [testname]\n");
    5580:	00003517          	auipc	a0,0x3
    5584:	88850513          	addi	a0,a0,-1912 # 7e08 <malloc+0x20ee>
    5588:	00000097          	auipc	ra,0x0
    558c:	6da080e7          	jalr	1754(ra) # 5c62 <printf>
    exit(1);
    5590:	4505                	li	a0,1
    5592:	00000097          	auipc	ra,0x0
    5596:	358080e7          	jalr	856(ra) # 58ea <exit>
          exit(1);
    559a:	4505                	li	a0,1
    559c:	00000097          	auipc	ra,0x0
    55a0:	34e080e7          	jalr	846(ra) # 58ea <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55a4:	40a905bb          	subw	a1,s2,a0
    55a8:	855a                	mv	a0,s6
    55aa:	00000097          	auipc	ra,0x0
    55ae:	6b8080e7          	jalr	1720(ra) # 5c62 <printf>
        if(continuous != 2)
    55b2:	09498763          	beq	s3,s4,5640 <main+0x256>
          exit(1);
    55b6:	4505                	li	a0,1
    55b8:	00000097          	auipc	ra,0x0
    55bc:	332080e7          	jalr	818(ra) # 58ea <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    55c0:	04c1                	addi	s1,s1,16
    55c2:	0084b903          	ld	s2,8(s1)
    55c6:	02090463          	beqz	s2,55ee <main+0x204>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55ca:	00098963          	beqz	s3,55dc <main+0x1f2>
    55ce:	85ce                	mv	a1,s3
    55d0:	854a                	mv	a0,s2
    55d2:	00000097          	auipc	ra,0x0
    55d6:	0b2080e7          	jalr	178(ra) # 5684 <strcmp>
    55da:	f17d                	bnez	a0,55c0 <main+0x1d6>
      if(!run(t->f, t->s))
    55dc:	85ca                	mv	a1,s2
    55de:	6088                	ld	a0,0(s1)
    55e0:	00000097          	auipc	ra,0x0
    55e4:	d6c080e7          	jalr	-660(ra) # 534c <run>
    55e8:	fd61                	bnez	a0,55c0 <main+0x1d6>
        fail = 1;
    55ea:	8a5a                	mv	s4,s6
    55ec:	bfd1                	j	55c0 <main+0x1d6>
  if(fail){
    55ee:	e80a0fe3          	beqz	s4,548c <main+0xa2>
    printf("SOME TESTS FAILED\n");
    55f2:	00003517          	auipc	a0,0x3
    55f6:	85e50513          	addi	a0,a0,-1954 # 7e50 <malloc+0x2136>
    55fa:	00000097          	auipc	ra,0x0
    55fe:	668080e7          	jalr	1640(ra) # 5c62 <printf>
    exit(1);
    5602:	4505                	li	a0,1
    5604:	00000097          	auipc	ra,0x0
    5608:	2e6080e7          	jalr	742(ra) # 58ea <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    560c:	00003517          	auipc	a0,0x3
    5610:	88c50513          	addi	a0,a0,-1908 # 7e98 <malloc+0x217e>
    5614:	00000097          	auipc	ra,0x0
    5618:	64e080e7          	jalr	1614(ra) # 5c62 <printf>
    exit(0);
    561c:	4501                	li	a0,0
    561e:	00000097          	auipc	ra,0x0
    5622:	2cc080e7          	jalr	716(ra) # 58ea <exit>
        printf("SOME TESTS FAILED\n");
    5626:	8556                	mv	a0,s5
    5628:	00000097          	auipc	ra,0x0
    562c:	63a080e7          	jalr	1594(ra) # 5c62 <printf>
        if(continuous != 2)
    5630:	f74995e3          	bne	s3,s4,559a <main+0x1b0>
      int free1 = countfree();
    5634:	00000097          	auipc	ra,0x0
    5638:	bda080e7          	jalr	-1062(ra) # 520e <countfree>
      if(free1 < free0){
    563c:	f72544e3          	blt	a0,s2,55a4 <main+0x1ba>
      int free0 = countfree();
    5640:	00000097          	auipc	ra,0x0
    5644:	bce080e7          	jalr	-1074(ra) # 520e <countfree>
    5648:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    564a:	bd843583          	ld	a1,-1064(s0)
    564e:	d1fd                	beqz	a1,5634 <main+0x24a>
    5650:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    5654:	6088                	ld	a0,0(s1)
    5656:	00000097          	auipc	ra,0x0
    565a:	cf6080e7          	jalr	-778(ra) # 534c <run>
    565e:	d561                	beqz	a0,5626 <main+0x23c>
      for (struct test *t = tests; t->s != 0; t++) {
    5660:	04c1                	addi	s1,s1,16
    5662:	648c                	ld	a1,8(s1)
    5664:	f9e5                	bnez	a1,5654 <main+0x26a>
    5666:	b7f9                	j	5634 <main+0x24a>

0000000000005668 <strcpy>:



char*
strcpy(char *s, const char *t)
{
    5668:	1141                	addi	sp,sp,-16
    566a:	e422                	sd	s0,8(sp)
    566c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    566e:	87aa                	mv	a5,a0
    5670:	0585                	addi	a1,a1,1
    5672:	0785                	addi	a5,a5,1
    5674:	fff5c703          	lbu	a4,-1(a1)
    5678:	fee78fa3          	sb	a4,-1(a5)
    567c:	fb75                	bnez	a4,5670 <strcpy+0x8>
    ;
  return os;
}
    567e:	6422                	ld	s0,8(sp)
    5680:	0141                	addi	sp,sp,16
    5682:	8082                	ret

0000000000005684 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5684:	1141                	addi	sp,sp,-16
    5686:	e422                	sd	s0,8(sp)
    5688:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    568a:	00054783          	lbu	a5,0(a0)
    568e:	cb91                	beqz	a5,56a2 <strcmp+0x1e>
    5690:	0005c703          	lbu	a4,0(a1)
    5694:	00f71763          	bne	a4,a5,56a2 <strcmp+0x1e>
    p++, q++;
    5698:	0505                	addi	a0,a0,1
    569a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    569c:	00054783          	lbu	a5,0(a0)
    56a0:	fbe5                	bnez	a5,5690 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    56a2:	0005c503          	lbu	a0,0(a1)
}
    56a6:	40a7853b          	subw	a0,a5,a0
    56aa:	6422                	ld	s0,8(sp)
    56ac:	0141                	addi	sp,sp,16
    56ae:	8082                	ret

00000000000056b0 <strlen>:

uint
strlen(const char *s)
{
    56b0:	1141                	addi	sp,sp,-16
    56b2:	e422                	sd	s0,8(sp)
    56b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    56b6:	00054783          	lbu	a5,0(a0)
    56ba:	cf91                	beqz	a5,56d6 <strlen+0x26>
    56bc:	0505                	addi	a0,a0,1
    56be:	87aa                	mv	a5,a0
    56c0:	86be                	mv	a3,a5
    56c2:	0785                	addi	a5,a5,1
    56c4:	fff7c703          	lbu	a4,-1(a5)
    56c8:	ff65                	bnez	a4,56c0 <strlen+0x10>
    56ca:	40a6853b          	subw	a0,a3,a0
    56ce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    56d0:	6422                	ld	s0,8(sp)
    56d2:	0141                	addi	sp,sp,16
    56d4:	8082                	ret
  for(n = 0; s[n]; n++)
    56d6:	4501                	li	a0,0
    56d8:	bfe5                	j	56d0 <strlen+0x20>

00000000000056da <memset>:

void*
memset(void *dst, int c, uint n)
{
    56da:	1141                	addi	sp,sp,-16
    56dc:	e422                	sd	s0,8(sp)
    56de:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    56e0:	ca19                	beqz	a2,56f6 <memset+0x1c>
    56e2:	87aa                	mv	a5,a0
    56e4:	1602                	slli	a2,a2,0x20
    56e6:	9201                	srli	a2,a2,0x20
    56e8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    56ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    56f0:	0785                	addi	a5,a5,1
    56f2:	fee79de3          	bne	a5,a4,56ec <memset+0x12>
  }
  return dst;
}
    56f6:	6422                	ld	s0,8(sp)
    56f8:	0141                	addi	sp,sp,16
    56fa:	8082                	ret

00000000000056fc <strchr>:

char*
strchr(const char *s, char c)
{
    56fc:	1141                	addi	sp,sp,-16
    56fe:	e422                	sd	s0,8(sp)
    5700:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5702:	00054783          	lbu	a5,0(a0)
    5706:	cb99                	beqz	a5,571c <strchr+0x20>
    if(*s == c)
    5708:	00f58763          	beq	a1,a5,5716 <strchr+0x1a>
  for(; *s; s++)
    570c:	0505                	addi	a0,a0,1
    570e:	00054783          	lbu	a5,0(a0)
    5712:	fbfd                	bnez	a5,5708 <strchr+0xc>
      return (char*)s;
  return 0;
    5714:	4501                	li	a0,0
}
    5716:	6422                	ld	s0,8(sp)
    5718:	0141                	addi	sp,sp,16
    571a:	8082                	ret
  return 0;
    571c:	4501                	li	a0,0
    571e:	bfe5                	j	5716 <strchr+0x1a>

0000000000005720 <gets>:

char*
gets(char *buf, int max)
{
    5720:	711d                	addi	sp,sp,-96
    5722:	ec86                	sd	ra,88(sp)
    5724:	e8a2                	sd	s0,80(sp)
    5726:	e4a6                	sd	s1,72(sp)
    5728:	e0ca                	sd	s2,64(sp)
    572a:	fc4e                	sd	s3,56(sp)
    572c:	f852                	sd	s4,48(sp)
    572e:	f456                	sd	s5,40(sp)
    5730:	f05a                	sd	s6,32(sp)
    5732:	ec5e                	sd	s7,24(sp)
    5734:	1080                	addi	s0,sp,96
    5736:	8baa                	mv	s7,a0
    5738:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    573a:	892a                	mv	s2,a0
    573c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    573e:	4aa9                	li	s5,10
    5740:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5742:	89a6                	mv	s3,s1
    5744:	2485                	addiw	s1,s1,1
    5746:	0344d863          	bge	s1,s4,5776 <gets+0x56>
    cc = read(0, &c, 1);
    574a:	4605                	li	a2,1
    574c:	faf40593          	addi	a1,s0,-81
    5750:	4501                	li	a0,0
    5752:	00000097          	auipc	ra,0x0
    5756:	1b0080e7          	jalr	432(ra) # 5902 <read>
    if(cc < 1)
    575a:	00a05e63          	blez	a0,5776 <gets+0x56>
    buf[i++] = c;
    575e:	faf44783          	lbu	a5,-81(s0)
    5762:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5766:	01578763          	beq	a5,s5,5774 <gets+0x54>
    576a:	0905                	addi	s2,s2,1
    576c:	fd679be3          	bne	a5,s6,5742 <gets+0x22>
    buf[i++] = c;
    5770:	89a6                	mv	s3,s1
    5772:	a011                	j	5776 <gets+0x56>
    5774:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5776:	99de                	add	s3,s3,s7
    5778:	00098023          	sb	zero,0(s3)
  return buf;
}
    577c:	855e                	mv	a0,s7
    577e:	60e6                	ld	ra,88(sp)
    5780:	6446                	ld	s0,80(sp)
    5782:	64a6                	ld	s1,72(sp)
    5784:	6906                	ld	s2,64(sp)
    5786:	79e2                	ld	s3,56(sp)
    5788:	7a42                	ld	s4,48(sp)
    578a:	7aa2                	ld	s5,40(sp)
    578c:	7b02                	ld	s6,32(sp)
    578e:	6be2                	ld	s7,24(sp)
    5790:	6125                	addi	sp,sp,96
    5792:	8082                	ret

0000000000005794 <stat>:

int
stat(const char *n, struct stat *st)
{
    5794:	1101                	addi	sp,sp,-32
    5796:	ec06                	sd	ra,24(sp)
    5798:	e822                	sd	s0,16(sp)
    579a:	e04a                	sd	s2,0(sp)
    579c:	1000                	addi	s0,sp,32
    579e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    57a0:	4581                	li	a1,0
    57a2:	00000097          	auipc	ra,0x0
    57a6:	188080e7          	jalr	392(ra) # 592a <open>
  if(fd < 0)
    57aa:	02054663          	bltz	a0,57d6 <stat+0x42>
    57ae:	e426                	sd	s1,8(sp)
    57b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    57b2:	85ca                	mv	a1,s2
    57b4:	00000097          	auipc	ra,0x0
    57b8:	18e080e7          	jalr	398(ra) # 5942 <fstat>
    57bc:	892a                	mv	s2,a0
  close(fd);
    57be:	8526                	mv	a0,s1
    57c0:	00000097          	auipc	ra,0x0
    57c4:	152080e7          	jalr	338(ra) # 5912 <close>
  return r;
    57c8:	64a2                	ld	s1,8(sp)
}
    57ca:	854a                	mv	a0,s2
    57cc:	60e2                	ld	ra,24(sp)
    57ce:	6442                	ld	s0,16(sp)
    57d0:	6902                	ld	s2,0(sp)
    57d2:	6105                	addi	sp,sp,32
    57d4:	8082                	ret
    return -1;
    57d6:	597d                	li	s2,-1
    57d8:	bfcd                	j	57ca <stat+0x36>

00000000000057da <atoi>:

int
atoi(const char *s)
{
    57da:	1141                	addi	sp,sp,-16
    57dc:	e422                	sd	s0,8(sp)
    57de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    57e0:	00054683          	lbu	a3,0(a0)
    57e4:	fd06879b          	addiw	a5,a3,-48
    57e8:	0ff7f793          	zext.b	a5,a5
    57ec:	4625                	li	a2,9
    57ee:	02f66863          	bltu	a2,a5,581e <atoi+0x44>
    57f2:	872a                	mv	a4,a0
  n = 0;
    57f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    57f6:	0705                	addi	a4,a4,1
    57f8:	0025179b          	slliw	a5,a0,0x2
    57fc:	9fa9                	addw	a5,a5,a0
    57fe:	0017979b          	slliw	a5,a5,0x1
    5802:	9fb5                	addw	a5,a5,a3
    5804:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5808:	00074683          	lbu	a3,0(a4)
    580c:	fd06879b          	addiw	a5,a3,-48
    5810:	0ff7f793          	zext.b	a5,a5
    5814:	fef671e3          	bgeu	a2,a5,57f6 <atoi+0x1c>
  return n;
}
    5818:	6422                	ld	s0,8(sp)
    581a:	0141                	addi	sp,sp,16
    581c:	8082                	ret
  n = 0;
    581e:	4501                	li	a0,0
    5820:	bfe5                	j	5818 <atoi+0x3e>

0000000000005822 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5822:	1141                	addi	sp,sp,-16
    5824:	e422                	sd	s0,8(sp)
    5826:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5828:	02b57463          	bgeu	a0,a1,5850 <memmove+0x2e>
    while(n-- > 0)
    582c:	00c05f63          	blez	a2,584a <memmove+0x28>
    5830:	1602                	slli	a2,a2,0x20
    5832:	9201                	srli	a2,a2,0x20
    5834:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5838:	872a                	mv	a4,a0
      *dst++ = *src++;
    583a:	0585                	addi	a1,a1,1
    583c:	0705                	addi	a4,a4,1
    583e:	fff5c683          	lbu	a3,-1(a1)
    5842:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5846:	fef71ae3          	bne	a4,a5,583a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    584a:	6422                	ld	s0,8(sp)
    584c:	0141                	addi	sp,sp,16
    584e:	8082                	ret
    dst += n;
    5850:	00c50733          	add	a4,a0,a2
    src += n;
    5854:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5856:	fec05ae3          	blez	a2,584a <memmove+0x28>
    585a:	fff6079b          	addiw	a5,a2,-1 # 2fff <iputtest+0x2d>
    585e:	1782                	slli	a5,a5,0x20
    5860:	9381                	srli	a5,a5,0x20
    5862:	fff7c793          	not	a5,a5
    5866:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5868:	15fd                	addi	a1,a1,-1
    586a:	177d                	addi	a4,a4,-1
    586c:	0005c683          	lbu	a3,0(a1)
    5870:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5874:	fee79ae3          	bne	a5,a4,5868 <memmove+0x46>
    5878:	bfc9                	j	584a <memmove+0x28>

000000000000587a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    587a:	1141                	addi	sp,sp,-16
    587c:	e422                	sd	s0,8(sp)
    587e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5880:	ca05                	beqz	a2,58b0 <memcmp+0x36>
    5882:	fff6069b          	addiw	a3,a2,-1
    5886:	1682                	slli	a3,a3,0x20
    5888:	9281                	srli	a3,a3,0x20
    588a:	0685                	addi	a3,a3,1
    588c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    588e:	00054783          	lbu	a5,0(a0)
    5892:	0005c703          	lbu	a4,0(a1)
    5896:	00e79863          	bne	a5,a4,58a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    589a:	0505                	addi	a0,a0,1
    p2++;
    589c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    589e:	fed518e3          	bne	a0,a3,588e <memcmp+0x14>
  }
  return 0;
    58a2:	4501                	li	a0,0
    58a4:	a019                	j	58aa <memcmp+0x30>
      return *p1 - *p2;
    58a6:	40e7853b          	subw	a0,a5,a4
}
    58aa:	6422                	ld	s0,8(sp)
    58ac:	0141                	addi	sp,sp,16
    58ae:	8082                	ret
  return 0;
    58b0:	4501                	li	a0,0
    58b2:	bfe5                	j	58aa <memcmp+0x30>

00000000000058b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    58b4:	1141                	addi	sp,sp,-16
    58b6:	e406                	sd	ra,8(sp)
    58b8:	e022                	sd	s0,0(sp)
    58ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    58bc:	00000097          	auipc	ra,0x0
    58c0:	f66080e7          	jalr	-154(ra) # 5822 <memmove>
}
    58c4:	60a2                	ld	ra,8(sp)
    58c6:	6402                	ld	s0,0(sp)
    58c8:	0141                	addi	sp,sp,16
    58ca:	8082                	ret

00000000000058cc <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
    58cc:	1141                	addi	sp,sp,-16
    58ce:	e422                	sd	s0,8(sp)
    58d0:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
    58d2:	040007b7          	lui	a5,0x4000
    58d6:	17f5                	addi	a5,a5,-3 # 3fffffd <__BSS_END__+0x3fefed5>
    58d8:	07b2                	slli	a5,a5,0xc
}
    58da:	4388                	lw	a0,0(a5)
    58dc:	6422                	ld	s0,8(sp)
    58de:	0141                	addi	sp,sp,16
    58e0:	8082                	ret

00000000000058e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    58e2:	4885                	li	a7,1
 ecall
    58e4:	00000073          	ecall
 ret
    58e8:	8082                	ret

00000000000058ea <exit>:
.global exit
exit:
 li a7, SYS_exit
    58ea:	4889                	li	a7,2
 ecall
    58ec:	00000073          	ecall
 ret
    58f0:	8082                	ret

00000000000058f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    58f2:	488d                	li	a7,3
 ecall
    58f4:	00000073          	ecall
 ret
    58f8:	8082                	ret

00000000000058fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    58fa:	4891                	li	a7,4
 ecall
    58fc:	00000073          	ecall
 ret
    5900:	8082                	ret

0000000000005902 <read>:
.global read
read:
 li a7, SYS_read
    5902:	4895                	li	a7,5
 ecall
    5904:	00000073          	ecall
 ret
    5908:	8082                	ret

000000000000590a <write>:
.global write
write:
 li a7, SYS_write
    590a:	48c1                	li	a7,16
 ecall
    590c:	00000073          	ecall
 ret
    5910:	8082                	ret

0000000000005912 <close>:
.global close
close:
 li a7, SYS_close
    5912:	48d5                	li	a7,21
 ecall
    5914:	00000073          	ecall
 ret
    5918:	8082                	ret

000000000000591a <kill>:
.global kill
kill:
 li a7, SYS_kill
    591a:	4899                	li	a7,6
 ecall
    591c:	00000073          	ecall
 ret
    5920:	8082                	ret

0000000000005922 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5922:	489d                	li	a7,7
 ecall
    5924:	00000073          	ecall
 ret
    5928:	8082                	ret

000000000000592a <open>:
.global open
open:
 li a7, SYS_open
    592a:	48bd                	li	a7,15
 ecall
    592c:	00000073          	ecall
 ret
    5930:	8082                	ret

0000000000005932 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5932:	48c5                	li	a7,17
 ecall
    5934:	00000073          	ecall
 ret
    5938:	8082                	ret

000000000000593a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    593a:	48c9                	li	a7,18
 ecall
    593c:	00000073          	ecall
 ret
    5940:	8082                	ret

0000000000005942 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5942:	48a1                	li	a7,8
 ecall
    5944:	00000073          	ecall
 ret
    5948:	8082                	ret

000000000000594a <link>:
.global link
link:
 li a7, SYS_link
    594a:	48cd                	li	a7,19
 ecall
    594c:	00000073          	ecall
 ret
    5950:	8082                	ret

0000000000005952 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5952:	48d1                	li	a7,20
 ecall
    5954:	00000073          	ecall
 ret
    5958:	8082                	ret

000000000000595a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    595a:	48a5                	li	a7,9
 ecall
    595c:	00000073          	ecall
 ret
    5960:	8082                	ret

0000000000005962 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5962:	48a9                	li	a7,10
 ecall
    5964:	00000073          	ecall
 ret
    5968:	8082                	ret

000000000000596a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    596a:	48ad                	li	a7,11
 ecall
    596c:	00000073          	ecall
 ret
    5970:	8082                	ret

0000000000005972 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5972:	48b1                	li	a7,12
 ecall
    5974:	00000073          	ecall
 ret
    5978:	8082                	ret

000000000000597a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    597a:	48b5                	li	a7,13
 ecall
    597c:	00000073          	ecall
 ret
    5980:	8082                	ret

0000000000005982 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5982:	48b9                	li	a7,14
 ecall
    5984:	00000073          	ecall
 ret
    5988:	8082                	ret

000000000000598a <connect>:
.global connect
connect:
 li a7, SYS_connect
    598a:	48f5                	li	a7,29
 ecall
    598c:	00000073          	ecall
 ret
    5990:	8082                	ret

0000000000005992 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5992:	48f9                	li	a7,30
 ecall
    5994:	00000073          	ecall
 ret
    5998:	8082                	ret

000000000000599a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    599a:	1101                	addi	sp,sp,-32
    599c:	ec06                	sd	ra,24(sp)
    599e:	e822                	sd	s0,16(sp)
    59a0:	1000                	addi	s0,sp,32
    59a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    59a6:	4605                	li	a2,1
    59a8:	fef40593          	addi	a1,s0,-17
    59ac:	00000097          	auipc	ra,0x0
    59b0:	f5e080e7          	jalr	-162(ra) # 590a <write>
}
    59b4:	60e2                	ld	ra,24(sp)
    59b6:	6442                	ld	s0,16(sp)
    59b8:	6105                	addi	sp,sp,32
    59ba:	8082                	ret

00000000000059bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    59bc:	7139                	addi	sp,sp,-64
    59be:	fc06                	sd	ra,56(sp)
    59c0:	f822                	sd	s0,48(sp)
    59c2:	f426                	sd	s1,40(sp)
    59c4:	0080                	addi	s0,sp,64
    59c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    59c8:	c299                	beqz	a3,59ce <printint+0x12>
    59ca:	0805cb63          	bltz	a1,5a60 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    59ce:	2581                	sext.w	a1,a1
  neg = 0;
    59d0:	4881                	li	a7,0
    59d2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    59d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    59d8:	2601                	sext.w	a2,a2
    59da:	00003517          	auipc	a0,0x3
    59de:	c7e50513          	addi	a0,a0,-898 # 8658 <digits>
    59e2:	883a                	mv	a6,a4
    59e4:	2705                	addiw	a4,a4,1
    59e6:	02c5f7bb          	remuw	a5,a1,a2
    59ea:	1782                	slli	a5,a5,0x20
    59ec:	9381                	srli	a5,a5,0x20
    59ee:	97aa                	add	a5,a5,a0
    59f0:	0007c783          	lbu	a5,0(a5)
    59f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    59f8:	0005879b          	sext.w	a5,a1
    59fc:	02c5d5bb          	divuw	a1,a1,a2
    5a00:	0685                	addi	a3,a3,1
    5a02:	fec7f0e3          	bgeu	a5,a2,59e2 <printint+0x26>
  if(neg)
    5a06:	00088c63          	beqz	a7,5a1e <printint+0x62>
    buf[i++] = '-';
    5a0a:	fd070793          	addi	a5,a4,-48
    5a0e:	00878733          	add	a4,a5,s0
    5a12:	02d00793          	li	a5,45
    5a16:	fef70823          	sb	a5,-16(a4)
    5a1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5a1e:	02e05c63          	blez	a4,5a56 <printint+0x9a>
    5a22:	f04a                	sd	s2,32(sp)
    5a24:	ec4e                	sd	s3,24(sp)
    5a26:	fc040793          	addi	a5,s0,-64
    5a2a:	00e78933          	add	s2,a5,a4
    5a2e:	fff78993          	addi	s3,a5,-1
    5a32:	99ba                	add	s3,s3,a4
    5a34:	377d                	addiw	a4,a4,-1
    5a36:	1702                	slli	a4,a4,0x20
    5a38:	9301                	srli	a4,a4,0x20
    5a3a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5a3e:	fff94583          	lbu	a1,-1(s2)
    5a42:	8526                	mv	a0,s1
    5a44:	00000097          	auipc	ra,0x0
    5a48:	f56080e7          	jalr	-170(ra) # 599a <putc>
  while(--i >= 0)
    5a4c:	197d                	addi	s2,s2,-1
    5a4e:	ff3918e3          	bne	s2,s3,5a3e <printint+0x82>
    5a52:	7902                	ld	s2,32(sp)
    5a54:	69e2                	ld	s3,24(sp)
}
    5a56:	70e2                	ld	ra,56(sp)
    5a58:	7442                	ld	s0,48(sp)
    5a5a:	74a2                	ld	s1,40(sp)
    5a5c:	6121                	addi	sp,sp,64
    5a5e:	8082                	ret
    x = -xx;
    5a60:	40b005bb          	negw	a1,a1
    neg = 1;
    5a64:	4885                	li	a7,1
    x = -xx;
    5a66:	b7b5                	j	59d2 <printint+0x16>

0000000000005a68 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5a68:	715d                	addi	sp,sp,-80
    5a6a:	e486                	sd	ra,72(sp)
    5a6c:	e0a2                	sd	s0,64(sp)
    5a6e:	f84a                	sd	s2,48(sp)
    5a70:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5a72:	0005c903          	lbu	s2,0(a1)
    5a76:	1a090a63          	beqz	s2,5c2a <vprintf+0x1c2>
    5a7a:	fc26                	sd	s1,56(sp)
    5a7c:	f44e                	sd	s3,40(sp)
    5a7e:	f052                	sd	s4,32(sp)
    5a80:	ec56                	sd	s5,24(sp)
    5a82:	e85a                	sd	s6,16(sp)
    5a84:	e45e                	sd	s7,8(sp)
    5a86:	8aaa                	mv	s5,a0
    5a88:	8bb2                	mv	s7,a2
    5a8a:	00158493          	addi	s1,a1,1
  state = 0;
    5a8e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a90:	02500a13          	li	s4,37
    5a94:	4b55                	li	s6,21
    5a96:	a839                	j	5ab4 <vprintf+0x4c>
        putc(fd, c);
    5a98:	85ca                	mv	a1,s2
    5a9a:	8556                	mv	a0,s5
    5a9c:	00000097          	auipc	ra,0x0
    5aa0:	efe080e7          	jalr	-258(ra) # 599a <putc>
    5aa4:	a019                	j	5aaa <vprintf+0x42>
    } else if(state == '%'){
    5aa6:	01498d63          	beq	s3,s4,5ac0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5aaa:	0485                	addi	s1,s1,1
    5aac:	fff4c903          	lbu	s2,-1(s1)
    5ab0:	16090763          	beqz	s2,5c1e <vprintf+0x1b6>
    if(state == 0){
    5ab4:	fe0999e3          	bnez	s3,5aa6 <vprintf+0x3e>
      if(c == '%'){
    5ab8:	ff4910e3          	bne	s2,s4,5a98 <vprintf+0x30>
        state = '%';
    5abc:	89d2                	mv	s3,s4
    5abe:	b7f5                	j	5aaa <vprintf+0x42>
      if(c == 'd'){
    5ac0:	13490463          	beq	s2,s4,5be8 <vprintf+0x180>
    5ac4:	f9d9079b          	addiw	a5,s2,-99
    5ac8:	0ff7f793          	zext.b	a5,a5
    5acc:	12fb6763          	bltu	s6,a5,5bfa <vprintf+0x192>
    5ad0:	f9d9079b          	addiw	a5,s2,-99
    5ad4:	0ff7f713          	zext.b	a4,a5
    5ad8:	12eb6163          	bltu	s6,a4,5bfa <vprintf+0x192>
    5adc:	00271793          	slli	a5,a4,0x2
    5ae0:	00003717          	auipc	a4,0x3
    5ae4:	b2070713          	addi	a4,a4,-1248 # 8600 <malloc+0x28e6>
    5ae8:	97ba                	add	a5,a5,a4
    5aea:	439c                	lw	a5,0(a5)
    5aec:	97ba                	add	a5,a5,a4
    5aee:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5af0:	008b8913          	addi	s2,s7,8
    5af4:	4685                	li	a3,1
    5af6:	4629                	li	a2,10
    5af8:	000ba583          	lw	a1,0(s7)
    5afc:	8556                	mv	a0,s5
    5afe:	00000097          	auipc	ra,0x0
    5b02:	ebe080e7          	jalr	-322(ra) # 59bc <printint>
    5b06:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5b08:	4981                	li	s3,0
    5b0a:	b745                	j	5aaa <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5b0c:	008b8913          	addi	s2,s7,8
    5b10:	4681                	li	a3,0
    5b12:	4629                	li	a2,10
    5b14:	000ba583          	lw	a1,0(s7)
    5b18:	8556                	mv	a0,s5
    5b1a:	00000097          	auipc	ra,0x0
    5b1e:	ea2080e7          	jalr	-350(ra) # 59bc <printint>
    5b22:	8bca                	mv	s7,s2
      state = 0;
    5b24:	4981                	li	s3,0
    5b26:	b751                	j	5aaa <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5b28:	008b8913          	addi	s2,s7,8
    5b2c:	4681                	li	a3,0
    5b2e:	4641                	li	a2,16
    5b30:	000ba583          	lw	a1,0(s7)
    5b34:	8556                	mv	a0,s5
    5b36:	00000097          	auipc	ra,0x0
    5b3a:	e86080e7          	jalr	-378(ra) # 59bc <printint>
    5b3e:	8bca                	mv	s7,s2
      state = 0;
    5b40:	4981                	li	s3,0
    5b42:	b7a5                	j	5aaa <vprintf+0x42>
    5b44:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5b46:	008b8c13          	addi	s8,s7,8
    5b4a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5b4e:	03000593          	li	a1,48
    5b52:	8556                	mv	a0,s5
    5b54:	00000097          	auipc	ra,0x0
    5b58:	e46080e7          	jalr	-442(ra) # 599a <putc>
  putc(fd, 'x');
    5b5c:	07800593          	li	a1,120
    5b60:	8556                	mv	a0,s5
    5b62:	00000097          	auipc	ra,0x0
    5b66:	e38080e7          	jalr	-456(ra) # 599a <putc>
    5b6a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b6c:	00003b97          	auipc	s7,0x3
    5b70:	aecb8b93          	addi	s7,s7,-1300 # 8658 <digits>
    5b74:	03c9d793          	srli	a5,s3,0x3c
    5b78:	97de                	add	a5,a5,s7
    5b7a:	0007c583          	lbu	a1,0(a5)
    5b7e:	8556                	mv	a0,s5
    5b80:	00000097          	auipc	ra,0x0
    5b84:	e1a080e7          	jalr	-486(ra) # 599a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b88:	0992                	slli	s3,s3,0x4
    5b8a:	397d                	addiw	s2,s2,-1
    5b8c:	fe0914e3          	bnez	s2,5b74 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5b90:	8be2                	mv	s7,s8
      state = 0;
    5b92:	4981                	li	s3,0
    5b94:	6c02                	ld	s8,0(sp)
    5b96:	bf11                	j	5aaa <vprintf+0x42>
        s = va_arg(ap, char*);
    5b98:	008b8993          	addi	s3,s7,8
    5b9c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5ba0:	02090163          	beqz	s2,5bc2 <vprintf+0x15a>
        while(*s != 0){
    5ba4:	00094583          	lbu	a1,0(s2)
    5ba8:	c9a5                	beqz	a1,5c18 <vprintf+0x1b0>
          putc(fd, *s);
    5baa:	8556                	mv	a0,s5
    5bac:	00000097          	auipc	ra,0x0
    5bb0:	dee080e7          	jalr	-530(ra) # 599a <putc>
          s++;
    5bb4:	0905                	addi	s2,s2,1
        while(*s != 0){
    5bb6:	00094583          	lbu	a1,0(s2)
    5bba:	f9e5                	bnez	a1,5baa <vprintf+0x142>
        s = va_arg(ap, char*);
    5bbc:	8bce                	mv	s7,s3
      state = 0;
    5bbe:	4981                	li	s3,0
    5bc0:	b5ed                	j	5aaa <vprintf+0x42>
          s = "(null)";
    5bc2:	00002917          	auipc	s2,0x2
    5bc6:	62690913          	addi	s2,s2,1574 # 81e8 <malloc+0x24ce>
        while(*s != 0){
    5bca:	02800593          	li	a1,40
    5bce:	bff1                	j	5baa <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5bd0:	008b8913          	addi	s2,s7,8
    5bd4:	000bc583          	lbu	a1,0(s7)
    5bd8:	8556                	mv	a0,s5
    5bda:	00000097          	auipc	ra,0x0
    5bde:	dc0080e7          	jalr	-576(ra) # 599a <putc>
    5be2:	8bca                	mv	s7,s2
      state = 0;
    5be4:	4981                	li	s3,0
    5be6:	b5d1                	j	5aaa <vprintf+0x42>
        putc(fd, c);
    5be8:	02500593          	li	a1,37
    5bec:	8556                	mv	a0,s5
    5bee:	00000097          	auipc	ra,0x0
    5bf2:	dac080e7          	jalr	-596(ra) # 599a <putc>
      state = 0;
    5bf6:	4981                	li	s3,0
    5bf8:	bd4d                	j	5aaa <vprintf+0x42>
        putc(fd, '%');
    5bfa:	02500593          	li	a1,37
    5bfe:	8556                	mv	a0,s5
    5c00:	00000097          	auipc	ra,0x0
    5c04:	d9a080e7          	jalr	-614(ra) # 599a <putc>
        putc(fd, c);
    5c08:	85ca                	mv	a1,s2
    5c0a:	8556                	mv	a0,s5
    5c0c:	00000097          	auipc	ra,0x0
    5c10:	d8e080e7          	jalr	-626(ra) # 599a <putc>
      state = 0;
    5c14:	4981                	li	s3,0
    5c16:	bd51                	j	5aaa <vprintf+0x42>
        s = va_arg(ap, char*);
    5c18:	8bce                	mv	s7,s3
      state = 0;
    5c1a:	4981                	li	s3,0
    5c1c:	b579                	j	5aaa <vprintf+0x42>
    5c1e:	74e2                	ld	s1,56(sp)
    5c20:	79a2                	ld	s3,40(sp)
    5c22:	7a02                	ld	s4,32(sp)
    5c24:	6ae2                	ld	s5,24(sp)
    5c26:	6b42                	ld	s6,16(sp)
    5c28:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5c2a:	60a6                	ld	ra,72(sp)
    5c2c:	6406                	ld	s0,64(sp)
    5c2e:	7942                	ld	s2,48(sp)
    5c30:	6161                	addi	sp,sp,80
    5c32:	8082                	ret

0000000000005c34 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5c34:	715d                	addi	sp,sp,-80
    5c36:	ec06                	sd	ra,24(sp)
    5c38:	e822                	sd	s0,16(sp)
    5c3a:	1000                	addi	s0,sp,32
    5c3c:	e010                	sd	a2,0(s0)
    5c3e:	e414                	sd	a3,8(s0)
    5c40:	e818                	sd	a4,16(s0)
    5c42:	ec1c                	sd	a5,24(s0)
    5c44:	03043023          	sd	a6,32(s0)
    5c48:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5c4c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5c50:	8622                	mv	a2,s0
    5c52:	00000097          	auipc	ra,0x0
    5c56:	e16080e7          	jalr	-490(ra) # 5a68 <vprintf>
}
    5c5a:	60e2                	ld	ra,24(sp)
    5c5c:	6442                	ld	s0,16(sp)
    5c5e:	6161                	addi	sp,sp,80
    5c60:	8082                	ret

0000000000005c62 <printf>:

void
printf(const char *fmt, ...)
{
    5c62:	711d                	addi	sp,sp,-96
    5c64:	ec06                	sd	ra,24(sp)
    5c66:	e822                	sd	s0,16(sp)
    5c68:	1000                	addi	s0,sp,32
    5c6a:	e40c                	sd	a1,8(s0)
    5c6c:	e810                	sd	a2,16(s0)
    5c6e:	ec14                	sd	a3,24(s0)
    5c70:	f018                	sd	a4,32(s0)
    5c72:	f41c                	sd	a5,40(s0)
    5c74:	03043823          	sd	a6,48(s0)
    5c78:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5c7c:	00840613          	addi	a2,s0,8
    5c80:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c84:	85aa                	mv	a1,a0
    5c86:	4505                	li	a0,1
    5c88:	00000097          	auipc	ra,0x0
    5c8c:	de0080e7          	jalr	-544(ra) # 5a68 <vprintf>
}
    5c90:	60e2                	ld	ra,24(sp)
    5c92:	6442                	ld	s0,16(sp)
    5c94:	6125                	addi	sp,sp,96
    5c96:	8082                	ret

0000000000005c98 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c98:	1141                	addi	sp,sp,-16
    5c9a:	e422                	sd	s0,8(sp)
    5c9c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c9e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ca2:	00004797          	auipc	a5,0x4
    5ca6:	c567b783          	ld	a5,-938(a5) # 98f8 <freep>
    5caa:	a02d                	j	5cd4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5cac:	4618                	lw	a4,8(a2)
    5cae:	9f2d                	addw	a4,a4,a1
    5cb0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5cb4:	6398                	ld	a4,0(a5)
    5cb6:	6310                	ld	a2,0(a4)
    5cb8:	a83d                	j	5cf6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5cba:	ff852703          	lw	a4,-8(a0)
    5cbe:	9f31                	addw	a4,a4,a2
    5cc0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5cc2:	ff053683          	ld	a3,-16(a0)
    5cc6:	a091                	j	5d0a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5cc8:	6398                	ld	a4,0(a5)
    5cca:	00e7e463          	bltu	a5,a4,5cd2 <free+0x3a>
    5cce:	00e6ea63          	bltu	a3,a4,5ce2 <free+0x4a>
{
    5cd2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5cd4:	fed7fae3          	bgeu	a5,a3,5cc8 <free+0x30>
    5cd8:	6398                	ld	a4,0(a5)
    5cda:	00e6e463          	bltu	a3,a4,5ce2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5cde:	fee7eae3          	bltu	a5,a4,5cd2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5ce2:	ff852583          	lw	a1,-8(a0)
    5ce6:	6390                	ld	a2,0(a5)
    5ce8:	02059813          	slli	a6,a1,0x20
    5cec:	01c85713          	srli	a4,a6,0x1c
    5cf0:	9736                	add	a4,a4,a3
    5cf2:	fae60de3          	beq	a2,a4,5cac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5cf6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5cfa:	4790                	lw	a2,8(a5)
    5cfc:	02061593          	slli	a1,a2,0x20
    5d00:	01c5d713          	srli	a4,a1,0x1c
    5d04:	973e                	add	a4,a4,a5
    5d06:	fae68ae3          	beq	a3,a4,5cba <free+0x22>
    p->s.ptr = bp->s.ptr;
    5d0a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5d0c:	00004717          	auipc	a4,0x4
    5d10:	bef73623          	sd	a5,-1044(a4) # 98f8 <freep>
}
    5d14:	6422                	ld	s0,8(sp)
    5d16:	0141                	addi	sp,sp,16
    5d18:	8082                	ret

0000000000005d1a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5d1a:	7139                	addi	sp,sp,-64
    5d1c:	fc06                	sd	ra,56(sp)
    5d1e:	f822                	sd	s0,48(sp)
    5d20:	f426                	sd	s1,40(sp)
    5d22:	ec4e                	sd	s3,24(sp)
    5d24:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5d26:	02051493          	slli	s1,a0,0x20
    5d2a:	9081                	srli	s1,s1,0x20
    5d2c:	04bd                	addi	s1,s1,15
    5d2e:	8091                	srli	s1,s1,0x4
    5d30:	0014899b          	addiw	s3,s1,1
    5d34:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5d36:	00004517          	auipc	a0,0x4
    5d3a:	bc253503          	ld	a0,-1086(a0) # 98f8 <freep>
    5d3e:	c915                	beqz	a0,5d72 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d42:	4798                	lw	a4,8(a5)
    5d44:	08977e63          	bgeu	a4,s1,5de0 <malloc+0xc6>
    5d48:	f04a                	sd	s2,32(sp)
    5d4a:	e852                	sd	s4,16(sp)
    5d4c:	e456                	sd	s5,8(sp)
    5d4e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5d50:	8a4e                	mv	s4,s3
    5d52:	0009871b          	sext.w	a4,s3
    5d56:	6685                	lui	a3,0x1
    5d58:	00d77363          	bgeu	a4,a3,5d5e <malloc+0x44>
    5d5c:	6a05                	lui	s4,0x1
    5d5e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5d62:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5d66:	00004917          	auipc	s2,0x4
    5d6a:	b9290913          	addi	s2,s2,-1134 # 98f8 <freep>
  if(p == (char*)-1)
    5d6e:	5afd                	li	s5,-1
    5d70:	a091                	j	5db4 <malloc+0x9a>
    5d72:	f04a                	sd	s2,32(sp)
    5d74:	e852                	sd	s4,16(sp)
    5d76:	e456                	sd	s5,8(sp)
    5d78:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5d7a:	0000a797          	auipc	a5,0xa
    5d7e:	39e78793          	addi	a5,a5,926 # 10118 <base>
    5d82:	00004717          	auipc	a4,0x4
    5d86:	b6f73b23          	sd	a5,-1162(a4) # 98f8 <freep>
    5d8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d90:	b7c1                	j	5d50 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    5d92:	6398                	ld	a4,0(a5)
    5d94:	e118                	sd	a4,0(a0)
    5d96:	a08d                	j	5df8 <malloc+0xde>
  hp->s.size = nu;
    5d98:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d9c:	0541                	addi	a0,a0,16
    5d9e:	00000097          	auipc	ra,0x0
    5da2:	efa080e7          	jalr	-262(ra) # 5c98 <free>
  return freep;
    5da6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5daa:	c13d                	beqz	a0,5e10 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5dac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5dae:	4798                	lw	a4,8(a5)
    5db0:	02977463          	bgeu	a4,s1,5dd8 <malloc+0xbe>
    if(p == freep)
    5db4:	00093703          	ld	a4,0(s2)
    5db8:	853e                	mv	a0,a5
    5dba:	fef719e3          	bne	a4,a5,5dac <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    5dbe:	8552                	mv	a0,s4
    5dc0:	00000097          	auipc	ra,0x0
    5dc4:	bb2080e7          	jalr	-1102(ra) # 5972 <sbrk>
  if(p == (char*)-1)
    5dc8:	fd5518e3          	bne	a0,s5,5d98 <malloc+0x7e>
        return 0;
    5dcc:	4501                	li	a0,0
    5dce:	7902                	ld	s2,32(sp)
    5dd0:	6a42                	ld	s4,16(sp)
    5dd2:	6aa2                	ld	s5,8(sp)
    5dd4:	6b02                	ld	s6,0(sp)
    5dd6:	a03d                	j	5e04 <malloc+0xea>
    5dd8:	7902                	ld	s2,32(sp)
    5dda:	6a42                	ld	s4,16(sp)
    5ddc:	6aa2                	ld	s5,8(sp)
    5dde:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5de0:	fae489e3          	beq	s1,a4,5d92 <malloc+0x78>
        p->s.size -= nunits;
    5de4:	4137073b          	subw	a4,a4,s3
    5de8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5dea:	02071693          	slli	a3,a4,0x20
    5dee:	01c6d713          	srli	a4,a3,0x1c
    5df2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5df4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5df8:	00004717          	auipc	a4,0x4
    5dfc:	b0a73023          	sd	a0,-1280(a4) # 98f8 <freep>
      return (void*)(p + 1);
    5e00:	01078513          	addi	a0,a5,16
  }
}
    5e04:	70e2                	ld	ra,56(sp)
    5e06:	7442                	ld	s0,48(sp)
    5e08:	74a2                	ld	s1,40(sp)
    5e0a:	69e2                	ld	s3,24(sp)
    5e0c:	6121                	addi	sp,sp,64
    5e0e:	8082                	ret
    5e10:	7902                	ld	s2,32(sp)
    5e12:	6a42                	ld	s4,16(sp)
    5e14:	6aa2                	ld	s5,8(sp)
    5e16:	6b02                	ld	s6,0(sp)
    5e18:	b7f5                	j	5e04 <malloc+0xea>
