
user/_stats：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define SZ 4096
char buf[SZ];

int
main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i, n;
  
  while (1) {
    n = statistics(buf, SZ);
  10:	00001a17          	auipc	s4,0x1
  14:	d08a0a13          	addi	s4,s4,-760 # d18 <buf>
  18:	6585                	lui	a1,0x1
  1a:	8552                	mv	a0,s4
  1c:	00000097          	auipc	ra,0x0
  20:	7ca080e7          	jalr	1994(ra) # 7e6 <statistics>
  24:	89aa                	mv	s3,a0
    for (i = 0; i < n; i++) {
  26:	02a05563          	blez	a0,50 <main+0x50>
  2a:	00001497          	auipc	s1,0x1
  2e:	cee48493          	addi	s1,s1,-786 # d18 <buf>
  32:	00950933          	add	s2,a0,s1
      write(1, buf+i, 1);
  36:	4605                	li	a2,1
  38:	85a6                	mv	a1,s1
  3a:	4505                	li	a0,1
  3c:	00000097          	auipc	ra,0x0
  40:	2aa080e7          	jalr	682(ra) # 2e6 <write>
    for (i = 0; i < n; i++) {
  44:	0485                	addi	s1,s1,1
  46:	ff2498e3          	bne	s1,s2,36 <main+0x36>
    }
    if (n != SZ)
  4a:	6785                	lui	a5,0x1
  4c:	fcf986e3          	beq	s3,a5,18 <main+0x18>
      break;
  }

  exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	274080e7          	jalr	628(ra) # 2c6 <exit>

000000000000005a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  60:	87aa                	mv	a5,a0
  62:	0585                	addi	a1,a1,1 # 1001 <buf+0x2e9>
  64:	0785                	addi	a5,a5,1 # 1001 <buf+0x2e9>
  66:	fff5c703          	lbu	a4,-1(a1)
  6a:	fee78fa3          	sb	a4,-1(a5)
  6e:	fb75                	bnez	a4,62 <strcpy+0x8>
    ;
  return os;
}
  70:	6422                	ld	s0,8(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret

0000000000000076 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cb91                	beqz	a5,94 <strcmp+0x1e>
  82:	0005c703          	lbu	a4,0(a1)
  86:	00f71763          	bne	a4,a5,94 <strcmp+0x1e>
    p++, q++;
  8a:	0505                	addi	a0,a0,1
  8c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	fbe5                	bnez	a5,82 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  94:	0005c503          	lbu	a0,0(a1)
}
  98:	40a7853b          	subw	a0,a5,a0
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strlen>:

uint
strlen(const char *s)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	cf91                	beqz	a5,c8 <strlen+0x26>
  ae:	0505                	addi	a0,a0,1
  b0:	87aa                	mv	a5,a0
  b2:	86be                	mv	a3,a5
  b4:	0785                	addi	a5,a5,1
  b6:	fff7c703          	lbu	a4,-1(a5)
  ba:	ff65                	bnez	a4,b2 <strlen+0x10>
  bc:	40a6853b          	subw	a0,a3,a0
  c0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret
  for(n = 0; s[n]; n++)
  c8:	4501                	li	a0,0
  ca:	bfe5                	j	c2 <strlen+0x20>

00000000000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d2:	ca19                	beqz	a2,e8 <memset+0x1c>
  d4:	87aa                	mv	a5,a0
  d6:	1602                	slli	a2,a2,0x20
  d8:	9201                	srli	a2,a2,0x20
  da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e2:	0785                	addi	a5,a5,1
  e4:	fee79de3          	bne	a5,a4,de <memset+0x12>
  }
  return dst;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strchr>:

char*
strchr(const char *s, char c)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb99                	beqz	a5,10e <strchr+0x20>
    if(*s == c)
  fa:	00f58763          	beq	a1,a5,108 <strchr+0x1a>
  for(; *s; s++)
  fe:	0505                	addi	a0,a0,1
 100:	00054783          	lbu	a5,0(a0)
 104:	fbfd                	bnez	a5,fa <strchr+0xc>
      return (char*)s;
  return 0;
 106:	4501                	li	a0,0
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  return 0;
 10e:	4501                	li	a0,0
 110:	bfe5                	j	108 <strchr+0x1a>

0000000000000112 <gets>:

char*
gets(char *buf, int max)
{
 112:	711d                	addi	sp,sp,-96
 114:	ec86                	sd	ra,88(sp)
 116:	e8a2                	sd	s0,80(sp)
 118:	e4a6                	sd	s1,72(sp)
 11a:	e0ca                	sd	s2,64(sp)
 11c:	fc4e                	sd	s3,56(sp)
 11e:	f852                	sd	s4,48(sp)
 120:	f456                	sd	s5,40(sp)
 122:	f05a                	sd	s6,32(sp)
 124:	ec5e                	sd	s7,24(sp)
 126:	1080                	addi	s0,sp,96
 128:	8baa                	mv	s7,a0
 12a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	892a                	mv	s2,a0
 12e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 130:	4aa9                	li	s5,10
 132:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	2485                	addiw	s1,s1,1
 138:	0344d863          	bge	s1,s4,168 <gets+0x56>
    cc = read(0, &c, 1);
 13c:	4605                	li	a2,1
 13e:	faf40593          	addi	a1,s0,-81
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	19a080e7          	jalr	410(ra) # 2de <read>
    if(cc < 1)
 14c:	00a05e63          	blez	a0,168 <gets+0x56>
    buf[i++] = c;
 150:	faf44783          	lbu	a5,-81(s0)
 154:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 158:	01578763          	beq	a5,s5,166 <gets+0x54>
 15c:	0905                	addi	s2,s2,1
 15e:	fd679be3          	bne	a5,s6,134 <gets+0x22>
    buf[i++] = c;
 162:	89a6                	mv	s3,s1
 164:	a011                	j	168 <gets+0x56>
 166:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 168:	99de                	add	s3,s3,s7
 16a:	00098023          	sb	zero,0(s3)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6125                	addi	sp,sp,96
 184:	8082                	ret

0000000000000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	1101                	addi	sp,sp,-32
 188:	ec06                	sd	ra,24(sp)
 18a:	e822                	sd	s0,16(sp)
 18c:	e04a                	sd	s2,0(sp)
 18e:	1000                	addi	s0,sp,32
 190:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 192:	4581                	li	a1,0
 194:	00000097          	auipc	ra,0x0
 198:	172080e7          	jalr	370(ra) # 306 <open>
  if(fd < 0)
 19c:	02054663          	bltz	a0,1c8 <stat+0x42>
 1a0:	e426                	sd	s1,8(sp)
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	00000097          	auipc	ra,0x0
 1aa:	178080e7          	jalr	376(ra) # 31e <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	13c080e7          	jalr	316(ra) # 2ee <close>
  return r;
 1ba:	64a2                	ld	s1,8(sp)
}
 1bc:	854a                	mv	a0,s2
 1be:	60e2                	ld	ra,24(sp)
 1c0:	6442                	ld	s0,16(sp)
 1c2:	6902                	ld	s2,0(sp)
 1c4:	6105                	addi	sp,sp,32
 1c6:	8082                	ret
    return -1;
 1c8:	597d                	li	s2,-1
 1ca:	bfcd                	j	1bc <stat+0x36>

00000000000001cc <atoi>:

int
atoi(const char *s)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d2:	00054683          	lbu	a3,0(a0)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	4625                	li	a2,9
 1e0:	02f66863          	bltu	a2,a5,210 <atoi+0x44>
 1e4:	872a                	mv	a4,a0
  n = 0;
 1e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e8:	0705                	addi	a4,a4,1
 1ea:	0025179b          	slliw	a5,a0,0x2
 1ee:	9fa9                	addw	a5,a5,a0
 1f0:	0017979b          	slliw	a5,a5,0x1
 1f4:	9fb5                	addw	a5,a5,a3
 1f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fa:	00074683          	lbu	a3,0(a4)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	fef671e3          	bgeu	a2,a5,1e8 <atoi+0x1c>
  return n;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  n = 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <atoi+0x3e>

0000000000000214 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21a:	02b57463          	bgeu	a0,a1,242 <memmove+0x2e>
    while(n-- > 0)
 21e:	00c05f63          	blez	a2,23c <memmove+0x28>
 222:	1602                	slli	a2,a2,0x20
 224:	9201                	srli	a2,a2,0x20
 226:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22a:	872a                	mv	a4,a0
      *dst++ = *src++;
 22c:	0585                	addi	a1,a1,1
 22e:	0705                	addi	a4,a4,1
 230:	fff5c683          	lbu	a3,-1(a1)
 234:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 238:	fef71ae3          	bne	a4,a5,22c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 248:	fec05ae3          	blez	a2,23c <memmove+0x28>
 24c:	fff6079b          	addiw	a5,a2,-1
 250:	1782                	slli	a5,a5,0x20
 252:	9381                	srli	a5,a5,0x20
 254:	fff7c793          	not	a5,a5
 258:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25a:	15fd                	addi	a1,a1,-1
 25c:	177d                	addi	a4,a4,-1
 25e:	0005c683          	lbu	a3,0(a1)
 262:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x46>
 26a:	bfc9                	j	23c <memmove+0x28>

000000000000026c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 272:	ca05                	beqz	a2,2a2 <memcmp+0x36>
 274:	fff6069b          	addiw	a3,a2,-1
 278:	1682                	slli	a3,a3,0x20
 27a:	9281                	srli	a3,a3,0x20
 27c:	0685                	addi	a3,a3,1
 27e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 280:	00054783          	lbu	a5,0(a0)
 284:	0005c703          	lbu	a4,0(a1)
 288:	00e79863          	bne	a5,a4,298 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28c:	0505                	addi	a0,a0,1
    p2++;
 28e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 290:	fed518e3          	bne	a0,a3,280 <memcmp+0x14>
  }
  return 0;
 294:	4501                	li	a0,0
 296:	a019                	j	29c <memcmp+0x30>
      return *p1 - *p2;
 298:	40e7853b          	subw	a0,a5,a4
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <memcmp+0x30>

00000000000002a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ae:	00000097          	auipc	ra,0x0
 2b2:	f66080e7          	jalr	-154(ra) # 214 <memmove>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 366:	1101                	addi	sp,sp,-32
 368:	ec06                	sd	ra,24(sp)
 36a:	e822                	sd	s0,16(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 372:	4605                	li	a2,1
 374:	fef40593          	addi	a1,s0,-17
 378:	00000097          	auipc	ra,0x0
 37c:	f6e080e7          	jalr	-146(ra) # 2e6 <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	addi	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	7139                	addi	sp,sp,-64
 38a:	fc06                	sd	ra,56(sp)
 38c:	f822                	sd	s0,48(sp)
 38e:	f426                	sd	s1,40(sp)
 390:	0080                	addi	s0,sp,64
 392:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 394:	c299                	beqz	a3,39a <printint+0x12>
 396:	0805cb63          	bltz	a1,42c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39a:	2581                	sext.w	a1,a1
  neg = 0;
 39c:	4881                	li	a7,0
 39e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a4:	2601                	sext.w	a2,a2
 3a6:	00000517          	auipc	a0,0x0
 3aa:	55250513          	addi	a0,a0,1362 # 8f8 <digits>
 3ae:	883a                	mv	a6,a4
 3b0:	2705                	addiw	a4,a4,1
 3b2:	02c5f7bb          	remuw	a5,a1,a2
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	97aa                	add	a5,a5,a0
 3bc:	0007c783          	lbu	a5,0(a5)
 3c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c4:	0005879b          	sext.w	a5,a1
 3c8:	02c5d5bb          	divuw	a1,a1,a2
 3cc:	0685                	addi	a3,a3,1
 3ce:	fec7f0e3          	bgeu	a5,a2,3ae <printint+0x26>
  if(neg)
 3d2:	00088c63          	beqz	a7,3ea <printint+0x62>
    buf[i++] = '-';
 3d6:	fd070793          	addi	a5,a4,-48
 3da:	00878733          	add	a4,a5,s0
 3de:	02d00793          	li	a5,45
 3e2:	fef70823          	sb	a5,-16(a4)
 3e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ea:	02e05c63          	blez	a4,422 <printint+0x9a>
 3ee:	f04a                	sd	s2,32(sp)
 3f0:	ec4e                	sd	s3,24(sp)
 3f2:	fc040793          	addi	a5,s0,-64
 3f6:	00e78933          	add	s2,a5,a4
 3fa:	fff78993          	addi	s3,a5,-1
 3fe:	99ba                	add	s3,s3,a4
 400:	377d                	addiw	a4,a4,-1
 402:	1702                	slli	a4,a4,0x20
 404:	9301                	srli	a4,a4,0x20
 406:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40a:	fff94583          	lbu	a1,-1(s2)
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	f56080e7          	jalr	-170(ra) # 366 <putc>
  while(--i >= 0)
 418:	197d                	addi	s2,s2,-1
 41a:	ff3918e3          	bne	s2,s3,40a <printint+0x82>
 41e:	7902                	ld	s2,32(sp)
 420:	69e2                	ld	s3,24(sp)
}
 422:	70e2                	ld	ra,56(sp)
 424:	7442                	ld	s0,48(sp)
 426:	74a2                	ld	s1,40(sp)
 428:	6121                	addi	sp,sp,64
 42a:	8082                	ret
    x = -xx;
 42c:	40b005bb          	negw	a1,a1
    neg = 1;
 430:	4885                	li	a7,1
    x = -xx;
 432:	b7b5                	j	39e <printint+0x16>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	715d                	addi	sp,sp,-80
 436:	e486                	sd	ra,72(sp)
 438:	e0a2                	sd	s0,64(sp)
 43a:	f84a                	sd	s2,48(sp)
 43c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43e:	0005c903          	lbu	s2,0(a1)
 442:	1a090a63          	beqz	s2,5f6 <vprintf+0x1c2>
 446:	fc26                	sd	s1,56(sp)
 448:	f44e                	sd	s3,40(sp)
 44a:	f052                	sd	s4,32(sp)
 44c:	ec56                	sd	s5,24(sp)
 44e:	e85a                	sd	s6,16(sp)
 450:	e45e                	sd	s7,8(sp)
 452:	8aaa                	mv	s5,a0
 454:	8bb2                	mv	s7,a2
 456:	00158493          	addi	s1,a1,1
  state = 0;
 45a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45c:	02500a13          	li	s4,37
 460:	4b55                	li	s6,21
 462:	a839                	j	480 <vprintf+0x4c>
        putc(fd, c);
 464:	85ca                	mv	a1,s2
 466:	8556                	mv	a0,s5
 468:	00000097          	auipc	ra,0x0
 46c:	efe080e7          	jalr	-258(ra) # 366 <putc>
 470:	a019                	j	476 <vprintf+0x42>
    } else if(state == '%'){
 472:	01498d63          	beq	s3,s4,48c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 476:	0485                	addi	s1,s1,1
 478:	fff4c903          	lbu	s2,-1(s1)
 47c:	16090763          	beqz	s2,5ea <vprintf+0x1b6>
    if(state == 0){
 480:	fe0999e3          	bnez	s3,472 <vprintf+0x3e>
      if(c == '%'){
 484:	ff4910e3          	bne	s2,s4,464 <vprintf+0x30>
        state = '%';
 488:	89d2                	mv	s3,s4
 48a:	b7f5                	j	476 <vprintf+0x42>
      if(c == 'd'){
 48c:	13490463          	beq	s2,s4,5b4 <vprintf+0x180>
 490:	f9d9079b          	addiw	a5,s2,-99
 494:	0ff7f793          	zext.b	a5,a5
 498:	12fb6763          	bltu	s6,a5,5c6 <vprintf+0x192>
 49c:	f9d9079b          	addiw	a5,s2,-99
 4a0:	0ff7f713          	zext.b	a4,a5
 4a4:	12eb6163          	bltu	s6,a4,5c6 <vprintf+0x192>
 4a8:	00271793          	slli	a5,a4,0x2
 4ac:	00000717          	auipc	a4,0x0
 4b0:	3f470713          	addi	a4,a4,1012 # 8a0 <statistics+0xba>
 4b4:	97ba                	add	a5,a5,a4
 4b6:	439c                	lw	a5,0(a5)
 4b8:	97ba                	add	a5,a5,a4
 4ba:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4bc:	008b8913          	addi	s2,s7,8
 4c0:	4685                	li	a3,1
 4c2:	4629                	li	a2,10
 4c4:	000ba583          	lw	a1,0(s7)
 4c8:	8556                	mv	a0,s5
 4ca:	00000097          	auipc	ra,0x0
 4ce:	ebe080e7          	jalr	-322(ra) # 388 <printint>
 4d2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	b745                	j	476 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d8:	008b8913          	addi	s2,s7,8
 4dc:	4681                	li	a3,0
 4de:	4629                	li	a2,10
 4e0:	000ba583          	lw	a1,0(s7)
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	ea2080e7          	jalr	-350(ra) # 388 <printint>
 4ee:	8bca                	mv	s7,s2
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b751                	j	476 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4681                	li	a3,0
 4fa:	4641                	li	a2,16
 4fc:	000ba583          	lw	a1,0(s7)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	e86080e7          	jalr	-378(ra) # 388 <printint>
 50a:	8bca                	mv	s7,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	b7a5                	j	476 <vprintf+0x42>
 510:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 512:	008b8c13          	addi	s8,s7,8
 516:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 51a:	03000593          	li	a1,48
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e46080e7          	jalr	-442(ra) # 366 <putc>
  putc(fd, 'x');
 528:	07800593          	li	a1,120
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e38080e7          	jalr	-456(ra) # 366 <putc>
 536:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 538:	00000b97          	auipc	s7,0x0
 53c:	3c0b8b93          	addi	s7,s7,960 # 8f8 <digits>
 540:	03c9d793          	srli	a5,s3,0x3c
 544:	97de                	add	a5,a5,s7
 546:	0007c583          	lbu	a1,0(a5)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	e1a080e7          	jalr	-486(ra) # 366 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 554:	0992                	slli	s3,s3,0x4
 556:	397d                	addiw	s2,s2,-1
 558:	fe0914e3          	bnez	s2,540 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 55c:	8be2                	mv	s7,s8
      state = 0;
 55e:	4981                	li	s3,0
 560:	6c02                	ld	s8,0(sp)
 562:	bf11                	j	476 <vprintf+0x42>
        s = va_arg(ap, char*);
 564:	008b8993          	addi	s3,s7,8
 568:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 56c:	02090163          	beqz	s2,58e <vprintf+0x15a>
        while(*s != 0){
 570:	00094583          	lbu	a1,0(s2)
 574:	c9a5                	beqz	a1,5e4 <vprintf+0x1b0>
          putc(fd, *s);
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	dee080e7          	jalr	-530(ra) # 366 <putc>
          s++;
 580:	0905                	addi	s2,s2,1
        while(*s != 0){
 582:	00094583          	lbu	a1,0(s2)
 586:	f9e5                	bnez	a1,576 <vprintf+0x142>
        s = va_arg(ap, char*);
 588:	8bce                	mv	s7,s3
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b5ed                	j	476 <vprintf+0x42>
          s = "(null)";
 58e:	00000917          	auipc	s2,0x0
 592:	2e290913          	addi	s2,s2,738 # 870 <statistics+0x8a>
        while(*s != 0){
 596:	02800593          	li	a1,40
 59a:	bff1                	j	576 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 59c:	008b8913          	addi	s2,s7,8
 5a0:	000bc583          	lbu	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	dc0080e7          	jalr	-576(ra) # 366 <putc>
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b5d1                	j	476 <vprintf+0x42>
        putc(fd, c);
 5b4:	02500593          	li	a1,37
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dac080e7          	jalr	-596(ra) # 366 <putc>
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bd4d                	j	476 <vprintf+0x42>
        putc(fd, '%');
 5c6:	02500593          	li	a1,37
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	d9a080e7          	jalr	-614(ra) # 366 <putc>
        putc(fd, c);
 5d4:	85ca                	mv	a1,s2
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	d8e080e7          	jalr	-626(ra) # 366 <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bd51                	j	476 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e4:	8bce                	mv	s7,s3
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b579                	j	476 <vprintf+0x42>
 5ea:	74e2                	ld	s1,56(sp)
 5ec:	79a2                	ld	s3,40(sp)
 5ee:	7a02                	ld	s4,32(sp)
 5f0:	6ae2                	ld	s5,24(sp)
 5f2:	6b42                	ld	s6,16(sp)
 5f4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5f6:	60a6                	ld	ra,72(sp)
 5f8:	6406                	ld	s0,64(sp)
 5fa:	7942                	ld	s2,48(sp)
 5fc:	6161                	addi	sp,sp,80
 5fe:	8082                	ret

0000000000000600 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 600:	715d                	addi	sp,sp,-80
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	addi	s0,sp,32
 608:	e010                	sd	a2,0(s0)
 60a:	e414                	sd	a3,8(s0)
 60c:	e818                	sd	a4,16(s0)
 60e:	ec1c                	sd	a5,24(s0)
 610:	03043023          	sd	a6,32(s0)
 614:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 618:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 61c:	8622                	mv	a2,s0
 61e:	00000097          	auipc	ra,0x0
 622:	e16080e7          	jalr	-490(ra) # 434 <vprintf>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6161                	addi	sp,sp,80
 62c:	8082                	ret

000000000000062e <printf>:

void
printf(const char *fmt, ...)
{
 62e:	711d                	addi	sp,sp,-96
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	e40c                	sd	a1,8(s0)
 638:	e810                	sd	a2,16(s0)
 63a:	ec14                	sd	a3,24(s0)
 63c:	f018                	sd	a4,32(s0)
 63e:	f41c                	sd	a5,40(s0)
 640:	03043823          	sd	a6,48(s0)
 644:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 648:	00840613          	addi	a2,s0,8
 64c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 650:	85aa                	mv	a1,a0
 652:	4505                	li	a0,1
 654:	00000097          	auipc	ra,0x0
 658:	de0080e7          	jalr	-544(ra) # 434 <vprintf>
}
 65c:	60e2                	ld	ra,24(sp)
 65e:	6442                	ld	s0,16(sp)
 660:	6125                	addi	sp,sp,96
 662:	8082                	ret

0000000000000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	1141                	addi	sp,sp,-16
 666:	e422                	sd	s0,8(sp)
 668:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	00000797          	auipc	a5,0x0
 672:	6a27b783          	ld	a5,1698(a5) # d10 <freep>
 676:	a02d                	j	6a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 678:	4618                	lw	a4,8(a2)
 67a:	9f2d                	addw	a4,a4,a1
 67c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 680:	6398                	ld	a4,0(a5)
 682:	6310                	ld	a2,0(a4)
 684:	a83d                	j	6c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 686:	ff852703          	lw	a4,-8(a0)
 68a:	9f31                	addw	a4,a4,a2
 68c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 68e:	ff053683          	ld	a3,-16(a0)
 692:	a091                	j	6d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	6398                	ld	a4,0(a5)
 696:	00e7e463          	bltu	a5,a4,69e <free+0x3a>
 69a:	00e6ea63          	bltu	a3,a4,6ae <free+0x4a>
{
 69e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	fed7fae3          	bgeu	a5,a3,694 <free+0x30>
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e6e463          	bltu	a3,a4,6ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	fee7eae3          	bltu	a5,a4,69e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ae:	ff852583          	lw	a1,-8(a0)
 6b2:	6390                	ld	a2,0(a5)
 6b4:	02059813          	slli	a6,a1,0x20
 6b8:	01c85713          	srli	a4,a6,0x1c
 6bc:	9736                	add	a4,a4,a3
 6be:	fae60de3          	beq	a2,a4,678 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c6:	4790                	lw	a2,8(a5)
 6c8:	02061593          	slli	a1,a2,0x20
 6cc:	01c5d713          	srli	a4,a1,0x1c
 6d0:	973e                	add	a4,a4,a5
 6d2:	fae68ae3          	beq	a3,a4,686 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d8:	00000717          	auipc	a4,0x0
 6dc:	62f73c23          	sd	a5,1592(a4) # d10 <freep>
}
 6e0:	6422                	ld	s0,8(sp)
 6e2:	0141                	addi	sp,sp,16
 6e4:	8082                	ret

00000000000006e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e6:	7139                	addi	sp,sp,-64
 6e8:	fc06                	sd	ra,56(sp)
 6ea:	f822                	sd	s0,48(sp)
 6ec:	f426                	sd	s1,40(sp)
 6ee:	ec4e                	sd	s3,24(sp)
 6f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	02051493          	slli	s1,a0,0x20
 6f6:	9081                	srli	s1,s1,0x20
 6f8:	04bd                	addi	s1,s1,15
 6fa:	8091                	srli	s1,s1,0x4
 6fc:	0014899b          	addiw	s3,s1,1
 700:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 702:	00000517          	auipc	a0,0x0
 706:	60e53503          	ld	a0,1550(a0) # d10 <freep>
 70a:	c915                	beqz	a0,73e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 70e:	4798                	lw	a4,8(a5)
 710:	08977e63          	bgeu	a4,s1,7ac <malloc+0xc6>
 714:	f04a                	sd	s2,32(sp)
 716:	e852                	sd	s4,16(sp)
 718:	e456                	sd	s5,8(sp)
 71a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 71c:	8a4e                	mv	s4,s3
 71e:	0009871b          	sext.w	a4,s3
 722:	6685                	lui	a3,0x1
 724:	00d77363          	bgeu	a4,a3,72a <malloc+0x44>
 728:	6a05                	lui	s4,0x1
 72a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 732:	00000917          	auipc	s2,0x0
 736:	5de90913          	addi	s2,s2,1502 # d10 <freep>
  if(p == (char*)-1)
 73a:	5afd                	li	s5,-1
 73c:	a091                	j	780 <malloc+0x9a>
 73e:	f04a                	sd	s2,32(sp)
 740:	e852                	sd	s4,16(sp)
 742:	e456                	sd	s5,8(sp)
 744:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 746:	00001797          	auipc	a5,0x1
 74a:	5d278793          	addi	a5,a5,1490 # 1d18 <base>
 74e:	00000717          	auipc	a4,0x0
 752:	5cf73123          	sd	a5,1474(a4) # d10 <freep>
 756:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 758:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 75c:	b7c1                	j	71c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 75e:	6398                	ld	a4,0(a5)
 760:	e118                	sd	a4,0(a0)
 762:	a08d                	j	7c4 <malloc+0xde>
  hp->s.size = nu;
 764:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 768:	0541                	addi	a0,a0,16
 76a:	00000097          	auipc	ra,0x0
 76e:	efa080e7          	jalr	-262(ra) # 664 <free>
  return freep;
 772:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 776:	c13d                	beqz	a0,7dc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 778:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77a:	4798                	lw	a4,8(a5)
 77c:	02977463          	bgeu	a4,s1,7a4 <malloc+0xbe>
    if(p == freep)
 780:	00093703          	ld	a4,0(s2)
 784:	853e                	mv	a0,a5
 786:	fef719e3          	bne	a4,a5,778 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 78a:	8552                	mv	a0,s4
 78c:	00000097          	auipc	ra,0x0
 790:	bc2080e7          	jalr	-1086(ra) # 34e <sbrk>
  if(p == (char*)-1)
 794:	fd5518e3          	bne	a0,s5,764 <malloc+0x7e>
        return 0;
 798:	4501                	li	a0,0
 79a:	7902                	ld	s2,32(sp)
 79c:	6a42                	ld	s4,16(sp)
 79e:	6aa2                	ld	s5,8(sp)
 7a0:	6b02                	ld	s6,0(sp)
 7a2:	a03d                	j	7d0 <malloc+0xea>
 7a4:	7902                	ld	s2,32(sp)
 7a6:	6a42                	ld	s4,16(sp)
 7a8:	6aa2                	ld	s5,8(sp)
 7aa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ac:	fae489e3          	beq	s1,a4,75e <malloc+0x78>
        p->s.size -= nunits;
 7b0:	4137073b          	subw	a4,a4,s3
 7b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7b6:	02071693          	slli	a3,a4,0x20
 7ba:	01c6d713          	srli	a4,a3,0x1c
 7be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c4:	00000717          	auipc	a4,0x0
 7c8:	54a73623          	sd	a0,1356(a4) # d10 <freep>
      return (void*)(p + 1);
 7cc:	01078513          	addi	a0,a5,16
  }
}
 7d0:	70e2                	ld	ra,56(sp)
 7d2:	7442                	ld	s0,48(sp)
 7d4:	74a2                	ld	s1,40(sp)
 7d6:	69e2                	ld	s3,24(sp)
 7d8:	6121                	addi	sp,sp,64
 7da:	8082                	ret
 7dc:	7902                	ld	s2,32(sp)
 7de:	6a42                	ld	s4,16(sp)
 7e0:	6aa2                	ld	s5,8(sp)
 7e2:	6b02                	ld	s6,0(sp)
 7e4:	b7f5                	j	7d0 <malloc+0xea>

00000000000007e6 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 7e6:	7179                	addi	sp,sp,-48
 7e8:	f406                	sd	ra,40(sp)
 7ea:	f022                	sd	s0,32(sp)
 7ec:	ec26                	sd	s1,24(sp)
 7ee:	e84a                	sd	s2,16(sp)
 7f0:	e44e                	sd	s3,8(sp)
 7f2:	e052                	sd	s4,0(sp)
 7f4:	1800                	addi	s0,sp,48
 7f6:	8a2a                	mv	s4,a0
 7f8:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 7fa:	4581                	li	a1,0
 7fc:	00000517          	auipc	a0,0x0
 800:	07c50513          	addi	a0,a0,124 # 878 <statistics+0x92>
 804:	00000097          	auipc	ra,0x0
 808:	b02080e7          	jalr	-1278(ra) # 306 <open>
  if(fd < 0) {
 80c:	04054263          	bltz	a0,850 <statistics+0x6a>
 810:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 812:	4481                	li	s1,0
 814:	03205063          	blez	s2,834 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 818:	4099063b          	subw	a2,s2,s1
 81c:	009a05b3          	add	a1,s4,s1
 820:	854e                	mv	a0,s3
 822:	00000097          	auipc	ra,0x0
 826:	abc080e7          	jalr	-1348(ra) # 2de <read>
 82a:	00054563          	bltz	a0,834 <statistics+0x4e>
      break;
    }
    i += n;
 82e:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 830:	ff24c4e3          	blt	s1,s2,818 <statistics+0x32>
  }
  close(fd);
 834:	854e                	mv	a0,s3
 836:	00000097          	auipc	ra,0x0
 83a:	ab8080e7          	jalr	-1352(ra) # 2ee <close>
  return i;
}
 83e:	8526                	mv	a0,s1
 840:	70a2                	ld	ra,40(sp)
 842:	7402                	ld	s0,32(sp)
 844:	64e2                	ld	s1,24(sp)
 846:	6942                	ld	s2,16(sp)
 848:	69a2                	ld	s3,8(sp)
 84a:	6a02                	ld	s4,0(sp)
 84c:	6145                	addi	sp,sp,48
 84e:	8082                	ret
      fprintf(2, "stats: open failed\n");
 850:	00000597          	auipc	a1,0x0
 854:	03858593          	addi	a1,a1,56 # 888 <statistics+0xa2>
 858:	4509                	li	a0,2
 85a:	00000097          	auipc	ra,0x0
 85e:	da6080e7          	jalr	-602(ra) # 600 <fprintf>
      exit(1);
 862:	4505                	li	a0,1
 864:	00000097          	auipc	ra,0x0
 868:	a62080e7          	jalr	-1438(ra) # 2c6 <exit>
