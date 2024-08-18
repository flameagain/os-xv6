
user/_mkdir：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	33c080e7          	jalr	828(ra) # 364 <mkdir>
  30:	02054663          	bltz	a0,5c <main+0x5c>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a81d                	j	70 <main+0x70>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00000597          	auipc	a1,0x0
  44:	7f058593          	addi	a1,a1,2032 # 830 <malloc+0x104>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	5fc080e7          	jalr	1532(ra) # 646 <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	2a8080e7          	jalr	680(ra) # 2fc <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5c:	6090                	ld	a2,0(s1)
  5e:	00000597          	auipc	a1,0x0
  62:	7ea58593          	addi	a1,a1,2026 # 848 <malloc+0x11c>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	5de080e7          	jalr	1502(ra) # 646 <fprintf>
      break;
    }
  }

  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	28a080e7          	jalr	650(ra) # 2fc <exit>

000000000000007a <strcpy>:



char*
strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0x8>
    ;
  return os;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cb91                	beqz	a5,b4 <strcmp+0x1e>
  a2:	0005c703          	lbu	a4,0(a1)
  a6:	00f71763          	bne	a4,a5,b4 <strcmp+0x1e>
    p++, q++;
  aa:	0505                	addi	a0,a0,1
  ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	fbe5                	bnez	a5,a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b4:	0005c503          	lbu	a0,0(a1)
}
  b8:	40a7853b          	subw	a0,a5,a0
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strlen>:

uint
strlen(const char *s)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf91                	beqz	a5,e8 <strlen+0x26>
  ce:	0505                	addi	a0,a0,1
  d0:	87aa                	mv	a5,a0
  d2:	86be                	mv	a3,a5
  d4:	0785                	addi	a5,a5,1
  d6:	fff7c703          	lbu	a4,-1(a5)
  da:	ff65                	bnez	a4,d2 <strlen+0x10>
  dc:	40a6853b          	subw	a0,a3,a0
  e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  for(n = 0; s[n]; n++)
  e8:	4501                	li	a0,0
  ea:	bfe5                	j	e2 <strlen+0x20>

00000000000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e422                	sd	s0,8(sp)
  f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f2:	ca19                	beqz	a2,108 <memset+0x1c>
  f4:	87aa                	mv	a5,a0
  f6:	1602                	slli	a2,a2,0x20
  f8:	9201                	srli	a2,a2,0x20
  fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x12>
  }
  return dst;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strchr>:

char*
strchr(const char *s, char c)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  for(; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cb99                	beqz	a5,12e <strchr+0x20>
    if(*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1a>
  for(; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xc>
      return (char*)s;
  return 0;
 126:	4501                	li	a0,0
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret
  return 0;
 12e:	4501                	li	a0,0
 130:	bfe5                	j	128 <strchr+0x1a>

0000000000000132 <gets>:

char*
gets(char *buf, int max)
{
 132:	711d                	addi	sp,sp,-96
 134:	ec86                	sd	ra,88(sp)
 136:	e8a2                	sd	s0,80(sp)
 138:	e4a6                	sd	s1,72(sp)
 13a:	e0ca                	sd	s2,64(sp)
 13c:	fc4e                	sd	s3,56(sp)
 13e:	f852                	sd	s4,48(sp)
 140:	f456                	sd	s5,40(sp)
 142:	f05a                	sd	s6,32(sp)
 144:	ec5e                	sd	s7,24(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 150:	4aa9                	li	s5,10
 152:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 154:	89a6                	mv	s3,s1
 156:	2485                	addiw	s1,s1,1
 158:	0344d863          	bge	s1,s4,188 <gets+0x56>
    cc = read(0, &c, 1);
 15c:	4605                	li	a2,1
 15e:	faf40593          	addi	a1,s0,-81
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	1b0080e7          	jalr	432(ra) # 314 <read>
    if(cc < 1)
 16c:	00a05e63          	blez	a0,188 <gets+0x56>
    buf[i++] = c;
 170:	faf44783          	lbu	a5,-81(s0)
 174:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 178:	01578763          	beq	a5,s5,186 <gets+0x54>
 17c:	0905                	addi	s2,s2,1
 17e:	fd679be3          	bne	a5,s6,154 <gets+0x22>
    buf[i++] = c;
 182:	89a6                	mv	s3,s1
 184:	a011                	j	188 <gets+0x56>
 186:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 188:	99de                	add	s3,s3,s7
 18a:	00098023          	sb	zero,0(s3)
  return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6125                	addi	sp,sp,96
 1a4:	8082                	ret

00000000000001a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	188080e7          	jalr	392(ra) # 33c <open>
  if(fd < 0)
 1bc:	02054663          	bltz	a0,1e8 <stat+0x42>
 1c0:	e426                	sd	s1,8(sp)
 1c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c4:	85ca                	mv	a1,s2
 1c6:	00000097          	auipc	ra,0x0
 1ca:	18e080e7          	jalr	398(ra) # 354 <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	152080e7          	jalr	338(ra) # 324 <close>
  return r;
 1da:	64a2                	ld	s1,8(sp)
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfcd                	j	1dc <stat+0x36>

00000000000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66863          	bltu	a2,a5,230 <atoi+0x44>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1c>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x3e>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fef71ae3          	bne	a4,a5,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 2e4:	040007b7          	lui	a5,0x4000
 2e8:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffeb41>
 2ea:	07b2                	slli	a5,a5,0xc
}
 2ec:	4388                	lw	a0,0(a5)
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f4:	4885                	li	a7,1
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fc:	4889                	li	a7,2
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <wait>:
.global wait
wait:
 li a7, SYS_wait
 304:	488d                	li	a7,3
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30c:	4891                	li	a7,4
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <read>:
.global read
read:
 li a7, SYS_read
 314:	4895                	li	a7,5
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <write>:
.global write
write:
 li a7, SYS_write
 31c:	48c1                	li	a7,16
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <close>:
.global close
close:
 li a7, SYS_close
 324:	48d5                	li	a7,21
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <kill>:
.global kill
kill:
 li a7, SYS_kill
 32c:	4899                	li	a7,6
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exec>:
.global exec
exec:
 li a7, SYS_exec
 334:	489d                	li	a7,7
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <open>:
.global open
open:
 li a7, SYS_open
 33c:	48bd                	li	a7,15
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 344:	48c5                	li	a7,17
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34c:	48c9                	li	a7,18
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 354:	48a1                	li	a7,8
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <link>:
.global link
link:
 li a7, SYS_link
 35c:	48cd                	li	a7,19
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 364:	48d1                	li	a7,20
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36c:	48a5                	li	a7,9
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <dup>:
.global dup
dup:
 li a7, SYS_dup
 374:	48a9                	li	a7,10
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37c:	48ad                	li	a7,11
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 384:	48b1                	li	a7,12
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38c:	48b5                	li	a7,13
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 394:	48b9                	li	a7,14
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <connect>:
.global connect
connect:
 li a7, SYS_connect
 39c:	48f5                	li	a7,29
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 3a4:	48f9                	li	a7,30
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	00000097          	auipc	ra,0x0
 3c2:	f5e080e7          	jalr	-162(ra) # 31c <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	7139                	addi	sp,sp,-64
 3d0:	fc06                	sd	ra,56(sp)
 3d2:	f822                	sd	s0,48(sp)
 3d4:	f426                	sd	s1,40(sp)
 3d6:	0080                	addi	s0,sp,64
 3d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	c299                	beqz	a3,3e0 <printint+0x12>
 3dc:	0805cb63          	bltz	a1,472 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e0:	2581                	sext.w	a1,a1
  neg = 0;
 3e2:	4881                	li	a7,0
 3e4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ea:	2601                	sext.w	a2,a2
 3ec:	00000517          	auipc	a0,0x0
 3f0:	4dc50513          	addi	a0,a0,1244 # 8c8 <digits>
 3f4:	883a                	mv	a6,a4
 3f6:	2705                	addiw	a4,a4,1
 3f8:	02c5f7bb          	remuw	a5,a1,a2
 3fc:	1782                	slli	a5,a5,0x20
 3fe:	9381                	srli	a5,a5,0x20
 400:	97aa                	add	a5,a5,a0
 402:	0007c783          	lbu	a5,0(a5)
 406:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40a:	0005879b          	sext.w	a5,a1
 40e:	02c5d5bb          	divuw	a1,a1,a2
 412:	0685                	addi	a3,a3,1
 414:	fec7f0e3          	bgeu	a5,a2,3f4 <printint+0x26>
  if(neg)
 418:	00088c63          	beqz	a7,430 <printint+0x62>
    buf[i++] = '-';
 41c:	fd070793          	addi	a5,a4,-48
 420:	00878733          	add	a4,a5,s0
 424:	02d00793          	li	a5,45
 428:	fef70823          	sb	a5,-16(a4)
 42c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 430:	02e05c63          	blez	a4,468 <printint+0x9a>
 434:	f04a                	sd	s2,32(sp)
 436:	ec4e                	sd	s3,24(sp)
 438:	fc040793          	addi	a5,s0,-64
 43c:	00e78933          	add	s2,a5,a4
 440:	fff78993          	addi	s3,a5,-1
 444:	99ba                	add	s3,s3,a4
 446:	377d                	addiw	a4,a4,-1
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	fff94583          	lbu	a1,-1(s2)
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	f56080e7          	jalr	-170(ra) # 3ac <putc>
  while(--i >= 0)
 45e:	197d                	addi	s2,s2,-1
 460:	ff3918e3          	bne	s2,s3,450 <printint+0x82>
 464:	7902                	ld	s2,32(sp)
 466:	69e2                	ld	s3,24(sp)
}
 468:	70e2                	ld	ra,56(sp)
 46a:	7442                	ld	s0,48(sp)
 46c:	74a2                	ld	s1,40(sp)
 46e:	6121                	addi	sp,sp,64
 470:	8082                	ret
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4885                	li	a7,1
    x = -xx;
 478:	b7b5                	j	3e4 <printint+0x16>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	715d                	addi	sp,sp,-80
 47c:	e486                	sd	ra,72(sp)
 47e:	e0a2                	sd	s0,64(sp)
 480:	f84a                	sd	s2,48(sp)
 482:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c903          	lbu	s2,0(a1)
 488:	1a090a63          	beqz	s2,63c <vprintf+0x1c2>
 48c:	fc26                	sd	s1,56(sp)
 48e:	f44e                	sd	s3,40(sp)
 490:	f052                	sd	s4,32(sp)
 492:	ec56                	sd	s5,24(sp)
 494:	e85a                	sd	s6,16(sp)
 496:	e45e                	sd	s7,8(sp)
 498:	8aaa                	mv	s5,a0
 49a:	8bb2                	mv	s7,a2
 49c:	00158493          	addi	s1,a1,1
  state = 0;
 4a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a2:	02500a13          	li	s4,37
 4a6:	4b55                	li	s6,21
 4a8:	a839                	j	4c6 <vprintf+0x4c>
        putc(fd, c);
 4aa:	85ca                	mv	a1,s2
 4ac:	8556                	mv	a0,s5
 4ae:	00000097          	auipc	ra,0x0
 4b2:	efe080e7          	jalr	-258(ra) # 3ac <putc>
 4b6:	a019                	j	4bc <vprintf+0x42>
    } else if(state == '%'){
 4b8:	01498d63          	beq	s3,s4,4d2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4bc:	0485                	addi	s1,s1,1
 4be:	fff4c903          	lbu	s2,-1(s1)
 4c2:	16090763          	beqz	s2,630 <vprintf+0x1b6>
    if(state == 0){
 4c6:	fe0999e3          	bnez	s3,4b8 <vprintf+0x3e>
      if(c == '%'){
 4ca:	ff4910e3          	bne	s2,s4,4aa <vprintf+0x30>
        state = '%';
 4ce:	89d2                	mv	s3,s4
 4d0:	b7f5                	j	4bc <vprintf+0x42>
      if(c == 'd'){
 4d2:	13490463          	beq	s2,s4,5fa <vprintf+0x180>
 4d6:	f9d9079b          	addiw	a5,s2,-99
 4da:	0ff7f793          	zext.b	a5,a5
 4de:	12fb6763          	bltu	s6,a5,60c <vprintf+0x192>
 4e2:	f9d9079b          	addiw	a5,s2,-99
 4e6:	0ff7f713          	zext.b	a4,a5
 4ea:	12eb6163          	bltu	s6,a4,60c <vprintf+0x192>
 4ee:	00271793          	slli	a5,a4,0x2
 4f2:	00000717          	auipc	a4,0x0
 4f6:	37e70713          	addi	a4,a4,894 # 870 <malloc+0x144>
 4fa:	97ba                	add	a5,a5,a4
 4fc:	439c                	lw	a5,0(a5)
 4fe:	97ba                	add	a5,a5,a4
 500:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 502:	008b8913          	addi	s2,s7,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000ba583          	lw	a1,0(s7)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	ebe080e7          	jalr	-322(ra) # 3ce <printint>
 518:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b745                	j	4bc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51e:	008b8913          	addi	s2,s7,8
 522:	4681                	li	a3,0
 524:	4629                	li	a2,10
 526:	000ba583          	lw	a1,0(s7)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	ea2080e7          	jalr	-350(ra) # 3ce <printint>
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
 538:	b751                	j	4bc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4681                	li	a3,0
 540:	4641                	li	a2,16
 542:	000ba583          	lw	a1,0(s7)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e86080e7          	jalr	-378(ra) # 3ce <printint>
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	b7a5                	j	4bc <vprintf+0x42>
 556:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 558:	008b8c13          	addi	s8,s7,8
 55c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 560:	03000593          	li	a1,48
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e46080e7          	jalr	-442(ra) # 3ac <putc>
  putc(fd, 'x');
 56e:	07800593          	li	a1,120
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e38080e7          	jalr	-456(ra) # 3ac <putc>
 57c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57e:	00000b97          	auipc	s7,0x0
 582:	34ab8b93          	addi	s7,s7,842 # 8c8 <digits>
 586:	03c9d793          	srli	a5,s3,0x3c
 58a:	97de                	add	a5,a5,s7
 58c:	0007c583          	lbu	a1,0(a5)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e1a080e7          	jalr	-486(ra) # 3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 59a:	0992                	slli	s3,s3,0x4
 59c:	397d                	addiw	s2,s2,-1
 59e:	fe0914e3          	bnez	s2,586 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5a2:	8be2                	mv	s7,s8
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	6c02                	ld	s8,0(sp)
 5a8:	bf11                	j	4bc <vprintf+0x42>
        s = va_arg(ap, char*);
 5aa:	008b8993          	addi	s3,s7,8
 5ae:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5b2:	02090163          	beqz	s2,5d4 <vprintf+0x15a>
        while(*s != 0){
 5b6:	00094583          	lbu	a1,0(s2)
 5ba:	c9a5                	beqz	a1,62a <vprintf+0x1b0>
          putc(fd, *s);
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	dee080e7          	jalr	-530(ra) # 3ac <putc>
          s++;
 5c6:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c8:	00094583          	lbu	a1,0(s2)
 5cc:	f9e5                	bnez	a1,5bc <vprintf+0x142>
        s = va_arg(ap, char*);
 5ce:	8bce                	mv	s7,s3
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b5ed                	j	4bc <vprintf+0x42>
          s = "(null)";
 5d4:	00000917          	auipc	s2,0x0
 5d8:	29490913          	addi	s2,s2,660 # 868 <malloc+0x13c>
        while(*s != 0){
 5dc:	02800593          	li	a1,40
 5e0:	bff1                	j	5bc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	000bc583          	lbu	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dc0080e7          	jalr	-576(ra) # 3ac <putc>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b5d1                	j	4bc <vprintf+0x42>
        putc(fd, c);
 5fa:	02500593          	li	a1,37
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dac080e7          	jalr	-596(ra) # 3ac <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bd4d                	j	4bc <vprintf+0x42>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	d9a080e7          	jalr	-614(ra) # 3ac <putc>
        putc(fd, c);
 61a:	85ca                	mv	a1,s2
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d8e080e7          	jalr	-626(ra) # 3ac <putc>
      state = 0;
 626:	4981                	li	s3,0
 628:	bd51                	j	4bc <vprintf+0x42>
        s = va_arg(ap, char*);
 62a:	8bce                	mv	s7,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b579                	j	4bc <vprintf+0x42>
 630:	74e2                	ld	s1,56(sp)
 632:	79a2                	ld	s3,40(sp)
 634:	7a02                	ld	s4,32(sp)
 636:	6ae2                	ld	s5,24(sp)
 638:	6b42                	ld	s6,16(sp)
 63a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 63c:	60a6                	ld	ra,72(sp)
 63e:	6406                	ld	s0,64(sp)
 640:	7942                	ld	s2,48(sp)
 642:	6161                	addi	sp,sp,80
 644:	8082                	ret

0000000000000646 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 646:	715d                	addi	sp,sp,-80
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	e010                	sd	a2,0(s0)
 650:	e414                	sd	a3,8(s0)
 652:	e818                	sd	a4,16(s0)
 654:	ec1c                	sd	a5,24(s0)
 656:	03043023          	sd	a6,32(s0)
 65a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 662:	8622                	mv	a2,s0
 664:	00000097          	auipc	ra,0x0
 668:	e16080e7          	jalr	-490(ra) # 47a <vprintf>
}
 66c:	60e2                	ld	ra,24(sp)
 66e:	6442                	ld	s0,16(sp)
 670:	6161                	addi	sp,sp,80
 672:	8082                	ret

0000000000000674 <printf>:

void
printf(const char *fmt, ...)
{
 674:	711d                	addi	sp,sp,-96
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	addi	s0,sp,32
 67c:	e40c                	sd	a1,8(s0)
 67e:	e810                	sd	a2,16(s0)
 680:	ec14                	sd	a3,24(s0)
 682:	f018                	sd	a4,32(s0)
 684:	f41c                	sd	a5,40(s0)
 686:	03043823          	sd	a6,48(s0)
 68a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	00840613          	addi	a2,s0,8
 692:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 696:	85aa                	mv	a1,a0
 698:	4505                	li	a0,1
 69a:	00000097          	auipc	ra,0x0
 69e:	de0080e7          	jalr	-544(ra) # 47a <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6125                	addi	sp,sp,96
 6a8:	8082                	ret

00000000000006aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e422                	sd	s0,8(sp)
 6ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b4:	00000797          	auipc	a5,0x0
 6b8:	60c7b783          	ld	a5,1548(a5) # cc0 <freep>
 6bc:	a02d                	j	6e6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6be:	4618                	lw	a4,8(a2)
 6c0:	9f2d                	addw	a4,a4,a1
 6c2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	6398                	ld	a4,0(a5)
 6c8:	6310                	ld	a2,0(a4)
 6ca:	a83d                	j	708 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6cc:	ff852703          	lw	a4,-8(a0)
 6d0:	9f31                	addw	a4,a4,a2
 6d2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d4:	ff053683          	ld	a3,-16(a0)
 6d8:	a091                	j	71c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e7e463          	bltu	a5,a4,6e4 <free+0x3a>
 6e0:	00e6ea63          	bltu	a3,a4,6f4 <free+0x4a>
{
 6e4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	fed7fae3          	bgeu	a5,a3,6da <free+0x30>
 6ea:	6398                	ld	a4,0(a5)
 6ec:	00e6e463          	bltu	a3,a4,6f4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	fee7eae3          	bltu	a5,a4,6e4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6f4:	ff852583          	lw	a1,-8(a0)
 6f8:	6390                	ld	a2,0(a5)
 6fa:	02059813          	slli	a6,a1,0x20
 6fe:	01c85713          	srli	a4,a6,0x1c
 702:	9736                	add	a4,a4,a3
 704:	fae60de3          	beq	a2,a4,6be <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 70c:	4790                	lw	a2,8(a5)
 70e:	02061593          	slli	a1,a2,0x20
 712:	01c5d713          	srli	a4,a1,0x1c
 716:	973e                	add	a4,a4,a5
 718:	fae68ae3          	beq	a3,a4,6cc <free+0x22>
    p->s.ptr = bp->s.ptr;
 71c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 71e:	00000717          	auipc	a4,0x0
 722:	5af73123          	sd	a5,1442(a4) # cc0 <freep>
}
 726:	6422                	ld	s0,8(sp)
 728:	0141                	addi	sp,sp,16
 72a:	8082                	ret

000000000000072c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 72c:	7139                	addi	sp,sp,-64
 72e:	fc06                	sd	ra,56(sp)
 730:	f822                	sd	s0,48(sp)
 732:	f426                	sd	s1,40(sp)
 734:	ec4e                	sd	s3,24(sp)
 736:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 738:	02051493          	slli	s1,a0,0x20
 73c:	9081                	srli	s1,s1,0x20
 73e:	04bd                	addi	s1,s1,15
 740:	8091                	srli	s1,s1,0x4
 742:	0014899b          	addiw	s3,s1,1
 746:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 748:	00000517          	auipc	a0,0x0
 74c:	57853503          	ld	a0,1400(a0) # cc0 <freep>
 750:	c915                	beqz	a0,784 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 754:	4798                	lw	a4,8(a5)
 756:	08977e63          	bgeu	a4,s1,7f2 <malloc+0xc6>
 75a:	f04a                	sd	s2,32(sp)
 75c:	e852                	sd	s4,16(sp)
 75e:	e456                	sd	s5,8(sp)
 760:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 762:	8a4e                	mv	s4,s3
 764:	0009871b          	sext.w	a4,s3
 768:	6685                	lui	a3,0x1
 76a:	00d77363          	bgeu	a4,a3,770 <malloc+0x44>
 76e:	6a05                	lui	s4,0x1
 770:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 774:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 778:	00000917          	auipc	s2,0x0
 77c:	54890913          	addi	s2,s2,1352 # cc0 <freep>
  if(p == (char*)-1)
 780:	5afd                	li	s5,-1
 782:	a091                	j	7c6 <malloc+0x9a>
 784:	f04a                	sd	s2,32(sp)
 786:	e852                	sd	s4,16(sp)
 788:	e456                	sd	s5,8(sp)
 78a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 78c:	00000797          	auipc	a5,0x0
 790:	53c78793          	addi	a5,a5,1340 # cc8 <base>
 794:	00000717          	auipc	a4,0x0
 798:	52f73623          	sd	a5,1324(a4) # cc0 <freep>
 79c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a2:	b7c1                	j	762 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	e118                	sd	a4,0(a0)
 7a8:	a08d                	j	80a <malloc+0xde>
  hp->s.size = nu;
 7aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ae:	0541                	addi	a0,a0,16
 7b0:	00000097          	auipc	ra,0x0
 7b4:	efa080e7          	jalr	-262(ra) # 6aa <free>
  return freep;
 7b8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7bc:	c13d                	beqz	a0,822 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	02977463          	bgeu	a4,s1,7ea <malloc+0xbe>
    if(p == freep)
 7c6:	00093703          	ld	a4,0(s2)
 7ca:	853e                	mv	a0,a5
 7cc:	fef719e3          	bne	a4,a5,7be <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7d0:	8552                	mv	a0,s4
 7d2:	00000097          	auipc	ra,0x0
 7d6:	bb2080e7          	jalr	-1102(ra) # 384 <sbrk>
  if(p == (char*)-1)
 7da:	fd5518e3          	bne	a0,s5,7aa <malloc+0x7e>
        return 0;
 7de:	4501                	li	a0,0
 7e0:	7902                	ld	s2,32(sp)
 7e2:	6a42                	ld	s4,16(sp)
 7e4:	6aa2                	ld	s5,8(sp)
 7e6:	6b02                	ld	s6,0(sp)
 7e8:	a03d                	j	816 <malloc+0xea>
 7ea:	7902                	ld	s2,32(sp)
 7ec:	6a42                	ld	s4,16(sp)
 7ee:	6aa2                	ld	s5,8(sp)
 7f0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7f2:	fae489e3          	beq	s1,a4,7a4 <malloc+0x78>
        p->s.size -= nunits;
 7f6:	4137073b          	subw	a4,a4,s3
 7fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fc:	02071693          	slli	a3,a4,0x20
 800:	01c6d713          	srli	a4,a3,0x1c
 804:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 806:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 80a:	00000717          	auipc	a4,0x0
 80e:	4aa73b23          	sd	a0,1206(a4) # cc0 <freep>
      return (void*)(p + 1);
 812:	01078513          	addi	a0,a5,16
  }
}
 816:	70e2                	ld	ra,56(sp)
 818:	7442                	ld	s0,48(sp)
 81a:	74a2                	ld	s1,40(sp)
 81c:	69e2                	ld	s3,24(sp)
 81e:	6121                	addi	sp,sp,64
 820:	8082                	ret
 822:	7902                	ld	s2,32(sp)
 824:	6a42                	ld	s4,16(sp)
 826:	6aa2                	ld	s5,8(sp)
 828:	6b02                	ld	s6,0(sp)
 82a:	b7f5                	j	816 <malloc+0xea>
