
user/_uthread：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	29278793          	addi	a5,a5,658 # 1298 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	26f73d23          	sd	a5,634(a4) # 1288 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	28f72023          	sw	a5,640(a4) # 3298 <__global_pointer$+0x182c>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	25a53503          	ld	a0,602(a0) # 1288 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0x60c>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009897          	auipc	a7,0x9
  44:	43888893          	addi	a7,a7,1080 # 9478 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6809                	lui	a6,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	6689                	lui	a3,0x2
  4e:	07868693          	addi	a3,a3,120 # 2078 <__global_pointer$+0x60c>
  52:	a809                	j	64 <thread_schedule+0x3e>
    if(t->state == RUNNABLE) {
  54:	01058733          	add	a4,a1,a6
  58:	4318                	lw	a4,0(a4)
  5a:	02c70963          	beq	a4,a2,8c <thread_schedule+0x66>
    t = t + 1;
  5e:	95b6                	add	a1,a1,a3
  for(int i = 0; i < MAX_THREAD; i++){
  60:	37fd                	addiw	a5,a5,-1
  62:	cb81                	beqz	a5,72 <thread_schedule+0x4c>
    if(t >= all_thread + MAX_THREAD)
  64:	ff15e8e3          	bltu	a1,a7,54 <thread_schedule+0x2e>
      t = all_thread;
  68:	00001597          	auipc	a1,0x1
  6c:	23058593          	addi	a1,a1,560 # 1298 <all_thread>
  70:	b7d5                	j	54 <thread_schedule+0x2e>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  72:	00001517          	auipc	a0,0x1
  76:	b8e50513          	addi	a0,a0,-1138 # c00 <malloc+0x106>
  7a:	00001097          	auipc	ra,0x1
  7e:	9c8080e7          	jalr	-1592(ra) # a42 <printf>
    exit(-1);
  82:	557d                	li	a0,-1
  84:	00000097          	auipc	ra,0x0
  88:	656080e7          	jalr	1622(ra) # 6da <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8c:	02b50263          	beq	a0,a1,b0 <thread_schedule+0x8a>
    next_thread->state = RUNNING;
  90:	6789                	lui	a5,0x2
  92:	97ae                	add	a5,a5,a1
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	1eb7b823          	sd	a1,496(a5) # 1288 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64)&t->context,(uint64)&next_thread->context);
  a0:	6789                	lui	a5,0x2
  a2:	07a1                	addi	a5,a5,8 # 2008 <__global_pointer$+0x59c>
  a4:	95be                	add	a1,a1,a5
  a6:	953e                	add	a0,a0,a5
  a8:	00000097          	auipc	ra,0x0
  ac:	35c080e7          	jalr	860(ra) # 404 <thread_switch>
  } else
    next_thread = 0;
}
  b0:	60a2                	ld	ra,8(sp)
  b2:	6402                	ld	s0,0(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <thread_create>:

void 
thread_create(void (*func)())
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  be:	00001797          	auipc	a5,0x1
  c2:	1da78793          	addi	a5,a5,474 # 1298 <all_thread>
    if (t->state == FREE) break;
  c6:	6609                	lui	a2,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c8:	6689                	lui	a3,0x2
  ca:	07868693          	addi	a3,a3,120 # 2078 <__global_pointer$+0x60c>
  ce:	00009597          	auipc	a1,0x9
  d2:	3aa58593          	addi	a1,a1,938 # 9478 <base>
    if (t->state == FREE) break;
  d6:	00c78733          	add	a4,a5,a2
  da:	4318                	lw	a4,0(a4)
  dc:	c701                	beqz	a4,e4 <thread_create+0x2c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  de:	97b6                	add	a5,a5,a3
  e0:	feb79be3          	bne	a5,a1,d6 <thread_create+0x1e>
  }
  t->state = RUNNABLE;
  e4:	6709                	lui	a4,0x2
  e6:	97ba                	add	a5,a5,a4
  e8:	4709                	li	a4,2
  ea:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
  t->context.sp = (uint64)&t -> stack+(STACK_SIZE);
  ec:	eb9c                	sd	a5,16(a5)
  t->context.ra = (uint64)func;
  ee:	e788                	sd	a0,8(a5)
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <thread_yield>:

void 
thread_yield(void)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  fe:	00001797          	auipc	a5,0x1
 102:	18a7b783          	ld	a5,394(a5) # 1288 <current_thread>
 106:	6709                	lui	a4,0x2
 108:	97ba                	add	a5,a5,a4
 10a:	4709                	li	a4,2
 10c:	c398                	sw	a4,0(a5)
  thread_schedule();
 10e:	00000097          	auipc	ra,0x0
 112:	f18080e7          	jalr	-232(ra) # 26 <thread_schedule>
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11e:	7179                	addi	sp,sp,-48
 120:	f406                	sd	ra,40(sp)
 122:	f022                	sd	s0,32(sp)
 124:	ec26                	sd	s1,24(sp)
 126:	e84a                	sd	s2,16(sp)
 128:	e44e                	sd	s3,8(sp)
 12a:	e052                	sd	s4,0(sp)
 12c:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 12e:	00001517          	auipc	a0,0x1
 132:	afa50513          	addi	a0,a0,-1286 # c28 <malloc+0x12e>
 136:	00001097          	auipc	ra,0x1
 13a:	90c080e7          	jalr	-1780(ra) # a42 <printf>
  a_started = 1;
 13e:	4785                	li	a5,1
 140:	00001717          	auipc	a4,0x1
 144:	14f72223          	sw	a5,324(a4) # 1284 <a_started>
  while(b_started == 0 || c_started == 0)
 148:	00001497          	auipc	s1,0x1
 14c:	13848493          	addi	s1,s1,312 # 1280 <b_started>
 150:	00001917          	auipc	s2,0x1
 154:	12c90913          	addi	s2,s2,300 # 127c <c_started>
 158:	a029                	j	162 <thread_a+0x44>
    thread_yield();
 15a:	00000097          	auipc	ra,0x0
 15e:	f9c080e7          	jalr	-100(ra) # f6 <thread_yield>
  while(b_started == 0 || c_started == 0)
 162:	409c                	lw	a5,0(s1)
 164:	2781                	sext.w	a5,a5
 166:	dbf5                	beqz	a5,15a <thread_a+0x3c>
 168:	00092783          	lw	a5,0(s2)
 16c:	2781                	sext.w	a5,a5
 16e:	d7f5                	beqz	a5,15a <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 170:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 172:	00001a17          	auipc	s4,0x1
 176:	acea0a13          	addi	s4,s4,-1330 # c40 <malloc+0x146>
    a_n += 1;
 17a:	00001917          	auipc	s2,0x1
 17e:	0fe90913          	addi	s2,s2,254 # 1278 <a_n>
  for (i = 0; i < 100; i++) {
 182:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 186:	85a6                	mv	a1,s1
 188:	8552                	mv	a0,s4
 18a:	00001097          	auipc	ra,0x1
 18e:	8b8080e7          	jalr	-1864(ra) # a42 <printf>
    a_n += 1;
 192:	00092783          	lw	a5,0(s2)
 196:	2785                	addiw	a5,a5,1
 198:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19c:	00000097          	auipc	ra,0x0
 1a0:	f5a080e7          	jalr	-166(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a4:	2485                	addiw	s1,s1,1
 1a6:	ff3490e3          	bne	s1,s3,186 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1aa:	00001597          	auipc	a1,0x1
 1ae:	0ce5a583          	lw	a1,206(a1) # 1278 <a_n>
 1b2:	00001517          	auipc	a0,0x1
 1b6:	a9e50513          	addi	a0,a0,-1378 # c50 <malloc+0x156>
 1ba:	00001097          	auipc	ra,0x1
 1be:	888080e7          	jalr	-1912(ra) # a42 <printf>

  current_thread->state = FREE;
 1c2:	00001797          	auipc	a5,0x1
 1c6:	0c67b783          	ld	a5,198(a5) # 1288 <current_thread>
 1ca:	6709                	lui	a4,0x2
 1cc:	97ba                	add	a5,a5,a4
 1ce:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	e54080e7          	jalr	-428(ra) # 26 <thread_schedule>
}
 1da:	70a2                	ld	ra,40(sp)
 1dc:	7402                	ld	s0,32(sp)
 1de:	64e2                	ld	s1,24(sp)
 1e0:	6942                	ld	s2,16(sp)
 1e2:	69a2                	ld	s3,8(sp)
 1e4:	6a02                	ld	s4,0(sp)
 1e6:	6145                	addi	sp,sp,48
 1e8:	8082                	ret

00000000000001ea <thread_b>:

void 
thread_b(void)
{
 1ea:	7179                	addi	sp,sp,-48
 1ec:	f406                	sd	ra,40(sp)
 1ee:	f022                	sd	s0,32(sp)
 1f0:	ec26                	sd	s1,24(sp)
 1f2:	e84a                	sd	s2,16(sp)
 1f4:	e44e                	sd	s3,8(sp)
 1f6:	e052                	sd	s4,0(sp)
 1f8:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fa:	00001517          	auipc	a0,0x1
 1fe:	a7650513          	addi	a0,a0,-1418 # c70 <malloc+0x176>
 202:	00001097          	auipc	ra,0x1
 206:	840080e7          	jalr	-1984(ra) # a42 <printf>
  b_started = 1;
 20a:	4785                	li	a5,1
 20c:	00001717          	auipc	a4,0x1
 210:	06f72a23          	sw	a5,116(a4) # 1280 <b_started>
  while(a_started == 0 || c_started == 0)
 214:	00001497          	auipc	s1,0x1
 218:	07048493          	addi	s1,s1,112 # 1284 <a_started>
 21c:	00001917          	auipc	s2,0x1
 220:	06090913          	addi	s2,s2,96 # 127c <c_started>
 224:	a029                	j	22e <thread_b+0x44>
    thread_yield();
 226:	00000097          	auipc	ra,0x0
 22a:	ed0080e7          	jalr	-304(ra) # f6 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22e:	409c                	lw	a5,0(s1)
 230:	2781                	sext.w	a5,a5
 232:	dbf5                	beqz	a5,226 <thread_b+0x3c>
 234:	00092783          	lw	a5,0(s2)
 238:	2781                	sext.w	a5,a5
 23a:	d7f5                	beqz	a5,226 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23c:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23e:	00001a17          	auipc	s4,0x1
 242:	a4aa0a13          	addi	s4,s4,-1462 # c88 <malloc+0x18e>
    b_n += 1;
 246:	00001917          	auipc	s2,0x1
 24a:	02e90913          	addi	s2,s2,46 # 1274 <b_n>
  for (i = 0; i < 100; i++) {
 24e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 252:	85a6                	mv	a1,s1
 254:	8552                	mv	a0,s4
 256:	00000097          	auipc	ra,0x0
 25a:	7ec080e7          	jalr	2028(ra) # a42 <printf>
    b_n += 1;
 25e:	00092783          	lw	a5,0(s2)
 262:	2785                	addiw	a5,a5,1
 264:	00f92023          	sw	a5,0(s2)
    thread_yield();
 268:	00000097          	auipc	ra,0x0
 26c:	e8e080e7          	jalr	-370(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 270:	2485                	addiw	s1,s1,1
 272:	ff3490e3          	bne	s1,s3,252 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 276:	00001597          	auipc	a1,0x1
 27a:	ffe5a583          	lw	a1,-2(a1) # 1274 <b_n>
 27e:	00001517          	auipc	a0,0x1
 282:	a1a50513          	addi	a0,a0,-1510 # c98 <malloc+0x19e>
 286:	00000097          	auipc	ra,0x0
 28a:	7bc080e7          	jalr	1980(ra) # a42 <printf>

  current_thread->state = FREE;
 28e:	00001797          	auipc	a5,0x1
 292:	ffa7b783          	ld	a5,-6(a5) # 1288 <current_thread>
 296:	6709                	lui	a4,0x2
 298:	97ba                	add	a5,a5,a4
 29a:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 29e:	00000097          	auipc	ra,0x0
 2a2:	d88080e7          	jalr	-632(ra) # 26 <thread_schedule>
}
 2a6:	70a2                	ld	ra,40(sp)
 2a8:	7402                	ld	s0,32(sp)
 2aa:	64e2                	ld	s1,24(sp)
 2ac:	6942                	ld	s2,16(sp)
 2ae:	69a2                	ld	s3,8(sp)
 2b0:	6a02                	ld	s4,0(sp)
 2b2:	6145                	addi	sp,sp,48
 2b4:	8082                	ret

00000000000002b6 <thread_c>:

void 
thread_c(void)
{
 2b6:	7179                	addi	sp,sp,-48
 2b8:	f406                	sd	ra,40(sp)
 2ba:	f022                	sd	s0,32(sp)
 2bc:	ec26                	sd	s1,24(sp)
 2be:	e84a                	sd	s2,16(sp)
 2c0:	e44e                	sd	s3,8(sp)
 2c2:	e052                	sd	s4,0(sp)
 2c4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	9f250513          	addi	a0,a0,-1550 # cb8 <malloc+0x1be>
 2ce:	00000097          	auipc	ra,0x0
 2d2:	774080e7          	jalr	1908(ra) # a42 <printf>
  c_started = 1;
 2d6:	4785                	li	a5,1
 2d8:	00001717          	auipc	a4,0x1
 2dc:	faf72223          	sw	a5,-92(a4) # 127c <c_started>
  while(a_started == 0 || b_started == 0)
 2e0:	00001497          	auipc	s1,0x1
 2e4:	fa448493          	addi	s1,s1,-92 # 1284 <a_started>
 2e8:	00001917          	auipc	s2,0x1
 2ec:	f9890913          	addi	s2,s2,-104 # 1280 <b_started>
 2f0:	a029                	j	2fa <thread_c+0x44>
    thread_yield();
 2f2:	00000097          	auipc	ra,0x0
 2f6:	e04080e7          	jalr	-508(ra) # f6 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fa:	409c                	lw	a5,0(s1)
 2fc:	2781                	sext.w	a5,a5
 2fe:	dbf5                	beqz	a5,2f2 <thread_c+0x3c>
 300:	00092783          	lw	a5,0(s2)
 304:	2781                	sext.w	a5,a5
 306:	d7f5                	beqz	a5,2f2 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 308:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30a:	00001a17          	auipc	s4,0x1
 30e:	9c6a0a13          	addi	s4,s4,-1594 # cd0 <malloc+0x1d6>
    c_n += 1;
 312:	00001917          	auipc	s2,0x1
 316:	f5e90913          	addi	s2,s2,-162 # 1270 <c_n>
  for (i = 0; i < 100; i++) {
 31a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31e:	85a6                	mv	a1,s1
 320:	8552                	mv	a0,s4
 322:	00000097          	auipc	ra,0x0
 326:	720080e7          	jalr	1824(ra) # a42 <printf>
    c_n += 1;
 32a:	00092783          	lw	a5,0(s2)
 32e:	2785                	addiw	a5,a5,1
 330:	00f92023          	sw	a5,0(s2)
    thread_yield();
 334:	00000097          	auipc	ra,0x0
 338:	dc2080e7          	jalr	-574(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 33c:	2485                	addiw	s1,s1,1
 33e:	ff3490e3          	bne	s1,s3,31e <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 342:	00001597          	auipc	a1,0x1
 346:	f2e5a583          	lw	a1,-210(a1) # 1270 <c_n>
 34a:	00001517          	auipc	a0,0x1
 34e:	99650513          	addi	a0,a0,-1642 # ce0 <malloc+0x1e6>
 352:	00000097          	auipc	ra,0x0
 356:	6f0080e7          	jalr	1776(ra) # a42 <printf>

  current_thread->state = FREE;
 35a:	00001797          	auipc	a5,0x1
 35e:	f2e7b783          	ld	a5,-210(a5) # 1288 <current_thread>
 362:	6709                	lui	a4,0x2
 364:	97ba                	add	a5,a5,a4
 366:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 36a:	00000097          	auipc	ra,0x0
 36e:	cbc080e7          	jalr	-836(ra) # 26 <thread_schedule>
}
 372:	70a2                	ld	ra,40(sp)
 374:	7402                	ld	s0,32(sp)
 376:	64e2                	ld	s1,24(sp)
 378:	6942                	ld	s2,16(sp)
 37a:	69a2                	ld	s3,8(sp)
 37c:	6a02                	ld	s4,0(sp)
 37e:	6145                	addi	sp,sp,48
 380:	8082                	ret

0000000000000382 <main>:

int 
main(int argc, char *argv[]) 
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 38a:	00001797          	auipc	a5,0x1
 38e:	ee07a923          	sw	zero,-270(a5) # 127c <c_started>
 392:	00001797          	auipc	a5,0x1
 396:	ee07a723          	sw	zero,-274(a5) # 1280 <b_started>
 39a:	00001797          	auipc	a5,0x1
 39e:	ee07a523          	sw	zero,-278(a5) # 1284 <a_started>
  a_n = b_n = c_n = 0;
 3a2:	00001797          	auipc	a5,0x1
 3a6:	ec07a723          	sw	zero,-306(a5) # 1270 <c_n>
 3aa:	00001797          	auipc	a5,0x1
 3ae:	ec07a523          	sw	zero,-310(a5) # 1274 <b_n>
 3b2:	00001797          	auipc	a5,0x1
 3b6:	ec07a323          	sw	zero,-314(a5) # 1278 <a_n>
  thread_init();
 3ba:	00000097          	auipc	ra,0x0
 3be:	c46080e7          	jalr	-954(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c2:	00000517          	auipc	a0,0x0
 3c6:	d5c50513          	addi	a0,a0,-676 # 11e <thread_a>
 3ca:	00000097          	auipc	ra,0x0
 3ce:	cee080e7          	jalr	-786(ra) # b8 <thread_create>
  thread_create(thread_b);
 3d2:	00000517          	auipc	a0,0x0
 3d6:	e1850513          	addi	a0,a0,-488 # 1ea <thread_b>
 3da:	00000097          	auipc	ra,0x0
 3de:	cde080e7          	jalr	-802(ra) # b8 <thread_create>
  thread_create(thread_c);
 3e2:	00000517          	auipc	a0,0x0
 3e6:	ed450513          	addi	a0,a0,-300 # 2b6 <thread_c>
 3ea:	00000097          	auipc	ra,0x0
 3ee:	cce080e7          	jalr	-818(ra) # b8 <thread_create>
  thread_schedule();
 3f2:	00000097          	auipc	ra,0x0
 3f6:	c34080e7          	jalr	-972(ra) # 26 <thread_schedule>
  exit(0);
 3fa:	4501                	li	a0,0
 3fc:	00000097          	auipc	ra,0x0
 400:	2de080e7          	jalr	734(ra) # 6da <exit>

0000000000000404 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	sd ra, 0(a0)
 404:	00153023          	sd	ra,0(a0)
	sd sp, 8(a0)
 408:	00253423          	sd	sp,8(a0)
	sd s0, 16(a0)
 40c:	e900                	sd	s0,16(a0)
	sd s1, 24(a0)
 40e:	ed04                	sd	s1,24(a0)
	sd s2, 32(a0)
 410:	03253023          	sd	s2,32(a0)
	sd s3, 40(a0)
 414:	03353423          	sd	s3,40(a0)
	sd s4, 48(a0)
 418:	03453823          	sd	s4,48(a0)
	sd s5, 56(a0)
 41c:	03553c23          	sd	s5,56(a0)
	sd s6, 64(a0)
 420:	05653023          	sd	s6,64(a0)
	sd s7, 72(a0)
 424:	05753423          	sd	s7,72(a0)
	sd s8, 80(a0)
 428:	05853823          	sd	s8,80(a0)
	sd s9, 88(a0)
 42c:	05953c23          	sd	s9,88(a0)
	sd s10, 96(a0)
 430:	07a53023          	sd	s10,96(a0)
	sd s11, 104(a0)
 434:	07b53423          	sd	s11,104(a0)
	ld ra, 0(a1)
 438:	0005b083          	ld	ra,0(a1)
	ld sp, 8(a1)
 43c:	0085b103          	ld	sp,8(a1)
	ld s0, 16(a1)
 440:	6980                	ld	s0,16(a1)
	ld s1, 24(a1)
 442:	6d84                	ld	s1,24(a1)
	ld s2, 32(a1)
 444:	0205b903          	ld	s2,32(a1)
	ld s3, 40(a1)
 448:	0285b983          	ld	s3,40(a1)
	ld s4, 48(a1)
 44c:	0305ba03          	ld	s4,48(a1)
	ld s5, 56(a1)
 450:	0385ba83          	ld	s5,56(a1)
	ld s6, 64(a1)
 454:	0405bb03          	ld	s6,64(a1)
	ld s7, 72(a1)
 458:	0485bb83          	ld	s7,72(a1)
	ld s8, 80(a1)
 45c:	0505bc03          	ld	s8,80(a1)
	ld s9, 88(a1)
 460:	0585bc83          	ld	s9,88(a1)
	ld s10, 96(a1)
 464:	0605bd03          	ld	s10,96(a1)
	ld s11, 104(a1)
 468:	0685bd83          	ld	s11,104(a1)
	ret    /* return to ra */
 46c:	8082                	ret

000000000000046e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 474:	87aa                	mv	a5,a0
 476:	0585                	addi	a1,a1,1
 478:	0785                	addi	a5,a5,1
 47a:	fff5c703          	lbu	a4,-1(a1)
 47e:	fee78fa3          	sb	a4,-1(a5)
 482:	fb75                	bnez	a4,476 <strcpy+0x8>
    ;
  return os;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret

000000000000048a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 490:	00054783          	lbu	a5,0(a0)
 494:	cb91                	beqz	a5,4a8 <strcmp+0x1e>
 496:	0005c703          	lbu	a4,0(a1)
 49a:	00f71763          	bne	a4,a5,4a8 <strcmp+0x1e>
    p++, q++;
 49e:	0505                	addi	a0,a0,1
 4a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	fbe5                	bnez	a5,496 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4a8:	0005c503          	lbu	a0,0(a1)
}
 4ac:	40a7853b          	subw	a0,a5,a0
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <strlen>:

uint
strlen(const char *s)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e422                	sd	s0,8(sp)
 4ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	cf91                	beqz	a5,4dc <strlen+0x26>
 4c2:	0505                	addi	a0,a0,1
 4c4:	87aa                	mv	a5,a0
 4c6:	86be                	mv	a3,a5
 4c8:	0785                	addi	a5,a5,1
 4ca:	fff7c703          	lbu	a4,-1(a5)
 4ce:	ff65                	bnez	a4,4c6 <strlen+0x10>
 4d0:	40a6853b          	subw	a0,a3,a0
 4d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
  for(n = 0; s[n]; n++)
 4dc:	4501                	li	a0,0
 4de:	bfe5                	j	4d6 <strlen+0x20>

00000000000004e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e422                	sd	s0,8(sp)
 4e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e6:	ca19                	beqz	a2,4fc <memset+0x1c>
 4e8:	87aa                	mv	a5,a0
 4ea:	1602                	slli	a2,a2,0x20
 4ec:	9201                	srli	a2,a2,0x20
 4ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f6:	0785                	addi	a5,a5,1
 4f8:	fee79de3          	bne	a5,a4,4f2 <memset+0x12>
  }
  return dst;
}
 4fc:	6422                	ld	s0,8(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <strchr>:

char*
strchr(const char *s, char c)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  for(; *s; s++)
 508:	00054783          	lbu	a5,0(a0)
 50c:	cb99                	beqz	a5,522 <strchr+0x20>
    if(*s == c)
 50e:	00f58763          	beq	a1,a5,51c <strchr+0x1a>
  for(; *s; s++)
 512:	0505                	addi	a0,a0,1
 514:	00054783          	lbu	a5,0(a0)
 518:	fbfd                	bnez	a5,50e <strchr+0xc>
      return (char*)s;
  return 0;
 51a:	4501                	li	a0,0
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret
  return 0;
 522:	4501                	li	a0,0
 524:	bfe5                	j	51c <strchr+0x1a>

0000000000000526 <gets>:

char*
gets(char *buf, int max)
{
 526:	711d                	addi	sp,sp,-96
 528:	ec86                	sd	ra,88(sp)
 52a:	e8a2                	sd	s0,80(sp)
 52c:	e4a6                	sd	s1,72(sp)
 52e:	e0ca                	sd	s2,64(sp)
 530:	fc4e                	sd	s3,56(sp)
 532:	f852                	sd	s4,48(sp)
 534:	f456                	sd	s5,40(sp)
 536:	f05a                	sd	s6,32(sp)
 538:	ec5e                	sd	s7,24(sp)
 53a:	1080                	addi	s0,sp,96
 53c:	8baa                	mv	s7,a0
 53e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 540:	892a                	mv	s2,a0
 542:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 544:	4aa9                	li	s5,10
 546:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 548:	89a6                	mv	s3,s1
 54a:	2485                	addiw	s1,s1,1
 54c:	0344d863          	bge	s1,s4,57c <gets+0x56>
    cc = read(0, &c, 1);
 550:	4605                	li	a2,1
 552:	faf40593          	addi	a1,s0,-81
 556:	4501                	li	a0,0
 558:	00000097          	auipc	ra,0x0
 55c:	19a080e7          	jalr	410(ra) # 6f2 <read>
    if(cc < 1)
 560:	00a05e63          	blez	a0,57c <gets+0x56>
    buf[i++] = c;
 564:	faf44783          	lbu	a5,-81(s0)
 568:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56c:	01578763          	beq	a5,s5,57a <gets+0x54>
 570:	0905                	addi	s2,s2,1
 572:	fd679be3          	bne	a5,s6,548 <gets+0x22>
    buf[i++] = c;
 576:	89a6                	mv	s3,s1
 578:	a011                	j	57c <gets+0x56>
 57a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57c:	99de                	add	s3,s3,s7
 57e:	00098023          	sb	zero,0(s3)
  return buf;
}
 582:	855e                	mv	a0,s7
 584:	60e6                	ld	ra,88(sp)
 586:	6446                	ld	s0,80(sp)
 588:	64a6                	ld	s1,72(sp)
 58a:	6906                	ld	s2,64(sp)
 58c:	79e2                	ld	s3,56(sp)
 58e:	7a42                	ld	s4,48(sp)
 590:	7aa2                	ld	s5,40(sp)
 592:	7b02                	ld	s6,32(sp)
 594:	6be2                	ld	s7,24(sp)
 596:	6125                	addi	sp,sp,96
 598:	8082                	ret

000000000000059a <stat>:

int
stat(const char *n, struct stat *st)
{
 59a:	1101                	addi	sp,sp,-32
 59c:	ec06                	sd	ra,24(sp)
 59e:	e822                	sd	s0,16(sp)
 5a0:	e04a                	sd	s2,0(sp)
 5a2:	1000                	addi	s0,sp,32
 5a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a6:	4581                	li	a1,0
 5a8:	00000097          	auipc	ra,0x0
 5ac:	172080e7          	jalr	370(ra) # 71a <open>
  if(fd < 0)
 5b0:	02054663          	bltz	a0,5dc <stat+0x42>
 5b4:	e426                	sd	s1,8(sp)
 5b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b8:	85ca                	mv	a1,s2
 5ba:	00000097          	auipc	ra,0x0
 5be:	178080e7          	jalr	376(ra) # 732 <fstat>
 5c2:	892a                	mv	s2,a0
  close(fd);
 5c4:	8526                	mv	a0,s1
 5c6:	00000097          	auipc	ra,0x0
 5ca:	13c080e7          	jalr	316(ra) # 702 <close>
  return r;
 5ce:	64a2                	ld	s1,8(sp)
}
 5d0:	854a                	mv	a0,s2
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	6902                	ld	s2,0(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret
    return -1;
 5dc:	597d                	li	s2,-1
 5de:	bfcd                	j	5d0 <stat+0x36>

00000000000005e0 <atoi>:

int
atoi(const char *s)
{
 5e0:	1141                	addi	sp,sp,-16
 5e2:	e422                	sd	s0,8(sp)
 5e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e6:	00054683          	lbu	a3,0(a0)
 5ea:	fd06879b          	addiw	a5,a3,-48
 5ee:	0ff7f793          	zext.b	a5,a5
 5f2:	4625                	li	a2,9
 5f4:	02f66863          	bltu	a2,a5,624 <atoi+0x44>
 5f8:	872a                	mv	a4,a0
  n = 0;
 5fa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5fc:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0x595>
 5fe:	0025179b          	slliw	a5,a0,0x2
 602:	9fa9                	addw	a5,a5,a0
 604:	0017979b          	slliw	a5,a5,0x1
 608:	9fb5                	addw	a5,a5,a3
 60a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 60e:	00074683          	lbu	a3,0(a4)
 612:	fd06879b          	addiw	a5,a3,-48
 616:	0ff7f793          	zext.b	a5,a5
 61a:	fef671e3          	bgeu	a2,a5,5fc <atoi+0x1c>
  return n;
}
 61e:	6422                	ld	s0,8(sp)
 620:	0141                	addi	sp,sp,16
 622:	8082                	ret
  n = 0;
 624:	4501                	li	a0,0
 626:	bfe5                	j	61e <atoi+0x3e>

0000000000000628 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 628:	1141                	addi	sp,sp,-16
 62a:	e422                	sd	s0,8(sp)
 62c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 62e:	02b57463          	bgeu	a0,a1,656 <memmove+0x2e>
    while(n-- > 0)
 632:	00c05f63          	blez	a2,650 <memmove+0x28>
 636:	1602                	slli	a2,a2,0x20
 638:	9201                	srli	a2,a2,0x20
 63a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 63e:	872a                	mv	a4,a0
      *dst++ = *src++;
 640:	0585                	addi	a1,a1,1
 642:	0705                	addi	a4,a4,1
 644:	fff5c683          	lbu	a3,-1(a1)
 648:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 64c:	fef71ae3          	bne	a4,a5,640 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 650:	6422                	ld	s0,8(sp)
 652:	0141                	addi	sp,sp,16
 654:	8082                	ret
    dst += n;
 656:	00c50733          	add	a4,a0,a2
    src += n;
 65a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 65c:	fec05ae3          	blez	a2,650 <memmove+0x28>
 660:	fff6079b          	addiw	a5,a2,-1 # 1fff <__global_pointer$+0x593>
 664:	1782                	slli	a5,a5,0x20
 666:	9381                	srli	a5,a5,0x20
 668:	fff7c793          	not	a5,a5
 66c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 66e:	15fd                	addi	a1,a1,-1
 670:	177d                	addi	a4,a4,-1
 672:	0005c683          	lbu	a3,0(a1)
 676:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 67a:	fee79ae3          	bne	a5,a4,66e <memmove+0x46>
 67e:	bfc9                	j	650 <memmove+0x28>

0000000000000680 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 680:	1141                	addi	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 686:	ca05                	beqz	a2,6b6 <memcmp+0x36>
 688:	fff6069b          	addiw	a3,a2,-1
 68c:	1682                	slli	a3,a3,0x20
 68e:	9281                	srli	a3,a3,0x20
 690:	0685                	addi	a3,a3,1
 692:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 694:	00054783          	lbu	a5,0(a0)
 698:	0005c703          	lbu	a4,0(a1)
 69c:	00e79863          	bne	a5,a4,6ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a0:	0505                	addi	a0,a0,1
    p2++;
 6a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a4:	fed518e3          	bne	a0,a3,694 <memcmp+0x14>
  }
  return 0;
 6a8:	4501                	li	a0,0
 6aa:	a019                	j	6b0 <memcmp+0x30>
      return *p1 - *p2;
 6ac:	40e7853b          	subw	a0,a5,a4
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret
  return 0;
 6b6:	4501                	li	a0,0
 6b8:	bfe5                	j	6b0 <memcmp+0x30>

00000000000006ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6ba:	1141                	addi	sp,sp,-16
 6bc:	e406                	sd	ra,8(sp)
 6be:	e022                	sd	s0,0(sp)
 6c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c2:	00000097          	auipc	ra,0x0
 6c6:	f66080e7          	jalr	-154(ra) # 628 <memmove>
}
 6ca:	60a2                	ld	ra,8(sp)
 6cc:	6402                	ld	s0,0(sp)
 6ce:	0141                	addi	sp,sp,16
 6d0:	8082                	ret

00000000000006d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d2:	4885                	li	a7,1
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <exit>:
.global exit
exit:
 li a7, SYS_exit
 6da:	4889                	li	a7,2
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6e2:	488d                	li	a7,3
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6ea:	4891                	li	a7,4
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <read>:
.global read
read:
 li a7, SYS_read
 6f2:	4895                	li	a7,5
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <write>:
.global write
write:
 li a7, SYS_write
 6fa:	48c1                	li	a7,16
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <close>:
.global close
close:
 li a7, SYS_close
 702:	48d5                	li	a7,21
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <kill>:
.global kill
kill:
 li a7, SYS_kill
 70a:	4899                	li	a7,6
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <exec>:
.global exec
exec:
 li a7, SYS_exec
 712:	489d                	li	a7,7
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <open>:
.global open
open:
 li a7, SYS_open
 71a:	48bd                	li	a7,15
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 722:	48c5                	li	a7,17
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 72a:	48c9                	li	a7,18
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 732:	48a1                	li	a7,8
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <link>:
.global link
link:
 li a7, SYS_link
 73a:	48cd                	li	a7,19
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 742:	48d1                	li	a7,20
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 74a:	48a5                	li	a7,9
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <dup>:
.global dup
dup:
 li a7, SYS_dup
 752:	48a9                	li	a7,10
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 75a:	48ad                	li	a7,11
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 762:	48b1                	li	a7,12
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 76a:	48b5                	li	a7,13
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 772:	48b9                	li	a7,14
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77a:	1101                	addi	sp,sp,-32
 77c:	ec06                	sd	ra,24(sp)
 77e:	e822                	sd	s0,16(sp)
 780:	1000                	addi	s0,sp,32
 782:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 786:	4605                	li	a2,1
 788:	fef40593          	addi	a1,s0,-17
 78c:	00000097          	auipc	ra,0x0
 790:	f6e080e7          	jalr	-146(ra) # 6fa <write>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6105                	addi	sp,sp,32
 79a:	8082                	ret

000000000000079c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	0080                	addi	s0,sp,64
 7a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a8:	c299                	beqz	a3,7ae <printint+0x12>
 7aa:	0805cb63          	bltz	a1,840 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ae:	2581                	sext.w	a1,a1
  neg = 0;
 7b0:	4881                	li	a7,0
 7b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b8:	2601                	sext.w	a2,a2
 7ba:	00000517          	auipc	a0,0x0
 7be:	5a650513          	addi	a0,a0,1446 # d60 <digits>
 7c2:	883a                	mv	a6,a4
 7c4:	2705                	addiw	a4,a4,1
 7c6:	02c5f7bb          	remuw	a5,a1,a2
 7ca:	1782                	slli	a5,a5,0x20
 7cc:	9381                	srli	a5,a5,0x20
 7ce:	97aa                	add	a5,a5,a0
 7d0:	0007c783          	lbu	a5,0(a5)
 7d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d8:	0005879b          	sext.w	a5,a1
 7dc:	02c5d5bb          	divuw	a1,a1,a2
 7e0:	0685                	addi	a3,a3,1
 7e2:	fec7f0e3          	bgeu	a5,a2,7c2 <printint+0x26>
  if(neg)
 7e6:	00088c63          	beqz	a7,7fe <printint+0x62>
    buf[i++] = '-';
 7ea:	fd070793          	addi	a5,a4,-48
 7ee:	00878733          	add	a4,a5,s0
 7f2:	02d00793          	li	a5,45
 7f6:	fef70823          	sb	a5,-16(a4)
 7fa:	0028071b          	addiw	a4,a6,2 # 2002 <__global_pointer$+0x596>

  while(--i >= 0)
 7fe:	02e05c63          	blez	a4,836 <printint+0x9a>
 802:	f04a                	sd	s2,32(sp)
 804:	ec4e                	sd	s3,24(sp)
 806:	fc040793          	addi	a5,s0,-64
 80a:	00e78933          	add	s2,a5,a4
 80e:	fff78993          	addi	s3,a5,-1
 812:	99ba                	add	s3,s3,a4
 814:	377d                	addiw	a4,a4,-1
 816:	1702                	slli	a4,a4,0x20
 818:	9301                	srli	a4,a4,0x20
 81a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 81e:	fff94583          	lbu	a1,-1(s2)
 822:	8526                	mv	a0,s1
 824:	00000097          	auipc	ra,0x0
 828:	f56080e7          	jalr	-170(ra) # 77a <putc>
  while(--i >= 0)
 82c:	197d                	addi	s2,s2,-1
 82e:	ff3918e3          	bne	s2,s3,81e <printint+0x82>
 832:	7902                	ld	s2,32(sp)
 834:	69e2                	ld	s3,24(sp)
}
 836:	70e2                	ld	ra,56(sp)
 838:	7442                	ld	s0,48(sp)
 83a:	74a2                	ld	s1,40(sp)
 83c:	6121                	addi	sp,sp,64
 83e:	8082                	ret
    x = -xx;
 840:	40b005bb          	negw	a1,a1
    neg = 1;
 844:	4885                	li	a7,1
    x = -xx;
 846:	b7b5                	j	7b2 <printint+0x16>

0000000000000848 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 848:	715d                	addi	sp,sp,-80
 84a:	e486                	sd	ra,72(sp)
 84c:	e0a2                	sd	s0,64(sp)
 84e:	f84a                	sd	s2,48(sp)
 850:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 852:	0005c903          	lbu	s2,0(a1)
 856:	1a090a63          	beqz	s2,a0a <vprintf+0x1c2>
 85a:	fc26                	sd	s1,56(sp)
 85c:	f44e                	sd	s3,40(sp)
 85e:	f052                	sd	s4,32(sp)
 860:	ec56                	sd	s5,24(sp)
 862:	e85a                	sd	s6,16(sp)
 864:	e45e                	sd	s7,8(sp)
 866:	8aaa                	mv	s5,a0
 868:	8bb2                	mv	s7,a2
 86a:	00158493          	addi	s1,a1,1
  state = 0;
 86e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 870:	02500a13          	li	s4,37
 874:	4b55                	li	s6,21
 876:	a839                	j	894 <vprintf+0x4c>
        putc(fd, c);
 878:	85ca                	mv	a1,s2
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	efe080e7          	jalr	-258(ra) # 77a <putc>
 884:	a019                	j	88a <vprintf+0x42>
    } else if(state == '%'){
 886:	01498d63          	beq	s3,s4,8a0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 88a:	0485                	addi	s1,s1,1
 88c:	fff4c903          	lbu	s2,-1(s1)
 890:	16090763          	beqz	s2,9fe <vprintf+0x1b6>
    if(state == 0){
 894:	fe0999e3          	bnez	s3,886 <vprintf+0x3e>
      if(c == '%'){
 898:	ff4910e3          	bne	s2,s4,878 <vprintf+0x30>
        state = '%';
 89c:	89d2                	mv	s3,s4
 89e:	b7f5                	j	88a <vprintf+0x42>
      if(c == 'd'){
 8a0:	13490463          	beq	s2,s4,9c8 <vprintf+0x180>
 8a4:	f9d9079b          	addiw	a5,s2,-99
 8a8:	0ff7f793          	zext.b	a5,a5
 8ac:	12fb6763          	bltu	s6,a5,9da <vprintf+0x192>
 8b0:	f9d9079b          	addiw	a5,s2,-99
 8b4:	0ff7f713          	zext.b	a4,a5
 8b8:	12eb6163          	bltu	s6,a4,9da <vprintf+0x192>
 8bc:	00271793          	slli	a5,a4,0x2
 8c0:	00000717          	auipc	a4,0x0
 8c4:	44870713          	addi	a4,a4,1096 # d08 <malloc+0x20e>
 8c8:	97ba                	add	a5,a5,a4
 8ca:	439c                	lw	a5,0(a5)
 8cc:	97ba                	add	a5,a5,a4
 8ce:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8d0:	008b8913          	addi	s2,s7,8
 8d4:	4685                	li	a3,1
 8d6:	4629                	li	a2,10
 8d8:	000ba583          	lw	a1,0(s7)
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	ebe080e7          	jalr	-322(ra) # 79c <printint>
 8e6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	b745                	j	88a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ec:	008b8913          	addi	s2,s7,8
 8f0:	4681                	li	a3,0
 8f2:	4629                	li	a2,10
 8f4:	000ba583          	lw	a1,0(s7)
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	ea2080e7          	jalr	-350(ra) # 79c <printint>
 902:	8bca                	mv	s7,s2
      state = 0;
 904:	4981                	li	s3,0
 906:	b751                	j	88a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 908:	008b8913          	addi	s2,s7,8
 90c:	4681                	li	a3,0
 90e:	4641                	li	a2,16
 910:	000ba583          	lw	a1,0(s7)
 914:	8556                	mv	a0,s5
 916:	00000097          	auipc	ra,0x0
 91a:	e86080e7          	jalr	-378(ra) # 79c <printint>
 91e:	8bca                	mv	s7,s2
      state = 0;
 920:	4981                	li	s3,0
 922:	b7a5                	j	88a <vprintf+0x42>
 924:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 926:	008b8c13          	addi	s8,s7,8
 92a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 92e:	03000593          	li	a1,48
 932:	8556                	mv	a0,s5
 934:	00000097          	auipc	ra,0x0
 938:	e46080e7          	jalr	-442(ra) # 77a <putc>
  putc(fd, 'x');
 93c:	07800593          	li	a1,120
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	e38080e7          	jalr	-456(ra) # 77a <putc>
 94a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 94c:	00000b97          	auipc	s7,0x0
 950:	414b8b93          	addi	s7,s7,1044 # d60 <digits>
 954:	03c9d793          	srli	a5,s3,0x3c
 958:	97de                	add	a5,a5,s7
 95a:	0007c583          	lbu	a1,0(a5)
 95e:	8556                	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	e1a080e7          	jalr	-486(ra) # 77a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 968:	0992                	slli	s3,s3,0x4
 96a:	397d                	addiw	s2,s2,-1
 96c:	fe0914e3          	bnez	s2,954 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 970:	8be2                	mv	s7,s8
      state = 0;
 972:	4981                	li	s3,0
 974:	6c02                	ld	s8,0(sp)
 976:	bf11                	j	88a <vprintf+0x42>
        s = va_arg(ap, char*);
 978:	008b8993          	addi	s3,s7,8
 97c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 980:	02090163          	beqz	s2,9a2 <vprintf+0x15a>
        while(*s != 0){
 984:	00094583          	lbu	a1,0(s2)
 988:	c9a5                	beqz	a1,9f8 <vprintf+0x1b0>
          putc(fd, *s);
 98a:	8556                	mv	a0,s5
 98c:	00000097          	auipc	ra,0x0
 990:	dee080e7          	jalr	-530(ra) # 77a <putc>
          s++;
 994:	0905                	addi	s2,s2,1
        while(*s != 0){
 996:	00094583          	lbu	a1,0(s2)
 99a:	f9e5                	bnez	a1,98a <vprintf+0x142>
        s = va_arg(ap, char*);
 99c:	8bce                	mv	s7,s3
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	b5ed                	j	88a <vprintf+0x42>
          s = "(null)";
 9a2:	00000917          	auipc	s2,0x0
 9a6:	35e90913          	addi	s2,s2,862 # d00 <malloc+0x206>
        while(*s != 0){
 9aa:	02800593          	li	a1,40
 9ae:	bff1                	j	98a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 9b0:	008b8913          	addi	s2,s7,8
 9b4:	000bc583          	lbu	a1,0(s7)
 9b8:	8556                	mv	a0,s5
 9ba:	00000097          	auipc	ra,0x0
 9be:	dc0080e7          	jalr	-576(ra) # 77a <putc>
 9c2:	8bca                	mv	s7,s2
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	b5d1                	j	88a <vprintf+0x42>
        putc(fd, c);
 9c8:	02500593          	li	a1,37
 9cc:	8556                	mv	a0,s5
 9ce:	00000097          	auipc	ra,0x0
 9d2:	dac080e7          	jalr	-596(ra) # 77a <putc>
      state = 0;
 9d6:	4981                	li	s3,0
 9d8:	bd4d                	j	88a <vprintf+0x42>
        putc(fd, '%');
 9da:	02500593          	li	a1,37
 9de:	8556                	mv	a0,s5
 9e0:	00000097          	auipc	ra,0x0
 9e4:	d9a080e7          	jalr	-614(ra) # 77a <putc>
        putc(fd, c);
 9e8:	85ca                	mv	a1,s2
 9ea:	8556                	mv	a0,s5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d8e080e7          	jalr	-626(ra) # 77a <putc>
      state = 0;
 9f4:	4981                	li	s3,0
 9f6:	bd51                	j	88a <vprintf+0x42>
        s = va_arg(ap, char*);
 9f8:	8bce                	mv	s7,s3
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b579                	j	88a <vprintf+0x42>
 9fe:	74e2                	ld	s1,56(sp)
 a00:	79a2                	ld	s3,40(sp)
 a02:	7a02                	ld	s4,32(sp)
 a04:	6ae2                	ld	s5,24(sp)
 a06:	6b42                	ld	s6,16(sp)
 a08:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a0a:	60a6                	ld	ra,72(sp)
 a0c:	6406                	ld	s0,64(sp)
 a0e:	7942                	ld	s2,48(sp)
 a10:	6161                	addi	sp,sp,80
 a12:	8082                	ret

0000000000000a14 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a14:	715d                	addi	sp,sp,-80
 a16:	ec06                	sd	ra,24(sp)
 a18:	e822                	sd	s0,16(sp)
 a1a:	1000                	addi	s0,sp,32
 a1c:	e010                	sd	a2,0(s0)
 a1e:	e414                	sd	a3,8(s0)
 a20:	e818                	sd	a4,16(s0)
 a22:	ec1c                	sd	a5,24(s0)
 a24:	03043023          	sd	a6,32(s0)
 a28:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a2c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a30:	8622                	mv	a2,s0
 a32:	00000097          	auipc	ra,0x0
 a36:	e16080e7          	jalr	-490(ra) # 848 <vprintf>
}
 a3a:	60e2                	ld	ra,24(sp)
 a3c:	6442                	ld	s0,16(sp)
 a3e:	6161                	addi	sp,sp,80
 a40:	8082                	ret

0000000000000a42 <printf>:

void
printf(const char *fmt, ...)
{
 a42:	711d                	addi	sp,sp,-96
 a44:	ec06                	sd	ra,24(sp)
 a46:	e822                	sd	s0,16(sp)
 a48:	1000                	addi	s0,sp,32
 a4a:	e40c                	sd	a1,8(s0)
 a4c:	e810                	sd	a2,16(s0)
 a4e:	ec14                	sd	a3,24(s0)
 a50:	f018                	sd	a4,32(s0)
 a52:	f41c                	sd	a5,40(s0)
 a54:	03043823          	sd	a6,48(s0)
 a58:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5c:	00840613          	addi	a2,s0,8
 a60:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a64:	85aa                	mv	a1,a0
 a66:	4505                	li	a0,1
 a68:	00000097          	auipc	ra,0x0
 a6c:	de0080e7          	jalr	-544(ra) # 848 <vprintf>
}
 a70:	60e2                	ld	ra,24(sp)
 a72:	6442                	ld	s0,16(sp)
 a74:	6125                	addi	sp,sp,96
 a76:	8082                	ret

0000000000000a78 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a78:	1141                	addi	sp,sp,-16
 a7a:	e422                	sd	s0,8(sp)
 a7c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a7e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a82:	00001797          	auipc	a5,0x1
 a86:	80e7b783          	ld	a5,-2034(a5) # 1290 <freep>
 a8a:	a02d                	j	ab4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a8c:	4618                	lw	a4,8(a2)
 a8e:	9f2d                	addw	a4,a4,a1
 a90:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a94:	6398                	ld	a4,0(a5)
 a96:	6310                	ld	a2,0(a4)
 a98:	a83d                	j	ad6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a9a:	ff852703          	lw	a4,-8(a0)
 a9e:	9f31                	addw	a4,a4,a2
 aa0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aa2:	ff053683          	ld	a3,-16(a0)
 aa6:	a091                	j	aea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa8:	6398                	ld	a4,0(a5)
 aaa:	00e7e463          	bltu	a5,a4,ab2 <free+0x3a>
 aae:	00e6ea63          	bltu	a3,a4,ac2 <free+0x4a>
{
 ab2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab4:	fed7fae3          	bgeu	a5,a3,aa8 <free+0x30>
 ab8:	6398                	ld	a4,0(a5)
 aba:	00e6e463          	bltu	a3,a4,ac2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abe:	fee7eae3          	bltu	a5,a4,ab2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ac2:	ff852583          	lw	a1,-8(a0)
 ac6:	6390                	ld	a2,0(a5)
 ac8:	02059813          	slli	a6,a1,0x20
 acc:	01c85713          	srli	a4,a6,0x1c
 ad0:	9736                	add	a4,a4,a3
 ad2:	fae60de3          	beq	a2,a4,a8c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ada:	4790                	lw	a2,8(a5)
 adc:	02061593          	slli	a1,a2,0x20
 ae0:	01c5d713          	srli	a4,a1,0x1c
 ae4:	973e                	add	a4,a4,a5
 ae6:	fae68ae3          	beq	a3,a4,a9a <free+0x22>
    p->s.ptr = bp->s.ptr;
 aea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aec:	00000717          	auipc	a4,0x0
 af0:	7af73223          	sd	a5,1956(a4) # 1290 <freep>
}
 af4:	6422                	ld	s0,8(sp)
 af6:	0141                	addi	sp,sp,16
 af8:	8082                	ret

0000000000000afa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 afa:	7139                	addi	sp,sp,-64
 afc:	fc06                	sd	ra,56(sp)
 afe:	f822                	sd	s0,48(sp)
 b00:	f426                	sd	s1,40(sp)
 b02:	ec4e                	sd	s3,24(sp)
 b04:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b06:	02051493          	slli	s1,a0,0x20
 b0a:	9081                	srli	s1,s1,0x20
 b0c:	04bd                	addi	s1,s1,15
 b0e:	8091                	srli	s1,s1,0x4
 b10:	0014899b          	addiw	s3,s1,1
 b14:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b16:	00000517          	auipc	a0,0x0
 b1a:	77a53503          	ld	a0,1914(a0) # 1290 <freep>
 b1e:	c915                	beqz	a0,b52 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b20:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b22:	4798                	lw	a4,8(a5)
 b24:	08977e63          	bgeu	a4,s1,bc0 <malloc+0xc6>
 b28:	f04a                	sd	s2,32(sp)
 b2a:	e852                	sd	s4,16(sp)
 b2c:	e456                	sd	s5,8(sp)
 b2e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b30:	8a4e                	mv	s4,s3
 b32:	0009871b          	sext.w	a4,s3
 b36:	6685                	lui	a3,0x1
 b38:	00d77363          	bgeu	a4,a3,b3e <malloc+0x44>
 b3c:	6a05                	lui	s4,0x1
 b3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b46:	00000917          	auipc	s2,0x0
 b4a:	74a90913          	addi	s2,s2,1866 # 1290 <freep>
  if(p == (char*)-1)
 b4e:	5afd                	li	s5,-1
 b50:	a091                	j	b94 <malloc+0x9a>
 b52:	f04a                	sd	s2,32(sp)
 b54:	e852                	sd	s4,16(sp)
 b56:	e456                	sd	s5,8(sp)
 b58:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b5a:	00009797          	auipc	a5,0x9
 b5e:	91e78793          	addi	a5,a5,-1762 # 9478 <base>
 b62:	00000717          	auipc	a4,0x0
 b66:	72f73723          	sd	a5,1838(a4) # 1290 <freep>
 b6a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b6c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b70:	b7c1                	j	b30 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b72:	6398                	ld	a4,0(a5)
 b74:	e118                	sd	a4,0(a0)
 b76:	a08d                	j	bd8 <malloc+0xde>
  hp->s.size = nu;
 b78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b7c:	0541                	addi	a0,a0,16
 b7e:	00000097          	auipc	ra,0x0
 b82:	efa080e7          	jalr	-262(ra) # a78 <free>
  return freep;
 b86:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b8a:	c13d                	beqz	a0,bf0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b8e:	4798                	lw	a4,8(a5)
 b90:	02977463          	bgeu	a4,s1,bb8 <malloc+0xbe>
    if(p == freep)
 b94:	00093703          	ld	a4,0(s2)
 b98:	853e                	mv	a0,a5
 b9a:	fef719e3          	bne	a4,a5,b8c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 b9e:	8552                	mv	a0,s4
 ba0:	00000097          	auipc	ra,0x0
 ba4:	bc2080e7          	jalr	-1086(ra) # 762 <sbrk>
  if(p == (char*)-1)
 ba8:	fd5518e3          	bne	a0,s5,b78 <malloc+0x7e>
        return 0;
 bac:	4501                	li	a0,0
 bae:	7902                	ld	s2,32(sp)
 bb0:	6a42                	ld	s4,16(sp)
 bb2:	6aa2                	ld	s5,8(sp)
 bb4:	6b02                	ld	s6,0(sp)
 bb6:	a03d                	j	be4 <malloc+0xea>
 bb8:	7902                	ld	s2,32(sp)
 bba:	6a42                	ld	s4,16(sp)
 bbc:	6aa2                	ld	s5,8(sp)
 bbe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bc0:	fae489e3          	beq	s1,a4,b72 <malloc+0x78>
        p->s.size -= nunits;
 bc4:	4137073b          	subw	a4,a4,s3
 bc8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bca:	02071693          	slli	a3,a4,0x20
 bce:	01c6d713          	srli	a4,a3,0x1c
 bd2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bd4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bd8:	00000717          	auipc	a4,0x0
 bdc:	6aa73c23          	sd	a0,1720(a4) # 1290 <freep>
      return (void*)(p + 1);
 be0:	01078513          	addi	a0,a5,16
  }
}
 be4:	70e2                	ld	ra,56(sp)
 be6:	7442                	ld	s0,48(sp)
 be8:	74a2                	ld	s1,40(sp)
 bea:	69e2                	ld	s3,24(sp)
 bec:	6121                	addi	sp,sp,64
 bee:	8082                	ret
 bf0:	7902                	ld	s2,32(sp)
 bf2:	6a42                	ld	s4,16(sp)
 bf4:	6aa2                	ld	s5,8(sp)
 bf6:	6b02                	ld	s6,0(sp)
 bf8:	b7f5                	j	be4 <malloc+0xea>
