
user/_kalloctest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test2();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	1c050513          	addi	a0,a0,448 # 11d0 <buf>
  18:	00001097          	auipc	ra,0x1
  1c:	a80080e7          	jalr	-1408(ra) # a98 <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	1a850513          	addi	a0,a0,424 # 11d0 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	370080e7          	jalr	880(ra) # 3a0 <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	444080e7          	jalr	1092(ra) # 47e <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	aca58593          	addi	a1,a1,-1334 # b20 <statistics+0x88>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	852080e7          	jalr	-1966(ra) # 8b2 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	16658593          	addi	a1,a1,358 # 11d0 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	abe50513          	addi	a0,a0,-1346 # b30 <statistics+0x98>
  7a:	00001097          	auipc	ra,0x1
  7e:	866080e7          	jalr	-1946(ra) # 8e0 <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  8e:	00001517          	auipc	a0,0x1
  92:	aaa50513          	addi	a0,a0,-1366 # b38 <statistics+0xa0>
  96:	00001097          	auipc	ra,0x1
  9a:	84a080e7          	jalr	-1974(ra) # 8e0 <printf>
  m = ntas(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	f60080e7          	jalr	-160(ra) # 0 <ntas>
  a8:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  aa:	00000097          	auipc	ra,0x0
  ae:	4c6080e7          	jalr	1222(ra) # 570 <fork>
    if(pid < 0){
  b2:	06054263          	bltz	a0,116 <test1+0x92>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  b6:	cd3d                	beqz	a0,134 <test1+0xb0>
    int pid = fork();
  b8:	00000097          	auipc	ra,0x0
  bc:	4b8080e7          	jalr	1208(ra) # 570 <fork>
    if(pid < 0){
  c0:	04054b63          	bltz	a0,116 <test1+0x92>
    if(pid == 0){
  c4:	c925                	beqz	a0,134 <test1+0xb0>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	4b8080e7          	jalr	1208(ra) # 580 <wait>
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	4ae080e7          	jalr	1198(ra) # 580 <wait>
  }
  printf("test1 results:\n");
  da:	00001517          	auipc	a0,0x1
  de:	a8e50513          	addi	a0,a0,-1394 # b68 <statistics+0xd0>
  e2:	00000097          	auipc	ra,0x0
  e6:	7fe080e7          	jalr	2046(ra) # 8e0 <printf>
  n = ntas(1);
  ea:	4505                	li	a0,1
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <ntas>
  if(n-m < 10) 
  f4:	9d05                	subw	a0,a0,s1
  f6:	47a5                	li	a5,9
  f8:	08a7ca63          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
  fc:	00001517          	auipc	a0,0x1
 100:	a7c50513          	addi	a0,a0,-1412 # b78 <statistics+0xe0>
 104:	00000097          	auipc	ra,0x0
 108:	7dc080e7          	jalr	2012(ra) # 8e0 <printf>
  else
    printf("test1 FAIL\n");
}
 10c:	70a2                	ld	ra,40(sp)
 10e:	7402                	ld	s0,32(sp)
 110:	64e2                	ld	s1,24(sp)
 112:	6145                	addi	sp,sp,48
 114:	8082                	ret
 116:	e84a                	sd	s2,16(sp)
 118:	e44e                	sd	s3,8(sp)
      printf("fork failed");
 11a:	00001517          	auipc	a0,0x1
 11e:	a2e50513          	addi	a0,a0,-1490 # b48 <statistics+0xb0>
 122:	00000097          	auipc	ra,0x0
 126:	7be080e7          	jalr	1982(ra) # 8e0 <printf>
      exit(-1);
 12a:	557d                	li	a0,-1
 12c:	00000097          	auipc	ra,0x0
 130:	44c080e7          	jalr	1100(ra) # 578 <exit>
 134:	e84a                	sd	s2,16(sp)
 136:	e44e                	sd	s3,8(sp)
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <__BSS_END__+0x164c0>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	4be080e7          	jalr	1214(ra) # 600 <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <digits+0x33c>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	4ae080e7          	jalr	1198(ra) # 600 <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	40e080e7          	jalr	1038(ra) # 578 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	9e650513          	addi	a0,a0,-1562 # b58 <statistics+0xc0>
 17a:	00000097          	auipc	ra,0x0
 17e:	766080e7          	jalr	1894(ra) # 8e0 <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	3f4080e7          	jalr	1012(ra) # 578 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	9fc50513          	addi	a0,a0,-1540 # b88 <statistics+0xf0>
 194:	00000097          	auipc	ra,0x0
 198:	74c080e7          	jalr	1868(ra) # 8e0 <printf>
}
 19c:	bf85                	j	10c <test1+0x88>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	450080e7          	jalr	1104(ra) # 600 <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
 1c0:	a031                	j	1cc <countfree+0x2e>
 1c2:	6785                	lui	a5,0x1
 1c4:	97aa                	add	a5,a5,a0
 1c6:	ff378fa3          	sb	s3,-1(a5) # fff <digits+0x337>
    n += 1;
 1ca:	2485                	addiw	s1,s1,1
    uint64 a = (uint64) sbrk(4096);
 1cc:	6505                	lui	a0,0x1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	432080e7          	jalr	1074(ra) # 600 <sbrk>
    if(a == 0xffffffffffffffff){
 1d6:	ff2516e3          	bne	a0,s2,1c2 <countfree+0x24>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	424080e7          	jalr	1060(ra) # 600 <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	418080e7          	jalr	1048(ra) # 600 <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	0880                	addi	s0,sp,80
  int free0 = countfree();
 218:	00000097          	auipc	ra,0x0
 21c:	f86080e7          	jalr	-122(ra) # 19e <countfree>
 220:	89aa                	mv	s3,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 222:	00001517          	auipc	a0,0x1
 226:	97650513          	addi	a0,a0,-1674 # b98 <statistics+0x100>
 22a:	00000097          	auipc	ra,0x0
 22e:	6b6080e7          	jalr	1718(ra) # 8e0 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 232:	6621                	lui	a2,0x8
 234:	85ce                	mv	a1,s3
 236:	00001517          	auipc	a0,0x1
 23a:	97250513          	addi	a0,a0,-1678 # ba8 <statistics+0x110>
 23e:	00000097          	auipc	ra,0x0
 242:	6a2080e7          	jalr	1698(ra) # 8e0 <printf>
  if(n - free0 > 1000) {
 246:	67a1                	lui	a5,0x8
 248:	413787bb          	subw	a5,a5,s3
 24c:	3e800713          	li	a4,1000
 250:	00f74c63          	blt	a4,a5,268 <test2+0x66>
 254:	4481                	li	s1,0
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
    if(i % 10 == 9)
 256:	4b29                	li	s6,10
 258:	4aa5                	li	s5,9
      printf(".");
 25a:	00001b97          	auipc	s7,0x1
 25e:	9aeb8b93          	addi	s7,s7,-1618 # c08 <statistics+0x170>
  for (int i = 0; i < 50; i++) {
 262:	03200a13          	li	s4,50
 266:	a01d                	j	28c <test2+0x8a>
    printf("test2 FAILED: cannot allocate enough memory");
 268:	00001517          	auipc	a0,0x1
 26c:	97050513          	addi	a0,a0,-1680 # bd8 <statistics+0x140>
 270:	00000097          	auipc	ra,0x0
 274:	670080e7          	jalr	1648(ra) # 8e0 <printf>
    exit(-1);
 278:	557d                	li	a0,-1
 27a:	00000097          	auipc	ra,0x0
 27e:	2fe080e7          	jalr	766(ra) # 578 <exit>
    if(free1 != free0) {
 282:	03299463          	bne	s3,s2,2aa <test2+0xa8>
  for (int i = 0; i < 50; i++) {
 286:	2485                	addiw	s1,s1,1
 288:	03448e63          	beq	s1,s4,2c4 <test2+0xc2>
    free1 = countfree();
 28c:	00000097          	auipc	ra,0x0
 290:	f12080e7          	jalr	-238(ra) # 19e <countfree>
 294:	892a                	mv	s2,a0
    if(i % 10 == 9)
 296:	0364e7bb          	remw	a5,s1,s6
 29a:	ff5794e3          	bne	a5,s5,282 <test2+0x80>
      printf(".");
 29e:	855e                	mv	a0,s7
 2a0:	00000097          	auipc	ra,0x0
 2a4:	640080e7          	jalr	1600(ra) # 8e0 <printf>
 2a8:	bfe9                	j	282 <test2+0x80>
      printf("test2 FAIL: losing pages\n");
 2aa:	00001517          	auipc	a0,0x1
 2ae:	96650513          	addi	a0,a0,-1690 # c10 <statistics+0x178>
 2b2:	00000097          	auipc	ra,0x0
 2b6:	62e080e7          	jalr	1582(ra) # 8e0 <printf>
      exit(-1);
 2ba:	557d                	li	a0,-1
 2bc:	00000097          	auipc	ra,0x0
 2c0:	2bc080e7          	jalr	700(ra) # 578 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2c4:	00001517          	auipc	a0,0x1
 2c8:	96c50513          	addi	a0,a0,-1684 # c30 <statistics+0x198>
 2cc:	00000097          	auipc	ra,0x0
 2d0:	614080e7          	jalr	1556(ra) # 8e0 <printf>
}
 2d4:	60a6                	ld	ra,72(sp)
 2d6:	6406                	ld	s0,64(sp)
 2d8:	74e2                	ld	s1,56(sp)
 2da:	7942                	ld	s2,48(sp)
 2dc:	79a2                	ld	s3,40(sp)
 2de:	7a02                	ld	s4,32(sp)
 2e0:	6ae2                	ld	s5,24(sp)
 2e2:	6b42                	ld	s6,16(sp)
 2e4:	6ba2                	ld	s7,8(sp)
 2e6:	6161                	addi	sp,sp,80
 2e8:	8082                	ret

00000000000002ea <main>:
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  test1();
 2f2:	00000097          	auipc	ra,0x0
 2f6:	d92080e7          	jalr	-622(ra) # 84 <test1>
  test2();
 2fa:	00000097          	auipc	ra,0x0
 2fe:	f08080e7          	jalr	-248(ra) # 202 <test2>
  exit(0);
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	274080e7          	jalr	628(ra) # 578 <exit>

000000000000030c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 312:	87aa                	mv	a5,a0
 314:	0585                	addi	a1,a1,1
 316:	0785                	addi	a5,a5,1 # 8001 <__BSS_END__+0x5e21>
 318:	fff5c703          	lbu	a4,-1(a1)
 31c:	fee78fa3          	sb	a4,-1(a5)
 320:	fb75                	bnez	a4,314 <strcpy+0x8>
    ;
  return os;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret

0000000000000328 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cb91                	beqz	a5,346 <strcmp+0x1e>
 334:	0005c703          	lbu	a4,0(a1)
 338:	00f71763          	bne	a4,a5,346 <strcmp+0x1e>
    p++, q++;
 33c:	0505                	addi	a0,a0,1
 33e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 340:	00054783          	lbu	a5,0(a0)
 344:	fbe5                	bnez	a5,334 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 346:	0005c503          	lbu	a0,0(a1)
}
 34a:	40a7853b          	subw	a0,a5,a0
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <strlen>:

uint
strlen(const char *s)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	cf91                	beqz	a5,37a <strlen+0x26>
 360:	0505                	addi	a0,a0,1
 362:	87aa                	mv	a5,a0
 364:	86be                	mv	a3,a5
 366:	0785                	addi	a5,a5,1
 368:	fff7c703          	lbu	a4,-1(a5)
 36c:	ff65                	bnez	a4,364 <strlen+0x10>
 36e:	40a6853b          	subw	a0,a3,a0
 372:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  for(n = 0; s[n]; n++)
 37a:	4501                	li	a0,0
 37c:	bfe5                	j	374 <strlen+0x20>

000000000000037e <memset>:

void*
memset(void *dst, int c, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 384:	ca19                	beqz	a2,39a <memset+0x1c>
 386:	87aa                	mv	a5,a0
 388:	1602                	slli	a2,a2,0x20
 38a:	9201                	srli	a2,a2,0x20
 38c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 390:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 394:	0785                	addi	a5,a5,1
 396:	fee79de3          	bne	a5,a4,390 <memset+0x12>
  }
  return dst;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <strchr>:

char*
strchr(const char *s, char c)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	cb99                	beqz	a5,3c0 <strchr+0x20>
    if(*s == c)
 3ac:	00f58763          	beq	a1,a5,3ba <strchr+0x1a>
  for(; *s; s++)
 3b0:	0505                	addi	a0,a0,1
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	fbfd                	bnez	a5,3ac <strchr+0xc>
      return (char*)s;
  return 0;
 3b8:	4501                	li	a0,0
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	bfe5                	j	3ba <strchr+0x1a>

00000000000003c4 <gets>:

char*
gets(char *buf, int max)
{
 3c4:	711d                	addi	sp,sp,-96
 3c6:	ec86                	sd	ra,88(sp)
 3c8:	e8a2                	sd	s0,80(sp)
 3ca:	e4a6                	sd	s1,72(sp)
 3cc:	e0ca                	sd	s2,64(sp)
 3ce:	fc4e                	sd	s3,56(sp)
 3d0:	f852                	sd	s4,48(sp)
 3d2:	f456                	sd	s5,40(sp)
 3d4:	f05a                	sd	s6,32(sp)
 3d6:	ec5e                	sd	s7,24(sp)
 3d8:	1080                	addi	s0,sp,96
 3da:	8baa                	mv	s7,a0
 3dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3de:	892a                	mv	s2,a0
 3e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e2:	4aa9                	li	s5,10
 3e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e6:	89a6                	mv	s3,s1
 3e8:	2485                	addiw	s1,s1,1
 3ea:	0344d863          	bge	s1,s4,41a <gets+0x56>
    cc = read(0, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	faf40593          	addi	a1,s0,-81
 3f4:	4501                	li	a0,0
 3f6:	00000097          	auipc	ra,0x0
 3fa:	19a080e7          	jalr	410(ra) # 590 <read>
    if(cc < 1)
 3fe:	00a05e63          	blez	a0,41a <gets+0x56>
    buf[i++] = c;
 402:	faf44783          	lbu	a5,-81(s0)
 406:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40a:	01578763          	beq	a5,s5,418 <gets+0x54>
 40e:	0905                	addi	s2,s2,1
 410:	fd679be3          	bne	a5,s6,3e6 <gets+0x22>
    buf[i++] = c;
 414:	89a6                	mv	s3,s1
 416:	a011                	j	41a <gets+0x56>
 418:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41a:	99de                	add	s3,s3,s7
 41c:	00098023          	sb	zero,0(s3)
  return buf;
}
 420:	855e                	mv	a0,s7
 422:	60e6                	ld	ra,88(sp)
 424:	6446                	ld	s0,80(sp)
 426:	64a6                	ld	s1,72(sp)
 428:	6906                	ld	s2,64(sp)
 42a:	79e2                	ld	s3,56(sp)
 42c:	7a42                	ld	s4,48(sp)
 42e:	7aa2                	ld	s5,40(sp)
 430:	7b02                	ld	s6,32(sp)
 432:	6be2                	ld	s7,24(sp)
 434:	6125                	addi	sp,sp,96
 436:	8082                	ret

0000000000000438 <stat>:

int
stat(const char *n, struct stat *st)
{
 438:	1101                	addi	sp,sp,-32
 43a:	ec06                	sd	ra,24(sp)
 43c:	e822                	sd	s0,16(sp)
 43e:	e04a                	sd	s2,0(sp)
 440:	1000                	addi	s0,sp,32
 442:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 444:	4581                	li	a1,0
 446:	00000097          	auipc	ra,0x0
 44a:	172080e7          	jalr	370(ra) # 5b8 <open>
  if(fd < 0)
 44e:	02054663          	bltz	a0,47a <stat+0x42>
 452:	e426                	sd	s1,8(sp)
 454:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 456:	85ca                	mv	a1,s2
 458:	00000097          	auipc	ra,0x0
 45c:	178080e7          	jalr	376(ra) # 5d0 <fstat>
 460:	892a                	mv	s2,a0
  close(fd);
 462:	8526                	mv	a0,s1
 464:	00000097          	auipc	ra,0x0
 468:	13c080e7          	jalr	316(ra) # 5a0 <close>
  return r;
 46c:	64a2                	ld	s1,8(sp)
}
 46e:	854a                	mv	a0,s2
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6902                	ld	s2,0(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret
    return -1;
 47a:	597d                	li	s2,-1
 47c:	bfcd                	j	46e <stat+0x36>

000000000000047e <atoi>:

int
atoi(const char *s)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 484:	00054683          	lbu	a3,0(a0)
 488:	fd06879b          	addiw	a5,a3,-48
 48c:	0ff7f793          	zext.b	a5,a5
 490:	4625                	li	a2,9
 492:	02f66863          	bltu	a2,a5,4c2 <atoi+0x44>
 496:	872a                	mv	a4,a0
  n = 0;
 498:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 49a:	0705                	addi	a4,a4,1
 49c:	0025179b          	slliw	a5,a0,0x2
 4a0:	9fa9                	addw	a5,a5,a0
 4a2:	0017979b          	slliw	a5,a5,0x1
 4a6:	9fb5                	addw	a5,a5,a3
 4a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4ac:	00074683          	lbu	a3,0(a4)
 4b0:	fd06879b          	addiw	a5,a3,-48
 4b4:	0ff7f793          	zext.b	a5,a5
 4b8:	fef671e3          	bgeu	a2,a5,49a <atoi+0x1c>
  return n;
}
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret
  n = 0;
 4c2:	4501                	li	a0,0
 4c4:	bfe5                	j	4bc <atoi+0x3e>

00000000000004c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e422                	sd	s0,8(sp)
 4ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4cc:	02b57463          	bgeu	a0,a1,4f4 <memmove+0x2e>
    while(n-- > 0)
 4d0:	00c05f63          	blez	a2,4ee <memmove+0x28>
 4d4:	1602                	slli	a2,a2,0x20
 4d6:	9201                	srli	a2,a2,0x20
 4d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4de:	0585                	addi	a1,a1,1
 4e0:	0705                	addi	a4,a4,1
 4e2:	fff5c683          	lbu	a3,-1(a1)
 4e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ea:	fef71ae3          	bne	a4,a5,4de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ee:	6422                	ld	s0,8(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret
    dst += n;
 4f4:	00c50733          	add	a4,a0,a2
    src += n;
 4f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fa:	fec05ae3          	blez	a2,4ee <memmove+0x28>
 4fe:	fff6079b          	addiw	a5,a2,-1 # 7fff <__BSS_END__+0x5e1f>
 502:	1782                	slli	a5,a5,0x20
 504:	9381                	srli	a5,a5,0x20
 506:	fff7c793          	not	a5,a5
 50a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50c:	15fd                	addi	a1,a1,-1
 50e:	177d                	addi	a4,a4,-1
 510:	0005c683          	lbu	a3,0(a1)
 514:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 518:	fee79ae3          	bne	a5,a4,50c <memmove+0x46>
 51c:	bfc9                	j	4ee <memmove+0x28>

000000000000051e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 524:	ca05                	beqz	a2,554 <memcmp+0x36>
 526:	fff6069b          	addiw	a3,a2,-1
 52a:	1682                	slli	a3,a3,0x20
 52c:	9281                	srli	a3,a3,0x20
 52e:	0685                	addi	a3,a3,1
 530:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 532:	00054783          	lbu	a5,0(a0)
 536:	0005c703          	lbu	a4,0(a1)
 53a:	00e79863          	bne	a5,a4,54a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 53e:	0505                	addi	a0,a0,1
    p2++;
 540:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 542:	fed518e3          	bne	a0,a3,532 <memcmp+0x14>
  }
  return 0;
 546:	4501                	li	a0,0
 548:	a019                	j	54e <memcmp+0x30>
      return *p1 - *p2;
 54a:	40e7853b          	subw	a0,a5,a4
}
 54e:	6422                	ld	s0,8(sp)
 550:	0141                	addi	sp,sp,16
 552:	8082                	ret
  return 0;
 554:	4501                	li	a0,0
 556:	bfe5                	j	54e <memcmp+0x30>

0000000000000558 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 558:	1141                	addi	sp,sp,-16
 55a:	e406                	sd	ra,8(sp)
 55c:	e022                	sd	s0,0(sp)
 55e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 560:	00000097          	auipc	ra,0x0
 564:	f66080e7          	jalr	-154(ra) # 4c6 <memmove>
}
 568:	60a2                	ld	ra,8(sp)
 56a:	6402                	ld	s0,0(sp)
 56c:	0141                	addi	sp,sp,16
 56e:	8082                	ret

0000000000000570 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 570:	4885                	li	a7,1
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <exit>:
.global exit
exit:
 li a7, SYS_exit
 578:	4889                	li	a7,2
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <wait>:
.global wait
wait:
 li a7, SYS_wait
 580:	488d                	li	a7,3
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 588:	4891                	li	a7,4
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <read>:
.global read
read:
 li a7, SYS_read
 590:	4895                	li	a7,5
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <write>:
.global write
write:
 li a7, SYS_write
 598:	48c1                	li	a7,16
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <close>:
.global close
close:
 li a7, SYS_close
 5a0:	48d5                	li	a7,21
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a8:	4899                	li	a7,6
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b0:	489d                	li	a7,7
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <open>:
.global open
open:
 li a7, SYS_open
 5b8:	48bd                	li	a7,15
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c0:	48c5                	li	a7,17
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c8:	48c9                	li	a7,18
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d0:	48a1                	li	a7,8
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <link>:
.global link
link:
 li a7, SYS_link
 5d8:	48cd                	li	a7,19
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e0:	48d1                	li	a7,20
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e8:	48a5                	li	a7,9
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f0:	48a9                	li	a7,10
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f8:	48ad                	li	a7,11
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 600:	48b1                	li	a7,12
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 608:	48b5                	li	a7,13
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 610:	48b9                	li	a7,14
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 618:	1101                	addi	sp,sp,-32
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	1000                	addi	s0,sp,32
 620:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 624:	4605                	li	a2,1
 626:	fef40593          	addi	a1,s0,-17
 62a:	00000097          	auipc	ra,0x0
 62e:	f6e080e7          	jalr	-146(ra) # 598 <write>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6105                	addi	sp,sp,32
 638:	8082                	ret

000000000000063a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63a:	7139                	addi	sp,sp,-64
 63c:	fc06                	sd	ra,56(sp)
 63e:	f822                	sd	s0,48(sp)
 640:	f426                	sd	s1,40(sp)
 642:	0080                	addi	s0,sp,64
 644:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 646:	c299                	beqz	a3,64c <printint+0x12>
 648:	0805cb63          	bltz	a1,6de <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64c:	2581                	sext.w	a1,a1
  neg = 0;
 64e:	4881                	li	a7,0
 650:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 654:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 656:	2601                	sext.w	a2,a2
 658:	00000517          	auipc	a0,0x0
 65c:	67050513          	addi	a0,a0,1648 # cc8 <digits>
 660:	883a                	mv	a6,a4
 662:	2705                	addiw	a4,a4,1
 664:	02c5f7bb          	remuw	a5,a1,a2
 668:	1782                	slli	a5,a5,0x20
 66a:	9381                	srli	a5,a5,0x20
 66c:	97aa                	add	a5,a5,a0
 66e:	0007c783          	lbu	a5,0(a5)
 672:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 676:	0005879b          	sext.w	a5,a1
 67a:	02c5d5bb          	divuw	a1,a1,a2
 67e:	0685                	addi	a3,a3,1
 680:	fec7f0e3          	bgeu	a5,a2,660 <printint+0x26>
  if(neg)
 684:	00088c63          	beqz	a7,69c <printint+0x62>
    buf[i++] = '-';
 688:	fd070793          	addi	a5,a4,-48
 68c:	00878733          	add	a4,a5,s0
 690:	02d00793          	li	a5,45
 694:	fef70823          	sb	a5,-16(a4)
 698:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 69c:	02e05c63          	blez	a4,6d4 <printint+0x9a>
 6a0:	f04a                	sd	s2,32(sp)
 6a2:	ec4e                	sd	s3,24(sp)
 6a4:	fc040793          	addi	a5,s0,-64
 6a8:	00e78933          	add	s2,a5,a4
 6ac:	fff78993          	addi	s3,a5,-1
 6b0:	99ba                	add	s3,s3,a4
 6b2:	377d                	addiw	a4,a4,-1
 6b4:	1702                	slli	a4,a4,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6bc:	fff94583          	lbu	a1,-1(s2)
 6c0:	8526                	mv	a0,s1
 6c2:	00000097          	auipc	ra,0x0
 6c6:	f56080e7          	jalr	-170(ra) # 618 <putc>
  while(--i >= 0)
 6ca:	197d                	addi	s2,s2,-1
 6cc:	ff3918e3          	bne	s2,s3,6bc <printint+0x82>
 6d0:	7902                	ld	s2,32(sp)
 6d2:	69e2                	ld	s3,24(sp)
}
 6d4:	70e2                	ld	ra,56(sp)
 6d6:	7442                	ld	s0,48(sp)
 6d8:	74a2                	ld	s1,40(sp)
 6da:	6121                	addi	sp,sp,64
 6dc:	8082                	ret
    x = -xx;
 6de:	40b005bb          	negw	a1,a1
    neg = 1;
 6e2:	4885                	li	a7,1
    x = -xx;
 6e4:	b7b5                	j	650 <printint+0x16>

00000000000006e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e6:	715d                	addi	sp,sp,-80
 6e8:	e486                	sd	ra,72(sp)
 6ea:	e0a2                	sd	s0,64(sp)
 6ec:	f84a                	sd	s2,48(sp)
 6ee:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f0:	0005c903          	lbu	s2,0(a1)
 6f4:	1a090a63          	beqz	s2,8a8 <vprintf+0x1c2>
 6f8:	fc26                	sd	s1,56(sp)
 6fa:	f44e                	sd	s3,40(sp)
 6fc:	f052                	sd	s4,32(sp)
 6fe:	ec56                	sd	s5,24(sp)
 700:	e85a                	sd	s6,16(sp)
 702:	e45e                	sd	s7,8(sp)
 704:	8aaa                	mv	s5,a0
 706:	8bb2                	mv	s7,a2
 708:	00158493          	addi	s1,a1,1
  state = 0;
 70c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70e:	02500a13          	li	s4,37
 712:	4b55                	li	s6,21
 714:	a839                	j	732 <vprintf+0x4c>
        putc(fd, c);
 716:	85ca                	mv	a1,s2
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	efe080e7          	jalr	-258(ra) # 618 <putc>
 722:	a019                	j	728 <vprintf+0x42>
    } else if(state == '%'){
 724:	01498d63          	beq	s3,s4,73e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 728:	0485                	addi	s1,s1,1
 72a:	fff4c903          	lbu	s2,-1(s1)
 72e:	16090763          	beqz	s2,89c <vprintf+0x1b6>
    if(state == 0){
 732:	fe0999e3          	bnez	s3,724 <vprintf+0x3e>
      if(c == '%'){
 736:	ff4910e3          	bne	s2,s4,716 <vprintf+0x30>
        state = '%';
 73a:	89d2                	mv	s3,s4
 73c:	b7f5                	j	728 <vprintf+0x42>
      if(c == 'd'){
 73e:	13490463          	beq	s2,s4,866 <vprintf+0x180>
 742:	f9d9079b          	addiw	a5,s2,-99
 746:	0ff7f793          	zext.b	a5,a5
 74a:	12fb6763          	bltu	s6,a5,878 <vprintf+0x192>
 74e:	f9d9079b          	addiw	a5,s2,-99
 752:	0ff7f713          	zext.b	a4,a5
 756:	12eb6163          	bltu	s6,a4,878 <vprintf+0x192>
 75a:	00271793          	slli	a5,a4,0x2
 75e:	00000717          	auipc	a4,0x0
 762:	51270713          	addi	a4,a4,1298 # c70 <statistics+0x1d8>
 766:	97ba                	add	a5,a5,a4
 768:	439c                	lw	a5,0(a5)
 76a:	97ba                	add	a5,a5,a4
 76c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 76e:	008b8913          	addi	s2,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	ebe080e7          	jalr	-322(ra) # 63a <printint>
 784:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 786:	4981                	li	s3,0
 788:	b745                	j	728 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	ea2080e7          	jalr	-350(ra) # 63a <printint>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b751                	j	728 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e86080e7          	jalr	-378(ra) # 63a <printint>
 7bc:	8bca                	mv	s7,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b7a5                	j	728 <vprintf+0x42>
 7c2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c4:	008b8c13          	addi	s8,s7,8
 7c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7cc:	03000593          	li	a1,48
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e46080e7          	jalr	-442(ra) # 618 <putc>
  putc(fd, 'x');
 7da:	07800593          	li	a1,120
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e38080e7          	jalr	-456(ra) # 618 <putc>
 7e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ea:	00000b97          	auipc	s7,0x0
 7ee:	4deb8b93          	addi	s7,s7,1246 # cc8 <digits>
 7f2:	03c9d793          	srli	a5,s3,0x3c
 7f6:	97de                	add	a5,a5,s7
 7f8:	0007c583          	lbu	a1,0(a5)
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	e1a080e7          	jalr	-486(ra) # 618 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 806:	0992                	slli	s3,s3,0x4
 808:	397d                	addiw	s2,s2,-1
 80a:	fe0914e3          	bnez	s2,7f2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 80e:	8be2                	mv	s7,s8
      state = 0;
 810:	4981                	li	s3,0
 812:	6c02                	ld	s8,0(sp)
 814:	bf11                	j	728 <vprintf+0x42>
        s = va_arg(ap, char*);
 816:	008b8993          	addi	s3,s7,8
 81a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 81e:	02090163          	beqz	s2,840 <vprintf+0x15a>
        while(*s != 0){
 822:	00094583          	lbu	a1,0(s2)
 826:	c9a5                	beqz	a1,896 <vprintf+0x1b0>
          putc(fd, *s);
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	dee080e7          	jalr	-530(ra) # 618 <putc>
          s++;
 832:	0905                	addi	s2,s2,1
        while(*s != 0){
 834:	00094583          	lbu	a1,0(s2)
 838:	f9e5                	bnez	a1,828 <vprintf+0x142>
        s = va_arg(ap, char*);
 83a:	8bce                	mv	s7,s3
      state = 0;
 83c:	4981                	li	s3,0
 83e:	b5ed                	j	728 <vprintf+0x42>
          s = "(null)";
 840:	00000917          	auipc	s2,0x0
 844:	40090913          	addi	s2,s2,1024 # c40 <statistics+0x1a8>
        while(*s != 0){
 848:	02800593          	li	a1,40
 84c:	bff1                	j	828 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 84e:	008b8913          	addi	s2,s7,8
 852:	000bc583          	lbu	a1,0(s7)
 856:	8556                	mv	a0,s5
 858:	00000097          	auipc	ra,0x0
 85c:	dc0080e7          	jalr	-576(ra) # 618 <putc>
 860:	8bca                	mv	s7,s2
      state = 0;
 862:	4981                	li	s3,0
 864:	b5d1                	j	728 <vprintf+0x42>
        putc(fd, c);
 866:	02500593          	li	a1,37
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	dac080e7          	jalr	-596(ra) # 618 <putc>
      state = 0;
 874:	4981                	li	s3,0
 876:	bd4d                	j	728 <vprintf+0x42>
        putc(fd, '%');
 878:	02500593          	li	a1,37
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	d9a080e7          	jalr	-614(ra) # 618 <putc>
        putc(fd, c);
 886:	85ca                	mv	a1,s2
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	d8e080e7          	jalr	-626(ra) # 618 <putc>
      state = 0;
 892:	4981                	li	s3,0
 894:	bd51                	j	728 <vprintf+0x42>
        s = va_arg(ap, char*);
 896:	8bce                	mv	s7,s3
      state = 0;
 898:	4981                	li	s3,0
 89a:	b579                	j	728 <vprintf+0x42>
 89c:	74e2                	ld	s1,56(sp)
 89e:	79a2                	ld	s3,40(sp)
 8a0:	7a02                	ld	s4,32(sp)
 8a2:	6ae2                	ld	s5,24(sp)
 8a4:	6b42                	ld	s6,16(sp)
 8a6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8a8:	60a6                	ld	ra,72(sp)
 8aa:	6406                	ld	s0,64(sp)
 8ac:	7942                	ld	s2,48(sp)
 8ae:	6161                	addi	sp,sp,80
 8b0:	8082                	ret

00000000000008b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b2:	715d                	addi	sp,sp,-80
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e010                	sd	a2,0(s0)
 8bc:	e414                	sd	a3,8(s0)
 8be:	e818                	sd	a4,16(s0)
 8c0:	ec1c                	sd	a5,24(s0)
 8c2:	03043023          	sd	a6,32(s0)
 8c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ce:	8622                	mv	a2,s0
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e16080e7          	jalr	-490(ra) # 6e6 <vprintf>
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	6161                	addi	sp,sp,80
 8de:	8082                	ret

00000000000008e0 <printf>:

void
printf(const char *fmt, ...)
{
 8e0:	711d                	addi	sp,sp,-96
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	1000                	addi	s0,sp,32
 8e8:	e40c                	sd	a1,8(s0)
 8ea:	e810                	sd	a2,16(s0)
 8ec:	ec14                	sd	a3,24(s0)
 8ee:	f018                	sd	a4,32(s0)
 8f0:	f41c                	sd	a5,40(s0)
 8f2:	03043823          	sd	a6,48(s0)
 8f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	00840613          	addi	a2,s0,8
 8fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 902:	85aa                	mv	a1,a0
 904:	4505                	li	a0,1
 906:	00000097          	auipc	ra,0x0
 90a:	de0080e7          	jalr	-544(ra) # 6e6 <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6125                	addi	sp,sp,96
 914:	8082                	ret

0000000000000916 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 916:	1141                	addi	sp,sp,-16
 918:	e422                	sd	s0,8(sp)
 91a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	00001797          	auipc	a5,0x1
 924:	8a87b783          	ld	a5,-1880(a5) # 11c8 <freep>
 928:	a02d                	j	952 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 92a:	4618                	lw	a4,8(a2)
 92c:	9f2d                	addw	a4,a4,a1
 92e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	6310                	ld	a2,0(a4)
 936:	a83d                	j	974 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 938:	ff852703          	lw	a4,-8(a0)
 93c:	9f31                	addw	a4,a4,a2
 93e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 940:	ff053683          	ld	a3,-16(a0)
 944:	a091                	j	988 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 946:	6398                	ld	a4,0(a5)
 948:	00e7e463          	bltu	a5,a4,950 <free+0x3a>
 94c:	00e6ea63          	bltu	a3,a4,960 <free+0x4a>
{
 950:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	fed7fae3          	bgeu	a5,a3,946 <free+0x30>
 956:	6398                	ld	a4,0(a5)
 958:	00e6e463          	bltu	a3,a4,960 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	fee7eae3          	bltu	a5,a4,950 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 960:	ff852583          	lw	a1,-8(a0)
 964:	6390                	ld	a2,0(a5)
 966:	02059813          	slli	a6,a1,0x20
 96a:	01c85713          	srli	a4,a6,0x1c
 96e:	9736                	add	a4,a4,a3
 970:	fae60de3          	beq	a2,a4,92a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 978:	4790                	lw	a2,8(a5)
 97a:	02061593          	slli	a1,a2,0x20
 97e:	01c5d713          	srli	a4,a1,0x1c
 982:	973e                	add	a4,a4,a5
 984:	fae68ae3          	beq	a3,a4,938 <free+0x22>
    p->s.ptr = bp->s.ptr;
 988:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 98a:	00001717          	auipc	a4,0x1
 98e:	82f73f23          	sd	a5,-1986(a4) # 11c8 <freep>
}
 992:	6422                	ld	s0,8(sp)
 994:	0141                	addi	sp,sp,16
 996:	8082                	ret

0000000000000998 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 998:	7139                	addi	sp,sp,-64
 99a:	fc06                	sd	ra,56(sp)
 99c:	f822                	sd	s0,48(sp)
 99e:	f426                	sd	s1,40(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a4:	02051493          	slli	s1,a0,0x20
 9a8:	9081                	srli	s1,s1,0x20
 9aa:	04bd                	addi	s1,s1,15
 9ac:	8091                	srli	s1,s1,0x4
 9ae:	0014899b          	addiw	s3,s1,1
 9b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b4:	00001517          	auipc	a0,0x1
 9b8:	81453503          	ld	a0,-2028(a0) # 11c8 <freep>
 9bc:	c915                	beqz	a0,9f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	08977e63          	bgeu	a4,s1,a5e <malloc+0xc6>
 9c6:	f04a                	sd	s2,32(sp)
 9c8:	e852                	sd	s4,16(sp)
 9ca:	e456                	sd	s5,8(sp)
 9cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ce:	8a4e                	mv	s4,s3
 9d0:	0009871b          	sext.w	a4,s3
 9d4:	6685                	lui	a3,0x1
 9d6:	00d77363          	bgeu	a4,a3,9dc <malloc+0x44>
 9da:	6a05                	lui	s4,0x1
 9dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e4:	00000917          	auipc	s2,0x0
 9e8:	7e490913          	addi	s2,s2,2020 # 11c8 <freep>
  if(p == (char*)-1)
 9ec:	5afd                	li	s5,-1
 9ee:	a091                	j	a32 <malloc+0x9a>
 9f0:	f04a                	sd	s2,32(sp)
 9f2:	e852                	sd	s4,16(sp)
 9f4:	e456                	sd	s5,8(sp)
 9f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f8:	00001797          	auipc	a5,0x1
 9fc:	7d878793          	addi	a5,a5,2008 # 21d0 <base>
 a00:	00000717          	auipc	a4,0x0
 a04:	7cf73423          	sd	a5,1992(a4) # 11c8 <freep>
 a08:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a0a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0e:	b7c1                	j	9ce <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	e118                	sd	a4,0(a0)
 a14:	a08d                	j	a76 <malloc+0xde>
  hp->s.size = nu;
 a16:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1a:	0541                	addi	a0,a0,16
 a1c:	00000097          	auipc	ra,0x0
 a20:	efa080e7          	jalr	-262(ra) # 916 <free>
  return freep;
 a24:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a28:	c13d                	beqz	a0,a8e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2c:	4798                	lw	a4,8(a5)
 a2e:	02977463          	bgeu	a4,s1,a56 <malloc+0xbe>
    if(p == freep)
 a32:	00093703          	ld	a4,0(s2)
 a36:	853e                	mv	a0,a5
 a38:	fef719e3          	bne	a4,a5,a2a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a3c:	8552                	mv	a0,s4
 a3e:	00000097          	auipc	ra,0x0
 a42:	bc2080e7          	jalr	-1086(ra) # 600 <sbrk>
  if(p == (char*)-1)
 a46:	fd5518e3          	bne	a0,s5,a16 <malloc+0x7e>
        return 0;
 a4a:	4501                	li	a0,0
 a4c:	7902                	ld	s2,32(sp)
 a4e:	6a42                	ld	s4,16(sp)
 a50:	6aa2                	ld	s5,8(sp)
 a52:	6b02                	ld	s6,0(sp)
 a54:	a03d                	j	a82 <malloc+0xea>
 a56:	7902                	ld	s2,32(sp)
 a58:	6a42                	ld	s4,16(sp)
 a5a:	6aa2                	ld	s5,8(sp)
 a5c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a5e:	fae489e3          	beq	s1,a4,a10 <malloc+0x78>
        p->s.size -= nunits;
 a62:	4137073b          	subw	a4,a4,s3
 a66:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a68:	02071693          	slli	a3,a4,0x20
 a6c:	01c6d713          	srli	a4,a3,0x1c
 a70:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a72:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a76:	00000717          	auipc	a4,0x0
 a7a:	74a73923          	sd	a0,1874(a4) # 11c8 <freep>
      return (void*)(p + 1);
 a7e:	01078513          	addi	a0,a5,16
  }
}
 a82:	70e2                	ld	ra,56(sp)
 a84:	7442                	ld	s0,48(sp)
 a86:	74a2                	ld	s1,40(sp)
 a88:	69e2                	ld	s3,24(sp)
 a8a:	6121                	addi	sp,sp,64
 a8c:	8082                	ret
 a8e:	7902                	ld	s2,32(sp)
 a90:	6a42                	ld	s4,16(sp)
 a92:	6aa2                	ld	s5,8(sp)
 a94:	6b02                	ld	s6,0(sp)
 a96:	b7f5                	j	a82 <malloc+0xea>

0000000000000a98 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 a98:	7179                	addi	sp,sp,-48
 a9a:	f406                	sd	ra,40(sp)
 a9c:	f022                	sd	s0,32(sp)
 a9e:	ec26                	sd	s1,24(sp)
 aa0:	e84a                	sd	s2,16(sp)
 aa2:	e44e                	sd	s3,8(sp)
 aa4:	e052                	sd	s4,0(sp)
 aa6:	1800                	addi	s0,sp,48
 aa8:	8a2a                	mv	s4,a0
 aaa:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 aac:	4581                	li	a1,0
 aae:	00000517          	auipc	a0,0x0
 ab2:	19a50513          	addi	a0,a0,410 # c48 <statistics+0x1b0>
 ab6:	00000097          	auipc	ra,0x0
 aba:	b02080e7          	jalr	-1278(ra) # 5b8 <open>
  if(fd < 0) {
 abe:	04054263          	bltz	a0,b02 <statistics+0x6a>
 ac2:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 ac4:	4481                	li	s1,0
 ac6:	03205063          	blez	s2,ae6 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 aca:	4099063b          	subw	a2,s2,s1
 ace:	009a05b3          	add	a1,s4,s1
 ad2:	854e                	mv	a0,s3
 ad4:	00000097          	auipc	ra,0x0
 ad8:	abc080e7          	jalr	-1348(ra) # 590 <read>
 adc:	00054563          	bltz	a0,ae6 <statistics+0x4e>
      break;
    }
    i += n;
 ae0:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 ae2:	ff24c4e3          	blt	s1,s2,aca <statistics+0x32>
  }
  close(fd);
 ae6:	854e                	mv	a0,s3
 ae8:	00000097          	auipc	ra,0x0
 aec:	ab8080e7          	jalr	-1352(ra) # 5a0 <close>
  return i;
}
 af0:	8526                	mv	a0,s1
 af2:	70a2                	ld	ra,40(sp)
 af4:	7402                	ld	s0,32(sp)
 af6:	64e2                	ld	s1,24(sp)
 af8:	6942                	ld	s2,16(sp)
 afa:	69a2                	ld	s3,8(sp)
 afc:	6a02                	ld	s4,0(sp)
 afe:	6145                	addi	sp,sp,48
 b00:	8082                	ret
      fprintf(2, "stats: open failed\n");
 b02:	00000597          	auipc	a1,0x0
 b06:	15658593          	addi	a1,a1,342 # c58 <statistics+0x1c0>
 b0a:	4509                	li	a0,2
 b0c:	00000097          	auipc	ra,0x0
 b10:	da6080e7          	jalr	-602(ra) # 8b2 <fprintf>
      exit(1);
 b14:	4505                	li	a0,1
 b16:	00000097          	auipc	ra,0x0
 b1a:	a62080e7          	jalr	-1438(ra) # 578 <exit>
