
user/_grep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	addi	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	e9ca8a93          	addi	s5,s5,-356 # fd8 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	1f0080e7          	jalr	496(ra) # 33e <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	addi	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3ce080e7          	jalr	974(ra) # 54c <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3ae080e7          	jalr	942(ra) # 544 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	e2250513          	addi	a0,a0,-478 # fd8 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	29a080e7          	jalr	666(ra) # 464 <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	addi	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	addi	s2,a1,16
 210:	ffd5099b          	addiw	s3,a0,-3
 214:	02099793          	slli	a5,s3,0x20
 218:	01d7d993          	srli	s3,a5,0x1d
 21c:	05e1                	addi	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	346080e7          	jalr	838(ra) # 56c <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	312080e7          	jalr	786(ra) # 554 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2da080e7          	jalr	730(ra) # 52c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	80658593          	addi	a1,a1,-2042 # a60 <malloc+0x104>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	612080e7          	jalr	1554(ra) # 876 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2be080e7          	jalr	702(ra) # 52c <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2a8080e7          	jalr	680(ra) # 52c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00000517          	auipc	a0,0x0
 294:	7f050513          	addi	a0,a0,2032 # a80 <malloc+0x124>
 298:	00000097          	auipc	ra,0x0
 29c:	60c080e7          	jalr	1548(ra) # 8a4 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	28a080e7          	jalr	650(ra) # 52c <exit>

00000000000002aa <strcpy>:



char*
strcpy(char *s, const char *t)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b0:	87aa                	mv	a5,a0
 2b2:	0585                	addi	a1,a1,1
 2b4:	0785                	addi	a5,a5,1
 2b6:	fff5c703          	lbu	a4,-1(a1)
 2ba:	fee78fa3          	sb	a4,-1(a5)
 2be:	fb75                	bnez	a4,2b2 <strcpy+0x8>
    ;
  return os;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cb91                	beqz	a5,2e4 <strcmp+0x1e>
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00f71763          	bne	a4,a5,2e4 <strcmp+0x1e>
    p++, q++;
 2da:	0505                	addi	a0,a0,1
 2dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	fbe5                	bnez	a5,2d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e4:	0005c503          	lbu	a0,0(a1)
}
 2e8:	40a7853b          	subw	a0,a5,a0
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strlen>:

uint
strlen(const char *s)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	cf91                	beqz	a5,318 <strlen+0x26>
 2fe:	0505                	addi	a0,a0,1
 300:	87aa                	mv	a5,a0
 302:	86be                	mv	a3,a5
 304:	0785                	addi	a5,a5,1
 306:	fff7c703          	lbu	a4,-1(a5)
 30a:	ff65                	bnez	a4,302 <strlen+0x10>
 30c:	40a6853b          	subw	a0,a3,a0
 310:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  for(n = 0; s[n]; n++)
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <strlen+0x20>

000000000000031c <memset>:

void*
memset(void *dst, int c, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 322:	ca19                	beqz	a2,338 <memset+0x1c>
 324:	87aa                	mv	a5,a0
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 332:	0785                	addi	a5,a5,1
 334:	fee79de3          	bne	a5,a4,32e <memset+0x12>
  }
  return dst;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  for(; *s; s++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cb99                	beqz	a5,35e <strchr+0x20>
    if(*s == c)
 34a:	00f58763          	beq	a1,a5,358 <strchr+0x1a>
  for(; *s; s++)
 34e:	0505                	addi	a0,a0,1
 350:	00054783          	lbu	a5,0(a0)
 354:	fbfd                	bnez	a5,34a <strchr+0xc>
      return (char*)s;
  return 0;
 356:	4501                	li	a0,0
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  return 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <strchr+0x1a>

0000000000000362 <gets>:

char*
gets(char *buf, int max)
{
 362:	711d                	addi	sp,sp,-96
 364:	ec86                	sd	ra,88(sp)
 366:	e8a2                	sd	s0,80(sp)
 368:	e4a6                	sd	s1,72(sp)
 36a:	e0ca                	sd	s2,64(sp)
 36c:	fc4e                	sd	s3,56(sp)
 36e:	f852                	sd	s4,48(sp)
 370:	f456                	sd	s5,40(sp)
 372:	f05a                	sd	s6,32(sp)
 374:	ec5e                	sd	s7,24(sp)
 376:	1080                	addi	s0,sp,96
 378:	8baa                	mv	s7,a0
 37a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37c:	892a                	mv	s2,a0
 37e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 380:	4aa9                	li	s5,10
 382:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 384:	89a6                	mv	s3,s1
 386:	2485                	addiw	s1,s1,1
 388:	0344d863          	bge	s1,s4,3b8 <gets+0x56>
    cc = read(0, &c, 1);
 38c:	4605                	li	a2,1
 38e:	faf40593          	addi	a1,s0,-81
 392:	4501                	li	a0,0
 394:	00000097          	auipc	ra,0x0
 398:	1b0080e7          	jalr	432(ra) # 544 <read>
    if(cc < 1)
 39c:	00a05e63          	blez	a0,3b8 <gets+0x56>
    buf[i++] = c;
 3a0:	faf44783          	lbu	a5,-81(s0)
 3a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a8:	01578763          	beq	a5,s5,3b6 <gets+0x54>
 3ac:	0905                	addi	s2,s2,1
 3ae:	fd679be3          	bne	a5,s6,384 <gets+0x22>
    buf[i++] = c;
 3b2:	89a6                	mv	s3,s1
 3b4:	a011                	j	3b8 <gets+0x56>
 3b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b8:	99de                	add	s3,s3,s7
 3ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 3be:	855e                	mv	a0,s7
 3c0:	60e6                	ld	ra,88(sp)
 3c2:	6446                	ld	s0,80(sp)
 3c4:	64a6                	ld	s1,72(sp)
 3c6:	6906                	ld	s2,64(sp)
 3c8:	79e2                	ld	s3,56(sp)
 3ca:	7a42                	ld	s4,48(sp)
 3cc:	7aa2                	ld	s5,40(sp)
 3ce:	7b02                	ld	s6,32(sp)
 3d0:	6be2                	ld	s7,24(sp)
 3d2:	6125                	addi	sp,sp,96
 3d4:	8082                	ret

00000000000003d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	e04a                	sd	s2,0(sp)
 3de:	1000                	addi	s0,sp,32
 3e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e2:	4581                	li	a1,0
 3e4:	00000097          	auipc	ra,0x0
 3e8:	188080e7          	jalr	392(ra) # 56c <open>
  if(fd < 0)
 3ec:	02054663          	bltz	a0,418 <stat+0x42>
 3f0:	e426                	sd	s1,8(sp)
 3f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f4:	85ca                	mv	a1,s2
 3f6:	00000097          	auipc	ra,0x0
 3fa:	18e080e7          	jalr	398(ra) # 584 <fstat>
 3fe:	892a                	mv	s2,a0
  close(fd);
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	152080e7          	jalr	338(ra) # 554 <close>
  return r;
 40a:	64a2                	ld	s1,8(sp)
}
 40c:	854a                	mv	a0,s2
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	6902                	ld	s2,0(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret
    return -1;
 418:	597d                	li	s2,-1
 41a:	bfcd                	j	40c <stat+0x36>

000000000000041c <atoi>:

int
atoi(const char *s)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 422:	00054683          	lbu	a3,0(a0)
 426:	fd06879b          	addiw	a5,a3,-48
 42a:	0ff7f793          	zext.b	a5,a5
 42e:	4625                	li	a2,9
 430:	02f66863          	bltu	a2,a5,460 <atoi+0x44>
 434:	872a                	mv	a4,a0
  n = 0;
 436:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 438:	0705                	addi	a4,a4,1
 43a:	0025179b          	slliw	a5,a0,0x2
 43e:	9fa9                	addw	a5,a5,a0
 440:	0017979b          	slliw	a5,a5,0x1
 444:	9fb5                	addw	a5,a5,a3
 446:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44a:	00074683          	lbu	a3,0(a4)
 44e:	fd06879b          	addiw	a5,a3,-48
 452:	0ff7f793          	zext.b	a5,a5
 456:	fef671e3          	bgeu	a2,a5,438 <atoi+0x1c>
  return n;
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
  n = 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <atoi+0x3e>

0000000000000464 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 46a:	02b57463          	bgeu	a0,a1,492 <memmove+0x2e>
    while(n-- > 0)
 46e:	00c05f63          	blez	a2,48c <memmove+0x28>
 472:	1602                	slli	a2,a2,0x20
 474:	9201                	srli	a2,a2,0x20
 476:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 47a:	872a                	mv	a4,a0
      *dst++ = *src++;
 47c:	0585                	addi	a1,a1,1
 47e:	0705                	addi	a4,a4,1
 480:	fff5c683          	lbu	a3,-1(a1)
 484:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 488:	fef71ae3          	bne	a4,a5,47c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48c:	6422                	ld	s0,8(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret
    dst += n;
 492:	00c50733          	add	a4,a0,a2
    src += n;
 496:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 498:	fec05ae3          	blez	a2,48c <memmove+0x28>
 49c:	fff6079b          	addiw	a5,a2,-1
 4a0:	1782                	slli	a5,a5,0x20
 4a2:	9381                	srli	a5,a5,0x20
 4a4:	fff7c793          	not	a5,a5
 4a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4aa:	15fd                	addi	a1,a1,-1
 4ac:	177d                	addi	a4,a4,-1
 4ae:	0005c683          	lbu	a3,0(a1)
 4b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b6:	fee79ae3          	bne	a5,a4,4aa <memmove+0x46>
 4ba:	bfc9                	j	48c <memmove+0x28>

00000000000004bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4bc:	1141                	addi	sp,sp,-16
 4be:	e422                	sd	s0,8(sp)
 4c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c2:	ca05                	beqz	a2,4f2 <memcmp+0x36>
 4c4:	fff6069b          	addiw	a3,a2,-1
 4c8:	1682                	slli	a3,a3,0x20
 4ca:	9281                	srli	a3,a3,0x20
 4cc:	0685                	addi	a3,a3,1
 4ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4d0:	00054783          	lbu	a5,0(a0)
 4d4:	0005c703          	lbu	a4,0(a1)
 4d8:	00e79863          	bne	a5,a4,4e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4dc:	0505                	addi	a0,a0,1
    p2++;
 4de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e0:	fed518e3          	bne	a0,a3,4d0 <memcmp+0x14>
  }
  return 0;
 4e4:	4501                	li	a0,0
 4e6:	a019                	j	4ec <memcmp+0x30>
      return *p1 - *p2;
 4e8:	40e7853b          	subw	a0,a5,a4
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
  return 0;
 4f2:	4501                	li	a0,0
 4f4:	bfe5                	j	4ec <memcmp+0x30>

00000000000004f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e406                	sd	ra,8(sp)
 4fa:	e022                	sd	s0,0(sp)
 4fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4fe:	00000097          	auipc	ra,0x0
 502:	f66080e7          	jalr	-154(ra) # 464 <memmove>
}
 506:	60a2                	ld	ra,8(sp)
 508:	6402                	ld	s0,0(sp)
 50a:	0141                	addi	sp,sp,16
 50c:	8082                	ret

000000000000050e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e422                	sd	s0,8(sp)
 512:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 514:	040007b7          	lui	a5,0x4000
 518:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffe831>
 51a:	07b2                	slli	a5,a5,0xc
}
 51c:	4388                	lw	a0,0(a5)
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret

0000000000000524 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 524:	4885                	li	a7,1
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <exit>:
.global exit
exit:
 li a7, SYS_exit
 52c:	4889                	li	a7,2
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <wait>:
.global wait
wait:
 li a7, SYS_wait
 534:	488d                	li	a7,3
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 53c:	4891                	li	a7,4
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <read>:
.global read
read:
 li a7, SYS_read
 544:	4895                	li	a7,5
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <write>:
.global write
write:
 li a7, SYS_write
 54c:	48c1                	li	a7,16
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <close>:
.global close
close:
 li a7, SYS_close
 554:	48d5                	li	a7,21
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <kill>:
.global kill
kill:
 li a7, SYS_kill
 55c:	4899                	li	a7,6
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <exec>:
.global exec
exec:
 li a7, SYS_exec
 564:	489d                	li	a7,7
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <open>:
.global open
open:
 li a7, SYS_open
 56c:	48bd                	li	a7,15
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 574:	48c5                	li	a7,17
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 57c:	48c9                	li	a7,18
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 584:	48a1                	li	a7,8
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <link>:
.global link
link:
 li a7, SYS_link
 58c:	48cd                	li	a7,19
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 594:	48d1                	li	a7,20
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 59c:	48a5                	li	a7,9
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a4:	48a9                	li	a7,10
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ac:	48ad                	li	a7,11
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b4:	48b1                	li	a7,12
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5bc:	48b5                	li	a7,13
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c4:	48b9                	li	a7,14
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <connect>:
.global connect
connect:
 li a7, SYS_connect
 5cc:	48f5                	li	a7,29
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 5d4:	48f9                	li	a7,30
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5dc:	1101                	addi	sp,sp,-32
 5de:	ec06                	sd	ra,24(sp)
 5e0:	e822                	sd	s0,16(sp)
 5e2:	1000                	addi	s0,sp,32
 5e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e8:	4605                	li	a2,1
 5ea:	fef40593          	addi	a1,s0,-17
 5ee:	00000097          	auipc	ra,0x0
 5f2:	f5e080e7          	jalr	-162(ra) # 54c <write>
}
 5f6:	60e2                	ld	ra,24(sp)
 5f8:	6442                	ld	s0,16(sp)
 5fa:	6105                	addi	sp,sp,32
 5fc:	8082                	ret

00000000000005fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5fe:	7139                	addi	sp,sp,-64
 600:	fc06                	sd	ra,56(sp)
 602:	f822                	sd	s0,48(sp)
 604:	f426                	sd	s1,40(sp)
 606:	0080                	addi	s0,sp,64
 608:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60a:	c299                	beqz	a3,610 <printint+0x12>
 60c:	0805cb63          	bltz	a1,6a2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 610:	2581                	sext.w	a1,a1
  neg = 0;
 612:	4881                	li	a7,0
 614:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 618:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 61a:	2601                	sext.w	a2,a2
 61c:	00000517          	auipc	a0,0x0
 620:	4dc50513          	addi	a0,a0,1244 # af8 <digits>
 624:	883a                	mv	a6,a4
 626:	2705                	addiw	a4,a4,1
 628:	02c5f7bb          	remuw	a5,a1,a2
 62c:	1782                	slli	a5,a5,0x20
 62e:	9381                	srli	a5,a5,0x20
 630:	97aa                	add	a5,a5,a0
 632:	0007c783          	lbu	a5,0(a5)
 636:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 63a:	0005879b          	sext.w	a5,a1
 63e:	02c5d5bb          	divuw	a1,a1,a2
 642:	0685                	addi	a3,a3,1
 644:	fec7f0e3          	bgeu	a5,a2,624 <printint+0x26>
  if(neg)
 648:	00088c63          	beqz	a7,660 <printint+0x62>
    buf[i++] = '-';
 64c:	fd070793          	addi	a5,a4,-48
 650:	00878733          	add	a4,a5,s0
 654:	02d00793          	li	a5,45
 658:	fef70823          	sb	a5,-16(a4)
 65c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 660:	02e05c63          	blez	a4,698 <printint+0x9a>
 664:	f04a                	sd	s2,32(sp)
 666:	ec4e                	sd	s3,24(sp)
 668:	fc040793          	addi	a5,s0,-64
 66c:	00e78933          	add	s2,a5,a4
 670:	fff78993          	addi	s3,a5,-1
 674:	99ba                	add	s3,s3,a4
 676:	377d                	addiw	a4,a4,-1
 678:	1702                	slli	a4,a4,0x20
 67a:	9301                	srli	a4,a4,0x20
 67c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 680:	fff94583          	lbu	a1,-1(s2)
 684:	8526                	mv	a0,s1
 686:	00000097          	auipc	ra,0x0
 68a:	f56080e7          	jalr	-170(ra) # 5dc <putc>
  while(--i >= 0)
 68e:	197d                	addi	s2,s2,-1
 690:	ff3918e3          	bne	s2,s3,680 <printint+0x82>
 694:	7902                	ld	s2,32(sp)
 696:	69e2                	ld	s3,24(sp)
}
 698:	70e2                	ld	ra,56(sp)
 69a:	7442                	ld	s0,48(sp)
 69c:	74a2                	ld	s1,40(sp)
 69e:	6121                	addi	sp,sp,64
 6a0:	8082                	ret
    x = -xx;
 6a2:	40b005bb          	negw	a1,a1
    neg = 1;
 6a6:	4885                	li	a7,1
    x = -xx;
 6a8:	b7b5                	j	614 <printint+0x16>

00000000000006aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6aa:	715d                	addi	sp,sp,-80
 6ac:	e486                	sd	ra,72(sp)
 6ae:	e0a2                	sd	s0,64(sp)
 6b0:	f84a                	sd	s2,48(sp)
 6b2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b4:	0005c903          	lbu	s2,0(a1)
 6b8:	1a090a63          	beqz	s2,86c <vprintf+0x1c2>
 6bc:	fc26                	sd	s1,56(sp)
 6be:	f44e                	sd	s3,40(sp)
 6c0:	f052                	sd	s4,32(sp)
 6c2:	ec56                	sd	s5,24(sp)
 6c4:	e85a                	sd	s6,16(sp)
 6c6:	e45e                	sd	s7,8(sp)
 6c8:	8aaa                	mv	s5,a0
 6ca:	8bb2                	mv	s7,a2
 6cc:	00158493          	addi	s1,a1,1
  state = 0;
 6d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6d2:	02500a13          	li	s4,37
 6d6:	4b55                	li	s6,21
 6d8:	a839                	j	6f6 <vprintf+0x4c>
        putc(fd, c);
 6da:	85ca                	mv	a1,s2
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	efe080e7          	jalr	-258(ra) # 5dc <putc>
 6e6:	a019                	j	6ec <vprintf+0x42>
    } else if(state == '%'){
 6e8:	01498d63          	beq	s3,s4,702 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6ec:	0485                	addi	s1,s1,1
 6ee:	fff4c903          	lbu	s2,-1(s1)
 6f2:	16090763          	beqz	s2,860 <vprintf+0x1b6>
    if(state == 0){
 6f6:	fe0999e3          	bnez	s3,6e8 <vprintf+0x3e>
      if(c == '%'){
 6fa:	ff4910e3          	bne	s2,s4,6da <vprintf+0x30>
        state = '%';
 6fe:	89d2                	mv	s3,s4
 700:	b7f5                	j	6ec <vprintf+0x42>
      if(c == 'd'){
 702:	13490463          	beq	s2,s4,82a <vprintf+0x180>
 706:	f9d9079b          	addiw	a5,s2,-99
 70a:	0ff7f793          	zext.b	a5,a5
 70e:	12fb6763          	bltu	s6,a5,83c <vprintf+0x192>
 712:	f9d9079b          	addiw	a5,s2,-99
 716:	0ff7f713          	zext.b	a4,a5
 71a:	12eb6163          	bltu	s6,a4,83c <vprintf+0x192>
 71e:	00271793          	slli	a5,a4,0x2
 722:	00000717          	auipc	a4,0x0
 726:	37e70713          	addi	a4,a4,894 # aa0 <malloc+0x144>
 72a:	97ba                	add	a5,a5,a4
 72c:	439c                	lw	a5,0(a5)
 72e:	97ba                	add	a5,a5,a4
 730:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 732:	008b8913          	addi	s2,s7,8
 736:	4685                	li	a3,1
 738:	4629                	li	a2,10
 73a:	000ba583          	lw	a1,0(s7)
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	ebe080e7          	jalr	-322(ra) # 5fe <printint>
 748:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b745                	j	6ec <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4629                	li	a2,10
 756:	000ba583          	lw	a1,0(s7)
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ea2080e7          	jalr	-350(ra) # 5fe <printint>
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
 768:	b751                	j	6ec <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000ba583          	lw	a1,0(s7)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e86080e7          	jalr	-378(ra) # 5fe <printint>
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	b7a5                	j	6ec <vprintf+0x42>
 786:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 788:	008b8c13          	addi	s8,s7,8
 78c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 790:	03000593          	li	a1,48
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e46080e7          	jalr	-442(ra) # 5dc <putc>
  putc(fd, 'x');
 79e:	07800593          	li	a1,120
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e38080e7          	jalr	-456(ra) # 5dc <putc>
 7ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ae:	00000b97          	auipc	s7,0x0
 7b2:	34ab8b93          	addi	s7,s7,842 # af8 <digits>
 7b6:	03c9d793          	srli	a5,s3,0x3c
 7ba:	97de                	add	a5,a5,s7
 7bc:	0007c583          	lbu	a1,0(a5)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e1a080e7          	jalr	-486(ra) # 5dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ca:	0992                	slli	s3,s3,0x4
 7cc:	397d                	addiw	s2,s2,-1
 7ce:	fe0914e3          	bnez	s2,7b6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7d2:	8be2                	mv	s7,s8
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	6c02                	ld	s8,0(sp)
 7d8:	bf11                	j	6ec <vprintf+0x42>
        s = va_arg(ap, char*);
 7da:	008b8993          	addi	s3,s7,8
 7de:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7e2:	02090163          	beqz	s2,804 <vprintf+0x15a>
        while(*s != 0){
 7e6:	00094583          	lbu	a1,0(s2)
 7ea:	c9a5                	beqz	a1,85a <vprintf+0x1b0>
          putc(fd, *s);
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	dee080e7          	jalr	-530(ra) # 5dc <putc>
          s++;
 7f6:	0905                	addi	s2,s2,1
        while(*s != 0){
 7f8:	00094583          	lbu	a1,0(s2)
 7fc:	f9e5                	bnez	a1,7ec <vprintf+0x142>
        s = va_arg(ap, char*);
 7fe:	8bce                	mv	s7,s3
      state = 0;
 800:	4981                	li	s3,0
 802:	b5ed                	j	6ec <vprintf+0x42>
          s = "(null)";
 804:	00000917          	auipc	s2,0x0
 808:	29490913          	addi	s2,s2,660 # a98 <malloc+0x13c>
        while(*s != 0){
 80c:	02800593          	li	a1,40
 810:	bff1                	j	7ec <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 812:	008b8913          	addi	s2,s7,8
 816:	000bc583          	lbu	a1,0(s7)
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	dc0080e7          	jalr	-576(ra) # 5dc <putc>
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
 828:	b5d1                	j	6ec <vprintf+0x42>
        putc(fd, c);
 82a:	02500593          	li	a1,37
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	dac080e7          	jalr	-596(ra) # 5dc <putc>
      state = 0;
 838:	4981                	li	s3,0
 83a:	bd4d                	j	6ec <vprintf+0x42>
        putc(fd, '%');
 83c:	02500593          	li	a1,37
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	d9a080e7          	jalr	-614(ra) # 5dc <putc>
        putc(fd, c);
 84a:	85ca                	mv	a1,s2
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	d8e080e7          	jalr	-626(ra) # 5dc <putc>
      state = 0;
 856:	4981                	li	s3,0
 858:	bd51                	j	6ec <vprintf+0x42>
        s = va_arg(ap, char*);
 85a:	8bce                	mv	s7,s3
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b579                	j	6ec <vprintf+0x42>
 860:	74e2                	ld	s1,56(sp)
 862:	79a2                	ld	s3,40(sp)
 864:	7a02                	ld	s4,32(sp)
 866:	6ae2                	ld	s5,24(sp)
 868:	6b42                	ld	s6,16(sp)
 86a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 86c:	60a6                	ld	ra,72(sp)
 86e:	6406                	ld	s0,64(sp)
 870:	7942                	ld	s2,48(sp)
 872:	6161                	addi	sp,sp,80
 874:	8082                	ret

0000000000000876 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 876:	715d                	addi	sp,sp,-80
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e010                	sd	a2,0(s0)
 880:	e414                	sd	a3,8(s0)
 882:	e818                	sd	a4,16(s0)
 884:	ec1c                	sd	a5,24(s0)
 886:	03043023          	sd	a6,32(s0)
 88a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 892:	8622                	mv	a2,s0
 894:	00000097          	auipc	ra,0x0
 898:	e16080e7          	jalr	-490(ra) # 6aa <vprintf>
}
 89c:	60e2                	ld	ra,24(sp)
 89e:	6442                	ld	s0,16(sp)
 8a0:	6161                	addi	sp,sp,80
 8a2:	8082                	ret

00000000000008a4 <printf>:

void
printf(const char *fmt, ...)
{
 8a4:	711d                	addi	sp,sp,-96
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e40c                	sd	a1,8(s0)
 8ae:	e810                	sd	a2,16(s0)
 8b0:	ec14                	sd	a3,24(s0)
 8b2:	f018                	sd	a4,32(s0)
 8b4:	f41c                	sd	a5,40(s0)
 8b6:	03043823          	sd	a6,48(s0)
 8ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	00840613          	addi	a2,s0,8
 8c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c6:	85aa                	mv	a1,a0
 8c8:	4505                	li	a0,1
 8ca:	00000097          	auipc	ra,0x0
 8ce:	de0080e7          	jalr	-544(ra) # 6aa <vprintf>
}
 8d2:	60e2                	ld	ra,24(sp)
 8d4:	6442                	ld	s0,16(sp)
 8d6:	6125                	addi	sp,sp,96
 8d8:	8082                	ret

00000000000008da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8da:	1141                	addi	sp,sp,-16
 8dc:	e422                	sd	s0,8(sp)
 8de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e4:	00000797          	auipc	a5,0x0
 8e8:	6ec7b783          	ld	a5,1772(a5) # fd0 <freep>
 8ec:	a02d                	j	916 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ee:	4618                	lw	a4,8(a2)
 8f0:	9f2d                	addw	a4,a4,a1
 8f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	6398                	ld	a4,0(a5)
 8f8:	6310                	ld	a2,0(a4)
 8fa:	a83d                	j	938 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8fc:	ff852703          	lw	a4,-8(a0)
 900:	9f31                	addw	a4,a4,a2
 902:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 904:	ff053683          	ld	a3,-16(a0)
 908:	a091                	j	94c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90a:	6398                	ld	a4,0(a5)
 90c:	00e7e463          	bltu	a5,a4,914 <free+0x3a>
 910:	00e6ea63          	bltu	a3,a4,924 <free+0x4a>
{
 914:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	fed7fae3          	bgeu	a5,a3,90a <free+0x30>
 91a:	6398                	ld	a4,0(a5)
 91c:	00e6e463          	bltu	a3,a4,924 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	fee7eae3          	bltu	a5,a4,914 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 924:	ff852583          	lw	a1,-8(a0)
 928:	6390                	ld	a2,0(a5)
 92a:	02059813          	slli	a6,a1,0x20
 92e:	01c85713          	srli	a4,a6,0x1c
 932:	9736                	add	a4,a4,a3
 934:	fae60de3          	beq	a2,a4,8ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 93c:	4790                	lw	a2,8(a5)
 93e:	02061593          	slli	a1,a2,0x20
 942:	01c5d713          	srli	a4,a1,0x1c
 946:	973e                	add	a4,a4,a5
 948:	fae68ae3          	beq	a3,a4,8fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 94c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 94e:	00000717          	auipc	a4,0x0
 952:	68f73123          	sd	a5,1666(a4) # fd0 <freep>
}
 956:	6422                	ld	s0,8(sp)
 958:	0141                	addi	sp,sp,16
 95a:	8082                	ret

000000000000095c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 95c:	7139                	addi	sp,sp,-64
 95e:	fc06                	sd	ra,56(sp)
 960:	f822                	sd	s0,48(sp)
 962:	f426                	sd	s1,40(sp)
 964:	ec4e                	sd	s3,24(sp)
 966:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 968:	02051493          	slli	s1,a0,0x20
 96c:	9081                	srli	s1,s1,0x20
 96e:	04bd                	addi	s1,s1,15
 970:	8091                	srli	s1,s1,0x4
 972:	0014899b          	addiw	s3,s1,1
 976:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 978:	00000517          	auipc	a0,0x0
 97c:	65853503          	ld	a0,1624(a0) # fd0 <freep>
 980:	c915                	beqz	a0,9b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 984:	4798                	lw	a4,8(a5)
 986:	08977e63          	bgeu	a4,s1,a22 <malloc+0xc6>
 98a:	f04a                	sd	s2,32(sp)
 98c:	e852                	sd	s4,16(sp)
 98e:	e456                	sd	s5,8(sp)
 990:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 992:	8a4e                	mv	s4,s3
 994:	0009871b          	sext.w	a4,s3
 998:	6685                	lui	a3,0x1
 99a:	00d77363          	bgeu	a4,a3,9a0 <malloc+0x44>
 99e:	6a05                	lui	s4,0x1
 9a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a8:	00000917          	auipc	s2,0x0
 9ac:	62890913          	addi	s2,s2,1576 # fd0 <freep>
  if(p == (char*)-1)
 9b0:	5afd                	li	s5,-1
 9b2:	a091                	j	9f6 <malloc+0x9a>
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	e852                	sd	s4,16(sp)
 9b8:	e456                	sd	s5,8(sp)
 9ba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9bc:	00001797          	auipc	a5,0x1
 9c0:	a1c78793          	addi	a5,a5,-1508 # 13d8 <base>
 9c4:	00000717          	auipc	a4,0x0
 9c8:	60f73623          	sd	a5,1548(a4) # fd0 <freep>
 9cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d2:	b7c1                	j	992 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9d4:	6398                	ld	a4,0(a5)
 9d6:	e118                	sd	a4,0(a0)
 9d8:	a08d                	j	a3a <malloc+0xde>
  hp->s.size = nu;
 9da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9de:	0541                	addi	a0,a0,16
 9e0:	00000097          	auipc	ra,0x0
 9e4:	efa080e7          	jalr	-262(ra) # 8da <free>
  return freep;
 9e8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ec:	c13d                	beqz	a0,a52 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f0:	4798                	lw	a4,8(a5)
 9f2:	02977463          	bgeu	a4,s1,a1a <malloc+0xbe>
    if(p == freep)
 9f6:	00093703          	ld	a4,0(s2)
 9fa:	853e                	mv	a0,a5
 9fc:	fef719e3          	bne	a4,a5,9ee <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a00:	8552                	mv	a0,s4
 a02:	00000097          	auipc	ra,0x0
 a06:	bb2080e7          	jalr	-1102(ra) # 5b4 <sbrk>
  if(p == (char*)-1)
 a0a:	fd5518e3          	bne	a0,s5,9da <malloc+0x7e>
        return 0;
 a0e:	4501                	li	a0,0
 a10:	7902                	ld	s2,32(sp)
 a12:	6a42                	ld	s4,16(sp)
 a14:	6aa2                	ld	s5,8(sp)
 a16:	6b02                	ld	s6,0(sp)
 a18:	a03d                	j	a46 <malloc+0xea>
 a1a:	7902                	ld	s2,32(sp)
 a1c:	6a42                	ld	s4,16(sp)
 a1e:	6aa2                	ld	s5,8(sp)
 a20:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a22:	fae489e3          	beq	s1,a4,9d4 <malloc+0x78>
        p->s.size -= nunits;
 a26:	4137073b          	subw	a4,a4,s3
 a2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2c:	02071693          	slli	a3,a4,0x20
 a30:	01c6d713          	srli	a4,a3,0x1c
 a34:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a36:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3a:	00000717          	auipc	a4,0x0
 a3e:	58a73b23          	sd	a0,1430(a4) # fd0 <freep>
      return (void*)(p + 1);
 a42:	01078513          	addi	a0,a5,16
  }
}
 a46:	70e2                	ld	ra,56(sp)
 a48:	7442                	ld	s0,48(sp)
 a4a:	74a2                	ld	s1,40(sp)
 a4c:	69e2                	ld	s3,24(sp)
 a4e:	6121                	addi	sp,sp,64
 a50:	8082                	ret
 a52:	7902                	ld	s2,32(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	b7f5                	j	a46 <malloc+0xea>
