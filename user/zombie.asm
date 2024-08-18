
user/_zombie：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	29c080e7          	jalr	668(ra) # 2a4 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	296080e7          	jalr	662(ra) # 2ac <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	31c080e7          	jalr	796(ra) # 33c <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:



char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	86be                	mv	a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x10>
  8c:	40a6853b          	subw	a0,a3,a0
  90:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	1b0080e7          	jalr	432(ra) # 2c4 <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
    buf[i++] = c;
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	00000097          	auipc	ra,0x0
 168:	188080e7          	jalr	392(ra) # 2ec <open>
  if(fd < 0)
 16c:	02054663          	bltz	a0,198 <stat+0x42>
 170:	e426                	sd	s1,8(sp)
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	18e080e7          	jalr	398(ra) # 304 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	152080e7          	jalr	338(ra) # 2d4 <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfcd                	j	18c <stat+0x36>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054683          	lbu	a3,0(a0)
 1a6:	fd06879b          	addiw	a5,a3,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4625                	li	a2,9
 1b0:	02f66863          	bltu	a2,a5,1e0 <atoi+0x44>
 1b4:	872a                	mv	a4,a0
  n = 0;
 1b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b8:	0705                	addi	a4,a4,1
 1ba:	0025179b          	slliw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	slliw	a5,a5,0x1
 1c4:	9fb5                	addw	a5,a5,a3
 1c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	00074683          	lbu	a3,0(a4)
 1ce:	fd06879b          	addiw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	fef671e3          	bgeu	a2,a5,1b8 <atoi+0x1c>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x3e>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ea:	02b57463          	bgeu	a0,a1,212 <memmove+0x2e>
    while(n-- > 0)
 1ee:	00c05f63          	blez	a2,20c <memmove+0x28>
 1f2:	1602                	slli	a2,a2,0x20
 1f4:	9201                	srli	a2,a2,0x20
 1f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	addi	a1,a1,1
 1fe:	0705                	addi	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fef71ae3          	bne	a4,a5,1fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x28>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	addi	a1,a1,-1
 22c:	177d                	addi	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x46>
 23a:	bfc9                	j	20c <memmove+0x28>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addiw	a3,a2,-1
 248:	1682                	slli	a3,a3,0x20
 24a:	9281                	srli	a3,a3,0x20
 24c:	0685                	addi	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	addi	a0,a0,1
    p2++;
 25e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27e:	00000097          	auipc	ra,0x0
 282:	f66080e7          	jalr	-154(ra) # 1e4 <memmove>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 294:	040007b7          	lui	a5,0x4000
 298:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffebd1>
 29a:	07b2                	slli	a5,a5,0xc
}
 29c:	4388                	lw	a0,0(a5)
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a4:	4885                	li	a7,1
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ac:	4889                	li	a7,2
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b4:	488d                	li	a7,3
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2bc:	4891                	li	a7,4
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <read>:
.global read
read:
 li a7, SYS_read
 2c4:	4895                	li	a7,5
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <write>:
.global write
write:
 li a7, SYS_write
 2cc:	48c1                	li	a7,16
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <close>:
.global close
close:
 li a7, SYS_close
 2d4:	48d5                	li	a7,21
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2dc:	4899                	li	a7,6
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e4:	489d                	li	a7,7
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <open>:
.global open
open:
 li a7, SYS_open
 2ec:	48bd                	li	a7,15
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f4:	48c5                	li	a7,17
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fc:	48c9                	li	a7,18
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 304:	48a1                	li	a7,8
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <link>:
.global link
link:
 li a7, SYS_link
 30c:	48cd                	li	a7,19
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 314:	48d1                	li	a7,20
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31c:	48a5                	li	a7,9
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <dup>:
.global dup
dup:
 li a7, SYS_dup
 324:	48a9                	li	a7,10
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32c:	48ad                	li	a7,11
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 334:	48b1                	li	a7,12
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33c:	48b5                	li	a7,13
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 344:	48b9                	li	a7,14
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <connect>:
.global connect
connect:
 li a7, SYS_connect
 34c:	48f5                	li	a7,29
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 354:	48f9                	li	a7,30
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35c:	1101                	addi	sp,sp,-32
 35e:	ec06                	sd	ra,24(sp)
 360:	e822                	sd	s0,16(sp)
 362:	1000                	addi	s0,sp,32
 364:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 368:	4605                	li	a2,1
 36a:	fef40593          	addi	a1,s0,-17
 36e:	00000097          	auipc	ra,0x0
 372:	f5e080e7          	jalr	-162(ra) # 2cc <write>
}
 376:	60e2                	ld	ra,24(sp)
 378:	6442                	ld	s0,16(sp)
 37a:	6105                	addi	sp,sp,32
 37c:	8082                	ret

000000000000037e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37e:	7139                	addi	sp,sp,-64
 380:	fc06                	sd	ra,56(sp)
 382:	f822                	sd	s0,48(sp)
 384:	f426                	sd	s1,40(sp)
 386:	0080                	addi	s0,sp,64
 388:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	c299                	beqz	a3,390 <printint+0x12>
 38c:	0805cb63          	bltz	a1,422 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 390:	2581                	sext.w	a1,a1
  neg = 0;
 392:	4881                	li	a7,0
 394:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 398:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39a:	2601                	sext.w	a2,a2
 39c:	00000517          	auipc	a0,0x0
 3a0:	4a450513          	addi	a0,a0,1188 # 840 <digits>
 3a4:	883a                	mv	a6,a4
 3a6:	2705                	addiw	a4,a4,1
 3a8:	02c5f7bb          	remuw	a5,a1,a2
 3ac:	1782                	slli	a5,a5,0x20
 3ae:	9381                	srli	a5,a5,0x20
 3b0:	97aa                	add	a5,a5,a0
 3b2:	0007c783          	lbu	a5,0(a5)
 3b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ba:	0005879b          	sext.w	a5,a1
 3be:	02c5d5bb          	divuw	a1,a1,a2
 3c2:	0685                	addi	a3,a3,1
 3c4:	fec7f0e3          	bgeu	a5,a2,3a4 <printint+0x26>
  if(neg)
 3c8:	00088c63          	beqz	a7,3e0 <printint+0x62>
    buf[i++] = '-';
 3cc:	fd070793          	addi	a5,a4,-48
 3d0:	00878733          	add	a4,a5,s0
 3d4:	02d00793          	li	a5,45
 3d8:	fef70823          	sb	a5,-16(a4)
 3dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e0:	02e05c63          	blez	a4,418 <printint+0x9a>
 3e4:	f04a                	sd	s2,32(sp)
 3e6:	ec4e                	sd	s3,24(sp)
 3e8:	fc040793          	addi	a5,s0,-64
 3ec:	00e78933          	add	s2,a5,a4
 3f0:	fff78993          	addi	s3,a5,-1
 3f4:	99ba                	add	s3,s3,a4
 3f6:	377d                	addiw	a4,a4,-1
 3f8:	1702                	slli	a4,a4,0x20
 3fa:	9301                	srli	a4,a4,0x20
 3fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 400:	fff94583          	lbu	a1,-1(s2)
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	f56080e7          	jalr	-170(ra) # 35c <putc>
  while(--i >= 0)
 40e:	197d                	addi	s2,s2,-1
 410:	ff3918e3          	bne	s2,s3,400 <printint+0x82>
 414:	7902                	ld	s2,32(sp)
 416:	69e2                	ld	s3,24(sp)
}
 418:	70e2                	ld	ra,56(sp)
 41a:	7442                	ld	s0,48(sp)
 41c:	74a2                	ld	s1,40(sp)
 41e:	6121                	addi	sp,sp,64
 420:	8082                	ret
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4885                	li	a7,1
    x = -xx;
 428:	b7b5                	j	394 <printint+0x16>

000000000000042a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42a:	715d                	addi	sp,sp,-80
 42c:	e486                	sd	ra,72(sp)
 42e:	e0a2                	sd	s0,64(sp)
 430:	f84a                	sd	s2,48(sp)
 432:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 434:	0005c903          	lbu	s2,0(a1)
 438:	1a090a63          	beqz	s2,5ec <vprintf+0x1c2>
 43c:	fc26                	sd	s1,56(sp)
 43e:	f44e                	sd	s3,40(sp)
 440:	f052                	sd	s4,32(sp)
 442:	ec56                	sd	s5,24(sp)
 444:	e85a                	sd	s6,16(sp)
 446:	e45e                	sd	s7,8(sp)
 448:	8aaa                	mv	s5,a0
 44a:	8bb2                	mv	s7,a2
 44c:	00158493          	addi	s1,a1,1
  state = 0;
 450:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 452:	02500a13          	li	s4,37
 456:	4b55                	li	s6,21
 458:	a839                	j	476 <vprintf+0x4c>
        putc(fd, c);
 45a:	85ca                	mv	a1,s2
 45c:	8556                	mv	a0,s5
 45e:	00000097          	auipc	ra,0x0
 462:	efe080e7          	jalr	-258(ra) # 35c <putc>
 466:	a019                	j	46c <vprintf+0x42>
    } else if(state == '%'){
 468:	01498d63          	beq	s3,s4,482 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 46c:	0485                	addi	s1,s1,1
 46e:	fff4c903          	lbu	s2,-1(s1)
 472:	16090763          	beqz	s2,5e0 <vprintf+0x1b6>
    if(state == 0){
 476:	fe0999e3          	bnez	s3,468 <vprintf+0x3e>
      if(c == '%'){
 47a:	ff4910e3          	bne	s2,s4,45a <vprintf+0x30>
        state = '%';
 47e:	89d2                	mv	s3,s4
 480:	b7f5                	j	46c <vprintf+0x42>
      if(c == 'd'){
 482:	13490463          	beq	s2,s4,5aa <vprintf+0x180>
 486:	f9d9079b          	addiw	a5,s2,-99
 48a:	0ff7f793          	zext.b	a5,a5
 48e:	12fb6763          	bltu	s6,a5,5bc <vprintf+0x192>
 492:	f9d9079b          	addiw	a5,s2,-99
 496:	0ff7f713          	zext.b	a4,a5
 49a:	12eb6163          	bltu	s6,a4,5bc <vprintf+0x192>
 49e:	00271793          	slli	a5,a4,0x2
 4a2:	00000717          	auipc	a4,0x0
 4a6:	34670713          	addi	a4,a4,838 # 7e8 <malloc+0x10c>
 4aa:	97ba                	add	a5,a5,a4
 4ac:	439c                	lw	a5,0(a5)
 4ae:	97ba                	add	a5,a5,a4
 4b0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4b2:	008b8913          	addi	s2,s7,8
 4b6:	4685                	li	a3,1
 4b8:	4629                	li	a2,10
 4ba:	000ba583          	lw	a1,0(s7)
 4be:	8556                	mv	a0,s5
 4c0:	00000097          	auipc	ra,0x0
 4c4:	ebe080e7          	jalr	-322(ra) # 37e <printint>
 4c8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ca:	4981                	li	s3,0
 4cc:	b745                	j	46c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ce:	008b8913          	addi	s2,s7,8
 4d2:	4681                	li	a3,0
 4d4:	4629                	li	a2,10
 4d6:	000ba583          	lw	a1,0(s7)
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	ea2080e7          	jalr	-350(ra) # 37e <printint>
 4e4:	8bca                	mv	s7,s2
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	b751                	j	46c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4ea:	008b8913          	addi	s2,s7,8
 4ee:	4681                	li	a3,0
 4f0:	4641                	li	a2,16
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	e86080e7          	jalr	-378(ra) # 37e <printint>
 500:	8bca                	mv	s7,s2
      state = 0;
 502:	4981                	li	s3,0
 504:	b7a5                	j	46c <vprintf+0x42>
 506:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 508:	008b8c13          	addi	s8,s7,8
 50c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 510:	03000593          	li	a1,48
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e46080e7          	jalr	-442(ra) # 35c <putc>
  putc(fd, 'x');
 51e:	07800593          	li	a1,120
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e38080e7          	jalr	-456(ra) # 35c <putc>
 52c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52e:	00000b97          	auipc	s7,0x0
 532:	312b8b93          	addi	s7,s7,786 # 840 <digits>
 536:	03c9d793          	srli	a5,s3,0x3c
 53a:	97de                	add	a5,a5,s7
 53c:	0007c583          	lbu	a1,0(a5)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e1a080e7          	jalr	-486(ra) # 35c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 54a:	0992                	slli	s3,s3,0x4
 54c:	397d                	addiw	s2,s2,-1
 54e:	fe0914e3          	bnez	s2,536 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 552:	8be2                	mv	s7,s8
      state = 0;
 554:	4981                	li	s3,0
 556:	6c02                	ld	s8,0(sp)
 558:	bf11                	j	46c <vprintf+0x42>
        s = va_arg(ap, char*);
 55a:	008b8993          	addi	s3,s7,8
 55e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 562:	02090163          	beqz	s2,584 <vprintf+0x15a>
        while(*s != 0){
 566:	00094583          	lbu	a1,0(s2)
 56a:	c9a5                	beqz	a1,5da <vprintf+0x1b0>
          putc(fd, *s);
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	dee080e7          	jalr	-530(ra) # 35c <putc>
          s++;
 576:	0905                	addi	s2,s2,1
        while(*s != 0){
 578:	00094583          	lbu	a1,0(s2)
 57c:	f9e5                	bnez	a1,56c <vprintf+0x142>
        s = va_arg(ap, char*);
 57e:	8bce                	mv	s7,s3
      state = 0;
 580:	4981                	li	s3,0
 582:	b5ed                	j	46c <vprintf+0x42>
          s = "(null)";
 584:	00000917          	auipc	s2,0x0
 588:	25c90913          	addi	s2,s2,604 # 7e0 <malloc+0x104>
        while(*s != 0){
 58c:	02800593          	li	a1,40
 590:	bff1                	j	56c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 592:	008b8913          	addi	s2,s7,8
 596:	000bc583          	lbu	a1,0(s7)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	dc0080e7          	jalr	-576(ra) # 35c <putc>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b5d1                	j	46c <vprintf+0x42>
        putc(fd, c);
 5aa:	02500593          	li	a1,37
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	dac080e7          	jalr	-596(ra) # 35c <putc>
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bd4d                	j	46c <vprintf+0x42>
        putc(fd, '%');
 5bc:	02500593          	li	a1,37
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	d9a080e7          	jalr	-614(ra) # 35c <putc>
        putc(fd, c);
 5ca:	85ca                	mv	a1,s2
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	d8e080e7          	jalr	-626(ra) # 35c <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd51                	j	46c <vprintf+0x42>
        s = va_arg(ap, char*);
 5da:	8bce                	mv	s7,s3
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b579                	j	46c <vprintf+0x42>
 5e0:	74e2                	ld	s1,56(sp)
 5e2:	79a2                	ld	s3,40(sp)
 5e4:	7a02                	ld	s4,32(sp)
 5e6:	6ae2                	ld	s5,24(sp)
 5e8:	6b42                	ld	s6,16(sp)
 5ea:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5ec:	60a6                	ld	ra,72(sp)
 5ee:	6406                	ld	s0,64(sp)
 5f0:	7942                	ld	s2,48(sp)
 5f2:	6161                	addi	sp,sp,80
 5f4:	8082                	ret

00000000000005f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5f6:	715d                	addi	sp,sp,-80
 5f8:	ec06                	sd	ra,24(sp)
 5fa:	e822                	sd	s0,16(sp)
 5fc:	1000                	addi	s0,sp,32
 5fe:	e010                	sd	a2,0(s0)
 600:	e414                	sd	a3,8(s0)
 602:	e818                	sd	a4,16(s0)
 604:	ec1c                	sd	a5,24(s0)
 606:	03043023          	sd	a6,32(s0)
 60a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 60e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 612:	8622                	mv	a2,s0
 614:	00000097          	auipc	ra,0x0
 618:	e16080e7          	jalr	-490(ra) # 42a <vprintf>
}
 61c:	60e2                	ld	ra,24(sp)
 61e:	6442                	ld	s0,16(sp)
 620:	6161                	addi	sp,sp,80
 622:	8082                	ret

0000000000000624 <printf>:

void
printf(const char *fmt, ...)
{
 624:	711d                	addi	sp,sp,-96
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	addi	s0,sp,32
 62c:	e40c                	sd	a1,8(s0)
 62e:	e810                	sd	a2,16(s0)
 630:	ec14                	sd	a3,24(s0)
 632:	f018                	sd	a4,32(s0)
 634:	f41c                	sd	a5,40(s0)
 636:	03043823          	sd	a6,48(s0)
 63a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 63e:	00840613          	addi	a2,s0,8
 642:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 646:	85aa                	mv	a1,a0
 648:	4505                	li	a0,1
 64a:	00000097          	auipc	ra,0x0
 64e:	de0080e7          	jalr	-544(ra) # 42a <vprintf>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6125                	addi	sp,sp,96
 658:	8082                	ret

000000000000065a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65a:	1141                	addi	sp,sp,-16
 65c:	e422                	sd	s0,8(sp)
 65e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	00000797          	auipc	a5,0x0
 668:	5cc7b783          	ld	a5,1484(a5) # c30 <freep>
 66c:	a02d                	j	696 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 66e:	4618                	lw	a4,8(a2)
 670:	9f2d                	addw	a4,a4,a1
 672:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	6398                	ld	a4,0(a5)
 678:	6310                	ld	a2,0(a4)
 67a:	a83d                	j	6b8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 67c:	ff852703          	lw	a4,-8(a0)
 680:	9f31                	addw	a4,a4,a2
 682:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 684:	ff053683          	ld	a3,-16(a0)
 688:	a091                	j	6cc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	6398                	ld	a4,0(a5)
 68c:	00e7e463          	bltu	a5,a4,694 <free+0x3a>
 690:	00e6ea63          	bltu	a3,a4,6a4 <free+0x4a>
{
 694:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	fed7fae3          	bgeu	a5,a3,68a <free+0x30>
 69a:	6398                	ld	a4,0(a5)
 69c:	00e6e463          	bltu	a3,a4,6a4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	fee7eae3          	bltu	a5,a4,694 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6a4:	ff852583          	lw	a1,-8(a0)
 6a8:	6390                	ld	a2,0(a5)
 6aa:	02059813          	slli	a6,a1,0x20
 6ae:	01c85713          	srli	a4,a6,0x1c
 6b2:	9736                	add	a4,a4,a3
 6b4:	fae60de3          	beq	a2,a4,66e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6bc:	4790                	lw	a2,8(a5)
 6be:	02061593          	slli	a1,a2,0x20
 6c2:	01c5d713          	srli	a4,a1,0x1c
 6c6:	973e                	add	a4,a4,a5
 6c8:	fae68ae3          	beq	a3,a4,67c <free+0x22>
    p->s.ptr = bp->s.ptr;
 6cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6ce:	00000717          	auipc	a4,0x0
 6d2:	56f73123          	sd	a5,1378(a4) # c30 <freep>
}
 6d6:	6422                	ld	s0,8(sp)
 6d8:	0141                	addi	sp,sp,16
 6da:	8082                	ret

00000000000006dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6dc:	7139                	addi	sp,sp,-64
 6de:	fc06                	sd	ra,56(sp)
 6e0:	f822                	sd	s0,48(sp)
 6e2:	f426                	sd	s1,40(sp)
 6e4:	ec4e                	sd	s3,24(sp)
 6e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e8:	02051493          	slli	s1,a0,0x20
 6ec:	9081                	srli	s1,s1,0x20
 6ee:	04bd                	addi	s1,s1,15
 6f0:	8091                	srli	s1,s1,0x4
 6f2:	0014899b          	addiw	s3,s1,1
 6f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6f8:	00000517          	auipc	a0,0x0
 6fc:	53853503          	ld	a0,1336(a0) # c30 <freep>
 700:	c915                	beqz	a0,734 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 702:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 704:	4798                	lw	a4,8(a5)
 706:	08977e63          	bgeu	a4,s1,7a2 <malloc+0xc6>
 70a:	f04a                	sd	s2,32(sp)
 70c:	e852                	sd	s4,16(sp)
 70e:	e456                	sd	s5,8(sp)
 710:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 712:	8a4e                	mv	s4,s3
 714:	0009871b          	sext.w	a4,s3
 718:	6685                	lui	a3,0x1
 71a:	00d77363          	bgeu	a4,a3,720 <malloc+0x44>
 71e:	6a05                	lui	s4,0x1
 720:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 724:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 728:	00000917          	auipc	s2,0x0
 72c:	50890913          	addi	s2,s2,1288 # c30 <freep>
  if(p == (char*)-1)
 730:	5afd                	li	s5,-1
 732:	a091                	j	776 <malloc+0x9a>
 734:	f04a                	sd	s2,32(sp)
 736:	e852                	sd	s4,16(sp)
 738:	e456                	sd	s5,8(sp)
 73a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 73c:	00000797          	auipc	a5,0x0
 740:	4fc78793          	addi	a5,a5,1276 # c38 <base>
 744:	00000717          	auipc	a4,0x0
 748:	4ef73623          	sd	a5,1260(a4) # c30 <freep>
 74c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 752:	b7c1                	j	712 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	e118                	sd	a4,0(a0)
 758:	a08d                	j	7ba <malloc+0xde>
  hp->s.size = nu;
 75a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 75e:	0541                	addi	a0,a0,16
 760:	00000097          	auipc	ra,0x0
 764:	efa080e7          	jalr	-262(ra) # 65a <free>
  return freep;
 768:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 76c:	c13d                	beqz	a0,7d2 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 770:	4798                	lw	a4,8(a5)
 772:	02977463          	bgeu	a4,s1,79a <malloc+0xbe>
    if(p == freep)
 776:	00093703          	ld	a4,0(s2)
 77a:	853e                	mv	a0,a5
 77c:	fef719e3          	bne	a4,a5,76e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 780:	8552                	mv	a0,s4
 782:	00000097          	auipc	ra,0x0
 786:	bb2080e7          	jalr	-1102(ra) # 334 <sbrk>
  if(p == (char*)-1)
 78a:	fd5518e3          	bne	a0,s5,75a <malloc+0x7e>
        return 0;
 78e:	4501                	li	a0,0
 790:	7902                	ld	s2,32(sp)
 792:	6a42                	ld	s4,16(sp)
 794:	6aa2                	ld	s5,8(sp)
 796:	6b02                	ld	s6,0(sp)
 798:	a03d                	j	7c6 <malloc+0xea>
 79a:	7902                	ld	s2,32(sp)
 79c:	6a42                	ld	s4,16(sp)
 79e:	6aa2                	ld	s5,8(sp)
 7a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7a2:	fae489e3          	beq	s1,a4,754 <malloc+0x78>
        p->s.size -= nunits;
 7a6:	4137073b          	subw	a4,a4,s3
 7aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ac:	02071693          	slli	a3,a4,0x20
 7b0:	01c6d713          	srli	a4,a3,0x1c
 7b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ba:	00000717          	auipc	a4,0x0
 7be:	46a73b23          	sd	a0,1142(a4) # c30 <freep>
      return (void*)(p + 1);
 7c2:	01078513          	addi	a0,a5,16
  }
}
 7c6:	70e2                	ld	ra,56(sp)
 7c8:	7442                	ld	s0,48(sp)
 7ca:	74a2                	ld	s1,40(sp)
 7cc:	69e2                	ld	s3,24(sp)
 7ce:	6121                	addi	sp,sp,64
 7d0:	8082                	ret
 7d2:	7902                	ld	s2,32(sp)
 7d4:	6a42                	ld	s4,16(sp)
 7d6:	6aa2                	ld	s5,8(sp)
 7d8:	6b02                	ld	s6,0(sp)
 7da:	b7f5                	j	7c6 <malloc+0xea>
