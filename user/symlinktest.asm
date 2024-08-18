
user/_symlinktest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	6585                	lui	a1,0x1
   e:	80058593          	addi	a1,a1,-2048 # 800 <gets+0x46>
  12:	00001097          	auipc	ra,0x1
  16:	99c080e7          	jalr	-1636(ra) # 9ae <open>
  if(fd < 0)
  1a:	02054063          	bltz	a0,3a <stat_slink+0x3a>
    return -1;
  if(fstat(fd, st) != 0)
  1e:	85a6                	mv	a1,s1
  20:	00001097          	auipc	ra,0x1
  24:	9a6080e7          	jalr	-1626(ra) # 9c6 <fstat>
  28:	00a03533          	snez	a0,a0
  2c:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  30:	60e2                	ld	ra,24(sp)
  32:	6442                	ld	s0,16(sp)
  34:	64a2                	ld	s1,8(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret
    return -1;
  3a:	557d                	li	a0,-1
  3c:	bfd5                	j	30 <stat_slink+0x30>

000000000000003e <main>:
{
  3e:	7119                	addi	sp,sp,-128
  40:	fc86                	sd	ra,120(sp)
  42:	f8a2                	sd	s0,112(sp)
  44:	f4a6                	sd	s1,104(sp)
  46:	f0ca                	sd	s2,96(sp)
  48:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  4a:	00001517          	auipc	a0,0x1
  4e:	e4e50513          	addi	a0,a0,-434 # e98 <malloc+0x102>
  52:	00001097          	auipc	ra,0x1
  56:	96c080e7          	jalr	-1684(ra) # 9be <unlink>
  unlink("/testsymlink/b");
  5a:	00001517          	auipc	a0,0x1
  5e:	e5650513          	addi	a0,a0,-426 # eb0 <malloc+0x11a>
  62:	00001097          	auipc	ra,0x1
  66:	95c080e7          	jalr	-1700(ra) # 9be <unlink>
  unlink("/testsymlink/c");
  6a:	00001517          	auipc	a0,0x1
  6e:	e5650513          	addi	a0,a0,-426 # ec0 <malloc+0x12a>
  72:	00001097          	auipc	ra,0x1
  76:	94c080e7          	jalr	-1716(ra) # 9be <unlink>
  unlink("/testsymlink/1");
  7a:	00001517          	auipc	a0,0x1
  7e:	e5650513          	addi	a0,a0,-426 # ed0 <malloc+0x13a>
  82:	00001097          	auipc	ra,0x1
  86:	93c080e7          	jalr	-1732(ra) # 9be <unlink>
  unlink("/testsymlink/2");
  8a:	00001517          	auipc	a0,0x1
  8e:	e5650513          	addi	a0,a0,-426 # ee0 <malloc+0x14a>
  92:	00001097          	auipc	ra,0x1
  96:	92c080e7          	jalr	-1748(ra) # 9be <unlink>
  unlink("/testsymlink/3");
  9a:	00001517          	auipc	a0,0x1
  9e:	e5650513          	addi	a0,a0,-426 # ef0 <malloc+0x15a>
  a2:	00001097          	auipc	ra,0x1
  a6:	91c080e7          	jalr	-1764(ra) # 9be <unlink>
  unlink("/testsymlink/4");
  aa:	00001517          	auipc	a0,0x1
  ae:	e5650513          	addi	a0,a0,-426 # f00 <malloc+0x16a>
  b2:	00001097          	auipc	ra,0x1
  b6:	90c080e7          	jalr	-1780(ra) # 9be <unlink>
  unlink("/testsymlink/z");
  ba:	00001517          	auipc	a0,0x1
  be:	e5650513          	addi	a0,a0,-426 # f10 <malloc+0x17a>
  c2:	00001097          	auipc	ra,0x1
  c6:	8fc080e7          	jalr	-1796(ra) # 9be <unlink>
  unlink("/testsymlink/y");
  ca:	00001517          	auipc	a0,0x1
  ce:	e5650513          	addi	a0,a0,-426 # f20 <malloc+0x18a>
  d2:	00001097          	auipc	ra,0x1
  d6:	8ec080e7          	jalr	-1812(ra) # 9be <unlink>
  unlink("/testsymlink");
  da:	00001517          	auipc	a0,0x1
  de:	e5650513          	addi	a0,a0,-426 # f30 <malloc+0x19a>
  e2:	00001097          	auipc	ra,0x1
  e6:	8dc080e7          	jalr	-1828(ra) # 9be <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  ea:	646367b7          	lui	a5,0x64636
  ee:	26178793          	addi	a5,a5,609 # 64636261 <__global_pointer$+0x64634275>
  f2:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
  f6:	f8040723          	sb	zero,-114(s0)
  fa:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
  fe:	00001517          	auipc	a0,0x1
 102:	e4250513          	addi	a0,a0,-446 # f40 <malloc+0x1aa>
 106:	00001097          	auipc	ra,0x1
 10a:	bd8080e7          	jalr	-1064(ra) # cde <printf>

  mkdir("/testsymlink");
 10e:	00001517          	auipc	a0,0x1
 112:	e2250513          	addi	a0,a0,-478 # f30 <malloc+0x19a>
 116:	00001097          	auipc	ra,0x1
 11a:	8c0080e7          	jalr	-1856(ra) # 9d6 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 11e:	20200593          	li	a1,514
 122:	00001517          	auipc	a0,0x1
 126:	d7650513          	addi	a0,a0,-650 # e98 <malloc+0x102>
 12a:	00001097          	auipc	ra,0x1
 12e:	884080e7          	jalr	-1916(ra) # 9ae <open>
 132:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 134:	10054563          	bltz	a0,23e <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 138:	00001597          	auipc	a1,0x1
 13c:	d7858593          	addi	a1,a1,-648 # eb0 <malloc+0x11a>
 140:	00001517          	auipc	a0,0x1
 144:	d5850513          	addi	a0,a0,-680 # e98 <malloc+0x102>
 148:	00001097          	auipc	ra,0x1
 14c:	8c6080e7          	jalr	-1850(ra) # a0e <symlink>
  if(r < 0)
 150:	10054663          	bltz	a0,25c <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 154:	4611                	li	a2,4
 156:	f9040593          	addi	a1,s0,-112
 15a:	8526                	mv	a0,s1
 15c:	00001097          	auipc	ra,0x1
 160:	832080e7          	jalr	-1998(ra) # 98e <write>
 164:	4791                	li	a5,4
 166:	10f50a63          	beq	a0,a5,27a <main+0x23c>
    fail("failed to write to a");
 16a:	00001517          	auipc	a0,0x1
 16e:	e2e50513          	addi	a0,a0,-466 # f98 <malloc+0x202>
 172:	00001097          	auipc	ra,0x1
 176:	b6c080e7          	jalr	-1172(ra) # cde <printf>
 17a:	4785                	li	a5,1
 17c:	00001717          	auipc	a4,0x1
 180:	66f72a23          	sw	a5,1652(a4) # 17f0 <failed>
  int r, fd1 = -1, fd2 = -1;
 184:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 186:	8526                	mv	a0,s1
 188:	00001097          	auipc	ra,0x1
 18c:	80e080e7          	jalr	-2034(ra) # 996 <close>
  close(fd2);
 190:	854a                	mv	a0,s2
 192:	00001097          	auipc	ra,0x1
 196:	804080e7          	jalr	-2044(ra) # 996 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 19a:	00001517          	auipc	a0,0x1
 19e:	0de50513          	addi	a0,a0,222 # 1278 <malloc+0x4e2>
 1a2:	00001097          	auipc	ra,0x1
 1a6:	b3c080e7          	jalr	-1220(ra) # cde <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1aa:	20200593          	li	a1,514
 1ae:	00001517          	auipc	a0,0x1
 1b2:	d6250513          	addi	a0,a0,-670 # f10 <malloc+0x17a>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	7f8080e7          	jalr	2040(ra) # 9ae <open>
  if(fd < 0) {
 1be:	42054863          	bltz	a0,5ee <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1c2:	00000097          	auipc	ra,0x0
 1c6:	7d4080e7          	jalr	2004(ra) # 996 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1ca:	00000097          	auipc	ra,0x0
 1ce:	79c080e7          	jalr	1948(ra) # 966 <fork>
    if(pid < 0){
 1d2:	44054163          	bltz	a0,614 <main+0x5d6>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1d6:	46050263          	beqz	a0,63a <main+0x5fc>
    pid = fork();
 1da:	00000097          	auipc	ra,0x0
 1de:	78c080e7          	jalr	1932(ra) # 966 <fork>
    if(pid < 0){
 1e2:	42054963          	bltz	a0,614 <main+0x5d6>
    if(pid == 0) {
 1e6:	44050a63          	beqz	a0,63a <main+0x5fc>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1ea:	f9840513          	addi	a0,s0,-104
 1ee:	00000097          	auipc	ra,0x0
 1f2:	788080e7          	jalr	1928(ra) # 976 <wait>
    if(r != 0) {
 1f6:	f9842783          	lw	a5,-104(s0)
 1fa:	4e079163          	bnez	a5,6dc <main+0x69e>
 1fe:	ecce                	sd	s3,88(sp)
 200:	e8d2                	sd	s4,80(sp)
 202:	e4d6                	sd	s5,72(sp)
 204:	e0da                	sd	s6,64(sp)
 206:	fc5e                	sd	s7,56(sp)
 208:	f862                	sd	s8,48(sp)
    wait(&r);
 20a:	f9840513          	addi	a0,s0,-104
 20e:	00000097          	auipc	ra,0x0
 212:	768080e7          	jalr	1896(ra) # 976 <wait>
    if(r != 0) {
 216:	f9842783          	lw	a5,-104(s0)
 21a:	4c079763          	bnez	a5,6e8 <main+0x6aa>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21e:	00001517          	auipc	a0,0x1
 222:	0fa50513          	addi	a0,a0,250 # 1318 <malloc+0x582>
 226:	00001097          	auipc	ra,0x1
 22a:	ab8080e7          	jalr	-1352(ra) # cde <printf>
  exit(failed);
 22e:	00001517          	auipc	a0,0x1
 232:	5c252503          	lw	a0,1474(a0) # 17f0 <failed>
 236:	00000097          	auipc	ra,0x0
 23a:	738080e7          	jalr	1848(ra) # 96e <exit>
  if(fd1 < 0) fail("failed to open a");
 23e:	00001517          	auipc	a0,0x1
 242:	d1a50513          	addi	a0,a0,-742 # f58 <malloc+0x1c2>
 246:	00001097          	auipc	ra,0x1
 24a:	a98080e7          	jalr	-1384(ra) # cde <printf>
 24e:	4785                	li	a5,1
 250:	00001717          	auipc	a4,0x1
 254:	5af72023          	sw	a5,1440(a4) # 17f0 <failed>
  int r, fd1 = -1, fd2 = -1;
 258:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 25a:	b735                	j	186 <main+0x148>
    fail("symlink b -> a failed");
 25c:	00001517          	auipc	a0,0x1
 260:	d1c50513          	addi	a0,a0,-740 # f78 <malloc+0x1e2>
 264:	00001097          	auipc	ra,0x1
 268:	a7a080e7          	jalr	-1414(ra) # cde <printf>
 26c:	4785                	li	a5,1
 26e:	00001717          	auipc	a4,0x1
 272:	58f72123          	sw	a5,1410(a4) # 17f0 <failed>
  int r, fd1 = -1, fd2 = -1;
 276:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 278:	b739                	j	186 <main+0x148>
  if (stat_slink("/testsymlink/b", &st) != 0)
 27a:	f9840593          	addi	a1,s0,-104
 27e:	00001517          	auipc	a0,0x1
 282:	c3250513          	addi	a0,a0,-974 # eb0 <malloc+0x11a>
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <stat_slink>
 28e:	e50d                	bnez	a0,2b8 <main+0x27a>
  if(st.type != T_SYMLINK)
 290:	fa041703          	lh	a4,-96(s0)
 294:	4791                	li	a5,4
 296:	04f70063          	beq	a4,a5,2d6 <main+0x298>
    fail("b isn't a symlink");
 29a:	00001517          	auipc	a0,0x1
 29e:	d3e50513          	addi	a0,a0,-706 # fd8 <malloc+0x242>
 2a2:	00001097          	auipc	ra,0x1
 2a6:	a3c080e7          	jalr	-1476(ra) # cde <printf>
 2aa:	4785                	li	a5,1
 2ac:	00001717          	auipc	a4,0x1
 2b0:	54f72223          	sw	a5,1348(a4) # 17f0 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b4:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b6:	bdc1                	j	186 <main+0x148>
    fail("failed to stat b");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	d0050513          	addi	a0,a0,-768 # fb8 <malloc+0x222>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	a1e080e7          	jalr	-1506(ra) # cde <printf>
 2c8:	4785                	li	a5,1
 2ca:	00001717          	auipc	a4,0x1
 2ce:	52f72323          	sw	a5,1318(a4) # 17f0 <failed>
  int r, fd1 = -1, fd2 = -1;
 2d2:	597d                	li	s2,-1
    fail("failed to stat b");
 2d4:	bd4d                	j	186 <main+0x148>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d6:	4589                	li	a1,2
 2d8:	00001517          	auipc	a0,0x1
 2dc:	bd850513          	addi	a0,a0,-1064 # eb0 <malloc+0x11a>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	6ce080e7          	jalr	1742(ra) # 9ae <open>
 2e8:	892a                	mv	s2,a0
  if(fd2 < 0)
 2ea:	02054d63          	bltz	a0,324 <main+0x2e6>
  read(fd2, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	f8e40593          	addi	a1,s0,-114
 2f4:	00000097          	auipc	ra,0x0
 2f8:	692080e7          	jalr	1682(ra) # 986 <read>
  if (c != 'a')
 2fc:	f8e44703          	lbu	a4,-114(s0)
 300:	06100793          	li	a5,97
 304:	02f70e63          	beq	a4,a5,340 <main+0x302>
    fail("failed to read bytes from b");
 308:	00001517          	auipc	a0,0x1
 30c:	d1050513          	addi	a0,a0,-752 # 1018 <malloc+0x282>
 310:	00001097          	auipc	ra,0x1
 314:	9ce080e7          	jalr	-1586(ra) # cde <printf>
 318:	4785                	li	a5,1
 31a:	00001717          	auipc	a4,0x1
 31e:	4cf72b23          	sw	a5,1238(a4) # 17f0 <failed>
 322:	b595                	j	186 <main+0x148>
    fail("failed to open b");
 324:	00001517          	auipc	a0,0x1
 328:	cd450513          	addi	a0,a0,-812 # ff8 <malloc+0x262>
 32c:	00001097          	auipc	ra,0x1
 330:	9b2080e7          	jalr	-1614(ra) # cde <printf>
 334:	4785                	li	a5,1
 336:	00001717          	auipc	a4,0x1
 33a:	4af72d23          	sw	a5,1210(a4) # 17f0 <failed>
 33e:	b5a1                	j	186 <main+0x148>
  unlink("/testsymlink/a");
 340:	00001517          	auipc	a0,0x1
 344:	b5850513          	addi	a0,a0,-1192 # e98 <malloc+0x102>
 348:	00000097          	auipc	ra,0x0
 34c:	676080e7          	jalr	1654(ra) # 9be <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 350:	4589                	li	a1,2
 352:	00001517          	auipc	a0,0x1
 356:	b5e50513          	addi	a0,a0,-1186 # eb0 <malloc+0x11a>
 35a:	00000097          	auipc	ra,0x0
 35e:	654080e7          	jalr	1620(ra) # 9ae <open>
 362:	12055263          	bgez	a0,486 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 366:	00001597          	auipc	a1,0x1
 36a:	b3258593          	addi	a1,a1,-1230 # e98 <malloc+0x102>
 36e:	00001517          	auipc	a0,0x1
 372:	b4250513          	addi	a0,a0,-1214 # eb0 <malloc+0x11a>
 376:	00000097          	auipc	ra,0x0
 37a:	698080e7          	jalr	1688(ra) # a0e <symlink>
  if(r < 0)
 37e:	12054263          	bltz	a0,4a2 <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 382:	4589                	li	a1,2
 384:	00001517          	auipc	a0,0x1
 388:	b2c50513          	addi	a0,a0,-1236 # eb0 <malloc+0x11a>
 38c:	00000097          	auipc	ra,0x0
 390:	622080e7          	jalr	1570(ra) # 9ae <open>
  if(r >= 0)
 394:	12055563          	bgez	a0,4be <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 398:	00001597          	auipc	a1,0x1
 39c:	b2858593          	addi	a1,a1,-1240 # ec0 <malloc+0x12a>
 3a0:	00001517          	auipc	a0,0x1
 3a4:	d3850513          	addi	a0,a0,-712 # 10d8 <malloc+0x342>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	666080e7          	jalr	1638(ra) # a0e <symlink>
  if(r != 0)
 3b0:	12051563          	bnez	a0,4da <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b4:	00001597          	auipc	a1,0x1
 3b8:	b1c58593          	addi	a1,a1,-1252 # ed0 <malloc+0x13a>
 3bc:	00001517          	auipc	a0,0x1
 3c0:	b2450513          	addi	a0,a0,-1244 # ee0 <malloc+0x14a>
 3c4:	00000097          	auipc	ra,0x0
 3c8:	64a080e7          	jalr	1610(ra) # a0e <symlink>
  if(r) fail("Failed to link 1->2");
 3cc:	12051563          	bnez	a0,4f6 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3d0:	00001597          	auipc	a1,0x1
 3d4:	b1058593          	addi	a1,a1,-1264 # ee0 <malloc+0x14a>
 3d8:	00001517          	auipc	a0,0x1
 3dc:	b1850513          	addi	a0,a0,-1256 # ef0 <malloc+0x15a>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	62e080e7          	jalr	1582(ra) # a0e <symlink>
  if(r) fail("Failed to link 2->3");
 3e8:	12051563          	bnez	a0,512 <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3ec:	00001597          	auipc	a1,0x1
 3f0:	b0458593          	addi	a1,a1,-1276 # ef0 <malloc+0x15a>
 3f4:	00001517          	auipc	a0,0x1
 3f8:	b0c50513          	addi	a0,a0,-1268 # f00 <malloc+0x16a>
 3fc:	00000097          	auipc	ra,0x0
 400:	612080e7          	jalr	1554(ra) # a0e <symlink>
  if(r) fail("Failed to link 3->4");
 404:	12051563          	bnez	a0,52e <main+0x4f0>
  close(fd1);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	58c080e7          	jalr	1420(ra) # 996 <close>
  close(fd2);
 412:	854a                	mv	a0,s2
 414:	00000097          	auipc	ra,0x0
 418:	582080e7          	jalr	1410(ra) # 996 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 41c:	20200593          	li	a1,514
 420:	00001517          	auipc	a0,0x1
 424:	ae050513          	addi	a0,a0,-1312 # f00 <malloc+0x16a>
 428:	00000097          	auipc	ra,0x0
 42c:	586080e7          	jalr	1414(ra) # 9ae <open>
 430:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 432:	10054c63          	bltz	a0,54a <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 436:	4589                	li	a1,2
 438:	00001517          	auipc	a0,0x1
 43c:	a9850513          	addi	a0,a0,-1384 # ed0 <malloc+0x13a>
 440:	00000097          	auipc	ra,0x0
 444:	56e080e7          	jalr	1390(ra) # 9ae <open>
 448:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 44a:	10054e63          	bltz	a0,566 <main+0x528>
  c = '#';
 44e:	02300793          	li	a5,35
 452:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 456:	4605                	li	a2,1
 458:	f8e40593          	addi	a1,s0,-114
 45c:	00000097          	auipc	ra,0x0
 460:	532080e7          	jalr	1330(ra) # 98e <write>
  if(r!=1) fail("Failed to write to 1\n");
 464:	4785                	li	a5,1
 466:	10f50e63          	beq	a0,a5,582 <main+0x544>
 46a:	00001517          	auipc	a0,0x1
 46e:	d6e50513          	addi	a0,a0,-658 # 11d8 <malloc+0x442>
 472:	00001097          	auipc	ra,0x1
 476:	86c080e7          	jalr	-1940(ra) # cde <printf>
 47a:	4785                	li	a5,1
 47c:	00001717          	auipc	a4,0x1
 480:	36f72a23          	sw	a5,884(a4) # 17f0 <failed>
 484:	b309                	j	186 <main+0x148>
    fail("Should not be able to open b after deleting a");
 486:	00001517          	auipc	a0,0x1
 48a:	bba50513          	addi	a0,a0,-1094 # 1040 <malloc+0x2aa>
 48e:	00001097          	auipc	ra,0x1
 492:	850080e7          	jalr	-1968(ra) # cde <printf>
 496:	4785                	li	a5,1
 498:	00001717          	auipc	a4,0x1
 49c:	34f72c23          	sw	a5,856(a4) # 17f0 <failed>
 4a0:	b1dd                	j	186 <main+0x148>
    fail("symlink a -> b failed");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	bd650513          	addi	a0,a0,-1066 # 1078 <malloc+0x2e2>
 4aa:	00001097          	auipc	ra,0x1
 4ae:	834080e7          	jalr	-1996(ra) # cde <printf>
 4b2:	4785                	li	a5,1
 4b4:	00001717          	auipc	a4,0x1
 4b8:	32f72e23          	sw	a5,828(a4) # 17f0 <failed>
 4bc:	b1e9                	j	186 <main+0x148>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	bda50513          	addi	a0,a0,-1062 # 1098 <malloc+0x302>
 4c6:	00001097          	auipc	ra,0x1
 4ca:	818080e7          	jalr	-2024(ra) # cde <printf>
 4ce:	4785                	li	a5,1
 4d0:	00001717          	auipc	a4,0x1
 4d4:	32f72023          	sw	a5,800(a4) # 17f0 <failed>
 4d8:	b17d                	j	186 <main+0x148>
    fail("Symlinking to nonexistent file should succeed\n");
 4da:	00001517          	auipc	a0,0x1
 4de:	c1e50513          	addi	a0,a0,-994 # 10f8 <malloc+0x362>
 4e2:	00000097          	auipc	ra,0x0
 4e6:	7fc080e7          	jalr	2044(ra) # cde <printf>
 4ea:	4785                	li	a5,1
 4ec:	00001717          	auipc	a4,0x1
 4f0:	30f72223          	sw	a5,772(a4) # 17f0 <failed>
 4f4:	b949                	j	186 <main+0x148>
  if(r) fail("Failed to link 1->2");
 4f6:	00001517          	auipc	a0,0x1
 4fa:	c4250513          	addi	a0,a0,-958 # 1138 <malloc+0x3a2>
 4fe:	00000097          	auipc	ra,0x0
 502:	7e0080e7          	jalr	2016(ra) # cde <printf>
 506:	4785                	li	a5,1
 508:	00001717          	auipc	a4,0x1
 50c:	2ef72423          	sw	a5,744(a4) # 17f0 <failed>
 510:	b99d                	j	186 <main+0x148>
  if(r) fail("Failed to link 2->3");
 512:	00001517          	auipc	a0,0x1
 516:	c4650513          	addi	a0,a0,-954 # 1158 <malloc+0x3c2>
 51a:	00000097          	auipc	ra,0x0
 51e:	7c4080e7          	jalr	1988(ra) # cde <printf>
 522:	4785                	li	a5,1
 524:	00001717          	auipc	a4,0x1
 528:	2cf72623          	sw	a5,716(a4) # 17f0 <failed>
 52c:	b9a9                	j	186 <main+0x148>
  if(r) fail("Failed to link 3->4");
 52e:	00001517          	auipc	a0,0x1
 532:	c4a50513          	addi	a0,a0,-950 # 1178 <malloc+0x3e2>
 536:	00000097          	auipc	ra,0x0
 53a:	7a8080e7          	jalr	1960(ra) # cde <printf>
 53e:	4785                	li	a5,1
 540:	00001717          	auipc	a4,0x1
 544:	2af72823          	sw	a5,688(a4) # 17f0 <failed>
 548:	b93d                	j	186 <main+0x148>
  if(fd1<0) fail("Failed to create 4\n");
 54a:	00001517          	auipc	a0,0x1
 54e:	c4e50513          	addi	a0,a0,-946 # 1198 <malloc+0x402>
 552:	00000097          	auipc	ra,0x0
 556:	78c080e7          	jalr	1932(ra) # cde <printf>
 55a:	4785                	li	a5,1
 55c:	00001717          	auipc	a4,0x1
 560:	28f72a23          	sw	a5,660(a4) # 17f0 <failed>
 564:	b10d                	j	186 <main+0x148>
  if(fd2<0) fail("Failed to open 1\n");
 566:	00001517          	auipc	a0,0x1
 56a:	c5250513          	addi	a0,a0,-942 # 11b8 <malloc+0x422>
 56e:	00000097          	auipc	ra,0x0
 572:	770080e7          	jalr	1904(ra) # cde <printf>
 576:	4785                	li	a5,1
 578:	00001717          	auipc	a4,0x1
 57c:	26f72c23          	sw	a5,632(a4) # 17f0 <failed>
 580:	b119                	j	186 <main+0x148>
  r = read(fd1, &c2, 1);
 582:	4605                	li	a2,1
 584:	f8f40593          	addi	a1,s0,-113
 588:	8526                	mv	a0,s1
 58a:	00000097          	auipc	ra,0x0
 58e:	3fc080e7          	jalr	1020(ra) # 986 <read>
  if(r!=1) fail("Failed to read from 4\n");
 592:	4785                	li	a5,1
 594:	02f51663          	bne	a0,a5,5c0 <main+0x582>
  if(c!=c2)
 598:	f8e44703          	lbu	a4,-114(s0)
 59c:	f8f44783          	lbu	a5,-113(s0)
 5a0:	02f70e63          	beq	a4,a5,5dc <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a4:	00001517          	auipc	a0,0x1
 5a8:	c7c50513          	addi	a0,a0,-900 # 1220 <malloc+0x48a>
 5ac:	00000097          	auipc	ra,0x0
 5b0:	732080e7          	jalr	1842(ra) # cde <printf>
 5b4:	4785                	li	a5,1
 5b6:	00001717          	auipc	a4,0x1
 5ba:	22f72d23          	sw	a5,570(a4) # 17f0 <failed>
 5be:	b6e1                	j	186 <main+0x148>
  if(r!=1) fail("Failed to read from 4\n");
 5c0:	00001517          	auipc	a0,0x1
 5c4:	c3850513          	addi	a0,a0,-968 # 11f8 <malloc+0x462>
 5c8:	00000097          	auipc	ra,0x0
 5cc:	716080e7          	jalr	1814(ra) # cde <printf>
 5d0:	4785                	li	a5,1
 5d2:	00001717          	auipc	a4,0x1
 5d6:	20f72f23          	sw	a5,542(a4) # 17f0 <failed>
 5da:	b675                	j	186 <main+0x148>
  printf("test symlinks: ok\n");
 5dc:	00001517          	auipc	a0,0x1
 5e0:	c8450513          	addi	a0,a0,-892 # 1260 <malloc+0x4ca>
 5e4:	00000097          	auipc	ra,0x0
 5e8:	6fa080e7          	jalr	1786(ra) # cde <printf>
 5ec:	be69                	j	186 <main+0x148>
 5ee:	ecce                	sd	s3,88(sp)
 5f0:	e8d2                	sd	s4,80(sp)
 5f2:	e4d6                	sd	s5,72(sp)
 5f4:	e0da                	sd	s6,64(sp)
 5f6:	fc5e                	sd	s7,56(sp)
 5f8:	f862                	sd	s8,48(sp)
    printf("FAILED: open failed");
 5fa:	00001517          	auipc	a0,0x1
 5fe:	ca650513          	addi	a0,a0,-858 # 12a0 <malloc+0x50a>
 602:	00000097          	auipc	ra,0x0
 606:	6dc080e7          	jalr	1756(ra) # cde <printf>
    exit(1);
 60a:	4505                	li	a0,1
 60c:	00000097          	auipc	ra,0x0
 610:	362080e7          	jalr	866(ra) # 96e <exit>
 614:	ecce                	sd	s3,88(sp)
 616:	e8d2                	sd	s4,80(sp)
 618:	e4d6                	sd	s5,72(sp)
 61a:	e0da                	sd	s6,64(sp)
 61c:	fc5e                	sd	s7,56(sp)
 61e:	f862                	sd	s8,48(sp)
      printf("FAILED: fork failed\n");
 620:	00001517          	auipc	a0,0x1
 624:	c9850513          	addi	a0,a0,-872 # 12b8 <malloc+0x522>
 628:	00000097          	auipc	ra,0x0
 62c:	6b6080e7          	jalr	1718(ra) # cde <printf>
      exit(1);
 630:	4505                	li	a0,1
 632:	00000097          	auipc	ra,0x0
 636:	33c080e7          	jalr	828(ra) # 96e <exit>
 63a:	ecce                	sd	s3,88(sp)
 63c:	e8d2                	sd	s4,80(sp)
 63e:	e4d6                	sd	s5,72(sp)
 640:	e0da                	sd	s6,64(sp)
 642:	fc5e                	sd	s7,56(sp)
 644:	f862                	sd	s8,48(sp)
  int r, fd1 = -1, fd2 = -1;
 646:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 64a:	06100c13          	li	s8,97
        x = x * 1103515245 + 12345;
 64e:	41c65a37          	lui	s4,0x41c65
 652:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <__global_pointer$+0x41c62e81>
 656:	698d                	lui	s3,0x3
 658:	0399899b          	addiw	s3,s3,57 # 3039 <__global_pointer$+0x104d>
        if((x % 3) == 0) {
 65c:	4a8d                	li	s5,3
          unlink("/testsymlink/y");
 65e:	00001917          	auipc	s2,0x1
 662:	8c290913          	addi	s2,s2,-1854 # f20 <malloc+0x18a>
          symlink("/testsymlink/z", "/testsymlink/y");
 666:	00001b17          	auipc	s6,0x1
 66a:	8aab0b13          	addi	s6,s6,-1878 # f10 <malloc+0x17a>
            if(st.type != T_SYMLINK) {
 66e:	4b91                	li	s7,4
 670:	a801                	j	680 <main+0x642>
          unlink("/testsymlink/y");
 672:	854a                	mv	a0,s2
 674:	00000097          	auipc	ra,0x0
 678:	34a080e7          	jalr	842(ra) # 9be <unlink>
      for(i = 0; i < 100; i++){
 67c:	34fd                	addiw	s1,s1,-1
 67e:	c8b1                	beqz	s1,6d2 <main+0x694>
        x = x * 1103515245 + 12345;
 680:	034c07bb          	mulw	a5,s8,s4
 684:	013787bb          	addw	a5,a5,s3
 688:	00078c1b          	sext.w	s8,a5
        if((x % 3) == 0) {
 68c:	0357f7bb          	remuw	a5,a5,s5
 690:	2781                	sext.w	a5,a5
 692:	f3e5                	bnez	a5,672 <main+0x634>
          symlink("/testsymlink/z", "/testsymlink/y");
 694:	85ca                	mv	a1,s2
 696:	855a                	mv	a0,s6
 698:	00000097          	auipc	ra,0x0
 69c:	376080e7          	jalr	886(ra) # a0e <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 6a0:	f9840593          	addi	a1,s0,-104
 6a4:	854a                	mv	a0,s2
 6a6:	00000097          	auipc	ra,0x0
 6aa:	95a080e7          	jalr	-1702(ra) # 0 <stat_slink>
 6ae:	f579                	bnez	a0,67c <main+0x63e>
            if(st.type != T_SYMLINK) {
 6b0:	fa041583          	lh	a1,-96(s0)
 6b4:	fd7584e3          	beq	a1,s7,67c <main+0x63e>
              printf("FAILED: not a symbolic link\n", st.type);
 6b8:	00001517          	auipc	a0,0x1
 6bc:	c1850513          	addi	a0,a0,-1000 # 12d0 <malloc+0x53a>
 6c0:	00000097          	auipc	ra,0x0
 6c4:	61e080e7          	jalr	1566(ra) # cde <printf>
              exit(1);
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	2a4080e7          	jalr	676(ra) # 96e <exit>
      exit(0);
 6d2:	4501                	li	a0,0
 6d4:	00000097          	auipc	ra,0x0
 6d8:	29a080e7          	jalr	666(ra) # 96e <exit>
 6dc:	ecce                	sd	s3,88(sp)
 6de:	e8d2                	sd	s4,80(sp)
 6e0:	e4d6                	sd	s5,72(sp)
 6e2:	e0da                	sd	s6,64(sp)
 6e4:	fc5e                	sd	s7,56(sp)
 6e6:	f862                	sd	s8,48(sp)
      printf("test concurrent symlinks: failed\n");
 6e8:	00001517          	auipc	a0,0x1
 6ec:	c0850513          	addi	a0,a0,-1016 # 12f0 <malloc+0x55a>
 6f0:	00000097          	auipc	ra,0x0
 6f4:	5ee080e7          	jalr	1518(ra) # cde <printf>
      exit(1);
 6f8:	4505                	li	a0,1
 6fa:	00000097          	auipc	ra,0x0
 6fe:	274080e7          	jalr	628(ra) # 96e <exit>

0000000000000702 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 702:	1141                	addi	sp,sp,-16
 704:	e422                	sd	s0,8(sp)
 706:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 708:	87aa                	mv	a5,a0
 70a:	0585                	addi	a1,a1,1
 70c:	0785                	addi	a5,a5,1
 70e:	fff5c703          	lbu	a4,-1(a1)
 712:	fee78fa3          	sb	a4,-1(a5)
 716:	fb75                	bnez	a4,70a <strcpy+0x8>
    ;
  return os;
}
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e422                	sd	s0,8(sp)
 722:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 724:	00054783          	lbu	a5,0(a0)
 728:	cb91                	beqz	a5,73c <strcmp+0x1e>
 72a:	0005c703          	lbu	a4,0(a1)
 72e:	00f71763          	bne	a4,a5,73c <strcmp+0x1e>
    p++, q++;
 732:	0505                	addi	a0,a0,1
 734:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 736:	00054783          	lbu	a5,0(a0)
 73a:	fbe5                	bnez	a5,72a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 73c:	0005c503          	lbu	a0,0(a1)
}
 740:	40a7853b          	subw	a0,a5,a0
 744:	6422                	ld	s0,8(sp)
 746:	0141                	addi	sp,sp,16
 748:	8082                	ret

000000000000074a <strlen>:

uint
strlen(const char *s)
{
 74a:	1141                	addi	sp,sp,-16
 74c:	e422                	sd	s0,8(sp)
 74e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 750:	00054783          	lbu	a5,0(a0)
 754:	cf91                	beqz	a5,770 <strlen+0x26>
 756:	0505                	addi	a0,a0,1
 758:	87aa                	mv	a5,a0
 75a:	86be                	mv	a3,a5
 75c:	0785                	addi	a5,a5,1
 75e:	fff7c703          	lbu	a4,-1(a5)
 762:	ff65                	bnez	a4,75a <strlen+0x10>
 764:	40a6853b          	subw	a0,a3,a0
 768:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret
  for(n = 0; s[n]; n++)
 770:	4501                	li	a0,0
 772:	bfe5                	j	76a <strlen+0x20>

0000000000000774 <memset>:

void*
memset(void *dst, int c, uint n)
{
 774:	1141                	addi	sp,sp,-16
 776:	e422                	sd	s0,8(sp)
 778:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 77a:	ca19                	beqz	a2,790 <memset+0x1c>
 77c:	87aa                	mv	a5,a0
 77e:	1602                	slli	a2,a2,0x20
 780:	9201                	srli	a2,a2,0x20
 782:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 786:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 78a:	0785                	addi	a5,a5,1
 78c:	fee79de3          	bne	a5,a4,786 <memset+0x12>
  }
  return dst;
}
 790:	6422                	ld	s0,8(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret

0000000000000796 <strchr>:

char*
strchr(const char *s, char c)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 79c:	00054783          	lbu	a5,0(a0)
 7a0:	cb99                	beqz	a5,7b6 <strchr+0x20>
    if(*s == c)
 7a2:	00f58763          	beq	a1,a5,7b0 <strchr+0x1a>
  for(; *s; s++)
 7a6:	0505                	addi	a0,a0,1
 7a8:	00054783          	lbu	a5,0(a0)
 7ac:	fbfd                	bnez	a5,7a2 <strchr+0xc>
      return (char*)s;
  return 0;
 7ae:	4501                	li	a0,0
}
 7b0:	6422                	ld	s0,8(sp)
 7b2:	0141                	addi	sp,sp,16
 7b4:	8082                	ret
  return 0;
 7b6:	4501                	li	a0,0
 7b8:	bfe5                	j	7b0 <strchr+0x1a>

00000000000007ba <gets>:

char*
gets(char *buf, int max)
{
 7ba:	711d                	addi	sp,sp,-96
 7bc:	ec86                	sd	ra,88(sp)
 7be:	e8a2                	sd	s0,80(sp)
 7c0:	e4a6                	sd	s1,72(sp)
 7c2:	e0ca                	sd	s2,64(sp)
 7c4:	fc4e                	sd	s3,56(sp)
 7c6:	f852                	sd	s4,48(sp)
 7c8:	f456                	sd	s5,40(sp)
 7ca:	f05a                	sd	s6,32(sp)
 7cc:	ec5e                	sd	s7,24(sp)
 7ce:	1080                	addi	s0,sp,96
 7d0:	8baa                	mv	s7,a0
 7d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7d4:	892a                	mv	s2,a0
 7d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7d8:	4aa9                	li	s5,10
 7da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7dc:	89a6                	mv	s3,s1
 7de:	2485                	addiw	s1,s1,1
 7e0:	0344d863          	bge	s1,s4,810 <gets+0x56>
    cc = read(0, &c, 1);
 7e4:	4605                	li	a2,1
 7e6:	faf40593          	addi	a1,s0,-81
 7ea:	4501                	li	a0,0
 7ec:	00000097          	auipc	ra,0x0
 7f0:	19a080e7          	jalr	410(ra) # 986 <read>
    if(cc < 1)
 7f4:	00a05e63          	blez	a0,810 <gets+0x56>
    buf[i++] = c;
 7f8:	faf44783          	lbu	a5,-81(s0)
 7fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 800:	01578763          	beq	a5,s5,80e <gets+0x54>
 804:	0905                	addi	s2,s2,1
 806:	fd679be3          	bne	a5,s6,7dc <gets+0x22>
    buf[i++] = c;
 80a:	89a6                	mv	s3,s1
 80c:	a011                	j	810 <gets+0x56>
 80e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 810:	99de                	add	s3,s3,s7
 812:	00098023          	sb	zero,0(s3)
  return buf;
}
 816:	855e                	mv	a0,s7
 818:	60e6                	ld	ra,88(sp)
 81a:	6446                	ld	s0,80(sp)
 81c:	64a6                	ld	s1,72(sp)
 81e:	6906                	ld	s2,64(sp)
 820:	79e2                	ld	s3,56(sp)
 822:	7a42                	ld	s4,48(sp)
 824:	7aa2                	ld	s5,40(sp)
 826:	7b02                	ld	s6,32(sp)
 828:	6be2                	ld	s7,24(sp)
 82a:	6125                	addi	sp,sp,96
 82c:	8082                	ret

000000000000082e <stat>:

int
stat(const char *n, struct stat *st)
{
 82e:	1101                	addi	sp,sp,-32
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	e04a                	sd	s2,0(sp)
 836:	1000                	addi	s0,sp,32
 838:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 83a:	4581                	li	a1,0
 83c:	00000097          	auipc	ra,0x0
 840:	172080e7          	jalr	370(ra) # 9ae <open>
  if(fd < 0)
 844:	02054663          	bltz	a0,870 <stat+0x42>
 848:	e426                	sd	s1,8(sp)
 84a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 84c:	85ca                	mv	a1,s2
 84e:	00000097          	auipc	ra,0x0
 852:	178080e7          	jalr	376(ra) # 9c6 <fstat>
 856:	892a                	mv	s2,a0
  close(fd);
 858:	8526                	mv	a0,s1
 85a:	00000097          	auipc	ra,0x0
 85e:	13c080e7          	jalr	316(ra) # 996 <close>
  return r;
 862:	64a2                	ld	s1,8(sp)
}
 864:	854a                	mv	a0,s2
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6902                	ld	s2,0(sp)
 86c:	6105                	addi	sp,sp,32
 86e:	8082                	ret
    return -1;
 870:	597d                	li	s2,-1
 872:	bfcd                	j	864 <stat+0x36>

0000000000000874 <atoi>:

int
atoi(const char *s)
{
 874:	1141                	addi	sp,sp,-16
 876:	e422                	sd	s0,8(sp)
 878:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 87a:	00054683          	lbu	a3,0(a0)
 87e:	fd06879b          	addiw	a5,a3,-48
 882:	0ff7f793          	zext.b	a5,a5
 886:	4625                	li	a2,9
 888:	02f66863          	bltu	a2,a5,8b8 <atoi+0x44>
 88c:	872a                	mv	a4,a0
  n = 0;
 88e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 890:	0705                	addi	a4,a4,1
 892:	0025179b          	slliw	a5,a0,0x2
 896:	9fa9                	addw	a5,a5,a0
 898:	0017979b          	slliw	a5,a5,0x1
 89c:	9fb5                	addw	a5,a5,a3
 89e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 8a2:	00074683          	lbu	a3,0(a4)
 8a6:	fd06879b          	addiw	a5,a3,-48
 8aa:	0ff7f793          	zext.b	a5,a5
 8ae:	fef671e3          	bgeu	a2,a5,890 <atoi+0x1c>
  return n;
}
 8b2:	6422                	ld	s0,8(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret
  n = 0;
 8b8:	4501                	li	a0,0
 8ba:	bfe5                	j	8b2 <atoi+0x3e>

00000000000008bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8bc:	1141                	addi	sp,sp,-16
 8be:	e422                	sd	s0,8(sp)
 8c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 8c2:	02b57463          	bgeu	a0,a1,8ea <memmove+0x2e>
    while(n-- > 0)
 8c6:	00c05f63          	blez	a2,8e4 <memmove+0x28>
 8ca:	1602                	slli	a2,a2,0x20
 8cc:	9201                	srli	a2,a2,0x20
 8ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 8d4:	0585                	addi	a1,a1,1
 8d6:	0705                	addi	a4,a4,1
 8d8:	fff5c683          	lbu	a3,-1(a1)
 8dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8e0:	fef71ae3          	bne	a4,a5,8d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8e4:	6422                	ld	s0,8(sp)
 8e6:	0141                	addi	sp,sp,16
 8e8:	8082                	ret
    dst += n;
 8ea:	00c50733          	add	a4,a0,a2
    src += n;
 8ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8f0:	fec05ae3          	blez	a2,8e4 <memmove+0x28>
 8f4:	fff6079b          	addiw	a5,a2,-1
 8f8:	1782                	slli	a5,a5,0x20
 8fa:	9381                	srli	a5,a5,0x20
 8fc:	fff7c793          	not	a5,a5
 900:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 902:	15fd                	addi	a1,a1,-1
 904:	177d                	addi	a4,a4,-1
 906:	0005c683          	lbu	a3,0(a1)
 90a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 90e:	fee79ae3          	bne	a5,a4,902 <memmove+0x46>
 912:	bfc9                	j	8e4 <memmove+0x28>

0000000000000914 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 914:	1141                	addi	sp,sp,-16
 916:	e422                	sd	s0,8(sp)
 918:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 91a:	ca05                	beqz	a2,94a <memcmp+0x36>
 91c:	fff6069b          	addiw	a3,a2,-1
 920:	1682                	slli	a3,a3,0x20
 922:	9281                	srli	a3,a3,0x20
 924:	0685                	addi	a3,a3,1
 926:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 928:	00054783          	lbu	a5,0(a0)
 92c:	0005c703          	lbu	a4,0(a1)
 930:	00e79863          	bne	a5,a4,940 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 934:	0505                	addi	a0,a0,1
    p2++;
 936:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 938:	fed518e3          	bne	a0,a3,928 <memcmp+0x14>
  }
  return 0;
 93c:	4501                	li	a0,0
 93e:	a019                	j	944 <memcmp+0x30>
      return *p1 - *p2;
 940:	40e7853b          	subw	a0,a5,a4
}
 944:	6422                	ld	s0,8(sp)
 946:	0141                	addi	sp,sp,16
 948:	8082                	ret
  return 0;
 94a:	4501                	li	a0,0
 94c:	bfe5                	j	944 <memcmp+0x30>

000000000000094e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 94e:	1141                	addi	sp,sp,-16
 950:	e406                	sd	ra,8(sp)
 952:	e022                	sd	s0,0(sp)
 954:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 956:	00000097          	auipc	ra,0x0
 95a:	f66080e7          	jalr	-154(ra) # 8bc <memmove>
}
 95e:	60a2                	ld	ra,8(sp)
 960:	6402                	ld	s0,0(sp)
 962:	0141                	addi	sp,sp,16
 964:	8082                	ret

0000000000000966 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 966:	4885                	li	a7,1
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <exit>:
.global exit
exit:
 li a7, SYS_exit
 96e:	4889                	li	a7,2
 ecall
 970:	00000073          	ecall
 ret
 974:	8082                	ret

0000000000000976 <wait>:
.global wait
wait:
 li a7, SYS_wait
 976:	488d                	li	a7,3
 ecall
 978:	00000073          	ecall
 ret
 97c:	8082                	ret

000000000000097e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 97e:	4891                	li	a7,4
 ecall
 980:	00000073          	ecall
 ret
 984:	8082                	ret

0000000000000986 <read>:
.global read
read:
 li a7, SYS_read
 986:	4895                	li	a7,5
 ecall
 988:	00000073          	ecall
 ret
 98c:	8082                	ret

000000000000098e <write>:
.global write
write:
 li a7, SYS_write
 98e:	48c1                	li	a7,16
 ecall
 990:	00000073          	ecall
 ret
 994:	8082                	ret

0000000000000996 <close>:
.global close
close:
 li a7, SYS_close
 996:	48d5                	li	a7,21
 ecall
 998:	00000073          	ecall
 ret
 99c:	8082                	ret

000000000000099e <kill>:
.global kill
kill:
 li a7, SYS_kill
 99e:	4899                	li	a7,6
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 9a6:	489d                	li	a7,7
 ecall
 9a8:	00000073          	ecall
 ret
 9ac:	8082                	ret

00000000000009ae <open>:
.global open
open:
 li a7, SYS_open
 9ae:	48bd                	li	a7,15
 ecall
 9b0:	00000073          	ecall
 ret
 9b4:	8082                	ret

00000000000009b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 9b6:	48c5                	li	a7,17
 ecall
 9b8:	00000073          	ecall
 ret
 9bc:	8082                	ret

00000000000009be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 9be:	48c9                	li	a7,18
 ecall
 9c0:	00000073          	ecall
 ret
 9c4:	8082                	ret

00000000000009c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 9c6:	48a1                	li	a7,8
 ecall
 9c8:	00000073          	ecall
 ret
 9cc:	8082                	ret

00000000000009ce <link>:
.global link
link:
 li a7, SYS_link
 9ce:	48cd                	li	a7,19
 ecall
 9d0:	00000073          	ecall
 ret
 9d4:	8082                	ret

00000000000009d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9d6:	48d1                	li	a7,20
 ecall
 9d8:	00000073          	ecall
 ret
 9dc:	8082                	ret

00000000000009de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9de:	48a5                	li	a7,9
 ecall
 9e0:	00000073          	ecall
 ret
 9e4:	8082                	ret

00000000000009e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9e6:	48a9                	li	a7,10
 ecall
 9e8:	00000073          	ecall
 ret
 9ec:	8082                	ret

00000000000009ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9ee:	48ad                	li	a7,11
 ecall
 9f0:	00000073          	ecall
 ret
 9f4:	8082                	ret

00000000000009f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9f6:	48b1                	li	a7,12
 ecall
 9f8:	00000073          	ecall
 ret
 9fc:	8082                	ret

00000000000009fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9fe:	48b5                	li	a7,13
 ecall
 a00:	00000073          	ecall
 ret
 a04:	8082                	ret

0000000000000a06 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 a06:	48b9                	li	a7,14
 ecall
 a08:	00000073          	ecall
 ret
 a0c:	8082                	ret

0000000000000a0e <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 a0e:	48d9                	li	a7,22
 ecall
 a10:	00000073          	ecall
 ret
 a14:	8082                	ret

0000000000000a16 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 a16:	1101                	addi	sp,sp,-32
 a18:	ec06                	sd	ra,24(sp)
 a1a:	e822                	sd	s0,16(sp)
 a1c:	1000                	addi	s0,sp,32
 a1e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 a22:	4605                	li	a2,1
 a24:	fef40593          	addi	a1,s0,-17
 a28:	00000097          	auipc	ra,0x0
 a2c:	f66080e7          	jalr	-154(ra) # 98e <write>
}
 a30:	60e2                	ld	ra,24(sp)
 a32:	6442                	ld	s0,16(sp)
 a34:	6105                	addi	sp,sp,32
 a36:	8082                	ret

0000000000000a38 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a38:	7139                	addi	sp,sp,-64
 a3a:	fc06                	sd	ra,56(sp)
 a3c:	f822                	sd	s0,48(sp)
 a3e:	f426                	sd	s1,40(sp)
 a40:	0080                	addi	s0,sp,64
 a42:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a44:	c299                	beqz	a3,a4a <printint+0x12>
 a46:	0805cb63          	bltz	a1,adc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a4a:	2581                	sext.w	a1,a1
  neg = 0;
 a4c:	4881                	li	a7,0
 a4e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a52:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a54:	2601                	sext.w	a2,a2
 a56:	00001517          	auipc	a0,0x1
 a5a:	94250513          	addi	a0,a0,-1726 # 1398 <digits>
 a5e:	883a                	mv	a6,a4
 a60:	2705                	addiw	a4,a4,1
 a62:	02c5f7bb          	remuw	a5,a1,a2
 a66:	1782                	slli	a5,a5,0x20
 a68:	9381                	srli	a5,a5,0x20
 a6a:	97aa                	add	a5,a5,a0
 a6c:	0007c783          	lbu	a5,0(a5)
 a70:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a74:	0005879b          	sext.w	a5,a1
 a78:	02c5d5bb          	divuw	a1,a1,a2
 a7c:	0685                	addi	a3,a3,1
 a7e:	fec7f0e3          	bgeu	a5,a2,a5e <printint+0x26>
  if(neg)
 a82:	00088c63          	beqz	a7,a9a <printint+0x62>
    buf[i++] = '-';
 a86:	fd070793          	addi	a5,a4,-48
 a8a:	00878733          	add	a4,a5,s0
 a8e:	02d00793          	li	a5,45
 a92:	fef70823          	sb	a5,-16(a4)
 a96:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a9a:	02e05c63          	blez	a4,ad2 <printint+0x9a>
 a9e:	f04a                	sd	s2,32(sp)
 aa0:	ec4e                	sd	s3,24(sp)
 aa2:	fc040793          	addi	a5,s0,-64
 aa6:	00e78933          	add	s2,a5,a4
 aaa:	fff78993          	addi	s3,a5,-1
 aae:	99ba                	add	s3,s3,a4
 ab0:	377d                	addiw	a4,a4,-1
 ab2:	1702                	slli	a4,a4,0x20
 ab4:	9301                	srli	a4,a4,0x20
 ab6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 aba:	fff94583          	lbu	a1,-1(s2)
 abe:	8526                	mv	a0,s1
 ac0:	00000097          	auipc	ra,0x0
 ac4:	f56080e7          	jalr	-170(ra) # a16 <putc>
  while(--i >= 0)
 ac8:	197d                	addi	s2,s2,-1
 aca:	ff3918e3          	bne	s2,s3,aba <printint+0x82>
 ace:	7902                	ld	s2,32(sp)
 ad0:	69e2                	ld	s3,24(sp)
}
 ad2:	70e2                	ld	ra,56(sp)
 ad4:	7442                	ld	s0,48(sp)
 ad6:	74a2                	ld	s1,40(sp)
 ad8:	6121                	addi	sp,sp,64
 ada:	8082                	ret
    x = -xx;
 adc:	40b005bb          	negw	a1,a1
    neg = 1;
 ae0:	4885                	li	a7,1
    x = -xx;
 ae2:	b7b5                	j	a4e <printint+0x16>

0000000000000ae4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ae4:	715d                	addi	sp,sp,-80
 ae6:	e486                	sd	ra,72(sp)
 ae8:	e0a2                	sd	s0,64(sp)
 aea:	f84a                	sd	s2,48(sp)
 aec:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 aee:	0005c903          	lbu	s2,0(a1)
 af2:	1a090a63          	beqz	s2,ca6 <vprintf+0x1c2>
 af6:	fc26                	sd	s1,56(sp)
 af8:	f44e                	sd	s3,40(sp)
 afa:	f052                	sd	s4,32(sp)
 afc:	ec56                	sd	s5,24(sp)
 afe:	e85a                	sd	s6,16(sp)
 b00:	e45e                	sd	s7,8(sp)
 b02:	8aaa                	mv	s5,a0
 b04:	8bb2                	mv	s7,a2
 b06:	00158493          	addi	s1,a1,1
  state = 0;
 b0a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b0c:	02500a13          	li	s4,37
 b10:	4b55                	li	s6,21
 b12:	a839                	j	b30 <vprintf+0x4c>
        putc(fd, c);
 b14:	85ca                	mv	a1,s2
 b16:	8556                	mv	a0,s5
 b18:	00000097          	auipc	ra,0x0
 b1c:	efe080e7          	jalr	-258(ra) # a16 <putc>
 b20:	a019                	j	b26 <vprintf+0x42>
    } else if(state == '%'){
 b22:	01498d63          	beq	s3,s4,b3c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 b26:	0485                	addi	s1,s1,1
 b28:	fff4c903          	lbu	s2,-1(s1)
 b2c:	16090763          	beqz	s2,c9a <vprintf+0x1b6>
    if(state == 0){
 b30:	fe0999e3          	bnez	s3,b22 <vprintf+0x3e>
      if(c == '%'){
 b34:	ff4910e3          	bne	s2,s4,b14 <vprintf+0x30>
        state = '%';
 b38:	89d2                	mv	s3,s4
 b3a:	b7f5                	j	b26 <vprintf+0x42>
      if(c == 'd'){
 b3c:	13490463          	beq	s2,s4,c64 <vprintf+0x180>
 b40:	f9d9079b          	addiw	a5,s2,-99
 b44:	0ff7f793          	zext.b	a5,a5
 b48:	12fb6763          	bltu	s6,a5,c76 <vprintf+0x192>
 b4c:	f9d9079b          	addiw	a5,s2,-99
 b50:	0ff7f713          	zext.b	a4,a5
 b54:	12eb6163          	bltu	s6,a4,c76 <vprintf+0x192>
 b58:	00271793          	slli	a5,a4,0x2
 b5c:	00000717          	auipc	a4,0x0
 b60:	7e470713          	addi	a4,a4,2020 # 1340 <malloc+0x5aa>
 b64:	97ba                	add	a5,a5,a4
 b66:	439c                	lw	a5,0(a5)
 b68:	97ba                	add	a5,a5,a4
 b6a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b6c:	008b8913          	addi	s2,s7,8
 b70:	4685                	li	a3,1
 b72:	4629                	li	a2,10
 b74:	000ba583          	lw	a1,0(s7)
 b78:	8556                	mv	a0,s5
 b7a:	00000097          	auipc	ra,0x0
 b7e:	ebe080e7          	jalr	-322(ra) # a38 <printint>
 b82:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b84:	4981                	li	s3,0
 b86:	b745                	j	b26 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b88:	008b8913          	addi	s2,s7,8
 b8c:	4681                	li	a3,0
 b8e:	4629                	li	a2,10
 b90:	000ba583          	lw	a1,0(s7)
 b94:	8556                	mv	a0,s5
 b96:	00000097          	auipc	ra,0x0
 b9a:	ea2080e7          	jalr	-350(ra) # a38 <printint>
 b9e:	8bca                	mv	s7,s2
      state = 0;
 ba0:	4981                	li	s3,0
 ba2:	b751                	j	b26 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 ba4:	008b8913          	addi	s2,s7,8
 ba8:	4681                	li	a3,0
 baa:	4641                	li	a2,16
 bac:	000ba583          	lw	a1,0(s7)
 bb0:	8556                	mv	a0,s5
 bb2:	00000097          	auipc	ra,0x0
 bb6:	e86080e7          	jalr	-378(ra) # a38 <printint>
 bba:	8bca                	mv	s7,s2
      state = 0;
 bbc:	4981                	li	s3,0
 bbe:	b7a5                	j	b26 <vprintf+0x42>
 bc0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 bc2:	008b8c13          	addi	s8,s7,8
 bc6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bca:	03000593          	li	a1,48
 bce:	8556                	mv	a0,s5
 bd0:	00000097          	auipc	ra,0x0
 bd4:	e46080e7          	jalr	-442(ra) # a16 <putc>
  putc(fd, 'x');
 bd8:	07800593          	li	a1,120
 bdc:	8556                	mv	a0,s5
 bde:	00000097          	auipc	ra,0x0
 be2:	e38080e7          	jalr	-456(ra) # a16 <putc>
 be6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 be8:	00000b97          	auipc	s7,0x0
 bec:	7b0b8b93          	addi	s7,s7,1968 # 1398 <digits>
 bf0:	03c9d793          	srli	a5,s3,0x3c
 bf4:	97de                	add	a5,a5,s7
 bf6:	0007c583          	lbu	a1,0(a5)
 bfa:	8556                	mv	a0,s5
 bfc:	00000097          	auipc	ra,0x0
 c00:	e1a080e7          	jalr	-486(ra) # a16 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c04:	0992                	slli	s3,s3,0x4
 c06:	397d                	addiw	s2,s2,-1
 c08:	fe0914e3          	bnez	s2,bf0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 c0c:	8be2                	mv	s7,s8
      state = 0;
 c0e:	4981                	li	s3,0
 c10:	6c02                	ld	s8,0(sp)
 c12:	bf11                	j	b26 <vprintf+0x42>
        s = va_arg(ap, char*);
 c14:	008b8993          	addi	s3,s7,8
 c18:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 c1c:	02090163          	beqz	s2,c3e <vprintf+0x15a>
        while(*s != 0){
 c20:	00094583          	lbu	a1,0(s2)
 c24:	c9a5                	beqz	a1,c94 <vprintf+0x1b0>
          putc(fd, *s);
 c26:	8556                	mv	a0,s5
 c28:	00000097          	auipc	ra,0x0
 c2c:	dee080e7          	jalr	-530(ra) # a16 <putc>
          s++;
 c30:	0905                	addi	s2,s2,1
        while(*s != 0){
 c32:	00094583          	lbu	a1,0(s2)
 c36:	f9e5                	bnez	a1,c26 <vprintf+0x142>
        s = va_arg(ap, char*);
 c38:	8bce                	mv	s7,s3
      state = 0;
 c3a:	4981                	li	s3,0
 c3c:	b5ed                	j	b26 <vprintf+0x42>
          s = "(null)";
 c3e:	00000917          	auipc	s2,0x0
 c42:	6fa90913          	addi	s2,s2,1786 # 1338 <malloc+0x5a2>
        while(*s != 0){
 c46:	02800593          	li	a1,40
 c4a:	bff1                	j	c26 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 c4c:	008b8913          	addi	s2,s7,8
 c50:	000bc583          	lbu	a1,0(s7)
 c54:	8556                	mv	a0,s5
 c56:	00000097          	auipc	ra,0x0
 c5a:	dc0080e7          	jalr	-576(ra) # a16 <putc>
 c5e:	8bca                	mv	s7,s2
      state = 0;
 c60:	4981                	li	s3,0
 c62:	b5d1                	j	b26 <vprintf+0x42>
        putc(fd, c);
 c64:	02500593          	li	a1,37
 c68:	8556                	mv	a0,s5
 c6a:	00000097          	auipc	ra,0x0
 c6e:	dac080e7          	jalr	-596(ra) # a16 <putc>
      state = 0;
 c72:	4981                	li	s3,0
 c74:	bd4d                	j	b26 <vprintf+0x42>
        putc(fd, '%');
 c76:	02500593          	li	a1,37
 c7a:	8556                	mv	a0,s5
 c7c:	00000097          	auipc	ra,0x0
 c80:	d9a080e7          	jalr	-614(ra) # a16 <putc>
        putc(fd, c);
 c84:	85ca                	mv	a1,s2
 c86:	8556                	mv	a0,s5
 c88:	00000097          	auipc	ra,0x0
 c8c:	d8e080e7          	jalr	-626(ra) # a16 <putc>
      state = 0;
 c90:	4981                	li	s3,0
 c92:	bd51                	j	b26 <vprintf+0x42>
        s = va_arg(ap, char*);
 c94:	8bce                	mv	s7,s3
      state = 0;
 c96:	4981                	li	s3,0
 c98:	b579                	j	b26 <vprintf+0x42>
 c9a:	74e2                	ld	s1,56(sp)
 c9c:	79a2                	ld	s3,40(sp)
 c9e:	7a02                	ld	s4,32(sp)
 ca0:	6ae2                	ld	s5,24(sp)
 ca2:	6b42                	ld	s6,16(sp)
 ca4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 ca6:	60a6                	ld	ra,72(sp)
 ca8:	6406                	ld	s0,64(sp)
 caa:	7942                	ld	s2,48(sp)
 cac:	6161                	addi	sp,sp,80
 cae:	8082                	ret

0000000000000cb0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 cb0:	715d                	addi	sp,sp,-80
 cb2:	ec06                	sd	ra,24(sp)
 cb4:	e822                	sd	s0,16(sp)
 cb6:	1000                	addi	s0,sp,32
 cb8:	e010                	sd	a2,0(s0)
 cba:	e414                	sd	a3,8(s0)
 cbc:	e818                	sd	a4,16(s0)
 cbe:	ec1c                	sd	a5,24(s0)
 cc0:	03043023          	sd	a6,32(s0)
 cc4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cc8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ccc:	8622                	mv	a2,s0
 cce:	00000097          	auipc	ra,0x0
 cd2:	e16080e7          	jalr	-490(ra) # ae4 <vprintf>
}
 cd6:	60e2                	ld	ra,24(sp)
 cd8:	6442                	ld	s0,16(sp)
 cda:	6161                	addi	sp,sp,80
 cdc:	8082                	ret

0000000000000cde <printf>:

void
printf(const char *fmt, ...)
{
 cde:	711d                	addi	sp,sp,-96
 ce0:	ec06                	sd	ra,24(sp)
 ce2:	e822                	sd	s0,16(sp)
 ce4:	1000                	addi	s0,sp,32
 ce6:	e40c                	sd	a1,8(s0)
 ce8:	e810                	sd	a2,16(s0)
 cea:	ec14                	sd	a3,24(s0)
 cec:	f018                	sd	a4,32(s0)
 cee:	f41c                	sd	a5,40(s0)
 cf0:	03043823          	sd	a6,48(s0)
 cf4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cf8:	00840613          	addi	a2,s0,8
 cfc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 d00:	85aa                	mv	a1,a0
 d02:	4505                	li	a0,1
 d04:	00000097          	auipc	ra,0x0
 d08:	de0080e7          	jalr	-544(ra) # ae4 <vprintf>
}
 d0c:	60e2                	ld	ra,24(sp)
 d0e:	6442                	ld	s0,16(sp)
 d10:	6125                	addi	sp,sp,96
 d12:	8082                	ret

0000000000000d14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d14:	1141                	addi	sp,sp,-16
 d16:	e422                	sd	s0,8(sp)
 d18:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d1a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d1e:	00001797          	auipc	a5,0x1
 d22:	ada7b783          	ld	a5,-1318(a5) # 17f8 <freep>
 d26:	a02d                	j	d50 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d28:	4618                	lw	a4,8(a2)
 d2a:	9f2d                	addw	a4,a4,a1
 d2c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d30:	6398                	ld	a4,0(a5)
 d32:	6310                	ld	a2,0(a4)
 d34:	a83d                	j	d72 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d36:	ff852703          	lw	a4,-8(a0)
 d3a:	9f31                	addw	a4,a4,a2
 d3c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d3e:	ff053683          	ld	a3,-16(a0)
 d42:	a091                	j	d86 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d44:	6398                	ld	a4,0(a5)
 d46:	00e7e463          	bltu	a5,a4,d4e <free+0x3a>
 d4a:	00e6ea63          	bltu	a3,a4,d5e <free+0x4a>
{
 d4e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d50:	fed7fae3          	bgeu	a5,a3,d44 <free+0x30>
 d54:	6398                	ld	a4,0(a5)
 d56:	00e6e463          	bltu	a3,a4,d5e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d5a:	fee7eae3          	bltu	a5,a4,d4e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d5e:	ff852583          	lw	a1,-8(a0)
 d62:	6390                	ld	a2,0(a5)
 d64:	02059813          	slli	a6,a1,0x20
 d68:	01c85713          	srli	a4,a6,0x1c
 d6c:	9736                	add	a4,a4,a3
 d6e:	fae60de3          	beq	a2,a4,d28 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d72:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d76:	4790                	lw	a2,8(a5)
 d78:	02061593          	slli	a1,a2,0x20
 d7c:	01c5d713          	srli	a4,a1,0x1c
 d80:	973e                	add	a4,a4,a5
 d82:	fae68ae3          	beq	a3,a4,d36 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d86:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d88:	00001717          	auipc	a4,0x1
 d8c:	a6f73823          	sd	a5,-1424(a4) # 17f8 <freep>
}
 d90:	6422                	ld	s0,8(sp)
 d92:	0141                	addi	sp,sp,16
 d94:	8082                	ret

0000000000000d96 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d96:	7139                	addi	sp,sp,-64
 d98:	fc06                	sd	ra,56(sp)
 d9a:	f822                	sd	s0,48(sp)
 d9c:	f426                	sd	s1,40(sp)
 d9e:	ec4e                	sd	s3,24(sp)
 da0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 da2:	02051493          	slli	s1,a0,0x20
 da6:	9081                	srli	s1,s1,0x20
 da8:	04bd                	addi	s1,s1,15
 daa:	8091                	srli	s1,s1,0x4
 dac:	0014899b          	addiw	s3,s1,1
 db0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 db2:	00001517          	auipc	a0,0x1
 db6:	a4653503          	ld	a0,-1466(a0) # 17f8 <freep>
 dba:	c915                	beqz	a0,dee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dbc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dbe:	4798                	lw	a4,8(a5)
 dc0:	08977e63          	bgeu	a4,s1,e5c <malloc+0xc6>
 dc4:	f04a                	sd	s2,32(sp)
 dc6:	e852                	sd	s4,16(sp)
 dc8:	e456                	sd	s5,8(sp)
 dca:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 dcc:	8a4e                	mv	s4,s3
 dce:	0009871b          	sext.w	a4,s3
 dd2:	6685                	lui	a3,0x1
 dd4:	00d77363          	bgeu	a4,a3,dda <malloc+0x44>
 dd8:	6a05                	lui	s4,0x1
 dda:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dde:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 de2:	00001917          	auipc	s2,0x1
 de6:	a1690913          	addi	s2,s2,-1514 # 17f8 <freep>
  if(p == (char*)-1)
 dea:	5afd                	li	s5,-1
 dec:	a091                	j	e30 <malloc+0x9a>
 dee:	f04a                	sd	s2,32(sp)
 df0:	e852                	sd	s4,16(sp)
 df2:	e456                	sd	s5,8(sp)
 df4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 df6:	00001797          	auipc	a5,0x1
 dfa:	a0a78793          	addi	a5,a5,-1526 # 1800 <base>
 dfe:	00001717          	auipc	a4,0x1
 e02:	9ef73d23          	sd	a5,-1542(a4) # 17f8 <freep>
 e06:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 e08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e0c:	b7c1                	j	dcc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 e0e:	6398                	ld	a4,0(a5)
 e10:	e118                	sd	a4,0(a0)
 e12:	a08d                	j	e74 <malloc+0xde>
  hp->s.size = nu;
 e14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e18:	0541                	addi	a0,a0,16
 e1a:	00000097          	auipc	ra,0x0
 e1e:	efa080e7          	jalr	-262(ra) # d14 <free>
  return freep;
 e22:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e26:	c13d                	beqz	a0,e8c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e2a:	4798                	lw	a4,8(a5)
 e2c:	02977463          	bgeu	a4,s1,e54 <malloc+0xbe>
    if(p == freep)
 e30:	00093703          	ld	a4,0(s2)
 e34:	853e                	mv	a0,a5
 e36:	fef719e3          	bne	a4,a5,e28 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 e3a:	8552                	mv	a0,s4
 e3c:	00000097          	auipc	ra,0x0
 e40:	bba080e7          	jalr	-1094(ra) # 9f6 <sbrk>
  if(p == (char*)-1)
 e44:	fd5518e3          	bne	a0,s5,e14 <malloc+0x7e>
        return 0;
 e48:	4501                	li	a0,0
 e4a:	7902                	ld	s2,32(sp)
 e4c:	6a42                	ld	s4,16(sp)
 e4e:	6aa2                	ld	s5,8(sp)
 e50:	6b02                	ld	s6,0(sp)
 e52:	a03d                	j	e80 <malloc+0xea>
 e54:	7902                	ld	s2,32(sp)
 e56:	6a42                	ld	s4,16(sp)
 e58:	6aa2                	ld	s5,8(sp)
 e5a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 e5c:	fae489e3          	beq	s1,a4,e0e <malloc+0x78>
        p->s.size -= nunits;
 e60:	4137073b          	subw	a4,a4,s3
 e64:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e66:	02071693          	slli	a3,a4,0x20
 e6a:	01c6d713          	srli	a4,a3,0x1c
 e6e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e70:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e74:	00001717          	auipc	a4,0x1
 e78:	98a73223          	sd	a0,-1660(a4) # 17f8 <freep>
      return (void*)(p + 1);
 e7c:	01078513          	addi	a0,a5,16
  }
}
 e80:	70e2                	ld	ra,56(sp)
 e82:	7442                	ld	s0,48(sp)
 e84:	74a2                	ld	s1,40(sp)
 e86:	69e2                	ld	s3,24(sp)
 e88:	6121                	addi	sp,sp,64
 e8a:	8082                	ret
 e8c:	7902                	ld	s2,32(sp)
 e8e:	6a42                	ld	s4,16(sp)
 e90:	6aa2                	ld	s5,8(sp)
 e92:	6b02                	ld	s6,0(sp)
 e94:	b7f5                	j	e80 <malloc+0xea>
