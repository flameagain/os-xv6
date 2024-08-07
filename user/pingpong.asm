
user/_pingpong：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "stddef.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
    int ptoc_fd[2], ctop_fd[2];
    pipe(ptoc_fd);
   a:	fd840513          	addi	a0,s0,-40
   e:	00000097          	auipc	ra,0x0
  12:	364080e7          	jalr	868(ra) # 372 <pipe>
    pipe(ctop_fd);
  16:	fd040513          	addi	a0,s0,-48
  1a:	00000097          	auipc	ra,0x0
  1e:	358080e7          	jalr	856(ra) # 372 <pipe>
    char buf[8];

    if (fork() == 0) // child process
  22:	00000097          	auipc	ra,0x0
  26:	338080e7          	jalr	824(ra) # 35a <fork>
  2a:	e13d                	bnez	a0,90 <main+0x90>
    {
        read(ptoc_fd[0], buf, 4);
  2c:	4611                	li	a2,4
  2e:	fc840593          	addi	a1,s0,-56
  32:	fd842503          	lw	a0,-40(s0)
  36:	00000097          	auipc	ra,0x0
  3a:	344080e7          	jalr	836(ra) # 37a <read>
        printf("%d: received %s\n", getpid(), buf);
  3e:	00000097          	auipc	ra,0x0
  42:	3a4080e7          	jalr	932(ra) # 3e2 <getpid>
  46:	85aa                	mv	a1,a0
  48:	fc840613          	addi	a2,s0,-56
  4c:	00001517          	auipc	a0,0x1
  50:	83c50513          	addi	a0,a0,-1988 # 888 <malloc+0x106>
  54:	00000097          	auipc	ra,0x0
  58:	676080e7          	jalr	1654(ra) # 6ca <printf>
        write(ctop_fd[1], "pong", strlen("pong"));
  5c:	fd442483          	lw	s1,-44(s0)
  60:	00001517          	auipc	a0,0x1
  64:	84050513          	addi	a0,a0,-1984 # 8a0 <malloc+0x11e>
  68:	00000097          	auipc	ra,0x0
  6c:	0d6080e7          	jalr	214(ra) # 13e <strlen>
  70:	0005061b          	sext.w	a2,a0
  74:	00001597          	auipc	a1,0x1
  78:	82c58593          	addi	a1,a1,-2004 # 8a0 <malloc+0x11e>
  7c:	8526                	mv	a0,s1
  7e:	00000097          	auipc	ra,0x0
  82:	304080e7          	jalr	772(ra) # 382 <write>
        write(ptoc_fd[1], "ping", strlen("ping"));
        wait(NULL);
        read(ctop_fd[0], buf, 4);
        printf("%d: received %s\n", getpid(), buf);
    }
    exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2da080e7          	jalr	730(ra) # 362 <exit>
        write(ptoc_fd[1], "ping", strlen("ping"));
  90:	fdc42483          	lw	s1,-36(s0)
  94:	00001517          	auipc	a0,0x1
  98:	81450513          	addi	a0,a0,-2028 # 8a8 <malloc+0x126>
  9c:	00000097          	auipc	ra,0x0
  a0:	0a2080e7          	jalr	162(ra) # 13e <strlen>
  a4:	0005061b          	sext.w	a2,a0
  a8:	00001597          	auipc	a1,0x1
  ac:	80058593          	addi	a1,a1,-2048 # 8a8 <malloc+0x126>
  b0:	8526                	mv	a0,s1
  b2:	00000097          	auipc	ra,0x0
  b6:	2d0080e7          	jalr	720(ra) # 382 <write>
        wait(NULL);
  ba:	4501                	li	a0,0
  bc:	00000097          	auipc	ra,0x0
  c0:	2ae080e7          	jalr	686(ra) # 36a <wait>
        read(ctop_fd[0], buf, 4);
  c4:	4611                	li	a2,4
  c6:	fc840593          	addi	a1,s0,-56
  ca:	fd042503          	lw	a0,-48(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	2ac080e7          	jalr	684(ra) # 37a <read>
        printf("%d: received %s\n", getpid(), buf);
  d6:	00000097          	auipc	ra,0x0
  da:	30c080e7          	jalr	780(ra) # 3e2 <getpid>
  de:	85aa                	mv	a1,a0
  e0:	fc840613          	addi	a2,s0,-56
  e4:	00000517          	auipc	a0,0x0
  e8:	7a450513          	addi	a0,a0,1956 # 888 <malloc+0x106>
  ec:	00000097          	auipc	ra,0x0
  f0:	5de080e7          	jalr	1502(ra) # 6ca <printf>
  f4:	bf49                	j	86 <main+0x86>

00000000000000f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	addi	a1,a1,1
 100:	0785                	addi	a5,a5,1
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	addi	a0,a0,1
 128:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	addi	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	86be                	mv	a3,a5
 150:	0785                	addi	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	ff65                	bnez	a4,14e <strlen+0x10>
 158:	40a6853b          	subw	a0,a3,a0
 15c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ca19                	beqz	a2,184 <memset+0x1c>
 170:	87aa                	mv	a5,a0
 172:	1602                	slli	a2,a2,0x20
 174:	9201                	srli	a2,a2,0x20
 176:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17e:	0785                	addi	a5,a5,1
 180:	fee79de3          	bne	a5,a4,17a <memset+0x12>
  }
  return dst;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb99                	beqz	a5,1aa <strchr+0x20>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1a>
  for(; *s; s++)
 19a:	0505                	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xc>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strchr+0x1a>

00000000000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	711d                	addi	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	addi	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	2485                	addiw	s1,s1,1
 1d4:	0344d863          	bge	s1,s4,204 <gets+0x56>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	addi	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	19a080e7          	jalr	410(ra) # 37a <read>
    if(cc < 1)
 1e8:	00a05e63          	blez	a0,204 <gets+0x56>
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f4:	01578763          	beq	a5,s5,202 <gets+0x54>
 1f8:	0905                	addi	s2,s2,1
 1fa:	fd679be3          	bne	a5,s6,1d0 <gets+0x22>
    buf[i++] = c;
 1fe:	89a6                	mv	s3,s1
 200:	a011                	j	204 <gets+0x56>
 202:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 204:	99de                	add	s3,s3,s7
 206:	00098023          	sb	zero,0(s3)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	00000097          	auipc	ra,0x0
 234:	172080e7          	jalr	370(ra) # 3a2 <open>
  if(fd < 0)
 238:	02054663          	bltz	a0,264 <stat+0x42>
 23c:	e426                	sd	s1,8(sp)
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	00000097          	auipc	ra,0x0
 246:	178080e7          	jalr	376(ra) # 3ba <fstat>
 24a:	892a                	mv	s2,a0
  close(fd);
 24c:	8526                	mv	a0,s1
 24e:	00000097          	auipc	ra,0x0
 252:	13c080e7          	jalr	316(ra) # 38a <close>
  return r;
 256:	64a2                	ld	s1,8(sp)
}
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	6902                	ld	s2,0(sp)
 260:	6105                	addi	sp,sp,32
 262:	8082                	ret
    return -1;
 264:	597d                	li	s2,-1
 266:	bfcd                	j	258 <stat+0x36>

0000000000000268 <atoi>:

int
atoi(const char *s)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26e:	00054683          	lbu	a3,0(a0)
 272:	fd06879b          	addiw	a5,a3,-48
 276:	0ff7f793          	zext.b	a5,a5
 27a:	4625                	li	a2,9
 27c:	02f66863          	bltu	a2,a5,2ac <atoi+0x44>
 280:	872a                	mv	a4,a0
  n = 0;
 282:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 284:	0705                	addi	a4,a4,1
 286:	0025179b          	slliw	a5,a0,0x2
 28a:	9fa9                	addw	a5,a5,a0
 28c:	0017979b          	slliw	a5,a5,0x1
 290:	9fb5                	addw	a5,a5,a3
 292:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 296:	00074683          	lbu	a3,0(a4)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	fef671e3          	bgeu	a2,a5,284 <atoi+0x1c>
  return n;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  n = 0;
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <atoi+0x3e>

00000000000002b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b6:	02b57463          	bgeu	a0,a1,2de <memmove+0x2e>
    while(n-- > 0)
 2ba:	00c05f63          	blez	a2,2d8 <memmove+0x28>
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c8:	0585                	addi	a1,a1,1
 2ca:	0705                	addi	a4,a4,1
 2cc:	fff5c683          	lbu	a3,-1(a1)
 2d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d4:	fef71ae3          	bne	a4,a5,2c8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
    dst += n;
 2de:	00c50733          	add	a4,a0,a2
    src += n;
 2e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e4:	fec05ae3          	blez	a2,2d8 <memmove+0x28>
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	fff7c793          	not	a5,a5
 2f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f6:	15fd                	addi	a1,a1,-1
 2f8:	177d                	addi	a4,a4,-1
 2fa:	0005c683          	lbu	a3,0(a1)
 2fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x46>
 306:	bfc9                	j	2d8 <memmove+0x28>

0000000000000308 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30e:	ca05                	beqz	a2,33e <memcmp+0x36>
 310:	fff6069b          	addiw	a3,a2,-1
 314:	1682                	slli	a3,a3,0x20
 316:	9281                	srli	a3,a3,0x20
 318:	0685                	addi	a3,a3,1
 31a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31c:	00054783          	lbu	a5,0(a0)
 320:	0005c703          	lbu	a4,0(a1)
 324:	00e79863          	bne	a5,a4,334 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 328:	0505                	addi	a0,a0,1
    p2++;
 32a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32c:	fed518e3          	bne	a0,a3,31c <memcmp+0x14>
  }
  return 0;
 330:	4501                	li	a0,0
 332:	a019                	j	338 <memcmp+0x30>
      return *p1 - *p2;
 334:	40e7853b          	subw	a0,a5,a4
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfe5                	j	338 <memcmp+0x30>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	00000097          	auipc	ra,0x0
 34e:	f66080e7          	jalr	-154(ra) # 2b0 <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35a:	4885                	li	a7,1
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exit>:
.global exit
exit:
 li a7, SYS_exit
 362:	4889                	li	a7,2
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <wait>:
.global wait
wait:
 li a7, SYS_wait
 36a:	488d                	li	a7,3
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 372:	4891                	li	a7,4
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <read>:
.global read
read:
 li a7, SYS_read
 37a:	4895                	li	a7,5
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <write>:
.global write
write:
 li a7, SYS_write
 382:	48c1                	li	a7,16
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <close>:
.global close
close:
 li a7, SYS_close
 38a:	48d5                	li	a7,21
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <kill>:
.global kill
kill:
 li a7, SYS_kill
 392:	4899                	li	a7,6
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exec>:
.global exec
exec:
 li a7, SYS_exec
 39a:	489d                	li	a7,7
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <open>:
.global open
open:
 li a7, SYS_open
 3a2:	48bd                	li	a7,15
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3aa:	48c5                	li	a7,17
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b2:	48c9                	li	a7,18
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ba:	48a1                	li	a7,8
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <link>:
.global link
link:
 li a7, SYS_link
 3c2:	48cd                	li	a7,19
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ca:	48d1                	li	a7,20
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d2:	48a5                	li	a7,9
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <dup>:
.global dup
dup:
 li a7, SYS_dup
 3da:	48a9                	li	a7,10
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e2:	48ad                	li	a7,11
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ea:	48b1                	li	a7,12
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f2:	48b5                	li	a7,13
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fa:	48b9                	li	a7,14
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	1000                	addi	s0,sp,32
 40a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40e:	4605                	li	a2,1
 410:	fef40593          	addi	a1,s0,-17
 414:	00000097          	auipc	ra,0x0
 418:	f6e080e7          	jalr	-146(ra) # 382 <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	7139                	addi	sp,sp,-64
 426:	fc06                	sd	ra,56(sp)
 428:	f822                	sd	s0,48(sp)
 42a:	f426                	sd	s1,40(sp)
 42c:	0080                	addi	s0,sp,64
 42e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 430:	c299                	beqz	a3,436 <printint+0x12>
 432:	0805cb63          	bltz	a1,4c8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 436:	2581                	sext.w	a1,a1
  neg = 0;
 438:	4881                	li	a7,0
 43a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 43e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 440:	2601                	sext.w	a2,a2
 442:	00000517          	auipc	a0,0x0
 446:	4ce50513          	addi	a0,a0,1230 # 910 <digits>
 44a:	883a                	mv	a6,a4
 44c:	2705                	addiw	a4,a4,1
 44e:	02c5f7bb          	remuw	a5,a1,a2
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	97aa                	add	a5,a5,a0
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 460:	0005879b          	sext.w	a5,a1
 464:	02c5d5bb          	divuw	a1,a1,a2
 468:	0685                	addi	a3,a3,1
 46a:	fec7f0e3          	bgeu	a5,a2,44a <printint+0x26>
  if(neg)
 46e:	00088c63          	beqz	a7,486 <printint+0x62>
    buf[i++] = '-';
 472:	fd070793          	addi	a5,a4,-48
 476:	00878733          	add	a4,a5,s0
 47a:	02d00793          	li	a5,45
 47e:	fef70823          	sb	a5,-16(a4)
 482:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 486:	02e05c63          	blez	a4,4be <printint+0x9a>
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	fc040793          	addi	a5,s0,-64
 492:	00e78933          	add	s2,a5,a4
 496:	fff78993          	addi	s3,a5,-1
 49a:	99ba                	add	s3,s3,a4
 49c:	377d                	addiw	a4,a4,-1
 49e:	1702                	slli	a4,a4,0x20
 4a0:	9301                	srli	a4,a4,0x20
 4a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a6:	fff94583          	lbu	a1,-1(s2)
 4aa:	8526                	mv	a0,s1
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f56080e7          	jalr	-170(ra) # 402 <putc>
  while(--i >= 0)
 4b4:	197d                	addi	s2,s2,-1
 4b6:	ff3918e3          	bne	s2,s3,4a6 <printint+0x82>
 4ba:	7902                	ld	s2,32(sp)
 4bc:	69e2                	ld	s3,24(sp)
}
 4be:	70e2                	ld	ra,56(sp)
 4c0:	7442                	ld	s0,48(sp)
 4c2:	74a2                	ld	s1,40(sp)
 4c4:	6121                	addi	sp,sp,64
 4c6:	8082                	ret
    x = -xx;
 4c8:	40b005bb          	negw	a1,a1
    neg = 1;
 4cc:	4885                	li	a7,1
    x = -xx;
 4ce:	b7b5                	j	43a <printint+0x16>

00000000000004d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d0:	715d                	addi	sp,sp,-80
 4d2:	e486                	sd	ra,72(sp)
 4d4:	e0a2                	sd	s0,64(sp)
 4d6:	f84a                	sd	s2,48(sp)
 4d8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4da:	0005c903          	lbu	s2,0(a1)
 4de:	1a090a63          	beqz	s2,692 <vprintf+0x1c2>
 4e2:	fc26                	sd	s1,56(sp)
 4e4:	f44e                	sd	s3,40(sp)
 4e6:	f052                	sd	s4,32(sp)
 4e8:	ec56                	sd	s5,24(sp)
 4ea:	e85a                	sd	s6,16(sp)
 4ec:	e45e                	sd	s7,8(sp)
 4ee:	8aaa                	mv	s5,a0
 4f0:	8bb2                	mv	s7,a2
 4f2:	00158493          	addi	s1,a1,1
  state = 0;
 4f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f8:	02500a13          	li	s4,37
 4fc:	4b55                	li	s6,21
 4fe:	a839                	j	51c <vprintf+0x4c>
        putc(fd, c);
 500:	85ca                	mv	a1,s2
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	efe080e7          	jalr	-258(ra) # 402 <putc>
 50c:	a019                	j	512 <vprintf+0x42>
    } else if(state == '%'){
 50e:	01498d63          	beq	s3,s4,528 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 512:	0485                	addi	s1,s1,1
 514:	fff4c903          	lbu	s2,-1(s1)
 518:	16090763          	beqz	s2,686 <vprintf+0x1b6>
    if(state == 0){
 51c:	fe0999e3          	bnez	s3,50e <vprintf+0x3e>
      if(c == '%'){
 520:	ff4910e3          	bne	s2,s4,500 <vprintf+0x30>
        state = '%';
 524:	89d2                	mv	s3,s4
 526:	b7f5                	j	512 <vprintf+0x42>
      if(c == 'd'){
 528:	13490463          	beq	s2,s4,650 <vprintf+0x180>
 52c:	f9d9079b          	addiw	a5,s2,-99
 530:	0ff7f793          	zext.b	a5,a5
 534:	12fb6763          	bltu	s6,a5,662 <vprintf+0x192>
 538:	f9d9079b          	addiw	a5,s2,-99
 53c:	0ff7f713          	zext.b	a4,a5
 540:	12eb6163          	bltu	s6,a4,662 <vprintf+0x192>
 544:	00271793          	slli	a5,a4,0x2
 548:	00000717          	auipc	a4,0x0
 54c:	37070713          	addi	a4,a4,880 # 8b8 <malloc+0x136>
 550:	97ba                	add	a5,a5,a4
 552:	439c                	lw	a5,0(a5)
 554:	97ba                	add	a5,a5,a4
 556:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 558:	008b8913          	addi	s2,s7,8
 55c:	4685                	li	a3,1
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	ebe080e7          	jalr	-322(ra) # 424 <printint>
 56e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 570:	4981                	li	s3,0
 572:	b745                	j	512 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	008b8913          	addi	s2,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	ea2080e7          	jalr	-350(ra) # 424 <printint>
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b751                	j	512 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000ba583          	lw	a1,0(s7)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e86080e7          	jalr	-378(ra) # 424 <printint>
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b7a5                	j	512 <vprintf+0x42>
 5ac:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ae:	008b8c13          	addi	s8,s7,8
 5b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b6:	03000593          	li	a1,48
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e46080e7          	jalr	-442(ra) # 402 <putc>
  putc(fd, 'x');
 5c4:	07800593          	li	a1,120
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e38080e7          	jalr	-456(ra) # 402 <putc>
 5d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d4:	00000b97          	auipc	s7,0x0
 5d8:	33cb8b93          	addi	s7,s7,828 # 910 <digits>
 5dc:	03c9d793          	srli	a5,s3,0x3c
 5e0:	97de                	add	a5,a5,s7
 5e2:	0007c583          	lbu	a1,0(a5)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e1a080e7          	jalr	-486(ra) # 402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f0:	0992                	slli	s3,s3,0x4
 5f2:	397d                	addiw	s2,s2,-1
 5f4:	fe0914e3          	bnez	s2,5dc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5f8:	8be2                	mv	s7,s8
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	6c02                	ld	s8,0(sp)
 5fe:	bf11                	j	512 <vprintf+0x42>
        s = va_arg(ap, char*);
 600:	008b8993          	addi	s3,s7,8
 604:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 608:	02090163          	beqz	s2,62a <vprintf+0x15a>
        while(*s != 0){
 60c:	00094583          	lbu	a1,0(s2)
 610:	c9a5                	beqz	a1,680 <vprintf+0x1b0>
          putc(fd, *s);
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	dee080e7          	jalr	-530(ra) # 402 <putc>
          s++;
 61c:	0905                	addi	s2,s2,1
        while(*s != 0){
 61e:	00094583          	lbu	a1,0(s2)
 622:	f9e5                	bnez	a1,612 <vprintf+0x142>
        s = va_arg(ap, char*);
 624:	8bce                	mv	s7,s3
      state = 0;
 626:	4981                	li	s3,0
 628:	b5ed                	j	512 <vprintf+0x42>
          s = "(null)";
 62a:	00000917          	auipc	s2,0x0
 62e:	28690913          	addi	s2,s2,646 # 8b0 <malloc+0x12e>
        while(*s != 0){
 632:	02800593          	li	a1,40
 636:	bff1                	j	612 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 638:	008b8913          	addi	s2,s7,8
 63c:	000bc583          	lbu	a1,0(s7)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	dc0080e7          	jalr	-576(ra) # 402 <putc>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b5d1                	j	512 <vprintf+0x42>
        putc(fd, c);
 650:	02500593          	li	a1,37
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	dac080e7          	jalr	-596(ra) # 402 <putc>
      state = 0;
 65e:	4981                	li	s3,0
 660:	bd4d                	j	512 <vprintf+0x42>
        putc(fd, '%');
 662:	02500593          	li	a1,37
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d9a080e7          	jalr	-614(ra) # 402 <putc>
        putc(fd, c);
 670:	85ca                	mv	a1,s2
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	d8e080e7          	jalr	-626(ra) # 402 <putc>
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd51                	j	512 <vprintf+0x42>
        s = va_arg(ap, char*);
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b579                	j	512 <vprintf+0x42>
 686:	74e2                	ld	s1,56(sp)
 688:	79a2                	ld	s3,40(sp)
 68a:	7a02                	ld	s4,32(sp)
 68c:	6ae2                	ld	s5,24(sp)
 68e:	6b42                	ld	s6,16(sp)
 690:	6ba2                	ld	s7,8(sp)
    }
  }
}
 692:	60a6                	ld	ra,72(sp)
 694:	6406                	ld	s0,64(sp)
 696:	7942                	ld	s2,48(sp)
 698:	6161                	addi	sp,sp,80
 69a:	8082                	ret

000000000000069c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 69c:	715d                	addi	sp,sp,-80
 69e:	ec06                	sd	ra,24(sp)
 6a0:	e822                	sd	s0,16(sp)
 6a2:	1000                	addi	s0,sp,32
 6a4:	e010                	sd	a2,0(s0)
 6a6:	e414                	sd	a3,8(s0)
 6a8:	e818                	sd	a4,16(s0)
 6aa:	ec1c                	sd	a5,24(s0)
 6ac:	03043023          	sd	a6,32(s0)
 6b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b8:	8622                	mv	a2,s0
 6ba:	00000097          	auipc	ra,0x0
 6be:	e16080e7          	jalr	-490(ra) # 4d0 <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6161                	addi	sp,sp,80
 6c8:	8082                	ret

00000000000006ca <printf>:

void
printf(const char *fmt, ...)
{
 6ca:	711d                	addi	sp,sp,-96
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	e40c                	sd	a1,8(s0)
 6d4:	e810                	sd	a2,16(s0)
 6d6:	ec14                	sd	a3,24(s0)
 6d8:	f018                	sd	a4,32(s0)
 6da:	f41c                	sd	a5,40(s0)
 6dc:	03043823          	sd	a6,48(s0)
 6e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e4:	00840613          	addi	a2,s0,8
 6e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ec:	85aa                	mv	a1,a0
 6ee:	4505                	li	a0,1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	de0080e7          	jalr	-544(ra) # 4d0 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6125                	addi	sp,sp,96
 6fe:	8082                	ret

0000000000000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	1141                	addi	sp,sp,-16
 702:	e422                	sd	s0,8(sp)
 704:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 706:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	00000797          	auipc	a5,0x0
 70e:	5d67b783          	ld	a5,1494(a5) # ce0 <freep>
 712:	a02d                	j	73c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 714:	4618                	lw	a4,8(a2)
 716:	9f2d                	addw	a4,a4,a1
 718:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	6398                	ld	a4,0(a5)
 71e:	6310                	ld	a2,0(a4)
 720:	a83d                	j	75e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 722:	ff852703          	lw	a4,-8(a0)
 726:	9f31                	addw	a4,a4,a2
 728:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 72a:	ff053683          	ld	a3,-16(a0)
 72e:	a091                	j	772 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	6398                	ld	a4,0(a5)
 732:	00e7e463          	bltu	a5,a4,73a <free+0x3a>
 736:	00e6ea63          	bltu	a3,a4,74a <free+0x4a>
{
 73a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	fed7fae3          	bgeu	a5,a3,730 <free+0x30>
 740:	6398                	ld	a4,0(a5)
 742:	00e6e463          	bltu	a3,a4,74a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	fee7eae3          	bltu	a5,a4,73a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 74a:	ff852583          	lw	a1,-8(a0)
 74e:	6390                	ld	a2,0(a5)
 750:	02059813          	slli	a6,a1,0x20
 754:	01c85713          	srli	a4,a6,0x1c
 758:	9736                	add	a4,a4,a3
 75a:	fae60de3          	beq	a2,a4,714 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 762:	4790                	lw	a2,8(a5)
 764:	02061593          	slli	a1,a2,0x20
 768:	01c5d713          	srli	a4,a1,0x1c
 76c:	973e                	add	a4,a4,a5
 76e:	fae68ae3          	beq	a3,a4,722 <free+0x22>
    p->s.ptr = bp->s.ptr;
 772:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 774:	00000717          	auipc	a4,0x0
 778:	56f73623          	sd	a5,1388(a4) # ce0 <freep>
}
 77c:	6422                	ld	s0,8(sp)
 77e:	0141                	addi	sp,sp,16
 780:	8082                	ret

0000000000000782 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 782:	7139                	addi	sp,sp,-64
 784:	fc06                	sd	ra,56(sp)
 786:	f822                	sd	s0,48(sp)
 788:	f426                	sd	s1,40(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78e:	02051493          	slli	s1,a0,0x20
 792:	9081                	srli	s1,s1,0x20
 794:	04bd                	addi	s1,s1,15
 796:	8091                	srli	s1,s1,0x4
 798:	0014899b          	addiw	s3,s1,1
 79c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79e:	00000517          	auipc	a0,0x0
 7a2:	54253503          	ld	a0,1346(a0) # ce0 <freep>
 7a6:	c915                	beqz	a0,7da <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7aa:	4798                	lw	a4,8(a5)
 7ac:	08977e63          	bgeu	a4,s1,848 <malloc+0xc6>
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	e852                	sd	s4,16(sp)
 7b4:	e456                	sd	s5,8(sp)
 7b6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b8:	8a4e                	mv	s4,s3
 7ba:	0009871b          	sext.w	a4,s3
 7be:	6685                	lui	a3,0x1
 7c0:	00d77363          	bgeu	a4,a3,7c6 <malloc+0x44>
 7c4:	6a05                	lui	s4,0x1
 7c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ce:	00000917          	auipc	s2,0x0
 7d2:	51290913          	addi	s2,s2,1298 # ce0 <freep>
  if(p == (char*)-1)
 7d6:	5afd                	li	s5,-1
 7d8:	a091                	j	81c <malloc+0x9a>
 7da:	f04a                	sd	s2,32(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e2:	00000797          	auipc	a5,0x0
 7e6:	50678793          	addi	a5,a5,1286 # ce8 <base>
 7ea:	00000717          	auipc	a4,0x0
 7ee:	4ef73b23          	sd	a5,1270(a4) # ce0 <freep>
 7f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f8:	b7c1                	j	7b8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7fa:	6398                	ld	a4,0(a5)
 7fc:	e118                	sd	a4,0(a0)
 7fe:	a08d                	j	860 <malloc+0xde>
  hp->s.size = nu;
 800:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 804:	0541                	addi	a0,a0,16
 806:	00000097          	auipc	ra,0x0
 80a:	efa080e7          	jalr	-262(ra) # 700 <free>
  return freep;
 80e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 812:	c13d                	beqz	a0,878 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 816:	4798                	lw	a4,8(a5)
 818:	02977463          	bgeu	a4,s1,840 <malloc+0xbe>
    if(p == freep)
 81c:	00093703          	ld	a4,0(s2)
 820:	853e                	mv	a0,a5
 822:	fef719e3          	bne	a4,a5,814 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 826:	8552                	mv	a0,s4
 828:	00000097          	auipc	ra,0x0
 82c:	bc2080e7          	jalr	-1086(ra) # 3ea <sbrk>
  if(p == (char*)-1)
 830:	fd5518e3          	bne	a0,s5,800 <malloc+0x7e>
        return 0;
 834:	4501                	li	a0,0
 836:	7902                	ld	s2,32(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
 83e:	a03d                	j	86c <malloc+0xea>
 840:	7902                	ld	s2,32(sp)
 842:	6a42                	ld	s4,16(sp)
 844:	6aa2                	ld	s5,8(sp)
 846:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 848:	fae489e3          	beq	s1,a4,7fa <malloc+0x78>
        p->s.size -= nunits;
 84c:	4137073b          	subw	a4,a4,s3
 850:	c798                	sw	a4,8(a5)
        p += p->s.size;
 852:	02071693          	slli	a3,a4,0x20
 856:	01c6d713          	srli	a4,a3,0x1c
 85a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 860:	00000717          	auipc	a4,0x0
 864:	48a73023          	sd	a0,1152(a4) # ce0 <freep>
      return (void*)(p + 1);
 868:	01078513          	addi	a0,a5,16
  }
}
 86c:	70e2                	ld	ra,56(sp)
 86e:	7442                	ld	s0,48(sp)
 870:	74a2                	ld	s1,40(sp)
 872:	69e2                	ld	s3,24(sp)
 874:	6121                	addi	sp,sp,64
 876:	8082                	ret
 878:	7902                	ld	s2,32(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	b7f5                	j	86c <malloc+0xea>
