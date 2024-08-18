
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	13013103          	ld	sp,304(sp) # 8000b130 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	399050ef          	jal	80005bae <start>

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
    80000030:	00035797          	auipc	a5,0x35
    80000034:	21078793          	addi	a5,a5,528 # 80035240 <end>
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
    80000050:	0000c917          	auipc	s2,0xc
    80000054:	fe090913          	addi	s2,s2,-32 # 8000c030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	59c080e7          	jalr	1436(ra) # 800065f6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	63c080e7          	jalr	1596(ra) # 800066aa <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ff2080e7          	jalr	-14(ra) # 8000607c <panic>

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
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000c517          	auipc	a0,0xc
    800000f2:	f4250513          	addi	a0,a0,-190 # 8000c030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	470080e7          	jalr	1136(ra) # 80006566 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00035517          	auipc	a0,0x35
    80000106:	13e50513          	addi	a0,a0,318 # 80035240 <end>
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
    80000124:	0000c497          	auipc	s1,0xc
    80000128:	f0c48493          	addi	s1,s1,-244 # 8000c030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	4c8080e7          	jalr	1224(ra) # 800065f6 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000c517          	auipc	a0,0xc
    80000140:	ef450513          	addi	a0,a0,-268 # 8000c030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	564080e7          	jalr	1380(ra) # 800066aa <release>

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
    80000168:	0000c517          	auipc	a0,0xc
    8000016c:	ec850513          	addi	a0,a0,-312 # 8000c030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	53a080e7          	jalr	1338(ra) # 800066aa <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffc9dc1>
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
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	b16080e7          	jalr	-1258(ra) # 80000e36 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000c717          	auipc	a4,0xc
    8000032c:	cd870713          	addi	a4,a4,-808 # 8000c000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	afa080e7          	jalr	-1286(ra) # 80000e36 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	d78080e7          	jalr	-648(ra) # 800060c6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	7fe080e7          	jalr	2046(ra) # 80001b5c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	1fe080e7          	jalr	510(ra) # 80005564 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	042080e7          	jalr	66(ra) # 800013b0 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	c16080e7          	jalr	-1002(ra) # 80005f8c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	f50080e7          	jalr	-176(ra) # 800062ce <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	d38080e7          	jalr	-712(ra) # 800060c6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	d28080e7          	jalr	-728(ra) # 800060c6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	d18080e7          	jalr	-744(ra) # 800060c6 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	9aa080e7          	jalr	-1622(ra) # 80000d78 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	75e080e7          	jalr	1886(ra) # 80001b34 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	77e080e7          	jalr	1918(ra) # 80001b5c <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	164080e7          	jalr	356(ra) # 8000554a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	176080e7          	jalr	374(ra) # 80005564 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	002080e7          	jalr	2(ra) # 800023f8 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	68e080e7          	jalr	1678(ra) # 80002a8c <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	632080e7          	jalr	1586(ra) # 80003a38 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	276080e7          	jalr	630(ra) # 80005684 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d24080e7          	jalr	-732(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000c717          	auipc	a4,0xc
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 8000c000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	0000c797          	auipc	a5,0xc
    80000438:	bd47b783          	ld	a5,-1068(a5) # 8000c008 <kernel_pagetable>
    8000043c:	83b1                	srli	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	slli	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
  sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	addi	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	addi	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	addi	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	bfc080e7          	jalr	-1028(ra) # 8000607c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srli	a5,s1,0xc
    800004a8:	07aa                	slli	a5,a5,0xa
    800004aa:	0017e793          	ori	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffc9db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	andi	s2,s2,511
    800004c0:	090e                	slli	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	andi	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srli	s1,s1,0xa
    800004d0:	04b2                	slli	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srli	a0,s3,0xc
    800004d8:	1ff57513          	andi	a0,a0,511
    800004dc:	050e                	slli	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	addi	sp,sp,64
    800004f2:	8082                	ret
        return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srli	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	andi	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret
  pa = PTE2PA(*pte);
    8000052e:	83a9                	srli	a5,a5,0xa
    80000530:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	addi	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	addi	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	andi	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srli	s1,s1,0xc
    8000058a:	04aa                	slli	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	ori	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	ad6080e7          	jalr	-1322(ra) # 8000607c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	ac6080e7          	jalr	-1338(ra) # 8000607c <panic>
      return -1;
    800005be:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	addi	sp,sp,80
    800005d4:	8082                	ret
  return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	addi	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	addi	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	addi	sp,sp,16
    800005f8:	8082                	ret
    panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	addi	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00006097          	auipc	ra,0x6
    80000606:	a7a080e7          	jalr	-1414(ra) # 8000607c <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	addi	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	addi	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	addi	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	slli	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	slli	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	addi	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	slli	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
  proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	60a080e7          	jalr	1546(ra) # 80000cd4 <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	addi	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	addi	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	0000c797          	auipc	a5,0xc
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 8000c008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	addi	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000708:	03459793          	slli	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      //panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6a85                	lui	s5,0x1
    8000072a:	0935f463          	bgeu	a1,s3,800007b2 <uvmunmap+0xb2>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a0a9                	j	8000077a <uvmunmap+0x7a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	addi	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00006097          	auipc	ra,0x6
    8000074c:	934080e7          	jalr	-1740(ra) # 8000607c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00006097          	auipc	ra,0x6
    8000075c:	924080e7          	jalr	-1756(ra) # 8000607c <panic>
      panic("uvmunmap: not a leaf");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	914080e7          	jalr	-1772(ra) # 8000607c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000770:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	9956                	add	s2,s2,s5
    80000776:	03397d63          	bgeu	s2,s3,800007b0 <uvmunmap+0xb0>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000077a:	4601                	li	a2,0
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8552                	mv	a0,s4
    80000780:	00000097          	auipc	ra,0x0
    80000784:	cd2080e7          	jalr	-814(ra) # 80000452 <walk>
    80000788:	84aa                	mv	s1,a0
    8000078a:	d179                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000078c:	611c                	ld	a5,0(a0)
    8000078e:	0017f713          	andi	a4,a5,1
    80000792:	d36d                	beqz	a4,80000774 <uvmunmap+0x74>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000794:	3ff7f713          	andi	a4,a5,1023
    80000798:	fd7704e3          	beq	a4,s7,80000760 <uvmunmap+0x60>
    if(do_free){
    8000079c:	fc0b0ae3          	beqz	s6,80000770 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800007a0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007a2:	00c79513          	slli	a0,a5,0xc
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	876080e7          	jalr	-1930(ra) # 8000001c <kfree>
    800007ae:	b7c9                	j	80000770 <uvmunmap+0x70>
    800007b0:	74e2                	ld	s1,56(sp)
    800007b2:	7942                	ld	s2,48(sp)
    800007b4:	79a2                	ld	s3,40(sp)
    800007b6:	7a02                	ld	s4,32(sp)
    800007b8:	6ae2                	ld	s5,24(sp)
    800007ba:	6b42                	ld	s6,16(sp)
    800007bc:	6ba2                	ld	s7,8(sp)
  }
}
    800007be:	60a6                	ld	ra,72(sp)
    800007c0:	6406                	ld	s0,64(sp)
    800007c2:	6161                	addi	sp,sp,80
    800007c4:	8082                	ret

00000000800007c6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	94a080e7          	jalr	-1718(ra) # 8000011a <kalloc>
    800007d8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007da:	c519                	beqz	a0,800007e8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007dc:	6605                	lui	a2,0x1
    800007de:	4581                	li	a1,0
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	99a080e7          	jalr	-1638(ra) # 8000017a <memset>
  return pagetable;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret

00000000800007f4 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f4:	7179                	addi	sp,sp,-48
    800007f6:	f406                	sd	ra,40(sp)
    800007f8:	f022                	sd	s0,32(sp)
    800007fa:	ec26                	sd	s1,24(sp)
    800007fc:	e84a                	sd	s2,16(sp)
    800007fe:	e44e                	sd	s3,8(sp)
    80000800:	e052                	sd	s4,0(sp)
    80000802:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000804:	6785                	lui	a5,0x1
    80000806:	04f67863          	bgeu	a2,a5,80000856 <uvminit+0x62>
    8000080a:	8a2a                	mv	s4,a0
    8000080c:	89ae                	mv	s3,a1
    8000080e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	90a080e7          	jalr	-1782(ra) # 8000011a <kalloc>
    80000818:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081a:	6605                	lui	a2,0x1
    8000081c:	4581                	li	a1,0
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	95c080e7          	jalr	-1700(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000826:	4779                	li	a4,30
    80000828:	86ca                	mv	a3,s2
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	8552                	mv	a0,s4
    80000830:	00000097          	auipc	ra,0x0
    80000834:	d0a080e7          	jalr	-758(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000838:	8626                	mv	a2,s1
    8000083a:	85ce                	mv	a1,s3
    8000083c:	854a                	mv	a0,s2
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	998080e7          	jalr	-1640(ra) # 800001d6 <memmove>
}
    80000846:	70a2                	ld	ra,40(sp)
    80000848:	7402                	ld	s0,32(sp)
    8000084a:	64e2                	ld	s1,24(sp)
    8000084c:	6942                	ld	s2,16(sp)
    8000084e:	69a2                	ld	s3,8(sp)
    80000850:	6a02                	ld	s4,0(sp)
    80000852:	6145                	addi	sp,sp,48
    80000854:	8082                	ret
    panic("inituvm: more than a page");
    80000856:	00008517          	auipc	a0,0x8
    8000085a:	86a50513          	addi	a0,a0,-1942 # 800080c0 <etext+0xc0>
    8000085e:	00006097          	auipc	ra,0x6
    80000862:	81e080e7          	jalr	-2018(ra) # 8000607c <panic>

0000000080000866 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000866:	1101                	addi	sp,sp,-32
    80000868:	ec06                	sd	ra,24(sp)
    8000086a:	e822                	sd	s0,16(sp)
    8000086c:	e426                	sd	s1,8(sp)
    8000086e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000870:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000872:	00b67d63          	bgeu	a2,a1,8000088c <uvmdealloc+0x26>
    80000876:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000878:	6785                	lui	a5,0x1
    8000087a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000087c:	00f60733          	add	a4,a2,a5
    80000880:	76fd                	lui	a3,0xfffff
    80000882:	8f75                	and	a4,a4,a3
    80000884:	97ae                	add	a5,a5,a1
    80000886:	8ff5                	and	a5,a5,a3
    80000888:	00f76863          	bltu	a4,a5,80000898 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088c:	8526                	mv	a0,s1
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000898:	8f99                	sub	a5,a5,a4
    8000089a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089c:	4685                	li	a3,1
    8000089e:	0007861b          	sext.w	a2,a5
    800008a2:	85ba                	mv	a1,a4
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	e5c080e7          	jalr	-420(ra) # 80000700 <uvmunmap>
    800008ac:	b7c5                	j	8000088c <uvmdealloc+0x26>

00000000800008ae <uvmalloc>:
  if(newsz < oldsz)
    800008ae:	0ab66563          	bltu	a2,a1,80000958 <uvmalloc+0xaa>
{
    800008b2:	7139                	addi	sp,sp,-64
    800008b4:	fc06                	sd	ra,56(sp)
    800008b6:	f822                	sd	s0,48(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	0080                	addi	s0,sp,64
    800008c0:	8aaa                	mv	s5,a0
    800008c2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c4:	6785                	lui	a5,0x1
    800008c6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c8:	95be                	add	a1,a1,a5
    800008ca:	77fd                	lui	a5,0xfffff
    800008cc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d0:	08c9f663          	bgeu	s3,a2,8000095c <uvmalloc+0xae>
    800008d4:	f426                	sd	s1,40(sp)
    800008d6:	f04a                	sd	s2,32(sp)
    800008d8:	894e                	mv	s2,s3
    mem = kalloc();
    800008da:	00000097          	auipc	ra,0x0
    800008de:	840080e7          	jalr	-1984(ra) # 8000011a <kalloc>
    800008e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e4:	c90d                	beqz	a0,80000916 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008e6:	6605                	lui	a2,0x1
    800008e8:	4581                	li	a1,0
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	890080e7          	jalr	-1904(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f2:	4779                	li	a4,30
    800008f4:	86a6                	mv	a3,s1
    800008f6:	6605                	lui	a2,0x1
    800008f8:	85ca                	mv	a1,s2
    800008fa:	8556                	mv	a0,s5
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	c3e080e7          	jalr	-962(ra) # 8000053a <mappages>
    80000904:	e915                	bnez	a0,80000938 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	6785                	lui	a5,0x1
    80000908:	993e                	add	s2,s2,a5
    8000090a:	fd4968e3          	bltu	s2,s4,800008da <uvmalloc+0x2c>
  return newsz;
    8000090e:	8552                	mv	a0,s4
    80000910:	74a2                	ld	s1,40(sp)
    80000912:	7902                	ld	s2,32(sp)
    80000914:	a819                	j	8000092a <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4a080e7          	jalr	-182(ra) # 80000866 <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
    80000926:	74a2                	ld	s1,40(sp)
    80000928:	7902                	ld	s2,32(sp)
}
    8000092a:	70e2                	ld	ra,56(sp)
    8000092c:	7442                	ld	s0,48(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f1e080e7          	jalr	-226(ra) # 80000866 <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	74a2                	ld	s1,40(sp)
    80000954:	7902                	ld	s2,32(sp)
    80000956:	bfd1                	j	8000092a <uvmalloc+0x7c>
    return oldsz;
    80000958:	852e                	mv	a0,a1
}
    8000095a:	8082                	ret
  return newsz;
    8000095c:	8532                	mv	a0,a2
    8000095e:	b7f1                	j	8000092a <uvmalloc+0x7c>

0000000080000960 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000960:	7179                	addi	sp,sp,-48
    80000962:	f406                	sd	ra,40(sp)
    80000964:	f022                	sd	s0,32(sp)
    80000966:	ec26                	sd	s1,24(sp)
    80000968:	e84a                	sd	s2,16(sp)
    8000096a:	e44e                	sd	s3,8(sp)
    8000096c:	e052                	sd	s4,0(sp)
    8000096e:	1800                	addi	s0,sp,48
    80000970:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000972:	84aa                	mv	s1,a0
    80000974:	6905                	lui	s2,0x1
    80000976:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000978:	4985                	li	s3,1
    8000097a:	a829                	j	80000994 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097e:	00c79513          	slli	a0,a5,0xc
    80000982:	00000097          	auipc	ra,0x0
    80000986:	fde080e7          	jalr	-34(ra) # 80000960 <freewalk>
      pagetable[i] = 0;
    8000098a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098e:	04a1                	addi	s1,s1,8
    80000990:	03248163          	beq	s1,s2,800009b2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000994:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000996:	00f7f713          	andi	a4,a5,15
    8000099a:	ff3701e3          	beq	a4,s3,8000097c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099e:	8b85                	andi	a5,a5,1
    800009a0:	d7fd                	beqz	a5,8000098e <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a2:	00007517          	auipc	a0,0x7
    800009a6:	73e50513          	addi	a0,a0,1854 # 800080e0 <etext+0xe0>
    800009aa:	00005097          	auipc	ra,0x5
    800009ae:	6d2080e7          	jalr	1746(ra) # 8000607c <panic>
    }
  }
  kfree((void*)pagetable);
    800009b2:	8552                	mv	a0,s4
    800009b4:	fffff097          	auipc	ra,0xfffff
    800009b8:	668080e7          	jalr	1640(ra) # 8000001c <kfree>
}
    800009bc:	70a2                	ld	ra,40(sp)
    800009be:	7402                	ld	s0,32(sp)
    800009c0:	64e2                	ld	s1,24(sp)
    800009c2:	6942                	ld	s2,16(sp)
    800009c4:	69a2                	ld	s3,8(sp)
    800009c6:	6a02                	ld	s4,0(sp)
    800009c8:	6145                	addi	sp,sp,48
    800009ca:	8082                	ret

00000000800009cc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
    800009d6:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d8:	e999                	bnez	a1,800009ee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009da:	8526                	mv	a0,s1
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	f84080e7          	jalr	-124(ra) # 80000960 <freewalk>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	addi	sp,sp,32
    800009ec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ee:	6785                	lui	a5,0x1
    800009f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f2:	95be                	add	a1,a1,a5
    800009f4:	4685                	li	a3,1
    800009f6:	00c5d613          	srli	a2,a1,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d04080e7          	jalr	-764(ra) # 80000700 <uvmunmap>
    80000a04:	bfd9                	j	800009da <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c269                	beqz	a2,80000ac8 <uvmcopy+0xc2>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8aaa                	mv	s5,a0
    80000a20:	8b2e                	mv	s6,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4481                	li	s1,0
    80000a26:	a829                	j	80000a40 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a28:	00007517          	auipc	a0,0x7
    80000a2c:	6c850513          	addi	a0,a0,1736 # 800080f0 <etext+0xf0>
    80000a30:	00005097          	auipc	ra,0x5
    80000a34:	64c080e7          	jalr	1612(ra) # 8000607c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a38:	6785                	lui	a5,0x1
    80000a3a:	94be                	add	s1,s1,a5
    80000a3c:	0944f463          	bgeu	s1,s4,80000ac4 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a40:	4601                	li	a2,0
    80000a42:	85a6                	mv	a1,s1
    80000a44:	8556                	mv	a0,s5
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	a0c080e7          	jalr	-1524(ra) # 80000452 <walk>
    80000a4e:	dd69                	beqz	a0,80000a28 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a50:	6118                	ld	a4,0(a0)
    80000a52:	00177793          	andi	a5,a4,1
    80000a56:	d3ed                	beqz	a5,80000a38 <uvmcopy+0x32>
      continue;
      //panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a58:	00a75593          	srli	a1,a4,0xa
    80000a5c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a60:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	6b6080e7          	jalr	1718(ra) # 8000011a <kalloc>
    80000a6c:	89aa                	mv	s3,a0
    80000a6e:	c515                	beqz	a0,80000a9a <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85de                	mv	a1,s7
    80000a74:	fffff097          	auipc	ra,0xfffff
    80000a78:	762080e7          	jalr	1890(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a7c:	874a                	mv	a4,s2
    80000a7e:	86ce                	mv	a3,s3
    80000a80:	6605                	lui	a2,0x1
    80000a82:	85a6                	mv	a1,s1
    80000a84:	855a                	mv	a0,s6
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	ab4080e7          	jalr	-1356(ra) # 8000053a <mappages>
    80000a8e:	d54d                	beqz	a0,80000a38 <uvmcopy+0x32>
      kfree(mem);
    80000a90:	854e                	mv	a0,s3
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	58a080e7          	jalr	1418(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a9a:	4685                	li	a3,1
    80000a9c:	00c4d613          	srli	a2,s1,0xc
    80000aa0:	4581                	li	a1,0
    80000aa2:	855a                	mv	a0,s6
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	c5c080e7          	jalr	-932(ra) # 80000700 <uvmunmap>
  return -1;
    80000aac:	557d                	li	a0,-1
}
    80000aae:	60a6                	ld	ra,72(sp)
    80000ab0:	6406                	ld	s0,64(sp)
    80000ab2:	74e2                	ld	s1,56(sp)
    80000ab4:	7942                	ld	s2,48(sp)
    80000ab6:	79a2                	ld	s3,40(sp)
    80000ab8:	7a02                	ld	s4,32(sp)
    80000aba:	6ae2                	ld	s5,24(sp)
    80000abc:	6b42                	ld	s6,16(sp)
    80000abe:	6ba2                	ld	s7,8(sp)
    80000ac0:	6161                	addi	sp,sp,80
    80000ac2:	8082                	ret
  return 0;
    80000ac4:	4501                	li	a0,0
    80000ac6:	b7e5                	j	80000aae <uvmcopy+0xa8>
    80000ac8:	4501                	li	a0,0
}
    80000aca:	8082                	ret

0000000080000acc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000acc:	1141                	addi	sp,sp,-16
    80000ace:	e406                	sd	ra,8(sp)
    80000ad0:	e022                	sd	s0,0(sp)
    80000ad2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad4:	4601                	li	a2,0
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	97c080e7          	jalr	-1668(ra) # 80000452 <walk>
  if(pte == 0)
    80000ade:	c901                	beqz	a0,80000aee <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae0:	611c                	ld	a5,0(a0)
    80000ae2:	9bbd                	andi	a5,a5,-17
    80000ae4:	e11c                	sd	a5,0(a0)
}
    80000ae6:	60a2                	ld	ra,8(sp)
    80000ae8:	6402                	ld	s0,0(sp)
    80000aea:	0141                	addi	sp,sp,16
    80000aec:	8082                	ret
    panic("uvmclear");
    80000aee:	00007517          	auipc	a0,0x7
    80000af2:	62250513          	addi	a0,a0,1570 # 80008110 <etext+0x110>
    80000af6:	00005097          	auipc	ra,0x5
    80000afa:	586080e7          	jalr	1414(ra) # 8000607c <panic>

0000000080000afe <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000afe:	c6bd                	beqz	a3,80000b6c <copyout+0x6e>
{
    80000b00:	715d                	addi	sp,sp,-80
    80000b02:	e486                	sd	ra,72(sp)
    80000b04:	e0a2                	sd	s0,64(sp)
    80000b06:	fc26                	sd	s1,56(sp)
    80000b08:	f84a                	sd	s2,48(sp)
    80000b0a:	f44e                	sd	s3,40(sp)
    80000b0c:	f052                	sd	s4,32(sp)
    80000b0e:	ec56                	sd	s5,24(sp)
    80000b10:	e85a                	sd	s6,16(sp)
    80000b12:	e45e                	sd	s7,8(sp)
    80000b14:	e062                	sd	s8,0(sp)
    80000b16:	0880                	addi	s0,sp,80
    80000b18:	8b2a                	mv	s6,a0
    80000b1a:	8c2e                	mv	s8,a1
    80000b1c:	8a32                	mv	s4,a2
    80000b1e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b20:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b22:	6a85                	lui	s5,0x1
    80000b24:	a015                	j	80000b48 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b26:	9562                	add	a0,a0,s8
    80000b28:	0004861b          	sext.w	a2,s1
    80000b2c:	85d2                	mv	a1,s4
    80000b2e:	41250533          	sub	a0,a0,s2
    80000b32:	fffff097          	auipc	ra,0xfffff
    80000b36:	6a4080e7          	jalr	1700(ra) # 800001d6 <memmove>

    len -= n;
    80000b3a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b3e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b40:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b44:	02098263          	beqz	s3,80000b68 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b48:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b4c:	85ca                	mv	a1,s2
    80000b4e:	855a                	mv	a0,s6
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	9a8080e7          	jalr	-1624(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b58:	cd01                	beqz	a0,80000b70 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5a:	418904b3          	sub	s1,s2,s8
    80000b5e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b60:	fc99f3e3          	bgeu	s3,s1,80000b26 <copyout+0x28>
    80000b64:	84ce                	mv	s1,s3
    80000b66:	b7c1                	j	80000b26 <copyout+0x28>
  }
  return 0;
    80000b68:	4501                	li	a0,0
    80000b6a:	a021                	j	80000b72 <copyout+0x74>
    80000b6c:	4501                	li	a0,0
}
    80000b6e:	8082                	ret
      return -1;
    80000b70:	557d                	li	a0,-1
}
    80000b72:	60a6                	ld	ra,72(sp)
    80000b74:	6406                	ld	s0,64(sp)
    80000b76:	74e2                	ld	s1,56(sp)
    80000b78:	7942                	ld	s2,48(sp)
    80000b7a:	79a2                	ld	s3,40(sp)
    80000b7c:	7a02                	ld	s4,32(sp)
    80000b7e:	6ae2                	ld	s5,24(sp)
    80000b80:	6b42                	ld	s6,16(sp)
    80000b82:	6ba2                	ld	s7,8(sp)
    80000b84:	6c02                	ld	s8,0(sp)
    80000b86:	6161                	addi	sp,sp,80
    80000b88:	8082                	ret

0000000080000b8a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8a:	caa5                	beqz	a3,80000bfa <copyin+0x70>
{
    80000b8c:	715d                	addi	sp,sp,-80
    80000b8e:	e486                	sd	ra,72(sp)
    80000b90:	e0a2                	sd	s0,64(sp)
    80000b92:	fc26                	sd	s1,56(sp)
    80000b94:	f84a                	sd	s2,48(sp)
    80000b96:	f44e                	sd	s3,40(sp)
    80000b98:	f052                	sd	s4,32(sp)
    80000b9a:	ec56                	sd	s5,24(sp)
    80000b9c:	e85a                	sd	s6,16(sp)
    80000b9e:	e45e                	sd	s7,8(sp)
    80000ba0:	e062                	sd	s8,0(sp)
    80000ba2:	0880                	addi	s0,sp,80
    80000ba4:	8b2a                	mv	s6,a0
    80000ba6:	8a2e                	mv	s4,a1
    80000ba8:	8c32                	mv	s8,a2
    80000baa:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bac:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bae:	6a85                	lui	s5,0x1
    80000bb0:	a01d                	j	80000bd6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb2:	018505b3          	add	a1,a0,s8
    80000bb6:	0004861b          	sext.w	a2,s1
    80000bba:	412585b3          	sub	a1,a1,s2
    80000bbe:	8552                	mv	a0,s4
    80000bc0:	fffff097          	auipc	ra,0xfffff
    80000bc4:	616080e7          	jalr	1558(ra) # 800001d6 <memmove>

    len -= n;
    80000bc8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bcc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bce:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd2:	02098263          	beqz	s3,80000bf6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bd6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bda:	85ca                	mv	a1,s2
    80000bdc:	855a                	mv	a0,s6
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	91a080e7          	jalr	-1766(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000be6:	cd01                	beqz	a0,80000bfe <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000be8:	418904b3          	sub	s1,s2,s8
    80000bec:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bee:	fc99f2e3          	bgeu	s3,s1,80000bb2 <copyin+0x28>
    80000bf2:	84ce                	mv	s1,s3
    80000bf4:	bf7d                	j	80000bb2 <copyin+0x28>
  }
  return 0;
    80000bf6:	4501                	li	a0,0
    80000bf8:	a021                	j	80000c00 <copyin+0x76>
    80000bfa:	4501                	li	a0,0
}
    80000bfc:	8082                	ret
      return -1;
    80000bfe:	557d                	li	a0,-1
}
    80000c00:	60a6                	ld	ra,72(sp)
    80000c02:	6406                	ld	s0,64(sp)
    80000c04:	74e2                	ld	s1,56(sp)
    80000c06:	7942                	ld	s2,48(sp)
    80000c08:	79a2                	ld	s3,40(sp)
    80000c0a:	7a02                	ld	s4,32(sp)
    80000c0c:	6ae2                	ld	s5,24(sp)
    80000c0e:	6b42                	ld	s6,16(sp)
    80000c10:	6ba2                	ld	s7,8(sp)
    80000c12:	6c02                	ld	s8,0(sp)
    80000c14:	6161                	addi	sp,sp,80
    80000c16:	8082                	ret

0000000080000c18 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c18:	cacd                	beqz	a3,80000cca <copyinstr+0xb2>
{
    80000c1a:	715d                	addi	sp,sp,-80
    80000c1c:	e486                	sd	ra,72(sp)
    80000c1e:	e0a2                	sd	s0,64(sp)
    80000c20:	fc26                	sd	s1,56(sp)
    80000c22:	f84a                	sd	s2,48(sp)
    80000c24:	f44e                	sd	s3,40(sp)
    80000c26:	f052                	sd	s4,32(sp)
    80000c28:	ec56                	sd	s5,24(sp)
    80000c2a:	e85a                	sd	s6,16(sp)
    80000c2c:	e45e                	sd	s7,8(sp)
    80000c2e:	0880                	addi	s0,sp,80
    80000c30:	8a2a                	mv	s4,a0
    80000c32:	8b2e                	mv	s6,a1
    80000c34:	8bb2                	mv	s7,a2
    80000c36:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c38:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3a:	6985                	lui	s3,0x1
    80000c3c:	a825                	j	80000c74 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c3e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c42:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c44:	37fd                	addiw	a5,a5,-1
    80000c46:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c4a:	60a6                	ld	ra,72(sp)
    80000c4c:	6406                	ld	s0,64(sp)
    80000c4e:	74e2                	ld	s1,56(sp)
    80000c50:	7942                	ld	s2,48(sp)
    80000c52:	79a2                	ld	s3,40(sp)
    80000c54:	7a02                	ld	s4,32(sp)
    80000c56:	6ae2                	ld	s5,24(sp)
    80000c58:	6b42                	ld	s6,16(sp)
    80000c5a:	6ba2                	ld	s7,8(sp)
    80000c5c:	6161                	addi	sp,sp,80
    80000c5e:	8082                	ret
    80000c60:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c64:	9742                	add	a4,a4,a6
      --max;
    80000c66:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c6a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c6e:	04e58663          	beq	a1,a4,80000cba <copyinstr+0xa2>
{
    80000c72:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c74:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c78:	85a6                	mv	a1,s1
    80000c7a:	8552                	mv	a0,s4
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	87c080e7          	jalr	-1924(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c84:	cd0d                	beqz	a0,80000cbe <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000c86:	417486b3          	sub	a3,s1,s7
    80000c8a:	96ce                	add	a3,a3,s3
    if(n > max)
    80000c8c:	00d97363          	bgeu	s2,a3,80000c92 <copyinstr+0x7a>
    80000c90:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000c92:	955e                	add	a0,a0,s7
    80000c94:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000c96:	c695                	beqz	a3,80000cc2 <copyinstr+0xaa>
    80000c98:	87da                	mv	a5,s6
    80000c9a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000c9c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca0:	96da                	add	a3,a3,s6
    80000ca2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffc9dc0>
    80000cac:	db49                	beqz	a4,80000c3e <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	fed797e3          	bne	a5,a3,80000ca2 <copyinstr+0x8a>
    80000cb8:	b765                	j	80000c60 <copyinstr+0x48>
    80000cba:	4781                	li	a5,0
    80000cbc:	b761                	j	80000c44 <copyinstr+0x2c>
      return -1;
    80000cbe:	557d                	li	a0,-1
    80000cc0:	b769                	j	80000c4a <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cc2:	6b85                	lui	s7,0x1
    80000cc4:	9ba6                	add	s7,s7,s1
    80000cc6:	87da                	mv	a5,s6
    80000cc8:	b76d                	j	80000c72 <copyinstr+0x5a>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	37fd                	addiw	a5,a5,-1
    80000cce:	0007851b          	sext.w	a0,a5
}
    80000cd2:	8082                	ret

0000000080000cd4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd4:	7139                	addi	sp,sp,-64
    80000cd6:	fc06                	sd	ra,56(sp)
    80000cd8:	f822                	sd	s0,48(sp)
    80000cda:	f426                	sd	s1,40(sp)
    80000cdc:	f04a                	sd	s2,32(sp)
    80000cde:	ec4e                	sd	s3,24(sp)
    80000ce0:	e852                	sd	s4,16(sp)
    80000ce2:	e456                	sd	s5,8(sp)
    80000ce4:	e05a                	sd	s6,0(sp)
    80000ce6:	0080                	addi	s0,sp,64
    80000ce8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cea:	0000b497          	auipc	s1,0xb
    80000cee:	79648493          	addi	s1,s1,1942 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf2:	8b26                	mv	s6,s1
    80000cf4:	00e12937          	lui	s2,0xe12
    80000cf8:	27f90913          	addi	s2,s2,639 # e1227f <_entry-0x7f1edd81>
    80000cfc:	0936                	slli	s2,s2,0xd
    80000cfe:	2f390913          	addi	s2,s2,755
    80000d02:	0932                	slli	s2,s2,0xc
    80000d04:	4a790913          	addi	s2,s2,1191
    80000d08:	093a                	slli	s2,s2,0xe
    80000d0a:	24590913          	addi	s2,s2,581
    80000d0e:	040009b7          	lui	s3,0x4000
    80000d12:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d14:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d16:	0001da97          	auipc	s5,0x1d
    80000d1a:	16aa8a93          	addi	s5,s5,362 # 8001de80 <tickslock>
    char *pa = kalloc();
    80000d1e:	fffff097          	auipc	ra,0xfffff
    80000d22:	3fc080e7          	jalr	1020(ra) # 8000011a <kalloc>
    80000d26:	862a                	mv	a2,a0
    if(pa == 0)
    80000d28:	c121                	beqz	a0,80000d68 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d2a:	416485b3          	sub	a1,s1,s6
    80000d2e:	858d                	srai	a1,a1,0x3
    80000d30:	032585b3          	mul	a1,a1,s2
    80000d34:	2585                	addiw	a1,a1,1
    80000d36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3a:	4719                	li	a4,6
    80000d3c:	6685                	lui	a3,0x1
    80000d3e:	40b985b3          	sub	a1,s3,a1
    80000d42:	8552                	mv	a0,s4
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	896080e7          	jalr	-1898(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	46848493          	addi	s1,s1,1128
    80000d50:	fd5497e3          	bne	s1,s5,80000d1e <proc_mapstacks+0x4a>
  }
}
    80000d54:	70e2                	ld	ra,56(sp)
    80000d56:	7442                	ld	s0,48(sp)
    80000d58:	74a2                	ld	s1,40(sp)
    80000d5a:	7902                	ld	s2,32(sp)
    80000d5c:	69e2                	ld	s3,24(sp)
    80000d5e:	6a42                	ld	s4,16(sp)
    80000d60:	6aa2                	ld	s5,8(sp)
    80000d62:	6b02                	ld	s6,0(sp)
    80000d64:	6121                	addi	sp,sp,64
    80000d66:	8082                	ret
      panic("kalloc");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	3b850513          	addi	a0,a0,952 # 80008120 <etext+0x120>
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	30c080e7          	jalr	780(ra) # 8000607c <panic>

0000000080000d78 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d78:	7139                	addi	sp,sp,-64
    80000d7a:	fc06                	sd	ra,56(sp)
    80000d7c:	f822                	sd	s0,48(sp)
    80000d7e:	f426                	sd	s1,40(sp)
    80000d80:	f04a                	sd	s2,32(sp)
    80000d82:	ec4e                	sd	s3,24(sp)
    80000d84:	e852                	sd	s4,16(sp)
    80000d86:	e456                	sd	s5,8(sp)
    80000d88:	e05a                	sd	s6,0(sp)
    80000d8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8c:	00007597          	auipc	a1,0x7
    80000d90:	39c58593          	addi	a1,a1,924 # 80008128 <etext+0x128>
    80000d94:	0000b517          	auipc	a0,0xb
    80000d98:	2bc50513          	addi	a0,a0,700 # 8000c050 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	7ca080e7          	jalr	1994(ra) # 80006566 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	38c58593          	addi	a1,a1,908 # 80008130 <etext+0x130>
    80000dac:	0000b517          	auipc	a0,0xb
    80000db0:	2bc50513          	addi	a0,a0,700 # 8000c068 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	7b2080e7          	jalr	1970(ra) # 80006566 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	0000b497          	auipc	s1,0xb
    80000dc0:	6c448493          	addi	s1,s1,1732 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dc4:	00007b17          	auipc	s6,0x7
    80000dc8:	37cb0b13          	addi	s6,s6,892 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	8aa6                	mv	s5,s1
    80000dce:	00e12937          	lui	s2,0xe12
    80000dd2:	27f90913          	addi	s2,s2,639 # e1227f <_entry-0x7f1edd81>
    80000dd6:	0936                	slli	s2,s2,0xd
    80000dd8:	2f390913          	addi	s2,s2,755
    80000ddc:	0932                	slli	s2,s2,0xc
    80000dde:	4a790913          	addi	s2,s2,1191
    80000de2:	093a                	slli	s2,s2,0xe
    80000de4:	24590913          	addi	s2,s2,581
    80000de8:	040009b7          	lui	s3,0x4000
    80000dec:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000dee:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df0:	0001da17          	auipc	s4,0x1d
    80000df4:	090a0a13          	addi	s4,s4,144 # 8001de80 <tickslock>
      initlock(&p->lock, "proc");
    80000df8:	85da                	mv	a1,s6
    80000dfa:	8526                	mv	a0,s1
    80000dfc:	00005097          	auipc	ra,0x5
    80000e00:	76a080e7          	jalr	1898(ra) # 80006566 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e04:	415487b3          	sub	a5,s1,s5
    80000e08:	878d                	srai	a5,a5,0x3
    80000e0a:	032787b3          	mul	a5,a5,s2
    80000e0e:	2785                	addiw	a5,a5,1
    80000e10:	00d7979b          	slliw	a5,a5,0xd
    80000e14:	40f987b3          	sub	a5,s3,a5
    80000e18:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	46848493          	addi	s1,s1,1128
    80000e1e:	fd449de3          	bne	s1,s4,80000df8 <procinit+0x80>
  }
}
    80000e22:	70e2                	ld	ra,56(sp)
    80000e24:	7442                	ld	s0,48(sp)
    80000e26:	74a2                	ld	s1,40(sp)
    80000e28:	7902                	ld	s2,32(sp)
    80000e2a:	69e2                	ld	s3,24(sp)
    80000e2c:	6a42                	ld	s4,16(sp)
    80000e2e:	6aa2                	ld	s5,8(sp)
    80000e30:	6b02                	ld	s6,0(sp)
    80000e32:	6121                	addi	sp,sp,64
    80000e34:	8082                	ret

0000000080000e36 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e3c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e3e:	2501                	sext.w	a0,a0
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
    80000e4c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e4e:	2781                	sext.w	a5,a5
    80000e50:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e52:	0000b517          	auipc	a0,0xb
    80000e56:	22e50513          	addi	a0,a0,558 # 8000c080 <cpus>
    80000e5a:	953e                	add	a0,a0,a5
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e62:	1101                	addi	sp,sp,-32
    80000e64:	ec06                	sd	ra,24(sp)
    80000e66:	e822                	sd	s0,16(sp)
    80000e68:	e426                	sd	s1,8(sp)
    80000e6a:	1000                	addi	s0,sp,32
  push_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	73e080e7          	jalr	1854(ra) # 800065aa <push_off>
    80000e74:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	0000b717          	auipc	a4,0xb
    80000e7e:	1d670713          	addi	a4,a4,470 # 8000c050 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	7c4080e7          	jalr	1988(ra) # 8000664a <pop_off>
  return p;
}
    80000e8e:	8526                	mv	a0,s1
    80000e90:	60e2                	ld	ra,24(sp)
    80000e92:	6442                	ld	s0,16(sp)
    80000e94:	64a2                	ld	s1,8(sp)
    80000e96:	6105                	addi	sp,sp,32
    80000e98:	8082                	ret

0000000080000e9a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e406                	sd	ra,8(sp)
    80000e9e:	e022                	sd	s0,0(sp)
    80000ea0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ea2:	00000097          	auipc	ra,0x0
    80000ea6:	fc0080e7          	jalr	-64(ra) # 80000e62 <myproc>
    80000eaa:	00006097          	auipc	ra,0x6
    80000eae:	800080e7          	jalr	-2048(ra) # 800066aa <release>

  if (first) {
    80000eb2:	0000a797          	auipc	a5,0xa
    80000eb6:	22e7a783          	lw	a5,558(a5) # 8000b0e0 <first.1>
    80000eba:	eb89                	bnez	a5,80000ecc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ebc:	00001097          	auipc	ra,0x1
    80000ec0:	cb8080e7          	jalr	-840(ra) # 80001b74 <usertrapret>
}
    80000ec4:	60a2                	ld	ra,8(sp)
    80000ec6:	6402                	ld	s0,0(sp)
    80000ec8:	0141                	addi	sp,sp,16
    80000eca:	8082                	ret
    first = 0;
    80000ecc:	0000a797          	auipc	a5,0xa
    80000ed0:	2007aa23          	sw	zero,532(a5) # 8000b0e0 <first.1>
    fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	b36080e7          	jalr	-1226(ra) # 80002a0c <fsinit>
    80000ede:	bff9                	j	80000ebc <forkret+0x22>

0000000080000ee0 <allocpid>:
allocpid() {
    80000ee0:	1101                	addi	sp,sp,-32
    80000ee2:	ec06                	sd	ra,24(sp)
    80000ee4:	e822                	sd	s0,16(sp)
    80000ee6:	e426                	sd	s1,8(sp)
    80000ee8:	e04a                	sd	s2,0(sp)
    80000eea:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eec:	0000b917          	auipc	s2,0xb
    80000ef0:	16490913          	addi	s2,s2,356 # 8000c050 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	700080e7          	jalr	1792(ra) # 800065f6 <acquire>
  pid = nextpid;
    80000efe:	0000a797          	auipc	a5,0xa
    80000f02:	1e678793          	addi	a5,a5,486 # 8000b0e4 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	79a080e7          	jalr	1946(ra) # 800066aa <release>
}
    80000f18:	8526                	mv	a0,s1
    80000f1a:	60e2                	ld	ra,24(sp)
    80000f1c:	6442                	ld	s0,16(sp)
    80000f1e:	64a2                	ld	s1,8(sp)
    80000f20:	6902                	ld	s2,0(sp)
    80000f22:	6105                	addi	sp,sp,32
    80000f24:	8082                	ret

0000000080000f26 <proc_pagetable>:
{
    80000f26:	1101                	addi	sp,sp,-32
    80000f28:	ec06                	sd	ra,24(sp)
    80000f2a:	e822                	sd	s0,16(sp)
    80000f2c:	e426                	sd	s1,8(sp)
    80000f2e:	e04a                	sd	s2,0(sp)
    80000f30:	1000                	addi	s0,sp,32
    80000f32:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	892080e7          	jalr	-1902(ra) # 800007c6 <uvmcreate>
    80000f3c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f3e:	c121                	beqz	a0,80000f7e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f40:	4729                	li	a4,10
    80000f42:	00006697          	auipc	a3,0x6
    80000f46:	0be68693          	addi	a3,a3,190 # 80007000 <_trampoline>
    80000f4a:	6605                	lui	a2,0x1
    80000f4c:	040005b7          	lui	a1,0x4000
    80000f50:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f52:	05b2                	slli	a1,a1,0xc
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5e6080e7          	jalr	1510(ra) # 8000053a <mappages>
    80000f5c:	02054863          	bltz	a0,80000f8c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f60:	4719                	li	a4,6
    80000f62:	05893683          	ld	a3,88(s2)
    80000f66:	6605                	lui	a2,0x1
    80000f68:	020005b7          	lui	a1,0x2000
    80000f6c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f6e:	05b6                	slli	a1,a1,0xd
    80000f70:	8526                	mv	a0,s1
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	5c8080e7          	jalr	1480(ra) # 8000053a <mappages>
    80000f7a:	02054163          	bltz	a0,80000f9c <proc_pagetable+0x76>
}
    80000f7e:	8526                	mv	a0,s1
    80000f80:	60e2                	ld	ra,24(sp)
    80000f82:	6442                	ld	s0,16(sp)
    80000f84:	64a2                	ld	s1,8(sp)
    80000f86:	6902                	ld	s2,0(sp)
    80000f88:	6105                	addi	sp,sp,32
    80000f8a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f8c:	4581                	li	a1,0
    80000f8e:	8526                	mv	a0,s1
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	a3c080e7          	jalr	-1476(ra) # 800009cc <uvmfree>
    return 0;
    80000f98:	4481                	li	s1,0
    80000f9a:	b7d5                	j	80000f7e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9c:	4681                	li	a3,0
    80000f9e:	4605                	li	a2,1
    80000fa0:	040005b7          	lui	a1,0x4000
    80000fa4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fa6:	05b2                	slli	a1,a1,0xc
    80000fa8:	8526                	mv	a0,s1
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	756080e7          	jalr	1878(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fb2:	4581                	li	a1,0
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	a16080e7          	jalr	-1514(ra) # 800009cc <uvmfree>
    return 0;
    80000fbe:	4481                	li	s1,0
    80000fc0:	bf7d                	j	80000f7e <proc_pagetable+0x58>

0000000080000fc2 <proc_freepagetable>:
{
    80000fc2:	1101                	addi	sp,sp,-32
    80000fc4:	ec06                	sd	ra,24(sp)
    80000fc6:	e822                	sd	s0,16(sp)
    80000fc8:	e426                	sd	s1,8(sp)
    80000fca:	e04a                	sd	s2,0(sp)
    80000fcc:	1000                	addi	s0,sp,32
    80000fce:	84aa                	mv	s1,a0
    80000fd0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd2:	4681                	li	a3,0
    80000fd4:	4605                	li	a2,1
    80000fd6:	040005b7          	lui	a1,0x4000
    80000fda:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fdc:	05b2                	slli	a1,a1,0xc
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	722080e7          	jalr	1826(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fe6:	4681                	li	a3,0
    80000fe8:	4605                	li	a2,1
    80000fea:	020005b7          	lui	a1,0x2000
    80000fee:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ff0:	05b6                	slli	a1,a1,0xd
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	fffff097          	auipc	ra,0xfffff
    80000ff8:	70c080e7          	jalr	1804(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ffc:	85ca                	mv	a1,s2
    80000ffe:	8526                	mv	a0,s1
    80001000:	00000097          	auipc	ra,0x0
    80001004:	9cc080e7          	jalr	-1588(ra) # 800009cc <uvmfree>
}
    80001008:	60e2                	ld	ra,24(sp)
    8000100a:	6442                	ld	s0,16(sp)
    8000100c:	64a2                	ld	s1,8(sp)
    8000100e:	6902                	ld	s2,0(sp)
    80001010:	6105                	addi	sp,sp,32
    80001012:	8082                	ret

0000000080001014 <freeproc>:
{
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	1000                	addi	s0,sp,32
    8000101e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001020:	6d28                	ld	a0,88(a0)
    80001022:	c509                	beqz	a0,8000102c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	ff8080e7          	jalr	-8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000102c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001030:	68a8                	ld	a0,80(s1)
    80001032:	c511                	beqz	a0,8000103e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001034:	64ac                	ld	a1,72(s1)
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	f8c080e7          	jalr	-116(ra) # 80000fc2 <proc_freepagetable>
  p->pagetable = 0;
    8000103e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001042:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001046:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000104a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000104e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001052:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001056:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000105a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000105e:	0004ac23          	sw	zero,24(s1)
}
    80001062:	60e2                	ld	ra,24(sp)
    80001064:	6442                	ld	s0,16(sp)
    80001066:	64a2                	ld	s1,8(sp)
    80001068:	6105                	addi	sp,sp,32
    8000106a:	8082                	ret

000000008000106c <allocproc>:
{
    8000106c:	1101                	addi	sp,sp,-32
    8000106e:	ec06                	sd	ra,24(sp)
    80001070:	e822                	sd	s0,16(sp)
    80001072:	e426                	sd	s1,8(sp)
    80001074:	e04a                	sd	s2,0(sp)
    80001076:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001078:	0000b497          	auipc	s1,0xb
    8000107c:	40848493          	addi	s1,s1,1032 # 8000c480 <proc>
    80001080:	0001d917          	auipc	s2,0x1d
    80001084:	e0090913          	addi	s2,s2,-512 # 8001de80 <tickslock>
    acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	56c080e7          	jalr	1388(ra) # 800065f6 <acquire>
    if(p->state == UNUSED) {
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
      release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	612080e7          	jalr	1554(ra) # 800066aa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a0:	46848493          	addi	s1,s1,1128
    800010a4:	ff2492e3          	bne	s1,s2,80001088 <allocproc+0x1c>
  return 0;
    800010a8:	4481                	li	s1,0
    800010aa:	a889                	j	800010fc <allocproc+0x90>
  p->pid = allocpid();
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e34080e7          	jalr	-460(ra) # 80000ee0 <allocpid>
    800010b4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b6:	4785                	li	a5,1
    800010b8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	060080e7          	jalr	96(ra) # 8000011a <kalloc>
    800010c2:	892a                	mv	s2,a0
    800010c4:	eca8                	sd	a0,88(s1)
    800010c6:	c131                	beqz	a0,8000110a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c8:	8526                	mv	a0,s1
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	e5c080e7          	jalr	-420(ra) # 80000f26 <proc_pagetable>
    800010d2:	892a                	mv	s2,a0
    800010d4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d6:	c531                	beqz	a0,80001122 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d8:	07000613          	li	a2,112
    800010dc:	4581                	li	a1,0
    800010de:	06048513          	addi	a0,s1,96
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	098080e7          	jalr	152(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010ea:	00000797          	auipc	a5,0x0
    800010ee:	db078793          	addi	a5,a5,-592 # 80000e9a <forkret>
    800010f2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010f4:	60bc                	ld	a5,64(s1)
    800010f6:	6705                	lui	a4,0x1
    800010f8:	97ba                	add	a5,a5,a4
    800010fa:	f4bc                	sd	a5,104(s1)
}
    800010fc:	8526                	mv	a0,s1
    800010fe:	60e2                	ld	ra,24(sp)
    80001100:	6442                	ld	s0,16(sp)
    80001102:	64a2                	ld	s1,8(sp)
    80001104:	6902                	ld	s2,0(sp)
    80001106:	6105                	addi	sp,sp,32
    80001108:	8082                	ret
    freeproc(p);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f08080e7          	jalr	-248(ra) # 80001014 <freeproc>
    release(&p->lock);
    80001114:	8526                	mv	a0,s1
    80001116:	00005097          	auipc	ra,0x5
    8000111a:	594080e7          	jalr	1428(ra) # 800066aa <release>
    return 0;
    8000111e:	84ca                	mv	s1,s2
    80001120:	bff1                	j	800010fc <allocproc+0x90>
    freeproc(p);
    80001122:	8526                	mv	a0,s1
    80001124:	00000097          	auipc	ra,0x0
    80001128:	ef0080e7          	jalr	-272(ra) # 80001014 <freeproc>
    release(&p->lock);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00005097          	auipc	ra,0x5
    80001132:	57c080e7          	jalr	1404(ra) # 800066aa <release>
    return 0;
    80001136:	84ca                	mv	s1,s2
    80001138:	b7d1                	j	800010fc <allocproc+0x90>

000000008000113a <userinit>:
{
    8000113a:	1101                	addi	sp,sp,-32
    8000113c:	ec06                	sd	ra,24(sp)
    8000113e:	e822                	sd	s0,16(sp)
    80001140:	e426                	sd	s1,8(sp)
    80001142:	1000                	addi	s0,sp,32
  p = allocproc();
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f28080e7          	jalr	-216(ra) # 8000106c <allocproc>
    8000114c:	84aa                	mv	s1,a0
  initproc = p;
    8000114e:	0000b797          	auipc	a5,0xb
    80001152:	eca7b123          	sd	a0,-318(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	0000a597          	auipc	a1,0xa
    8000115e:	f9658593          	addi	a1,a1,-106 # 8000b0f0 <initcode>
    80001162:	6928                	ld	a0,80(a0)
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	690080e7          	jalr	1680(ra) # 800007f4 <uvminit>
  p->sz = PGSIZE;
    8000116c:	6785                	lui	a5,0x1
    8000116e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001170:	6cb8                	ld	a4,88(s1)
    80001172:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001176:	6cb8                	ld	a4,88(s1)
    80001178:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000117a:	4641                	li	a2,16
    8000117c:	00007597          	auipc	a1,0x7
    80001180:	fcc58593          	addi	a1,a1,-52 # 80008148 <etext+0x148>
    80001184:	15848513          	addi	a0,s1,344
    80001188:	fffff097          	auipc	ra,0xfffff
    8000118c:	134080e7          	jalr	308(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001190:	00007517          	auipc	a0,0x7
    80001194:	fc850513          	addi	a0,a0,-56 # 80008158 <etext+0x158>
    80001198:	00002097          	auipc	ra,0x2
    8000119c:	2ba080e7          	jalr	698(ra) # 80003452 <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	500080e7          	jalr	1280(ra) # 800066aa <release>
}
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6105                	addi	sp,sp,32
    800011ba:	8082                	ret

00000000800011bc <growproc>:
{
    800011bc:	1101                	addi	sp,sp,-32
    800011be:	ec06                	sd	ra,24(sp)
    800011c0:	e822                	sd	s0,16(sp)
    800011c2:	e426                	sd	s1,8(sp)
    800011c4:	e04a                	sd	s2,0(sp)
    800011c6:	1000                	addi	s0,sp,32
    800011c8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	c98080e7          	jalr	-872(ra) # 80000e62 <myproc>
    800011d2:	892a                	mv	s2,a0
  sz = p->sz;
    800011d4:	652c                	ld	a1,72(a0)
    800011d6:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011da:	00904f63          	bgtz	s1,800011f8 <growproc+0x3c>
  } else if(n < 0){
    800011de:	0204cd63          	bltz	s1,80001218 <growproc+0x5c>
  p->sz = sz;
    800011e2:	1782                	slli	a5,a5,0x20
    800011e4:	9381                	srli	a5,a5,0x20
    800011e6:	04f93423          	sd	a5,72(s2)
  return 0;
    800011ea:	4501                	li	a0,0
}
    800011ec:	60e2                	ld	ra,24(sp)
    800011ee:	6442                	ld	s0,16(sp)
    800011f0:	64a2                	ld	s1,8(sp)
    800011f2:	6902                	ld	s2,0(sp)
    800011f4:	6105                	addi	sp,sp,32
    800011f6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011f8:	00f4863b          	addw	a2,s1,a5
    800011fc:	1602                	slli	a2,a2,0x20
    800011fe:	9201                	srli	a2,a2,0x20
    80001200:	1582                	slli	a1,a1,0x20
    80001202:	9181                	srli	a1,a1,0x20
    80001204:	6928                	ld	a0,80(a0)
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	6a8080e7          	jalr	1704(ra) # 800008ae <uvmalloc>
    8000120e:	0005079b          	sext.w	a5,a0
    80001212:	fbe1                	bnez	a5,800011e2 <growproc+0x26>
      return -1;
    80001214:	557d                	li	a0,-1
    80001216:	bfd9                	j	800011ec <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001218:	00f4863b          	addw	a2,s1,a5
    8000121c:	1602                	slli	a2,a2,0x20
    8000121e:	9201                	srli	a2,a2,0x20
    80001220:	1582                	slli	a1,a1,0x20
    80001222:	9181                	srli	a1,a1,0x20
    80001224:	6928                	ld	a0,80(a0)
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	640080e7          	jalr	1600(ra) # 80000866 <uvmdealloc>
    8000122e:	0005079b          	sext.w	a5,a0
    80001232:	bf45                	j	800011e2 <growproc+0x26>

0000000080001234 <fork>:
{
    80001234:	7139                	addi	sp,sp,-64
    80001236:	fc06                	sd	ra,56(sp)
    80001238:	f822                	sd	s0,48(sp)
    8000123a:	ec4e                	sd	s3,24(sp)
    8000123c:	e456                	sd	s5,8(sp)
    8000123e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001240:	00000097          	auipc	ra,0x0
    80001244:	c22080e7          	jalr	-990(ra) # 80000e62 <myproc>
    80001248:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	e22080e7          	jalr	-478(ra) # 8000106c <allocproc>
    80001252:	14050d63          	beqz	a0,800013ac <fork+0x178>
    80001256:	e852                	sd	s4,16(sp)
    80001258:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000125a:	0489b603          	ld	a2,72(s3)
    8000125e:	692c                	ld	a1,80(a0)
    80001260:	0509b503          	ld	a0,80(s3)
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	7a2080e7          	jalr	1954(ra) # 80000a06 <uvmcopy>
    8000126c:	04054a63          	bltz	a0,800012c0 <fork+0x8c>
    80001270:	f426                	sd	s1,40(sp)
    80001272:	f04a                	sd	s2,32(sp)
  np->sz = p->sz;
    80001274:	0489b783          	ld	a5,72(s3)
    80001278:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000127c:	0589b683          	ld	a3,88(s3)
    80001280:	87b6                	mv	a5,a3
    80001282:	058a3703          	ld	a4,88(s4)
    80001286:	12068693          	addi	a3,a3,288
    8000128a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000128e:	6788                	ld	a0,8(a5)
    80001290:	6b8c                	ld	a1,16(a5)
    80001292:	6f90                	ld	a2,24(a5)
    80001294:	01073023          	sd	a6,0(a4)
    80001298:	e708                	sd	a0,8(a4)
    8000129a:	eb0c                	sd	a1,16(a4)
    8000129c:	ef10                	sd	a2,24(a4)
    8000129e:	02078793          	addi	a5,a5,32
    800012a2:	02070713          	addi	a4,a4,32
    800012a6:	fed792e3          	bne	a5,a3,8000128a <fork+0x56>
  np->trapframe->a0 = 0;
    800012aa:	058a3783          	ld	a5,88(s4)
    800012ae:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012b2:	0d098493          	addi	s1,s3,208
    800012b6:	0d0a0913          	addi	s2,s4,208
    800012ba:	15098a93          	addi	s5,s3,336
    800012be:	a015                	j	800012e2 <fork+0xae>
    freeproc(np);
    800012c0:	8552                	mv	a0,s4
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	d52080e7          	jalr	-686(ra) # 80001014 <freeproc>
    release(&np->lock);
    800012ca:	8552                	mv	a0,s4
    800012cc:	00005097          	auipc	ra,0x5
    800012d0:	3de080e7          	jalr	990(ra) # 800066aa <release>
    return -1;
    800012d4:	5afd                	li	s5,-1
    800012d6:	6a42                	ld	s4,16(sp)
    800012d8:	a0d9                	j	8000139e <fork+0x16a>
  for(i = 0; i < NOFILE; i++)
    800012da:	04a1                	addi	s1,s1,8
    800012dc:	0921                	addi	s2,s2,8
    800012de:	01548b63          	beq	s1,s5,800012f4 <fork+0xc0>
    if(p->ofile[i])
    800012e2:	6088                	ld	a0,0(s1)
    800012e4:	d97d                	beqz	a0,800012da <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800012e6:	00002097          	auipc	ra,0x2
    800012ea:	7e4080e7          	jalr	2020(ra) # 80003aca <filedup>
    800012ee:	00a93023          	sd	a0,0(s2)
    800012f2:	b7e5                	j	800012da <fork+0xa6>
  np->cwd = idup(p->cwd);
    800012f4:	1509b503          	ld	a0,336(s3)
    800012f8:	00002097          	auipc	ra,0x2
    800012fc:	94a080e7          	jalr	-1718(ra) # 80002c42 <idup>
    80001300:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001304:	4641                	li	a2,16
    80001306:	15898593          	addi	a1,s3,344
    8000130a:	158a0513          	addi	a0,s4,344
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	fae080e7          	jalr	-82(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001316:	030a2a83          	lw	s5,48(s4)
  release(&np->lock);
    8000131a:	8552                	mv	a0,s4
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	38e080e7          	jalr	910(ra) # 800066aa <release>
  acquire(&wait_lock);
    80001324:	0000b497          	auipc	s1,0xb
    80001328:	d4448493          	addi	s1,s1,-700 # 8000c068 <wait_lock>
    8000132c:	8526                	mv	a0,s1
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	2c8080e7          	jalr	712(ra) # 800065f6 <acquire>
  np->parent = p;
    80001336:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    8000133a:	8526                	mv	a0,s1
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	36e080e7          	jalr	878(ra) # 800066aa <release>
  acquire(&np->lock);
    80001344:	8552                	mv	a0,s4
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	2b0080e7          	jalr	688(ra) # 800065f6 <acquire>
  np->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	00fa2c23          	sw	a5,24(s4)
  for(int i = 0; i < VMASIZE; i++) {
    80001354:	16898493          	addi	s1,s3,360
    80001358:	168a0913          	addi	s2,s4,360
    8000135c:	46898993          	addi	s3,s3,1128
    80001360:	a039                	j	8000136e <fork+0x13a>
    80001362:	03048493          	addi	s1,s1,48
    80001366:	03090913          	addi	s2,s2,48
    8000136a:	03348263          	beq	s1,s3,8000138e <fork+0x15a>
    if(p->vma[i].valid){
    8000136e:	409c                	lw	a5,0(s1)
    80001370:	dbed                	beqz	a5,80001362 <fork+0x12e>
      memmove(&(np->vma[i]), &(p->vma[i]), sizeof(p->vma[i]));
    80001372:	03000613          	li	a2,48
    80001376:	85a6                	mv	a1,s1
    80001378:	854a                	mv	a0,s2
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	e5c080e7          	jalr	-420(ra) # 800001d6 <memmove>
      filedup(p->vma[i].f);
    80001382:	6c88                	ld	a0,24(s1)
    80001384:	00002097          	auipc	ra,0x2
    80001388:	746080e7          	jalr	1862(ra) # 80003aca <filedup>
    8000138c:	bfd9                	j	80001362 <fork+0x12e>
  release(&np->lock);
    8000138e:	8552                	mv	a0,s4
    80001390:	00005097          	auipc	ra,0x5
    80001394:	31a080e7          	jalr	794(ra) # 800066aa <release>
  return pid;
    80001398:	74a2                	ld	s1,40(sp)
    8000139a:	7902                	ld	s2,32(sp)
    8000139c:	6a42                	ld	s4,16(sp)
}
    8000139e:	8556                	mv	a0,s5
    800013a0:	70e2                	ld	ra,56(sp)
    800013a2:	7442                	ld	s0,48(sp)
    800013a4:	69e2                	ld	s3,24(sp)
    800013a6:	6aa2                	ld	s5,8(sp)
    800013a8:	6121                	addi	sp,sp,64
    800013aa:	8082                	ret
    return -1;
    800013ac:	5afd                	li	s5,-1
    800013ae:	bfc5                	j	8000139e <fork+0x16a>

00000000800013b0 <scheduler>:
{
    800013b0:	7139                	addi	sp,sp,-64
    800013b2:	fc06                	sd	ra,56(sp)
    800013b4:	f822                	sd	s0,48(sp)
    800013b6:	f426                	sd	s1,40(sp)
    800013b8:	f04a                	sd	s2,32(sp)
    800013ba:	ec4e                	sd	s3,24(sp)
    800013bc:	e852                	sd	s4,16(sp)
    800013be:	e456                	sd	s5,8(sp)
    800013c0:	e05a                	sd	s6,0(sp)
    800013c2:	0080                	addi	s0,sp,64
    800013c4:	8792                	mv	a5,tp
  int id = r_tp();
    800013c6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c8:	00779a93          	slli	s5,a5,0x7
    800013cc:	0000b717          	auipc	a4,0xb
    800013d0:	c8470713          	addi	a4,a4,-892 # 8000c050 <pid_lock>
    800013d4:	9756                	add	a4,a4,s5
    800013d6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013da:	0000b717          	auipc	a4,0xb
    800013de:	cae70713          	addi	a4,a4,-850 # 8000c088 <cpus+0x8>
    800013e2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e4:	498d                	li	s3,3
        p->state = RUNNING;
    800013e6:	4b11                	li	s6,4
        c->proc = p;
    800013e8:	079e                	slli	a5,a5,0x7
    800013ea:	0000ba17          	auipc	s4,0xb
    800013ee:	c66a0a13          	addi	s4,s4,-922 # 8000c050 <pid_lock>
    800013f2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f4:	0001d917          	auipc	s2,0x1d
    800013f8:	a8c90913          	addi	s2,s2,-1396 # 8001de80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001400:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001404:	10079073          	csrw	sstatus,a5
    80001408:	0000b497          	auipc	s1,0xb
    8000140c:	07848493          	addi	s1,s1,120 # 8000c480 <proc>
    80001410:	a811                	j	80001424 <scheduler+0x74>
      release(&p->lock);
    80001412:	8526                	mv	a0,s1
    80001414:	00005097          	auipc	ra,0x5
    80001418:	296080e7          	jalr	662(ra) # 800066aa <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000141c:	46848493          	addi	s1,s1,1128
    80001420:	fd248ee3          	beq	s1,s2,800013fc <scheduler+0x4c>
      acquire(&p->lock);
    80001424:	8526                	mv	a0,s1
    80001426:	00005097          	auipc	ra,0x5
    8000142a:	1d0080e7          	jalr	464(ra) # 800065f6 <acquire>
      if(p->state == RUNNABLE) {
    8000142e:	4c9c                	lw	a5,24(s1)
    80001430:	ff3791e3          	bne	a5,s3,80001412 <scheduler+0x62>
        p->state = RUNNING;
    80001434:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001438:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143c:	06048593          	addi	a1,s1,96
    80001440:	8556                	mv	a0,s5
    80001442:	00000097          	auipc	ra,0x0
    80001446:	688080e7          	jalr	1672(ra) # 80001aca <swtch>
        c->proc = 0;
    8000144a:	020a3823          	sd	zero,48(s4)
    8000144e:	b7d1                	j	80001412 <scheduler+0x62>

0000000080001450 <sched>:
{
    80001450:	7179                	addi	sp,sp,-48
    80001452:	f406                	sd	ra,40(sp)
    80001454:	f022                	sd	s0,32(sp)
    80001456:	ec26                	sd	s1,24(sp)
    80001458:	e84a                	sd	s2,16(sp)
    8000145a:	e44e                	sd	s3,8(sp)
    8000145c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	a04080e7          	jalr	-1532(ra) # 80000e62 <myproc>
    80001466:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001468:	00005097          	auipc	ra,0x5
    8000146c:	114080e7          	jalr	276(ra) # 8000657c <holding>
    80001470:	c93d                	beqz	a0,800014e6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001472:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	0000b717          	auipc	a4,0xb
    8000147c:	bd870713          	addi	a4,a4,-1064 # 8000c050 <pid_lock>
    80001480:	97ba                	add	a5,a5,a4
    80001482:	0a87a703          	lw	a4,168(a5)
    80001486:	4785                	li	a5,1
    80001488:	06f71763          	bne	a4,a5,800014f6 <sched+0xa6>
  if(p->state == RUNNING)
    8000148c:	4c98                	lw	a4,24(s1)
    8000148e:	4791                	li	a5,4
    80001490:	06f70b63          	beq	a4,a5,80001506 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001494:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001498:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000149a:	efb5                	bnez	a5,80001516 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000149c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149e:	0000b917          	auipc	s2,0xb
    800014a2:	bb290913          	addi	s2,s2,-1102 # 8000c050 <pid_lock>
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	97ca                	add	a5,a5,s2
    800014ac:	0ac7a983          	lw	s3,172(a5)
    800014b0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b2:	2781                	sext.w	a5,a5
    800014b4:	079e                	slli	a5,a5,0x7
    800014b6:	0000b597          	auipc	a1,0xb
    800014ba:	bd258593          	addi	a1,a1,-1070 # 8000c088 <cpus+0x8>
    800014be:	95be                	add	a1,a1,a5
    800014c0:	06048513          	addi	a0,s1,96
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	606080e7          	jalr	1542(ra) # 80001aca <swtch>
    800014cc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ce:	2781                	sext.w	a5,a5
    800014d0:	079e                	slli	a5,a5,0x7
    800014d2:	993e                	add	s2,s2,a5
    800014d4:	0b392623          	sw	s3,172(s2)
}
    800014d8:	70a2                	ld	ra,40(sp)
    800014da:	7402                	ld	s0,32(sp)
    800014dc:	64e2                	ld	s1,24(sp)
    800014de:	6942                	ld	s2,16(sp)
    800014e0:	69a2                	ld	s3,8(sp)
    800014e2:	6145                	addi	sp,sp,48
    800014e4:	8082                	ret
    panic("sched p->lock");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	c7a50513          	addi	a0,a0,-902 # 80008160 <etext+0x160>
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	b8e080e7          	jalr	-1138(ra) # 8000607c <panic>
    panic("sched locks");
    800014f6:	00007517          	auipc	a0,0x7
    800014fa:	c7a50513          	addi	a0,a0,-902 # 80008170 <etext+0x170>
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	b7e080e7          	jalr	-1154(ra) # 8000607c <panic>
    panic("sched running");
    80001506:	00007517          	auipc	a0,0x7
    8000150a:	c7a50513          	addi	a0,a0,-902 # 80008180 <etext+0x180>
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	b6e080e7          	jalr	-1170(ra) # 8000607c <panic>
    panic("sched interruptible");
    80001516:	00007517          	auipc	a0,0x7
    8000151a:	c7a50513          	addi	a0,a0,-902 # 80008190 <etext+0x190>
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	b5e080e7          	jalr	-1186(ra) # 8000607c <panic>

0000000080001526 <yield>:
{
    80001526:	1101                	addi	sp,sp,-32
    80001528:	ec06                	sd	ra,24(sp)
    8000152a:	e822                	sd	s0,16(sp)
    8000152c:	e426                	sd	s1,8(sp)
    8000152e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	932080e7          	jalr	-1742(ra) # 80000e62 <myproc>
    80001538:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	0bc080e7          	jalr	188(ra) # 800065f6 <acquire>
  p->state = RUNNABLE;
    80001542:	478d                	li	a5,3
    80001544:	cc9c                	sw	a5,24(s1)
  sched();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	f0a080e7          	jalr	-246(ra) # 80001450 <sched>
  release(&p->lock);
    8000154e:	8526                	mv	a0,s1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	15a080e7          	jalr	346(ra) # 800066aa <release>
}
    80001558:	60e2                	ld	ra,24(sp)
    8000155a:	6442                	ld	s0,16(sp)
    8000155c:	64a2                	ld	s1,8(sp)
    8000155e:	6105                	addi	sp,sp,32
    80001560:	8082                	ret

0000000080001562 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001562:	7179                	addi	sp,sp,-48
    80001564:	f406                	sd	ra,40(sp)
    80001566:	f022                	sd	s0,32(sp)
    80001568:	ec26                	sd	s1,24(sp)
    8000156a:	e84a                	sd	s2,16(sp)
    8000156c:	e44e                	sd	s3,8(sp)
    8000156e:	1800                	addi	s0,sp,48
    80001570:	89aa                	mv	s3,a0
    80001572:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001574:	00000097          	auipc	ra,0x0
    80001578:	8ee080e7          	jalr	-1810(ra) # 80000e62 <myproc>
    8000157c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	078080e7          	jalr	120(ra) # 800065f6 <acquire>
  release(lk);
    80001586:	854a                	mv	a0,s2
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	122080e7          	jalr	290(ra) # 800066aa <release>

  // Go to sleep.
  p->chan = chan;
    80001590:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001594:	4789                	li	a5,2
    80001596:	cc9c                	sw	a5,24(s1)

  sched();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	eb8080e7          	jalr	-328(ra) # 80001450 <sched>

  // Tidy up.
  p->chan = 0;
    800015a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a4:	8526                	mv	a0,s1
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	104080e7          	jalr	260(ra) # 800066aa <release>
  acquire(lk);
    800015ae:	854a                	mv	a0,s2
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	046080e7          	jalr	70(ra) # 800065f6 <acquire>
}
    800015b8:	70a2                	ld	ra,40(sp)
    800015ba:	7402                	ld	s0,32(sp)
    800015bc:	64e2                	ld	s1,24(sp)
    800015be:	6942                	ld	s2,16(sp)
    800015c0:	69a2                	ld	s3,8(sp)
    800015c2:	6145                	addi	sp,sp,48
    800015c4:	8082                	ret

00000000800015c6 <wait>:
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	882080e7          	jalr	-1918(ra) # 80000e62 <myproc>
    800015e8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ea:	0000b517          	auipc	a0,0xb
    800015ee:	a7e50513          	addi	a0,a0,-1410 # 8000c068 <wait_lock>
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	004080e7          	jalr	4(ra) # 800065f6 <acquire>
    havekids = 0;
    800015fa:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015fc:	4a15                	li	s4,5
        havekids = 1;
    800015fe:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001600:	0001d997          	auipc	s3,0x1d
    80001604:	88098993          	addi	s3,s3,-1920 # 8001de80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001608:	0000bc17          	auipc	s8,0xb
    8000160c:	a60c0c13          	addi	s8,s8,-1440 # 8000c068 <wait_lock>
    80001610:	a87d                	j	800016ce <wait+0x108>
          pid = np->pid;
    80001612:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001616:	000b0e63          	beqz	s6,80001632 <wait+0x6c>
    8000161a:	4691                	li	a3,4
    8000161c:	02c48613          	addi	a2,s1,44
    80001620:	85da                	mv	a1,s6
    80001622:	05093503          	ld	a0,80(s2)
    80001626:	fffff097          	auipc	ra,0xfffff
    8000162a:	4d8080e7          	jalr	1240(ra) # 80000afe <copyout>
    8000162e:	04054163          	bltz	a0,80001670 <wait+0xaa>
          freeproc(np);
    80001632:	8526                	mv	a0,s1
    80001634:	00000097          	auipc	ra,0x0
    80001638:	9e0080e7          	jalr	-1568(ra) # 80001014 <freeproc>
          release(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	06c080e7          	jalr	108(ra) # 800066aa <release>
          release(&wait_lock);
    80001646:	0000b517          	auipc	a0,0xb
    8000164a:	a2250513          	addi	a0,a0,-1502 # 8000c068 <wait_lock>
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	05c080e7          	jalr	92(ra) # 800066aa <release>
}
    80001656:	854e                	mv	a0,s3
    80001658:	60a6                	ld	ra,72(sp)
    8000165a:	6406                	ld	s0,64(sp)
    8000165c:	74e2                	ld	s1,56(sp)
    8000165e:	7942                	ld	s2,48(sp)
    80001660:	79a2                	ld	s3,40(sp)
    80001662:	7a02                	ld	s4,32(sp)
    80001664:	6ae2                	ld	s5,24(sp)
    80001666:	6b42                	ld	s6,16(sp)
    80001668:	6ba2                	ld	s7,8(sp)
    8000166a:	6c02                	ld	s8,0(sp)
    8000166c:	6161                	addi	sp,sp,80
    8000166e:	8082                	ret
            release(&np->lock);
    80001670:	8526                	mv	a0,s1
    80001672:	00005097          	auipc	ra,0x5
    80001676:	038080e7          	jalr	56(ra) # 800066aa <release>
            release(&wait_lock);
    8000167a:	0000b517          	auipc	a0,0xb
    8000167e:	9ee50513          	addi	a0,a0,-1554 # 8000c068 <wait_lock>
    80001682:	00005097          	auipc	ra,0x5
    80001686:	028080e7          	jalr	40(ra) # 800066aa <release>
            return -1;
    8000168a:	59fd                	li	s3,-1
    8000168c:	b7e9                	j	80001656 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000168e:	46848493          	addi	s1,s1,1128
    80001692:	03348463          	beq	s1,s3,800016ba <wait+0xf4>
      if(np->parent == p){
    80001696:	7c9c                	ld	a5,56(s1)
    80001698:	ff279be3          	bne	a5,s2,8000168e <wait+0xc8>
        acquire(&np->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	f58080e7          	jalr	-168(ra) # 800065f6 <acquire>
        if(np->state == ZOMBIE){
    800016a6:	4c9c                	lw	a5,24(s1)
    800016a8:	f74785e3          	beq	a5,s4,80001612 <wait+0x4c>
        release(&np->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	ffc080e7          	jalr	-4(ra) # 800066aa <release>
        havekids = 1;
    800016b6:	8756                	mv	a4,s5
    800016b8:	bfd9                	j	8000168e <wait+0xc8>
    if(!havekids || p->killed){
    800016ba:	c305                	beqz	a4,800016da <wait+0x114>
    800016bc:	02892783          	lw	a5,40(s2)
    800016c0:	ef89                	bnez	a5,800016da <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c2:	85e2                	mv	a1,s8
    800016c4:	854a                	mv	a0,s2
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	e9c080e7          	jalr	-356(ra) # 80001562 <sleep>
    havekids = 0;
    800016ce:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016d0:	0000b497          	auipc	s1,0xb
    800016d4:	db048493          	addi	s1,s1,-592 # 8000c480 <proc>
    800016d8:	bf7d                	j	80001696 <wait+0xd0>
      release(&wait_lock);
    800016da:	0000b517          	auipc	a0,0xb
    800016de:	98e50513          	addi	a0,a0,-1650 # 8000c068 <wait_lock>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	fc8080e7          	jalr	-56(ra) # 800066aa <release>
      return -1;
    800016ea:	59fd                	li	s3,-1
    800016ec:	b7ad                	j	80001656 <wait+0x90>

00000000800016ee <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ee:	7139                	addi	sp,sp,-64
    800016f0:	fc06                	sd	ra,56(sp)
    800016f2:	f822                	sd	s0,48(sp)
    800016f4:	f426                	sd	s1,40(sp)
    800016f6:	f04a                	sd	s2,32(sp)
    800016f8:	ec4e                	sd	s3,24(sp)
    800016fa:	e852                	sd	s4,16(sp)
    800016fc:	e456                	sd	s5,8(sp)
    800016fe:	0080                	addi	s0,sp,64
    80001700:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	0000b497          	auipc	s1,0xb
    80001706:	d7e48493          	addi	s1,s1,-642 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000170a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000170c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170e:	0001c917          	auipc	s2,0x1c
    80001712:	77290913          	addi	s2,s2,1906 # 8001de80 <tickslock>
    80001716:	a811                	j	8000172a <wakeup+0x3c>
      }
      release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	f90080e7          	jalr	-112(ra) # 800066aa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	46848493          	addi	s1,s1,1128
    80001726:	03248663          	beq	s1,s2,80001752 <wakeup+0x64>
    if(p != myproc()){
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	738080e7          	jalr	1848(ra) # 80000e62 <myproc>
    80001732:	fea488e3          	beq	s1,a0,80001722 <wakeup+0x34>
      acquire(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	ebe080e7          	jalr	-322(ra) # 800065f6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4c9c                	lw	a5,24(s1)
    80001742:	fd379be3          	bne	a5,s3,80001718 <wakeup+0x2a>
    80001746:	709c                	ld	a5,32(s1)
    80001748:	fd4798e3          	bne	a5,s4,80001718 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000174c:	0154ac23          	sw	s5,24(s1)
    80001750:	b7e1                	j	80001718 <wakeup+0x2a>
    }
  }
}
    80001752:	70e2                	ld	ra,56(sp)
    80001754:	7442                	ld	s0,48(sp)
    80001756:	74a2                	ld	s1,40(sp)
    80001758:	7902                	ld	s2,32(sp)
    8000175a:	69e2                	ld	s3,24(sp)
    8000175c:	6a42                	ld	s4,16(sp)
    8000175e:	6aa2                	ld	s5,8(sp)
    80001760:	6121                	addi	sp,sp,64
    80001762:	8082                	ret

0000000080001764 <reparent>:
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001776:	0000b497          	auipc	s1,0xb
    8000177a:	d0a48493          	addi	s1,s1,-758 # 8000c480 <proc>
      pp->parent = initproc;
    8000177e:	0000ba17          	auipc	s4,0xb
    80001782:	892a0a13          	addi	s4,s4,-1902 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001786:	0001c997          	auipc	s3,0x1c
    8000178a:	6fa98993          	addi	s3,s3,1786 # 8001de80 <tickslock>
    8000178e:	a029                	j	80001798 <reparent+0x34>
    80001790:	46848493          	addi	s1,s1,1128
    80001794:	01348d63          	beq	s1,s3,800017ae <reparent+0x4a>
    if(pp->parent == p){
    80001798:	7c9c                	ld	a5,56(s1)
    8000179a:	ff279be3          	bne	a5,s2,80001790 <reparent+0x2c>
      pp->parent = initproc;
    8000179e:	000a3503          	ld	a0,0(s4)
    800017a2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	f4a080e7          	jalr	-182(ra) # 800016ee <wakeup>
    800017ac:	b7d5                	j	80001790 <reparent+0x2c>
}
    800017ae:	70a2                	ld	ra,40(sp)
    800017b0:	7402                	ld	s0,32(sp)
    800017b2:	64e2                	ld	s1,24(sp)
    800017b4:	6942                	ld	s2,16(sp)
    800017b6:	69a2                	ld	s3,8(sp)
    800017b8:	6a02                	ld	s4,0(sp)
    800017ba:	6145                	addi	sp,sp,48
    800017bc:	8082                	ret

00000000800017be <exit>:
{
    800017be:	7139                	addi	sp,sp,-64
    800017c0:	fc06                	sd	ra,56(sp)
    800017c2:	f822                	sd	s0,48(sp)
    800017c4:	f426                	sd	s1,40(sp)
    800017c6:	f04a                	sd	s2,32(sp)
    800017c8:	ec4e                	sd	s3,24(sp)
    800017ca:	e852                	sd	s4,16(sp)
    800017cc:	0080                	addi	s0,sp,64
    800017ce:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017d0:	fffff097          	auipc	ra,0xfffff
    800017d4:	692080e7          	jalr	1682(ra) # 80000e62 <myproc>
    800017d8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017da:	0000b797          	auipc	a5,0xb
    800017de:	8367b783          	ld	a5,-1994(a5) # 8000c010 <initproc>
    800017e2:	0d050493          	addi	s1,a0,208
    800017e6:	15050913          	addi	s2,a0,336
    800017ea:	00a78463          	beq	a5,a0,800017f2 <exit+0x34>
    800017ee:	e456                	sd	s5,8(sp)
    800017f0:	a01d                	j	80001816 <exit+0x58>
    800017f2:	e456                	sd	s5,8(sp)
    panic("init exiting");
    800017f4:	00007517          	auipc	a0,0x7
    800017f8:	9b450513          	addi	a0,a0,-1612 # 800081a8 <etext+0x1a8>
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	880080e7          	jalr	-1920(ra) # 8000607c <panic>
      fileclose(f);
    80001804:	00002097          	auipc	ra,0x2
    80001808:	318080e7          	jalr	792(ra) # 80003b1c <fileclose>
      p->ofile[fd] = 0;
    8000180c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001810:	04a1                	addi	s1,s1,8
    80001812:	01248563          	beq	s1,s2,8000181c <exit+0x5e>
    if(p->ofile[fd]){
    80001816:	6088                	ld	a0,0(s1)
    80001818:	f575                	bnez	a0,80001804 <exit+0x46>
    8000181a:	bfdd                	j	80001810 <exit+0x52>
    8000181c:	16898493          	addi	s1,s3,360
    80001820:	46898a93          	addi	s5,s3,1128
    80001824:	a83d                	j	80001862 <exit+0xa4>
      fileclose(p->vma[i].f);
    80001826:	01893503          	ld	a0,24(s2)
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	2f2080e7          	jalr	754(ra) # 80003b1c <fileclose>
      uvmunmap(p->pagetable, p->vma[i].addr, p->vma[i].length/PGSIZE, 1);
    80001832:	01092783          	lw	a5,16(s2)
    80001836:	41f7d61b          	sraiw	a2,a5,0x1f
    8000183a:	0146561b          	srliw	a2,a2,0x14
    8000183e:	9e3d                	addw	a2,a2,a5
    80001840:	4685                	li	a3,1
    80001842:	40c6561b          	sraiw	a2,a2,0xc
    80001846:	00893583          	ld	a1,8(s2)
    8000184a:	0509b503          	ld	a0,80(s3)
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	eb2080e7          	jalr	-334(ra) # 80000700 <uvmunmap>
      p->vma[i].valid = 0;
    80001856:	00092023          	sw	zero,0(s2)
  for(int i = 0; i < VMASIZE; i++) {
    8000185a:	03048493          	addi	s1,s1,48
    8000185e:	03548063          	beq	s1,s5,8000187e <exit+0xc0>
    if(p->vma[i].valid) {
    80001862:	8926                	mv	s2,s1
    80001864:	409c                	lw	a5,0(s1)
    80001866:	dbf5                	beqz	a5,8000185a <exit+0x9c>
      if(p->vma[i].flags & MAP_SHARED)
    80001868:	50dc                	lw	a5,36(s1)
    8000186a:	8b85                	andi	a5,a5,1
    8000186c:	dfcd                	beqz	a5,80001826 <exit+0x68>
        filewrite(p->vma[i].f, p->vma[i].addr, p->vma[i].length);
    8000186e:	4890                	lw	a2,16(s1)
    80001870:	648c                	ld	a1,8(s1)
    80001872:	6c88                	ld	a0,24(s1)
    80001874:	00002097          	auipc	ra,0x2
    80001878:	4ce080e7          	jalr	1230(ra) # 80003d42 <filewrite>
    8000187c:	b76d                	j	80001826 <exit+0x68>
  begin_op();
    8000187e:	00002097          	auipc	ra,0x2
    80001882:	dd4080e7          	jalr	-556(ra) # 80003652 <begin_op>
  iput(p->cwd);
    80001886:	1509b503          	ld	a0,336(s3)
    8000188a:	00001097          	auipc	ra,0x1
    8000188e:	5b4080e7          	jalr	1460(ra) # 80002e3e <iput>
  end_op();
    80001892:	00002097          	auipc	ra,0x2
    80001896:	e3a080e7          	jalr	-454(ra) # 800036cc <end_op>
  p->cwd = 0;
    8000189a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000189e:	0000a497          	auipc	s1,0xa
    800018a2:	7ca48493          	addi	s1,s1,1994 # 8000c068 <wait_lock>
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	d4e080e7          	jalr	-690(ra) # 800065f6 <acquire>
  reparent(p);
    800018b0:	854e                	mv	a0,s3
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	eb2080e7          	jalr	-334(ra) # 80001764 <reparent>
  wakeup(p->parent);
    800018ba:	0389b503          	ld	a0,56(s3)
    800018be:	00000097          	auipc	ra,0x0
    800018c2:	e30080e7          	jalr	-464(ra) # 800016ee <wakeup>
  acquire(&p->lock);
    800018c6:	854e                	mv	a0,s3
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	d2e080e7          	jalr	-722(ra) # 800065f6 <acquire>
  p->xstate = status;
    800018d0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018d4:	4795                	li	a5,5
    800018d6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	dce080e7          	jalr	-562(ra) # 800066aa <release>
  sched();
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	b6c080e7          	jalr	-1172(ra) # 80001450 <sched>
  panic("zombie exit");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	8cc50513          	addi	a0,a0,-1844 # 800081b8 <etext+0x1b8>
    800018f4:	00004097          	auipc	ra,0x4
    800018f8:	788080e7          	jalr	1928(ra) # 8000607c <panic>

00000000800018fc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000190c:	0000b497          	auipc	s1,0xb
    80001910:	b7448493          	addi	s1,s1,-1164 # 8000c480 <proc>
    80001914:	0001c997          	auipc	s3,0x1c
    80001918:	56c98993          	addi	s3,s3,1388 # 8001de80 <tickslock>
    acquire(&p->lock);
    8000191c:	8526                	mv	a0,s1
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	cd8080e7          	jalr	-808(ra) # 800065f6 <acquire>
    if(p->pid == pid){
    80001926:	589c                	lw	a5,48(s1)
    80001928:	01278d63          	beq	a5,s2,80001942 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	d7c080e7          	jalr	-644(ra) # 800066aa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001936:	46848493          	addi	s1,s1,1128
    8000193a:	ff3491e3          	bne	s1,s3,8000191c <kill+0x20>
  }
  return -1;
    8000193e:	557d                	li	a0,-1
    80001940:	a829                	j	8000195a <kill+0x5e>
      p->killed = 1;
    80001942:	4785                	li	a5,1
    80001944:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001946:	4c98                	lw	a4,24(s1)
    80001948:	4789                	li	a5,2
    8000194a:	00f70f63          	beq	a4,a5,80001968 <kill+0x6c>
      release(&p->lock);
    8000194e:	8526                	mv	a0,s1
    80001950:	00005097          	auipc	ra,0x5
    80001954:	d5a080e7          	jalr	-678(ra) # 800066aa <release>
      return 0;
    80001958:	4501                	li	a0,0
}
    8000195a:	70a2                	ld	ra,40(sp)
    8000195c:	7402                	ld	s0,32(sp)
    8000195e:	64e2                	ld	s1,24(sp)
    80001960:	6942                	ld	s2,16(sp)
    80001962:	69a2                	ld	s3,8(sp)
    80001964:	6145                	addi	sp,sp,48
    80001966:	8082                	ret
        p->state = RUNNABLE;
    80001968:	478d                	li	a5,3
    8000196a:	cc9c                	sw	a5,24(s1)
    8000196c:	b7cd                	j	8000194e <kill+0x52>

000000008000196e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000196e:	7179                	addi	sp,sp,-48
    80001970:	f406                	sd	ra,40(sp)
    80001972:	f022                	sd	s0,32(sp)
    80001974:	ec26                	sd	s1,24(sp)
    80001976:	e84a                	sd	s2,16(sp)
    80001978:	e44e                	sd	s3,8(sp)
    8000197a:	e052                	sd	s4,0(sp)
    8000197c:	1800                	addi	s0,sp,48
    8000197e:	84aa                	mv	s1,a0
    80001980:	892e                	mv	s2,a1
    80001982:	89b2                	mv	s3,a2
    80001984:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	4dc080e7          	jalr	1244(ra) # 80000e62 <myproc>
  if(user_dst){
    8000198e:	c08d                	beqz	s1,800019b0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001990:	86d2                	mv	a3,s4
    80001992:	864e                	mv	a2,s3
    80001994:	85ca                	mv	a1,s2
    80001996:	6928                	ld	a0,80(a0)
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	166080e7          	jalr	358(ra) # 80000afe <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019a0:	70a2                	ld	ra,40(sp)
    800019a2:	7402                	ld	s0,32(sp)
    800019a4:	64e2                	ld	s1,24(sp)
    800019a6:	6942                	ld	s2,16(sp)
    800019a8:	69a2                	ld	s3,8(sp)
    800019aa:	6a02                	ld	s4,0(sp)
    800019ac:	6145                	addi	sp,sp,48
    800019ae:	8082                	ret
    memmove((char *)dst, src, len);
    800019b0:	000a061b          	sext.w	a2,s4
    800019b4:	85ce                	mv	a1,s3
    800019b6:	854a                	mv	a0,s2
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	81e080e7          	jalr	-2018(ra) # 800001d6 <memmove>
    return 0;
    800019c0:	8526                	mv	a0,s1
    800019c2:	bff9                	j	800019a0 <either_copyout+0x32>

00000000800019c4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019c4:	7179                	addi	sp,sp,-48
    800019c6:	f406                	sd	ra,40(sp)
    800019c8:	f022                	sd	s0,32(sp)
    800019ca:	ec26                	sd	s1,24(sp)
    800019cc:	e84a                	sd	s2,16(sp)
    800019ce:	e44e                	sd	s3,8(sp)
    800019d0:	e052                	sd	s4,0(sp)
    800019d2:	1800                	addi	s0,sp,48
    800019d4:	892a                	mv	s2,a0
    800019d6:	84ae                	mv	s1,a1
    800019d8:	89b2                	mv	s3,a2
    800019da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	486080e7          	jalr	1158(ra) # 80000e62 <myproc>
  if(user_src){
    800019e4:	c08d                	beqz	s1,80001a06 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019e6:	86d2                	mv	a3,s4
    800019e8:	864e                	mv	a2,s3
    800019ea:	85ca                	mv	a1,s2
    800019ec:	6928                	ld	a0,80(a0)
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	19c080e7          	jalr	412(ra) # 80000b8a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019f6:	70a2                	ld	ra,40(sp)
    800019f8:	7402                	ld	s0,32(sp)
    800019fa:	64e2                	ld	s1,24(sp)
    800019fc:	6942                	ld	s2,16(sp)
    800019fe:	69a2                	ld	s3,8(sp)
    80001a00:	6a02                	ld	s4,0(sp)
    80001a02:	6145                	addi	sp,sp,48
    80001a04:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a06:	000a061b          	sext.w	a2,s4
    80001a0a:	85ce                	mv	a1,s3
    80001a0c:	854a                	mv	a0,s2
    80001a0e:	ffffe097          	auipc	ra,0xffffe
    80001a12:	7c8080e7          	jalr	1992(ra) # 800001d6 <memmove>
    return 0;
    80001a16:	8526                	mv	a0,s1
    80001a18:	bff9                	j	800019f6 <either_copyin+0x32>

0000000080001a1a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a1a:	715d                	addi	sp,sp,-80
    80001a1c:	e486                	sd	ra,72(sp)
    80001a1e:	e0a2                	sd	s0,64(sp)
    80001a20:	fc26                	sd	s1,56(sp)
    80001a22:	f84a                	sd	s2,48(sp)
    80001a24:	f44e                	sd	s3,40(sp)
    80001a26:	f052                	sd	s4,32(sp)
    80001a28:	ec56                	sd	s5,24(sp)
    80001a2a:	e85a                	sd	s6,16(sp)
    80001a2c:	e45e                	sd	s7,8(sp)
    80001a2e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a30:	00006517          	auipc	a0,0x6
    80001a34:	5e850513          	addi	a0,a0,1512 # 80008018 <etext+0x18>
    80001a38:	00004097          	auipc	ra,0x4
    80001a3c:	68e080e7          	jalr	1678(ra) # 800060c6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a40:	0000b497          	auipc	s1,0xb
    80001a44:	b9848493          	addi	s1,s1,-1128 # 8000c5d8 <proc+0x158>
    80001a48:	0001c917          	auipc	s2,0x1c
    80001a4c:	59090913          	addi	s2,s2,1424 # 8001dfd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a50:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a52:	00006997          	auipc	s3,0x6
    80001a56:	77698993          	addi	s3,s3,1910 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a5a:	00006a97          	auipc	s5,0x6
    80001a5e:	776a8a93          	addi	s5,s5,1910 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001a62:	00006a17          	auipc	s4,0x6
    80001a66:	5b6a0a13          	addi	s4,s4,1462 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6a:	00007b97          	auipc	s7,0x7
    80001a6e:	c5eb8b93          	addi	s7,s7,-930 # 800086c8 <states.0>
    80001a72:	a00d                	j	80001a94 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a74:	ed86a583          	lw	a1,-296(a3)
    80001a78:	8556                	mv	a0,s5
    80001a7a:	00004097          	auipc	ra,0x4
    80001a7e:	64c080e7          	jalr	1612(ra) # 800060c6 <printf>
    printf("\n");
    80001a82:	8552                	mv	a0,s4
    80001a84:	00004097          	auipc	ra,0x4
    80001a88:	642080e7          	jalr	1602(ra) # 800060c6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a8c:	46848493          	addi	s1,s1,1128
    80001a90:	03248263          	beq	s1,s2,80001ab4 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a94:	86a6                	mv	a3,s1
    80001a96:	ec04a783          	lw	a5,-320(s1)
    80001a9a:	dbed                	beqz	a5,80001a8c <procdump+0x72>
      state = "???";
    80001a9c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a9e:	fcfb6be3          	bltu	s6,a5,80001a74 <procdump+0x5a>
    80001aa2:	02079713          	slli	a4,a5,0x20
    80001aa6:	01d75793          	srli	a5,a4,0x1d
    80001aaa:	97de                	add	a5,a5,s7
    80001aac:	6390                	ld	a2,0(a5)
    80001aae:	f279                	bnez	a2,80001a74 <procdump+0x5a>
      state = "???";
    80001ab0:	864e                	mv	a2,s3
    80001ab2:	b7c9                	j	80001a74 <procdump+0x5a>
  }
}
    80001ab4:	60a6                	ld	ra,72(sp)
    80001ab6:	6406                	ld	s0,64(sp)
    80001ab8:	74e2                	ld	s1,56(sp)
    80001aba:	7942                	ld	s2,48(sp)
    80001abc:	79a2                	ld	s3,40(sp)
    80001abe:	7a02                	ld	s4,32(sp)
    80001ac0:	6ae2                	ld	s5,24(sp)
    80001ac2:	6b42                	ld	s6,16(sp)
    80001ac4:	6ba2                	ld	s7,8(sp)
    80001ac6:	6161                	addi	sp,sp,80
    80001ac8:	8082                	ret

0000000080001aca <swtch>:
    80001aca:	00153023          	sd	ra,0(a0)
    80001ace:	00253423          	sd	sp,8(a0)
    80001ad2:	e900                	sd	s0,16(a0)
    80001ad4:	ed04                	sd	s1,24(a0)
    80001ad6:	03253023          	sd	s2,32(a0)
    80001ada:	03353423          	sd	s3,40(a0)
    80001ade:	03453823          	sd	s4,48(a0)
    80001ae2:	03553c23          	sd	s5,56(a0)
    80001ae6:	05653023          	sd	s6,64(a0)
    80001aea:	05753423          	sd	s7,72(a0)
    80001aee:	05853823          	sd	s8,80(a0)
    80001af2:	05953c23          	sd	s9,88(a0)
    80001af6:	07a53023          	sd	s10,96(a0)
    80001afa:	07b53423          	sd	s11,104(a0)
    80001afe:	0005b083          	ld	ra,0(a1)
    80001b02:	0085b103          	ld	sp,8(a1)
    80001b06:	6980                	ld	s0,16(a1)
    80001b08:	6d84                	ld	s1,24(a1)
    80001b0a:	0205b903          	ld	s2,32(a1)
    80001b0e:	0285b983          	ld	s3,40(a1)
    80001b12:	0305ba03          	ld	s4,48(a1)
    80001b16:	0385ba83          	ld	s5,56(a1)
    80001b1a:	0405bb03          	ld	s6,64(a1)
    80001b1e:	0485bb83          	ld	s7,72(a1)
    80001b22:	0505bc03          	ld	s8,80(a1)
    80001b26:	0585bc83          	ld	s9,88(a1)
    80001b2a:	0605bd03          	ld	s10,96(a1)
    80001b2e:	0685bd83          	ld	s11,104(a1)
    80001b32:	8082                	ret

0000000080001b34 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b34:	1141                	addi	sp,sp,-16
    80001b36:	e406                	sd	ra,8(sp)
    80001b38:	e022                	sd	s0,0(sp)
    80001b3a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b3c:	00006597          	auipc	a1,0x6
    80001b40:	6cc58593          	addi	a1,a1,1740 # 80008208 <etext+0x208>
    80001b44:	0001c517          	auipc	a0,0x1c
    80001b48:	33c50513          	addi	a0,a0,828 # 8001de80 <tickslock>
    80001b4c:	00005097          	auipc	ra,0x5
    80001b50:	a1a080e7          	jalr	-1510(ra) # 80006566 <initlock>
}
    80001b54:	60a2                	ld	ra,8(sp)
    80001b56:	6402                	ld	s0,0(sp)
    80001b58:	0141                	addi	sp,sp,16
    80001b5a:	8082                	ret

0000000080001b5c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b5c:	1141                	addi	sp,sp,-16
    80001b5e:	e422                	sd	s0,8(sp)
    80001b60:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b62:	00004797          	auipc	a5,0x4
    80001b66:	92e78793          	addi	a5,a5,-1746 # 80005490 <kernelvec>
    80001b6a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b6e:	6422                	ld	s0,8(sp)
    80001b70:	0141                	addi	sp,sp,16
    80001b72:	8082                	ret

0000000080001b74 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b74:	1141                	addi	sp,sp,-16
    80001b76:	e406                	sd	ra,8(sp)
    80001b78:	e022                	sd	s0,0(sp)
    80001b7a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b7c:	fffff097          	auipc	ra,0xfffff
    80001b80:	2e6080e7          	jalr	742(ra) # 80000e62 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b8a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b8e:	00005697          	auipc	a3,0x5
    80001b92:	47268693          	addi	a3,a3,1138 # 80007000 <_trampoline>
    80001b96:	00005717          	auipc	a4,0x5
    80001b9a:	46a70713          	addi	a4,a4,1130 # 80007000 <_trampoline>
    80001b9e:	8f15                	sub	a4,a4,a3
    80001ba0:	040007b7          	lui	a5,0x4000
    80001ba4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ba6:	07b2                	slli	a5,a5,0xc
    80001ba8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001baa:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bae:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bb0:	18002673          	csrr	a2,satp
    80001bb4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bb6:	6d30                	ld	a2,88(a0)
    80001bb8:	6138                	ld	a4,64(a0)
    80001bba:	6585                	lui	a1,0x1
    80001bbc:	972e                	add	a4,a4,a1
    80001bbe:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bc0:	6d38                	ld	a4,88(a0)
    80001bc2:	00000617          	auipc	a2,0x0
    80001bc6:	14060613          	addi	a2,a2,320 # 80001d02 <usertrap>
    80001bca:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bcc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bce:	8612                	mv	a2,tp
    80001bd0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bd6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bda:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bde:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001be2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001be4:	6f18                	ld	a4,24(a4)
    80001be6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bea:	692c                	ld	a1,80(a0)
    80001bec:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bee:	00005717          	auipc	a4,0x5
    80001bf2:	4a270713          	addi	a4,a4,1186 # 80007090 <userret>
    80001bf6:	8f15                	sub	a4,a4,a3
    80001bf8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bfa:	577d                	li	a4,-1
    80001bfc:	177e                	slli	a4,a4,0x3f
    80001bfe:	8dd9                	or	a1,a1,a4
    80001c00:	02000537          	lui	a0,0x2000
    80001c04:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c06:	0536                	slli	a0,a0,0xd
    80001c08:	9782                	jalr	a5
}
    80001c0a:	60a2                	ld	ra,8(sp)
    80001c0c:	6402                	ld	s0,0(sp)
    80001c0e:	0141                	addi	sp,sp,16
    80001c10:	8082                	ret

0000000080001c12 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c12:	1101                	addi	sp,sp,-32
    80001c14:	ec06                	sd	ra,24(sp)
    80001c16:	e822                	sd	s0,16(sp)
    80001c18:	e426                	sd	s1,8(sp)
    80001c1a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c1c:	0001c497          	auipc	s1,0x1c
    80001c20:	26448493          	addi	s1,s1,612 # 8001de80 <tickslock>
    80001c24:	8526                	mv	a0,s1
    80001c26:	00005097          	auipc	ra,0x5
    80001c2a:	9d0080e7          	jalr	-1584(ra) # 800065f6 <acquire>
  ticks++;
    80001c2e:	0000a517          	auipc	a0,0xa
    80001c32:	3ea50513          	addi	a0,a0,1002 # 8000c018 <ticks>
    80001c36:	411c                	lw	a5,0(a0)
    80001c38:	2785                	addiw	a5,a5,1
    80001c3a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	ab2080e7          	jalr	-1358(ra) # 800016ee <wakeup>
  release(&tickslock);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00005097          	auipc	ra,0x5
    80001c4a:	a64080e7          	jalr	-1436(ra) # 800066aa <release>
}
    80001c4e:	60e2                	ld	ra,24(sp)
    80001c50:	6442                	ld	s0,16(sp)
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret

0000000080001c58 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c58:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c5c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c5e:	0a07d163          	bgez	a5,80001d00 <devintr+0xa8>
{
    80001c62:	1101                	addi	sp,sp,-32
    80001c64:	ec06                	sd	ra,24(sp)
    80001c66:	e822                	sd	s0,16(sp)
    80001c68:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c6a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c6e:	46a5                	li	a3,9
    80001c70:	00d70c63          	beq	a4,a3,80001c88 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c74:	577d                	li	a4,-1
    80001c76:	177e                	slli	a4,a4,0x3f
    80001c78:	0705                	addi	a4,a4,1
    return 0;
    80001c7a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c7c:	06e78163          	beq	a5,a4,80001cde <devintr+0x86>
  }
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	6105                	addi	sp,sp,32
    80001c86:	8082                	ret
    80001c88:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	912080e7          	jalr	-1774(ra) # 8000559c <plic_claim>
    80001c92:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c94:	47a9                	li	a5,10
    80001c96:	00f50963          	beq	a0,a5,80001ca8 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c9a:	4785                	li	a5,1
    80001c9c:	00f50b63          	beq	a0,a5,80001cb2 <devintr+0x5a>
    return 1;
    80001ca0:	4505                	li	a0,1
    } else if(irq){
    80001ca2:	ec89                	bnez	s1,80001cbc <devintr+0x64>
    80001ca4:	64a2                	ld	s1,8(sp)
    80001ca6:	bfe9                	j	80001c80 <devintr+0x28>
      uartintr();
    80001ca8:	00005097          	auipc	ra,0x5
    80001cac:	86e080e7          	jalr	-1938(ra) # 80006516 <uartintr>
    if(irq)
    80001cb0:	a839                	j	80001cce <devintr+0x76>
      virtio_disk_intr();
    80001cb2:	00004097          	auipc	ra,0x4
    80001cb6:	dbe080e7          	jalr	-578(ra) # 80005a70 <virtio_disk_intr>
    if(irq)
    80001cba:	a811                	j	80001cce <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cbc:	85a6                	mv	a1,s1
    80001cbe:	00006517          	auipc	a0,0x6
    80001cc2:	55250513          	addi	a0,a0,1362 # 80008210 <etext+0x210>
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	400080e7          	jalr	1024(ra) # 800060c6 <printf>
      plic_complete(irq);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00004097          	auipc	ra,0x4
    80001cd4:	8f0080e7          	jalr	-1808(ra) # 800055c0 <plic_complete>
    return 1;
    80001cd8:	4505                	li	a0,1
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	b755                	j	80001c80 <devintr+0x28>
    if(cpuid() == 0){
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	158080e7          	jalr	344(ra) # 80000e36 <cpuid>
    80001ce6:	c901                	beqz	a0,80001cf6 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cee:	14479073          	csrw	sip,a5
    return 2;
    80001cf2:	4509                	li	a0,2
    80001cf4:	b771                	j	80001c80 <devintr+0x28>
      clockintr();
    80001cf6:	00000097          	auipc	ra,0x0
    80001cfa:	f1c080e7          	jalr	-228(ra) # 80001c12 <clockintr>
    80001cfe:	b7ed                	j	80001ce8 <devintr+0x90>
}
    80001d00:	8082                	ret

0000000080001d02 <usertrap>:
{
    80001d02:	7139                	addi	sp,sp,-64
    80001d04:	fc06                	sd	ra,56(sp)
    80001d06:	f822                	sd	s0,48(sp)
    80001d08:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d0e:	1007f793          	andi	a5,a5,256
    80001d12:	e7a5                	bnez	a5,80001d7a <usertrap+0x78>
    80001d14:	f426                	sd	s1,40(sp)
    80001d16:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d18:	00003797          	auipc	a5,0x3
    80001d1c:	77878793          	addi	a5,a5,1912 # 80005490 <kernelvec>
    80001d20:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	13e080e7          	jalr	318(ra) # 80000e62 <myproc>
    80001d2c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d2e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d30:	14102773          	csrr	a4,sepc
    80001d34:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d36:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d3a:	47a1                	li	a5,8
    80001d3c:	06f71363          	bne	a4,a5,80001da2 <usertrap+0xa0>
    if(p->killed)
    80001d40:	551c                	lw	a5,40(a0)
    80001d42:	ebb1                	bnez	a5,80001d96 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001d44:	6cb8                	ld	a4,88(s1)
    80001d46:	6f1c                	ld	a5,24(a4)
    80001d48:	0791                	addi	a5,a5,4
    80001d4a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d50:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d54:	10079073          	csrw	sstatus,a5
    syscall();
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	42a080e7          	jalr	1066(ra) # 80002182 <syscall>
  if(p->killed)
    80001d60:	549c                	lw	a5,40(s1)
    80001d62:	1a079c63          	bnez	a5,80001f1a <usertrap+0x218>
  usertrapret();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	e0e080e7          	jalr	-498(ra) # 80001b74 <usertrapret>
    80001d6e:	74a2                	ld	s1,40(sp)
    80001d70:	7902                	ld	s2,32(sp)
}
    80001d72:	70e2                	ld	ra,56(sp)
    80001d74:	7442                	ld	s0,48(sp)
    80001d76:	6121                	addi	sp,sp,64
    80001d78:	8082                	ret
    80001d7a:	f426                	sd	s1,40(sp)
    80001d7c:	f04a                	sd	s2,32(sp)
    80001d7e:	ec4e                	sd	s3,24(sp)
    80001d80:	e852                	sd	s4,16(sp)
    80001d82:	e456                	sd	s5,8(sp)
    80001d84:	e05a                	sd	s6,0(sp)
    panic("usertrap: not from user mode");
    80001d86:	00006517          	auipc	a0,0x6
    80001d8a:	4aa50513          	addi	a0,a0,1194 # 80008230 <etext+0x230>
    80001d8e:	00004097          	auipc	ra,0x4
    80001d92:	2ee080e7          	jalr	750(ra) # 8000607c <panic>
      exit(-1);
    80001d96:	557d                	li	a0,-1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	a26080e7          	jalr	-1498(ra) # 800017be <exit>
    80001da0:	b755                	j	80001d44 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	eb6080e7          	jalr	-330(ra) # 80001c58 <devintr>
    80001daa:	892a                	mv	s2,a0
    80001dac:	16051463          	bnez	a0,80001f14 <usertrap+0x212>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	14202773          	csrr	a4,scause
  else if( r_scause() == 13 || r_scause() == 15 ){
    80001db4:	47b5                	li	a5,13
    80001db6:	00f70763          	beq	a4,a5,80001dc4 <usertrap+0xc2>
    80001dba:	14202773          	csrr	a4,scause
    80001dbe:	47bd                	li	a5,15
    80001dc0:	12f71063          	bne	a4,a5,80001ee0 <usertrap+0x1de>
    80001dc4:	ec4e                	sd	s3,24(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc6:	143029f3          	csrr	s3,stval
    if(va >= p->sz || va > MAXVA || PGROUNDUP(va) == PGROUNDDOWN(p->trapframe->sp)) {
    80001dca:	64bc                	ld	a5,72(s1)
    80001dcc:	00f9ff63          	bgeu	s3,a5,80001dea <usertrap+0xe8>
    80001dd0:	4785                	li	a5,1
    80001dd2:	179a                	slli	a5,a5,0x26
    80001dd4:	0137eb63          	bltu	a5,s3,80001dea <usertrap+0xe8>
    80001dd8:	6cb4                	ld	a3,88(s1)
    80001dda:	6705                	lui	a4,0x1
    80001ddc:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80001de0:	97ce                	add	a5,a5,s3
    80001de2:	7a94                	ld	a3,48(a3)
    80001de4:	8fb5                	xor	a5,a5,a3
    80001de6:	00e7f463          	bgeu	a5,a4,80001dee <usertrap+0xec>
      p->killed = 1;
    80001dea:	4785                	li	a5,1
    80001dec:	d49c                	sw	a5,40(s1)
    for (int i = 0; i < VMASIZE; i++) {
    80001dee:	16848793          	addi	a5,s1,360
    80001df2:	874a                	mv	a4,s2
      if (p->vma[i].valid == 1 && va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) {
    80001df4:	4585                	li	a1,1
    for (int i = 0; i < VMASIZE; i++) {
    80001df6:	4541                	li	a0,16
    80001df8:	a809                	j	80001e0a <usertrap+0x108>
    80001dfa:	69e2                	ld	s3,24(sp)
    80001dfc:	6a42                	ld	s4,16(sp)
    80001dfe:	b78d                	j	80001d60 <usertrap+0x5e>
    80001e00:	2705                	addiw	a4,a4,1
    80001e02:	03078793          	addi	a5,a5,48
    80001e06:	0ca70163          	beq	a4,a0,80001ec8 <usertrap+0x1c6>
      if (p->vma[i].valid == 1 && va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) {
    80001e0a:	4394                	lw	a3,0(a5)
    80001e0c:	feb69ae3          	bne	a3,a1,80001e00 <usertrap+0xfe>
    80001e10:	6794                	ld	a3,8(a5)
    80001e12:	fed9e7e3          	bltu	s3,a3,80001e00 <usertrap+0xfe>
    80001e16:	4b90                	lw	a2,16(a5)
    80001e18:	96b2                	add	a3,a3,a2
    80001e1a:	fed9f3e3          	bgeu	s3,a3,80001e00 <usertrap+0xfe>
    80001e1e:	e852                	sd	s4,16(sp)
        vma = &p->vma[i];
    80001e20:	00171a13          	slli	s4,a4,0x1
    80001e24:	9a3a                	add	s4,s4,a4
    80001e26:	0a12                	slli	s4,s4,0x4
    80001e28:	168a0a13          	addi	s4,s4,360
    80001e2c:	9a26                	add	s4,s4,s1
    if(vma) {
    80001e2e:	fc0a06e3          	beqz	s4,80001dfa <usertrap+0xf8>
    80001e32:	e456                	sd	s5,8(sp)
    80001e34:	e05a                	sd	s6,0(sp)
      uint64 offset = va - vma->addr;
    80001e36:	008a3b03          	ld	s6,8(s4)
      uint64 mem = (uint64)kalloc();
    80001e3a:	ffffe097          	auipc	ra,0xffffe
    80001e3e:	2e0080e7          	jalr	736(ra) # 8000011a <kalloc>
    80001e42:	8aaa                	mv	s5,a0
      if(mem == 0) {
    80001e44:	c96d                	beqz	a0,80001f36 <usertrap+0x234>
      va = PGROUNDDOWN(va);
    80001e46:	77fd                	lui	a5,0xfffff
    80001e48:	00f9f9b3          	and	s3,s3,a5
        memset((void*)mem, 0, PGSIZE);
    80001e4c:	6605                	lui	a2,0x1
    80001e4e:	4581                	li	a1,0
    80001e50:	ffffe097          	auipc	ra,0xffffe
    80001e54:	32a080e7          	jalr	810(ra) # 8000017a <memset>
        ilock(vma->f->ip);
    80001e58:	018a3783          	ld	a5,24(s4)
    80001e5c:	6f88                	ld	a0,24(a5)
    80001e5e:	00001097          	auipc	ra,0x1
    80001e62:	e22080e7          	jalr	-478(ra) # 80002c80 <ilock>
        readi(vma->f->ip, 0, mem, offset, PGSIZE);
    80001e66:	018a3783          	ld	a5,24(s4)
    80001e6a:	6705                	lui	a4,0x1
    80001e6c:	416986bb          	subw	a3,s3,s6
    80001e70:	8656                	mv	a2,s5
    80001e72:	4581                	li	a1,0
    80001e74:	6f88                	ld	a0,24(a5)
    80001e76:	00001097          	auipc	ra,0x1
    80001e7a:	0c2080e7          	jalr	194(ra) # 80002f38 <readi>
        iunlock(vma->f->ip);
    80001e7e:	018a3783          	ld	a5,24(s4)
    80001e82:	6f88                	ld	a0,24(a5)
    80001e84:	00001097          	auipc	ra,0x1
    80001e88:	ec2080e7          	jalr	-318(ra) # 80002d46 <iunlock>
        if(vma->prot & PROT_READ){
    80001e8c:	020a2783          	lw	a5,32(s4)
    80001e90:	0017f693          	andi	a3,a5,1
          flag |= PTE_R;
    80001e94:	4749                	li	a4,18
        if(vma->prot & PROT_READ){
    80001e96:	e291                	bnez	a3,80001e9a <usertrap+0x198>
        int flag = PTE_U;
    80001e98:	4741                	li	a4,16
        if(vma->prot & PROT_WRITE){
    80001e9a:	0027f693          	andi	a3,a5,2
    80001e9e:	c299                	beqz	a3,80001ea4 <usertrap+0x1a2>
          flag |= PTE_W;
    80001ea0:	00476713          	ori	a4,a4,4
        if(vma->prot & PROT_EXEC){
    80001ea4:	8b91                	andi	a5,a5,4
    80001ea6:	c399                	beqz	a5,80001eac <usertrap+0x1aa>
          flag |= PTE_X;
    80001ea8:	00876713          	ori	a4,a4,8
        if(mappages(p->pagetable, va, PGSIZE, mem, flag) != 0) {
    80001eac:	86d6                	mv	a3,s5
    80001eae:	6605                	lui	a2,0x1
    80001eb0:	85ce                	mv	a1,s3
    80001eb2:	68a8                	ld	a0,80(s1)
    80001eb4:	ffffe097          	auipc	ra,0xffffe
    80001eb8:	686080e7          	jalr	1670(ra) # 8000053a <mappages>
    80001ebc:	e901                	bnez	a0,80001ecc <usertrap+0x1ca>
    80001ebe:	69e2                	ld	s3,24(sp)
    80001ec0:	6a42                	ld	s4,16(sp)
    80001ec2:	6aa2                	ld	s5,8(sp)
    80001ec4:	6b02                	ld	s6,0(sp)
    80001ec6:	bd69                	j	80001d60 <usertrap+0x5e>
    80001ec8:	69e2                	ld	s3,24(sp)
    80001eca:	bd59                	j	80001d60 <usertrap+0x5e>
          kfree((void*)mem);
    80001ecc:	8556                	mv	a0,s5
    80001ece:	ffffe097          	auipc	ra,0xffffe
    80001ed2:	14e080e7          	jalr	334(ra) # 8000001c <kfree>
          p->killed = 1;
    80001ed6:	69e2                	ld	s3,24(sp)
    80001ed8:	6a42                	ld	s4,16(sp)
    80001eda:	6aa2                	ld	s5,8(sp)
    80001edc:	6b02                	ld	s6,0(sp)
    80001ede:	a805                	j	80001f0e <usertrap+0x20c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ee4:	5890                	lw	a2,48(s1)
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	36a50513          	addi	a0,a0,874 # 80008250 <etext+0x250>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	1d8080e7          	jalr	472(ra) # 800060c6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efa:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	38250513          	addi	a0,a0,898 # 80008280 <etext+0x280>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	1c0080e7          	jalr	448(ra) # 800060c6 <printf>
          p->killed = 1;
    80001f0e:	4785                	li	a5,1
    80001f10:	d49c                	sw	a5,40(s1)
  if(p->killed)
    80001f12:	a029                	j	80001f1c <usertrap+0x21a>
    80001f14:	549c                	lw	a5,40(s1)
    80001f16:	cb81                	beqz	a5,80001f26 <usertrap+0x224>
    80001f18:	a011                	j	80001f1c <usertrap+0x21a>
    80001f1a:	4901                	li	s2,0
    exit(-1);
    80001f1c:	557d                	li	a0,-1
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	8a0080e7          	jalr	-1888(ra) # 800017be <exit>
  if(which_dev == 2)
    80001f26:	4789                	li	a5,2
    80001f28:	e2f91fe3          	bne	s2,a5,80001d66 <usertrap+0x64>
    yield();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	5fa080e7          	jalr	1530(ra) # 80001526 <yield>
    80001f34:	bd0d                	j	80001d66 <usertrap+0x64>
    80001f36:	69e2                	ld	s3,24(sp)
    80001f38:	6a42                	ld	s4,16(sp)
    80001f3a:	6aa2                	ld	s5,8(sp)
    80001f3c:	6b02                	ld	s6,0(sp)
    80001f3e:	bfc1                	j	80001f0e <usertrap+0x20c>

0000000080001f40 <kerneltrap>:
{
    80001f40:	7179                	addi	sp,sp,-48
    80001f42:	f406                	sd	ra,40(sp)
    80001f44:	f022                	sd	s0,32(sp)
    80001f46:	ec26                	sd	s1,24(sp)
    80001f48:	e84a                	sd	s2,16(sp)
    80001f4a:	e44e                	sd	s3,8(sp)
    80001f4c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f4e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f52:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f56:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f5a:	1004f793          	andi	a5,s1,256
    80001f5e:	cb85                	beqz	a5,80001f8e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f64:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f66:	ef85                	bnez	a5,80001f9e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f68:	00000097          	auipc	ra,0x0
    80001f6c:	cf0080e7          	jalr	-784(ra) # 80001c58 <devintr>
    80001f70:	cd1d                	beqz	a0,80001fae <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f72:	4789                	li	a5,2
    80001f74:	06f50a63          	beq	a0,a5,80001fe8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f78:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f7c:	10049073          	csrw	sstatus,s1
}
    80001f80:	70a2                	ld	ra,40(sp)
    80001f82:	7402                	ld	s0,32(sp)
    80001f84:	64e2                	ld	s1,24(sp)
    80001f86:	6942                	ld	s2,16(sp)
    80001f88:	69a2                	ld	s3,8(sp)
    80001f8a:	6145                	addi	sp,sp,48
    80001f8c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f8e:	00006517          	auipc	a0,0x6
    80001f92:	31250513          	addi	a0,a0,786 # 800082a0 <etext+0x2a0>
    80001f96:	00004097          	auipc	ra,0x4
    80001f9a:	0e6080e7          	jalr	230(ra) # 8000607c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f9e:	00006517          	auipc	a0,0x6
    80001fa2:	32a50513          	addi	a0,a0,810 # 800082c8 <etext+0x2c8>
    80001fa6:	00004097          	auipc	ra,0x4
    80001faa:	0d6080e7          	jalr	214(ra) # 8000607c <panic>
    printf("scause %p\n", scause);
    80001fae:	85ce                	mv	a1,s3
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	33850513          	addi	a0,a0,824 # 800082e8 <etext+0x2e8>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	10e080e7          	jalr	270(ra) # 800060c6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fc0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fc4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc8:	00006517          	auipc	a0,0x6
    80001fcc:	33050513          	addi	a0,a0,816 # 800082f8 <etext+0x2f8>
    80001fd0:	00004097          	auipc	ra,0x4
    80001fd4:	0f6080e7          	jalr	246(ra) # 800060c6 <printf>
    panic("kerneltrap");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	33850513          	addi	a0,a0,824 # 80008310 <etext+0x310>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	09c080e7          	jalr	156(ra) # 8000607c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	e7a080e7          	jalr	-390(ra) # 80000e62 <myproc>
    80001ff0:	d541                	beqz	a0,80001f78 <kerneltrap+0x38>
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	e70080e7          	jalr	-400(ra) # 80000e62 <myproc>
    80001ffa:	4d18                	lw	a4,24(a0)
    80001ffc:	4791                	li	a5,4
    80001ffe:	f6f71de3          	bne	a4,a5,80001f78 <kerneltrap+0x38>
    yield();
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	524080e7          	jalr	1316(ra) # 80001526 <yield>
    8000200a:	b7bd                	j	80001f78 <kerneltrap+0x38>

000000008000200c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	e4a080e7          	jalr	-438(ra) # 80000e62 <myproc>
  switch (n) {
    80002020:	4795                	li	a5,5
    80002022:	0497e163          	bltu	a5,s1,80002064 <argraw+0x58>
    80002026:	048a                	slli	s1,s1,0x2
    80002028:	00006717          	auipc	a4,0x6
    8000202c:	6d070713          	addi	a4,a4,1744 # 800086f8 <states.0+0x30>
    80002030:	94ba                	add	s1,s1,a4
    80002032:	409c                	lw	a5,0(s1)
    80002034:	97ba                	add	a5,a5,a4
    80002036:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002038:	6d3c                	ld	a5,88(a0)
    8000203a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret
    return p->trapframe->a1;
    80002046:	6d3c                	ld	a5,88(a0)
    80002048:	7fa8                	ld	a0,120(a5)
    8000204a:	bfcd                	j	8000203c <argraw+0x30>
    return p->trapframe->a2;
    8000204c:	6d3c                	ld	a5,88(a0)
    8000204e:	63c8                	ld	a0,128(a5)
    80002050:	b7f5                	j	8000203c <argraw+0x30>
    return p->trapframe->a3;
    80002052:	6d3c                	ld	a5,88(a0)
    80002054:	67c8                	ld	a0,136(a5)
    80002056:	b7dd                	j	8000203c <argraw+0x30>
    return p->trapframe->a4;
    80002058:	6d3c                	ld	a5,88(a0)
    8000205a:	6bc8                	ld	a0,144(a5)
    8000205c:	b7c5                	j	8000203c <argraw+0x30>
    return p->trapframe->a5;
    8000205e:	6d3c                	ld	a5,88(a0)
    80002060:	6fc8                	ld	a0,152(a5)
    80002062:	bfe9                	j	8000203c <argraw+0x30>
  panic("argraw");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	2bc50513          	addi	a0,a0,700 # 80008320 <etext+0x320>
    8000206c:	00004097          	auipc	ra,0x4
    80002070:	010080e7          	jalr	16(ra) # 8000607c <panic>

0000000080002074 <fetchaddr>:
{
    80002074:	1101                	addi	sp,sp,-32
    80002076:	ec06                	sd	ra,24(sp)
    80002078:	e822                	sd	s0,16(sp)
    8000207a:	e426                	sd	s1,8(sp)
    8000207c:	e04a                	sd	s2,0(sp)
    8000207e:	1000                	addi	s0,sp,32
    80002080:	84aa                	mv	s1,a0
    80002082:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	dde080e7          	jalr	-546(ra) # 80000e62 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000208c:	653c                	ld	a5,72(a0)
    8000208e:	02f4f863          	bgeu	s1,a5,800020be <fetchaddr+0x4a>
    80002092:	00848713          	addi	a4,s1,8
    80002096:	02e7e663          	bltu	a5,a4,800020c2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000209a:	46a1                	li	a3,8
    8000209c:	8626                	mv	a2,s1
    8000209e:	85ca                	mv	a1,s2
    800020a0:	6928                	ld	a0,80(a0)
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	ae8080e7          	jalr	-1304(ra) # 80000b8a <copyin>
    800020aa:	00a03533          	snez	a0,a0
    800020ae:	40a00533          	neg	a0,a0
}
    800020b2:	60e2                	ld	ra,24(sp)
    800020b4:	6442                	ld	s0,16(sp)
    800020b6:	64a2                	ld	s1,8(sp)
    800020b8:	6902                	ld	s2,0(sp)
    800020ba:	6105                	addi	sp,sp,32
    800020bc:	8082                	ret
    return -1;
    800020be:	557d                	li	a0,-1
    800020c0:	bfcd                	j	800020b2 <fetchaddr+0x3e>
    800020c2:	557d                	li	a0,-1
    800020c4:	b7fd                	j	800020b2 <fetchaddr+0x3e>

00000000800020c6 <fetchstr>:
{
    800020c6:	7179                	addi	sp,sp,-48
    800020c8:	f406                	sd	ra,40(sp)
    800020ca:	f022                	sd	s0,32(sp)
    800020cc:	ec26                	sd	s1,24(sp)
    800020ce:	e84a                	sd	s2,16(sp)
    800020d0:	e44e                	sd	s3,8(sp)
    800020d2:	1800                	addi	s0,sp,48
    800020d4:	892a                	mv	s2,a0
    800020d6:	84ae                	mv	s1,a1
    800020d8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	d88080e7          	jalr	-632(ra) # 80000e62 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020e2:	86ce                	mv	a3,s3
    800020e4:	864a                	mv	a2,s2
    800020e6:	85a6                	mv	a1,s1
    800020e8:	6928                	ld	a0,80(a0)
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	b2e080e7          	jalr	-1234(ra) # 80000c18 <copyinstr>
  if(err < 0)
    800020f2:	00054763          	bltz	a0,80002100 <fetchstr+0x3a>
  return strlen(buf);
    800020f6:	8526                	mv	a0,s1
    800020f8:	ffffe097          	auipc	ra,0xffffe
    800020fc:	1f6080e7          	jalr	502(ra) # 800002ee <strlen>
}
    80002100:	70a2                	ld	ra,40(sp)
    80002102:	7402                	ld	s0,32(sp)
    80002104:	64e2                	ld	s1,24(sp)
    80002106:	6942                	ld	s2,16(sp)
    80002108:	69a2                	ld	s3,8(sp)
    8000210a:	6145                	addi	sp,sp,48
    8000210c:	8082                	ret

000000008000210e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	1000                	addi	s0,sp,32
    80002118:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	ef2080e7          	jalr	-270(ra) # 8000200c <argraw>
    80002122:	c088                	sw	a0,0(s1)
  return 0;
}
    80002124:	4501                	li	a0,0
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	64a2                	ld	s1,8(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002130:	1101                	addi	sp,sp,-32
    80002132:	ec06                	sd	ra,24(sp)
    80002134:	e822                	sd	s0,16(sp)
    80002136:	e426                	sd	s1,8(sp)
    80002138:	1000                	addi	s0,sp,32
    8000213a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	ed0080e7          	jalr	-304(ra) # 8000200c <argraw>
    80002144:	e088                	sd	a0,0(s1)
  return 0;
}
    80002146:	4501                	li	a0,0
    80002148:	60e2                	ld	ra,24(sp)
    8000214a:	6442                	ld	s0,16(sp)
    8000214c:	64a2                	ld	s1,8(sp)
    8000214e:	6105                	addi	sp,sp,32
    80002150:	8082                	ret

0000000080002152 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002152:	1101                	addi	sp,sp,-32
    80002154:	ec06                	sd	ra,24(sp)
    80002156:	e822                	sd	s0,16(sp)
    80002158:	e426                	sd	s1,8(sp)
    8000215a:	e04a                	sd	s2,0(sp)
    8000215c:	1000                	addi	s0,sp,32
    8000215e:	84ae                	mv	s1,a1
    80002160:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002162:	00000097          	auipc	ra,0x0
    80002166:	eaa080e7          	jalr	-342(ra) # 8000200c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000216a:	864a                	mv	a2,s2
    8000216c:	85a6                	mv	a1,s1
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f58080e7          	jalr	-168(ra) # 800020c6 <fetchstr>
}
    80002176:	60e2                	ld	ra,24(sp)
    80002178:	6442                	ld	s0,16(sp)
    8000217a:	64a2                	ld	s1,8(sp)
    8000217c:	6902                	ld	s2,0(sp)
    8000217e:	6105                	addi	sp,sp,32
    80002180:	8082                	ret

0000000080002182 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002182:	1101                	addi	sp,sp,-32
    80002184:	ec06                	sd	ra,24(sp)
    80002186:	e822                	sd	s0,16(sp)
    80002188:	e426                	sd	s1,8(sp)
    8000218a:	e04a                	sd	s2,0(sp)
    8000218c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	cd4080e7          	jalr	-812(ra) # 80000e62 <myproc>
    80002196:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002198:	05853903          	ld	s2,88(a0)
    8000219c:	0a893783          	ld	a5,168(s2)
    800021a0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a4:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffc9dbf>
    800021a6:	4759                	li	a4,22
    800021a8:	00f76f63          	bltu	a4,a5,800021c6 <syscall+0x44>
    800021ac:	00369713          	slli	a4,a3,0x3
    800021b0:	00006797          	auipc	a5,0x6
    800021b4:	56078793          	addi	a5,a5,1376 # 80008710 <syscalls>
    800021b8:	97ba                	add	a5,a5,a4
    800021ba:	639c                	ld	a5,0(a5)
    800021bc:	c789                	beqz	a5,800021c6 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021be:	9782                	jalr	a5
    800021c0:	06a93823          	sd	a0,112(s2)
    800021c4:	a839                	j	800021e2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021c6:	15848613          	addi	a2,s1,344
    800021ca:	588c                	lw	a1,48(s1)
    800021cc:	00006517          	auipc	a0,0x6
    800021d0:	15c50513          	addi	a0,a0,348 # 80008328 <etext+0x328>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	ef2080e7          	jalr	-270(ra) # 800060c6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021dc:	6cbc                	ld	a5,88(s1)
    800021de:	577d                	li	a4,-1
    800021e0:	fbb8                	sd	a4,112(a5)
  }
}
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	64a2                	ld	s1,8(sp)
    800021e8:	6902                	ld	s2,0(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021f6:	fec40593          	addi	a1,s0,-20
    800021fa:	4501                	li	a0,0
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	f12080e7          	jalr	-238(ra) # 8000210e <argint>
    return -1;
    80002204:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002206:	00054963          	bltz	a0,80002218 <sys_exit+0x2a>
  exit(n);
    8000220a:	fec42503          	lw	a0,-20(s0)
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	5b0080e7          	jalr	1456(ra) # 800017be <exit>
  return 0;  // not reached
    80002216:	4781                	li	a5,0
}
    80002218:	853e                	mv	a0,a5
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002222:	1141                	addi	sp,sp,-16
    80002224:	e406                	sd	ra,8(sp)
    80002226:	e022                	sd	s0,0(sp)
    80002228:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	c38080e7          	jalr	-968(ra) # 80000e62 <myproc>
}
    80002232:	5908                	lw	a0,48(a0)
    80002234:	60a2                	ld	ra,8(sp)
    80002236:	6402                	ld	s0,0(sp)
    80002238:	0141                	addi	sp,sp,16
    8000223a:	8082                	ret

000000008000223c <sys_fork>:

uint64
sys_fork(void)
{
    8000223c:	1141                	addi	sp,sp,-16
    8000223e:	e406                	sd	ra,8(sp)
    80002240:	e022                	sd	s0,0(sp)
    80002242:	0800                	addi	s0,sp,16
  return fork();
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	ff0080e7          	jalr	-16(ra) # 80001234 <fork>
}
    8000224c:	60a2                	ld	ra,8(sp)
    8000224e:	6402                	ld	s0,0(sp)
    80002250:	0141                	addi	sp,sp,16
    80002252:	8082                	ret

0000000080002254 <sys_wait>:

uint64
sys_wait(void)
{
    80002254:	1101                	addi	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000225c:	fe840593          	addi	a1,s0,-24
    80002260:	4501                	li	a0,0
    80002262:	00000097          	auipc	ra,0x0
    80002266:	ece080e7          	jalr	-306(ra) # 80002130 <argaddr>
    8000226a:	87aa                	mv	a5,a0
    return -1;
    8000226c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000226e:	0007c863          	bltz	a5,8000227e <sys_wait+0x2a>
  return wait(p);
    80002272:	fe843503          	ld	a0,-24(s0)
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	350080e7          	jalr	848(ra) # 800015c6 <wait>
}
    8000227e:	60e2                	ld	ra,24(sp)
    80002280:	6442                	ld	s0,16(sp)
    80002282:	6105                	addi	sp,sp,32
    80002284:	8082                	ret

0000000080002286 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000228e:	fdc40593          	addi	a1,s0,-36
    80002292:	4501                	li	a0,0
    80002294:	00000097          	auipc	ra,0x0
    80002298:	e7a080e7          	jalr	-390(ra) # 8000210e <argint>
    8000229c:	87aa                	mv	a5,a0
    return -1;
    8000229e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022a0:	0207c263          	bltz	a5,800022c4 <sys_sbrk+0x3e>
    800022a4:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	bbc080e7          	jalr	-1092(ra) # 80000e62 <myproc>
    800022ae:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022b0:	fdc42503          	lw	a0,-36(s0)
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	f08080e7          	jalr	-248(ra) # 800011bc <growproc>
    800022bc:	00054863          	bltz	a0,800022cc <sys_sbrk+0x46>
    return -1;
  return addr;
    800022c0:	8526                	mv	a0,s1
    800022c2:	64e2                	ld	s1,24(sp)
}
    800022c4:	70a2                	ld	ra,40(sp)
    800022c6:	7402                	ld	s0,32(sp)
    800022c8:	6145                	addi	sp,sp,48
    800022ca:	8082                	ret
    return -1;
    800022cc:	557d                	li	a0,-1
    800022ce:	64e2                	ld	s1,24(sp)
    800022d0:	bfd5                	j	800022c4 <sys_sbrk+0x3e>

00000000800022d2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022d2:	7139                	addi	sp,sp,-64
    800022d4:	fc06                	sd	ra,56(sp)
    800022d6:	f822                	sd	s0,48(sp)
    800022d8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022da:	fcc40593          	addi	a1,s0,-52
    800022de:	4501                	li	a0,0
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	e2e080e7          	jalr	-466(ra) # 8000210e <argint>
    return -1;
    800022e8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022ea:	06054b63          	bltz	a0,80002360 <sys_sleep+0x8e>
    800022ee:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800022f0:	0001c517          	auipc	a0,0x1c
    800022f4:	b9050513          	addi	a0,a0,-1136 # 8001de80 <tickslock>
    800022f8:	00004097          	auipc	ra,0x4
    800022fc:	2fe080e7          	jalr	766(ra) # 800065f6 <acquire>
  ticks0 = ticks;
    80002300:	0000a917          	auipc	s2,0xa
    80002304:	d1892903          	lw	s2,-744(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    80002308:	fcc42783          	lw	a5,-52(s0)
    8000230c:	c3a1                	beqz	a5,8000234c <sys_sleep+0x7a>
    8000230e:	f426                	sd	s1,40(sp)
    80002310:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002312:	0001c997          	auipc	s3,0x1c
    80002316:	b6e98993          	addi	s3,s3,-1170 # 8001de80 <tickslock>
    8000231a:	0000a497          	auipc	s1,0xa
    8000231e:	cfe48493          	addi	s1,s1,-770 # 8000c018 <ticks>
    if(myproc()->killed){
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	b40080e7          	jalr	-1216(ra) # 80000e62 <myproc>
    8000232a:	551c                	lw	a5,40(a0)
    8000232c:	ef9d                	bnez	a5,8000236a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000232e:	85ce                	mv	a1,s3
    80002330:	8526                	mv	a0,s1
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	230080e7          	jalr	560(ra) # 80001562 <sleep>
  while(ticks - ticks0 < n){
    8000233a:	409c                	lw	a5,0(s1)
    8000233c:	412787bb          	subw	a5,a5,s2
    80002340:	fcc42703          	lw	a4,-52(s0)
    80002344:	fce7efe3          	bltu	a5,a4,80002322 <sys_sleep+0x50>
    80002348:	74a2                	ld	s1,40(sp)
    8000234a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000234c:	0001c517          	auipc	a0,0x1c
    80002350:	b3450513          	addi	a0,a0,-1228 # 8001de80 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	356080e7          	jalr	854(ra) # 800066aa <release>
  return 0;
    8000235c:	4781                	li	a5,0
    8000235e:	7902                	ld	s2,32(sp)
}
    80002360:	853e                	mv	a0,a5
    80002362:	70e2                	ld	ra,56(sp)
    80002364:	7442                	ld	s0,48(sp)
    80002366:	6121                	addi	sp,sp,64
    80002368:	8082                	ret
      release(&tickslock);
    8000236a:	0001c517          	auipc	a0,0x1c
    8000236e:	b1650513          	addi	a0,a0,-1258 # 8001de80 <tickslock>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	338080e7          	jalr	824(ra) # 800066aa <release>
      return -1;
    8000237a:	57fd                	li	a5,-1
    8000237c:	74a2                	ld	s1,40(sp)
    8000237e:	7902                	ld	s2,32(sp)
    80002380:	69e2                	ld	s3,24(sp)
    80002382:	bff9                	j	80002360 <sys_sleep+0x8e>

0000000080002384 <sys_kill>:

uint64
sys_kill(void)
{
    80002384:	1101                	addi	sp,sp,-32
    80002386:	ec06                	sd	ra,24(sp)
    80002388:	e822                	sd	s0,16(sp)
    8000238a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000238c:	fec40593          	addi	a1,s0,-20
    80002390:	4501                	li	a0,0
    80002392:	00000097          	auipc	ra,0x0
    80002396:	d7c080e7          	jalr	-644(ra) # 8000210e <argint>
    8000239a:	87aa                	mv	a5,a0
    return -1;
    8000239c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000239e:	0007c863          	bltz	a5,800023ae <sys_kill+0x2a>
  return kill(pid);
    800023a2:	fec42503          	lw	a0,-20(s0)
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	556080e7          	jalr	1366(ra) # 800018fc <kill>
}
    800023ae:	60e2                	ld	ra,24(sp)
    800023b0:	6442                	ld	s0,16(sp)
    800023b2:	6105                	addi	sp,sp,32
    800023b4:	8082                	ret

00000000800023b6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023b6:	1101                	addi	sp,sp,-32
    800023b8:	ec06                	sd	ra,24(sp)
    800023ba:	e822                	sd	s0,16(sp)
    800023bc:	e426                	sd	s1,8(sp)
    800023be:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023c0:	0001c517          	auipc	a0,0x1c
    800023c4:	ac050513          	addi	a0,a0,-1344 # 8001de80 <tickslock>
    800023c8:	00004097          	auipc	ra,0x4
    800023cc:	22e080e7          	jalr	558(ra) # 800065f6 <acquire>
  xticks = ticks;
    800023d0:	0000a497          	auipc	s1,0xa
    800023d4:	c484a483          	lw	s1,-952(s1) # 8000c018 <ticks>
  release(&tickslock);
    800023d8:	0001c517          	auipc	a0,0x1c
    800023dc:	aa850513          	addi	a0,a0,-1368 # 8001de80 <tickslock>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	2ca080e7          	jalr	714(ra) # 800066aa <release>
  return xticks;
}
    800023e8:	02049513          	slli	a0,s1,0x20
    800023ec:	9101                	srli	a0,a0,0x20
    800023ee:	60e2                	ld	ra,24(sp)
    800023f0:	6442                	ld	s0,16(sp)
    800023f2:	64a2                	ld	s1,8(sp)
    800023f4:	6105                	addi	sp,sp,32
    800023f6:	8082                	ret

00000000800023f8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	e052                	sd	s4,0(sp)
    80002406:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002408:	00006597          	auipc	a1,0x6
    8000240c:	f4058593          	addi	a1,a1,-192 # 80008348 <etext+0x348>
    80002410:	0001c517          	auipc	a0,0x1c
    80002414:	a8850513          	addi	a0,a0,-1400 # 8001de98 <bcache>
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	14e080e7          	jalr	334(ra) # 80006566 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002420:	00024797          	auipc	a5,0x24
    80002424:	a7878793          	addi	a5,a5,-1416 # 80025e98 <bcache+0x8000>
    80002428:	00024717          	auipc	a4,0x24
    8000242c:	cd870713          	addi	a4,a4,-808 # 80026100 <bcache+0x8268>
    80002430:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002434:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002438:	0001c497          	auipc	s1,0x1c
    8000243c:	a7848493          	addi	s1,s1,-1416 # 8001deb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002440:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002442:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002444:	00006a17          	auipc	s4,0x6
    80002448:	f0ca0a13          	addi	s4,s4,-244 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    8000244c:	2b893783          	ld	a5,696(s2)
    80002450:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002452:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002456:	85d2                	mv	a1,s4
    80002458:	01048513          	addi	a0,s1,16
    8000245c:	00001097          	auipc	ra,0x1
    80002460:	4b2080e7          	jalr	1202(ra) # 8000390e <initsleeplock>
    bcache.head.next->prev = b;
    80002464:	2b893783          	ld	a5,696(s2)
    80002468:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000246a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000246e:	45848493          	addi	s1,s1,1112
    80002472:	fd349de3          	bne	s1,s3,8000244c <binit+0x54>
  }
}
    80002476:	70a2                	ld	ra,40(sp)
    80002478:	7402                	ld	s0,32(sp)
    8000247a:	64e2                	ld	s1,24(sp)
    8000247c:	6942                	ld	s2,16(sp)
    8000247e:	69a2                	ld	s3,8(sp)
    80002480:	6a02                	ld	s4,0(sp)
    80002482:	6145                	addi	sp,sp,48
    80002484:	8082                	ret

0000000080002486 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	1800                	addi	s0,sp,48
    80002494:	892a                	mv	s2,a0
    80002496:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002498:	0001c517          	auipc	a0,0x1c
    8000249c:	a0050513          	addi	a0,a0,-1536 # 8001de98 <bcache>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	156080e7          	jalr	342(ra) # 800065f6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024a8:	00024497          	auipc	s1,0x24
    800024ac:	ca84b483          	ld	s1,-856(s1) # 80026150 <bcache+0x82b8>
    800024b0:	00024797          	auipc	a5,0x24
    800024b4:	c5078793          	addi	a5,a5,-944 # 80026100 <bcache+0x8268>
    800024b8:	02f48f63          	beq	s1,a5,800024f6 <bread+0x70>
    800024bc:	873e                	mv	a4,a5
    800024be:	a021                	j	800024c6 <bread+0x40>
    800024c0:	68a4                	ld	s1,80(s1)
    800024c2:	02e48a63          	beq	s1,a4,800024f6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024c6:	449c                	lw	a5,8(s1)
    800024c8:	ff279ce3          	bne	a5,s2,800024c0 <bread+0x3a>
    800024cc:	44dc                	lw	a5,12(s1)
    800024ce:	ff3799e3          	bne	a5,s3,800024c0 <bread+0x3a>
      b->refcnt++;
    800024d2:	40bc                	lw	a5,64(s1)
    800024d4:	2785                	addiw	a5,a5,1
    800024d6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d8:	0001c517          	auipc	a0,0x1c
    800024dc:	9c050513          	addi	a0,a0,-1600 # 8001de98 <bcache>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	1ca080e7          	jalr	458(ra) # 800066aa <release>
      acquiresleep(&b->lock);
    800024e8:	01048513          	addi	a0,s1,16
    800024ec:	00001097          	auipc	ra,0x1
    800024f0:	45c080e7          	jalr	1116(ra) # 80003948 <acquiresleep>
      return b;
    800024f4:	a8b9                	j	80002552 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f6:	00024497          	auipc	s1,0x24
    800024fa:	c524b483          	ld	s1,-942(s1) # 80026148 <bcache+0x82b0>
    800024fe:	00024797          	auipc	a5,0x24
    80002502:	c0278793          	addi	a5,a5,-1022 # 80026100 <bcache+0x8268>
    80002506:	00f48863          	beq	s1,a5,80002516 <bread+0x90>
    8000250a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000250c:	40bc                	lw	a5,64(s1)
    8000250e:	cf81                	beqz	a5,80002526 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002510:	64a4                	ld	s1,72(s1)
    80002512:	fee49de3          	bne	s1,a4,8000250c <bread+0x86>
  panic("bget: no buffers");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	e4250513          	addi	a0,a0,-446 # 80008358 <etext+0x358>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	b5e080e7          	jalr	-1186(ra) # 8000607c <panic>
      b->dev = dev;
    80002526:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000252a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000252e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002532:	4785                	li	a5,1
    80002534:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002536:	0001c517          	auipc	a0,0x1c
    8000253a:	96250513          	addi	a0,a0,-1694 # 8001de98 <bcache>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	16c080e7          	jalr	364(ra) # 800066aa <release>
      acquiresleep(&b->lock);
    80002546:	01048513          	addi	a0,s1,16
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	3fe080e7          	jalr	1022(ra) # 80003948 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002552:	409c                	lw	a5,0(s1)
    80002554:	cb89                	beqz	a5,80002566 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002556:	8526                	mv	a0,s1
    80002558:	70a2                	ld	ra,40(sp)
    8000255a:	7402                	ld	s0,32(sp)
    8000255c:	64e2                	ld	s1,24(sp)
    8000255e:	6942                	ld	s2,16(sp)
    80002560:	69a2                	ld	s3,8(sp)
    80002562:	6145                	addi	sp,sp,48
    80002564:	8082                	ret
    virtio_disk_rw(b, 0);
    80002566:	4581                	li	a1,0
    80002568:	8526                	mv	a0,s1
    8000256a:	00003097          	auipc	ra,0x3
    8000256e:	278080e7          	jalr	632(ra) # 800057e2 <virtio_disk_rw>
    b->valid = 1;
    80002572:	4785                	li	a5,1
    80002574:	c09c                	sw	a5,0(s1)
  return b;
    80002576:	b7c5                	j	80002556 <bread+0xd0>

0000000080002578 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
    80002582:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002584:	0541                	addi	a0,a0,16
    80002586:	00001097          	auipc	ra,0x1
    8000258a:	45c080e7          	jalr	1116(ra) # 800039e2 <holdingsleep>
    8000258e:	cd01                	beqz	a0,800025a6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002590:	4585                	li	a1,1
    80002592:	8526                	mv	a0,s1
    80002594:	00003097          	auipc	ra,0x3
    80002598:	24e080e7          	jalr	590(ra) # 800057e2 <virtio_disk_rw>
}
    8000259c:	60e2                	ld	ra,24(sp)
    8000259e:	6442                	ld	s0,16(sp)
    800025a0:	64a2                	ld	s1,8(sp)
    800025a2:	6105                	addi	sp,sp,32
    800025a4:	8082                	ret
    panic("bwrite");
    800025a6:	00006517          	auipc	a0,0x6
    800025aa:	dca50513          	addi	a0,a0,-566 # 80008370 <etext+0x370>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	ace080e7          	jalr	-1330(ra) # 8000607c <panic>

00000000800025b6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025b6:	1101                	addi	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	e04a                	sd	s2,0(sp)
    800025c0:	1000                	addi	s0,sp,32
    800025c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c4:	01050913          	addi	s2,a0,16
    800025c8:	854a                	mv	a0,s2
    800025ca:	00001097          	auipc	ra,0x1
    800025ce:	418080e7          	jalr	1048(ra) # 800039e2 <holdingsleep>
    800025d2:	c925                	beqz	a0,80002642 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800025d4:	854a                	mv	a0,s2
    800025d6:	00001097          	auipc	ra,0x1
    800025da:	3c8080e7          	jalr	968(ra) # 8000399e <releasesleep>

  acquire(&bcache.lock);
    800025de:	0001c517          	auipc	a0,0x1c
    800025e2:	8ba50513          	addi	a0,a0,-1862 # 8001de98 <bcache>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	010080e7          	jalr	16(ra) # 800065f6 <acquire>
  b->refcnt--;
    800025ee:	40bc                	lw	a5,64(s1)
    800025f0:	37fd                	addiw	a5,a5,-1
    800025f2:	0007871b          	sext.w	a4,a5
    800025f6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025f8:	e71d                	bnez	a4,80002626 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025fa:	68b8                	ld	a4,80(s1)
    800025fc:	64bc                	ld	a5,72(s1)
    800025fe:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002600:	68b8                	ld	a4,80(s1)
    80002602:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002604:	00024797          	auipc	a5,0x24
    80002608:	89478793          	addi	a5,a5,-1900 # 80025e98 <bcache+0x8000>
    8000260c:	2b87b703          	ld	a4,696(a5)
    80002610:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002612:	00024717          	auipc	a4,0x24
    80002616:	aee70713          	addi	a4,a4,-1298 # 80026100 <bcache+0x8268>
    8000261a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000261c:	2b87b703          	ld	a4,696(a5)
    80002620:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002622:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002626:	0001c517          	auipc	a0,0x1c
    8000262a:	87250513          	addi	a0,a0,-1934 # 8001de98 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	07c080e7          	jalr	124(ra) # 800066aa <release>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6902                	ld	s2,0(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret
    panic("brelse");
    80002642:	00006517          	auipc	a0,0x6
    80002646:	d3650513          	addi	a0,a0,-714 # 80008378 <etext+0x378>
    8000264a:	00004097          	auipc	ra,0x4
    8000264e:	a32080e7          	jalr	-1486(ra) # 8000607c <panic>

0000000080002652 <bpin>:

void
bpin(struct buf *b) {
    80002652:	1101                	addi	sp,sp,-32
    80002654:	ec06                	sd	ra,24(sp)
    80002656:	e822                	sd	s0,16(sp)
    80002658:	e426                	sd	s1,8(sp)
    8000265a:	1000                	addi	s0,sp,32
    8000265c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000265e:	0001c517          	auipc	a0,0x1c
    80002662:	83a50513          	addi	a0,a0,-1990 # 8001de98 <bcache>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	f90080e7          	jalr	-112(ra) # 800065f6 <acquire>
  b->refcnt++;
    8000266e:	40bc                	lw	a5,64(s1)
    80002670:	2785                	addiw	a5,a5,1
    80002672:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002674:	0001c517          	auipc	a0,0x1c
    80002678:	82450513          	addi	a0,a0,-2012 # 8001de98 <bcache>
    8000267c:	00004097          	auipc	ra,0x4
    80002680:	02e080e7          	jalr	46(ra) # 800066aa <release>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret

000000008000268e <bunpin>:

void
bunpin(struct buf *b) {
    8000268e:	1101                	addi	sp,sp,-32
    80002690:	ec06                	sd	ra,24(sp)
    80002692:	e822                	sd	s0,16(sp)
    80002694:	e426                	sd	s1,8(sp)
    80002696:	1000                	addi	s0,sp,32
    80002698:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000269a:	0001b517          	auipc	a0,0x1b
    8000269e:	7fe50513          	addi	a0,a0,2046 # 8001de98 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	f54080e7          	jalr	-172(ra) # 800065f6 <acquire>
  b->refcnt--;
    800026aa:	40bc                	lw	a5,64(s1)
    800026ac:	37fd                	addiw	a5,a5,-1
    800026ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026b0:	0001b517          	auipc	a0,0x1b
    800026b4:	7e850513          	addi	a0,a0,2024 # 8001de98 <bcache>
    800026b8:	00004097          	auipc	ra,0x4
    800026bc:	ff2080e7          	jalr	-14(ra) # 800066aa <release>
}
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret

00000000800026ca <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ca:	1101                	addi	sp,sp,-32
    800026cc:	ec06                	sd	ra,24(sp)
    800026ce:	e822                	sd	s0,16(sp)
    800026d0:	e426                	sd	s1,8(sp)
    800026d2:	e04a                	sd	s2,0(sp)
    800026d4:	1000                	addi	s0,sp,32
    800026d6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026d8:	00d5d59b          	srliw	a1,a1,0xd
    800026dc:	00024797          	auipc	a5,0x24
    800026e0:	e987a783          	lw	a5,-360(a5) # 80026574 <sb+0x1c>
    800026e4:	9dbd                	addw	a1,a1,a5
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	da0080e7          	jalr	-608(ra) # 80002486 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026ee:	0074f713          	andi	a4,s1,7
    800026f2:	4785                	li	a5,1
    800026f4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026f8:	14ce                	slli	s1,s1,0x33
    800026fa:	90d9                	srli	s1,s1,0x36
    800026fc:	00950733          	add	a4,a0,s1
    80002700:	05874703          	lbu	a4,88(a4)
    80002704:	00e7f6b3          	and	a3,a5,a4
    80002708:	c69d                	beqz	a3,80002736 <bfree+0x6c>
    8000270a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000270c:	94aa                	add	s1,s1,a0
    8000270e:	fff7c793          	not	a5,a5
    80002712:	8f7d                	and	a4,a4,a5
    80002714:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002718:	00001097          	auipc	ra,0x1
    8000271c:	112080e7          	jalr	274(ra) # 8000382a <log_write>
  brelse(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	00000097          	auipc	ra,0x0
    80002726:	e94080e7          	jalr	-364(ra) # 800025b6 <brelse>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6902                	ld	s2,0(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    panic("freeing free block");
    80002736:	00006517          	auipc	a0,0x6
    8000273a:	c4a50513          	addi	a0,a0,-950 # 80008380 <etext+0x380>
    8000273e:	00004097          	auipc	ra,0x4
    80002742:	93e080e7          	jalr	-1730(ra) # 8000607c <panic>

0000000080002746 <balloc>:
{
    80002746:	711d                	addi	sp,sp,-96
    80002748:	ec86                	sd	ra,88(sp)
    8000274a:	e8a2                	sd	s0,80(sp)
    8000274c:	e4a6                	sd	s1,72(sp)
    8000274e:	e0ca                	sd	s2,64(sp)
    80002750:	fc4e                	sd	s3,56(sp)
    80002752:	f852                	sd	s4,48(sp)
    80002754:	f456                	sd	s5,40(sp)
    80002756:	f05a                	sd	s6,32(sp)
    80002758:	ec5e                	sd	s7,24(sp)
    8000275a:	e862                	sd	s8,16(sp)
    8000275c:	e466                	sd	s9,8(sp)
    8000275e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002760:	00024797          	auipc	a5,0x24
    80002764:	dfc7a783          	lw	a5,-516(a5) # 8002655c <sb+0x4>
    80002768:	cbc1                	beqz	a5,800027f8 <balloc+0xb2>
    8000276a:	8baa                	mv	s7,a0
    8000276c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000276e:	00024b17          	auipc	s6,0x24
    80002772:	deab0b13          	addi	s6,s6,-534 # 80026558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002776:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002778:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000277a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000277c:	6c89                	lui	s9,0x2
    8000277e:	a831                	j	8000279a <balloc+0x54>
    brelse(bp);
    80002780:	854a                	mv	a0,s2
    80002782:	00000097          	auipc	ra,0x0
    80002786:	e34080e7          	jalr	-460(ra) # 800025b6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000278a:	015c87bb          	addw	a5,s9,s5
    8000278e:	00078a9b          	sext.w	s5,a5
    80002792:	004b2703          	lw	a4,4(s6)
    80002796:	06eaf163          	bgeu	s5,a4,800027f8 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000279a:	41fad79b          	sraiw	a5,s5,0x1f
    8000279e:	0137d79b          	srliw	a5,a5,0x13
    800027a2:	015787bb          	addw	a5,a5,s5
    800027a6:	40d7d79b          	sraiw	a5,a5,0xd
    800027aa:	01cb2583          	lw	a1,28(s6)
    800027ae:	9dbd                	addw	a1,a1,a5
    800027b0:	855e                	mv	a0,s7
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	cd4080e7          	jalr	-812(ra) # 80002486 <bread>
    800027ba:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027bc:	004b2503          	lw	a0,4(s6)
    800027c0:	000a849b          	sext.w	s1,s5
    800027c4:	8762                	mv	a4,s8
    800027c6:	faa4fde3          	bgeu	s1,a0,80002780 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027ca:	00777693          	andi	a3,a4,7
    800027ce:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027d2:	41f7579b          	sraiw	a5,a4,0x1f
    800027d6:	01d7d79b          	srliw	a5,a5,0x1d
    800027da:	9fb9                	addw	a5,a5,a4
    800027dc:	4037d79b          	sraiw	a5,a5,0x3
    800027e0:	00f90633          	add	a2,s2,a5
    800027e4:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800027e8:	00c6f5b3          	and	a1,a3,a2
    800027ec:	cd91                	beqz	a1,80002808 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ee:	2705                	addiw	a4,a4,1
    800027f0:	2485                	addiw	s1,s1,1
    800027f2:	fd471ae3          	bne	a4,s4,800027c6 <balloc+0x80>
    800027f6:	b769                	j	80002780 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027f8:	00006517          	auipc	a0,0x6
    800027fc:	ba050513          	addi	a0,a0,-1120 # 80008398 <etext+0x398>
    80002800:	00004097          	auipc	ra,0x4
    80002804:	87c080e7          	jalr	-1924(ra) # 8000607c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002808:	97ca                	add	a5,a5,s2
    8000280a:	8e55                	or	a2,a2,a3
    8000280c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002810:	854a                	mv	a0,s2
    80002812:	00001097          	auipc	ra,0x1
    80002816:	018080e7          	jalr	24(ra) # 8000382a <log_write>
        brelse(bp);
    8000281a:	854a                	mv	a0,s2
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	d9a080e7          	jalr	-614(ra) # 800025b6 <brelse>
  bp = bread(dev, bno);
    80002824:	85a6                	mv	a1,s1
    80002826:	855e                	mv	a0,s7
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	c5e080e7          	jalr	-930(ra) # 80002486 <bread>
    80002830:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002832:	40000613          	li	a2,1024
    80002836:	4581                	li	a1,0
    80002838:	05850513          	addi	a0,a0,88
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	93e080e7          	jalr	-1730(ra) # 8000017a <memset>
  log_write(bp);
    80002844:	854a                	mv	a0,s2
    80002846:	00001097          	auipc	ra,0x1
    8000284a:	fe4080e7          	jalr	-28(ra) # 8000382a <log_write>
  brelse(bp);
    8000284e:	854a                	mv	a0,s2
    80002850:	00000097          	auipc	ra,0x0
    80002854:	d66080e7          	jalr	-666(ra) # 800025b6 <brelse>
}
    80002858:	8526                	mv	a0,s1
    8000285a:	60e6                	ld	ra,88(sp)
    8000285c:	6446                	ld	s0,80(sp)
    8000285e:	64a6                	ld	s1,72(sp)
    80002860:	6906                	ld	s2,64(sp)
    80002862:	79e2                	ld	s3,56(sp)
    80002864:	7a42                	ld	s4,48(sp)
    80002866:	7aa2                	ld	s5,40(sp)
    80002868:	7b02                	ld	s6,32(sp)
    8000286a:	6be2                	ld	s7,24(sp)
    8000286c:	6c42                	ld	s8,16(sp)
    8000286e:	6ca2                	ld	s9,8(sp)
    80002870:	6125                	addi	sp,sp,96
    80002872:	8082                	ret

0000000080002874 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	1800                	addi	s0,sp,48
    80002882:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002884:	47ad                	li	a5,11
    80002886:	04b7ff63          	bgeu	a5,a1,800028e4 <bmap+0x70>
    8000288a:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000288c:	ff45849b          	addiw	s1,a1,-12
    80002890:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002894:	0ff00793          	li	a5,255
    80002898:	0ae7e463          	bltu	a5,a4,80002940 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000289c:	08052583          	lw	a1,128(a0)
    800028a0:	c5b5                	beqz	a1,8000290c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028a2:	00092503          	lw	a0,0(s2)
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	be0080e7          	jalr	-1056(ra) # 80002486 <bread>
    800028ae:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028b0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028b4:	02049713          	slli	a4,s1,0x20
    800028b8:	01e75593          	srli	a1,a4,0x1e
    800028bc:	00b784b3          	add	s1,a5,a1
    800028c0:	0004a983          	lw	s3,0(s1)
    800028c4:	04098e63          	beqz	s3,80002920 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028c8:	8552                	mv	a0,s4
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	cec080e7          	jalr	-788(ra) # 800025b6 <brelse>
    return addr;
    800028d2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800028d4:	854e                	mv	a0,s3
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6145                	addi	sp,sp,48
    800028e2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028e4:	02059793          	slli	a5,a1,0x20
    800028e8:	01e7d593          	srli	a1,a5,0x1e
    800028ec:	00b504b3          	add	s1,a0,a1
    800028f0:	0504a983          	lw	s3,80(s1)
    800028f4:	fe0990e3          	bnez	s3,800028d4 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028f8:	4108                	lw	a0,0(a0)
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	e4c080e7          	jalr	-436(ra) # 80002746 <balloc>
    80002902:	0005099b          	sext.w	s3,a0
    80002906:	0534a823          	sw	s3,80(s1)
    8000290a:	b7e9                	j	800028d4 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000290c:	4108                	lw	a0,0(a0)
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	e38080e7          	jalr	-456(ra) # 80002746 <balloc>
    80002916:	0005059b          	sext.w	a1,a0
    8000291a:	08b92023          	sw	a1,128(s2)
    8000291e:	b751                	j	800028a2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002920:	00092503          	lw	a0,0(s2)
    80002924:	00000097          	auipc	ra,0x0
    80002928:	e22080e7          	jalr	-478(ra) # 80002746 <balloc>
    8000292c:	0005099b          	sext.w	s3,a0
    80002930:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002934:	8552                	mv	a0,s4
    80002936:	00001097          	auipc	ra,0x1
    8000293a:	ef4080e7          	jalr	-268(ra) # 8000382a <log_write>
    8000293e:	b769                	j	800028c8 <bmap+0x54>
  panic("bmap: out of range");
    80002940:	00006517          	auipc	a0,0x6
    80002944:	a7050513          	addi	a0,a0,-1424 # 800083b0 <etext+0x3b0>
    80002948:	00003097          	auipc	ra,0x3
    8000294c:	734080e7          	jalr	1844(ra) # 8000607c <panic>

0000000080002950 <iget>:
{
    80002950:	7179                	addi	sp,sp,-48
    80002952:	f406                	sd	ra,40(sp)
    80002954:	f022                	sd	s0,32(sp)
    80002956:	ec26                	sd	s1,24(sp)
    80002958:	e84a                	sd	s2,16(sp)
    8000295a:	e44e                	sd	s3,8(sp)
    8000295c:	e052                	sd	s4,0(sp)
    8000295e:	1800                	addi	s0,sp,48
    80002960:	89aa                	mv	s3,a0
    80002962:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002964:	00024517          	auipc	a0,0x24
    80002968:	c1450513          	addi	a0,a0,-1004 # 80026578 <itable>
    8000296c:	00004097          	auipc	ra,0x4
    80002970:	c8a080e7          	jalr	-886(ra) # 800065f6 <acquire>
  empty = 0;
    80002974:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002976:	00024497          	auipc	s1,0x24
    8000297a:	c1a48493          	addi	s1,s1,-998 # 80026590 <itable+0x18>
    8000297e:	00025697          	auipc	a3,0x25
    80002982:	6a268693          	addi	a3,a3,1698 # 80028020 <log>
    80002986:	a039                	j	80002994 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002988:	02090b63          	beqz	s2,800029be <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000298c:	08848493          	addi	s1,s1,136
    80002990:	02d48a63          	beq	s1,a3,800029c4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002994:	449c                	lw	a5,8(s1)
    80002996:	fef059e3          	blez	a5,80002988 <iget+0x38>
    8000299a:	4098                	lw	a4,0(s1)
    8000299c:	ff3716e3          	bne	a4,s3,80002988 <iget+0x38>
    800029a0:	40d8                	lw	a4,4(s1)
    800029a2:	ff4713e3          	bne	a4,s4,80002988 <iget+0x38>
      ip->ref++;
    800029a6:	2785                	addiw	a5,a5,1
    800029a8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029aa:	00024517          	auipc	a0,0x24
    800029ae:	bce50513          	addi	a0,a0,-1074 # 80026578 <itable>
    800029b2:	00004097          	auipc	ra,0x4
    800029b6:	cf8080e7          	jalr	-776(ra) # 800066aa <release>
      return ip;
    800029ba:	8926                	mv	s2,s1
    800029bc:	a03d                	j	800029ea <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029be:	f7f9                	bnez	a5,8000298c <iget+0x3c>
      empty = ip;
    800029c0:	8926                	mv	s2,s1
    800029c2:	b7e9                	j	8000298c <iget+0x3c>
  if(empty == 0)
    800029c4:	02090c63          	beqz	s2,800029fc <iget+0xac>
  ip->dev = dev;
    800029c8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029cc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029d0:	4785                	li	a5,1
    800029d2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029d6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029da:	00024517          	auipc	a0,0x24
    800029de:	b9e50513          	addi	a0,a0,-1122 # 80026578 <itable>
    800029e2:	00004097          	auipc	ra,0x4
    800029e6:	cc8080e7          	jalr	-824(ra) # 800066aa <release>
}
    800029ea:	854a                	mv	a0,s2
    800029ec:	70a2                	ld	ra,40(sp)
    800029ee:	7402                	ld	s0,32(sp)
    800029f0:	64e2                	ld	s1,24(sp)
    800029f2:	6942                	ld	s2,16(sp)
    800029f4:	69a2                	ld	s3,8(sp)
    800029f6:	6a02                	ld	s4,0(sp)
    800029f8:	6145                	addi	sp,sp,48
    800029fa:	8082                	ret
    panic("iget: no inodes");
    800029fc:	00006517          	auipc	a0,0x6
    80002a00:	9cc50513          	addi	a0,a0,-1588 # 800083c8 <etext+0x3c8>
    80002a04:	00003097          	auipc	ra,0x3
    80002a08:	678080e7          	jalr	1656(ra) # 8000607c <panic>

0000000080002a0c <fsinit>:
fsinit(int dev) {
    80002a0c:	7179                	addi	sp,sp,-48
    80002a0e:	f406                	sd	ra,40(sp)
    80002a10:	f022                	sd	s0,32(sp)
    80002a12:	ec26                	sd	s1,24(sp)
    80002a14:	e84a                	sd	s2,16(sp)
    80002a16:	e44e                	sd	s3,8(sp)
    80002a18:	1800                	addi	s0,sp,48
    80002a1a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a1c:	4585                	li	a1,1
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	a68080e7          	jalr	-1432(ra) # 80002486 <bread>
    80002a26:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a28:	00024997          	auipc	s3,0x24
    80002a2c:	b3098993          	addi	s3,s3,-1232 # 80026558 <sb>
    80002a30:	02000613          	li	a2,32
    80002a34:	05850593          	addi	a1,a0,88
    80002a38:	854e                	mv	a0,s3
    80002a3a:	ffffd097          	auipc	ra,0xffffd
    80002a3e:	79c080e7          	jalr	1948(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a42:	8526                	mv	a0,s1
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	b72080e7          	jalr	-1166(ra) # 800025b6 <brelse>
  if(sb.magic != FSMAGIC)
    80002a4c:	0009a703          	lw	a4,0(s3)
    80002a50:	102037b7          	lui	a5,0x10203
    80002a54:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a58:	02f71263          	bne	a4,a5,80002a7c <fsinit+0x70>
  initlog(dev, &sb);
    80002a5c:	00024597          	auipc	a1,0x24
    80002a60:	afc58593          	addi	a1,a1,-1284 # 80026558 <sb>
    80002a64:	854a                	mv	a0,s2
    80002a66:	00001097          	auipc	ra,0x1
    80002a6a:	b54080e7          	jalr	-1196(ra) # 800035ba <initlog>
}
    80002a6e:	70a2                	ld	ra,40(sp)
    80002a70:	7402                	ld	s0,32(sp)
    80002a72:	64e2                	ld	s1,24(sp)
    80002a74:	6942                	ld	s2,16(sp)
    80002a76:	69a2                	ld	s3,8(sp)
    80002a78:	6145                	addi	sp,sp,48
    80002a7a:	8082                	ret
    panic("invalid file system");
    80002a7c:	00006517          	auipc	a0,0x6
    80002a80:	95c50513          	addi	a0,a0,-1700 # 800083d8 <etext+0x3d8>
    80002a84:	00003097          	auipc	ra,0x3
    80002a88:	5f8080e7          	jalr	1528(ra) # 8000607c <panic>

0000000080002a8c <iinit>:
{
    80002a8c:	7179                	addi	sp,sp,-48
    80002a8e:	f406                	sd	ra,40(sp)
    80002a90:	f022                	sd	s0,32(sp)
    80002a92:	ec26                	sd	s1,24(sp)
    80002a94:	e84a                	sd	s2,16(sp)
    80002a96:	e44e                	sd	s3,8(sp)
    80002a98:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a9a:	00006597          	auipc	a1,0x6
    80002a9e:	95658593          	addi	a1,a1,-1706 # 800083f0 <etext+0x3f0>
    80002aa2:	00024517          	auipc	a0,0x24
    80002aa6:	ad650513          	addi	a0,a0,-1322 # 80026578 <itable>
    80002aaa:	00004097          	auipc	ra,0x4
    80002aae:	abc080e7          	jalr	-1348(ra) # 80006566 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab2:	00024497          	auipc	s1,0x24
    80002ab6:	aee48493          	addi	s1,s1,-1298 # 800265a0 <itable+0x28>
    80002aba:	00025997          	auipc	s3,0x25
    80002abe:	57698993          	addi	s3,s3,1398 # 80028030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac2:	00006917          	auipc	s2,0x6
    80002ac6:	93690913          	addi	s2,s2,-1738 # 800083f8 <etext+0x3f8>
    80002aca:	85ca                	mv	a1,s2
    80002acc:	8526                	mv	a0,s1
    80002ace:	00001097          	auipc	ra,0x1
    80002ad2:	e40080e7          	jalr	-448(ra) # 8000390e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ad6:	08848493          	addi	s1,s1,136
    80002ada:	ff3498e3          	bne	s1,s3,80002aca <iinit+0x3e>
}
    80002ade:	70a2                	ld	ra,40(sp)
    80002ae0:	7402                	ld	s0,32(sp)
    80002ae2:	64e2                	ld	s1,24(sp)
    80002ae4:	6942                	ld	s2,16(sp)
    80002ae6:	69a2                	ld	s3,8(sp)
    80002ae8:	6145                	addi	sp,sp,48
    80002aea:	8082                	ret

0000000080002aec <ialloc>:
{
    80002aec:	7139                	addi	sp,sp,-64
    80002aee:	fc06                	sd	ra,56(sp)
    80002af0:	f822                	sd	s0,48(sp)
    80002af2:	f426                	sd	s1,40(sp)
    80002af4:	f04a                	sd	s2,32(sp)
    80002af6:	ec4e                	sd	s3,24(sp)
    80002af8:	e852                	sd	s4,16(sp)
    80002afa:	e456                	sd	s5,8(sp)
    80002afc:	e05a                	sd	s6,0(sp)
    80002afe:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b00:	00024717          	auipc	a4,0x24
    80002b04:	a6472703          	lw	a4,-1436(a4) # 80026564 <sb+0xc>
    80002b08:	4785                	li	a5,1
    80002b0a:	04e7f863          	bgeu	a5,a4,80002b5a <ialloc+0x6e>
    80002b0e:	8aaa                	mv	s5,a0
    80002b10:	8b2e                	mv	s6,a1
    80002b12:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b14:	00024a17          	auipc	s4,0x24
    80002b18:	a44a0a13          	addi	s4,s4,-1468 # 80026558 <sb>
    80002b1c:	00495593          	srli	a1,s2,0x4
    80002b20:	018a2783          	lw	a5,24(s4)
    80002b24:	9dbd                	addw	a1,a1,a5
    80002b26:	8556                	mv	a0,s5
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	95e080e7          	jalr	-1698(ra) # 80002486 <bread>
    80002b30:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b32:	05850993          	addi	s3,a0,88
    80002b36:	00f97793          	andi	a5,s2,15
    80002b3a:	079a                	slli	a5,a5,0x6
    80002b3c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3e:	00099783          	lh	a5,0(s3)
    80002b42:	c785                	beqz	a5,80002b6a <ialloc+0x7e>
    brelse(bp);
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	a72080e7          	jalr	-1422(ra) # 800025b6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4c:	0905                	addi	s2,s2,1
    80002b4e:	00ca2703          	lw	a4,12(s4)
    80002b52:	0009079b          	sext.w	a5,s2
    80002b56:	fce7e3e3          	bltu	a5,a4,80002b1c <ialloc+0x30>
  panic("ialloc: no inodes");
    80002b5a:	00006517          	auipc	a0,0x6
    80002b5e:	8a650513          	addi	a0,a0,-1882 # 80008400 <etext+0x400>
    80002b62:	00003097          	auipc	ra,0x3
    80002b66:	51a080e7          	jalr	1306(ra) # 8000607c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b6a:	04000613          	li	a2,64
    80002b6e:	4581                	li	a1,0
    80002b70:	854e                	mv	a0,s3
    80002b72:	ffffd097          	auipc	ra,0xffffd
    80002b76:	608080e7          	jalr	1544(ra) # 8000017a <memset>
      dip->type = type;
    80002b7a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b7e:	8526                	mv	a0,s1
    80002b80:	00001097          	auipc	ra,0x1
    80002b84:	caa080e7          	jalr	-854(ra) # 8000382a <log_write>
      brelse(bp);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	00000097          	auipc	ra,0x0
    80002b8e:	a2c080e7          	jalr	-1492(ra) # 800025b6 <brelse>
      return iget(dev, inum);
    80002b92:	0009059b          	sext.w	a1,s2
    80002b96:	8556                	mv	a0,s5
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	db8080e7          	jalr	-584(ra) # 80002950 <iget>
}
    80002ba0:	70e2                	ld	ra,56(sp)
    80002ba2:	7442                	ld	s0,48(sp)
    80002ba4:	74a2                	ld	s1,40(sp)
    80002ba6:	7902                	ld	s2,32(sp)
    80002ba8:	69e2                	ld	s3,24(sp)
    80002baa:	6a42                	ld	s4,16(sp)
    80002bac:	6aa2                	ld	s5,8(sp)
    80002bae:	6b02                	ld	s6,0(sp)
    80002bb0:	6121                	addi	sp,sp,64
    80002bb2:	8082                	ret

0000000080002bb4 <iupdate>:
{
    80002bb4:	1101                	addi	sp,sp,-32
    80002bb6:	ec06                	sd	ra,24(sp)
    80002bb8:	e822                	sd	s0,16(sp)
    80002bba:	e426                	sd	s1,8(sp)
    80002bbc:	e04a                	sd	s2,0(sp)
    80002bbe:	1000                	addi	s0,sp,32
    80002bc0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc2:	415c                	lw	a5,4(a0)
    80002bc4:	0047d79b          	srliw	a5,a5,0x4
    80002bc8:	00024597          	auipc	a1,0x24
    80002bcc:	9a85a583          	lw	a1,-1624(a1) # 80026570 <sb+0x18>
    80002bd0:	9dbd                	addw	a1,a1,a5
    80002bd2:	4108                	lw	a0,0(a0)
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	8b2080e7          	jalr	-1870(ra) # 80002486 <bread>
    80002bdc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bde:	05850793          	addi	a5,a0,88
    80002be2:	40d8                	lw	a4,4(s1)
    80002be4:	8b3d                	andi	a4,a4,15
    80002be6:	071a                	slli	a4,a4,0x6
    80002be8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bea:	04449703          	lh	a4,68(s1)
    80002bee:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bf2:	04649703          	lh	a4,70(s1)
    80002bf6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bfa:	04849703          	lh	a4,72(s1)
    80002bfe:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c02:	04a49703          	lh	a4,74(s1)
    80002c06:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c0a:	44f8                	lw	a4,76(s1)
    80002c0c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c0e:	03400613          	li	a2,52
    80002c12:	05048593          	addi	a1,s1,80
    80002c16:	00c78513          	addi	a0,a5,12
    80002c1a:	ffffd097          	auipc	ra,0xffffd
    80002c1e:	5bc080e7          	jalr	1468(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c22:	854a                	mv	a0,s2
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	c06080e7          	jalr	-1018(ra) # 8000382a <log_write>
  brelse(bp);
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	988080e7          	jalr	-1656(ra) # 800025b6 <brelse>
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6902                	ld	s2,0(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <idup>:
{
    80002c42:	1101                	addi	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c4e:	00024517          	auipc	a0,0x24
    80002c52:	92a50513          	addi	a0,a0,-1750 # 80026578 <itable>
    80002c56:	00004097          	auipc	ra,0x4
    80002c5a:	9a0080e7          	jalr	-1632(ra) # 800065f6 <acquire>
  ip->ref++;
    80002c5e:	449c                	lw	a5,8(s1)
    80002c60:	2785                	addiw	a5,a5,1
    80002c62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c64:	00024517          	auipc	a0,0x24
    80002c68:	91450513          	addi	a0,a0,-1772 # 80026578 <itable>
    80002c6c:	00004097          	auipc	ra,0x4
    80002c70:	a3e080e7          	jalr	-1474(ra) # 800066aa <release>
}
    80002c74:	8526                	mv	a0,s1
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret

0000000080002c80 <ilock>:
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8a:	c10d                	beqz	a0,80002cac <ilock+0x2c>
    80002c8c:	84aa                	mv	s1,a0
    80002c8e:	451c                	lw	a5,8(a0)
    80002c90:	00f05e63          	blez	a5,80002cac <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c94:	0541                	addi	a0,a0,16
    80002c96:	00001097          	auipc	ra,0x1
    80002c9a:	cb2080e7          	jalr	-846(ra) # 80003948 <acquiresleep>
  if(ip->valid == 0){
    80002c9e:	40bc                	lw	a5,64(s1)
    80002ca0:	cf99                	beqz	a5,80002cbe <ilock+0x3e>
}
    80002ca2:	60e2                	ld	ra,24(sp)
    80002ca4:	6442                	ld	s0,16(sp)
    80002ca6:	64a2                	ld	s1,8(sp)
    80002ca8:	6105                	addi	sp,sp,32
    80002caa:	8082                	ret
    80002cac:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cae:	00005517          	auipc	a0,0x5
    80002cb2:	76a50513          	addi	a0,a0,1898 # 80008418 <etext+0x418>
    80002cb6:	00003097          	auipc	ra,0x3
    80002cba:	3c6080e7          	jalr	966(ra) # 8000607c <panic>
    80002cbe:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc0:	40dc                	lw	a5,4(s1)
    80002cc2:	0047d79b          	srliw	a5,a5,0x4
    80002cc6:	00024597          	auipc	a1,0x24
    80002cca:	8aa5a583          	lw	a1,-1878(a1) # 80026570 <sb+0x18>
    80002cce:	9dbd                	addw	a1,a1,a5
    80002cd0:	4088                	lw	a0,0(s1)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	7b4080e7          	jalr	1972(ra) # 80002486 <bread>
    80002cda:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cdc:	05850593          	addi	a1,a0,88
    80002ce0:	40dc                	lw	a5,4(s1)
    80002ce2:	8bbd                	andi	a5,a5,15
    80002ce4:	079a                	slli	a5,a5,0x6
    80002ce6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce8:	00059783          	lh	a5,0(a1)
    80002cec:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf0:	00259783          	lh	a5,2(a1)
    80002cf4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf8:	00459783          	lh	a5,4(a1)
    80002cfc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d00:	00659783          	lh	a5,6(a1)
    80002d04:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d08:	459c                	lw	a5,8(a1)
    80002d0a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d0c:	03400613          	li	a2,52
    80002d10:	05b1                	addi	a1,a1,12
    80002d12:	05048513          	addi	a0,s1,80
    80002d16:	ffffd097          	auipc	ra,0xffffd
    80002d1a:	4c0080e7          	jalr	1216(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d1e:	854a                	mv	a0,s2
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	896080e7          	jalr	-1898(ra) # 800025b6 <brelse>
    ip->valid = 1;
    80002d28:	4785                	li	a5,1
    80002d2a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d2c:	04449783          	lh	a5,68(s1)
    80002d30:	c399                	beqz	a5,80002d36 <ilock+0xb6>
    80002d32:	6902                	ld	s2,0(sp)
    80002d34:	b7bd                	j	80002ca2 <ilock+0x22>
      panic("ilock: no type");
    80002d36:	00005517          	auipc	a0,0x5
    80002d3a:	6ea50513          	addi	a0,a0,1770 # 80008420 <etext+0x420>
    80002d3e:	00003097          	auipc	ra,0x3
    80002d42:	33e080e7          	jalr	830(ra) # 8000607c <panic>

0000000080002d46 <iunlock>:
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d52:	c905                	beqz	a0,80002d82 <iunlock+0x3c>
    80002d54:	84aa                	mv	s1,a0
    80002d56:	01050913          	addi	s2,a0,16
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00001097          	auipc	ra,0x1
    80002d60:	c86080e7          	jalr	-890(ra) # 800039e2 <holdingsleep>
    80002d64:	cd19                	beqz	a0,80002d82 <iunlock+0x3c>
    80002d66:	449c                	lw	a5,8(s1)
    80002d68:	00f05d63          	blez	a5,80002d82 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	c30080e7          	jalr	-976(ra) # 8000399e <releasesleep>
}
    80002d76:	60e2                	ld	ra,24(sp)
    80002d78:	6442                	ld	s0,16(sp)
    80002d7a:	64a2                	ld	s1,8(sp)
    80002d7c:	6902                	ld	s2,0(sp)
    80002d7e:	6105                	addi	sp,sp,32
    80002d80:	8082                	ret
    panic("iunlock");
    80002d82:	00005517          	auipc	a0,0x5
    80002d86:	6ae50513          	addi	a0,a0,1710 # 80008430 <etext+0x430>
    80002d8a:	00003097          	auipc	ra,0x3
    80002d8e:	2f2080e7          	jalr	754(ra) # 8000607c <panic>

0000000080002d92 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d92:	7179                	addi	sp,sp,-48
    80002d94:	f406                	sd	ra,40(sp)
    80002d96:	f022                	sd	s0,32(sp)
    80002d98:	ec26                	sd	s1,24(sp)
    80002d9a:	e84a                	sd	s2,16(sp)
    80002d9c:	e44e                	sd	s3,8(sp)
    80002d9e:	1800                	addi	s0,sp,48
    80002da0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da2:	05050493          	addi	s1,a0,80
    80002da6:	08050913          	addi	s2,a0,128
    80002daa:	a021                	j	80002db2 <itrunc+0x20>
    80002dac:	0491                	addi	s1,s1,4
    80002dae:	01248d63          	beq	s1,s2,80002dc8 <itrunc+0x36>
    if(ip->addrs[i]){
    80002db2:	408c                	lw	a1,0(s1)
    80002db4:	dde5                	beqz	a1,80002dac <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002db6:	0009a503          	lw	a0,0(s3)
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	910080e7          	jalr	-1776(ra) # 800026ca <bfree>
      ip->addrs[i] = 0;
    80002dc2:	0004a023          	sw	zero,0(s1)
    80002dc6:	b7dd                	j	80002dac <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc8:	0809a583          	lw	a1,128(s3)
    80002dcc:	ed99                	bnez	a1,80002dea <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd2:	854e                	mv	a0,s3
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	de0080e7          	jalr	-544(ra) # 80002bb4 <iupdate>
}
    80002ddc:	70a2                	ld	ra,40(sp)
    80002dde:	7402                	ld	s0,32(sp)
    80002de0:	64e2                	ld	s1,24(sp)
    80002de2:	6942                	ld	s2,16(sp)
    80002de4:	69a2                	ld	s3,8(sp)
    80002de6:	6145                	addi	sp,sp,48
    80002de8:	8082                	ret
    80002dea:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dec:	0009a503          	lw	a0,0(s3)
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	696080e7          	jalr	1686(ra) # 80002486 <bread>
    80002df8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dfa:	05850493          	addi	s1,a0,88
    80002dfe:	45850913          	addi	s2,a0,1112
    80002e02:	a021                	j	80002e0a <itrunc+0x78>
    80002e04:	0491                	addi	s1,s1,4
    80002e06:	01248b63          	beq	s1,s2,80002e1c <itrunc+0x8a>
      if(a[j])
    80002e0a:	408c                	lw	a1,0(s1)
    80002e0c:	dde5                	beqz	a1,80002e04 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	8b8080e7          	jalr	-1864(ra) # 800026ca <bfree>
    80002e1a:	b7ed                	j	80002e04 <itrunc+0x72>
    brelse(bp);
    80002e1c:	8552                	mv	a0,s4
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	798080e7          	jalr	1944(ra) # 800025b6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e26:	0809a583          	lw	a1,128(s3)
    80002e2a:	0009a503          	lw	a0,0(s3)
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	89c080e7          	jalr	-1892(ra) # 800026ca <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e36:	0809a023          	sw	zero,128(s3)
    80002e3a:	6a02                	ld	s4,0(sp)
    80002e3c:	bf49                	j	80002dce <itrunc+0x3c>

0000000080002e3e <iput>:
{
    80002e3e:	1101                	addi	sp,sp,-32
    80002e40:	ec06                	sd	ra,24(sp)
    80002e42:	e822                	sd	s0,16(sp)
    80002e44:	e426                	sd	s1,8(sp)
    80002e46:	1000                	addi	s0,sp,32
    80002e48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e4a:	00023517          	auipc	a0,0x23
    80002e4e:	72e50513          	addi	a0,a0,1838 # 80026578 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	7a4080e7          	jalr	1956(ra) # 800065f6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e5a:	4498                	lw	a4,8(s1)
    80002e5c:	4785                	li	a5,1
    80002e5e:	02f70263          	beq	a4,a5,80002e82 <iput+0x44>
  ip->ref--;
    80002e62:	449c                	lw	a5,8(s1)
    80002e64:	37fd                	addiw	a5,a5,-1
    80002e66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e68:	00023517          	auipc	a0,0x23
    80002e6c:	71050513          	addi	a0,a0,1808 # 80026578 <itable>
    80002e70:	00004097          	auipc	ra,0x4
    80002e74:	83a080e7          	jalr	-1990(ra) # 800066aa <release>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	64a2                	ld	s1,8(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e82:	40bc                	lw	a5,64(s1)
    80002e84:	dff9                	beqz	a5,80002e62 <iput+0x24>
    80002e86:	04a49783          	lh	a5,74(s1)
    80002e8a:	ffe1                	bnez	a5,80002e62 <iput+0x24>
    80002e8c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e8e:	01048913          	addi	s2,s1,16
    80002e92:	854a                	mv	a0,s2
    80002e94:	00001097          	auipc	ra,0x1
    80002e98:	ab4080e7          	jalr	-1356(ra) # 80003948 <acquiresleep>
    release(&itable.lock);
    80002e9c:	00023517          	auipc	a0,0x23
    80002ea0:	6dc50513          	addi	a0,a0,1756 # 80026578 <itable>
    80002ea4:	00004097          	auipc	ra,0x4
    80002ea8:	806080e7          	jalr	-2042(ra) # 800066aa <release>
    itrunc(ip);
    80002eac:	8526                	mv	a0,s1
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	ee4080e7          	jalr	-284(ra) # 80002d92 <itrunc>
    ip->type = 0;
    80002eb6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	cf8080e7          	jalr	-776(ra) # 80002bb4 <iupdate>
    ip->valid = 0;
    80002ec4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	00001097          	auipc	ra,0x1
    80002ece:	ad4080e7          	jalr	-1324(ra) # 8000399e <releasesleep>
    acquire(&itable.lock);
    80002ed2:	00023517          	auipc	a0,0x23
    80002ed6:	6a650513          	addi	a0,a0,1702 # 80026578 <itable>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	71c080e7          	jalr	1820(ra) # 800065f6 <acquire>
    80002ee2:	6902                	ld	s2,0(sp)
    80002ee4:	bfbd                	j	80002e62 <iput+0x24>

0000000080002ee6 <iunlockput>:
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	1000                	addi	s0,sp,32
    80002ef0:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	e54080e7          	jalr	-428(ra) # 80002d46 <iunlock>
  iput(ip);
    80002efa:	8526                	mv	a0,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	f42080e7          	jalr	-190(ra) # 80002e3e <iput>
}
    80002f04:	60e2                	ld	ra,24(sp)
    80002f06:	6442                	ld	s0,16(sp)
    80002f08:	64a2                	ld	s1,8(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret

0000000080002f0e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0e:	1141                	addi	sp,sp,-16
    80002f10:	e422                	sd	s0,8(sp)
    80002f12:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f14:	411c                	lw	a5,0(a0)
    80002f16:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f18:	415c                	lw	a5,4(a0)
    80002f1a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f1c:	04451783          	lh	a5,68(a0)
    80002f20:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f24:	04a51783          	lh	a5,74(a0)
    80002f28:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f2c:	04c56783          	lwu	a5,76(a0)
    80002f30:	e99c                	sd	a5,16(a1)
}
    80002f32:	6422                	ld	s0,8(sp)
    80002f34:	0141                	addi	sp,sp,16
    80002f36:	8082                	ret

0000000080002f38 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f38:	457c                	lw	a5,76(a0)
    80002f3a:	0ed7ef63          	bltu	a5,a3,80003038 <readi+0x100>
{
    80002f3e:	7159                	addi	sp,sp,-112
    80002f40:	f486                	sd	ra,104(sp)
    80002f42:	f0a2                	sd	s0,96(sp)
    80002f44:	eca6                	sd	s1,88(sp)
    80002f46:	fc56                	sd	s5,56(sp)
    80002f48:	f85a                	sd	s6,48(sp)
    80002f4a:	f45e                	sd	s7,40(sp)
    80002f4c:	f062                	sd	s8,32(sp)
    80002f4e:	1880                	addi	s0,sp,112
    80002f50:	8baa                	mv	s7,a0
    80002f52:	8c2e                	mv	s8,a1
    80002f54:	8ab2                	mv	s5,a2
    80002f56:	84b6                	mv	s1,a3
    80002f58:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f5a:	9f35                	addw	a4,a4,a3
    return 0;
    80002f5c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f5e:	0ad76c63          	bltu	a4,a3,80003016 <readi+0xde>
    80002f62:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f64:	00e7f463          	bgeu	a5,a4,80002f6c <readi+0x34>
    n = ip->size - off;
    80002f68:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6c:	0c0b0463          	beqz	s6,80003034 <readi+0xfc>
    80002f70:	e8ca                	sd	s2,80(sp)
    80002f72:	e0d2                	sd	s4,64(sp)
    80002f74:	ec66                	sd	s9,24(sp)
    80002f76:	e86a                	sd	s10,16(sp)
    80002f78:	e46e                	sd	s11,8(sp)
    80002f7a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f80:	5cfd                	li	s9,-1
    80002f82:	a82d                	j	80002fbc <readi+0x84>
    80002f84:	020a1d93          	slli	s11,s4,0x20
    80002f88:	020ddd93          	srli	s11,s11,0x20
    80002f8c:	05890613          	addi	a2,s2,88
    80002f90:	86ee                	mv	a3,s11
    80002f92:	963a                	add	a2,a2,a4
    80002f94:	85d6                	mv	a1,s5
    80002f96:	8562                	mv	a0,s8
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	9d6080e7          	jalr	-1578(ra) # 8000196e <either_copyout>
    80002fa0:	05950d63          	beq	a0,s9,80002ffa <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa4:	854a                	mv	a0,s2
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	610080e7          	jalr	1552(ra) # 800025b6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fae:	013a09bb          	addw	s3,s4,s3
    80002fb2:	009a04bb          	addw	s1,s4,s1
    80002fb6:	9aee                	add	s5,s5,s11
    80002fb8:	0769f863          	bgeu	s3,s6,80003028 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fbc:	000ba903          	lw	s2,0(s7)
    80002fc0:	00a4d59b          	srliw	a1,s1,0xa
    80002fc4:	855e                	mv	a0,s7
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	8ae080e7          	jalr	-1874(ra) # 80002874 <bmap>
    80002fce:	0005059b          	sext.w	a1,a0
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	4b2080e7          	jalr	1202(ra) # 80002486 <bread>
    80002fdc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fde:	3ff4f713          	andi	a4,s1,1023
    80002fe2:	40ed07bb          	subw	a5,s10,a4
    80002fe6:	413b06bb          	subw	a3,s6,s3
    80002fea:	8a3e                	mv	s4,a5
    80002fec:	2781                	sext.w	a5,a5
    80002fee:	0006861b          	sext.w	a2,a3
    80002ff2:	f8f679e3          	bgeu	a2,a5,80002f84 <readi+0x4c>
    80002ff6:	8a36                	mv	s4,a3
    80002ff8:	b771                	j	80002f84 <readi+0x4c>
      brelse(bp);
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	5ba080e7          	jalr	1466(ra) # 800025b6 <brelse>
      tot = -1;
    80003004:	59fd                	li	s3,-1
      break;
    80003006:	6946                	ld	s2,80(sp)
    80003008:	6a06                	ld	s4,64(sp)
    8000300a:	6ce2                	ld	s9,24(sp)
    8000300c:	6d42                	ld	s10,16(sp)
    8000300e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003010:	0009851b          	sext.w	a0,s3
    80003014:	69a6                	ld	s3,72(sp)
}
    80003016:	70a6                	ld	ra,104(sp)
    80003018:	7406                	ld	s0,96(sp)
    8000301a:	64e6                	ld	s1,88(sp)
    8000301c:	7ae2                	ld	s5,56(sp)
    8000301e:	7b42                	ld	s6,48(sp)
    80003020:	7ba2                	ld	s7,40(sp)
    80003022:	7c02                	ld	s8,32(sp)
    80003024:	6165                	addi	sp,sp,112
    80003026:	8082                	ret
    80003028:	6946                	ld	s2,80(sp)
    8000302a:	6a06                	ld	s4,64(sp)
    8000302c:	6ce2                	ld	s9,24(sp)
    8000302e:	6d42                	ld	s10,16(sp)
    80003030:	6da2                	ld	s11,8(sp)
    80003032:	bff9                	j	80003010 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003034:	89da                	mv	s3,s6
    80003036:	bfe9                	j	80003010 <readi+0xd8>
    return 0;
    80003038:	4501                	li	a0,0
}
    8000303a:	8082                	ret

000000008000303c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000303c:	457c                	lw	a5,76(a0)
    8000303e:	10d7ee63          	bltu	a5,a3,8000315a <writei+0x11e>
{
    80003042:	7159                	addi	sp,sp,-112
    80003044:	f486                	sd	ra,104(sp)
    80003046:	f0a2                	sd	s0,96(sp)
    80003048:	e8ca                	sd	s2,80(sp)
    8000304a:	fc56                	sd	s5,56(sp)
    8000304c:	f85a                	sd	s6,48(sp)
    8000304e:	f45e                	sd	s7,40(sp)
    80003050:	f062                	sd	s8,32(sp)
    80003052:	1880                	addi	s0,sp,112
    80003054:	8b2a                	mv	s6,a0
    80003056:	8c2e                	mv	s8,a1
    80003058:	8ab2                	mv	s5,a2
    8000305a:	8936                	mv	s2,a3
    8000305c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000305e:	00e687bb          	addw	a5,a3,a4
    80003062:	0ed7ee63          	bltu	a5,a3,8000315e <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003066:	00043737          	lui	a4,0x43
    8000306a:	0ef76c63          	bltu	a4,a5,80003162 <writei+0x126>
    8000306e:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003070:	0c0b8d63          	beqz	s7,8000314a <writei+0x10e>
    80003074:	eca6                	sd	s1,88(sp)
    80003076:	e4ce                	sd	s3,72(sp)
    80003078:	ec66                	sd	s9,24(sp)
    8000307a:	e86a                	sd	s10,16(sp)
    8000307c:	e46e                	sd	s11,8(sp)
    8000307e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003080:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003084:	5cfd                	li	s9,-1
    80003086:	a091                	j	800030ca <writei+0x8e>
    80003088:	02099d93          	slli	s11,s3,0x20
    8000308c:	020ddd93          	srli	s11,s11,0x20
    80003090:	05848513          	addi	a0,s1,88
    80003094:	86ee                	mv	a3,s11
    80003096:	8656                	mv	a2,s5
    80003098:	85e2                	mv	a1,s8
    8000309a:	953a                	add	a0,a0,a4
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	928080e7          	jalr	-1752(ra) # 800019c4 <either_copyin>
    800030a4:	07950263          	beq	a0,s9,80003108 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030a8:	8526                	mv	a0,s1
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	780080e7          	jalr	1920(ra) # 8000382a <log_write>
    brelse(bp);
    800030b2:	8526                	mv	a0,s1
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	502080e7          	jalr	1282(ra) # 800025b6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030bc:	01498a3b          	addw	s4,s3,s4
    800030c0:	0129893b          	addw	s2,s3,s2
    800030c4:	9aee                	add	s5,s5,s11
    800030c6:	057a7663          	bgeu	s4,s7,80003112 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030ca:	000b2483          	lw	s1,0(s6)
    800030ce:	00a9559b          	srliw	a1,s2,0xa
    800030d2:	855a                	mv	a0,s6
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	7a0080e7          	jalr	1952(ra) # 80002874 <bmap>
    800030dc:	0005059b          	sext.w	a1,a0
    800030e0:	8526                	mv	a0,s1
    800030e2:	fffff097          	auipc	ra,0xfffff
    800030e6:	3a4080e7          	jalr	932(ra) # 80002486 <bread>
    800030ea:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ec:	3ff97713          	andi	a4,s2,1023
    800030f0:	40ed07bb          	subw	a5,s10,a4
    800030f4:	414b86bb          	subw	a3,s7,s4
    800030f8:	89be                	mv	s3,a5
    800030fa:	2781                	sext.w	a5,a5
    800030fc:	0006861b          	sext.w	a2,a3
    80003100:	f8f674e3          	bgeu	a2,a5,80003088 <writei+0x4c>
    80003104:	89b6                	mv	s3,a3
    80003106:	b749                	j	80003088 <writei+0x4c>
      brelse(bp);
    80003108:	8526                	mv	a0,s1
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	4ac080e7          	jalr	1196(ra) # 800025b6 <brelse>
  }

  if(off > ip->size)
    80003112:	04cb2783          	lw	a5,76(s6)
    80003116:	0327fc63          	bgeu	a5,s2,8000314e <writei+0x112>
    ip->size = off;
    8000311a:	052b2623          	sw	s2,76(s6)
    8000311e:	64e6                	ld	s1,88(sp)
    80003120:	69a6                	ld	s3,72(sp)
    80003122:	6ce2                	ld	s9,24(sp)
    80003124:	6d42                	ld	s10,16(sp)
    80003126:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003128:	855a                	mv	a0,s6
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	a8a080e7          	jalr	-1398(ra) # 80002bb4 <iupdate>

  return tot;
    80003132:	000a051b          	sext.w	a0,s4
    80003136:	6a06                	ld	s4,64(sp)
}
    80003138:	70a6                	ld	ra,104(sp)
    8000313a:	7406                	ld	s0,96(sp)
    8000313c:	6946                	ld	s2,80(sp)
    8000313e:	7ae2                	ld	s5,56(sp)
    80003140:	7b42                	ld	s6,48(sp)
    80003142:	7ba2                	ld	s7,40(sp)
    80003144:	7c02                	ld	s8,32(sp)
    80003146:	6165                	addi	sp,sp,112
    80003148:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000314a:	8a5e                	mv	s4,s7
    8000314c:	bff1                	j	80003128 <writei+0xec>
    8000314e:	64e6                	ld	s1,88(sp)
    80003150:	69a6                	ld	s3,72(sp)
    80003152:	6ce2                	ld	s9,24(sp)
    80003154:	6d42                	ld	s10,16(sp)
    80003156:	6da2                	ld	s11,8(sp)
    80003158:	bfc1                	j	80003128 <writei+0xec>
    return -1;
    8000315a:	557d                	li	a0,-1
}
    8000315c:	8082                	ret
    return -1;
    8000315e:	557d                	li	a0,-1
    80003160:	bfe1                	j	80003138 <writei+0xfc>
    return -1;
    80003162:	557d                	li	a0,-1
    80003164:	bfd1                	j	80003138 <writei+0xfc>

0000000080003166 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003166:	1141                	addi	sp,sp,-16
    80003168:	e406                	sd	ra,8(sp)
    8000316a:	e022                	sd	s0,0(sp)
    8000316c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000316e:	4639                	li	a2,14
    80003170:	ffffd097          	auipc	ra,0xffffd
    80003174:	0da080e7          	jalr	218(ra) # 8000024a <strncmp>
}
    80003178:	60a2                	ld	ra,8(sp)
    8000317a:	6402                	ld	s0,0(sp)
    8000317c:	0141                	addi	sp,sp,16
    8000317e:	8082                	ret

0000000080003180 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003180:	7139                	addi	sp,sp,-64
    80003182:	fc06                	sd	ra,56(sp)
    80003184:	f822                	sd	s0,48(sp)
    80003186:	f426                	sd	s1,40(sp)
    80003188:	f04a                	sd	s2,32(sp)
    8000318a:	ec4e                	sd	s3,24(sp)
    8000318c:	e852                	sd	s4,16(sp)
    8000318e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003190:	04451703          	lh	a4,68(a0)
    80003194:	4785                	li	a5,1
    80003196:	00f71a63          	bne	a4,a5,800031aa <dirlookup+0x2a>
    8000319a:	892a                	mv	s2,a0
    8000319c:	89ae                	mv	s3,a1
    8000319e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a0:	457c                	lw	a5,76(a0)
    800031a2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031a4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a6:	e79d                	bnez	a5,800031d4 <dirlookup+0x54>
    800031a8:	a8a5                	j	80003220 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031aa:	00005517          	auipc	a0,0x5
    800031ae:	28e50513          	addi	a0,a0,654 # 80008438 <etext+0x438>
    800031b2:	00003097          	auipc	ra,0x3
    800031b6:	eca080e7          	jalr	-310(ra) # 8000607c <panic>
      panic("dirlookup read");
    800031ba:	00005517          	auipc	a0,0x5
    800031be:	29650513          	addi	a0,a0,662 # 80008450 <etext+0x450>
    800031c2:	00003097          	auipc	ra,0x3
    800031c6:	eba080e7          	jalr	-326(ra) # 8000607c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ca:	24c1                	addiw	s1,s1,16
    800031cc:	04c92783          	lw	a5,76(s2)
    800031d0:	04f4f763          	bgeu	s1,a5,8000321e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031d4:	4741                	li	a4,16
    800031d6:	86a6                	mv	a3,s1
    800031d8:	fc040613          	addi	a2,s0,-64
    800031dc:	4581                	li	a1,0
    800031de:	854a                	mv	a0,s2
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	d58080e7          	jalr	-680(ra) # 80002f38 <readi>
    800031e8:	47c1                	li	a5,16
    800031ea:	fcf518e3          	bne	a0,a5,800031ba <dirlookup+0x3a>
    if(de.inum == 0)
    800031ee:	fc045783          	lhu	a5,-64(s0)
    800031f2:	dfe1                	beqz	a5,800031ca <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031f4:	fc240593          	addi	a1,s0,-62
    800031f8:	854e                	mv	a0,s3
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	f6c080e7          	jalr	-148(ra) # 80003166 <namecmp>
    80003202:	f561                	bnez	a0,800031ca <dirlookup+0x4a>
      if(poff)
    80003204:	000a0463          	beqz	s4,8000320c <dirlookup+0x8c>
        *poff = off;
    80003208:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000320c:	fc045583          	lhu	a1,-64(s0)
    80003210:	00092503          	lw	a0,0(s2)
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	73c080e7          	jalr	1852(ra) # 80002950 <iget>
    8000321c:	a011                	j	80003220 <dirlookup+0xa0>
  return 0;
    8000321e:	4501                	li	a0,0
}
    80003220:	70e2                	ld	ra,56(sp)
    80003222:	7442                	ld	s0,48(sp)
    80003224:	74a2                	ld	s1,40(sp)
    80003226:	7902                	ld	s2,32(sp)
    80003228:	69e2                	ld	s3,24(sp)
    8000322a:	6a42                	ld	s4,16(sp)
    8000322c:	6121                	addi	sp,sp,64
    8000322e:	8082                	ret

0000000080003230 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003230:	711d                	addi	sp,sp,-96
    80003232:	ec86                	sd	ra,88(sp)
    80003234:	e8a2                	sd	s0,80(sp)
    80003236:	e4a6                	sd	s1,72(sp)
    80003238:	e0ca                	sd	s2,64(sp)
    8000323a:	fc4e                	sd	s3,56(sp)
    8000323c:	f852                	sd	s4,48(sp)
    8000323e:	f456                	sd	s5,40(sp)
    80003240:	f05a                	sd	s6,32(sp)
    80003242:	ec5e                	sd	s7,24(sp)
    80003244:	e862                	sd	s8,16(sp)
    80003246:	e466                	sd	s9,8(sp)
    80003248:	1080                	addi	s0,sp,96
    8000324a:	84aa                	mv	s1,a0
    8000324c:	8b2e                	mv	s6,a1
    8000324e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003250:	00054703          	lbu	a4,0(a0)
    80003254:	02f00793          	li	a5,47
    80003258:	02f70263          	beq	a4,a5,8000327c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	c06080e7          	jalr	-1018(ra) # 80000e62 <myproc>
    80003264:	15053503          	ld	a0,336(a0)
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	9da080e7          	jalr	-1574(ra) # 80002c42 <idup>
    80003270:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003272:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003276:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003278:	4b85                	li	s7,1
    8000327a:	a875                	j	80003336 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000327c:	4585                	li	a1,1
    8000327e:	4505                	li	a0,1
    80003280:	fffff097          	auipc	ra,0xfffff
    80003284:	6d0080e7          	jalr	1744(ra) # 80002950 <iget>
    80003288:	8a2a                	mv	s4,a0
    8000328a:	b7e5                	j	80003272 <namex+0x42>
      iunlockput(ip);
    8000328c:	8552                	mv	a0,s4
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	c58080e7          	jalr	-936(ra) # 80002ee6 <iunlockput>
      return 0;
    80003296:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003298:	8552                	mv	a0,s4
    8000329a:	60e6                	ld	ra,88(sp)
    8000329c:	6446                	ld	s0,80(sp)
    8000329e:	64a6                	ld	s1,72(sp)
    800032a0:	6906                	ld	s2,64(sp)
    800032a2:	79e2                	ld	s3,56(sp)
    800032a4:	7a42                	ld	s4,48(sp)
    800032a6:	7aa2                	ld	s5,40(sp)
    800032a8:	7b02                	ld	s6,32(sp)
    800032aa:	6be2                	ld	s7,24(sp)
    800032ac:	6c42                	ld	s8,16(sp)
    800032ae:	6ca2                	ld	s9,8(sp)
    800032b0:	6125                	addi	sp,sp,96
    800032b2:	8082                	ret
      iunlock(ip);
    800032b4:	8552                	mv	a0,s4
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	a90080e7          	jalr	-1392(ra) # 80002d46 <iunlock>
      return ip;
    800032be:	bfe9                	j	80003298 <namex+0x68>
      iunlockput(ip);
    800032c0:	8552                	mv	a0,s4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	c24080e7          	jalr	-988(ra) # 80002ee6 <iunlockput>
      return 0;
    800032ca:	8a4e                	mv	s4,s3
    800032cc:	b7f1                	j	80003298 <namex+0x68>
  len = path - s;
    800032ce:	40998633          	sub	a2,s3,s1
    800032d2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032d6:	099c5863          	bge	s8,s9,80003366 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032da:	4639                	li	a2,14
    800032dc:	85a6                	mv	a1,s1
    800032de:	8556                	mv	a0,s5
    800032e0:	ffffd097          	auipc	ra,0xffffd
    800032e4:	ef6080e7          	jalr	-266(ra) # 800001d6 <memmove>
    800032e8:	84ce                	mv	s1,s3
  while(*path == '/')
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	01279763          	bne	a5,s2,800032fc <namex+0xcc>
    path++;
    800032f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	ff278de3          	beq	a5,s2,800032f2 <namex+0xc2>
    ilock(ip);
    800032fc:	8552                	mv	a0,s4
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	982080e7          	jalr	-1662(ra) # 80002c80 <ilock>
    if(ip->type != T_DIR){
    80003306:	044a1783          	lh	a5,68(s4)
    8000330a:	f97791e3          	bne	a5,s7,8000328c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000330e:	000b0563          	beqz	s6,80003318 <namex+0xe8>
    80003312:	0004c783          	lbu	a5,0(s1)
    80003316:	dfd9                	beqz	a5,800032b4 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003318:	4601                	li	a2,0
    8000331a:	85d6                	mv	a1,s5
    8000331c:	8552                	mv	a0,s4
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	e62080e7          	jalr	-414(ra) # 80003180 <dirlookup>
    80003326:	89aa                	mv	s3,a0
    80003328:	dd41                	beqz	a0,800032c0 <namex+0x90>
    iunlockput(ip);
    8000332a:	8552                	mv	a0,s4
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	bba080e7          	jalr	-1094(ra) # 80002ee6 <iunlockput>
    ip = next;
    80003334:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	01279763          	bne	a5,s2,80003348 <namex+0x118>
    path++;
    8000333e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003340:	0004c783          	lbu	a5,0(s1)
    80003344:	ff278de3          	beq	a5,s2,8000333e <namex+0x10e>
  if(*path == 0)
    80003348:	cb9d                	beqz	a5,8000337e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000334a:	0004c783          	lbu	a5,0(s1)
    8000334e:	89a6                	mv	s3,s1
  len = path - s;
    80003350:	4c81                	li	s9,0
    80003352:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003354:	01278963          	beq	a5,s2,80003366 <namex+0x136>
    80003358:	dbbd                	beqz	a5,800032ce <namex+0x9e>
    path++;
    8000335a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000335c:	0009c783          	lbu	a5,0(s3)
    80003360:	ff279ce3          	bne	a5,s2,80003358 <namex+0x128>
    80003364:	b7ad                	j	800032ce <namex+0x9e>
    memmove(name, s, len);
    80003366:	2601                	sext.w	a2,a2
    80003368:	85a6                	mv	a1,s1
    8000336a:	8556                	mv	a0,s5
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	e6a080e7          	jalr	-406(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003374:	9cd6                	add	s9,s9,s5
    80003376:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000337a:	84ce                	mv	s1,s3
    8000337c:	b7bd                	j	800032ea <namex+0xba>
  if(nameiparent){
    8000337e:	f00b0de3          	beqz	s6,80003298 <namex+0x68>
    iput(ip);
    80003382:	8552                	mv	a0,s4
    80003384:	00000097          	auipc	ra,0x0
    80003388:	aba080e7          	jalr	-1350(ra) # 80002e3e <iput>
    return 0;
    8000338c:	4a01                	li	s4,0
    8000338e:	b729                	j	80003298 <namex+0x68>

0000000080003390 <dirlink>:
{
    80003390:	7139                	addi	sp,sp,-64
    80003392:	fc06                	sd	ra,56(sp)
    80003394:	f822                	sd	s0,48(sp)
    80003396:	f04a                	sd	s2,32(sp)
    80003398:	ec4e                	sd	s3,24(sp)
    8000339a:	e852                	sd	s4,16(sp)
    8000339c:	0080                	addi	s0,sp,64
    8000339e:	892a                	mv	s2,a0
    800033a0:	8a2e                	mv	s4,a1
    800033a2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033a4:	4601                	li	a2,0
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	dda080e7          	jalr	-550(ra) # 80003180 <dirlookup>
    800033ae:	ed25                	bnez	a0,80003426 <dirlink+0x96>
    800033b0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033b2:	04c92483          	lw	s1,76(s2)
    800033b6:	c49d                	beqz	s1,800033e4 <dirlink+0x54>
    800033b8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ba:	4741                	li	a4,16
    800033bc:	86a6                	mv	a3,s1
    800033be:	fc040613          	addi	a2,s0,-64
    800033c2:	4581                	li	a1,0
    800033c4:	854a                	mv	a0,s2
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	b72080e7          	jalr	-1166(ra) # 80002f38 <readi>
    800033ce:	47c1                	li	a5,16
    800033d0:	06f51163          	bne	a0,a5,80003432 <dirlink+0xa2>
    if(de.inum == 0)
    800033d4:	fc045783          	lhu	a5,-64(s0)
    800033d8:	c791                	beqz	a5,800033e4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033da:	24c1                	addiw	s1,s1,16
    800033dc:	04c92783          	lw	a5,76(s2)
    800033e0:	fcf4ede3          	bltu	s1,a5,800033ba <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033e4:	4639                	li	a2,14
    800033e6:	85d2                	mv	a1,s4
    800033e8:	fc240513          	addi	a0,s0,-62
    800033ec:	ffffd097          	auipc	ra,0xffffd
    800033f0:	e94080e7          	jalr	-364(ra) # 80000280 <strncpy>
  de.inum = inum;
    800033f4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f8:	4741                	li	a4,16
    800033fa:	86a6                	mv	a3,s1
    800033fc:	fc040613          	addi	a2,s0,-64
    80003400:	4581                	li	a1,0
    80003402:	854a                	mv	a0,s2
    80003404:	00000097          	auipc	ra,0x0
    80003408:	c38080e7          	jalr	-968(ra) # 8000303c <writei>
    8000340c:	872a                	mv	a4,a0
    8000340e:	47c1                	li	a5,16
  return 0;
    80003410:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003412:	02f71863          	bne	a4,a5,80003442 <dirlink+0xb2>
    80003416:	74a2                	ld	s1,40(sp)
}
    80003418:	70e2                	ld	ra,56(sp)
    8000341a:	7442                	ld	s0,48(sp)
    8000341c:	7902                	ld	s2,32(sp)
    8000341e:	69e2                	ld	s3,24(sp)
    80003420:	6a42                	ld	s4,16(sp)
    80003422:	6121                	addi	sp,sp,64
    80003424:	8082                	ret
    iput(ip);
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	a18080e7          	jalr	-1512(ra) # 80002e3e <iput>
    return -1;
    8000342e:	557d                	li	a0,-1
    80003430:	b7e5                	j	80003418 <dirlink+0x88>
      panic("dirlink read");
    80003432:	00005517          	auipc	a0,0x5
    80003436:	02e50513          	addi	a0,a0,46 # 80008460 <etext+0x460>
    8000343a:	00003097          	auipc	ra,0x3
    8000343e:	c42080e7          	jalr	-958(ra) # 8000607c <panic>
    panic("dirlink");
    80003442:	00005517          	auipc	a0,0x5
    80003446:	12e50513          	addi	a0,a0,302 # 80008570 <etext+0x570>
    8000344a:	00003097          	auipc	ra,0x3
    8000344e:	c32080e7          	jalr	-974(ra) # 8000607c <panic>

0000000080003452 <namei>:

struct inode*
namei(char *path)
{
    80003452:	1101                	addi	sp,sp,-32
    80003454:	ec06                	sd	ra,24(sp)
    80003456:	e822                	sd	s0,16(sp)
    80003458:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000345a:	fe040613          	addi	a2,s0,-32
    8000345e:	4581                	li	a1,0
    80003460:	00000097          	auipc	ra,0x0
    80003464:	dd0080e7          	jalr	-560(ra) # 80003230 <namex>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	6105                	addi	sp,sp,32
    8000346e:	8082                	ret

0000000080003470 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003470:	1141                	addi	sp,sp,-16
    80003472:	e406                	sd	ra,8(sp)
    80003474:	e022                	sd	s0,0(sp)
    80003476:	0800                	addi	s0,sp,16
    80003478:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000347a:	4585                	li	a1,1
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	db4080e7          	jalr	-588(ra) # 80003230 <namex>
}
    80003484:	60a2                	ld	ra,8(sp)
    80003486:	6402                	ld	s0,0(sp)
    80003488:	0141                	addi	sp,sp,16
    8000348a:	8082                	ret

000000008000348c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000348c:	1101                	addi	sp,sp,-32
    8000348e:	ec06                	sd	ra,24(sp)
    80003490:	e822                	sd	s0,16(sp)
    80003492:	e426                	sd	s1,8(sp)
    80003494:	e04a                	sd	s2,0(sp)
    80003496:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003498:	00025917          	auipc	s2,0x25
    8000349c:	b8890913          	addi	s2,s2,-1144 # 80028020 <log>
    800034a0:	01892583          	lw	a1,24(s2)
    800034a4:	02892503          	lw	a0,40(s2)
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	fde080e7          	jalr	-34(ra) # 80002486 <bread>
    800034b0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034b2:	02c92603          	lw	a2,44(s2)
    800034b6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034b8:	00c05f63          	blez	a2,800034d6 <write_head+0x4a>
    800034bc:	00025717          	auipc	a4,0x25
    800034c0:	b9470713          	addi	a4,a4,-1132 # 80028050 <log+0x30>
    800034c4:	87aa                	mv	a5,a0
    800034c6:	060a                	slli	a2,a2,0x2
    800034c8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034ca:	4314                	lw	a3,0(a4)
    800034cc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034ce:	0711                	addi	a4,a4,4
    800034d0:	0791                	addi	a5,a5,4
    800034d2:	fec79ce3          	bne	a5,a2,800034ca <write_head+0x3e>
  }
  bwrite(buf);
    800034d6:	8526                	mv	a0,s1
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	0a0080e7          	jalr	160(ra) # 80002578 <bwrite>
  brelse(buf);
    800034e0:	8526                	mv	a0,s1
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	0d4080e7          	jalr	212(ra) # 800025b6 <brelse>
}
    800034ea:	60e2                	ld	ra,24(sp)
    800034ec:	6442                	ld	s0,16(sp)
    800034ee:	64a2                	ld	s1,8(sp)
    800034f0:	6902                	ld	s2,0(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f6:	00025797          	auipc	a5,0x25
    800034fa:	b567a783          	lw	a5,-1194(a5) # 8002804c <log+0x2c>
    800034fe:	0af05d63          	blez	a5,800035b8 <install_trans+0xc2>
{
    80003502:	7139                	addi	sp,sp,-64
    80003504:	fc06                	sd	ra,56(sp)
    80003506:	f822                	sd	s0,48(sp)
    80003508:	f426                	sd	s1,40(sp)
    8000350a:	f04a                	sd	s2,32(sp)
    8000350c:	ec4e                	sd	s3,24(sp)
    8000350e:	e852                	sd	s4,16(sp)
    80003510:	e456                	sd	s5,8(sp)
    80003512:	e05a                	sd	s6,0(sp)
    80003514:	0080                	addi	s0,sp,64
    80003516:	8b2a                	mv	s6,a0
    80003518:	00025a97          	auipc	s5,0x25
    8000351c:	b38a8a93          	addi	s5,s5,-1224 # 80028050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003520:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003522:	00025997          	auipc	s3,0x25
    80003526:	afe98993          	addi	s3,s3,-1282 # 80028020 <log>
    8000352a:	a00d                	j	8000354c <install_trans+0x56>
    brelse(lbuf);
    8000352c:	854a                	mv	a0,s2
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	088080e7          	jalr	136(ra) # 800025b6 <brelse>
    brelse(dbuf);
    80003536:	8526                	mv	a0,s1
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	07e080e7          	jalr	126(ra) # 800025b6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003540:	2a05                	addiw	s4,s4,1
    80003542:	0a91                	addi	s5,s5,4
    80003544:	02c9a783          	lw	a5,44(s3)
    80003548:	04fa5e63          	bge	s4,a5,800035a4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000354c:	0189a583          	lw	a1,24(s3)
    80003550:	014585bb          	addw	a1,a1,s4
    80003554:	2585                	addiw	a1,a1,1
    80003556:	0289a503          	lw	a0,40(s3)
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	f2c080e7          	jalr	-212(ra) # 80002486 <bread>
    80003562:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003564:	000aa583          	lw	a1,0(s5)
    80003568:	0289a503          	lw	a0,40(s3)
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	f1a080e7          	jalr	-230(ra) # 80002486 <bread>
    80003574:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003576:	40000613          	li	a2,1024
    8000357a:	05890593          	addi	a1,s2,88
    8000357e:	05850513          	addi	a0,a0,88
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	c54080e7          	jalr	-940(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000358a:	8526                	mv	a0,s1
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	fec080e7          	jalr	-20(ra) # 80002578 <bwrite>
    if(recovering == 0)
    80003594:	f80b1ce3          	bnez	s6,8000352c <install_trans+0x36>
      bunpin(dbuf);
    80003598:	8526                	mv	a0,s1
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	0f4080e7          	jalr	244(ra) # 8000268e <bunpin>
    800035a2:	b769                	j	8000352c <install_trans+0x36>
}
    800035a4:	70e2                	ld	ra,56(sp)
    800035a6:	7442                	ld	s0,48(sp)
    800035a8:	74a2                	ld	s1,40(sp)
    800035aa:	7902                	ld	s2,32(sp)
    800035ac:	69e2                	ld	s3,24(sp)
    800035ae:	6a42                	ld	s4,16(sp)
    800035b0:	6aa2                	ld	s5,8(sp)
    800035b2:	6b02                	ld	s6,0(sp)
    800035b4:	6121                	addi	sp,sp,64
    800035b6:	8082                	ret
    800035b8:	8082                	ret

00000000800035ba <initlog>:
{
    800035ba:	7179                	addi	sp,sp,-48
    800035bc:	f406                	sd	ra,40(sp)
    800035be:	f022                	sd	s0,32(sp)
    800035c0:	ec26                	sd	s1,24(sp)
    800035c2:	e84a                	sd	s2,16(sp)
    800035c4:	e44e                	sd	s3,8(sp)
    800035c6:	1800                	addi	s0,sp,48
    800035c8:	892a                	mv	s2,a0
    800035ca:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035cc:	00025497          	auipc	s1,0x25
    800035d0:	a5448493          	addi	s1,s1,-1452 # 80028020 <log>
    800035d4:	00005597          	auipc	a1,0x5
    800035d8:	e9c58593          	addi	a1,a1,-356 # 80008470 <etext+0x470>
    800035dc:	8526                	mv	a0,s1
    800035de:	00003097          	auipc	ra,0x3
    800035e2:	f88080e7          	jalr	-120(ra) # 80006566 <initlock>
  log.start = sb->logstart;
    800035e6:	0149a583          	lw	a1,20(s3)
    800035ea:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035ec:	0109a783          	lw	a5,16(s3)
    800035f0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035f2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035f6:	854a                	mv	a0,s2
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	e8e080e7          	jalr	-370(ra) # 80002486 <bread>
  log.lh.n = lh->n;
    80003600:	4d30                	lw	a2,88(a0)
    80003602:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003604:	00c05f63          	blez	a2,80003622 <initlog+0x68>
    80003608:	87aa                	mv	a5,a0
    8000360a:	00025717          	auipc	a4,0x25
    8000360e:	a4670713          	addi	a4,a4,-1466 # 80028050 <log+0x30>
    80003612:	060a                	slli	a2,a2,0x2
    80003614:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003616:	4ff4                	lw	a3,92(a5)
    80003618:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000361a:	0791                	addi	a5,a5,4
    8000361c:	0711                	addi	a4,a4,4
    8000361e:	fec79ce3          	bne	a5,a2,80003616 <initlog+0x5c>
  brelse(buf);
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	f94080e7          	jalr	-108(ra) # 800025b6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000362a:	4505                	li	a0,1
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	eca080e7          	jalr	-310(ra) # 800034f6 <install_trans>
  log.lh.n = 0;
    80003634:	00025797          	auipc	a5,0x25
    80003638:	a007ac23          	sw	zero,-1512(a5) # 8002804c <log+0x2c>
  write_head(); // clear the log
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	e50080e7          	jalr	-432(ra) # 8000348c <write_head>
}
    80003644:	70a2                	ld	ra,40(sp)
    80003646:	7402                	ld	s0,32(sp)
    80003648:	64e2                	ld	s1,24(sp)
    8000364a:	6942                	ld	s2,16(sp)
    8000364c:	69a2                	ld	s3,8(sp)
    8000364e:	6145                	addi	sp,sp,48
    80003650:	8082                	ret

0000000080003652 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003652:	1101                	addi	sp,sp,-32
    80003654:	ec06                	sd	ra,24(sp)
    80003656:	e822                	sd	s0,16(sp)
    80003658:	e426                	sd	s1,8(sp)
    8000365a:	e04a                	sd	s2,0(sp)
    8000365c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000365e:	00025517          	auipc	a0,0x25
    80003662:	9c250513          	addi	a0,a0,-1598 # 80028020 <log>
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	f90080e7          	jalr	-112(ra) # 800065f6 <acquire>
  while(1){
    if(log.committing){
    8000366e:	00025497          	auipc	s1,0x25
    80003672:	9b248493          	addi	s1,s1,-1614 # 80028020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003676:	4979                	li	s2,30
    80003678:	a039                	j	80003686 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000367a:	85a6                	mv	a1,s1
    8000367c:	8526                	mv	a0,s1
    8000367e:	ffffe097          	auipc	ra,0xffffe
    80003682:	ee4080e7          	jalr	-284(ra) # 80001562 <sleep>
    if(log.committing){
    80003686:	50dc                	lw	a5,36(s1)
    80003688:	fbed                	bnez	a5,8000367a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368a:	5098                	lw	a4,32(s1)
    8000368c:	2705                	addiw	a4,a4,1
    8000368e:	0027179b          	slliw	a5,a4,0x2
    80003692:	9fb9                	addw	a5,a5,a4
    80003694:	0017979b          	slliw	a5,a5,0x1
    80003698:	54d4                	lw	a3,44(s1)
    8000369a:	9fb5                	addw	a5,a5,a3
    8000369c:	00f95963          	bge	s2,a5,800036ae <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036a0:	85a6                	mv	a1,s1
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	ebe080e7          	jalr	-322(ra) # 80001562 <sleep>
    800036ac:	bfe9                	j	80003686 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ae:	00025517          	auipc	a0,0x25
    800036b2:	97250513          	addi	a0,a0,-1678 # 80028020 <log>
    800036b6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	ff2080e7          	jalr	-14(ra) # 800066aa <release>
      break;
    }
  }
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	64a2                	ld	s1,8(sp)
    800036c6:	6902                	ld	s2,0(sp)
    800036c8:	6105                	addi	sp,sp,32
    800036ca:	8082                	ret

00000000800036cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036cc:	7139                	addi	sp,sp,-64
    800036ce:	fc06                	sd	ra,56(sp)
    800036d0:	f822                	sd	s0,48(sp)
    800036d2:	f426                	sd	s1,40(sp)
    800036d4:	f04a                	sd	s2,32(sp)
    800036d6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036d8:	00025497          	auipc	s1,0x25
    800036dc:	94848493          	addi	s1,s1,-1720 # 80028020 <log>
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	f14080e7          	jalr	-236(ra) # 800065f6 <acquire>
  log.outstanding -= 1;
    800036ea:	509c                	lw	a5,32(s1)
    800036ec:	37fd                	addiw	a5,a5,-1
    800036ee:	0007891b          	sext.w	s2,a5
    800036f2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036f4:	50dc                	lw	a5,36(s1)
    800036f6:	e7b9                	bnez	a5,80003744 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800036f8:	06091163          	bnez	s2,8000375a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036fc:	00025497          	auipc	s1,0x25
    80003700:	92448493          	addi	s1,s1,-1756 # 80028020 <log>
    80003704:	4785                	li	a5,1
    80003706:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003708:	8526                	mv	a0,s1
    8000370a:	00003097          	auipc	ra,0x3
    8000370e:	fa0080e7          	jalr	-96(ra) # 800066aa <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003712:	54dc                	lw	a5,44(s1)
    80003714:	06f04763          	bgtz	a5,80003782 <end_op+0xb6>
    acquire(&log.lock);
    80003718:	00025497          	auipc	s1,0x25
    8000371c:	90848493          	addi	s1,s1,-1784 # 80028020 <log>
    80003720:	8526                	mv	a0,s1
    80003722:	00003097          	auipc	ra,0x3
    80003726:	ed4080e7          	jalr	-300(ra) # 800065f6 <acquire>
    log.committing = 0;
    8000372a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000372e:	8526                	mv	a0,s1
    80003730:	ffffe097          	auipc	ra,0xffffe
    80003734:	fbe080e7          	jalr	-66(ra) # 800016ee <wakeup>
    release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	f70080e7          	jalr	-144(ra) # 800066aa <release>
}
    80003742:	a815                	j	80003776 <end_op+0xaa>
    80003744:	ec4e                	sd	s3,24(sp)
    80003746:	e852                	sd	s4,16(sp)
    80003748:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000374a:	00005517          	auipc	a0,0x5
    8000374e:	d2e50513          	addi	a0,a0,-722 # 80008478 <etext+0x478>
    80003752:	00003097          	auipc	ra,0x3
    80003756:	92a080e7          	jalr	-1750(ra) # 8000607c <panic>
    wakeup(&log);
    8000375a:	00025497          	auipc	s1,0x25
    8000375e:	8c648493          	addi	s1,s1,-1850 # 80028020 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	f8a080e7          	jalr	-118(ra) # 800016ee <wakeup>
  release(&log.lock);
    8000376c:	8526                	mv	a0,s1
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	f3c080e7          	jalr	-196(ra) # 800066aa <release>
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	7902                	ld	s2,32(sp)
    8000377e:	6121                	addi	sp,sp,64
    80003780:	8082                	ret
    80003782:	ec4e                	sd	s3,24(sp)
    80003784:	e852                	sd	s4,16(sp)
    80003786:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003788:	00025a97          	auipc	s5,0x25
    8000378c:	8c8a8a93          	addi	s5,s5,-1848 # 80028050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003790:	00025a17          	auipc	s4,0x25
    80003794:	890a0a13          	addi	s4,s4,-1904 # 80028020 <log>
    80003798:	018a2583          	lw	a1,24(s4)
    8000379c:	012585bb          	addw	a1,a1,s2
    800037a0:	2585                	addiw	a1,a1,1
    800037a2:	028a2503          	lw	a0,40(s4)
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	ce0080e7          	jalr	-800(ra) # 80002486 <bread>
    800037ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037b0:	000aa583          	lw	a1,0(s5)
    800037b4:	028a2503          	lw	a0,40(s4)
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	cce080e7          	jalr	-818(ra) # 80002486 <bread>
    800037c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037c2:	40000613          	li	a2,1024
    800037c6:	05850593          	addi	a1,a0,88
    800037ca:	05848513          	addi	a0,s1,88
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	a08080e7          	jalr	-1528(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037d6:	8526                	mv	a0,s1
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	da0080e7          	jalr	-608(ra) # 80002578 <bwrite>
    brelse(from);
    800037e0:	854e                	mv	a0,s3
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	dd4080e7          	jalr	-556(ra) # 800025b6 <brelse>
    brelse(to);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	dca080e7          	jalr	-566(ra) # 800025b6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f4:	2905                	addiw	s2,s2,1
    800037f6:	0a91                	addi	s5,s5,4
    800037f8:	02ca2783          	lw	a5,44(s4)
    800037fc:	f8f94ee3          	blt	s2,a5,80003798 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003800:	00000097          	auipc	ra,0x0
    80003804:	c8c080e7          	jalr	-884(ra) # 8000348c <write_head>
    install_trans(0); // Now install writes to home locations
    80003808:	4501                	li	a0,0
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	cec080e7          	jalr	-788(ra) # 800034f6 <install_trans>
    log.lh.n = 0;
    80003812:	00025797          	auipc	a5,0x25
    80003816:	8207ad23          	sw	zero,-1990(a5) # 8002804c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000381a:	00000097          	auipc	ra,0x0
    8000381e:	c72080e7          	jalr	-910(ra) # 8000348c <write_head>
    80003822:	69e2                	ld	s3,24(sp)
    80003824:	6a42                	ld	s4,16(sp)
    80003826:	6aa2                	ld	s5,8(sp)
    80003828:	bdc5                	j	80003718 <end_op+0x4c>

000000008000382a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000382a:	1101                	addi	sp,sp,-32
    8000382c:	ec06                	sd	ra,24(sp)
    8000382e:	e822                	sd	s0,16(sp)
    80003830:	e426                	sd	s1,8(sp)
    80003832:	e04a                	sd	s2,0(sp)
    80003834:	1000                	addi	s0,sp,32
    80003836:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003838:	00024917          	auipc	s2,0x24
    8000383c:	7e890913          	addi	s2,s2,2024 # 80028020 <log>
    80003840:	854a                	mv	a0,s2
    80003842:	00003097          	auipc	ra,0x3
    80003846:	db4080e7          	jalr	-588(ra) # 800065f6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000384a:	02c92603          	lw	a2,44(s2)
    8000384e:	47f5                	li	a5,29
    80003850:	06c7c563          	blt	a5,a2,800038ba <log_write+0x90>
    80003854:	00024797          	auipc	a5,0x24
    80003858:	7e87a783          	lw	a5,2024(a5) # 8002803c <log+0x1c>
    8000385c:	37fd                	addiw	a5,a5,-1
    8000385e:	04f65e63          	bge	a2,a5,800038ba <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003862:	00024797          	auipc	a5,0x24
    80003866:	7de7a783          	lw	a5,2014(a5) # 80028040 <log+0x20>
    8000386a:	06f05063          	blez	a5,800038ca <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000386e:	4781                	li	a5,0
    80003870:	06c05563          	blez	a2,800038da <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003874:	44cc                	lw	a1,12(s1)
    80003876:	00024717          	auipc	a4,0x24
    8000387a:	7da70713          	addi	a4,a4,2010 # 80028050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000387e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003880:	4314                	lw	a3,0(a4)
    80003882:	04b68c63          	beq	a3,a1,800038da <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003886:	2785                	addiw	a5,a5,1
    80003888:	0711                	addi	a4,a4,4
    8000388a:	fef61be3          	bne	a2,a5,80003880 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000388e:	0621                	addi	a2,a2,8
    80003890:	060a                	slli	a2,a2,0x2
    80003892:	00024797          	auipc	a5,0x24
    80003896:	78e78793          	addi	a5,a5,1934 # 80028020 <log>
    8000389a:	97b2                	add	a5,a5,a2
    8000389c:	44d8                	lw	a4,12(s1)
    8000389e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038a0:	8526                	mv	a0,s1
    800038a2:	fffff097          	auipc	ra,0xfffff
    800038a6:	db0080e7          	jalr	-592(ra) # 80002652 <bpin>
    log.lh.n++;
    800038aa:	00024717          	auipc	a4,0x24
    800038ae:	77670713          	addi	a4,a4,1910 # 80028020 <log>
    800038b2:	575c                	lw	a5,44(a4)
    800038b4:	2785                	addiw	a5,a5,1
    800038b6:	d75c                	sw	a5,44(a4)
    800038b8:	a82d                	j	800038f2 <log_write+0xc8>
    panic("too big a transaction");
    800038ba:	00005517          	auipc	a0,0x5
    800038be:	bce50513          	addi	a0,a0,-1074 # 80008488 <etext+0x488>
    800038c2:	00002097          	auipc	ra,0x2
    800038c6:	7ba080e7          	jalr	1978(ra) # 8000607c <panic>
    panic("log_write outside of trans");
    800038ca:	00005517          	auipc	a0,0x5
    800038ce:	bd650513          	addi	a0,a0,-1066 # 800084a0 <etext+0x4a0>
    800038d2:	00002097          	auipc	ra,0x2
    800038d6:	7aa080e7          	jalr	1962(ra) # 8000607c <panic>
  log.lh.block[i] = b->blockno;
    800038da:	00878693          	addi	a3,a5,8
    800038de:	068a                	slli	a3,a3,0x2
    800038e0:	00024717          	auipc	a4,0x24
    800038e4:	74070713          	addi	a4,a4,1856 # 80028020 <log>
    800038e8:	9736                	add	a4,a4,a3
    800038ea:	44d4                	lw	a3,12(s1)
    800038ec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038ee:	faf609e3          	beq	a2,a5,800038a0 <log_write+0x76>
  }
  release(&log.lock);
    800038f2:	00024517          	auipc	a0,0x24
    800038f6:	72e50513          	addi	a0,a0,1838 # 80028020 <log>
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	db0080e7          	jalr	-592(ra) # 800066aa <release>
}
    80003902:	60e2                	ld	ra,24(sp)
    80003904:	6442                	ld	s0,16(sp)
    80003906:	64a2                	ld	s1,8(sp)
    80003908:	6902                	ld	s2,0(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret

000000008000390e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000390e:	1101                	addi	sp,sp,-32
    80003910:	ec06                	sd	ra,24(sp)
    80003912:	e822                	sd	s0,16(sp)
    80003914:	e426                	sd	s1,8(sp)
    80003916:	e04a                	sd	s2,0(sp)
    80003918:	1000                	addi	s0,sp,32
    8000391a:	84aa                	mv	s1,a0
    8000391c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000391e:	00005597          	auipc	a1,0x5
    80003922:	ba258593          	addi	a1,a1,-1118 # 800084c0 <etext+0x4c0>
    80003926:	0521                	addi	a0,a0,8
    80003928:	00003097          	auipc	ra,0x3
    8000392c:	c3e080e7          	jalr	-962(ra) # 80006566 <initlock>
  lk->name = name;
    80003930:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003934:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003938:	0204a423          	sw	zero,40(s1)
}
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6902                	ld	s2,0(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	e04a                	sd	s2,0(sp)
    80003952:	1000                	addi	s0,sp,32
    80003954:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003956:	00850913          	addi	s2,a0,8
    8000395a:	854a                	mv	a0,s2
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	c9a080e7          	jalr	-870(ra) # 800065f6 <acquire>
  while (lk->locked) {
    80003964:	409c                	lw	a5,0(s1)
    80003966:	cb89                	beqz	a5,80003978 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003968:	85ca                	mv	a1,s2
    8000396a:	8526                	mv	a0,s1
    8000396c:	ffffe097          	auipc	ra,0xffffe
    80003970:	bf6080e7          	jalr	-1034(ra) # 80001562 <sleep>
  while (lk->locked) {
    80003974:	409c                	lw	a5,0(s1)
    80003976:	fbed                	bnez	a5,80003968 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003978:	4785                	li	a5,1
    8000397a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000397c:	ffffd097          	auipc	ra,0xffffd
    80003980:	4e6080e7          	jalr	1254(ra) # 80000e62 <myproc>
    80003984:	591c                	lw	a5,48(a0)
    80003986:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003988:	854a                	mv	a0,s2
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	d20080e7          	jalr	-736(ra) # 800066aa <release>
}
    80003992:	60e2                	ld	ra,24(sp)
    80003994:	6442                	ld	s0,16(sp)
    80003996:	64a2                	ld	s1,8(sp)
    80003998:	6902                	ld	s2,0(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret

000000008000399e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	e04a                	sd	s2,0(sp)
    800039a8:	1000                	addi	s0,sp,32
    800039aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ac:	00850913          	addi	s2,a0,8
    800039b0:	854a                	mv	a0,s2
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	c44080e7          	jalr	-956(ra) # 800065f6 <acquire>
  lk->locked = 0;
    800039ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039be:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039c2:	8526                	mv	a0,s1
    800039c4:	ffffe097          	auipc	ra,0xffffe
    800039c8:	d2a080e7          	jalr	-726(ra) # 800016ee <wakeup>
  release(&lk->lk);
    800039cc:	854a                	mv	a0,s2
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	cdc080e7          	jalr	-804(ra) # 800066aa <release>
}
    800039d6:	60e2                	ld	ra,24(sp)
    800039d8:	6442                	ld	s0,16(sp)
    800039da:	64a2                	ld	s1,8(sp)
    800039dc:	6902                	ld	s2,0(sp)
    800039de:	6105                	addi	sp,sp,32
    800039e0:	8082                	ret

00000000800039e2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039e2:	7179                	addi	sp,sp,-48
    800039e4:	f406                	sd	ra,40(sp)
    800039e6:	f022                	sd	s0,32(sp)
    800039e8:	ec26                	sd	s1,24(sp)
    800039ea:	e84a                	sd	s2,16(sp)
    800039ec:	1800                	addi	s0,sp,48
    800039ee:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039f0:	00850913          	addi	s2,a0,8
    800039f4:	854a                	mv	a0,s2
    800039f6:	00003097          	auipc	ra,0x3
    800039fa:	c00080e7          	jalr	-1024(ra) # 800065f6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039fe:	409c                	lw	a5,0(s1)
    80003a00:	ef91                	bnez	a5,80003a1c <holdingsleep+0x3a>
    80003a02:	4481                	li	s1,0
  release(&lk->lk);
    80003a04:	854a                	mv	a0,s2
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	ca4080e7          	jalr	-860(ra) # 800066aa <release>
  return r;
}
    80003a0e:	8526                	mv	a0,s1
    80003a10:	70a2                	ld	ra,40(sp)
    80003a12:	7402                	ld	s0,32(sp)
    80003a14:	64e2                	ld	s1,24(sp)
    80003a16:	6942                	ld	s2,16(sp)
    80003a18:	6145                	addi	sp,sp,48
    80003a1a:	8082                	ret
    80003a1c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a1e:	0284a983          	lw	s3,40(s1)
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	440080e7          	jalr	1088(ra) # 80000e62 <myproc>
    80003a2a:	5904                	lw	s1,48(a0)
    80003a2c:	413484b3          	sub	s1,s1,s3
    80003a30:	0014b493          	seqz	s1,s1
    80003a34:	69a2                	ld	s3,8(sp)
    80003a36:	b7f9                	j	80003a04 <holdingsleep+0x22>

0000000080003a38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a38:	1141                	addi	sp,sp,-16
    80003a3a:	e406                	sd	ra,8(sp)
    80003a3c:	e022                	sd	s0,0(sp)
    80003a3e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a40:	00005597          	auipc	a1,0x5
    80003a44:	a9058593          	addi	a1,a1,-1392 # 800084d0 <etext+0x4d0>
    80003a48:	00024517          	auipc	a0,0x24
    80003a4c:	72050513          	addi	a0,a0,1824 # 80028168 <ftable>
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	b16080e7          	jalr	-1258(ra) # 80006566 <initlock>
}
    80003a58:	60a2                	ld	ra,8(sp)
    80003a5a:	6402                	ld	s0,0(sp)
    80003a5c:	0141                	addi	sp,sp,16
    80003a5e:	8082                	ret

0000000080003a60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a60:	1101                	addi	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a6a:	00024517          	auipc	a0,0x24
    80003a6e:	6fe50513          	addi	a0,a0,1790 # 80028168 <ftable>
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	b84080e7          	jalr	-1148(ra) # 800065f6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a7a:	00024497          	auipc	s1,0x24
    80003a7e:	70648493          	addi	s1,s1,1798 # 80028180 <ftable+0x18>
    80003a82:	00025717          	auipc	a4,0x25
    80003a86:	69e70713          	addi	a4,a4,1694 # 80029120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a8a:	40dc                	lw	a5,4(s1)
    80003a8c:	cf99                	beqz	a5,80003aaa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a8e:	02848493          	addi	s1,s1,40
    80003a92:	fee49ce3          	bne	s1,a4,80003a8a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a96:	00024517          	auipc	a0,0x24
    80003a9a:	6d250513          	addi	a0,a0,1746 # 80028168 <ftable>
    80003a9e:	00003097          	auipc	ra,0x3
    80003aa2:	c0c080e7          	jalr	-1012(ra) # 800066aa <release>
  return 0;
    80003aa6:	4481                	li	s1,0
    80003aa8:	a819                	j	80003abe <filealloc+0x5e>
      f->ref = 1;
    80003aaa:	4785                	li	a5,1
    80003aac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aae:	00024517          	auipc	a0,0x24
    80003ab2:	6ba50513          	addi	a0,a0,1722 # 80028168 <ftable>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	bf4080e7          	jalr	-1036(ra) # 800066aa <release>
}
    80003abe:	8526                	mv	a0,s1
    80003ac0:	60e2                	ld	ra,24(sp)
    80003ac2:	6442                	ld	s0,16(sp)
    80003ac4:	64a2                	ld	s1,8(sp)
    80003ac6:	6105                	addi	sp,sp,32
    80003ac8:	8082                	ret

0000000080003aca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003aca:	1101                	addi	sp,sp,-32
    80003acc:	ec06                	sd	ra,24(sp)
    80003ace:	e822                	sd	s0,16(sp)
    80003ad0:	e426                	sd	s1,8(sp)
    80003ad2:	1000                	addi	s0,sp,32
    80003ad4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ad6:	00024517          	auipc	a0,0x24
    80003ada:	69250513          	addi	a0,a0,1682 # 80028168 <ftable>
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	b18080e7          	jalr	-1256(ra) # 800065f6 <acquire>
  if(f->ref < 1)
    80003ae6:	40dc                	lw	a5,4(s1)
    80003ae8:	02f05263          	blez	a5,80003b0c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003aec:	2785                	addiw	a5,a5,1
    80003aee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003af0:	00024517          	auipc	a0,0x24
    80003af4:	67850513          	addi	a0,a0,1656 # 80028168 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	bb2080e7          	jalr	-1102(ra) # 800066aa <release>
  return f;
}
    80003b00:	8526                	mv	a0,s1
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6105                	addi	sp,sp,32
    80003b0a:	8082                	ret
    panic("filedup");
    80003b0c:	00005517          	auipc	a0,0x5
    80003b10:	9cc50513          	addi	a0,a0,-1588 # 800084d8 <etext+0x4d8>
    80003b14:	00002097          	auipc	ra,0x2
    80003b18:	568080e7          	jalr	1384(ra) # 8000607c <panic>

0000000080003b1c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b1c:	7139                	addi	sp,sp,-64
    80003b1e:	fc06                	sd	ra,56(sp)
    80003b20:	f822                	sd	s0,48(sp)
    80003b22:	f426                	sd	s1,40(sp)
    80003b24:	0080                	addi	s0,sp,64
    80003b26:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b28:	00024517          	auipc	a0,0x24
    80003b2c:	64050513          	addi	a0,a0,1600 # 80028168 <ftable>
    80003b30:	00003097          	auipc	ra,0x3
    80003b34:	ac6080e7          	jalr	-1338(ra) # 800065f6 <acquire>
  if(f->ref < 1)
    80003b38:	40dc                	lw	a5,4(s1)
    80003b3a:	04f05c63          	blez	a5,80003b92 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b3e:	37fd                	addiw	a5,a5,-1
    80003b40:	0007871b          	sext.w	a4,a5
    80003b44:	c0dc                	sw	a5,4(s1)
    80003b46:	06e04263          	bgtz	a4,80003baa <fileclose+0x8e>
    80003b4a:	f04a                	sd	s2,32(sp)
    80003b4c:	ec4e                	sd	s3,24(sp)
    80003b4e:	e852                	sd	s4,16(sp)
    80003b50:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b52:	0004a903          	lw	s2,0(s1)
    80003b56:	0094ca83          	lbu	s5,9(s1)
    80003b5a:	0104ba03          	ld	s4,16(s1)
    80003b5e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b62:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b66:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b6a:	00024517          	auipc	a0,0x24
    80003b6e:	5fe50513          	addi	a0,a0,1534 # 80028168 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	b38080e7          	jalr	-1224(ra) # 800066aa <release>

  if(ff.type == FD_PIPE){
    80003b7a:	4785                	li	a5,1
    80003b7c:	04f90463          	beq	s2,a5,80003bc4 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b80:	3979                	addiw	s2,s2,-2
    80003b82:	4785                	li	a5,1
    80003b84:	0527fb63          	bgeu	a5,s2,80003bda <fileclose+0xbe>
    80003b88:	7902                	ld	s2,32(sp)
    80003b8a:	69e2                	ld	s3,24(sp)
    80003b8c:	6a42                	ld	s4,16(sp)
    80003b8e:	6aa2                	ld	s5,8(sp)
    80003b90:	a02d                	j	80003bba <fileclose+0x9e>
    80003b92:	f04a                	sd	s2,32(sp)
    80003b94:	ec4e                	sd	s3,24(sp)
    80003b96:	e852                	sd	s4,16(sp)
    80003b98:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b9a:	00005517          	auipc	a0,0x5
    80003b9e:	94650513          	addi	a0,a0,-1722 # 800084e0 <etext+0x4e0>
    80003ba2:	00002097          	auipc	ra,0x2
    80003ba6:	4da080e7          	jalr	1242(ra) # 8000607c <panic>
    release(&ftable.lock);
    80003baa:	00024517          	auipc	a0,0x24
    80003bae:	5be50513          	addi	a0,a0,1470 # 80028168 <ftable>
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	af8080e7          	jalr	-1288(ra) # 800066aa <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003bba:	70e2                	ld	ra,56(sp)
    80003bbc:	7442                	ld	s0,48(sp)
    80003bbe:	74a2                	ld	s1,40(sp)
    80003bc0:	6121                	addi	sp,sp,64
    80003bc2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc4:	85d6                	mv	a1,s5
    80003bc6:	8552                	mv	a0,s4
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	3a2080e7          	jalr	930(ra) # 80003f6a <pipeclose>
    80003bd0:	7902                	ld	s2,32(sp)
    80003bd2:	69e2                	ld	s3,24(sp)
    80003bd4:	6a42                	ld	s4,16(sp)
    80003bd6:	6aa2                	ld	s5,8(sp)
    80003bd8:	b7cd                	j	80003bba <fileclose+0x9e>
    begin_op();
    80003bda:	00000097          	auipc	ra,0x0
    80003bde:	a78080e7          	jalr	-1416(ra) # 80003652 <begin_op>
    iput(ff.ip);
    80003be2:	854e                	mv	a0,s3
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	25a080e7          	jalr	602(ra) # 80002e3e <iput>
    end_op();
    80003bec:	00000097          	auipc	ra,0x0
    80003bf0:	ae0080e7          	jalr	-1312(ra) # 800036cc <end_op>
    80003bf4:	7902                	ld	s2,32(sp)
    80003bf6:	69e2                	ld	s3,24(sp)
    80003bf8:	6a42                	ld	s4,16(sp)
    80003bfa:	6aa2                	ld	s5,8(sp)
    80003bfc:	bf7d                	j	80003bba <fileclose+0x9e>

0000000080003bfe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bfe:	715d                	addi	sp,sp,-80
    80003c00:	e486                	sd	ra,72(sp)
    80003c02:	e0a2                	sd	s0,64(sp)
    80003c04:	fc26                	sd	s1,56(sp)
    80003c06:	f44e                	sd	s3,40(sp)
    80003c08:	0880                	addi	s0,sp,80
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	254080e7          	jalr	596(ra) # 80000e62 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c16:	409c                	lw	a5,0(s1)
    80003c18:	37f9                	addiw	a5,a5,-2
    80003c1a:	4705                	li	a4,1
    80003c1c:	04f76863          	bltu	a4,a5,80003c6c <filestat+0x6e>
    80003c20:	f84a                	sd	s2,48(sp)
    80003c22:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c24:	6c88                	ld	a0,24(s1)
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	05a080e7          	jalr	90(ra) # 80002c80 <ilock>
    stati(f->ip, &st);
    80003c2e:	fb840593          	addi	a1,s0,-72
    80003c32:	6c88                	ld	a0,24(s1)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	2da080e7          	jalr	730(ra) # 80002f0e <stati>
    iunlock(f->ip);
    80003c3c:	6c88                	ld	a0,24(s1)
    80003c3e:	fffff097          	auipc	ra,0xfffff
    80003c42:	108080e7          	jalr	264(ra) # 80002d46 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c46:	46e1                	li	a3,24
    80003c48:	fb840613          	addi	a2,s0,-72
    80003c4c:	85ce                	mv	a1,s3
    80003c4e:	05093503          	ld	a0,80(s2)
    80003c52:	ffffd097          	auipc	ra,0xffffd
    80003c56:	eac080e7          	jalr	-340(ra) # 80000afe <copyout>
    80003c5a:	41f5551b          	sraiw	a0,a0,0x1f
    80003c5e:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c60:	60a6                	ld	ra,72(sp)
    80003c62:	6406                	ld	s0,64(sp)
    80003c64:	74e2                	ld	s1,56(sp)
    80003c66:	79a2                	ld	s3,40(sp)
    80003c68:	6161                	addi	sp,sp,80
    80003c6a:	8082                	ret
  return -1;
    80003c6c:	557d                	li	a0,-1
    80003c6e:	bfcd                	j	80003c60 <filestat+0x62>

0000000080003c70 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c70:	7179                	addi	sp,sp,-48
    80003c72:	f406                	sd	ra,40(sp)
    80003c74:	f022                	sd	s0,32(sp)
    80003c76:	e84a                	sd	s2,16(sp)
    80003c78:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c7a:	00854783          	lbu	a5,8(a0)
    80003c7e:	cbc5                	beqz	a5,80003d2e <fileread+0xbe>
    80003c80:	ec26                	sd	s1,24(sp)
    80003c82:	e44e                	sd	s3,8(sp)
    80003c84:	84aa                	mv	s1,a0
    80003c86:	89ae                	mv	s3,a1
    80003c88:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c8a:	411c                	lw	a5,0(a0)
    80003c8c:	4705                	li	a4,1
    80003c8e:	04e78963          	beq	a5,a4,80003ce0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c92:	470d                	li	a4,3
    80003c94:	04e78f63          	beq	a5,a4,80003cf2 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c98:	4709                	li	a4,2
    80003c9a:	08e79263          	bne	a5,a4,80003d1e <fileread+0xae>
    ilock(f->ip);
    80003c9e:	6d08                	ld	a0,24(a0)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	fe0080e7          	jalr	-32(ra) # 80002c80 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ca8:	874a                	mv	a4,s2
    80003caa:	5094                	lw	a3,32(s1)
    80003cac:	864e                	mv	a2,s3
    80003cae:	4585                	li	a1,1
    80003cb0:	6c88                	ld	a0,24(s1)
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	286080e7          	jalr	646(ra) # 80002f38 <readi>
    80003cba:	892a                	mv	s2,a0
    80003cbc:	00a05563          	blez	a0,80003cc6 <fileread+0x56>
      f->off += r;
    80003cc0:	509c                	lw	a5,32(s1)
    80003cc2:	9fa9                	addw	a5,a5,a0
    80003cc4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cc6:	6c88                	ld	a0,24(s1)
    80003cc8:	fffff097          	auipc	ra,0xfffff
    80003ccc:	07e080e7          	jalr	126(ra) # 80002d46 <iunlock>
    80003cd0:	64e2                	ld	s1,24(sp)
    80003cd2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003cd4:	854a                	mv	a0,s2
    80003cd6:	70a2                	ld	ra,40(sp)
    80003cd8:	7402                	ld	s0,32(sp)
    80003cda:	6942                	ld	s2,16(sp)
    80003cdc:	6145                	addi	sp,sp,48
    80003cde:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ce0:	6908                	ld	a0,16(a0)
    80003ce2:	00000097          	auipc	ra,0x0
    80003ce6:	3fa080e7          	jalr	1018(ra) # 800040dc <piperead>
    80003cea:	892a                	mv	s2,a0
    80003cec:	64e2                	ld	s1,24(sp)
    80003cee:	69a2                	ld	s3,8(sp)
    80003cf0:	b7d5                	j	80003cd4 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cf2:	02451783          	lh	a5,36(a0)
    80003cf6:	03079693          	slli	a3,a5,0x30
    80003cfa:	92c1                	srli	a3,a3,0x30
    80003cfc:	4725                	li	a4,9
    80003cfe:	02d76a63          	bltu	a4,a3,80003d32 <fileread+0xc2>
    80003d02:	0792                	slli	a5,a5,0x4
    80003d04:	00024717          	auipc	a4,0x24
    80003d08:	3c470713          	addi	a4,a4,964 # 800280c8 <devsw>
    80003d0c:	97ba                	add	a5,a5,a4
    80003d0e:	639c                	ld	a5,0(a5)
    80003d10:	c78d                	beqz	a5,80003d3a <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d12:	4505                	li	a0,1
    80003d14:	9782                	jalr	a5
    80003d16:	892a                	mv	s2,a0
    80003d18:	64e2                	ld	s1,24(sp)
    80003d1a:	69a2                	ld	s3,8(sp)
    80003d1c:	bf65                	j	80003cd4 <fileread+0x64>
    panic("fileread");
    80003d1e:	00004517          	auipc	a0,0x4
    80003d22:	7d250513          	addi	a0,a0,2002 # 800084f0 <etext+0x4f0>
    80003d26:	00002097          	auipc	ra,0x2
    80003d2a:	356080e7          	jalr	854(ra) # 8000607c <panic>
    return -1;
    80003d2e:	597d                	li	s2,-1
    80003d30:	b755                	j	80003cd4 <fileread+0x64>
      return -1;
    80003d32:	597d                	li	s2,-1
    80003d34:	64e2                	ld	s1,24(sp)
    80003d36:	69a2                	ld	s3,8(sp)
    80003d38:	bf71                	j	80003cd4 <fileread+0x64>
    80003d3a:	597d                	li	s2,-1
    80003d3c:	64e2                	ld	s1,24(sp)
    80003d3e:	69a2                	ld	s3,8(sp)
    80003d40:	bf51                	j	80003cd4 <fileread+0x64>

0000000080003d42 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d42:	00954783          	lbu	a5,9(a0)
    80003d46:	12078963          	beqz	a5,80003e78 <filewrite+0x136>
{
    80003d4a:	715d                	addi	sp,sp,-80
    80003d4c:	e486                	sd	ra,72(sp)
    80003d4e:	e0a2                	sd	s0,64(sp)
    80003d50:	f84a                	sd	s2,48(sp)
    80003d52:	f052                	sd	s4,32(sp)
    80003d54:	e85a                	sd	s6,16(sp)
    80003d56:	0880                	addi	s0,sp,80
    80003d58:	892a                	mv	s2,a0
    80003d5a:	8b2e                	mv	s6,a1
    80003d5c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d5e:	411c                	lw	a5,0(a0)
    80003d60:	4705                	li	a4,1
    80003d62:	02e78763          	beq	a5,a4,80003d90 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d66:	470d                	li	a4,3
    80003d68:	02e78a63          	beq	a5,a4,80003d9c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d6c:	4709                	li	a4,2
    80003d6e:	0ee79863          	bne	a5,a4,80003e5e <filewrite+0x11c>
    80003d72:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d74:	0cc05463          	blez	a2,80003e3c <filewrite+0xfa>
    80003d78:	fc26                	sd	s1,56(sp)
    80003d7a:	ec56                	sd	s5,24(sp)
    80003d7c:	e45e                	sd	s7,8(sp)
    80003d7e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d80:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d82:	6b85                	lui	s7,0x1
    80003d84:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d88:	6c05                	lui	s8,0x1
    80003d8a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d8e:	a851                	j	80003e22 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d90:	6908                	ld	a0,16(a0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	248080e7          	jalr	584(ra) # 80003fda <pipewrite>
    80003d9a:	a85d                	j	80003e50 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d9c:	02451783          	lh	a5,36(a0)
    80003da0:	03079693          	slli	a3,a5,0x30
    80003da4:	92c1                	srli	a3,a3,0x30
    80003da6:	4725                	li	a4,9
    80003da8:	0cd76a63          	bltu	a4,a3,80003e7c <filewrite+0x13a>
    80003dac:	0792                	slli	a5,a5,0x4
    80003dae:	00024717          	auipc	a4,0x24
    80003db2:	31a70713          	addi	a4,a4,794 # 800280c8 <devsw>
    80003db6:	97ba                	add	a5,a5,a4
    80003db8:	679c                	ld	a5,8(a5)
    80003dba:	c3f9                	beqz	a5,80003e80 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003dbc:	4505                	li	a0,1
    80003dbe:	9782                	jalr	a5
    80003dc0:	a841                	j	80003e50 <filewrite+0x10e>
      if(n1 > max)
    80003dc2:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	88c080e7          	jalr	-1908(ra) # 80003652 <begin_op>
      ilock(f->ip);
    80003dce:	01893503          	ld	a0,24(s2)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	eae080e7          	jalr	-338(ra) # 80002c80 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dda:	8756                	mv	a4,s5
    80003ddc:	02092683          	lw	a3,32(s2)
    80003de0:	01698633          	add	a2,s3,s6
    80003de4:	4585                	li	a1,1
    80003de6:	01893503          	ld	a0,24(s2)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	252080e7          	jalr	594(ra) # 8000303c <writei>
    80003df2:	84aa                	mv	s1,a0
    80003df4:	00a05763          	blez	a0,80003e02 <filewrite+0xc0>
        f->off += r;
    80003df8:	02092783          	lw	a5,32(s2)
    80003dfc:	9fa9                	addw	a5,a5,a0
    80003dfe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e02:	01893503          	ld	a0,24(s2)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	f40080e7          	jalr	-192(ra) # 80002d46 <iunlock>
      end_op();
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	8be080e7          	jalr	-1858(ra) # 800036cc <end_op>

      if(r != n1){
    80003e16:	029a9563          	bne	s5,s1,80003e40 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e1a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e1e:	0149da63          	bge	s3,s4,80003e32 <filewrite+0xf0>
      int n1 = n - i;
    80003e22:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e26:	0004879b          	sext.w	a5,s1
    80003e2a:	f8fbdce3          	bge	s7,a5,80003dc2 <filewrite+0x80>
    80003e2e:	84e2                	mv	s1,s8
    80003e30:	bf49                	j	80003dc2 <filewrite+0x80>
    80003e32:	74e2                	ld	s1,56(sp)
    80003e34:	6ae2                	ld	s5,24(sp)
    80003e36:	6ba2                	ld	s7,8(sp)
    80003e38:	6c02                	ld	s8,0(sp)
    80003e3a:	a039                	j	80003e48 <filewrite+0x106>
    int i = 0;
    80003e3c:	4981                	li	s3,0
    80003e3e:	a029                	j	80003e48 <filewrite+0x106>
    80003e40:	74e2                	ld	s1,56(sp)
    80003e42:	6ae2                	ld	s5,24(sp)
    80003e44:	6ba2                	ld	s7,8(sp)
    80003e46:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e48:	033a1e63          	bne	s4,s3,80003e84 <filewrite+0x142>
    80003e4c:	8552                	mv	a0,s4
    80003e4e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e50:	60a6                	ld	ra,72(sp)
    80003e52:	6406                	ld	s0,64(sp)
    80003e54:	7942                	ld	s2,48(sp)
    80003e56:	7a02                	ld	s4,32(sp)
    80003e58:	6b42                	ld	s6,16(sp)
    80003e5a:	6161                	addi	sp,sp,80
    80003e5c:	8082                	ret
    80003e5e:	fc26                	sd	s1,56(sp)
    80003e60:	f44e                	sd	s3,40(sp)
    80003e62:	ec56                	sd	s5,24(sp)
    80003e64:	e45e                	sd	s7,8(sp)
    80003e66:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e68:	00004517          	auipc	a0,0x4
    80003e6c:	69850513          	addi	a0,a0,1688 # 80008500 <etext+0x500>
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	20c080e7          	jalr	524(ra) # 8000607c <panic>
    return -1;
    80003e78:	557d                	li	a0,-1
}
    80003e7a:	8082                	ret
      return -1;
    80003e7c:	557d                	li	a0,-1
    80003e7e:	bfc9                	j	80003e50 <filewrite+0x10e>
    80003e80:	557d                	li	a0,-1
    80003e82:	b7f9                	j	80003e50 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e84:	557d                	li	a0,-1
    80003e86:	79a2                	ld	s3,40(sp)
    80003e88:	b7e1                	j	80003e50 <filewrite+0x10e>

0000000080003e8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e8a:	7179                	addi	sp,sp,-48
    80003e8c:	f406                	sd	ra,40(sp)
    80003e8e:	f022                	sd	s0,32(sp)
    80003e90:	ec26                	sd	s1,24(sp)
    80003e92:	e052                	sd	s4,0(sp)
    80003e94:	1800                	addi	s0,sp,48
    80003e96:	84aa                	mv	s1,a0
    80003e98:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9a:	0005b023          	sd	zero,0(a1)
    80003e9e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	bbe080e7          	jalr	-1090(ra) # 80003a60 <filealloc>
    80003eaa:	e088                	sd	a0,0(s1)
    80003eac:	cd49                	beqz	a0,80003f46 <pipealloc+0xbc>
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	bb2080e7          	jalr	-1102(ra) # 80003a60 <filealloc>
    80003eb6:	00aa3023          	sd	a0,0(s4)
    80003eba:	c141                	beqz	a0,80003f3a <pipealloc+0xb0>
    80003ebc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ebe:	ffffc097          	auipc	ra,0xffffc
    80003ec2:	25c080e7          	jalr	604(ra) # 8000011a <kalloc>
    80003ec6:	892a                	mv	s2,a0
    80003ec8:	c13d                	beqz	a0,80003f2e <pipealloc+0xa4>
    80003eca:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003ecc:	4985                	li	s3,1
    80003ece:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ed2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ed6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ede:	00004597          	auipc	a1,0x4
    80003ee2:	63258593          	addi	a1,a1,1586 # 80008510 <etext+0x510>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	680080e7          	jalr	1664(ra) # 80006566 <initlock>
  (*f0)->type = FD_PIPE;
    80003eee:	609c                	ld	a5,0(s1)
    80003ef0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ef4:	609c                	ld	a5,0(s1)
    80003ef6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003efa:	609c                	ld	a5,0(s1)
    80003efc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f00:	609c                	ld	a5,0(s1)
    80003f02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f06:	000a3783          	ld	a5,0(s4)
    80003f0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f0e:	000a3783          	ld	a5,0(s4)
    80003f12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f16:	000a3783          	ld	a5,0(s4)
    80003f1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f1e:	000a3783          	ld	a5,0(s4)
    80003f22:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f26:	4501                	li	a0,0
    80003f28:	6942                	ld	s2,16(sp)
    80003f2a:	69a2                	ld	s3,8(sp)
    80003f2c:	a03d                	j	80003f5a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f2e:	6088                	ld	a0,0(s1)
    80003f30:	c119                	beqz	a0,80003f36 <pipealloc+0xac>
    80003f32:	6942                	ld	s2,16(sp)
    80003f34:	a029                	j	80003f3e <pipealloc+0xb4>
    80003f36:	6942                	ld	s2,16(sp)
    80003f38:	a039                	j	80003f46 <pipealloc+0xbc>
    80003f3a:	6088                	ld	a0,0(s1)
    80003f3c:	c50d                	beqz	a0,80003f66 <pipealloc+0xdc>
    fileclose(*f0);
    80003f3e:	00000097          	auipc	ra,0x0
    80003f42:	bde080e7          	jalr	-1058(ra) # 80003b1c <fileclose>
  if(*f1)
    80003f46:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f4a:	557d                	li	a0,-1
  if(*f1)
    80003f4c:	c799                	beqz	a5,80003f5a <pipealloc+0xd0>
    fileclose(*f1);
    80003f4e:	853e                	mv	a0,a5
    80003f50:	00000097          	auipc	ra,0x0
    80003f54:	bcc080e7          	jalr	-1076(ra) # 80003b1c <fileclose>
  return -1;
    80003f58:	557d                	li	a0,-1
}
    80003f5a:	70a2                	ld	ra,40(sp)
    80003f5c:	7402                	ld	s0,32(sp)
    80003f5e:	64e2                	ld	s1,24(sp)
    80003f60:	6a02                	ld	s4,0(sp)
    80003f62:	6145                	addi	sp,sp,48
    80003f64:	8082                	ret
  return -1;
    80003f66:	557d                	li	a0,-1
    80003f68:	bfcd                	j	80003f5a <pipealloc+0xd0>

0000000080003f6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f6a:	1101                	addi	sp,sp,-32
    80003f6c:	ec06                	sd	ra,24(sp)
    80003f6e:	e822                	sd	s0,16(sp)
    80003f70:	e426                	sd	s1,8(sp)
    80003f72:	e04a                	sd	s2,0(sp)
    80003f74:	1000                	addi	s0,sp,32
    80003f76:	84aa                	mv	s1,a0
    80003f78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f7a:	00002097          	auipc	ra,0x2
    80003f7e:	67c080e7          	jalr	1660(ra) # 800065f6 <acquire>
  if(writable){
    80003f82:	02090d63          	beqz	s2,80003fbc <pipeclose+0x52>
    pi->writeopen = 0;
    80003f86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f8a:	21848513          	addi	a0,s1,536
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	760080e7          	jalr	1888(ra) # 800016ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f96:	2204b783          	ld	a5,544(s1)
    80003f9a:	eb95                	bnez	a5,80003fce <pipeclose+0x64>
    release(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	70c080e7          	jalr	1804(ra) # 800066aa <release>
    kfree((char*)pi);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	ffffc097          	auipc	ra,0xffffc
    80003fac:	074080e7          	jalr	116(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fb0:	60e2                	ld	ra,24(sp)
    80003fb2:	6442                	ld	s0,16(sp)
    80003fb4:	64a2                	ld	s1,8(sp)
    80003fb6:	6902                	ld	s2,0(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret
    pi->readopen = 0;
    80003fbc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fc0:	21c48513          	addi	a0,s1,540
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	72a080e7          	jalr	1834(ra) # 800016ee <wakeup>
    80003fcc:	b7e9                	j	80003f96 <pipeclose+0x2c>
    release(&pi->lock);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	6da080e7          	jalr	1754(ra) # 800066aa <release>
}
    80003fd8:	bfe1                	j	80003fb0 <pipeclose+0x46>

0000000080003fda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fda:	711d                	addi	sp,sp,-96
    80003fdc:	ec86                	sd	ra,88(sp)
    80003fde:	e8a2                	sd	s0,80(sp)
    80003fe0:	e4a6                	sd	s1,72(sp)
    80003fe2:	e0ca                	sd	s2,64(sp)
    80003fe4:	fc4e                	sd	s3,56(sp)
    80003fe6:	f852                	sd	s4,48(sp)
    80003fe8:	f456                	sd	s5,40(sp)
    80003fea:	1080                	addi	s0,sp,96
    80003fec:	84aa                	mv	s1,a0
    80003fee:	8aae                	mv	s5,a1
    80003ff0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	e70080e7          	jalr	-400(ra) # 80000e62 <myproc>
    80003ffa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	5f8080e7          	jalr	1528(ra) # 800065f6 <acquire>
  while(i < n){
    80004006:	0d405563          	blez	s4,800040d0 <pipewrite+0xf6>
    8000400a:	f05a                	sd	s6,32(sp)
    8000400c:	ec5e                	sd	s7,24(sp)
    8000400e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004010:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004012:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004014:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004018:	21c48b93          	addi	s7,s1,540
    8000401c:	a089                	j	8000405e <pipewrite+0x84>
      release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	68a080e7          	jalr	1674(ra) # 800066aa <release>
      return -1;
    80004028:	597d                	li	s2,-1
    8000402a:	7b02                	ld	s6,32(sp)
    8000402c:	6be2                	ld	s7,24(sp)
    8000402e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004030:	854a                	mv	a0,s2
    80004032:	60e6                	ld	ra,88(sp)
    80004034:	6446                	ld	s0,80(sp)
    80004036:	64a6                	ld	s1,72(sp)
    80004038:	6906                	ld	s2,64(sp)
    8000403a:	79e2                	ld	s3,56(sp)
    8000403c:	7a42                	ld	s4,48(sp)
    8000403e:	7aa2                	ld	s5,40(sp)
    80004040:	6125                	addi	sp,sp,96
    80004042:	8082                	ret
      wakeup(&pi->nread);
    80004044:	8562                	mv	a0,s8
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	6a8080e7          	jalr	1704(ra) # 800016ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000404e:	85a6                	mv	a1,s1
    80004050:	855e                	mv	a0,s7
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	510080e7          	jalr	1296(ra) # 80001562 <sleep>
  while(i < n){
    8000405a:	05495c63          	bge	s2,s4,800040b2 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000405e:	2204a783          	lw	a5,544(s1)
    80004062:	dfd5                	beqz	a5,8000401e <pipewrite+0x44>
    80004064:	0289a783          	lw	a5,40(s3)
    80004068:	fbdd                	bnez	a5,8000401e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000406a:	2184a783          	lw	a5,536(s1)
    8000406e:	21c4a703          	lw	a4,540(s1)
    80004072:	2007879b          	addiw	a5,a5,512
    80004076:	fcf707e3          	beq	a4,a5,80004044 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000407a:	4685                	li	a3,1
    8000407c:	01590633          	add	a2,s2,s5
    80004080:	faf40593          	addi	a1,s0,-81
    80004084:	0509b503          	ld	a0,80(s3)
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	b02080e7          	jalr	-1278(ra) # 80000b8a <copyin>
    80004090:	05650263          	beq	a0,s6,800040d4 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004094:	21c4a783          	lw	a5,540(s1)
    80004098:	0017871b          	addiw	a4,a5,1
    8000409c:	20e4ae23          	sw	a4,540(s1)
    800040a0:	1ff7f793          	andi	a5,a5,511
    800040a4:	97a6                	add	a5,a5,s1
    800040a6:	faf44703          	lbu	a4,-81(s0)
    800040aa:	00e78c23          	sb	a4,24(a5)
      i++;
    800040ae:	2905                	addiw	s2,s2,1
    800040b0:	b76d                	j	8000405a <pipewrite+0x80>
    800040b2:	7b02                	ld	s6,32(sp)
    800040b4:	6be2                	ld	s7,24(sp)
    800040b6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040b8:	21848513          	addi	a0,s1,536
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	632080e7          	jalr	1586(ra) # 800016ee <wakeup>
  release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	5e4080e7          	jalr	1508(ra) # 800066aa <release>
  return i;
    800040ce:	b78d                	j	80004030 <pipewrite+0x56>
  int i = 0;
    800040d0:	4901                	li	s2,0
    800040d2:	b7dd                	j	800040b8 <pipewrite+0xde>
    800040d4:	7b02                	ld	s6,32(sp)
    800040d6:	6be2                	ld	s7,24(sp)
    800040d8:	6c42                	ld	s8,16(sp)
    800040da:	bff9                	j	800040b8 <pipewrite+0xde>

00000000800040dc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040dc:	715d                	addi	sp,sp,-80
    800040de:	e486                	sd	ra,72(sp)
    800040e0:	e0a2                	sd	s0,64(sp)
    800040e2:	fc26                	sd	s1,56(sp)
    800040e4:	f84a                	sd	s2,48(sp)
    800040e6:	f44e                	sd	s3,40(sp)
    800040e8:	f052                	sd	s4,32(sp)
    800040ea:	ec56                	sd	s5,24(sp)
    800040ec:	0880                	addi	s0,sp,80
    800040ee:	84aa                	mv	s1,a0
    800040f0:	892e                	mv	s2,a1
    800040f2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	d6e080e7          	jalr	-658(ra) # 80000e62 <myproc>
    800040fc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	4f6080e7          	jalr	1270(ra) # 800065f6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004108:	2184a703          	lw	a4,536(s1)
    8000410c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004110:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004114:	02f71663          	bne	a4,a5,80004140 <piperead+0x64>
    80004118:	2244a783          	lw	a5,548(s1)
    8000411c:	cb9d                	beqz	a5,80004152 <piperead+0x76>
    if(pr->killed){
    8000411e:	028a2783          	lw	a5,40(s4)
    80004122:	e38d                	bnez	a5,80004144 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004124:	85a6                	mv	a1,s1
    80004126:	854e                	mv	a0,s3
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	43a080e7          	jalr	1082(ra) # 80001562 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004130:	2184a703          	lw	a4,536(s1)
    80004134:	21c4a783          	lw	a5,540(s1)
    80004138:	fef700e3          	beq	a4,a5,80004118 <piperead+0x3c>
    8000413c:	e85a                	sd	s6,16(sp)
    8000413e:	a819                	j	80004154 <piperead+0x78>
    80004140:	e85a                	sd	s6,16(sp)
    80004142:	a809                	j	80004154 <piperead+0x78>
      release(&pi->lock);
    80004144:	8526                	mv	a0,s1
    80004146:	00002097          	auipc	ra,0x2
    8000414a:	564080e7          	jalr	1380(ra) # 800066aa <release>
      return -1;
    8000414e:	59fd                	li	s3,-1
    80004150:	a0a5                	j	800041b8 <piperead+0xdc>
    80004152:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004154:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004156:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004158:	05505463          	blez	s5,800041a0 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000415c:	2184a783          	lw	a5,536(s1)
    80004160:	21c4a703          	lw	a4,540(s1)
    80004164:	02f70e63          	beq	a4,a5,800041a0 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004168:	0017871b          	addiw	a4,a5,1
    8000416c:	20e4ac23          	sw	a4,536(s1)
    80004170:	1ff7f793          	andi	a5,a5,511
    80004174:	97a6                	add	a5,a5,s1
    80004176:	0187c783          	lbu	a5,24(a5)
    8000417a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000417e:	4685                	li	a3,1
    80004180:	fbf40613          	addi	a2,s0,-65
    80004184:	85ca                	mv	a1,s2
    80004186:	050a3503          	ld	a0,80(s4)
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	974080e7          	jalr	-1676(ra) # 80000afe <copyout>
    80004192:	01650763          	beq	a0,s6,800041a0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004196:	2985                	addiw	s3,s3,1
    80004198:	0905                	addi	s2,s2,1
    8000419a:	fd3a91e3          	bne	s5,s3,8000415c <piperead+0x80>
    8000419e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041a0:	21c48513          	addi	a0,s1,540
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	54a080e7          	jalr	1354(ra) # 800016ee <wakeup>
  release(&pi->lock);
    800041ac:	8526                	mv	a0,s1
    800041ae:	00002097          	auipc	ra,0x2
    800041b2:	4fc080e7          	jalr	1276(ra) # 800066aa <release>
    800041b6:	6b42                	ld	s6,16(sp)
  return i;
}
    800041b8:	854e                	mv	a0,s3
    800041ba:	60a6                	ld	ra,72(sp)
    800041bc:	6406                	ld	s0,64(sp)
    800041be:	74e2                	ld	s1,56(sp)
    800041c0:	7942                	ld	s2,48(sp)
    800041c2:	79a2                	ld	s3,40(sp)
    800041c4:	7a02                	ld	s4,32(sp)
    800041c6:	6ae2                	ld	s5,24(sp)
    800041c8:	6161                	addi	sp,sp,80
    800041ca:	8082                	ret

00000000800041cc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041cc:	df010113          	addi	sp,sp,-528
    800041d0:	20113423          	sd	ra,520(sp)
    800041d4:	20813023          	sd	s0,512(sp)
    800041d8:	ffa6                	sd	s1,504(sp)
    800041da:	fbca                	sd	s2,496(sp)
    800041dc:	0c00                	addi	s0,sp,528
    800041de:	892a                	mv	s2,a0
    800041e0:	dea43c23          	sd	a0,-520(s0)
    800041e4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	c7a080e7          	jalr	-902(ra) # 80000e62 <myproc>
    800041f0:	84aa                	mv	s1,a0

  begin_op();
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	460080e7          	jalr	1120(ra) # 80003652 <begin_op>

  if((ip = namei(path)) == 0){
    800041fa:	854a                	mv	a0,s2
    800041fc:	fffff097          	auipc	ra,0xfffff
    80004200:	256080e7          	jalr	598(ra) # 80003452 <namei>
    80004204:	c135                	beqz	a0,80004268 <exec+0x9c>
    80004206:	f3d2                	sd	s4,480(sp)
    80004208:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	a76080e7          	jalr	-1418(ra) # 80002c80 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004212:	04000713          	li	a4,64
    80004216:	4681                	li	a3,0
    80004218:	e5040613          	addi	a2,s0,-432
    8000421c:	4581                	li	a1,0
    8000421e:	8552                	mv	a0,s4
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	d18080e7          	jalr	-744(ra) # 80002f38 <readi>
    80004228:	04000793          	li	a5,64
    8000422c:	00f51a63          	bne	a0,a5,80004240 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004230:	e5042703          	lw	a4,-432(s0)
    80004234:	464c47b7          	lui	a5,0x464c4
    80004238:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000423c:	02f70c63          	beq	a4,a5,80004274 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004240:	8552                	mv	a0,s4
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	ca4080e7          	jalr	-860(ra) # 80002ee6 <iunlockput>
    end_op();
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	482080e7          	jalr	1154(ra) # 800036cc <end_op>
  }
  return -1;
    80004252:	557d                	li	a0,-1
    80004254:	7a1e                	ld	s4,480(sp)
}
    80004256:	20813083          	ld	ra,520(sp)
    8000425a:	20013403          	ld	s0,512(sp)
    8000425e:	74fe                	ld	s1,504(sp)
    80004260:	795e                	ld	s2,496(sp)
    80004262:	21010113          	addi	sp,sp,528
    80004266:	8082                	ret
    end_op();
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	464080e7          	jalr	1124(ra) # 800036cc <end_op>
    return -1;
    80004270:	557d                	li	a0,-1
    80004272:	b7d5                	j	80004256 <exec+0x8a>
    80004274:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004276:	8526                	mv	a0,s1
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	cae080e7          	jalr	-850(ra) # 80000f26 <proc_pagetable>
    80004280:	8b2a                	mv	s6,a0
    80004282:	30050563          	beqz	a0,8000458c <exec+0x3c0>
    80004286:	f7ce                	sd	s3,488(sp)
    80004288:	efd6                	sd	s5,472(sp)
    8000428a:	e7de                	sd	s7,456(sp)
    8000428c:	e3e2                	sd	s8,448(sp)
    8000428e:	ff66                	sd	s9,440(sp)
    80004290:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004292:	e7042d03          	lw	s10,-400(s0)
    80004296:	e8845783          	lhu	a5,-376(s0)
    8000429a:	14078563          	beqz	a5,800043e4 <exec+0x218>
    8000429e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042a0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a2:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800042a4:	6c85                	lui	s9,0x1
    800042a6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042aa:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042ae:	6a85                	lui	s5,0x1
    800042b0:	a0b5                	j	8000431c <exec+0x150>
      panic("loadseg: address should exist");
    800042b2:	00004517          	auipc	a0,0x4
    800042b6:	26650513          	addi	a0,a0,614 # 80008518 <etext+0x518>
    800042ba:	00002097          	auipc	ra,0x2
    800042be:	dc2080e7          	jalr	-574(ra) # 8000607c <panic>
    if(sz - i < PGSIZE)
    800042c2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042c4:	8726                	mv	a4,s1
    800042c6:	012c06bb          	addw	a3,s8,s2
    800042ca:	4581                	li	a1,0
    800042cc:	8552                	mv	a0,s4
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	c6a080e7          	jalr	-918(ra) # 80002f38 <readi>
    800042d6:	2501                	sext.w	a0,a0
    800042d8:	26a49e63          	bne	s1,a0,80004554 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800042dc:	012a893b          	addw	s2,s5,s2
    800042e0:	03397563          	bgeu	s2,s3,8000430a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800042e4:	02091593          	slli	a1,s2,0x20
    800042e8:	9181                	srli	a1,a1,0x20
    800042ea:	95de                	add	a1,a1,s7
    800042ec:	855a                	mv	a0,s6
    800042ee:	ffffc097          	auipc	ra,0xffffc
    800042f2:	20a080e7          	jalr	522(ra) # 800004f8 <walkaddr>
    800042f6:	862a                	mv	a2,a0
    if(pa == 0)
    800042f8:	dd4d                	beqz	a0,800042b2 <exec+0xe6>
    if(sz - i < PGSIZE)
    800042fa:	412984bb          	subw	s1,s3,s2
    800042fe:	0004879b          	sext.w	a5,s1
    80004302:	fcfcf0e3          	bgeu	s9,a5,800042c2 <exec+0xf6>
    80004306:	84d6                	mv	s1,s5
    80004308:	bf6d                	j	800042c2 <exec+0xf6>
    sz = sz1;
    8000430a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000430e:	2d85                	addiw	s11,s11,1
    80004310:	038d0d1b          	addiw	s10,s10,56
    80004314:	e8845783          	lhu	a5,-376(s0)
    80004318:	06fddf63          	bge	s11,a5,80004396 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000431c:	2d01                	sext.w	s10,s10
    8000431e:	03800713          	li	a4,56
    80004322:	86ea                	mv	a3,s10
    80004324:	e1840613          	addi	a2,s0,-488
    80004328:	4581                	li	a1,0
    8000432a:	8552                	mv	a0,s4
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	c0c080e7          	jalr	-1012(ra) # 80002f38 <readi>
    80004334:	03800793          	li	a5,56
    80004338:	1ef51863          	bne	a0,a5,80004528 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000433c:	e1842783          	lw	a5,-488(s0)
    80004340:	4705                	li	a4,1
    80004342:	fce796e3          	bne	a5,a4,8000430e <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004346:	e4043603          	ld	a2,-448(s0)
    8000434a:	e3843783          	ld	a5,-456(s0)
    8000434e:	1ef66163          	bltu	a2,a5,80004530 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004352:	e2843783          	ld	a5,-472(s0)
    80004356:	963e                	add	a2,a2,a5
    80004358:	1ef66063          	bltu	a2,a5,80004538 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000435c:	85a6                	mv	a1,s1
    8000435e:	855a                	mv	a0,s6
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	54e080e7          	jalr	1358(ra) # 800008ae <uvmalloc>
    80004368:	e0a43423          	sd	a0,-504(s0)
    8000436c:	1c050a63          	beqz	a0,80004540 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004370:	e2843b83          	ld	s7,-472(s0)
    80004374:	df043783          	ld	a5,-528(s0)
    80004378:	00fbf7b3          	and	a5,s7,a5
    8000437c:	1c079a63          	bnez	a5,80004550 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004380:	e2042c03          	lw	s8,-480(s0)
    80004384:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004388:	00098463          	beqz	s3,80004390 <exec+0x1c4>
    8000438c:	4901                	li	s2,0
    8000438e:	bf99                	j	800042e4 <exec+0x118>
    sz = sz1;
    80004390:	e0843483          	ld	s1,-504(s0)
    80004394:	bfad                	j	8000430e <exec+0x142>
    80004396:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004398:	8552                	mv	a0,s4
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	b4c080e7          	jalr	-1204(ra) # 80002ee6 <iunlockput>
  end_op();
    800043a2:	fffff097          	auipc	ra,0xfffff
    800043a6:	32a080e7          	jalr	810(ra) # 800036cc <end_op>
  p = myproc();
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	ab8080e7          	jalr	-1352(ra) # 80000e62 <myproc>
    800043b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043b4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800043b8:	6985                	lui	s3,0x1
    800043ba:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800043bc:	99a6                	add	s3,s3,s1
    800043be:	77fd                	lui	a5,0xfffff
    800043c0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043c4:	6609                	lui	a2,0x2
    800043c6:	964e                	add	a2,a2,s3
    800043c8:	85ce                	mv	a1,s3
    800043ca:	855a                	mv	a0,s6
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	4e2080e7          	jalr	1250(ra) # 800008ae <uvmalloc>
    800043d4:	892a                	mv	s2,a0
    800043d6:	e0a43423          	sd	a0,-504(s0)
    800043da:	e519                	bnez	a0,800043e8 <exec+0x21c>
  if(pagetable)
    800043dc:	e1343423          	sd	s3,-504(s0)
    800043e0:	4a01                	li	s4,0
    800043e2:	aa95                	j	80004556 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043e4:	4481                	li	s1,0
    800043e6:	bf4d                	j	80004398 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043e8:	75f9                	lui	a1,0xffffe
    800043ea:	95aa                	add	a1,a1,a0
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	6de080e7          	jalr	1758(ra) # 80000acc <uvmclear>
  stackbase = sp - PGSIZE;
    800043f6:	7bfd                	lui	s7,0xfffff
    800043f8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043fa:	e0043783          	ld	a5,-512(s0)
    800043fe:	6388                	ld	a0,0(a5)
    80004400:	c52d                	beqz	a0,8000446a <exec+0x29e>
    80004402:	e9040993          	addi	s3,s0,-368
    80004406:	f9040c13          	addi	s8,s0,-112
    8000440a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000440c:	ffffc097          	auipc	ra,0xffffc
    80004410:	ee2080e7          	jalr	-286(ra) # 800002ee <strlen>
    80004414:	0015079b          	addiw	a5,a0,1
    80004418:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000441c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004420:	13796463          	bltu	s2,s7,80004548 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004424:	e0043d03          	ld	s10,-512(s0)
    80004428:	000d3a03          	ld	s4,0(s10)
    8000442c:	8552                	mv	a0,s4
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	ec0080e7          	jalr	-320(ra) # 800002ee <strlen>
    80004436:	0015069b          	addiw	a3,a0,1
    8000443a:	8652                	mv	a2,s4
    8000443c:	85ca                	mv	a1,s2
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	6be080e7          	jalr	1726(ra) # 80000afe <copyout>
    80004448:	10054263          	bltz	a0,8000454c <exec+0x380>
    ustack[argc] = sp;
    8000444c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004450:	0485                	addi	s1,s1,1
    80004452:	008d0793          	addi	a5,s10,8
    80004456:	e0f43023          	sd	a5,-512(s0)
    8000445a:	008d3503          	ld	a0,8(s10)
    8000445e:	c909                	beqz	a0,80004470 <exec+0x2a4>
    if(argc >= MAXARG)
    80004460:	09a1                	addi	s3,s3,8
    80004462:	fb8995e3          	bne	s3,s8,8000440c <exec+0x240>
  ip = 0;
    80004466:	4a01                	li	s4,0
    80004468:	a0fd                	j	80004556 <exec+0x38a>
  sp = sz;
    8000446a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000446e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004470:	00349793          	slli	a5,s1,0x3
    80004474:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffc9d50>
    80004478:	97a2                	add	a5,a5,s0
    8000447a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000447e:	00148693          	addi	a3,s1,1
    80004482:	068e                	slli	a3,a3,0x3
    80004484:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004488:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000448c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004490:	f57966e3          	bltu	s2,s7,800043dc <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004494:	e9040613          	addi	a2,s0,-368
    80004498:	85ca                	mv	a1,s2
    8000449a:	855a                	mv	a0,s6
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	662080e7          	jalr	1634(ra) # 80000afe <copyout>
    800044a4:	0e054663          	bltz	a0,80004590 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800044a8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044b0:	df843783          	ld	a5,-520(s0)
    800044b4:	0007c703          	lbu	a4,0(a5)
    800044b8:	cf11                	beqz	a4,800044d4 <exec+0x308>
    800044ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044bc:	02f00693          	li	a3,47
    800044c0:	a039                	j	800044ce <exec+0x302>
      last = s+1;
    800044c2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044c6:	0785                	addi	a5,a5,1
    800044c8:	fff7c703          	lbu	a4,-1(a5)
    800044cc:	c701                	beqz	a4,800044d4 <exec+0x308>
    if(*s == '/')
    800044ce:	fed71ce3          	bne	a4,a3,800044c6 <exec+0x2fa>
    800044d2:	bfc5                	j	800044c2 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800044d4:	4641                	li	a2,16
    800044d6:	df843583          	ld	a1,-520(s0)
    800044da:	158a8513          	addi	a0,s5,344
    800044de:	ffffc097          	auipc	ra,0xffffc
    800044e2:	dde080e7          	jalr	-546(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800044e6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044ea:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800044ee:	e0843783          	ld	a5,-504(s0)
    800044f2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044f6:	058ab783          	ld	a5,88(s5)
    800044fa:	e6843703          	ld	a4,-408(s0)
    800044fe:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004500:	058ab783          	ld	a5,88(s5)
    80004504:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004508:	85e6                	mv	a1,s9
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	ab8080e7          	jalr	-1352(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004512:	0004851b          	sext.w	a0,s1
    80004516:	79be                	ld	s3,488(sp)
    80004518:	7a1e                	ld	s4,480(sp)
    8000451a:	6afe                	ld	s5,472(sp)
    8000451c:	6b5e                	ld	s6,464(sp)
    8000451e:	6bbe                	ld	s7,456(sp)
    80004520:	6c1e                	ld	s8,448(sp)
    80004522:	7cfa                	ld	s9,440(sp)
    80004524:	7d5a                	ld	s10,432(sp)
    80004526:	bb05                	j	80004256 <exec+0x8a>
    80004528:	e0943423          	sd	s1,-504(s0)
    8000452c:	7dba                	ld	s11,424(sp)
    8000452e:	a025                	j	80004556 <exec+0x38a>
    80004530:	e0943423          	sd	s1,-504(s0)
    80004534:	7dba                	ld	s11,424(sp)
    80004536:	a005                	j	80004556 <exec+0x38a>
    80004538:	e0943423          	sd	s1,-504(s0)
    8000453c:	7dba                	ld	s11,424(sp)
    8000453e:	a821                	j	80004556 <exec+0x38a>
    80004540:	e0943423          	sd	s1,-504(s0)
    80004544:	7dba                	ld	s11,424(sp)
    80004546:	a801                	j	80004556 <exec+0x38a>
  ip = 0;
    80004548:	4a01                	li	s4,0
    8000454a:	a031                	j	80004556 <exec+0x38a>
    8000454c:	4a01                	li	s4,0
  if(pagetable)
    8000454e:	a021                	j	80004556 <exec+0x38a>
    80004550:	7dba                	ld	s11,424(sp)
    80004552:	a011                	j	80004556 <exec+0x38a>
    80004554:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004556:	e0843583          	ld	a1,-504(s0)
    8000455a:	855a                	mv	a0,s6
    8000455c:	ffffd097          	auipc	ra,0xffffd
    80004560:	a66080e7          	jalr	-1434(ra) # 80000fc2 <proc_freepagetable>
  return -1;
    80004564:	557d                	li	a0,-1
  if(ip){
    80004566:	000a1b63          	bnez	s4,8000457c <exec+0x3b0>
    8000456a:	79be                	ld	s3,488(sp)
    8000456c:	7a1e                	ld	s4,480(sp)
    8000456e:	6afe                	ld	s5,472(sp)
    80004570:	6b5e                	ld	s6,464(sp)
    80004572:	6bbe                	ld	s7,456(sp)
    80004574:	6c1e                	ld	s8,448(sp)
    80004576:	7cfa                	ld	s9,440(sp)
    80004578:	7d5a                	ld	s10,432(sp)
    8000457a:	b9f1                	j	80004256 <exec+0x8a>
    8000457c:	79be                	ld	s3,488(sp)
    8000457e:	6afe                	ld	s5,472(sp)
    80004580:	6b5e                	ld	s6,464(sp)
    80004582:	6bbe                	ld	s7,456(sp)
    80004584:	6c1e                	ld	s8,448(sp)
    80004586:	7cfa                	ld	s9,440(sp)
    80004588:	7d5a                	ld	s10,432(sp)
    8000458a:	b95d                	j	80004240 <exec+0x74>
    8000458c:	6b5e                	ld	s6,464(sp)
    8000458e:	b94d                	j	80004240 <exec+0x74>
  sz = sz1;
    80004590:	e0843983          	ld	s3,-504(s0)
    80004594:	b5a1                	j	800043dc <exec+0x210>

0000000080004596 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004596:	7179                	addi	sp,sp,-48
    80004598:	f406                	sd	ra,40(sp)
    8000459a:	f022                	sd	s0,32(sp)
    8000459c:	ec26                	sd	s1,24(sp)
    8000459e:	e84a                	sd	s2,16(sp)
    800045a0:	1800                	addi	s0,sp,48
    800045a2:	892e                	mv	s2,a1
    800045a4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045a6:	fdc40593          	addi	a1,s0,-36
    800045aa:	ffffe097          	auipc	ra,0xffffe
    800045ae:	b64080e7          	jalr	-1180(ra) # 8000210e <argint>
    800045b2:	04054063          	bltz	a0,800045f2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045b6:	fdc42703          	lw	a4,-36(s0)
    800045ba:	47bd                	li	a5,15
    800045bc:	02e7ed63          	bltu	a5,a4,800045f6 <argfd+0x60>
    800045c0:	ffffd097          	auipc	ra,0xffffd
    800045c4:	8a2080e7          	jalr	-1886(ra) # 80000e62 <myproc>
    800045c8:	fdc42703          	lw	a4,-36(s0)
    800045cc:	01a70793          	addi	a5,a4,26
    800045d0:	078e                	slli	a5,a5,0x3
    800045d2:	953e                	add	a0,a0,a5
    800045d4:	611c                	ld	a5,0(a0)
    800045d6:	c395                	beqz	a5,800045fa <argfd+0x64>
    return -1;
  if(pfd)
    800045d8:	00090463          	beqz	s2,800045e0 <argfd+0x4a>
    *pfd = fd;
    800045dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e0:	4501                	li	a0,0
  if(pf)
    800045e2:	c091                	beqz	s1,800045e6 <argfd+0x50>
    *pf = f;
    800045e4:	e09c                	sd	a5,0(s1)
}
    800045e6:	70a2                	ld	ra,40(sp)
    800045e8:	7402                	ld	s0,32(sp)
    800045ea:	64e2                	ld	s1,24(sp)
    800045ec:	6942                	ld	s2,16(sp)
    800045ee:	6145                	addi	sp,sp,48
    800045f0:	8082                	ret
    return -1;
    800045f2:	557d                	li	a0,-1
    800045f4:	bfcd                	j	800045e6 <argfd+0x50>
    return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	b7fd                	j	800045e6 <argfd+0x50>
    800045fa:	557d                	li	a0,-1
    800045fc:	b7ed                	j	800045e6 <argfd+0x50>

00000000800045fe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045fe:	1101                	addi	sp,sp,-32
    80004600:	ec06                	sd	ra,24(sp)
    80004602:	e822                	sd	s0,16(sp)
    80004604:	e426                	sd	s1,8(sp)
    80004606:	1000                	addi	s0,sp,32
    80004608:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000460a:	ffffd097          	auipc	ra,0xffffd
    8000460e:	858080e7          	jalr	-1960(ra) # 80000e62 <myproc>
    80004612:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004614:	0d050793          	addi	a5,a0,208
    80004618:	4501                	li	a0,0
    8000461a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000461c:	6398                	ld	a4,0(a5)
    8000461e:	cb19                	beqz	a4,80004634 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004620:	2505                	addiw	a0,a0,1
    80004622:	07a1                	addi	a5,a5,8
    80004624:	fed51ce3          	bne	a0,a3,8000461c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004628:	557d                	li	a0,-1
}
    8000462a:	60e2                	ld	ra,24(sp)
    8000462c:	6442                	ld	s0,16(sp)
    8000462e:	64a2                	ld	s1,8(sp)
    80004630:	6105                	addi	sp,sp,32
    80004632:	8082                	ret
      p->ofile[fd] = f;
    80004634:	01a50793          	addi	a5,a0,26
    80004638:	078e                	slli	a5,a5,0x3
    8000463a:	963e                	add	a2,a2,a5
    8000463c:	e204                	sd	s1,0(a2)
      return fd;
    8000463e:	b7f5                	j	8000462a <fdalloc+0x2c>

0000000080004640 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004640:	715d                	addi	sp,sp,-80
    80004642:	e486                	sd	ra,72(sp)
    80004644:	e0a2                	sd	s0,64(sp)
    80004646:	fc26                	sd	s1,56(sp)
    80004648:	f84a                	sd	s2,48(sp)
    8000464a:	f44e                	sd	s3,40(sp)
    8000464c:	f052                	sd	s4,32(sp)
    8000464e:	ec56                	sd	s5,24(sp)
    80004650:	0880                	addi	s0,sp,80
    80004652:	8aae                	mv	s5,a1
    80004654:	8a32                	mv	s4,a2
    80004656:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004658:	fb040593          	addi	a1,s0,-80
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	e14080e7          	jalr	-492(ra) # 80003470 <nameiparent>
    80004664:	892a                	mv	s2,a0
    80004666:	12050c63          	beqz	a0,8000479e <create+0x15e>
    return 0;

  ilock(dp);
    8000466a:	ffffe097          	auipc	ra,0xffffe
    8000466e:	616080e7          	jalr	1558(ra) # 80002c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004672:	4601                	li	a2,0
    80004674:	fb040593          	addi	a1,s0,-80
    80004678:	854a                	mv	a0,s2
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	b06080e7          	jalr	-1274(ra) # 80003180 <dirlookup>
    80004682:	84aa                	mv	s1,a0
    80004684:	c539                	beqz	a0,800046d2 <create+0x92>
    iunlockput(dp);
    80004686:	854a                	mv	a0,s2
    80004688:	fffff097          	auipc	ra,0xfffff
    8000468c:	85e080e7          	jalr	-1954(ra) # 80002ee6 <iunlockput>
    ilock(ip);
    80004690:	8526                	mv	a0,s1
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	5ee080e7          	jalr	1518(ra) # 80002c80 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000469a:	4789                	li	a5,2
    8000469c:	02fa9463          	bne	s5,a5,800046c4 <create+0x84>
    800046a0:	0444d783          	lhu	a5,68(s1)
    800046a4:	37f9                	addiw	a5,a5,-2
    800046a6:	17c2                	slli	a5,a5,0x30
    800046a8:	93c1                	srli	a5,a5,0x30
    800046aa:	4705                	li	a4,1
    800046ac:	00f76c63          	bltu	a4,a5,800046c4 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b0:	8526                	mv	a0,s1
    800046b2:	60a6                	ld	ra,72(sp)
    800046b4:	6406                	ld	s0,64(sp)
    800046b6:	74e2                	ld	s1,56(sp)
    800046b8:	7942                	ld	s2,48(sp)
    800046ba:	79a2                	ld	s3,40(sp)
    800046bc:	7a02                	ld	s4,32(sp)
    800046be:	6ae2                	ld	s5,24(sp)
    800046c0:	6161                	addi	sp,sp,80
    800046c2:	8082                	ret
    iunlockput(ip);
    800046c4:	8526                	mv	a0,s1
    800046c6:	fffff097          	auipc	ra,0xfffff
    800046ca:	820080e7          	jalr	-2016(ra) # 80002ee6 <iunlockput>
    return 0;
    800046ce:	4481                	li	s1,0
    800046d0:	b7c5                	j	800046b0 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046d2:	85d6                	mv	a1,s5
    800046d4:	00092503          	lw	a0,0(s2)
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	414080e7          	jalr	1044(ra) # 80002aec <ialloc>
    800046e0:	84aa                	mv	s1,a0
    800046e2:	c139                	beqz	a0,80004728 <create+0xe8>
  ilock(ip);
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	59c080e7          	jalr	1436(ra) # 80002c80 <ilock>
  ip->major = major;
    800046ec:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800046f0:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800046f4:	4985                	li	s3,1
    800046f6:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800046fa:	8526                	mv	a0,s1
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	4b8080e7          	jalr	1208(ra) # 80002bb4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004704:	033a8a63          	beq	s5,s3,80004738 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004708:	40d0                	lw	a2,4(s1)
    8000470a:	fb040593          	addi	a1,s0,-80
    8000470e:	854a                	mv	a0,s2
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	c80080e7          	jalr	-896(ra) # 80003390 <dirlink>
    80004718:	06054b63          	bltz	a0,8000478e <create+0x14e>
  iunlockput(dp);
    8000471c:	854a                	mv	a0,s2
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	7c8080e7          	jalr	1992(ra) # 80002ee6 <iunlockput>
  return ip;
    80004726:	b769                	j	800046b0 <create+0x70>
    panic("create: ialloc");
    80004728:	00004517          	auipc	a0,0x4
    8000472c:	e1050513          	addi	a0,a0,-496 # 80008538 <etext+0x538>
    80004730:	00002097          	auipc	ra,0x2
    80004734:	94c080e7          	jalr	-1716(ra) # 8000607c <panic>
    dp->nlink++;  // for ".."
    80004738:	04a95783          	lhu	a5,74(s2)
    8000473c:	2785                	addiw	a5,a5,1
    8000473e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004742:	854a                	mv	a0,s2
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	470080e7          	jalr	1136(ra) # 80002bb4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000474c:	40d0                	lw	a2,4(s1)
    8000474e:	00004597          	auipc	a1,0x4
    80004752:	dfa58593          	addi	a1,a1,-518 # 80008548 <etext+0x548>
    80004756:	8526                	mv	a0,s1
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	c38080e7          	jalr	-968(ra) # 80003390 <dirlink>
    80004760:	00054f63          	bltz	a0,8000477e <create+0x13e>
    80004764:	00492603          	lw	a2,4(s2)
    80004768:	00004597          	auipc	a1,0x4
    8000476c:	de858593          	addi	a1,a1,-536 # 80008550 <etext+0x550>
    80004770:	8526                	mv	a0,s1
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	c1e080e7          	jalr	-994(ra) # 80003390 <dirlink>
    8000477a:	f80557e3          	bgez	a0,80004708 <create+0xc8>
      panic("create dots");
    8000477e:	00004517          	auipc	a0,0x4
    80004782:	dda50513          	addi	a0,a0,-550 # 80008558 <etext+0x558>
    80004786:	00002097          	auipc	ra,0x2
    8000478a:	8f6080e7          	jalr	-1802(ra) # 8000607c <panic>
    panic("create: dirlink");
    8000478e:	00004517          	auipc	a0,0x4
    80004792:	dda50513          	addi	a0,a0,-550 # 80008568 <etext+0x568>
    80004796:	00002097          	auipc	ra,0x2
    8000479a:	8e6080e7          	jalr	-1818(ra) # 8000607c <panic>
    return 0;
    8000479e:	84aa                	mv	s1,a0
    800047a0:	bf01                	j	800046b0 <create+0x70>

00000000800047a2 <sys_dup>:
{
    800047a2:	7179                	addi	sp,sp,-48
    800047a4:	f406                	sd	ra,40(sp)
    800047a6:	f022                	sd	s0,32(sp)
    800047a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047aa:	fd840613          	addi	a2,s0,-40
    800047ae:	4581                	li	a1,0
    800047b0:	4501                	li	a0,0
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	de4080e7          	jalr	-540(ra) # 80004596 <argfd>
    return -1;
    800047ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047bc:	02054763          	bltz	a0,800047ea <sys_dup+0x48>
    800047c0:	ec26                	sd	s1,24(sp)
    800047c2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800047c4:	fd843903          	ld	s2,-40(s0)
    800047c8:	854a                	mv	a0,s2
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	e34080e7          	jalr	-460(ra) # 800045fe <fdalloc>
    800047d2:	84aa                	mv	s1,a0
    return -1;
    800047d4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047d6:	00054f63          	bltz	a0,800047f4 <sys_dup+0x52>
  filedup(f);
    800047da:	854a                	mv	a0,s2
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	2ee080e7          	jalr	750(ra) # 80003aca <filedup>
  return fd;
    800047e4:	87a6                	mv	a5,s1
    800047e6:	64e2                	ld	s1,24(sp)
    800047e8:	6942                	ld	s2,16(sp)
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	70a2                	ld	ra,40(sp)
    800047ee:	7402                	ld	s0,32(sp)
    800047f0:	6145                	addi	sp,sp,48
    800047f2:	8082                	ret
    800047f4:	64e2                	ld	s1,24(sp)
    800047f6:	6942                	ld	s2,16(sp)
    800047f8:	bfcd                	j	800047ea <sys_dup+0x48>

00000000800047fa <sys_read>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	d8c080e7          	jalr	-628(ra) # 80004596 <argfd>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	04054163          	bltz	a0,80004856 <sys_read+0x5c>
    80004818:	fe440593          	addi	a1,s0,-28
    8000481c:	4509                	li	a0,2
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	8f0080e7          	jalr	-1808(ra) # 8000210e <argint>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	02054763          	bltz	a0,80004856 <sys_read+0x5c>
    8000482c:	fd840593          	addi	a1,s0,-40
    80004830:	4505                	li	a0,1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	8fe080e7          	jalr	-1794(ra) # 80002130 <argaddr>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	00054d63          	bltz	a0,80004856 <sys_read+0x5c>
  return fileread(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	424080e7          	jalr	1060(ra) # 80003c70 <fileread>
    80004854:	87aa                	mv	a5,a0
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	6145                	addi	sp,sp,48
    8000485e:	8082                	ret

0000000080004860 <sys_write>:
{
    80004860:	7179                	addi	sp,sp,-48
    80004862:	f406                	sd	ra,40(sp)
    80004864:	f022                	sd	s0,32(sp)
    80004866:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004868:	fe840613          	addi	a2,s0,-24
    8000486c:	4581                	li	a1,0
    8000486e:	4501                	li	a0,0
    80004870:	00000097          	auipc	ra,0x0
    80004874:	d26080e7          	jalr	-730(ra) # 80004596 <argfd>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487a:	04054163          	bltz	a0,800048bc <sys_write+0x5c>
    8000487e:	fe440593          	addi	a1,s0,-28
    80004882:	4509                	li	a0,2
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	88a080e7          	jalr	-1910(ra) # 8000210e <argint>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	02054763          	bltz	a0,800048bc <sys_write+0x5c>
    80004892:	fd840593          	addi	a1,s0,-40
    80004896:	4505                	li	a0,1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	898080e7          	jalr	-1896(ra) # 80002130 <argaddr>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	00054d63          	bltz	a0,800048bc <sys_write+0x5c>
  return filewrite(f, p, n);
    800048a6:	fe442603          	lw	a2,-28(s0)
    800048aa:	fd843583          	ld	a1,-40(s0)
    800048ae:	fe843503          	ld	a0,-24(s0)
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	490080e7          	jalr	1168(ra) # 80003d42 <filewrite>
    800048ba:	87aa                	mv	a5,a0
}
    800048bc:	853e                	mv	a0,a5
    800048be:	70a2                	ld	ra,40(sp)
    800048c0:	7402                	ld	s0,32(sp)
    800048c2:	6145                	addi	sp,sp,48
    800048c4:	8082                	ret

00000000800048c6 <sys_close>:
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ce:	fe040613          	addi	a2,s0,-32
    800048d2:	fec40593          	addi	a1,s0,-20
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	cbe080e7          	jalr	-834(ra) # 80004596 <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e2:	02054463          	bltz	a0,8000490a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048e6:	ffffc097          	auipc	ra,0xffffc
    800048ea:	57c080e7          	jalr	1404(ra) # 80000e62 <myproc>
    800048ee:	fec42783          	lw	a5,-20(s0)
    800048f2:	07e9                	addi	a5,a5,26
    800048f4:	078e                	slli	a5,a5,0x3
    800048f6:	953e                	add	a0,a0,a5
    800048f8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048fc:	fe043503          	ld	a0,-32(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	21c080e7          	jalr	540(ra) # 80003b1c <fileclose>
  return 0;
    80004908:	4781                	li	a5,0
}
    8000490a:	853e                	mv	a0,a5
    8000490c:	60e2                	ld	ra,24(sp)
    8000490e:	6442                	ld	s0,16(sp)
    80004910:	6105                	addi	sp,sp,32
    80004912:	8082                	ret

0000000080004914 <sys_fstat>:
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491c:	fe840613          	addi	a2,s0,-24
    80004920:	4581                	li	a1,0
    80004922:	4501                	li	a0,0
    80004924:	00000097          	auipc	ra,0x0
    80004928:	c72080e7          	jalr	-910(ra) # 80004596 <argfd>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000492e:	02054563          	bltz	a0,80004958 <sys_fstat+0x44>
    80004932:	fe040593          	addi	a1,s0,-32
    80004936:	4505                	li	a0,1
    80004938:	ffffd097          	auipc	ra,0xffffd
    8000493c:	7f8080e7          	jalr	2040(ra) # 80002130 <argaddr>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004942:	00054b63          	bltz	a0,80004958 <sys_fstat+0x44>
  return filestat(f, st);
    80004946:	fe043583          	ld	a1,-32(s0)
    8000494a:	fe843503          	ld	a0,-24(s0)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	2b0080e7          	jalr	688(ra) # 80003bfe <filestat>
    80004956:	87aa                	mv	a5,a0
}
    80004958:	853e                	mv	a0,a5
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	6105                	addi	sp,sp,32
    80004960:	8082                	ret

0000000080004962 <sys_link>:
{
    80004962:	7169                	addi	sp,sp,-304
    80004964:	f606                	sd	ra,296(sp)
    80004966:	f222                	sd	s0,288(sp)
    80004968:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000496a:	08000613          	li	a2,128
    8000496e:	ed040593          	addi	a1,s0,-304
    80004972:	4501                	li	a0,0
    80004974:	ffffd097          	auipc	ra,0xffffd
    80004978:	7de080e7          	jalr	2014(ra) # 80002152 <argstr>
    return -1;
    8000497c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000497e:	12054663          	bltz	a0,80004aaa <sys_link+0x148>
    80004982:	08000613          	li	a2,128
    80004986:	f5040593          	addi	a1,s0,-176
    8000498a:	4505                	li	a0,1
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	7c6080e7          	jalr	1990(ra) # 80002152 <argstr>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004996:	10054a63          	bltz	a0,80004aaa <sys_link+0x148>
    8000499a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	cb6080e7          	jalr	-842(ra) # 80003652 <begin_op>
  if((ip = namei(old)) == 0){
    800049a4:	ed040513          	addi	a0,s0,-304
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	aaa080e7          	jalr	-1366(ra) # 80003452 <namei>
    800049b0:	84aa                	mv	s1,a0
    800049b2:	c949                	beqz	a0,80004a44 <sys_link+0xe2>
  ilock(ip);
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	2cc080e7          	jalr	716(ra) # 80002c80 <ilock>
  if(ip->type == T_DIR){
    800049bc:	04449703          	lh	a4,68(s1)
    800049c0:	4785                	li	a5,1
    800049c2:	08f70863          	beq	a4,a5,80004a52 <sys_link+0xf0>
    800049c6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800049c8:	04a4d783          	lhu	a5,74(s1)
    800049cc:	2785                	addiw	a5,a5,1
    800049ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	1e0080e7          	jalr	480(ra) # 80002bb4 <iupdate>
  iunlock(ip);
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	368080e7          	jalr	872(ra) # 80002d46 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e6:	fd040593          	addi	a1,s0,-48
    800049ea:	f5040513          	addi	a0,s0,-176
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	a82080e7          	jalr	-1406(ra) # 80003470 <nameiparent>
    800049f6:	892a                	mv	s2,a0
    800049f8:	cd35                	beqz	a0,80004a74 <sys_link+0x112>
  ilock(dp);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	286080e7          	jalr	646(ra) # 80002c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a02:	00092703          	lw	a4,0(s2)
    80004a06:	409c                	lw	a5,0(s1)
    80004a08:	06f71163          	bne	a4,a5,80004a6a <sys_link+0x108>
    80004a0c:	40d0                	lw	a2,4(s1)
    80004a0e:	fd040593          	addi	a1,s0,-48
    80004a12:	854a                	mv	a0,s2
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	97c080e7          	jalr	-1668(ra) # 80003390 <dirlink>
    80004a1c:	04054763          	bltz	a0,80004a6a <sys_link+0x108>
  iunlockput(dp);
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	4c4080e7          	jalr	1220(ra) # 80002ee6 <iunlockput>
  iput(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	412080e7          	jalr	1042(ra) # 80002e3e <iput>
  end_op();
    80004a34:	fffff097          	auipc	ra,0xfffff
    80004a38:	c98080e7          	jalr	-872(ra) # 800036cc <end_op>
  return 0;
    80004a3c:	4781                	li	a5,0
    80004a3e:	64f2                	ld	s1,280(sp)
    80004a40:	6952                	ld	s2,272(sp)
    80004a42:	a0a5                	j	80004aaa <sys_link+0x148>
    end_op();
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	c88080e7          	jalr	-888(ra) # 800036cc <end_op>
    return -1;
    80004a4c:	57fd                	li	a5,-1
    80004a4e:	64f2                	ld	s1,280(sp)
    80004a50:	a8a9                	j	80004aaa <sys_link+0x148>
    iunlockput(ip);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	492080e7          	jalr	1170(ra) # 80002ee6 <iunlockput>
    end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	c70080e7          	jalr	-912(ra) # 800036cc <end_op>
    return -1;
    80004a64:	57fd                	li	a5,-1
    80004a66:	64f2                	ld	s1,280(sp)
    80004a68:	a089                	j	80004aaa <sys_link+0x148>
    iunlockput(dp);
    80004a6a:	854a                	mv	a0,s2
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	47a080e7          	jalr	1146(ra) # 80002ee6 <iunlockput>
  ilock(ip);
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	20a080e7          	jalr	522(ra) # 80002c80 <ilock>
  ip->nlink--;
    80004a7e:	04a4d783          	lhu	a5,74(s1)
    80004a82:	37fd                	addiw	a5,a5,-1
    80004a84:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	12a080e7          	jalr	298(ra) # 80002bb4 <iupdate>
  iunlockput(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	452080e7          	jalr	1106(ra) # 80002ee6 <iunlockput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	c30080e7          	jalr	-976(ra) # 800036cc <end_op>
  return -1;
    80004aa4:	57fd                	li	a5,-1
    80004aa6:	64f2                	ld	s1,280(sp)
    80004aa8:	6952                	ld	s2,272(sp)
}
    80004aaa:	853e                	mv	a0,a5
    80004aac:	70b2                	ld	ra,296(sp)
    80004aae:	7412                	ld	s0,288(sp)
    80004ab0:	6155                	addi	sp,sp,304
    80004ab2:	8082                	ret

0000000080004ab4 <sys_unlink>:
{
    80004ab4:	7151                	addi	sp,sp,-240
    80004ab6:	f586                	sd	ra,232(sp)
    80004ab8:	f1a2                	sd	s0,224(sp)
    80004aba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004abc:	08000613          	li	a2,128
    80004ac0:	f3040593          	addi	a1,s0,-208
    80004ac4:	4501                	li	a0,0
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	68c080e7          	jalr	1676(ra) # 80002152 <argstr>
    80004ace:	1a054a63          	bltz	a0,80004c82 <sys_unlink+0x1ce>
    80004ad2:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	b7e080e7          	jalr	-1154(ra) # 80003652 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004adc:	fb040593          	addi	a1,s0,-80
    80004ae0:	f3040513          	addi	a0,s0,-208
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	98c080e7          	jalr	-1652(ra) # 80003470 <nameiparent>
    80004aec:	84aa                	mv	s1,a0
    80004aee:	cd71                	beqz	a0,80004bca <sys_unlink+0x116>
  ilock(dp);
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	190080e7          	jalr	400(ra) # 80002c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af8:	00004597          	auipc	a1,0x4
    80004afc:	a5058593          	addi	a1,a1,-1456 # 80008548 <etext+0x548>
    80004b00:	fb040513          	addi	a0,s0,-80
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	662080e7          	jalr	1634(ra) # 80003166 <namecmp>
    80004b0c:	14050c63          	beqz	a0,80004c64 <sys_unlink+0x1b0>
    80004b10:	00004597          	auipc	a1,0x4
    80004b14:	a4058593          	addi	a1,a1,-1472 # 80008550 <etext+0x550>
    80004b18:	fb040513          	addi	a0,s0,-80
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	64a080e7          	jalr	1610(ra) # 80003166 <namecmp>
    80004b24:	14050063          	beqz	a0,80004c64 <sys_unlink+0x1b0>
    80004b28:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b2a:	f2c40613          	addi	a2,s0,-212
    80004b2e:	fb040593          	addi	a1,s0,-80
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	64c080e7          	jalr	1612(ra) # 80003180 <dirlookup>
    80004b3c:	892a                	mv	s2,a0
    80004b3e:	12050263          	beqz	a0,80004c62 <sys_unlink+0x1ae>
  ilock(ip);
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	13e080e7          	jalr	318(ra) # 80002c80 <ilock>
  if(ip->nlink < 1)
    80004b4a:	04a91783          	lh	a5,74(s2)
    80004b4e:	08f05563          	blez	a5,80004bd8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b52:	04491703          	lh	a4,68(s2)
    80004b56:	4785                	li	a5,1
    80004b58:	08f70963          	beq	a4,a5,80004bea <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b5c:	4641                	li	a2,16
    80004b5e:	4581                	li	a1,0
    80004b60:	fc040513          	addi	a0,s0,-64
    80004b64:	ffffb097          	auipc	ra,0xffffb
    80004b68:	616080e7          	jalr	1558(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b6c:	4741                	li	a4,16
    80004b6e:	f2c42683          	lw	a3,-212(s0)
    80004b72:	fc040613          	addi	a2,s0,-64
    80004b76:	4581                	li	a1,0
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	4c2080e7          	jalr	1218(ra) # 8000303c <writei>
    80004b82:	47c1                	li	a5,16
    80004b84:	0af51b63          	bne	a0,a5,80004c3a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b88:	04491703          	lh	a4,68(s2)
    80004b8c:	4785                	li	a5,1
    80004b8e:	0af70f63          	beq	a4,a5,80004c4c <sys_unlink+0x198>
  iunlockput(dp);
    80004b92:	8526                	mv	a0,s1
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	352080e7          	jalr	850(ra) # 80002ee6 <iunlockput>
  ip->nlink--;
    80004b9c:	04a95783          	lhu	a5,74(s2)
    80004ba0:	37fd                	addiw	a5,a5,-1
    80004ba2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba6:	854a                	mv	a0,s2
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	00c080e7          	jalr	12(ra) # 80002bb4 <iupdate>
  iunlockput(ip);
    80004bb0:	854a                	mv	a0,s2
    80004bb2:	ffffe097          	auipc	ra,0xffffe
    80004bb6:	334080e7          	jalr	820(ra) # 80002ee6 <iunlockput>
  end_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	b12080e7          	jalr	-1262(ra) # 800036cc <end_op>
  return 0;
    80004bc2:	4501                	li	a0,0
    80004bc4:	64ee                	ld	s1,216(sp)
    80004bc6:	694e                	ld	s2,208(sp)
    80004bc8:	a84d                	j	80004c7a <sys_unlink+0x1c6>
    end_op();
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	b02080e7          	jalr	-1278(ra) # 800036cc <end_op>
    return -1;
    80004bd2:	557d                	li	a0,-1
    80004bd4:	64ee                	ld	s1,216(sp)
    80004bd6:	a055                	j	80004c7a <sys_unlink+0x1c6>
    80004bd8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004bda:	00004517          	auipc	a0,0x4
    80004bde:	99e50513          	addi	a0,a0,-1634 # 80008578 <etext+0x578>
    80004be2:	00001097          	auipc	ra,0x1
    80004be6:	49a080e7          	jalr	1178(ra) # 8000607c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bea:	04c92703          	lw	a4,76(s2)
    80004bee:	02000793          	li	a5,32
    80004bf2:	f6e7f5e3          	bgeu	a5,a4,80004b5c <sys_unlink+0xa8>
    80004bf6:	e5ce                	sd	s3,200(sp)
    80004bf8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bfc:	4741                	li	a4,16
    80004bfe:	86ce                	mv	a3,s3
    80004c00:	f1840613          	addi	a2,s0,-232
    80004c04:	4581                	li	a1,0
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	330080e7          	jalr	816(ra) # 80002f38 <readi>
    80004c10:	47c1                	li	a5,16
    80004c12:	00f51c63          	bne	a0,a5,80004c2a <sys_unlink+0x176>
    if(de.inum != 0)
    80004c16:	f1845783          	lhu	a5,-232(s0)
    80004c1a:	e7b5                	bnez	a5,80004c86 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c1c:	29c1                	addiw	s3,s3,16
    80004c1e:	04c92783          	lw	a5,76(s2)
    80004c22:	fcf9ede3          	bltu	s3,a5,80004bfc <sys_unlink+0x148>
    80004c26:	69ae                	ld	s3,200(sp)
    80004c28:	bf15                	j	80004b5c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	96650513          	addi	a0,a0,-1690 # 80008590 <etext+0x590>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	44a080e7          	jalr	1098(ra) # 8000607c <panic>
    80004c3a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c3c:	00004517          	auipc	a0,0x4
    80004c40:	96c50513          	addi	a0,a0,-1684 # 800085a8 <etext+0x5a8>
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	438080e7          	jalr	1080(ra) # 8000607c <panic>
    dp->nlink--;
    80004c4c:	04a4d783          	lhu	a5,74(s1)
    80004c50:	37fd                	addiw	a5,a5,-1
    80004c52:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	f5c080e7          	jalr	-164(ra) # 80002bb4 <iupdate>
    80004c60:	bf0d                	j	80004b92 <sys_unlink+0xde>
    80004c62:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c64:	8526                	mv	a0,s1
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	280080e7          	jalr	640(ra) # 80002ee6 <iunlockput>
  end_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	a5e080e7          	jalr	-1442(ra) # 800036cc <end_op>
  return -1;
    80004c76:	557d                	li	a0,-1
    80004c78:	64ee                	ld	s1,216(sp)
}
    80004c7a:	70ae                	ld	ra,232(sp)
    80004c7c:	740e                	ld	s0,224(sp)
    80004c7e:	616d                	addi	sp,sp,240
    80004c80:	8082                	ret
    return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	bfdd                	j	80004c7a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c86:	854a                	mv	a0,s2
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	25e080e7          	jalr	606(ra) # 80002ee6 <iunlockput>
    goto bad;
    80004c90:	694e                	ld	s2,208(sp)
    80004c92:	69ae                	ld	s3,200(sp)
    80004c94:	bfc1                	j	80004c64 <sys_unlink+0x1b0>

0000000080004c96 <sys_open>:

uint64
sys_open(void)
{
    80004c96:	7131                	addi	sp,sp,-192
    80004c98:	fd06                	sd	ra,184(sp)
    80004c9a:	f922                	sd	s0,176(sp)
    80004c9c:	f526                	sd	s1,168(sp)
    80004c9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca0:	08000613          	li	a2,128
    80004ca4:	f5040593          	addi	a1,s0,-176
    80004ca8:	4501                	li	a0,0
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	4a8080e7          	jalr	1192(ra) # 80002152 <argstr>
    return -1;
    80004cb2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb4:	0c054463          	bltz	a0,80004d7c <sys_open+0xe6>
    80004cb8:	f4c40593          	addi	a1,s0,-180
    80004cbc:	4505                	li	a0,1
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	450080e7          	jalr	1104(ra) # 8000210e <argint>
    80004cc6:	0a054b63          	bltz	a0,80004d7c <sys_open+0xe6>
    80004cca:	f14a                	sd	s2,160(sp)

  begin_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	986080e7          	jalr	-1658(ra) # 80003652 <begin_op>

  if(omode & O_CREATE){
    80004cd4:	f4c42783          	lw	a5,-180(s0)
    80004cd8:	2007f793          	andi	a5,a5,512
    80004cdc:	cfc5                	beqz	a5,80004d94 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cde:	4681                	li	a3,0
    80004ce0:	4601                	li	a2,0
    80004ce2:	4589                	li	a1,2
    80004ce4:	f5040513          	addi	a0,s0,-176
    80004ce8:	00000097          	auipc	ra,0x0
    80004cec:	958080e7          	jalr	-1704(ra) # 80004640 <create>
    80004cf0:	892a                	mv	s2,a0
    if(ip == 0){
    80004cf2:	c959                	beqz	a0,80004d88 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf4:	04491703          	lh	a4,68(s2)
    80004cf8:	478d                	li	a5,3
    80004cfa:	00f71763          	bne	a4,a5,80004d08 <sys_open+0x72>
    80004cfe:	04695703          	lhu	a4,70(s2)
    80004d02:	47a5                	li	a5,9
    80004d04:	0ce7ef63          	bltu	a5,a4,80004de2 <sys_open+0x14c>
    80004d08:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	d56080e7          	jalr	-682(ra) # 80003a60 <filealloc>
    80004d12:	89aa                	mv	s3,a0
    80004d14:	c965                	beqz	a0,80004e04 <sys_open+0x16e>
    80004d16:	00000097          	auipc	ra,0x0
    80004d1a:	8e8080e7          	jalr	-1816(ra) # 800045fe <fdalloc>
    80004d1e:	84aa                	mv	s1,a0
    80004d20:	0c054d63          	bltz	a0,80004dfa <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d24:	04491703          	lh	a4,68(s2)
    80004d28:	478d                	li	a5,3
    80004d2a:	0ef70a63          	beq	a4,a5,80004e1e <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d2e:	4789                	li	a5,2
    80004d30:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d34:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d38:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d3c:	f4c42783          	lw	a5,-180(s0)
    80004d40:	0017c713          	xori	a4,a5,1
    80004d44:	8b05                	andi	a4,a4,1
    80004d46:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d4a:	0037f713          	andi	a4,a5,3
    80004d4e:	00e03733          	snez	a4,a4
    80004d52:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d56:	4007f793          	andi	a5,a5,1024
    80004d5a:	c791                	beqz	a5,80004d66 <sys_open+0xd0>
    80004d5c:	04491703          	lh	a4,68(s2)
    80004d60:	4789                	li	a5,2
    80004d62:	0cf70563          	beq	a4,a5,80004e2c <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004d66:	854a                	mv	a0,s2
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	fde080e7          	jalr	-34(ra) # 80002d46 <iunlock>
  end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	95c080e7          	jalr	-1700(ra) # 800036cc <end_op>
    80004d78:	790a                	ld	s2,160(sp)
    80004d7a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	70ea                	ld	ra,184(sp)
    80004d80:	744a                	ld	s0,176(sp)
    80004d82:	74aa                	ld	s1,168(sp)
    80004d84:	6129                	addi	sp,sp,192
    80004d86:	8082                	ret
      end_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	944080e7          	jalr	-1724(ra) # 800036cc <end_op>
      return -1;
    80004d90:	790a                	ld	s2,160(sp)
    80004d92:	b7ed                	j	80004d7c <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d94:	f5040513          	addi	a0,s0,-176
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	6ba080e7          	jalr	1722(ra) # 80003452 <namei>
    80004da0:	892a                	mv	s2,a0
    80004da2:	c90d                	beqz	a0,80004dd4 <sys_open+0x13e>
    ilock(ip);
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	edc080e7          	jalr	-292(ra) # 80002c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dac:	04491703          	lh	a4,68(s2)
    80004db0:	4785                	li	a5,1
    80004db2:	f4f711e3          	bne	a4,a5,80004cf4 <sys_open+0x5e>
    80004db6:	f4c42783          	lw	a5,-180(s0)
    80004dba:	d7b9                	beqz	a5,80004d08 <sys_open+0x72>
      iunlockput(ip);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	128080e7          	jalr	296(ra) # 80002ee6 <iunlockput>
      end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	906080e7          	jalr	-1786(ra) # 800036cc <end_op>
      return -1;
    80004dce:	54fd                	li	s1,-1
    80004dd0:	790a                	ld	s2,160(sp)
    80004dd2:	b76d                	j	80004d7c <sys_open+0xe6>
      end_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	8f8080e7          	jalr	-1800(ra) # 800036cc <end_op>
      return -1;
    80004ddc:	54fd                	li	s1,-1
    80004dde:	790a                	ld	s2,160(sp)
    80004de0:	bf71                	j	80004d7c <sys_open+0xe6>
    iunlockput(ip);
    80004de2:	854a                	mv	a0,s2
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	102080e7          	jalr	258(ra) # 80002ee6 <iunlockput>
    end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	8e0080e7          	jalr	-1824(ra) # 800036cc <end_op>
    return -1;
    80004df4:	54fd                	li	s1,-1
    80004df6:	790a                	ld	s2,160(sp)
    80004df8:	b751                	j	80004d7c <sys_open+0xe6>
      fileclose(f);
    80004dfa:	854e                	mv	a0,s3
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	d20080e7          	jalr	-736(ra) # 80003b1c <fileclose>
    iunlockput(ip);
    80004e04:	854a                	mv	a0,s2
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	0e0080e7          	jalr	224(ra) # 80002ee6 <iunlockput>
    end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	8be080e7          	jalr	-1858(ra) # 800036cc <end_op>
    return -1;
    80004e16:	54fd                	li	s1,-1
    80004e18:	790a                	ld	s2,160(sp)
    80004e1a:	69ea                	ld	s3,152(sp)
    80004e1c:	b785                	j	80004d7c <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004e1e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e22:	04691783          	lh	a5,70(s2)
    80004e26:	02f99223          	sh	a5,36(s3)
    80004e2a:	b739                	j	80004d38 <sys_open+0xa2>
    itrunc(ip);
    80004e2c:	854a                	mv	a0,s2
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	f64080e7          	jalr	-156(ra) # 80002d92 <itrunc>
    80004e36:	bf05                	j	80004d66 <sys_open+0xd0>

0000000080004e38 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e38:	7175                	addi	sp,sp,-144
    80004e3a:	e506                	sd	ra,136(sp)
    80004e3c:	e122                	sd	s0,128(sp)
    80004e3e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	812080e7          	jalr	-2030(ra) # 80003652 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e48:	08000613          	li	a2,128
    80004e4c:	f7040593          	addi	a1,s0,-144
    80004e50:	4501                	li	a0,0
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	300080e7          	jalr	768(ra) # 80002152 <argstr>
    80004e5a:	02054963          	bltz	a0,80004e8c <sys_mkdir+0x54>
    80004e5e:	4681                	li	a3,0
    80004e60:	4601                	li	a2,0
    80004e62:	4585                	li	a1,1
    80004e64:	f7040513          	addi	a0,s0,-144
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	7d8080e7          	jalr	2008(ra) # 80004640 <create>
    80004e70:	cd11                	beqz	a0,80004e8c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	074080e7          	jalr	116(ra) # 80002ee6 <iunlockput>
  end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	852080e7          	jalr	-1966(ra) # 800036cc <end_op>
  return 0;
    80004e82:	4501                	li	a0,0
}
    80004e84:	60aa                	ld	ra,136(sp)
    80004e86:	640a                	ld	s0,128(sp)
    80004e88:	6149                	addi	sp,sp,144
    80004e8a:	8082                	ret
    end_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	840080e7          	jalr	-1984(ra) # 800036cc <end_op>
    return -1;
    80004e94:	557d                	li	a0,-1
    80004e96:	b7fd                	j	80004e84 <sys_mkdir+0x4c>

0000000080004e98 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e98:	7135                	addi	sp,sp,-160
    80004e9a:	ed06                	sd	ra,152(sp)
    80004e9c:	e922                	sd	s0,144(sp)
    80004e9e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	7b2080e7          	jalr	1970(ra) # 80003652 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ea8:	08000613          	li	a2,128
    80004eac:	f7040593          	addi	a1,s0,-144
    80004eb0:	4501                	li	a0,0
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	2a0080e7          	jalr	672(ra) # 80002152 <argstr>
    80004eba:	04054a63          	bltz	a0,80004f0e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ebe:	f6c40593          	addi	a1,s0,-148
    80004ec2:	4505                	li	a0,1
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	24a080e7          	jalr	586(ra) # 8000210e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ecc:	04054163          	bltz	a0,80004f0e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ed0:	f6840593          	addi	a1,s0,-152
    80004ed4:	4509                	li	a0,2
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	238080e7          	jalr	568(ra) # 8000210e <argint>
     argint(1, &major) < 0 ||
    80004ede:	02054863          	bltz	a0,80004f0e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ee2:	f6841683          	lh	a3,-152(s0)
    80004ee6:	f6c41603          	lh	a2,-148(s0)
    80004eea:	458d                	li	a1,3
    80004eec:	f7040513          	addi	a0,s0,-144
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	750080e7          	jalr	1872(ra) # 80004640 <create>
     argint(2, &minor) < 0 ||
    80004ef8:	c919                	beqz	a0,80004f0e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004efa:	ffffe097          	auipc	ra,0xffffe
    80004efe:	fec080e7          	jalr	-20(ra) # 80002ee6 <iunlockput>
  end_op();
    80004f02:	ffffe097          	auipc	ra,0xffffe
    80004f06:	7ca080e7          	jalr	1994(ra) # 800036cc <end_op>
  return 0;
    80004f0a:	4501                	li	a0,0
    80004f0c:	a031                	j	80004f18 <sys_mknod+0x80>
    end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	7be080e7          	jalr	1982(ra) # 800036cc <end_op>
    return -1;
    80004f16:	557d                	li	a0,-1
}
    80004f18:	60ea                	ld	ra,152(sp)
    80004f1a:	644a                	ld	s0,144(sp)
    80004f1c:	610d                	addi	sp,sp,160
    80004f1e:	8082                	ret

0000000080004f20 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f20:	7135                	addi	sp,sp,-160
    80004f22:	ed06                	sd	ra,152(sp)
    80004f24:	e922                	sd	s0,144(sp)
    80004f26:	e14a                	sd	s2,128(sp)
    80004f28:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	f38080e7          	jalr	-200(ra) # 80000e62 <myproc>
    80004f32:	892a                	mv	s2,a0
  
  begin_op();
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	71e080e7          	jalr	1822(ra) # 80003652 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f3c:	08000613          	li	a2,128
    80004f40:	f6040593          	addi	a1,s0,-160
    80004f44:	4501                	li	a0,0
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	20c080e7          	jalr	524(ra) # 80002152 <argstr>
    80004f4e:	04054d63          	bltz	a0,80004fa8 <sys_chdir+0x88>
    80004f52:	e526                	sd	s1,136(sp)
    80004f54:	f6040513          	addi	a0,s0,-160
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	4fa080e7          	jalr	1274(ra) # 80003452 <namei>
    80004f60:	84aa                	mv	s1,a0
    80004f62:	c131                	beqz	a0,80004fa6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	d1c080e7          	jalr	-740(ra) # 80002c80 <ilock>
  if(ip->type != T_DIR){
    80004f6c:	04449703          	lh	a4,68(s1)
    80004f70:	4785                	li	a5,1
    80004f72:	04f71163          	bne	a4,a5,80004fb4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f76:	8526                	mv	a0,s1
    80004f78:	ffffe097          	auipc	ra,0xffffe
    80004f7c:	dce080e7          	jalr	-562(ra) # 80002d46 <iunlock>
  iput(p->cwd);
    80004f80:	15093503          	ld	a0,336(s2)
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	eba080e7          	jalr	-326(ra) # 80002e3e <iput>
  end_op();
    80004f8c:	ffffe097          	auipc	ra,0xffffe
    80004f90:	740080e7          	jalr	1856(ra) # 800036cc <end_op>
  p->cwd = ip;
    80004f94:	14993823          	sd	s1,336(s2)
  return 0;
    80004f98:	4501                	li	a0,0
    80004f9a:	64aa                	ld	s1,136(sp)
}
    80004f9c:	60ea                	ld	ra,152(sp)
    80004f9e:	644a                	ld	s0,144(sp)
    80004fa0:	690a                	ld	s2,128(sp)
    80004fa2:	610d                	addi	sp,sp,160
    80004fa4:	8082                	ret
    80004fa6:	64aa                	ld	s1,136(sp)
    end_op();
    80004fa8:	ffffe097          	auipc	ra,0xffffe
    80004fac:	724080e7          	jalr	1828(ra) # 800036cc <end_op>
    return -1;
    80004fb0:	557d                	li	a0,-1
    80004fb2:	b7ed                	j	80004f9c <sys_chdir+0x7c>
    iunlockput(ip);
    80004fb4:	8526                	mv	a0,s1
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	f30080e7          	jalr	-208(ra) # 80002ee6 <iunlockput>
    end_op();
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	70e080e7          	jalr	1806(ra) # 800036cc <end_op>
    return -1;
    80004fc6:	557d                	li	a0,-1
    80004fc8:	64aa                	ld	s1,136(sp)
    80004fca:	bfc9                	j	80004f9c <sys_chdir+0x7c>

0000000080004fcc <sys_exec>:

uint64
sys_exec(void)
{
    80004fcc:	7121                	addi	sp,sp,-448
    80004fce:	ff06                	sd	ra,440(sp)
    80004fd0:	fb22                	sd	s0,432(sp)
    80004fd2:	f34a                	sd	s2,416(sp)
    80004fd4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fd6:	08000613          	li	a2,128
    80004fda:	f5040593          	addi	a1,s0,-176
    80004fde:	4501                	li	a0,0
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	172080e7          	jalr	370(ra) # 80002152 <argstr>
    return -1;
    80004fe8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fea:	0e054a63          	bltz	a0,800050de <sys_exec+0x112>
    80004fee:	e4840593          	addi	a1,s0,-440
    80004ff2:	4505                	li	a0,1
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	13c080e7          	jalr	316(ra) # 80002130 <argaddr>
    80004ffc:	0e054163          	bltz	a0,800050de <sys_exec+0x112>
    80005000:	f726                	sd	s1,424(sp)
    80005002:	ef4e                	sd	s3,408(sp)
    80005004:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005006:	10000613          	li	a2,256
    8000500a:	4581                	li	a1,0
    8000500c:	e5040513          	addi	a0,s0,-432
    80005010:	ffffb097          	auipc	ra,0xffffb
    80005014:	16a080e7          	jalr	362(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005018:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000501c:	89a6                	mv	s3,s1
    8000501e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005020:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005024:	00391513          	slli	a0,s2,0x3
    80005028:	e4040593          	addi	a1,s0,-448
    8000502c:	e4843783          	ld	a5,-440(s0)
    80005030:	953e                	add	a0,a0,a5
    80005032:	ffffd097          	auipc	ra,0xffffd
    80005036:	042080e7          	jalr	66(ra) # 80002074 <fetchaddr>
    8000503a:	02054a63          	bltz	a0,8000506e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    8000503e:	e4043783          	ld	a5,-448(s0)
    80005042:	c7b1                	beqz	a5,8000508e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005044:	ffffb097          	auipc	ra,0xffffb
    80005048:	0d6080e7          	jalr	214(ra) # 8000011a <kalloc>
    8000504c:	85aa                	mv	a1,a0
    8000504e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005052:	cd11                	beqz	a0,8000506e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005054:	6605                	lui	a2,0x1
    80005056:	e4043503          	ld	a0,-448(s0)
    8000505a:	ffffd097          	auipc	ra,0xffffd
    8000505e:	06c080e7          	jalr	108(ra) # 800020c6 <fetchstr>
    80005062:	00054663          	bltz	a0,8000506e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005066:	0905                	addi	s2,s2,1
    80005068:	09a1                	addi	s3,s3,8
    8000506a:	fb491de3          	bne	s2,s4,80005024 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506e:	f5040913          	addi	s2,s0,-176
    80005072:	6088                	ld	a0,0(s1)
    80005074:	c12d                	beqz	a0,800050d6 <sys_exec+0x10a>
    kfree(argv[i]);
    80005076:	ffffb097          	auipc	ra,0xffffb
    8000507a:	fa6080e7          	jalr	-90(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507e:	04a1                	addi	s1,s1,8
    80005080:	ff2499e3          	bne	s1,s2,80005072 <sys_exec+0xa6>
  return -1;
    80005084:	597d                	li	s2,-1
    80005086:	74ba                	ld	s1,424(sp)
    80005088:	69fa                	ld	s3,408(sp)
    8000508a:	6a5a                	ld	s4,400(sp)
    8000508c:	a889                	j	800050de <sys_exec+0x112>
      argv[i] = 0;
    8000508e:	0009079b          	sext.w	a5,s2
    80005092:	078e                	slli	a5,a5,0x3
    80005094:	fd078793          	addi	a5,a5,-48
    80005098:	97a2                	add	a5,a5,s0
    8000509a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000509e:	e5040593          	addi	a1,s0,-432
    800050a2:	f5040513          	addi	a0,s0,-176
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	126080e7          	jalr	294(ra) # 800041cc <exec>
    800050ae:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b0:	f5040993          	addi	s3,s0,-176
    800050b4:	6088                	ld	a0,0(s1)
    800050b6:	cd01                	beqz	a0,800050ce <sys_exec+0x102>
    kfree(argv[i]);
    800050b8:	ffffb097          	auipc	ra,0xffffb
    800050bc:	f64080e7          	jalr	-156(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c0:	04a1                	addi	s1,s1,8
    800050c2:	ff3499e3          	bne	s1,s3,800050b4 <sys_exec+0xe8>
    800050c6:	74ba                	ld	s1,424(sp)
    800050c8:	69fa                	ld	s3,408(sp)
    800050ca:	6a5a                	ld	s4,400(sp)
    800050cc:	a809                	j	800050de <sys_exec+0x112>
  return ret;
    800050ce:	74ba                	ld	s1,424(sp)
    800050d0:	69fa                	ld	s3,408(sp)
    800050d2:	6a5a                	ld	s4,400(sp)
    800050d4:	a029                	j	800050de <sys_exec+0x112>
  return -1;
    800050d6:	597d                	li	s2,-1
    800050d8:	74ba                	ld	s1,424(sp)
    800050da:	69fa                	ld	s3,408(sp)
    800050dc:	6a5a                	ld	s4,400(sp)
}
    800050de:	854a                	mv	a0,s2
    800050e0:	70fa                	ld	ra,440(sp)
    800050e2:	745a                	ld	s0,432(sp)
    800050e4:	791a                	ld	s2,416(sp)
    800050e6:	6139                	addi	sp,sp,448
    800050e8:	8082                	ret

00000000800050ea <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ea:	7139                	addi	sp,sp,-64
    800050ec:	fc06                	sd	ra,56(sp)
    800050ee:	f822                	sd	s0,48(sp)
    800050f0:	f426                	sd	s1,40(sp)
    800050f2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050f4:	ffffc097          	auipc	ra,0xffffc
    800050f8:	d6e080e7          	jalr	-658(ra) # 80000e62 <myproc>
    800050fc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050fe:	fd840593          	addi	a1,s0,-40
    80005102:	4501                	li	a0,0
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	02c080e7          	jalr	44(ra) # 80002130 <argaddr>
    return -1;
    8000510c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000510e:	0e054063          	bltz	a0,800051ee <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005112:	fc840593          	addi	a1,s0,-56
    80005116:	fd040513          	addi	a0,s0,-48
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	d70080e7          	jalr	-656(ra) # 80003e8a <pipealloc>
    return -1;
    80005122:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005124:	0c054563          	bltz	a0,800051ee <sys_pipe+0x104>
  fd0 = -1;
    80005128:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000512c:	fd043503          	ld	a0,-48(s0)
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	4ce080e7          	jalr	1230(ra) # 800045fe <fdalloc>
    80005138:	fca42223          	sw	a0,-60(s0)
    8000513c:	08054c63          	bltz	a0,800051d4 <sys_pipe+0xea>
    80005140:	fc843503          	ld	a0,-56(s0)
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	4ba080e7          	jalr	1210(ra) # 800045fe <fdalloc>
    8000514c:	fca42023          	sw	a0,-64(s0)
    80005150:	06054963          	bltz	a0,800051c2 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005154:	4691                	li	a3,4
    80005156:	fc440613          	addi	a2,s0,-60
    8000515a:	fd843583          	ld	a1,-40(s0)
    8000515e:	68a8                	ld	a0,80(s1)
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	99e080e7          	jalr	-1634(ra) # 80000afe <copyout>
    80005168:	02054063          	bltz	a0,80005188 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000516c:	4691                	li	a3,4
    8000516e:	fc040613          	addi	a2,s0,-64
    80005172:	fd843583          	ld	a1,-40(s0)
    80005176:	0591                	addi	a1,a1,4
    80005178:	68a8                	ld	a0,80(s1)
    8000517a:	ffffc097          	auipc	ra,0xffffc
    8000517e:	984080e7          	jalr	-1660(ra) # 80000afe <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005182:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005184:	06055563          	bgez	a0,800051ee <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005188:	fc442783          	lw	a5,-60(s0)
    8000518c:	07e9                	addi	a5,a5,26
    8000518e:	078e                	slli	a5,a5,0x3
    80005190:	97a6                	add	a5,a5,s1
    80005192:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005196:	fc042783          	lw	a5,-64(s0)
    8000519a:	07e9                	addi	a5,a5,26
    8000519c:	078e                	slli	a5,a5,0x3
    8000519e:	00f48533          	add	a0,s1,a5
    800051a2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051a6:	fd043503          	ld	a0,-48(s0)
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	972080e7          	jalr	-1678(ra) # 80003b1c <fileclose>
    fileclose(wf);
    800051b2:	fc843503          	ld	a0,-56(s0)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	966080e7          	jalr	-1690(ra) # 80003b1c <fileclose>
    return -1;
    800051be:	57fd                	li	a5,-1
    800051c0:	a03d                	j	800051ee <sys_pipe+0x104>
    if(fd0 >= 0)
    800051c2:	fc442783          	lw	a5,-60(s0)
    800051c6:	0007c763          	bltz	a5,800051d4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051ca:	07e9                	addi	a5,a5,26
    800051cc:	078e                	slli	a5,a5,0x3
    800051ce:	97a6                	add	a5,a5,s1
    800051d0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051d4:	fd043503          	ld	a0,-48(s0)
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	944080e7          	jalr	-1724(ra) # 80003b1c <fileclose>
    fileclose(wf);
    800051e0:	fc843503          	ld	a0,-56(s0)
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	938080e7          	jalr	-1736(ra) # 80003b1c <fileclose>
    return -1;
    800051ec:	57fd                	li	a5,-1
}
    800051ee:	853e                	mv	a0,a5
    800051f0:	70e2                	ld	ra,56(sp)
    800051f2:	7442                	ld	s0,48(sp)
    800051f4:	74a2                	ld	s1,40(sp)
    800051f6:	6121                	addi	sp,sp,64
    800051f8:	8082                	ret

00000000800051fa <sys_mmap>:

uint64
sys_mmap(void){
    800051fa:	711d                	addi	sp,sp,-96
    800051fc:	ec86                	sd	ra,88(sp)
    800051fe:	e8a2                	sd	s0,80(sp)
    80005200:	1080                	addi	s0,sp,96
  int prot,flags,fd,offset; //文件相关参数

  uint64 addr; // 相应内存部分起始地址
  int length;  // 映射字节数

  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005202:	fb040593          	addi	a1,s0,-80
    80005206:	4501                	li	a0,0
    80005208:	ffffd097          	auipc	ra,0xffffd
    8000520c:	f28080e7          	jalr	-216(ra) # 80002130 <argaddr>
    argint(3, &flags) || argfd(4, &fd, &f) || argint(5, &offset)) {
    return -1;
    80005210:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005212:	e579                	bnez	a0,800052e0 <sys_mmap+0xe6>
    80005214:	fac40593          	addi	a1,s0,-84
    80005218:	4505                	li	a0,1
    8000521a:	ffffd097          	auipc	ra,0xffffd
    8000521e:	ef4080e7          	jalr	-268(ra) # 8000210e <argint>
    return -1;
    80005222:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005224:	ed55                	bnez	a0,800052e0 <sys_mmap+0xe6>
    80005226:	fc440593          	addi	a1,s0,-60
    8000522a:	4509                	li	a0,2
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	ee2080e7          	jalr	-286(ra) # 8000210e <argint>
    return -1;
    80005234:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005236:	e54d                	bnez	a0,800052e0 <sys_mmap+0xe6>
    argint(3, &flags) || argfd(4, &fd, &f) || argint(5, &offset)) {
    80005238:	fc040593          	addi	a1,s0,-64
    8000523c:	450d                	li	a0,3
    8000523e:	ffffd097          	auipc	ra,0xffffd
    80005242:	ed0080e7          	jalr	-304(ra) # 8000210e <argint>
    return -1;
    80005246:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length) || argint(2, &prot) ||
    80005248:	ed41                	bnez	a0,800052e0 <sys_mmap+0xe6>
    argint(3, &flags) || argfd(4, &fd, &f) || argint(5, &offset)) {
    8000524a:	fc840613          	addi	a2,s0,-56
    8000524e:	fbc40593          	addi	a1,s0,-68
    80005252:	4511                	li	a0,4
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	342080e7          	jalr	834(ra) # 80004596 <argfd>
    return -1;
    8000525c:	57fd                	li	a5,-1
    argint(3, &flags) || argfd(4, &fd, &f) || argint(5, &offset)) {
    8000525e:	e149                	bnez	a0,800052e0 <sys_mmap+0xe6>
    80005260:	e4a6                	sd	s1,72(sp)
    80005262:	fb840593          	addi	a1,s0,-72
    80005266:	4515                	li	a0,5
    80005268:	ffffd097          	auipc	ra,0xffffd
    8000526c:	ea6080e7          	jalr	-346(ra) # 8000210e <argint>
    80005270:	84aa                	mv	s1,a0
    return -1;
    80005272:	57fd                	li	a5,-1
    argint(3, &flags) || argfd(4, &fd, &f) || argint(5, &offset)) {
    80005274:	e56d                	bnez	a0,8000535e <sys_mmap+0x164>
    80005276:	fc4e                	sd	s3,56(sp)
  }
  if(!(f->writable) && (prot & PROT_WRITE) && flags == MAP_SHARED){
    80005278:	fc843983          	ld	s3,-56(s0)
    8000527c:	0099c783          	lbu	a5,9(s3)
    80005280:	eb91                	bnez	a5,80005294 <sys_mmap+0x9a>
    80005282:	fc442783          	lw	a5,-60(s0)
    80005286:	8b89                	andi	a5,a5,2
    80005288:	c791                	beqz	a5,80005294 <sys_mmap+0x9a>
    8000528a:	fc042703          	lw	a4,-64(s0)
    8000528e:	4785                	li	a5,1
    80005290:	0cf70363          	beq	a4,a5,80005356 <sys_mmap+0x15c>
    80005294:	e0ca                	sd	s2,64(sp)
    // 若须写回 但写权限冲突
    return -1;
  }
  struct proc *p=myproc();
    80005296:	ffffc097          	auipc	ra,0xffffc
    8000529a:	bcc080e7          	jalr	-1076(ra) # 80000e62 <myproc>
    8000529e:	892a                	mv	s2,a0
  length = PGROUNDUP(length); //使用堆高位地址，因为其是从低到高生长的
    800052a0:	fac42783          	lw	a5,-84(s0)
    800052a4:	6685                	lui	a3,0x1
    800052a6:	36fd                	addiw	a3,a3,-1 # fff <_entry-0x7ffff001>
    800052a8:	9ebd                	addw	a3,a3,a5
    800052aa:	77fd                	lui	a5,0xfffff
    800052ac:	8efd                	and	a3,a3,a5
    800052ae:	2681                	sext.w	a3,a3
    800052b0:	fad42623          	sw	a3,-84(s0)
  if(p->sz > MAXVA - length){
    800052b4:	652c                	ld	a1,72(a0)
    800052b6:	4785                	li	a5,1
    800052b8:	179a                	slli	a5,a5,0x26
    800052ba:	40d78733          	sub	a4,a5,a3
    return -1;
    800052be:	57fd                	li	a5,-1
  if(p->sz > MAXVA - length){
    800052c0:	0ab76163          	bltu	a4,a1,80005362 <sys_mmap+0x168>
    800052c4:	16850793          	addi	a5,a0,360
  }

  // 遍历vma数组，寻找未使用区域映射文件
  for(int i = 0; i < VMASIZE; i++) {
    800052c8:	4641                	li	a2,16
    if(p->vma[i].valid == 0) {
    800052ca:	4398                	lw	a4,0(a5)
    800052cc:	cf19                	beqz	a4,800052ea <sys_mmap+0xf0>
  for(int i = 0; i < VMASIZE; i++) {
    800052ce:	2485                	addiw	s1,s1,1
    800052d0:	03078793          	addi	a5,a5,48 # fffffffffffff030 <end+0xffffffff7ffc9df0>
    800052d4:	fec49be3          	bne	s1,a2,800052ca <sys_mmap+0xd0>
      filedup(f); // 添加引用，不要忘记！！！
      p->sz += length;
      return p->vma[i].addr;
    }
  }
  return -1;
    800052d8:	57fd                	li	a5,-1
    800052da:	64a6                	ld	s1,72(sp)
    800052dc:	6906                	ld	s2,64(sp)
    800052de:	79e2                	ld	s3,56(sp)
}
    800052e0:	853e                	mv	a0,a5
    800052e2:	60e6                	ld	ra,88(sp)
    800052e4:	6446                	ld	s0,80(sp)
    800052e6:	6125                	addi	sp,sp,96
    800052e8:	8082                	ret
    800052ea:	f852                	sd	s4,48(sp)
      p->vma[i].valid = 1;
    800052ec:	00149a13          	slli	s4,s1,0x1
    800052f0:	009a07b3          	add	a5,s4,s1
    800052f4:	0792                	slli	a5,a5,0x4
    800052f6:	97ca                	add	a5,a5,s2
    800052f8:	4705                	li	a4,1
    800052fa:	16e7a423          	sw	a4,360(a5)
      p->vma[i].addr = p->sz;
    800052fe:	16b7b823          	sd	a1,368(a5)
      p->vma[i].length = length;
    80005302:	16d7ac23          	sw	a3,376(a5)
      p->vma[i].f = f;
    80005306:	1937b023          	sd	s3,384(a5)
      p->vma[i].prot = prot;
    8000530a:	fc442703          	lw	a4,-60(s0)
    8000530e:	18e7a423          	sw	a4,392(a5)
      p->vma[i].flags = flags;
    80005312:	fc042703          	lw	a4,-64(s0)
    80005316:	18e7a623          	sw	a4,396(a5)
      p->vma[i].fd = fd;
    8000531a:	fbc42703          	lw	a4,-68(s0)
    8000531e:	18e7a823          	sw	a4,400(a5)
      p->vma[i].offset = offset;
    80005322:	fb842703          	lw	a4,-72(s0)
    80005326:	18e7aa23          	sw	a4,404(a5)
      filedup(f); // 添加引用，不要忘记！！！
    8000532a:	854e                	mv	a0,s3
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	79e080e7          	jalr	1950(ra) # 80003aca <filedup>
      p->sz += length;
    80005334:	fac42703          	lw	a4,-84(s0)
    80005338:	04893783          	ld	a5,72(s2)
    8000533c:	97ba                	add	a5,a5,a4
    8000533e:	04f93423          	sd	a5,72(s2)
      return p->vma[i].addr;
    80005342:	9a26                	add	s4,s4,s1
    80005344:	0a12                	slli	s4,s4,0x4
    80005346:	9952                	add	s2,s2,s4
    80005348:	17093783          	ld	a5,368(s2)
    8000534c:	64a6                	ld	s1,72(sp)
    8000534e:	6906                	ld	s2,64(sp)
    80005350:	79e2                	ld	s3,56(sp)
    80005352:	7a42                	ld	s4,48(sp)
    80005354:	b771                	j	800052e0 <sys_mmap+0xe6>
    return -1;
    80005356:	57fd                	li	a5,-1
    80005358:	64a6                	ld	s1,72(sp)
    8000535a:	79e2                	ld	s3,56(sp)
    8000535c:	b751                	j	800052e0 <sys_mmap+0xe6>
    8000535e:	64a6                	ld	s1,72(sp)
    80005360:	b741                	j	800052e0 <sys_mmap+0xe6>
    80005362:	64a6                	ld	s1,72(sp)
    80005364:	6906                	ld	s2,64(sp)
    80005366:	79e2                	ld	s3,56(sp)
    80005368:	bfa5                	j	800052e0 <sys_mmap+0xe6>

000000008000536a <sys_munmap>:

//munmap
uint64
sys_munmap(void){
    8000536a:	7179                	addi	sp,sp,-48
    8000536c:	f406                	sd	ra,40(sp)
    8000536e:	f022                	sd	s0,32(sp)
    80005370:	1800                	addi	s0,sp,48
  uint64 addr;
  int length;
  if(argaddr(0, &addr) || argint(1, &length)){
    80005372:	fd840593          	addi	a1,s0,-40
    80005376:	4501                	li	a0,0
    80005378:	ffffd097          	auipc	ra,0xffffd
    8000537c:	db8080e7          	jalr	-584(ra) # 80002130 <argaddr>
    return -1;
    80005380:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length)){
    80005382:	ed6d                	bnez	a0,8000547c <sys_munmap+0x112>
    80005384:	ec26                	sd	s1,24(sp)
    80005386:	fd440593          	addi	a1,s0,-44
    8000538a:	4505                	li	a0,1
    8000538c:	ffffd097          	auipc	ra,0xffffd
    80005390:	d82080e7          	jalr	-638(ra) # 8000210e <argint>
    80005394:	84aa                	mv	s1,a0
    return -1;
    80005396:	57fd                	li	a5,-1
  if(argaddr(0, &addr) || argint(1, &length)){
    80005398:	e16d                	bnez	a0,8000547a <sys_munmap+0x110>
    8000539a:	e84a                	sd	s2,16(sp)
  }
  // 地址空间从低向高生长，优先使用了高位
  addr = PGROUNDDOWN(addr); 
    8000539c:	777d                	lui	a4,0xfffff
    8000539e:	fd843783          	ld	a5,-40(s0)
    800053a2:	8ff9                	and	a5,a5,a4
    800053a4:	fcf43c23          	sd	a5,-40(s0)
  length = PGROUNDUP(length);
    800053a8:	fd442703          	lw	a4,-44(s0)
    800053ac:	6785                	lui	a5,0x1
    800053ae:	37fd                	addiw	a5,a5,-1 # fff <_entry-0x7ffff001>
    800053b0:	9fb9                	addw	a5,a5,a4
    800053b2:	777d                	lui	a4,0xfffff
    800053b4:	8ff9                	and	a5,a5,a4
    800053b6:	fcf42a23          	sw	a5,-44(s0)
  struct proc *p = myproc();
    800053ba:	ffffc097          	auipc	ra,0xffffc
    800053be:	aa8080e7          	jalr	-1368(ra) # 80000e62 <myproc>
    800053c2:	892a                	mv	s2,a0
  struct vma *vma = 0;
  // 查找满足地址范围的vma
  for(int i = 0; i < VMASIZE; i++) {
    if (addr >= p->vma[i].addr || addr < p->vma[i].addr + p->vma[i].length) {
    800053c4:	fd843583          	ld	a1,-40(s0)
    800053c8:	17050793          	addi	a5,a0,368
  for(int i = 0; i < VMASIZE; i++) {
    800053cc:	4641                	li	a2,16
    if (addr >= p->vma[i].addr || addr < p->vma[i].addr + p->vma[i].length) {
    800053ce:	6394                	ld	a3,0(a5)
    800053d0:	00d5ff63          	bgeu	a1,a3,800053ee <sys_munmap+0x84>
    800053d4:	4798                	lw	a4,8(a5)
    800053d6:	9736                	add	a4,a4,a3
    800053d8:	00e5eb63          	bltu	a1,a4,800053ee <sys_munmap+0x84>
  for(int i = 0; i < VMASIZE; i++) {
    800053dc:	2485                	addiw	s1,s1,1
    800053de:	03078793          	addi	a5,a5,48
    800053e2:	fec496e3          	bne	s1,a2,800053ce <sys_munmap+0x64>
      break;
    }
  }
    // 若未找到则直接返回
    if(vma == 0){
      return 0;
    800053e6:	4781                	li	a5,0
    800053e8:	64e2                	ld	s1,24(sp)
    800053ea:	6942                	ld	s2,16(sp)
    800053ec:	a841                	j	8000547c <sys_munmap+0x112>
      vma = &p->vma[i];
    800053ee:	00149793          	slli	a5,s1,0x1
    800053f2:	94be                	add	s1,s1,a5
    800053f4:	0492                	slli	s1,s1,0x4
    800053f6:	16848493          	addi	s1,s1,360
    800053fa:	94ca                	add	s1,s1,s2
    if(vma == 0){
    800053fc:	c8bd                	beqz	s1,80005472 <sys_munmap+0x108>
    } 
    // 由实验要求，只需要取消地址与传入地址相同的文件的映射即可
    if(vma->addr == addr) {
    800053fe:	6498                	ld	a4,8(s1)
      if(vma->length == 0) {
        fileclose(vma->f);
        vma->valid = 0;
      }
    }
  return 0;
    80005400:	4781                	li	a5,0
    if(vma->addr == addr) {
    80005402:	00e58563          	beq	a1,a4,8000540c <sys_munmap+0xa2>
    80005406:	64e2                	ld	s1,24(sp)
    80005408:	6942                	ld	s2,16(sp)
    8000540a:	a88d                	j	8000547c <sys_munmap+0x112>
      vma->addr += length; 
    8000540c:	fd442603          	lw	a2,-44(s0)
    80005410:	9732                	add	a4,a4,a2
    80005412:	e498                	sd	a4,8(s1)
      vma->length -= length;
    80005414:	489c                	lw	a5,16(s1)
    80005416:	9f91                	subw	a5,a5,a2
    80005418:	c89c                	sw	a5,16(s1)
      if(vma->flags & MAP_SHARED){
    8000541a:	50dc                	lw	a5,36(s1)
    8000541c:	8b85                	andi	a5,a5,1
    8000541e:	eb8d                	bnez	a5,80005450 <sys_munmap+0xe6>
      uvmunmap(p->pagetable, addr, length/PGSIZE, 1);
    80005420:	fd442783          	lw	a5,-44(s0)
    80005424:	41f7d61b          	sraiw	a2,a5,0x1f
    80005428:	0146561b          	srliw	a2,a2,0x14
    8000542c:	9e3d                	addw	a2,a2,a5
    8000542e:	4685                	li	a3,1
    80005430:	40c6561b          	sraiw	a2,a2,0xc
    80005434:	fd843583          	ld	a1,-40(s0)
    80005438:	05093503          	ld	a0,80(s2)
    8000543c:	ffffb097          	auipc	ra,0xffffb
    80005440:	2c4080e7          	jalr	708(ra) # 80000700 <uvmunmap>
      if(vma->length == 0) {
    80005444:	4898                	lw	a4,16(s1)
  return 0;
    80005446:	4781                	li	a5,0
      if(vma->length == 0) {
    80005448:	cb11                	beqz	a4,8000545c <sys_munmap+0xf2>
    8000544a:	64e2                	ld	s1,24(sp)
    8000544c:	6942                	ld	s2,16(sp)
    8000544e:	a03d                	j	8000547c <sys_munmap+0x112>
        filewrite(vma->f, addr, length);
    80005450:	6c88                	ld	a0,24(s1)
    80005452:	fffff097          	auipc	ra,0xfffff
    80005456:	8f0080e7          	jalr	-1808(ra) # 80003d42 <filewrite>
    8000545a:	b7d9                	j	80005420 <sys_munmap+0xb6>
        fileclose(vma->f);
    8000545c:	6c88                	ld	a0,24(s1)
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	6be080e7          	jalr	1726(ra) # 80003b1c <fileclose>
        vma->valid = 0;
    80005466:	0004a023          	sw	zero,0(s1)
  return 0;
    8000546a:	4781                	li	a5,0
    8000546c:	64e2                	ld	s1,24(sp)
    8000546e:	6942                	ld	s2,16(sp)
    80005470:	a031                	j	8000547c <sys_munmap+0x112>
      return 0;
    80005472:	4781                	li	a5,0
    80005474:	64e2                	ld	s1,24(sp)
    80005476:	6942                	ld	s2,16(sp)
    80005478:	a011                	j	8000547c <sys_munmap+0x112>
    8000547a:	64e2                	ld	s1,24(sp)
    8000547c:	853e                	mv	a0,a5
    8000547e:	70a2                	ld	ra,40(sp)
    80005480:	7402                	ld	s0,32(sp)
    80005482:	6145                	addi	sp,sp,48
    80005484:	8082                	ret
	...

0000000080005490 <kernelvec>:
    80005490:	7111                	addi	sp,sp,-256
    80005492:	e006                	sd	ra,0(sp)
    80005494:	e40a                	sd	sp,8(sp)
    80005496:	e80e                	sd	gp,16(sp)
    80005498:	ec12                	sd	tp,24(sp)
    8000549a:	f016                	sd	t0,32(sp)
    8000549c:	f41a                	sd	t1,40(sp)
    8000549e:	f81e                	sd	t2,48(sp)
    800054a0:	fc22                	sd	s0,56(sp)
    800054a2:	e0a6                	sd	s1,64(sp)
    800054a4:	e4aa                	sd	a0,72(sp)
    800054a6:	e8ae                	sd	a1,80(sp)
    800054a8:	ecb2                	sd	a2,88(sp)
    800054aa:	f0b6                	sd	a3,96(sp)
    800054ac:	f4ba                	sd	a4,104(sp)
    800054ae:	f8be                	sd	a5,112(sp)
    800054b0:	fcc2                	sd	a6,120(sp)
    800054b2:	e146                	sd	a7,128(sp)
    800054b4:	e54a                	sd	s2,136(sp)
    800054b6:	e94e                	sd	s3,144(sp)
    800054b8:	ed52                	sd	s4,152(sp)
    800054ba:	f156                	sd	s5,160(sp)
    800054bc:	f55a                	sd	s6,168(sp)
    800054be:	f95e                	sd	s7,176(sp)
    800054c0:	fd62                	sd	s8,184(sp)
    800054c2:	e1e6                	sd	s9,192(sp)
    800054c4:	e5ea                	sd	s10,200(sp)
    800054c6:	e9ee                	sd	s11,208(sp)
    800054c8:	edf2                	sd	t3,216(sp)
    800054ca:	f1f6                	sd	t4,224(sp)
    800054cc:	f5fa                	sd	t5,232(sp)
    800054ce:	f9fe                	sd	t6,240(sp)
    800054d0:	a71fc0ef          	jal	80001f40 <kerneltrap>
    800054d4:	6082                	ld	ra,0(sp)
    800054d6:	6122                	ld	sp,8(sp)
    800054d8:	61c2                	ld	gp,16(sp)
    800054da:	7282                	ld	t0,32(sp)
    800054dc:	7322                	ld	t1,40(sp)
    800054de:	73c2                	ld	t2,48(sp)
    800054e0:	7462                	ld	s0,56(sp)
    800054e2:	6486                	ld	s1,64(sp)
    800054e4:	6526                	ld	a0,72(sp)
    800054e6:	65c6                	ld	a1,80(sp)
    800054e8:	6666                	ld	a2,88(sp)
    800054ea:	7686                	ld	a3,96(sp)
    800054ec:	7726                	ld	a4,104(sp)
    800054ee:	77c6                	ld	a5,112(sp)
    800054f0:	7866                	ld	a6,120(sp)
    800054f2:	688a                	ld	a7,128(sp)
    800054f4:	692a                	ld	s2,136(sp)
    800054f6:	69ca                	ld	s3,144(sp)
    800054f8:	6a6a                	ld	s4,152(sp)
    800054fa:	7a8a                	ld	s5,160(sp)
    800054fc:	7b2a                	ld	s6,168(sp)
    800054fe:	7bca                	ld	s7,176(sp)
    80005500:	7c6a                	ld	s8,184(sp)
    80005502:	6c8e                	ld	s9,192(sp)
    80005504:	6d2e                	ld	s10,200(sp)
    80005506:	6dce                	ld	s11,208(sp)
    80005508:	6e6e                	ld	t3,216(sp)
    8000550a:	7e8e                	ld	t4,224(sp)
    8000550c:	7f2e                	ld	t5,232(sp)
    8000550e:	7fce                	ld	t6,240(sp)
    80005510:	6111                	addi	sp,sp,256
    80005512:	10200073          	sret
    80005516:	00000013          	nop
    8000551a:	00000013          	nop
    8000551e:	0001                	nop

0000000080005520 <timervec>:
    80005520:	34051573          	csrrw	a0,mscratch,a0
    80005524:	e10c                	sd	a1,0(a0)
    80005526:	e510                	sd	a2,8(a0)
    80005528:	e914                	sd	a3,16(a0)
    8000552a:	6d0c                	ld	a1,24(a0)
    8000552c:	7110                	ld	a2,32(a0)
    8000552e:	6194                	ld	a3,0(a1)
    80005530:	96b2                	add	a3,a3,a2
    80005532:	e194                	sd	a3,0(a1)
    80005534:	4589                	li	a1,2
    80005536:	14459073          	csrw	sip,a1
    8000553a:	6914                	ld	a3,16(a0)
    8000553c:	6510                	ld	a2,8(a0)
    8000553e:	610c                	ld	a1,0(a0)
    80005540:	34051573          	csrrw	a0,mscratch,a0
    80005544:	30200073          	mret
	...

000000008000554a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000554a:	1141                	addi	sp,sp,-16
    8000554c:	e422                	sd	s0,8(sp)
    8000554e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005550:	0c0007b7          	lui	a5,0xc000
    80005554:	4705                	li	a4,1
    80005556:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005558:	0c0007b7          	lui	a5,0xc000
    8000555c:	c3d8                	sw	a4,4(a5)
}
    8000555e:	6422                	ld	s0,8(sp)
    80005560:	0141                	addi	sp,sp,16
    80005562:	8082                	ret

0000000080005564 <plicinithart>:

void
plicinithart(void)
{
    80005564:	1141                	addi	sp,sp,-16
    80005566:	e406                	sd	ra,8(sp)
    80005568:	e022                	sd	s0,0(sp)
    8000556a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	8ca080e7          	jalr	-1846(ra) # 80000e36 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005574:	0085171b          	slliw	a4,a0,0x8
    80005578:	0c0027b7          	lui	a5,0xc002
    8000557c:	97ba                	add	a5,a5,a4
    8000557e:	40200713          	li	a4,1026
    80005582:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005586:	00d5151b          	slliw	a0,a0,0xd
    8000558a:	0c2017b7          	lui	a5,0xc201
    8000558e:	97aa                	add	a5,a5,a0
    80005590:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005594:	60a2                	ld	ra,8(sp)
    80005596:	6402                	ld	s0,0(sp)
    80005598:	0141                	addi	sp,sp,16
    8000559a:	8082                	ret

000000008000559c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000559c:	1141                	addi	sp,sp,-16
    8000559e:	e406                	sd	ra,8(sp)
    800055a0:	e022                	sd	s0,0(sp)
    800055a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055a4:	ffffc097          	auipc	ra,0xffffc
    800055a8:	892080e7          	jalr	-1902(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800055ac:	00d5151b          	slliw	a0,a0,0xd
    800055b0:	0c2017b7          	lui	a5,0xc201
    800055b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800055b6:	43c8                	lw	a0,4(a5)
    800055b8:	60a2                	ld	ra,8(sp)
    800055ba:	6402                	ld	s0,0(sp)
    800055bc:	0141                	addi	sp,sp,16
    800055be:	8082                	ret

00000000800055c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055c0:	1101                	addi	sp,sp,-32
    800055c2:	ec06                	sd	ra,24(sp)
    800055c4:	e822                	sd	s0,16(sp)
    800055c6:	e426                	sd	s1,8(sp)
    800055c8:	1000                	addi	s0,sp,32
    800055ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055cc:	ffffc097          	auipc	ra,0xffffc
    800055d0:	86a080e7          	jalr	-1942(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055d4:	00d5151b          	slliw	a0,a0,0xd
    800055d8:	0c2017b7          	lui	a5,0xc201
    800055dc:	97aa                	add	a5,a5,a0
    800055de:	c3c4                	sw	s1,4(a5)
}
    800055e0:	60e2                	ld	ra,24(sp)
    800055e2:	6442                	ld	s0,16(sp)
    800055e4:	64a2                	ld	s1,8(sp)
    800055e6:	6105                	addi	sp,sp,32
    800055e8:	8082                	ret

00000000800055ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055ea:	1141                	addi	sp,sp,-16
    800055ec:	e406                	sd	ra,8(sp)
    800055ee:	e022                	sd	s0,0(sp)
    800055f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055f2:	479d                	li	a5,7
    800055f4:	06a7c863          	blt	a5,a0,80005664 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800055f8:	00025717          	auipc	a4,0x25
    800055fc:	a0870713          	addi	a4,a4,-1528 # 8002a000 <disk>
    80005600:	972a                	add	a4,a4,a0
    80005602:	6789                	lui	a5,0x2
    80005604:	97ba                	add	a5,a5,a4
    80005606:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000560a:	e7ad                	bnez	a5,80005674 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000560c:	00451793          	slli	a5,a0,0x4
    80005610:	00027717          	auipc	a4,0x27
    80005614:	9f070713          	addi	a4,a4,-1552 # 8002c000 <disk+0x2000>
    80005618:	6314                	ld	a3,0(a4)
    8000561a:	96be                	add	a3,a3,a5
    8000561c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005620:	6314                	ld	a3,0(a4)
    80005622:	96be                	add	a3,a3,a5
    80005624:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005628:	6314                	ld	a3,0(a4)
    8000562a:	96be                	add	a3,a3,a5
    8000562c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005630:	6318                	ld	a4,0(a4)
    80005632:	97ba                	add	a5,a5,a4
    80005634:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005638:	00025717          	auipc	a4,0x25
    8000563c:	9c870713          	addi	a4,a4,-1592 # 8002a000 <disk>
    80005640:	972a                	add	a4,a4,a0
    80005642:	6789                	lui	a5,0x2
    80005644:	97ba                	add	a5,a5,a4
    80005646:	4705                	li	a4,1
    80005648:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000564c:	00027517          	auipc	a0,0x27
    80005650:	9cc50513          	addi	a0,a0,-1588 # 8002c018 <disk+0x2018>
    80005654:	ffffc097          	auipc	ra,0xffffc
    80005658:	09a080e7          	jalr	154(ra) # 800016ee <wakeup>
}
    8000565c:	60a2                	ld	ra,8(sp)
    8000565e:	6402                	ld	s0,0(sp)
    80005660:	0141                	addi	sp,sp,16
    80005662:	8082                	ret
    panic("free_desc 1");
    80005664:	00003517          	auipc	a0,0x3
    80005668:	f5450513          	addi	a0,a0,-172 # 800085b8 <etext+0x5b8>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	a10080e7          	jalr	-1520(ra) # 8000607c <panic>
    panic("free_desc 2");
    80005674:	00003517          	auipc	a0,0x3
    80005678:	f5450513          	addi	a0,a0,-172 # 800085c8 <etext+0x5c8>
    8000567c:	00001097          	auipc	ra,0x1
    80005680:	a00080e7          	jalr	-1536(ra) # 8000607c <panic>

0000000080005684 <virtio_disk_init>:
{
    80005684:	1141                	addi	sp,sp,-16
    80005686:	e406                	sd	ra,8(sp)
    80005688:	e022                	sd	s0,0(sp)
    8000568a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000568c:	00003597          	auipc	a1,0x3
    80005690:	f4c58593          	addi	a1,a1,-180 # 800085d8 <etext+0x5d8>
    80005694:	00027517          	auipc	a0,0x27
    80005698:	a9450513          	addi	a0,a0,-1388 # 8002c128 <disk+0x2128>
    8000569c:	00001097          	auipc	ra,0x1
    800056a0:	eca080e7          	jalr	-310(ra) # 80006566 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056a4:	100017b7          	lui	a5,0x10001
    800056a8:	4398                	lw	a4,0(a5)
    800056aa:	2701                	sext.w	a4,a4
    800056ac:	747277b7          	lui	a5,0x74727
    800056b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056b4:	0ef71f63          	bne	a4,a5,800057b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800056b8:	100017b7          	lui	a5,0x10001
    800056bc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800056be:	439c                	lw	a5,0(a5)
    800056c0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056c2:	4705                	li	a4,1
    800056c4:	0ee79763          	bne	a5,a4,800057b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056c8:	100017b7          	lui	a5,0x10001
    800056cc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800056ce:	439c                	lw	a5,0(a5)
    800056d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800056d2:	4709                	li	a4,2
    800056d4:	0ce79f63          	bne	a5,a4,800057b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056d8:	100017b7          	lui	a5,0x10001
    800056dc:	47d8                	lw	a4,12(a5)
    800056de:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056e0:	554d47b7          	lui	a5,0x554d4
    800056e4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056e8:	0cf71563          	bne	a4,a5,800057b2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ec:	100017b7          	lui	a5,0x10001
    800056f0:	4705                	li	a4,1
    800056f2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f4:	470d                	li	a4,3
    800056f6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056f8:	10001737          	lui	a4,0x10001
    800056fc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056fe:	c7ffe737          	lui	a4,0xc7ffe
    80005702:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fc951f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005706:	8ef9                	and	a3,a3,a4
    80005708:	10001737          	lui	a4,0x10001
    8000570c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000570e:	472d                	li	a4,11
    80005710:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005712:	473d                	li	a4,15
    80005714:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005716:	100017b7          	lui	a5,0x10001
    8000571a:	6705                	lui	a4,0x1
    8000571c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000571e:	100017b7          	lui	a5,0x10001
    80005722:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005726:	100017b7          	lui	a5,0x10001
    8000572a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000572e:	439c                	lw	a5,0(a5)
    80005730:	2781                	sext.w	a5,a5
  if(max == 0)
    80005732:	cbc1                	beqz	a5,800057c2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005734:	471d                	li	a4,7
    80005736:	08f77e63          	bgeu	a4,a5,800057d2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000573a:	100017b7          	lui	a5,0x10001
    8000573e:	4721                	li	a4,8
    80005740:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005742:	6609                	lui	a2,0x2
    80005744:	4581                	li	a1,0
    80005746:	00025517          	auipc	a0,0x25
    8000574a:	8ba50513          	addi	a0,a0,-1862 # 8002a000 <disk>
    8000574e:	ffffb097          	auipc	ra,0xffffb
    80005752:	a2c080e7          	jalr	-1492(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005756:	00025697          	auipc	a3,0x25
    8000575a:	8aa68693          	addi	a3,a3,-1878 # 8002a000 <disk>
    8000575e:	00c6d713          	srli	a4,a3,0xc
    80005762:	2701                	sext.w	a4,a4
    80005764:	100017b7          	lui	a5,0x10001
    80005768:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000576a:	00027797          	auipc	a5,0x27
    8000576e:	89678793          	addi	a5,a5,-1898 # 8002c000 <disk+0x2000>
    80005772:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005774:	00025717          	auipc	a4,0x25
    80005778:	90c70713          	addi	a4,a4,-1780 # 8002a080 <disk+0x80>
    8000577c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000577e:	00026717          	auipc	a4,0x26
    80005782:	88270713          	addi	a4,a4,-1918 # 8002b000 <disk+0x1000>
    80005786:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005788:	4705                	li	a4,1
    8000578a:	00e78c23          	sb	a4,24(a5)
    8000578e:	00e78ca3          	sb	a4,25(a5)
    80005792:	00e78d23          	sb	a4,26(a5)
    80005796:	00e78da3          	sb	a4,27(a5)
    8000579a:	00e78e23          	sb	a4,28(a5)
    8000579e:	00e78ea3          	sb	a4,29(a5)
    800057a2:	00e78f23          	sb	a4,30(a5)
    800057a6:	00e78fa3          	sb	a4,31(a5)
}
    800057aa:	60a2                	ld	ra,8(sp)
    800057ac:	6402                	ld	s0,0(sp)
    800057ae:	0141                	addi	sp,sp,16
    800057b0:	8082                	ret
    panic("could not find virtio disk");
    800057b2:	00003517          	auipc	a0,0x3
    800057b6:	e3650513          	addi	a0,a0,-458 # 800085e8 <etext+0x5e8>
    800057ba:	00001097          	auipc	ra,0x1
    800057be:	8c2080e7          	jalr	-1854(ra) # 8000607c <panic>
    panic("virtio disk has no queue 0");
    800057c2:	00003517          	auipc	a0,0x3
    800057c6:	e4650513          	addi	a0,a0,-442 # 80008608 <etext+0x608>
    800057ca:	00001097          	auipc	ra,0x1
    800057ce:	8b2080e7          	jalr	-1870(ra) # 8000607c <panic>
    panic("virtio disk max queue too short");
    800057d2:	00003517          	auipc	a0,0x3
    800057d6:	e5650513          	addi	a0,a0,-426 # 80008628 <etext+0x628>
    800057da:	00001097          	auipc	ra,0x1
    800057de:	8a2080e7          	jalr	-1886(ra) # 8000607c <panic>

00000000800057e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057e2:	7159                	addi	sp,sp,-112
    800057e4:	f486                	sd	ra,104(sp)
    800057e6:	f0a2                	sd	s0,96(sp)
    800057e8:	eca6                	sd	s1,88(sp)
    800057ea:	e8ca                	sd	s2,80(sp)
    800057ec:	e4ce                	sd	s3,72(sp)
    800057ee:	e0d2                	sd	s4,64(sp)
    800057f0:	fc56                	sd	s5,56(sp)
    800057f2:	f85a                	sd	s6,48(sp)
    800057f4:	f45e                	sd	s7,40(sp)
    800057f6:	f062                	sd	s8,32(sp)
    800057f8:	ec66                	sd	s9,24(sp)
    800057fa:	1880                	addi	s0,sp,112
    800057fc:	8a2a                	mv	s4,a0
    800057fe:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005800:	00c52c03          	lw	s8,12(a0)
    80005804:	001c1c1b          	slliw	s8,s8,0x1
    80005808:	1c02                	slli	s8,s8,0x20
    8000580a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000580e:	00027517          	auipc	a0,0x27
    80005812:	91a50513          	addi	a0,a0,-1766 # 8002c128 <disk+0x2128>
    80005816:	00001097          	auipc	ra,0x1
    8000581a:	de0080e7          	jalr	-544(ra) # 800065f6 <acquire>
  for(int i = 0; i < 3; i++){
    8000581e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005820:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005822:	00024b97          	auipc	s7,0x24
    80005826:	7deb8b93          	addi	s7,s7,2014 # 8002a000 <disk>
    8000582a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000582c:	4a8d                	li	s5,3
    8000582e:	a88d                	j	800058a0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005830:	00fb8733          	add	a4,s7,a5
    80005834:	975a                	add	a4,a4,s6
    80005836:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000583a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000583c:	0207c563          	bltz	a5,80005866 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005840:	2905                	addiw	s2,s2,1
    80005842:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005844:	1b590163          	beq	s2,s5,800059e6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005848:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000584a:	00026717          	auipc	a4,0x26
    8000584e:	7ce70713          	addi	a4,a4,1998 # 8002c018 <disk+0x2018>
    80005852:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005854:	00074683          	lbu	a3,0(a4)
    80005858:	fee1                	bnez	a3,80005830 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000585a:	2785                	addiw	a5,a5,1
    8000585c:	0705                	addi	a4,a4,1
    8000585e:	fe979be3          	bne	a5,s1,80005854 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005862:	57fd                	li	a5,-1
    80005864:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005866:	03205163          	blez	s2,80005888 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000586a:	f9042503          	lw	a0,-112(s0)
    8000586e:	00000097          	auipc	ra,0x0
    80005872:	d7c080e7          	jalr	-644(ra) # 800055ea <free_desc>
      for(int j = 0; j < i; j++)
    80005876:	4785                	li	a5,1
    80005878:	0127d863          	bge	a5,s2,80005888 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000587c:	f9442503          	lw	a0,-108(s0)
    80005880:	00000097          	auipc	ra,0x0
    80005884:	d6a080e7          	jalr	-662(ra) # 800055ea <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005888:	00027597          	auipc	a1,0x27
    8000588c:	8a058593          	addi	a1,a1,-1888 # 8002c128 <disk+0x2128>
    80005890:	00026517          	auipc	a0,0x26
    80005894:	78850513          	addi	a0,a0,1928 # 8002c018 <disk+0x2018>
    80005898:	ffffc097          	auipc	ra,0xffffc
    8000589c:	cca080e7          	jalr	-822(ra) # 80001562 <sleep>
  for(int i = 0; i < 3; i++){
    800058a0:	f9040613          	addi	a2,s0,-112
    800058a4:	894e                	mv	s2,s3
    800058a6:	b74d                	j	80005848 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800058a8:	00026717          	auipc	a4,0x26
    800058ac:	75873703          	ld	a4,1880(a4) # 8002c000 <disk+0x2000>
    800058b0:	973e                	add	a4,a4,a5
    800058b2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058b6:	00024897          	auipc	a7,0x24
    800058ba:	74a88893          	addi	a7,a7,1866 # 8002a000 <disk>
    800058be:	00026717          	auipc	a4,0x26
    800058c2:	74270713          	addi	a4,a4,1858 # 8002c000 <disk+0x2000>
    800058c6:	6314                	ld	a3,0(a4)
    800058c8:	96be                	add	a3,a3,a5
    800058ca:	00c6d583          	lhu	a1,12(a3)
    800058ce:	0015e593          	ori	a1,a1,1
    800058d2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800058d6:	f9842683          	lw	a3,-104(s0)
    800058da:	630c                	ld	a1,0(a4)
    800058dc:	97ae                	add	a5,a5,a1
    800058de:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058e2:	20050593          	addi	a1,a0,512
    800058e6:	0592                	slli	a1,a1,0x4
    800058e8:	95c6                	add	a1,a1,a7
    800058ea:	57fd                	li	a5,-1
    800058ec:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058f0:	00469793          	slli	a5,a3,0x4
    800058f4:	00073803          	ld	a6,0(a4)
    800058f8:	983e                	add	a6,a6,a5
    800058fa:	6689                	lui	a3,0x2
    800058fc:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005900:	96b2                	add	a3,a3,a2
    80005902:	96c6                	add	a3,a3,a7
    80005904:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005908:	6314                	ld	a3,0(a4)
    8000590a:	96be                	add	a3,a3,a5
    8000590c:	4605                	li	a2,1
    8000590e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005910:	6314                	ld	a3,0(a4)
    80005912:	96be                	add	a3,a3,a5
    80005914:	4809                	li	a6,2
    80005916:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000591a:	6314                	ld	a3,0(a4)
    8000591c:	97b6                	add	a5,a5,a3
    8000591e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005922:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005926:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000592a:	6714                	ld	a3,8(a4)
    8000592c:	0026d783          	lhu	a5,2(a3)
    80005930:	8b9d                	andi	a5,a5,7
    80005932:	0786                	slli	a5,a5,0x1
    80005934:	96be                	add	a3,a3,a5
    80005936:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000593a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000593e:	6718                	ld	a4,8(a4)
    80005940:	00275783          	lhu	a5,2(a4)
    80005944:	2785                	addiw	a5,a5,1
    80005946:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000594a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000594e:	100017b7          	lui	a5,0x10001
    80005952:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005956:	004a2783          	lw	a5,4(s4)
    8000595a:	02c79163          	bne	a5,a2,8000597c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000595e:	00026917          	auipc	s2,0x26
    80005962:	7ca90913          	addi	s2,s2,1994 # 8002c128 <disk+0x2128>
  while(b->disk == 1) {
    80005966:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005968:	85ca                	mv	a1,s2
    8000596a:	8552                	mv	a0,s4
    8000596c:	ffffc097          	auipc	ra,0xffffc
    80005970:	bf6080e7          	jalr	-1034(ra) # 80001562 <sleep>
  while(b->disk == 1) {
    80005974:	004a2783          	lw	a5,4(s4)
    80005978:	fe9788e3          	beq	a5,s1,80005968 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000597c:	f9042903          	lw	s2,-112(s0)
    80005980:	20090713          	addi	a4,s2,512
    80005984:	0712                	slli	a4,a4,0x4
    80005986:	00024797          	auipc	a5,0x24
    8000598a:	67a78793          	addi	a5,a5,1658 # 8002a000 <disk>
    8000598e:	97ba                	add	a5,a5,a4
    80005990:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005994:	00026997          	auipc	s3,0x26
    80005998:	66c98993          	addi	s3,s3,1644 # 8002c000 <disk+0x2000>
    8000599c:	00491713          	slli	a4,s2,0x4
    800059a0:	0009b783          	ld	a5,0(s3)
    800059a4:	97ba                	add	a5,a5,a4
    800059a6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059aa:	854a                	mv	a0,s2
    800059ac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	c3a080e7          	jalr	-966(ra) # 800055ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059b8:	8885                	andi	s1,s1,1
    800059ba:	f0ed                	bnez	s1,8000599c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059bc:	00026517          	auipc	a0,0x26
    800059c0:	76c50513          	addi	a0,a0,1900 # 8002c128 <disk+0x2128>
    800059c4:	00001097          	auipc	ra,0x1
    800059c8:	ce6080e7          	jalr	-794(ra) # 800066aa <release>
}
    800059cc:	70a6                	ld	ra,104(sp)
    800059ce:	7406                	ld	s0,96(sp)
    800059d0:	64e6                	ld	s1,88(sp)
    800059d2:	6946                	ld	s2,80(sp)
    800059d4:	69a6                	ld	s3,72(sp)
    800059d6:	6a06                	ld	s4,64(sp)
    800059d8:	7ae2                	ld	s5,56(sp)
    800059da:	7b42                	ld	s6,48(sp)
    800059dc:	7ba2                	ld	s7,40(sp)
    800059de:	7c02                	ld	s8,32(sp)
    800059e0:	6ce2                	ld	s9,24(sp)
    800059e2:	6165                	addi	sp,sp,112
    800059e4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059e6:	f9042503          	lw	a0,-112(s0)
    800059ea:	00451613          	slli	a2,a0,0x4
  if(write)
    800059ee:	00024597          	auipc	a1,0x24
    800059f2:	61258593          	addi	a1,a1,1554 # 8002a000 <disk>
    800059f6:	20050793          	addi	a5,a0,512
    800059fa:	0792                	slli	a5,a5,0x4
    800059fc:	97ae                	add	a5,a5,a1
    800059fe:	01903733          	snez	a4,s9
    80005a02:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005a06:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005a0a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a0e:	00026717          	auipc	a4,0x26
    80005a12:	5f270713          	addi	a4,a4,1522 # 8002c000 <disk+0x2000>
    80005a16:	6314                	ld	a3,0(a4)
    80005a18:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a1a:	6789                	lui	a5,0x2
    80005a1c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005a20:	97b2                	add	a5,a5,a2
    80005a22:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a24:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a26:	631c                	ld	a5,0(a4)
    80005a28:	97b2                	add	a5,a5,a2
    80005a2a:	46c1                	li	a3,16
    80005a2c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a2e:	631c                	ld	a5,0(a4)
    80005a30:	97b2                	add	a5,a5,a2
    80005a32:	4685                	li	a3,1
    80005a34:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005a38:	f9442783          	lw	a5,-108(s0)
    80005a3c:	6314                	ld	a3,0(a4)
    80005a3e:	96b2                	add	a3,a3,a2
    80005a40:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a44:	0792                	slli	a5,a5,0x4
    80005a46:	6314                	ld	a3,0(a4)
    80005a48:	96be                	add	a3,a3,a5
    80005a4a:	058a0593          	addi	a1,s4,88
    80005a4e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005a50:	6318                	ld	a4,0(a4)
    80005a52:	973e                	add	a4,a4,a5
    80005a54:	40000693          	li	a3,1024
    80005a58:	c714                	sw	a3,8(a4)
  if(write)
    80005a5a:	e40c97e3          	bnez	s9,800058a8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a5e:	00026717          	auipc	a4,0x26
    80005a62:	5a273703          	ld	a4,1442(a4) # 8002c000 <disk+0x2000>
    80005a66:	973e                	add	a4,a4,a5
    80005a68:	4689                	li	a3,2
    80005a6a:	00d71623          	sh	a3,12(a4)
    80005a6e:	b5a1                	j	800058b6 <virtio_disk_rw+0xd4>

0000000080005a70 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a70:	1101                	addi	sp,sp,-32
    80005a72:	ec06                	sd	ra,24(sp)
    80005a74:	e822                	sd	s0,16(sp)
    80005a76:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a78:	00026517          	auipc	a0,0x26
    80005a7c:	6b050513          	addi	a0,a0,1712 # 8002c128 <disk+0x2128>
    80005a80:	00001097          	auipc	ra,0x1
    80005a84:	b76080e7          	jalr	-1162(ra) # 800065f6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a88:	100017b7          	lui	a5,0x10001
    80005a8c:	53b8                	lw	a4,96(a5)
    80005a8e:	8b0d                	andi	a4,a4,3
    80005a90:	100017b7          	lui	a5,0x10001
    80005a94:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a96:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a9a:	00026797          	auipc	a5,0x26
    80005a9e:	56678793          	addi	a5,a5,1382 # 8002c000 <disk+0x2000>
    80005aa2:	6b94                	ld	a3,16(a5)
    80005aa4:	0207d703          	lhu	a4,32(a5)
    80005aa8:	0026d783          	lhu	a5,2(a3)
    80005aac:	06f70563          	beq	a4,a5,80005b16 <virtio_disk_intr+0xa6>
    80005ab0:	e426                	sd	s1,8(sp)
    80005ab2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ab4:	00024917          	auipc	s2,0x24
    80005ab8:	54c90913          	addi	s2,s2,1356 # 8002a000 <disk>
    80005abc:	00026497          	auipc	s1,0x26
    80005ac0:	54448493          	addi	s1,s1,1348 # 8002c000 <disk+0x2000>
    __sync_synchronize();
    80005ac4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ac8:	6898                	ld	a4,16(s1)
    80005aca:	0204d783          	lhu	a5,32(s1)
    80005ace:	8b9d                	andi	a5,a5,7
    80005ad0:	078e                	slli	a5,a5,0x3
    80005ad2:	97ba                	add	a5,a5,a4
    80005ad4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ad6:	20078713          	addi	a4,a5,512
    80005ada:	0712                	slli	a4,a4,0x4
    80005adc:	974a                	add	a4,a4,s2
    80005ade:	03074703          	lbu	a4,48(a4)
    80005ae2:	e731                	bnez	a4,80005b2e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ae4:	20078793          	addi	a5,a5,512
    80005ae8:	0792                	slli	a5,a5,0x4
    80005aea:	97ca                	add	a5,a5,s2
    80005aec:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005aee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005af2:	ffffc097          	auipc	ra,0xffffc
    80005af6:	bfc080e7          	jalr	-1028(ra) # 800016ee <wakeup>

    disk.used_idx += 1;
    80005afa:	0204d783          	lhu	a5,32(s1)
    80005afe:	2785                	addiw	a5,a5,1
    80005b00:	17c2                	slli	a5,a5,0x30
    80005b02:	93c1                	srli	a5,a5,0x30
    80005b04:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b08:	6898                	ld	a4,16(s1)
    80005b0a:	00275703          	lhu	a4,2(a4)
    80005b0e:	faf71be3          	bne	a4,a5,80005ac4 <virtio_disk_intr+0x54>
    80005b12:	64a2                	ld	s1,8(sp)
    80005b14:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005b16:	00026517          	auipc	a0,0x26
    80005b1a:	61250513          	addi	a0,a0,1554 # 8002c128 <disk+0x2128>
    80005b1e:	00001097          	auipc	ra,0x1
    80005b22:	b8c080e7          	jalr	-1140(ra) # 800066aa <release>
}
    80005b26:	60e2                	ld	ra,24(sp)
    80005b28:	6442                	ld	s0,16(sp)
    80005b2a:	6105                	addi	sp,sp,32
    80005b2c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b2e:	00003517          	auipc	a0,0x3
    80005b32:	b1a50513          	addi	a0,a0,-1254 # 80008648 <etext+0x648>
    80005b36:	00000097          	auipc	ra,0x0
    80005b3a:	546080e7          	jalr	1350(ra) # 8000607c <panic>

0000000080005b3e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b3e:	1141                	addi	sp,sp,-16
    80005b40:	e422                	sd	s0,8(sp)
    80005b42:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b44:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b48:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b4c:	0037979b          	slliw	a5,a5,0x3
    80005b50:	02004737          	lui	a4,0x2004
    80005b54:	97ba                	add	a5,a5,a4
    80005b56:	0200c737          	lui	a4,0x200c
    80005b5a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005b5c:	6318                	ld	a4,0(a4)
    80005b5e:	000f4637          	lui	a2,0xf4
    80005b62:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b66:	9732                	add	a4,a4,a2
    80005b68:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b6a:	00259693          	slli	a3,a1,0x2
    80005b6e:	96ae                	add	a3,a3,a1
    80005b70:	068e                	slli	a3,a3,0x3
    80005b72:	00027717          	auipc	a4,0x27
    80005b76:	48e70713          	addi	a4,a4,1166 # 8002d000 <timer_scratch>
    80005b7a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b7c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b7e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b80:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b84:	00000797          	auipc	a5,0x0
    80005b88:	99c78793          	addi	a5,a5,-1636 # 80005520 <timervec>
    80005b8c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b90:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b94:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b98:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b9c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ba0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ba4:	30479073          	csrw	mie,a5
}
    80005ba8:	6422                	ld	s0,8(sp)
    80005baa:	0141                	addi	sp,sp,16
    80005bac:	8082                	ret

0000000080005bae <start>:
{
    80005bae:	1141                	addi	sp,sp,-16
    80005bb0:	e406                	sd	ra,8(sp)
    80005bb2:	e022                	sd	s0,0(sp)
    80005bb4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bb6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005bba:	7779                	lui	a4,0xffffe
    80005bbc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffc95bf>
    80005bc0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005bc2:	6705                	lui	a4,0x1
    80005bc4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005bc8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005bca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005bce:	ffffa797          	auipc	a5,0xffffa
    80005bd2:	74a78793          	addi	a5,a5,1866 # 80000318 <main>
    80005bd6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005bda:	4781                	li	a5,0
    80005bdc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005be0:	67c1                	lui	a5,0x10
    80005be2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005be4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005be8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005bec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005bf0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005bf4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005bf8:	57fd                	li	a5,-1
    80005bfa:	83a9                	srli	a5,a5,0xa
    80005bfc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c00:	47bd                	li	a5,15
    80005c02:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	f38080e7          	jalr	-200(ra) # 80005b3e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c0e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c12:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c14:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c16:	30200073          	mret
}
    80005c1a:	60a2                	ld	ra,8(sp)
    80005c1c:	6402                	ld	s0,0(sp)
    80005c1e:	0141                	addi	sp,sp,16
    80005c20:	8082                	ret

0000000080005c22 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c22:	715d                	addi	sp,sp,-80
    80005c24:	e486                	sd	ra,72(sp)
    80005c26:	e0a2                	sd	s0,64(sp)
    80005c28:	f84a                	sd	s2,48(sp)
    80005c2a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c2c:	04c05663          	blez	a2,80005c78 <consolewrite+0x56>
    80005c30:	fc26                	sd	s1,56(sp)
    80005c32:	f44e                	sd	s3,40(sp)
    80005c34:	f052                	sd	s4,32(sp)
    80005c36:	ec56                	sd	s5,24(sp)
    80005c38:	8a2a                	mv	s4,a0
    80005c3a:	84ae                	mv	s1,a1
    80005c3c:	89b2                	mv	s3,a2
    80005c3e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c40:	5afd                	li	s5,-1
    80005c42:	4685                	li	a3,1
    80005c44:	8626                	mv	a2,s1
    80005c46:	85d2                	mv	a1,s4
    80005c48:	fbf40513          	addi	a0,s0,-65
    80005c4c:	ffffc097          	auipc	ra,0xffffc
    80005c50:	d78080e7          	jalr	-648(ra) # 800019c4 <either_copyin>
    80005c54:	03550463          	beq	a0,s5,80005c7c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005c58:	fbf44503          	lbu	a0,-65(s0)
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	7de080e7          	jalr	2014(ra) # 8000643a <uartputc>
  for(i = 0; i < n; i++){
    80005c64:	2905                	addiw	s2,s2,1
    80005c66:	0485                	addi	s1,s1,1
    80005c68:	fd299de3          	bne	s3,s2,80005c42 <consolewrite+0x20>
    80005c6c:	894e                	mv	s2,s3
    80005c6e:	74e2                	ld	s1,56(sp)
    80005c70:	79a2                	ld	s3,40(sp)
    80005c72:	7a02                	ld	s4,32(sp)
    80005c74:	6ae2                	ld	s5,24(sp)
    80005c76:	a039                	j	80005c84 <consolewrite+0x62>
    80005c78:	4901                	li	s2,0
    80005c7a:	a029                	j	80005c84 <consolewrite+0x62>
    80005c7c:	74e2                	ld	s1,56(sp)
    80005c7e:	79a2                	ld	s3,40(sp)
    80005c80:	7a02                	ld	s4,32(sp)
    80005c82:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c84:	854a                	mv	a0,s2
    80005c86:	60a6                	ld	ra,72(sp)
    80005c88:	6406                	ld	s0,64(sp)
    80005c8a:	7942                	ld	s2,48(sp)
    80005c8c:	6161                	addi	sp,sp,80
    80005c8e:	8082                	ret

0000000080005c90 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c90:	711d                	addi	sp,sp,-96
    80005c92:	ec86                	sd	ra,88(sp)
    80005c94:	e8a2                	sd	s0,80(sp)
    80005c96:	e4a6                	sd	s1,72(sp)
    80005c98:	e0ca                	sd	s2,64(sp)
    80005c9a:	fc4e                	sd	s3,56(sp)
    80005c9c:	f852                	sd	s4,48(sp)
    80005c9e:	f456                	sd	s5,40(sp)
    80005ca0:	f05a                	sd	s6,32(sp)
    80005ca2:	1080                	addi	s0,sp,96
    80005ca4:	8aaa                	mv	s5,a0
    80005ca6:	8a2e                	mv	s4,a1
    80005ca8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005caa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005cae:	0002f517          	auipc	a0,0x2f
    80005cb2:	49250513          	addi	a0,a0,1170 # 80035140 <cons>
    80005cb6:	00001097          	auipc	ra,0x1
    80005cba:	940080e7          	jalr	-1728(ra) # 800065f6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005cbe:	0002f497          	auipc	s1,0x2f
    80005cc2:	48248493          	addi	s1,s1,1154 # 80035140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005cc6:	0002f917          	auipc	s2,0x2f
    80005cca:	51290913          	addi	s2,s2,1298 # 800351d8 <cons+0x98>
  while(n > 0){
    80005cce:	0d305463          	blez	s3,80005d96 <consoleread+0x106>
    while(cons.r == cons.w){
    80005cd2:	0984a783          	lw	a5,152(s1)
    80005cd6:	09c4a703          	lw	a4,156(s1)
    80005cda:	0af71963          	bne	a4,a5,80005d8c <consoleread+0xfc>
      if(myproc()->killed){
    80005cde:	ffffb097          	auipc	ra,0xffffb
    80005ce2:	184080e7          	jalr	388(ra) # 80000e62 <myproc>
    80005ce6:	551c                	lw	a5,40(a0)
    80005ce8:	e7ad                	bnez	a5,80005d52 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005cea:	85a6                	mv	a1,s1
    80005cec:	854a                	mv	a0,s2
    80005cee:	ffffc097          	auipc	ra,0xffffc
    80005cf2:	874080e7          	jalr	-1932(ra) # 80001562 <sleep>
    while(cons.r == cons.w){
    80005cf6:	0984a783          	lw	a5,152(s1)
    80005cfa:	09c4a703          	lw	a4,156(s1)
    80005cfe:	fef700e3          	beq	a4,a5,80005cde <consoleread+0x4e>
    80005d02:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005d04:	0002f717          	auipc	a4,0x2f
    80005d08:	43c70713          	addi	a4,a4,1084 # 80035140 <cons>
    80005d0c:	0017869b          	addiw	a3,a5,1
    80005d10:	08d72c23          	sw	a3,152(a4)
    80005d14:	07f7f693          	andi	a3,a5,127
    80005d18:	9736                	add	a4,a4,a3
    80005d1a:	01874703          	lbu	a4,24(a4)
    80005d1e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005d22:	4691                	li	a3,4
    80005d24:	04db8a63          	beq	s7,a3,80005d78 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005d28:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d2c:	4685                	li	a3,1
    80005d2e:	faf40613          	addi	a2,s0,-81
    80005d32:	85d2                	mv	a1,s4
    80005d34:	8556                	mv	a0,s5
    80005d36:	ffffc097          	auipc	ra,0xffffc
    80005d3a:	c38080e7          	jalr	-968(ra) # 8000196e <either_copyout>
    80005d3e:	57fd                	li	a5,-1
    80005d40:	04f50a63          	beq	a0,a5,80005d94 <consoleread+0x104>
      break;

    dst++;
    80005d44:	0a05                	addi	s4,s4,1
    --n;
    80005d46:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005d48:	47a9                	li	a5,10
    80005d4a:	06fb8163          	beq	s7,a5,80005dac <consoleread+0x11c>
    80005d4e:	6be2                	ld	s7,24(sp)
    80005d50:	bfbd                	j	80005cce <consoleread+0x3e>
        release(&cons.lock);
    80005d52:	0002f517          	auipc	a0,0x2f
    80005d56:	3ee50513          	addi	a0,a0,1006 # 80035140 <cons>
    80005d5a:	00001097          	auipc	ra,0x1
    80005d5e:	950080e7          	jalr	-1712(ra) # 800066aa <release>
        return -1;
    80005d62:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d64:	60e6                	ld	ra,88(sp)
    80005d66:	6446                	ld	s0,80(sp)
    80005d68:	64a6                	ld	s1,72(sp)
    80005d6a:	6906                	ld	s2,64(sp)
    80005d6c:	79e2                	ld	s3,56(sp)
    80005d6e:	7a42                	ld	s4,48(sp)
    80005d70:	7aa2                	ld	s5,40(sp)
    80005d72:	7b02                	ld	s6,32(sp)
    80005d74:	6125                	addi	sp,sp,96
    80005d76:	8082                	ret
      if(n < target){
    80005d78:	0009871b          	sext.w	a4,s3
    80005d7c:	01677a63          	bgeu	a4,s6,80005d90 <consoleread+0x100>
        cons.r--;
    80005d80:	0002f717          	auipc	a4,0x2f
    80005d84:	44f72c23          	sw	a5,1112(a4) # 800351d8 <cons+0x98>
    80005d88:	6be2                	ld	s7,24(sp)
    80005d8a:	a031                	j	80005d96 <consoleread+0x106>
    80005d8c:	ec5e                	sd	s7,24(sp)
    80005d8e:	bf9d                	j	80005d04 <consoleread+0x74>
    80005d90:	6be2                	ld	s7,24(sp)
    80005d92:	a011                	j	80005d96 <consoleread+0x106>
    80005d94:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d96:	0002f517          	auipc	a0,0x2f
    80005d9a:	3aa50513          	addi	a0,a0,938 # 80035140 <cons>
    80005d9e:	00001097          	auipc	ra,0x1
    80005da2:	90c080e7          	jalr	-1780(ra) # 800066aa <release>
  return target - n;
    80005da6:	413b053b          	subw	a0,s6,s3
    80005daa:	bf6d                	j	80005d64 <consoleread+0xd4>
    80005dac:	6be2                	ld	s7,24(sp)
    80005dae:	b7e5                	j	80005d96 <consoleread+0x106>

0000000080005db0 <consputc>:
{
    80005db0:	1141                	addi	sp,sp,-16
    80005db2:	e406                	sd	ra,8(sp)
    80005db4:	e022                	sd	s0,0(sp)
    80005db6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005db8:	10000793          	li	a5,256
    80005dbc:	00f50a63          	beq	a0,a5,80005dd0 <consputc+0x20>
    uartputc_sync(c);
    80005dc0:	00000097          	auipc	ra,0x0
    80005dc4:	59c080e7          	jalr	1436(ra) # 8000635c <uartputc_sync>
}
    80005dc8:	60a2                	ld	ra,8(sp)
    80005dca:	6402                	ld	s0,0(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005dd0:	4521                	li	a0,8
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	58a080e7          	jalr	1418(ra) # 8000635c <uartputc_sync>
    80005dda:	02000513          	li	a0,32
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	57e080e7          	jalr	1406(ra) # 8000635c <uartputc_sync>
    80005de6:	4521                	li	a0,8
    80005de8:	00000097          	auipc	ra,0x0
    80005dec:	574080e7          	jalr	1396(ra) # 8000635c <uartputc_sync>
    80005df0:	bfe1                	j	80005dc8 <consputc+0x18>

0000000080005df2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005df2:	1101                	addi	sp,sp,-32
    80005df4:	ec06                	sd	ra,24(sp)
    80005df6:	e822                	sd	s0,16(sp)
    80005df8:	e426                	sd	s1,8(sp)
    80005dfa:	1000                	addi	s0,sp,32
    80005dfc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005dfe:	0002f517          	auipc	a0,0x2f
    80005e02:	34250513          	addi	a0,a0,834 # 80035140 <cons>
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	7f0080e7          	jalr	2032(ra) # 800065f6 <acquire>

  switch(c){
    80005e0e:	47d5                	li	a5,21
    80005e10:	0af48563          	beq	s1,a5,80005eba <consoleintr+0xc8>
    80005e14:	0297c963          	blt	a5,s1,80005e46 <consoleintr+0x54>
    80005e18:	47a1                	li	a5,8
    80005e1a:	0ef48c63          	beq	s1,a5,80005f12 <consoleintr+0x120>
    80005e1e:	47c1                	li	a5,16
    80005e20:	10f49f63          	bne	s1,a5,80005f3e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005e24:	ffffc097          	auipc	ra,0xffffc
    80005e28:	bf6080e7          	jalr	-1034(ra) # 80001a1a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e2c:	0002f517          	auipc	a0,0x2f
    80005e30:	31450513          	addi	a0,a0,788 # 80035140 <cons>
    80005e34:	00001097          	auipc	ra,0x1
    80005e38:	876080e7          	jalr	-1930(ra) # 800066aa <release>
}
    80005e3c:	60e2                	ld	ra,24(sp)
    80005e3e:	6442                	ld	s0,16(sp)
    80005e40:	64a2                	ld	s1,8(sp)
    80005e42:	6105                	addi	sp,sp,32
    80005e44:	8082                	ret
  switch(c){
    80005e46:	07f00793          	li	a5,127
    80005e4a:	0cf48463          	beq	s1,a5,80005f12 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e4e:	0002f717          	auipc	a4,0x2f
    80005e52:	2f270713          	addi	a4,a4,754 # 80035140 <cons>
    80005e56:	0a072783          	lw	a5,160(a4)
    80005e5a:	09872703          	lw	a4,152(a4)
    80005e5e:	9f99                	subw	a5,a5,a4
    80005e60:	07f00713          	li	a4,127
    80005e64:	fcf764e3          	bltu	a4,a5,80005e2c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005e68:	47b5                	li	a5,13
    80005e6a:	0cf48d63          	beq	s1,a5,80005f44 <consoleintr+0x152>
      consputc(c);
    80005e6e:	8526                	mv	a0,s1
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	f40080e7          	jalr	-192(ra) # 80005db0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e78:	0002f797          	auipc	a5,0x2f
    80005e7c:	2c878793          	addi	a5,a5,712 # 80035140 <cons>
    80005e80:	0a07a703          	lw	a4,160(a5)
    80005e84:	0017069b          	addiw	a3,a4,1
    80005e88:	0006861b          	sext.w	a2,a3
    80005e8c:	0ad7a023          	sw	a3,160(a5)
    80005e90:	07f77713          	andi	a4,a4,127
    80005e94:	97ba                	add	a5,a5,a4
    80005e96:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e9a:	47a9                	li	a5,10
    80005e9c:	0cf48b63          	beq	s1,a5,80005f72 <consoleintr+0x180>
    80005ea0:	4791                	li	a5,4
    80005ea2:	0cf48863          	beq	s1,a5,80005f72 <consoleintr+0x180>
    80005ea6:	0002f797          	auipc	a5,0x2f
    80005eaa:	3327a783          	lw	a5,818(a5) # 800351d8 <cons+0x98>
    80005eae:	0807879b          	addiw	a5,a5,128
    80005eb2:	f6f61de3          	bne	a2,a5,80005e2c <consoleintr+0x3a>
    80005eb6:	863e                	mv	a2,a5
    80005eb8:	a86d                	j	80005f72 <consoleintr+0x180>
    80005eba:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005ebc:	0002f717          	auipc	a4,0x2f
    80005ec0:	28470713          	addi	a4,a4,644 # 80035140 <cons>
    80005ec4:	0a072783          	lw	a5,160(a4)
    80005ec8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ecc:	0002f497          	auipc	s1,0x2f
    80005ed0:	27448493          	addi	s1,s1,628 # 80035140 <cons>
    while(cons.e != cons.w &&
    80005ed4:	4929                	li	s2,10
    80005ed6:	02f70a63          	beq	a4,a5,80005f0a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005eda:	37fd                	addiw	a5,a5,-1
    80005edc:	07f7f713          	andi	a4,a5,127
    80005ee0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ee2:	01874703          	lbu	a4,24(a4)
    80005ee6:	03270463          	beq	a4,s2,80005f0e <consoleintr+0x11c>
      cons.e--;
    80005eea:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005eee:	10000513          	li	a0,256
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	ebe080e7          	jalr	-322(ra) # 80005db0 <consputc>
    while(cons.e != cons.w &&
    80005efa:	0a04a783          	lw	a5,160(s1)
    80005efe:	09c4a703          	lw	a4,156(s1)
    80005f02:	fcf71ce3          	bne	a4,a5,80005eda <consoleintr+0xe8>
    80005f06:	6902                	ld	s2,0(sp)
    80005f08:	b715                	j	80005e2c <consoleintr+0x3a>
    80005f0a:	6902                	ld	s2,0(sp)
    80005f0c:	b705                	j	80005e2c <consoleintr+0x3a>
    80005f0e:	6902                	ld	s2,0(sp)
    80005f10:	bf31                	j	80005e2c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005f12:	0002f717          	auipc	a4,0x2f
    80005f16:	22e70713          	addi	a4,a4,558 # 80035140 <cons>
    80005f1a:	0a072783          	lw	a5,160(a4)
    80005f1e:	09c72703          	lw	a4,156(a4)
    80005f22:	f0f705e3          	beq	a4,a5,80005e2c <consoleintr+0x3a>
      cons.e--;
    80005f26:	37fd                	addiw	a5,a5,-1
    80005f28:	0002f717          	auipc	a4,0x2f
    80005f2c:	2af72c23          	sw	a5,696(a4) # 800351e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005f30:	10000513          	li	a0,256
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	e7c080e7          	jalr	-388(ra) # 80005db0 <consputc>
    80005f3c:	bdc5                	j	80005e2c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f3e:	ee0487e3          	beqz	s1,80005e2c <consoleintr+0x3a>
    80005f42:	b731                	j	80005e4e <consoleintr+0x5c>
      consputc(c);
    80005f44:	4529                	li	a0,10
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	e6a080e7          	jalr	-406(ra) # 80005db0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f4e:	0002f797          	auipc	a5,0x2f
    80005f52:	1f278793          	addi	a5,a5,498 # 80035140 <cons>
    80005f56:	0a07a703          	lw	a4,160(a5)
    80005f5a:	0017069b          	addiw	a3,a4,1
    80005f5e:	0006861b          	sext.w	a2,a3
    80005f62:	0ad7a023          	sw	a3,160(a5)
    80005f66:	07f77713          	andi	a4,a4,127
    80005f6a:	97ba                	add	a5,a5,a4
    80005f6c:	4729                	li	a4,10
    80005f6e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f72:	0002f797          	auipc	a5,0x2f
    80005f76:	26c7a523          	sw	a2,618(a5) # 800351dc <cons+0x9c>
        wakeup(&cons.r);
    80005f7a:	0002f517          	auipc	a0,0x2f
    80005f7e:	25e50513          	addi	a0,a0,606 # 800351d8 <cons+0x98>
    80005f82:	ffffb097          	auipc	ra,0xffffb
    80005f86:	76c080e7          	jalr	1900(ra) # 800016ee <wakeup>
    80005f8a:	b54d                	j	80005e2c <consoleintr+0x3a>

0000000080005f8c <consoleinit>:

void
consoleinit(void)
{
    80005f8c:	1141                	addi	sp,sp,-16
    80005f8e:	e406                	sd	ra,8(sp)
    80005f90:	e022                	sd	s0,0(sp)
    80005f92:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f94:	00002597          	auipc	a1,0x2
    80005f98:	6cc58593          	addi	a1,a1,1740 # 80008660 <etext+0x660>
    80005f9c:	0002f517          	auipc	a0,0x2f
    80005fa0:	1a450513          	addi	a0,a0,420 # 80035140 <cons>
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	5c2080e7          	jalr	1474(ra) # 80006566 <initlock>

  uartinit();
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	354080e7          	jalr	852(ra) # 80006300 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fb4:	00022797          	auipc	a5,0x22
    80005fb8:	11478793          	addi	a5,a5,276 # 800280c8 <devsw>
    80005fbc:	00000717          	auipc	a4,0x0
    80005fc0:	cd470713          	addi	a4,a4,-812 # 80005c90 <consoleread>
    80005fc4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fc6:	00000717          	auipc	a4,0x0
    80005fca:	c5c70713          	addi	a4,a4,-932 # 80005c22 <consolewrite>
    80005fce:	ef98                	sd	a4,24(a5)
}
    80005fd0:	60a2                	ld	ra,8(sp)
    80005fd2:	6402                	ld	s0,0(sp)
    80005fd4:	0141                	addi	sp,sp,16
    80005fd6:	8082                	ret

0000000080005fd8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005fd8:	7179                	addi	sp,sp,-48
    80005fda:	f406                	sd	ra,40(sp)
    80005fdc:	f022                	sd	s0,32(sp)
    80005fde:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005fe0:	c219                	beqz	a2,80005fe6 <printint+0xe>
    80005fe2:	08054963          	bltz	a0,80006074 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005fe6:	2501                	sext.w	a0,a0
    80005fe8:	4881                	li	a7,0
    80005fea:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005fee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ff0:	2581                	sext.w	a1,a1
    80005ff2:	00002617          	auipc	a2,0x2
    80005ff6:	7de60613          	addi	a2,a2,2014 # 800087d0 <digits>
    80005ffa:	883a                	mv	a6,a4
    80005ffc:	2705                	addiw	a4,a4,1
    80005ffe:	02b577bb          	remuw	a5,a0,a1
    80006002:	1782                	slli	a5,a5,0x20
    80006004:	9381                	srli	a5,a5,0x20
    80006006:	97b2                	add	a5,a5,a2
    80006008:	0007c783          	lbu	a5,0(a5)
    8000600c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006010:	0005079b          	sext.w	a5,a0
    80006014:	02b5553b          	divuw	a0,a0,a1
    80006018:	0685                	addi	a3,a3,1
    8000601a:	feb7f0e3          	bgeu	a5,a1,80005ffa <printint+0x22>

  if(sign)
    8000601e:	00088c63          	beqz	a7,80006036 <printint+0x5e>
    buf[i++] = '-';
    80006022:	fe070793          	addi	a5,a4,-32
    80006026:	00878733          	add	a4,a5,s0
    8000602a:	02d00793          	li	a5,45
    8000602e:	fef70823          	sb	a5,-16(a4)
    80006032:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006036:	02e05b63          	blez	a4,8000606c <printint+0x94>
    8000603a:	ec26                	sd	s1,24(sp)
    8000603c:	e84a                	sd	s2,16(sp)
    8000603e:	fd040793          	addi	a5,s0,-48
    80006042:	00e784b3          	add	s1,a5,a4
    80006046:	fff78913          	addi	s2,a5,-1
    8000604a:	993a                	add	s2,s2,a4
    8000604c:	377d                	addiw	a4,a4,-1
    8000604e:	1702                	slli	a4,a4,0x20
    80006050:	9301                	srli	a4,a4,0x20
    80006052:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006056:	fff4c503          	lbu	a0,-1(s1)
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	d56080e7          	jalr	-682(ra) # 80005db0 <consputc>
  while(--i >= 0)
    80006062:	14fd                	addi	s1,s1,-1
    80006064:	ff2499e3          	bne	s1,s2,80006056 <printint+0x7e>
    80006068:	64e2                	ld	s1,24(sp)
    8000606a:	6942                	ld	s2,16(sp)
}
    8000606c:	70a2                	ld	ra,40(sp)
    8000606e:	7402                	ld	s0,32(sp)
    80006070:	6145                	addi	sp,sp,48
    80006072:	8082                	ret
    x = -xx;
    80006074:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006078:	4885                	li	a7,1
    x = -xx;
    8000607a:	bf85                	j	80005fea <printint+0x12>

000000008000607c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000607c:	1101                	addi	sp,sp,-32
    8000607e:	ec06                	sd	ra,24(sp)
    80006080:	e822                	sd	s0,16(sp)
    80006082:	e426                	sd	s1,8(sp)
    80006084:	1000                	addi	s0,sp,32
    80006086:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006088:	0002f797          	auipc	a5,0x2f
    8000608c:	1607ac23          	sw	zero,376(a5) # 80035200 <pr+0x18>
  printf("panic: ");
    80006090:	00002517          	auipc	a0,0x2
    80006094:	5d850513          	addi	a0,a0,1496 # 80008668 <etext+0x668>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	02e080e7          	jalr	46(ra) # 800060c6 <printf>
  printf(s);
    800060a0:	8526                	mv	a0,s1
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	024080e7          	jalr	36(ra) # 800060c6 <printf>
  printf("\n");
    800060aa:	00002517          	auipc	a0,0x2
    800060ae:	f6e50513          	addi	a0,a0,-146 # 80008018 <etext+0x18>
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	014080e7          	jalr	20(ra) # 800060c6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800060ba:	4785                	li	a5,1
    800060bc:	00006717          	auipc	a4,0x6
    800060c0:	f6f72023          	sw	a5,-160(a4) # 8000c01c <panicked>
  for(;;)
    800060c4:	a001                	j	800060c4 <panic+0x48>

00000000800060c6 <printf>:
{
    800060c6:	7131                	addi	sp,sp,-192
    800060c8:	fc86                	sd	ra,120(sp)
    800060ca:	f8a2                	sd	s0,112(sp)
    800060cc:	e8d2                	sd	s4,80(sp)
    800060ce:	f06a                	sd	s10,32(sp)
    800060d0:	0100                	addi	s0,sp,128
    800060d2:	8a2a                	mv	s4,a0
    800060d4:	e40c                	sd	a1,8(s0)
    800060d6:	e810                	sd	a2,16(s0)
    800060d8:	ec14                	sd	a3,24(s0)
    800060da:	f018                	sd	a4,32(s0)
    800060dc:	f41c                	sd	a5,40(s0)
    800060de:	03043823          	sd	a6,48(s0)
    800060e2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060e6:	0002fd17          	auipc	s10,0x2f
    800060ea:	11ad2d03          	lw	s10,282(s10) # 80035200 <pr+0x18>
  if(locking)
    800060ee:	040d1463          	bnez	s10,80006136 <printf+0x70>
  if (fmt == 0)
    800060f2:	040a0b63          	beqz	s4,80006148 <printf+0x82>
  va_start(ap, fmt);
    800060f6:	00840793          	addi	a5,s0,8
    800060fa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060fe:	000a4503          	lbu	a0,0(s4)
    80006102:	18050b63          	beqz	a0,80006298 <printf+0x1d2>
    80006106:	f4a6                	sd	s1,104(sp)
    80006108:	f0ca                	sd	s2,96(sp)
    8000610a:	ecce                	sd	s3,88(sp)
    8000610c:	e4d6                	sd	s5,72(sp)
    8000610e:	e0da                	sd	s6,64(sp)
    80006110:	fc5e                	sd	s7,56(sp)
    80006112:	f862                	sd	s8,48(sp)
    80006114:	f466                	sd	s9,40(sp)
    80006116:	ec6e                	sd	s11,24(sp)
    80006118:	4981                	li	s3,0
    if(c != '%'){
    8000611a:	02500b13          	li	s6,37
    switch(c){
    8000611e:	07000b93          	li	s7,112
  consputc('x');
    80006122:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006124:	00002a97          	auipc	s5,0x2
    80006128:	6aca8a93          	addi	s5,s5,1708 # 800087d0 <digits>
    switch(c){
    8000612c:	07300c13          	li	s8,115
    80006130:	06400d93          	li	s11,100
    80006134:	a0b1                	j	80006180 <printf+0xba>
    acquire(&pr.lock);
    80006136:	0002f517          	auipc	a0,0x2f
    8000613a:	0b250513          	addi	a0,a0,178 # 800351e8 <pr>
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	4b8080e7          	jalr	1208(ra) # 800065f6 <acquire>
    80006146:	b775                	j	800060f2 <printf+0x2c>
    80006148:	f4a6                	sd	s1,104(sp)
    8000614a:	f0ca                	sd	s2,96(sp)
    8000614c:	ecce                	sd	s3,88(sp)
    8000614e:	e4d6                	sd	s5,72(sp)
    80006150:	e0da                	sd	s6,64(sp)
    80006152:	fc5e                	sd	s7,56(sp)
    80006154:	f862                	sd	s8,48(sp)
    80006156:	f466                	sd	s9,40(sp)
    80006158:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000615a:	00002517          	auipc	a0,0x2
    8000615e:	51e50513          	addi	a0,a0,1310 # 80008678 <etext+0x678>
    80006162:	00000097          	auipc	ra,0x0
    80006166:	f1a080e7          	jalr	-230(ra) # 8000607c <panic>
      consputc(c);
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	c46080e7          	jalr	-954(ra) # 80005db0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006172:	2985                	addiw	s3,s3,1
    80006174:	013a07b3          	add	a5,s4,s3
    80006178:	0007c503          	lbu	a0,0(a5)
    8000617c:	10050563          	beqz	a0,80006286 <printf+0x1c0>
    if(c != '%'){
    80006180:	ff6515e3          	bne	a0,s6,8000616a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006184:	2985                	addiw	s3,s3,1
    80006186:	013a07b3          	add	a5,s4,s3
    8000618a:	0007c783          	lbu	a5,0(a5)
    8000618e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006192:	10078b63          	beqz	a5,800062a8 <printf+0x1e2>
    switch(c){
    80006196:	05778a63          	beq	a5,s7,800061ea <printf+0x124>
    8000619a:	02fbf663          	bgeu	s7,a5,800061c6 <printf+0x100>
    8000619e:	09878863          	beq	a5,s8,8000622e <printf+0x168>
    800061a2:	07800713          	li	a4,120
    800061a6:	0ce79563          	bne	a5,a4,80006270 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800061aa:	f8843783          	ld	a5,-120(s0)
    800061ae:	00878713          	addi	a4,a5,8
    800061b2:	f8e43423          	sd	a4,-120(s0)
    800061b6:	4605                	li	a2,1
    800061b8:	85e6                	mv	a1,s9
    800061ba:	4388                	lw	a0,0(a5)
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	e1c080e7          	jalr	-484(ra) # 80005fd8 <printint>
      break;
    800061c4:	b77d                	j	80006172 <printf+0xac>
    switch(c){
    800061c6:	09678f63          	beq	a5,s6,80006264 <printf+0x19e>
    800061ca:	0bb79363          	bne	a5,s11,80006270 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800061ce:	f8843783          	ld	a5,-120(s0)
    800061d2:	00878713          	addi	a4,a5,8
    800061d6:	f8e43423          	sd	a4,-120(s0)
    800061da:	4605                	li	a2,1
    800061dc:	45a9                	li	a1,10
    800061de:	4388                	lw	a0,0(a5)
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	df8080e7          	jalr	-520(ra) # 80005fd8 <printint>
      break;
    800061e8:	b769                	j	80006172 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800061ea:	f8843783          	ld	a5,-120(s0)
    800061ee:	00878713          	addi	a4,a5,8
    800061f2:	f8e43423          	sd	a4,-120(s0)
    800061f6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800061fa:	03000513          	li	a0,48
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	bb2080e7          	jalr	-1102(ra) # 80005db0 <consputc>
  consputc('x');
    80006206:	07800513          	li	a0,120
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	ba6080e7          	jalr	-1114(ra) # 80005db0 <consputc>
    80006212:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006214:	03c95793          	srli	a5,s2,0x3c
    80006218:	97d6                	add	a5,a5,s5
    8000621a:	0007c503          	lbu	a0,0(a5)
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	b92080e7          	jalr	-1134(ra) # 80005db0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006226:	0912                	slli	s2,s2,0x4
    80006228:	34fd                	addiw	s1,s1,-1
    8000622a:	f4ed                	bnez	s1,80006214 <printf+0x14e>
    8000622c:	b799                	j	80006172 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000622e:	f8843783          	ld	a5,-120(s0)
    80006232:	00878713          	addi	a4,a5,8
    80006236:	f8e43423          	sd	a4,-120(s0)
    8000623a:	6384                	ld	s1,0(a5)
    8000623c:	cc89                	beqz	s1,80006256 <printf+0x190>
      for(; *s; s++)
    8000623e:	0004c503          	lbu	a0,0(s1)
    80006242:	d905                	beqz	a0,80006172 <printf+0xac>
        consputc(*s);
    80006244:	00000097          	auipc	ra,0x0
    80006248:	b6c080e7          	jalr	-1172(ra) # 80005db0 <consputc>
      for(; *s; s++)
    8000624c:	0485                	addi	s1,s1,1
    8000624e:	0004c503          	lbu	a0,0(s1)
    80006252:	f96d                	bnez	a0,80006244 <printf+0x17e>
    80006254:	bf39                	j	80006172 <printf+0xac>
        s = "(null)";
    80006256:	00002497          	auipc	s1,0x2
    8000625a:	41a48493          	addi	s1,s1,1050 # 80008670 <etext+0x670>
      for(; *s; s++)
    8000625e:	02800513          	li	a0,40
    80006262:	b7cd                	j	80006244 <printf+0x17e>
      consputc('%');
    80006264:	855a                	mv	a0,s6
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	b4a080e7          	jalr	-1206(ra) # 80005db0 <consputc>
      break;
    8000626e:	b711                	j	80006172 <printf+0xac>
      consputc('%');
    80006270:	855a                	mv	a0,s6
    80006272:	00000097          	auipc	ra,0x0
    80006276:	b3e080e7          	jalr	-1218(ra) # 80005db0 <consputc>
      consputc(c);
    8000627a:	8526                	mv	a0,s1
    8000627c:	00000097          	auipc	ra,0x0
    80006280:	b34080e7          	jalr	-1228(ra) # 80005db0 <consputc>
      break;
    80006284:	b5fd                	j	80006172 <printf+0xac>
    80006286:	74a6                	ld	s1,104(sp)
    80006288:	7906                	ld	s2,96(sp)
    8000628a:	69e6                	ld	s3,88(sp)
    8000628c:	6aa6                	ld	s5,72(sp)
    8000628e:	6b06                	ld	s6,64(sp)
    80006290:	7be2                	ld	s7,56(sp)
    80006292:	7c42                	ld	s8,48(sp)
    80006294:	7ca2                	ld	s9,40(sp)
    80006296:	6de2                	ld	s11,24(sp)
  if(locking)
    80006298:	020d1263          	bnez	s10,800062bc <printf+0x1f6>
}
    8000629c:	70e6                	ld	ra,120(sp)
    8000629e:	7446                	ld	s0,112(sp)
    800062a0:	6a46                	ld	s4,80(sp)
    800062a2:	7d02                	ld	s10,32(sp)
    800062a4:	6129                	addi	sp,sp,192
    800062a6:	8082                	ret
    800062a8:	74a6                	ld	s1,104(sp)
    800062aa:	7906                	ld	s2,96(sp)
    800062ac:	69e6                	ld	s3,88(sp)
    800062ae:	6aa6                	ld	s5,72(sp)
    800062b0:	6b06                	ld	s6,64(sp)
    800062b2:	7be2                	ld	s7,56(sp)
    800062b4:	7c42                	ld	s8,48(sp)
    800062b6:	7ca2                	ld	s9,40(sp)
    800062b8:	6de2                	ld	s11,24(sp)
    800062ba:	bff9                	j	80006298 <printf+0x1d2>
    release(&pr.lock);
    800062bc:	0002f517          	auipc	a0,0x2f
    800062c0:	f2c50513          	addi	a0,a0,-212 # 800351e8 <pr>
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	3e6080e7          	jalr	998(ra) # 800066aa <release>
}
    800062cc:	bfc1                	j	8000629c <printf+0x1d6>

00000000800062ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800062ce:	1101                	addi	sp,sp,-32
    800062d0:	ec06                	sd	ra,24(sp)
    800062d2:	e822                	sd	s0,16(sp)
    800062d4:	e426                	sd	s1,8(sp)
    800062d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062d8:	0002f497          	auipc	s1,0x2f
    800062dc:	f1048493          	addi	s1,s1,-240 # 800351e8 <pr>
    800062e0:	00002597          	auipc	a1,0x2
    800062e4:	3a858593          	addi	a1,a1,936 # 80008688 <etext+0x688>
    800062e8:	8526                	mv	a0,s1
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	27c080e7          	jalr	636(ra) # 80006566 <initlock>
  pr.locking = 1;
    800062f2:	4785                	li	a5,1
    800062f4:	cc9c                	sw	a5,24(s1)
}
    800062f6:	60e2                	ld	ra,24(sp)
    800062f8:	6442                	ld	s0,16(sp)
    800062fa:	64a2                	ld	s1,8(sp)
    800062fc:	6105                	addi	sp,sp,32
    800062fe:	8082                	ret

0000000080006300 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006300:	1141                	addi	sp,sp,-16
    80006302:	e406                	sd	ra,8(sp)
    80006304:	e022                	sd	s0,0(sp)
    80006306:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006308:	100007b7          	lui	a5,0x10000
    8000630c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006310:	10000737          	lui	a4,0x10000
    80006314:	f8000693          	li	a3,-128
    80006318:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000631c:	468d                	li	a3,3
    8000631e:	10000637          	lui	a2,0x10000
    80006322:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006326:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000632a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000632e:	10000737          	lui	a4,0x10000
    80006332:	461d                	li	a2,7
    80006334:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006338:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000633c:	00002597          	auipc	a1,0x2
    80006340:	35458593          	addi	a1,a1,852 # 80008690 <etext+0x690>
    80006344:	0002f517          	auipc	a0,0x2f
    80006348:	ec450513          	addi	a0,a0,-316 # 80035208 <uart_tx_lock>
    8000634c:	00000097          	auipc	ra,0x0
    80006350:	21a080e7          	jalr	538(ra) # 80006566 <initlock>
}
    80006354:	60a2                	ld	ra,8(sp)
    80006356:	6402                	ld	s0,0(sp)
    80006358:	0141                	addi	sp,sp,16
    8000635a:	8082                	ret

000000008000635c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000635c:	1101                	addi	sp,sp,-32
    8000635e:	ec06                	sd	ra,24(sp)
    80006360:	e822                	sd	s0,16(sp)
    80006362:	e426                	sd	s1,8(sp)
    80006364:	1000                	addi	s0,sp,32
    80006366:	84aa                	mv	s1,a0
  push_off();
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	242080e7          	jalr	578(ra) # 800065aa <push_off>

  if(panicked){
    80006370:	00006797          	auipc	a5,0x6
    80006374:	cac7a783          	lw	a5,-852(a5) # 8000c01c <panicked>
    80006378:	eb85                	bnez	a5,800063a8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000637a:	10000737          	lui	a4,0x10000
    8000637e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006380:	00074783          	lbu	a5,0(a4)
    80006384:	0207f793          	andi	a5,a5,32
    80006388:	dfe5                	beqz	a5,80006380 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000638a:	0ff4f513          	zext.b	a0,s1
    8000638e:	100007b7          	lui	a5,0x10000
    80006392:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006396:	00000097          	auipc	ra,0x0
    8000639a:	2b4080e7          	jalr	692(ra) # 8000664a <pop_off>
}
    8000639e:	60e2                	ld	ra,24(sp)
    800063a0:	6442                	ld	s0,16(sp)
    800063a2:	64a2                	ld	s1,8(sp)
    800063a4:	6105                	addi	sp,sp,32
    800063a6:	8082                	ret
    for(;;)
    800063a8:	a001                	j	800063a8 <uartputc_sync+0x4c>

00000000800063aa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800063aa:	00006797          	auipc	a5,0x6
    800063ae:	c767b783          	ld	a5,-906(a5) # 8000c020 <uart_tx_r>
    800063b2:	00006717          	auipc	a4,0x6
    800063b6:	c7673703          	ld	a4,-906(a4) # 8000c028 <uart_tx_w>
    800063ba:	06f70f63          	beq	a4,a5,80006438 <uartstart+0x8e>
{
    800063be:	7139                	addi	sp,sp,-64
    800063c0:	fc06                	sd	ra,56(sp)
    800063c2:	f822                	sd	s0,48(sp)
    800063c4:	f426                	sd	s1,40(sp)
    800063c6:	f04a                	sd	s2,32(sp)
    800063c8:	ec4e                	sd	s3,24(sp)
    800063ca:	e852                	sd	s4,16(sp)
    800063cc:	e456                	sd	s5,8(sp)
    800063ce:	e05a                	sd	s6,0(sp)
    800063d0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063d2:	10000937          	lui	s2,0x10000
    800063d6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063d8:	0002fa97          	auipc	s5,0x2f
    800063dc:	e30a8a93          	addi	s5,s5,-464 # 80035208 <uart_tx_lock>
    uart_tx_r += 1;
    800063e0:	00006497          	auipc	s1,0x6
    800063e4:	c4048493          	addi	s1,s1,-960 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800063e8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800063ec:	00006997          	auipc	s3,0x6
    800063f0:	c3c98993          	addi	s3,s3,-964 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063f4:	00094703          	lbu	a4,0(s2)
    800063f8:	02077713          	andi	a4,a4,32
    800063fc:	c705                	beqz	a4,80006424 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063fe:	01f7f713          	andi	a4,a5,31
    80006402:	9756                	add	a4,a4,s5
    80006404:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006408:	0785                	addi	a5,a5,1
    8000640a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000640c:	8526                	mv	a0,s1
    8000640e:	ffffb097          	auipc	ra,0xffffb
    80006412:	2e0080e7          	jalr	736(ra) # 800016ee <wakeup>
    WriteReg(THR, c);
    80006416:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000641a:	609c                	ld	a5,0(s1)
    8000641c:	0009b703          	ld	a4,0(s3)
    80006420:	fcf71ae3          	bne	a4,a5,800063f4 <uartstart+0x4a>
  }
}
    80006424:	70e2                	ld	ra,56(sp)
    80006426:	7442                	ld	s0,48(sp)
    80006428:	74a2                	ld	s1,40(sp)
    8000642a:	7902                	ld	s2,32(sp)
    8000642c:	69e2                	ld	s3,24(sp)
    8000642e:	6a42                	ld	s4,16(sp)
    80006430:	6aa2                	ld	s5,8(sp)
    80006432:	6b02                	ld	s6,0(sp)
    80006434:	6121                	addi	sp,sp,64
    80006436:	8082                	ret
    80006438:	8082                	ret

000000008000643a <uartputc>:
{
    8000643a:	7179                	addi	sp,sp,-48
    8000643c:	f406                	sd	ra,40(sp)
    8000643e:	f022                	sd	s0,32(sp)
    80006440:	e052                	sd	s4,0(sp)
    80006442:	1800                	addi	s0,sp,48
    80006444:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006446:	0002f517          	auipc	a0,0x2f
    8000644a:	dc250513          	addi	a0,a0,-574 # 80035208 <uart_tx_lock>
    8000644e:	00000097          	auipc	ra,0x0
    80006452:	1a8080e7          	jalr	424(ra) # 800065f6 <acquire>
  if(panicked){
    80006456:	00006797          	auipc	a5,0x6
    8000645a:	bc67a783          	lw	a5,-1082(a5) # 8000c01c <panicked>
    8000645e:	c391                	beqz	a5,80006462 <uartputc+0x28>
    for(;;)
    80006460:	a001                	j	80006460 <uartputc+0x26>
    80006462:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006464:	00006717          	auipc	a4,0x6
    80006468:	bc473703          	ld	a4,-1084(a4) # 8000c028 <uart_tx_w>
    8000646c:	00006797          	auipc	a5,0x6
    80006470:	bb47b783          	ld	a5,-1100(a5) # 8000c020 <uart_tx_r>
    80006474:	02078793          	addi	a5,a5,32
    80006478:	02e79f63          	bne	a5,a4,800064b6 <uartputc+0x7c>
    8000647c:	e84a                	sd	s2,16(sp)
    8000647e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006480:	0002f997          	auipc	s3,0x2f
    80006484:	d8898993          	addi	s3,s3,-632 # 80035208 <uart_tx_lock>
    80006488:	00006497          	auipc	s1,0x6
    8000648c:	b9848493          	addi	s1,s1,-1128 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006490:	00006917          	auipc	s2,0x6
    80006494:	b9890913          	addi	s2,s2,-1128 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006498:	85ce                	mv	a1,s3
    8000649a:	8526                	mv	a0,s1
    8000649c:	ffffb097          	auipc	ra,0xffffb
    800064a0:	0c6080e7          	jalr	198(ra) # 80001562 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064a4:	00093703          	ld	a4,0(s2)
    800064a8:	609c                	ld	a5,0(s1)
    800064aa:	02078793          	addi	a5,a5,32
    800064ae:	fee785e3          	beq	a5,a4,80006498 <uartputc+0x5e>
    800064b2:	6942                	ld	s2,16(sp)
    800064b4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064b6:	0002f497          	auipc	s1,0x2f
    800064ba:	d5248493          	addi	s1,s1,-686 # 80035208 <uart_tx_lock>
    800064be:	01f77793          	andi	a5,a4,31
    800064c2:	97a6                	add	a5,a5,s1
    800064c4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800064c8:	0705                	addi	a4,a4,1
    800064ca:	00006797          	auipc	a5,0x6
    800064ce:	b4e7bf23          	sd	a4,-1186(a5) # 8000c028 <uart_tx_w>
      uartstart();
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	ed8080e7          	jalr	-296(ra) # 800063aa <uartstart>
      release(&uart_tx_lock);
    800064da:	8526                	mv	a0,s1
    800064dc:	00000097          	auipc	ra,0x0
    800064e0:	1ce080e7          	jalr	462(ra) # 800066aa <release>
    800064e4:	64e2                	ld	s1,24(sp)
}
    800064e6:	70a2                	ld	ra,40(sp)
    800064e8:	7402                	ld	s0,32(sp)
    800064ea:	6a02                	ld	s4,0(sp)
    800064ec:	6145                	addi	sp,sp,48
    800064ee:	8082                	ret

00000000800064f0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064f0:	1141                	addi	sp,sp,-16
    800064f2:	e422                	sd	s0,8(sp)
    800064f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064f6:	100007b7          	lui	a5,0x10000
    800064fa:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800064fc:	0007c783          	lbu	a5,0(a5)
    80006500:	8b85                	andi	a5,a5,1
    80006502:	cb81                	beqz	a5,80006512 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006504:	100007b7          	lui	a5,0x10000
    80006508:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000650c:	6422                	ld	s0,8(sp)
    8000650e:	0141                	addi	sp,sp,16
    80006510:	8082                	ret
    return -1;
    80006512:	557d                	li	a0,-1
    80006514:	bfe5                	j	8000650c <uartgetc+0x1c>

0000000080006516 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006516:	1101                	addi	sp,sp,-32
    80006518:	ec06                	sd	ra,24(sp)
    8000651a:	e822                	sd	s0,16(sp)
    8000651c:	e426                	sd	s1,8(sp)
    8000651e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006520:	54fd                	li	s1,-1
    80006522:	a029                	j	8000652c <uartintr+0x16>
      break;
    consoleintr(c);
    80006524:	00000097          	auipc	ra,0x0
    80006528:	8ce080e7          	jalr	-1842(ra) # 80005df2 <consoleintr>
    int c = uartgetc();
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	fc4080e7          	jalr	-60(ra) # 800064f0 <uartgetc>
    if(c == -1)
    80006534:	fe9518e3          	bne	a0,s1,80006524 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006538:	0002f497          	auipc	s1,0x2f
    8000653c:	cd048493          	addi	s1,s1,-816 # 80035208 <uart_tx_lock>
    80006540:	8526                	mv	a0,s1
    80006542:	00000097          	auipc	ra,0x0
    80006546:	0b4080e7          	jalr	180(ra) # 800065f6 <acquire>
  uartstart();
    8000654a:	00000097          	auipc	ra,0x0
    8000654e:	e60080e7          	jalr	-416(ra) # 800063aa <uartstart>
  release(&uart_tx_lock);
    80006552:	8526                	mv	a0,s1
    80006554:	00000097          	auipc	ra,0x0
    80006558:	156080e7          	jalr	342(ra) # 800066aa <release>
}
    8000655c:	60e2                	ld	ra,24(sp)
    8000655e:	6442                	ld	s0,16(sp)
    80006560:	64a2                	ld	s1,8(sp)
    80006562:	6105                	addi	sp,sp,32
    80006564:	8082                	ret

0000000080006566 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006566:	1141                	addi	sp,sp,-16
    80006568:	e422                	sd	s0,8(sp)
    8000656a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000656c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000656e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006572:	00053823          	sd	zero,16(a0)
}
    80006576:	6422                	ld	s0,8(sp)
    80006578:	0141                	addi	sp,sp,16
    8000657a:	8082                	ret

000000008000657c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000657c:	411c                	lw	a5,0(a0)
    8000657e:	e399                	bnez	a5,80006584 <holding+0x8>
    80006580:	4501                	li	a0,0
  return r;
}
    80006582:	8082                	ret
{
    80006584:	1101                	addi	sp,sp,-32
    80006586:	ec06                	sd	ra,24(sp)
    80006588:	e822                	sd	s0,16(sp)
    8000658a:	e426                	sd	s1,8(sp)
    8000658c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000658e:	6904                	ld	s1,16(a0)
    80006590:	ffffb097          	auipc	ra,0xffffb
    80006594:	8b6080e7          	jalr	-1866(ra) # 80000e46 <mycpu>
    80006598:	40a48533          	sub	a0,s1,a0
    8000659c:	00153513          	seqz	a0,a0
}
    800065a0:	60e2                	ld	ra,24(sp)
    800065a2:	6442                	ld	s0,16(sp)
    800065a4:	64a2                	ld	s1,8(sp)
    800065a6:	6105                	addi	sp,sp,32
    800065a8:	8082                	ret

00000000800065aa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800065aa:	1101                	addi	sp,sp,-32
    800065ac:	ec06                	sd	ra,24(sp)
    800065ae:	e822                	sd	s0,16(sp)
    800065b0:	e426                	sd	s1,8(sp)
    800065b2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065b4:	100024f3          	csrr	s1,sstatus
    800065b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065be:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800065c2:	ffffb097          	auipc	ra,0xffffb
    800065c6:	884080e7          	jalr	-1916(ra) # 80000e46 <mycpu>
    800065ca:	5d3c                	lw	a5,120(a0)
    800065cc:	cf89                	beqz	a5,800065e6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800065ce:	ffffb097          	auipc	ra,0xffffb
    800065d2:	878080e7          	jalr	-1928(ra) # 80000e46 <mycpu>
    800065d6:	5d3c                	lw	a5,120(a0)
    800065d8:	2785                	addiw	a5,a5,1
    800065da:	dd3c                	sw	a5,120(a0)
}
    800065dc:	60e2                	ld	ra,24(sp)
    800065de:	6442                	ld	s0,16(sp)
    800065e0:	64a2                	ld	s1,8(sp)
    800065e2:	6105                	addi	sp,sp,32
    800065e4:	8082                	ret
    mycpu()->intena = old;
    800065e6:	ffffb097          	auipc	ra,0xffffb
    800065ea:	860080e7          	jalr	-1952(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065ee:	8085                	srli	s1,s1,0x1
    800065f0:	8885                	andi	s1,s1,1
    800065f2:	dd64                	sw	s1,124(a0)
    800065f4:	bfe9                	j	800065ce <push_off+0x24>

00000000800065f6 <acquire>:
{
    800065f6:	1101                	addi	sp,sp,-32
    800065f8:	ec06                	sd	ra,24(sp)
    800065fa:	e822                	sd	s0,16(sp)
    800065fc:	e426                	sd	s1,8(sp)
    800065fe:	1000                	addi	s0,sp,32
    80006600:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006602:	00000097          	auipc	ra,0x0
    80006606:	fa8080e7          	jalr	-88(ra) # 800065aa <push_off>
  if(holding(lk))
    8000660a:	8526                	mv	a0,s1
    8000660c:	00000097          	auipc	ra,0x0
    80006610:	f70080e7          	jalr	-144(ra) # 8000657c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006614:	4705                	li	a4,1
  if(holding(lk))
    80006616:	e115                	bnez	a0,8000663a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006618:	87ba                	mv	a5,a4
    8000661a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000661e:	2781                	sext.w	a5,a5
    80006620:	ffe5                	bnez	a5,80006618 <acquire+0x22>
  __sync_synchronize();
    80006622:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006626:	ffffb097          	auipc	ra,0xffffb
    8000662a:	820080e7          	jalr	-2016(ra) # 80000e46 <mycpu>
    8000662e:	e888                	sd	a0,16(s1)
}
    80006630:	60e2                	ld	ra,24(sp)
    80006632:	6442                	ld	s0,16(sp)
    80006634:	64a2                	ld	s1,8(sp)
    80006636:	6105                	addi	sp,sp,32
    80006638:	8082                	ret
    panic("acquire");
    8000663a:	00002517          	auipc	a0,0x2
    8000663e:	05e50513          	addi	a0,a0,94 # 80008698 <etext+0x698>
    80006642:	00000097          	auipc	ra,0x0
    80006646:	a3a080e7          	jalr	-1478(ra) # 8000607c <panic>

000000008000664a <pop_off>:

void
pop_off(void)
{
    8000664a:	1141                	addi	sp,sp,-16
    8000664c:	e406                	sd	ra,8(sp)
    8000664e:	e022                	sd	s0,0(sp)
    80006650:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006652:	ffffa097          	auipc	ra,0xffffa
    80006656:	7f4080e7          	jalr	2036(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000665a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000665e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006660:	e78d                	bnez	a5,8000668a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006662:	5d3c                	lw	a5,120(a0)
    80006664:	02f05b63          	blez	a5,8000669a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006668:	37fd                	addiw	a5,a5,-1
    8000666a:	0007871b          	sext.w	a4,a5
    8000666e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006670:	eb09                	bnez	a4,80006682 <pop_off+0x38>
    80006672:	5d7c                	lw	a5,124(a0)
    80006674:	c799                	beqz	a5,80006682 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006676:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000667a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000667e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006682:	60a2                	ld	ra,8(sp)
    80006684:	6402                	ld	s0,0(sp)
    80006686:	0141                	addi	sp,sp,16
    80006688:	8082                	ret
    panic("pop_off - interruptible");
    8000668a:	00002517          	auipc	a0,0x2
    8000668e:	01650513          	addi	a0,a0,22 # 800086a0 <etext+0x6a0>
    80006692:	00000097          	auipc	ra,0x0
    80006696:	9ea080e7          	jalr	-1558(ra) # 8000607c <panic>
    panic("pop_off");
    8000669a:	00002517          	auipc	a0,0x2
    8000669e:	01e50513          	addi	a0,a0,30 # 800086b8 <etext+0x6b8>
    800066a2:	00000097          	auipc	ra,0x0
    800066a6:	9da080e7          	jalr	-1574(ra) # 8000607c <panic>

00000000800066aa <release>:
{
    800066aa:	1101                	addi	sp,sp,-32
    800066ac:	ec06                	sd	ra,24(sp)
    800066ae:	e822                	sd	s0,16(sp)
    800066b0:	e426                	sd	s1,8(sp)
    800066b2:	1000                	addi	s0,sp,32
    800066b4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066b6:	00000097          	auipc	ra,0x0
    800066ba:	ec6080e7          	jalr	-314(ra) # 8000657c <holding>
    800066be:	c115                	beqz	a0,800066e2 <release+0x38>
  lk->cpu = 0;
    800066c0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066c4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800066c8:	0310000f          	fence	rw,w
    800066cc:	0004a023          	sw	zero,0(s1)
  pop_off();
    800066d0:	00000097          	auipc	ra,0x0
    800066d4:	f7a080e7          	jalr	-134(ra) # 8000664a <pop_off>
}
    800066d8:	60e2                	ld	ra,24(sp)
    800066da:	6442                	ld	s0,16(sp)
    800066dc:	64a2                	ld	s1,8(sp)
    800066de:	6105                	addi	sp,sp,32
    800066e0:	8082                	ret
    panic("release");
    800066e2:	00002517          	auipc	a0,0x2
    800066e6:	fde50513          	addi	a0,a0,-34 # 800086c0 <etext+0x6c0>
    800066ea:	00000097          	auipc	ra,0x0
    800066ee:	992080e7          	jalr	-1646(ra) # 8000607c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
