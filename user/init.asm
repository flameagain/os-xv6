
user/_init：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8a250513          	addi	a0,a0,-1886 # 8b0 <malloc+0x106>
  16:	00000097          	auipc	ra,0x0
  1a:	3a4080e7          	jalr	932(ra) # 3ba <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3ce080e7          	jalr	974(ra) # 3f2 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3c4080e7          	jalr	964(ra) # 3f2 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	88290913          	addi	s2,s2,-1918 # 8b8 <malloc+0x10e>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6b2080e7          	jalr	1714(ra) # 6f2 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	32a080e7          	jalr	810(ra) # 372 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	328080e7          	jalr	808(ra) # 382 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	89e50513          	addi	a0,a0,-1890 # 908 <malloc+0x15e>
  72:	00000097          	auipc	ra,0x0
  76:	680080e7          	jalr	1664(ra) # 6f2 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2fe080e7          	jalr	766(ra) # 37a <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	82850513          	addi	a0,a0,-2008 # 8b0 <malloc+0x106>
  90:	00000097          	auipc	ra,0x0
  94:	332080e7          	jalr	818(ra) # 3c2 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	81650513          	addi	a0,a0,-2026 # 8b0 <malloc+0x106>
  a2:	00000097          	auipc	ra,0x0
  a6:	318080e7          	jalr	792(ra) # 3ba <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	82450513          	addi	a0,a0,-2012 # 8d0 <malloc+0x126>
  b4:	00000097          	auipc	ra,0x0
  b8:	63e080e7          	jalr	1598(ra) # 6f2 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2bc080e7          	jalr	700(ra) # 37a <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	cb258593          	addi	a1,a1,-846 # d78 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	81a50513          	addi	a0,a0,-2022 # 8e8 <malloc+0x13e>
  d6:	00000097          	auipc	ra,0x0
  da:	2dc080e7          	jalr	732(ra) # 3b2 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	81250513          	addi	a0,a0,-2030 # 8f0 <malloc+0x146>
  e6:	00000097          	auipc	ra,0x0
  ea:	60c080e7          	jalr	1548(ra) # 6f2 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	28a080e7          	jalr	650(ra) # 37a <exit>

00000000000000f8 <strcpy>:



char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	86be                	mv	a3,a5
 152:	0785                	addi	a5,a5,1
 154:	fff7c703          	lbu	a4,-1(a5)
 158:	ff65                	bnez	a4,150 <strlen+0x10>
 15a:	40a6853b          	subw	a0,a3,a0
 15e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d863          	bge	s1,s4,206 <gets+0x56>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	1b0080e7          	jalr	432(ra) # 392 <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x56>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x54>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679be3          	bne	a5,s6,1d2 <gets+0x22>
    buf[i++] = c;
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x56>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	00000097          	auipc	ra,0x0
 236:	188080e7          	jalr	392(ra) # 3ba <open>
  if(fd < 0)
 23a:	02054663          	bltz	a0,266 <stat+0x42>
 23e:	e426                	sd	s1,8(sp)
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	18e080e7          	jalr	398(ra) # 3d2 <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	152080e7          	jalr	338(ra) # 3a2 <close>
  return r;
 258:	64a2                	ld	s1,8(sp)
}
 25a:	854a                	mv	a0,s2
 25c:	60e2                	ld	ra,24(sp)
 25e:	6442                	ld	s0,16(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	597d                	li	s2,-1
 268:	bfcd                	j	25a <stat+0x36>

000000000000026a <atoi>:

int
atoi(const char *s)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 270:	00054683          	lbu	a3,0(a0)
 274:	fd06879b          	addiw	a5,a3,-48
 278:	0ff7f793          	zext.b	a5,a5
 27c:	4625                	li	a2,9
 27e:	02f66863          	bltu	a2,a5,2ae <atoi+0x44>
 282:	872a                	mv	a4,a0
  n = 0;
 284:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 286:	0705                	addi	a4,a4,1
 288:	0025179b          	slliw	a5,a0,0x2
 28c:	9fa9                	addw	a5,a5,a0
 28e:	0017979b          	slliw	a5,a5,0x1
 292:	9fb5                	addw	a5,a5,a3
 294:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 298:	00074683          	lbu	a3,0(a4)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	fef671e3          	bgeu	a2,a5,286 <atoi+0x1c>
  return n;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  n = 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <atoi+0x3e>

00000000000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57463          	bgeu	a0,a1,2e0 <memmove+0x2e>
    while(n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x28>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d6:	fef71ae3          	bne	a4,a5,2ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e6:	fec05ae3          	blez	a2,2da <memmove+0x28>
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x46>
 308:	bfc9                	j	2da <memmove+0x28>

000000000000030a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca05                	beqz	a2,340 <memcmp+0x36>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x14>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x30>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <memcmp+0x30>

0000000000000344 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34c:	00000097          	auipc	ra,0x0
 350:	f66080e7          	jalr	-154(ra) # 2b2 <memmove>
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 362:	040007b7          	lui	a5,0x4000
 366:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffea85>
 368:	07b2                	slli	a5,a5,0xc
}
 36a:	4388                	lw	a0,0(a5)
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 372:	4885                	li	a7,1
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exit>:
.global exit
exit:
 li a7, SYS_exit
 37a:	4889                	li	a7,2
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <wait>:
.global wait
wait:
 li a7, SYS_wait
 382:	488d                	li	a7,3
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38a:	4891                	li	a7,4
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <read>:
.global read
read:
 li a7, SYS_read
 392:	4895                	li	a7,5
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <write>:
.global write
write:
 li a7, SYS_write
 39a:	48c1                	li	a7,16
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <close>:
.global close
close:
 li a7, SYS_close
 3a2:	48d5                	li	a7,21
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3aa:	4899                	li	a7,6
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b2:	489d                	li	a7,7
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c2:	48c5                	li	a7,17
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ca:	48c9                	li	a7,18
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ea:	48a5                	li	a7,9
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f2:	48a9                	li	a7,10
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fa:	48ad                	li	a7,11
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 402:	48b1                	li	a7,12
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40a:	48b5                	li	a7,13
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 412:	48b9                	li	a7,14
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <connect>:
.global connect
connect:
 li a7, SYS_connect
 41a:	48f5                	li	a7,29
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 422:	48f9                	li	a7,30
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	1000                	addi	s0,sp,32
 432:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 436:	4605                	li	a2,1
 438:	fef40593          	addi	a1,s0,-17
 43c:	00000097          	auipc	ra,0x0
 440:	f5e080e7          	jalr	-162(ra) # 39a <write>
}
 444:	60e2                	ld	ra,24(sp)
 446:	6442                	ld	s0,16(sp)
 448:	6105                	addi	sp,sp,32
 44a:	8082                	ret

000000000000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	7139                	addi	sp,sp,-64
 44e:	fc06                	sd	ra,56(sp)
 450:	f822                	sd	s0,48(sp)
 452:	f426                	sd	s1,40(sp)
 454:	0080                	addi	s0,sp,64
 456:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 458:	c299                	beqz	a3,45e <printint+0x12>
 45a:	0805cb63          	bltz	a1,4f0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45e:	2581                	sext.w	a1,a1
  neg = 0;
 460:	4881                	li	a7,0
 462:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 466:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 468:	2601                	sext.w	a2,a2
 46a:	00000517          	auipc	a0,0x0
 46e:	51e50513          	addi	a0,a0,1310 # 988 <digits>
 472:	883a                	mv	a6,a4
 474:	2705                	addiw	a4,a4,1
 476:	02c5f7bb          	remuw	a5,a1,a2
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	97aa                	add	a5,a5,a0
 480:	0007c783          	lbu	a5,0(a5)
 484:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 488:	0005879b          	sext.w	a5,a1
 48c:	02c5d5bb          	divuw	a1,a1,a2
 490:	0685                	addi	a3,a3,1
 492:	fec7f0e3          	bgeu	a5,a2,472 <printint+0x26>
  if(neg)
 496:	00088c63          	beqz	a7,4ae <printint+0x62>
    buf[i++] = '-';
 49a:	fd070793          	addi	a5,a4,-48
 49e:	00878733          	add	a4,a5,s0
 4a2:	02d00793          	li	a5,45
 4a6:	fef70823          	sb	a5,-16(a4)
 4aa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ae:	02e05c63          	blez	a4,4e6 <printint+0x9a>
 4b2:	f04a                	sd	s2,32(sp)
 4b4:	ec4e                	sd	s3,24(sp)
 4b6:	fc040793          	addi	a5,s0,-64
 4ba:	00e78933          	add	s2,a5,a4
 4be:	fff78993          	addi	s3,a5,-1
 4c2:	99ba                	add	s3,s3,a4
 4c4:	377d                	addiw	a4,a4,-1
 4c6:	1702                	slli	a4,a4,0x20
 4c8:	9301                	srli	a4,a4,0x20
 4ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ce:	fff94583          	lbu	a1,-1(s2)
 4d2:	8526                	mv	a0,s1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f56080e7          	jalr	-170(ra) # 42a <putc>
  while(--i >= 0)
 4dc:	197d                	addi	s2,s2,-1
 4de:	ff3918e3          	bne	s2,s3,4ce <printint+0x82>
 4e2:	7902                	ld	s2,32(sp)
 4e4:	69e2                	ld	s3,24(sp)
}
 4e6:	70e2                	ld	ra,56(sp)
 4e8:	7442                	ld	s0,48(sp)
 4ea:	74a2                	ld	s1,40(sp)
 4ec:	6121                	addi	sp,sp,64
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005bb          	negw	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	b7b5                	j	462 <printint+0x16>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	715d                	addi	sp,sp,-80
 4fa:	e486                	sd	ra,72(sp)
 4fc:	e0a2                	sd	s0,64(sp)
 4fe:	f84a                	sd	s2,48(sp)
 500:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 502:	0005c903          	lbu	s2,0(a1)
 506:	1a090a63          	beqz	s2,6ba <vprintf+0x1c2>
 50a:	fc26                	sd	s1,56(sp)
 50c:	f44e                	sd	s3,40(sp)
 50e:	f052                	sd	s4,32(sp)
 510:	ec56                	sd	s5,24(sp)
 512:	e85a                	sd	s6,16(sp)
 514:	e45e                	sd	s7,8(sp)
 516:	8aaa                	mv	s5,a0
 518:	8bb2                	mv	s7,a2
 51a:	00158493          	addi	s1,a1,1
  state = 0;
 51e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 520:	02500a13          	li	s4,37
 524:	4b55                	li	s6,21
 526:	a839                	j	544 <vprintf+0x4c>
        putc(fd, c);
 528:	85ca                	mv	a1,s2
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	efe080e7          	jalr	-258(ra) # 42a <putc>
 534:	a019                	j	53a <vprintf+0x42>
    } else if(state == '%'){
 536:	01498d63          	beq	s3,s4,550 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 53a:	0485                	addi	s1,s1,1
 53c:	fff4c903          	lbu	s2,-1(s1)
 540:	16090763          	beqz	s2,6ae <vprintf+0x1b6>
    if(state == 0){
 544:	fe0999e3          	bnez	s3,536 <vprintf+0x3e>
      if(c == '%'){
 548:	ff4910e3          	bne	s2,s4,528 <vprintf+0x30>
        state = '%';
 54c:	89d2                	mv	s3,s4
 54e:	b7f5                	j	53a <vprintf+0x42>
      if(c == 'd'){
 550:	13490463          	beq	s2,s4,678 <vprintf+0x180>
 554:	f9d9079b          	addiw	a5,s2,-99
 558:	0ff7f793          	zext.b	a5,a5
 55c:	12fb6763          	bltu	s6,a5,68a <vprintf+0x192>
 560:	f9d9079b          	addiw	a5,s2,-99
 564:	0ff7f713          	zext.b	a4,a5
 568:	12eb6163          	bltu	s6,a4,68a <vprintf+0x192>
 56c:	00271793          	slli	a5,a4,0x2
 570:	00000717          	auipc	a4,0x0
 574:	3c070713          	addi	a4,a4,960 # 930 <malloc+0x186>
 578:	97ba                	add	a5,a5,a4
 57a:	439c                	lw	a5,0(a5)
 57c:	97ba                	add	a5,a5,a4
 57e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b8913          	addi	s2,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	ebe080e7          	jalr	-322(ra) # 44c <printint>
 596:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 598:	4981                	li	s3,0
 59a:	b745                	j	53a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ea2080e7          	jalr	-350(ra) # 44c <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b751                	j	53a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e86080e7          	jalr	-378(ra) # 44c <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b7a5                	j	53a <vprintf+0x42>
 5d4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d6:	008b8c13          	addi	s8,s7,8
 5da:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5de:	03000593          	li	a1,48
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e46080e7          	jalr	-442(ra) # 42a <putc>
  putc(fd, 'x');
 5ec:	07800593          	li	a1,120
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e38080e7          	jalr	-456(ra) # 42a <putc>
 5fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	00000b97          	auipc	s7,0x0
 600:	38cb8b93          	addi	s7,s7,908 # 988 <digits>
 604:	03c9d793          	srli	a5,s3,0x3c
 608:	97de                	add	a5,a5,s7
 60a:	0007c583          	lbu	a1,0(a5)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e1a080e7          	jalr	-486(ra) # 42a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 618:	0992                	slli	s3,s3,0x4
 61a:	397d                	addiw	s2,s2,-1
 61c:	fe0914e3          	bnez	s2,604 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 620:	8be2                	mv	s7,s8
      state = 0;
 622:	4981                	li	s3,0
 624:	6c02                	ld	s8,0(sp)
 626:	bf11                	j	53a <vprintf+0x42>
        s = va_arg(ap, char*);
 628:	008b8993          	addi	s3,s7,8
 62c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 630:	02090163          	beqz	s2,652 <vprintf+0x15a>
        while(*s != 0){
 634:	00094583          	lbu	a1,0(s2)
 638:	c9a5                	beqz	a1,6a8 <vprintf+0x1b0>
          putc(fd, *s);
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dee080e7          	jalr	-530(ra) # 42a <putc>
          s++;
 644:	0905                	addi	s2,s2,1
        while(*s != 0){
 646:	00094583          	lbu	a1,0(s2)
 64a:	f9e5                	bnez	a1,63a <vprintf+0x142>
        s = va_arg(ap, char*);
 64c:	8bce                	mv	s7,s3
      state = 0;
 64e:	4981                	li	s3,0
 650:	b5ed                	j	53a <vprintf+0x42>
          s = "(null)";
 652:	00000917          	auipc	s2,0x0
 656:	2d690913          	addi	s2,s2,726 # 928 <malloc+0x17e>
        while(*s != 0){
 65a:	02800593          	li	a1,40
 65e:	bff1                	j	63a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 660:	008b8913          	addi	s2,s7,8
 664:	000bc583          	lbu	a1,0(s7)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	dc0080e7          	jalr	-576(ra) # 42a <putc>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b5d1                	j	53a <vprintf+0x42>
        putc(fd, c);
 678:	02500593          	li	a1,37
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	dac080e7          	jalr	-596(ra) # 42a <putc>
      state = 0;
 686:	4981                	li	s3,0
 688:	bd4d                	j	53a <vprintf+0x42>
        putc(fd, '%');
 68a:	02500593          	li	a1,37
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	d9a080e7          	jalr	-614(ra) # 42a <putc>
        putc(fd, c);
 698:	85ca                	mv	a1,s2
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	d8e080e7          	jalr	-626(ra) # 42a <putc>
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd51                	j	53a <vprintf+0x42>
        s = va_arg(ap, char*);
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b579                	j	53a <vprintf+0x42>
 6ae:	74e2                	ld	s1,56(sp)
 6b0:	79a2                	ld	s3,40(sp)
 6b2:	7a02                	ld	s4,32(sp)
 6b4:	6ae2                	ld	s5,24(sp)
 6b6:	6b42                	ld	s6,16(sp)
 6b8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ba:	60a6                	ld	ra,72(sp)
 6bc:	6406                	ld	s0,64(sp)
 6be:	7942                	ld	s2,48(sp)
 6c0:	6161                	addi	sp,sp,80
 6c2:	8082                	ret

00000000000006c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c4:	715d                	addi	sp,sp,-80
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e010                	sd	a2,0(s0)
 6ce:	e414                	sd	a3,8(s0)
 6d0:	e818                	sd	a4,16(s0)
 6d2:	ec1c                	sd	a5,24(s0)
 6d4:	03043023          	sd	a6,32(s0)
 6d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e0:	8622                	mv	a2,s0
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e16080e7          	jalr	-490(ra) # 4f8 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <printf>:

void
printf(const char *fmt, ...)
{
 6f2:	711d                	addi	sp,sp,-96
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e40c                	sd	a1,8(s0)
 6fc:	e810                	sd	a2,16(s0)
 6fe:	ec14                	sd	a3,24(s0)
 700:	f018                	sd	a4,32(s0)
 702:	f41c                	sd	a5,40(s0)
 704:	03043823          	sd	a6,48(s0)
 708:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	00840613          	addi	a2,s0,8
 710:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 714:	85aa                	mv	a1,a0
 716:	4505                	li	a0,1
 718:	00000097          	auipc	ra,0x0
 71c:	de0080e7          	jalr	-544(ra) # 4f8 <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6125                	addi	sp,sp,96
 726:	8082                	ret

0000000000000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	1141                	addi	sp,sp,-16
 72a:	e422                	sd	s0,8(sp)
 72c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	00000797          	auipc	a5,0x0
 736:	6567b783          	ld	a5,1622(a5) # d88 <freep>
 73a:	a02d                	j	764 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	4618                	lw	a4,8(a2)
 73e:	9f2d                	addw	a4,a4,a1
 740:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	6398                	ld	a4,0(a5)
 746:	6310                	ld	a2,0(a4)
 748:	a83d                	j	786 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74a:	ff852703          	lw	a4,-8(a0)
 74e:	9f31                	addw	a4,a4,a2
 750:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 752:	ff053683          	ld	a3,-16(a0)
 756:	a091                	j	79a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	6398                	ld	a4,0(a5)
 75a:	00e7e463          	bltu	a5,a4,762 <free+0x3a>
 75e:	00e6ea63          	bltu	a3,a4,772 <free+0x4a>
{
 762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	fed7fae3          	bgeu	a5,a3,758 <free+0x30>
 768:	6398                	ld	a4,0(a5)
 76a:	00e6e463          	bltu	a3,a4,772 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fee7eae3          	bltu	a5,a4,762 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 772:	ff852583          	lw	a1,-8(a0)
 776:	6390                	ld	a2,0(a5)
 778:	02059813          	slli	a6,a1,0x20
 77c:	01c85713          	srli	a4,a6,0x1c
 780:	9736                	add	a4,a4,a3
 782:	fae60de3          	beq	a2,a4,73c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78a:	4790                	lw	a2,8(a5)
 78c:	02061593          	slli	a1,a2,0x20
 790:	01c5d713          	srli	a4,a1,0x1c
 794:	973e                	add	a4,a4,a5
 796:	fae68ae3          	beq	a3,a4,74a <free+0x22>
    p->s.ptr = bp->s.ptr;
 79a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79c:	00000717          	auipc	a4,0x0
 7a0:	5ef73623          	sd	a5,1516(a4) # d88 <freep>
}
 7a4:	6422                	ld	s0,8(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret

00000000000007aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7aa:	7139                	addi	sp,sp,-64
 7ac:	fc06                	sd	ra,56(sp)
 7ae:	f822                	sd	s0,48(sp)
 7b0:	f426                	sd	s1,40(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b6:	02051493          	slli	s1,a0,0x20
 7ba:	9081                	srli	s1,s1,0x20
 7bc:	04bd                	addi	s1,s1,15
 7be:	8091                	srli	s1,s1,0x4
 7c0:	0014899b          	addiw	s3,s1,1
 7c4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c6:	00000517          	auipc	a0,0x0
 7ca:	5c253503          	ld	a0,1474(a0) # d88 <freep>
 7ce:	c915                	beqz	a0,802 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d2:	4798                	lw	a4,8(a5)
 7d4:	08977e63          	bgeu	a4,s1,870 <malloc+0xc6>
 7d8:	f04a                	sd	s2,32(sp)
 7da:	e852                	sd	s4,16(sp)
 7dc:	e456                	sd	s5,8(sp)
 7de:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e0:	8a4e                	mv	s4,s3
 7e2:	0009871b          	sext.w	a4,s3
 7e6:	6685                	lui	a3,0x1
 7e8:	00d77363          	bgeu	a4,a3,7ee <malloc+0x44>
 7ec:	6a05                	lui	s4,0x1
 7ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f6:	00000917          	auipc	s2,0x0
 7fa:	59290913          	addi	s2,s2,1426 # d88 <freep>
  if(p == (char*)-1)
 7fe:	5afd                	li	s5,-1
 800:	a091                	j	844 <malloc+0x9a>
 802:	f04a                	sd	s2,32(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80a:	00000797          	auipc	a5,0x0
 80e:	58678793          	addi	a5,a5,1414 # d90 <base>
 812:	00000717          	auipc	a4,0x0
 816:	56f73b23          	sd	a5,1398(a4) # d88 <freep>
 81a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 820:	b7c1                	j	7e0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	e118                	sd	a4,0(a0)
 826:	a08d                	j	888 <malloc+0xde>
  hp->s.size = nu;
 828:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82c:	0541                	addi	a0,a0,16
 82e:	00000097          	auipc	ra,0x0
 832:	efa080e7          	jalr	-262(ra) # 728 <free>
  return freep;
 836:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83a:	c13d                	beqz	a0,8a0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83e:	4798                	lw	a4,8(a5)
 840:	02977463          	bgeu	a4,s1,868 <malloc+0xbe>
    if(p == freep)
 844:	00093703          	ld	a4,0(s2)
 848:	853e                	mv	a0,a5
 84a:	fef719e3          	bne	a4,a5,83c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 84e:	8552                	mv	a0,s4
 850:	00000097          	auipc	ra,0x0
 854:	bb2080e7          	jalr	-1102(ra) # 402 <sbrk>
  if(p == (char*)-1)
 858:	fd5518e3          	bne	a0,s5,828 <malloc+0x7e>
        return 0;
 85c:	4501                	li	a0,0
 85e:	7902                	ld	s2,32(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	a03d                	j	894 <malloc+0xea>
 868:	7902                	ld	s2,32(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 870:	fae489e3          	beq	s1,a4,822 <malloc+0x78>
        p->s.size -= nunits;
 874:	4137073b          	subw	a4,a4,s3
 878:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87a:	02071693          	slli	a3,a4,0x20
 87e:	01c6d713          	srli	a4,a3,0x1c
 882:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 884:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 888:	00000717          	auipc	a4,0x0
 88c:	50a73023          	sd	a0,1280(a4) # d88 <freep>
      return (void*)(p + 1);
 890:	01078513          	addi	a0,a5,16
  }
}
 894:	70e2                	ld	ra,56(sp)
 896:	7442                	ld	s0,48(sp)
 898:	74a2                	ld	s1,40(sp)
 89a:	69e2                	ld	s3,24(sp)
 89c:	6121                	addi	sp,sp,64
 89e:	8082                	ret
 8a0:	7902                	ld	s2,32(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	b7f5                	j	894 <malloc+0xea>
