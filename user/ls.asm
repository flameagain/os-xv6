
user/_ls：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	314080e7          	jalr	788(ra) # 320 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	2e8080e7          	jalr	744(ra) # 320 <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2c6080e7          	jalr	710(ra) # 320 <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	f8698993          	addi	s3,s3,-122 # fe8 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	420080e7          	jalr	1056(ra) # 492 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2a4080e7          	jalr	676(ra) # 320 <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	296080e7          	jalr	662(ra) # 320 <strlen>
  92:	1902                	slli	s2,s2,0x20
  94:	02095913          	srli	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2a6080e7          	jalr	678(ra) # 34a <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	addi	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4d0080e7          	jalr	1232(ra) # 59a <open>
  d2:	06054963          	bltz	a0,144 <ls+0x90>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	4d2080e7          	jalr	1234(ra) # 5b2 <fstat>
  e8:	06054963          	bltz	a0,15a <ls+0xa6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	da041783          	lh	a5,-608(s0)
  f0:	4705                	li	a4,1
  f2:	08e78663          	beq	a5,a4,17e <ls+0xca>
  f6:	4709                	li	a4,2
  f8:	02e79663          	bne	a5,a4,124 <ls+0x70>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
  fc:	854a                	mv	a0,s2
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <fmtname>
 106:	85aa                	mv	a1,a0
 108:	da843703          	ld	a4,-600(s0)
 10c:	d9c42683          	lw	a3,-612(s0)
 110:	da041603          	lh	a2,-608(s0)
 114:	00001517          	auipc	a0,0x1
 118:	9ac50513          	addi	a0,a0,-1620 # ac0 <malloc+0x136>
 11c:	00000097          	auipc	ra,0x0
 120:	7b6080e7          	jalr	1974(ra) # 8d2 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 124:	8526                	mv	a0,s1
 126:	00000097          	auipc	ra,0x0
 12a:	45c080e7          	jalr	1116(ra) # 582 <close>
 12e:	25813483          	ld	s1,600(sp)
}
 132:	26813083          	ld	ra,616(sp)
 136:	26013403          	ld	s0,608(sp)
 13a:	25013903          	ld	s2,592(sp)
 13e:	27010113          	addi	sp,sp,624
 142:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 144:	864a                	mv	a2,s2
 146:	00001597          	auipc	a1,0x1
 14a:	94a58593          	addi	a1,a1,-1718 # a90 <malloc+0x106>
 14e:	4509                	li	a0,2
 150:	00000097          	auipc	ra,0x0
 154:	754080e7          	jalr	1876(ra) # 8a4 <fprintf>
    return;
 158:	bfe9                	j	132 <ls+0x7e>
    fprintf(2, "ls: cannot stat %s\n", path);
 15a:	864a                	mv	a2,s2
 15c:	00001597          	auipc	a1,0x1
 160:	94c58593          	addi	a1,a1,-1716 # aa8 <malloc+0x11e>
 164:	4509                	li	a0,2
 166:	00000097          	auipc	ra,0x0
 16a:	73e080e7          	jalr	1854(ra) # 8a4 <fprintf>
    close(fd);
 16e:	8526                	mv	a0,s1
 170:	00000097          	auipc	ra,0x0
 174:	412080e7          	jalr	1042(ra) # 582 <close>
    return;
 178:	25813483          	ld	s1,600(sp)
 17c:	bf5d                	j	132 <ls+0x7e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17e:	854a                	mv	a0,s2
 180:	00000097          	auipc	ra,0x0
 184:	1a0080e7          	jalr	416(ra) # 320 <strlen>
 188:	2541                	addiw	a0,a0,16
 18a:	20000793          	li	a5,512
 18e:	00a7fb63          	bgeu	a5,a0,1a4 <ls+0xf0>
      printf("ls: path too long\n");
 192:	00001517          	auipc	a0,0x1
 196:	93e50513          	addi	a0,a0,-1730 # ad0 <malloc+0x146>
 19a:	00000097          	auipc	ra,0x0
 19e:	738080e7          	jalr	1848(ra) # 8d2 <printf>
      break;
 1a2:	b749                	j	124 <ls+0x70>
 1a4:	25313423          	sd	s3,584(sp)
 1a8:	25413023          	sd	s4,576(sp)
 1ac:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1b0:	85ca                	mv	a1,s2
 1b2:	dc040513          	addi	a0,s0,-576
 1b6:	00000097          	auipc	ra,0x0
 1ba:	122080e7          	jalr	290(ra) # 2d8 <strcpy>
    p = buf+strlen(buf);
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	15e080e7          	jalr	350(ra) # 320 <strlen>
 1ca:	1502                	slli	a0,a0,0x20
 1cc:	9101                	srli	a0,a0,0x20
 1ce:	dc040793          	addi	a5,s0,-576
 1d2:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1d6:	00190993          	addi	s3,s2,1
 1da:	02f00793          	li	a5,47
 1de:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e2:	00001a17          	auipc	s4,0x1
 1e6:	906a0a13          	addi	s4,s4,-1786 # ae8 <malloc+0x15e>
        printf("ls: cannot stat %s\n", buf);
 1ea:	00001a97          	auipc	s5,0x1
 1ee:	8bea8a93          	addi	s5,s5,-1858 # aa8 <malloc+0x11e>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f2:	a801                	j	202 <ls+0x14e>
        printf("ls: cannot stat %s\n", buf);
 1f4:	dc040593          	addi	a1,s0,-576
 1f8:	8556                	mv	a0,s5
 1fa:	00000097          	auipc	ra,0x0
 1fe:	6d8080e7          	jalr	1752(ra) # 8d2 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	4641                	li	a2,16
 204:	db040593          	addi	a1,s0,-592
 208:	8526                	mv	a0,s1
 20a:	00000097          	auipc	ra,0x0
 20e:	368080e7          	jalr	872(ra) # 572 <read>
 212:	47c1                	li	a5,16
 214:	04f51c63          	bne	a0,a5,26c <ls+0x1b8>
      if(de.inum == 0)
 218:	db045783          	lhu	a5,-592(s0)
 21c:	d3fd                	beqz	a5,202 <ls+0x14e>
      memmove(p, de.name, DIRSIZ);
 21e:	4639                	li	a2,14
 220:	db240593          	addi	a1,s0,-590
 224:	854e                	mv	a0,s3
 226:	00000097          	auipc	ra,0x0
 22a:	26c080e7          	jalr	620(ra) # 492 <memmove>
      p[DIRSIZ] = 0;
 22e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 232:	d9840593          	addi	a1,s0,-616
 236:	dc040513          	addi	a0,s0,-576
 23a:	00000097          	auipc	ra,0x0
 23e:	1ca080e7          	jalr	458(ra) # 404 <stat>
 242:	fa0549e3          	bltz	a0,1f4 <ls+0x140>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 246:	dc040513          	addi	a0,s0,-576
 24a:	00000097          	auipc	ra,0x0
 24e:	db6080e7          	jalr	-586(ra) # 0 <fmtname>
 252:	85aa                	mv	a1,a0
 254:	da843703          	ld	a4,-600(s0)
 258:	d9c42683          	lw	a3,-612(s0)
 25c:	da041603          	lh	a2,-608(s0)
 260:	8552                	mv	a0,s4
 262:	00000097          	auipc	ra,0x0
 266:	670080e7          	jalr	1648(ra) # 8d2 <printf>
 26a:	bf61                	j	202 <ls+0x14e>
 26c:	24813983          	ld	s3,584(sp)
 270:	24013a03          	ld	s4,576(sp)
 274:	23813a83          	ld	s5,568(sp)
 278:	b575                	j	124 <ls+0x70>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 282:	4785                	li	a5,1
 284:	02a7db63          	bge	a5,a0,2ba <main+0x40>
 288:	e426                	sd	s1,8(sp)
 28a:	e04a                	sd	s2,0(sp)
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	02091793          	slli	a5,s2,0x20
 298:	01d7d913          	srli	s2,a5,0x1d
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	2a8080e7          	jalr	680(ra) # 55a <exit>
 2ba:	e426                	sd	s1,8(sp)
 2bc:	e04a                	sd	s2,0(sp)
    ls(".");
 2be:	00001517          	auipc	a0,0x1
 2c2:	83a50513          	addi	a0,a0,-1990 # af8 <malloc+0x16e>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	dee080e7          	jalr	-530(ra) # b4 <ls>
    exit(0);
 2ce:	4501                	li	a0,0
 2d0:	00000097          	auipc	ra,0x0
 2d4:	28a080e7          	jalr	650(ra) # 55a <exit>

00000000000002d8 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2de:	87aa                	mv	a5,a0
 2e0:	0585                	addi	a1,a1,1
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff5c703          	lbu	a4,-1(a1)
 2e8:	fee78fa3          	sb	a4,-1(a5)
 2ec:	fb75                	bnez	a4,2e0 <strcpy+0x8>
    ;
  return os;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb91                	beqz	a5,312 <strcmp+0x1e>
 300:	0005c703          	lbu	a4,0(a1)
 304:	00f71763          	bne	a4,a5,312 <strcmp+0x1e>
    p++, q++;
 308:	0505                	addi	a0,a0,1
 30a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 30c:	00054783          	lbu	a5,0(a0)
 310:	fbe5                	bnez	a5,300 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 312:	0005c503          	lbu	a0,0(a1)
}
 316:	40a7853b          	subw	a0,a5,a0
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strlen>:

uint
strlen(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 326:	00054783          	lbu	a5,0(a0)
 32a:	cf91                	beqz	a5,346 <strlen+0x26>
 32c:	0505                	addi	a0,a0,1
 32e:	87aa                	mv	a5,a0
 330:	86be                	mv	a3,a5
 332:	0785                	addi	a5,a5,1
 334:	fff7c703          	lbu	a4,-1(a5)
 338:	ff65                	bnez	a4,330 <strlen+0x10>
 33a:	40a6853b          	subw	a0,a3,a0
 33e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  for(n = 0; s[n]; n++)
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <strlen+0x20>

000000000000034a <memset>:

void*
memset(void *dst, int c, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 350:	ca19                	beqz	a2,366 <memset+0x1c>
 352:	87aa                	mv	a5,a0
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 35c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 360:	0785                	addi	a5,a5,1
 362:	fee79de3          	bne	a5,a4,35c <memset+0x12>
  }
  return dst;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <strchr>:

char*
strchr(const char *s, char c)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  for(; *s; s++)
 372:	00054783          	lbu	a5,0(a0)
 376:	cb99                	beqz	a5,38c <strchr+0x20>
    if(*s == c)
 378:	00f58763          	beq	a1,a5,386 <strchr+0x1a>
  for(; *s; s++)
 37c:	0505                	addi	a0,a0,1
 37e:	00054783          	lbu	a5,0(a0)
 382:	fbfd                	bnez	a5,378 <strchr+0xc>
      return (char*)s;
  return 0;
 384:	4501                	li	a0,0
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <strchr+0x1a>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	1080                	addi	s0,sp,96
 3a6:	8baa                	mv	s7,a0
 3a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3aa:	892a                	mv	s2,a0
 3ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ae:	4aa9                	li	s5,10
 3b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	2485                	addiw	s1,s1,1
 3b6:	0344d863          	bge	s1,s4,3e6 <gets+0x56>
    cc = read(0, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	faf40593          	addi	a1,s0,-81
 3c0:	4501                	li	a0,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	1b0080e7          	jalr	432(ra) # 572 <read>
    if(cc < 1)
 3ca:	00a05e63          	blez	a0,3e6 <gets+0x56>
    buf[i++] = c;
 3ce:	faf44783          	lbu	a5,-81(s0)
 3d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d6:	01578763          	beq	a5,s5,3e4 <gets+0x54>
 3da:	0905                	addi	s2,s2,1
 3dc:	fd679be3          	bne	a5,s6,3b2 <gets+0x22>
    buf[i++] = c;
 3e0:	89a6                	mv	s3,s1
 3e2:	a011                	j	3e6 <gets+0x56>
 3e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e6:	99de                	add	s3,s3,s7
 3e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ec:	855e                	mv	a0,s7
 3ee:	60e6                	ld	ra,88(sp)
 3f0:	6446                	ld	s0,80(sp)
 3f2:	64a6                	ld	s1,72(sp)
 3f4:	6906                	ld	s2,64(sp)
 3f6:	79e2                	ld	s3,56(sp)
 3f8:	7a42                	ld	s4,48(sp)
 3fa:	7aa2                	ld	s5,40(sp)
 3fc:	7b02                	ld	s6,32(sp)
 3fe:	6be2                	ld	s7,24(sp)
 400:	6125                	addi	sp,sp,96
 402:	8082                	ret

0000000000000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	e04a                	sd	s2,0(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 410:	4581                	li	a1,0
 412:	00000097          	auipc	ra,0x0
 416:	188080e7          	jalr	392(ra) # 59a <open>
  if(fd < 0)
 41a:	02054663          	bltz	a0,446 <stat+0x42>
 41e:	e426                	sd	s1,8(sp)
 420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 422:	85ca                	mv	a1,s2
 424:	00000097          	auipc	ra,0x0
 428:	18e080e7          	jalr	398(ra) # 5b2 <fstat>
 42c:	892a                	mv	s2,a0
  close(fd);
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	152080e7          	jalr	338(ra) # 582 <close>
  return r;
 438:	64a2                	ld	s1,8(sp)
}
 43a:	854a                	mv	a0,s2
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6902                	ld	s2,0(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret
    return -1;
 446:	597d                	li	s2,-1
 448:	bfcd                	j	43a <stat+0x36>

000000000000044a <atoi>:

int
atoi(const char *s)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 450:	00054683          	lbu	a3,0(a0)
 454:	fd06879b          	addiw	a5,a3,-48
 458:	0ff7f793          	zext.b	a5,a5
 45c:	4625                	li	a2,9
 45e:	02f66863          	bltu	a2,a5,48e <atoi+0x44>
 462:	872a                	mv	a4,a0
  n = 0;
 464:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 466:	0705                	addi	a4,a4,1
 468:	0025179b          	slliw	a5,a0,0x2
 46c:	9fa9                	addw	a5,a5,a0
 46e:	0017979b          	slliw	a5,a5,0x1
 472:	9fb5                	addw	a5,a5,a3
 474:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 478:	00074683          	lbu	a3,0(a4)
 47c:	fd06879b          	addiw	a5,a3,-48
 480:	0ff7f793          	zext.b	a5,a5
 484:	fef671e3          	bgeu	a2,a5,466 <atoi+0x1c>
  return n;
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  n = 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <atoi+0x3e>

0000000000000492 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 498:	02b57463          	bgeu	a0,a1,4c0 <memmove+0x2e>
    while(n-- > 0)
 49c:	00c05f63          	blez	a2,4ba <memmove+0x28>
 4a0:	1602                	slli	a2,a2,0x20
 4a2:	9201                	srli	a2,a2,0x20
 4a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 4aa:	0585                	addi	a1,a1,1
 4ac:	0705                	addi	a4,a4,1
 4ae:	fff5c683          	lbu	a3,-1(a1)
 4b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b6:	fef71ae3          	bne	a4,a5,4aa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
    dst += n;
 4c0:	00c50733          	add	a4,a0,a2
    src += n;
 4c4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c6:	fec05ae3          	blez	a2,4ba <memmove+0x28>
 4ca:	fff6079b          	addiw	a5,a2,-1
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	fff7c793          	not	a5,a5
 4d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d8:	15fd                	addi	a1,a1,-1
 4da:	177d                	addi	a4,a4,-1
 4dc:	0005c683          	lbu	a3,0(a1)
 4e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e4:	fee79ae3          	bne	a5,a4,4d8 <memmove+0x46>
 4e8:	bfc9                	j	4ba <memmove+0x28>

00000000000004ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e422                	sd	s0,8(sp)
 4ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f0:	ca05                	beqz	a2,520 <memcmp+0x36>
 4f2:	fff6069b          	addiw	a3,a2,-1
 4f6:	1682                	slli	a3,a3,0x20
 4f8:	9281                	srli	a3,a3,0x20
 4fa:	0685                	addi	a3,a3,1
 4fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4fe:	00054783          	lbu	a5,0(a0)
 502:	0005c703          	lbu	a4,0(a1)
 506:	00e79863          	bne	a5,a4,516 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 50a:	0505                	addi	a0,a0,1
    p2++;
 50c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50e:	fed518e3          	bne	a0,a3,4fe <memcmp+0x14>
  }
  return 0;
 512:	4501                	li	a0,0
 514:	a019                	j	51a <memcmp+0x30>
      return *p1 - *p2;
 516:	40e7853b          	subw	a0,a5,a4
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
  return 0;
 520:	4501                	li	a0,0
 522:	bfe5                	j	51a <memcmp+0x30>

0000000000000524 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 524:	1141                	addi	sp,sp,-16
 526:	e406                	sd	ra,8(sp)
 528:	e022                	sd	s0,0(sp)
 52a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 52c:	00000097          	auipc	ra,0x0
 530:	f66080e7          	jalr	-154(ra) # 492 <memmove>
}
 534:	60a2                	ld	ra,8(sp)
 536:	6402                	ld	s0,0(sp)
 538:	0141                	addi	sp,sp,16
 53a:	8082                	ret

000000000000053c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e422                	sd	s0,8(sp)
 540:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 542:	040007b7          	lui	a5,0x4000
 546:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffe821>
 548:	07b2                	slli	a5,a5,0xc
}
 54a:	4388                	lw	a0,0(a5)
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret

0000000000000552 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 552:	4885                	li	a7,1
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <exit>:
.global exit
exit:
 li a7, SYS_exit
 55a:	4889                	li	a7,2
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <wait>:
.global wait
wait:
 li a7, SYS_wait
 562:	488d                	li	a7,3
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 56a:	4891                	li	a7,4
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <read>:
.global read
read:
 li a7, SYS_read
 572:	4895                	li	a7,5
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <write>:
.global write
write:
 li a7, SYS_write
 57a:	48c1                	li	a7,16
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <close>:
.global close
close:
 li a7, SYS_close
 582:	48d5                	li	a7,21
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <kill>:
.global kill
kill:
 li a7, SYS_kill
 58a:	4899                	li	a7,6
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <exec>:
.global exec
exec:
 li a7, SYS_exec
 592:	489d                	li	a7,7
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <open>:
.global open
open:
 li a7, SYS_open
 59a:	48bd                	li	a7,15
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a2:	48c5                	li	a7,17
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5aa:	48c9                	li	a7,18
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b2:	48a1                	li	a7,8
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <link>:
.global link
link:
 li a7, SYS_link
 5ba:	48cd                	li	a7,19
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c2:	48d1                	li	a7,20
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ca:	48a5                	li	a7,9
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d2:	48a9                	li	a7,10
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5da:	48ad                	li	a7,11
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e2:	48b1                	li	a7,12
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ea:	48b5                	li	a7,13
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f2:	48b9                	li	a7,14
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <connect>:
.global connect
connect:
 li a7, SYS_connect
 5fa:	48f5                	li	a7,29
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 602:	48f9                	li	a7,30
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60a:	1101                	addi	sp,sp,-32
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	1000                	addi	s0,sp,32
 612:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 616:	4605                	li	a2,1
 618:	fef40593          	addi	a1,s0,-17
 61c:	00000097          	auipc	ra,0x0
 620:	f5e080e7          	jalr	-162(ra) # 57a <write>
}
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	6105                	addi	sp,sp,32
 62a:	8082                	ret

000000000000062c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62c:	7139                	addi	sp,sp,-64
 62e:	fc06                	sd	ra,56(sp)
 630:	f822                	sd	s0,48(sp)
 632:	f426                	sd	s1,40(sp)
 634:	0080                	addi	s0,sp,64
 636:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 638:	c299                	beqz	a3,63e <printint+0x12>
 63a:	0805cb63          	bltz	a1,6d0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 63e:	2581                	sext.w	a1,a1
  neg = 0;
 640:	4881                	li	a7,0
 642:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 646:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 648:	2601                	sext.w	a2,a2
 64a:	00000517          	auipc	a0,0x0
 64e:	51650513          	addi	a0,a0,1302 # b60 <digits>
 652:	883a                	mv	a6,a4
 654:	2705                	addiw	a4,a4,1
 656:	02c5f7bb          	remuw	a5,a1,a2
 65a:	1782                	slli	a5,a5,0x20
 65c:	9381                	srli	a5,a5,0x20
 65e:	97aa                	add	a5,a5,a0
 660:	0007c783          	lbu	a5,0(a5)
 664:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 668:	0005879b          	sext.w	a5,a1
 66c:	02c5d5bb          	divuw	a1,a1,a2
 670:	0685                	addi	a3,a3,1
 672:	fec7f0e3          	bgeu	a5,a2,652 <printint+0x26>
  if(neg)
 676:	00088c63          	beqz	a7,68e <printint+0x62>
    buf[i++] = '-';
 67a:	fd070793          	addi	a5,a4,-48
 67e:	00878733          	add	a4,a5,s0
 682:	02d00793          	li	a5,45
 686:	fef70823          	sb	a5,-16(a4)
 68a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 68e:	02e05c63          	blez	a4,6c6 <printint+0x9a>
 692:	f04a                	sd	s2,32(sp)
 694:	ec4e                	sd	s3,24(sp)
 696:	fc040793          	addi	a5,s0,-64
 69a:	00e78933          	add	s2,a5,a4
 69e:	fff78993          	addi	s3,a5,-1
 6a2:	99ba                	add	s3,s3,a4
 6a4:	377d                	addiw	a4,a4,-1
 6a6:	1702                	slli	a4,a4,0x20
 6a8:	9301                	srli	a4,a4,0x20
 6aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ae:	fff94583          	lbu	a1,-1(s2)
 6b2:	8526                	mv	a0,s1
 6b4:	00000097          	auipc	ra,0x0
 6b8:	f56080e7          	jalr	-170(ra) # 60a <putc>
  while(--i >= 0)
 6bc:	197d                	addi	s2,s2,-1
 6be:	ff3918e3          	bne	s2,s3,6ae <printint+0x82>
 6c2:	7902                	ld	s2,32(sp)
 6c4:	69e2                	ld	s3,24(sp)
}
 6c6:	70e2                	ld	ra,56(sp)
 6c8:	7442                	ld	s0,48(sp)
 6ca:	74a2                	ld	s1,40(sp)
 6cc:	6121                	addi	sp,sp,64
 6ce:	8082                	ret
    x = -xx;
 6d0:	40b005bb          	negw	a1,a1
    neg = 1;
 6d4:	4885                	li	a7,1
    x = -xx;
 6d6:	b7b5                	j	642 <printint+0x16>

00000000000006d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d8:	715d                	addi	sp,sp,-80
 6da:	e486                	sd	ra,72(sp)
 6dc:	e0a2                	sd	s0,64(sp)
 6de:	f84a                	sd	s2,48(sp)
 6e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e2:	0005c903          	lbu	s2,0(a1)
 6e6:	1a090a63          	beqz	s2,89a <vprintf+0x1c2>
 6ea:	fc26                	sd	s1,56(sp)
 6ec:	f44e                	sd	s3,40(sp)
 6ee:	f052                	sd	s4,32(sp)
 6f0:	ec56                	sd	s5,24(sp)
 6f2:	e85a                	sd	s6,16(sp)
 6f4:	e45e                	sd	s7,8(sp)
 6f6:	8aaa                	mv	s5,a0
 6f8:	8bb2                	mv	s7,a2
 6fa:	00158493          	addi	s1,a1,1
  state = 0;
 6fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 700:	02500a13          	li	s4,37
 704:	4b55                	li	s6,21
 706:	a839                	j	724 <vprintf+0x4c>
        putc(fd, c);
 708:	85ca                	mv	a1,s2
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	efe080e7          	jalr	-258(ra) # 60a <putc>
 714:	a019                	j	71a <vprintf+0x42>
    } else if(state == '%'){
 716:	01498d63          	beq	s3,s4,730 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 71a:	0485                	addi	s1,s1,1
 71c:	fff4c903          	lbu	s2,-1(s1)
 720:	16090763          	beqz	s2,88e <vprintf+0x1b6>
    if(state == 0){
 724:	fe0999e3          	bnez	s3,716 <vprintf+0x3e>
      if(c == '%'){
 728:	ff4910e3          	bne	s2,s4,708 <vprintf+0x30>
        state = '%';
 72c:	89d2                	mv	s3,s4
 72e:	b7f5                	j	71a <vprintf+0x42>
      if(c == 'd'){
 730:	13490463          	beq	s2,s4,858 <vprintf+0x180>
 734:	f9d9079b          	addiw	a5,s2,-99
 738:	0ff7f793          	zext.b	a5,a5
 73c:	12fb6763          	bltu	s6,a5,86a <vprintf+0x192>
 740:	f9d9079b          	addiw	a5,s2,-99
 744:	0ff7f713          	zext.b	a4,a5
 748:	12eb6163          	bltu	s6,a4,86a <vprintf+0x192>
 74c:	00271793          	slli	a5,a4,0x2
 750:	00000717          	auipc	a4,0x0
 754:	3b870713          	addi	a4,a4,952 # b08 <malloc+0x17e>
 758:	97ba                	add	a5,a5,a4
 75a:	439c                	lw	a5,0(a5)
 75c:	97ba                	add	a5,a5,a4
 75e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 760:	008b8913          	addi	s2,s7,8
 764:	4685                	li	a3,1
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	ebe080e7          	jalr	-322(ra) # 62c <printint>
 776:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 778:	4981                	li	s3,0
 77a:	b745                	j	71a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77c:	008b8913          	addi	s2,s7,8
 780:	4681                	li	a3,0
 782:	4629                	li	a2,10
 784:	000ba583          	lw	a1,0(s7)
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	ea2080e7          	jalr	-350(ra) # 62c <printint>
 792:	8bca                	mv	s7,s2
      state = 0;
 794:	4981                	li	s3,0
 796:	b751                	j	71a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4641                	li	a2,16
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e86080e7          	jalr	-378(ra) # 62c <printint>
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b7a5                	j	71a <vprintf+0x42>
 7b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b6:	008b8c13          	addi	s8,s7,8
 7ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7be:	03000593          	li	a1,48
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e46080e7          	jalr	-442(ra) # 60a <putc>
  putc(fd, 'x');
 7cc:	07800593          	li	a1,120
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e38080e7          	jalr	-456(ra) # 60a <putc>
 7da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7dc:	00000b97          	auipc	s7,0x0
 7e0:	384b8b93          	addi	s7,s7,900 # b60 <digits>
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	e1a080e7          	jalr	-486(ra) # 60a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f8:	0992                	slli	s3,s3,0x4
 7fa:	397d                	addiw	s2,s2,-1
 7fc:	fe0914e3          	bnez	s2,7e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 800:	8be2                	mv	s7,s8
      state = 0;
 802:	4981                	li	s3,0
 804:	6c02                	ld	s8,0(sp)
 806:	bf11                	j	71a <vprintf+0x42>
        s = va_arg(ap, char*);
 808:	008b8993          	addi	s3,s7,8
 80c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 810:	02090163          	beqz	s2,832 <vprintf+0x15a>
        while(*s != 0){
 814:	00094583          	lbu	a1,0(s2)
 818:	c9a5                	beqz	a1,888 <vprintf+0x1b0>
          putc(fd, *s);
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	dee080e7          	jalr	-530(ra) # 60a <putc>
          s++;
 824:	0905                	addi	s2,s2,1
        while(*s != 0){
 826:	00094583          	lbu	a1,0(s2)
 82a:	f9e5                	bnez	a1,81a <vprintf+0x142>
        s = va_arg(ap, char*);
 82c:	8bce                	mv	s7,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	b5ed                	j	71a <vprintf+0x42>
          s = "(null)";
 832:	00000917          	auipc	s2,0x0
 836:	2ce90913          	addi	s2,s2,718 # b00 <malloc+0x176>
        while(*s != 0){
 83a:	02800593          	li	a1,40
 83e:	bff1                	j	81a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 840:	008b8913          	addi	s2,s7,8
 844:	000bc583          	lbu	a1,0(s7)
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	dc0080e7          	jalr	-576(ra) # 60a <putc>
 852:	8bca                	mv	s7,s2
      state = 0;
 854:	4981                	li	s3,0
 856:	b5d1                	j	71a <vprintf+0x42>
        putc(fd, c);
 858:	02500593          	li	a1,37
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	dac080e7          	jalr	-596(ra) # 60a <putc>
      state = 0;
 866:	4981                	li	s3,0
 868:	bd4d                	j	71a <vprintf+0x42>
        putc(fd, '%');
 86a:	02500593          	li	a1,37
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	d9a080e7          	jalr	-614(ra) # 60a <putc>
        putc(fd, c);
 878:	85ca                	mv	a1,s2
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	d8e080e7          	jalr	-626(ra) # 60a <putc>
      state = 0;
 884:	4981                	li	s3,0
 886:	bd51                	j	71a <vprintf+0x42>
        s = va_arg(ap, char*);
 888:	8bce                	mv	s7,s3
      state = 0;
 88a:	4981                	li	s3,0
 88c:	b579                	j	71a <vprintf+0x42>
 88e:	74e2                	ld	s1,56(sp)
 890:	79a2                	ld	s3,40(sp)
 892:	7a02                	ld	s4,32(sp)
 894:	6ae2                	ld	s5,24(sp)
 896:	6b42                	ld	s6,16(sp)
 898:	6ba2                	ld	s7,8(sp)
    }
  }
}
 89a:	60a6                	ld	ra,72(sp)
 89c:	6406                	ld	s0,64(sp)
 89e:	7942                	ld	s2,48(sp)
 8a0:	6161                	addi	sp,sp,80
 8a2:	8082                	ret

00000000000008a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e010                	sd	a2,0(s0)
 8ae:	e414                	sd	a3,8(s0)
 8b0:	e818                	sd	a4,16(s0)
 8b2:	ec1c                	sd	a5,24(s0)
 8b4:	03043023          	sd	a6,32(s0)
 8b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c0:	8622                	mv	a2,s0
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e16080e7          	jalr	-490(ra) # 6d8 <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6161                	addi	sp,sp,80
 8d0:	8082                	ret

00000000000008d2 <printf>:

void
printf(const char *fmt, ...)
{
 8d2:	711d                	addi	sp,sp,-96
 8d4:	ec06                	sd	ra,24(sp)
 8d6:	e822                	sd	s0,16(sp)
 8d8:	1000                	addi	s0,sp,32
 8da:	e40c                	sd	a1,8(s0)
 8dc:	e810                	sd	a2,16(s0)
 8de:	ec14                	sd	a3,24(s0)
 8e0:	f018                	sd	a4,32(s0)
 8e2:	f41c                	sd	a5,40(s0)
 8e4:	03043823          	sd	a6,48(s0)
 8e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	00840613          	addi	a2,s0,8
 8f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f4:	85aa                	mv	a1,a0
 8f6:	4505                	li	a0,1
 8f8:	00000097          	auipc	ra,0x0
 8fc:	de0080e7          	jalr	-544(ra) # 6d8 <vprintf>
}
 900:	60e2                	ld	ra,24(sp)
 902:	6442                	ld	s0,16(sp)
 904:	6125                	addi	sp,sp,96
 906:	8082                	ret

0000000000000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 908:	1141                	addi	sp,sp,-16
 90a:	e422                	sd	s0,8(sp)
 90c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 912:	00000797          	auipc	a5,0x0
 916:	6ce7b783          	ld	a5,1742(a5) # fe0 <freep>
 91a:	a02d                	j	944 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91c:	4618                	lw	a4,8(a2)
 91e:	9f2d                	addw	a4,a4,a1
 920:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	6310                	ld	a2,0(a4)
 928:	a83d                	j	966 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 92a:	ff852703          	lw	a4,-8(a0)
 92e:	9f31                	addw	a4,a4,a2
 930:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 932:	ff053683          	ld	a3,-16(a0)
 936:	a091                	j	97a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 938:	6398                	ld	a4,0(a5)
 93a:	00e7e463          	bltu	a5,a4,942 <free+0x3a>
 93e:	00e6ea63          	bltu	a3,a4,952 <free+0x4a>
{
 942:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	fed7fae3          	bgeu	a5,a3,938 <free+0x30>
 948:	6398                	ld	a4,0(a5)
 94a:	00e6e463          	bltu	a3,a4,952 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94e:	fee7eae3          	bltu	a5,a4,942 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 952:	ff852583          	lw	a1,-8(a0)
 956:	6390                	ld	a2,0(a5)
 958:	02059813          	slli	a6,a1,0x20
 95c:	01c85713          	srli	a4,a6,0x1c
 960:	9736                	add	a4,a4,a3
 962:	fae60de3          	beq	a2,a4,91c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 96a:	4790                	lw	a2,8(a5)
 96c:	02061593          	slli	a1,a2,0x20
 970:	01c5d713          	srli	a4,a1,0x1c
 974:	973e                	add	a4,a4,a5
 976:	fae68ae3          	beq	a3,a4,92a <free+0x22>
    p->s.ptr = bp->s.ptr;
 97a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 97c:	00000717          	auipc	a4,0x0
 980:	66f73223          	sd	a5,1636(a4) # fe0 <freep>
}
 984:	6422                	ld	s0,8(sp)
 986:	0141                	addi	sp,sp,16
 988:	8082                	ret

000000000000098a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 98a:	7139                	addi	sp,sp,-64
 98c:	fc06                	sd	ra,56(sp)
 98e:	f822                	sd	s0,48(sp)
 990:	f426                	sd	s1,40(sp)
 992:	ec4e                	sd	s3,24(sp)
 994:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 996:	02051493          	slli	s1,a0,0x20
 99a:	9081                	srli	s1,s1,0x20
 99c:	04bd                	addi	s1,s1,15
 99e:	8091                	srli	s1,s1,0x4
 9a0:	0014899b          	addiw	s3,s1,1
 9a4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a6:	00000517          	auipc	a0,0x0
 9aa:	63a53503          	ld	a0,1594(a0) # fe0 <freep>
 9ae:	c915                	beqz	a0,9e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	08977e63          	bgeu	a4,s1,a50 <malloc+0xc6>
 9b8:	f04a                	sd	s2,32(sp)
 9ba:	e852                	sd	s4,16(sp)
 9bc:	e456                	sd	s5,8(sp)
 9be:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9c0:	8a4e                	mv	s4,s3
 9c2:	0009871b          	sext.w	a4,s3
 9c6:	6685                	lui	a3,0x1
 9c8:	00d77363          	bgeu	a4,a3,9ce <malloc+0x44>
 9cc:	6a05                	lui	s4,0x1
 9ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d6:	00000917          	auipc	s2,0x0
 9da:	60a90913          	addi	s2,s2,1546 # fe0 <freep>
  if(p == (char*)-1)
 9de:	5afd                	li	s5,-1
 9e0:	a091                	j	a24 <malloc+0x9a>
 9e2:	f04a                	sd	s2,32(sp)
 9e4:	e852                	sd	s4,16(sp)
 9e6:	e456                	sd	s5,8(sp)
 9e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9ea:	00000797          	auipc	a5,0x0
 9ee:	60e78793          	addi	a5,a5,1550 # ff8 <base>
 9f2:	00000717          	auipc	a4,0x0
 9f6:	5ef73723          	sd	a5,1518(a4) # fe0 <freep>
 9fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a00:	b7c1                	j	9c0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a02:	6398                	ld	a4,0(a5)
 a04:	e118                	sd	a4,0(a0)
 a06:	a08d                	j	a68 <malloc+0xde>
  hp->s.size = nu;
 a08:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a0c:	0541                	addi	a0,a0,16
 a0e:	00000097          	auipc	ra,0x0
 a12:	efa080e7          	jalr	-262(ra) # 908 <free>
  return freep;
 a16:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a1a:	c13d                	beqz	a0,a80 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1e:	4798                	lw	a4,8(a5)
 a20:	02977463          	bgeu	a4,s1,a48 <malloc+0xbe>
    if(p == freep)
 a24:	00093703          	ld	a4,0(s2)
 a28:	853e                	mv	a0,a5
 a2a:	fef719e3          	bne	a4,a5,a1c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a2e:	8552                	mv	a0,s4
 a30:	00000097          	auipc	ra,0x0
 a34:	bb2080e7          	jalr	-1102(ra) # 5e2 <sbrk>
  if(p == (char*)-1)
 a38:	fd5518e3          	bne	a0,s5,a08 <malloc+0x7e>
        return 0;
 a3c:	4501                	li	a0,0
 a3e:	7902                	ld	s2,32(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6b02                	ld	s6,0(sp)
 a46:	a03d                	j	a74 <malloc+0xea>
 a48:	7902                	ld	s2,32(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a50:	fae489e3          	beq	s1,a4,a02 <malloc+0x78>
        p->s.size -= nunits;
 a54:	4137073b          	subw	a4,a4,s3
 a58:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5a:	02071693          	slli	a3,a4,0x20
 a5e:	01c6d713          	srli	a4,a3,0x1c
 a62:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a64:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a68:	00000717          	auipc	a4,0x0
 a6c:	56a73c23          	sd	a0,1400(a4) # fe0 <freep>
      return (void*)(p + 1);
 a70:	01078513          	addi	a0,a5,16
  }
}
 a74:	70e2                	ld	ra,56(sp)
 a76:	7442                	ld	s0,48(sp)
 a78:	74a2                	ld	s1,40(sp)
 a7a:	69e2                	ld	s3,24(sp)
 a7c:	6121                	addi	sp,sp,64
 a7e:	8082                	ret
 a80:	7902                	ld	s2,32(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	b7f5                	j	a74 <malloc+0xea>
