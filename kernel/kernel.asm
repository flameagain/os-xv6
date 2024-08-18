
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	64013103          	ld	sp,1600(sp) # 8000c640 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7a8060ef          	jal	800067be <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	55078793          	addi	a5,a5,1360 # 8002a580 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000d917          	auipc	s2,0xd
    80000054:	00090913          	mv	s2,s2
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	1ac080e7          	jalr	428(ra) # 80007206 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2) # 8000d068 <kmem+0x18>
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	24c080e7          	jalr	588(ra) # 800072ba <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f7e50513          	addi	a0,a0,-130 # 80009000 <etext>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	c02080e7          	jalr	-1022(ra) # 80006c8c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80009010 <etext+0x10>
    800000ee:	0000d517          	auipc	a0,0xd
    800000f2:	f6250513          	addi	a0,a0,-158 # 8000d050 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	080080e7          	jalr	128(ra) # 80007176 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0002a517          	auipc	a0,0x2a
    80000106:	47e50513          	addi	a0,a0,1150 # 8002a580 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000d497          	auipc	s1,0xd
    80000128:	f2c48493          	addi	s1,s1,-212 # 8000d050 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	0d8080e7          	jalr	216(ra) # 80007206 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000d517          	auipc	a0,0xd
    80000140:	f1450513          	addi	a0,a0,-236 # 8000d050 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	174080e7          	jalr	372(ra) # 800072ba <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000d517          	auipc	a0,0xd
    8000016c:	ee850513          	addi	a0,a0,-280 # 8000d050 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	14a080e7          	jalr	330(ra) # 800072ba <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd4a81>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1101                	addi	sp,sp,-32
    8000031a:	ec06                	sd	ra,24(sp)
    8000031c:	e822                	sd	s0,16(sp)
    8000031e:	e426                	sd	s1,8(sp)
    80000320:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000322:	00001097          	auipc	ra,0x1
    80000326:	b86080e7          	jalr	-1146(ra) # 80000ea8 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    8000032a:	0000d497          	auipc	s1,0xd
    8000032e:	cd648493          	addi	s1,s1,-810 # 8000d000 <started>
  if(cpuid() == 0){
    80000332:	c531                	beqz	a0,8000037e <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000334:	8526                	mv	a0,s1
    80000336:	00007097          	auipc	ra,0x7
    8000033a:	fe2080e7          	jalr	-30(ra) # 80007318 <lockfree_read4>
    8000033e:	d97d                	beqz	a0,80000334 <main+0x1c>
      ;
    __sync_synchronize();
    80000340:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	b64080e7          	jalr	-1180(ra) # 80000ea8 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00009517          	auipc	a0,0x9
    80000352:	cea50513          	addi	a0,a0,-790 # 80009038 <etext+0x38>
    80000356:	00007097          	auipc	ra,0x7
    8000035a:	980080e7          	jalr	-1664(ra) # 80006cd6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0e8080e7          	jalr	232(ra) # 80000446 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	7c6080e7          	jalr	1990(ra) # 80001b2c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f0a080e7          	jalr	-246(ra) # 80005278 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	072080e7          	jalr	114(ra) # 800013e8 <scheduler>
    consoleinit();
    8000037e:	00007097          	auipc	ra,0x7
    80000382:	81e080e7          	jalr	-2018(ra) # 80006b9c <consoleinit>
    printfinit();
    80000386:	00007097          	auipc	ra,0x7
    8000038a:	b58080e7          	jalr	-1192(ra) # 80006ede <printfinit>
    printf("\n");
    8000038e:	00009517          	auipc	a0,0x9
    80000392:	c8a50513          	addi	a0,a0,-886 # 80009018 <etext+0x18>
    80000396:	00007097          	auipc	ra,0x7
    8000039a:	940080e7          	jalr	-1728(ra) # 80006cd6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00009517          	auipc	a0,0x9
    800003a2:	c8250513          	addi	a0,a0,-894 # 80009020 <etext+0x20>
    800003a6:	00007097          	auipc	ra,0x7
    800003aa:	930080e7          	jalr	-1744(ra) # 80006cd6 <printf>
    printf("\n");
    800003ae:	00009517          	auipc	a0,0x9
    800003b2:	c6a50513          	addi	a0,a0,-918 # 80009018 <etext+0x18>
    800003b6:	00007097          	auipc	ra,0x7
    800003ba:	920080e7          	jalr	-1760(ra) # 80006cd6 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	362080e7          	jalr	866(ra) # 80000728 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	078080e7          	jalr	120(ra) # 80000446 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a16080e7          	jalr	-1514(ra) # 80000dec <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	726080e7          	jalr	1830(ra) # 80001b04 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	746080e7          	jalr	1862(ra) # 80001b2c <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e5c080e7          	jalr	-420(ra) # 8000524a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e82080e7          	jalr	-382(ra) # 80005278 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	eb0080e7          	jalr	-336(ra) # 800022ae <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	53c080e7          	jalr	1340(ra) # 80002942 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	4e0080e7          	jalr	1248(ra) # 800038ee <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	f88080e7          	jalr	-120(ra) # 8000539e <virtio_disk_init>
    pci_init();
    8000041e:	00006097          	auipc	ra,0x6
    80000422:	2a4080e7          	jalr	676(ra) # 800066c2 <pci_init>
    sockinit();
    80000426:	00006097          	auipc	ra,0x6
    8000042a:	e8a080e7          	jalr	-374(ra) # 800062b0 <sockinit>
    userinit();      // first user process
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	d7e080e7          	jalr	-642(ra) # 800011ac <userinit>
    __sync_synchronize();
    80000436:	0330000f          	fence	rw,rw
    started = 1;
    8000043a:	4785                	li	a5,1
    8000043c:	0000d717          	auipc	a4,0xd
    80000440:	bcf72223          	sw	a5,-1084(a4) # 8000d000 <started>
    80000444:	bf0d                	j	80000376 <main+0x5e>

0000000080000446 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000446:	1141                	addi	sp,sp,-16
    80000448:	e422                	sd	s0,8(sp)
    8000044a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000044c:	0000d797          	auipc	a5,0xd
    80000450:	bbc7b783          	ld	a5,-1092(a5) # 8000d008 <kernel_pagetable>
    80000454:	83b1                	srli	a5,a5,0xc
    80000456:	577d                	li	a4,-1
    80000458:	177e                	slli	a4,a4,0x3f
    8000045a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000045c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000460:	12000073          	sfence.vma
  sfence_vma();
}
    80000464:	6422                	ld	s0,8(sp)
    80000466:	0141                	addi	sp,sp,16
    80000468:	8082                	ret

000000008000046a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000046a:	7139                	addi	sp,sp,-64
    8000046c:	fc06                	sd	ra,56(sp)
    8000046e:	f822                	sd	s0,48(sp)
    80000470:	f426                	sd	s1,40(sp)
    80000472:	f04a                	sd	s2,32(sp)
    80000474:	ec4e                	sd	s3,24(sp)
    80000476:	e852                	sd	s4,16(sp)
    80000478:	e456                	sd	s5,8(sp)
    8000047a:	e05a                	sd	s6,0(sp)
    8000047c:	0080                	addi	s0,sp,64
    8000047e:	84aa                	mv	s1,a0
    80000480:	89ae                	mv	s3,a1
    80000482:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000484:	57fd                	li	a5,-1
    80000486:	83e9                	srli	a5,a5,0x1a
    80000488:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000048a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000048c:	04b7f263          	bgeu	a5,a1,800004d0 <walk+0x66>
    panic("walk");
    80000490:	00009517          	auipc	a0,0x9
    80000494:	bc050513          	addi	a0,a0,-1088 # 80009050 <etext+0x50>
    80000498:	00006097          	auipc	ra,0x6
    8000049c:	7f4080e7          	jalr	2036(ra) # 80006c8c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004a0:	060a8663          	beqz	s5,8000050c <walk+0xa2>
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	c76080e7          	jalr	-906(ra) # 8000011a <kalloc>
    800004ac:	84aa                	mv	s1,a0
    800004ae:	c529                	beqz	a0,800004f8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004b0:	6605                	lui	a2,0x1
    800004b2:	4581                	li	a1,0
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	cc6080e7          	jalr	-826(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004bc:	00c4d793          	srli	a5,s1,0xc
    800004c0:	07aa                	slli	a5,a5,0xa
    800004c2:	0017e793          	ori	a5,a5,1
    800004c6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ca:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd4a77>
    800004cc:	036a0063          	beq	s4,s6,800004ec <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004d0:	0149d933          	srl	s2,s3,s4
    800004d4:	1ff97913          	andi	s2,s2,511
    800004d8:	090e                	slli	s2,s2,0x3
    800004da:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004dc:	00093483          	ld	s1,0(s2)
    800004e0:	0014f793          	andi	a5,s1,1
    800004e4:	dfd5                	beqz	a5,800004a0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e6:	80a9                	srli	s1,s1,0xa
    800004e8:	04b2                	slli	s1,s1,0xc
    800004ea:	b7c5                	j	800004ca <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004ec:	00c9d513          	srli	a0,s3,0xc
    800004f0:	1ff57513          	andi	a0,a0,511
    800004f4:	050e                	slli	a0,a0,0x3
    800004f6:	9526                	add	a0,a0,s1
}
    800004f8:	70e2                	ld	ra,56(sp)
    800004fa:	7442                	ld	s0,48(sp)
    800004fc:	74a2                	ld	s1,40(sp)
    800004fe:	7902                	ld	s2,32(sp)
    80000500:	69e2                	ld	s3,24(sp)
    80000502:	6a42                	ld	s4,16(sp)
    80000504:	6aa2                	ld	s5,8(sp)
    80000506:	6b02                	ld	s6,0(sp)
    80000508:	6121                	addi	sp,sp,64
    8000050a:	8082                	ret
        return 0;
    8000050c:	4501                	li	a0,0
    8000050e:	b7ed                	j	800004f8 <walk+0x8e>

0000000080000510 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000510:	57fd                	li	a5,-1
    80000512:	83e9                	srli	a5,a5,0x1a
    80000514:	00b7f463          	bgeu	a5,a1,8000051c <walkaddr+0xc>
    return 0;
    80000518:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000051a:	8082                	ret
{
    8000051c:	1141                	addi	sp,sp,-16
    8000051e:	e406                	sd	ra,8(sp)
    80000520:	e022                	sd	s0,0(sp)
    80000522:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000524:	4601                	li	a2,0
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	f44080e7          	jalr	-188(ra) # 8000046a <walk>
  if(pte == 0)
    8000052e:	c105                	beqz	a0,8000054e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000530:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000532:	0117f693          	andi	a3,a5,17
    80000536:	4745                	li	a4,17
    return 0;
    80000538:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000053a:	00e68663          	beq	a3,a4,80000546 <walkaddr+0x36>
}
    8000053e:	60a2                	ld	ra,8(sp)
    80000540:	6402                	ld	s0,0(sp)
    80000542:	0141                	addi	sp,sp,16
    80000544:	8082                	ret
  pa = PTE2PA(*pte);
    80000546:	83a9                	srli	a5,a5,0xa
    80000548:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000054c:	bfcd                	j	8000053e <walkaddr+0x2e>
    return 0;
    8000054e:	4501                	li	a0,0
    80000550:	b7fd                	j	8000053e <walkaddr+0x2e>

0000000080000552 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000552:	715d                	addi	sp,sp,-80
    80000554:	e486                	sd	ra,72(sp)
    80000556:	e0a2                	sd	s0,64(sp)
    80000558:	fc26                	sd	s1,56(sp)
    8000055a:	f84a                	sd	s2,48(sp)
    8000055c:	f44e                	sd	s3,40(sp)
    8000055e:	f052                	sd	s4,32(sp)
    80000560:	ec56                	sd	s5,24(sp)
    80000562:	e85a                	sd	s6,16(sp)
    80000564:	e45e                	sd	s7,8(sp)
    80000566:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000568:	c639                	beqz	a2,800005b6 <mappages+0x64>
    8000056a:	8aaa                	mv	s5,a0
    8000056c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000056e:	777d                	lui	a4,0xfffff
    80000570:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000574:	fff58993          	addi	s3,a1,-1
    80000578:	99b2                	add	s3,s3,a2
    8000057a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000057e:	893e                	mv	s2,a5
    80000580:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000584:	6b85                	lui	s7,0x1
    80000586:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000058a:	4605                	li	a2,1
    8000058c:	85ca                	mv	a1,s2
    8000058e:	8556                	mv	a0,s5
    80000590:	00000097          	auipc	ra,0x0
    80000594:	eda080e7          	jalr	-294(ra) # 8000046a <walk>
    80000598:	cd1d                	beqz	a0,800005d6 <mappages+0x84>
    if(*pte & PTE_V)
    8000059a:	611c                	ld	a5,0(a0)
    8000059c:	8b85                	andi	a5,a5,1
    8000059e:	e785                	bnez	a5,800005c6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005a0:	80b1                	srli	s1,s1,0xc
    800005a2:	04aa                	slli	s1,s1,0xa
    800005a4:	0164e4b3          	or	s1,s1,s6
    800005a8:	0014e493          	ori	s1,s1,1
    800005ac:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ae:	05390063          	beq	s2,s3,800005ee <mappages+0x9c>
    a += PGSIZE;
    800005b2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005b4:	bfc9                	j	80000586 <mappages+0x34>
    panic("mappages: size");
    800005b6:	00009517          	auipc	a0,0x9
    800005ba:	aa250513          	addi	a0,a0,-1374 # 80009058 <etext+0x58>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	6ce080e7          	jalr	1742(ra) # 80006c8c <panic>
      panic("mappages: remap");
    800005c6:	00009517          	auipc	a0,0x9
    800005ca:	aa250513          	addi	a0,a0,-1374 # 80009068 <etext+0x68>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	6be080e7          	jalr	1726(ra) # 80006c8c <panic>
      return -1;
    800005d6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005d8:	60a6                	ld	ra,72(sp)
    800005da:	6406                	ld	s0,64(sp)
    800005dc:	74e2                	ld	s1,56(sp)
    800005de:	7942                	ld	s2,48(sp)
    800005e0:	79a2                	ld	s3,40(sp)
    800005e2:	7a02                	ld	s4,32(sp)
    800005e4:	6ae2                	ld	s5,24(sp)
    800005e6:	6b42                	ld	s6,16(sp)
    800005e8:	6ba2                	ld	s7,8(sp)
    800005ea:	6161                	addi	sp,sp,80
    800005ec:	8082                	ret
  return 0;
    800005ee:	4501                	li	a0,0
    800005f0:	b7e5                	j	800005d8 <mappages+0x86>

00000000800005f2 <kvmmap>:
{
    800005f2:	1141                	addi	sp,sp,-16
    800005f4:	e406                	sd	ra,8(sp)
    800005f6:	e022                	sd	s0,0(sp)
    800005f8:	0800                	addi	s0,sp,16
    800005fa:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005fc:	86b2                	mv	a3,a2
    800005fe:	863e                	mv	a2,a5
    80000600:	00000097          	auipc	ra,0x0
    80000604:	f52080e7          	jalr	-174(ra) # 80000552 <mappages>
    80000608:	e509                	bnez	a0,80000612 <kvmmap+0x20>
}
    8000060a:	60a2                	ld	ra,8(sp)
    8000060c:	6402                	ld	s0,0(sp)
    8000060e:	0141                	addi	sp,sp,16
    80000610:	8082                	ret
    panic("kvmmap");
    80000612:	00009517          	auipc	a0,0x9
    80000616:	a6650513          	addi	a0,a0,-1434 # 80009078 <etext+0x78>
    8000061a:	00006097          	auipc	ra,0x6
    8000061e:	672080e7          	jalr	1650(ra) # 80006c8c <panic>

0000000080000622 <kvmmake>:
{
    80000622:	1101                	addi	sp,sp,-32
    80000624:	ec06                	sd	ra,24(sp)
    80000626:	e822                	sd	s0,16(sp)
    80000628:	e426                	sd	s1,8(sp)
    8000062a:	e04a                	sd	s2,0(sp)
    8000062c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	aec080e7          	jalr	-1300(ra) # 8000011a <kalloc>
    80000636:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000638:	6605                	lui	a2,0x1
    8000063a:	4581                	li	a1,0
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	b3e080e7          	jalr	-1218(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000644:	4719                	li	a4,6
    80000646:	6685                	lui	a3,0x1
    80000648:	10000637          	lui	a2,0x10000
    8000064c:	100005b7          	lui	a1,0x10000
    80000650:	8526                	mv	a0,s1
    80000652:	00000097          	auipc	ra,0x0
    80000656:	fa0080e7          	jalr	-96(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000065a:	4719                	li	a4,6
    8000065c:	6685                	lui	a3,0x1
    8000065e:	10001637          	lui	a2,0x10001
    80000662:	100015b7          	lui	a1,0x10001
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f8a080e7          	jalr	-118(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000670:	4719                	li	a4,6
    80000672:	100006b7          	lui	a3,0x10000
    80000676:	30000637          	lui	a2,0x30000
    8000067a:	300005b7          	lui	a1,0x30000
    8000067e:	8526                	mv	a0,s1
    80000680:	00000097          	auipc	ra,0x0
    80000684:	f72080e7          	jalr	-142(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000688:	4719                	li	a4,6
    8000068a:	000206b7          	lui	a3,0x20
    8000068e:	40000637          	lui	a2,0x40000
    80000692:	400005b7          	lui	a1,0x40000
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f5a080e7          	jalr	-166(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	004006b7          	lui	a3,0x400
    800006a6:	0c000637          	lui	a2,0xc000
    800006aa:	0c0005b7          	lui	a1,0xc000
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f42080e7          	jalr	-190(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006b8:	00009917          	auipc	s2,0x9
    800006bc:	94890913          	addi	s2,s2,-1720 # 80009000 <etext>
    800006c0:	4729                	li	a4,10
    800006c2:	80009697          	auipc	a3,0x80009
    800006c6:	93e68693          	addi	a3,a3,-1730 # 9000 <_entry-0x7fff7000>
    800006ca:	4605                	li	a2,1
    800006cc:	067e                	slli	a2,a2,0x1f
    800006ce:	85b2                	mv	a1,a2
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f20080e7          	jalr	-224(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006da:	46c5                	li	a3,17
    800006dc:	06ee                	slli	a3,a3,0x1b
    800006de:	4719                	li	a4,6
    800006e0:	412686b3          	sub	a3,a3,s2
    800006e4:	864a                	mv	a2,s2
    800006e6:	85ca                	mv	a1,s2
    800006e8:	8526                	mv	a0,s1
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f08080e7          	jalr	-248(ra) # 800005f2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f2:	4729                	li	a4,10
    800006f4:	6685                	lui	a3,0x1
    800006f6:	00008617          	auipc	a2,0x8
    800006fa:	90a60613          	addi	a2,a2,-1782 # 80008000 <_trampoline>
    800006fe:	040005b7          	lui	a1,0x4000
    80000702:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000704:	05b2                	slli	a1,a1,0xc
    80000706:	8526                	mv	a0,s1
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	eea080e7          	jalr	-278(ra) # 800005f2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	638080e7          	jalr	1592(ra) # 80000d4a <proc_mapstacks>
}
    8000071a:	8526                	mv	a0,s1
    8000071c:	60e2                	ld	ra,24(sp)
    8000071e:	6442                	ld	s0,16(sp)
    80000720:	64a2                	ld	s1,8(sp)
    80000722:	6902                	ld	s2,0(sp)
    80000724:	6105                	addi	sp,sp,32
    80000726:	8082                	ret

0000000080000728 <kvminit>:
{
    80000728:	1141                	addi	sp,sp,-16
    8000072a:	e406                	sd	ra,8(sp)
    8000072c:	e022                	sd	s0,0(sp)
    8000072e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000730:	00000097          	auipc	ra,0x0
    80000734:	ef2080e7          	jalr	-270(ra) # 80000622 <kvmmake>
    80000738:	0000d797          	auipc	a5,0xd
    8000073c:	8ca7b823          	sd	a0,-1840(a5) # 8000d008 <kernel_pagetable>
}
    80000740:	60a2                	ld	ra,8(sp)
    80000742:	6402                	ld	s0,0(sp)
    80000744:	0141                	addi	sp,sp,16
    80000746:	8082                	ret

0000000080000748 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000748:	715d                	addi	sp,sp,-80
    8000074a:	e486                	sd	ra,72(sp)
    8000074c:	e0a2                	sd	s0,64(sp)
    8000074e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000750:	03459793          	slli	a5,a1,0x34
    80000754:	e39d                	bnez	a5,8000077a <uvmunmap+0x32>
    80000756:	f84a                	sd	s2,48(sp)
    80000758:	f44e                	sd	s3,40(sp)
    8000075a:	f052                	sd	s4,32(sp)
    8000075c:	ec56                	sd	s5,24(sp)
    8000075e:	e85a                	sd	s6,16(sp)
    80000760:	e45e                	sd	s7,8(sp)
    80000762:	8a2a                	mv	s4,a0
    80000764:	892e                	mv	s2,a1
    80000766:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000768:	0632                	slli	a2,a2,0xc
    8000076a:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000076e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000770:	6b05                	lui	s6,0x1
    80000772:	0b35f563          	bgeu	a1,s3,8000081c <uvmunmap+0xd4>
    80000776:	fc26                	sd	s1,56(sp)
    80000778:	a0b5                	j	800007e4 <uvmunmap+0x9c>
    8000077a:	fc26                	sd	s1,56(sp)
    8000077c:	f84a                	sd	s2,48(sp)
    8000077e:	f44e                	sd	s3,40(sp)
    80000780:	f052                	sd	s4,32(sp)
    80000782:	ec56                	sd	s5,24(sp)
    80000784:	e85a                	sd	s6,16(sp)
    80000786:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000788:	00009517          	auipc	a0,0x9
    8000078c:	8f850513          	addi	a0,a0,-1800 # 80009080 <etext+0x80>
    80000790:	00006097          	auipc	ra,0x6
    80000794:	4fc080e7          	jalr	1276(ra) # 80006c8c <panic>
      panic("uvmunmap: walk");
    80000798:	00009517          	auipc	a0,0x9
    8000079c:	90050513          	addi	a0,a0,-1792 # 80009098 <etext+0x98>
    800007a0:	00006097          	auipc	ra,0x6
    800007a4:	4ec080e7          	jalr	1260(ra) # 80006c8c <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007a8:	85ca                	mv	a1,s2
    800007aa:	00009517          	auipc	a0,0x9
    800007ae:	8fe50513          	addi	a0,a0,-1794 # 800090a8 <etext+0xa8>
    800007b2:	00006097          	auipc	ra,0x6
    800007b6:	524080e7          	jalr	1316(ra) # 80006cd6 <printf>
      panic("uvmunmap: not mapped");
    800007ba:	00009517          	auipc	a0,0x9
    800007be:	8fe50513          	addi	a0,a0,-1794 # 800090b8 <etext+0xb8>
    800007c2:	00006097          	auipc	ra,0x6
    800007c6:	4ca080e7          	jalr	1226(ra) # 80006c8c <panic>
      panic("uvmunmap: not a leaf");
    800007ca:	00009517          	auipc	a0,0x9
    800007ce:	90650513          	addi	a0,a0,-1786 # 800090d0 <etext+0xd0>
    800007d2:	00006097          	auipc	ra,0x6
    800007d6:	4ba080e7          	jalr	1210(ra) # 80006c8c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007da:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007de:	995a                	add	s2,s2,s6
    800007e0:	03397d63          	bgeu	s2,s3,8000081a <uvmunmap+0xd2>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e4:	4601                	li	a2,0
    800007e6:	85ca                	mv	a1,s2
    800007e8:	8552                	mv	a0,s4
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	c80080e7          	jalr	-896(ra) # 8000046a <walk>
    800007f2:	84aa                	mv	s1,a0
    800007f4:	d155                	beqz	a0,80000798 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0) {
    800007f6:	6110                	ld	a2,0(a0)
    800007f8:	00167793          	andi	a5,a2,1
    800007fc:	d7d5                	beqz	a5,800007a8 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fe:	3ff67793          	andi	a5,a2,1023
    80000802:	fd7784e3          	beq	a5,s7,800007ca <uvmunmap+0x82>
    if(do_free){
    80000806:	fc0a8ae3          	beqz	s5,800007da <uvmunmap+0x92>
      uint64 pa = PTE2PA(*pte);
    8000080a:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    8000080c:	00c61513          	slli	a0,a2,0xc
    80000810:	00000097          	auipc	ra,0x0
    80000814:	80c080e7          	jalr	-2036(ra) # 8000001c <kfree>
    80000818:	b7c9                	j	800007da <uvmunmap+0x92>
    8000081a:	74e2                	ld	s1,56(sp)
    8000081c:	7942                	ld	s2,48(sp)
    8000081e:	79a2                	ld	s3,40(sp)
    80000820:	7a02                	ld	s4,32(sp)
    80000822:	6ae2                	ld	s5,24(sp)
    80000824:	6b42                	ld	s6,16(sp)
    80000826:	6ba2                	ld	s7,8(sp)
  }
}
    80000828:	60a6                	ld	ra,72(sp)
    8000082a:	6406                	ld	s0,64(sp)
    8000082c:	6161                	addi	sp,sp,80
    8000082e:	8082                	ret

0000000080000830 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000830:	1101                	addi	sp,sp,-32
    80000832:	ec06                	sd	ra,24(sp)
    80000834:	e822                	sd	s0,16(sp)
    80000836:	e426                	sd	s1,8(sp)
    80000838:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	8e0080e7          	jalr	-1824(ra) # 8000011a <kalloc>
    80000842:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000844:	c519                	beqz	a0,80000852 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000846:	6605                	lui	a2,0x1
    80000848:	4581                	li	a1,0
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	930080e7          	jalr	-1744(ra) # 8000017a <memset>
  return pagetable;
}
    80000852:	8526                	mv	a0,s1
    80000854:	60e2                	ld	ra,24(sp)
    80000856:	6442                	ld	s0,16(sp)
    80000858:	64a2                	ld	s1,8(sp)
    8000085a:	6105                	addi	sp,sp,32
    8000085c:	8082                	ret

000000008000085e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000085e:	7179                	addi	sp,sp,-48
    80000860:	f406                	sd	ra,40(sp)
    80000862:	f022                	sd	s0,32(sp)
    80000864:	ec26                	sd	s1,24(sp)
    80000866:	e84a                	sd	s2,16(sp)
    80000868:	e44e                	sd	s3,8(sp)
    8000086a:	e052                	sd	s4,0(sp)
    8000086c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000086e:	6785                	lui	a5,0x1
    80000870:	04f67863          	bgeu	a2,a5,800008c0 <uvminit+0x62>
    80000874:	8a2a                	mv	s4,a0
    80000876:	89ae                	mv	s3,a1
    80000878:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	8a0080e7          	jalr	-1888(ra) # 8000011a <kalloc>
    80000882:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000884:	6605                	lui	a2,0x1
    80000886:	4581                	li	a1,0
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	8f2080e7          	jalr	-1806(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000890:	4779                	li	a4,30
    80000892:	86ca                	mv	a3,s2
    80000894:	6605                	lui	a2,0x1
    80000896:	4581                	li	a1,0
    80000898:	8552                	mv	a0,s4
    8000089a:	00000097          	auipc	ra,0x0
    8000089e:	cb8080e7          	jalr	-840(ra) # 80000552 <mappages>
  memmove(mem, src, sz);
    800008a2:	8626                	mv	a2,s1
    800008a4:	85ce                	mv	a1,s3
    800008a6:	854a                	mv	a0,s2
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	92e080e7          	jalr	-1746(ra) # 800001d6 <memmove>
}
    800008b0:	70a2                	ld	ra,40(sp)
    800008b2:	7402                	ld	s0,32(sp)
    800008b4:	64e2                	ld	s1,24(sp)
    800008b6:	6942                	ld	s2,16(sp)
    800008b8:	69a2                	ld	s3,8(sp)
    800008ba:	6a02                	ld	s4,0(sp)
    800008bc:	6145                	addi	sp,sp,48
    800008be:	8082                	ret
    panic("inituvm: more than a page");
    800008c0:	00009517          	auipc	a0,0x9
    800008c4:	82850513          	addi	a0,a0,-2008 # 800090e8 <etext+0xe8>
    800008c8:	00006097          	auipc	ra,0x6
    800008cc:	3c4080e7          	jalr	964(ra) # 80006c8c <panic>

00000000800008d0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008d0:	1101                	addi	sp,sp,-32
    800008d2:	ec06                	sd	ra,24(sp)
    800008d4:	e822                	sd	s0,16(sp)
    800008d6:	e426                	sd	s1,8(sp)
    800008d8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008da:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008dc:	00b67d63          	bgeu	a2,a1,800008f6 <uvmdealloc+0x26>
    800008e0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008e2:	6785                	lui	a5,0x1
    800008e4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008e6:	00f60733          	add	a4,a2,a5
    800008ea:	76fd                	lui	a3,0xfffff
    800008ec:	8f75                	and	a4,a4,a3
    800008ee:	97ae                	add	a5,a5,a1
    800008f0:	8ff5                	and	a5,a5,a3
    800008f2:	00f76863          	bltu	a4,a5,80000902 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f6:	8526                	mv	a0,s1
    800008f8:	60e2                	ld	ra,24(sp)
    800008fa:	6442                	ld	s0,16(sp)
    800008fc:	64a2                	ld	s1,8(sp)
    800008fe:	6105                	addi	sp,sp,32
    80000900:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000902:	8f99                	sub	a5,a5,a4
    80000904:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000906:	4685                	li	a3,1
    80000908:	0007861b          	sext.w	a2,a5
    8000090c:	85ba                	mv	a1,a4
    8000090e:	00000097          	auipc	ra,0x0
    80000912:	e3a080e7          	jalr	-454(ra) # 80000748 <uvmunmap>
    80000916:	b7c5                	j	800008f6 <uvmdealloc+0x26>

0000000080000918 <uvmalloc>:
  if(newsz < oldsz)
    80000918:	0ab66563          	bltu	a2,a1,800009c2 <uvmalloc+0xaa>
{
    8000091c:	7139                	addi	sp,sp,-64
    8000091e:	fc06                	sd	ra,56(sp)
    80000920:	f822                	sd	s0,48(sp)
    80000922:	ec4e                	sd	s3,24(sp)
    80000924:	e852                	sd	s4,16(sp)
    80000926:	e456                	sd	s5,8(sp)
    80000928:	0080                	addi	s0,sp,64
    8000092a:	8aaa                	mv	s5,a0
    8000092c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000092e:	6785                	lui	a5,0x1
    80000930:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000932:	95be                	add	a1,a1,a5
    80000934:	77fd                	lui	a5,0xfffff
    80000936:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093a:	08c9f663          	bgeu	s3,a2,800009c6 <uvmalloc+0xae>
    8000093e:	f426                	sd	s1,40(sp)
    80000940:	f04a                	sd	s2,32(sp)
    80000942:	894e                	mv	s2,s3
    mem = kalloc();
    80000944:	fffff097          	auipc	ra,0xfffff
    80000948:	7d6080e7          	jalr	2006(ra) # 8000011a <kalloc>
    8000094c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000094e:	c90d                	beqz	a0,80000980 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000950:	6605                	lui	a2,0x1
    80000952:	4581                	li	a1,0
    80000954:	00000097          	auipc	ra,0x0
    80000958:	826080e7          	jalr	-2010(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000095c:	4779                	li	a4,30
    8000095e:	86a6                	mv	a3,s1
    80000960:	6605                	lui	a2,0x1
    80000962:	85ca                	mv	a1,s2
    80000964:	8556                	mv	a0,s5
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	bec080e7          	jalr	-1044(ra) # 80000552 <mappages>
    8000096e:	e915                	bnez	a0,800009a2 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000970:	6785                	lui	a5,0x1
    80000972:	993e                	add	s2,s2,a5
    80000974:	fd4968e3          	bltu	s2,s4,80000944 <uvmalloc+0x2c>
  return newsz;
    80000978:	8552                	mv	a0,s4
    8000097a:	74a2                	ld	s1,40(sp)
    8000097c:	7902                	ld	s2,32(sp)
    8000097e:	a819                	j	80000994 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000980:	864e                	mv	a2,s3
    80000982:	85ca                	mv	a1,s2
    80000984:	8556                	mv	a0,s5
    80000986:	00000097          	auipc	ra,0x0
    8000098a:	f4a080e7          	jalr	-182(ra) # 800008d0 <uvmdealloc>
      return 0;
    8000098e:	4501                	li	a0,0
    80000990:	74a2                	ld	s1,40(sp)
    80000992:	7902                	ld	s2,32(sp)
}
    80000994:	70e2                	ld	ra,56(sp)
    80000996:	7442                	ld	s0,48(sp)
    80000998:	69e2                	ld	s3,24(sp)
    8000099a:	6a42                	ld	s4,16(sp)
    8000099c:	6aa2                	ld	s5,8(sp)
    8000099e:	6121                	addi	sp,sp,64
    800009a0:	8082                	ret
      kfree(mem);
    800009a2:	8526                	mv	a0,s1
    800009a4:	fffff097          	auipc	ra,0xfffff
    800009a8:	678080e7          	jalr	1656(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009ac:	864e                	mv	a2,s3
    800009ae:	85ca                	mv	a1,s2
    800009b0:	8556                	mv	a0,s5
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	f1e080e7          	jalr	-226(ra) # 800008d0 <uvmdealloc>
      return 0;
    800009ba:	4501                	li	a0,0
    800009bc:	74a2                	ld	s1,40(sp)
    800009be:	7902                	ld	s2,32(sp)
    800009c0:	bfd1                	j	80000994 <uvmalloc+0x7c>
    return oldsz;
    800009c2:	852e                	mv	a0,a1
}
    800009c4:	8082                	ret
  return newsz;
    800009c6:	8532                	mv	a0,a2
    800009c8:	b7f1                	j	80000994 <uvmalloc+0x7c>

00000000800009ca <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ca:	7179                	addi	sp,sp,-48
    800009cc:	f406                	sd	ra,40(sp)
    800009ce:	f022                	sd	s0,32(sp)
    800009d0:	ec26                	sd	s1,24(sp)
    800009d2:	e84a                	sd	s2,16(sp)
    800009d4:	e44e                	sd	s3,8(sp)
    800009d6:	e052                	sd	s4,0(sp)
    800009d8:	1800                	addi	s0,sp,48
    800009da:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009dc:	84aa                	mv	s1,a0
    800009de:	6905                	lui	s2,0x1
    800009e0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	4985                	li	s3,1
    800009e4:	a829                	j	800009fe <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009e6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009e8:	00c79513          	slli	a0,a5,0xc
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	fde080e7          	jalr	-34(ra) # 800009ca <freewalk>
      pagetable[i] = 0;
    800009f4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009f8:	04a1                	addi	s1,s1,8
    800009fa:	03248163          	beq	s1,s2,80000a1c <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009fe:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a00:	00f7f713          	andi	a4,a5,15
    80000a04:	ff3701e3          	beq	a4,s3,800009e6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a08:	8b85                	andi	a5,a5,1
    80000a0a:	d7fd                	beqz	a5,800009f8 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a0c:	00008517          	auipc	a0,0x8
    80000a10:	6fc50513          	addi	a0,a0,1788 # 80009108 <etext+0x108>
    80000a14:	00006097          	auipc	ra,0x6
    80000a18:	278080e7          	jalr	632(ra) # 80006c8c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a1c:	8552                	mv	a0,s4
    80000a1e:	fffff097          	auipc	ra,0xfffff
    80000a22:	5fe080e7          	jalr	1534(ra) # 8000001c <kfree>
}
    80000a26:	70a2                	ld	ra,40(sp)
    80000a28:	7402                	ld	s0,32(sp)
    80000a2a:	64e2                	ld	s1,24(sp)
    80000a2c:	6942                	ld	s2,16(sp)
    80000a2e:	69a2                	ld	s3,8(sp)
    80000a30:	6a02                	ld	s4,0(sp)
    80000a32:	6145                	addi	sp,sp,48
    80000a34:	8082                	ret

0000000080000a36 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	1000                	addi	s0,sp,32
    80000a40:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a42:	e999                	bnez	a1,80000a58 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a44:	8526                	mv	a0,s1
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	f84080e7          	jalr	-124(ra) # 800009ca <freewalk>
}
    80000a4e:	60e2                	ld	ra,24(sp)
    80000a50:	6442                	ld	s0,16(sp)
    80000a52:	64a2                	ld	s1,8(sp)
    80000a54:	6105                	addi	sp,sp,32
    80000a56:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a58:	6785                	lui	a5,0x1
    80000a5a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a5c:	95be                	add	a1,a1,a5
    80000a5e:	4685                	li	a3,1
    80000a60:	00c5d613          	srli	a2,a1,0xc
    80000a64:	4581                	li	a1,0
    80000a66:	00000097          	auipc	ra,0x0
    80000a6a:	ce2080e7          	jalr	-798(ra) # 80000748 <uvmunmap>
    80000a6e:	bfd9                	j	80000a44 <uvmfree+0xe>

0000000080000a70 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a70:	c679                	beqz	a2,80000b3e <uvmcopy+0xce>
{
    80000a72:	715d                	addi	sp,sp,-80
    80000a74:	e486                	sd	ra,72(sp)
    80000a76:	e0a2                	sd	s0,64(sp)
    80000a78:	fc26                	sd	s1,56(sp)
    80000a7a:	f84a                	sd	s2,48(sp)
    80000a7c:	f44e                	sd	s3,40(sp)
    80000a7e:	f052                	sd	s4,32(sp)
    80000a80:	ec56                	sd	s5,24(sp)
    80000a82:	e85a                	sd	s6,16(sp)
    80000a84:	e45e                	sd	s7,8(sp)
    80000a86:	0880                	addi	s0,sp,80
    80000a88:	8b2a                	mv	s6,a0
    80000a8a:	8aae                	mv	s5,a1
    80000a8c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a8e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a90:	4601                	li	a2,0
    80000a92:	85ce                	mv	a1,s3
    80000a94:	855a                	mv	a0,s6
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	9d4080e7          	jalr	-1580(ra) # 8000046a <walk>
    80000a9e:	c531                	beqz	a0,80000aea <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000aa0:	6118                	ld	a4,0(a0)
    80000aa2:	00177793          	andi	a5,a4,1
    80000aa6:	cbb1                	beqz	a5,80000afa <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aa8:	00a75593          	srli	a1,a4,0xa
    80000aac:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ab0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	666080e7          	jalr	1638(ra) # 8000011a <kalloc>
    80000abc:	892a                	mv	s2,a0
    80000abe:	c939                	beqz	a0,80000b14 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ac0:	6605                	lui	a2,0x1
    80000ac2:	85de                	mv	a1,s7
    80000ac4:	fffff097          	auipc	ra,0xfffff
    80000ac8:	712080e7          	jalr	1810(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000acc:	8726                	mv	a4,s1
    80000ace:	86ca                	mv	a3,s2
    80000ad0:	6605                	lui	a2,0x1
    80000ad2:	85ce                	mv	a1,s3
    80000ad4:	8556                	mv	a0,s5
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	a7c080e7          	jalr	-1412(ra) # 80000552 <mappages>
    80000ade:	e515                	bnez	a0,80000b0a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ae0:	6785                	lui	a5,0x1
    80000ae2:	99be                	add	s3,s3,a5
    80000ae4:	fb49e6e3          	bltu	s3,s4,80000a90 <uvmcopy+0x20>
    80000ae8:	a081                	j	80000b28 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aea:	00008517          	auipc	a0,0x8
    80000aee:	62e50513          	addi	a0,a0,1582 # 80009118 <etext+0x118>
    80000af2:	00006097          	auipc	ra,0x6
    80000af6:	19a080e7          	jalr	410(ra) # 80006c8c <panic>
      panic("uvmcopy: page not present");
    80000afa:	00008517          	auipc	a0,0x8
    80000afe:	63e50513          	addi	a0,a0,1598 # 80009138 <etext+0x138>
    80000b02:	00006097          	auipc	ra,0x6
    80000b06:	18a080e7          	jalr	394(ra) # 80006c8c <panic>
      kfree(mem);
    80000b0a:	854a                	mv	a0,s2
    80000b0c:	fffff097          	auipc	ra,0xfffff
    80000b10:	510080e7          	jalr	1296(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b14:	4685                	li	a3,1
    80000b16:	00c9d613          	srli	a2,s3,0xc
    80000b1a:	4581                	li	a1,0
    80000b1c:	8556                	mv	a0,s5
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	c2a080e7          	jalr	-982(ra) # 80000748 <uvmunmap>
  return -1;
    80000b26:	557d                	li	a0,-1
}
    80000b28:	60a6                	ld	ra,72(sp)
    80000b2a:	6406                	ld	s0,64(sp)
    80000b2c:	74e2                	ld	s1,56(sp)
    80000b2e:	7942                	ld	s2,48(sp)
    80000b30:	79a2                	ld	s3,40(sp)
    80000b32:	7a02                	ld	s4,32(sp)
    80000b34:	6ae2                	ld	s5,24(sp)
    80000b36:	6b42                	ld	s6,16(sp)
    80000b38:	6ba2                	ld	s7,8(sp)
    80000b3a:	6161                	addi	sp,sp,80
    80000b3c:	8082                	ret
  return 0;
    80000b3e:	4501                	li	a0,0
}
    80000b40:	8082                	ret

0000000080000b42 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b42:	1141                	addi	sp,sp,-16
    80000b44:	e406                	sd	ra,8(sp)
    80000b46:	e022                	sd	s0,0(sp)
    80000b48:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b4a:	4601                	li	a2,0
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	91e080e7          	jalr	-1762(ra) # 8000046a <walk>
  if(pte == 0)
    80000b54:	c901                	beqz	a0,80000b64 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b56:	611c                	ld	a5,0(a0)
    80000b58:	9bbd                	andi	a5,a5,-17
    80000b5a:	e11c                	sd	a5,0(a0)
}
    80000b5c:	60a2                	ld	ra,8(sp)
    80000b5e:	6402                	ld	s0,0(sp)
    80000b60:	0141                	addi	sp,sp,16
    80000b62:	8082                	ret
    panic("uvmclear");
    80000b64:	00008517          	auipc	a0,0x8
    80000b68:	5f450513          	addi	a0,a0,1524 # 80009158 <etext+0x158>
    80000b6c:	00006097          	auipc	ra,0x6
    80000b70:	120080e7          	jalr	288(ra) # 80006c8c <panic>

0000000080000b74 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b74:	c6bd                	beqz	a3,80000be2 <copyout+0x6e>
{
    80000b76:	715d                	addi	sp,sp,-80
    80000b78:	e486                	sd	ra,72(sp)
    80000b7a:	e0a2                	sd	s0,64(sp)
    80000b7c:	fc26                	sd	s1,56(sp)
    80000b7e:	f84a                	sd	s2,48(sp)
    80000b80:	f44e                	sd	s3,40(sp)
    80000b82:	f052                	sd	s4,32(sp)
    80000b84:	ec56                	sd	s5,24(sp)
    80000b86:	e85a                	sd	s6,16(sp)
    80000b88:	e45e                	sd	s7,8(sp)
    80000b8a:	e062                	sd	s8,0(sp)
    80000b8c:	0880                	addi	s0,sp,80
    80000b8e:	8b2a                	mv	s6,a0
    80000b90:	8c2e                	mv	s8,a1
    80000b92:	8a32                	mv	s4,a2
    80000b94:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b96:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b98:	6a85                	lui	s5,0x1
    80000b9a:	a015                	j	80000bbe <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b9c:	9562                	add	a0,a0,s8
    80000b9e:	0004861b          	sext.w	a2,s1
    80000ba2:	85d2                	mv	a1,s4
    80000ba4:	41250533          	sub	a0,a0,s2
    80000ba8:	fffff097          	auipc	ra,0xfffff
    80000bac:	62e080e7          	jalr	1582(ra) # 800001d6 <memmove>

    len -= n;
    80000bb0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bb4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bb6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bba:	02098263          	beqz	s3,80000bde <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bbe:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bc2:	85ca                	mv	a1,s2
    80000bc4:	855a                	mv	a0,s6
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	94a080e7          	jalr	-1718(ra) # 80000510 <walkaddr>
    if(pa0 == 0)
    80000bce:	cd01                	beqz	a0,80000be6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bd0:	418904b3          	sub	s1,s2,s8
    80000bd4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bd6:	fc99f3e3          	bgeu	s3,s1,80000b9c <copyout+0x28>
    80000bda:	84ce                	mv	s1,s3
    80000bdc:	b7c1                	j	80000b9c <copyout+0x28>
  }
  return 0;
    80000bde:	4501                	li	a0,0
    80000be0:	a021                	j	80000be8 <copyout+0x74>
    80000be2:	4501                	li	a0,0
}
    80000be4:	8082                	ret
      return -1;
    80000be6:	557d                	li	a0,-1
}
    80000be8:	60a6                	ld	ra,72(sp)
    80000bea:	6406                	ld	s0,64(sp)
    80000bec:	74e2                	ld	s1,56(sp)
    80000bee:	7942                	ld	s2,48(sp)
    80000bf0:	79a2                	ld	s3,40(sp)
    80000bf2:	7a02                	ld	s4,32(sp)
    80000bf4:	6ae2                	ld	s5,24(sp)
    80000bf6:	6b42                	ld	s6,16(sp)
    80000bf8:	6ba2                	ld	s7,8(sp)
    80000bfa:	6c02                	ld	s8,0(sp)
    80000bfc:	6161                	addi	sp,sp,80
    80000bfe:	8082                	ret

0000000080000c00 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000c00:	caa5                	beqz	a3,80000c70 <copyin+0x70>
{
    80000c02:	715d                	addi	sp,sp,-80
    80000c04:	e486                	sd	ra,72(sp)
    80000c06:	e0a2                	sd	s0,64(sp)
    80000c08:	fc26                	sd	s1,56(sp)
    80000c0a:	f84a                	sd	s2,48(sp)
    80000c0c:	f44e                	sd	s3,40(sp)
    80000c0e:	f052                	sd	s4,32(sp)
    80000c10:	ec56                	sd	s5,24(sp)
    80000c12:	e85a                	sd	s6,16(sp)
    80000c14:	e45e                	sd	s7,8(sp)
    80000c16:	e062                	sd	s8,0(sp)
    80000c18:	0880                	addi	s0,sp,80
    80000c1a:	8b2a                	mv	s6,a0
    80000c1c:	8a2e                	mv	s4,a1
    80000c1e:	8c32                	mv	s8,a2
    80000c20:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c22:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c24:	6a85                	lui	s5,0x1
    80000c26:	a01d                	j	80000c4c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c28:	018505b3          	add	a1,a0,s8
    80000c2c:	0004861b          	sext.w	a2,s1
    80000c30:	412585b3          	sub	a1,a1,s2
    80000c34:	8552                	mv	a0,s4
    80000c36:	fffff097          	auipc	ra,0xfffff
    80000c3a:	5a0080e7          	jalr	1440(ra) # 800001d6 <memmove>

    len -= n;
    80000c3e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c42:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c48:	02098263          	beqz	s3,80000c6c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c50:	85ca                	mv	a1,s2
    80000c52:	855a                	mv	a0,s6
    80000c54:	00000097          	auipc	ra,0x0
    80000c58:	8bc080e7          	jalr	-1860(ra) # 80000510 <walkaddr>
    if(pa0 == 0)
    80000c5c:	cd01                	beqz	a0,80000c74 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c5e:	418904b3          	sub	s1,s2,s8
    80000c62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c64:	fc99f2e3          	bgeu	s3,s1,80000c28 <copyin+0x28>
    80000c68:	84ce                	mv	s1,s3
    80000c6a:	bf7d                	j	80000c28 <copyin+0x28>
  }
  return 0;
    80000c6c:	4501                	li	a0,0
    80000c6e:	a021                	j	80000c76 <copyin+0x76>
    80000c70:	4501                	li	a0,0
}
    80000c72:	8082                	ret
      return -1;
    80000c74:	557d                	li	a0,-1
}
    80000c76:	60a6                	ld	ra,72(sp)
    80000c78:	6406                	ld	s0,64(sp)
    80000c7a:	74e2                	ld	s1,56(sp)
    80000c7c:	7942                	ld	s2,48(sp)
    80000c7e:	79a2                	ld	s3,40(sp)
    80000c80:	7a02                	ld	s4,32(sp)
    80000c82:	6ae2                	ld	s5,24(sp)
    80000c84:	6b42                	ld	s6,16(sp)
    80000c86:	6ba2                	ld	s7,8(sp)
    80000c88:	6c02                	ld	s8,0(sp)
    80000c8a:	6161                	addi	sp,sp,80
    80000c8c:	8082                	ret

0000000080000c8e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c8e:	cacd                	beqz	a3,80000d40 <copyinstr+0xb2>
{
    80000c90:	715d                	addi	sp,sp,-80
    80000c92:	e486                	sd	ra,72(sp)
    80000c94:	e0a2                	sd	s0,64(sp)
    80000c96:	fc26                	sd	s1,56(sp)
    80000c98:	f84a                	sd	s2,48(sp)
    80000c9a:	f44e                	sd	s3,40(sp)
    80000c9c:	f052                	sd	s4,32(sp)
    80000c9e:	ec56                	sd	s5,24(sp)
    80000ca0:	e85a                	sd	s6,16(sp)
    80000ca2:	e45e                	sd	s7,8(sp)
    80000ca4:	0880                	addi	s0,sp,80
    80000ca6:	8a2a                	mv	s4,a0
    80000ca8:	8b2e                	mv	s6,a1
    80000caa:	8bb2                	mv	s7,a2
    80000cac:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000cae:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cb0:	6985                	lui	s3,0x1
    80000cb2:	a825                	j	80000cea <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cb4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cba:	37fd                	addiw	a5,a5,-1
    80000cbc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cc0:	60a6                	ld	ra,72(sp)
    80000cc2:	6406                	ld	s0,64(sp)
    80000cc4:	74e2                	ld	s1,56(sp)
    80000cc6:	7942                	ld	s2,48(sp)
    80000cc8:	79a2                	ld	s3,40(sp)
    80000cca:	7a02                	ld	s4,32(sp)
    80000ccc:	6ae2                	ld	s5,24(sp)
    80000cce:	6b42                	ld	s6,16(sp)
    80000cd0:	6ba2                	ld	s7,8(sp)
    80000cd2:	6161                	addi	sp,sp,80
    80000cd4:	8082                	ret
    80000cd6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000cda:	9742                	add	a4,a4,a6
      --max;
    80000cdc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000ce0:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000ce4:	04e58663          	beq	a1,a4,80000d30 <copyinstr+0xa2>
{
    80000ce8:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000cea:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cee:	85a6                	mv	a1,s1
    80000cf0:	8552                	mv	a0,s4
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	81e080e7          	jalr	-2018(ra) # 80000510 <walkaddr>
    if(pa0 == 0)
    80000cfa:	cd0d                	beqz	a0,80000d34 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000cfc:	417486b3          	sub	a3,s1,s7
    80000d00:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d02:	00d97363          	bgeu	s2,a3,80000d08 <copyinstr+0x7a>
    80000d06:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d08:	955e                	add	a0,a0,s7
    80000d0a:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d0c:	c695                	beqz	a3,80000d38 <copyinstr+0xaa>
    80000d0e:	87da                	mv	a5,s6
    80000d10:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d12:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d16:	96da                	add	a3,a3,s6
    80000d18:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d1a:	00f60733          	add	a4,a2,a5
    80000d1e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd4a80>
    80000d22:	db49                	beqz	a4,80000cb4 <copyinstr+0x26>
        *dst = *p;
    80000d24:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d28:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d2a:	fed797e3          	bne	a5,a3,80000d18 <copyinstr+0x8a>
    80000d2e:	b765                	j	80000cd6 <copyinstr+0x48>
    80000d30:	4781                	li	a5,0
    80000d32:	b761                	j	80000cba <copyinstr+0x2c>
      return -1;
    80000d34:	557d                	li	a0,-1
    80000d36:	b769                	j	80000cc0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d38:	6b85                	lui	s7,0x1
    80000d3a:	9ba6                	add	s7,s7,s1
    80000d3c:	87da                	mv	a5,s6
    80000d3e:	b76d                	j	80000ce8 <copyinstr+0x5a>
  int got_null = 0;
    80000d40:	4781                	li	a5,0
  if(got_null){
    80000d42:	37fd                	addiw	a5,a5,-1
    80000d44:	0007851b          	sext.w	a0,a5
}
    80000d48:	8082                	ret

0000000080000d4a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d4a:	7139                	addi	sp,sp,-64
    80000d4c:	fc06                	sd	ra,56(sp)
    80000d4e:	f822                	sd	s0,48(sp)
    80000d50:	f426                	sd	s1,40(sp)
    80000d52:	f04a                	sd	s2,32(sp)
    80000d54:	ec4e                	sd	s3,24(sp)
    80000d56:	e852                	sd	s4,16(sp)
    80000d58:	e456                	sd	s5,8(sp)
    80000d5a:	e05a                	sd	s6,0(sp)
    80000d5c:	0080                	addi	s0,sp,64
    80000d5e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	0000c497          	auipc	s1,0xc
    80000d64:	74048493          	addi	s1,s1,1856 # 8000d4a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d68:	8b26                	mv	s6,s1
    80000d6a:	04fa5937          	lui	s2,0x4fa5
    80000d6e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d72:	0932                	slli	s2,s2,0xc
    80000d74:	fa590913          	addi	s2,s2,-91
    80000d78:	0932                	slli	s2,s2,0xc
    80000d7a:	fa590913          	addi	s2,s2,-91
    80000d7e:	0932                	slli	s2,s2,0xc
    80000d80:	fa590913          	addi	s2,s2,-91
    80000d84:	010009b7          	lui	s3,0x1000
    80000d88:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d8a:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	00012a97          	auipc	s5,0x12
    80000d90:	114a8a93          	addi	s5,s5,276 # 80012ea0 <tickslock>
    char *pa = kalloc();
    80000d94:	fffff097          	auipc	ra,0xfffff
    80000d98:	386080e7          	jalr	902(ra) # 8000011a <kalloc>
    80000d9c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d9e:	cd1d                	beqz	a0,80000ddc <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000da0:	416485b3          	sub	a1,s1,s6
    80000da4:	858d                	srai	a1,a1,0x3
    80000da6:	032585b3          	mul	a1,a1,s2
    80000daa:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dae:	4719                	li	a4,6
    80000db0:	6685                	lui	a3,0x1
    80000db2:	40b985b3          	sub	a1,s3,a1
    80000db6:	8552                	mv	a0,s4
    80000db8:	00000097          	auipc	ra,0x0
    80000dbc:	83a080e7          	jalr	-1990(ra) # 800005f2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc0:	16848493          	addi	s1,s1,360
    80000dc4:	fd5498e3          	bne	s1,s5,80000d94 <proc_mapstacks+0x4a>
  }
}
    80000dc8:	70e2                	ld	ra,56(sp)
    80000dca:	7442                	ld	s0,48(sp)
    80000dcc:	74a2                	ld	s1,40(sp)
    80000dce:	7902                	ld	s2,32(sp)
    80000dd0:	69e2                	ld	s3,24(sp)
    80000dd2:	6a42                	ld	s4,16(sp)
    80000dd4:	6aa2                	ld	s5,8(sp)
    80000dd6:	6b02                	ld	s6,0(sp)
    80000dd8:	6121                	addi	sp,sp,64
    80000dda:	8082                	ret
      panic("kalloc");
    80000ddc:	00008517          	auipc	a0,0x8
    80000de0:	38c50513          	addi	a0,a0,908 # 80009168 <etext+0x168>
    80000de4:	00006097          	auipc	ra,0x6
    80000de8:	ea8080e7          	jalr	-344(ra) # 80006c8c <panic>

0000000080000dec <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000dec:	7139                	addi	sp,sp,-64
    80000dee:	fc06                	sd	ra,56(sp)
    80000df0:	f822                	sd	s0,48(sp)
    80000df2:	f426                	sd	s1,40(sp)
    80000df4:	f04a                	sd	s2,32(sp)
    80000df6:	ec4e                	sd	s3,24(sp)
    80000df8:	e852                	sd	s4,16(sp)
    80000dfa:	e456                	sd	s5,8(sp)
    80000dfc:	e05a                	sd	s6,0(sp)
    80000dfe:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e00:	00008597          	auipc	a1,0x8
    80000e04:	37058593          	addi	a1,a1,880 # 80009170 <etext+0x170>
    80000e08:	0000c517          	auipc	a0,0xc
    80000e0c:	26850513          	addi	a0,a0,616 # 8000d070 <pid_lock>
    80000e10:	00006097          	auipc	ra,0x6
    80000e14:	366080e7          	jalr	870(ra) # 80007176 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e18:	00008597          	auipc	a1,0x8
    80000e1c:	36058593          	addi	a1,a1,864 # 80009178 <etext+0x178>
    80000e20:	0000c517          	auipc	a0,0xc
    80000e24:	26850513          	addi	a0,a0,616 # 8000d088 <wait_lock>
    80000e28:	00006097          	auipc	ra,0x6
    80000e2c:	34e080e7          	jalr	846(ra) # 80007176 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	0000c497          	auipc	s1,0xc
    80000e34:	67048493          	addi	s1,s1,1648 # 8000d4a0 <proc>
      initlock(&p->lock, "proc");
    80000e38:	00008b17          	auipc	s6,0x8
    80000e3c:	350b0b13          	addi	s6,s6,848 # 80009188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000e40:	8aa6                	mv	s5,s1
    80000e42:	04fa5937          	lui	s2,0x4fa5
    80000e46:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e4a:	0932                	slli	s2,s2,0xc
    80000e4c:	fa590913          	addi	s2,s2,-91
    80000e50:	0932                	slli	s2,s2,0xc
    80000e52:	fa590913          	addi	s2,s2,-91
    80000e56:	0932                	slli	s2,s2,0xc
    80000e58:	fa590913          	addi	s2,s2,-91
    80000e5c:	010009b7          	lui	s3,0x1000
    80000e60:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e62:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e64:	00012a17          	auipc	s4,0x12
    80000e68:	03ca0a13          	addi	s4,s4,60 # 80012ea0 <tickslock>
      initlock(&p->lock, "proc");
    80000e6c:	85da                	mv	a1,s6
    80000e6e:	8526                	mv	a0,s1
    80000e70:	00006097          	auipc	ra,0x6
    80000e74:	306080e7          	jalr	774(ra) # 80007176 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e78:	415487b3          	sub	a5,s1,s5
    80000e7c:	878d                	srai	a5,a5,0x3
    80000e7e:	032787b3          	mul	a5,a5,s2
    80000e82:	00d7979b          	slliw	a5,a5,0xd
    80000e86:	40f987b3          	sub	a5,s3,a5
    80000e8a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8c:	16848493          	addi	s1,s1,360
    80000e90:	fd449ee3          	bne	s1,s4,80000e6c <procinit+0x80>
  }
}
    80000e94:	70e2                	ld	ra,56(sp)
    80000e96:	7442                	ld	s0,48(sp)
    80000e98:	74a2                	ld	s1,40(sp)
    80000e9a:	7902                	ld	s2,32(sp)
    80000e9c:	69e2                	ld	s3,24(sp)
    80000e9e:	6a42                	ld	s4,16(sp)
    80000ea0:	6aa2                	ld	s5,8(sp)
    80000ea2:	6b02                	ld	s6,0(sp)
    80000ea4:	6121                	addi	sp,sp,64
    80000ea6:	8082                	ret

0000000080000ea8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eae:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000eb0:	2501                	sext.w	a0,a0
    80000eb2:	6422                	ld	s0,8(sp)
    80000eb4:	0141                	addi	sp,sp,16
    80000eb6:	8082                	ret

0000000080000eb8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000eb8:	1141                	addi	sp,sp,-16
    80000eba:	e422                	sd	s0,8(sp)
    80000ebc:	0800                	addi	s0,sp,16
    80000ebe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ec0:	2781                	sext.w	a5,a5
    80000ec2:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ec4:	0000c517          	auipc	a0,0xc
    80000ec8:	1dc50513          	addi	a0,a0,476 # 8000d0a0 <cpus>
    80000ecc:	953e                	add	a0,a0,a5
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	1000                	addi	s0,sp,32
  push_off();
    80000ede:	00006097          	auipc	ra,0x6
    80000ee2:	2dc080e7          	jalr	732(ra) # 800071ba <push_off>
    80000ee6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ee8:	2781                	sext.w	a5,a5
    80000eea:	079e                	slli	a5,a5,0x7
    80000eec:	0000c717          	auipc	a4,0xc
    80000ef0:	18470713          	addi	a4,a4,388 # 8000d070 <pid_lock>
    80000ef4:	97ba                	add	a5,a5,a4
    80000ef6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ef8:	00006097          	auipc	ra,0x6
    80000efc:	362080e7          	jalr	866(ra) # 8000725a <pop_off>
  return p;
}
    80000f00:	8526                	mv	a0,s1
    80000f02:	60e2                	ld	ra,24(sp)
    80000f04:	6442                	ld	s0,16(sp)
    80000f06:	64a2                	ld	s1,8(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f0c:	1141                	addi	sp,sp,-16
    80000f0e:	e406                	sd	ra,8(sp)
    80000f10:	e022                	sd	s0,0(sp)
    80000f12:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	fc0080e7          	jalr	-64(ra) # 80000ed4 <myproc>
    80000f1c:	00006097          	auipc	ra,0x6
    80000f20:	39e080e7          	jalr	926(ra) # 800072ba <release>

  if (first) {
    80000f24:	0000b797          	auipc	a5,0xb
    80000f28:	6bc7a783          	lw	a5,1724(a5) # 8000c5e0 <first.1>
    80000f2c:	eb89                	bnez	a5,80000f3e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	c16080e7          	jalr	-1002(ra) # 80001b44 <usertrapret>
}
    80000f36:	60a2                	ld	ra,8(sp)
    80000f38:	6402                	ld	s0,0(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret
    first = 0;
    80000f3e:	0000b797          	auipc	a5,0xb
    80000f42:	6a07a123          	sw	zero,1698(a5) # 8000c5e0 <first.1>
    fsinit(ROOTDEV);
    80000f46:	4505                	li	a0,1
    80000f48:	00002097          	auipc	ra,0x2
    80000f4c:	97a080e7          	jalr	-1670(ra) # 800028c2 <fsinit>
    80000f50:	bff9                	j	80000f2e <forkret+0x22>

0000000080000f52 <allocpid>:
allocpid() {
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	e04a                	sd	s2,0(sp)
    80000f5c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f5e:	0000c917          	auipc	s2,0xc
    80000f62:	11290913          	addi	s2,s2,274 # 8000d070 <pid_lock>
    80000f66:	854a                	mv	a0,s2
    80000f68:	00006097          	auipc	ra,0x6
    80000f6c:	29e080e7          	jalr	670(ra) # 80007206 <acquire>
  pid = nextpid;
    80000f70:	0000b797          	auipc	a5,0xb
    80000f74:	67478793          	addi	a5,a5,1652 # 8000c5e4 <nextpid>
    80000f78:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f7a:	0014871b          	addiw	a4,s1,1
    80000f7e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f80:	854a                	mv	a0,s2
    80000f82:	00006097          	auipc	ra,0x6
    80000f86:	338080e7          	jalr	824(ra) # 800072ba <release>
}
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	60e2                	ld	ra,24(sp)
    80000f8e:	6442                	ld	s0,16(sp)
    80000f90:	64a2                	ld	s1,8(sp)
    80000f92:	6902                	ld	s2,0(sp)
    80000f94:	6105                	addi	sp,sp,32
    80000f96:	8082                	ret

0000000080000f98 <proc_pagetable>:
{
    80000f98:	1101                	addi	sp,sp,-32
    80000f9a:	ec06                	sd	ra,24(sp)
    80000f9c:	e822                	sd	s0,16(sp)
    80000f9e:	e426                	sd	s1,8(sp)
    80000fa0:	e04a                	sd	s2,0(sp)
    80000fa2:	1000                	addi	s0,sp,32
    80000fa4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	88a080e7          	jalr	-1910(ra) # 80000830 <uvmcreate>
    80000fae:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fb0:	c121                	beqz	a0,80000ff0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fb2:	4729                	li	a4,10
    80000fb4:	00007697          	auipc	a3,0x7
    80000fb8:	04c68693          	addi	a3,a3,76 # 80008000 <_trampoline>
    80000fbc:	6605                	lui	a2,0x1
    80000fbe:	040005b7          	lui	a1,0x4000
    80000fc2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc4:	05b2                	slli	a1,a1,0xc
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	58c080e7          	jalr	1420(ra) # 80000552 <mappages>
    80000fce:	02054863          	bltz	a0,80000ffe <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fd2:	4719                	li	a4,6
    80000fd4:	05893683          	ld	a3,88(s2)
    80000fd8:	6605                	lui	a2,0x1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	56e080e7          	jalr	1390(ra) # 80000552 <mappages>
    80000fec:	02054163          	bltz	a0,8000100e <proc_pagetable+0x76>
}
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	60e2                	ld	ra,24(sp)
    80000ff4:	6442                	ld	s0,16(sp)
    80000ff6:	64a2                	ld	s1,8(sp)
    80000ff8:	6902                	ld	s2,0(sp)
    80000ffa:	6105                	addi	sp,sp,32
    80000ffc:	8082                	ret
    uvmfree(pagetable, 0);
    80000ffe:	4581                	li	a1,0
    80001000:	8526                	mv	a0,s1
    80001002:	00000097          	auipc	ra,0x0
    80001006:	a34080e7          	jalr	-1484(ra) # 80000a36 <uvmfree>
    return 0;
    8000100a:	4481                	li	s1,0
    8000100c:	b7d5                	j	80000ff0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000100e:	4681                	li	a3,0
    80001010:	4605                	li	a2,1
    80001012:	040005b7          	lui	a1,0x4000
    80001016:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001018:	05b2                	slli	a1,a1,0xc
    8000101a:	8526                	mv	a0,s1
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	72c080e7          	jalr	1836(ra) # 80000748 <uvmunmap>
    uvmfree(pagetable, 0);
    80001024:	4581                	li	a1,0
    80001026:	8526                	mv	a0,s1
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	a0e080e7          	jalr	-1522(ra) # 80000a36 <uvmfree>
    return 0;
    80001030:	4481                	li	s1,0
    80001032:	bf7d                	j	80000ff0 <proc_pagetable+0x58>

0000000080001034 <proc_freepagetable>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
    80001040:	84aa                	mv	s1,a0
    80001042:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	040005b7          	lui	a1,0x4000
    8000104c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104e:	05b2                	slli	a1,a1,0xc
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	6f8080e7          	jalr	1784(ra) # 80000748 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001058:	4681                	li	a3,0
    8000105a:	4605                	li	a2,1
    8000105c:	020005b7          	lui	a1,0x2000
    80001060:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001062:	05b6                	slli	a1,a1,0xd
    80001064:	8526                	mv	a0,s1
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	6e2080e7          	jalr	1762(ra) # 80000748 <uvmunmap>
  uvmfree(pagetable, sz);
    8000106e:	85ca                	mv	a1,s2
    80001070:	8526                	mv	a0,s1
    80001072:	00000097          	auipc	ra,0x0
    80001076:	9c4080e7          	jalr	-1596(ra) # 80000a36 <uvmfree>
}
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <freeproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	1000                	addi	s0,sp,32
    80001090:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001092:	6d28                	ld	a0,88(a0)
    80001094:	c509                	beqz	a0,8000109e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	f86080e7          	jalr	-122(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000109e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010a2:	68a8                	ld	a0,80(s1)
    800010a4:	c511                	beqz	a0,800010b0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010a6:	64ac                	ld	a1,72(s1)
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	f8c080e7          	jalr	-116(ra) # 80001034 <proc_freepagetable>
  p->pagetable = 0;
    800010b0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010b4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010b8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010bc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010c4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010c8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010cc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d0:	0004ac23          	sw	zero,24(s1)
}
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6105                	addi	sp,sp,32
    800010dc:	8082                	ret

00000000800010de <allocproc>:
{
    800010de:	1101                	addi	sp,sp,-32
    800010e0:	ec06                	sd	ra,24(sp)
    800010e2:	e822                	sd	s0,16(sp)
    800010e4:	e426                	sd	s1,8(sp)
    800010e6:	e04a                	sd	s2,0(sp)
    800010e8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ea:	0000c497          	auipc	s1,0xc
    800010ee:	3b648493          	addi	s1,s1,950 # 8000d4a0 <proc>
    800010f2:	00012917          	auipc	s2,0x12
    800010f6:	dae90913          	addi	s2,s2,-594 # 80012ea0 <tickslock>
    acquire(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00006097          	auipc	ra,0x6
    80001100:	10a080e7          	jalr	266(ra) # 80007206 <acquire>
    if(p->state == UNUSED) {
    80001104:	4c9c                	lw	a5,24(s1)
    80001106:	cf81                	beqz	a5,8000111e <allocproc+0x40>
      release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00006097          	auipc	ra,0x6
    8000110e:	1b0080e7          	jalr	432(ra) # 800072ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001112:	16848493          	addi	s1,s1,360
    80001116:	ff2492e3          	bne	s1,s2,800010fa <allocproc+0x1c>
  return 0;
    8000111a:	4481                	li	s1,0
    8000111c:	a889                	j	8000116e <allocproc+0x90>
  p->pid = allocpid();
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	e34080e7          	jalr	-460(ra) # 80000f52 <allocpid>
    80001126:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001128:	4785                	li	a5,1
    8000112a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	fee080e7          	jalr	-18(ra) # 8000011a <kalloc>
    80001134:	892a                	mv	s2,a0
    80001136:	eca8                	sd	a0,88(s1)
    80001138:	c131                	beqz	a0,8000117c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	e5c080e7          	jalr	-420(ra) # 80000f98 <proc_pagetable>
    80001144:	892a                	mv	s2,a0
    80001146:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001148:	c531                	beqz	a0,80001194 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000114a:	07000613          	li	a2,112
    8000114e:	4581                	li	a1,0
    80001150:	06048513          	addi	a0,s1,96
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000115c:	00000797          	auipc	a5,0x0
    80001160:	db078793          	addi	a5,a5,-592 # 80000f0c <forkret>
    80001164:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001166:	60bc                	ld	a5,64(s1)
    80001168:	6705                	lui	a4,0x1
    8000116a:	97ba                	add	a5,a5,a4
    8000116c:	f4bc                	sd	a5,104(s1)
}
    8000116e:	8526                	mv	a0,s1
    80001170:	60e2                	ld	ra,24(sp)
    80001172:	6442                	ld	s0,16(sp)
    80001174:	64a2                	ld	s1,8(sp)
    80001176:	6902                	ld	s2,0(sp)
    80001178:	6105                	addi	sp,sp,32
    8000117a:	8082                	ret
    freeproc(p);
    8000117c:	8526                	mv	a0,s1
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	f08080e7          	jalr	-248(ra) # 80001086 <freeproc>
    release(&p->lock);
    80001186:	8526                	mv	a0,s1
    80001188:	00006097          	auipc	ra,0x6
    8000118c:	132080e7          	jalr	306(ra) # 800072ba <release>
    return 0;
    80001190:	84ca                	mv	s1,s2
    80001192:	bff1                	j	8000116e <allocproc+0x90>
    freeproc(p);
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	ef0080e7          	jalr	-272(ra) # 80001086 <freeproc>
    release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00006097          	auipc	ra,0x6
    800011a4:	11a080e7          	jalr	282(ra) # 800072ba <release>
    return 0;
    800011a8:	84ca                	mv	s1,s2
    800011aa:	b7d1                	j	8000116e <allocproc+0x90>

00000000800011ac <userinit>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	1000                	addi	s0,sp,32
  p = allocproc();
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f28080e7          	jalr	-216(ra) # 800010de <allocproc>
    800011be:	84aa                	mv	s1,a0
  initproc = p;
    800011c0:	0000c797          	auipc	a5,0xc
    800011c4:	e4a7b823          	sd	a0,-432(a5) # 8000d010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011c8:	03400613          	li	a2,52
    800011cc:	0000b597          	auipc	a1,0xb
    800011d0:	43458593          	addi	a1,a1,1076 # 8000c600 <initcode>
    800011d4:	6928                	ld	a0,80(a0)
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	688080e7          	jalr	1672(ra) # 8000085e <uvminit>
  p->sz = PGSIZE;
    800011de:	6785                	lui	a5,0x1
    800011e0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011e2:	6cb8                	ld	a4,88(s1)
    800011e4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011e8:	6cb8                	ld	a4,88(s1)
    800011ea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ec:	4641                	li	a2,16
    800011ee:	00008597          	auipc	a1,0x8
    800011f2:	fa258593          	addi	a1,a1,-94 # 80009190 <etext+0x190>
    800011f6:	15848513          	addi	a0,s1,344
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	0c2080e7          	jalr	194(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001202:	00008517          	auipc	a0,0x8
    80001206:	f9e50513          	addi	a0,a0,-98 # 800091a0 <etext+0x1a0>
    8000120a:	00002097          	auipc	ra,0x2
    8000120e:	0fe080e7          	jalr	254(ra) # 80003308 <namei>
    80001212:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001216:	478d                	li	a5,3
    80001218:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000121a:	8526                	mv	a0,s1
    8000121c:	00006097          	auipc	ra,0x6
    80001220:	09e080e7          	jalr	158(ra) # 800072ba <release>
}
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <growproc>:
{
    8000122e:	1101                	addi	sp,sp,-32
    80001230:	ec06                	sd	ra,24(sp)
    80001232:	e822                	sd	s0,16(sp)
    80001234:	e426                	sd	s1,8(sp)
    80001236:	e04a                	sd	s2,0(sp)
    80001238:	1000                	addi	s0,sp,32
    8000123a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	c98080e7          	jalr	-872(ra) # 80000ed4 <myproc>
    80001244:	892a                	mv	s2,a0
  sz = p->sz;
    80001246:	652c                	ld	a1,72(a0)
    80001248:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000124c:	00904f63          	bgtz	s1,8000126a <growproc+0x3c>
  } else if(n < 0){
    80001250:	0204cd63          	bltz	s1,8000128a <growproc+0x5c>
  p->sz = sz;
    80001254:	1782                	slli	a5,a5,0x20
    80001256:	9381                	srli	a5,a5,0x20
    80001258:	04f93423          	sd	a5,72(s2)
  return 0;
    8000125c:	4501                	li	a0,0
}
    8000125e:	60e2                	ld	ra,24(sp)
    80001260:	6442                	ld	s0,16(sp)
    80001262:	64a2                	ld	s1,8(sp)
    80001264:	6902                	ld	s2,0(sp)
    80001266:	6105                	addi	sp,sp,32
    80001268:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000126a:	00f4863b          	addw	a2,s1,a5
    8000126e:	1602                	slli	a2,a2,0x20
    80001270:	9201                	srli	a2,a2,0x20
    80001272:	1582                	slli	a1,a1,0x20
    80001274:	9181                	srli	a1,a1,0x20
    80001276:	6928                	ld	a0,80(a0)
    80001278:	fffff097          	auipc	ra,0xfffff
    8000127c:	6a0080e7          	jalr	1696(ra) # 80000918 <uvmalloc>
    80001280:	0005079b          	sext.w	a5,a0
    80001284:	fbe1                	bnez	a5,80001254 <growproc+0x26>
      return -1;
    80001286:	557d                	li	a0,-1
    80001288:	bfd9                	j	8000125e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000128a:	00f4863b          	addw	a2,s1,a5
    8000128e:	1602                	slli	a2,a2,0x20
    80001290:	9201                	srli	a2,a2,0x20
    80001292:	1582                	slli	a1,a1,0x20
    80001294:	9181                	srli	a1,a1,0x20
    80001296:	6928                	ld	a0,80(a0)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	638080e7          	jalr	1592(ra) # 800008d0 <uvmdealloc>
    800012a0:	0005079b          	sext.w	a5,a0
    800012a4:	bf45                	j	80001254 <growproc+0x26>

00000000800012a6 <fork>:
{
    800012a6:	7139                	addi	sp,sp,-64
    800012a8:	fc06                	sd	ra,56(sp)
    800012aa:	f822                	sd	s0,48(sp)
    800012ac:	f04a                	sd	s2,32(sp)
    800012ae:	e456                	sd	s5,8(sp)
    800012b0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	c22080e7          	jalr	-990(ra) # 80000ed4 <myproc>
    800012ba:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	e22080e7          	jalr	-478(ra) # 800010de <allocproc>
    800012c4:	12050063          	beqz	a0,800013e4 <fork+0x13e>
    800012c8:	e852                	sd	s4,16(sp)
    800012ca:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012cc:	048ab603          	ld	a2,72(s5)
    800012d0:	692c                	ld	a1,80(a0)
    800012d2:	050ab503          	ld	a0,80(s5)
    800012d6:	fffff097          	auipc	ra,0xfffff
    800012da:	79a080e7          	jalr	1946(ra) # 80000a70 <uvmcopy>
    800012de:	04054a63          	bltz	a0,80001332 <fork+0x8c>
    800012e2:	f426                	sd	s1,40(sp)
    800012e4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012e6:	048ab783          	ld	a5,72(s5)
    800012ea:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012ee:	058ab683          	ld	a3,88(s5)
    800012f2:	87b6                	mv	a5,a3
    800012f4:	058a3703          	ld	a4,88(s4)
    800012f8:	12068693          	addi	a3,a3,288
    800012fc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001300:	6788                	ld	a0,8(a5)
    80001302:	6b8c                	ld	a1,16(a5)
    80001304:	6f90                	ld	a2,24(a5)
    80001306:	01073023          	sd	a6,0(a4)
    8000130a:	e708                	sd	a0,8(a4)
    8000130c:	eb0c                	sd	a1,16(a4)
    8000130e:	ef10                	sd	a2,24(a4)
    80001310:	02078793          	addi	a5,a5,32
    80001314:	02070713          	addi	a4,a4,32
    80001318:	fed792e3          	bne	a5,a3,800012fc <fork+0x56>
  np->trapframe->a0 = 0;
    8000131c:	058a3783          	ld	a5,88(s4)
    80001320:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001324:	0d0a8493          	addi	s1,s5,208
    80001328:	0d0a0913          	addi	s2,s4,208
    8000132c:	150a8993          	addi	s3,s5,336
    80001330:	a015                	j	80001354 <fork+0xae>
    freeproc(np);
    80001332:	8552                	mv	a0,s4
    80001334:	00000097          	auipc	ra,0x0
    80001338:	d52080e7          	jalr	-686(ra) # 80001086 <freeproc>
    release(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00006097          	auipc	ra,0x6
    80001342:	f7c080e7          	jalr	-132(ra) # 800072ba <release>
    return -1;
    80001346:	597d                	li	s2,-1
    80001348:	6a42                	ld	s4,16(sp)
    8000134a:	a071                	j	800013d6 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000134c:	04a1                	addi	s1,s1,8
    8000134e:	0921                	addi	s2,s2,8
    80001350:	01348b63          	beq	s1,s3,80001366 <fork+0xc0>
    if(p->ofile[i])
    80001354:	6088                	ld	a0,0(s1)
    80001356:	d97d                	beqz	a0,8000134c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001358:	00002097          	auipc	ra,0x2
    8000135c:	628080e7          	jalr	1576(ra) # 80003980 <filedup>
    80001360:	00a93023          	sd	a0,0(s2)
    80001364:	b7e5                	j	8000134c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001366:	150ab503          	ld	a0,336(s5)
    8000136a:	00001097          	auipc	ra,0x1
    8000136e:	78e080e7          	jalr	1934(ra) # 80002af8 <idup>
    80001372:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001376:	4641                	li	a2,16
    80001378:	158a8593          	addi	a1,s5,344
    8000137c:	158a0513          	addi	a0,s4,344
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	f3c080e7          	jalr	-196(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001388:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000138c:	8552                	mv	a0,s4
    8000138e:	00006097          	auipc	ra,0x6
    80001392:	f2c080e7          	jalr	-212(ra) # 800072ba <release>
  acquire(&wait_lock);
    80001396:	0000c497          	auipc	s1,0xc
    8000139a:	cf248493          	addi	s1,s1,-782 # 8000d088 <wait_lock>
    8000139e:	8526                	mv	a0,s1
    800013a0:	00006097          	auipc	ra,0x6
    800013a4:	e66080e7          	jalr	-410(ra) # 80007206 <acquire>
  np->parent = p;
    800013a8:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00006097          	auipc	ra,0x6
    800013b2:	f0c080e7          	jalr	-244(ra) # 800072ba <release>
  acquire(&np->lock);
    800013b6:	8552                	mv	a0,s4
    800013b8:	00006097          	auipc	ra,0x6
    800013bc:	e4e080e7          	jalr	-434(ra) # 80007206 <acquire>
  np->state = RUNNABLE;
    800013c0:	478d                	li	a5,3
    800013c2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013c6:	8552                	mv	a0,s4
    800013c8:	00006097          	auipc	ra,0x6
    800013cc:	ef2080e7          	jalr	-270(ra) # 800072ba <release>
  return pid;
    800013d0:	74a2                	ld	s1,40(sp)
    800013d2:	69e2                	ld	s3,24(sp)
    800013d4:	6a42                	ld	s4,16(sp)
}
    800013d6:	854a                	mv	a0,s2
    800013d8:	70e2                	ld	ra,56(sp)
    800013da:	7442                	ld	s0,48(sp)
    800013dc:	7902                	ld	s2,32(sp)
    800013de:	6aa2                	ld	s5,8(sp)
    800013e0:	6121                	addi	sp,sp,64
    800013e2:	8082                	ret
    return -1;
    800013e4:	597d                	li	s2,-1
    800013e6:	bfc5                	j	800013d6 <fork+0x130>

00000000800013e8 <scheduler>:
{
    800013e8:	7139                	addi	sp,sp,-64
    800013ea:	fc06                	sd	ra,56(sp)
    800013ec:	f822                	sd	s0,48(sp)
    800013ee:	f426                	sd	s1,40(sp)
    800013f0:	f04a                	sd	s2,32(sp)
    800013f2:	ec4e                	sd	s3,24(sp)
    800013f4:	e852                	sd	s4,16(sp)
    800013f6:	e456                	sd	s5,8(sp)
    800013f8:	e05a                	sd	s6,0(sp)
    800013fa:	0080                	addi	s0,sp,64
    800013fc:	8792                	mv	a5,tp
  int id = r_tp();
    800013fe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001400:	00779a93          	slli	s5,a5,0x7
    80001404:	0000c717          	auipc	a4,0xc
    80001408:	c6c70713          	addi	a4,a4,-916 # 8000d070 <pid_lock>
    8000140c:	9756                	add	a4,a4,s5
    8000140e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001412:	0000c717          	auipc	a4,0xc
    80001416:	c9670713          	addi	a4,a4,-874 # 8000d0a8 <cpus+0x8>
    8000141a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000141c:	498d                	li	s3,3
        p->state = RUNNING;
    8000141e:	4b11                	li	s6,4
        c->proc = p;
    80001420:	079e                	slli	a5,a5,0x7
    80001422:	0000ca17          	auipc	s4,0xc
    80001426:	c4ea0a13          	addi	s4,s4,-946 # 8000d070 <pid_lock>
    8000142a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142c:	00012917          	auipc	s2,0x12
    80001430:	a7490913          	addi	s2,s2,-1420 # 80012ea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001434:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001438:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143c:	10079073          	csrw	sstatus,a5
    80001440:	0000c497          	auipc	s1,0xc
    80001444:	06048493          	addi	s1,s1,96 # 8000d4a0 <proc>
    80001448:	a811                	j	8000145c <scheduler+0x74>
      release(&p->lock);
    8000144a:	8526                	mv	a0,s1
    8000144c:	00006097          	auipc	ra,0x6
    80001450:	e6e080e7          	jalr	-402(ra) # 800072ba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001454:	16848493          	addi	s1,s1,360
    80001458:	fd248ee3          	beq	s1,s2,80001434 <scheduler+0x4c>
      acquire(&p->lock);
    8000145c:	8526                	mv	a0,s1
    8000145e:	00006097          	auipc	ra,0x6
    80001462:	da8080e7          	jalr	-600(ra) # 80007206 <acquire>
      if(p->state == RUNNABLE) {
    80001466:	4c9c                	lw	a5,24(s1)
    80001468:	ff3791e3          	bne	a5,s3,8000144a <scheduler+0x62>
        p->state = RUNNING;
    8000146c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001470:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001474:	06048593          	addi	a1,s1,96
    80001478:	8556                	mv	a0,s5
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	620080e7          	jalr	1568(ra) # 80001a9a <swtch>
        c->proc = 0;
    80001482:	020a3823          	sd	zero,48(s4)
    80001486:	b7d1                	j	8000144a <scheduler+0x62>

0000000080001488 <sched>:
{
    80001488:	7179                	addi	sp,sp,-48
    8000148a:	f406                	sd	ra,40(sp)
    8000148c:	f022                	sd	s0,32(sp)
    8000148e:	ec26                	sd	s1,24(sp)
    80001490:	e84a                	sd	s2,16(sp)
    80001492:	e44e                	sd	s3,8(sp)
    80001494:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	a3e080e7          	jalr	-1474(ra) # 80000ed4 <myproc>
    8000149e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014a0:	00006097          	auipc	ra,0x6
    800014a4:	cec080e7          	jalr	-788(ra) # 8000718c <holding>
    800014a8:	c93d                	beqz	a0,8000151e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014aa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	0000c717          	auipc	a4,0xc
    800014b4:	bc070713          	addi	a4,a4,-1088 # 8000d070 <pid_lock>
    800014b8:	97ba                	add	a5,a5,a4
    800014ba:	0a87a703          	lw	a4,168(a5)
    800014be:	4785                	li	a5,1
    800014c0:	06f71763          	bne	a4,a5,8000152e <sched+0xa6>
  if(p->state == RUNNING)
    800014c4:	4c98                	lw	a4,24(s1)
    800014c6:	4791                	li	a5,4
    800014c8:	06f70b63          	beq	a4,a5,8000153e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014d2:	efb5                	bnez	a5,8000154e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d6:	0000c917          	auipc	s2,0xc
    800014da:	b9a90913          	addi	s2,s2,-1126 # 8000d070 <pid_lock>
    800014de:	2781                	sext.w	a5,a5
    800014e0:	079e                	slli	a5,a5,0x7
    800014e2:	97ca                	add	a5,a5,s2
    800014e4:	0ac7a983          	lw	s3,172(a5)
    800014e8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ea:	2781                	sext.w	a5,a5
    800014ec:	079e                	slli	a5,a5,0x7
    800014ee:	0000c597          	auipc	a1,0xc
    800014f2:	bba58593          	addi	a1,a1,-1094 # 8000d0a8 <cpus+0x8>
    800014f6:	95be                	add	a1,a1,a5
    800014f8:	06048513          	addi	a0,s1,96
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	59e080e7          	jalr	1438(ra) # 80001a9a <swtch>
    80001504:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001506:	2781                	sext.w	a5,a5
    80001508:	079e                	slli	a5,a5,0x7
    8000150a:	993e                	add	s2,s2,a5
    8000150c:	0b392623          	sw	s3,172(s2)
}
    80001510:	70a2                	ld	ra,40(sp)
    80001512:	7402                	ld	s0,32(sp)
    80001514:	64e2                	ld	s1,24(sp)
    80001516:	6942                	ld	s2,16(sp)
    80001518:	69a2                	ld	s3,8(sp)
    8000151a:	6145                	addi	sp,sp,48
    8000151c:	8082                	ret
    panic("sched p->lock");
    8000151e:	00008517          	auipc	a0,0x8
    80001522:	c8a50513          	addi	a0,a0,-886 # 800091a8 <etext+0x1a8>
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	766080e7          	jalr	1894(ra) # 80006c8c <panic>
    panic("sched locks");
    8000152e:	00008517          	auipc	a0,0x8
    80001532:	c8a50513          	addi	a0,a0,-886 # 800091b8 <etext+0x1b8>
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	756080e7          	jalr	1878(ra) # 80006c8c <panic>
    panic("sched running");
    8000153e:	00008517          	auipc	a0,0x8
    80001542:	c8a50513          	addi	a0,a0,-886 # 800091c8 <etext+0x1c8>
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	746080e7          	jalr	1862(ra) # 80006c8c <panic>
    panic("sched interruptible");
    8000154e:	00008517          	auipc	a0,0x8
    80001552:	c8a50513          	addi	a0,a0,-886 # 800091d8 <etext+0x1d8>
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	736080e7          	jalr	1846(ra) # 80006c8c <panic>

000000008000155e <yield>:
{
    8000155e:	1101                	addi	sp,sp,-32
    80001560:	ec06                	sd	ra,24(sp)
    80001562:	e822                	sd	s0,16(sp)
    80001564:	e426                	sd	s1,8(sp)
    80001566:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	96c080e7          	jalr	-1684(ra) # 80000ed4 <myproc>
    80001570:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001572:	00006097          	auipc	ra,0x6
    80001576:	c94080e7          	jalr	-876(ra) # 80007206 <acquire>
  p->state = RUNNABLE;
    8000157a:	478d                	li	a5,3
    8000157c:	cc9c                	sw	a5,24(s1)
  sched();
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	f0a080e7          	jalr	-246(ra) # 80001488 <sched>
  release(&p->lock);
    80001586:	8526                	mv	a0,s1
    80001588:	00006097          	auipc	ra,0x6
    8000158c:	d32080e7          	jalr	-718(ra) # 800072ba <release>
}
    80001590:	60e2                	ld	ra,24(sp)
    80001592:	6442                	ld	s0,16(sp)
    80001594:	64a2                	ld	s1,8(sp)
    80001596:	6105                	addi	sp,sp,32
    80001598:	8082                	ret

000000008000159a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000159a:	7179                	addi	sp,sp,-48
    8000159c:	f406                	sd	ra,40(sp)
    8000159e:	f022                	sd	s0,32(sp)
    800015a0:	ec26                	sd	s1,24(sp)
    800015a2:	e84a                	sd	s2,16(sp)
    800015a4:	e44e                	sd	s3,8(sp)
    800015a6:	1800                	addi	s0,sp,48
    800015a8:	89aa                	mv	s3,a0
    800015aa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	928080e7          	jalr	-1752(ra) # 80000ed4 <myproc>
    800015b4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015b6:	00006097          	auipc	ra,0x6
    800015ba:	c50080e7          	jalr	-944(ra) # 80007206 <acquire>
  release(lk);
    800015be:	854a                	mv	a0,s2
    800015c0:	00006097          	auipc	ra,0x6
    800015c4:	cfa080e7          	jalr	-774(ra) # 800072ba <release>

  // Go to sleep.
  p->chan = chan;
    800015c8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015cc:	4789                	li	a5,2
    800015ce:	cc9c                	sw	a5,24(s1)

  sched();
    800015d0:	00000097          	auipc	ra,0x0
    800015d4:	eb8080e7          	jalr	-328(ra) # 80001488 <sched>

  // Tidy up.
  p->chan = 0;
    800015d8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	00006097          	auipc	ra,0x6
    800015e2:	cdc080e7          	jalr	-804(ra) # 800072ba <release>
  acquire(lk);
    800015e6:	854a                	mv	a0,s2
    800015e8:	00006097          	auipc	ra,0x6
    800015ec:	c1e080e7          	jalr	-994(ra) # 80007206 <acquire>
}
    800015f0:	70a2                	ld	ra,40(sp)
    800015f2:	7402                	ld	s0,32(sp)
    800015f4:	64e2                	ld	s1,24(sp)
    800015f6:	6942                	ld	s2,16(sp)
    800015f8:	69a2                	ld	s3,8(sp)
    800015fa:	6145                	addi	sp,sp,48
    800015fc:	8082                	ret

00000000800015fe <wait>:
{
    800015fe:	715d                	addi	sp,sp,-80
    80001600:	e486                	sd	ra,72(sp)
    80001602:	e0a2                	sd	s0,64(sp)
    80001604:	fc26                	sd	s1,56(sp)
    80001606:	f84a                	sd	s2,48(sp)
    80001608:	f44e                	sd	s3,40(sp)
    8000160a:	f052                	sd	s4,32(sp)
    8000160c:	ec56                	sd	s5,24(sp)
    8000160e:	e85a                	sd	s6,16(sp)
    80001610:	e45e                	sd	s7,8(sp)
    80001612:	e062                	sd	s8,0(sp)
    80001614:	0880                	addi	s0,sp,80
    80001616:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001618:	00000097          	auipc	ra,0x0
    8000161c:	8bc080e7          	jalr	-1860(ra) # 80000ed4 <myproc>
    80001620:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001622:	0000c517          	auipc	a0,0xc
    80001626:	a6650513          	addi	a0,a0,-1434 # 8000d088 <wait_lock>
    8000162a:	00006097          	auipc	ra,0x6
    8000162e:	bdc080e7          	jalr	-1060(ra) # 80007206 <acquire>
    havekids = 0;
    80001632:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001634:	4a15                	li	s4,5
        havekids = 1;
    80001636:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001638:	00012997          	auipc	s3,0x12
    8000163c:	86898993          	addi	s3,s3,-1944 # 80012ea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001640:	0000cc17          	auipc	s8,0xc
    80001644:	a48c0c13          	addi	s8,s8,-1464 # 8000d088 <wait_lock>
    80001648:	a87d                	j	80001706 <wait+0x108>
          pid = np->pid;
    8000164a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000164e:	000b0e63          	beqz	s6,8000166a <wait+0x6c>
    80001652:	4691                	li	a3,4
    80001654:	02c48613          	addi	a2,s1,44
    80001658:	85da                	mv	a1,s6
    8000165a:	05093503          	ld	a0,80(s2)
    8000165e:	fffff097          	auipc	ra,0xfffff
    80001662:	516080e7          	jalr	1302(ra) # 80000b74 <copyout>
    80001666:	04054163          	bltz	a0,800016a8 <wait+0xaa>
          freeproc(np);
    8000166a:	8526                	mv	a0,s1
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	a1a080e7          	jalr	-1510(ra) # 80001086 <freeproc>
          release(&np->lock);
    80001674:	8526                	mv	a0,s1
    80001676:	00006097          	auipc	ra,0x6
    8000167a:	c44080e7          	jalr	-956(ra) # 800072ba <release>
          release(&wait_lock);
    8000167e:	0000c517          	auipc	a0,0xc
    80001682:	a0a50513          	addi	a0,a0,-1526 # 8000d088 <wait_lock>
    80001686:	00006097          	auipc	ra,0x6
    8000168a:	c34080e7          	jalr	-972(ra) # 800072ba <release>
}
    8000168e:	854e                	mv	a0,s3
    80001690:	60a6                	ld	ra,72(sp)
    80001692:	6406                	ld	s0,64(sp)
    80001694:	74e2                	ld	s1,56(sp)
    80001696:	7942                	ld	s2,48(sp)
    80001698:	79a2                	ld	s3,40(sp)
    8000169a:	7a02                	ld	s4,32(sp)
    8000169c:	6ae2                	ld	s5,24(sp)
    8000169e:	6b42                	ld	s6,16(sp)
    800016a0:	6ba2                	ld	s7,8(sp)
    800016a2:	6c02                	ld	s8,0(sp)
    800016a4:	6161                	addi	sp,sp,80
    800016a6:	8082                	ret
            release(&np->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	00006097          	auipc	ra,0x6
    800016ae:	c10080e7          	jalr	-1008(ra) # 800072ba <release>
            release(&wait_lock);
    800016b2:	0000c517          	auipc	a0,0xc
    800016b6:	9d650513          	addi	a0,a0,-1578 # 8000d088 <wait_lock>
    800016ba:	00006097          	auipc	ra,0x6
    800016be:	c00080e7          	jalr	-1024(ra) # 800072ba <release>
            return -1;
    800016c2:	59fd                	li	s3,-1
    800016c4:	b7e9                	j	8000168e <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016c6:	16848493          	addi	s1,s1,360
    800016ca:	03348463          	beq	s1,s3,800016f2 <wait+0xf4>
      if(np->parent == p){
    800016ce:	7c9c                	ld	a5,56(s1)
    800016d0:	ff279be3          	bne	a5,s2,800016c6 <wait+0xc8>
        acquire(&np->lock);
    800016d4:	8526                	mv	a0,s1
    800016d6:	00006097          	auipc	ra,0x6
    800016da:	b30080e7          	jalr	-1232(ra) # 80007206 <acquire>
        if(np->state == ZOMBIE){
    800016de:	4c9c                	lw	a5,24(s1)
    800016e0:	f74785e3          	beq	a5,s4,8000164a <wait+0x4c>
        release(&np->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00006097          	auipc	ra,0x6
    800016ea:	bd4080e7          	jalr	-1068(ra) # 800072ba <release>
        havekids = 1;
    800016ee:	8756                	mv	a4,s5
    800016f0:	bfd9                	j	800016c6 <wait+0xc8>
    if(!havekids || p->killed){
    800016f2:	c305                	beqz	a4,80001712 <wait+0x114>
    800016f4:	02892783          	lw	a5,40(s2)
    800016f8:	ef89                	bnez	a5,80001712 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016fa:	85e2                	mv	a1,s8
    800016fc:	854a                	mv	a0,s2
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	e9c080e7          	jalr	-356(ra) # 8000159a <sleep>
    havekids = 0;
    80001706:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001708:	0000c497          	auipc	s1,0xc
    8000170c:	d9848493          	addi	s1,s1,-616 # 8000d4a0 <proc>
    80001710:	bf7d                	j	800016ce <wait+0xd0>
      release(&wait_lock);
    80001712:	0000c517          	auipc	a0,0xc
    80001716:	97650513          	addi	a0,a0,-1674 # 8000d088 <wait_lock>
    8000171a:	00006097          	auipc	ra,0x6
    8000171e:	ba0080e7          	jalr	-1120(ra) # 800072ba <release>
      return -1;
    80001722:	59fd                	li	s3,-1
    80001724:	b7ad                	j	8000168e <wait+0x90>

0000000080001726 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001726:	7139                	addi	sp,sp,-64
    80001728:	fc06                	sd	ra,56(sp)
    8000172a:	f822                	sd	s0,48(sp)
    8000172c:	f426                	sd	s1,40(sp)
    8000172e:	f04a                	sd	s2,32(sp)
    80001730:	ec4e                	sd	s3,24(sp)
    80001732:	e852                	sd	s4,16(sp)
    80001734:	e456                	sd	s5,8(sp)
    80001736:	0080                	addi	s0,sp,64
    80001738:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000173a:	0000c497          	auipc	s1,0xc
    8000173e:	d6648493          	addi	s1,s1,-666 # 8000d4a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001742:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001744:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001746:	00011917          	auipc	s2,0x11
    8000174a:	75a90913          	addi	s2,s2,1882 # 80012ea0 <tickslock>
    8000174e:	a811                	j	80001762 <wakeup+0x3c>
      }
      release(&p->lock);
    80001750:	8526                	mv	a0,s1
    80001752:	00006097          	auipc	ra,0x6
    80001756:	b68080e7          	jalr	-1176(ra) # 800072ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000175a:	16848493          	addi	s1,s1,360
    8000175e:	03248663          	beq	s1,s2,8000178a <wakeup+0x64>
    if(p != myproc()){
    80001762:	fffff097          	auipc	ra,0xfffff
    80001766:	772080e7          	jalr	1906(ra) # 80000ed4 <myproc>
    8000176a:	fea488e3          	beq	s1,a0,8000175a <wakeup+0x34>
      acquire(&p->lock);
    8000176e:	8526                	mv	a0,s1
    80001770:	00006097          	auipc	ra,0x6
    80001774:	a96080e7          	jalr	-1386(ra) # 80007206 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001778:	4c9c                	lw	a5,24(s1)
    8000177a:	fd379be3          	bne	a5,s3,80001750 <wakeup+0x2a>
    8000177e:	709c                	ld	a5,32(s1)
    80001780:	fd4798e3          	bne	a5,s4,80001750 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001784:	0154ac23          	sw	s5,24(s1)
    80001788:	b7e1                	j	80001750 <wakeup+0x2a>
    }
  }
}
    8000178a:	70e2                	ld	ra,56(sp)
    8000178c:	7442                	ld	s0,48(sp)
    8000178e:	74a2                	ld	s1,40(sp)
    80001790:	7902                	ld	s2,32(sp)
    80001792:	69e2                	ld	s3,24(sp)
    80001794:	6a42                	ld	s4,16(sp)
    80001796:	6aa2                	ld	s5,8(sp)
    80001798:	6121                	addi	sp,sp,64
    8000179a:	8082                	ret

000000008000179c <reparent>:
{
    8000179c:	7179                	addi	sp,sp,-48
    8000179e:	f406                	sd	ra,40(sp)
    800017a0:	f022                	sd	s0,32(sp)
    800017a2:	ec26                	sd	s1,24(sp)
    800017a4:	e84a                	sd	s2,16(sp)
    800017a6:	e44e                	sd	s3,8(sp)
    800017a8:	e052                	sd	s4,0(sp)
    800017aa:	1800                	addi	s0,sp,48
    800017ac:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ae:	0000c497          	auipc	s1,0xc
    800017b2:	cf248493          	addi	s1,s1,-782 # 8000d4a0 <proc>
      pp->parent = initproc;
    800017b6:	0000ca17          	auipc	s4,0xc
    800017ba:	85aa0a13          	addi	s4,s4,-1958 # 8000d010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017be:	00011997          	auipc	s3,0x11
    800017c2:	6e298993          	addi	s3,s3,1762 # 80012ea0 <tickslock>
    800017c6:	a029                	j	800017d0 <reparent+0x34>
    800017c8:	16848493          	addi	s1,s1,360
    800017cc:	01348d63          	beq	s1,s3,800017e6 <reparent+0x4a>
    if(pp->parent == p){
    800017d0:	7c9c                	ld	a5,56(s1)
    800017d2:	ff279be3          	bne	a5,s2,800017c8 <reparent+0x2c>
      pp->parent = initproc;
    800017d6:	000a3503          	ld	a0,0(s4)
    800017da:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	f4a080e7          	jalr	-182(ra) # 80001726 <wakeup>
    800017e4:	b7d5                	j	800017c8 <reparent+0x2c>
}
    800017e6:	70a2                	ld	ra,40(sp)
    800017e8:	7402                	ld	s0,32(sp)
    800017ea:	64e2                	ld	s1,24(sp)
    800017ec:	6942                	ld	s2,16(sp)
    800017ee:	69a2                	ld	s3,8(sp)
    800017f0:	6a02                	ld	s4,0(sp)
    800017f2:	6145                	addi	sp,sp,48
    800017f4:	8082                	ret

00000000800017f6 <exit>:
{
    800017f6:	7179                	addi	sp,sp,-48
    800017f8:	f406                	sd	ra,40(sp)
    800017fa:	f022                	sd	s0,32(sp)
    800017fc:	ec26                	sd	s1,24(sp)
    800017fe:	e84a                	sd	s2,16(sp)
    80001800:	e44e                	sd	s3,8(sp)
    80001802:	e052                	sd	s4,0(sp)
    80001804:	1800                	addi	s0,sp,48
    80001806:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001808:	fffff097          	auipc	ra,0xfffff
    8000180c:	6cc080e7          	jalr	1740(ra) # 80000ed4 <myproc>
    80001810:	89aa                	mv	s3,a0
  if(p == initproc)
    80001812:	0000b797          	auipc	a5,0xb
    80001816:	7fe7b783          	ld	a5,2046(a5) # 8000d010 <initproc>
    8000181a:	0d050493          	addi	s1,a0,208
    8000181e:	15050913          	addi	s2,a0,336
    80001822:	02a79363          	bne	a5,a0,80001848 <exit+0x52>
    panic("init exiting");
    80001826:	00008517          	auipc	a0,0x8
    8000182a:	9ca50513          	addi	a0,a0,-1590 # 800091f0 <etext+0x1f0>
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	45e080e7          	jalr	1118(ra) # 80006c8c <panic>
      fileclose(f);
    80001836:	00002097          	auipc	ra,0x2
    8000183a:	19c080e7          	jalr	412(ra) # 800039d2 <fileclose>
      p->ofile[fd] = 0;
    8000183e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001842:	04a1                	addi	s1,s1,8
    80001844:	01248563          	beq	s1,s2,8000184e <exit+0x58>
    if(p->ofile[fd]){
    80001848:	6088                	ld	a0,0(s1)
    8000184a:	f575                	bnez	a0,80001836 <exit+0x40>
    8000184c:	bfdd                	j	80001842 <exit+0x4c>
  begin_op();
    8000184e:	00002097          	auipc	ra,0x2
    80001852:	cba080e7          	jalr	-838(ra) # 80003508 <begin_op>
  iput(p->cwd);
    80001856:	1509b503          	ld	a0,336(s3)
    8000185a:	00001097          	auipc	ra,0x1
    8000185e:	49a080e7          	jalr	1178(ra) # 80002cf4 <iput>
  end_op();
    80001862:	00002097          	auipc	ra,0x2
    80001866:	d20080e7          	jalr	-736(ra) # 80003582 <end_op>
  p->cwd = 0;
    8000186a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000186e:	0000c497          	auipc	s1,0xc
    80001872:	81a48493          	addi	s1,s1,-2022 # 8000d088 <wait_lock>
    80001876:	8526                	mv	a0,s1
    80001878:	00006097          	auipc	ra,0x6
    8000187c:	98e080e7          	jalr	-1650(ra) # 80007206 <acquire>
  reparent(p);
    80001880:	854e                	mv	a0,s3
    80001882:	00000097          	auipc	ra,0x0
    80001886:	f1a080e7          	jalr	-230(ra) # 8000179c <reparent>
  wakeup(p->parent);
    8000188a:	0389b503          	ld	a0,56(s3)
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	e98080e7          	jalr	-360(ra) # 80001726 <wakeup>
  acquire(&p->lock);
    80001896:	854e                	mv	a0,s3
    80001898:	00006097          	auipc	ra,0x6
    8000189c:	96e080e7          	jalr	-1682(ra) # 80007206 <acquire>
  p->xstate = status;
    800018a0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018a4:	4795                	li	a5,5
    800018a6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00006097          	auipc	ra,0x6
    800018b0:	a0e080e7          	jalr	-1522(ra) # 800072ba <release>
  sched();
    800018b4:	00000097          	auipc	ra,0x0
    800018b8:	bd4080e7          	jalr	-1068(ra) # 80001488 <sched>
  panic("zombie exit");
    800018bc:	00008517          	auipc	a0,0x8
    800018c0:	94450513          	addi	a0,a0,-1724 # 80009200 <etext+0x200>
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	3c8080e7          	jalr	968(ra) # 80006c8c <panic>

00000000800018cc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018cc:	7179                	addi	sp,sp,-48
    800018ce:	f406                	sd	ra,40(sp)
    800018d0:	f022                	sd	s0,32(sp)
    800018d2:	ec26                	sd	s1,24(sp)
    800018d4:	e84a                	sd	s2,16(sp)
    800018d6:	e44e                	sd	s3,8(sp)
    800018d8:	1800                	addi	s0,sp,48
    800018da:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018dc:	0000c497          	auipc	s1,0xc
    800018e0:	bc448493          	addi	s1,s1,-1084 # 8000d4a0 <proc>
    800018e4:	00011997          	auipc	s3,0x11
    800018e8:	5bc98993          	addi	s3,s3,1468 # 80012ea0 <tickslock>
    acquire(&p->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00006097          	auipc	ra,0x6
    800018f2:	918080e7          	jalr	-1768(ra) # 80007206 <acquire>
    if(p->pid == pid){
    800018f6:	589c                	lw	a5,48(s1)
    800018f8:	01278d63          	beq	a5,s2,80001912 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018fc:	8526                	mv	a0,s1
    800018fe:	00006097          	auipc	ra,0x6
    80001902:	9bc080e7          	jalr	-1604(ra) # 800072ba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001906:	16848493          	addi	s1,s1,360
    8000190a:	ff3491e3          	bne	s1,s3,800018ec <kill+0x20>
  }
  return -1;
    8000190e:	557d                	li	a0,-1
    80001910:	a829                	j	8000192a <kill+0x5e>
      p->killed = 1;
    80001912:	4785                	li	a5,1
    80001914:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001916:	4c98                	lw	a4,24(s1)
    80001918:	4789                	li	a5,2
    8000191a:	00f70f63          	beq	a4,a5,80001938 <kill+0x6c>
      release(&p->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	00006097          	auipc	ra,0x6
    80001924:	99a080e7          	jalr	-1638(ra) # 800072ba <release>
      return 0;
    80001928:	4501                	li	a0,0
}
    8000192a:	70a2                	ld	ra,40(sp)
    8000192c:	7402                	ld	s0,32(sp)
    8000192e:	64e2                	ld	s1,24(sp)
    80001930:	6942                	ld	s2,16(sp)
    80001932:	69a2                	ld	s3,8(sp)
    80001934:	6145                	addi	sp,sp,48
    80001936:	8082                	ret
        p->state = RUNNABLE;
    80001938:	478d                	li	a5,3
    8000193a:	cc9c                	sw	a5,24(s1)
    8000193c:	b7cd                	j	8000191e <kill+0x52>

000000008000193e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000193e:	7179                	addi	sp,sp,-48
    80001940:	f406                	sd	ra,40(sp)
    80001942:	f022                	sd	s0,32(sp)
    80001944:	ec26                	sd	s1,24(sp)
    80001946:	e84a                	sd	s2,16(sp)
    80001948:	e44e                	sd	s3,8(sp)
    8000194a:	e052                	sd	s4,0(sp)
    8000194c:	1800                	addi	s0,sp,48
    8000194e:	84aa                	mv	s1,a0
    80001950:	892e                	mv	s2,a1
    80001952:	89b2                	mv	s3,a2
    80001954:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	57e080e7          	jalr	1406(ra) # 80000ed4 <myproc>
  if(user_dst){
    8000195e:	c08d                	beqz	s1,80001980 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001960:	86d2                	mv	a3,s4
    80001962:	864e                	mv	a2,s3
    80001964:	85ca                	mv	a1,s2
    80001966:	6928                	ld	a0,80(a0)
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	20c080e7          	jalr	524(ra) # 80000b74 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001970:	70a2                	ld	ra,40(sp)
    80001972:	7402                	ld	s0,32(sp)
    80001974:	64e2                	ld	s1,24(sp)
    80001976:	6942                	ld	s2,16(sp)
    80001978:	69a2                	ld	s3,8(sp)
    8000197a:	6a02                	ld	s4,0(sp)
    8000197c:	6145                	addi	sp,sp,48
    8000197e:	8082                	ret
    memmove((char *)dst, src, len);
    80001980:	000a061b          	sext.w	a2,s4
    80001984:	85ce                	mv	a1,s3
    80001986:	854a                	mv	a0,s2
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	84e080e7          	jalr	-1970(ra) # 800001d6 <memmove>
    return 0;
    80001990:	8526                	mv	a0,s1
    80001992:	bff9                	j	80001970 <either_copyout+0x32>

0000000080001994 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001994:	7179                	addi	sp,sp,-48
    80001996:	f406                	sd	ra,40(sp)
    80001998:	f022                	sd	s0,32(sp)
    8000199a:	ec26                	sd	s1,24(sp)
    8000199c:	e84a                	sd	s2,16(sp)
    8000199e:	e44e                	sd	s3,8(sp)
    800019a0:	e052                	sd	s4,0(sp)
    800019a2:	1800                	addi	s0,sp,48
    800019a4:	892a                	mv	s2,a0
    800019a6:	84ae                	mv	s1,a1
    800019a8:	89b2                	mv	s3,a2
    800019aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	528080e7          	jalr	1320(ra) # 80000ed4 <myproc>
  if(user_src){
    800019b4:	c08d                	beqz	s1,800019d6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019b6:	86d2                	mv	a3,s4
    800019b8:	864e                	mv	a2,s3
    800019ba:	85ca                	mv	a1,s2
    800019bc:	6928                	ld	a0,80(a0)
    800019be:	fffff097          	auipc	ra,0xfffff
    800019c2:	242080e7          	jalr	578(ra) # 80000c00 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019c6:	70a2                	ld	ra,40(sp)
    800019c8:	7402                	ld	s0,32(sp)
    800019ca:	64e2                	ld	s1,24(sp)
    800019cc:	6942                	ld	s2,16(sp)
    800019ce:	69a2                	ld	s3,8(sp)
    800019d0:	6a02                	ld	s4,0(sp)
    800019d2:	6145                	addi	sp,sp,48
    800019d4:	8082                	ret
    memmove(dst, (char*)src, len);
    800019d6:	000a061b          	sext.w	a2,s4
    800019da:	85ce                	mv	a1,s3
    800019dc:	854a                	mv	a0,s2
    800019de:	ffffe097          	auipc	ra,0xffffe
    800019e2:	7f8080e7          	jalr	2040(ra) # 800001d6 <memmove>
    return 0;
    800019e6:	8526                	mv	a0,s1
    800019e8:	bff9                	j	800019c6 <either_copyin+0x32>

00000000800019ea <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ea:	715d                	addi	sp,sp,-80
    800019ec:	e486                	sd	ra,72(sp)
    800019ee:	e0a2                	sd	s0,64(sp)
    800019f0:	fc26                	sd	s1,56(sp)
    800019f2:	f84a                	sd	s2,48(sp)
    800019f4:	f44e                	sd	s3,40(sp)
    800019f6:	f052                	sd	s4,32(sp)
    800019f8:	ec56                	sd	s5,24(sp)
    800019fa:	e85a                	sd	s6,16(sp)
    800019fc:	e45e                	sd	s7,8(sp)
    800019fe:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a00:	00007517          	auipc	a0,0x7
    80001a04:	61850513          	addi	a0,a0,1560 # 80009018 <etext+0x18>
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	2ce080e7          	jalr	718(ra) # 80006cd6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a10:	0000c497          	auipc	s1,0xc
    80001a14:	be848493          	addi	s1,s1,-1048 # 8000d5f8 <proc+0x158>
    80001a18:	00011917          	auipc	s2,0x11
    80001a1c:	5e090913          	addi	s2,s2,1504 # 80012ff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a20:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a22:	00007997          	auipc	s3,0x7
    80001a26:	7ee98993          	addi	s3,s3,2030 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001a2a:	00007a97          	auipc	s5,0x7
    80001a2e:	7eea8a93          	addi	s5,s5,2030 # 80009218 <etext+0x218>
    printf("\n");
    80001a32:	00007a17          	auipc	s4,0x7
    80001a36:	5e6a0a13          	addi	s4,s4,1510 # 80009018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3a:	00008b97          	auipc	s7,0x8
    80001a3e:	d06b8b93          	addi	s7,s7,-762 # 80009740 <states.0>
    80001a42:	a00d                	j	80001a64 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a44:	ed86a583          	lw	a1,-296(a3)
    80001a48:	8556                	mv	a0,s5
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	28c080e7          	jalr	652(ra) # 80006cd6 <printf>
    printf("\n");
    80001a52:	8552                	mv	a0,s4
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	282080e7          	jalr	642(ra) # 80006cd6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5c:	16848493          	addi	s1,s1,360
    80001a60:	03248263          	beq	s1,s2,80001a84 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a64:	86a6                	mv	a3,s1
    80001a66:	ec04a783          	lw	a5,-320(s1)
    80001a6a:	dbed                	beqz	a5,80001a5c <procdump+0x72>
      state = "???";
    80001a6c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6e:	fcfb6be3          	bltu	s6,a5,80001a44 <procdump+0x5a>
    80001a72:	02079713          	slli	a4,a5,0x20
    80001a76:	01d75793          	srli	a5,a4,0x1d
    80001a7a:	97de                	add	a5,a5,s7
    80001a7c:	6390                	ld	a2,0(a5)
    80001a7e:	f279                	bnez	a2,80001a44 <procdump+0x5a>
      state = "???";
    80001a80:	864e                	mv	a2,s3
    80001a82:	b7c9                	j	80001a44 <procdump+0x5a>
  }
}
    80001a84:	60a6                	ld	ra,72(sp)
    80001a86:	6406                	ld	s0,64(sp)
    80001a88:	74e2                	ld	s1,56(sp)
    80001a8a:	7942                	ld	s2,48(sp)
    80001a8c:	79a2                	ld	s3,40(sp)
    80001a8e:	7a02                	ld	s4,32(sp)
    80001a90:	6ae2                	ld	s5,24(sp)
    80001a92:	6b42                	ld	s6,16(sp)
    80001a94:	6ba2                	ld	s7,8(sp)
    80001a96:	6161                	addi	sp,sp,80
    80001a98:	8082                	ret

0000000080001a9a <swtch>:
    80001a9a:	00153023          	sd	ra,0(a0)
    80001a9e:	00253423          	sd	sp,8(a0)
    80001aa2:	e900                	sd	s0,16(a0)
    80001aa4:	ed04                	sd	s1,24(a0)
    80001aa6:	03253023          	sd	s2,32(a0)
    80001aaa:	03353423          	sd	s3,40(a0)
    80001aae:	03453823          	sd	s4,48(a0)
    80001ab2:	03553c23          	sd	s5,56(a0)
    80001ab6:	05653023          	sd	s6,64(a0)
    80001aba:	05753423          	sd	s7,72(a0)
    80001abe:	05853823          	sd	s8,80(a0)
    80001ac2:	05953c23          	sd	s9,88(a0)
    80001ac6:	07a53023          	sd	s10,96(a0)
    80001aca:	07b53423          	sd	s11,104(a0)
    80001ace:	0005b083          	ld	ra,0(a1)
    80001ad2:	0085b103          	ld	sp,8(a1)
    80001ad6:	6980                	ld	s0,16(a1)
    80001ad8:	6d84                	ld	s1,24(a1)
    80001ada:	0205b903          	ld	s2,32(a1)
    80001ade:	0285b983          	ld	s3,40(a1)
    80001ae2:	0305ba03          	ld	s4,48(a1)
    80001ae6:	0385ba83          	ld	s5,56(a1)
    80001aea:	0405bb03          	ld	s6,64(a1)
    80001aee:	0485bb83          	ld	s7,72(a1)
    80001af2:	0505bc03          	ld	s8,80(a1)
    80001af6:	0585bc83          	ld	s9,88(a1)
    80001afa:	0605bd03          	ld	s10,96(a1)
    80001afe:	0685bd83          	ld	s11,104(a1)
    80001b02:	8082                	ret

0000000080001b04 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b04:	1141                	addi	sp,sp,-16
    80001b06:	e406                	sd	ra,8(sp)
    80001b08:	e022                	sd	s0,0(sp)
    80001b0a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b0c:	00007597          	auipc	a1,0x7
    80001b10:	74458593          	addi	a1,a1,1860 # 80009250 <etext+0x250>
    80001b14:	00011517          	auipc	a0,0x11
    80001b18:	38c50513          	addi	a0,a0,908 # 80012ea0 <tickslock>
    80001b1c:	00005097          	auipc	ra,0x5
    80001b20:	65a080e7          	jalr	1626(ra) # 80007176 <initlock>
}
    80001b24:	60a2                	ld	ra,8(sp)
    80001b26:	6402                	ld	s0,0(sp)
    80001b28:	0141                	addi	sp,sp,16
    80001b2a:	8082                	ret

0000000080001b2c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b2c:	1141                	addi	sp,sp,-16
    80001b2e:	e422                	sd	s0,8(sp)
    80001b30:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b32:	00003797          	auipc	a5,0x3
    80001b36:	65e78793          	addi	a5,a5,1630 # 80005190 <kernelvec>
    80001b3a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b3e:	6422                	ld	s0,8(sp)
    80001b40:	0141                	addi	sp,sp,16
    80001b42:	8082                	ret

0000000080001b44 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b44:	1141                	addi	sp,sp,-16
    80001b46:	e406                	sd	ra,8(sp)
    80001b48:	e022                	sd	s0,0(sp)
    80001b4a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	388080e7          	jalr	904(ra) # 80000ed4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b5e:	00006697          	auipc	a3,0x6
    80001b62:	4a268693          	addi	a3,a3,1186 # 80008000 <_trampoline>
    80001b66:	00006717          	auipc	a4,0x6
    80001b6a:	49a70713          	addi	a4,a4,1178 # 80008000 <_trampoline>
    80001b6e:	8f15                	sub	a4,a4,a3
    80001b70:	040007b7          	lui	a5,0x4000
    80001b74:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b76:	07b2                	slli	a5,a5,0xc
    80001b78:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b80:	18002673          	csrr	a2,satp
    80001b84:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b86:	6d30                	ld	a2,88(a0)
    80001b88:	6138                	ld	a4,64(a0)
    80001b8a:	6585                	lui	a1,0x1
    80001b8c:	972e                	add	a4,a4,a1
    80001b8e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b90:	6d38                	ld	a4,88(a0)
    80001b92:	00000617          	auipc	a2,0x0
    80001b96:	15260613          	addi	a2,a2,338 # 80001ce4 <usertrap>
    80001b9a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b9c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b9e:	8612                	mv	a2,tp
    80001ba0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ba6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001baa:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bae:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bb2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bb4:	6f18                	ld	a4,24(a4)
    80001bb6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bba:	692c                	ld	a1,80(a0)
    80001bbc:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bbe:	00006717          	auipc	a4,0x6
    80001bc2:	4d270713          	addi	a4,a4,1234 # 80008090 <userret>
    80001bc6:	8f15                	sub	a4,a4,a3
    80001bc8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bca:	577d                	li	a4,-1
    80001bcc:	177e                	slli	a4,a4,0x3f
    80001bce:	8dd9                	or	a1,a1,a4
    80001bd0:	02000537          	lui	a0,0x2000
    80001bd4:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bd6:	0536                	slli	a0,a0,0xd
    80001bd8:	9782                	jalr	a5
}
    80001bda:	60a2                	ld	ra,8(sp)
    80001bdc:	6402                	ld	s0,0(sp)
    80001bde:	0141                	addi	sp,sp,16
    80001be0:	8082                	ret

0000000080001be2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bec:	00011497          	auipc	s1,0x11
    80001bf0:	2b448493          	addi	s1,s1,692 # 80012ea0 <tickslock>
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	00005097          	auipc	ra,0x5
    80001bfa:	610080e7          	jalr	1552(ra) # 80007206 <acquire>
  ticks++;
    80001bfe:	0000b517          	auipc	a0,0xb
    80001c02:	41a50513          	addi	a0,a0,1050 # 8000d018 <ticks>
    80001c06:	411c                	lw	a5,0(a0)
    80001c08:	2785                	addiw	a5,a5,1
    80001c0a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c0c:	00000097          	auipc	ra,0x0
    80001c10:	b1a080e7          	jalr	-1254(ra) # 80001726 <wakeup>
  release(&tickslock);
    80001c14:	8526                	mv	a0,s1
    80001c16:	00005097          	auipc	ra,0x5
    80001c1a:	6a4080e7          	jalr	1700(ra) # 800072ba <release>
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret

0000000080001c28 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c28:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c2c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c2e:	0a07da63          	bgez	a5,80001ce2 <devintr+0xba>
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c3a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c3e:	46a5                	li	a3,9
    80001c40:	00d70c63          	beq	a4,a3,80001c58 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c44:	577d                	li	a4,-1
    80001c46:	177e                	slli	a4,a4,0x3f
    80001c48:	0705                	addi	a4,a4,1
    return 0;
    80001c4a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c4c:	06e78a63          	beq	a5,a4,80001cc0 <devintr+0x98>
  }
}
    80001c50:	60e2                	ld	ra,24(sp)
    80001c52:	6442                	ld	s0,16(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret
    80001c58:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c5a:	00003097          	auipc	ra,0x3
    80001c5e:	65c080e7          	jalr	1628(ra) # 800052b6 <plic_claim>
    80001c62:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c64:	47a9                	li	a5,10
    80001c66:	00f50d63          	beq	a0,a5,80001c80 <devintr+0x58>
    } else if(irq == VIRTIO0_IRQ){
    80001c6a:	4785                	li	a5,1
    80001c6c:	02f50663          	beq	a0,a5,80001c98 <devintr+0x70>
    else if(irq == E1000_IRQ){
    80001c70:	02100793          	li	a5,33
    80001c74:	02f50763          	beq	a0,a5,80001ca2 <devintr+0x7a>
    return 1;
    80001c78:	4505                	li	a0,1
    else if(irq){
    80001c7a:	e88d                	bnez	s1,80001cac <devintr+0x84>
    80001c7c:	64a2                	ld	s1,8(sp)
    80001c7e:	bfc9                	j	80001c50 <devintr+0x28>
      uartintr();
    80001c80:	00005097          	auipc	ra,0x5
    80001c84:	4a6080e7          	jalr	1190(ra) # 80007126 <uartintr>
      plic_complete(irq);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00003097          	auipc	ra,0x3
    80001c8e:	650080e7          	jalr	1616(ra) # 800052da <plic_complete>
    return 1;
    80001c92:	4505                	li	a0,1
    80001c94:	64a2                	ld	s1,8(sp)
    80001c96:	bf6d                	j	80001c50 <devintr+0x28>
      virtio_disk_intr();
    80001c98:	00004097          	auipc	ra,0x4
    80001c9c:	af2080e7          	jalr	-1294(ra) # 8000578a <virtio_disk_intr>
    if(irq)
    80001ca0:	b7e5                	j	80001c88 <devintr+0x60>
      e1000_intr();
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	e32080e7          	jalr	-462(ra) # 80005ad4 <e1000_intr>
    if(irq)
    80001caa:	bff9                	j	80001c88 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cac:	85a6                	mv	a1,s1
    80001cae:	00007517          	auipc	a0,0x7
    80001cb2:	5aa50513          	addi	a0,a0,1450 # 80009258 <etext+0x258>
    80001cb6:	00005097          	auipc	ra,0x5
    80001cba:	020080e7          	jalr	32(ra) # 80006cd6 <printf>
    if(irq)
    80001cbe:	b7e9                	j	80001c88 <devintr+0x60>
    if(cpuid() == 0){
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1e8080e7          	jalr	488(ra) # 80000ea8 <cpuid>
    80001cc8:	c901                	beqz	a0,80001cd8 <devintr+0xb0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cca:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd0:	14479073          	csrw	sip,a5
    return 2;
    80001cd4:	4509                	li	a0,2
    80001cd6:	bfad                	j	80001c50 <devintr+0x28>
      clockintr();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f0a080e7          	jalr	-246(ra) # 80001be2 <clockintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0xa2>
}
    80001ce2:	8082                	ret

0000000080001ce4 <usertrap>:
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf4:	1007f793          	andi	a5,a5,256
    80001cf8:	e3b9                	bnez	a5,80001d3e <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfa:	00003797          	auipc	a5,0x3
    80001cfe:	49678793          	addi	a5,a5,1174 # 80005190 <kernelvec>
    80001d02:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	1ce080e7          	jalr	462(ra) # 80000ed4 <myproc>
    80001d0e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d10:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d12:	14102773          	csrr	a4,sepc
    80001d16:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d18:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1c:	47a1                	li	a5,8
    80001d1e:	02f70863          	beq	a4,a5,80001d4e <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	f06080e7          	jalr	-250(ra) # 80001c28 <devintr>
    80001d2a:	892a                	mv	s2,a0
    80001d2c:	c551                	beqz	a0,80001db8 <usertrap+0xd4>
  if(lockfree_read4(&p->killed))
    80001d2e:	02848513          	addi	a0,s1,40
    80001d32:	00005097          	auipc	ra,0x5
    80001d36:	5e6080e7          	jalr	1510(ra) # 80007318 <lockfree_read4>
    80001d3a:	cd21                	beqz	a0,80001d92 <usertrap+0xae>
    80001d3c:	a0b1                	j	80001d88 <usertrap+0xa4>
    panic("usertrap: not from user mode");
    80001d3e:	00007517          	auipc	a0,0x7
    80001d42:	53a50513          	addi	a0,a0,1338 # 80009278 <etext+0x278>
    80001d46:	00005097          	auipc	ra,0x5
    80001d4a:	f46080e7          	jalr	-186(ra) # 80006c8c <panic>
    if(lockfree_read4(&p->killed))
    80001d4e:	02850513          	addi	a0,a0,40
    80001d52:	00005097          	auipc	ra,0x5
    80001d56:	5c6080e7          	jalr	1478(ra) # 80007318 <lockfree_read4>
    80001d5a:	e929                	bnez	a0,80001dac <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001d5c:	6cb8                	ld	a4,88(s1)
    80001d5e:	6f1c                	ld	a5,24(a4)
    80001d60:	0791                	addi	a5,a5,4
    80001d62:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	2c8080e7          	jalr	712(ra) # 80002038 <syscall>
  if(lockfree_read4(&p->killed))
    80001d78:	02848513          	addi	a0,s1,40
    80001d7c:	00005097          	auipc	ra,0x5
    80001d80:	59c080e7          	jalr	1436(ra) # 80007318 <lockfree_read4>
    80001d84:	c911                	beqz	a0,80001d98 <usertrap+0xb4>
    80001d86:	4901                	li	s2,0
    exit(-1);
    80001d88:	557d                	li	a0,-1
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	a6c080e7          	jalr	-1428(ra) # 800017f6 <exit>
  if(which_dev == 2)
    80001d92:	4789                	li	a5,2
    80001d94:	04f90c63          	beq	s2,a5,80001dec <usertrap+0x108>
  usertrapret();
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	dac080e7          	jalr	-596(ra) # 80001b44 <usertrapret>
}
    80001da0:	60e2                	ld	ra,24(sp)
    80001da2:	6442                	ld	s0,16(sp)
    80001da4:	64a2                	ld	s1,8(sp)
    80001da6:	6902                	ld	s2,0(sp)
    80001da8:	6105                	addi	sp,sp,32
    80001daa:	8082                	ret
      exit(-1);
    80001dac:	557d                	li	a0,-1
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	a48080e7          	jalr	-1464(ra) # 800017f6 <exit>
    80001db6:	b75d                	j	80001d5c <usertrap+0x78>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dbc:	5890                	lw	a2,48(s1)
    80001dbe:	00007517          	auipc	a0,0x7
    80001dc2:	4da50513          	addi	a0,a0,1242 # 80009298 <etext+0x298>
    80001dc6:	00005097          	auipc	ra,0x5
    80001dca:	f10080e7          	jalr	-240(ra) # 80006cd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dce:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dd2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dd6:	00007517          	auipc	a0,0x7
    80001dda:	4f250513          	addi	a0,a0,1266 # 800092c8 <etext+0x2c8>
    80001dde:	00005097          	auipc	ra,0x5
    80001de2:	ef8080e7          	jalr	-264(ra) # 80006cd6 <printf>
    p->killed = 1;
    80001de6:	4785                	li	a5,1
    80001de8:	d49c                	sw	a5,40(s1)
    80001dea:	b779                	j	80001d78 <usertrap+0x94>
    yield();
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	772080e7          	jalr	1906(ra) # 8000155e <yield>
    80001df4:	b755                	j	80001d98 <usertrap+0xb4>

0000000080001df6 <kerneltrap>:
{
    80001df6:	7179                	addi	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	e84a                	sd	s2,16(sp)
    80001e00:	e44e                	sd	s3,8(sp)
    80001e02:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e10:	1004f793          	andi	a5,s1,256
    80001e14:	cb85                	beqz	a5,80001e44 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e1a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e1c:	ef85                	bnez	a5,80001e54 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	e0a080e7          	jalr	-502(ra) # 80001c28 <devintr>
    80001e26:	cd1d                	beqz	a0,80001e64 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e28:	4789                	li	a5,2
    80001e2a:	06f50a63          	beq	a0,a5,80001e9e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e32:	10049073          	csrw	sstatus,s1
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6145                	addi	sp,sp,48
    80001e42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e44:	00007517          	auipc	a0,0x7
    80001e48:	4a450513          	addi	a0,a0,1188 # 800092e8 <etext+0x2e8>
    80001e4c:	00005097          	auipc	ra,0x5
    80001e50:	e40080e7          	jalr	-448(ra) # 80006c8c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e54:	00007517          	auipc	a0,0x7
    80001e58:	4bc50513          	addi	a0,a0,1212 # 80009310 <etext+0x310>
    80001e5c:	00005097          	auipc	ra,0x5
    80001e60:	e30080e7          	jalr	-464(ra) # 80006c8c <panic>
    printf("scause %p\n", scause);
    80001e64:	85ce                	mv	a1,s3
    80001e66:	00007517          	auipc	a0,0x7
    80001e6a:	4ca50513          	addi	a0,a0,1226 # 80009330 <etext+0x330>
    80001e6e:	00005097          	auipc	ra,0x5
    80001e72:	e68080e7          	jalr	-408(ra) # 80006cd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e76:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e7a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e7e:	00007517          	auipc	a0,0x7
    80001e82:	4c250513          	addi	a0,a0,1218 # 80009340 <etext+0x340>
    80001e86:	00005097          	auipc	ra,0x5
    80001e8a:	e50080e7          	jalr	-432(ra) # 80006cd6 <printf>
    panic("kerneltrap");
    80001e8e:	00007517          	auipc	a0,0x7
    80001e92:	4ca50513          	addi	a0,a0,1226 # 80009358 <etext+0x358>
    80001e96:	00005097          	auipc	ra,0x5
    80001e9a:	df6080e7          	jalr	-522(ra) # 80006c8c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	036080e7          	jalr	54(ra) # 80000ed4 <myproc>
    80001ea6:	d541                	beqz	a0,80001e2e <kerneltrap+0x38>
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	02c080e7          	jalr	44(ra) # 80000ed4 <myproc>
    80001eb0:	4d18                	lw	a4,24(a0)
    80001eb2:	4791                	li	a5,4
    80001eb4:	f6f71de3          	bne	a4,a5,80001e2e <kerneltrap+0x38>
    yield();
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	6a6080e7          	jalr	1702(ra) # 8000155e <yield>
    80001ec0:	b7bd                	j	80001e2e <kerneltrap+0x38>

0000000080001ec2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ec2:	1101                	addi	sp,sp,-32
    80001ec4:	ec06                	sd	ra,24(sp)
    80001ec6:	e822                	sd	s0,16(sp)
    80001ec8:	e426                	sd	s1,8(sp)
    80001eca:	1000                	addi	s0,sp,32
    80001ecc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	006080e7          	jalr	6(ra) # 80000ed4 <myproc>
  switch (n) {
    80001ed6:	4795                	li	a5,5
    80001ed8:	0497e163          	bltu	a5,s1,80001f1a <argraw+0x58>
    80001edc:	048a                	slli	s1,s1,0x2
    80001ede:	00008717          	auipc	a4,0x8
    80001ee2:	89270713          	addi	a4,a4,-1902 # 80009770 <states.0+0x30>
    80001ee6:	94ba                	add	s1,s1,a4
    80001ee8:	409c                	lw	a5,0(s1)
    80001eea:	97ba                	add	a5,a5,a4
    80001eec:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eee:	6d3c                	ld	a5,88(a0)
    80001ef0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ef2:	60e2                	ld	ra,24(sp)
    80001ef4:	6442                	ld	s0,16(sp)
    80001ef6:	64a2                	ld	s1,8(sp)
    80001ef8:	6105                	addi	sp,sp,32
    80001efa:	8082                	ret
    return p->trapframe->a1;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	7fa8                	ld	a0,120(a5)
    80001f00:	bfcd                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a2;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	63c8                	ld	a0,128(a5)
    80001f06:	b7f5                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a3;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	67c8                	ld	a0,136(a5)
    80001f0c:	b7dd                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a4;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	6bc8                	ld	a0,144(a5)
    80001f12:	b7c5                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a5;
    80001f14:	6d3c                	ld	a5,88(a0)
    80001f16:	6fc8                	ld	a0,152(a5)
    80001f18:	bfe9                	j	80001ef2 <argraw+0x30>
  panic("argraw");
    80001f1a:	00007517          	auipc	a0,0x7
    80001f1e:	44e50513          	addi	a0,a0,1102 # 80009368 <etext+0x368>
    80001f22:	00005097          	auipc	ra,0x5
    80001f26:	d6a080e7          	jalr	-662(ra) # 80006c8c <panic>

0000000080001f2a <fetchaddr>:
{
    80001f2a:	1101                	addi	sp,sp,-32
    80001f2c:	ec06                	sd	ra,24(sp)
    80001f2e:	e822                	sd	s0,16(sp)
    80001f30:	e426                	sd	s1,8(sp)
    80001f32:	e04a                	sd	s2,0(sp)
    80001f34:	1000                	addi	s0,sp,32
    80001f36:	84aa                	mv	s1,a0
    80001f38:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	f9a080e7          	jalr	-102(ra) # 80000ed4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f42:	653c                	ld	a5,72(a0)
    80001f44:	02f4f863          	bgeu	s1,a5,80001f74 <fetchaddr+0x4a>
    80001f48:	00848713          	addi	a4,s1,8
    80001f4c:	02e7e663          	bltu	a5,a4,80001f78 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f50:	46a1                	li	a3,8
    80001f52:	8626                	mv	a2,s1
    80001f54:	85ca                	mv	a1,s2
    80001f56:	6928                	ld	a0,80(a0)
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	ca8080e7          	jalr	-856(ra) # 80000c00 <copyin>
    80001f60:	00a03533          	snez	a0,a0
    80001f64:	40a00533          	neg	a0,a0
}
    80001f68:	60e2                	ld	ra,24(sp)
    80001f6a:	6442                	ld	s0,16(sp)
    80001f6c:	64a2                	ld	s1,8(sp)
    80001f6e:	6902                	ld	s2,0(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret
    return -1;
    80001f74:	557d                	li	a0,-1
    80001f76:	bfcd                	j	80001f68 <fetchaddr+0x3e>
    80001f78:	557d                	li	a0,-1
    80001f7a:	b7fd                	j	80001f68 <fetchaddr+0x3e>

0000000080001f7c <fetchstr>:
{
    80001f7c:	7179                	addi	sp,sp,-48
    80001f7e:	f406                	sd	ra,40(sp)
    80001f80:	f022                	sd	s0,32(sp)
    80001f82:	ec26                	sd	s1,24(sp)
    80001f84:	e84a                	sd	s2,16(sp)
    80001f86:	e44e                	sd	s3,8(sp)
    80001f88:	1800                	addi	s0,sp,48
    80001f8a:	892a                	mv	s2,a0
    80001f8c:	84ae                	mv	s1,a1
    80001f8e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	f44080e7          	jalr	-188(ra) # 80000ed4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f98:	86ce                	mv	a3,s3
    80001f9a:	864a                	mv	a2,s2
    80001f9c:	85a6                	mv	a1,s1
    80001f9e:	6928                	ld	a0,80(a0)
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	cee080e7          	jalr	-786(ra) # 80000c8e <copyinstr>
  if(err < 0)
    80001fa8:	00054763          	bltz	a0,80001fb6 <fetchstr+0x3a>
  return strlen(buf);
    80001fac:	8526                	mv	a0,s1
    80001fae:	ffffe097          	auipc	ra,0xffffe
    80001fb2:	340080e7          	jalr	832(ra) # 800002ee <strlen>
}
    80001fb6:	70a2                	ld	ra,40(sp)
    80001fb8:	7402                	ld	s0,32(sp)
    80001fba:	64e2                	ld	s1,24(sp)
    80001fbc:	6942                	ld	s2,16(sp)
    80001fbe:	69a2                	ld	s3,8(sp)
    80001fc0:	6145                	addi	sp,sp,48
    80001fc2:	8082                	ret

0000000080001fc4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fc4:	1101                	addi	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	e426                	sd	s1,8(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	ef2080e7          	jalr	-270(ra) # 80001ec2 <argraw>
    80001fd8:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fda:	4501                	li	a0,0
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	1000                	addi	s0,sp,32
    80001ff0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff2:	00000097          	auipc	ra,0x0
    80001ff6:	ed0080e7          	jalr	-304(ra) # 80001ec2 <argraw>
    80001ffa:	e088                	sd	a0,0(s1)
  return 0;
}
    80001ffc:	4501                	li	a0,0
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	64a2                	ld	s1,8(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002008:	1101                	addi	sp,sp,-32
    8000200a:	ec06                	sd	ra,24(sp)
    8000200c:	e822                	sd	s0,16(sp)
    8000200e:	e426                	sd	s1,8(sp)
    80002010:	e04a                	sd	s2,0(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84ae                	mv	s1,a1
    80002016:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	eaa080e7          	jalr	-342(ra) # 80001ec2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002020:	864a                	mv	a2,s2
    80002022:	85a6                	mv	a1,s1
    80002024:	00000097          	auipc	ra,0x0
    80002028:	f58080e7          	jalr	-168(ra) # 80001f7c <fetchstr>
}
    8000202c:	60e2                	ld	ra,24(sp)
    8000202e:	6442                	ld	s0,16(sp)
    80002030:	64a2                	ld	s1,8(sp)
    80002032:	6902                	ld	s2,0(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <syscall>:



void
syscall(void)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	e04a                	sd	s2,0(sp)
    80002042:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	e90080e7          	jalr	-368(ra) # 80000ed4 <myproc>
    8000204c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000204e:	05853903          	ld	s2,88(a0)
    80002052:	0a893783          	ld	a5,168(s2)
    80002056:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000205a:	37fd                	addiw	a5,a5,-1
    8000205c:	4771                	li	a4,28
    8000205e:	00f76f63          	bltu	a4,a5,8000207c <syscall+0x44>
    80002062:	00369713          	slli	a4,a3,0x3
    80002066:	00007797          	auipc	a5,0x7
    8000206a:	72278793          	addi	a5,a5,1826 # 80009788 <syscalls>
    8000206e:	97ba                	add	a5,a5,a4
    80002070:	639c                	ld	a5,0(a5)
    80002072:	c789                	beqz	a5,8000207c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002074:	9782                	jalr	a5
    80002076:	06a93823          	sd	a0,112(s2)
    8000207a:	a839                	j	80002098 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000207c:	15848613          	addi	a2,s1,344
    80002080:	588c                	lw	a1,48(s1)
    80002082:	00007517          	auipc	a0,0x7
    80002086:	2ee50513          	addi	a0,a0,750 # 80009370 <etext+0x370>
    8000208a:	00005097          	auipc	ra,0x5
    8000208e:	c4c080e7          	jalr	-948(ra) # 80006cd6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002092:	6cbc                	ld	a5,88(s1)
    80002094:	577d                	li	a4,-1
    80002096:	fbb8                	sd	a4,112(a5)
  }
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6902                	ld	s2,0(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020a4:	1101                	addi	sp,sp,-32
    800020a6:	ec06                	sd	ra,24(sp)
    800020a8:	e822                	sd	s0,16(sp)
    800020aa:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ac:	fec40593          	addi	a1,s0,-20
    800020b0:	4501                	li	a0,0
    800020b2:	00000097          	auipc	ra,0x0
    800020b6:	f12080e7          	jalr	-238(ra) # 80001fc4 <argint>
    return -1;
    800020ba:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020bc:	00054963          	bltz	a0,800020ce <sys_exit+0x2a>
  exit(n);
    800020c0:	fec42503          	lw	a0,-20(s0)
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	732080e7          	jalr	1842(ra) # 800017f6 <exit>
  return 0;  // not reached
    800020cc:	4781                	li	a5,0
}
    800020ce:	853e                	mv	a0,a5
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d8:	1141                	addi	sp,sp,-16
    800020da:	e406                	sd	ra,8(sp)
    800020dc:	e022                	sd	s0,0(sp)
    800020de:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	df4080e7          	jalr	-524(ra) # 80000ed4 <myproc>
}
    800020e8:	5908                	lw	a0,48(a0)
    800020ea:	60a2                	ld	ra,8(sp)
    800020ec:	6402                	ld	s0,0(sp)
    800020ee:	0141                	addi	sp,sp,16
    800020f0:	8082                	ret

00000000800020f2 <sys_fork>:

uint64
sys_fork(void)
{
    800020f2:	1141                	addi	sp,sp,-16
    800020f4:	e406                	sd	ra,8(sp)
    800020f6:	e022                	sd	s0,0(sp)
    800020f8:	0800                	addi	s0,sp,16
  return fork();
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	1ac080e7          	jalr	428(ra) # 800012a6 <fork>
}
    80002102:	60a2                	ld	ra,8(sp)
    80002104:	6402                	ld	s0,0(sp)
    80002106:	0141                	addi	sp,sp,16
    80002108:	8082                	ret

000000008000210a <sys_wait>:

uint64
sys_wait(void)
{
    8000210a:	1101                	addi	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002112:	fe840593          	addi	a1,s0,-24
    80002116:	4501                	li	a0,0
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	ece080e7          	jalr	-306(ra) # 80001fe6 <argaddr>
    80002120:	87aa                	mv	a5,a0
    return -1;
    80002122:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002124:	0007c863          	bltz	a5,80002134 <sys_wait+0x2a>
  return wait(p);
    80002128:	fe843503          	ld	a0,-24(s0)
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	4d2080e7          	jalr	1234(ra) # 800015fe <wait>
}
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000213c:	7179                	addi	sp,sp,-48
    8000213e:	f406                	sd	ra,40(sp)
    80002140:	f022                	sd	s0,32(sp)
    80002142:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002144:	fdc40593          	addi	a1,s0,-36
    80002148:	4501                	li	a0,0
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	e7a080e7          	jalr	-390(ra) # 80001fc4 <argint>
    80002152:	87aa                	mv	a5,a0
    return -1;
    80002154:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002156:	0207c263          	bltz	a5,8000217a <sys_sbrk+0x3e>
    8000215a:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	d78080e7          	jalr	-648(ra) # 80000ed4 <myproc>
    80002164:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002166:	fdc42503          	lw	a0,-36(s0)
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	0c4080e7          	jalr	196(ra) # 8000122e <growproc>
    80002172:	00054863          	bltz	a0,80002182 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002176:	8526                	mv	a0,s1
    80002178:	64e2                	ld	s1,24(sp)
}
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	6145                	addi	sp,sp,48
    80002180:	8082                	ret
    return -1;
    80002182:	557d                	li	a0,-1
    80002184:	64e2                	ld	s1,24(sp)
    80002186:	bfd5                	j	8000217a <sys_sbrk+0x3e>

0000000080002188 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002188:	7139                	addi	sp,sp,-64
    8000218a:	fc06                	sd	ra,56(sp)
    8000218c:	f822                	sd	s0,48(sp)
    8000218e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002190:	fcc40593          	addi	a1,s0,-52
    80002194:	4501                	li	a0,0
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	e2e080e7          	jalr	-466(ra) # 80001fc4 <argint>
    return -1;
    8000219e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021a0:	06054b63          	bltz	a0,80002216 <sys_sleep+0x8e>
    800021a4:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800021a6:	00011517          	auipc	a0,0x11
    800021aa:	cfa50513          	addi	a0,a0,-774 # 80012ea0 <tickslock>
    800021ae:	00005097          	auipc	ra,0x5
    800021b2:	058080e7          	jalr	88(ra) # 80007206 <acquire>
  ticks0 = ticks;
    800021b6:	0000b917          	auipc	s2,0xb
    800021ba:	e6292903          	lw	s2,-414(s2) # 8000d018 <ticks>
  while(ticks - ticks0 < n){
    800021be:	fcc42783          	lw	a5,-52(s0)
    800021c2:	c3a1                	beqz	a5,80002202 <sys_sleep+0x7a>
    800021c4:	f426                	sd	s1,40(sp)
    800021c6:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021c8:	00011997          	auipc	s3,0x11
    800021cc:	cd898993          	addi	s3,s3,-808 # 80012ea0 <tickslock>
    800021d0:	0000b497          	auipc	s1,0xb
    800021d4:	e4848493          	addi	s1,s1,-440 # 8000d018 <ticks>
    if(myproc()->killed){
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	cfc080e7          	jalr	-772(ra) # 80000ed4 <myproc>
    800021e0:	551c                	lw	a5,40(a0)
    800021e2:	ef9d                	bnez	a5,80002220 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021e4:	85ce                	mv	a1,s3
    800021e6:	8526                	mv	a0,s1
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	3b2080e7          	jalr	946(ra) # 8000159a <sleep>
  while(ticks - ticks0 < n){
    800021f0:	409c                	lw	a5,0(s1)
    800021f2:	412787bb          	subw	a5,a5,s2
    800021f6:	fcc42703          	lw	a4,-52(s0)
    800021fa:	fce7efe3          	bltu	a5,a4,800021d8 <sys_sleep+0x50>
    800021fe:	74a2                	ld	s1,40(sp)
    80002200:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002202:	00011517          	auipc	a0,0x11
    80002206:	c9e50513          	addi	a0,a0,-866 # 80012ea0 <tickslock>
    8000220a:	00005097          	auipc	ra,0x5
    8000220e:	0b0080e7          	jalr	176(ra) # 800072ba <release>
  return 0;
    80002212:	4781                	li	a5,0
    80002214:	7902                	ld	s2,32(sp)
}
    80002216:	853e                	mv	a0,a5
    80002218:	70e2                	ld	ra,56(sp)
    8000221a:	7442                	ld	s0,48(sp)
    8000221c:	6121                	addi	sp,sp,64
    8000221e:	8082                	ret
      release(&tickslock);
    80002220:	00011517          	auipc	a0,0x11
    80002224:	c8050513          	addi	a0,a0,-896 # 80012ea0 <tickslock>
    80002228:	00005097          	auipc	ra,0x5
    8000222c:	092080e7          	jalr	146(ra) # 800072ba <release>
      return -1;
    80002230:	57fd                	li	a5,-1
    80002232:	74a2                	ld	s1,40(sp)
    80002234:	7902                	ld	s2,32(sp)
    80002236:	69e2                	ld	s3,24(sp)
    80002238:	bff9                	j	80002216 <sys_sleep+0x8e>

000000008000223a <sys_kill>:

uint64
sys_kill(void)
{
    8000223a:	1101                	addi	sp,sp,-32
    8000223c:	ec06                	sd	ra,24(sp)
    8000223e:	e822                	sd	s0,16(sp)
    80002240:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002242:	fec40593          	addi	a1,s0,-20
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	d7c080e7          	jalr	-644(ra) # 80001fc4 <argint>
    80002250:	87aa                	mv	a5,a0
    return -1;
    80002252:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002254:	0007c863          	bltz	a5,80002264 <sys_kill+0x2a>
  return kill(pid);
    80002258:	fec42503          	lw	a0,-20(s0)
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	670080e7          	jalr	1648(ra) # 800018cc <kill>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	6105                	addi	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000226c:	1101                	addi	sp,sp,-32
    8000226e:	ec06                	sd	ra,24(sp)
    80002270:	e822                	sd	s0,16(sp)
    80002272:	e426                	sd	s1,8(sp)
    80002274:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002276:	00011517          	auipc	a0,0x11
    8000227a:	c2a50513          	addi	a0,a0,-982 # 80012ea0 <tickslock>
    8000227e:	00005097          	auipc	ra,0x5
    80002282:	f88080e7          	jalr	-120(ra) # 80007206 <acquire>
  xticks = ticks;
    80002286:	0000b497          	auipc	s1,0xb
    8000228a:	d924a483          	lw	s1,-622(s1) # 8000d018 <ticks>
  release(&tickslock);
    8000228e:	00011517          	auipc	a0,0x11
    80002292:	c1250513          	addi	a0,a0,-1006 # 80012ea0 <tickslock>
    80002296:	00005097          	auipc	ra,0x5
    8000229a:	024080e7          	jalr	36(ra) # 800072ba <release>
  return xticks;
}
    8000229e:	02049513          	slli	a0,s1,0x20
    800022a2:	9101                	srli	a0,a0,0x20
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	64a2                	ld	s1,8(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	e44e                	sd	s3,8(sp)
    800022ba:	e052                	sd	s4,0(sp)
    800022bc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022be:	00007597          	auipc	a1,0x7
    800022c2:	0d258593          	addi	a1,a1,210 # 80009390 <etext+0x390>
    800022c6:	00011517          	auipc	a0,0x11
    800022ca:	bf250513          	addi	a0,a0,-1038 # 80012eb8 <bcache>
    800022ce:	00005097          	auipc	ra,0x5
    800022d2:	ea8080e7          	jalr	-344(ra) # 80007176 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022d6:	00019797          	auipc	a5,0x19
    800022da:	be278793          	addi	a5,a5,-1054 # 8001aeb8 <bcache+0x8000>
    800022de:	00019717          	auipc	a4,0x19
    800022e2:	e4270713          	addi	a4,a4,-446 # 8001b120 <bcache+0x8268>
    800022e6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022ea:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ee:	00011497          	auipc	s1,0x11
    800022f2:	be248493          	addi	s1,s1,-1054 # 80012ed0 <bcache+0x18>
    b->next = bcache.head.next;
    800022f6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022f8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022fa:	00007a17          	auipc	s4,0x7
    800022fe:	09ea0a13          	addi	s4,s4,158 # 80009398 <etext+0x398>
    b->next = bcache.head.next;
    80002302:	2b893783          	ld	a5,696(s2)
    80002306:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002308:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000230c:	85d2                	mv	a1,s4
    8000230e:	01048513          	addi	a0,s1,16
    80002312:	00001097          	auipc	ra,0x1
    80002316:	4b2080e7          	jalr	1202(ra) # 800037c4 <initsleeplock>
    bcache.head.next->prev = b;
    8000231a:	2b893783          	ld	a5,696(s2)
    8000231e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002320:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002324:	45848493          	addi	s1,s1,1112
    80002328:	fd349de3          	bne	s1,s3,80002302 <binit+0x54>
  }
}
    8000232c:	70a2                	ld	ra,40(sp)
    8000232e:	7402                	ld	s0,32(sp)
    80002330:	64e2                	ld	s1,24(sp)
    80002332:	6942                	ld	s2,16(sp)
    80002334:	69a2                	ld	s3,8(sp)
    80002336:	6a02                	ld	s4,0(sp)
    80002338:	6145                	addi	sp,sp,48
    8000233a:	8082                	ret

000000008000233c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000233c:	7179                	addi	sp,sp,-48
    8000233e:	f406                	sd	ra,40(sp)
    80002340:	f022                	sd	s0,32(sp)
    80002342:	ec26                	sd	s1,24(sp)
    80002344:	e84a                	sd	s2,16(sp)
    80002346:	e44e                	sd	s3,8(sp)
    80002348:	1800                	addi	s0,sp,48
    8000234a:	892a                	mv	s2,a0
    8000234c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000234e:	00011517          	auipc	a0,0x11
    80002352:	b6a50513          	addi	a0,a0,-1174 # 80012eb8 <bcache>
    80002356:	00005097          	auipc	ra,0x5
    8000235a:	eb0080e7          	jalr	-336(ra) # 80007206 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000235e:	00019497          	auipc	s1,0x19
    80002362:	e124b483          	ld	s1,-494(s1) # 8001b170 <bcache+0x82b8>
    80002366:	00019797          	auipc	a5,0x19
    8000236a:	dba78793          	addi	a5,a5,-582 # 8001b120 <bcache+0x8268>
    8000236e:	02f48f63          	beq	s1,a5,800023ac <bread+0x70>
    80002372:	873e                	mv	a4,a5
    80002374:	a021                	j	8000237c <bread+0x40>
    80002376:	68a4                	ld	s1,80(s1)
    80002378:	02e48a63          	beq	s1,a4,800023ac <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000237c:	449c                	lw	a5,8(s1)
    8000237e:	ff279ce3          	bne	a5,s2,80002376 <bread+0x3a>
    80002382:	44dc                	lw	a5,12(s1)
    80002384:	ff3799e3          	bne	a5,s3,80002376 <bread+0x3a>
      b->refcnt++;
    80002388:	40bc                	lw	a5,64(s1)
    8000238a:	2785                	addiw	a5,a5,1
    8000238c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000238e:	00011517          	auipc	a0,0x11
    80002392:	b2a50513          	addi	a0,a0,-1238 # 80012eb8 <bcache>
    80002396:	00005097          	auipc	ra,0x5
    8000239a:	f24080e7          	jalr	-220(ra) # 800072ba <release>
      acquiresleep(&b->lock);
    8000239e:	01048513          	addi	a0,s1,16
    800023a2:	00001097          	auipc	ra,0x1
    800023a6:	45c080e7          	jalr	1116(ra) # 800037fe <acquiresleep>
      return b;
    800023aa:	a8b9                	j	80002408 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023ac:	00019497          	auipc	s1,0x19
    800023b0:	dbc4b483          	ld	s1,-580(s1) # 8001b168 <bcache+0x82b0>
    800023b4:	00019797          	auipc	a5,0x19
    800023b8:	d6c78793          	addi	a5,a5,-660 # 8001b120 <bcache+0x8268>
    800023bc:	00f48863          	beq	s1,a5,800023cc <bread+0x90>
    800023c0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023c2:	40bc                	lw	a5,64(s1)
    800023c4:	cf81                	beqz	a5,800023dc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c6:	64a4                	ld	s1,72(s1)
    800023c8:	fee49de3          	bne	s1,a4,800023c2 <bread+0x86>
  panic("bget: no buffers");
    800023cc:	00007517          	auipc	a0,0x7
    800023d0:	fd450513          	addi	a0,a0,-44 # 800093a0 <etext+0x3a0>
    800023d4:	00005097          	auipc	ra,0x5
    800023d8:	8b8080e7          	jalr	-1864(ra) # 80006c8c <panic>
      b->dev = dev;
    800023dc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023e0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023e4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023e8:	4785                	li	a5,1
    800023ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ec:	00011517          	auipc	a0,0x11
    800023f0:	acc50513          	addi	a0,a0,-1332 # 80012eb8 <bcache>
    800023f4:	00005097          	auipc	ra,0x5
    800023f8:	ec6080e7          	jalr	-314(ra) # 800072ba <release>
      acquiresleep(&b->lock);
    800023fc:	01048513          	addi	a0,s1,16
    80002400:	00001097          	auipc	ra,0x1
    80002404:	3fe080e7          	jalr	1022(ra) # 800037fe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002408:	409c                	lw	a5,0(s1)
    8000240a:	cb89                	beqz	a5,8000241c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000240c:	8526                	mv	a0,s1
    8000240e:	70a2                	ld	ra,40(sp)
    80002410:	7402                	ld	s0,32(sp)
    80002412:	64e2                	ld	s1,24(sp)
    80002414:	6942                	ld	s2,16(sp)
    80002416:	69a2                	ld	s3,8(sp)
    80002418:	6145                	addi	sp,sp,48
    8000241a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000241c:	4581                	li	a1,0
    8000241e:	8526                	mv	a0,s1
    80002420:	00003097          	auipc	ra,0x3
    80002424:	0dc080e7          	jalr	220(ra) # 800054fc <virtio_disk_rw>
    b->valid = 1;
    80002428:	4785                	li	a5,1
    8000242a:	c09c                	sw	a5,0(s1)
  return b;
    8000242c:	b7c5                	j	8000240c <bread+0xd0>

000000008000242e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000242e:	1101                	addi	sp,sp,-32
    80002430:	ec06                	sd	ra,24(sp)
    80002432:	e822                	sd	s0,16(sp)
    80002434:	e426                	sd	s1,8(sp)
    80002436:	1000                	addi	s0,sp,32
    80002438:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000243a:	0541                	addi	a0,a0,16
    8000243c:	00001097          	auipc	ra,0x1
    80002440:	45c080e7          	jalr	1116(ra) # 80003898 <holdingsleep>
    80002444:	cd01                	beqz	a0,8000245c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002446:	4585                	li	a1,1
    80002448:	8526                	mv	a0,s1
    8000244a:	00003097          	auipc	ra,0x3
    8000244e:	0b2080e7          	jalr	178(ra) # 800054fc <virtio_disk_rw>
}
    80002452:	60e2                	ld	ra,24(sp)
    80002454:	6442                	ld	s0,16(sp)
    80002456:	64a2                	ld	s1,8(sp)
    80002458:	6105                	addi	sp,sp,32
    8000245a:	8082                	ret
    panic("bwrite");
    8000245c:	00007517          	auipc	a0,0x7
    80002460:	f5c50513          	addi	a0,a0,-164 # 800093b8 <etext+0x3b8>
    80002464:	00005097          	auipc	ra,0x5
    80002468:	828080e7          	jalr	-2008(ra) # 80006c8c <panic>

000000008000246c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000246c:	1101                	addi	sp,sp,-32
    8000246e:	ec06                	sd	ra,24(sp)
    80002470:	e822                	sd	s0,16(sp)
    80002472:	e426                	sd	s1,8(sp)
    80002474:	e04a                	sd	s2,0(sp)
    80002476:	1000                	addi	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000247a:	01050913          	addi	s2,a0,16
    8000247e:	854a                	mv	a0,s2
    80002480:	00001097          	auipc	ra,0x1
    80002484:	418080e7          	jalr	1048(ra) # 80003898 <holdingsleep>
    80002488:	c925                	beqz	a0,800024f8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000248a:	854a                	mv	a0,s2
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	3c8080e7          	jalr	968(ra) # 80003854 <releasesleep>

  acquire(&bcache.lock);
    80002494:	00011517          	auipc	a0,0x11
    80002498:	a2450513          	addi	a0,a0,-1500 # 80012eb8 <bcache>
    8000249c:	00005097          	auipc	ra,0x5
    800024a0:	d6a080e7          	jalr	-662(ra) # 80007206 <acquire>
  b->refcnt--;
    800024a4:	40bc                	lw	a5,64(s1)
    800024a6:	37fd                	addiw	a5,a5,-1
    800024a8:	0007871b          	sext.w	a4,a5
    800024ac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024ae:	e71d                	bnez	a4,800024dc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024b0:	68b8                	ld	a4,80(s1)
    800024b2:	64bc                	ld	a5,72(s1)
    800024b4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024b6:	68b8                	ld	a4,80(s1)
    800024b8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024ba:	00019797          	auipc	a5,0x19
    800024be:	9fe78793          	addi	a5,a5,-1538 # 8001aeb8 <bcache+0x8000>
    800024c2:	2b87b703          	ld	a4,696(a5)
    800024c6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024c8:	00019717          	auipc	a4,0x19
    800024cc:	c5870713          	addi	a4,a4,-936 # 8001b120 <bcache+0x8268>
    800024d0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024d2:	2b87b703          	ld	a4,696(a5)
    800024d6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024d8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024dc:	00011517          	auipc	a0,0x11
    800024e0:	9dc50513          	addi	a0,a0,-1572 # 80012eb8 <bcache>
    800024e4:	00005097          	auipc	ra,0x5
    800024e8:	dd6080e7          	jalr	-554(ra) # 800072ba <release>
}
    800024ec:	60e2                	ld	ra,24(sp)
    800024ee:	6442                	ld	s0,16(sp)
    800024f0:	64a2                	ld	s1,8(sp)
    800024f2:	6902                	ld	s2,0(sp)
    800024f4:	6105                	addi	sp,sp,32
    800024f6:	8082                	ret
    panic("brelse");
    800024f8:	00007517          	auipc	a0,0x7
    800024fc:	ec850513          	addi	a0,a0,-312 # 800093c0 <etext+0x3c0>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	78c080e7          	jalr	1932(ra) # 80006c8c <panic>

0000000080002508 <bpin>:

void
bpin(struct buf *b) {
    80002508:	1101                	addi	sp,sp,-32
    8000250a:	ec06                	sd	ra,24(sp)
    8000250c:	e822                	sd	s0,16(sp)
    8000250e:	e426                	sd	s1,8(sp)
    80002510:	1000                	addi	s0,sp,32
    80002512:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002514:	00011517          	auipc	a0,0x11
    80002518:	9a450513          	addi	a0,a0,-1628 # 80012eb8 <bcache>
    8000251c:	00005097          	auipc	ra,0x5
    80002520:	cea080e7          	jalr	-790(ra) # 80007206 <acquire>
  b->refcnt++;
    80002524:	40bc                	lw	a5,64(s1)
    80002526:	2785                	addiw	a5,a5,1
    80002528:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000252a:	00011517          	auipc	a0,0x11
    8000252e:	98e50513          	addi	a0,a0,-1650 # 80012eb8 <bcache>
    80002532:	00005097          	auipc	ra,0x5
    80002536:	d88080e7          	jalr	-632(ra) # 800072ba <release>
}
    8000253a:	60e2                	ld	ra,24(sp)
    8000253c:	6442                	ld	s0,16(sp)
    8000253e:	64a2                	ld	s1,8(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret

0000000080002544 <bunpin>:

void
bunpin(struct buf *b) {
    80002544:	1101                	addi	sp,sp,-32
    80002546:	ec06                	sd	ra,24(sp)
    80002548:	e822                	sd	s0,16(sp)
    8000254a:	e426                	sd	s1,8(sp)
    8000254c:	1000                	addi	s0,sp,32
    8000254e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002550:	00011517          	auipc	a0,0x11
    80002554:	96850513          	addi	a0,a0,-1688 # 80012eb8 <bcache>
    80002558:	00005097          	auipc	ra,0x5
    8000255c:	cae080e7          	jalr	-850(ra) # 80007206 <acquire>
  b->refcnt--;
    80002560:	40bc                	lw	a5,64(s1)
    80002562:	37fd                	addiw	a5,a5,-1
    80002564:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002566:	00011517          	auipc	a0,0x11
    8000256a:	95250513          	addi	a0,a0,-1710 # 80012eb8 <bcache>
    8000256e:	00005097          	auipc	ra,0x5
    80002572:	d4c080e7          	jalr	-692(ra) # 800072ba <release>
}
    80002576:	60e2                	ld	ra,24(sp)
    80002578:	6442                	ld	s0,16(sp)
    8000257a:	64a2                	ld	s1,8(sp)
    8000257c:	6105                	addi	sp,sp,32
    8000257e:	8082                	ret

0000000080002580 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002580:	1101                	addi	sp,sp,-32
    80002582:	ec06                	sd	ra,24(sp)
    80002584:	e822                	sd	s0,16(sp)
    80002586:	e426                	sd	s1,8(sp)
    80002588:	e04a                	sd	s2,0(sp)
    8000258a:	1000                	addi	s0,sp,32
    8000258c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000258e:	00d5d59b          	srliw	a1,a1,0xd
    80002592:	00019797          	auipc	a5,0x19
    80002596:	0027a783          	lw	a5,2(a5) # 8001b594 <sb+0x1c>
    8000259a:	9dbd                	addw	a1,a1,a5
    8000259c:	00000097          	auipc	ra,0x0
    800025a0:	da0080e7          	jalr	-608(ra) # 8000233c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025a4:	0074f713          	andi	a4,s1,7
    800025a8:	4785                	li	a5,1
    800025aa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025ae:	14ce                	slli	s1,s1,0x33
    800025b0:	90d9                	srli	s1,s1,0x36
    800025b2:	00950733          	add	a4,a0,s1
    800025b6:	05874703          	lbu	a4,88(a4)
    800025ba:	00e7f6b3          	and	a3,a5,a4
    800025be:	c69d                	beqz	a3,800025ec <bfree+0x6c>
    800025c0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025c2:	94aa                	add	s1,s1,a0
    800025c4:	fff7c793          	not	a5,a5
    800025c8:	8f7d                	and	a4,a4,a5
    800025ca:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025ce:	00001097          	auipc	ra,0x1
    800025d2:	112080e7          	jalr	274(ra) # 800036e0 <log_write>
  brelse(bp);
    800025d6:	854a                	mv	a0,s2
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	e94080e7          	jalr	-364(ra) # 8000246c <brelse>
}
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	64a2                	ld	s1,8(sp)
    800025e6:	6902                	ld	s2,0(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret
    panic("freeing free block");
    800025ec:	00007517          	auipc	a0,0x7
    800025f0:	ddc50513          	addi	a0,a0,-548 # 800093c8 <etext+0x3c8>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	698080e7          	jalr	1688(ra) # 80006c8c <panic>

00000000800025fc <balloc>:
{
    800025fc:	711d                	addi	sp,sp,-96
    800025fe:	ec86                	sd	ra,88(sp)
    80002600:	e8a2                	sd	s0,80(sp)
    80002602:	e4a6                	sd	s1,72(sp)
    80002604:	e0ca                	sd	s2,64(sp)
    80002606:	fc4e                	sd	s3,56(sp)
    80002608:	f852                	sd	s4,48(sp)
    8000260a:	f456                	sd	s5,40(sp)
    8000260c:	f05a                	sd	s6,32(sp)
    8000260e:	ec5e                	sd	s7,24(sp)
    80002610:	e862                	sd	s8,16(sp)
    80002612:	e466                	sd	s9,8(sp)
    80002614:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002616:	00019797          	auipc	a5,0x19
    8000261a:	f667a783          	lw	a5,-154(a5) # 8001b57c <sb+0x4>
    8000261e:	cbc1                	beqz	a5,800026ae <balloc+0xb2>
    80002620:	8baa                	mv	s7,a0
    80002622:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002624:	00019b17          	auipc	s6,0x19
    80002628:	f54b0b13          	addi	s6,s6,-172 # 8001b578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000262c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000262e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002630:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002632:	6c89                	lui	s9,0x2
    80002634:	a831                	j	80002650 <balloc+0x54>
    brelse(bp);
    80002636:	854a                	mv	a0,s2
    80002638:	00000097          	auipc	ra,0x0
    8000263c:	e34080e7          	jalr	-460(ra) # 8000246c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002640:	015c87bb          	addw	a5,s9,s5
    80002644:	00078a9b          	sext.w	s5,a5
    80002648:	004b2703          	lw	a4,4(s6)
    8000264c:	06eaf163          	bgeu	s5,a4,800026ae <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002650:	41fad79b          	sraiw	a5,s5,0x1f
    80002654:	0137d79b          	srliw	a5,a5,0x13
    80002658:	015787bb          	addw	a5,a5,s5
    8000265c:	40d7d79b          	sraiw	a5,a5,0xd
    80002660:	01cb2583          	lw	a1,28(s6)
    80002664:	9dbd                	addw	a1,a1,a5
    80002666:	855e                	mv	a0,s7
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	cd4080e7          	jalr	-812(ra) # 8000233c <bread>
    80002670:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002672:	004b2503          	lw	a0,4(s6)
    80002676:	000a849b          	sext.w	s1,s5
    8000267a:	8762                	mv	a4,s8
    8000267c:	faa4fde3          	bgeu	s1,a0,80002636 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002680:	00777693          	andi	a3,a4,7
    80002684:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002688:	41f7579b          	sraiw	a5,a4,0x1f
    8000268c:	01d7d79b          	srliw	a5,a5,0x1d
    80002690:	9fb9                	addw	a5,a5,a4
    80002692:	4037d79b          	sraiw	a5,a5,0x3
    80002696:	00f90633          	add	a2,s2,a5
    8000269a:	05864603          	lbu	a2,88(a2)
    8000269e:	00c6f5b3          	and	a1,a3,a2
    800026a2:	cd91                	beqz	a1,800026be <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	2705                	addiw	a4,a4,1
    800026a6:	2485                	addiw	s1,s1,1
    800026a8:	fd471ae3          	bne	a4,s4,8000267c <balloc+0x80>
    800026ac:	b769                	j	80002636 <balloc+0x3a>
  panic("balloc: out of blocks");
    800026ae:	00007517          	auipc	a0,0x7
    800026b2:	d3250513          	addi	a0,a0,-718 # 800093e0 <etext+0x3e0>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	5d6080e7          	jalr	1494(ra) # 80006c8c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026be:	97ca                	add	a5,a5,s2
    800026c0:	8e55                	or	a2,a2,a3
    800026c2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	018080e7          	jalr	24(ra) # 800036e0 <log_write>
        brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	d9a080e7          	jalr	-614(ra) # 8000246c <brelse>
  bp = bread(dev, bno);
    800026da:	85a6                	mv	a1,s1
    800026dc:	855e                	mv	a0,s7
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	c5e080e7          	jalr	-930(ra) # 8000233c <bread>
    800026e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e8:	40000613          	li	a2,1024
    800026ec:	4581                	li	a1,0
    800026ee:	05850513          	addi	a0,a0,88
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	a88080e7          	jalr	-1400(ra) # 8000017a <memset>
  log_write(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	00001097          	auipc	ra,0x1
    80002700:	fe4080e7          	jalr	-28(ra) # 800036e0 <log_write>
  brelse(bp);
    80002704:	854a                	mv	a0,s2
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	d66080e7          	jalr	-666(ra) # 8000246c <brelse>
}
    8000270e:	8526                	mv	a0,s1
    80002710:	60e6                	ld	ra,88(sp)
    80002712:	6446                	ld	s0,80(sp)
    80002714:	64a6                	ld	s1,72(sp)
    80002716:	6906                	ld	s2,64(sp)
    80002718:	79e2                	ld	s3,56(sp)
    8000271a:	7a42                	ld	s4,48(sp)
    8000271c:	7aa2                	ld	s5,40(sp)
    8000271e:	7b02                	ld	s6,32(sp)
    80002720:	6be2                	ld	s7,24(sp)
    80002722:	6c42                	ld	s8,16(sp)
    80002724:	6ca2                	ld	s9,8(sp)
    80002726:	6125                	addi	sp,sp,96
    80002728:	8082                	ret

000000008000272a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000272a:	7179                	addi	sp,sp,-48
    8000272c:	f406                	sd	ra,40(sp)
    8000272e:	f022                	sd	s0,32(sp)
    80002730:	ec26                	sd	s1,24(sp)
    80002732:	e84a                	sd	s2,16(sp)
    80002734:	e44e                	sd	s3,8(sp)
    80002736:	1800                	addi	s0,sp,48
    80002738:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000273a:	47ad                	li	a5,11
    8000273c:	04b7ff63          	bgeu	a5,a1,8000279a <bmap+0x70>
    80002740:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002742:	ff45849b          	addiw	s1,a1,-12
    80002746:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000274a:	0ff00793          	li	a5,255
    8000274e:	0ae7e463          	bltu	a5,a4,800027f6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002752:	08052583          	lw	a1,128(a0)
    80002756:	c5b5                	beqz	a1,800027c2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002758:	00092503          	lw	a0,0(s2)
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	be0080e7          	jalr	-1056(ra) # 8000233c <bread>
    80002764:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002766:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000276a:	02049713          	slli	a4,s1,0x20
    8000276e:	01e75593          	srli	a1,a4,0x1e
    80002772:	00b784b3          	add	s1,a5,a1
    80002776:	0004a983          	lw	s3,0(s1)
    8000277a:	04098e63          	beqz	s3,800027d6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000277e:	8552                	mv	a0,s4
    80002780:	00000097          	auipc	ra,0x0
    80002784:	cec080e7          	jalr	-788(ra) # 8000246c <brelse>
    return addr;
    80002788:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000278a:	854e                	mv	a0,s3
    8000278c:	70a2                	ld	ra,40(sp)
    8000278e:	7402                	ld	s0,32(sp)
    80002790:	64e2                	ld	s1,24(sp)
    80002792:	6942                	ld	s2,16(sp)
    80002794:	69a2                	ld	s3,8(sp)
    80002796:	6145                	addi	sp,sp,48
    80002798:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000279a:	02059793          	slli	a5,a1,0x20
    8000279e:	01e7d593          	srli	a1,a5,0x1e
    800027a2:	00b504b3          	add	s1,a0,a1
    800027a6:	0504a983          	lw	s3,80(s1)
    800027aa:	fe0990e3          	bnez	s3,8000278a <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027ae:	4108                	lw	a0,0(a0)
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	e4c080e7          	jalr	-436(ra) # 800025fc <balloc>
    800027b8:	0005099b          	sext.w	s3,a0
    800027bc:	0534a823          	sw	s3,80(s1)
    800027c0:	b7e9                	j	8000278a <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027c2:	4108                	lw	a0,0(a0)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e38080e7          	jalr	-456(ra) # 800025fc <balloc>
    800027cc:	0005059b          	sext.w	a1,a0
    800027d0:	08b92023          	sw	a1,128(s2)
    800027d4:	b751                	j	80002758 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027d6:	00092503          	lw	a0,0(s2)
    800027da:	00000097          	auipc	ra,0x0
    800027de:	e22080e7          	jalr	-478(ra) # 800025fc <balloc>
    800027e2:	0005099b          	sext.w	s3,a0
    800027e6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027ea:	8552                	mv	a0,s4
    800027ec:	00001097          	auipc	ra,0x1
    800027f0:	ef4080e7          	jalr	-268(ra) # 800036e0 <log_write>
    800027f4:	b769                	j	8000277e <bmap+0x54>
  panic("bmap: out of range");
    800027f6:	00007517          	auipc	a0,0x7
    800027fa:	c0250513          	addi	a0,a0,-1022 # 800093f8 <etext+0x3f8>
    800027fe:	00004097          	auipc	ra,0x4
    80002802:	48e080e7          	jalr	1166(ra) # 80006c8c <panic>

0000000080002806 <iget>:
{
    80002806:	7179                	addi	sp,sp,-48
    80002808:	f406                	sd	ra,40(sp)
    8000280a:	f022                	sd	s0,32(sp)
    8000280c:	ec26                	sd	s1,24(sp)
    8000280e:	e84a                	sd	s2,16(sp)
    80002810:	e44e                	sd	s3,8(sp)
    80002812:	e052                	sd	s4,0(sp)
    80002814:	1800                	addi	s0,sp,48
    80002816:	89aa                	mv	s3,a0
    80002818:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000281a:	00019517          	auipc	a0,0x19
    8000281e:	d7e50513          	addi	a0,a0,-642 # 8001b598 <itable>
    80002822:	00005097          	auipc	ra,0x5
    80002826:	9e4080e7          	jalr	-1564(ra) # 80007206 <acquire>
  empty = 0;
    8000282a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000282c:	00019497          	auipc	s1,0x19
    80002830:	d8448493          	addi	s1,s1,-636 # 8001b5b0 <itable+0x18>
    80002834:	0001b697          	auipc	a3,0x1b
    80002838:	80c68693          	addi	a3,a3,-2036 # 8001d040 <log>
    8000283c:	a039                	j	8000284a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000283e:	02090b63          	beqz	s2,80002874 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002842:	08848493          	addi	s1,s1,136
    80002846:	02d48a63          	beq	s1,a3,8000287a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000284a:	449c                	lw	a5,8(s1)
    8000284c:	fef059e3          	blez	a5,8000283e <iget+0x38>
    80002850:	4098                	lw	a4,0(s1)
    80002852:	ff3716e3          	bne	a4,s3,8000283e <iget+0x38>
    80002856:	40d8                	lw	a4,4(s1)
    80002858:	ff4713e3          	bne	a4,s4,8000283e <iget+0x38>
      ip->ref++;
    8000285c:	2785                	addiw	a5,a5,1
    8000285e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002860:	00019517          	auipc	a0,0x19
    80002864:	d3850513          	addi	a0,a0,-712 # 8001b598 <itable>
    80002868:	00005097          	auipc	ra,0x5
    8000286c:	a52080e7          	jalr	-1454(ra) # 800072ba <release>
      return ip;
    80002870:	8926                	mv	s2,s1
    80002872:	a03d                	j	800028a0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002874:	f7f9                	bnez	a5,80002842 <iget+0x3c>
      empty = ip;
    80002876:	8926                	mv	s2,s1
    80002878:	b7e9                	j	80002842 <iget+0x3c>
  if(empty == 0)
    8000287a:	02090c63          	beqz	s2,800028b2 <iget+0xac>
  ip->dev = dev;
    8000287e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002882:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002886:	4785                	li	a5,1
    80002888:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000288c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002890:	00019517          	auipc	a0,0x19
    80002894:	d0850513          	addi	a0,a0,-760 # 8001b598 <itable>
    80002898:	00005097          	auipc	ra,0x5
    8000289c:	a22080e7          	jalr	-1502(ra) # 800072ba <release>
}
    800028a0:	854a                	mv	a0,s2
    800028a2:	70a2                	ld	ra,40(sp)
    800028a4:	7402                	ld	s0,32(sp)
    800028a6:	64e2                	ld	s1,24(sp)
    800028a8:	6942                	ld	s2,16(sp)
    800028aa:	69a2                	ld	s3,8(sp)
    800028ac:	6a02                	ld	s4,0(sp)
    800028ae:	6145                	addi	sp,sp,48
    800028b0:	8082                	ret
    panic("iget: no inodes");
    800028b2:	00007517          	auipc	a0,0x7
    800028b6:	b5e50513          	addi	a0,a0,-1186 # 80009410 <etext+0x410>
    800028ba:	00004097          	auipc	ra,0x4
    800028be:	3d2080e7          	jalr	978(ra) # 80006c8c <panic>

00000000800028c2 <fsinit>:
fsinit(int dev) {
    800028c2:	7179                	addi	sp,sp,-48
    800028c4:	f406                	sd	ra,40(sp)
    800028c6:	f022                	sd	s0,32(sp)
    800028c8:	ec26                	sd	s1,24(sp)
    800028ca:	e84a                	sd	s2,16(sp)
    800028cc:	e44e                	sd	s3,8(sp)
    800028ce:	1800                	addi	s0,sp,48
    800028d0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028d2:	4585                	li	a1,1
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	a68080e7          	jalr	-1432(ra) # 8000233c <bread>
    800028dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028de:	00019997          	auipc	s3,0x19
    800028e2:	c9a98993          	addi	s3,s3,-870 # 8001b578 <sb>
    800028e6:	02000613          	li	a2,32
    800028ea:	05850593          	addi	a1,a0,88
    800028ee:	854e                	mv	a0,s3
    800028f0:	ffffe097          	auipc	ra,0xffffe
    800028f4:	8e6080e7          	jalr	-1818(ra) # 800001d6 <memmove>
  brelse(bp);
    800028f8:	8526                	mv	a0,s1
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	b72080e7          	jalr	-1166(ra) # 8000246c <brelse>
  if(sb.magic != FSMAGIC)
    80002902:	0009a703          	lw	a4,0(s3)
    80002906:	102037b7          	lui	a5,0x10203
    8000290a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290e:	02f71263          	bne	a4,a5,80002932 <fsinit+0x70>
  initlog(dev, &sb);
    80002912:	00019597          	auipc	a1,0x19
    80002916:	c6658593          	addi	a1,a1,-922 # 8001b578 <sb>
    8000291a:	854a                	mv	a0,s2
    8000291c:	00001097          	auipc	ra,0x1
    80002920:	b54080e7          	jalr	-1196(ra) # 80003470 <initlog>
}
    80002924:	70a2                	ld	ra,40(sp)
    80002926:	7402                	ld	s0,32(sp)
    80002928:	64e2                	ld	s1,24(sp)
    8000292a:	6942                	ld	s2,16(sp)
    8000292c:	69a2                	ld	s3,8(sp)
    8000292e:	6145                	addi	sp,sp,48
    80002930:	8082                	ret
    panic("invalid file system");
    80002932:	00007517          	auipc	a0,0x7
    80002936:	aee50513          	addi	a0,a0,-1298 # 80009420 <etext+0x420>
    8000293a:	00004097          	auipc	ra,0x4
    8000293e:	352080e7          	jalr	850(ra) # 80006c8c <panic>

0000000080002942 <iinit>:
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002950:	00007597          	auipc	a1,0x7
    80002954:	ae858593          	addi	a1,a1,-1304 # 80009438 <etext+0x438>
    80002958:	00019517          	auipc	a0,0x19
    8000295c:	c4050513          	addi	a0,a0,-960 # 8001b598 <itable>
    80002960:	00005097          	auipc	ra,0x5
    80002964:	816080e7          	jalr	-2026(ra) # 80007176 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002968:	00019497          	auipc	s1,0x19
    8000296c:	c5848493          	addi	s1,s1,-936 # 8001b5c0 <itable+0x28>
    80002970:	0001a997          	auipc	s3,0x1a
    80002974:	6e098993          	addi	s3,s3,1760 # 8001d050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002978:	00007917          	auipc	s2,0x7
    8000297c:	ac890913          	addi	s2,s2,-1336 # 80009440 <etext+0x440>
    80002980:	85ca                	mv	a1,s2
    80002982:	8526                	mv	a0,s1
    80002984:	00001097          	auipc	ra,0x1
    80002988:	e40080e7          	jalr	-448(ra) # 800037c4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000298c:	08848493          	addi	s1,s1,136
    80002990:	ff3498e3          	bne	s1,s3,80002980 <iinit+0x3e>
}
    80002994:	70a2                	ld	ra,40(sp)
    80002996:	7402                	ld	s0,32(sp)
    80002998:	64e2                	ld	s1,24(sp)
    8000299a:	6942                	ld	s2,16(sp)
    8000299c:	69a2                	ld	s3,8(sp)
    8000299e:	6145                	addi	sp,sp,48
    800029a0:	8082                	ret

00000000800029a2 <ialloc>:
{
    800029a2:	7139                	addi	sp,sp,-64
    800029a4:	fc06                	sd	ra,56(sp)
    800029a6:	f822                	sd	s0,48(sp)
    800029a8:	f426                	sd	s1,40(sp)
    800029aa:	f04a                	sd	s2,32(sp)
    800029ac:	ec4e                	sd	s3,24(sp)
    800029ae:	e852                	sd	s4,16(sp)
    800029b0:	e456                	sd	s5,8(sp)
    800029b2:	e05a                	sd	s6,0(sp)
    800029b4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b6:	00019717          	auipc	a4,0x19
    800029ba:	bce72703          	lw	a4,-1074(a4) # 8001b584 <sb+0xc>
    800029be:	4785                	li	a5,1
    800029c0:	04e7f863          	bgeu	a5,a4,80002a10 <ialloc+0x6e>
    800029c4:	8aaa                	mv	s5,a0
    800029c6:	8b2e                	mv	s6,a1
    800029c8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029ca:	00019a17          	auipc	s4,0x19
    800029ce:	baea0a13          	addi	s4,s4,-1106 # 8001b578 <sb>
    800029d2:	00495593          	srli	a1,s2,0x4
    800029d6:	018a2783          	lw	a5,24(s4)
    800029da:	9dbd                	addw	a1,a1,a5
    800029dc:	8556                	mv	a0,s5
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	95e080e7          	jalr	-1698(ra) # 8000233c <bread>
    800029e6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029e8:	05850993          	addi	s3,a0,88
    800029ec:	00f97793          	andi	a5,s2,15
    800029f0:	079a                	slli	a5,a5,0x6
    800029f2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029f4:	00099783          	lh	a5,0(s3)
    800029f8:	c785                	beqz	a5,80002a20 <ialloc+0x7e>
    brelse(bp);
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	a72080e7          	jalr	-1422(ra) # 8000246c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a02:	0905                	addi	s2,s2,1
    80002a04:	00ca2703          	lw	a4,12(s4)
    80002a08:	0009079b          	sext.w	a5,s2
    80002a0c:	fce7e3e3          	bltu	a5,a4,800029d2 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a10:	00007517          	auipc	a0,0x7
    80002a14:	a3850513          	addi	a0,a0,-1480 # 80009448 <etext+0x448>
    80002a18:	00004097          	auipc	ra,0x4
    80002a1c:	274080e7          	jalr	628(ra) # 80006c8c <panic>
      memset(dip, 0, sizeof(*dip));
    80002a20:	04000613          	li	a2,64
    80002a24:	4581                	li	a1,0
    80002a26:	854e                	mv	a0,s3
    80002a28:	ffffd097          	auipc	ra,0xffffd
    80002a2c:	752080e7          	jalr	1874(ra) # 8000017a <memset>
      dip->type = type;
    80002a30:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a34:	8526                	mv	a0,s1
    80002a36:	00001097          	auipc	ra,0x1
    80002a3a:	caa080e7          	jalr	-854(ra) # 800036e0 <log_write>
      brelse(bp);
    80002a3e:	8526                	mv	a0,s1
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	a2c080e7          	jalr	-1492(ra) # 8000246c <brelse>
      return iget(dev, inum);
    80002a48:	0009059b          	sext.w	a1,s2
    80002a4c:	8556                	mv	a0,s5
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	db8080e7          	jalr	-584(ra) # 80002806 <iget>
}
    80002a56:	70e2                	ld	ra,56(sp)
    80002a58:	7442                	ld	s0,48(sp)
    80002a5a:	74a2                	ld	s1,40(sp)
    80002a5c:	7902                	ld	s2,32(sp)
    80002a5e:	69e2                	ld	s3,24(sp)
    80002a60:	6a42                	ld	s4,16(sp)
    80002a62:	6aa2                	ld	s5,8(sp)
    80002a64:	6b02                	ld	s6,0(sp)
    80002a66:	6121                	addi	sp,sp,64
    80002a68:	8082                	ret

0000000080002a6a <iupdate>:
{
    80002a6a:	1101                	addi	sp,sp,-32
    80002a6c:	ec06                	sd	ra,24(sp)
    80002a6e:	e822                	sd	s0,16(sp)
    80002a70:	e426                	sd	s1,8(sp)
    80002a72:	e04a                	sd	s2,0(sp)
    80002a74:	1000                	addi	s0,sp,32
    80002a76:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a78:	415c                	lw	a5,4(a0)
    80002a7a:	0047d79b          	srliw	a5,a5,0x4
    80002a7e:	00019597          	auipc	a1,0x19
    80002a82:	b125a583          	lw	a1,-1262(a1) # 8001b590 <sb+0x18>
    80002a86:	9dbd                	addw	a1,a1,a5
    80002a88:	4108                	lw	a0,0(a0)
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	8b2080e7          	jalr	-1870(ra) # 8000233c <bread>
    80002a92:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a94:	05850793          	addi	a5,a0,88
    80002a98:	40d8                	lw	a4,4(s1)
    80002a9a:	8b3d                	andi	a4,a4,15
    80002a9c:	071a                	slli	a4,a4,0x6
    80002a9e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002aa0:	04449703          	lh	a4,68(s1)
    80002aa4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002aa8:	04649703          	lh	a4,70(s1)
    80002aac:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ab0:	04849703          	lh	a4,72(s1)
    80002ab4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ab8:	04a49703          	lh	a4,74(s1)
    80002abc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ac0:	44f8                	lw	a4,76(s1)
    80002ac2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ac4:	03400613          	li	a2,52
    80002ac8:	05048593          	addi	a1,s1,80
    80002acc:	00c78513          	addi	a0,a5,12
    80002ad0:	ffffd097          	auipc	ra,0xffffd
    80002ad4:	706080e7          	jalr	1798(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ad8:	854a                	mv	a0,s2
    80002ada:	00001097          	auipc	ra,0x1
    80002ade:	c06080e7          	jalr	-1018(ra) # 800036e0 <log_write>
  brelse(bp);
    80002ae2:	854a                	mv	a0,s2
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	988080e7          	jalr	-1656(ra) # 8000246c <brelse>
}
    80002aec:	60e2                	ld	ra,24(sp)
    80002aee:	6442                	ld	s0,16(sp)
    80002af0:	64a2                	ld	s1,8(sp)
    80002af2:	6902                	ld	s2,0(sp)
    80002af4:	6105                	addi	sp,sp,32
    80002af6:	8082                	ret

0000000080002af8 <idup>:
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	1000                	addi	s0,sp,32
    80002b02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b04:	00019517          	auipc	a0,0x19
    80002b08:	a9450513          	addi	a0,a0,-1388 # 8001b598 <itable>
    80002b0c:	00004097          	auipc	ra,0x4
    80002b10:	6fa080e7          	jalr	1786(ra) # 80007206 <acquire>
  ip->ref++;
    80002b14:	449c                	lw	a5,8(s1)
    80002b16:	2785                	addiw	a5,a5,1
    80002b18:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b1a:	00019517          	auipc	a0,0x19
    80002b1e:	a7e50513          	addi	a0,a0,-1410 # 8001b598 <itable>
    80002b22:	00004097          	auipc	ra,0x4
    80002b26:	798080e7          	jalr	1944(ra) # 800072ba <release>
}
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	60e2                	ld	ra,24(sp)
    80002b2e:	6442                	ld	s0,16(sp)
    80002b30:	64a2                	ld	s1,8(sp)
    80002b32:	6105                	addi	sp,sp,32
    80002b34:	8082                	ret

0000000080002b36 <ilock>:
{
    80002b36:	1101                	addi	sp,sp,-32
    80002b38:	ec06                	sd	ra,24(sp)
    80002b3a:	e822                	sd	s0,16(sp)
    80002b3c:	e426                	sd	s1,8(sp)
    80002b3e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b40:	c10d                	beqz	a0,80002b62 <ilock+0x2c>
    80002b42:	84aa                	mv	s1,a0
    80002b44:	451c                	lw	a5,8(a0)
    80002b46:	00f05e63          	blez	a5,80002b62 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b4a:	0541                	addi	a0,a0,16
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	cb2080e7          	jalr	-846(ra) # 800037fe <acquiresleep>
  if(ip->valid == 0){
    80002b54:	40bc                	lw	a5,64(s1)
    80002b56:	cf99                	beqz	a5,80002b74 <ilock+0x3e>
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6105                	addi	sp,sp,32
    80002b60:	8082                	ret
    80002b62:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002b64:	00007517          	auipc	a0,0x7
    80002b68:	8fc50513          	addi	a0,a0,-1796 # 80009460 <etext+0x460>
    80002b6c:	00004097          	auipc	ra,0x4
    80002b70:	120080e7          	jalr	288(ra) # 80006c8c <panic>
    80002b74:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b76:	40dc                	lw	a5,4(s1)
    80002b78:	0047d79b          	srliw	a5,a5,0x4
    80002b7c:	00019597          	auipc	a1,0x19
    80002b80:	a145a583          	lw	a1,-1516(a1) # 8001b590 <sb+0x18>
    80002b84:	9dbd                	addw	a1,a1,a5
    80002b86:	4088                	lw	a0,0(s1)
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	7b4080e7          	jalr	1972(ra) # 8000233c <bread>
    80002b90:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b92:	05850593          	addi	a1,a0,88
    80002b96:	40dc                	lw	a5,4(s1)
    80002b98:	8bbd                	andi	a5,a5,15
    80002b9a:	079a                	slli	a5,a5,0x6
    80002b9c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b9e:	00059783          	lh	a5,0(a1)
    80002ba2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ba6:	00259783          	lh	a5,2(a1)
    80002baa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bae:	00459783          	lh	a5,4(a1)
    80002bb2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bb6:	00659783          	lh	a5,6(a1)
    80002bba:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bbe:	459c                	lw	a5,8(a1)
    80002bc0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc2:	03400613          	li	a2,52
    80002bc6:	05b1                	addi	a1,a1,12
    80002bc8:	05048513          	addi	a0,s1,80
    80002bcc:	ffffd097          	auipc	ra,0xffffd
    80002bd0:	60a080e7          	jalr	1546(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	896080e7          	jalr	-1898(ra) # 8000246c <brelse>
    ip->valid = 1;
    80002bde:	4785                	li	a5,1
    80002be0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002be2:	04449783          	lh	a5,68(s1)
    80002be6:	c399                	beqz	a5,80002bec <ilock+0xb6>
    80002be8:	6902                	ld	s2,0(sp)
    80002bea:	b7bd                	j	80002b58 <ilock+0x22>
      panic("ilock: no type");
    80002bec:	00007517          	auipc	a0,0x7
    80002bf0:	87c50513          	addi	a0,a0,-1924 # 80009468 <etext+0x468>
    80002bf4:	00004097          	auipc	ra,0x4
    80002bf8:	098080e7          	jalr	152(ra) # 80006c8c <panic>

0000000080002bfc <iunlock>:
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	e04a                	sd	s2,0(sp)
    80002c06:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c08:	c905                	beqz	a0,80002c38 <iunlock+0x3c>
    80002c0a:	84aa                	mv	s1,a0
    80002c0c:	01050913          	addi	s2,a0,16
    80002c10:	854a                	mv	a0,s2
    80002c12:	00001097          	auipc	ra,0x1
    80002c16:	c86080e7          	jalr	-890(ra) # 80003898 <holdingsleep>
    80002c1a:	cd19                	beqz	a0,80002c38 <iunlock+0x3c>
    80002c1c:	449c                	lw	a5,8(s1)
    80002c1e:	00f05d63          	blez	a5,80002c38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c22:	854a                	mv	a0,s2
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	c30080e7          	jalr	-976(ra) # 80003854 <releasesleep>
}
    80002c2c:	60e2                	ld	ra,24(sp)
    80002c2e:	6442                	ld	s0,16(sp)
    80002c30:	64a2                	ld	s1,8(sp)
    80002c32:	6902                	ld	s2,0(sp)
    80002c34:	6105                	addi	sp,sp,32
    80002c36:	8082                	ret
    panic("iunlock");
    80002c38:	00007517          	auipc	a0,0x7
    80002c3c:	84050513          	addi	a0,a0,-1984 # 80009478 <etext+0x478>
    80002c40:	00004097          	auipc	ra,0x4
    80002c44:	04c080e7          	jalr	76(ra) # 80006c8c <panic>

0000000080002c48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c48:	7179                	addi	sp,sp,-48
    80002c4a:	f406                	sd	ra,40(sp)
    80002c4c:	f022                	sd	s0,32(sp)
    80002c4e:	ec26                	sd	s1,24(sp)
    80002c50:	e84a                	sd	s2,16(sp)
    80002c52:	e44e                	sd	s3,8(sp)
    80002c54:	1800                	addi	s0,sp,48
    80002c56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c58:	05050493          	addi	s1,a0,80
    80002c5c:	08050913          	addi	s2,a0,128
    80002c60:	a021                	j	80002c68 <itrunc+0x20>
    80002c62:	0491                	addi	s1,s1,4
    80002c64:	01248d63          	beq	s1,s2,80002c7e <itrunc+0x36>
    if(ip->addrs[i]){
    80002c68:	408c                	lw	a1,0(s1)
    80002c6a:	dde5                	beqz	a1,80002c62 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002c6c:	0009a503          	lw	a0,0(s3)
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	910080e7          	jalr	-1776(ra) # 80002580 <bfree>
      ip->addrs[i] = 0;
    80002c78:	0004a023          	sw	zero,0(s1)
    80002c7c:	b7dd                	j	80002c62 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c7e:	0809a583          	lw	a1,128(s3)
    80002c82:	ed99                	bnez	a1,80002ca0 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c84:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c88:	854e                	mv	a0,s3
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	de0080e7          	jalr	-544(ra) # 80002a6a <iupdate>
}
    80002c92:	70a2                	ld	ra,40(sp)
    80002c94:	7402                	ld	s0,32(sp)
    80002c96:	64e2                	ld	s1,24(sp)
    80002c98:	6942                	ld	s2,16(sp)
    80002c9a:	69a2                	ld	s3,8(sp)
    80002c9c:	6145                	addi	sp,sp,48
    80002c9e:	8082                	ret
    80002ca0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca2:	0009a503          	lw	a0,0(s3)
    80002ca6:	fffff097          	auipc	ra,0xfffff
    80002caa:	696080e7          	jalr	1686(ra) # 8000233c <bread>
    80002cae:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb0:	05850493          	addi	s1,a0,88
    80002cb4:	45850913          	addi	s2,a0,1112
    80002cb8:	a021                	j	80002cc0 <itrunc+0x78>
    80002cba:	0491                	addi	s1,s1,4
    80002cbc:	01248b63          	beq	s1,s2,80002cd2 <itrunc+0x8a>
      if(a[j])
    80002cc0:	408c                	lw	a1,0(s1)
    80002cc2:	dde5                	beqz	a1,80002cba <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002cc4:	0009a503          	lw	a0,0(s3)
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	8b8080e7          	jalr	-1864(ra) # 80002580 <bfree>
    80002cd0:	b7ed                	j	80002cba <itrunc+0x72>
    brelse(bp);
    80002cd2:	8552                	mv	a0,s4
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	798080e7          	jalr	1944(ra) # 8000246c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cdc:	0809a583          	lw	a1,128(s3)
    80002ce0:	0009a503          	lw	a0,0(s3)
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	89c080e7          	jalr	-1892(ra) # 80002580 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cec:	0809a023          	sw	zero,128(s3)
    80002cf0:	6a02                	ld	s4,0(sp)
    80002cf2:	bf49                	j	80002c84 <itrunc+0x3c>

0000000080002cf4 <iput>:
{
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	1000                	addi	s0,sp,32
    80002cfe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d00:	00019517          	auipc	a0,0x19
    80002d04:	89850513          	addi	a0,a0,-1896 # 8001b598 <itable>
    80002d08:	00004097          	auipc	ra,0x4
    80002d0c:	4fe080e7          	jalr	1278(ra) # 80007206 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d10:	4498                	lw	a4,8(s1)
    80002d12:	4785                	li	a5,1
    80002d14:	02f70263          	beq	a4,a5,80002d38 <iput+0x44>
  ip->ref--;
    80002d18:	449c                	lw	a5,8(s1)
    80002d1a:	37fd                	addiw	a5,a5,-1
    80002d1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d1e:	00019517          	auipc	a0,0x19
    80002d22:	87a50513          	addi	a0,a0,-1926 # 8001b598 <itable>
    80002d26:	00004097          	auipc	ra,0x4
    80002d2a:	594080e7          	jalr	1428(ra) # 800072ba <release>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d38:	40bc                	lw	a5,64(s1)
    80002d3a:	dff9                	beqz	a5,80002d18 <iput+0x24>
    80002d3c:	04a49783          	lh	a5,74(s1)
    80002d40:	ffe1                	bnez	a5,80002d18 <iput+0x24>
    80002d42:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002d44:	01048913          	addi	s2,s1,16
    80002d48:	854a                	mv	a0,s2
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	ab4080e7          	jalr	-1356(ra) # 800037fe <acquiresleep>
    release(&itable.lock);
    80002d52:	00019517          	auipc	a0,0x19
    80002d56:	84650513          	addi	a0,a0,-1978 # 8001b598 <itable>
    80002d5a:	00004097          	auipc	ra,0x4
    80002d5e:	560080e7          	jalr	1376(ra) # 800072ba <release>
    itrunc(ip);
    80002d62:	8526                	mv	a0,s1
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	ee4080e7          	jalr	-284(ra) # 80002c48 <itrunc>
    ip->type = 0;
    80002d6c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d70:	8526                	mv	a0,s1
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	cf8080e7          	jalr	-776(ra) # 80002a6a <iupdate>
    ip->valid = 0;
    80002d7a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	ad4080e7          	jalr	-1324(ra) # 80003854 <releasesleep>
    acquire(&itable.lock);
    80002d88:	00019517          	auipc	a0,0x19
    80002d8c:	81050513          	addi	a0,a0,-2032 # 8001b598 <itable>
    80002d90:	00004097          	auipc	ra,0x4
    80002d94:	476080e7          	jalr	1142(ra) # 80007206 <acquire>
    80002d98:	6902                	ld	s2,0(sp)
    80002d9a:	bfbd                	j	80002d18 <iput+0x24>

0000000080002d9c <iunlockput>:
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	e54080e7          	jalr	-428(ra) # 80002bfc <iunlock>
  iput(ip);
    80002db0:	8526                	mv	a0,s1
    80002db2:	00000097          	auipc	ra,0x0
    80002db6:	f42080e7          	jalr	-190(ra) # 80002cf4 <iput>
}
    80002dba:	60e2                	ld	ra,24(sp)
    80002dbc:	6442                	ld	s0,16(sp)
    80002dbe:	64a2                	ld	s1,8(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret

0000000080002dc4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dc4:	1141                	addi	sp,sp,-16
    80002dc6:	e422                	sd	s0,8(sp)
    80002dc8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dca:	411c                	lw	a5,0(a0)
    80002dcc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dce:	415c                	lw	a5,4(a0)
    80002dd0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd2:	04451783          	lh	a5,68(a0)
    80002dd6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dda:	04a51783          	lh	a5,74(a0)
    80002dde:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de2:	04c56783          	lwu	a5,76(a0)
    80002de6:	e99c                	sd	a5,16(a1)
}
    80002de8:	6422                	ld	s0,8(sp)
    80002dea:	0141                	addi	sp,sp,16
    80002dec:	8082                	ret

0000000080002dee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dee:	457c                	lw	a5,76(a0)
    80002df0:	0ed7ef63          	bltu	a5,a3,80002eee <readi+0x100>
{
    80002df4:	7159                	addi	sp,sp,-112
    80002df6:	f486                	sd	ra,104(sp)
    80002df8:	f0a2                	sd	s0,96(sp)
    80002dfa:	eca6                	sd	s1,88(sp)
    80002dfc:	fc56                	sd	s5,56(sp)
    80002dfe:	f85a                	sd	s6,48(sp)
    80002e00:	f45e                	sd	s7,40(sp)
    80002e02:	f062                	sd	s8,32(sp)
    80002e04:	1880                	addi	s0,sp,112
    80002e06:	8baa                	mv	s7,a0
    80002e08:	8c2e                	mv	s8,a1
    80002e0a:	8ab2                	mv	s5,a2
    80002e0c:	84b6                	mv	s1,a3
    80002e0e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e10:	9f35                	addw	a4,a4,a3
    return 0;
    80002e12:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e14:	0ad76c63          	bltu	a4,a3,80002ecc <readi+0xde>
    80002e18:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002e1a:	00e7f463          	bgeu	a5,a4,80002e22 <readi+0x34>
    n = ip->size - off;
    80002e1e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e22:	0c0b0463          	beqz	s6,80002eea <readi+0xfc>
    80002e26:	e8ca                	sd	s2,80(sp)
    80002e28:	e0d2                	sd	s4,64(sp)
    80002e2a:	ec66                	sd	s9,24(sp)
    80002e2c:	e86a                	sd	s10,16(sp)
    80002e2e:	e46e                	sd	s11,8(sp)
    80002e30:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e32:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e36:	5cfd                	li	s9,-1
    80002e38:	a82d                	j	80002e72 <readi+0x84>
    80002e3a:	020a1d93          	slli	s11,s4,0x20
    80002e3e:	020ddd93          	srli	s11,s11,0x20
    80002e42:	05890613          	addi	a2,s2,88
    80002e46:	86ee                	mv	a3,s11
    80002e48:	963a                	add	a2,a2,a4
    80002e4a:	85d6                	mv	a1,s5
    80002e4c:	8562                	mv	a0,s8
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	af0080e7          	jalr	-1296(ra) # 8000193e <either_copyout>
    80002e56:	05950d63          	beq	a0,s9,80002eb0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e5a:	854a                	mv	a0,s2
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	610080e7          	jalr	1552(ra) # 8000246c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e64:	013a09bb          	addw	s3,s4,s3
    80002e68:	009a04bb          	addw	s1,s4,s1
    80002e6c:	9aee                	add	s5,s5,s11
    80002e6e:	0769f863          	bgeu	s3,s6,80002ede <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e72:	000ba903          	lw	s2,0(s7)
    80002e76:	00a4d59b          	srliw	a1,s1,0xa
    80002e7a:	855e                	mv	a0,s7
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	8ae080e7          	jalr	-1874(ra) # 8000272a <bmap>
    80002e84:	0005059b          	sext.w	a1,a0
    80002e88:	854a                	mv	a0,s2
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	4b2080e7          	jalr	1202(ra) # 8000233c <bread>
    80002e92:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e94:	3ff4f713          	andi	a4,s1,1023
    80002e98:	40ed07bb          	subw	a5,s10,a4
    80002e9c:	413b06bb          	subw	a3,s6,s3
    80002ea0:	8a3e                	mv	s4,a5
    80002ea2:	2781                	sext.w	a5,a5
    80002ea4:	0006861b          	sext.w	a2,a3
    80002ea8:	f8f679e3          	bgeu	a2,a5,80002e3a <readi+0x4c>
    80002eac:	8a36                	mv	s4,a3
    80002eae:	b771                	j	80002e3a <readi+0x4c>
      brelse(bp);
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	5ba080e7          	jalr	1466(ra) # 8000246c <brelse>
      tot = -1;
    80002eba:	59fd                	li	s3,-1
      break;
    80002ebc:	6946                	ld	s2,80(sp)
    80002ebe:	6a06                	ld	s4,64(sp)
    80002ec0:	6ce2                	ld	s9,24(sp)
    80002ec2:	6d42                	ld	s10,16(sp)
    80002ec4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ec6:	0009851b          	sext.w	a0,s3
    80002eca:	69a6                	ld	s3,72(sp)
}
    80002ecc:	70a6                	ld	ra,104(sp)
    80002ece:	7406                	ld	s0,96(sp)
    80002ed0:	64e6                	ld	s1,88(sp)
    80002ed2:	7ae2                	ld	s5,56(sp)
    80002ed4:	7b42                	ld	s6,48(sp)
    80002ed6:	7ba2                	ld	s7,40(sp)
    80002ed8:	7c02                	ld	s8,32(sp)
    80002eda:	6165                	addi	sp,sp,112
    80002edc:	8082                	ret
    80002ede:	6946                	ld	s2,80(sp)
    80002ee0:	6a06                	ld	s4,64(sp)
    80002ee2:	6ce2                	ld	s9,24(sp)
    80002ee4:	6d42                	ld	s10,16(sp)
    80002ee6:	6da2                	ld	s11,8(sp)
    80002ee8:	bff9                	j	80002ec6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eea:	89da                	mv	s3,s6
    80002eec:	bfe9                	j	80002ec6 <readi+0xd8>
    return 0;
    80002eee:	4501                	li	a0,0
}
    80002ef0:	8082                	ret

0000000080002ef2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef2:	457c                	lw	a5,76(a0)
    80002ef4:	10d7ee63          	bltu	a5,a3,80003010 <writei+0x11e>
{
    80002ef8:	7159                	addi	sp,sp,-112
    80002efa:	f486                	sd	ra,104(sp)
    80002efc:	f0a2                	sd	s0,96(sp)
    80002efe:	e8ca                	sd	s2,80(sp)
    80002f00:	fc56                	sd	s5,56(sp)
    80002f02:	f85a                	sd	s6,48(sp)
    80002f04:	f45e                	sd	s7,40(sp)
    80002f06:	f062                	sd	s8,32(sp)
    80002f08:	1880                	addi	s0,sp,112
    80002f0a:	8b2a                	mv	s6,a0
    80002f0c:	8c2e                	mv	s8,a1
    80002f0e:	8ab2                	mv	s5,a2
    80002f10:	8936                	mv	s2,a3
    80002f12:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f14:	00e687bb          	addw	a5,a3,a4
    80002f18:	0ed7ee63          	bltu	a5,a3,80003014 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f1c:	00043737          	lui	a4,0x43
    80002f20:	0ef76c63          	bltu	a4,a5,80003018 <writei+0x126>
    80002f24:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f26:	0c0b8d63          	beqz	s7,80003000 <writei+0x10e>
    80002f2a:	eca6                	sd	s1,88(sp)
    80002f2c:	e4ce                	sd	s3,72(sp)
    80002f2e:	ec66                	sd	s9,24(sp)
    80002f30:	e86a                	sd	s10,16(sp)
    80002f32:	e46e                	sd	s11,8(sp)
    80002f34:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f36:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f3a:	5cfd                	li	s9,-1
    80002f3c:	a091                	j	80002f80 <writei+0x8e>
    80002f3e:	02099d93          	slli	s11,s3,0x20
    80002f42:	020ddd93          	srli	s11,s11,0x20
    80002f46:	05848513          	addi	a0,s1,88
    80002f4a:	86ee                	mv	a3,s11
    80002f4c:	8656                	mv	a2,s5
    80002f4e:	85e2                	mv	a1,s8
    80002f50:	953a                	add	a0,a0,a4
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	a42080e7          	jalr	-1470(ra) # 80001994 <either_copyin>
    80002f5a:	07950263          	beq	a0,s9,80002fbe <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	780080e7          	jalr	1920(ra) # 800036e0 <log_write>
    brelse(bp);
    80002f68:	8526                	mv	a0,s1
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	502080e7          	jalr	1282(ra) # 8000246c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f72:	01498a3b          	addw	s4,s3,s4
    80002f76:	0129893b          	addw	s2,s3,s2
    80002f7a:	9aee                	add	s5,s5,s11
    80002f7c:	057a7663          	bgeu	s4,s7,80002fc8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f80:	000b2483          	lw	s1,0(s6)
    80002f84:	00a9559b          	srliw	a1,s2,0xa
    80002f88:	855a                	mv	a0,s6
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	7a0080e7          	jalr	1952(ra) # 8000272a <bmap>
    80002f92:	0005059b          	sext.w	a1,a0
    80002f96:	8526                	mv	a0,s1
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	3a4080e7          	jalr	932(ra) # 8000233c <bread>
    80002fa0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa2:	3ff97713          	andi	a4,s2,1023
    80002fa6:	40ed07bb          	subw	a5,s10,a4
    80002faa:	414b86bb          	subw	a3,s7,s4
    80002fae:	89be                	mv	s3,a5
    80002fb0:	2781                	sext.w	a5,a5
    80002fb2:	0006861b          	sext.w	a2,a3
    80002fb6:	f8f674e3          	bgeu	a2,a5,80002f3e <writei+0x4c>
    80002fba:	89b6                	mv	s3,a3
    80002fbc:	b749                	j	80002f3e <writei+0x4c>
      brelse(bp);
    80002fbe:	8526                	mv	a0,s1
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	4ac080e7          	jalr	1196(ra) # 8000246c <brelse>
  }

  if(off > ip->size)
    80002fc8:	04cb2783          	lw	a5,76(s6)
    80002fcc:	0327fc63          	bgeu	a5,s2,80003004 <writei+0x112>
    ip->size = off;
    80002fd0:	052b2623          	sw	s2,76(s6)
    80002fd4:	64e6                	ld	s1,88(sp)
    80002fd6:	69a6                	ld	s3,72(sp)
    80002fd8:	6ce2                	ld	s9,24(sp)
    80002fda:	6d42                	ld	s10,16(sp)
    80002fdc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fde:	855a                	mv	a0,s6
    80002fe0:	00000097          	auipc	ra,0x0
    80002fe4:	a8a080e7          	jalr	-1398(ra) # 80002a6a <iupdate>

  return tot;
    80002fe8:	000a051b          	sext.w	a0,s4
    80002fec:	6a06                	ld	s4,64(sp)
}
    80002fee:	70a6                	ld	ra,104(sp)
    80002ff0:	7406                	ld	s0,96(sp)
    80002ff2:	6946                	ld	s2,80(sp)
    80002ff4:	7ae2                	ld	s5,56(sp)
    80002ff6:	7b42                	ld	s6,48(sp)
    80002ff8:	7ba2                	ld	s7,40(sp)
    80002ffa:	7c02                	ld	s8,32(sp)
    80002ffc:	6165                	addi	sp,sp,112
    80002ffe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003000:	8a5e                	mv	s4,s7
    80003002:	bff1                	j	80002fde <writei+0xec>
    80003004:	64e6                	ld	s1,88(sp)
    80003006:	69a6                	ld	s3,72(sp)
    80003008:	6ce2                	ld	s9,24(sp)
    8000300a:	6d42                	ld	s10,16(sp)
    8000300c:	6da2                	ld	s11,8(sp)
    8000300e:	bfc1                	j	80002fde <writei+0xec>
    return -1;
    80003010:	557d                	li	a0,-1
}
    80003012:	8082                	ret
    return -1;
    80003014:	557d                	li	a0,-1
    80003016:	bfe1                	j	80002fee <writei+0xfc>
    return -1;
    80003018:	557d                	li	a0,-1
    8000301a:	bfd1                	j	80002fee <writei+0xfc>

000000008000301c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000301c:	1141                	addi	sp,sp,-16
    8000301e:	e406                	sd	ra,8(sp)
    80003020:	e022                	sd	s0,0(sp)
    80003022:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003024:	4639                	li	a2,14
    80003026:	ffffd097          	auipc	ra,0xffffd
    8000302a:	224080e7          	jalr	548(ra) # 8000024a <strncmp>
}
    8000302e:	60a2                	ld	ra,8(sp)
    80003030:	6402                	ld	s0,0(sp)
    80003032:	0141                	addi	sp,sp,16
    80003034:	8082                	ret

0000000080003036 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003036:	7139                	addi	sp,sp,-64
    80003038:	fc06                	sd	ra,56(sp)
    8000303a:	f822                	sd	s0,48(sp)
    8000303c:	f426                	sd	s1,40(sp)
    8000303e:	f04a                	sd	s2,32(sp)
    80003040:	ec4e                	sd	s3,24(sp)
    80003042:	e852                	sd	s4,16(sp)
    80003044:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003046:	04451703          	lh	a4,68(a0)
    8000304a:	4785                	li	a5,1
    8000304c:	00f71a63          	bne	a4,a5,80003060 <dirlookup+0x2a>
    80003050:	892a                	mv	s2,a0
    80003052:	89ae                	mv	s3,a1
    80003054:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003056:	457c                	lw	a5,76(a0)
    80003058:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000305a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	e79d                	bnez	a5,8000308a <dirlookup+0x54>
    8000305e:	a8a5                	j	800030d6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003060:	00006517          	auipc	a0,0x6
    80003064:	42050513          	addi	a0,a0,1056 # 80009480 <etext+0x480>
    80003068:	00004097          	auipc	ra,0x4
    8000306c:	c24080e7          	jalr	-988(ra) # 80006c8c <panic>
      panic("dirlookup read");
    80003070:	00006517          	auipc	a0,0x6
    80003074:	42850513          	addi	a0,a0,1064 # 80009498 <etext+0x498>
    80003078:	00004097          	auipc	ra,0x4
    8000307c:	c14080e7          	jalr	-1004(ra) # 80006c8c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003080:	24c1                	addiw	s1,s1,16
    80003082:	04c92783          	lw	a5,76(s2)
    80003086:	04f4f763          	bgeu	s1,a5,800030d4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000308a:	4741                	li	a4,16
    8000308c:	86a6                	mv	a3,s1
    8000308e:	fc040613          	addi	a2,s0,-64
    80003092:	4581                	li	a1,0
    80003094:	854a                	mv	a0,s2
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	d58080e7          	jalr	-680(ra) # 80002dee <readi>
    8000309e:	47c1                	li	a5,16
    800030a0:	fcf518e3          	bne	a0,a5,80003070 <dirlookup+0x3a>
    if(de.inum == 0)
    800030a4:	fc045783          	lhu	a5,-64(s0)
    800030a8:	dfe1                	beqz	a5,80003080 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030aa:	fc240593          	addi	a1,s0,-62
    800030ae:	854e                	mv	a0,s3
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	f6c080e7          	jalr	-148(ra) # 8000301c <namecmp>
    800030b8:	f561                	bnez	a0,80003080 <dirlookup+0x4a>
      if(poff)
    800030ba:	000a0463          	beqz	s4,800030c2 <dirlookup+0x8c>
        *poff = off;
    800030be:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030c2:	fc045583          	lhu	a1,-64(s0)
    800030c6:	00092503          	lw	a0,0(s2)
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	73c080e7          	jalr	1852(ra) # 80002806 <iget>
    800030d2:	a011                	j	800030d6 <dirlookup+0xa0>
  return 0;
    800030d4:	4501                	li	a0,0
}
    800030d6:	70e2                	ld	ra,56(sp)
    800030d8:	7442                	ld	s0,48(sp)
    800030da:	74a2                	ld	s1,40(sp)
    800030dc:	7902                	ld	s2,32(sp)
    800030de:	69e2                	ld	s3,24(sp)
    800030e0:	6a42                	ld	s4,16(sp)
    800030e2:	6121                	addi	sp,sp,64
    800030e4:	8082                	ret

00000000800030e6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030e6:	711d                	addi	sp,sp,-96
    800030e8:	ec86                	sd	ra,88(sp)
    800030ea:	e8a2                	sd	s0,80(sp)
    800030ec:	e4a6                	sd	s1,72(sp)
    800030ee:	e0ca                	sd	s2,64(sp)
    800030f0:	fc4e                	sd	s3,56(sp)
    800030f2:	f852                	sd	s4,48(sp)
    800030f4:	f456                	sd	s5,40(sp)
    800030f6:	f05a                	sd	s6,32(sp)
    800030f8:	ec5e                	sd	s7,24(sp)
    800030fa:	e862                	sd	s8,16(sp)
    800030fc:	e466                	sd	s9,8(sp)
    800030fe:	1080                	addi	s0,sp,96
    80003100:	84aa                	mv	s1,a0
    80003102:	8b2e                	mv	s6,a1
    80003104:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003106:	00054703          	lbu	a4,0(a0)
    8000310a:	02f00793          	li	a5,47
    8000310e:	02f70263          	beq	a4,a5,80003132 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003112:	ffffe097          	auipc	ra,0xffffe
    80003116:	dc2080e7          	jalr	-574(ra) # 80000ed4 <myproc>
    8000311a:	15053503          	ld	a0,336(a0)
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	9da080e7          	jalr	-1574(ra) # 80002af8 <idup>
    80003126:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003128:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000312c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000312e:	4b85                	li	s7,1
    80003130:	a875                	j	800031ec <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003132:	4585                	li	a1,1
    80003134:	4505                	li	a0,1
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	6d0080e7          	jalr	1744(ra) # 80002806 <iget>
    8000313e:	8a2a                	mv	s4,a0
    80003140:	b7e5                	j	80003128 <namex+0x42>
      iunlockput(ip);
    80003142:	8552                	mv	a0,s4
    80003144:	00000097          	auipc	ra,0x0
    80003148:	c58080e7          	jalr	-936(ra) # 80002d9c <iunlockput>
      return 0;
    8000314c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000314e:	8552                	mv	a0,s4
    80003150:	60e6                	ld	ra,88(sp)
    80003152:	6446                	ld	s0,80(sp)
    80003154:	64a6                	ld	s1,72(sp)
    80003156:	6906                	ld	s2,64(sp)
    80003158:	79e2                	ld	s3,56(sp)
    8000315a:	7a42                	ld	s4,48(sp)
    8000315c:	7aa2                	ld	s5,40(sp)
    8000315e:	7b02                	ld	s6,32(sp)
    80003160:	6be2                	ld	s7,24(sp)
    80003162:	6c42                	ld	s8,16(sp)
    80003164:	6ca2                	ld	s9,8(sp)
    80003166:	6125                	addi	sp,sp,96
    80003168:	8082                	ret
      iunlock(ip);
    8000316a:	8552                	mv	a0,s4
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	a90080e7          	jalr	-1392(ra) # 80002bfc <iunlock>
      return ip;
    80003174:	bfe9                	j	8000314e <namex+0x68>
      iunlockput(ip);
    80003176:	8552                	mv	a0,s4
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	c24080e7          	jalr	-988(ra) # 80002d9c <iunlockput>
      return 0;
    80003180:	8a4e                	mv	s4,s3
    80003182:	b7f1                	j	8000314e <namex+0x68>
  len = path - s;
    80003184:	40998633          	sub	a2,s3,s1
    80003188:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000318c:	099c5863          	bge	s8,s9,8000321c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003190:	4639                	li	a2,14
    80003192:	85a6                	mv	a1,s1
    80003194:	8556                	mv	a0,s5
    80003196:	ffffd097          	auipc	ra,0xffffd
    8000319a:	040080e7          	jalr	64(ra) # 800001d6 <memmove>
    8000319e:	84ce                	mv	s1,s3
  while(*path == '/')
    800031a0:	0004c783          	lbu	a5,0(s1)
    800031a4:	01279763          	bne	a5,s2,800031b2 <namex+0xcc>
    path++;
    800031a8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031aa:	0004c783          	lbu	a5,0(s1)
    800031ae:	ff278de3          	beq	a5,s2,800031a8 <namex+0xc2>
    ilock(ip);
    800031b2:	8552                	mv	a0,s4
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	982080e7          	jalr	-1662(ra) # 80002b36 <ilock>
    if(ip->type != T_DIR){
    800031bc:	044a1783          	lh	a5,68(s4)
    800031c0:	f97791e3          	bne	a5,s7,80003142 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031c4:	000b0563          	beqz	s6,800031ce <namex+0xe8>
    800031c8:	0004c783          	lbu	a5,0(s1)
    800031cc:	dfd9                	beqz	a5,8000316a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031ce:	4601                	li	a2,0
    800031d0:	85d6                	mv	a1,s5
    800031d2:	8552                	mv	a0,s4
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	e62080e7          	jalr	-414(ra) # 80003036 <dirlookup>
    800031dc:	89aa                	mv	s3,a0
    800031de:	dd41                	beqz	a0,80003176 <namex+0x90>
    iunlockput(ip);
    800031e0:	8552                	mv	a0,s4
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	bba080e7          	jalr	-1094(ra) # 80002d9c <iunlockput>
    ip = next;
    800031ea:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	01279763          	bne	a5,s2,800031fe <namex+0x118>
    path++;
    800031f4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	ff278de3          	beq	a5,s2,800031f4 <namex+0x10e>
  if(*path == 0)
    800031fe:	cb9d                	beqz	a5,80003234 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003200:	0004c783          	lbu	a5,0(s1)
    80003204:	89a6                	mv	s3,s1
  len = path - s;
    80003206:	4c81                	li	s9,0
    80003208:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000320a:	01278963          	beq	a5,s2,8000321c <namex+0x136>
    8000320e:	dbbd                	beqz	a5,80003184 <namex+0x9e>
    path++;
    80003210:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003212:	0009c783          	lbu	a5,0(s3)
    80003216:	ff279ce3          	bne	a5,s2,8000320e <namex+0x128>
    8000321a:	b7ad                	j	80003184 <namex+0x9e>
    memmove(name, s, len);
    8000321c:	2601                	sext.w	a2,a2
    8000321e:	85a6                	mv	a1,s1
    80003220:	8556                	mv	a0,s5
    80003222:	ffffd097          	auipc	ra,0xffffd
    80003226:	fb4080e7          	jalr	-76(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000322a:	9cd6                	add	s9,s9,s5
    8000322c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003230:	84ce                	mv	s1,s3
    80003232:	b7bd                	j	800031a0 <namex+0xba>
  if(nameiparent){
    80003234:	f00b0de3          	beqz	s6,8000314e <namex+0x68>
    iput(ip);
    80003238:	8552                	mv	a0,s4
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	aba080e7          	jalr	-1350(ra) # 80002cf4 <iput>
    return 0;
    80003242:	4a01                	li	s4,0
    80003244:	b729                	j	8000314e <namex+0x68>

0000000080003246 <dirlink>:
{
    80003246:	7139                	addi	sp,sp,-64
    80003248:	fc06                	sd	ra,56(sp)
    8000324a:	f822                	sd	s0,48(sp)
    8000324c:	f04a                	sd	s2,32(sp)
    8000324e:	ec4e                	sd	s3,24(sp)
    80003250:	e852                	sd	s4,16(sp)
    80003252:	0080                	addi	s0,sp,64
    80003254:	892a                	mv	s2,a0
    80003256:	8a2e                	mv	s4,a1
    80003258:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000325a:	4601                	li	a2,0
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	dda080e7          	jalr	-550(ra) # 80003036 <dirlookup>
    80003264:	ed25                	bnez	a0,800032dc <dirlink+0x96>
    80003266:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003268:	04c92483          	lw	s1,76(s2)
    8000326c:	c49d                	beqz	s1,8000329a <dirlink+0x54>
    8000326e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003270:	4741                	li	a4,16
    80003272:	86a6                	mv	a3,s1
    80003274:	fc040613          	addi	a2,s0,-64
    80003278:	4581                	li	a1,0
    8000327a:	854a                	mv	a0,s2
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	b72080e7          	jalr	-1166(ra) # 80002dee <readi>
    80003284:	47c1                	li	a5,16
    80003286:	06f51163          	bne	a0,a5,800032e8 <dirlink+0xa2>
    if(de.inum == 0)
    8000328a:	fc045783          	lhu	a5,-64(s0)
    8000328e:	c791                	beqz	a5,8000329a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003290:	24c1                	addiw	s1,s1,16
    80003292:	04c92783          	lw	a5,76(s2)
    80003296:	fcf4ede3          	bltu	s1,a5,80003270 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000329a:	4639                	li	a2,14
    8000329c:	85d2                	mv	a1,s4
    8000329e:	fc240513          	addi	a0,s0,-62
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	fde080e7          	jalr	-34(ra) # 80000280 <strncpy>
  de.inum = inum;
    800032aa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ae:	4741                	li	a4,16
    800032b0:	86a6                	mv	a3,s1
    800032b2:	fc040613          	addi	a2,s0,-64
    800032b6:	4581                	li	a1,0
    800032b8:	854a                	mv	a0,s2
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	c38080e7          	jalr	-968(ra) # 80002ef2 <writei>
    800032c2:	872a                	mv	a4,a0
    800032c4:	47c1                	li	a5,16
  return 0;
    800032c6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c8:	02f71863          	bne	a4,a5,800032f8 <dirlink+0xb2>
    800032cc:	74a2                	ld	s1,40(sp)
}
    800032ce:	70e2                	ld	ra,56(sp)
    800032d0:	7442                	ld	s0,48(sp)
    800032d2:	7902                	ld	s2,32(sp)
    800032d4:	69e2                	ld	s3,24(sp)
    800032d6:	6a42                	ld	s4,16(sp)
    800032d8:	6121                	addi	sp,sp,64
    800032da:	8082                	ret
    iput(ip);
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	a18080e7          	jalr	-1512(ra) # 80002cf4 <iput>
    return -1;
    800032e4:	557d                	li	a0,-1
    800032e6:	b7e5                	j	800032ce <dirlink+0x88>
      panic("dirlink read");
    800032e8:	00006517          	auipc	a0,0x6
    800032ec:	1c050513          	addi	a0,a0,448 # 800094a8 <etext+0x4a8>
    800032f0:	00004097          	auipc	ra,0x4
    800032f4:	99c080e7          	jalr	-1636(ra) # 80006c8c <panic>
    panic("dirlink");
    800032f8:	00006517          	auipc	a0,0x6
    800032fc:	2c050513          	addi	a0,a0,704 # 800095b8 <etext+0x5b8>
    80003300:	00004097          	auipc	ra,0x4
    80003304:	98c080e7          	jalr	-1652(ra) # 80006c8c <panic>

0000000080003308 <namei>:

struct inode*
namei(char *path)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003310:	fe040613          	addi	a2,s0,-32
    80003314:	4581                	li	a1,0
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	dd0080e7          	jalr	-560(ra) # 800030e6 <namex>
}
    8000331e:	60e2                	ld	ra,24(sp)
    80003320:	6442                	ld	s0,16(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret

0000000080003326 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003326:	1141                	addi	sp,sp,-16
    80003328:	e406                	sd	ra,8(sp)
    8000332a:	e022                	sd	s0,0(sp)
    8000332c:	0800                	addi	s0,sp,16
    8000332e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003330:	4585                	li	a1,1
    80003332:	00000097          	auipc	ra,0x0
    80003336:	db4080e7          	jalr	-588(ra) # 800030e6 <namex>
}
    8000333a:	60a2                	ld	ra,8(sp)
    8000333c:	6402                	ld	s0,0(sp)
    8000333e:	0141                	addi	sp,sp,16
    80003340:	8082                	ret

0000000080003342 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	e04a                	sd	s2,0(sp)
    8000334c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000334e:	0001a917          	auipc	s2,0x1a
    80003352:	cf290913          	addi	s2,s2,-782 # 8001d040 <log>
    80003356:	01892583          	lw	a1,24(s2)
    8000335a:	02892503          	lw	a0,40(s2)
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	fde080e7          	jalr	-34(ra) # 8000233c <bread>
    80003366:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003368:	02c92603          	lw	a2,44(s2)
    8000336c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000336e:	00c05f63          	blez	a2,8000338c <write_head+0x4a>
    80003372:	0001a717          	auipc	a4,0x1a
    80003376:	cfe70713          	addi	a4,a4,-770 # 8001d070 <log+0x30>
    8000337a:	87aa                	mv	a5,a0
    8000337c:	060a                	slli	a2,a2,0x2
    8000337e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003380:	4314                	lw	a3,0(a4)
    80003382:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003384:	0711                	addi	a4,a4,4
    80003386:	0791                	addi	a5,a5,4
    80003388:	fec79ce3          	bne	a5,a2,80003380 <write_head+0x3e>
  }
  bwrite(buf);
    8000338c:	8526                	mv	a0,s1
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	0a0080e7          	jalr	160(ra) # 8000242e <bwrite>
  brelse(buf);
    80003396:	8526                	mv	a0,s1
    80003398:	fffff097          	auipc	ra,0xfffff
    8000339c:	0d4080e7          	jalr	212(ra) # 8000246c <brelse>
}
    800033a0:	60e2                	ld	ra,24(sp)
    800033a2:	6442                	ld	s0,16(sp)
    800033a4:	64a2                	ld	s1,8(sp)
    800033a6:	6902                	ld	s2,0(sp)
    800033a8:	6105                	addi	sp,sp,32
    800033aa:	8082                	ret

00000000800033ac <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ac:	0001a797          	auipc	a5,0x1a
    800033b0:	cc07a783          	lw	a5,-832(a5) # 8001d06c <log+0x2c>
    800033b4:	0af05d63          	blez	a5,8000346e <install_trans+0xc2>
{
    800033b8:	7139                	addi	sp,sp,-64
    800033ba:	fc06                	sd	ra,56(sp)
    800033bc:	f822                	sd	s0,48(sp)
    800033be:	f426                	sd	s1,40(sp)
    800033c0:	f04a                	sd	s2,32(sp)
    800033c2:	ec4e                	sd	s3,24(sp)
    800033c4:	e852                	sd	s4,16(sp)
    800033c6:	e456                	sd	s5,8(sp)
    800033c8:	e05a                	sd	s6,0(sp)
    800033ca:	0080                	addi	s0,sp,64
    800033cc:	8b2a                	mv	s6,a0
    800033ce:	0001aa97          	auipc	s5,0x1a
    800033d2:	ca2a8a93          	addi	s5,s5,-862 # 8001d070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033d6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033d8:	0001a997          	auipc	s3,0x1a
    800033dc:	c6898993          	addi	s3,s3,-920 # 8001d040 <log>
    800033e0:	a00d                	j	80003402 <install_trans+0x56>
    brelse(lbuf);
    800033e2:	854a                	mv	a0,s2
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	088080e7          	jalr	136(ra) # 8000246c <brelse>
    brelse(dbuf);
    800033ec:	8526                	mv	a0,s1
    800033ee:	fffff097          	auipc	ra,0xfffff
    800033f2:	07e080e7          	jalr	126(ra) # 8000246c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f6:	2a05                	addiw	s4,s4,1
    800033f8:	0a91                	addi	s5,s5,4
    800033fa:	02c9a783          	lw	a5,44(s3)
    800033fe:	04fa5e63          	bge	s4,a5,8000345a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003402:	0189a583          	lw	a1,24(s3)
    80003406:	014585bb          	addw	a1,a1,s4
    8000340a:	2585                	addiw	a1,a1,1
    8000340c:	0289a503          	lw	a0,40(s3)
    80003410:	fffff097          	auipc	ra,0xfffff
    80003414:	f2c080e7          	jalr	-212(ra) # 8000233c <bread>
    80003418:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000341a:	000aa583          	lw	a1,0(s5)
    8000341e:	0289a503          	lw	a0,40(s3)
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	f1a080e7          	jalr	-230(ra) # 8000233c <bread>
    8000342a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000342c:	40000613          	li	a2,1024
    80003430:	05890593          	addi	a1,s2,88
    80003434:	05850513          	addi	a0,a0,88
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	d9e080e7          	jalr	-610(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003440:	8526                	mv	a0,s1
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	fec080e7          	jalr	-20(ra) # 8000242e <bwrite>
    if(recovering == 0)
    8000344a:	f80b1ce3          	bnez	s6,800033e2 <install_trans+0x36>
      bunpin(dbuf);
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	0f4080e7          	jalr	244(ra) # 80002544 <bunpin>
    80003458:	b769                	j	800033e2 <install_trans+0x36>
}
    8000345a:	70e2                	ld	ra,56(sp)
    8000345c:	7442                	ld	s0,48(sp)
    8000345e:	74a2                	ld	s1,40(sp)
    80003460:	7902                	ld	s2,32(sp)
    80003462:	69e2                	ld	s3,24(sp)
    80003464:	6a42                	ld	s4,16(sp)
    80003466:	6aa2                	ld	s5,8(sp)
    80003468:	6b02                	ld	s6,0(sp)
    8000346a:	6121                	addi	sp,sp,64
    8000346c:	8082                	ret
    8000346e:	8082                	ret

0000000080003470 <initlog>:
{
    80003470:	7179                	addi	sp,sp,-48
    80003472:	f406                	sd	ra,40(sp)
    80003474:	f022                	sd	s0,32(sp)
    80003476:	ec26                	sd	s1,24(sp)
    80003478:	e84a                	sd	s2,16(sp)
    8000347a:	e44e                	sd	s3,8(sp)
    8000347c:	1800                	addi	s0,sp,48
    8000347e:	892a                	mv	s2,a0
    80003480:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003482:	0001a497          	auipc	s1,0x1a
    80003486:	bbe48493          	addi	s1,s1,-1090 # 8001d040 <log>
    8000348a:	00006597          	auipc	a1,0x6
    8000348e:	02e58593          	addi	a1,a1,46 # 800094b8 <etext+0x4b8>
    80003492:	8526                	mv	a0,s1
    80003494:	00004097          	auipc	ra,0x4
    80003498:	ce2080e7          	jalr	-798(ra) # 80007176 <initlock>
  log.start = sb->logstart;
    8000349c:	0149a583          	lw	a1,20(s3)
    800034a0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034a2:	0109a783          	lw	a5,16(s3)
    800034a6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034a8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034ac:	854a                	mv	a0,s2
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	e8e080e7          	jalr	-370(ra) # 8000233c <bread>
  log.lh.n = lh->n;
    800034b6:	4d30                	lw	a2,88(a0)
    800034b8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034ba:	00c05f63          	blez	a2,800034d8 <initlog+0x68>
    800034be:	87aa                	mv	a5,a0
    800034c0:	0001a717          	auipc	a4,0x1a
    800034c4:	bb070713          	addi	a4,a4,-1104 # 8001d070 <log+0x30>
    800034c8:	060a                	slli	a2,a2,0x2
    800034ca:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034cc:	4ff4                	lw	a3,92(a5)
    800034ce:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d0:	0791                	addi	a5,a5,4
    800034d2:	0711                	addi	a4,a4,4
    800034d4:	fec79ce3          	bne	a5,a2,800034cc <initlog+0x5c>
  brelse(buf);
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	f94080e7          	jalr	-108(ra) # 8000246c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034e0:	4505                	li	a0,1
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	eca080e7          	jalr	-310(ra) # 800033ac <install_trans>
  log.lh.n = 0;
    800034ea:	0001a797          	auipc	a5,0x1a
    800034ee:	b807a123          	sw	zero,-1150(a5) # 8001d06c <log+0x2c>
  write_head(); // clear the log
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	e50080e7          	jalr	-432(ra) # 80003342 <write_head>
}
    800034fa:	70a2                	ld	ra,40(sp)
    800034fc:	7402                	ld	s0,32(sp)
    800034fe:	64e2                	ld	s1,24(sp)
    80003500:	6942                	ld	s2,16(sp)
    80003502:	69a2                	ld	s3,8(sp)
    80003504:	6145                	addi	sp,sp,48
    80003506:	8082                	ret

0000000080003508 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003508:	1101                	addi	sp,sp,-32
    8000350a:	ec06                	sd	ra,24(sp)
    8000350c:	e822                	sd	s0,16(sp)
    8000350e:	e426                	sd	s1,8(sp)
    80003510:	e04a                	sd	s2,0(sp)
    80003512:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003514:	0001a517          	auipc	a0,0x1a
    80003518:	b2c50513          	addi	a0,a0,-1236 # 8001d040 <log>
    8000351c:	00004097          	auipc	ra,0x4
    80003520:	cea080e7          	jalr	-790(ra) # 80007206 <acquire>
  while(1){
    if(log.committing){
    80003524:	0001a497          	auipc	s1,0x1a
    80003528:	b1c48493          	addi	s1,s1,-1252 # 8001d040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000352c:	4979                	li	s2,30
    8000352e:	a039                	j	8000353c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003530:	85a6                	mv	a1,s1
    80003532:	8526                	mv	a0,s1
    80003534:	ffffe097          	auipc	ra,0xffffe
    80003538:	066080e7          	jalr	102(ra) # 8000159a <sleep>
    if(log.committing){
    8000353c:	50dc                	lw	a5,36(s1)
    8000353e:	fbed                	bnez	a5,80003530 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003540:	5098                	lw	a4,32(s1)
    80003542:	2705                	addiw	a4,a4,1
    80003544:	0027179b          	slliw	a5,a4,0x2
    80003548:	9fb9                	addw	a5,a5,a4
    8000354a:	0017979b          	slliw	a5,a5,0x1
    8000354e:	54d4                	lw	a3,44(s1)
    80003550:	9fb5                	addw	a5,a5,a3
    80003552:	00f95963          	bge	s2,a5,80003564 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003556:	85a6                	mv	a1,s1
    80003558:	8526                	mv	a0,s1
    8000355a:	ffffe097          	auipc	ra,0xffffe
    8000355e:	040080e7          	jalr	64(ra) # 8000159a <sleep>
    80003562:	bfe9                	j	8000353c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003564:	0001a517          	auipc	a0,0x1a
    80003568:	adc50513          	addi	a0,a0,-1316 # 8001d040 <log>
    8000356c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000356e:	00004097          	auipc	ra,0x4
    80003572:	d4c080e7          	jalr	-692(ra) # 800072ba <release>
      break;
    }
  }
}
    80003576:	60e2                	ld	ra,24(sp)
    80003578:	6442                	ld	s0,16(sp)
    8000357a:	64a2                	ld	s1,8(sp)
    8000357c:	6902                	ld	s2,0(sp)
    8000357e:	6105                	addi	sp,sp,32
    80003580:	8082                	ret

0000000080003582 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003582:	7139                	addi	sp,sp,-64
    80003584:	fc06                	sd	ra,56(sp)
    80003586:	f822                	sd	s0,48(sp)
    80003588:	f426                	sd	s1,40(sp)
    8000358a:	f04a                	sd	s2,32(sp)
    8000358c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000358e:	0001a497          	auipc	s1,0x1a
    80003592:	ab248493          	addi	s1,s1,-1358 # 8001d040 <log>
    80003596:	8526                	mv	a0,s1
    80003598:	00004097          	auipc	ra,0x4
    8000359c:	c6e080e7          	jalr	-914(ra) # 80007206 <acquire>
  log.outstanding -= 1;
    800035a0:	509c                	lw	a5,32(s1)
    800035a2:	37fd                	addiw	a5,a5,-1
    800035a4:	0007891b          	sext.w	s2,a5
    800035a8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035aa:	50dc                	lw	a5,36(s1)
    800035ac:	e7b9                	bnez	a5,800035fa <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800035ae:	06091163          	bnez	s2,80003610 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035b2:	0001a497          	auipc	s1,0x1a
    800035b6:	a8e48493          	addi	s1,s1,-1394 # 8001d040 <log>
    800035ba:	4785                	li	a5,1
    800035bc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035be:	8526                	mv	a0,s1
    800035c0:	00004097          	auipc	ra,0x4
    800035c4:	cfa080e7          	jalr	-774(ra) # 800072ba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035c8:	54dc                	lw	a5,44(s1)
    800035ca:	06f04763          	bgtz	a5,80003638 <end_op+0xb6>
    acquire(&log.lock);
    800035ce:	0001a497          	auipc	s1,0x1a
    800035d2:	a7248493          	addi	s1,s1,-1422 # 8001d040 <log>
    800035d6:	8526                	mv	a0,s1
    800035d8:	00004097          	auipc	ra,0x4
    800035dc:	c2e080e7          	jalr	-978(ra) # 80007206 <acquire>
    log.committing = 0;
    800035e0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035e4:	8526                	mv	a0,s1
    800035e6:	ffffe097          	auipc	ra,0xffffe
    800035ea:	140080e7          	jalr	320(ra) # 80001726 <wakeup>
    release(&log.lock);
    800035ee:	8526                	mv	a0,s1
    800035f0:	00004097          	auipc	ra,0x4
    800035f4:	cca080e7          	jalr	-822(ra) # 800072ba <release>
}
    800035f8:	a815                	j	8000362c <end_op+0xaa>
    800035fa:	ec4e                	sd	s3,24(sp)
    800035fc:	e852                	sd	s4,16(sp)
    800035fe:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003600:	00006517          	auipc	a0,0x6
    80003604:	ec050513          	addi	a0,a0,-320 # 800094c0 <etext+0x4c0>
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	684080e7          	jalr	1668(ra) # 80006c8c <panic>
    wakeup(&log);
    80003610:	0001a497          	auipc	s1,0x1a
    80003614:	a3048493          	addi	s1,s1,-1488 # 8001d040 <log>
    80003618:	8526                	mv	a0,s1
    8000361a:	ffffe097          	auipc	ra,0xffffe
    8000361e:	10c080e7          	jalr	268(ra) # 80001726 <wakeup>
  release(&log.lock);
    80003622:	8526                	mv	a0,s1
    80003624:	00004097          	auipc	ra,0x4
    80003628:	c96080e7          	jalr	-874(ra) # 800072ba <release>
}
    8000362c:	70e2                	ld	ra,56(sp)
    8000362e:	7442                	ld	s0,48(sp)
    80003630:	74a2                	ld	s1,40(sp)
    80003632:	7902                	ld	s2,32(sp)
    80003634:	6121                	addi	sp,sp,64
    80003636:	8082                	ret
    80003638:	ec4e                	sd	s3,24(sp)
    8000363a:	e852                	sd	s4,16(sp)
    8000363c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363e:	0001aa97          	auipc	s5,0x1a
    80003642:	a32a8a93          	addi	s5,s5,-1486 # 8001d070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003646:	0001aa17          	auipc	s4,0x1a
    8000364a:	9faa0a13          	addi	s4,s4,-1542 # 8001d040 <log>
    8000364e:	018a2583          	lw	a1,24(s4)
    80003652:	012585bb          	addw	a1,a1,s2
    80003656:	2585                	addiw	a1,a1,1
    80003658:	028a2503          	lw	a0,40(s4)
    8000365c:	fffff097          	auipc	ra,0xfffff
    80003660:	ce0080e7          	jalr	-800(ra) # 8000233c <bread>
    80003664:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003666:	000aa583          	lw	a1,0(s5)
    8000366a:	028a2503          	lw	a0,40(s4)
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	cce080e7          	jalr	-818(ra) # 8000233c <bread>
    80003676:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003678:	40000613          	li	a2,1024
    8000367c:	05850593          	addi	a1,a0,88
    80003680:	05848513          	addi	a0,s1,88
    80003684:	ffffd097          	auipc	ra,0xffffd
    80003688:	b52080e7          	jalr	-1198(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000368c:	8526                	mv	a0,s1
    8000368e:	fffff097          	auipc	ra,0xfffff
    80003692:	da0080e7          	jalr	-608(ra) # 8000242e <bwrite>
    brelse(from);
    80003696:	854e                	mv	a0,s3
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	dd4080e7          	jalr	-556(ra) # 8000246c <brelse>
    brelse(to);
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	dca080e7          	jalr	-566(ra) # 8000246c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036aa:	2905                	addiw	s2,s2,1
    800036ac:	0a91                	addi	s5,s5,4
    800036ae:	02ca2783          	lw	a5,44(s4)
    800036b2:	f8f94ee3          	blt	s2,a5,8000364e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036b6:	00000097          	auipc	ra,0x0
    800036ba:	c8c080e7          	jalr	-884(ra) # 80003342 <write_head>
    install_trans(0); // Now install writes to home locations
    800036be:	4501                	li	a0,0
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	cec080e7          	jalr	-788(ra) # 800033ac <install_trans>
    log.lh.n = 0;
    800036c8:	0001a797          	auipc	a5,0x1a
    800036cc:	9a07a223          	sw	zero,-1628(a5) # 8001d06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036d0:	00000097          	auipc	ra,0x0
    800036d4:	c72080e7          	jalr	-910(ra) # 80003342 <write_head>
    800036d8:	69e2                	ld	s3,24(sp)
    800036da:	6a42                	ld	s4,16(sp)
    800036dc:	6aa2                	ld	s5,8(sp)
    800036de:	bdc5                	j	800035ce <end_op+0x4c>

00000000800036e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036e0:	1101                	addi	sp,sp,-32
    800036e2:	ec06                	sd	ra,24(sp)
    800036e4:	e822                	sd	s0,16(sp)
    800036e6:	e426                	sd	s1,8(sp)
    800036e8:	e04a                	sd	s2,0(sp)
    800036ea:	1000                	addi	s0,sp,32
    800036ec:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036ee:	0001a917          	auipc	s2,0x1a
    800036f2:	95290913          	addi	s2,s2,-1710 # 8001d040 <log>
    800036f6:	854a                	mv	a0,s2
    800036f8:	00004097          	auipc	ra,0x4
    800036fc:	b0e080e7          	jalr	-1266(ra) # 80007206 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003700:	02c92603          	lw	a2,44(s2)
    80003704:	47f5                	li	a5,29
    80003706:	06c7c563          	blt	a5,a2,80003770 <log_write+0x90>
    8000370a:	0001a797          	auipc	a5,0x1a
    8000370e:	9527a783          	lw	a5,-1710(a5) # 8001d05c <log+0x1c>
    80003712:	37fd                	addiw	a5,a5,-1
    80003714:	04f65e63          	bge	a2,a5,80003770 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003718:	0001a797          	auipc	a5,0x1a
    8000371c:	9487a783          	lw	a5,-1720(a5) # 8001d060 <log+0x20>
    80003720:	06f05063          	blez	a5,80003780 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003724:	4781                	li	a5,0
    80003726:	06c05563          	blez	a2,80003790 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000372a:	44cc                	lw	a1,12(s1)
    8000372c:	0001a717          	auipc	a4,0x1a
    80003730:	94470713          	addi	a4,a4,-1724 # 8001d070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003734:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003736:	4314                	lw	a3,0(a4)
    80003738:	04b68c63          	beq	a3,a1,80003790 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000373c:	2785                	addiw	a5,a5,1
    8000373e:	0711                	addi	a4,a4,4
    80003740:	fef61be3          	bne	a2,a5,80003736 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003744:	0621                	addi	a2,a2,8
    80003746:	060a                	slli	a2,a2,0x2
    80003748:	0001a797          	auipc	a5,0x1a
    8000374c:	8f878793          	addi	a5,a5,-1800 # 8001d040 <log>
    80003750:	97b2                	add	a5,a5,a2
    80003752:	44d8                	lw	a4,12(s1)
    80003754:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003756:	8526                	mv	a0,s1
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	db0080e7          	jalr	-592(ra) # 80002508 <bpin>
    log.lh.n++;
    80003760:	0001a717          	auipc	a4,0x1a
    80003764:	8e070713          	addi	a4,a4,-1824 # 8001d040 <log>
    80003768:	575c                	lw	a5,44(a4)
    8000376a:	2785                	addiw	a5,a5,1
    8000376c:	d75c                	sw	a5,44(a4)
    8000376e:	a82d                	j	800037a8 <log_write+0xc8>
    panic("too big a transaction");
    80003770:	00006517          	auipc	a0,0x6
    80003774:	d6050513          	addi	a0,a0,-672 # 800094d0 <etext+0x4d0>
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	514080e7          	jalr	1300(ra) # 80006c8c <panic>
    panic("log_write outside of trans");
    80003780:	00006517          	auipc	a0,0x6
    80003784:	d6850513          	addi	a0,a0,-664 # 800094e8 <etext+0x4e8>
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	504080e7          	jalr	1284(ra) # 80006c8c <panic>
  log.lh.block[i] = b->blockno;
    80003790:	00878693          	addi	a3,a5,8
    80003794:	068a                	slli	a3,a3,0x2
    80003796:	0001a717          	auipc	a4,0x1a
    8000379a:	8aa70713          	addi	a4,a4,-1878 # 8001d040 <log>
    8000379e:	9736                	add	a4,a4,a3
    800037a0:	44d4                	lw	a3,12(s1)
    800037a2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037a4:	faf609e3          	beq	a2,a5,80003756 <log_write+0x76>
  }
  release(&log.lock);
    800037a8:	0001a517          	auipc	a0,0x1a
    800037ac:	89850513          	addi	a0,a0,-1896 # 8001d040 <log>
    800037b0:	00004097          	auipc	ra,0x4
    800037b4:	b0a080e7          	jalr	-1270(ra) # 800072ba <release>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret

00000000800037c4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	e04a                	sd	s2,0(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
    800037d2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037d4:	00006597          	auipc	a1,0x6
    800037d8:	d3458593          	addi	a1,a1,-716 # 80009508 <etext+0x508>
    800037dc:	0521                	addi	a0,a0,8
    800037de:	00004097          	auipc	ra,0x4
    800037e2:	998080e7          	jalr	-1640(ra) # 80007176 <initlock>
  lk->name = name;
    800037e6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037ea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037ee:	0204a423          	sw	zero,40(s1)
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6902                	ld	s2,0(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	e426                	sd	s1,8(sp)
    80003806:	e04a                	sd	s2,0(sp)
    80003808:	1000                	addi	s0,sp,32
    8000380a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000380c:	00850913          	addi	s2,a0,8
    80003810:	854a                	mv	a0,s2
    80003812:	00004097          	auipc	ra,0x4
    80003816:	9f4080e7          	jalr	-1548(ra) # 80007206 <acquire>
  while (lk->locked) {
    8000381a:	409c                	lw	a5,0(s1)
    8000381c:	cb89                	beqz	a5,8000382e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000381e:	85ca                	mv	a1,s2
    80003820:	8526                	mv	a0,s1
    80003822:	ffffe097          	auipc	ra,0xffffe
    80003826:	d78080e7          	jalr	-648(ra) # 8000159a <sleep>
  while (lk->locked) {
    8000382a:	409c                	lw	a5,0(s1)
    8000382c:	fbed                	bnez	a5,8000381e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000382e:	4785                	li	a5,1
    80003830:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	6a2080e7          	jalr	1698(ra) # 80000ed4 <myproc>
    8000383a:	591c                	lw	a5,48(a0)
    8000383c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000383e:	854a                	mv	a0,s2
    80003840:	00004097          	auipc	ra,0x4
    80003844:	a7a080e7          	jalr	-1414(ra) # 800072ba <release>
}
    80003848:	60e2                	ld	ra,24(sp)
    8000384a:	6442                	ld	s0,16(sp)
    8000384c:	64a2                	ld	s1,8(sp)
    8000384e:	6902                	ld	s2,0(sp)
    80003850:	6105                	addi	sp,sp,32
    80003852:	8082                	ret

0000000080003854 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
    80003860:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003862:	00850913          	addi	s2,a0,8
    80003866:	854a                	mv	a0,s2
    80003868:	00004097          	auipc	ra,0x4
    8000386c:	99e080e7          	jalr	-1634(ra) # 80007206 <acquire>
  lk->locked = 0;
    80003870:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003874:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003878:	8526                	mv	a0,s1
    8000387a:	ffffe097          	auipc	ra,0xffffe
    8000387e:	eac080e7          	jalr	-340(ra) # 80001726 <wakeup>
  release(&lk->lk);
    80003882:	854a                	mv	a0,s2
    80003884:	00004097          	auipc	ra,0x4
    80003888:	a36080e7          	jalr	-1482(ra) # 800072ba <release>
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6902                	ld	s2,0(sp)
    80003894:	6105                	addi	sp,sp,32
    80003896:	8082                	ret

0000000080003898 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003898:	7179                	addi	sp,sp,-48
    8000389a:	f406                	sd	ra,40(sp)
    8000389c:	f022                	sd	s0,32(sp)
    8000389e:	ec26                	sd	s1,24(sp)
    800038a0:	e84a                	sd	s2,16(sp)
    800038a2:	1800                	addi	s0,sp,48
    800038a4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038a6:	00850913          	addi	s2,a0,8
    800038aa:	854a                	mv	a0,s2
    800038ac:	00004097          	auipc	ra,0x4
    800038b0:	95a080e7          	jalr	-1702(ra) # 80007206 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b4:	409c                	lw	a5,0(s1)
    800038b6:	ef91                	bnez	a5,800038d2 <holdingsleep+0x3a>
    800038b8:	4481                	li	s1,0
  release(&lk->lk);
    800038ba:	854a                	mv	a0,s2
    800038bc:	00004097          	auipc	ra,0x4
    800038c0:	9fe080e7          	jalr	-1538(ra) # 800072ba <release>
  return r;
}
    800038c4:	8526                	mv	a0,s1
    800038c6:	70a2                	ld	ra,40(sp)
    800038c8:	7402                	ld	s0,32(sp)
    800038ca:	64e2                	ld	s1,24(sp)
    800038cc:	6942                	ld	s2,16(sp)
    800038ce:	6145                	addi	sp,sp,48
    800038d0:	8082                	ret
    800038d2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d4:	0284a983          	lw	s3,40(s1)
    800038d8:	ffffd097          	auipc	ra,0xffffd
    800038dc:	5fc080e7          	jalr	1532(ra) # 80000ed4 <myproc>
    800038e0:	5904                	lw	s1,48(a0)
    800038e2:	413484b3          	sub	s1,s1,s3
    800038e6:	0014b493          	seqz	s1,s1
    800038ea:	69a2                	ld	s3,8(sp)
    800038ec:	b7f9                	j	800038ba <holdingsleep+0x22>

00000000800038ee <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038ee:	1141                	addi	sp,sp,-16
    800038f0:	e406                	sd	ra,8(sp)
    800038f2:	e022                	sd	s0,0(sp)
    800038f4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038f6:	00006597          	auipc	a1,0x6
    800038fa:	c2258593          	addi	a1,a1,-990 # 80009518 <etext+0x518>
    800038fe:	0001a517          	auipc	a0,0x1a
    80003902:	88a50513          	addi	a0,a0,-1910 # 8001d188 <ftable>
    80003906:	00004097          	auipc	ra,0x4
    8000390a:	870080e7          	jalr	-1936(ra) # 80007176 <initlock>
}
    8000390e:	60a2                	ld	ra,8(sp)
    80003910:	6402                	ld	s0,0(sp)
    80003912:	0141                	addi	sp,sp,16
    80003914:	8082                	ret

0000000080003916 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003916:	1101                	addi	sp,sp,-32
    80003918:	ec06                	sd	ra,24(sp)
    8000391a:	e822                	sd	s0,16(sp)
    8000391c:	e426                	sd	s1,8(sp)
    8000391e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003920:	0001a517          	auipc	a0,0x1a
    80003924:	86850513          	addi	a0,a0,-1944 # 8001d188 <ftable>
    80003928:	00004097          	auipc	ra,0x4
    8000392c:	8de080e7          	jalr	-1826(ra) # 80007206 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003930:	0001a497          	auipc	s1,0x1a
    80003934:	87048493          	addi	s1,s1,-1936 # 8001d1a0 <ftable+0x18>
    80003938:	0001b717          	auipc	a4,0x1b
    8000393c:	b2870713          	addi	a4,a4,-1240 # 8001e460 <ftable+0x12d8>
    if(f->ref == 0){
    80003940:	40dc                	lw	a5,4(s1)
    80003942:	cf99                	beqz	a5,80003960 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003944:	03048493          	addi	s1,s1,48
    80003948:	fee49ce3          	bne	s1,a4,80003940 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000394c:	0001a517          	auipc	a0,0x1a
    80003950:	83c50513          	addi	a0,a0,-1988 # 8001d188 <ftable>
    80003954:	00004097          	auipc	ra,0x4
    80003958:	966080e7          	jalr	-1690(ra) # 800072ba <release>
  return 0;
    8000395c:	4481                	li	s1,0
    8000395e:	a819                	j	80003974 <filealloc+0x5e>
      f->ref = 1;
    80003960:	4785                	li	a5,1
    80003962:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003964:	0001a517          	auipc	a0,0x1a
    80003968:	82450513          	addi	a0,a0,-2012 # 8001d188 <ftable>
    8000396c:	00004097          	auipc	ra,0x4
    80003970:	94e080e7          	jalr	-1714(ra) # 800072ba <release>
}
    80003974:	8526                	mv	a0,s1
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6105                	addi	sp,sp,32
    8000397e:	8082                	ret

0000000080003980 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000398c:	00019517          	auipc	a0,0x19
    80003990:	7fc50513          	addi	a0,a0,2044 # 8001d188 <ftable>
    80003994:	00004097          	auipc	ra,0x4
    80003998:	872080e7          	jalr	-1934(ra) # 80007206 <acquire>
  if(f->ref < 1)
    8000399c:	40dc                	lw	a5,4(s1)
    8000399e:	02f05263          	blez	a5,800039c2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039a2:	2785                	addiw	a5,a5,1
    800039a4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039a6:	00019517          	auipc	a0,0x19
    800039aa:	7e250513          	addi	a0,a0,2018 # 8001d188 <ftable>
    800039ae:	00004097          	auipc	ra,0x4
    800039b2:	90c080e7          	jalr	-1780(ra) # 800072ba <release>
  return f;
}
    800039b6:	8526                	mv	a0,s1
    800039b8:	60e2                	ld	ra,24(sp)
    800039ba:	6442                	ld	s0,16(sp)
    800039bc:	64a2                	ld	s1,8(sp)
    800039be:	6105                	addi	sp,sp,32
    800039c0:	8082                	ret
    panic("filedup");
    800039c2:	00006517          	auipc	a0,0x6
    800039c6:	b5e50513          	addi	a0,a0,-1186 # 80009520 <etext+0x520>
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	2c2080e7          	jalr	706(ra) # 80006c8c <panic>

00000000800039d2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039d2:	7139                	addi	sp,sp,-64
    800039d4:	fc06                	sd	ra,56(sp)
    800039d6:	f822                	sd	s0,48(sp)
    800039d8:	f426                	sd	s1,40(sp)
    800039da:	0080                	addi	s0,sp,64
    800039dc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039de:	00019517          	auipc	a0,0x19
    800039e2:	7aa50513          	addi	a0,a0,1962 # 8001d188 <ftable>
    800039e6:	00004097          	auipc	ra,0x4
    800039ea:	820080e7          	jalr	-2016(ra) # 80007206 <acquire>
  if(f->ref < 1)
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	06f05463          	blez	a5,80003a58 <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039f4:	37fd                	addiw	a5,a5,-1
    800039f6:	0007871b          	sext.w	a4,a5
    800039fa:	c0dc                	sw	a5,4(s1)
    800039fc:	06e04b63          	bgtz	a4,80003a72 <fileclose+0xa0>
    80003a00:	f04a                	sd	s2,32(sp)
    80003a02:	ec4e                	sd	s3,24(sp)
    80003a04:	e852                	sd	s4,16(sp)
    80003a06:	e456                	sd	s5,8(sp)
    80003a08:	e05a                	sd	s6,0(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a0a:	0004a903          	lw	s2,0(s1)
    80003a0e:	0094ca83          	lbu	s5,9(s1)
    80003a12:	0104ba03          	ld	s4,16(s1)
    80003a16:	0184b983          	ld	s3,24(s1)
    80003a1a:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    80003a1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a26:	00019517          	auipc	a0,0x19
    80003a2a:	76250513          	addi	a0,a0,1890 # 8001d188 <ftable>
    80003a2e:	00004097          	auipc	ra,0x4
    80003a32:	88c080e7          	jalr	-1908(ra) # 800072ba <release>

  if(ff.type == FD_PIPE){
    80003a36:	4785                	li	a5,1
    80003a38:	04f90a63          	beq	s2,a5,80003a8c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a3c:	ffe9079b          	addiw	a5,s2,-2
    80003a40:	4705                	li	a4,1
    80003a42:	06f77163          	bgeu	a4,a5,80003aa4 <fileclose+0xd2>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a46:	4791                	li	a5,4
    80003a48:	08f90163          	beq	s2,a5,80003aca <fileclose+0xf8>
    80003a4c:	7902                	ld	s2,32(sp)
    80003a4e:	69e2                	ld	s3,24(sp)
    80003a50:	6a42                	ld	s4,16(sp)
    80003a52:	6aa2                	ld	s5,8(sp)
    80003a54:	6b02                	ld	s6,0(sp)
    80003a56:	a035                	j	80003a82 <fileclose+0xb0>
    80003a58:	f04a                	sd	s2,32(sp)
    80003a5a:	ec4e                	sd	s3,24(sp)
    80003a5c:	e852                	sd	s4,16(sp)
    80003a5e:	e456                	sd	s5,8(sp)
    80003a60:	e05a                	sd	s6,0(sp)
    panic("fileclose");
    80003a62:	00006517          	auipc	a0,0x6
    80003a66:	ac650513          	addi	a0,a0,-1338 # 80009528 <etext+0x528>
    80003a6a:	00003097          	auipc	ra,0x3
    80003a6e:	222080e7          	jalr	546(ra) # 80006c8c <panic>
    release(&ftable.lock);
    80003a72:	00019517          	auipc	a0,0x19
    80003a76:	71650513          	addi	a0,a0,1814 # 8001d188 <ftable>
    80003a7a:	00004097          	auipc	ra,0x4
    80003a7e:	840080e7          	jalr	-1984(ra) # 800072ba <release>
    sockclose(ff.sock);
  }
#endif
}
    80003a82:	70e2                	ld	ra,56(sp)
    80003a84:	7442                	ld	s0,48(sp)
    80003a86:	74a2                	ld	s1,40(sp)
    80003a88:	6121                	addi	sp,sp,64
    80003a8a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a8c:	85d6                	mv	a1,s5
    80003a8e:	8552                	mv	a0,s4
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	3da080e7          	jalr	986(ra) # 80003e6a <pipeclose>
    80003a98:	7902                	ld	s2,32(sp)
    80003a9a:	69e2                	ld	s3,24(sp)
    80003a9c:	6a42                	ld	s4,16(sp)
    80003a9e:	6aa2                	ld	s5,8(sp)
    80003aa0:	6b02                	ld	s6,0(sp)
    80003aa2:	b7c5                	j	80003a82 <fileclose+0xb0>
    begin_op();
    80003aa4:	00000097          	auipc	ra,0x0
    80003aa8:	a64080e7          	jalr	-1436(ra) # 80003508 <begin_op>
    iput(ff.ip);
    80003aac:	854e                	mv	a0,s3
    80003aae:	fffff097          	auipc	ra,0xfffff
    80003ab2:	246080e7          	jalr	582(ra) # 80002cf4 <iput>
    end_op();
    80003ab6:	00000097          	auipc	ra,0x0
    80003aba:	acc080e7          	jalr	-1332(ra) # 80003582 <end_op>
    80003abe:	7902                	ld	s2,32(sp)
    80003ac0:	69e2                	ld	s3,24(sp)
    80003ac2:	6a42                	ld	s4,16(sp)
    80003ac4:	6aa2                	ld	s5,8(sp)
    80003ac6:	6b02                	ld	s6,0(sp)
    80003ac8:	bf6d                	j	80003a82 <fileclose+0xb0>
    sockclose(ff.sock);
    80003aca:	855a                	mv	a0,s6
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	936080e7          	jalr	-1738(ra) # 80006402 <sockclose>
    80003ad4:	7902                	ld	s2,32(sp)
    80003ad6:	69e2                	ld	s3,24(sp)
    80003ad8:	6a42                	ld	s4,16(sp)
    80003ada:	6aa2                	ld	s5,8(sp)
    80003adc:	6b02                	ld	s6,0(sp)
    80003ade:	b755                	j	80003a82 <fileclose+0xb0>

0000000080003ae0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ae0:	715d                	addi	sp,sp,-80
    80003ae2:	e486                	sd	ra,72(sp)
    80003ae4:	e0a2                	sd	s0,64(sp)
    80003ae6:	fc26                	sd	s1,56(sp)
    80003ae8:	f44e                	sd	s3,40(sp)
    80003aea:	0880                	addi	s0,sp,80
    80003aec:	84aa                	mv	s1,a0
    80003aee:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003af0:	ffffd097          	auipc	ra,0xffffd
    80003af4:	3e4080e7          	jalr	996(ra) # 80000ed4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003af8:	409c                	lw	a5,0(s1)
    80003afa:	37f9                	addiw	a5,a5,-2
    80003afc:	4705                	li	a4,1
    80003afe:	04f76863          	bltu	a4,a5,80003b4e <filestat+0x6e>
    80003b02:	f84a                	sd	s2,48(sp)
    80003b04:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b06:	6c88                	ld	a0,24(s1)
    80003b08:	fffff097          	auipc	ra,0xfffff
    80003b0c:	02e080e7          	jalr	46(ra) # 80002b36 <ilock>
    stati(f->ip, &st);
    80003b10:	fb840593          	addi	a1,s0,-72
    80003b14:	6c88                	ld	a0,24(s1)
    80003b16:	fffff097          	auipc	ra,0xfffff
    80003b1a:	2ae080e7          	jalr	686(ra) # 80002dc4 <stati>
    iunlock(f->ip);
    80003b1e:	6c88                	ld	a0,24(s1)
    80003b20:	fffff097          	auipc	ra,0xfffff
    80003b24:	0dc080e7          	jalr	220(ra) # 80002bfc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b28:	46e1                	li	a3,24
    80003b2a:	fb840613          	addi	a2,s0,-72
    80003b2e:	85ce                	mv	a1,s3
    80003b30:	05093503          	ld	a0,80(s2)
    80003b34:	ffffd097          	auipc	ra,0xffffd
    80003b38:	040080e7          	jalr	64(ra) # 80000b74 <copyout>
    80003b3c:	41f5551b          	sraiw	a0,a0,0x1f
    80003b40:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b42:	60a6                	ld	ra,72(sp)
    80003b44:	6406                	ld	s0,64(sp)
    80003b46:	74e2                	ld	s1,56(sp)
    80003b48:	79a2                	ld	s3,40(sp)
    80003b4a:	6161                	addi	sp,sp,80
    80003b4c:	8082                	ret
  return -1;
    80003b4e:	557d                	li	a0,-1
    80003b50:	bfcd                	j	80003b42 <filestat+0x62>

0000000080003b52 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b52:	7179                	addi	sp,sp,-48
    80003b54:	f406                	sd	ra,40(sp)
    80003b56:	f022                	sd	s0,32(sp)
    80003b58:	e84a                	sd	s2,16(sp)
    80003b5a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b5c:	00854783          	lbu	a5,8(a0)
    80003b60:	c7e1                	beqz	a5,80003c28 <fileread+0xd6>
    80003b62:	ec26                	sd	s1,24(sp)
    80003b64:	e44e                	sd	s3,8(sp)
    80003b66:	84aa                	mv	s1,a0
    80003b68:	89ae                	mv	s3,a1
    80003b6a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b6c:	411c                	lw	a5,0(a0)
    80003b6e:	4705                	li	a4,1
    80003b70:	02e78963          	beq	a5,a4,80003ba2 <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b74:	470d                	li	a4,3
    80003b76:	02e78f63          	beq	a5,a4,80003bb4 <fileread+0x62>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b7a:	4709                	li	a4,2
    80003b7c:	06e78263          	beq	a5,a4,80003be0 <fileread+0x8e>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b80:	4711                	li	a4,4
    80003b82:	08e79b63          	bne	a5,a4,80003c18 <fileread+0xc6>
    r = sockread(f->sock, addr, n);
    80003b86:	7108                	ld	a0,32(a0)
    80003b88:	00003097          	auipc	ra,0x3
    80003b8c:	90a080e7          	jalr	-1782(ra) # 80006492 <sockread>
    80003b90:	892a                	mv	s2,a0
    80003b92:	64e2                	ld	s1,24(sp)
    80003b94:	69a2                	ld	s3,8(sp)
  else {
    panic("fileread");
  }

  return r;
}
    80003b96:	854a                	mv	a0,s2
    80003b98:	70a2                	ld	ra,40(sp)
    80003b9a:	7402                	ld	s0,32(sp)
    80003b9c:	6942                	ld	s2,16(sp)
    80003b9e:	6145                	addi	sp,sp,48
    80003ba0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ba2:	6908                	ld	a0,16(a0)
    80003ba4:	00000097          	auipc	ra,0x0
    80003ba8:	438080e7          	jalr	1080(ra) # 80003fdc <piperead>
    80003bac:	892a                	mv	s2,a0
    80003bae:	64e2                	ld	s1,24(sp)
    80003bb0:	69a2                	ld	s3,8(sp)
    80003bb2:	b7d5                	j	80003b96 <fileread+0x44>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bb4:	02c51783          	lh	a5,44(a0)
    80003bb8:	03079693          	slli	a3,a5,0x30
    80003bbc:	92c1                	srli	a3,a3,0x30
    80003bbe:	4725                	li	a4,9
    80003bc0:	06d76663          	bltu	a4,a3,80003c2c <fileread+0xda>
    80003bc4:	0792                	slli	a5,a5,0x4
    80003bc6:	00019717          	auipc	a4,0x19
    80003bca:	52270713          	addi	a4,a4,1314 # 8001d0e8 <devsw>
    80003bce:	97ba                	add	a5,a5,a4
    80003bd0:	639c                	ld	a5,0(a5)
    80003bd2:	c3ad                	beqz	a5,80003c34 <fileread+0xe2>
    r = devsw[f->major].read(1, addr, n);
    80003bd4:	4505                	li	a0,1
    80003bd6:	9782                	jalr	a5
    80003bd8:	892a                	mv	s2,a0
    80003bda:	64e2                	ld	s1,24(sp)
    80003bdc:	69a2                	ld	s3,8(sp)
    80003bde:	bf65                	j	80003b96 <fileread+0x44>
    ilock(f->ip);
    80003be0:	6d08                	ld	a0,24(a0)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	f54080e7          	jalr	-172(ra) # 80002b36 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bea:	874a                	mv	a4,s2
    80003bec:	5494                	lw	a3,40(s1)
    80003bee:	864e                	mv	a2,s3
    80003bf0:	4585                	li	a1,1
    80003bf2:	6c88                	ld	a0,24(s1)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	1fa080e7          	jalr	506(ra) # 80002dee <readi>
    80003bfc:	892a                	mv	s2,a0
    80003bfe:	00a05563          	blez	a0,80003c08 <fileread+0xb6>
      f->off += r;
    80003c02:	549c                	lw	a5,40(s1)
    80003c04:	9fa9                	addw	a5,a5,a0
    80003c06:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003c08:	6c88                	ld	a0,24(s1)
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	ff2080e7          	jalr	-14(ra) # 80002bfc <iunlock>
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	69a2                	ld	s3,8(sp)
    80003c16:	b741                	j	80003b96 <fileread+0x44>
    panic("fileread");
    80003c18:	00006517          	auipc	a0,0x6
    80003c1c:	92050513          	addi	a0,a0,-1760 # 80009538 <etext+0x538>
    80003c20:	00003097          	auipc	ra,0x3
    80003c24:	06c080e7          	jalr	108(ra) # 80006c8c <panic>
    return -1;
    80003c28:	597d                	li	s2,-1
    80003c2a:	b7b5                	j	80003b96 <fileread+0x44>
      return -1;
    80003c2c:	597d                	li	s2,-1
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	69a2                	ld	s3,8(sp)
    80003c32:	b795                	j	80003b96 <fileread+0x44>
    80003c34:	597d                	li	s2,-1
    80003c36:	64e2                	ld	s1,24(sp)
    80003c38:	69a2                	ld	s3,8(sp)
    80003c3a:	bfb1                	j	80003b96 <fileread+0x44>

0000000080003c3c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c3c:	00954783          	lbu	a5,9(a0)
    80003c40:	12078c63          	beqz	a5,80003d78 <filewrite+0x13c>
{
    80003c44:	715d                	addi	sp,sp,-80
    80003c46:	e486                	sd	ra,72(sp)
    80003c48:	e0a2                	sd	s0,64(sp)
    80003c4a:	fc26                	sd	s1,56(sp)
    80003c4c:	f84a                	sd	s2,48(sp)
    80003c4e:	ec56                	sd	s5,24(sp)
    80003c50:	0880                	addi	s0,sp,80
    80003c52:	84aa                	mv	s1,a0
    80003c54:	8aae                	mv	s5,a1
    80003c56:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c58:	411c                	lw	a5,0(a0)
    80003c5a:	4705                	li	a4,1
    80003c5c:	02e78763          	beq	a5,a4,80003c8a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c60:	470d                	li	a4,3
    80003c62:	02e78a63          	beq	a5,a4,80003c96 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c66:	4709                	li	a4,2
    80003c68:	04e78a63          	beq	a5,a4,80003cbc <filewrite+0x80>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003c6c:	4711                	li	a4,4
    80003c6e:	0ee79863          	bne	a5,a4,80003d5e <filewrite+0x122>
    ret = sockwrite(f->sock, addr, n);
    80003c72:	7108                	ld	a0,32(a0)
    80003c74:	00003097          	auipc	ra,0x3
    80003c78:	8f0080e7          	jalr	-1808(ra) # 80006564 <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c7c:	60a6                	ld	ra,72(sp)
    80003c7e:	6406                	ld	s0,64(sp)
    80003c80:	74e2                	ld	s1,56(sp)
    80003c82:	7942                	ld	s2,48(sp)
    80003c84:	6ae2                	ld	s5,24(sp)
    80003c86:	6161                	addi	sp,sp,80
    80003c88:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c8a:	6908                	ld	a0,16(a0)
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	24e080e7          	jalr	590(ra) # 80003eda <pipewrite>
    80003c94:	b7e5                	j	80003c7c <filewrite+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c96:	02c51783          	lh	a5,44(a0)
    80003c9a:	03079693          	slli	a3,a5,0x30
    80003c9e:	92c1                	srli	a3,a3,0x30
    80003ca0:	4725                	li	a4,9
    80003ca2:	0cd76d63          	bltu	a4,a3,80003d7c <filewrite+0x140>
    80003ca6:	0792                	slli	a5,a5,0x4
    80003ca8:	00019717          	auipc	a4,0x19
    80003cac:	44070713          	addi	a4,a4,1088 # 8001d0e8 <devsw>
    80003cb0:	97ba                	add	a5,a5,a4
    80003cb2:	679c                	ld	a5,8(a5)
    80003cb4:	c7f1                	beqz	a5,80003d80 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003cb6:	4505                	li	a0,1
    80003cb8:	9782                	jalr	a5
    80003cba:	b7c9                	j	80003c7c <filewrite+0x40>
    80003cbc:	f052                	sd	s4,32(sp)
    while(i < n){
    80003cbe:	08c05563          	blez	a2,80003d48 <filewrite+0x10c>
    80003cc2:	f44e                	sd	s3,40(sp)
    80003cc4:	e85a                	sd	s6,16(sp)
    80003cc6:	e45e                	sd	s7,8(sp)
    80003cc8:	e062                	sd	s8,0(sp)
    int i = 0;
    80003cca:	4a01                	li	s4,0
      if(n1 > max)
    80003ccc:	6b85                	lui	s7,0x1
    80003cce:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cd2:	6c05                	lui	s8,0x1
    80003cd4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cd8:	a899                	j	80003d2e <filewrite+0xf2>
    80003cda:	00098b1b          	sext.w	s6,s3
      begin_op();
    80003cde:	00000097          	auipc	ra,0x0
    80003ce2:	82a080e7          	jalr	-2006(ra) # 80003508 <begin_op>
      ilock(f->ip);
    80003ce6:	6c88                	ld	a0,24(s1)
    80003ce8:	fffff097          	auipc	ra,0xfffff
    80003cec:	e4e080e7          	jalr	-434(ra) # 80002b36 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf0:	875a                	mv	a4,s6
    80003cf2:	5494                	lw	a3,40(s1)
    80003cf4:	015a0633          	add	a2,s4,s5
    80003cf8:	4585                	li	a1,1
    80003cfa:	6c88                	ld	a0,24(s1)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	1f6080e7          	jalr	502(ra) # 80002ef2 <writei>
    80003d04:	89aa                	mv	s3,a0
    80003d06:	00a05563          	blez	a0,80003d10 <filewrite+0xd4>
        f->off += r;
    80003d0a:	549c                	lw	a5,40(s1)
    80003d0c:	9fa9                	addw	a5,a5,a0
    80003d0e:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003d10:	6c88                	ld	a0,24(s1)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	eea080e7          	jalr	-278(ra) # 80002bfc <iunlock>
      end_op();
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	868080e7          	jalr	-1944(ra) # 80003582 <end_op>
      if(r != n1){
    80003d22:	033b1563          	bne	s6,s3,80003d4c <filewrite+0x110>
      i += r;
    80003d26:	01498a3b          	addw	s4,s3,s4
    while(i < n){
    80003d2a:	012a5a63          	bge	s4,s2,80003d3e <filewrite+0x102>
      int n1 = n - i;
    80003d2e:	414909bb          	subw	s3,s2,s4
      if(n1 > max)
    80003d32:	0009879b          	sext.w	a5,s3
    80003d36:	fafbd2e3          	bge	s7,a5,80003cda <filewrite+0x9e>
    80003d3a:	89e2                	mv	s3,s8
    80003d3c:	bf79                	j	80003cda <filewrite+0x9e>
    80003d3e:	79a2                	ld	s3,40(sp)
    80003d40:	6b42                	ld	s6,16(sp)
    80003d42:	6ba2                	ld	s7,8(sp)
    80003d44:	6c02                	ld	s8,0(sp)
    80003d46:	a039                	j	80003d54 <filewrite+0x118>
    int i = 0;
    80003d48:	4a01                	li	s4,0
    80003d4a:	a029                	j	80003d54 <filewrite+0x118>
    80003d4c:	79a2                	ld	s3,40(sp)
    80003d4e:	6b42                	ld	s6,16(sp)
    80003d50:	6ba2                	ld	s7,8(sp)
    80003d52:	6c02                	ld	s8,0(sp)
    ret = (i == n ? n : -1);
    80003d54:	03491863          	bne	s2,s4,80003d84 <filewrite+0x148>
    80003d58:	854a                	mv	a0,s2
    80003d5a:	7a02                	ld	s4,32(sp)
    80003d5c:	b705                	j	80003c7c <filewrite+0x40>
    80003d5e:	f44e                	sd	s3,40(sp)
    80003d60:	f052                	sd	s4,32(sp)
    80003d62:	e85a                	sd	s6,16(sp)
    80003d64:	e45e                	sd	s7,8(sp)
    80003d66:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003d68:	00005517          	auipc	a0,0x5
    80003d6c:	7e050513          	addi	a0,a0,2016 # 80009548 <etext+0x548>
    80003d70:	00003097          	auipc	ra,0x3
    80003d74:	f1c080e7          	jalr	-228(ra) # 80006c8c <panic>
    return -1;
    80003d78:	557d                	li	a0,-1
}
    80003d7a:	8082                	ret
      return -1;
    80003d7c:	557d                	li	a0,-1
    80003d7e:	bdfd                	j	80003c7c <filewrite+0x40>
    80003d80:	557d                	li	a0,-1
    80003d82:	bded                	j	80003c7c <filewrite+0x40>
    ret = (i == n ? n : -1);
    80003d84:	557d                	li	a0,-1
    80003d86:	7a02                	ld	s4,32(sp)
    80003d88:	bdd5                	j	80003c7c <filewrite+0x40>

0000000080003d8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d8a:	7179                	addi	sp,sp,-48
    80003d8c:	f406                	sd	ra,40(sp)
    80003d8e:	f022                	sd	s0,32(sp)
    80003d90:	ec26                	sd	s1,24(sp)
    80003d92:	e052                	sd	s4,0(sp)
    80003d94:	1800                	addi	s0,sp,48
    80003d96:	84aa                	mv	s1,a0
    80003d98:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d9a:	0005b023          	sd	zero,0(a1)
    80003d9e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	b74080e7          	jalr	-1164(ra) # 80003916 <filealloc>
    80003daa:	e088                	sd	a0,0(s1)
    80003dac:	cd49                	beqz	a0,80003e46 <pipealloc+0xbc>
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	b68080e7          	jalr	-1176(ra) # 80003916 <filealloc>
    80003db6:	00aa3023          	sd	a0,0(s4)
    80003dba:	c141                	beqz	a0,80003e3a <pipealloc+0xb0>
    80003dbc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dbe:	ffffc097          	auipc	ra,0xffffc
    80003dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80003dc6:	892a                	mv	s2,a0
    80003dc8:	c13d                	beqz	a0,80003e2e <pipealloc+0xa4>
    80003dca:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003dcc:	4985                	li	s3,1
    80003dce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dd6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dde:	00005597          	auipc	a1,0x5
    80003de2:	77a58593          	addi	a1,a1,1914 # 80009558 <etext+0x558>
    80003de6:	00003097          	auipc	ra,0x3
    80003dea:	390080e7          	jalr	912(ra) # 80007176 <initlock>
  (*f0)->type = FD_PIPE;
    80003dee:	609c                	ld	a5,0(s1)
    80003df0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e06:	000a3783          	ld	a5,0(s4)
    80003e0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e0e:	000a3783          	ld	a5,0(s4)
    80003e12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e16:	000a3783          	ld	a5,0(s4)
    80003e1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e26:	4501                	li	a0,0
    80003e28:	6942                	ld	s2,16(sp)
    80003e2a:	69a2                	ld	s3,8(sp)
    80003e2c:	a03d                	j	80003e5a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e2e:	6088                	ld	a0,0(s1)
    80003e30:	c119                	beqz	a0,80003e36 <pipealloc+0xac>
    80003e32:	6942                	ld	s2,16(sp)
    80003e34:	a029                	j	80003e3e <pipealloc+0xb4>
    80003e36:	6942                	ld	s2,16(sp)
    80003e38:	a039                	j	80003e46 <pipealloc+0xbc>
    80003e3a:	6088                	ld	a0,0(s1)
    80003e3c:	c50d                	beqz	a0,80003e66 <pipealloc+0xdc>
    fileclose(*f0);
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	b94080e7          	jalr	-1132(ra) # 800039d2 <fileclose>
  if(*f1)
    80003e46:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e4a:	557d                	li	a0,-1
  if(*f1)
    80003e4c:	c799                	beqz	a5,80003e5a <pipealloc+0xd0>
    fileclose(*f1);
    80003e4e:	853e                	mv	a0,a5
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	b82080e7          	jalr	-1150(ra) # 800039d2 <fileclose>
  return -1;
    80003e58:	557d                	li	a0,-1
}
    80003e5a:	70a2                	ld	ra,40(sp)
    80003e5c:	7402                	ld	s0,32(sp)
    80003e5e:	64e2                	ld	s1,24(sp)
    80003e60:	6a02                	ld	s4,0(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
  return -1;
    80003e66:	557d                	li	a0,-1
    80003e68:	bfcd                	j	80003e5a <pipealloc+0xd0>

0000000080003e6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6a:	1101                	addi	sp,sp,-32
    80003e6c:	ec06                	sd	ra,24(sp)
    80003e6e:	e822                	sd	s0,16(sp)
    80003e70:	e426                	sd	s1,8(sp)
    80003e72:	e04a                	sd	s2,0(sp)
    80003e74:	1000                	addi	s0,sp,32
    80003e76:	84aa                	mv	s1,a0
    80003e78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7a:	00003097          	auipc	ra,0x3
    80003e7e:	38c080e7          	jalr	908(ra) # 80007206 <acquire>
  if(writable){
    80003e82:	02090d63          	beqz	s2,80003ebc <pipeclose+0x52>
    pi->writeopen = 0;
    80003e86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8a:	21848513          	addi	a0,s1,536
    80003e8e:	ffffe097          	auipc	ra,0xffffe
    80003e92:	898080e7          	jalr	-1896(ra) # 80001726 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e96:	2204b783          	ld	a5,544(s1)
    80003e9a:	eb95                	bnez	a5,80003ece <pipeclose+0x64>
    release(&pi->lock);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00003097          	auipc	ra,0x3
    80003ea2:	41c080e7          	jalr	1052(ra) # 800072ba <release>
    kfree((char*)pi);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb0:	60e2                	ld	ra,24(sp)
    80003eb2:	6442                	ld	s0,16(sp)
    80003eb4:	64a2                	ld	s1,8(sp)
    80003eb6:	6902                	ld	s2,0(sp)
    80003eb8:	6105                	addi	sp,sp,32
    80003eba:	8082                	ret
    pi->readopen = 0;
    80003ebc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec0:	21c48513          	addi	a0,s1,540
    80003ec4:	ffffe097          	auipc	ra,0xffffe
    80003ec8:	862080e7          	jalr	-1950(ra) # 80001726 <wakeup>
    80003ecc:	b7e9                	j	80003e96 <pipeclose+0x2c>
    release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00003097          	auipc	ra,0x3
    80003ed4:	3ea080e7          	jalr	1002(ra) # 800072ba <release>
}
    80003ed8:	bfe1                	j	80003eb0 <pipeclose+0x46>

0000000080003eda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eda:	711d                	addi	sp,sp,-96
    80003edc:	ec86                	sd	ra,88(sp)
    80003ede:	e8a2                	sd	s0,80(sp)
    80003ee0:	e4a6                	sd	s1,72(sp)
    80003ee2:	e0ca                	sd	s2,64(sp)
    80003ee4:	fc4e                	sd	s3,56(sp)
    80003ee6:	f852                	sd	s4,48(sp)
    80003ee8:	f456                	sd	s5,40(sp)
    80003eea:	1080                	addi	s0,sp,96
    80003eec:	84aa                	mv	s1,a0
    80003eee:	8aae                	mv	s5,a1
    80003ef0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef2:	ffffd097          	auipc	ra,0xffffd
    80003ef6:	fe2080e7          	jalr	-30(ra) # 80000ed4 <myproc>
    80003efa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003efc:	8526                	mv	a0,s1
    80003efe:	00003097          	auipc	ra,0x3
    80003f02:	308080e7          	jalr	776(ra) # 80007206 <acquire>
  while(i < n){
    80003f06:	0d405563          	blez	s4,80003fd0 <pipewrite+0xf6>
    80003f0a:	f05a                	sd	s6,32(sp)
    80003f0c:	ec5e                	sd	s7,24(sp)
    80003f0e:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f10:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f12:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f14:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f18:	21c48b93          	addi	s7,s1,540
    80003f1c:	a089                	j	80003f5e <pipewrite+0x84>
      release(&pi->lock);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	00003097          	auipc	ra,0x3
    80003f24:	39a080e7          	jalr	922(ra) # 800072ba <release>
      return -1;
    80003f28:	597d                	li	s2,-1
    80003f2a:	7b02                	ld	s6,32(sp)
    80003f2c:	6be2                	ld	s7,24(sp)
    80003f2e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f30:	854a                	mv	a0,s2
    80003f32:	60e6                	ld	ra,88(sp)
    80003f34:	6446                	ld	s0,80(sp)
    80003f36:	64a6                	ld	s1,72(sp)
    80003f38:	6906                	ld	s2,64(sp)
    80003f3a:	79e2                	ld	s3,56(sp)
    80003f3c:	7a42                	ld	s4,48(sp)
    80003f3e:	7aa2                	ld	s5,40(sp)
    80003f40:	6125                	addi	sp,sp,96
    80003f42:	8082                	ret
      wakeup(&pi->nread);
    80003f44:	8562                	mv	a0,s8
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	7e0080e7          	jalr	2016(ra) # 80001726 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f4e:	85a6                	mv	a1,s1
    80003f50:	855e                	mv	a0,s7
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	648080e7          	jalr	1608(ra) # 8000159a <sleep>
  while(i < n){
    80003f5a:	05495c63          	bge	s2,s4,80003fb2 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003f5e:	2204a783          	lw	a5,544(s1)
    80003f62:	dfd5                	beqz	a5,80003f1e <pipewrite+0x44>
    80003f64:	0289a783          	lw	a5,40(s3)
    80003f68:	fbdd                	bnez	a5,80003f1e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6a:	2184a783          	lw	a5,536(s1)
    80003f6e:	21c4a703          	lw	a4,540(s1)
    80003f72:	2007879b          	addiw	a5,a5,512
    80003f76:	fcf707e3          	beq	a4,a5,80003f44 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	01590633          	add	a2,s2,s5
    80003f80:	faf40593          	addi	a1,s0,-81
    80003f84:	0509b503          	ld	a0,80(s3)
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	c78080e7          	jalr	-904(ra) # 80000c00 <copyin>
    80003f90:	05650263          	beq	a0,s6,80003fd4 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f94:	21c4a783          	lw	a5,540(s1)
    80003f98:	0017871b          	addiw	a4,a5,1
    80003f9c:	20e4ae23          	sw	a4,540(s1)
    80003fa0:	1ff7f793          	andi	a5,a5,511
    80003fa4:	97a6                	add	a5,a5,s1
    80003fa6:	faf44703          	lbu	a4,-81(s0)
    80003faa:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fae:	2905                	addiw	s2,s2,1
    80003fb0:	b76d                	j	80003f5a <pipewrite+0x80>
    80003fb2:	7b02                	ld	s6,32(sp)
    80003fb4:	6be2                	ld	s7,24(sp)
    80003fb6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003fb8:	21848513          	addi	a0,s1,536
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	76a080e7          	jalr	1898(ra) # 80001726 <wakeup>
  release(&pi->lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	00003097          	auipc	ra,0x3
    80003fca:	2f4080e7          	jalr	756(ra) # 800072ba <release>
  return i;
    80003fce:	b78d                	j	80003f30 <pipewrite+0x56>
  int i = 0;
    80003fd0:	4901                	li	s2,0
    80003fd2:	b7dd                	j	80003fb8 <pipewrite+0xde>
    80003fd4:	7b02                	ld	s6,32(sp)
    80003fd6:	6be2                	ld	s7,24(sp)
    80003fd8:	6c42                	ld	s8,16(sp)
    80003fda:	bff9                	j	80003fb8 <pipewrite+0xde>

0000000080003fdc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fdc:	715d                	addi	sp,sp,-80
    80003fde:	e486                	sd	ra,72(sp)
    80003fe0:	e0a2                	sd	s0,64(sp)
    80003fe2:	fc26                	sd	s1,56(sp)
    80003fe4:	f84a                	sd	s2,48(sp)
    80003fe6:	f44e                	sd	s3,40(sp)
    80003fe8:	f052                	sd	s4,32(sp)
    80003fea:	ec56                	sd	s5,24(sp)
    80003fec:	0880                	addi	s0,sp,80
    80003fee:	84aa                	mv	s1,a0
    80003ff0:	892e                	mv	s2,a1
    80003ff2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	ee0080e7          	jalr	-288(ra) # 80000ed4 <myproc>
    80003ffc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00003097          	auipc	ra,0x3
    80004004:	206080e7          	jalr	518(ra) # 80007206 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004008:	2184a703          	lw	a4,536(s1)
    8000400c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004010:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004014:	02f71663          	bne	a4,a5,80004040 <piperead+0x64>
    80004018:	2244a783          	lw	a5,548(s1)
    8000401c:	cb9d                	beqz	a5,80004052 <piperead+0x76>
    if(pr->killed){
    8000401e:	028a2783          	lw	a5,40(s4)
    80004022:	e38d                	bnez	a5,80004044 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004024:	85a6                	mv	a1,s1
    80004026:	854e                	mv	a0,s3
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	572080e7          	jalr	1394(ra) # 8000159a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004030:	2184a703          	lw	a4,536(s1)
    80004034:	21c4a783          	lw	a5,540(s1)
    80004038:	fef700e3          	beq	a4,a5,80004018 <piperead+0x3c>
    8000403c:	e85a                	sd	s6,16(sp)
    8000403e:	a819                	j	80004054 <piperead+0x78>
    80004040:	e85a                	sd	s6,16(sp)
    80004042:	a809                	j	80004054 <piperead+0x78>
      release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00003097          	auipc	ra,0x3
    8000404a:	274080e7          	jalr	628(ra) # 800072ba <release>
      return -1;
    8000404e:	59fd                	li	s3,-1
    80004050:	a0a5                	j	800040b8 <piperead+0xdc>
    80004052:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004054:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004056:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004058:	05505463          	blez	s5,800040a0 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000405c:	2184a783          	lw	a5,536(s1)
    80004060:	21c4a703          	lw	a4,540(s1)
    80004064:	02f70e63          	beq	a4,a5,800040a0 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004068:	0017871b          	addiw	a4,a5,1
    8000406c:	20e4ac23          	sw	a4,536(s1)
    80004070:	1ff7f793          	andi	a5,a5,511
    80004074:	97a6                	add	a5,a5,s1
    80004076:	0187c783          	lbu	a5,24(a5)
    8000407a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000407e:	4685                	li	a3,1
    80004080:	fbf40613          	addi	a2,s0,-65
    80004084:	85ca                	mv	a1,s2
    80004086:	050a3503          	ld	a0,80(s4)
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	aea080e7          	jalr	-1302(ra) # 80000b74 <copyout>
    80004092:	01650763          	beq	a0,s6,800040a0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004096:	2985                	addiw	s3,s3,1
    80004098:	0905                	addi	s2,s2,1
    8000409a:	fd3a91e3          	bne	s5,s3,8000405c <piperead+0x80>
    8000409e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040a0:	21c48513          	addi	a0,s1,540
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	682080e7          	jalr	1666(ra) # 80001726 <wakeup>
  release(&pi->lock);
    800040ac:	8526                	mv	a0,s1
    800040ae:	00003097          	auipc	ra,0x3
    800040b2:	20c080e7          	jalr	524(ra) # 800072ba <release>
    800040b6:	6b42                	ld	s6,16(sp)
  return i;
}
    800040b8:	854e                	mv	a0,s3
    800040ba:	60a6                	ld	ra,72(sp)
    800040bc:	6406                	ld	s0,64(sp)
    800040be:	74e2                	ld	s1,56(sp)
    800040c0:	7942                	ld	s2,48(sp)
    800040c2:	79a2                	ld	s3,40(sp)
    800040c4:	7a02                	ld	s4,32(sp)
    800040c6:	6ae2                	ld	s5,24(sp)
    800040c8:	6161                	addi	sp,sp,80
    800040ca:	8082                	ret

00000000800040cc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040cc:	df010113          	addi	sp,sp,-528
    800040d0:	20113423          	sd	ra,520(sp)
    800040d4:	20813023          	sd	s0,512(sp)
    800040d8:	ffa6                	sd	s1,504(sp)
    800040da:	fbca                	sd	s2,496(sp)
    800040dc:	0c00                	addi	s0,sp,528
    800040de:	892a                	mv	s2,a0
    800040e0:	dea43c23          	sd	a0,-520(s0)
    800040e4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	dec080e7          	jalr	-532(ra) # 80000ed4 <myproc>
    800040f0:	84aa                	mv	s1,a0

  begin_op();
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	416080e7          	jalr	1046(ra) # 80003508 <begin_op>

  if((ip = namei(path)) == 0){
    800040fa:	854a                	mv	a0,s2
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	20c080e7          	jalr	524(ra) # 80003308 <namei>
    80004104:	c135                	beqz	a0,80004168 <exec+0x9c>
    80004106:	f3d2                	sd	s4,480(sp)
    80004108:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000410a:	fffff097          	auipc	ra,0xfffff
    8000410e:	a2c080e7          	jalr	-1492(ra) # 80002b36 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004112:	04000713          	li	a4,64
    80004116:	4681                	li	a3,0
    80004118:	e5040613          	addi	a2,s0,-432
    8000411c:	4581                	li	a1,0
    8000411e:	8552                	mv	a0,s4
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	cce080e7          	jalr	-818(ra) # 80002dee <readi>
    80004128:	04000793          	li	a5,64
    8000412c:	00f51a63          	bne	a0,a5,80004140 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004130:	e5042703          	lw	a4,-432(s0)
    80004134:	464c47b7          	lui	a5,0x464c4
    80004138:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000413c:	02f70c63          	beq	a4,a5,80004174 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004140:	8552                	mv	a0,s4
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	c5a080e7          	jalr	-934(ra) # 80002d9c <iunlockput>
    end_op();
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	438080e7          	jalr	1080(ra) # 80003582 <end_op>
  }
  return -1;
    80004152:	557d                	li	a0,-1
    80004154:	7a1e                	ld	s4,480(sp)
}
    80004156:	20813083          	ld	ra,520(sp)
    8000415a:	20013403          	ld	s0,512(sp)
    8000415e:	74fe                	ld	s1,504(sp)
    80004160:	795e                	ld	s2,496(sp)
    80004162:	21010113          	addi	sp,sp,528
    80004166:	8082                	ret
    end_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	41a080e7          	jalr	1050(ra) # 80003582 <end_op>
    return -1;
    80004170:	557d                	li	a0,-1
    80004172:	b7d5                	j	80004156 <exec+0x8a>
    80004174:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004176:	8526                	mv	a0,s1
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	e20080e7          	jalr	-480(ra) # 80000f98 <proc_pagetable>
    80004180:	8b2a                	mv	s6,a0
    80004182:	30050563          	beqz	a0,8000448c <exec+0x3c0>
    80004186:	f7ce                	sd	s3,488(sp)
    80004188:	efd6                	sd	s5,472(sp)
    8000418a:	e7de                	sd	s7,456(sp)
    8000418c:	e3e2                	sd	s8,448(sp)
    8000418e:	ff66                	sd	s9,440(sp)
    80004190:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004192:	e7042d03          	lw	s10,-400(s0)
    80004196:	e8845783          	lhu	a5,-376(s0)
    8000419a:	14078563          	beqz	a5,800042e4 <exec+0x218>
    8000419e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a2:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800041a4:	6c85                	lui	s9,0x1
    800041a6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041aa:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041ae:	6a85                	lui	s5,0x1
    800041b0:	a0b5                	j	8000421c <exec+0x150>
      panic("loadseg: address should exist");
    800041b2:	00005517          	auipc	a0,0x5
    800041b6:	3ae50513          	addi	a0,a0,942 # 80009560 <etext+0x560>
    800041ba:	00003097          	auipc	ra,0x3
    800041be:	ad2080e7          	jalr	-1326(ra) # 80006c8c <panic>
    if(sz - i < PGSIZE)
    800041c2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c4:	8726                	mv	a4,s1
    800041c6:	012c06bb          	addw	a3,s8,s2
    800041ca:	4581                	li	a1,0
    800041cc:	8552                	mv	a0,s4
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	c20080e7          	jalr	-992(ra) # 80002dee <readi>
    800041d6:	2501                	sext.w	a0,a0
    800041d8:	26a49e63          	bne	s1,a0,80004454 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800041dc:	012a893b          	addw	s2,s5,s2
    800041e0:	03397563          	bgeu	s2,s3,8000420a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800041e4:	02091593          	slli	a1,s2,0x20
    800041e8:	9181                	srli	a1,a1,0x20
    800041ea:	95de                	add	a1,a1,s7
    800041ec:	855a                	mv	a0,s6
    800041ee:	ffffc097          	auipc	ra,0xffffc
    800041f2:	322080e7          	jalr	802(ra) # 80000510 <walkaddr>
    800041f6:	862a                	mv	a2,a0
    if(pa == 0)
    800041f8:	dd4d                	beqz	a0,800041b2 <exec+0xe6>
    if(sz - i < PGSIZE)
    800041fa:	412984bb          	subw	s1,s3,s2
    800041fe:	0004879b          	sext.w	a5,s1
    80004202:	fcfcf0e3          	bgeu	s9,a5,800041c2 <exec+0xf6>
    80004206:	84d6                	mv	s1,s5
    80004208:	bf6d                	j	800041c2 <exec+0xf6>
    sz = sz1;
    8000420a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420e:	2d85                	addiw	s11,s11,1
    80004210:	038d0d1b          	addiw	s10,s10,56
    80004214:	e8845783          	lhu	a5,-376(s0)
    80004218:	06fddf63          	bge	s11,a5,80004296 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000421c:	2d01                	sext.w	s10,s10
    8000421e:	03800713          	li	a4,56
    80004222:	86ea                	mv	a3,s10
    80004224:	e1840613          	addi	a2,s0,-488
    80004228:	4581                	li	a1,0
    8000422a:	8552                	mv	a0,s4
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	bc2080e7          	jalr	-1086(ra) # 80002dee <readi>
    80004234:	03800793          	li	a5,56
    80004238:	1ef51863          	bne	a0,a5,80004428 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000423c:	e1842783          	lw	a5,-488(s0)
    80004240:	4705                	li	a4,1
    80004242:	fce796e3          	bne	a5,a4,8000420e <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004246:	e4043603          	ld	a2,-448(s0)
    8000424a:	e3843783          	ld	a5,-456(s0)
    8000424e:	1ef66163          	bltu	a2,a5,80004430 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004252:	e2843783          	ld	a5,-472(s0)
    80004256:	963e                	add	a2,a2,a5
    80004258:	1ef66063          	bltu	a2,a5,80004438 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000425c:	85a6                	mv	a1,s1
    8000425e:	855a                	mv	a0,s6
    80004260:	ffffc097          	auipc	ra,0xffffc
    80004264:	6b8080e7          	jalr	1720(ra) # 80000918 <uvmalloc>
    80004268:	e0a43423          	sd	a0,-504(s0)
    8000426c:	1c050a63          	beqz	a0,80004440 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004270:	e2843b83          	ld	s7,-472(s0)
    80004274:	df043783          	ld	a5,-528(s0)
    80004278:	00fbf7b3          	and	a5,s7,a5
    8000427c:	1c079a63          	bnez	a5,80004450 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004280:	e2042c03          	lw	s8,-480(s0)
    80004284:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004288:	00098463          	beqz	s3,80004290 <exec+0x1c4>
    8000428c:	4901                	li	s2,0
    8000428e:	bf99                	j	800041e4 <exec+0x118>
    sz = sz1;
    80004290:	e0843483          	ld	s1,-504(s0)
    80004294:	bfad                	j	8000420e <exec+0x142>
    80004296:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004298:	8552                	mv	a0,s4
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	b02080e7          	jalr	-1278(ra) # 80002d9c <iunlockput>
  end_op();
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	2e0080e7          	jalr	736(ra) # 80003582 <end_op>
  p = myproc();
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	c2a080e7          	jalr	-982(ra) # 80000ed4 <myproc>
    800042b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042b4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800042b8:	6985                	lui	s3,0x1
    800042ba:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042bc:	99a6                	add	s3,s3,s1
    800042be:	77fd                	lui	a5,0xfffff
    800042c0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042c4:	6609                	lui	a2,0x2
    800042c6:	964e                	add	a2,a2,s3
    800042c8:	85ce                	mv	a1,s3
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	64c080e7          	jalr	1612(ra) # 80000918 <uvmalloc>
    800042d4:	892a                	mv	s2,a0
    800042d6:	e0a43423          	sd	a0,-504(s0)
    800042da:	e519                	bnez	a0,800042e8 <exec+0x21c>
  if(pagetable)
    800042dc:	e1343423          	sd	s3,-504(s0)
    800042e0:	4a01                	li	s4,0
    800042e2:	aa95                	j	80004456 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e4:	4481                	li	s1,0
    800042e6:	bf4d                	j	80004298 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042e8:	75f9                	lui	a1,0xffffe
    800042ea:	95aa                	add	a1,a1,a0
    800042ec:	855a                	mv	a0,s6
    800042ee:	ffffd097          	auipc	ra,0xffffd
    800042f2:	854080e7          	jalr	-1964(ra) # 80000b42 <uvmclear>
  stackbase = sp - PGSIZE;
    800042f6:	7bfd                	lui	s7,0xfffff
    800042f8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800042fa:	e0043783          	ld	a5,-512(s0)
    800042fe:	6388                	ld	a0,0(a5)
    80004300:	c52d                	beqz	a0,8000436a <exec+0x29e>
    80004302:	e9040993          	addi	s3,s0,-368
    80004306:	f9040c13          	addi	s8,s0,-112
    8000430a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000430c:	ffffc097          	auipc	ra,0xffffc
    80004310:	fe2080e7          	jalr	-30(ra) # 800002ee <strlen>
    80004314:	0015079b          	addiw	a5,a0,1
    80004318:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000431c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004320:	13796463          	bltu	s2,s7,80004448 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004324:	e0043d03          	ld	s10,-512(s0)
    80004328:	000d3a03          	ld	s4,0(s10)
    8000432c:	8552                	mv	a0,s4
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	fc0080e7          	jalr	-64(ra) # 800002ee <strlen>
    80004336:	0015069b          	addiw	a3,a0,1
    8000433a:	8652                	mv	a2,s4
    8000433c:	85ca                	mv	a1,s2
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	834080e7          	jalr	-1996(ra) # 80000b74 <copyout>
    80004348:	10054263          	bltz	a0,8000444c <exec+0x380>
    ustack[argc] = sp;
    8000434c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004350:	0485                	addi	s1,s1,1
    80004352:	008d0793          	addi	a5,s10,8
    80004356:	e0f43023          	sd	a5,-512(s0)
    8000435a:	008d3503          	ld	a0,8(s10)
    8000435e:	c909                	beqz	a0,80004370 <exec+0x2a4>
    if(argc >= MAXARG)
    80004360:	09a1                	addi	s3,s3,8
    80004362:	fb8995e3          	bne	s3,s8,8000430c <exec+0x240>
  ip = 0;
    80004366:	4a01                	li	s4,0
    80004368:	a0fd                	j	80004456 <exec+0x38a>
  sp = sz;
    8000436a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000436e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004370:	00349793          	slli	a5,s1,0x3
    80004374:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd4a10>
    80004378:	97a2                	add	a5,a5,s0
    8000437a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000437e:	00148693          	addi	a3,s1,1
    80004382:	068e                	slli	a3,a3,0x3
    80004384:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004388:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000438c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004390:	f57966e3          	bltu	s2,s7,800042dc <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004394:	e9040613          	addi	a2,s0,-368
    80004398:	85ca                	mv	a1,s2
    8000439a:	855a                	mv	a0,s6
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	7d8080e7          	jalr	2008(ra) # 80000b74 <copyout>
    800043a4:	0e054663          	bltz	a0,80004490 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800043a8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043b0:	df843783          	ld	a5,-520(s0)
    800043b4:	0007c703          	lbu	a4,0(a5)
    800043b8:	cf11                	beqz	a4,800043d4 <exec+0x308>
    800043ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043bc:	02f00693          	li	a3,47
    800043c0:	a039                	j	800043ce <exec+0x302>
      last = s+1;
    800043c2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043c6:	0785                	addi	a5,a5,1
    800043c8:	fff7c703          	lbu	a4,-1(a5)
    800043cc:	c701                	beqz	a4,800043d4 <exec+0x308>
    if(*s == '/')
    800043ce:	fed71ce3          	bne	a4,a3,800043c6 <exec+0x2fa>
    800043d2:	bfc5                	j	800043c2 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800043d4:	4641                	li	a2,16
    800043d6:	df843583          	ld	a1,-520(s0)
    800043da:	158a8513          	addi	a0,s5,344
    800043de:	ffffc097          	auipc	ra,0xffffc
    800043e2:	ede080e7          	jalr	-290(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800043e6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043ea:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043ee:	e0843783          	ld	a5,-504(s0)
    800043f2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043f6:	058ab783          	ld	a5,88(s5)
    800043fa:	e6843703          	ld	a4,-408(s0)
    800043fe:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004400:	058ab783          	ld	a5,88(s5)
    80004404:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004408:	85e6                	mv	a1,s9
    8000440a:	ffffd097          	auipc	ra,0xffffd
    8000440e:	c2a080e7          	jalr	-982(ra) # 80001034 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004412:	0004851b          	sext.w	a0,s1
    80004416:	79be                	ld	s3,488(sp)
    80004418:	7a1e                	ld	s4,480(sp)
    8000441a:	6afe                	ld	s5,472(sp)
    8000441c:	6b5e                	ld	s6,464(sp)
    8000441e:	6bbe                	ld	s7,456(sp)
    80004420:	6c1e                	ld	s8,448(sp)
    80004422:	7cfa                	ld	s9,440(sp)
    80004424:	7d5a                	ld	s10,432(sp)
    80004426:	bb05                	j	80004156 <exec+0x8a>
    80004428:	e0943423          	sd	s1,-504(s0)
    8000442c:	7dba                	ld	s11,424(sp)
    8000442e:	a025                	j	80004456 <exec+0x38a>
    80004430:	e0943423          	sd	s1,-504(s0)
    80004434:	7dba                	ld	s11,424(sp)
    80004436:	a005                	j	80004456 <exec+0x38a>
    80004438:	e0943423          	sd	s1,-504(s0)
    8000443c:	7dba                	ld	s11,424(sp)
    8000443e:	a821                	j	80004456 <exec+0x38a>
    80004440:	e0943423          	sd	s1,-504(s0)
    80004444:	7dba                	ld	s11,424(sp)
    80004446:	a801                	j	80004456 <exec+0x38a>
  ip = 0;
    80004448:	4a01                	li	s4,0
    8000444a:	a031                	j	80004456 <exec+0x38a>
    8000444c:	4a01                	li	s4,0
  if(pagetable)
    8000444e:	a021                	j	80004456 <exec+0x38a>
    80004450:	7dba                	ld	s11,424(sp)
    80004452:	a011                	j	80004456 <exec+0x38a>
    80004454:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004456:	e0843583          	ld	a1,-504(s0)
    8000445a:	855a                	mv	a0,s6
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	bd8080e7          	jalr	-1064(ra) # 80001034 <proc_freepagetable>
  return -1;
    80004464:	557d                	li	a0,-1
  if(ip){
    80004466:	000a1b63          	bnez	s4,8000447c <exec+0x3b0>
    8000446a:	79be                	ld	s3,488(sp)
    8000446c:	7a1e                	ld	s4,480(sp)
    8000446e:	6afe                	ld	s5,472(sp)
    80004470:	6b5e                	ld	s6,464(sp)
    80004472:	6bbe                	ld	s7,456(sp)
    80004474:	6c1e                	ld	s8,448(sp)
    80004476:	7cfa                	ld	s9,440(sp)
    80004478:	7d5a                	ld	s10,432(sp)
    8000447a:	b9f1                	j	80004156 <exec+0x8a>
    8000447c:	79be                	ld	s3,488(sp)
    8000447e:	6afe                	ld	s5,472(sp)
    80004480:	6b5e                	ld	s6,464(sp)
    80004482:	6bbe                	ld	s7,456(sp)
    80004484:	6c1e                	ld	s8,448(sp)
    80004486:	7cfa                	ld	s9,440(sp)
    80004488:	7d5a                	ld	s10,432(sp)
    8000448a:	b95d                	j	80004140 <exec+0x74>
    8000448c:	6b5e                	ld	s6,464(sp)
    8000448e:	b94d                	j	80004140 <exec+0x74>
  sz = sz1;
    80004490:	e0843983          	ld	s3,-504(s0)
    80004494:	b5a1                	j	800042dc <exec+0x210>

0000000080004496 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004496:	7179                	addi	sp,sp,-48
    80004498:	f406                	sd	ra,40(sp)
    8000449a:	f022                	sd	s0,32(sp)
    8000449c:	ec26                	sd	s1,24(sp)
    8000449e:	e84a                	sd	s2,16(sp)
    800044a0:	1800                	addi	s0,sp,48
    800044a2:	892e                	mv	s2,a1
    800044a4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800044a6:	fdc40593          	addi	a1,s0,-36
    800044aa:	ffffe097          	auipc	ra,0xffffe
    800044ae:	b1a080e7          	jalr	-1254(ra) # 80001fc4 <argint>
    800044b2:	04054063          	bltz	a0,800044f2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044b6:	fdc42703          	lw	a4,-36(s0)
    800044ba:	47bd                	li	a5,15
    800044bc:	02e7ed63          	bltu	a5,a4,800044f6 <argfd+0x60>
    800044c0:	ffffd097          	auipc	ra,0xffffd
    800044c4:	a14080e7          	jalr	-1516(ra) # 80000ed4 <myproc>
    800044c8:	fdc42703          	lw	a4,-36(s0)
    800044cc:	01a70793          	addi	a5,a4,26
    800044d0:	078e                	slli	a5,a5,0x3
    800044d2:	953e                	add	a0,a0,a5
    800044d4:	611c                	ld	a5,0(a0)
    800044d6:	c395                	beqz	a5,800044fa <argfd+0x64>
    return -1;
  if(pfd)
    800044d8:	00090463          	beqz	s2,800044e0 <argfd+0x4a>
    *pfd = fd;
    800044dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044e0:	4501                	li	a0,0
  if(pf)
    800044e2:	c091                	beqz	s1,800044e6 <argfd+0x50>
    *pf = f;
    800044e4:	e09c                	sd	a5,0(s1)
}
    800044e6:	70a2                	ld	ra,40(sp)
    800044e8:	7402                	ld	s0,32(sp)
    800044ea:	64e2                	ld	s1,24(sp)
    800044ec:	6942                	ld	s2,16(sp)
    800044ee:	6145                	addi	sp,sp,48
    800044f0:	8082                	ret
    return -1;
    800044f2:	557d                	li	a0,-1
    800044f4:	bfcd                	j	800044e6 <argfd+0x50>
    return -1;
    800044f6:	557d                	li	a0,-1
    800044f8:	b7fd                	j	800044e6 <argfd+0x50>
    800044fa:	557d                	li	a0,-1
    800044fc:	b7ed                	j	800044e6 <argfd+0x50>

00000000800044fe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044fe:	1101                	addi	sp,sp,-32
    80004500:	ec06                	sd	ra,24(sp)
    80004502:	e822                	sd	s0,16(sp)
    80004504:	e426                	sd	s1,8(sp)
    80004506:	1000                	addi	s0,sp,32
    80004508:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	9ca080e7          	jalr	-1590(ra) # 80000ed4 <myproc>
    80004512:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004514:	0d050793          	addi	a5,a0,208
    80004518:	4501                	li	a0,0
    8000451a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000451c:	6398                	ld	a4,0(a5)
    8000451e:	cb19                	beqz	a4,80004534 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004520:	2505                	addiw	a0,a0,1
    80004522:	07a1                	addi	a5,a5,8
    80004524:	fed51ce3          	bne	a0,a3,8000451c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004528:	557d                	li	a0,-1
}
    8000452a:	60e2                	ld	ra,24(sp)
    8000452c:	6442                	ld	s0,16(sp)
    8000452e:	64a2                	ld	s1,8(sp)
    80004530:	6105                	addi	sp,sp,32
    80004532:	8082                	ret
      p->ofile[fd] = f;
    80004534:	01a50793          	addi	a5,a0,26
    80004538:	078e                	slli	a5,a5,0x3
    8000453a:	963e                	add	a2,a2,a5
    8000453c:	e204                	sd	s1,0(a2)
      return fd;
    8000453e:	b7f5                	j	8000452a <fdalloc+0x2c>

0000000080004540 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004540:	715d                	addi	sp,sp,-80
    80004542:	e486                	sd	ra,72(sp)
    80004544:	e0a2                	sd	s0,64(sp)
    80004546:	fc26                	sd	s1,56(sp)
    80004548:	f84a                	sd	s2,48(sp)
    8000454a:	f44e                	sd	s3,40(sp)
    8000454c:	f052                	sd	s4,32(sp)
    8000454e:	ec56                	sd	s5,24(sp)
    80004550:	0880                	addi	s0,sp,80
    80004552:	8aae                	mv	s5,a1
    80004554:	8a32                	mv	s4,a2
    80004556:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004558:	fb040593          	addi	a1,s0,-80
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	dca080e7          	jalr	-566(ra) # 80003326 <nameiparent>
    80004564:	892a                	mv	s2,a0
    80004566:	12050c63          	beqz	a0,8000469e <create+0x15e>
    return 0;

  ilock(dp);
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	5cc080e7          	jalr	1484(ra) # 80002b36 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004572:	4601                	li	a2,0
    80004574:	fb040593          	addi	a1,s0,-80
    80004578:	854a                	mv	a0,s2
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	abc080e7          	jalr	-1348(ra) # 80003036 <dirlookup>
    80004582:	84aa                	mv	s1,a0
    80004584:	c539                	beqz	a0,800045d2 <create+0x92>
    iunlockput(dp);
    80004586:	854a                	mv	a0,s2
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	814080e7          	jalr	-2028(ra) # 80002d9c <iunlockput>
    ilock(ip);
    80004590:	8526                	mv	a0,s1
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	5a4080e7          	jalr	1444(ra) # 80002b36 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000459a:	4789                	li	a5,2
    8000459c:	02fa9463          	bne	s5,a5,800045c4 <create+0x84>
    800045a0:	0444d783          	lhu	a5,68(s1)
    800045a4:	37f9                	addiw	a5,a5,-2
    800045a6:	17c2                	slli	a5,a5,0x30
    800045a8:	93c1                	srli	a5,a5,0x30
    800045aa:	4705                	li	a4,1
    800045ac:	00f76c63          	bltu	a4,a5,800045c4 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045b0:	8526                	mv	a0,s1
    800045b2:	60a6                	ld	ra,72(sp)
    800045b4:	6406                	ld	s0,64(sp)
    800045b6:	74e2                	ld	s1,56(sp)
    800045b8:	7942                	ld	s2,48(sp)
    800045ba:	79a2                	ld	s3,40(sp)
    800045bc:	7a02                	ld	s4,32(sp)
    800045be:	6ae2                	ld	s5,24(sp)
    800045c0:	6161                	addi	sp,sp,80
    800045c2:	8082                	ret
    iunlockput(ip);
    800045c4:	8526                	mv	a0,s1
    800045c6:	ffffe097          	auipc	ra,0xffffe
    800045ca:	7d6080e7          	jalr	2006(ra) # 80002d9c <iunlockput>
    return 0;
    800045ce:	4481                	li	s1,0
    800045d0:	b7c5                	j	800045b0 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045d2:	85d6                	mv	a1,s5
    800045d4:	00092503          	lw	a0,0(s2)
    800045d8:	ffffe097          	auipc	ra,0xffffe
    800045dc:	3ca080e7          	jalr	970(ra) # 800029a2 <ialloc>
    800045e0:	84aa                	mv	s1,a0
    800045e2:	c139                	beqz	a0,80004628 <create+0xe8>
  ilock(ip);
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	552080e7          	jalr	1362(ra) # 80002b36 <ilock>
  ip->major = major;
    800045ec:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800045f0:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800045f4:	4985                	li	s3,1
    800045f6:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800045fa:	8526                	mv	a0,s1
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	46e080e7          	jalr	1134(ra) # 80002a6a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004604:	033a8a63          	beq	s5,s3,80004638 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004608:	40d0                	lw	a2,4(s1)
    8000460a:	fb040593          	addi	a1,s0,-80
    8000460e:	854a                	mv	a0,s2
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	c36080e7          	jalr	-970(ra) # 80003246 <dirlink>
    80004618:	06054b63          	bltz	a0,8000468e <create+0x14e>
  iunlockput(dp);
    8000461c:	854a                	mv	a0,s2
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	77e080e7          	jalr	1918(ra) # 80002d9c <iunlockput>
  return ip;
    80004626:	b769                	j	800045b0 <create+0x70>
    panic("create: ialloc");
    80004628:	00005517          	auipc	a0,0x5
    8000462c:	f5850513          	addi	a0,a0,-168 # 80009580 <etext+0x580>
    80004630:	00002097          	auipc	ra,0x2
    80004634:	65c080e7          	jalr	1628(ra) # 80006c8c <panic>
    dp->nlink++;  // for ".."
    80004638:	04a95783          	lhu	a5,74(s2)
    8000463c:	2785                	addiw	a5,a5,1
    8000463e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004642:	854a                	mv	a0,s2
    80004644:	ffffe097          	auipc	ra,0xffffe
    80004648:	426080e7          	jalr	1062(ra) # 80002a6a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000464c:	40d0                	lw	a2,4(s1)
    8000464e:	00005597          	auipc	a1,0x5
    80004652:	f4258593          	addi	a1,a1,-190 # 80009590 <etext+0x590>
    80004656:	8526                	mv	a0,s1
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	bee080e7          	jalr	-1042(ra) # 80003246 <dirlink>
    80004660:	00054f63          	bltz	a0,8000467e <create+0x13e>
    80004664:	00492603          	lw	a2,4(s2)
    80004668:	00005597          	auipc	a1,0x5
    8000466c:	f3058593          	addi	a1,a1,-208 # 80009598 <etext+0x598>
    80004670:	8526                	mv	a0,s1
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	bd4080e7          	jalr	-1068(ra) # 80003246 <dirlink>
    8000467a:	f80557e3          	bgez	a0,80004608 <create+0xc8>
      panic("create dots");
    8000467e:	00005517          	auipc	a0,0x5
    80004682:	f2250513          	addi	a0,a0,-222 # 800095a0 <etext+0x5a0>
    80004686:	00002097          	auipc	ra,0x2
    8000468a:	606080e7          	jalr	1542(ra) # 80006c8c <panic>
    panic("create: dirlink");
    8000468e:	00005517          	auipc	a0,0x5
    80004692:	f2250513          	addi	a0,a0,-222 # 800095b0 <etext+0x5b0>
    80004696:	00002097          	auipc	ra,0x2
    8000469a:	5f6080e7          	jalr	1526(ra) # 80006c8c <panic>
    return 0;
    8000469e:	84aa                	mv	s1,a0
    800046a0:	bf01                	j	800045b0 <create+0x70>

00000000800046a2 <sys_dup>:
{
    800046a2:	7179                	addi	sp,sp,-48
    800046a4:	f406                	sd	ra,40(sp)
    800046a6:	f022                	sd	s0,32(sp)
    800046a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046aa:	fd840613          	addi	a2,s0,-40
    800046ae:	4581                	li	a1,0
    800046b0:	4501                	li	a0,0
    800046b2:	00000097          	auipc	ra,0x0
    800046b6:	de4080e7          	jalr	-540(ra) # 80004496 <argfd>
    return -1;
    800046ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046bc:	02054763          	bltz	a0,800046ea <sys_dup+0x48>
    800046c0:	ec26                	sd	s1,24(sp)
    800046c2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800046c4:	fd843903          	ld	s2,-40(s0)
    800046c8:	854a                	mv	a0,s2
    800046ca:	00000097          	auipc	ra,0x0
    800046ce:	e34080e7          	jalr	-460(ra) # 800044fe <fdalloc>
    800046d2:	84aa                	mv	s1,a0
    return -1;
    800046d4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046d6:	00054f63          	bltz	a0,800046f4 <sys_dup+0x52>
  filedup(f);
    800046da:	854a                	mv	a0,s2
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	2a4080e7          	jalr	676(ra) # 80003980 <filedup>
  return fd;
    800046e4:	87a6                	mv	a5,s1
    800046e6:	64e2                	ld	s1,24(sp)
    800046e8:	6942                	ld	s2,16(sp)
}
    800046ea:	853e                	mv	a0,a5
    800046ec:	70a2                	ld	ra,40(sp)
    800046ee:	7402                	ld	s0,32(sp)
    800046f0:	6145                	addi	sp,sp,48
    800046f2:	8082                	ret
    800046f4:	64e2                	ld	s1,24(sp)
    800046f6:	6942                	ld	s2,16(sp)
    800046f8:	bfcd                	j	800046ea <sys_dup+0x48>

00000000800046fa <sys_read>:
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004702:	fe840613          	addi	a2,s0,-24
    80004706:	4581                	li	a1,0
    80004708:	4501                	li	a0,0
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	d8c080e7          	jalr	-628(ra) # 80004496 <argfd>
    return -1;
    80004712:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004714:	04054163          	bltz	a0,80004756 <sys_read+0x5c>
    80004718:	fe440593          	addi	a1,s0,-28
    8000471c:	4509                	li	a0,2
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	8a6080e7          	jalr	-1882(ra) # 80001fc4 <argint>
    return -1;
    80004726:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004728:	02054763          	bltz	a0,80004756 <sys_read+0x5c>
    8000472c:	fd840593          	addi	a1,s0,-40
    80004730:	4505                	li	a0,1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	8b4080e7          	jalr	-1868(ra) # 80001fe6 <argaddr>
    return -1;
    8000473a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473c:	00054d63          	bltz	a0,80004756 <sys_read+0x5c>
  return fileread(f, p, n);
    80004740:	fe442603          	lw	a2,-28(s0)
    80004744:	fd843583          	ld	a1,-40(s0)
    80004748:	fe843503          	ld	a0,-24(s0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	406080e7          	jalr	1030(ra) # 80003b52 <fileread>
    80004754:	87aa                	mv	a5,a0
}
    80004756:	853e                	mv	a0,a5
    80004758:	70a2                	ld	ra,40(sp)
    8000475a:	7402                	ld	s0,32(sp)
    8000475c:	6145                	addi	sp,sp,48
    8000475e:	8082                	ret

0000000080004760 <sys_write>:
{
    80004760:	7179                	addi	sp,sp,-48
    80004762:	f406                	sd	ra,40(sp)
    80004764:	f022                	sd	s0,32(sp)
    80004766:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004768:	fe840613          	addi	a2,s0,-24
    8000476c:	4581                	li	a1,0
    8000476e:	4501                	li	a0,0
    80004770:	00000097          	auipc	ra,0x0
    80004774:	d26080e7          	jalr	-730(ra) # 80004496 <argfd>
    return -1;
    80004778:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477a:	04054163          	bltz	a0,800047bc <sys_write+0x5c>
    8000477e:	fe440593          	addi	a1,s0,-28
    80004782:	4509                	li	a0,2
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	840080e7          	jalr	-1984(ra) # 80001fc4 <argint>
    return -1;
    8000478c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000478e:	02054763          	bltz	a0,800047bc <sys_write+0x5c>
    80004792:	fd840593          	addi	a1,s0,-40
    80004796:	4505                	li	a0,1
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	84e080e7          	jalr	-1970(ra) # 80001fe6 <argaddr>
    return -1;
    800047a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a2:	00054d63          	bltz	a0,800047bc <sys_write+0x5c>
  return filewrite(f, p, n);
    800047a6:	fe442603          	lw	a2,-28(s0)
    800047aa:	fd843583          	ld	a1,-40(s0)
    800047ae:	fe843503          	ld	a0,-24(s0)
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	48a080e7          	jalr	1162(ra) # 80003c3c <filewrite>
    800047ba:	87aa                	mv	a5,a0
}
    800047bc:	853e                	mv	a0,a5
    800047be:	70a2                	ld	ra,40(sp)
    800047c0:	7402                	ld	s0,32(sp)
    800047c2:	6145                	addi	sp,sp,48
    800047c4:	8082                	ret

00000000800047c6 <sys_close>:
{
    800047c6:	1101                	addi	sp,sp,-32
    800047c8:	ec06                	sd	ra,24(sp)
    800047ca:	e822                	sd	s0,16(sp)
    800047cc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ce:	fe040613          	addi	a2,s0,-32
    800047d2:	fec40593          	addi	a1,s0,-20
    800047d6:	4501                	li	a0,0
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	cbe080e7          	jalr	-834(ra) # 80004496 <argfd>
    return -1;
    800047e0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047e2:	02054463          	bltz	a0,8000480a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	6ee080e7          	jalr	1774(ra) # 80000ed4 <myproc>
    800047ee:	fec42783          	lw	a5,-20(s0)
    800047f2:	07e9                	addi	a5,a5,26
    800047f4:	078e                	slli	a5,a5,0x3
    800047f6:	953e                	add	a0,a0,a5
    800047f8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047fc:	fe043503          	ld	a0,-32(s0)
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	1d2080e7          	jalr	466(ra) # 800039d2 <fileclose>
  return 0;
    80004808:	4781                	li	a5,0
}
    8000480a:	853e                	mv	a0,a5
    8000480c:	60e2                	ld	ra,24(sp)
    8000480e:	6442                	ld	s0,16(sp)
    80004810:	6105                	addi	sp,sp,32
    80004812:	8082                	ret

0000000080004814 <sys_fstat>:
{
    80004814:	1101                	addi	sp,sp,-32
    80004816:	ec06                	sd	ra,24(sp)
    80004818:	e822                	sd	s0,16(sp)
    8000481a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000481c:	fe840613          	addi	a2,s0,-24
    80004820:	4581                	li	a1,0
    80004822:	4501                	li	a0,0
    80004824:	00000097          	auipc	ra,0x0
    80004828:	c72080e7          	jalr	-910(ra) # 80004496 <argfd>
    return -1;
    8000482c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000482e:	02054563          	bltz	a0,80004858 <sys_fstat+0x44>
    80004832:	fe040593          	addi	a1,s0,-32
    80004836:	4505                	li	a0,1
    80004838:	ffffd097          	auipc	ra,0xffffd
    8000483c:	7ae080e7          	jalr	1966(ra) # 80001fe6 <argaddr>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004842:	00054b63          	bltz	a0,80004858 <sys_fstat+0x44>
  return filestat(f, st);
    80004846:	fe043583          	ld	a1,-32(s0)
    8000484a:	fe843503          	ld	a0,-24(s0)
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	292080e7          	jalr	658(ra) # 80003ae0 <filestat>
    80004856:	87aa                	mv	a5,a0
}
    80004858:	853e                	mv	a0,a5
    8000485a:	60e2                	ld	ra,24(sp)
    8000485c:	6442                	ld	s0,16(sp)
    8000485e:	6105                	addi	sp,sp,32
    80004860:	8082                	ret

0000000080004862 <sys_link>:
{
    80004862:	7169                	addi	sp,sp,-304
    80004864:	f606                	sd	ra,296(sp)
    80004866:	f222                	sd	s0,288(sp)
    80004868:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486a:	08000613          	li	a2,128
    8000486e:	ed040593          	addi	a1,s0,-304
    80004872:	4501                	li	a0,0
    80004874:	ffffd097          	auipc	ra,0xffffd
    80004878:	794080e7          	jalr	1940(ra) # 80002008 <argstr>
    return -1;
    8000487c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487e:	12054663          	bltz	a0,800049aa <sys_link+0x148>
    80004882:	08000613          	li	a2,128
    80004886:	f5040593          	addi	a1,s0,-176
    8000488a:	4505                	li	a0,1
    8000488c:	ffffd097          	auipc	ra,0xffffd
    80004890:	77c080e7          	jalr	1916(ra) # 80002008 <argstr>
    return -1;
    80004894:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004896:	10054a63          	bltz	a0,800049aa <sys_link+0x148>
    8000489a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	c6c080e7          	jalr	-916(ra) # 80003508 <begin_op>
  if((ip = namei(old)) == 0){
    800048a4:	ed040513          	addi	a0,s0,-304
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	a60080e7          	jalr	-1440(ra) # 80003308 <namei>
    800048b0:	84aa                	mv	s1,a0
    800048b2:	c949                	beqz	a0,80004944 <sys_link+0xe2>
  ilock(ip);
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	282080e7          	jalr	642(ra) # 80002b36 <ilock>
  if(ip->type == T_DIR){
    800048bc:	04449703          	lh	a4,68(s1)
    800048c0:	4785                	li	a5,1
    800048c2:	08f70863          	beq	a4,a5,80004952 <sys_link+0xf0>
    800048c6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048c8:	04a4d783          	lhu	a5,74(s1)
    800048cc:	2785                	addiw	a5,a5,1
    800048ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	196080e7          	jalr	406(ra) # 80002a6a <iupdate>
  iunlock(ip);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	31e080e7          	jalr	798(ra) # 80002bfc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048e6:	fd040593          	addi	a1,s0,-48
    800048ea:	f5040513          	addi	a0,s0,-176
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	a38080e7          	jalr	-1480(ra) # 80003326 <nameiparent>
    800048f6:	892a                	mv	s2,a0
    800048f8:	cd35                	beqz	a0,80004974 <sys_link+0x112>
  ilock(dp);
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	23c080e7          	jalr	572(ra) # 80002b36 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004902:	00092703          	lw	a4,0(s2)
    80004906:	409c                	lw	a5,0(s1)
    80004908:	06f71163          	bne	a4,a5,8000496a <sys_link+0x108>
    8000490c:	40d0                	lw	a2,4(s1)
    8000490e:	fd040593          	addi	a1,s0,-48
    80004912:	854a                	mv	a0,s2
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	932080e7          	jalr	-1742(ra) # 80003246 <dirlink>
    8000491c:	04054763          	bltz	a0,8000496a <sys_link+0x108>
  iunlockput(dp);
    80004920:	854a                	mv	a0,s2
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	47a080e7          	jalr	1146(ra) # 80002d9c <iunlockput>
  iput(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	3c8080e7          	jalr	968(ra) # 80002cf4 <iput>
  end_op();
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	c4e080e7          	jalr	-946(ra) # 80003582 <end_op>
  return 0;
    8000493c:	4781                	li	a5,0
    8000493e:	64f2                	ld	s1,280(sp)
    80004940:	6952                	ld	s2,272(sp)
    80004942:	a0a5                	j	800049aa <sys_link+0x148>
    end_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	c3e080e7          	jalr	-962(ra) # 80003582 <end_op>
    return -1;
    8000494c:	57fd                	li	a5,-1
    8000494e:	64f2                	ld	s1,280(sp)
    80004950:	a8a9                	j	800049aa <sys_link+0x148>
    iunlockput(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	448080e7          	jalr	1096(ra) # 80002d9c <iunlockput>
    end_op();
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	c26080e7          	jalr	-986(ra) # 80003582 <end_op>
    return -1;
    80004964:	57fd                	li	a5,-1
    80004966:	64f2                	ld	s1,280(sp)
    80004968:	a089                	j	800049aa <sys_link+0x148>
    iunlockput(dp);
    8000496a:	854a                	mv	a0,s2
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	430080e7          	jalr	1072(ra) # 80002d9c <iunlockput>
  ilock(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	1c0080e7          	jalr	448(ra) # 80002b36 <ilock>
  ip->nlink--;
    8000497e:	04a4d783          	lhu	a5,74(s1)
    80004982:	37fd                	addiw	a5,a5,-1
    80004984:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	0e0080e7          	jalr	224(ra) # 80002a6a <iupdate>
  iunlockput(ip);
    80004992:	8526                	mv	a0,s1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	408080e7          	jalr	1032(ra) # 80002d9c <iunlockput>
  end_op();
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	be6080e7          	jalr	-1050(ra) # 80003582 <end_op>
  return -1;
    800049a4:	57fd                	li	a5,-1
    800049a6:	64f2                	ld	s1,280(sp)
    800049a8:	6952                	ld	s2,272(sp)
}
    800049aa:	853e                	mv	a0,a5
    800049ac:	70b2                	ld	ra,296(sp)
    800049ae:	7412                	ld	s0,288(sp)
    800049b0:	6155                	addi	sp,sp,304
    800049b2:	8082                	ret

00000000800049b4 <sys_unlink>:
{
    800049b4:	7151                	addi	sp,sp,-240
    800049b6:	f586                	sd	ra,232(sp)
    800049b8:	f1a2                	sd	s0,224(sp)
    800049ba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049bc:	08000613          	li	a2,128
    800049c0:	f3040593          	addi	a1,s0,-208
    800049c4:	4501                	li	a0,0
    800049c6:	ffffd097          	auipc	ra,0xffffd
    800049ca:	642080e7          	jalr	1602(ra) # 80002008 <argstr>
    800049ce:	1a054a63          	bltz	a0,80004b82 <sys_unlink+0x1ce>
    800049d2:	eda6                	sd	s1,216(sp)
  begin_op();
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	b34080e7          	jalr	-1228(ra) # 80003508 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049dc:	fb040593          	addi	a1,s0,-80
    800049e0:	f3040513          	addi	a0,s0,-208
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	942080e7          	jalr	-1726(ra) # 80003326 <nameiparent>
    800049ec:	84aa                	mv	s1,a0
    800049ee:	cd71                	beqz	a0,80004aca <sys_unlink+0x116>
  ilock(dp);
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	146080e7          	jalr	326(ra) # 80002b36 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049f8:	00005597          	auipc	a1,0x5
    800049fc:	b9858593          	addi	a1,a1,-1128 # 80009590 <etext+0x590>
    80004a00:	fb040513          	addi	a0,s0,-80
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	618080e7          	jalr	1560(ra) # 8000301c <namecmp>
    80004a0c:	14050c63          	beqz	a0,80004b64 <sys_unlink+0x1b0>
    80004a10:	00005597          	auipc	a1,0x5
    80004a14:	b8858593          	addi	a1,a1,-1144 # 80009598 <etext+0x598>
    80004a18:	fb040513          	addi	a0,s0,-80
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	600080e7          	jalr	1536(ra) # 8000301c <namecmp>
    80004a24:	14050063          	beqz	a0,80004b64 <sys_unlink+0x1b0>
    80004a28:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a2a:	f2c40613          	addi	a2,s0,-212
    80004a2e:	fb040593          	addi	a1,s0,-80
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	602080e7          	jalr	1538(ra) # 80003036 <dirlookup>
    80004a3c:	892a                	mv	s2,a0
    80004a3e:	12050263          	beqz	a0,80004b62 <sys_unlink+0x1ae>
  ilock(ip);
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	0f4080e7          	jalr	244(ra) # 80002b36 <ilock>
  if(ip->nlink < 1)
    80004a4a:	04a91783          	lh	a5,74(s2)
    80004a4e:	08f05563          	blez	a5,80004ad8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a52:	04491703          	lh	a4,68(s2)
    80004a56:	4785                	li	a5,1
    80004a58:	08f70963          	beq	a4,a5,80004aea <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004a5c:	4641                	li	a2,16
    80004a5e:	4581                	li	a1,0
    80004a60:	fc040513          	addi	a0,s0,-64
    80004a64:	ffffb097          	auipc	ra,0xffffb
    80004a68:	716080e7          	jalr	1814(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a6c:	4741                	li	a4,16
    80004a6e:	f2c42683          	lw	a3,-212(s0)
    80004a72:	fc040613          	addi	a2,s0,-64
    80004a76:	4581                	li	a1,0
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	478080e7          	jalr	1144(ra) # 80002ef2 <writei>
    80004a82:	47c1                	li	a5,16
    80004a84:	0af51b63          	bne	a0,a5,80004b3a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004a88:	04491703          	lh	a4,68(s2)
    80004a8c:	4785                	li	a5,1
    80004a8e:	0af70f63          	beq	a4,a5,80004b4c <sys_unlink+0x198>
  iunlockput(dp);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	308080e7          	jalr	776(ra) # 80002d9c <iunlockput>
  ip->nlink--;
    80004a9c:	04a95783          	lhu	a5,74(s2)
    80004aa0:	37fd                	addiw	a5,a5,-1
    80004aa2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aa6:	854a                	mv	a0,s2
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	fc2080e7          	jalr	-62(ra) # 80002a6a <iupdate>
  iunlockput(ip);
    80004ab0:	854a                	mv	a0,s2
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	2ea080e7          	jalr	746(ra) # 80002d9c <iunlockput>
  end_op();
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	ac8080e7          	jalr	-1336(ra) # 80003582 <end_op>
  return 0;
    80004ac2:	4501                	li	a0,0
    80004ac4:	64ee                	ld	s1,216(sp)
    80004ac6:	694e                	ld	s2,208(sp)
    80004ac8:	a84d                	j	80004b7a <sys_unlink+0x1c6>
    end_op();
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	ab8080e7          	jalr	-1352(ra) # 80003582 <end_op>
    return -1;
    80004ad2:	557d                	li	a0,-1
    80004ad4:	64ee                	ld	s1,216(sp)
    80004ad6:	a055                	j	80004b7a <sys_unlink+0x1c6>
    80004ad8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004ada:	00005517          	auipc	a0,0x5
    80004ade:	ae650513          	addi	a0,a0,-1306 # 800095c0 <etext+0x5c0>
    80004ae2:	00002097          	auipc	ra,0x2
    80004ae6:	1aa080e7          	jalr	426(ra) # 80006c8c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aea:	04c92703          	lw	a4,76(s2)
    80004aee:	02000793          	li	a5,32
    80004af2:	f6e7f5e3          	bgeu	a5,a4,80004a5c <sys_unlink+0xa8>
    80004af6:	e5ce                	sd	s3,200(sp)
    80004af8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afc:	4741                	li	a4,16
    80004afe:	86ce                	mv	a3,s3
    80004b00:	f1840613          	addi	a2,s0,-232
    80004b04:	4581                	li	a1,0
    80004b06:	854a                	mv	a0,s2
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	2e6080e7          	jalr	742(ra) # 80002dee <readi>
    80004b10:	47c1                	li	a5,16
    80004b12:	00f51c63          	bne	a0,a5,80004b2a <sys_unlink+0x176>
    if(de.inum != 0)
    80004b16:	f1845783          	lhu	a5,-232(s0)
    80004b1a:	e7b5                	bnez	a5,80004b86 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b1c:	29c1                	addiw	s3,s3,16
    80004b1e:	04c92783          	lw	a5,76(s2)
    80004b22:	fcf9ede3          	bltu	s3,a5,80004afc <sys_unlink+0x148>
    80004b26:	69ae                	ld	s3,200(sp)
    80004b28:	bf15                	j	80004a5c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004b2a:	00005517          	auipc	a0,0x5
    80004b2e:	aae50513          	addi	a0,a0,-1362 # 800095d8 <etext+0x5d8>
    80004b32:	00002097          	auipc	ra,0x2
    80004b36:	15a080e7          	jalr	346(ra) # 80006c8c <panic>
    80004b3a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004b3c:	00005517          	auipc	a0,0x5
    80004b40:	ab450513          	addi	a0,a0,-1356 # 800095f0 <etext+0x5f0>
    80004b44:	00002097          	auipc	ra,0x2
    80004b48:	148080e7          	jalr	328(ra) # 80006c8c <panic>
    dp->nlink--;
    80004b4c:	04a4d783          	lhu	a5,74(s1)
    80004b50:	37fd                	addiw	a5,a5,-1
    80004b52:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	f12080e7          	jalr	-238(ra) # 80002a6a <iupdate>
    80004b60:	bf0d                	j	80004a92 <sys_unlink+0xde>
    80004b62:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	236080e7          	jalr	566(ra) # 80002d9c <iunlockput>
  end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	a14080e7          	jalr	-1516(ra) # 80003582 <end_op>
  return -1;
    80004b76:	557d                	li	a0,-1
    80004b78:	64ee                	ld	s1,216(sp)
}
    80004b7a:	70ae                	ld	ra,232(sp)
    80004b7c:	740e                	ld	s0,224(sp)
    80004b7e:	616d                	addi	sp,sp,240
    80004b80:	8082                	ret
    return -1;
    80004b82:	557d                	li	a0,-1
    80004b84:	bfdd                	j	80004b7a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004b86:	854a                	mv	a0,s2
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	214080e7          	jalr	532(ra) # 80002d9c <iunlockput>
    goto bad;
    80004b90:	694e                	ld	s2,208(sp)
    80004b92:	69ae                	ld	s3,200(sp)
    80004b94:	bfc1                	j	80004b64 <sys_unlink+0x1b0>

0000000080004b96 <sys_open>:

uint64
sys_open(void)
{
    80004b96:	7131                	addi	sp,sp,-192
    80004b98:	fd06                	sd	ra,184(sp)
    80004b9a:	f922                	sd	s0,176(sp)
    80004b9c:	f526                	sd	s1,168(sp)
    80004b9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ba0:	08000613          	li	a2,128
    80004ba4:	f5040593          	addi	a1,s0,-176
    80004ba8:	4501                	li	a0,0
    80004baa:	ffffd097          	auipc	ra,0xffffd
    80004bae:	45e080e7          	jalr	1118(ra) # 80002008 <argstr>
    return -1;
    80004bb2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bb4:	0c054463          	bltz	a0,80004c7c <sys_open+0xe6>
    80004bb8:	f4c40593          	addi	a1,s0,-180
    80004bbc:	4505                	li	a0,1
    80004bbe:	ffffd097          	auipc	ra,0xffffd
    80004bc2:	406080e7          	jalr	1030(ra) # 80001fc4 <argint>
    80004bc6:	0a054b63          	bltz	a0,80004c7c <sys_open+0xe6>
    80004bca:	f14a                	sd	s2,160(sp)

  begin_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	93c080e7          	jalr	-1732(ra) # 80003508 <begin_op>

  if(omode & O_CREATE){
    80004bd4:	f4c42783          	lw	a5,-180(s0)
    80004bd8:	2007f793          	andi	a5,a5,512
    80004bdc:	cfc5                	beqz	a5,80004c94 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bde:	4681                	li	a3,0
    80004be0:	4601                	li	a2,0
    80004be2:	4589                	li	a1,2
    80004be4:	f5040513          	addi	a0,s0,-176
    80004be8:	00000097          	auipc	ra,0x0
    80004bec:	958080e7          	jalr	-1704(ra) # 80004540 <create>
    80004bf0:	892a                	mv	s2,a0
    if(ip == 0){
    80004bf2:	c959                	beqz	a0,80004c88 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bf4:	04491703          	lh	a4,68(s2)
    80004bf8:	478d                	li	a5,3
    80004bfa:	00f71763          	bne	a4,a5,80004c08 <sys_open+0x72>
    80004bfe:	04695703          	lhu	a4,70(s2)
    80004c02:	47a5                	li	a5,9
    80004c04:	0ce7ef63          	bltu	a5,a4,80004ce2 <sys_open+0x14c>
    80004c08:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	d0c080e7          	jalr	-756(ra) # 80003916 <filealloc>
    80004c12:	89aa                	mv	s3,a0
    80004c14:	c965                	beqz	a0,80004d04 <sys_open+0x16e>
    80004c16:	00000097          	auipc	ra,0x0
    80004c1a:	8e8080e7          	jalr	-1816(ra) # 800044fe <fdalloc>
    80004c1e:	84aa                	mv	s1,a0
    80004c20:	0c054d63          	bltz	a0,80004cfa <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c24:	04491703          	lh	a4,68(s2)
    80004c28:	478d                	li	a5,3
    80004c2a:	0ef70a63          	beq	a4,a5,80004d1e <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c2e:	4789                	li	a5,2
    80004c30:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c34:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004c38:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c3c:	f4c42783          	lw	a5,-180(s0)
    80004c40:	0017c713          	xori	a4,a5,1
    80004c44:	8b05                	andi	a4,a4,1
    80004c46:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c4a:	0037f713          	andi	a4,a5,3
    80004c4e:	00e03733          	snez	a4,a4
    80004c52:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c56:	4007f793          	andi	a5,a5,1024
    80004c5a:	c791                	beqz	a5,80004c66 <sys_open+0xd0>
    80004c5c:	04491703          	lh	a4,68(s2)
    80004c60:	4789                	li	a5,2
    80004c62:	0cf70563          	beq	a4,a5,80004d2c <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	f94080e7          	jalr	-108(ra) # 80002bfc <iunlock>
  end_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	912080e7          	jalr	-1774(ra) # 80003582 <end_op>
    80004c78:	790a                	ld	s2,160(sp)
    80004c7a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	70ea                	ld	ra,184(sp)
    80004c80:	744a                	ld	s0,176(sp)
    80004c82:	74aa                	ld	s1,168(sp)
    80004c84:	6129                	addi	sp,sp,192
    80004c86:	8082                	ret
      end_op();
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	8fa080e7          	jalr	-1798(ra) # 80003582 <end_op>
      return -1;
    80004c90:	790a                	ld	s2,160(sp)
    80004c92:	b7ed                	j	80004c7c <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004c94:	f5040513          	addi	a0,s0,-176
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	670080e7          	jalr	1648(ra) # 80003308 <namei>
    80004ca0:	892a                	mv	s2,a0
    80004ca2:	c90d                	beqz	a0,80004cd4 <sys_open+0x13e>
    ilock(ip);
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	e92080e7          	jalr	-366(ra) # 80002b36 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cac:	04491703          	lh	a4,68(s2)
    80004cb0:	4785                	li	a5,1
    80004cb2:	f4f711e3          	bne	a4,a5,80004bf4 <sys_open+0x5e>
    80004cb6:	f4c42783          	lw	a5,-180(s0)
    80004cba:	d7b9                	beqz	a5,80004c08 <sys_open+0x72>
      iunlockput(ip);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	0de080e7          	jalr	222(ra) # 80002d9c <iunlockput>
      end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	8bc080e7          	jalr	-1860(ra) # 80003582 <end_op>
      return -1;
    80004cce:	54fd                	li	s1,-1
    80004cd0:	790a                	ld	s2,160(sp)
    80004cd2:	b76d                	j	80004c7c <sys_open+0xe6>
      end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	8ae080e7          	jalr	-1874(ra) # 80003582 <end_op>
      return -1;
    80004cdc:	54fd                	li	s1,-1
    80004cde:	790a                	ld	s2,160(sp)
    80004ce0:	bf71                	j	80004c7c <sys_open+0xe6>
    iunlockput(ip);
    80004ce2:	854a                	mv	a0,s2
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	0b8080e7          	jalr	184(ra) # 80002d9c <iunlockput>
    end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	896080e7          	jalr	-1898(ra) # 80003582 <end_op>
    return -1;
    80004cf4:	54fd                	li	s1,-1
    80004cf6:	790a                	ld	s2,160(sp)
    80004cf8:	b751                	j	80004c7c <sys_open+0xe6>
      fileclose(f);
    80004cfa:	854e                	mv	a0,s3
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	cd6080e7          	jalr	-810(ra) # 800039d2 <fileclose>
    iunlockput(ip);
    80004d04:	854a                	mv	a0,s2
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	096080e7          	jalr	150(ra) # 80002d9c <iunlockput>
    end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	874080e7          	jalr	-1932(ra) # 80003582 <end_op>
    return -1;
    80004d16:	54fd                	li	s1,-1
    80004d18:	790a                	ld	s2,160(sp)
    80004d1a:	69ea                	ld	s3,152(sp)
    80004d1c:	b785                	j	80004c7c <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004d1e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d22:	04691783          	lh	a5,70(s2)
    80004d26:	02f99623          	sh	a5,44(s3)
    80004d2a:	b739                	j	80004c38 <sys_open+0xa2>
    itrunc(ip);
    80004d2c:	854a                	mv	a0,s2
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	f1a080e7          	jalr	-230(ra) # 80002c48 <itrunc>
    80004d36:	bf05                	j	80004c66 <sys_open+0xd0>

0000000080004d38 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d38:	7175                	addi	sp,sp,-144
    80004d3a:	e506                	sd	ra,136(sp)
    80004d3c:	e122                	sd	s0,128(sp)
    80004d3e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	7c8080e7          	jalr	1992(ra) # 80003508 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d48:	08000613          	li	a2,128
    80004d4c:	f7040593          	addi	a1,s0,-144
    80004d50:	4501                	li	a0,0
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	2b6080e7          	jalr	694(ra) # 80002008 <argstr>
    80004d5a:	02054963          	bltz	a0,80004d8c <sys_mkdir+0x54>
    80004d5e:	4681                	li	a3,0
    80004d60:	4601                	li	a2,0
    80004d62:	4585                	li	a1,1
    80004d64:	f7040513          	addi	a0,s0,-144
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	7d8080e7          	jalr	2008(ra) # 80004540 <create>
    80004d70:	cd11                	beqz	a0,80004d8c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	02a080e7          	jalr	42(ra) # 80002d9c <iunlockput>
  end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	808080e7          	jalr	-2040(ra) # 80003582 <end_op>
  return 0;
    80004d82:	4501                	li	a0,0
}
    80004d84:	60aa                	ld	ra,136(sp)
    80004d86:	640a                	ld	s0,128(sp)
    80004d88:	6149                	addi	sp,sp,144
    80004d8a:	8082                	ret
    end_op();
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	7f6080e7          	jalr	2038(ra) # 80003582 <end_op>
    return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b7fd                	j	80004d84 <sys_mkdir+0x4c>

0000000080004d98 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d98:	7135                	addi	sp,sp,-160
    80004d9a:	ed06                	sd	ra,152(sp)
    80004d9c:	e922                	sd	s0,144(sp)
    80004d9e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	768080e7          	jalr	1896(ra) # 80003508 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004da8:	08000613          	li	a2,128
    80004dac:	f7040593          	addi	a1,s0,-144
    80004db0:	4501                	li	a0,0
    80004db2:	ffffd097          	auipc	ra,0xffffd
    80004db6:	256080e7          	jalr	598(ra) # 80002008 <argstr>
    80004dba:	04054a63          	bltz	a0,80004e0e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004dbe:	f6c40593          	addi	a1,s0,-148
    80004dc2:	4505                	li	a0,1
    80004dc4:	ffffd097          	auipc	ra,0xffffd
    80004dc8:	200080e7          	jalr	512(ra) # 80001fc4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dcc:	04054163          	bltz	a0,80004e0e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dd0:	f6840593          	addi	a1,s0,-152
    80004dd4:	4509                	li	a0,2
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	1ee080e7          	jalr	494(ra) # 80001fc4 <argint>
     argint(1, &major) < 0 ||
    80004dde:	02054863          	bltz	a0,80004e0e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004de2:	f6841683          	lh	a3,-152(s0)
    80004de6:	f6c41603          	lh	a2,-148(s0)
    80004dea:	458d                	li	a1,3
    80004dec:	f7040513          	addi	a0,s0,-144
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	750080e7          	jalr	1872(ra) # 80004540 <create>
     argint(2, &minor) < 0 ||
    80004df8:	c919                	beqz	a0,80004e0e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	fa2080e7          	jalr	-94(ra) # 80002d9c <iunlockput>
  end_op();
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	780080e7          	jalr	1920(ra) # 80003582 <end_op>
  return 0;
    80004e0a:	4501                	li	a0,0
    80004e0c:	a031                	j	80004e18 <sys_mknod+0x80>
    end_op();
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	774080e7          	jalr	1908(ra) # 80003582 <end_op>
    return -1;
    80004e16:	557d                	li	a0,-1
}
    80004e18:	60ea                	ld	ra,152(sp)
    80004e1a:	644a                	ld	s0,144(sp)
    80004e1c:	610d                	addi	sp,sp,160
    80004e1e:	8082                	ret

0000000080004e20 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e20:	7135                	addi	sp,sp,-160
    80004e22:	ed06                	sd	ra,152(sp)
    80004e24:	e922                	sd	s0,144(sp)
    80004e26:	e14a                	sd	s2,128(sp)
    80004e28:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e2a:	ffffc097          	auipc	ra,0xffffc
    80004e2e:	0aa080e7          	jalr	170(ra) # 80000ed4 <myproc>
    80004e32:	892a                	mv	s2,a0
  
  begin_op();
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	6d4080e7          	jalr	1748(ra) # 80003508 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e3c:	08000613          	li	a2,128
    80004e40:	f6040593          	addi	a1,s0,-160
    80004e44:	4501                	li	a0,0
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	1c2080e7          	jalr	450(ra) # 80002008 <argstr>
    80004e4e:	04054d63          	bltz	a0,80004ea8 <sys_chdir+0x88>
    80004e52:	e526                	sd	s1,136(sp)
    80004e54:	f6040513          	addi	a0,s0,-160
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	4b0080e7          	jalr	1200(ra) # 80003308 <namei>
    80004e60:	84aa                	mv	s1,a0
    80004e62:	c131                	beqz	a0,80004ea6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	cd2080e7          	jalr	-814(ra) # 80002b36 <ilock>
  if(ip->type != T_DIR){
    80004e6c:	04449703          	lh	a4,68(s1)
    80004e70:	4785                	li	a5,1
    80004e72:	04f71163          	bne	a4,a5,80004eb4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	d84080e7          	jalr	-636(ra) # 80002bfc <iunlock>
  iput(p->cwd);
    80004e80:	15093503          	ld	a0,336(s2)
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	e70080e7          	jalr	-400(ra) # 80002cf4 <iput>
  end_op();
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	6f6080e7          	jalr	1782(ra) # 80003582 <end_op>
  p->cwd = ip;
    80004e94:	14993823          	sd	s1,336(s2)
  return 0;
    80004e98:	4501                	li	a0,0
    80004e9a:	64aa                	ld	s1,136(sp)
}
    80004e9c:	60ea                	ld	ra,152(sp)
    80004e9e:	644a                	ld	s0,144(sp)
    80004ea0:	690a                	ld	s2,128(sp)
    80004ea2:	610d                	addi	sp,sp,160
    80004ea4:	8082                	ret
    80004ea6:	64aa                	ld	s1,136(sp)
    end_op();
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	6da080e7          	jalr	1754(ra) # 80003582 <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b7ed                	j	80004e9c <sys_chdir+0x7c>
    iunlockput(ip);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	ee6080e7          	jalr	-282(ra) # 80002d9c <iunlockput>
    end_op();
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	6c4080e7          	jalr	1732(ra) # 80003582 <end_op>
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	64aa                	ld	s1,136(sp)
    80004eca:	bfc9                	j	80004e9c <sys_chdir+0x7c>

0000000080004ecc <sys_exec>:

uint64
sys_exec(void)
{
    80004ecc:	7121                	addi	sp,sp,-448
    80004ece:	ff06                	sd	ra,440(sp)
    80004ed0:	fb22                	sd	s0,432(sp)
    80004ed2:	f34a                	sd	s2,416(sp)
    80004ed4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ed6:	08000613          	li	a2,128
    80004eda:	f5040593          	addi	a1,s0,-176
    80004ede:	4501                	li	a0,0
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	128080e7          	jalr	296(ra) # 80002008 <argstr>
    return -1;
    80004ee8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eea:	0e054a63          	bltz	a0,80004fde <sys_exec+0x112>
    80004eee:	e4840593          	addi	a1,s0,-440
    80004ef2:	4505                	li	a0,1
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	0f2080e7          	jalr	242(ra) # 80001fe6 <argaddr>
    80004efc:	0e054163          	bltz	a0,80004fde <sys_exec+0x112>
    80004f00:	f726                	sd	s1,424(sp)
    80004f02:	ef4e                	sd	s3,408(sp)
    80004f04:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f06:	10000613          	li	a2,256
    80004f0a:	4581                	li	a1,0
    80004f0c:	e5040513          	addi	a0,s0,-432
    80004f10:	ffffb097          	auipc	ra,0xffffb
    80004f14:	26a080e7          	jalr	618(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f18:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f1c:	89a6                	mv	s3,s1
    80004f1e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f20:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f24:	00391513          	slli	a0,s2,0x3
    80004f28:	e4040593          	addi	a1,s0,-448
    80004f2c:	e4843783          	ld	a5,-440(s0)
    80004f30:	953e                	add	a0,a0,a5
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	ff8080e7          	jalr	-8(ra) # 80001f2a <fetchaddr>
    80004f3a:	02054a63          	bltz	a0,80004f6e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004f3e:	e4043783          	ld	a5,-448(s0)
    80004f42:	c7b1                	beqz	a5,80004f8e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f44:	ffffb097          	auipc	ra,0xffffb
    80004f48:	1d6080e7          	jalr	470(ra) # 8000011a <kalloc>
    80004f4c:	85aa                	mv	a1,a0
    80004f4e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f52:	cd11                	beqz	a0,80004f6e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f54:	6605                	lui	a2,0x1
    80004f56:	e4043503          	ld	a0,-448(s0)
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	022080e7          	jalr	34(ra) # 80001f7c <fetchstr>
    80004f62:	00054663          	bltz	a0,80004f6e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004f66:	0905                	addi	s2,s2,1
    80004f68:	09a1                	addi	s3,s3,8
    80004f6a:	fb491de3          	bne	s2,s4,80004f24 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6e:	f5040913          	addi	s2,s0,-176
    80004f72:	6088                	ld	a0,0(s1)
    80004f74:	c12d                	beqz	a0,80004fd6 <sys_exec+0x10a>
    kfree(argv[i]);
    80004f76:	ffffb097          	auipc	ra,0xffffb
    80004f7a:	0a6080e7          	jalr	166(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7e:	04a1                	addi	s1,s1,8
    80004f80:	ff2499e3          	bne	s1,s2,80004f72 <sys_exec+0xa6>
  return -1;
    80004f84:	597d                	li	s2,-1
    80004f86:	74ba                	ld	s1,424(sp)
    80004f88:	69fa                	ld	s3,408(sp)
    80004f8a:	6a5a                	ld	s4,400(sp)
    80004f8c:	a889                	j	80004fde <sys_exec+0x112>
      argv[i] = 0;
    80004f8e:	0009079b          	sext.w	a5,s2
    80004f92:	078e                	slli	a5,a5,0x3
    80004f94:	fd078793          	addi	a5,a5,-48
    80004f98:	97a2                	add	a5,a5,s0
    80004f9a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f9e:	e5040593          	addi	a1,s0,-432
    80004fa2:	f5040513          	addi	a0,s0,-176
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	126080e7          	jalr	294(ra) # 800040cc <exec>
    80004fae:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb0:	f5040993          	addi	s3,s0,-176
    80004fb4:	6088                	ld	a0,0(s1)
    80004fb6:	cd01                	beqz	a0,80004fce <sys_exec+0x102>
    kfree(argv[i]);
    80004fb8:	ffffb097          	auipc	ra,0xffffb
    80004fbc:	064080e7          	jalr	100(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fc0:	04a1                	addi	s1,s1,8
    80004fc2:	ff3499e3          	bne	s1,s3,80004fb4 <sys_exec+0xe8>
    80004fc6:	74ba                	ld	s1,424(sp)
    80004fc8:	69fa                	ld	s3,408(sp)
    80004fca:	6a5a                	ld	s4,400(sp)
    80004fcc:	a809                	j	80004fde <sys_exec+0x112>
  return ret;
    80004fce:	74ba                	ld	s1,424(sp)
    80004fd0:	69fa                	ld	s3,408(sp)
    80004fd2:	6a5a                	ld	s4,400(sp)
    80004fd4:	a029                	j	80004fde <sys_exec+0x112>
  return -1;
    80004fd6:	597d                	li	s2,-1
    80004fd8:	74ba                	ld	s1,424(sp)
    80004fda:	69fa                	ld	s3,408(sp)
    80004fdc:	6a5a                	ld	s4,400(sp)
}
    80004fde:	854a                	mv	a0,s2
    80004fe0:	70fa                	ld	ra,440(sp)
    80004fe2:	745a                	ld	s0,432(sp)
    80004fe4:	791a                	ld	s2,416(sp)
    80004fe6:	6139                	addi	sp,sp,448
    80004fe8:	8082                	ret

0000000080004fea <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fea:	7139                	addi	sp,sp,-64
    80004fec:	fc06                	sd	ra,56(sp)
    80004fee:	f822                	sd	s0,48(sp)
    80004ff0:	f426                	sd	s1,40(sp)
    80004ff2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ff4:	ffffc097          	auipc	ra,0xffffc
    80004ff8:	ee0080e7          	jalr	-288(ra) # 80000ed4 <myproc>
    80004ffc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004ffe:	fd840593          	addi	a1,s0,-40
    80005002:	4501                	li	a0,0
    80005004:	ffffd097          	auipc	ra,0xffffd
    80005008:	fe2080e7          	jalr	-30(ra) # 80001fe6 <argaddr>
    return -1;
    8000500c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000500e:	0e054063          	bltz	a0,800050ee <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005012:	fc840593          	addi	a1,s0,-56
    80005016:	fd040513          	addi	a0,s0,-48
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	d70080e7          	jalr	-656(ra) # 80003d8a <pipealloc>
    return -1;
    80005022:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005024:	0c054563          	bltz	a0,800050ee <sys_pipe+0x104>
  fd0 = -1;
    80005028:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000502c:	fd043503          	ld	a0,-48(s0)
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	4ce080e7          	jalr	1230(ra) # 800044fe <fdalloc>
    80005038:	fca42223          	sw	a0,-60(s0)
    8000503c:	08054c63          	bltz	a0,800050d4 <sys_pipe+0xea>
    80005040:	fc843503          	ld	a0,-56(s0)
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	4ba080e7          	jalr	1210(ra) # 800044fe <fdalloc>
    8000504c:	fca42023          	sw	a0,-64(s0)
    80005050:	06054963          	bltz	a0,800050c2 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005054:	4691                	li	a3,4
    80005056:	fc440613          	addi	a2,s0,-60
    8000505a:	fd843583          	ld	a1,-40(s0)
    8000505e:	68a8                	ld	a0,80(s1)
    80005060:	ffffc097          	auipc	ra,0xffffc
    80005064:	b14080e7          	jalr	-1260(ra) # 80000b74 <copyout>
    80005068:	02054063          	bltz	a0,80005088 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000506c:	4691                	li	a3,4
    8000506e:	fc040613          	addi	a2,s0,-64
    80005072:	fd843583          	ld	a1,-40(s0)
    80005076:	0591                	addi	a1,a1,4
    80005078:	68a8                	ld	a0,80(s1)
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	afa080e7          	jalr	-1286(ra) # 80000b74 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005082:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005084:	06055563          	bgez	a0,800050ee <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005088:	fc442783          	lw	a5,-60(s0)
    8000508c:	07e9                	addi	a5,a5,26
    8000508e:	078e                	slli	a5,a5,0x3
    80005090:	97a6                	add	a5,a5,s1
    80005092:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005096:	fc042783          	lw	a5,-64(s0)
    8000509a:	07e9                	addi	a5,a5,26
    8000509c:	078e                	slli	a5,a5,0x3
    8000509e:	00f48533          	add	a0,s1,a5
    800050a2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050a6:	fd043503          	ld	a0,-48(s0)
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	928080e7          	jalr	-1752(ra) # 800039d2 <fileclose>
    fileclose(wf);
    800050b2:	fc843503          	ld	a0,-56(s0)
    800050b6:	fffff097          	auipc	ra,0xfffff
    800050ba:	91c080e7          	jalr	-1764(ra) # 800039d2 <fileclose>
    return -1;
    800050be:	57fd                	li	a5,-1
    800050c0:	a03d                	j	800050ee <sys_pipe+0x104>
    if(fd0 >= 0)
    800050c2:	fc442783          	lw	a5,-60(s0)
    800050c6:	0007c763          	bltz	a5,800050d4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050ca:	07e9                	addi	a5,a5,26
    800050cc:	078e                	slli	a5,a5,0x3
    800050ce:	97a6                	add	a5,a5,s1
    800050d0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050d4:	fd043503          	ld	a0,-48(s0)
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	8fa080e7          	jalr	-1798(ra) # 800039d2 <fileclose>
    fileclose(wf);
    800050e0:	fc843503          	ld	a0,-56(s0)
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	8ee080e7          	jalr	-1810(ra) # 800039d2 <fileclose>
    return -1;
    800050ec:	57fd                	li	a5,-1
}
    800050ee:	853e                	mv	a0,a5
    800050f0:	70e2                	ld	ra,56(sp)
    800050f2:	7442                	ld	s0,48(sp)
    800050f4:	74a2                	ld	s1,40(sp)
    800050f6:	6121                	addi	sp,sp,64
    800050f8:	8082                	ret

00000000800050fa <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    800050fa:	7179                	addi	sp,sp,-48
    800050fc:	f406                	sd	ra,40(sp)
    800050fe:	f022                	sd	s0,32(sp)
    80005100:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
    80005102:	fe440593          	addi	a1,s0,-28
    80005106:	4501                	li	a0,0
    80005108:	ffffd097          	auipc	ra,0xffffd
    8000510c:	ebc080e7          	jalr	-324(ra) # 80001fc4 <argint>
    80005110:	06054663          	bltz	a0,8000517c <sys_connect+0x82>
      argint(1, (int*)&lport) < 0 ||
    80005114:	fdc40593          	addi	a1,s0,-36
    80005118:	4505                	li	a0,1
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	eaa080e7          	jalr	-342(ra) # 80001fc4 <argint>
  if (argint(0, (int*)&raddr) < 0 ||
    80005122:	04054f63          	bltz	a0,80005180 <sys_connect+0x86>
      argint(2, (int*)&rport) < 0) {
    80005126:	fe040593          	addi	a1,s0,-32
    8000512a:	4509                	li	a0,2
    8000512c:	ffffd097          	auipc	ra,0xffffd
    80005130:	e98080e7          	jalr	-360(ra) # 80001fc4 <argint>
      argint(1, (int*)&lport) < 0 ||
    80005134:	04054863          	bltz	a0,80005184 <sys_connect+0x8a>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
    80005138:	fe045683          	lhu	a3,-32(s0)
    8000513c:	fdc45603          	lhu	a2,-36(s0)
    80005140:	fe442583          	lw	a1,-28(s0)
    80005144:	fe840513          	addi	a0,s0,-24
    80005148:	00001097          	auipc	ra,0x1
    8000514c:	190080e7          	jalr	400(ra) # 800062d8 <sockalloc>
    80005150:	02054c63          	bltz	a0,80005188 <sys_connect+0x8e>
    return -1;
  if((fd=fdalloc(f)) < 0){
    80005154:	fe843503          	ld	a0,-24(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	3a6080e7          	jalr	934(ra) # 800044fe <fdalloc>
    80005160:	00054663          	bltz	a0,8000516c <sys_connect+0x72>
    fileclose(f);
    return -1;
  }

  return fd;
}
    80005164:	70a2                	ld	ra,40(sp)
    80005166:	7402                	ld	s0,32(sp)
    80005168:	6145                	addi	sp,sp,48
    8000516a:	8082                	ret
    fileclose(f);
    8000516c:	fe843503          	ld	a0,-24(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	862080e7          	jalr	-1950(ra) # 800039d2 <fileclose>
    return -1;
    80005178:	557d                	li	a0,-1
    8000517a:	b7ed                	j	80005164 <sys_connect+0x6a>
    return -1;
    8000517c:	557d                	li	a0,-1
    8000517e:	b7dd                	j	80005164 <sys_connect+0x6a>
    80005180:	557d                	li	a0,-1
    80005182:	b7cd                	j	80005164 <sys_connect+0x6a>
    80005184:	557d                	li	a0,-1
    80005186:	bff9                	j	80005164 <sys_connect+0x6a>
    return -1;
    80005188:	557d                	li	a0,-1
    8000518a:	bfe9                	j	80005164 <sys_connect+0x6a>
    8000518c:	0000                	unimp
	...

0000000080005190 <kernelvec>:
    80005190:	7111                	addi	sp,sp,-256
    80005192:	e006                	sd	ra,0(sp)
    80005194:	e40a                	sd	sp,8(sp)
    80005196:	e80e                	sd	gp,16(sp)
    80005198:	ec12                	sd	tp,24(sp)
    8000519a:	f016                	sd	t0,32(sp)
    8000519c:	f41a                	sd	t1,40(sp)
    8000519e:	f81e                	sd	t2,48(sp)
    800051a0:	fc22                	sd	s0,56(sp)
    800051a2:	e0a6                	sd	s1,64(sp)
    800051a4:	e4aa                	sd	a0,72(sp)
    800051a6:	e8ae                	sd	a1,80(sp)
    800051a8:	ecb2                	sd	a2,88(sp)
    800051aa:	f0b6                	sd	a3,96(sp)
    800051ac:	f4ba                	sd	a4,104(sp)
    800051ae:	f8be                	sd	a5,112(sp)
    800051b0:	fcc2                	sd	a6,120(sp)
    800051b2:	e146                	sd	a7,128(sp)
    800051b4:	e54a                	sd	s2,136(sp)
    800051b6:	e94e                	sd	s3,144(sp)
    800051b8:	ed52                	sd	s4,152(sp)
    800051ba:	f156                	sd	s5,160(sp)
    800051bc:	f55a                	sd	s6,168(sp)
    800051be:	f95e                	sd	s7,176(sp)
    800051c0:	fd62                	sd	s8,184(sp)
    800051c2:	e1e6                	sd	s9,192(sp)
    800051c4:	e5ea                	sd	s10,200(sp)
    800051c6:	e9ee                	sd	s11,208(sp)
    800051c8:	edf2                	sd	t3,216(sp)
    800051ca:	f1f6                	sd	t4,224(sp)
    800051cc:	f5fa                	sd	t5,232(sp)
    800051ce:	f9fe                	sd	t6,240(sp)
    800051d0:	c27fc0ef          	jal	80001df6 <kerneltrap>
    800051d4:	6082                	ld	ra,0(sp)
    800051d6:	6122                	ld	sp,8(sp)
    800051d8:	61c2                	ld	gp,16(sp)
    800051da:	7282                	ld	t0,32(sp)
    800051dc:	7322                	ld	t1,40(sp)
    800051de:	73c2                	ld	t2,48(sp)
    800051e0:	7462                	ld	s0,56(sp)
    800051e2:	6486                	ld	s1,64(sp)
    800051e4:	6526                	ld	a0,72(sp)
    800051e6:	65c6                	ld	a1,80(sp)
    800051e8:	6666                	ld	a2,88(sp)
    800051ea:	7686                	ld	a3,96(sp)
    800051ec:	7726                	ld	a4,104(sp)
    800051ee:	77c6                	ld	a5,112(sp)
    800051f0:	7866                	ld	a6,120(sp)
    800051f2:	688a                	ld	a7,128(sp)
    800051f4:	692a                	ld	s2,136(sp)
    800051f6:	69ca                	ld	s3,144(sp)
    800051f8:	6a6a                	ld	s4,152(sp)
    800051fa:	7a8a                	ld	s5,160(sp)
    800051fc:	7b2a                	ld	s6,168(sp)
    800051fe:	7bca                	ld	s7,176(sp)
    80005200:	7c6a                	ld	s8,184(sp)
    80005202:	6c8e                	ld	s9,192(sp)
    80005204:	6d2e                	ld	s10,200(sp)
    80005206:	6dce                	ld	s11,208(sp)
    80005208:	6e6e                	ld	t3,216(sp)
    8000520a:	7e8e                	ld	t4,224(sp)
    8000520c:	7f2e                	ld	t5,232(sp)
    8000520e:	7fce                	ld	t6,240(sp)
    80005210:	6111                	addi	sp,sp,256
    80005212:	10200073          	sret
    80005216:	00000013          	nop
    8000521a:	00000013          	nop
    8000521e:	0001                	nop

0000000080005220 <timervec>:
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	e10c                	sd	a1,0(a0)
    80005226:	e510                	sd	a2,8(a0)
    80005228:	e914                	sd	a3,16(a0)
    8000522a:	6d0c                	ld	a1,24(a0)
    8000522c:	7110                	ld	a2,32(a0)
    8000522e:	6194                	ld	a3,0(a1)
    80005230:	96b2                	add	a3,a3,a2
    80005232:	e194                	sd	a3,0(a1)
    80005234:	4589                	li	a1,2
    80005236:	14459073          	csrw	sip,a1
    8000523a:	6914                	ld	a3,16(a0)
    8000523c:	6510                	ld	a2,8(a0)
    8000523e:	610c                	ld	a1,0(a0)
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	30200073          	mret
	...

000000008000524a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524a:	1141                	addi	sp,sp,-16
    8000524c:	e422                	sd	s0,8(sp)
    8000524e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005250:	0c0007b7          	lui	a5,0xc000
    80005254:	4705                	li	a4,1
    80005256:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005258:	0c0007b7          	lui	a5,0xc000
    8000525c:	c3d8                	sw	a4,4(a5)
    8000525e:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    80005260:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    80005262:	0c000737          	lui	a4,0xc000
    80005266:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    8000526a:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    8000526c:	0791                	addi	a5,a5,4
    8000526e:	fee79ee3          	bne	a5,a4,8000526a <plicinit+0x20>
  }
#endif  
}
    80005272:	6422                	ld	s0,8(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret

0000000080005278 <plicinithart>:

void
plicinithart(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	c28080e7          	jalr	-984(ra) # 80000ea8 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005288:	0085171b          	slliw	a4,a0,0x8
    8000528c:	0c0027b7          	lui	a5,0xc002
    80005290:	97ba                	add	a5,a5,a4
    80005292:	40200713          	li	a4,1026
    80005296:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    8000529a:	577d                	li	a4,-1
    8000529c:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a0:	00d5151b          	slliw	a0,a0,0xd
    800052a4:	0c2017b7          	lui	a5,0xc201
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052ae:	60a2                	ld	ra,8(sp)
    800052b0:	6402                	ld	s0,0(sp)
    800052b2:	0141                	addi	sp,sp,16
    800052b4:	8082                	ret

00000000800052b6 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052b6:	1141                	addi	sp,sp,-16
    800052b8:	e406                	sd	ra,8(sp)
    800052ba:	e022                	sd	s0,0(sp)
    800052bc:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052be:	ffffc097          	auipc	ra,0xffffc
    800052c2:	bea080e7          	jalr	-1046(ra) # 80000ea8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052c6:	00d5151b          	slliw	a0,a0,0xd
    800052ca:	0c2017b7          	lui	a5,0xc201
    800052ce:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d0:	43c8                	lw	a0,4(a5)
    800052d2:	60a2                	ld	ra,8(sp)
    800052d4:	6402                	ld	s0,0(sp)
    800052d6:	0141                	addi	sp,sp,16
    800052d8:	8082                	ret

00000000800052da <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052da:	1101                	addi	sp,sp,-32
    800052dc:	ec06                	sd	ra,24(sp)
    800052de:	e822                	sd	s0,16(sp)
    800052e0:	e426                	sd	s1,8(sp)
    800052e2:	1000                	addi	s0,sp,32
    800052e4:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052e6:	ffffc097          	auipc	ra,0xffffc
    800052ea:	bc2080e7          	jalr	-1086(ra) # 80000ea8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052ee:	00d5151b          	slliw	a0,a0,0xd
    800052f2:	0c2017b7          	lui	a5,0xc201
    800052f6:	97aa                	add	a5,a5,a0
    800052f8:	c3c4                	sw	s1,4(a5)
}
    800052fa:	60e2                	ld	ra,24(sp)
    800052fc:	6442                	ld	s0,16(sp)
    800052fe:	64a2                	ld	s1,8(sp)
    80005300:	6105                	addi	sp,sp,32
    80005302:	8082                	ret

0000000080005304 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005304:	1141                	addi	sp,sp,-16
    80005306:	e406                	sd	ra,8(sp)
    80005308:	e022                	sd	s0,0(sp)
    8000530a:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000530c:	479d                	li	a5,7
    8000530e:	06a7c863          	blt	a5,a0,8000537e <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005312:	0001a717          	auipc	a4,0x1a
    80005316:	cee70713          	addi	a4,a4,-786 # 8001f000 <disk>
    8000531a:	972a                	add	a4,a4,a0
    8000531c:	6789                	lui	a5,0x2
    8000531e:	97ba                	add	a5,a5,a4
    80005320:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005324:	e7ad                	bnez	a5,8000538e <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005326:	00451793          	slli	a5,a0,0x4
    8000532a:	0001c717          	auipc	a4,0x1c
    8000532e:	cd670713          	addi	a4,a4,-810 # 80021000 <disk+0x2000>
    80005332:	6314                	ld	a3,0(a4)
    80005334:	96be                	add	a3,a3,a5
    80005336:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000533a:	6314                	ld	a3,0(a4)
    8000533c:	96be                	add	a3,a3,a5
    8000533e:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005342:	6314                	ld	a3,0(a4)
    80005344:	96be                	add	a3,a3,a5
    80005346:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000534a:	6318                	ld	a4,0(a4)
    8000534c:	97ba                	add	a5,a5,a4
    8000534e:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005352:	0001a717          	auipc	a4,0x1a
    80005356:	cae70713          	addi	a4,a4,-850 # 8001f000 <disk>
    8000535a:	972a                	add	a4,a4,a0
    8000535c:	6789                	lui	a5,0x2
    8000535e:	97ba                	add	a5,a5,a4
    80005360:	4705                	li	a4,1
    80005362:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005366:	0001c517          	auipc	a0,0x1c
    8000536a:	cb250513          	addi	a0,a0,-846 # 80021018 <disk+0x2018>
    8000536e:	ffffc097          	auipc	ra,0xffffc
    80005372:	3b8080e7          	jalr	952(ra) # 80001726 <wakeup>
}
    80005376:	60a2                	ld	ra,8(sp)
    80005378:	6402                	ld	s0,0(sp)
    8000537a:	0141                	addi	sp,sp,16
    8000537c:	8082                	ret
    panic("free_desc 1");
    8000537e:	00004517          	auipc	a0,0x4
    80005382:	28250513          	addi	a0,a0,642 # 80009600 <etext+0x600>
    80005386:	00002097          	auipc	ra,0x2
    8000538a:	906080e7          	jalr	-1786(ra) # 80006c8c <panic>
    panic("free_desc 2");
    8000538e:	00004517          	auipc	a0,0x4
    80005392:	28250513          	addi	a0,a0,642 # 80009610 <etext+0x610>
    80005396:	00002097          	auipc	ra,0x2
    8000539a:	8f6080e7          	jalr	-1802(ra) # 80006c8c <panic>

000000008000539e <virtio_disk_init>:
{
    8000539e:	1141                	addi	sp,sp,-16
    800053a0:	e406                	sd	ra,8(sp)
    800053a2:	e022                	sd	s0,0(sp)
    800053a4:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053a6:	00004597          	auipc	a1,0x4
    800053aa:	27a58593          	addi	a1,a1,634 # 80009620 <etext+0x620>
    800053ae:	0001c517          	auipc	a0,0x1c
    800053b2:	d7a50513          	addi	a0,a0,-646 # 80021128 <disk+0x2128>
    800053b6:	00002097          	auipc	ra,0x2
    800053ba:	dc0080e7          	jalr	-576(ra) # 80007176 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053be:	100017b7          	lui	a5,0x10001
    800053c2:	4398                	lw	a4,0(a5)
    800053c4:	2701                	sext.w	a4,a4
    800053c6:	747277b7          	lui	a5,0x74727
    800053ca:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053ce:	0ef71f63          	bne	a4,a5,800054cc <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d2:	100017b7          	lui	a5,0x10001
    800053d6:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053d8:	439c                	lw	a5,0(a5)
    800053da:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053dc:	4705                	li	a4,1
    800053de:	0ee79763          	bne	a5,a4,800054cc <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e2:	100017b7          	lui	a5,0x10001
    800053e6:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053e8:	439c                	lw	a5,0(a5)
    800053ea:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ec:	4709                	li	a4,2
    800053ee:	0ce79f63          	bne	a5,a4,800054cc <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053f2:	100017b7          	lui	a5,0x10001
    800053f6:	47d8                	lw	a4,12(a5)
    800053f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053fa:	554d47b7          	lui	a5,0x554d4
    800053fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005402:	0cf71563          	bne	a4,a5,800054cc <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	4705                	li	a4,1
    8000540c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540e:	470d                	li	a4,3
    80005410:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005412:	10001737          	lui	a4,0x10001
    80005416:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005418:	c7ffe737          	lui	a4,0xc7ffe
    8000541c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd41df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005420:	8ef9                	and	a3,a3,a4
    80005422:	10001737          	lui	a4,0x10001
    80005426:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	472d                	li	a4,11
    8000542a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542c:	473d                	li	a4,15
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005430:	100017b7          	lui	a5,0x10001
    80005434:	6705                	lui	a4,0x1
    80005436:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005438:	100017b7          	lui	a5,0x10001
    8000543c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005440:	100017b7          	lui	a5,0x10001
    80005444:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005448:	439c                	lw	a5,0(a5)
    8000544a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000544c:	cbc1                	beqz	a5,800054dc <virtio_disk_init+0x13e>
  if(max < NUM)
    8000544e:	471d                	li	a4,7
    80005450:	08f77e63          	bgeu	a4,a5,800054ec <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	4721                	li	a4,8
    8000545a:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000545c:	6609                	lui	a2,0x2
    8000545e:	4581                	li	a1,0
    80005460:	0001a517          	auipc	a0,0x1a
    80005464:	ba050513          	addi	a0,a0,-1120 # 8001f000 <disk>
    80005468:	ffffb097          	auipc	ra,0xffffb
    8000546c:	d12080e7          	jalr	-750(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005470:	0001a697          	auipc	a3,0x1a
    80005474:	b9068693          	addi	a3,a3,-1136 # 8001f000 <disk>
    80005478:	00c6d713          	srli	a4,a3,0xc
    8000547c:	2701                	sext.w	a4,a4
    8000547e:	100017b7          	lui	a5,0x10001
    80005482:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005484:	0001c797          	auipc	a5,0x1c
    80005488:	b7c78793          	addi	a5,a5,-1156 # 80021000 <disk+0x2000>
    8000548c:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    8000548e:	0001a717          	auipc	a4,0x1a
    80005492:	bf270713          	addi	a4,a4,-1038 # 8001f080 <disk+0x80>
    80005496:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005498:	0001b717          	auipc	a4,0x1b
    8000549c:	b6870713          	addi	a4,a4,-1176 # 80020000 <disk+0x1000>
    800054a0:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054a2:	4705                	li	a4,1
    800054a4:	00e78c23          	sb	a4,24(a5)
    800054a8:	00e78ca3          	sb	a4,25(a5)
    800054ac:	00e78d23          	sb	a4,26(a5)
    800054b0:	00e78da3          	sb	a4,27(a5)
    800054b4:	00e78e23          	sb	a4,28(a5)
    800054b8:	00e78ea3          	sb	a4,29(a5)
    800054bc:	00e78f23          	sb	a4,30(a5)
    800054c0:	00e78fa3          	sb	a4,31(a5)
}
    800054c4:	60a2                	ld	ra,8(sp)
    800054c6:	6402                	ld	s0,0(sp)
    800054c8:	0141                	addi	sp,sp,16
    800054ca:	8082                	ret
    panic("could not find virtio disk");
    800054cc:	00004517          	auipc	a0,0x4
    800054d0:	16450513          	addi	a0,a0,356 # 80009630 <etext+0x630>
    800054d4:	00001097          	auipc	ra,0x1
    800054d8:	7b8080e7          	jalr	1976(ra) # 80006c8c <panic>
    panic("virtio disk has no queue 0");
    800054dc:	00004517          	auipc	a0,0x4
    800054e0:	17450513          	addi	a0,a0,372 # 80009650 <etext+0x650>
    800054e4:	00001097          	auipc	ra,0x1
    800054e8:	7a8080e7          	jalr	1960(ra) # 80006c8c <panic>
    panic("virtio disk max queue too short");
    800054ec:	00004517          	auipc	a0,0x4
    800054f0:	18450513          	addi	a0,a0,388 # 80009670 <etext+0x670>
    800054f4:	00001097          	auipc	ra,0x1
    800054f8:	798080e7          	jalr	1944(ra) # 80006c8c <panic>

00000000800054fc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054fc:	7159                	addi	sp,sp,-112
    800054fe:	f486                	sd	ra,104(sp)
    80005500:	f0a2                	sd	s0,96(sp)
    80005502:	eca6                	sd	s1,88(sp)
    80005504:	e8ca                	sd	s2,80(sp)
    80005506:	e4ce                	sd	s3,72(sp)
    80005508:	e0d2                	sd	s4,64(sp)
    8000550a:	fc56                	sd	s5,56(sp)
    8000550c:	f85a                	sd	s6,48(sp)
    8000550e:	f45e                	sd	s7,40(sp)
    80005510:	f062                	sd	s8,32(sp)
    80005512:	ec66                	sd	s9,24(sp)
    80005514:	1880                	addi	s0,sp,112
    80005516:	8a2a                	mv	s4,a0
    80005518:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000551a:	00c52c03          	lw	s8,12(a0)
    8000551e:	001c1c1b          	slliw	s8,s8,0x1
    80005522:	1c02                	slli	s8,s8,0x20
    80005524:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005528:	0001c517          	auipc	a0,0x1c
    8000552c:	c0050513          	addi	a0,a0,-1024 # 80021128 <disk+0x2128>
    80005530:	00002097          	auipc	ra,0x2
    80005534:	cd6080e7          	jalr	-810(ra) # 80007206 <acquire>
  for(int i = 0; i < 3; i++){
    80005538:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000553a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000553c:	0001ab97          	auipc	s7,0x1a
    80005540:	ac4b8b93          	addi	s7,s7,-1340 # 8001f000 <disk>
    80005544:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005546:	4a8d                	li	s5,3
    80005548:	a88d                	j	800055ba <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    8000554a:	00fb8733          	add	a4,s7,a5
    8000554e:	975a                	add	a4,a4,s6
    80005550:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005554:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005556:	0207c563          	bltz	a5,80005580 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000555a:	2905                	addiw	s2,s2,1
    8000555c:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000555e:	1b590163          	beq	s2,s5,80005700 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005562:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005564:	0001c717          	auipc	a4,0x1c
    80005568:	ab470713          	addi	a4,a4,-1356 # 80021018 <disk+0x2018>
    8000556c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000556e:	00074683          	lbu	a3,0(a4)
    80005572:	fee1                	bnez	a3,8000554a <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    80005574:	2785                	addiw	a5,a5,1
    80005576:	0705                	addi	a4,a4,1
    80005578:	fe979be3          	bne	a5,s1,8000556e <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    8000557c:	57fd                	li	a5,-1
    8000557e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005580:	03205163          	blez	s2,800055a2 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    80005584:	f9042503          	lw	a0,-112(s0)
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	d7c080e7          	jalr	-644(ra) # 80005304 <free_desc>
      for(int j = 0; j < i; j++)
    80005590:	4785                	li	a5,1
    80005592:	0127d863          	bge	a5,s2,800055a2 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    80005596:	f9442503          	lw	a0,-108(s0)
    8000559a:	00000097          	auipc	ra,0x0
    8000559e:	d6a080e7          	jalr	-662(ra) # 80005304 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a2:	0001c597          	auipc	a1,0x1c
    800055a6:	b8658593          	addi	a1,a1,-1146 # 80021128 <disk+0x2128>
    800055aa:	0001c517          	auipc	a0,0x1c
    800055ae:	a6e50513          	addi	a0,a0,-1426 # 80021018 <disk+0x2018>
    800055b2:	ffffc097          	auipc	ra,0xffffc
    800055b6:	fe8080e7          	jalr	-24(ra) # 8000159a <sleep>
  for(int i = 0; i < 3; i++){
    800055ba:	f9040613          	addi	a2,s0,-112
    800055be:	894e                	mv	s2,s3
    800055c0:	b74d                	j	80005562 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055c2:	0001c717          	auipc	a4,0x1c
    800055c6:	a3e73703          	ld	a4,-1474(a4) # 80021000 <disk+0x2000>
    800055ca:	973e                	add	a4,a4,a5
    800055cc:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055d0:	0001a897          	auipc	a7,0x1a
    800055d4:	a3088893          	addi	a7,a7,-1488 # 8001f000 <disk>
    800055d8:	0001c717          	auipc	a4,0x1c
    800055dc:	a2870713          	addi	a4,a4,-1496 # 80021000 <disk+0x2000>
    800055e0:	6314                	ld	a3,0(a4)
    800055e2:	96be                	add	a3,a3,a5
    800055e4:	00c6d583          	lhu	a1,12(a3)
    800055e8:	0015e593          	ori	a1,a1,1
    800055ec:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055f0:	f9842683          	lw	a3,-104(s0)
    800055f4:	630c                	ld	a1,0(a4)
    800055f6:	97ae                	add	a5,a5,a1
    800055f8:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055fc:	20050593          	addi	a1,a0,512
    80005600:	0592                	slli	a1,a1,0x4
    80005602:	95c6                	add	a1,a1,a7
    80005604:	57fd                	li	a5,-1
    80005606:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000560a:	00469793          	slli	a5,a3,0x4
    8000560e:	00073803          	ld	a6,0(a4)
    80005612:	983e                	add	a6,a6,a5
    80005614:	6689                	lui	a3,0x2
    80005616:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    8000561a:	96b2                	add	a3,a3,a2
    8000561c:	96c6                	add	a3,a3,a7
    8000561e:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005622:	6314                	ld	a3,0(a4)
    80005624:	96be                	add	a3,a3,a5
    80005626:	4605                	li	a2,1
    80005628:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000562a:	6314                	ld	a3,0(a4)
    8000562c:	96be                	add	a3,a3,a5
    8000562e:	4809                	li	a6,2
    80005630:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    80005634:	6314                	ld	a3,0(a4)
    80005636:	97b6                	add	a5,a5,a3
    80005638:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000563c:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005640:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005644:	6714                	ld	a3,8(a4)
    80005646:	0026d783          	lhu	a5,2(a3)
    8000564a:	8b9d                	andi	a5,a5,7
    8000564c:	0786                	slli	a5,a5,0x1
    8000564e:	96be                	add	a3,a3,a5
    80005650:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005654:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005658:	6718                	ld	a4,8(a4)
    8000565a:	00275783          	lhu	a5,2(a4)
    8000565e:	2785                	addiw	a5,a5,1
    80005660:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005664:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005668:	100017b7          	lui	a5,0x10001
    8000566c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005670:	004a2783          	lw	a5,4(s4)
    80005674:	02c79163          	bne	a5,a2,80005696 <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    80005678:	0001c917          	auipc	s2,0x1c
    8000567c:	ab090913          	addi	s2,s2,-1360 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    80005680:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005682:	85ca                	mv	a1,s2
    80005684:	8552                	mv	a0,s4
    80005686:	ffffc097          	auipc	ra,0xffffc
    8000568a:	f14080e7          	jalr	-236(ra) # 8000159a <sleep>
  while(b->disk == 1) {
    8000568e:	004a2783          	lw	a5,4(s4)
    80005692:	fe9788e3          	beq	a5,s1,80005682 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    80005696:	f9042903          	lw	s2,-112(s0)
    8000569a:	20090713          	addi	a4,s2,512
    8000569e:	0712                	slli	a4,a4,0x4
    800056a0:	0001a797          	auipc	a5,0x1a
    800056a4:	96078793          	addi	a5,a5,-1696 # 8001f000 <disk>
    800056a8:	97ba                	add	a5,a5,a4
    800056aa:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056ae:	0001c997          	auipc	s3,0x1c
    800056b2:	95298993          	addi	s3,s3,-1710 # 80021000 <disk+0x2000>
    800056b6:	00491713          	slli	a4,s2,0x4
    800056ba:	0009b783          	ld	a5,0(s3)
    800056be:	97ba                	add	a5,a5,a4
    800056c0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056c4:	854a                	mv	a0,s2
    800056c6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ca:	00000097          	auipc	ra,0x0
    800056ce:	c3a080e7          	jalr	-966(ra) # 80005304 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056d2:	8885                	andi	s1,s1,1
    800056d4:	f0ed                	bnez	s1,800056b6 <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056d6:	0001c517          	auipc	a0,0x1c
    800056da:	a5250513          	addi	a0,a0,-1454 # 80021128 <disk+0x2128>
    800056de:	00002097          	auipc	ra,0x2
    800056e2:	bdc080e7          	jalr	-1060(ra) # 800072ba <release>
}
    800056e6:	70a6                	ld	ra,104(sp)
    800056e8:	7406                	ld	s0,96(sp)
    800056ea:	64e6                	ld	s1,88(sp)
    800056ec:	6946                	ld	s2,80(sp)
    800056ee:	69a6                	ld	s3,72(sp)
    800056f0:	6a06                	ld	s4,64(sp)
    800056f2:	7ae2                	ld	s5,56(sp)
    800056f4:	7b42                	ld	s6,48(sp)
    800056f6:	7ba2                	ld	s7,40(sp)
    800056f8:	7c02                	ld	s8,32(sp)
    800056fa:	6ce2                	ld	s9,24(sp)
    800056fc:	6165                	addi	sp,sp,112
    800056fe:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005700:	f9042503          	lw	a0,-112(s0)
    80005704:	00451613          	slli	a2,a0,0x4
  if(write)
    80005708:	0001a597          	auipc	a1,0x1a
    8000570c:	8f858593          	addi	a1,a1,-1800 # 8001f000 <disk>
    80005710:	20050793          	addi	a5,a0,512
    80005714:	0792                	slli	a5,a5,0x4
    80005716:	97ae                	add	a5,a5,a1
    80005718:	01903733          	snez	a4,s9
    8000571c:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005720:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005724:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005728:	0001c717          	auipc	a4,0x1c
    8000572c:	8d870713          	addi	a4,a4,-1832 # 80021000 <disk+0x2000>
    80005730:	6314                	ld	a3,0(a4)
    80005732:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005734:	6789                	lui	a5,0x2
    80005736:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    8000573a:	97b2                	add	a5,a5,a2
    8000573c:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000573e:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005740:	631c                	ld	a5,0(a4)
    80005742:	97b2                	add	a5,a5,a2
    80005744:	46c1                	li	a3,16
    80005746:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005748:	631c                	ld	a5,0(a4)
    8000574a:	97b2                	add	a5,a5,a2
    8000574c:	4685                	li	a3,1
    8000574e:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005752:	f9442783          	lw	a5,-108(s0)
    80005756:	6314                	ld	a3,0(a4)
    80005758:	96b2                	add	a3,a3,a2
    8000575a:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000575e:	0792                	slli	a5,a5,0x4
    80005760:	6314                	ld	a3,0(a4)
    80005762:	96be                	add	a3,a3,a5
    80005764:	058a0593          	addi	a1,s4,88
    80005768:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    8000576a:	6318                	ld	a4,0(a4)
    8000576c:	973e                	add	a4,a4,a5
    8000576e:	40000693          	li	a3,1024
    80005772:	c714                	sw	a3,8(a4)
  if(write)
    80005774:	e40c97e3          	bnez	s9,800055c2 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005778:	0001c717          	auipc	a4,0x1c
    8000577c:	88873703          	ld	a4,-1912(a4) # 80021000 <disk+0x2000>
    80005780:	973e                	add	a4,a4,a5
    80005782:	4689                	li	a3,2
    80005784:	00d71623          	sh	a3,12(a4)
    80005788:	b5a1                	j	800055d0 <virtio_disk_rw+0xd4>

000000008000578a <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000578a:	1101                	addi	sp,sp,-32
    8000578c:	ec06                	sd	ra,24(sp)
    8000578e:	e822                	sd	s0,16(sp)
    80005790:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005792:	0001c517          	auipc	a0,0x1c
    80005796:	99650513          	addi	a0,a0,-1642 # 80021128 <disk+0x2128>
    8000579a:	00002097          	auipc	ra,0x2
    8000579e:	a6c080e7          	jalr	-1428(ra) # 80007206 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057a2:	100017b7          	lui	a5,0x10001
    800057a6:	53b8                	lw	a4,96(a5)
    800057a8:	8b0d                	andi	a4,a4,3
    800057aa:	100017b7          	lui	a5,0x10001
    800057ae:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057b0:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057b4:	0001c797          	auipc	a5,0x1c
    800057b8:	84c78793          	addi	a5,a5,-1972 # 80021000 <disk+0x2000>
    800057bc:	6b94                	ld	a3,16(a5)
    800057be:	0207d703          	lhu	a4,32(a5)
    800057c2:	0026d783          	lhu	a5,2(a3)
    800057c6:	06f70563          	beq	a4,a5,80005830 <virtio_disk_intr+0xa6>
    800057ca:	e426                	sd	s1,8(sp)
    800057cc:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ce:	0001a917          	auipc	s2,0x1a
    800057d2:	83290913          	addi	s2,s2,-1998 # 8001f000 <disk>
    800057d6:	0001c497          	auipc	s1,0x1c
    800057da:	82a48493          	addi	s1,s1,-2006 # 80021000 <disk+0x2000>
    __sync_synchronize();
    800057de:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e2:	6898                	ld	a4,16(s1)
    800057e4:	0204d783          	lhu	a5,32(s1)
    800057e8:	8b9d                	andi	a5,a5,7
    800057ea:	078e                	slli	a5,a5,0x3
    800057ec:	97ba                	add	a5,a5,a4
    800057ee:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057f0:	20078713          	addi	a4,a5,512
    800057f4:	0712                	slli	a4,a4,0x4
    800057f6:	974a                	add	a4,a4,s2
    800057f8:	03074703          	lbu	a4,48(a4)
    800057fc:	e731                	bnez	a4,80005848 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057fe:	20078793          	addi	a5,a5,512
    80005802:	0792                	slli	a5,a5,0x4
    80005804:	97ca                	add	a5,a5,s2
    80005806:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005808:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000580c:	ffffc097          	auipc	ra,0xffffc
    80005810:	f1a080e7          	jalr	-230(ra) # 80001726 <wakeup>

    disk.used_idx += 1;
    80005814:	0204d783          	lhu	a5,32(s1)
    80005818:	2785                	addiw	a5,a5,1
    8000581a:	17c2                	slli	a5,a5,0x30
    8000581c:	93c1                	srli	a5,a5,0x30
    8000581e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005822:	6898                	ld	a4,16(s1)
    80005824:	00275703          	lhu	a4,2(a4)
    80005828:	faf71be3          	bne	a4,a5,800057de <virtio_disk_intr+0x54>
    8000582c:	64a2                	ld	s1,8(sp)
    8000582e:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005830:	0001c517          	auipc	a0,0x1c
    80005834:	8f850513          	addi	a0,a0,-1800 # 80021128 <disk+0x2128>
    80005838:	00002097          	auipc	ra,0x2
    8000583c:	a82080e7          	jalr	-1406(ra) # 800072ba <release>
}
    80005840:	60e2                	ld	ra,24(sp)
    80005842:	6442                	ld	s0,16(sp)
    80005844:	6105                	addi	sp,sp,32
    80005846:	8082                	ret
      panic("virtio_disk_intr status");
    80005848:	00004517          	auipc	a0,0x4
    8000584c:	e4850513          	addi	a0,a0,-440 # 80009690 <etext+0x690>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	43c080e7          	jalr	1084(ra) # 80006c8c <panic>

0000000080005858 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005858:	7179                	addi	sp,sp,-48
    8000585a:	f406                	sd	ra,40(sp)
    8000585c:	f022                	sd	s0,32(sp)
    8000585e:	ec26                	sd	s1,24(sp)
    80005860:	e84a                	sd	s2,16(sp)
    80005862:	e44e                	sd	s3,8(sp)
    80005864:	1800                	addi	s0,sp,48
    80005866:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80005868:	00004597          	auipc	a1,0x4
    8000586c:	e4058593          	addi	a1,a1,-448 # 800096a8 <etext+0x6a8>
    80005870:	0001c517          	auipc	a0,0x1c
    80005874:	79050513          	addi	a0,a0,1936 # 80022000 <e1000_lock>
    80005878:	00002097          	auipc	ra,0x2
    8000587c:	8fe080e7          	jalr	-1794(ra) # 80007176 <initlock>

  regs = xregs;
    80005880:	00007797          	auipc	a5,0x7
    80005884:	7a97b023          	sd	s1,1952(a5) # 8000d020 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80005888:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    8000588c:	409c                	lw	a5,0(s1)
    8000588e:	00400737          	lui	a4,0x400
    80005892:	8fd9                	or	a5,a5,a4
    80005894:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80005896:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    8000589a:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    8000589e:	10000613          	li	a2,256
    800058a2:	4581                	li	a1,0
    800058a4:	0001c517          	auipc	a0,0x1c
    800058a8:	77c50513          	addi	a0,a0,1916 # 80022020 <tx_ring>
    800058ac:	ffffb097          	auipc	ra,0xffffb
    800058b0:	8ce080e7          	jalr	-1842(ra) # 8000017a <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    800058b4:	0001c717          	auipc	a4,0x1c
    800058b8:	77870713          	addi	a4,a4,1912 # 8002202c <tx_ring+0xc>
    800058bc:	0001d797          	auipc	a5,0x1d
    800058c0:	86478793          	addi	a5,a5,-1948 # 80022120 <tx_mbufs>
    800058c4:	0001d617          	auipc	a2,0x1d
    800058c8:	8dc60613          	addi	a2,a2,-1828 # 800221a0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    800058cc:	4685                	li	a3,1
    800058ce:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    800058d2:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    800058d6:	0741                	addi	a4,a4,16
    800058d8:	07a1                	addi	a5,a5,8
    800058da:	fec79ae3          	bne	a5,a2,800058ce <e1000_init+0x76>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    800058de:	0001c717          	auipc	a4,0x1c
    800058e2:	74270713          	addi	a4,a4,1858 # 80022020 <tx_ring>
    800058e6:	00007797          	auipc	a5,0x7
    800058ea:	73a7b783          	ld	a5,1850(a5) # 8000d020 <regs>
    800058ee:	6691                	lui	a3,0x4
    800058f0:	97b6                	add	a5,a5,a3
    800058f2:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800058f6:	10000713          	li	a4,256
    800058fa:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800058fe:	8007ac23          	sw	zero,-2024(a5)
    80005902:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80005906:	0001d917          	auipc	s2,0x1d
    8000590a:	89a90913          	addi	s2,s2,-1894 # 800221a0 <rx_ring>
    8000590e:	10000613          	li	a2,256
    80005912:	4581                	li	a1,0
    80005914:	854a                	mv	a0,s2
    80005916:	ffffb097          	auipc	ra,0xffffb
    8000591a:	864080e7          	jalr	-1948(ra) # 8000017a <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    8000591e:	0001d497          	auipc	s1,0x1d
    80005922:	98248493          	addi	s1,s1,-1662 # 800222a0 <rx_mbufs>
    80005926:	0001d997          	auipc	s3,0x1d
    8000592a:	9fa98993          	addi	s3,s3,-1542 # 80022320 <lock>
    rx_mbufs[i] = mbufalloc(0);
    8000592e:	4501                	li	a0,0
    80005930:	00000097          	auipc	ra,0x0
    80005934:	402080e7          	jalr	1026(ra) # 80005d32 <mbufalloc>
    80005938:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    8000593a:	c94d                	beqz	a0,800059ec <e1000_init+0x194>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    8000593c:	651c                	ld	a5,8(a0)
    8000593e:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005942:	04a1                	addi	s1,s1,8
    80005944:	0941                	addi	s2,s2,16
    80005946:	ff3494e3          	bne	s1,s3,8000592e <e1000_init+0xd6>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    8000594a:	00007697          	auipc	a3,0x7
    8000594e:	6d66b683          	ld	a3,1750(a3) # 8000d020 <regs>
    80005952:	0001d717          	auipc	a4,0x1d
    80005956:	84e70713          	addi	a4,a4,-1970 # 800221a0 <rx_ring>
    8000595a:	678d                	lui	a5,0x3
    8000595c:	97b6                	add	a5,a5,a3
    8000595e:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005962:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005966:	473d                	li	a4,15
    80005968:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    8000596c:	10000713          	li	a4,256
    80005970:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005974:	6795                	lui	a5,0x5
    80005976:	97b6                	add	a5,a5,a3
    80005978:	12005737          	lui	a4,0x12005
    8000597c:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    80005980:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80005984:	80005737          	lui	a4,0x80005
    80005988:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefffdb0b4>
    8000598c:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80005990:	6795                	lui	a5,0x5
    80005992:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    80005996:	97b6                	add	a5,a5,a3
    80005998:	6715                	lui	a4,0x5
    8000599a:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    8000599e:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    800059a0:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    800059a4:	0791                	addi	a5,a5,4
    800059a6:	fee79de3          	bne	a5,a4,800059a0 <e1000_init+0x148>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    800059aa:	000407b7          	lui	a5,0x40
    800059ae:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    800059b2:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    800059b6:	006027b7          	lui	a5,0x602
    800059ba:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    800059bc:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    800059c0:	040087b7          	lui	a5,0x4008
    800059c4:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    800059c6:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    800059ca:	678d                	lui	a5,0x3
    800059cc:	97b6                	add	a5,a5,a3
    800059ce:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    800059d2:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    800059d6:	08000793          	li	a5,128
    800059da:	0cf6a823          	sw	a5,208(a3)
}
    800059de:	70a2                	ld	ra,40(sp)
    800059e0:	7402                	ld	s0,32(sp)
    800059e2:	64e2                	ld	s1,24(sp)
    800059e4:	6942                	ld	s2,16(sp)
    800059e6:	69a2                	ld	s3,8(sp)
    800059e8:	6145                	addi	sp,sp,48
    800059ea:	8082                	ret
      panic("e1000");
    800059ec:	00004517          	auipc	a0,0x4
    800059f0:	cbc50513          	addi	a0,a0,-836 # 800096a8 <etext+0x6a8>
    800059f4:	00001097          	auipc	ra,0x1
    800059f8:	298080e7          	jalr	664(ra) # 80006c8c <panic>

00000000800059fc <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    800059fc:	7179                	addi	sp,sp,-48
    800059fe:	f406                	sd	ra,40(sp)
    80005a00:	f022                	sd	s0,32(sp)
    80005a02:	ec26                	sd	s1,24(sp)
    80005a04:	e84a                	sd	s2,16(sp)
    80005a06:	e44e                	sd	s3,8(sp)
    80005a08:	1800                	addi	s0,sp,48
    80005a0a:	892a                	mv	s2,a0
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);
    80005a0c:	0001c997          	auipc	s3,0x1c
    80005a10:	5f498993          	addi	s3,s3,1524 # 80022000 <e1000_lock>
    80005a14:	854e                	mv	a0,s3
    80005a16:	00001097          	auipc	ra,0x1
    80005a1a:	7f0080e7          	jalr	2032(ra) # 80007206 <acquire>
  //get the current index
  uint32 tx_index = regs[E1000_TDT];
    80005a1e:	00007797          	auipc	a5,0x7
    80005a22:	6027b783          	ld	a5,1538(a5) # 8000d020 <regs>
    80005a26:	6711                	lui	a4,0x4
    80005a28:	97ba                	add	a5,a5,a4
    80005a2a:	8187a783          	lw	a5,-2024(a5)
    80005a2e:	0007849b          	sext.w	s1,a5
  
  //check status
  if((tx_ring[tx_index].status & E1000_TXD_STAT_DD) == 0){
    80005a32:	02079713          	slli	a4,a5,0x20
    80005a36:	01c75793          	srli	a5,a4,0x1c
    80005a3a:	99be                	add	s3,s3,a5
    80005a3c:	02c9c783          	lbu	a5,44(s3)
    80005a40:	8b85                	andi	a5,a5,1
    80005a42:	cfbd                	beqz	a5,80005ac0 <e1000_transmit+0xc4>
    release(&e1000_lock);
    return -1;
  }

  //free the last mbuf
  if(tx_mbufs[tx_index]){
    80005a44:	02049793          	slli	a5,s1,0x20
    80005a48:	01d7d713          	srli	a4,a5,0x1d
    80005a4c:	0001c797          	auipc	a5,0x1c
    80005a50:	5b478793          	addi	a5,a5,1460 # 80022000 <e1000_lock>
    80005a54:	97ba                	add	a5,a5,a4
    80005a56:	1207b503          	ld	a0,288(a5)
    80005a5a:	c509                	beqz	a0,80005a64 <e1000_transmit+0x68>
    mbuffree(tx_mbufs[tx_index]);
    80005a5c:	00000097          	auipc	ra,0x0
    80005a60:	332080e7          	jalr	818(ra) # 80005d8e <mbuffree>
  }

  //sent mbuf
  tx_mbufs[tx_index] = m;
    80005a64:	0001c517          	auipc	a0,0x1c
    80005a68:	59c50513          	addi	a0,a0,1436 # 80022000 <e1000_lock>
    80005a6c:	02049793          	slli	a5,s1,0x20
    80005a70:	9381                	srli	a5,a5,0x20
    80005a72:	00379713          	slli	a4,a5,0x3
    80005a76:	972a                	add	a4,a4,a0
    80005a78:	13273023          	sd	s2,288(a4) # 4120 <_entry-0x7fffbee0>
  tx_ring[tx_index].addr = (uint64)m->head;
    80005a7c:	0792                	slli	a5,a5,0x4
    80005a7e:	97aa                	add	a5,a5,a0
    80005a80:	00893703          	ld	a4,8(s2)
    80005a84:	f398                	sd	a4,32(a5)
  tx_ring[tx_index].length = m->len;
    80005a86:	01092703          	lw	a4,16(s2)
    80005a8a:	02e79423          	sh	a4,40(a5)
  tx_ring[tx_index].cmd = E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS;
    80005a8e:	4725                	li	a4,9
    80005a90:	02e785a3          	sb	a4,43(a5)

  //sent the next index of mbuf
  regs[E1000_TDT] = (tx_index + 1)% TX_RING_SIZE;
    80005a94:	2485                	addiw	s1,s1,1
    80005a96:	88bd                	andi	s1,s1,15
    80005a98:	00007797          	auipc	a5,0x7
    80005a9c:	5887b783          	ld	a5,1416(a5) # 8000d020 <regs>
    80005aa0:	6711                	lui	a4,0x4
    80005aa2:	97ba                	add	a5,a5,a4
    80005aa4:	8097ac23          	sw	s1,-2024(a5)

  release(&e1000_lock);
    80005aa8:	00002097          	auipc	ra,0x2
    80005aac:	812080e7          	jalr	-2030(ra) # 800072ba <release>
  return 0;
    80005ab0:	4501                	li	a0,0
}
    80005ab2:	70a2                	ld	ra,40(sp)
    80005ab4:	7402                	ld	s0,32(sp)
    80005ab6:	64e2                	ld	s1,24(sp)
    80005ab8:	6942                	ld	s2,16(sp)
    80005aba:	69a2                	ld	s3,8(sp)
    80005abc:	6145                	addi	sp,sp,48
    80005abe:	8082                	ret
    release(&e1000_lock);
    80005ac0:	0001c517          	auipc	a0,0x1c
    80005ac4:	54050513          	addi	a0,a0,1344 # 80022000 <e1000_lock>
    80005ac8:	00001097          	auipc	ra,0x1
    80005acc:	7f2080e7          	jalr	2034(ra) # 800072ba <release>
    return -1;
    80005ad0:	557d                	li	a0,-1
    80005ad2:	b7c5                	j	80005ab2 <e1000_transmit+0xb6>

0000000080005ad4 <e1000_intr>:
  }
}

void
e1000_intr(void)
{
    80005ad4:	7139                	addi	sp,sp,-64
    80005ad6:	fc06                	sd	ra,56(sp)
    80005ad8:	f822                	sd	s0,48(sp)
    80005ada:	e05a                	sd	s6,0(sp)
    80005adc:	0080                	addi	s0,sp,64
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005ade:	00007797          	auipc	a5,0x7
    80005ae2:	5427b783          	ld	a5,1346(a5) # 8000d020 <regs>
    80005ae6:	577d                	li	a4,-1
    80005ae8:	0ce7a023          	sw	a4,192(a5)
    uint32 rx_index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005aec:	670d                	lui	a4,0x3
    80005aee:	97ba                	add	a5,a5,a4
    80005af0:	8187a783          	lw	a5,-2024(a5)
    80005af4:	2785                	addiw	a5,a5,1
    80005af6:	00f7fb13          	andi	s6,a5,15
    if((rx_ring[rx_index].status & E1000_RXD_STAT_DD) == 0)
    80005afa:	004b1793          	slli	a5,s6,0x4
    80005afe:	0001c717          	auipc	a4,0x1c
    80005b02:	50270713          	addi	a4,a4,1282 # 80022000 <e1000_lock>
    80005b06:	97ba                	add	a5,a5,a4
    80005b08:	1ac7c783          	lbu	a5,428(a5)
    80005b0c:	8b85                	andi	a5,a5,1
    80005b0e:	cfbd                	beqz	a5,80005b8c <e1000_intr+0xb8>
    80005b10:	f426                	sd	s1,40(sp)
    80005b12:	f04a                	sd	s2,32(sp)
    80005b14:	ec4e                	sd	s3,24(sp)
    80005b16:	e852                	sd	s4,16(sp)
    80005b18:	e456                	sd	s5,8(sp)
    rx_mbufs[rx_index]->len = rx_ring[rx_index].length;
    80005b1a:	89ba                	mv	s3,a4
    regs[E1000_RDT] = rx_index;
    80005b1c:	00007a97          	auipc	s5,0x7
    80005b20:	504a8a93          	addi	s5,s5,1284 # 8000d020 <regs>
    80005b24:	6a0d                	lui	s4,0x3
    rx_mbufs[rx_index]->len = rx_ring[rx_index].length;
    80005b26:	003b1913          	slli	s2,s6,0x3
    80005b2a:	994e                	add	s2,s2,s3
    80005b2c:	2a093783          	ld	a5,672(s2)
    80005b30:	004b1493          	slli	s1,s6,0x4
    80005b34:	94ce                	add	s1,s1,s3
    80005b36:	1a84d703          	lhu	a4,424(s1)
    80005b3a:	cb98                	sw	a4,16(a5)
    net_rx(rx_mbufs[rx_index]);
    80005b3c:	2a093503          	ld	a0,672(s2)
    80005b40:	00000097          	auipc	ra,0x0
    80005b44:	3c8080e7          	jalr	968(ra) # 80005f08 <net_rx>
    rx_mbufs[rx_index] = mbufalloc(0);
    80005b48:	4501                	li	a0,0
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	1e8080e7          	jalr	488(ra) # 80005d32 <mbufalloc>
    80005b52:	2aa93023          	sd	a0,672(s2)
    rx_ring[rx_index].addr = (uint64)rx_mbufs[rx_index]->head;
    80005b56:	651c                	ld	a5,8(a0)
    80005b58:	1af4b023          	sd	a5,416(s1)
    rx_ring[rx_index].status = 0;
    80005b5c:	1a048623          	sb	zero,428(s1)
    regs[E1000_RDT] = rx_index;
    80005b60:	000ab783          	ld	a5,0(s5)
    80005b64:	97d2                	add	a5,a5,s4
    80005b66:	8167ac23          	sw	s6,-2024(a5)
    uint32 rx_index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005b6a:	8187a783          	lw	a5,-2024(a5)
    80005b6e:	2785                	addiw	a5,a5,1
    80005b70:	00f7fb13          	andi	s6,a5,15
    if((rx_ring[rx_index].status & E1000_RXD_STAT_DD) == 0)
    80005b74:	004b1793          	slli	a5,s6,0x4
    80005b78:	97ce                	add	a5,a5,s3
    80005b7a:	1ac7c783          	lbu	a5,428(a5)
    80005b7e:	8b85                	andi	a5,a5,1
    80005b80:	f3dd                	bnez	a5,80005b26 <e1000_intr+0x52>
    80005b82:	74a2                	ld	s1,40(sp)
    80005b84:	7902                	ld	s2,32(sp)
    80005b86:	69e2                	ld	s3,24(sp)
    80005b88:	6a42                	ld	s4,16(sp)
    80005b8a:	6aa2                	ld	s5,8(sp)

  e1000_recv();
}
    80005b8c:	70e2                	ld	ra,56(sp)
    80005b8e:	7442                	ld	s0,48(sp)
    80005b90:	6b02                	ld	s6,0(sp)
    80005b92:	6121                	addi	sp,sp,64
    80005b94:	8082                	ret

0000000080005b96 <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005b96:	1141                	addi	sp,sp,-16
    80005b98:	e422                	sd	s0,8(sp)
    80005b9a:	0800                	addi	s0,sp,16
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005b9c:	4785                	li	a5,1
    80005b9e:	04b7db63          	bge	a5,a1,80005bf4 <in_cksum+0x5e>
    80005ba2:	ffe5861b          	addiw	a2,a1,-2
    80005ba6:	0016561b          	srliw	a2,a2,0x1
    80005baa:	0016069b          	addiw	a3,a2,1
    80005bae:	02069793          	slli	a5,a3,0x20
    80005bb2:	01f7d693          	srli	a3,a5,0x1f
    80005bb6:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    80005bb8:	4781                	li	a5,0
    sum += *w++;
    80005bba:	0509                	addi	a0,a0,2
    80005bbc:	ffe55703          	lhu	a4,-2(a0)
    80005bc0:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    80005bc2:	fed51ce3          	bne	a0,a3,80005bba <in_cksum+0x24>
    80005bc6:	35f9                	addiw	a1,a1,-2
    80005bc8:	0016161b          	slliw	a2,a2,0x1
    80005bcc:	9d91                	subw	a1,a1,a2
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005bce:	4705                	li	a4,1
    80005bd0:	02e58563          	beq	a1,a4,80005bfa <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005bd4:	03079713          	slli	a4,a5,0x30
    80005bd8:	9341                	srli	a4,a4,0x30
    80005bda:	0107d79b          	srliw	a5,a5,0x10
    80005bde:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    80005be0:	0107d51b          	srliw	a0,a5,0x10
    80005be4:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005be6:	fff54513          	not	a0,a0
  return answer;
}
    80005bea:	1542                	slli	a0,a0,0x30
    80005bec:	9141                	srli	a0,a0,0x30
    80005bee:	6422                	ld	s0,8(sp)
    80005bf0:	0141                	addi	sp,sp,16
    80005bf2:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005bf4:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    80005bf6:	4781                	li	a5,0
    80005bf8:	bfd9                	j	80005bce <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005bfa:	0006c703          	lbu	a4,0(a3)
    sum += answer;
    80005bfe:	9fb9                	addw	a5,a5,a4
    80005c00:	bfd1                	j	80005bd4 <in_cksum+0x3e>

0000000080005c02 <mbufpull>:
{
    80005c02:	1141                	addi	sp,sp,-16
    80005c04:	e422                	sd	s0,8(sp)
    80005c06:	0800                	addi	s0,sp,16
    80005c08:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005c0a:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005c0c:	4b98                	lw	a4,16(a5)
    80005c0e:	00b76b63          	bltu	a4,a1,80005c24 <mbufpull+0x22>
  m->len -= len;
    80005c12:	9f0d                	subw	a4,a4,a1
    80005c14:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005c16:	1582                	slli	a1,a1,0x20
    80005c18:	9181                	srli	a1,a1,0x20
    80005c1a:	95aa                	add	a1,a1,a0
    80005c1c:	e78c                	sd	a1,8(a5)
}
    80005c1e:	6422                	ld	s0,8(sp)
    80005c20:	0141                	addi	sp,sp,16
    80005c22:	8082                	ret
    return 0;
    80005c24:	4501                	li	a0,0
    80005c26:	bfe5                	j	80005c1e <mbufpull+0x1c>

0000000080005c28 <mbufpush>:
{
    80005c28:	87aa                	mv	a5,a0
  m->head -= len;
    80005c2a:	02059713          	slli	a4,a1,0x20
    80005c2e:	9301                	srli	a4,a4,0x20
    80005c30:	6508                	ld	a0,8(a0)
    80005c32:	8d19                	sub	a0,a0,a4
    80005c34:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005c36:	01478713          	addi	a4,a5,20
    80005c3a:	00e56663          	bltu	a0,a4,80005c46 <mbufpush+0x1e>
  m->len += len;
    80005c3e:	4b98                	lw	a4,16(a5)
    80005c40:	9f2d                	addw	a4,a4,a1
    80005c42:	cb98                	sw	a4,16(a5)
}
    80005c44:	8082                	ret
{
    80005c46:	1141                	addi	sp,sp,-16
    80005c48:	e406                	sd	ra,8(sp)
    80005c4a:	e022                	sd	s0,0(sp)
    80005c4c:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005c4e:	00004517          	auipc	a0,0x4
    80005c52:	a6250513          	addi	a0,a0,-1438 # 800096b0 <etext+0x6b0>
    80005c56:	00001097          	auipc	ra,0x1
    80005c5a:	036080e7          	jalr	54(ra) # 80006c8c <panic>

0000000080005c5e <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005c5e:	7179                	addi	sp,sp,-48
    80005c60:	f406                	sd	ra,40(sp)
    80005c62:	f022                	sd	s0,32(sp)
    80005c64:	ec26                	sd	s1,24(sp)
    80005c66:	e84a                	sd	s2,16(sp)
    80005c68:	e44e                	sd	s3,8(sp)
    80005c6a:	1800                	addi	s0,sp,48
    80005c6c:	89aa                	mv	s3,a0
    80005c6e:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005c70:	45b9                	li	a1,14
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	fb6080e7          	jalr	-74(ra) # 80005c28 <mbufpush>
    80005c7a:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005c7c:	4619                	li	a2,6
    80005c7e:	00007597          	auipc	a1,0x7
    80005c82:	97258593          	addi	a1,a1,-1678 # 8000c5f0 <local_mac>
    80005c86:	0519                	addi	a0,a0,6
    80005c88:	ffffa097          	auipc	ra,0xffffa
    80005c8c:	54e080e7          	jalr	1358(ra) # 800001d6 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005c90:	4619                	li	a2,6
    80005c92:	00007597          	auipc	a1,0x7
    80005c96:	95658593          	addi	a1,a1,-1706 # 8000c5e8 <broadcast_mac>
    80005c9a:	8526                	mv	a0,s1
    80005c9c:	ffffa097          	auipc	ra,0xffffa
    80005ca0:	53a080e7          	jalr	1338(ra) # 800001d6 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005ca4:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005ca8:	00f48623          	sb	a5,12(s1)
    80005cac:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005cb0:	854e                	mv	a0,s3
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	d4a080e7          	jalr	-694(ra) # 800059fc <e1000_transmit>
    80005cba:	e901                	bnez	a0,80005cca <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005cbc:	70a2                	ld	ra,40(sp)
    80005cbe:	7402                	ld	s0,32(sp)
    80005cc0:	64e2                	ld	s1,24(sp)
    80005cc2:	6942                	ld	s2,16(sp)
    80005cc4:	69a2                	ld	s3,8(sp)
    80005cc6:	6145                	addi	sp,sp,48
    80005cc8:	8082                	ret
  kfree(m);
    80005cca:	854e                	mv	a0,s3
    80005ccc:	ffffa097          	auipc	ra,0xffffa
    80005cd0:	350080e7          	jalr	848(ra) # 8000001c <kfree>
}
    80005cd4:	b7e5                	j	80005cbc <net_tx_eth+0x5e>

0000000080005cd6 <mbufput>:
{
    80005cd6:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005cd8:	4918                	lw	a4,16(a0)
    80005cda:	02071693          	slli	a3,a4,0x20
    80005cde:	9281                	srli	a3,a3,0x20
    80005ce0:	6508                	ld	a0,8(a0)
    80005ce2:	9536                	add	a0,a0,a3
  m->len += len;
    80005ce4:	9f2d                	addw	a4,a4,a1
    80005ce6:	0007069b          	sext.w	a3,a4
    80005cea:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005cec:	6785                	lui	a5,0x1
    80005cee:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005cf2:	00d7e363          	bltu	a5,a3,80005cf8 <mbufput+0x22>
}
    80005cf6:	8082                	ret
{
    80005cf8:	1141                	addi	sp,sp,-16
    80005cfa:	e406                	sd	ra,8(sp)
    80005cfc:	e022                	sd	s0,0(sp)
    80005cfe:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005d00:	00004517          	auipc	a0,0x4
    80005d04:	9c050513          	addi	a0,a0,-1600 # 800096c0 <etext+0x6c0>
    80005d08:	00001097          	auipc	ra,0x1
    80005d0c:	f84080e7          	jalr	-124(ra) # 80006c8c <panic>

0000000080005d10 <mbuftrim>:
{
    80005d10:	1141                	addi	sp,sp,-16
    80005d12:	e422                	sd	s0,8(sp)
    80005d14:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005d16:	491c                	lw	a5,16(a0)
    80005d18:	00b7eb63          	bltu	a5,a1,80005d2e <mbuftrim+0x1e>
  m->len -= len;
    80005d1c:	9f8d                	subw	a5,a5,a1
    80005d1e:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005d20:	1782                	slli	a5,a5,0x20
    80005d22:	9381                	srli	a5,a5,0x20
    80005d24:	6508                	ld	a0,8(a0)
    80005d26:	953e                	add	a0,a0,a5
}
    80005d28:	6422                	ld	s0,8(sp)
    80005d2a:	0141                	addi	sp,sp,16
    80005d2c:	8082                	ret
    return 0;
    80005d2e:	4501                	li	a0,0
    80005d30:	bfe5                	j	80005d28 <mbuftrim+0x18>

0000000080005d32 <mbufalloc>:
{
    80005d32:	1101                	addi	sp,sp,-32
    80005d34:	ec06                	sd	ra,24(sp)
    80005d36:	e822                	sd	s0,16(sp)
    80005d38:	e04a                	sd	s2,0(sp)
    80005d3a:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005d3c:	6785                	lui	a5,0x1
    80005d3e:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005d42:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005d44:	02a7ed63          	bltu	a5,a0,80005d7e <mbufalloc+0x4c>
    80005d48:	e426                	sd	s1,8(sp)
    80005d4a:	84aa                	mv	s1,a0
  m = kalloc();
    80005d4c:	ffffa097          	auipc	ra,0xffffa
    80005d50:	3ce080e7          	jalr	974(ra) # 8000011a <kalloc>
    80005d54:	892a                	mv	s2,a0
  if (m == 0)
    80005d56:	c915                	beqz	a0,80005d8a <mbufalloc+0x58>
  m->next = 0;
    80005d58:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005d5c:	0551                	addi	a0,a0,20
    80005d5e:	1482                	slli	s1,s1,0x20
    80005d60:	9081                	srli	s1,s1,0x20
    80005d62:	94aa                	add	s1,s1,a0
    80005d64:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005d68:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005d6c:	6605                	lui	a2,0x1
    80005d6e:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005d72:	4581                	li	a1,0
    80005d74:	ffffa097          	auipc	ra,0xffffa
    80005d78:	406080e7          	jalr	1030(ra) # 8000017a <memset>
  return m;
    80005d7c:	64a2                	ld	s1,8(sp)
}
    80005d7e:	854a                	mv	a0,s2
    80005d80:	60e2                	ld	ra,24(sp)
    80005d82:	6442                	ld	s0,16(sp)
    80005d84:	6902                	ld	s2,0(sp)
    80005d86:	6105                	addi	sp,sp,32
    80005d88:	8082                	ret
    80005d8a:	64a2                	ld	s1,8(sp)
    80005d8c:	bfcd                	j	80005d7e <mbufalloc+0x4c>

0000000080005d8e <mbuffree>:
{
    80005d8e:	1141                	addi	sp,sp,-16
    80005d90:	e406                	sd	ra,8(sp)
    80005d92:	e022                	sd	s0,0(sp)
    80005d94:	0800                	addi	s0,sp,16
  kfree(m);
    80005d96:	ffffa097          	auipc	ra,0xffffa
    80005d9a:	286080e7          	jalr	646(ra) # 8000001c <kfree>
}
    80005d9e:	60a2                	ld	ra,8(sp)
    80005da0:	6402                	ld	s0,0(sp)
    80005da2:	0141                	addi	sp,sp,16
    80005da4:	8082                	ret

0000000080005da6 <mbufq_pushtail>:
{
    80005da6:	1141                	addi	sp,sp,-16
    80005da8:	e422                	sd	s0,8(sp)
    80005daa:	0800                	addi	s0,sp,16
  m->next = 0;
    80005dac:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005db0:	611c                	ld	a5,0(a0)
    80005db2:	c799                	beqz	a5,80005dc0 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005db4:	651c                	ld	a5,8(a0)
    80005db6:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005db8:	e50c                	sd	a1,8(a0)
}
    80005dba:	6422                	ld	s0,8(sp)
    80005dbc:	0141                	addi	sp,sp,16
    80005dbe:	8082                	ret
    q->head = q->tail = m;
    80005dc0:	e50c                	sd	a1,8(a0)
    80005dc2:	e10c                	sd	a1,0(a0)
    return;
    80005dc4:	bfdd                	j	80005dba <mbufq_pushtail+0x14>

0000000080005dc6 <mbufq_pophead>:
{
    80005dc6:	1141                	addi	sp,sp,-16
    80005dc8:	e422                	sd	s0,8(sp)
    80005dca:	0800                	addi	s0,sp,16
    80005dcc:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005dce:	6108                	ld	a0,0(a0)
  if (!head)
    80005dd0:	c119                	beqz	a0,80005dd6 <mbufq_pophead+0x10>
  q->head = head->next;
    80005dd2:	6118                	ld	a4,0(a0)
    80005dd4:	e398                	sd	a4,0(a5)
}
    80005dd6:	6422                	ld	s0,8(sp)
    80005dd8:	0141                	addi	sp,sp,16
    80005dda:	8082                	ret

0000000080005ddc <mbufq_empty>:
{
    80005ddc:	1141                	addi	sp,sp,-16
    80005dde:	e422                	sd	s0,8(sp)
    80005de0:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005de2:	6108                	ld	a0,0(a0)
}
    80005de4:	00153513          	seqz	a0,a0
    80005de8:	6422                	ld	s0,8(sp)
    80005dea:	0141                	addi	sp,sp,16
    80005dec:	8082                	ret

0000000080005dee <mbufq_init>:
{
    80005dee:	1141                	addi	sp,sp,-16
    80005df0:	e422                	sd	s0,8(sp)
    80005df2:	0800                	addi	s0,sp,16
  q->head = 0;
    80005df4:	00053023          	sd	zero,0(a0)
}
    80005df8:	6422                	ld	s0,8(sp)
    80005dfa:	0141                	addi	sp,sp,16
    80005dfc:	8082                	ret

0000000080005dfe <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005dfe:	7179                	addi	sp,sp,-48
    80005e00:	f406                	sd	ra,40(sp)
    80005e02:	f022                	sd	s0,32(sp)
    80005e04:	ec26                	sd	s1,24(sp)
    80005e06:	e84a                	sd	s2,16(sp)
    80005e08:	e44e                	sd	s3,8(sp)
    80005e0a:	e052                	sd	s4,0(sp)
    80005e0c:	1800                	addi	s0,sp,48
    80005e0e:	89aa                	mv	s3,a0
    80005e10:	892e                	mv	s2,a1
    80005e12:	8a32                	mv	s4,a2
    80005e14:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005e16:	45a1                	li	a1,8
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	e10080e7          	jalr	-496(ra) # 80005c28 <mbufpush>
    80005e20:	008a179b          	slliw	a5,s4,0x8
    80005e24:	008a5a1b          	srliw	s4,s4,0x8
    80005e28:	0147e7b3          	or	a5,a5,s4
  udphdr->sport = htons(sport);
    80005e2c:	00f51023          	sh	a5,0(a0)
    80005e30:	0084979b          	slliw	a5,s1,0x8
    80005e34:	0084d49b          	srliw	s1,s1,0x8
    80005e38:	8fc5                	or	a5,a5,s1
  udphdr->dport = htons(dport);
    80005e3a:	00f51123          	sh	a5,2(a0)
  udphdr->ulen = htons(m->len);
    80005e3e:	0109a783          	lw	a5,16(s3)
    80005e42:	0087971b          	slliw	a4,a5,0x8
    80005e46:	0107979b          	slliw	a5,a5,0x10
    80005e4a:	0107d79b          	srliw	a5,a5,0x10
    80005e4e:	0087d79b          	srliw	a5,a5,0x8
    80005e52:	8fd9                	or	a5,a5,a4
    80005e54:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005e58:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005e5c:	45d1                	li	a1,20
    80005e5e:	854e                	mv	a0,s3
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	dc8080e7          	jalr	-568(ra) # 80005c28 <mbufpush>
    80005e68:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005e6a:	4651                	li	a2,20
    80005e6c:	4581                	li	a1,0
    80005e6e:	ffffa097          	auipc	ra,0xffffa
    80005e72:	30c080e7          	jalr	780(ra) # 8000017a <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005e76:	04500793          	li	a5,69
    80005e7a:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005e7e:	47c5                	li	a5,17
    80005e80:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005e84:	0f0207b7          	lui	a5,0xf020
    80005e88:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80005e8a:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005e8c:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005e90:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005e94:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005e96:	0089171b          	slliw	a4,s2,0x8
    80005e9a:	00ff06b7          	lui	a3,0xff0
    80005e9e:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005ea0:	8fd9                	or	a5,a5,a4
    80005ea2:	0089591b          	srliw	s2,s2,0x8
    80005ea6:	6741                	lui	a4,0x10
    80005ea8:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005eac:	00e97933          	and	s2,s2,a4
    80005eb0:	0127e7b3          	or	a5,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005eb4:	c89c                	sw	a5,16(s1)
  iphdr->ip_len = htons(m->len);
    80005eb6:	0109a783          	lw	a5,16(s3)
  return (((val & 0x00ffU) << 8) |
    80005eba:	0087971b          	slliw	a4,a5,0x8
    80005ebe:	0107979b          	slliw	a5,a5,0x10
    80005ec2:	0107d79b          	srliw	a5,a5,0x10
    80005ec6:	0087d79b          	srliw	a5,a5,0x8
    80005eca:	8fd9                	or	a5,a5,a4
    80005ecc:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005ed0:	06400793          	li	a5,100
    80005ed4:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005ed8:	45d1                	li	a1,20
    80005eda:	8526                	mv	a0,s1
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	cba080e7          	jalr	-838(ra) # 80005b96 <in_cksum>
    80005ee4:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005ee8:	6585                	lui	a1,0x1
    80005eea:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005eee:	854e                	mv	a0,s3
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	d6e080e7          	jalr	-658(ra) # 80005c5e <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005ef8:	70a2                	ld	ra,40(sp)
    80005efa:	7402                	ld	s0,32(sp)
    80005efc:	64e2                	ld	s1,24(sp)
    80005efe:	6942                	ld	s2,16(sp)
    80005f00:	69a2                	ld	s3,8(sp)
    80005f02:	6a02                	ld	s4,0(sp)
    80005f04:	6145                	addi	sp,sp,48
    80005f06:	8082                	ret

0000000080005f08 <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005f08:	715d                	addi	sp,sp,-80
    80005f0a:	e486                	sd	ra,72(sp)
    80005f0c:	e0a2                	sd	s0,64(sp)
    80005f0e:	fc26                	sd	s1,56(sp)
    80005f10:	0880                	addi	s0,sp,80
    80005f12:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005f14:	45b9                	li	a1,14
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	cec080e7          	jalr	-788(ra) # 80005c02 <mbufpull>
  if (!ethhdr) {
    80005f1e:	c915                	beqz	a0,80005f52 <net_rx+0x4a>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005f20:	00c54683          	lbu	a3,12(a0)
    80005f24:	00d54783          	lbu	a5,13(a0)
    80005f28:	07a2                	slli	a5,a5,0x8
    80005f2a:	00d7e733          	or	a4,a5,a3
  if (type == ETHTYPE_IP)
    80005f2e:	46a1                	li	a3,8
    80005f30:	02d70763          	beq	a4,a3,80005f5e <net_rx+0x56>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005f34:	2701                	sext.w	a4,a4
    80005f36:	60800793          	li	a5,1544
    80005f3a:	18f70263          	beq	a4,a5,800060be <net_rx+0x1b6>
  kfree(m);
    80005f3e:	8526                	mv	a0,s1
    80005f40:	ffffa097          	auipc	ra,0xffffa
    80005f44:	0dc080e7          	jalr	220(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005f48:	60a6                	ld	ra,72(sp)
    80005f4a:	6406                	ld	s0,64(sp)
    80005f4c:	74e2                	ld	s1,56(sp)
    80005f4e:	6161                	addi	sp,sp,80
    80005f50:	8082                	ret
  kfree(m);
    80005f52:	8526                	mv	a0,s1
    80005f54:	ffffa097          	auipc	ra,0xffffa
    80005f58:	0c8080e7          	jalr	200(ra) # 8000001c <kfree>
}
    80005f5c:	b7f5                	j	80005f48 <net_rx+0x40>
    80005f5e:	f84a                	sd	s2,48(sp)
  iphdr = mbufpullhdr(m, *iphdr);
    80005f60:	45d1                	li	a1,20
    80005f62:	8526                	mv	a0,s1
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	c9e080e7          	jalr	-866(ra) # 80005c02 <mbufpull>
    80005f6c:	892a                	mv	s2,a0
  if (!iphdr)
    80005f6e:	c125                	beqz	a0,80005fce <net_rx+0xc6>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005f70:	00054703          	lbu	a4,0(a0)
    80005f74:	04500793          	li	a5,69
    80005f78:	04f71b63          	bne	a4,a5,80005fce <net_rx+0xc6>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005f7c:	45d1                	li	a1,20
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	c18080e7          	jalr	-1000(ra) # 80005b96 <in_cksum>
    80005f86:	e521                	bnez	a0,80005fce <net_rx+0xc6>
  if (htons(iphdr->ip_off) != 0)
    80005f88:	00695783          	lhu	a5,6(s2)
    80005f8c:	e3a9                	bnez	a5,80005fce <net_rx+0xc6>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005f8e:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005f92:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005f96:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f9a:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005f9c:	0087169b          	slliw	a3,a4,0x8
    80005fa0:	00ff0637          	lui	a2,0xff0
    80005fa4:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005fa6:	8fd5                	or	a5,a5,a3
    80005fa8:	0087571b          	srliw	a4,a4,0x8
    80005fac:	66c1                	lui	a3,0x10
    80005fae:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005fb2:	8f75                	and	a4,a4,a3
    80005fb4:	8fd9                	or	a5,a5,a4
    80005fb6:	2781                	sext.w	a5,a5
    80005fb8:	0a000737          	lui	a4,0xa000
    80005fbc:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005fc0:	00e79763          	bne	a5,a4,80005fce <net_rx+0xc6>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005fc4:	00994703          	lbu	a4,9(s2)
    80005fc8:	47c5                	li	a5,17
    80005fca:	00f70963          	beq	a4,a5,80005fdc <net_rx+0xd4>
  kfree(m);
    80005fce:	8526                	mv	a0,s1
    80005fd0:	ffffa097          	auipc	ra,0xffffa
    80005fd4:	04c080e7          	jalr	76(ra) # 8000001c <kfree>
}
    80005fd8:	7942                	ld	s2,48(sp)
    80005fda:	b7bd                	j	80005f48 <net_rx+0x40>
    80005fdc:	f44e                	sd	s3,40(sp)
    80005fde:	f052                	sd	s4,32(sp)
    80005fe0:	ec56                	sd	s5,24(sp)
  return (((val & 0x00ffU) << 8) |
    80005fe2:	00295783          	lhu	a5,2(s2)
    80005fe6:	0087971b          	slliw	a4,a5,0x8
    80005fea:	0087d993          	srli	s3,a5,0x8
    80005fee:	00e9e9b3          	or	s3,s3,a4
    80005ff2:	19c2                	slli	s3,s3,0x30
    80005ff4:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005ff8:	fec9879b          	addiw	a5,s3,-20
    80005ffc:	03079a13          	slli	s4,a5,0x30
    80006000:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80006004:	45a1                	li	a1,8
    80006006:	8526                	mv	a0,s1
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	bfa080e7          	jalr	-1030(ra) # 80005c02 <mbufpull>
    80006010:	8aaa                	mv	s5,a0
  if (!udphdr)
    80006012:	c51d                	beqz	a0,80006040 <net_rx+0x138>
    80006014:	00455783          	lhu	a5,4(a0)
    80006018:	0087971b          	slliw	a4,a5,0x8
    8000601c:	83a1                	srli	a5,a5,0x8
    8000601e:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80006020:	2a01                	sext.w	s4,s4
    80006022:	17c2                	slli	a5,a5,0x30
    80006024:	93c1                	srli	a5,a5,0x30
    80006026:	00fa1d63          	bne	s4,a5,80006040 <net_rx+0x138>
  len -= sizeof(*udphdr);
    8000602a:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    8000602e:	0107979b          	slliw	a5,a5,0x10
    80006032:	0107d79b          	srliw	a5,a5,0x10
    80006036:	0007871b          	sext.w	a4,a5
    8000603a:	488c                	lw	a1,16(s1)
    8000603c:	00e5fc63          	bgeu	a1,a4,80006054 <net_rx+0x14c>
  kfree(m);
    80006040:	8526                	mv	a0,s1
    80006042:	ffffa097          	auipc	ra,0xffffa
    80006046:	fda080e7          	jalr	-38(ra) # 8000001c <kfree>
}
    8000604a:	7942                	ld	s2,48(sp)
    8000604c:	79a2                	ld	s3,40(sp)
    8000604e:	7a02                	ld	s4,32(sp)
    80006050:	6ae2                	ld	s5,24(sp)
    80006052:	bddd                	j	80005f48 <net_rx+0x40>
  mbuftrim(m, m->len - len);
    80006054:	9d9d                	subw	a1,a1,a5
    80006056:	8526                	mv	a0,s1
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	cb8080e7          	jalr	-840(ra) # 80005d10 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80006060:	00c92783          	lw	a5,12(s2)
    80006064:	000ad703          	lhu	a4,0(s5)
    80006068:	0087169b          	slliw	a3,a4,0x8
    8000606c:	8321                	srli	a4,a4,0x8
    8000606e:	8ed9                	or	a3,a3,a4
    80006070:	002ad703          	lhu	a4,2(s5)
    80006074:	0087161b          	slliw	a2,a4,0x8
    80006078:	8321                	srli	a4,a4,0x8
    8000607a:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    8000607c:	0187959b          	slliw	a1,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006080:	0187d71b          	srliw	a4,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006084:	8dd9                	or	a1,a1,a4
          ((val & 0x0000ff00UL) << 8) |
    80006086:	0087971b          	slliw	a4,a5,0x8
    8000608a:	00ff0537          	lui	a0,0xff0
    8000608e:	8f69                	and	a4,a4,a0
          ((val & 0x00ff0000UL) >> 8) |
    80006090:	8dd9                	or	a1,a1,a4
    80006092:	0087d79b          	srliw	a5,a5,0x8
    80006096:	6741                	lui	a4,0x10
    80006098:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    8000609c:	8ff9                	and	a5,a5,a4
    8000609e:	8ddd                	or	a1,a1,a5
  sockrecvudp(m, sip, dport, sport);
    800060a0:	16c2                	slli	a3,a3,0x30
    800060a2:	92c1                	srli	a3,a3,0x30
    800060a4:	1642                	slli	a2,a2,0x30
    800060a6:	9241                	srli	a2,a2,0x30
    800060a8:	2581                	sext.w	a1,a1
    800060aa:	8526                	mv	a0,s1
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	54e080e7          	jalr	1358(ra) # 800065fa <sockrecvudp>
  return;
    800060b4:	7942                	ld	s2,48(sp)
    800060b6:	79a2                	ld	s3,40(sp)
    800060b8:	7a02                	ld	s4,32(sp)
    800060ba:	6ae2                	ld	s5,24(sp)
    800060bc:	b571                	j	80005f48 <net_rx+0x40>
    800060be:	f84a                	sd	s2,48(sp)
  arphdr = mbufpullhdr(m, *arphdr);
    800060c0:	45f1                	li	a1,28
    800060c2:	8526                	mv	a0,s1
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	b3e080e7          	jalr	-1218(ra) # 80005c02 <mbufpull>
    800060cc:	892a                	mv	s2,a0
  if (!arphdr)
    800060ce:	c14d                	beqz	a0,80006170 <net_rx+0x268>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    800060d0:	00054703          	lbu	a4,0(a0) # ff0000 <_entry-0x7f010000>
    800060d4:	00154783          	lbu	a5,1(a0)
    800060d8:	07a2                	slli	a5,a5,0x8
    800060da:	8fd9                	or	a5,a5,a4
    800060dc:	10000713          	li	a4,256
    800060e0:	08e79863          	bne	a5,a4,80006170 <net_rx+0x268>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    800060e4:	00254703          	lbu	a4,2(a0)
    800060e8:	00354783          	lbu	a5,3(a0)
    800060ec:	07a2                	slli	a5,a5,0x8
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    800060ee:	8fd9                	or	a5,a5,a4
    800060f0:	4721                	li	a4,8
    800060f2:	06e79f63          	bne	a5,a4,80006170 <net_rx+0x268>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    800060f6:	00454703          	lbu	a4,4(a0)
    800060fa:	4799                	li	a5,6
    800060fc:	06f71a63          	bne	a4,a5,80006170 <net_rx+0x268>
      arphdr->hln != ETHADDR_LEN ||
    80006100:	00554703          	lbu	a4,5(a0)
    80006104:	4791                	li	a5,4
    80006106:	06f71563          	bne	a4,a5,80006170 <net_rx+0x268>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    8000610a:	00654703          	lbu	a4,6(a0)
    8000610e:	00754783          	lbu	a5,7(a0)
    80006112:	07a2                	slli	a5,a5,0x8
    80006114:	8fd9                	or	a5,a5,a4
    80006116:	10000713          	li	a4,256
    8000611a:	04e79b63          	bne	a5,a4,80006170 <net_rx+0x268>
  tip = ntohl(arphdr->tip); // target IP address
    8000611e:	01854703          	lbu	a4,24(a0)
    80006122:	01954783          	lbu	a5,25(a0)
    80006126:	07a2                	slli	a5,a5,0x8
    80006128:	8fd9                	or	a5,a5,a4
    8000612a:	01a54703          	lbu	a4,26(a0)
    8000612e:	0742                	slli	a4,a4,0x10
    80006130:	8f5d                	or	a4,a4,a5
    80006132:	01b54783          	lbu	a5,27(a0)
    80006136:	07e2                	slli	a5,a5,0x18
    80006138:	8fd9                	or	a5,a5,a4
    8000613a:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    8000613e:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006142:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006146:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80006148:	0087169b          	slliw	a3,a4,0x8
    8000614c:	00ff0637          	lui	a2,0xff0
    80006150:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80006152:	8fd5                	or	a5,a5,a3
    80006154:	0087571b          	srliw	a4,a4,0x8
    80006158:	66c1                	lui	a3,0x10
    8000615a:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    8000615e:	8f75                	and	a4,a4,a3
    80006160:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006162:	2781                	sext.w	a5,a5
    80006164:	0a000737          	lui	a4,0xa000
    80006168:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    8000616c:	00e78963          	beq	a5,a4,8000617e <net_rx+0x276>
  kfree(m);
    80006170:	8526                	mv	a0,s1
    80006172:	ffffa097          	auipc	ra,0xffffa
    80006176:	eaa080e7          	jalr	-342(ra) # 8000001c <kfree>
}
    8000617a:	7942                	ld	s2,48(sp)
    8000617c:	b3f1                	j	80005f48 <net_rx+0x40>
    8000617e:	f052                	sd	s4,32(sp)
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    80006180:	4619                	li	a2,6
    80006182:	00850593          	addi	a1,a0,8
    80006186:	fb840513          	addi	a0,s0,-72
    8000618a:	ffffa097          	auipc	ra,0xffffa
    8000618e:	04c080e7          	jalr	76(ra) # 800001d6 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    80006192:	00e94703          	lbu	a4,14(s2)
    80006196:	00f94783          	lbu	a5,15(s2)
    8000619a:	07a2                	slli	a5,a5,0x8
    8000619c:	8fd9                	or	a5,a5,a4
    8000619e:	01094703          	lbu	a4,16(s2)
    800061a2:	0742                	slli	a4,a4,0x10
    800061a4:	8f5d                	or	a4,a4,a5
    800061a6:	01194783          	lbu	a5,17(s2)
    800061aa:	07e2                	slli	a5,a5,0x18
    800061ac:	8fd9                	or	a5,a5,a4
    800061ae:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800061b2:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800061b6:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061ba:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    800061be:	0087179b          	slliw	a5,a4,0x8
    800061c2:	00ff06b7          	lui	a3,0xff0
    800061c6:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061c8:	00f96933          	or	s2,s2,a5
    800061cc:	0087579b          	srliw	a5,a4,0x8
    800061d0:	6741                	lui	a4,0x10
    800061d2:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    800061d6:	8ff9                	and	a5,a5,a4
    800061d8:	00f96933          	or	s2,s2,a5
    800061dc:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    800061de:	08000513          	li	a0,128
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	b50080e7          	jalr	-1200(ra) # 80005d32 <mbufalloc>
    800061ea:	8a2a                	mv	s4,a0
  if (!m)
    800061ec:	c161                	beqz	a0,800062ac <net_rx+0x3a4>
    800061ee:	f44e                	sd	s3,40(sp)
    800061f0:	ec56                	sd	s5,24(sp)
  arphdr = mbufputhdr(m, *arphdr);
    800061f2:	45f1                	li	a1,28
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	ae2080e7          	jalr	-1310(ra) # 80005cd6 <mbufput>
    800061fc:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    800061fe:	00050023          	sb	zero,0(a0)
    80006202:	4785                	li	a5,1
    80006204:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    80006208:	47a1                	li	a5,8
    8000620a:	00f50123          	sb	a5,2(a0)
    8000620e:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80006212:	4799                	li	a5,6
    80006214:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    80006218:	4791                	li	a5,4
    8000621a:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    8000621e:	00050323          	sb	zero,6(a0)
    80006222:	4a89                	li	s5,2
    80006224:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    80006228:	4619                	li	a2,6
    8000622a:	00006597          	auipc	a1,0x6
    8000622e:	3c658593          	addi	a1,a1,966 # 8000c5f0 <local_mac>
    80006232:	0521                	addi	a0,a0,8
    80006234:	ffffa097          	auipc	ra,0xffffa
    80006238:	fa2080e7          	jalr	-94(ra) # 800001d6 <memmove>
  arphdr->sip = htonl(local_ip);
    8000623c:	47a9                	li	a5,10
    8000623e:	00f98723          	sb	a5,14(s3)
    80006242:	000987a3          	sb	zero,15(s3)
    80006246:	01598823          	sb	s5,16(s3)
    8000624a:	47bd                	li	a5,15
    8000624c:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    80006250:	4619                	li	a2,6
    80006252:	fb840593          	addi	a1,s0,-72
    80006256:	01298513          	addi	a0,s3,18
    8000625a:	ffffa097          	auipc	ra,0xffffa
    8000625e:	f7c080e7          	jalr	-132(ra) # 800001d6 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    80006262:	0189179b          	slliw	a5,s2,0x18
          ((val & 0xff000000UL) >> 24));
    80006266:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000626a:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    8000626c:	0089171b          	slliw	a4,s2,0x8
    80006270:	00ff06b7          	lui	a3,0xff0
    80006274:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006276:	8fd9                	or	a5,a5,a4
    80006278:	0109591b          	srliw	s2,s2,0x10
  arphdr->tip = htonl(dip);
    8000627c:	00f98c23          	sb	a5,24(s3)
    80006280:	01298ca3          	sb	s2,25(s3)
    80006284:	0107d71b          	srliw	a4,a5,0x10
    80006288:	00e98d23          	sb	a4,26(s3)
    8000628c:	0187d79b          	srliw	a5,a5,0x18
    80006290:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    80006294:	6585                	lui	a1,0x1
    80006296:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    8000629a:	8552                	mv	a0,s4
    8000629c:	00000097          	auipc	ra,0x0
    800062a0:	9c2080e7          	jalr	-1598(ra) # 80005c5e <net_tx_eth>
    800062a4:	79a2                	ld	s3,40(sp)
    800062a6:	7a02                	ld	s4,32(sp)
    800062a8:	6ae2                	ld	s5,24(sp)
  return 0;
    800062aa:	b5d9                	j	80006170 <net_rx+0x268>
    800062ac:	7a02                	ld	s4,32(sp)
    800062ae:	b5c9                	j	80006170 <net_rx+0x268>

00000000800062b0 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    800062b0:	1141                	addi	sp,sp,-16
    800062b2:	e406                	sd	ra,8(sp)
    800062b4:	e022                	sd	s0,0(sp)
    800062b6:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    800062b8:	00003597          	auipc	a1,0x3
    800062bc:	41058593          	addi	a1,a1,1040 # 800096c8 <etext+0x6c8>
    800062c0:	0001c517          	auipc	a0,0x1c
    800062c4:	06050513          	addi	a0,a0,96 # 80022320 <lock>
    800062c8:	00001097          	auipc	ra,0x1
    800062cc:	eae080e7          	jalr	-338(ra) # 80007176 <initlock>
}
    800062d0:	60a2                	ld	ra,8(sp)
    800062d2:	6402                	ld	s0,0(sp)
    800062d4:	0141                	addi	sp,sp,16
    800062d6:	8082                	ret

00000000800062d8 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    800062d8:	7139                	addi	sp,sp,-64
    800062da:	fc06                	sd	ra,56(sp)
    800062dc:	f822                	sd	s0,48(sp)
    800062de:	f426                	sd	s1,40(sp)
    800062e0:	f04a                	sd	s2,32(sp)
    800062e2:	ec4e                	sd	s3,24(sp)
    800062e4:	e852                	sd	s4,16(sp)
    800062e6:	0080                	addi	s0,sp,64
    800062e8:	892a                	mv	s2,a0
    800062ea:	84ae                	mv	s1,a1
    800062ec:	8a32                	mv	s4,a2
    800062ee:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    800062f0:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    800062f4:	ffffd097          	auipc	ra,0xffffd
    800062f8:	622080e7          	jalr	1570(ra) # 80003916 <filealloc>
    800062fc:	00a93023          	sd	a0,0(s2)
    80006300:	cd65                	beqz	a0,800063f8 <sockalloc+0x120>
    80006302:	e456                	sd	s5,8(sp)
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    80006304:	ffffa097          	auipc	ra,0xffffa
    80006308:	e16080e7          	jalr	-490(ra) # 8000011a <kalloc>
    8000630c:	8aaa                	mv	s5,a0
    8000630e:	c15d                	beqz	a0,800063b4 <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    80006310:	c504                	sw	s1,8(a0)
  si->lport = lport;
    80006312:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006316:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    8000631a:	00003597          	auipc	a1,0x3
    8000631e:	3b658593          	addi	a1,a1,950 # 800096d0 <etext+0x6d0>
    80006322:	0541                	addi	a0,a0,16
    80006324:	00001097          	auipc	ra,0x1
    80006328:	e52080e7          	jalr	-430(ra) # 80007176 <initlock>
  mbufq_init(&si->rxq);
    8000632c:	028a8513          	addi	a0,s5,40
    80006330:	00000097          	auipc	ra,0x0
    80006334:	abe080e7          	jalr	-1346(ra) # 80005dee <mbufq_init>
  (*f)->type = FD_SOCK;
    80006338:	00093783          	ld	a5,0(s2)
    8000633c:	4711                	li	a4,4
    8000633e:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    80006340:	00093703          	ld	a4,0(s2)
    80006344:	4785                	li	a5,1
    80006346:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    8000634a:	00093703          	ld	a4,0(s2)
    8000634e:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    80006352:	00093783          	ld	a5,0(s2)
    80006356:	0357b023          	sd	s5,32(a5)

  // add to list of sockets
  acquire(&lock);
    8000635a:	0001c517          	auipc	a0,0x1c
    8000635e:	fc650513          	addi	a0,a0,-58 # 80022320 <lock>
    80006362:	00001097          	auipc	ra,0x1
    80006366:	ea4080e7          	jalr	-348(ra) # 80007206 <acquire>
  pos = sockets;
    8000636a:	00007597          	auipc	a1,0x7
    8000636e:	cbe5b583          	ld	a1,-834(a1) # 8000d028 <sockets>
  while (pos) {
    80006372:	c9b9                	beqz	a1,800063c8 <sockalloc+0xf0>
  pos = sockets;
    80006374:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    80006376:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    8000637a:	0009869b          	sext.w	a3,s3
    8000637e:	a019                	j	80006384 <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    80006380:	639c                	ld	a5,0(a5)
  while (pos) {
    80006382:	c3b9                	beqz	a5,800063c8 <sockalloc+0xf0>
    if (pos->raddr == raddr &&
    80006384:	4798                	lw	a4,8(a5)
    80006386:	fe971de3          	bne	a4,s1,80006380 <sockalloc+0xa8>
    8000638a:	00c7d703          	lhu	a4,12(a5)
    8000638e:	fec719e3          	bne	a4,a2,80006380 <sockalloc+0xa8>
        pos->lport == lport &&
    80006392:	00e7d703          	lhu	a4,14(a5)
    80006396:	fed715e3          	bne	a4,a3,80006380 <sockalloc+0xa8>
      release(&lock);
    8000639a:	0001c517          	auipc	a0,0x1c
    8000639e:	f8650513          	addi	a0,a0,-122 # 80022320 <lock>
    800063a2:	00001097          	auipc	ra,0x1
    800063a6:	f18080e7          	jalr	-232(ra) # 800072ba <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    800063aa:	8556                	mv	a0,s5
    800063ac:	ffffa097          	auipc	ra,0xffffa
    800063b0:	c70080e7          	jalr	-912(ra) # 8000001c <kfree>
  if (*f)
    800063b4:	00093503          	ld	a0,0(s2)
    800063b8:	c131                	beqz	a0,800063fc <sockalloc+0x124>
    fileclose(*f);
    800063ba:	ffffd097          	auipc	ra,0xffffd
    800063be:	618080e7          	jalr	1560(ra) # 800039d2 <fileclose>
  return -1;
    800063c2:	557d                	li	a0,-1
    800063c4:	6aa2                	ld	s5,8(sp)
    800063c6:	a00d                	j	800063e8 <sockalloc+0x110>
  si->next = sockets;
    800063c8:	00bab023          	sd	a1,0(s5)
  sockets = si;
    800063cc:	00007797          	auipc	a5,0x7
    800063d0:	c557be23          	sd	s5,-932(a5) # 8000d028 <sockets>
  release(&lock);
    800063d4:	0001c517          	auipc	a0,0x1c
    800063d8:	f4c50513          	addi	a0,a0,-180 # 80022320 <lock>
    800063dc:	00001097          	auipc	ra,0x1
    800063e0:	ede080e7          	jalr	-290(ra) # 800072ba <release>
  return 0;
    800063e4:	4501                	li	a0,0
    800063e6:	6aa2                	ld	s5,8(sp)
}
    800063e8:	70e2                	ld	ra,56(sp)
    800063ea:	7442                	ld	s0,48(sp)
    800063ec:	74a2                	ld	s1,40(sp)
    800063ee:	7902                	ld	s2,32(sp)
    800063f0:	69e2                	ld	s3,24(sp)
    800063f2:	6a42                	ld	s4,16(sp)
    800063f4:	6121                	addi	sp,sp,64
    800063f6:	8082                	ret
  return -1;
    800063f8:	557d                	li	a0,-1
    800063fa:	b7fd                	j	800063e8 <sockalloc+0x110>
    800063fc:	557d                	li	a0,-1
    800063fe:	6aa2                	ld	s5,8(sp)
    80006400:	b7e5                	j	800063e8 <sockalloc+0x110>

0000000080006402 <sockclose>:

void
sockclose(struct sock *si)
{
    80006402:	1101                	addi	sp,sp,-32
    80006404:	ec06                	sd	ra,24(sp)
    80006406:	e822                	sd	s0,16(sp)
    80006408:	e426                	sd	s1,8(sp)
    8000640a:	e04a                	sd	s2,0(sp)
    8000640c:	1000                	addi	s0,sp,32
    8000640e:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    80006410:	0001c517          	auipc	a0,0x1c
    80006414:	f1050513          	addi	a0,a0,-240 # 80022320 <lock>
    80006418:	00001097          	auipc	ra,0x1
    8000641c:	dee080e7          	jalr	-530(ra) # 80007206 <acquire>
  pos = &sockets;
    80006420:	00007797          	auipc	a5,0x7
    80006424:	c087b783          	ld	a5,-1016(a5) # 8000d028 <sockets>
  while (*pos) {
    80006428:	cb99                	beqz	a5,8000643e <sockclose+0x3c>
    if (*pos == si){
    8000642a:	04f90463          	beq	s2,a5,80006472 <sockclose+0x70>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    8000642e:	873e                	mv	a4,a5
    80006430:	639c                	ld	a5,0(a5)
  while (*pos) {
    80006432:	c791                	beqz	a5,8000643e <sockclose+0x3c>
    if (*pos == si){
    80006434:	fef91de3          	bne	s2,a5,8000642e <sockclose+0x2c>
      *pos = si->next;
    80006438:	00093783          	ld	a5,0(s2)
    8000643c:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    8000643e:	0001c517          	auipc	a0,0x1c
    80006442:	ee250513          	addi	a0,a0,-286 # 80022320 <lock>
    80006446:	00001097          	auipc	ra,0x1
    8000644a:	e74080e7          	jalr	-396(ra) # 800072ba <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    8000644e:	02890493          	addi	s1,s2,40
    80006452:	8526                	mv	a0,s1
    80006454:	00000097          	auipc	ra,0x0
    80006458:	988080e7          	jalr	-1656(ra) # 80005ddc <mbufq_empty>
    8000645c:	e105                	bnez	a0,8000647c <sockclose+0x7a>
    m = mbufq_pophead(&si->rxq);
    8000645e:	8526                	mv	a0,s1
    80006460:	00000097          	auipc	ra,0x0
    80006464:	966080e7          	jalr	-1690(ra) # 80005dc6 <mbufq_pophead>
    mbuffree(m);
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	926080e7          	jalr	-1754(ra) # 80005d8e <mbuffree>
    80006470:	b7cd                	j	80006452 <sockclose+0x50>
  pos = &sockets;
    80006472:	00007717          	auipc	a4,0x7
    80006476:	bb670713          	addi	a4,a4,-1098 # 8000d028 <sockets>
    8000647a:	bf7d                	j	80006438 <sockclose+0x36>
  }

  kfree((char*)si);
    8000647c:	854a                	mv	a0,s2
    8000647e:	ffffa097          	auipc	ra,0xffffa
    80006482:	b9e080e7          	jalr	-1122(ra) # 8000001c <kfree>
}
    80006486:	60e2                	ld	ra,24(sp)
    80006488:	6442                	ld	s0,16(sp)
    8000648a:	64a2                	ld	s1,8(sp)
    8000648c:	6902                	ld	s2,0(sp)
    8000648e:	6105                	addi	sp,sp,32
    80006490:	8082                	ret

0000000080006492 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    80006492:	7139                	addi	sp,sp,-64
    80006494:	fc06                	sd	ra,56(sp)
    80006496:	f822                	sd	s0,48(sp)
    80006498:	f426                	sd	s1,40(sp)
    8000649a:	f04a                	sd	s2,32(sp)
    8000649c:	ec4e                	sd	s3,24(sp)
    8000649e:	e852                	sd	s4,16(sp)
    800064a0:	e456                	sd	s5,8(sp)
    800064a2:	0080                	addi	s0,sp,64
    800064a4:	84aa                	mv	s1,a0
    800064a6:	8a2e                	mv	s4,a1
    800064a8:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    800064aa:	ffffb097          	auipc	ra,0xffffb
    800064ae:	a2a080e7          	jalr	-1494(ra) # 80000ed4 <myproc>
    800064b2:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    800064b4:	01048993          	addi	s3,s1,16
    800064b8:	854e                	mv	a0,s3
    800064ba:	00001097          	auipc	ra,0x1
    800064be:	d4c080e7          	jalr	-692(ra) # 80007206 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    800064c2:	02848493          	addi	s1,s1,40
    800064c6:	a039                	j	800064d4 <sockread+0x42>
    sleep(&si->rxq, &si->lock);
    800064c8:	85ce                	mv	a1,s3
    800064ca:	8526                	mv	a0,s1
    800064cc:	ffffb097          	auipc	ra,0xffffb
    800064d0:	0ce080e7          	jalr	206(ra) # 8000159a <sleep>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    800064d4:	8526                	mv	a0,s1
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	906080e7          	jalr	-1786(ra) # 80005ddc <mbufq_empty>
    800064de:	c919                	beqz	a0,800064f4 <sockread+0x62>
    800064e0:	02892783          	lw	a5,40(s2)
    800064e4:	d3f5                	beqz	a5,800064c8 <sockread+0x36>
  }
  if (pr->killed) {
    release(&si->lock);
    800064e6:	854e                	mv	a0,s3
    800064e8:	00001097          	auipc	ra,0x1
    800064ec:	dd2080e7          	jalr	-558(ra) # 800072ba <release>
    return -1;
    800064f0:	59fd                	li	s3,-1
    800064f2:	a881                	j	80006542 <sockread+0xb0>
  if (pr->killed) {
    800064f4:	02892783          	lw	a5,40(s2)
    800064f8:	f7fd                	bnez	a5,800064e6 <sockread+0x54>
  }
  m = mbufq_pophead(&si->rxq);
    800064fa:	8526                	mv	a0,s1
    800064fc:	00000097          	auipc	ra,0x0
    80006500:	8ca080e7          	jalr	-1846(ra) # 80005dc6 <mbufq_pophead>
    80006504:	84aa                	mv	s1,a0
  release(&si->lock);
    80006506:	854e                	mv	a0,s3
    80006508:	00001097          	auipc	ra,0x1
    8000650c:	db2080e7          	jalr	-590(ra) # 800072ba <release>

  len = m->len;
  if (len > n)
    80006510:	489c                	lw	a5,16(s1)
    80006512:	89be                	mv	s3,a5
    80006514:	2781                	sext.w	a5,a5
    80006516:	00fad363          	bge	s5,a5,8000651c <sockread+0x8a>
    8000651a:	89d6                	mv	s3,s5
    8000651c:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    8000651e:	86ce                	mv	a3,s3
    80006520:	6490                	ld	a2,8(s1)
    80006522:	85d2                	mv	a1,s4
    80006524:	05093503          	ld	a0,80(s2)
    80006528:	ffffa097          	auipc	ra,0xffffa
    8000652c:	64c080e7          	jalr	1612(ra) # 80000b74 <copyout>
    80006530:	892a                	mv	s2,a0
    80006532:	57fd                	li	a5,-1
    80006534:	02f50163          	beq	a0,a5,80006556 <sockread+0xc4>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    80006538:	8526                	mv	a0,s1
    8000653a:	00000097          	auipc	ra,0x0
    8000653e:	854080e7          	jalr	-1964(ra) # 80005d8e <mbuffree>
  return len;
}
    80006542:	854e                	mv	a0,s3
    80006544:	70e2                	ld	ra,56(sp)
    80006546:	7442                	ld	s0,48(sp)
    80006548:	74a2                	ld	s1,40(sp)
    8000654a:	7902                	ld	s2,32(sp)
    8000654c:	69e2                	ld	s3,24(sp)
    8000654e:	6a42                	ld	s4,16(sp)
    80006550:	6aa2                	ld	s5,8(sp)
    80006552:	6121                	addi	sp,sp,64
    80006554:	8082                	ret
    mbuffree(m);
    80006556:	8526                	mv	a0,s1
    80006558:	00000097          	auipc	ra,0x0
    8000655c:	836080e7          	jalr	-1994(ra) # 80005d8e <mbuffree>
    return -1;
    80006560:	89ca                	mv	s3,s2
    80006562:	b7c5                	j	80006542 <sockread+0xb0>

0000000080006564 <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    80006564:	7139                	addi	sp,sp,-64
    80006566:	fc06                	sd	ra,56(sp)
    80006568:	f822                	sd	s0,48(sp)
    8000656a:	f04a                	sd	s2,32(sp)
    8000656c:	ec4e                	sd	s3,24(sp)
    8000656e:	e852                	sd	s4,16(sp)
    80006570:	e456                	sd	s5,8(sp)
    80006572:	0080                	addi	s0,sp,64
    80006574:	8aaa                	mv	s5,a0
    80006576:	89ae                	mv	s3,a1
    80006578:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    8000657a:	ffffb097          	auipc	ra,0xffffb
    8000657e:	95a080e7          	jalr	-1702(ra) # 80000ed4 <myproc>
    80006582:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006584:	08000513          	li	a0,128
    80006588:	fffff097          	auipc	ra,0xfffff
    8000658c:	7aa080e7          	jalr	1962(ra) # 80005d32 <mbufalloc>
  if (!m)
    80006590:	c13d                	beqz	a0,800065f6 <sockwrite+0x92>
    80006592:	f426                	sd	s1,40(sp)
    80006594:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    80006596:	050a3a03          	ld	s4,80(s4) # 3050 <_entry-0x7fffcfb0>
    8000659a:	85ca                	mv	a1,s2
    8000659c:	fffff097          	auipc	ra,0xfffff
    800065a0:	73a080e7          	jalr	1850(ra) # 80005cd6 <mbufput>
    800065a4:	85aa                	mv	a1,a0
    800065a6:	86ca                	mv	a3,s2
    800065a8:	864e                	mv	a2,s3
    800065aa:	8552                	mv	a0,s4
    800065ac:	ffffa097          	auipc	ra,0xffffa
    800065b0:	654080e7          	jalr	1620(ra) # 80000c00 <copyin>
    800065b4:	89aa                	mv	s3,a0
    800065b6:	57fd                	li	a5,-1
    800065b8:	02f50863          	beq	a0,a5,800065e8 <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    800065bc:	00ead683          	lhu	a3,14(s5)
    800065c0:	00cad603          	lhu	a2,12(s5)
    800065c4:	008aa583          	lw	a1,8(s5)
    800065c8:	8526                	mv	a0,s1
    800065ca:	00000097          	auipc	ra,0x0
    800065ce:	834080e7          	jalr	-1996(ra) # 80005dfe <net_tx_udp>
  return n;
    800065d2:	89ca                	mv	s3,s2
    800065d4:	74a2                	ld	s1,40(sp)
}
    800065d6:	854e                	mv	a0,s3
    800065d8:	70e2                	ld	ra,56(sp)
    800065da:	7442                	ld	s0,48(sp)
    800065dc:	7902                	ld	s2,32(sp)
    800065de:	69e2                	ld	s3,24(sp)
    800065e0:	6a42                	ld	s4,16(sp)
    800065e2:	6aa2                	ld	s5,8(sp)
    800065e4:	6121                	addi	sp,sp,64
    800065e6:	8082                	ret
    mbuffree(m);
    800065e8:	8526                	mv	a0,s1
    800065ea:	fffff097          	auipc	ra,0xfffff
    800065ee:	7a4080e7          	jalr	1956(ra) # 80005d8e <mbuffree>
    return -1;
    800065f2:	74a2                	ld	s1,40(sp)
    800065f4:	b7cd                	j	800065d6 <sockwrite+0x72>
    return -1;
    800065f6:	59fd                	li	s3,-1
    800065f8:	bff9                	j	800065d6 <sockwrite+0x72>

00000000800065fa <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    800065fa:	7139                	addi	sp,sp,-64
    800065fc:	fc06                	sd	ra,56(sp)
    800065fe:	f822                	sd	s0,48(sp)
    80006600:	f426                	sd	s1,40(sp)
    80006602:	f04a                	sd	s2,32(sp)
    80006604:	ec4e                	sd	s3,24(sp)
    80006606:	e852                	sd	s4,16(sp)
    80006608:	e456                	sd	s5,8(sp)
    8000660a:	0080                	addi	s0,sp,64
    8000660c:	8a2a                	mv	s4,a0
    8000660e:	892e                	mv	s2,a1
    80006610:	89b2                	mv	s3,a2
    80006612:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    80006614:	0001c517          	auipc	a0,0x1c
    80006618:	d0c50513          	addi	a0,a0,-756 # 80022320 <lock>
    8000661c:	00001097          	auipc	ra,0x1
    80006620:	bea080e7          	jalr	-1046(ra) # 80007206 <acquire>
  si = sockets;
    80006624:	00007497          	auipc	s1,0x7
    80006628:	a044b483          	ld	s1,-1532(s1) # 8000d028 <sockets>
  while (si) {
    8000662c:	c4ad                	beqz	s1,80006696 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    8000662e:	0009871b          	sext.w	a4,s3
    80006632:	000a869b          	sext.w	a3,s5
    80006636:	a019                	j	8000663c <sockrecvudp+0x42>
      goto found;
    si = si->next;
    80006638:	6084                	ld	s1,0(s1)
  while (si) {
    8000663a:	ccb1                	beqz	s1,80006696 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    8000663c:	449c                	lw	a5,8(s1)
    8000663e:	ff279de3          	bne	a5,s2,80006638 <sockrecvudp+0x3e>
    80006642:	00c4d783          	lhu	a5,12(s1)
    80006646:	fee799e3          	bne	a5,a4,80006638 <sockrecvudp+0x3e>
    8000664a:	00e4d783          	lhu	a5,14(s1)
    8000664e:	fed795e3          	bne	a5,a3,80006638 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    80006652:	01048913          	addi	s2,s1,16
    80006656:	854a                	mv	a0,s2
    80006658:	00001097          	auipc	ra,0x1
    8000665c:	bae080e7          	jalr	-1106(ra) # 80007206 <acquire>
  mbufq_pushtail(&si->rxq, m);
    80006660:	02848493          	addi	s1,s1,40
    80006664:	85d2                	mv	a1,s4
    80006666:	8526                	mv	a0,s1
    80006668:	fffff097          	auipc	ra,0xfffff
    8000666c:	73e080e7          	jalr	1854(ra) # 80005da6 <mbufq_pushtail>
  wakeup(&si->rxq);
    80006670:	8526                	mv	a0,s1
    80006672:	ffffb097          	auipc	ra,0xffffb
    80006676:	0b4080e7          	jalr	180(ra) # 80001726 <wakeup>
  release(&si->lock);
    8000667a:	854a                	mv	a0,s2
    8000667c:	00001097          	auipc	ra,0x1
    80006680:	c3e080e7          	jalr	-962(ra) # 800072ba <release>
  release(&lock);
    80006684:	0001c517          	auipc	a0,0x1c
    80006688:	c9c50513          	addi	a0,a0,-868 # 80022320 <lock>
    8000668c:	00001097          	auipc	ra,0x1
    80006690:	c2e080e7          	jalr	-978(ra) # 800072ba <release>
    80006694:	a831                	j	800066b0 <sockrecvudp+0xb6>
  release(&lock);
    80006696:	0001c517          	auipc	a0,0x1c
    8000669a:	c8a50513          	addi	a0,a0,-886 # 80022320 <lock>
    8000669e:	00001097          	auipc	ra,0x1
    800066a2:	c1c080e7          	jalr	-996(ra) # 800072ba <release>
  mbuffree(m);
    800066a6:	8552                	mv	a0,s4
    800066a8:	fffff097          	auipc	ra,0xfffff
    800066ac:	6e6080e7          	jalr	1766(ra) # 80005d8e <mbuffree>
}
    800066b0:	70e2                	ld	ra,56(sp)
    800066b2:	7442                	ld	s0,48(sp)
    800066b4:	74a2                	ld	s1,40(sp)
    800066b6:	7902                	ld	s2,32(sp)
    800066b8:	69e2                	ld	s3,24(sp)
    800066ba:	6a42                	ld	s4,16(sp)
    800066bc:	6aa2                	ld	s5,8(sp)
    800066be:	6121                	addi	sp,sp,64
    800066c0:	8082                	ret

00000000800066c2 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    800066c2:	715d                	addi	sp,sp,-80
    800066c4:	e486                	sd	ra,72(sp)
    800066c6:	e0a2                	sd	s0,64(sp)
    800066c8:	fc26                	sd	s1,56(sp)
    800066ca:	f84a                	sd	s2,48(sp)
    800066cc:	f44e                	sd	s3,40(sp)
    800066ce:	f052                	sd	s4,32(sp)
    800066d0:	ec56                	sd	s5,24(sp)
    800066d2:	e85a                	sd	s6,16(sp)
    800066d4:	e45e                	sd	s7,8(sp)
    800066d6:	0880                	addi	s0,sp,80
    800066d8:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    800066dc:	100e8937          	lui	s2,0x100e8
    800066e0:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    800066e4:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    800066e6:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    800066e8:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    800066ec:	6a09                	lui	s4,0x2
    800066ee:	300409b7          	lui	s3,0x30040
    800066f2:	a819                	j	80006708 <pci_init+0x46>
      base[4+0] = e1000_regs;
    800066f4:	0166a823          	sw	s6,16(a3) # ff0010 <_entry-0x7f00fff0>

      e1000_init((uint32*)e1000_regs);
    800066f8:	855a                	mv	a0,s6
    800066fa:	fffff097          	auipc	ra,0xfffff
    800066fe:	15e080e7          	jalr	350(ra) # 80005858 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    80006702:	94d2                	add	s1,s1,s4
    80006704:	03348a63          	beq	s1,s3,80006738 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006708:	86a6                	mv	a3,s1
    uint32 id = base[0];
    8000670a:	409c                	lw	a5,0(s1)
    8000670c:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    8000670e:	ff279ae3          	bne	a5,s2,80006702 <pci_init+0x40>
      base[1] = 7;
    80006712:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80006716:	0330000f          	fence	rw,rw
      for(int i = 0; i < 6; i++){
    8000671a:	01048793          	addi	a5,s1,16
    8000671e:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80006722:	4398                	lw	a4,0(a5)
    80006724:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80006726:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    8000672a:	0330000f          	fence	rw,rw
        base[4+i] = old;
    8000672e:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80006730:	0791                	addi	a5,a5,4
    80006732:	fec798e3          	bne	a5,a2,80006722 <pci_init+0x60>
    80006736:	bf7d                	j	800066f4 <pci_init+0x32>
    }
  }
}
    80006738:	60a6                	ld	ra,72(sp)
    8000673a:	6406                	ld	s0,64(sp)
    8000673c:	74e2                	ld	s1,56(sp)
    8000673e:	7942                	ld	s2,48(sp)
    80006740:	79a2                	ld	s3,40(sp)
    80006742:	7a02                	ld	s4,32(sp)
    80006744:	6ae2                	ld	s5,24(sp)
    80006746:	6b42                	ld	s6,16(sp)
    80006748:	6ba2                	ld	s7,8(sp)
    8000674a:	6161                	addi	sp,sp,80
    8000674c:	8082                	ret

000000008000674e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000674e:	1141                	addi	sp,sp,-16
    80006750:	e422                	sd	s0,8(sp)
    80006752:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006754:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80006758:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000675c:	0037979b          	slliw	a5,a5,0x3
    80006760:	02004737          	lui	a4,0x2004
    80006764:	97ba                	add	a5,a5,a4
    80006766:	0200c737          	lui	a4,0x200c
    8000676a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000676c:	6318                	ld	a4,0(a4)
    8000676e:	000f4637          	lui	a2,0xf4
    80006772:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006776:	9732                	add	a4,a4,a2
    80006778:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000677a:	00259693          	slli	a3,a1,0x2
    8000677e:	96ae                	add	a3,a3,a1
    80006780:	068e                	slli	a3,a3,0x3
    80006782:	0001c717          	auipc	a4,0x1c
    80006786:	bbe70713          	addi	a4,a4,-1090 # 80022340 <timer_scratch>
    8000678a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000678c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000678e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80006790:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80006794:	fffff797          	auipc	a5,0xfffff
    80006798:	a8c78793          	addi	a5,a5,-1396 # 80005220 <timervec>
    8000679c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800067a0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800067a4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800067a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800067ac:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800067b0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800067b4:	30479073          	csrw	mie,a5
}
    800067b8:	6422                	ld	s0,8(sp)
    800067ba:	0141                	addi	sp,sp,16
    800067bc:	8082                	ret

00000000800067be <start>:
{
    800067be:	1141                	addi	sp,sp,-16
    800067c0:	e406                	sd	ra,8(sp)
    800067c2:	e022                	sd	s0,0(sp)
    800067c4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800067c6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800067ca:	7779                	lui	a4,0xffffe
    800067cc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd427f>
    800067d0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800067d2:	6705                	lui	a4,0x1
    800067d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800067d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800067da:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800067de:	ffffa797          	auipc	a5,0xffffa
    800067e2:	b3a78793          	addi	a5,a5,-1222 # 80000318 <main>
    800067e6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800067ea:	4781                	li	a5,0
    800067ec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800067f0:	67c1                	lui	a5,0x10
    800067f2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800067f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800067f8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800067fc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006800:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80006804:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80006808:	57fd                	li	a5,-1
    8000680a:	83a9                	srli	a5,a5,0xa
    8000680c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80006810:	47bd                	li	a5,15
    80006812:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006816:	00000097          	auipc	ra,0x0
    8000681a:	f38080e7          	jalr	-200(ra) # 8000674e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000681e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80006822:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80006824:	823e                	mv	tp,a5
  asm volatile("mret");
    80006826:	30200073          	mret
}
    8000682a:	60a2                	ld	ra,8(sp)
    8000682c:	6402                	ld	s0,0(sp)
    8000682e:	0141                	addi	sp,sp,16
    80006830:	8082                	ret

0000000080006832 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80006832:	715d                	addi	sp,sp,-80
    80006834:	e486                	sd	ra,72(sp)
    80006836:	e0a2                	sd	s0,64(sp)
    80006838:	f84a                	sd	s2,48(sp)
    8000683a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000683c:	04c05663          	blez	a2,80006888 <consolewrite+0x56>
    80006840:	fc26                	sd	s1,56(sp)
    80006842:	f44e                	sd	s3,40(sp)
    80006844:	f052                	sd	s4,32(sp)
    80006846:	ec56                	sd	s5,24(sp)
    80006848:	8a2a                	mv	s4,a0
    8000684a:	84ae                	mv	s1,a1
    8000684c:	89b2                	mv	s3,a2
    8000684e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80006850:	5afd                	li	s5,-1
    80006852:	4685                	li	a3,1
    80006854:	8626                	mv	a2,s1
    80006856:	85d2                	mv	a1,s4
    80006858:	fbf40513          	addi	a0,s0,-65
    8000685c:	ffffb097          	auipc	ra,0xffffb
    80006860:	138080e7          	jalr	312(ra) # 80001994 <either_copyin>
    80006864:	03550463          	beq	a0,s5,8000688c <consolewrite+0x5a>
      break;
    uartputc(c);
    80006868:	fbf44503          	lbu	a0,-65(s0)
    8000686c:	00000097          	auipc	ra,0x0
    80006870:	7de080e7          	jalr	2014(ra) # 8000704a <uartputc>
  for(i = 0; i < n; i++){
    80006874:	2905                	addiw	s2,s2,1
    80006876:	0485                	addi	s1,s1,1
    80006878:	fd299de3          	bne	s3,s2,80006852 <consolewrite+0x20>
    8000687c:	894e                	mv	s2,s3
    8000687e:	74e2                	ld	s1,56(sp)
    80006880:	79a2                	ld	s3,40(sp)
    80006882:	7a02                	ld	s4,32(sp)
    80006884:	6ae2                	ld	s5,24(sp)
    80006886:	a039                	j	80006894 <consolewrite+0x62>
    80006888:	4901                	li	s2,0
    8000688a:	a029                	j	80006894 <consolewrite+0x62>
    8000688c:	74e2                	ld	s1,56(sp)
    8000688e:	79a2                	ld	s3,40(sp)
    80006890:	7a02                	ld	s4,32(sp)
    80006892:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80006894:	854a                	mv	a0,s2
    80006896:	60a6                	ld	ra,72(sp)
    80006898:	6406                	ld	s0,64(sp)
    8000689a:	7942                	ld	s2,48(sp)
    8000689c:	6161                	addi	sp,sp,80
    8000689e:	8082                	ret

00000000800068a0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800068a0:	711d                	addi	sp,sp,-96
    800068a2:	ec86                	sd	ra,88(sp)
    800068a4:	e8a2                	sd	s0,80(sp)
    800068a6:	e4a6                	sd	s1,72(sp)
    800068a8:	e0ca                	sd	s2,64(sp)
    800068aa:	fc4e                	sd	s3,56(sp)
    800068ac:	f852                	sd	s4,48(sp)
    800068ae:	f456                	sd	s5,40(sp)
    800068b0:	f05a                	sd	s6,32(sp)
    800068b2:	1080                	addi	s0,sp,96
    800068b4:	8aaa                	mv	s5,a0
    800068b6:	8a2e                	mv	s4,a1
    800068b8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800068ba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800068be:	00024517          	auipc	a0,0x24
    800068c2:	bc250513          	addi	a0,a0,-1086 # 8002a480 <cons>
    800068c6:	00001097          	auipc	ra,0x1
    800068ca:	940080e7          	jalr	-1728(ra) # 80007206 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800068ce:	00024497          	auipc	s1,0x24
    800068d2:	bb248493          	addi	s1,s1,-1102 # 8002a480 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800068d6:	00024917          	auipc	s2,0x24
    800068da:	c4290913          	addi	s2,s2,-958 # 8002a518 <cons+0x98>
  while(n > 0){
    800068de:	0d305463          	blez	s3,800069a6 <consoleread+0x106>
    while(cons.r == cons.w){
    800068e2:	0984a783          	lw	a5,152(s1)
    800068e6:	09c4a703          	lw	a4,156(s1)
    800068ea:	0af71963          	bne	a4,a5,8000699c <consoleread+0xfc>
      if(myproc()->killed){
    800068ee:	ffffa097          	auipc	ra,0xffffa
    800068f2:	5e6080e7          	jalr	1510(ra) # 80000ed4 <myproc>
    800068f6:	551c                	lw	a5,40(a0)
    800068f8:	e7ad                	bnez	a5,80006962 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800068fa:	85a6                	mv	a1,s1
    800068fc:	854a                	mv	a0,s2
    800068fe:	ffffb097          	auipc	ra,0xffffb
    80006902:	c9c080e7          	jalr	-868(ra) # 8000159a <sleep>
    while(cons.r == cons.w){
    80006906:	0984a783          	lw	a5,152(s1)
    8000690a:	09c4a703          	lw	a4,156(s1)
    8000690e:	fef700e3          	beq	a4,a5,800068ee <consoleread+0x4e>
    80006912:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80006914:	00024717          	auipc	a4,0x24
    80006918:	b6c70713          	addi	a4,a4,-1172 # 8002a480 <cons>
    8000691c:	0017869b          	addiw	a3,a5,1
    80006920:	08d72c23          	sw	a3,152(a4)
    80006924:	07f7f693          	andi	a3,a5,127
    80006928:	9736                	add	a4,a4,a3
    8000692a:	01874703          	lbu	a4,24(a4)
    8000692e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80006932:	4691                	li	a3,4
    80006934:	04db8a63          	beq	s7,a3,80006988 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80006938:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000693c:	4685                	li	a3,1
    8000693e:	faf40613          	addi	a2,s0,-81
    80006942:	85d2                	mv	a1,s4
    80006944:	8556                	mv	a0,s5
    80006946:	ffffb097          	auipc	ra,0xffffb
    8000694a:	ff8080e7          	jalr	-8(ra) # 8000193e <either_copyout>
    8000694e:	57fd                	li	a5,-1
    80006950:	04f50a63          	beq	a0,a5,800069a4 <consoleread+0x104>
      break;

    dst++;
    80006954:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    80006956:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if(c == '\n'){
    80006958:	47a9                	li	a5,10
    8000695a:	06fb8163          	beq	s7,a5,800069bc <consoleread+0x11c>
    8000695e:	6be2                	ld	s7,24(sp)
    80006960:	bfbd                	j	800068de <consoleread+0x3e>
        release(&cons.lock);
    80006962:	00024517          	auipc	a0,0x24
    80006966:	b1e50513          	addi	a0,a0,-1250 # 8002a480 <cons>
    8000696a:	00001097          	auipc	ra,0x1
    8000696e:	950080e7          	jalr	-1712(ra) # 800072ba <release>
        return -1;
    80006972:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80006974:	60e6                	ld	ra,88(sp)
    80006976:	6446                	ld	s0,80(sp)
    80006978:	64a6                	ld	s1,72(sp)
    8000697a:	6906                	ld	s2,64(sp)
    8000697c:	79e2                	ld	s3,56(sp)
    8000697e:	7a42                	ld	s4,48(sp)
    80006980:	7aa2                	ld	s5,40(sp)
    80006982:	7b02                	ld	s6,32(sp)
    80006984:	6125                	addi	sp,sp,96
    80006986:	8082                	ret
      if(n < target){
    80006988:	0009871b          	sext.w	a4,s3
    8000698c:	01677a63          	bgeu	a4,s6,800069a0 <consoleread+0x100>
        cons.r--;
    80006990:	00024717          	auipc	a4,0x24
    80006994:	b8f72423          	sw	a5,-1144(a4) # 8002a518 <cons+0x98>
    80006998:	6be2                	ld	s7,24(sp)
    8000699a:	a031                	j	800069a6 <consoleread+0x106>
    8000699c:	ec5e                	sd	s7,24(sp)
    8000699e:	bf9d                	j	80006914 <consoleread+0x74>
    800069a0:	6be2                	ld	s7,24(sp)
    800069a2:	a011                	j	800069a6 <consoleread+0x106>
    800069a4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800069a6:	00024517          	auipc	a0,0x24
    800069aa:	ada50513          	addi	a0,a0,-1318 # 8002a480 <cons>
    800069ae:	00001097          	auipc	ra,0x1
    800069b2:	90c080e7          	jalr	-1780(ra) # 800072ba <release>
  return target - n;
    800069b6:	413b053b          	subw	a0,s6,s3
    800069ba:	bf6d                	j	80006974 <consoleread+0xd4>
    800069bc:	6be2                	ld	s7,24(sp)
    800069be:	b7e5                	j	800069a6 <consoleread+0x106>

00000000800069c0 <consputc>:
{
    800069c0:	1141                	addi	sp,sp,-16
    800069c2:	e406                	sd	ra,8(sp)
    800069c4:	e022                	sd	s0,0(sp)
    800069c6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800069c8:	10000793          	li	a5,256
    800069cc:	00f50a63          	beq	a0,a5,800069e0 <consputc+0x20>
    uartputc_sync(c);
    800069d0:	00000097          	auipc	ra,0x0
    800069d4:	59c080e7          	jalr	1436(ra) # 80006f6c <uartputc_sync>
}
    800069d8:	60a2                	ld	ra,8(sp)
    800069da:	6402                	ld	s0,0(sp)
    800069dc:	0141                	addi	sp,sp,16
    800069de:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800069e0:	4521                	li	a0,8
    800069e2:	00000097          	auipc	ra,0x0
    800069e6:	58a080e7          	jalr	1418(ra) # 80006f6c <uartputc_sync>
    800069ea:	02000513          	li	a0,32
    800069ee:	00000097          	auipc	ra,0x0
    800069f2:	57e080e7          	jalr	1406(ra) # 80006f6c <uartputc_sync>
    800069f6:	4521                	li	a0,8
    800069f8:	00000097          	auipc	ra,0x0
    800069fc:	574080e7          	jalr	1396(ra) # 80006f6c <uartputc_sync>
    80006a00:	bfe1                	j	800069d8 <consputc+0x18>

0000000080006a02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006a02:	1101                	addi	sp,sp,-32
    80006a04:	ec06                	sd	ra,24(sp)
    80006a06:	e822                	sd	s0,16(sp)
    80006a08:	e426                	sd	s1,8(sp)
    80006a0a:	1000                	addi	s0,sp,32
    80006a0c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006a0e:	00024517          	auipc	a0,0x24
    80006a12:	a7250513          	addi	a0,a0,-1422 # 8002a480 <cons>
    80006a16:	00000097          	auipc	ra,0x0
    80006a1a:	7f0080e7          	jalr	2032(ra) # 80007206 <acquire>

  switch(c){
    80006a1e:	47d5                	li	a5,21
    80006a20:	0af48563          	beq	s1,a5,80006aca <consoleintr+0xc8>
    80006a24:	0297c963          	blt	a5,s1,80006a56 <consoleintr+0x54>
    80006a28:	47a1                	li	a5,8
    80006a2a:	0ef48c63          	beq	s1,a5,80006b22 <consoleintr+0x120>
    80006a2e:	47c1                	li	a5,16
    80006a30:	10f49f63          	bne	s1,a5,80006b4e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80006a34:	ffffb097          	auipc	ra,0xffffb
    80006a38:	fb6080e7          	jalr	-74(ra) # 800019ea <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006a3c:	00024517          	auipc	a0,0x24
    80006a40:	a4450513          	addi	a0,a0,-1468 # 8002a480 <cons>
    80006a44:	00001097          	auipc	ra,0x1
    80006a48:	876080e7          	jalr	-1930(ra) # 800072ba <release>
}
    80006a4c:	60e2                	ld	ra,24(sp)
    80006a4e:	6442                	ld	s0,16(sp)
    80006a50:	64a2                	ld	s1,8(sp)
    80006a52:	6105                	addi	sp,sp,32
    80006a54:	8082                	ret
  switch(c){
    80006a56:	07f00793          	li	a5,127
    80006a5a:	0cf48463          	beq	s1,a5,80006b22 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006a5e:	00024717          	auipc	a4,0x24
    80006a62:	a2270713          	addi	a4,a4,-1502 # 8002a480 <cons>
    80006a66:	0a072783          	lw	a5,160(a4)
    80006a6a:	09872703          	lw	a4,152(a4)
    80006a6e:	9f99                	subw	a5,a5,a4
    80006a70:	07f00713          	li	a4,127
    80006a74:	fcf764e3          	bltu	a4,a5,80006a3c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80006a78:	47b5                	li	a5,13
    80006a7a:	0cf48d63          	beq	s1,a5,80006b54 <consoleintr+0x152>
      consputc(c);
    80006a7e:	8526                	mv	a0,s1
    80006a80:	00000097          	auipc	ra,0x0
    80006a84:	f40080e7          	jalr	-192(ra) # 800069c0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a88:	00024797          	auipc	a5,0x24
    80006a8c:	9f878793          	addi	a5,a5,-1544 # 8002a480 <cons>
    80006a90:	0a07a703          	lw	a4,160(a5)
    80006a94:	0017069b          	addiw	a3,a4,1
    80006a98:	0006861b          	sext.w	a2,a3
    80006a9c:	0ad7a023          	sw	a3,160(a5)
    80006aa0:	07f77713          	andi	a4,a4,127
    80006aa4:	97ba                	add	a5,a5,a4
    80006aa6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006aaa:	47a9                	li	a5,10
    80006aac:	0cf48b63          	beq	s1,a5,80006b82 <consoleintr+0x180>
    80006ab0:	4791                	li	a5,4
    80006ab2:	0cf48863          	beq	s1,a5,80006b82 <consoleintr+0x180>
    80006ab6:	00024797          	auipc	a5,0x24
    80006aba:	a627a783          	lw	a5,-1438(a5) # 8002a518 <cons+0x98>
    80006abe:	0807879b          	addiw	a5,a5,128
    80006ac2:	f6f61de3          	bne	a2,a5,80006a3c <consoleintr+0x3a>
    80006ac6:	863e                	mv	a2,a5
    80006ac8:	a86d                	j	80006b82 <consoleintr+0x180>
    80006aca:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80006acc:	00024717          	auipc	a4,0x24
    80006ad0:	9b470713          	addi	a4,a4,-1612 # 8002a480 <cons>
    80006ad4:	0a072783          	lw	a5,160(a4)
    80006ad8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006adc:	00024497          	auipc	s1,0x24
    80006ae0:	9a448493          	addi	s1,s1,-1628 # 8002a480 <cons>
    while(cons.e != cons.w &&
    80006ae4:	4929                	li	s2,10
    80006ae6:	02f70a63          	beq	a4,a5,80006b1a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006aea:	37fd                	addiw	a5,a5,-1
    80006aec:	07f7f713          	andi	a4,a5,127
    80006af0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006af2:	01874703          	lbu	a4,24(a4)
    80006af6:	03270463          	beq	a4,s2,80006b1e <consoleintr+0x11c>
      cons.e--;
    80006afa:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006afe:	10000513          	li	a0,256
    80006b02:	00000097          	auipc	ra,0x0
    80006b06:	ebe080e7          	jalr	-322(ra) # 800069c0 <consputc>
    while(cons.e != cons.w &&
    80006b0a:	0a04a783          	lw	a5,160(s1)
    80006b0e:	09c4a703          	lw	a4,156(s1)
    80006b12:	fcf71ce3          	bne	a4,a5,80006aea <consoleintr+0xe8>
    80006b16:	6902                	ld	s2,0(sp)
    80006b18:	b715                	j	80006a3c <consoleintr+0x3a>
    80006b1a:	6902                	ld	s2,0(sp)
    80006b1c:	b705                	j	80006a3c <consoleintr+0x3a>
    80006b1e:	6902                	ld	s2,0(sp)
    80006b20:	bf31                	j	80006a3c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80006b22:	00024717          	auipc	a4,0x24
    80006b26:	95e70713          	addi	a4,a4,-1698 # 8002a480 <cons>
    80006b2a:	0a072783          	lw	a5,160(a4)
    80006b2e:	09c72703          	lw	a4,156(a4)
    80006b32:	f0f705e3          	beq	a4,a5,80006a3c <consoleintr+0x3a>
      cons.e--;
    80006b36:	37fd                	addiw	a5,a5,-1
    80006b38:	00024717          	auipc	a4,0x24
    80006b3c:	9ef72423          	sw	a5,-1560(a4) # 8002a520 <cons+0xa0>
      consputc(BACKSPACE);
    80006b40:	10000513          	li	a0,256
    80006b44:	00000097          	auipc	ra,0x0
    80006b48:	e7c080e7          	jalr	-388(ra) # 800069c0 <consputc>
    80006b4c:	bdc5                	j	80006a3c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006b4e:	ee0487e3          	beqz	s1,80006a3c <consoleintr+0x3a>
    80006b52:	b731                	j	80006a5e <consoleintr+0x5c>
      consputc(c);
    80006b54:	4529                	li	a0,10
    80006b56:	00000097          	auipc	ra,0x0
    80006b5a:	e6a080e7          	jalr	-406(ra) # 800069c0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006b5e:	00024797          	auipc	a5,0x24
    80006b62:	92278793          	addi	a5,a5,-1758 # 8002a480 <cons>
    80006b66:	0a07a703          	lw	a4,160(a5)
    80006b6a:	0017069b          	addiw	a3,a4,1
    80006b6e:	0006861b          	sext.w	a2,a3
    80006b72:	0ad7a023          	sw	a3,160(a5)
    80006b76:	07f77713          	andi	a4,a4,127
    80006b7a:	97ba                	add	a5,a5,a4
    80006b7c:	4729                	li	a4,10
    80006b7e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006b82:	00024797          	auipc	a5,0x24
    80006b86:	98c7ad23          	sw	a2,-1638(a5) # 8002a51c <cons+0x9c>
        wakeup(&cons.r);
    80006b8a:	00024517          	auipc	a0,0x24
    80006b8e:	98e50513          	addi	a0,a0,-1650 # 8002a518 <cons+0x98>
    80006b92:	ffffb097          	auipc	ra,0xffffb
    80006b96:	b94080e7          	jalr	-1132(ra) # 80001726 <wakeup>
    80006b9a:	b54d                	j	80006a3c <consoleintr+0x3a>

0000000080006b9c <consoleinit>:

void
consoleinit(void)
{
    80006b9c:	1141                	addi	sp,sp,-16
    80006b9e:	e406                	sd	ra,8(sp)
    80006ba0:	e022                	sd	s0,0(sp)
    80006ba2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006ba4:	00003597          	auipc	a1,0x3
    80006ba8:	b3458593          	addi	a1,a1,-1228 # 800096d8 <etext+0x6d8>
    80006bac:	00024517          	auipc	a0,0x24
    80006bb0:	8d450513          	addi	a0,a0,-1836 # 8002a480 <cons>
    80006bb4:	00000097          	auipc	ra,0x0
    80006bb8:	5c2080e7          	jalr	1474(ra) # 80007176 <initlock>

  uartinit();
    80006bbc:	00000097          	auipc	ra,0x0
    80006bc0:	354080e7          	jalr	852(ra) # 80006f10 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006bc4:	00016797          	auipc	a5,0x16
    80006bc8:	52478793          	addi	a5,a5,1316 # 8001d0e8 <devsw>
    80006bcc:	00000717          	auipc	a4,0x0
    80006bd0:	cd470713          	addi	a4,a4,-812 # 800068a0 <consoleread>
    80006bd4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006bd6:	00000717          	auipc	a4,0x0
    80006bda:	c5c70713          	addi	a4,a4,-932 # 80006832 <consolewrite>
    80006bde:	ef98                	sd	a4,24(a5)
}
    80006be0:	60a2                	ld	ra,8(sp)
    80006be2:	6402                	ld	s0,0(sp)
    80006be4:	0141                	addi	sp,sp,16
    80006be6:	8082                	ret

0000000080006be8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006be8:	7179                	addi	sp,sp,-48
    80006bea:	f406                	sd	ra,40(sp)
    80006bec:	f022                	sd	s0,32(sp)
    80006bee:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006bf0:	c219                	beqz	a2,80006bf6 <printint+0xe>
    80006bf2:	08054963          	bltz	a0,80006c84 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006bf6:	2501                	sext.w	a0,a0
    80006bf8:	4881                	li	a7,0
    80006bfa:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006bfe:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006c00:	2581                	sext.w	a1,a1
    80006c02:	00003617          	auipc	a2,0x3
    80006c06:	c7660613          	addi	a2,a2,-906 # 80009878 <digits>
    80006c0a:	883a                	mv	a6,a4
    80006c0c:	2705                	addiw	a4,a4,1
    80006c0e:	02b577bb          	remuw	a5,a0,a1
    80006c12:	1782                	slli	a5,a5,0x20
    80006c14:	9381                	srli	a5,a5,0x20
    80006c16:	97b2                	add	a5,a5,a2
    80006c18:	0007c783          	lbu	a5,0(a5)
    80006c1c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006c20:	0005079b          	sext.w	a5,a0
    80006c24:	02b5553b          	divuw	a0,a0,a1
    80006c28:	0685                	addi	a3,a3,1
    80006c2a:	feb7f0e3          	bgeu	a5,a1,80006c0a <printint+0x22>

  if(sign)
    80006c2e:	00088c63          	beqz	a7,80006c46 <printint+0x5e>
    buf[i++] = '-';
    80006c32:	fe070793          	addi	a5,a4,-32
    80006c36:	00878733          	add	a4,a5,s0
    80006c3a:	02d00793          	li	a5,45
    80006c3e:	fef70823          	sb	a5,-16(a4)
    80006c42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006c46:	02e05b63          	blez	a4,80006c7c <printint+0x94>
    80006c4a:	ec26                	sd	s1,24(sp)
    80006c4c:	e84a                	sd	s2,16(sp)
    80006c4e:	fd040793          	addi	a5,s0,-48
    80006c52:	00e784b3          	add	s1,a5,a4
    80006c56:	fff78913          	addi	s2,a5,-1
    80006c5a:	993a                	add	s2,s2,a4
    80006c5c:	377d                	addiw	a4,a4,-1
    80006c5e:	1702                	slli	a4,a4,0x20
    80006c60:	9301                	srli	a4,a4,0x20
    80006c62:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006c66:	fff4c503          	lbu	a0,-1(s1)
    80006c6a:	00000097          	auipc	ra,0x0
    80006c6e:	d56080e7          	jalr	-682(ra) # 800069c0 <consputc>
  while(--i >= 0)
    80006c72:	14fd                	addi	s1,s1,-1
    80006c74:	ff2499e3          	bne	s1,s2,80006c66 <printint+0x7e>
    80006c78:	64e2                	ld	s1,24(sp)
    80006c7a:	6942                	ld	s2,16(sp)
}
    80006c7c:	70a2                	ld	ra,40(sp)
    80006c7e:	7402                	ld	s0,32(sp)
    80006c80:	6145                	addi	sp,sp,48
    80006c82:	8082                	ret
    x = -xx;
    80006c84:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006c88:	4885                	li	a7,1
    x = -xx;
    80006c8a:	bf85                	j	80006bfa <printint+0x12>

0000000080006c8c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006c8c:	1101                	addi	sp,sp,-32
    80006c8e:	ec06                	sd	ra,24(sp)
    80006c90:	e822                	sd	s0,16(sp)
    80006c92:	e426                	sd	s1,8(sp)
    80006c94:	1000                	addi	s0,sp,32
    80006c96:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006c98:	00024797          	auipc	a5,0x24
    80006c9c:	8a07a423          	sw	zero,-1880(a5) # 8002a540 <pr+0x18>
  printf("panic: ");
    80006ca0:	00003517          	auipc	a0,0x3
    80006ca4:	a4050513          	addi	a0,a0,-1472 # 800096e0 <etext+0x6e0>
    80006ca8:	00000097          	auipc	ra,0x0
    80006cac:	02e080e7          	jalr	46(ra) # 80006cd6 <printf>
  printf(s);
    80006cb0:	8526                	mv	a0,s1
    80006cb2:	00000097          	auipc	ra,0x0
    80006cb6:	024080e7          	jalr	36(ra) # 80006cd6 <printf>
  printf("\n");
    80006cba:	00002517          	auipc	a0,0x2
    80006cbe:	35e50513          	addi	a0,a0,862 # 80009018 <etext+0x18>
    80006cc2:	00000097          	auipc	ra,0x0
    80006cc6:	014080e7          	jalr	20(ra) # 80006cd6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006cca:	4785                	li	a5,1
    80006ccc:	00006717          	auipc	a4,0x6
    80006cd0:	36f72223          	sw	a5,868(a4) # 8000d030 <panicked>
  for(;;)
    80006cd4:	a001                	j	80006cd4 <panic+0x48>

0000000080006cd6 <printf>:
{
    80006cd6:	7131                	addi	sp,sp,-192
    80006cd8:	fc86                	sd	ra,120(sp)
    80006cda:	f8a2                	sd	s0,112(sp)
    80006cdc:	e8d2                	sd	s4,80(sp)
    80006cde:	f06a                	sd	s10,32(sp)
    80006ce0:	0100                	addi	s0,sp,128
    80006ce2:	8a2a                	mv	s4,a0
    80006ce4:	e40c                	sd	a1,8(s0)
    80006ce6:	e810                	sd	a2,16(s0)
    80006ce8:	ec14                	sd	a3,24(s0)
    80006cea:	f018                	sd	a4,32(s0)
    80006cec:	f41c                	sd	a5,40(s0)
    80006cee:	03043823          	sd	a6,48(s0)
    80006cf2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006cf6:	00024d17          	auipc	s10,0x24
    80006cfa:	84ad2d03          	lw	s10,-1974(s10) # 8002a540 <pr+0x18>
  if(locking)
    80006cfe:	040d1463          	bnez	s10,80006d46 <printf+0x70>
  if (fmt == 0)
    80006d02:	040a0b63          	beqz	s4,80006d58 <printf+0x82>
  va_start(ap, fmt);
    80006d06:	00840793          	addi	a5,s0,8
    80006d0a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006d0e:	000a4503          	lbu	a0,0(s4)
    80006d12:	18050b63          	beqz	a0,80006ea8 <printf+0x1d2>
    80006d16:	f4a6                	sd	s1,104(sp)
    80006d18:	f0ca                	sd	s2,96(sp)
    80006d1a:	ecce                	sd	s3,88(sp)
    80006d1c:	e4d6                	sd	s5,72(sp)
    80006d1e:	e0da                	sd	s6,64(sp)
    80006d20:	fc5e                	sd	s7,56(sp)
    80006d22:	f862                	sd	s8,48(sp)
    80006d24:	f466                	sd	s9,40(sp)
    80006d26:	ec6e                	sd	s11,24(sp)
    80006d28:	4981                	li	s3,0
    if(c != '%'){
    80006d2a:	02500b13          	li	s6,37
    switch(c){
    80006d2e:	07000b93          	li	s7,112
  consputc('x');
    80006d32:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d34:	00003a97          	auipc	s5,0x3
    80006d38:	b44a8a93          	addi	s5,s5,-1212 # 80009878 <digits>
    switch(c){
    80006d3c:	07300c13          	li	s8,115
    80006d40:	06400d93          	li	s11,100
    80006d44:	a0b1                	j	80006d90 <printf+0xba>
    acquire(&pr.lock);
    80006d46:	00023517          	auipc	a0,0x23
    80006d4a:	7e250513          	addi	a0,a0,2018 # 8002a528 <pr>
    80006d4e:	00000097          	auipc	ra,0x0
    80006d52:	4b8080e7          	jalr	1208(ra) # 80007206 <acquire>
    80006d56:	b775                	j	80006d02 <printf+0x2c>
    80006d58:	f4a6                	sd	s1,104(sp)
    80006d5a:	f0ca                	sd	s2,96(sp)
    80006d5c:	ecce                	sd	s3,88(sp)
    80006d5e:	e4d6                	sd	s5,72(sp)
    80006d60:	e0da                	sd	s6,64(sp)
    80006d62:	fc5e                	sd	s7,56(sp)
    80006d64:	f862                	sd	s8,48(sp)
    80006d66:	f466                	sd	s9,40(sp)
    80006d68:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006d6a:	00003517          	auipc	a0,0x3
    80006d6e:	98650513          	addi	a0,a0,-1658 # 800096f0 <etext+0x6f0>
    80006d72:	00000097          	auipc	ra,0x0
    80006d76:	f1a080e7          	jalr	-230(ra) # 80006c8c <panic>
      consputc(c);
    80006d7a:	00000097          	auipc	ra,0x0
    80006d7e:	c46080e7          	jalr	-954(ra) # 800069c0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006d82:	2985                	addiw	s3,s3,1
    80006d84:	013a07b3          	add	a5,s4,s3
    80006d88:	0007c503          	lbu	a0,0(a5)
    80006d8c:	10050563          	beqz	a0,80006e96 <printf+0x1c0>
    if(c != '%'){
    80006d90:	ff6515e3          	bne	a0,s6,80006d7a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006d94:	2985                	addiw	s3,s3,1
    80006d96:	013a07b3          	add	a5,s4,s3
    80006d9a:	0007c783          	lbu	a5,0(a5)
    80006d9e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006da2:	10078b63          	beqz	a5,80006eb8 <printf+0x1e2>
    switch(c){
    80006da6:	05778a63          	beq	a5,s7,80006dfa <printf+0x124>
    80006daa:	02fbf663          	bgeu	s7,a5,80006dd6 <printf+0x100>
    80006dae:	09878863          	beq	a5,s8,80006e3e <printf+0x168>
    80006db2:	07800713          	li	a4,120
    80006db6:	0ce79563          	bne	a5,a4,80006e80 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006dba:	f8843783          	ld	a5,-120(s0)
    80006dbe:	00878713          	addi	a4,a5,8
    80006dc2:	f8e43423          	sd	a4,-120(s0)
    80006dc6:	4605                	li	a2,1
    80006dc8:	85e6                	mv	a1,s9
    80006dca:	4388                	lw	a0,0(a5)
    80006dcc:	00000097          	auipc	ra,0x0
    80006dd0:	e1c080e7          	jalr	-484(ra) # 80006be8 <printint>
      break;
    80006dd4:	b77d                	j	80006d82 <printf+0xac>
    switch(c){
    80006dd6:	09678f63          	beq	a5,s6,80006e74 <printf+0x19e>
    80006dda:	0bb79363          	bne	a5,s11,80006e80 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006dde:	f8843783          	ld	a5,-120(s0)
    80006de2:	00878713          	addi	a4,a5,8
    80006de6:	f8e43423          	sd	a4,-120(s0)
    80006dea:	4605                	li	a2,1
    80006dec:	45a9                	li	a1,10
    80006dee:	4388                	lw	a0,0(a5)
    80006df0:	00000097          	auipc	ra,0x0
    80006df4:	df8080e7          	jalr	-520(ra) # 80006be8 <printint>
      break;
    80006df8:	b769                	j	80006d82 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006dfa:	f8843783          	ld	a5,-120(s0)
    80006dfe:	00878713          	addi	a4,a5,8
    80006e02:	f8e43423          	sd	a4,-120(s0)
    80006e06:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006e0a:	03000513          	li	a0,48
    80006e0e:	00000097          	auipc	ra,0x0
    80006e12:	bb2080e7          	jalr	-1102(ra) # 800069c0 <consputc>
  consputc('x');
    80006e16:	07800513          	li	a0,120
    80006e1a:	00000097          	auipc	ra,0x0
    80006e1e:	ba6080e7          	jalr	-1114(ra) # 800069c0 <consputc>
    80006e22:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006e24:	03c95793          	srli	a5,s2,0x3c
    80006e28:	97d6                	add	a5,a5,s5
    80006e2a:	0007c503          	lbu	a0,0(a5)
    80006e2e:	00000097          	auipc	ra,0x0
    80006e32:	b92080e7          	jalr	-1134(ra) # 800069c0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006e36:	0912                	slli	s2,s2,0x4
    80006e38:	34fd                	addiw	s1,s1,-1
    80006e3a:	f4ed                	bnez	s1,80006e24 <printf+0x14e>
    80006e3c:	b799                	j	80006d82 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006e3e:	f8843783          	ld	a5,-120(s0)
    80006e42:	00878713          	addi	a4,a5,8
    80006e46:	f8e43423          	sd	a4,-120(s0)
    80006e4a:	6384                	ld	s1,0(a5)
    80006e4c:	cc89                	beqz	s1,80006e66 <printf+0x190>
      for(; *s; s++)
    80006e4e:	0004c503          	lbu	a0,0(s1)
    80006e52:	d905                	beqz	a0,80006d82 <printf+0xac>
        consputc(*s);
    80006e54:	00000097          	auipc	ra,0x0
    80006e58:	b6c080e7          	jalr	-1172(ra) # 800069c0 <consputc>
      for(; *s; s++)
    80006e5c:	0485                	addi	s1,s1,1
    80006e5e:	0004c503          	lbu	a0,0(s1)
    80006e62:	f96d                	bnez	a0,80006e54 <printf+0x17e>
    80006e64:	bf39                	j	80006d82 <printf+0xac>
        s = "(null)";
    80006e66:	00003497          	auipc	s1,0x3
    80006e6a:	88248493          	addi	s1,s1,-1918 # 800096e8 <etext+0x6e8>
      for(; *s; s++)
    80006e6e:	02800513          	li	a0,40
    80006e72:	b7cd                	j	80006e54 <printf+0x17e>
      consputc('%');
    80006e74:	855a                	mv	a0,s6
    80006e76:	00000097          	auipc	ra,0x0
    80006e7a:	b4a080e7          	jalr	-1206(ra) # 800069c0 <consputc>
      break;
    80006e7e:	b711                	j	80006d82 <printf+0xac>
      consputc('%');
    80006e80:	855a                	mv	a0,s6
    80006e82:	00000097          	auipc	ra,0x0
    80006e86:	b3e080e7          	jalr	-1218(ra) # 800069c0 <consputc>
      consputc(c);
    80006e8a:	8526                	mv	a0,s1
    80006e8c:	00000097          	auipc	ra,0x0
    80006e90:	b34080e7          	jalr	-1228(ra) # 800069c0 <consputc>
      break;
    80006e94:	b5fd                	j	80006d82 <printf+0xac>
    80006e96:	74a6                	ld	s1,104(sp)
    80006e98:	7906                	ld	s2,96(sp)
    80006e9a:	69e6                	ld	s3,88(sp)
    80006e9c:	6aa6                	ld	s5,72(sp)
    80006e9e:	6b06                	ld	s6,64(sp)
    80006ea0:	7be2                	ld	s7,56(sp)
    80006ea2:	7c42                	ld	s8,48(sp)
    80006ea4:	7ca2                	ld	s9,40(sp)
    80006ea6:	6de2                	ld	s11,24(sp)
  if(locking)
    80006ea8:	020d1263          	bnez	s10,80006ecc <printf+0x1f6>
}
    80006eac:	70e6                	ld	ra,120(sp)
    80006eae:	7446                	ld	s0,112(sp)
    80006eb0:	6a46                	ld	s4,80(sp)
    80006eb2:	7d02                	ld	s10,32(sp)
    80006eb4:	6129                	addi	sp,sp,192
    80006eb6:	8082                	ret
    80006eb8:	74a6                	ld	s1,104(sp)
    80006eba:	7906                	ld	s2,96(sp)
    80006ebc:	69e6                	ld	s3,88(sp)
    80006ebe:	6aa6                	ld	s5,72(sp)
    80006ec0:	6b06                	ld	s6,64(sp)
    80006ec2:	7be2                	ld	s7,56(sp)
    80006ec4:	7c42                	ld	s8,48(sp)
    80006ec6:	7ca2                	ld	s9,40(sp)
    80006ec8:	6de2                	ld	s11,24(sp)
    80006eca:	bff9                	j	80006ea8 <printf+0x1d2>
    release(&pr.lock);
    80006ecc:	00023517          	auipc	a0,0x23
    80006ed0:	65c50513          	addi	a0,a0,1628 # 8002a528 <pr>
    80006ed4:	00000097          	auipc	ra,0x0
    80006ed8:	3e6080e7          	jalr	998(ra) # 800072ba <release>
}
    80006edc:	bfc1                	j	80006eac <printf+0x1d6>

0000000080006ede <printfinit>:
    ;
}

void
printfinit(void)
{
    80006ede:	1101                	addi	sp,sp,-32
    80006ee0:	ec06                	sd	ra,24(sp)
    80006ee2:	e822                	sd	s0,16(sp)
    80006ee4:	e426                	sd	s1,8(sp)
    80006ee6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006ee8:	00023497          	auipc	s1,0x23
    80006eec:	64048493          	addi	s1,s1,1600 # 8002a528 <pr>
    80006ef0:	00003597          	auipc	a1,0x3
    80006ef4:	81058593          	addi	a1,a1,-2032 # 80009700 <etext+0x700>
    80006ef8:	8526                	mv	a0,s1
    80006efa:	00000097          	auipc	ra,0x0
    80006efe:	27c080e7          	jalr	636(ra) # 80007176 <initlock>
  pr.locking = 1;
    80006f02:	4785                	li	a5,1
    80006f04:	cc9c                	sw	a5,24(s1)
}
    80006f06:	60e2                	ld	ra,24(sp)
    80006f08:	6442                	ld	s0,16(sp)
    80006f0a:	64a2                	ld	s1,8(sp)
    80006f0c:	6105                	addi	sp,sp,32
    80006f0e:	8082                	ret

0000000080006f10 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006f10:	1141                	addi	sp,sp,-16
    80006f12:	e406                	sd	ra,8(sp)
    80006f14:	e022                	sd	s0,0(sp)
    80006f16:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006f18:	100007b7          	lui	a5,0x10000
    80006f1c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006f20:	10000737          	lui	a4,0x10000
    80006f24:	f8000693          	li	a3,-128
    80006f28:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006f2c:	468d                	li	a3,3
    80006f2e:	10000637          	lui	a2,0x10000
    80006f32:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006f36:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006f3a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006f3e:	10000737          	lui	a4,0x10000
    80006f42:	461d                	li	a2,7
    80006f44:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006f48:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006f4c:	00002597          	auipc	a1,0x2
    80006f50:	7bc58593          	addi	a1,a1,1980 # 80009708 <etext+0x708>
    80006f54:	00023517          	auipc	a0,0x23
    80006f58:	5f450513          	addi	a0,a0,1524 # 8002a548 <uart_tx_lock>
    80006f5c:	00000097          	auipc	ra,0x0
    80006f60:	21a080e7          	jalr	538(ra) # 80007176 <initlock>
}
    80006f64:	60a2                	ld	ra,8(sp)
    80006f66:	6402                	ld	s0,0(sp)
    80006f68:	0141                	addi	sp,sp,16
    80006f6a:	8082                	ret

0000000080006f6c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006f6c:	1101                	addi	sp,sp,-32
    80006f6e:	ec06                	sd	ra,24(sp)
    80006f70:	e822                	sd	s0,16(sp)
    80006f72:	e426                	sd	s1,8(sp)
    80006f74:	1000                	addi	s0,sp,32
    80006f76:	84aa                	mv	s1,a0
  push_off();
    80006f78:	00000097          	auipc	ra,0x0
    80006f7c:	242080e7          	jalr	578(ra) # 800071ba <push_off>

  if(panicked){
    80006f80:	00006797          	auipc	a5,0x6
    80006f84:	0b07a783          	lw	a5,176(a5) # 8000d030 <panicked>
    80006f88:	eb85                	bnez	a5,80006fb8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006f8a:	10000737          	lui	a4,0x10000
    80006f8e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006f90:	00074783          	lbu	a5,0(a4)
    80006f94:	0207f793          	andi	a5,a5,32
    80006f98:	dfe5                	beqz	a5,80006f90 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006f9a:	0ff4f513          	zext.b	a0,s1
    80006f9e:	100007b7          	lui	a5,0x10000
    80006fa2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006fa6:	00000097          	auipc	ra,0x0
    80006faa:	2b4080e7          	jalr	692(ra) # 8000725a <pop_off>
}
    80006fae:	60e2                	ld	ra,24(sp)
    80006fb0:	6442                	ld	s0,16(sp)
    80006fb2:	64a2                	ld	s1,8(sp)
    80006fb4:	6105                	addi	sp,sp,32
    80006fb6:	8082                	ret
    for(;;)
    80006fb8:	a001                	j	80006fb8 <uartputc_sync+0x4c>

0000000080006fba <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006fba:	00006797          	auipc	a5,0x6
    80006fbe:	07e7b783          	ld	a5,126(a5) # 8000d038 <uart_tx_r>
    80006fc2:	00006717          	auipc	a4,0x6
    80006fc6:	07e73703          	ld	a4,126(a4) # 8000d040 <uart_tx_w>
    80006fca:	06f70f63          	beq	a4,a5,80007048 <uartstart+0x8e>
{
    80006fce:	7139                	addi	sp,sp,-64
    80006fd0:	fc06                	sd	ra,56(sp)
    80006fd2:	f822                	sd	s0,48(sp)
    80006fd4:	f426                	sd	s1,40(sp)
    80006fd6:	f04a                	sd	s2,32(sp)
    80006fd8:	ec4e                	sd	s3,24(sp)
    80006fda:	e852                	sd	s4,16(sp)
    80006fdc:	e456                	sd	s5,8(sp)
    80006fde:	e05a                	sd	s6,0(sp)
    80006fe0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006fe2:	10000937          	lui	s2,0x10000
    80006fe6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006fe8:	00023a97          	auipc	s5,0x23
    80006fec:	560a8a93          	addi	s5,s5,1376 # 8002a548 <uart_tx_lock>
    uart_tx_r += 1;
    80006ff0:	00006497          	auipc	s1,0x6
    80006ff4:	04848493          	addi	s1,s1,72 # 8000d038 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006ff8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006ffc:	00006997          	auipc	s3,0x6
    80007000:	04498993          	addi	s3,s3,68 # 8000d040 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80007004:	00094703          	lbu	a4,0(s2)
    80007008:	02077713          	andi	a4,a4,32
    8000700c:	c705                	beqz	a4,80007034 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000700e:	01f7f713          	andi	a4,a5,31
    80007012:	9756                	add	a4,a4,s5
    80007014:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80007018:	0785                	addi	a5,a5,1
    8000701a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000701c:	8526                	mv	a0,s1
    8000701e:	ffffa097          	auipc	ra,0xffffa
    80007022:	708080e7          	jalr	1800(ra) # 80001726 <wakeup>
    WriteReg(THR, c);
    80007026:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000702a:	609c                	ld	a5,0(s1)
    8000702c:	0009b703          	ld	a4,0(s3)
    80007030:	fcf71ae3          	bne	a4,a5,80007004 <uartstart+0x4a>
  }
}
    80007034:	70e2                	ld	ra,56(sp)
    80007036:	7442                	ld	s0,48(sp)
    80007038:	74a2                	ld	s1,40(sp)
    8000703a:	7902                	ld	s2,32(sp)
    8000703c:	69e2                	ld	s3,24(sp)
    8000703e:	6a42                	ld	s4,16(sp)
    80007040:	6aa2                	ld	s5,8(sp)
    80007042:	6b02                	ld	s6,0(sp)
    80007044:	6121                	addi	sp,sp,64
    80007046:	8082                	ret
    80007048:	8082                	ret

000000008000704a <uartputc>:
{
    8000704a:	7179                	addi	sp,sp,-48
    8000704c:	f406                	sd	ra,40(sp)
    8000704e:	f022                	sd	s0,32(sp)
    80007050:	e052                	sd	s4,0(sp)
    80007052:	1800                	addi	s0,sp,48
    80007054:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80007056:	00023517          	auipc	a0,0x23
    8000705a:	4f250513          	addi	a0,a0,1266 # 8002a548 <uart_tx_lock>
    8000705e:	00000097          	auipc	ra,0x0
    80007062:	1a8080e7          	jalr	424(ra) # 80007206 <acquire>
  if(panicked){
    80007066:	00006797          	auipc	a5,0x6
    8000706a:	fca7a783          	lw	a5,-54(a5) # 8000d030 <panicked>
    8000706e:	c391                	beqz	a5,80007072 <uartputc+0x28>
    for(;;)
    80007070:	a001                	j	80007070 <uartputc+0x26>
    80007072:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80007074:	00006717          	auipc	a4,0x6
    80007078:	fcc73703          	ld	a4,-52(a4) # 8000d040 <uart_tx_w>
    8000707c:	00006797          	auipc	a5,0x6
    80007080:	fbc7b783          	ld	a5,-68(a5) # 8000d038 <uart_tx_r>
    80007084:	02078793          	addi	a5,a5,32
    80007088:	02e79f63          	bne	a5,a4,800070c6 <uartputc+0x7c>
    8000708c:	e84a                	sd	s2,16(sp)
    8000708e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80007090:	00023997          	auipc	s3,0x23
    80007094:	4b898993          	addi	s3,s3,1208 # 8002a548 <uart_tx_lock>
    80007098:	00006497          	auipc	s1,0x6
    8000709c:	fa048493          	addi	s1,s1,-96 # 8000d038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800070a0:	00006917          	auipc	s2,0x6
    800070a4:	fa090913          	addi	s2,s2,-96 # 8000d040 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800070a8:	85ce                	mv	a1,s3
    800070aa:	8526                	mv	a0,s1
    800070ac:	ffffa097          	auipc	ra,0xffffa
    800070b0:	4ee080e7          	jalr	1262(ra) # 8000159a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800070b4:	00093703          	ld	a4,0(s2)
    800070b8:	609c                	ld	a5,0(s1)
    800070ba:	02078793          	addi	a5,a5,32
    800070be:	fee785e3          	beq	a5,a4,800070a8 <uartputc+0x5e>
    800070c2:	6942                	ld	s2,16(sp)
    800070c4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800070c6:	00023497          	auipc	s1,0x23
    800070ca:	48248493          	addi	s1,s1,1154 # 8002a548 <uart_tx_lock>
    800070ce:	01f77793          	andi	a5,a4,31
    800070d2:	97a6                	add	a5,a5,s1
    800070d4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800070d8:	0705                	addi	a4,a4,1
    800070da:	00006797          	auipc	a5,0x6
    800070de:	f6e7b323          	sd	a4,-154(a5) # 8000d040 <uart_tx_w>
      uartstart();
    800070e2:	00000097          	auipc	ra,0x0
    800070e6:	ed8080e7          	jalr	-296(ra) # 80006fba <uartstart>
      release(&uart_tx_lock);
    800070ea:	8526                	mv	a0,s1
    800070ec:	00000097          	auipc	ra,0x0
    800070f0:	1ce080e7          	jalr	462(ra) # 800072ba <release>
    800070f4:	64e2                	ld	s1,24(sp)
}
    800070f6:	70a2                	ld	ra,40(sp)
    800070f8:	7402                	ld	s0,32(sp)
    800070fa:	6a02                	ld	s4,0(sp)
    800070fc:	6145                	addi	sp,sp,48
    800070fe:	8082                	ret

0000000080007100 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80007100:	1141                	addi	sp,sp,-16
    80007102:	e422                	sd	s0,8(sp)
    80007104:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80007106:	100007b7          	lui	a5,0x10000
    8000710a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000710c:	0007c783          	lbu	a5,0(a5)
    80007110:	8b85                	andi	a5,a5,1
    80007112:	cb81                	beqz	a5,80007122 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80007114:	100007b7          	lui	a5,0x10000
    80007118:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000711c:	6422                	ld	s0,8(sp)
    8000711e:	0141                	addi	sp,sp,16
    80007120:	8082                	ret
    return -1;
    80007122:	557d                	li	a0,-1
    80007124:	bfe5                	j	8000711c <uartgetc+0x1c>

0000000080007126 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80007126:	1101                	addi	sp,sp,-32
    80007128:	ec06                	sd	ra,24(sp)
    8000712a:	e822                	sd	s0,16(sp)
    8000712c:	e426                	sd	s1,8(sp)
    8000712e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80007130:	54fd                	li	s1,-1
    80007132:	a029                	j	8000713c <uartintr+0x16>
      break;
    consoleintr(c);
    80007134:	00000097          	auipc	ra,0x0
    80007138:	8ce080e7          	jalr	-1842(ra) # 80006a02 <consoleintr>
    int c = uartgetc();
    8000713c:	00000097          	auipc	ra,0x0
    80007140:	fc4080e7          	jalr	-60(ra) # 80007100 <uartgetc>
    if(c == -1)
    80007144:	fe9518e3          	bne	a0,s1,80007134 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80007148:	00023497          	auipc	s1,0x23
    8000714c:	40048493          	addi	s1,s1,1024 # 8002a548 <uart_tx_lock>
    80007150:	8526                	mv	a0,s1
    80007152:	00000097          	auipc	ra,0x0
    80007156:	0b4080e7          	jalr	180(ra) # 80007206 <acquire>
  uartstart();
    8000715a:	00000097          	auipc	ra,0x0
    8000715e:	e60080e7          	jalr	-416(ra) # 80006fba <uartstart>
  release(&uart_tx_lock);
    80007162:	8526                	mv	a0,s1
    80007164:	00000097          	auipc	ra,0x0
    80007168:	156080e7          	jalr	342(ra) # 800072ba <release>
}
    8000716c:	60e2                	ld	ra,24(sp)
    8000716e:	6442                	ld	s0,16(sp)
    80007170:	64a2                	ld	s1,8(sp)
    80007172:	6105                	addi	sp,sp,32
    80007174:	8082                	ret

0000000080007176 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80007176:	1141                	addi	sp,sp,-16
    80007178:	e422                	sd	s0,8(sp)
    8000717a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000717c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000717e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80007182:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80007186:	6422                	ld	s0,8(sp)
    80007188:	0141                	addi	sp,sp,16
    8000718a:	8082                	ret

000000008000718c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000718c:	411c                	lw	a5,0(a0)
    8000718e:	e399                	bnez	a5,80007194 <holding+0x8>
    80007190:	4501                	li	a0,0
  return r;
}
    80007192:	8082                	ret
{
    80007194:	1101                	addi	sp,sp,-32
    80007196:	ec06                	sd	ra,24(sp)
    80007198:	e822                	sd	s0,16(sp)
    8000719a:	e426                	sd	s1,8(sp)
    8000719c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000719e:	6904                	ld	s1,16(a0)
    800071a0:	ffffa097          	auipc	ra,0xffffa
    800071a4:	d18080e7          	jalr	-744(ra) # 80000eb8 <mycpu>
    800071a8:	40a48533          	sub	a0,s1,a0
    800071ac:	00153513          	seqz	a0,a0
}
    800071b0:	60e2                	ld	ra,24(sp)
    800071b2:	6442                	ld	s0,16(sp)
    800071b4:	64a2                	ld	s1,8(sp)
    800071b6:	6105                	addi	sp,sp,32
    800071b8:	8082                	ret

00000000800071ba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800071ba:	1101                	addi	sp,sp,-32
    800071bc:	ec06                	sd	ra,24(sp)
    800071be:	e822                	sd	s0,16(sp)
    800071c0:	e426                	sd	s1,8(sp)
    800071c2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800071c4:	100024f3          	csrr	s1,sstatus
    800071c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800071cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800071ce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800071d2:	ffffa097          	auipc	ra,0xffffa
    800071d6:	ce6080e7          	jalr	-794(ra) # 80000eb8 <mycpu>
    800071da:	5d3c                	lw	a5,120(a0)
    800071dc:	cf89                	beqz	a5,800071f6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800071de:	ffffa097          	auipc	ra,0xffffa
    800071e2:	cda080e7          	jalr	-806(ra) # 80000eb8 <mycpu>
    800071e6:	5d3c                	lw	a5,120(a0)
    800071e8:	2785                	addiw	a5,a5,1
    800071ea:	dd3c                	sw	a5,120(a0)
}
    800071ec:	60e2                	ld	ra,24(sp)
    800071ee:	6442                	ld	s0,16(sp)
    800071f0:	64a2                	ld	s1,8(sp)
    800071f2:	6105                	addi	sp,sp,32
    800071f4:	8082                	ret
    mycpu()->intena = old;
    800071f6:	ffffa097          	auipc	ra,0xffffa
    800071fa:	cc2080e7          	jalr	-830(ra) # 80000eb8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800071fe:	8085                	srli	s1,s1,0x1
    80007200:	8885                	andi	s1,s1,1
    80007202:	dd64                	sw	s1,124(a0)
    80007204:	bfe9                	j	800071de <push_off+0x24>

0000000080007206 <acquire>:
{
    80007206:	1101                	addi	sp,sp,-32
    80007208:	ec06                	sd	ra,24(sp)
    8000720a:	e822                	sd	s0,16(sp)
    8000720c:	e426                	sd	s1,8(sp)
    8000720e:	1000                	addi	s0,sp,32
    80007210:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80007212:	00000097          	auipc	ra,0x0
    80007216:	fa8080e7          	jalr	-88(ra) # 800071ba <push_off>
  if(holding(lk))
    8000721a:	8526                	mv	a0,s1
    8000721c:	00000097          	auipc	ra,0x0
    80007220:	f70080e7          	jalr	-144(ra) # 8000718c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007224:	4705                	li	a4,1
  if(holding(lk))
    80007226:	e115                	bnez	a0,8000724a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007228:	87ba                	mv	a5,a4
    8000722a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000722e:	2781                	sext.w	a5,a5
    80007230:	ffe5                	bnez	a5,80007228 <acquire+0x22>
  __sync_synchronize();
    80007232:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80007236:	ffffa097          	auipc	ra,0xffffa
    8000723a:	c82080e7          	jalr	-894(ra) # 80000eb8 <mycpu>
    8000723e:	e888                	sd	a0,16(s1)
}
    80007240:	60e2                	ld	ra,24(sp)
    80007242:	6442                	ld	s0,16(sp)
    80007244:	64a2                	ld	s1,8(sp)
    80007246:	6105                	addi	sp,sp,32
    80007248:	8082                	ret
    panic("acquire");
    8000724a:	00002517          	auipc	a0,0x2
    8000724e:	4c650513          	addi	a0,a0,1222 # 80009710 <etext+0x710>
    80007252:	00000097          	auipc	ra,0x0
    80007256:	a3a080e7          	jalr	-1478(ra) # 80006c8c <panic>

000000008000725a <pop_off>:

void
pop_off(void)
{
    8000725a:	1141                	addi	sp,sp,-16
    8000725c:	e406                	sd	ra,8(sp)
    8000725e:	e022                	sd	s0,0(sp)
    80007260:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80007262:	ffffa097          	auipc	ra,0xffffa
    80007266:	c56080e7          	jalr	-938(ra) # 80000eb8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000726a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000726e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80007270:	e78d                	bnez	a5,8000729a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80007272:	5d3c                	lw	a5,120(a0)
    80007274:	02f05b63          	blez	a5,800072aa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80007278:	37fd                	addiw	a5,a5,-1
    8000727a:	0007871b          	sext.w	a4,a5
    8000727e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80007280:	eb09                	bnez	a4,80007292 <pop_off+0x38>
    80007282:	5d7c                	lw	a5,124(a0)
    80007284:	c799                	beqz	a5,80007292 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007286:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000728a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000728e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80007292:	60a2                	ld	ra,8(sp)
    80007294:	6402                	ld	s0,0(sp)
    80007296:	0141                	addi	sp,sp,16
    80007298:	8082                	ret
    panic("pop_off - interruptible");
    8000729a:	00002517          	auipc	a0,0x2
    8000729e:	47e50513          	addi	a0,a0,1150 # 80009718 <etext+0x718>
    800072a2:	00000097          	auipc	ra,0x0
    800072a6:	9ea080e7          	jalr	-1558(ra) # 80006c8c <panic>
    panic("pop_off");
    800072aa:	00002517          	auipc	a0,0x2
    800072ae:	48650513          	addi	a0,a0,1158 # 80009730 <etext+0x730>
    800072b2:	00000097          	auipc	ra,0x0
    800072b6:	9da080e7          	jalr	-1574(ra) # 80006c8c <panic>

00000000800072ba <release>:
{
    800072ba:	1101                	addi	sp,sp,-32
    800072bc:	ec06                	sd	ra,24(sp)
    800072be:	e822                	sd	s0,16(sp)
    800072c0:	e426                	sd	s1,8(sp)
    800072c2:	1000                	addi	s0,sp,32
    800072c4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800072c6:	00000097          	auipc	ra,0x0
    800072ca:	ec6080e7          	jalr	-314(ra) # 8000718c <holding>
    800072ce:	c115                	beqz	a0,800072f2 <release+0x38>
  lk->cpu = 0;
    800072d0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800072d4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800072d8:	0310000f          	fence	rw,w
    800072dc:	0004a023          	sw	zero,0(s1)
  pop_off();
    800072e0:	00000097          	auipc	ra,0x0
    800072e4:	f7a080e7          	jalr	-134(ra) # 8000725a <pop_off>
}
    800072e8:	60e2                	ld	ra,24(sp)
    800072ea:	6442                	ld	s0,16(sp)
    800072ec:	64a2                	ld	s1,8(sp)
    800072ee:	6105                	addi	sp,sp,32
    800072f0:	8082                	ret
    panic("release");
    800072f2:	00002517          	auipc	a0,0x2
    800072f6:	44650513          	addi	a0,a0,1094 # 80009738 <etext+0x738>
    800072fa:	00000097          	auipc	ra,0x0
    800072fe:	992080e7          	jalr	-1646(ra) # 80006c8c <panic>

0000000080007302 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80007302:	1141                	addi	sp,sp,-16
    80007304:	e422                	sd	s0,8(sp)
    80007306:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007308:	0330000f          	fence	rw,rw
    8000730c:	6108                	ld	a0,0(a0)
    8000730e:	0230000f          	fence	r,rw
  return val;
}
    80007312:	6422                	ld	s0,8(sp)
    80007314:	0141                	addi	sp,sp,16
    80007316:	8082                	ret

0000000080007318 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80007318:	1141                	addi	sp,sp,-16
    8000731a:	e422                	sd	s0,8(sp)
    8000731c:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000731e:	0330000f          	fence	rw,rw
    80007322:	4108                	lw	a0,0(a0)
    80007324:	0230000f          	fence	r,rw
  return val;
}
    80007328:	2501                	sext.w	a0,a0
    8000732a:	6422                	ld	s0,8(sp)
    8000732c:	0141                	addi	sp,sp,16
    8000732e:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
