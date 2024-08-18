
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	e22d8d93          	addi	s11,s11,-478 # e50 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	910a0a13          	addi	s4,s4,-1776 # 948 <malloc+0x106>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1de080e7          	jalr	478(ra) # 224 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3ae080e7          	jalr	942(ra) # 42a <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	dc648493          	addi	s1,s1,-570 # e50 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	8c250513          	addi	a0,a0,-1854 # 968 <malloc+0x126>
  ae:	00000097          	auipc	ra,0x0
  b2:	6dc080e7          	jalr	1756(ra) # 78a <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	88450513          	addi	a0,a0,-1916 # 958 <malloc+0x116>
  dc:	00000097          	auipc	ra,0x0
  e0:	6ae080e7          	jalr	1710(ra) # 78a <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	32c080e7          	jalr	812(ra) # 412 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	336080e7          	jalr	822(ra) # 452 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	302080e7          	jalr	770(ra) # 43a <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2ca080e7          	jalr	714(ra) # 412 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00000597          	auipc	a1,0x0
 15a:	7fa58593          	addi	a1,a1,2042 # 950 <malloc+0x10e>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2a8080e7          	jalr	680(ra) # 412 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	80250513          	addi	a0,a0,-2046 # 978 <malloc+0x136>
 17e:	00000097          	auipc	ra,0x0
 182:	60c080e7          	jalr	1548(ra) # 78a <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	28a080e7          	jalr	650(ra) # 412 <exit>

0000000000000190 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 196:	87aa                	mv	a5,a0
 198:	0585                	addi	a1,a1,1
 19a:	0785                	addi	a5,a5,1
 19c:	fff5c703          	lbu	a4,-1(a1)
 1a0:	fee78fa3          	sb	a4,-1(a5)
 1a4:	fb75                	bnez	a4,198 <strcpy+0x8>
    ;
  return os;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cb91                	beqz	a5,1ca <strcmp+0x1e>
 1b8:	0005c703          	lbu	a4,0(a1)
 1bc:	00f71763          	bne	a4,a5,1ca <strcmp+0x1e>
    p++, q++;
 1c0:	0505                	addi	a0,a0,1
 1c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbe5                	bnez	a5,1b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ca:	0005c503          	lbu	a0,0(a1)
}
 1ce:	40a7853b          	subw	a0,a5,a0
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strlen>:

uint
strlen(const char *s)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cf91                	beqz	a5,1fe <strlen+0x26>
 1e4:	0505                	addi	a0,a0,1
 1e6:	87aa                	mv	a5,a0
 1e8:	86be                	mv	a3,a5
 1ea:	0785                	addi	a5,a5,1
 1ec:	fff7c703          	lbu	a4,-1(a5)
 1f0:	ff65                	bnez	a4,1e8 <strlen+0x10>
 1f2:	40a6853b          	subw	a0,a3,a0
 1f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  for(n = 0; s[n]; n++)
 1fe:	4501                	li	a0,0
 200:	bfe5                	j	1f8 <strlen+0x20>

0000000000000202 <memset>:

void*
memset(void *dst, int c, uint n)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 208:	ca19                	beqz	a2,21e <memset+0x1c>
 20a:	87aa                	mv	a5,a0
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 214:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 218:	0785                	addi	a5,a5,1
 21a:	fee79de3          	bne	a5,a4,214 <memset+0x12>
  }
  return dst;
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret

0000000000000224 <strchr>:

char*
strchr(const char *s, char c)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  for(; *s; s++)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	cb99                	beqz	a5,244 <strchr+0x20>
    if(*s == c)
 230:	00f58763          	beq	a1,a5,23e <strchr+0x1a>
  for(; *s; s++)
 234:	0505                	addi	a0,a0,1
 236:	00054783          	lbu	a5,0(a0)
 23a:	fbfd                	bnez	a5,230 <strchr+0xc>
      return (char*)s;
  return 0;
 23c:	4501                	li	a0,0
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
  return 0;
 244:	4501                	li	a0,0
 246:	bfe5                	j	23e <strchr+0x1a>

0000000000000248 <gets>:

char*
gets(char *buf, int max)
{
 248:	711d                	addi	sp,sp,-96
 24a:	ec86                	sd	ra,88(sp)
 24c:	e8a2                	sd	s0,80(sp)
 24e:	e4a6                	sd	s1,72(sp)
 250:	e0ca                	sd	s2,64(sp)
 252:	fc4e                	sd	s3,56(sp)
 254:	f852                	sd	s4,48(sp)
 256:	f456                	sd	s5,40(sp)
 258:	f05a                	sd	s6,32(sp)
 25a:	ec5e                	sd	s7,24(sp)
 25c:	1080                	addi	s0,sp,96
 25e:	8baa                	mv	s7,a0
 260:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 262:	892a                	mv	s2,a0
 264:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 266:	4aa9                	li	s5,10
 268:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 26a:	89a6                	mv	s3,s1
 26c:	2485                	addiw	s1,s1,1
 26e:	0344d863          	bge	s1,s4,29e <gets+0x56>
    cc = read(0, &c, 1);
 272:	4605                	li	a2,1
 274:	faf40593          	addi	a1,s0,-81
 278:	4501                	li	a0,0
 27a:	00000097          	auipc	ra,0x0
 27e:	1b0080e7          	jalr	432(ra) # 42a <read>
    if(cc < 1)
 282:	00a05e63          	blez	a0,29e <gets+0x56>
    buf[i++] = c;
 286:	faf44783          	lbu	a5,-81(s0)
 28a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28e:	01578763          	beq	a5,s5,29c <gets+0x54>
 292:	0905                	addi	s2,s2,1
 294:	fd679be3          	bne	a5,s6,26a <gets+0x22>
    buf[i++] = c;
 298:	89a6                	mv	s3,s1
 29a:	a011                	j	29e <gets+0x56>
 29c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29e:	99de                	add	s3,s3,s7
 2a0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a4:	855e                	mv	a0,s7
 2a6:	60e6                	ld	ra,88(sp)
 2a8:	6446                	ld	s0,80(sp)
 2aa:	64a6                	ld	s1,72(sp)
 2ac:	6906                	ld	s2,64(sp)
 2ae:	79e2                	ld	s3,56(sp)
 2b0:	7a42                	ld	s4,48(sp)
 2b2:	7aa2                	ld	s5,40(sp)
 2b4:	7b02                	ld	s6,32(sp)
 2b6:	6be2                	ld	s7,24(sp)
 2b8:	6125                	addi	sp,sp,96
 2ba:	8082                	ret

00000000000002bc <stat>:

int
stat(const char *n, struct stat *st)
{
 2bc:	1101                	addi	sp,sp,-32
 2be:	ec06                	sd	ra,24(sp)
 2c0:	e822                	sd	s0,16(sp)
 2c2:	e04a                	sd	s2,0(sp)
 2c4:	1000                	addi	s0,sp,32
 2c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	4581                	li	a1,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	188080e7          	jalr	392(ra) # 452 <open>
  if(fd < 0)
 2d2:	02054663          	bltz	a0,2fe <stat+0x42>
 2d6:	e426                	sd	s1,8(sp)
 2d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2da:	85ca                	mv	a1,s2
 2dc:	00000097          	auipc	ra,0x0
 2e0:	18e080e7          	jalr	398(ra) # 46a <fstat>
 2e4:	892a                	mv	s2,a0
  close(fd);
 2e6:	8526                	mv	a0,s1
 2e8:	00000097          	auipc	ra,0x0
 2ec:	152080e7          	jalr	338(ra) # 43a <close>
  return r;
 2f0:	64a2                	ld	s1,8(sp)
}
 2f2:	854a                	mv	a0,s2
 2f4:	60e2                	ld	ra,24(sp)
 2f6:	6442                	ld	s0,16(sp)
 2f8:	6902                	ld	s2,0(sp)
 2fa:	6105                	addi	sp,sp,32
 2fc:	8082                	ret
    return -1;
 2fe:	597d                	li	s2,-1
 300:	bfcd                	j	2f2 <stat+0x36>

0000000000000302 <atoi>:

int
atoi(const char *s)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	00054683          	lbu	a3,0(a0)
 30c:	fd06879b          	addiw	a5,a3,-48
 310:	0ff7f793          	zext.b	a5,a5
 314:	4625                	li	a2,9
 316:	02f66863          	bltu	a2,a5,346 <atoi+0x44>
 31a:	872a                	mv	a4,a0
  n = 0;
 31c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 31e:	0705                	addi	a4,a4,1
 320:	0025179b          	slliw	a5,a0,0x2
 324:	9fa9                	addw	a5,a5,a0
 326:	0017979b          	slliw	a5,a5,0x1
 32a:	9fb5                	addw	a5,a5,a3
 32c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 330:	00074683          	lbu	a3,0(a4)
 334:	fd06879b          	addiw	a5,a3,-48
 338:	0ff7f793          	zext.b	a5,a5
 33c:	fef671e3          	bgeu	a2,a5,31e <atoi+0x1c>
  return n;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  n = 0;
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <atoi+0x3e>

000000000000034a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 350:	02b57463          	bgeu	a0,a1,378 <memmove+0x2e>
    while(n-- > 0)
 354:	00c05f63          	blez	a2,372 <memmove+0x28>
 358:	1602                	slli	a2,a2,0x20
 35a:	9201                	srli	a2,a2,0x20
 35c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 360:	872a                	mv	a4,a0
      *dst++ = *src++;
 362:	0585                	addi	a1,a1,1
 364:	0705                	addi	a4,a4,1
 366:	fff5c683          	lbu	a3,-1(a1)
 36a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36e:	fef71ae3          	bne	a4,a5,362 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
    dst += n;
 378:	00c50733          	add	a4,a0,a2
    src += n;
 37c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37e:	fec05ae3          	blez	a2,372 <memmove+0x28>
 382:	fff6079b          	addiw	a5,a2,-1
 386:	1782                	slli	a5,a5,0x20
 388:	9381                	srli	a5,a5,0x20
 38a:	fff7c793          	not	a5,a5
 38e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 390:	15fd                	addi	a1,a1,-1
 392:	177d                	addi	a4,a4,-1
 394:	0005c683          	lbu	a3,0(a1)
 398:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39c:	fee79ae3          	bne	a5,a4,390 <memmove+0x46>
 3a0:	bfc9                	j	372 <memmove+0x28>

00000000000003a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a8:	ca05                	beqz	a2,3d8 <memcmp+0x36>
 3aa:	fff6069b          	addiw	a3,a2,-1
 3ae:	1682                	slli	a3,a3,0x20
 3b0:	9281                	srli	a3,a3,0x20
 3b2:	0685                	addi	a3,a3,1
 3b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	0005c703          	lbu	a4,0(a1)
 3be:	00e79863          	bne	a5,a4,3ce <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c2:	0505                	addi	a0,a0,1
    p2++;
 3c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c6:	fed518e3          	bne	a0,a3,3b6 <memcmp+0x14>
  }
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	a019                	j	3d2 <memcmp+0x30>
      return *p1 - *p2;
 3ce:	40e7853b          	subw	a0,a5,a4
}
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
  return 0;
 3d8:	4501                	li	a0,0
 3da:	bfe5                	j	3d2 <memcmp+0x30>

00000000000003dc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e406                	sd	ra,8(sp)
 3e0:	e022                	sd	s0,0(sp)
 3e2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f66080e7          	jalr	-154(ra) # 34a <memmove>
}
 3ec:	60a2                	ld	ra,8(sp)
 3ee:	6402                	ld	s0,0(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 3fa:	040007b7          	lui	a5,0x4000
 3fe:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffe9b9>
 400:	07b2                	slli	a5,a5,0xc
}
 402:	4388                	lw	a0,0(a5)
 404:	6422                	ld	s0,8(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret

000000000000040a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40a:	4885                	li	a7,1
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exit>:
.global exit
exit:
 li a7, SYS_exit
 412:	4889                	li	a7,2
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <wait>:
.global wait
wait:
 li a7, SYS_wait
 41a:	488d                	li	a7,3
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 422:	4891                	li	a7,4
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <read>:
.global read
read:
 li a7, SYS_read
 42a:	4895                	li	a7,5
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <write>:
.global write
write:
 li a7, SYS_write
 432:	48c1                	li	a7,16
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <close>:
.global close
close:
 li a7, SYS_close
 43a:	48d5                	li	a7,21
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <kill>:
.global kill
kill:
 li a7, SYS_kill
 442:	4899                	li	a7,6
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exec>:
.global exec
exec:
 li a7, SYS_exec
 44a:	489d                	li	a7,7
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <open>:
.global open
open:
 li a7, SYS_open
 452:	48bd                	li	a7,15
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45a:	48c5                	li	a7,17
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 462:	48c9                	li	a7,18
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46a:	48a1                	li	a7,8
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <link>:
.global link
link:
 li a7, SYS_link
 472:	48cd                	li	a7,19
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47a:	48d1                	li	a7,20
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 482:	48a5                	li	a7,9
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <dup>:
.global dup
dup:
 li a7, SYS_dup
 48a:	48a9                	li	a7,10
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 492:	48ad                	li	a7,11
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49a:	48b1                	li	a7,12
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a2:	48b5                	li	a7,13
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4aa:	48b9                	li	a7,14
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4b2:	48f5                	li	a7,29
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ba:	48f9                	li	a7,30
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c2:	1101                	addi	sp,sp,-32
 4c4:	ec06                	sd	ra,24(sp)
 4c6:	e822                	sd	s0,16(sp)
 4c8:	1000                	addi	s0,sp,32
 4ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ce:	4605                	li	a2,1
 4d0:	fef40593          	addi	a1,s0,-17
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f5e080e7          	jalr	-162(ra) # 432 <write>
}
 4dc:	60e2                	ld	ra,24(sp)
 4de:	6442                	ld	s0,16(sp)
 4e0:	6105                	addi	sp,sp,32
 4e2:	8082                	ret

00000000000004e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e4:	7139                	addi	sp,sp,-64
 4e6:	fc06                	sd	ra,56(sp)
 4e8:	f822                	sd	s0,48(sp)
 4ea:	f426                	sd	s1,40(sp)
 4ec:	0080                	addi	s0,sp,64
 4ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f0:	c299                	beqz	a3,4f6 <printint+0x12>
 4f2:	0805cb63          	bltz	a1,588 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f6:	2581                	sext.w	a1,a1
  neg = 0;
 4f8:	4881                	li	a7,0
 4fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 500:	2601                	sext.w	a2,a2
 502:	00000517          	auipc	a0,0x0
 506:	4ee50513          	addi	a0,a0,1262 # 9f0 <digits>
 50a:	883a                	mv	a6,a4
 50c:	2705                	addiw	a4,a4,1
 50e:	02c5f7bb          	remuw	a5,a1,a2
 512:	1782                	slli	a5,a5,0x20
 514:	9381                	srli	a5,a5,0x20
 516:	97aa                	add	a5,a5,a0
 518:	0007c783          	lbu	a5,0(a5)
 51c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 520:	0005879b          	sext.w	a5,a1
 524:	02c5d5bb          	divuw	a1,a1,a2
 528:	0685                	addi	a3,a3,1
 52a:	fec7f0e3          	bgeu	a5,a2,50a <printint+0x26>
  if(neg)
 52e:	00088c63          	beqz	a7,546 <printint+0x62>
    buf[i++] = '-';
 532:	fd070793          	addi	a5,a4,-48
 536:	00878733          	add	a4,a5,s0
 53a:	02d00793          	li	a5,45
 53e:	fef70823          	sb	a5,-16(a4)
 542:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 546:	02e05c63          	blez	a4,57e <printint+0x9a>
 54a:	f04a                	sd	s2,32(sp)
 54c:	ec4e                	sd	s3,24(sp)
 54e:	fc040793          	addi	a5,s0,-64
 552:	00e78933          	add	s2,a5,a4
 556:	fff78993          	addi	s3,a5,-1
 55a:	99ba                	add	s3,s3,a4
 55c:	377d                	addiw	a4,a4,-1
 55e:	1702                	slli	a4,a4,0x20
 560:	9301                	srli	a4,a4,0x20
 562:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 566:	fff94583          	lbu	a1,-1(s2)
 56a:	8526                	mv	a0,s1
 56c:	00000097          	auipc	ra,0x0
 570:	f56080e7          	jalr	-170(ra) # 4c2 <putc>
  while(--i >= 0)
 574:	197d                	addi	s2,s2,-1
 576:	ff3918e3          	bne	s2,s3,566 <printint+0x82>
 57a:	7902                	ld	s2,32(sp)
 57c:	69e2                	ld	s3,24(sp)
}
 57e:	70e2                	ld	ra,56(sp)
 580:	7442                	ld	s0,48(sp)
 582:	74a2                	ld	s1,40(sp)
 584:	6121                	addi	sp,sp,64
 586:	8082                	ret
    x = -xx;
 588:	40b005bb          	negw	a1,a1
    neg = 1;
 58c:	4885                	li	a7,1
    x = -xx;
 58e:	b7b5                	j	4fa <printint+0x16>

0000000000000590 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 590:	715d                	addi	sp,sp,-80
 592:	e486                	sd	ra,72(sp)
 594:	e0a2                	sd	s0,64(sp)
 596:	f84a                	sd	s2,48(sp)
 598:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59a:	0005c903          	lbu	s2,0(a1)
 59e:	1a090a63          	beqz	s2,752 <vprintf+0x1c2>
 5a2:	fc26                	sd	s1,56(sp)
 5a4:	f44e                	sd	s3,40(sp)
 5a6:	f052                	sd	s4,32(sp)
 5a8:	ec56                	sd	s5,24(sp)
 5aa:	e85a                	sd	s6,16(sp)
 5ac:	e45e                	sd	s7,8(sp)
 5ae:	8aaa                	mv	s5,a0
 5b0:	8bb2                	mv	s7,a2
 5b2:	00158493          	addi	s1,a1,1
  state = 0;
 5b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b8:	02500a13          	li	s4,37
 5bc:	4b55                	li	s6,21
 5be:	a839                	j	5dc <vprintf+0x4c>
        putc(fd, c);
 5c0:	85ca                	mv	a1,s2
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	efe080e7          	jalr	-258(ra) # 4c2 <putc>
 5cc:	a019                	j	5d2 <vprintf+0x42>
    } else if(state == '%'){
 5ce:	01498d63          	beq	s3,s4,5e8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5d2:	0485                	addi	s1,s1,1
 5d4:	fff4c903          	lbu	s2,-1(s1)
 5d8:	16090763          	beqz	s2,746 <vprintf+0x1b6>
    if(state == 0){
 5dc:	fe0999e3          	bnez	s3,5ce <vprintf+0x3e>
      if(c == '%'){
 5e0:	ff4910e3          	bne	s2,s4,5c0 <vprintf+0x30>
        state = '%';
 5e4:	89d2                	mv	s3,s4
 5e6:	b7f5                	j	5d2 <vprintf+0x42>
      if(c == 'd'){
 5e8:	13490463          	beq	s2,s4,710 <vprintf+0x180>
 5ec:	f9d9079b          	addiw	a5,s2,-99
 5f0:	0ff7f793          	zext.b	a5,a5
 5f4:	12fb6763          	bltu	s6,a5,722 <vprintf+0x192>
 5f8:	f9d9079b          	addiw	a5,s2,-99
 5fc:	0ff7f713          	zext.b	a4,a5
 600:	12eb6163          	bltu	s6,a4,722 <vprintf+0x192>
 604:	00271793          	slli	a5,a4,0x2
 608:	00000717          	auipc	a4,0x0
 60c:	39070713          	addi	a4,a4,912 # 998 <malloc+0x156>
 610:	97ba                	add	a5,a5,a4
 612:	439c                	lw	a5,0(a5)
 614:	97ba                	add	a5,a5,a4
 616:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 618:	008b8913          	addi	s2,s7,8
 61c:	4685                	li	a3,1
 61e:	4629                	li	a2,10
 620:	000ba583          	lw	a1,0(s7)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	ebe080e7          	jalr	-322(ra) # 4e4 <printint>
 62e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 630:	4981                	li	s3,0
 632:	b745                	j	5d2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000ba583          	lw	a1,0(s7)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	ea2080e7          	jalr	-350(ra) # 4e4 <printint>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b751                	j	5d2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e86080e7          	jalr	-378(ra) # 4e4 <printint>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b7a5                	j	5d2 <vprintf+0x42>
 66c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8c13          	addi	s8,s7,8
 672:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 676:	03000593          	li	a1,48
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e46080e7          	jalr	-442(ra) # 4c2 <putc>
  putc(fd, 'x');
 684:	07800593          	li	a1,120
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e38080e7          	jalr	-456(ra) # 4c2 <putc>
 692:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 694:	00000b97          	auipc	s7,0x0
 698:	35cb8b93          	addi	s7,s7,860 # 9f0 <digits>
 69c:	03c9d793          	srli	a5,s3,0x3c
 6a0:	97de                	add	a5,a5,s7
 6a2:	0007c583          	lbu	a1,0(a5)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e1a080e7          	jalr	-486(ra) # 4c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b0:	0992                	slli	s3,s3,0x4
 6b2:	397d                	addiw	s2,s2,-1
 6b4:	fe0914e3          	bnez	s2,69c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6b8:	8be2                	mv	s7,s8
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	6c02                	ld	s8,0(sp)
 6be:	bf11                	j	5d2 <vprintf+0x42>
        s = va_arg(ap, char*);
 6c0:	008b8993          	addi	s3,s7,8
 6c4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6c8:	02090163          	beqz	s2,6ea <vprintf+0x15a>
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	c9a5                	beqz	a1,740 <vprintf+0x1b0>
          putc(fd, *s);
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dee080e7          	jalr	-530(ra) # 4c2 <putc>
          s++;
 6dc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	f9e5                	bnez	a1,6d2 <vprintf+0x142>
        s = va_arg(ap, char*);
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b5ed                	j	5d2 <vprintf+0x42>
          s = "(null)";
 6ea:	00000917          	auipc	s2,0x0
 6ee:	2a690913          	addi	s2,s2,678 # 990 <malloc+0x14e>
        while(*s != 0){
 6f2:	02800593          	li	a1,40
 6f6:	bff1                	j	6d2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	000bc583          	lbu	a1,0(s7)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	dc0080e7          	jalr	-576(ra) # 4c2 <putc>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b5d1                	j	5d2 <vprintf+0x42>
        putc(fd, c);
 710:	02500593          	li	a1,37
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	dac080e7          	jalr	-596(ra) # 4c2 <putc>
      state = 0;
 71e:	4981                	li	s3,0
 720:	bd4d                	j	5d2 <vprintf+0x42>
        putc(fd, '%');
 722:	02500593          	li	a1,37
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	d9a080e7          	jalr	-614(ra) # 4c2 <putc>
        putc(fd, c);
 730:	85ca                	mv	a1,s2
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	d8e080e7          	jalr	-626(ra) # 4c2 <putc>
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bd51                	j	5d2 <vprintf+0x42>
        s = va_arg(ap, char*);
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	b579                	j	5d2 <vprintf+0x42>
 746:	74e2                	ld	s1,56(sp)
 748:	79a2                	ld	s3,40(sp)
 74a:	7a02                	ld	s4,32(sp)
 74c:	6ae2                	ld	s5,24(sp)
 74e:	6b42                	ld	s6,16(sp)
 750:	6ba2                	ld	s7,8(sp)
    }
  }
}
 752:	60a6                	ld	ra,72(sp)
 754:	6406                	ld	s0,64(sp)
 756:	7942                	ld	s2,48(sp)
 758:	6161                	addi	sp,sp,80
 75a:	8082                	ret

000000000000075c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75c:	715d                	addi	sp,sp,-80
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e010                	sd	a2,0(s0)
 766:	e414                	sd	a3,8(s0)
 768:	e818                	sd	a4,16(s0)
 76a:	ec1c                	sd	a5,24(s0)
 76c:	03043023          	sd	a6,32(s0)
 770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	8622                	mv	a2,s0
 77a:	00000097          	auipc	ra,0x0
 77e:	e16080e7          	jalr	-490(ra) # 590 <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6161                	addi	sp,sp,80
 788:	8082                	ret

000000000000078a <printf>:

void
printf(const char *fmt, ...)
{
 78a:	711d                	addi	sp,sp,-96
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e40c                	sd	a1,8(s0)
 794:	e810                	sd	a2,16(s0)
 796:	ec14                	sd	a3,24(s0)
 798:	f018                	sd	a4,32(s0)
 79a:	f41c                	sd	a5,40(s0)
 79c:	03043823          	sd	a6,48(s0)
 7a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	00840613          	addi	a2,s0,8
 7a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ac:	85aa                	mv	a1,a0
 7ae:	4505                	li	a0,1
 7b0:	00000097          	auipc	ra,0x0
 7b4:	de0080e7          	jalr	-544(ra) # 590 <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	1141                	addi	sp,sp,-16
 7c2:	e422                	sd	s0,8(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00000797          	auipc	a5,0x0
 7ce:	67e7b783          	ld	a5,1662(a5) # e48 <freep>
 7d2:	a02d                	j	7fc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9f2d                	addw	a4,a4,a1
 7d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	6310                	ld	a2,0(a4)
 7e0:	a83d                	j	81e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9f31                	addw	a4,a4,a2
 7e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ea:	ff053683          	ld	a3,-16(a0)
 7ee:	a091                	j	832 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e7e463          	bltu	a5,a4,7fa <free+0x3a>
 7f6:	00e6ea63          	bltu	a3,a4,80a <free+0x4a>
{
 7fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	fed7fae3          	bgeu	a5,a3,7f0 <free+0x30>
 800:	6398                	ld	a4,0(a5)
 802:	00e6e463          	bltu	a3,a4,80a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	fee7eae3          	bltu	a5,a4,7fa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 80a:	ff852583          	lw	a1,-8(a0)
 80e:	6390                	ld	a2,0(a5)
 810:	02059813          	slli	a6,a1,0x20
 814:	01c85713          	srli	a4,a6,0x1c
 818:	9736                	add	a4,a4,a3
 81a:	fae60de3          	beq	a2,a4,7d4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 822:	4790                	lw	a2,8(a5)
 824:	02061593          	slli	a1,a2,0x20
 828:	01c5d713          	srli	a4,a1,0x1c
 82c:	973e                	add	a4,a4,a5
 82e:	fae68ae3          	beq	a3,a4,7e2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 832:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 834:	00000717          	auipc	a4,0x0
 838:	60f73a23          	sd	a5,1556(a4) # e48 <freep>
}
 83c:	6422                	ld	s0,8(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret

0000000000000842 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	7139                	addi	sp,sp,-64
 844:	fc06                	sd	ra,56(sp)
 846:	f822                	sd	s0,48(sp)
 848:	f426                	sd	s1,40(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	02051493          	slli	s1,a0,0x20
 852:	9081                	srli	s1,s1,0x20
 854:	04bd                	addi	s1,s1,15
 856:	8091                	srli	s1,s1,0x4
 858:	0014899b          	addiw	s3,s1,1
 85c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 85e:	00000517          	auipc	a0,0x0
 862:	5ea53503          	ld	a0,1514(a0) # e48 <freep>
 866:	c915                	beqz	a0,89a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	08977e63          	bgeu	a4,s1,908 <malloc+0xc6>
 870:	f04a                	sd	s2,32(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 878:	8a4e                	mv	s4,s3
 87a:	0009871b          	sext.w	a4,s3
 87e:	6685                	lui	a3,0x1
 880:	00d77363          	bgeu	a4,a3,886 <malloc+0x44>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88e:	00000917          	auipc	s2,0x0
 892:	5ba90913          	addi	s2,s2,1466 # e48 <freep>
  if(p == (char*)-1)
 896:	5afd                	li	s5,-1
 898:	a091                	j	8dc <malloc+0x9a>
 89a:	f04a                	sd	s2,32(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	7ae78793          	addi	a5,a5,1966 # 1050 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	58f73f23          	sd	a5,1438(a4) # e48 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b8:	b7c1                	j	878 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a08d                	j	920 <malloc+0xde>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	00000097          	auipc	ra,0x0
 8ca:	efa080e7          	jalr	-262(ra) # 7c0 <free>
  return freep;
 8ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d2:	c13d                	beqz	a0,938 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	02977463          	bgeu	a4,s1,900 <malloc+0xbe>
    if(p == freep)
 8dc:	00093703          	ld	a4,0(s2)
 8e0:	853e                	mv	a0,a5
 8e2:	fef719e3          	bne	a4,a5,8d4 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8e6:	8552                	mv	a0,s4
 8e8:	00000097          	auipc	ra,0x0
 8ec:	bb2080e7          	jalr	-1102(ra) # 49a <sbrk>
  if(p == (char*)-1)
 8f0:	fd5518e3          	bne	a0,s5,8c0 <malloc+0x7e>
        return 0;
 8f4:	4501                	li	a0,0
 8f6:	7902                	ld	s2,32(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	a03d                	j	92c <malloc+0xea>
 900:	7902                	ld	s2,32(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 908:	fae489e3          	beq	s1,a4,8ba <malloc+0x78>
        p->s.size -= nunits;
 90c:	4137073b          	subw	a4,a4,s3
 910:	c798                	sw	a4,8(a5)
        p += p->s.size;
 912:	02071693          	slli	a3,a4,0x20
 916:	01c6d713          	srli	a4,a3,0x1c
 91a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 920:	00000717          	auipc	a4,0x0
 924:	52a73423          	sd	a0,1320(a4) # e48 <freep>
      return (void*)(p + 1);
 928:	01078513          	addi	a0,a5,16
  }
}
 92c:	70e2                	ld	ra,56(sp)
 92e:	7442                	ld	s0,48(sp)
 930:	74a2                	ld	s1,40(sp)
 932:	69e2                	ld	s3,24(sp)
 934:	6121                	addi	sp,sp,64
 936:	8082                	ret
 938:	7902                	ld	s2,32(sp)
 93a:	6a42                	ld	s4,16(sp)
 93c:	6aa2                	ld	s5,8(sp)
 93e:	6b02                	ld	s6,0(sp)
 940:	b7f5                	j	92c <malloc+0xea>
