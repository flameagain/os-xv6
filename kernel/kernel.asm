
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	0e013103          	ld	sp,224(sp) # 8000b0e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	029050ef          	jal	8000583e <start>

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
    80000030:	0002d797          	auipc	a5,0x2d
    80000034:	21078793          	addi	a5,a5,528 # 8002d240 <end>
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
    8000005e:	2ac080e7          	jalr	684(ra) # 80006306 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	34c080e7          	jalr	844(ra) # 800063ba <release>
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
    8000008e:	d2c080e7          	jalr	-724(ra) # 80005db6 <panic>

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
    800000fa:	180080e7          	jalr	384(ra) # 80006276 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0002d517          	auipc	a0,0x2d
    80000106:	13e50513          	addi	a0,a0,318 # 8002d240 <end>
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
    80000132:	1d8080e7          	jalr	472(ra) # 80006306 <acquire>
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
    8000014a:	274080e7          	jalr	628(ra) # 800063ba <release>

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
    80000174:	24a080e7          	jalr	586(ra) # 800063ba <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd1dc1>
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
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
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
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	aba080e7          	jalr	-1350(ra) # 80005e08 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	788080e7          	jalr	1928(ra) # 80001ae6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	e8e080e7          	jalr	-370(ra) # 800051f4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	034080e7          	jalr	52(ra) # 800013a2 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	8a6080e7          	jalr	-1882(ra) # 80005c1c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	98e080e7          	jalr	-1650(ra) # 80005d0c <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	a7a080e7          	jalr	-1414(ra) # 80005e08 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	a6a080e7          	jalr	-1430(ra) # 80005e08 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a5a080e7          	jalr	-1446(ra) # 80005e08 <printf>
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
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	6e8080e7          	jalr	1768(ra) # 80001abe <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	708080e7          	jalr	1800(ra) # 80001ae6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	df4080e7          	jalr	-524(ra) # 800051da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e06080e7          	jalr	-506(ra) # 800051f4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f1c080e7          	jalr	-228(ra) # 80002312 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	5a8080e7          	jalr	1448(ra) # 800029a6 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	54c080e7          	jalr	1356(ra) # 80003952 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f06080e7          	jalr	-250(ra) # 80005314 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d50080e7          	jalr	-688(ra) # 80001166 <userinit>
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
    80000484:	936080e7          	jalr	-1738(ra) # 80005db6 <panic>
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
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd1db7>
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
    800005aa:	810080e7          	jalr	-2032(ra) # 80005db6 <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	800080e7          	jalr	-2048(ra) # 80005db6 <panic>
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
    80000602:	00005097          	auipc	ra,0x5
    80000606:	7b4080e7          	jalr	1972(ra) # 80005db6 <panic>

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
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
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
    8000071e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
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
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	66e080e7          	jalr	1646(ra) # 80005db6 <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	65e080e7          	jalr	1630(ra) # 80005db6 <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	64e080e7          	jalr	1614(ra) # 80005db6 <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	63e080e7          	jalr	1598(ra) # 80005db6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	andi	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	andi	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007b2:	0532                	slli	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
  }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	addi	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
  return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	addi	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	addi	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	addi	sp,sp,48
    80000862:	8082                	ret
    panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	addi	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	54a080e7          	jalr	1354(ra) # 80005db6 <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	addi	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
  if(newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	addi	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
      return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
    return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
  return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	andi	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	3fe080e7          	jalr	1022(ra) # 80005db6 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srli	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	addi	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	andi	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srli	a1,a4,0xa
    80000a50:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	addi	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	320080e7          	jalr	800(ra) # 80005db6 <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	310080e7          	jalr	784(ra) # 80005db6 <panic>
      kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srli	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
  return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	addi	sp,sp,80
    80000ae0:	8082                	ret
  return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	addi	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
  if(pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	andi	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	addi	sp,sp,16
    80000b06:	8082                	ret
    panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	addi	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	2a6080e7          	jalr	678(ra) # 80005db6 <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	addi	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

    len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b58:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
  }
  return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
      return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	addi	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

    len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
  }
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
      return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	addi	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
      --max;
    80000c80:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd1dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
  int got_null = 0;
    80000ce4:	4781                	li	a5,0
  if(got_null){
    80000ce6:	37fd                	addiw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	0000b497          	auipc	s1,0xb
    80000d08:	77c48493          	addi	s1,s1,1916 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	fcf3d937          	lui	s2,0xfcf3d
    80000d12:	f3d90913          	addi	s2,s2,-195 # fffffffffcf3cf3d <end+0xffffffff7cf0fcfd>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	f3d90913          	addi	s2,s2,-195
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	f3d90913          	addi	s2,s2,-195
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	f3d90913          	addi	s2,s2,-195
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00016a97          	auipc	s5,0x16
    80000d34:	f50a8a93          	addi	s5,s5,-176 # 80016c80 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	8595                	srai	a1,a1,0x5
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	2a048493          	addi	s1,s1,672
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	02c080e7          	jalr	44(ra) # 80005db6 <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	0000b517          	auipc	a0,0xb
    80000db2:	2a250513          	addi	a0,a0,674 # 8000c050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	4c0080e7          	jalr	1216(ra) # 80006276 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	0000b517          	auipc	a0,0xb
    80000dca:	2a250513          	addi	a0,a0,674 # 8000c068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	4a8080e7          	jalr	1192(ra) # 80006276 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000b497          	auipc	s1,0xb
    80000dda:	6aa48493          	addi	s1,s1,1706 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	fcf3d937          	lui	s2,0xfcf3d
    80000dec:	f3d90913          	addi	s2,s2,-195 # fffffffffcf3cf3d <end+0xffffffff7cf0fcfd>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	f3d90913          	addi	s2,s2,-195
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	f3d90913          	addi	s2,s2,-195
    80000dfc:	0932                	slli	s2,s2,0xc
    80000dfe:	f3d90913          	addi	s2,s2,-195
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00016a17          	auipc	s4,0x16
    80000e0e:	e76a0a13          	addi	s4,s4,-394 # 80016c80 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	460080e7          	jalr	1120(ra) # 80006276 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	8795                	srai	a5,a5,0x5
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	2a048493          	addi	s1,s1,672
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	0000b517          	auipc	a0,0xb
    80000e70:	21450513          	addi	a0,a0,532 # 8000c080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	434080e7          	jalr	1076(ra) # 800062ba <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	0000b717          	auipc	a4,0xb
    80000e98:	1bc70713          	addi	a4,a4,444 # 8000c050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	4ba080e7          	jalr	1210(ra) # 8000635a <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	4f6080e7          	jalr	1270(ra) # 800063ba <release>

  if (first) {
    80000ecc:	0000a797          	auipc	a5,0xa
    80000ed0:	1c47a783          	lw	a5,452(a5) # 8000b090 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c28080e7          	jalr	-984(ra) # 80001afe <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	0000a797          	auipc	a5,0xa
    80000eea:	1a07a523          	sw	zero,426(a5) # 8000b090 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	a36080e7          	jalr	-1482(ra) # 80002926 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	0000b917          	auipc	s2,0xb
    80000f0a:	14a90913          	addi	s2,s2,330 # 8000c050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	3f6080e7          	jalr	1014(ra) # 80006306 <acquire>
  pid = nextpid;
    80000f18:	0000a797          	auipc	a5,0xa
    80000f1c:	17c78793          	addi	a5,a5,380 # 8000b094 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	490080e7          	jalr	1168(ra) # 800063ba <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ac23          	sw	zero,24(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	0000b497          	auipc	s1,0xb
    80001096:	3ee48493          	addi	s1,s1,1006 # 8000c480 <proc>
    8000109a:	00016917          	auipc	s2,0x16
    8000109e:	be690913          	addi	s2,s2,-1050 # 80016c80 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	262080e7          	jalr	610(ra) # 80006306 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	308080e7          	jalr	776(ra) # 800063ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	2a048493          	addi	s1,s1,672
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	a095                	j	80001128 <allocproc+0xa2>
  p->pid = allocpid();
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e34080e7          	jalr	-460(ra) # 80000efa <allocpid>
    800010ce:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d0:	4785                	li	a5,1
    800010d2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	046080e7          	jalr	70(ra) # 8000011a <kalloc>
    800010dc:	892a                	mv	s2,a0
    800010de:	eca8                	sd	a0,88(s1)
    800010e0:	c939                	beqz	a0,80001136 <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e5c080e7          	jalr	-420(ra) # 80000f40 <proc_pagetable>
    800010ec:	892a                	mv	s2,a0
    800010ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f0:	cd39                	beqz	a0,8000114e <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    800010f2:	07000613          	li	a2,112
    800010f6:	4581                	li	a1,0
    800010f8:	06048513          	addi	a0,s1,96
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	07e080e7          	jalr	126(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001104:	00000797          	auipc	a5,0x0
    80001108:	db078793          	addi	a5,a5,-592 # 80000eb4 <forkret>
    8000110c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110e:	60bc                	ld	a5,64(s1)
    80001110:	6705                	lui	a4,0x1
    80001112:	97ba                	add	a5,a5,a4
    80001114:	f4bc                	sd	a5,104(s1)
  p->alarm_interval = 0;
    80001116:	1604a423          	sw	zero,360(s1)
  p->alarm_ticks = 0;
    8000111a:	1604a623          	sw	zero,364(s1)
  p->alarm_handler = 0;
    8000111e:	1604b823          	sd	zero,368(s1)
  p->handler_exec = 1;
    80001122:	4785                	li	a5,1
    80001124:	16f4ac23          	sw	a5,376(s1)
}
    80001128:	8526                	mv	a0,s1
    8000112a:	60e2                	ld	ra,24(sp)
    8000112c:	6442                	ld	s0,16(sp)
    8000112e:	64a2                	ld	s1,8(sp)
    80001130:	6902                	ld	s2,0(sp)
    80001132:	6105                	addi	sp,sp,32
    80001134:	8082                	ret
    freeproc(p);
    80001136:	8526                	mv	a0,s1
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	ef6080e7          	jalr	-266(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001140:	8526                	mv	a0,s1
    80001142:	00005097          	auipc	ra,0x5
    80001146:	278080e7          	jalr	632(ra) # 800063ba <release>
    return 0;
    8000114a:	84ca                	mv	s1,s2
    8000114c:	bff1                	j	80001128 <allocproc+0xa2>
    freeproc(p);
    8000114e:	8526                	mv	a0,s1
    80001150:	00000097          	auipc	ra,0x0
    80001154:	ede080e7          	jalr	-290(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001158:	8526                	mv	a0,s1
    8000115a:	00005097          	auipc	ra,0x5
    8000115e:	260080e7          	jalr	608(ra) # 800063ba <release>
    return 0;
    80001162:	84ca                	mv	s1,s2
    80001164:	b7d1                	j	80001128 <allocproc+0xa2>

0000000080001166 <userinit>:
{
    80001166:	1101                	addi	sp,sp,-32
    80001168:	ec06                	sd	ra,24(sp)
    8000116a:	e822                	sd	s0,16(sp)
    8000116c:	e426                	sd	s1,8(sp)
    8000116e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f16080e7          	jalr	-234(ra) # 80001086 <allocproc>
    80001178:	84aa                	mv	s1,a0
  initproc = p;
    8000117a:	0000b797          	auipc	a5,0xb
    8000117e:	e8a7bb23          	sd	a0,-362(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001182:	03400613          	li	a2,52
    80001186:	0000a597          	auipc	a1,0xa
    8000118a:	f1a58593          	addi	a1,a1,-230 # 8000b0a0 <initcode>
    8000118e:	6928                	ld	a0,80(a0)
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	672080e7          	jalr	1650(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001198:	6785                	lui	a5,0x1
    8000119a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119c:	6cb8                	ld	a4,88(s1)
    8000119e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a2:	6cb8                	ld	a4,88(s1)
    800011a4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a6:	4641                	li	a2,16
    800011a8:	00007597          	auipc	a1,0x7
    800011ac:	fd858593          	addi	a1,a1,-40 # 80008180 <etext+0x180>
    800011b0:	15848513          	addi	a0,s1,344
    800011b4:	fffff097          	auipc	ra,0xfffff
    800011b8:	108080e7          	jalr	264(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011bc:	00007517          	auipc	a0,0x7
    800011c0:	fd450513          	addi	a0,a0,-44 # 80008190 <etext+0x190>
    800011c4:	00002097          	auipc	ra,0x2
    800011c8:	1a8080e7          	jalr	424(ra) # 8000336c <namei>
    800011cc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d0:	478d                	li	a5,3
    800011d2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	1e4080e7          	jalr	484(ra) # 800063ba <release>
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <growproc>:
{
    800011e8:	1101                	addi	sp,sp,-32
    800011ea:	ec06                	sd	ra,24(sp)
    800011ec:	e822                	sd	s0,16(sp)
    800011ee:	e426                	sd	s1,8(sp)
    800011f0:	e04a                	sd	s2,0(sp)
    800011f2:	1000                	addi	s0,sp,32
    800011f4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	c86080e7          	jalr	-890(ra) # 80000e7c <myproc>
    800011fe:	892a                	mv	s2,a0
  sz = p->sz;
    80001200:	652c                	ld	a1,72(a0)
    80001202:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001206:	00904f63          	bgtz	s1,80001224 <growproc+0x3c>
  } else if(n < 0){
    8000120a:	0204cd63          	bltz	s1,80001244 <growproc+0x5c>
  p->sz = sz;
    8000120e:	1782                	slli	a5,a5,0x20
    80001210:	9381                	srli	a5,a5,0x20
    80001212:	04f93423          	sd	a5,72(s2)
  return 0;
    80001216:	4501                	li	a0,0
}
    80001218:	60e2                	ld	ra,24(sp)
    8000121a:	6442                	ld	s0,16(sp)
    8000121c:	64a2                	ld	s1,8(sp)
    8000121e:	6902                	ld	s2,0(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001224:	00f4863b          	addw	a2,s1,a5
    80001228:	1602                	slli	a2,a2,0x20
    8000122a:	9201                	srli	a2,a2,0x20
    8000122c:	1582                	slli	a1,a1,0x20
    8000122e:	9181                	srli	a1,a1,0x20
    80001230:	6928                	ld	a0,80(a0)
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	68a080e7          	jalr	1674(ra) # 800008bc <uvmalloc>
    8000123a:	0005079b          	sext.w	a5,a0
    8000123e:	fbe1                	bnez	a5,8000120e <growproc+0x26>
      return -1;
    80001240:	557d                	li	a0,-1
    80001242:	bfd9                	j	80001218 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001244:	00f4863b          	addw	a2,s1,a5
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	622080e7          	jalr	1570(ra) # 80000874 <uvmdealloc>
    8000125a:	0005079b          	sext.w	a5,a0
    8000125e:	bf45                	j	8000120e <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7139                	addi	sp,sp,-64
    80001262:	fc06                	sd	ra,56(sp)
    80001264:	f822                	sd	s0,48(sp)
    80001266:	f04a                	sd	s2,32(sp)
    80001268:	e456                	sd	s5,8(sp)
    8000126a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	c10080e7          	jalr	-1008(ra) # 80000e7c <myproc>
    80001274:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	e10080e7          	jalr	-496(ra) # 80001086 <allocproc>
    8000127e:	12050063          	beqz	a0,8000139e <fork+0x13e>
    80001282:	e852                	sd	s4,16(sp)
    80001284:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001286:	048ab603          	ld	a2,72(s5)
    8000128a:	692c                	ld	a1,80(a0)
    8000128c:	050ab503          	ld	a0,80(s5)
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	784080e7          	jalr	1924(ra) # 80000a14 <uvmcopy>
    80001298:	04054a63          	bltz	a0,800012ec <fork+0x8c>
    8000129c:	f426                	sd	s1,40(sp)
    8000129e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012a0:	048ab783          	ld	a5,72(s5)
    800012a4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012a8:	058ab683          	ld	a3,88(s5)
    800012ac:	87b6                	mv	a5,a3
    800012ae:	058a3703          	ld	a4,88(s4)
    800012b2:	12068693          	addi	a3,a3,288
    800012b6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ba:	6788                	ld	a0,8(a5)
    800012bc:	6b8c                	ld	a1,16(a5)
    800012be:	6f90                	ld	a2,24(a5)
    800012c0:	01073023          	sd	a6,0(a4)
    800012c4:	e708                	sd	a0,8(a4)
    800012c6:	eb0c                	sd	a1,16(a4)
    800012c8:	ef10                	sd	a2,24(a4)
    800012ca:	02078793          	addi	a5,a5,32
    800012ce:	02070713          	addi	a4,a4,32
    800012d2:	fed792e3          	bne	a5,a3,800012b6 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d6:	058a3783          	ld	a5,88(s4)
    800012da:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012de:	0d0a8493          	addi	s1,s5,208
    800012e2:	0d0a0913          	addi	s2,s4,208
    800012e6:	150a8993          	addi	s3,s5,336
    800012ea:	a015                	j	8000130e <fork+0xae>
    freeproc(np);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	d40080e7          	jalr	-704(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012f6:	8552                	mv	a0,s4
    800012f8:	00005097          	auipc	ra,0x5
    800012fc:	0c2080e7          	jalr	194(ra) # 800063ba <release>
    return -1;
    80001300:	597d                	li	s2,-1
    80001302:	6a42                	ld	s4,16(sp)
    80001304:	a071                	j	80001390 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	0921                	addi	s2,s2,8
    8000130a:	01348b63          	beq	s1,s3,80001320 <fork+0xc0>
    if(p->ofile[i])
    8000130e:	6088                	ld	a0,0(s1)
    80001310:	d97d                	beqz	a0,80001306 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001312:	00002097          	auipc	ra,0x2
    80001316:	6d2080e7          	jalr	1746(ra) # 800039e4 <filedup>
    8000131a:	00a93023          	sd	a0,0(s2)
    8000131e:	b7e5                	j	80001306 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001320:	150ab503          	ld	a0,336(s5)
    80001324:	00002097          	auipc	ra,0x2
    80001328:	838080e7          	jalr	-1992(ra) # 80002b5c <idup>
    8000132c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	158a0513          	addi	a0,s4,344
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	f82080e7          	jalr	-126(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001342:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001346:	8552                	mv	a0,s4
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	072080e7          	jalr	114(ra) # 800063ba <release>
  acquire(&wait_lock);
    80001350:	0000b497          	auipc	s1,0xb
    80001354:	d1848493          	addi	s1,s1,-744 # 8000c068 <wait_lock>
    80001358:	8526                	mv	a0,s1
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	fac080e7          	jalr	-84(ra) # 80006306 <acquire>
  np->parent = p;
    80001362:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001366:	8526                	mv	a0,s1
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	052080e7          	jalr	82(ra) # 800063ba <release>
  acquire(&np->lock);
    80001370:	8552                	mv	a0,s4
    80001372:	00005097          	auipc	ra,0x5
    80001376:	f94080e7          	jalr	-108(ra) # 80006306 <acquire>
  np->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001380:	8552                	mv	a0,s4
    80001382:	00005097          	auipc	ra,0x5
    80001386:	038080e7          	jalr	56(ra) # 800063ba <release>
  return pid;
    8000138a:	74a2                	ld	s1,40(sp)
    8000138c:	69e2                	ld	s3,24(sp)
    8000138e:	6a42                	ld	s4,16(sp)
}
    80001390:	854a                	mv	a0,s2
    80001392:	70e2                	ld	ra,56(sp)
    80001394:	7442                	ld	s0,48(sp)
    80001396:	7902                	ld	s2,32(sp)
    80001398:	6aa2                	ld	s5,8(sp)
    8000139a:	6121                	addi	sp,sp,64
    8000139c:	8082                	ret
    return -1;
    8000139e:	597d                	li	s2,-1
    800013a0:	bfc5                	j	80001390 <fork+0x130>

00000000800013a2 <scheduler>:
{
    800013a2:	7139                	addi	sp,sp,-64
    800013a4:	fc06                	sd	ra,56(sp)
    800013a6:	f822                	sd	s0,48(sp)
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	f04a                	sd	s2,32(sp)
    800013ac:	ec4e                	sd	s3,24(sp)
    800013ae:	e852                	sd	s4,16(sp)
    800013b0:	e456                	sd	s5,8(sp)
    800013b2:	e05a                	sd	s6,0(sp)
    800013b4:	0080                	addi	s0,sp,64
    800013b6:	8792                	mv	a5,tp
  int id = r_tp();
    800013b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ba:	00779a93          	slli	s5,a5,0x7
    800013be:	0000b717          	auipc	a4,0xb
    800013c2:	c9270713          	addi	a4,a4,-878 # 8000c050 <pid_lock>
    800013c6:	9756                	add	a4,a4,s5
    800013c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013cc:	0000b717          	auipc	a4,0xb
    800013d0:	cbc70713          	addi	a4,a4,-836 # 8000c088 <cpus+0x8>
    800013d4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d6:	498d                	li	s3,3
        p->state = RUNNING;
    800013d8:	4b11                	li	s6,4
        c->proc = p;
    800013da:	079e                	slli	a5,a5,0x7
    800013dc:	0000ba17          	auipc	s4,0xb
    800013e0:	c74a0a13          	addi	s4,s4,-908 # 8000c050 <pid_lock>
    800013e4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	00016917          	auipc	s2,0x16
    800013ea:	89a90913          	addi	s2,s2,-1894 # 80016c80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f6:	10079073          	csrw	sstatus,a5
    800013fa:	0000b497          	auipc	s1,0xb
    800013fe:	08648493          	addi	s1,s1,134 # 8000c480 <proc>
    80001402:	a811                	j	80001416 <scheduler+0x74>
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	fb4080e7          	jalr	-76(ra) # 800063ba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	2a048493          	addi	s1,s1,672
    80001412:	fd248ee3          	beq	s1,s2,800013ee <scheduler+0x4c>
      acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	eee080e7          	jalr	-274(ra) # 80006306 <acquire>
      if(p->state == RUNNABLE) {
    80001420:	4c9c                	lw	a5,24(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <scheduler+0x62>
        p->state = RUNNING;
    80001426:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142e:	06048593          	addi	a1,s1,96
    80001432:	8556                	mv	a0,s5
    80001434:	00000097          	auipc	ra,0x0
    80001438:	620080e7          	jalr	1568(ra) # 80001a54 <swtch>
        c->proc = 0;
    8000143c:	020a3823          	sd	zero,48(s4)
    80001440:	b7d1                	j	80001404 <scheduler+0x62>

0000000080001442 <sched>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	a2c080e7          	jalr	-1492(ra) # 80000e7c <myproc>
    80001458:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	e32080e7          	jalr	-462(ra) # 8000628c <holding>
    80001462:	c93d                	beqz	a0,800014d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	0000b717          	auipc	a4,0xb
    8000146e:	be670713          	addi	a4,a4,-1050 # 8000c050 <pid_lock>
    80001472:	97ba                	add	a5,a5,a4
    80001474:	0a87a703          	lw	a4,168(a5)
    80001478:	4785                	li	a5,1
    8000147a:	06f71763          	bne	a4,a5,800014e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000147e:	4c98                	lw	a4,24(s1)
    80001480:	4791                	li	a5,4
    80001482:	06f70b63          	beq	a4,a5,800014f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001486:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148c:	efb5                	bnez	a5,80001508 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001490:	0000b917          	auipc	s2,0xb
    80001494:	bc090913          	addi	s2,s2,-1088 # 8000c050 <pid_lock>
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	97ca                	add	a5,a5,s2
    8000149e:	0ac7a983          	lw	s3,172(a5)
    800014a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	0000b597          	auipc	a1,0xb
    800014ac:	be058593          	addi	a1,a1,-1056 # 8000c088 <cpus+0x8>
    800014b0:	95be                	add	a1,a1,a5
    800014b2:	06048513          	addi	a0,s1,96
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	59e080e7          	jalr	1438(ra) # 80001a54 <swtch>
    800014be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	993e                	add	s2,s2,a5
    800014c6:	0b392623          	sw	s3,172(s2)
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("sched p->lock");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	cc050513          	addi	a0,a0,-832 # 80008198 <etext+0x198>
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	8d6080e7          	jalr	-1834(ra) # 80005db6 <panic>
    panic("sched locks");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	cc050513          	addi	a0,a0,-832 # 800081a8 <etext+0x1a8>
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	8c6080e7          	jalr	-1850(ra) # 80005db6 <panic>
    panic("sched running");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	cc050513          	addi	a0,a0,-832 # 800081b8 <etext+0x1b8>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	8b6080e7          	jalr	-1866(ra) # 80005db6 <panic>
    panic("sched interruptible");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cc050513          	addi	a0,a0,-832 # 800081c8 <etext+0x1c8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	8a6080e7          	jalr	-1882(ra) # 80005db6 <panic>

0000000080001518 <yield>:
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	95a080e7          	jalr	-1702(ra) # 80000e7c <myproc>
    8000152a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	dda080e7          	jalr	-550(ra) # 80006306 <acquire>
  p->state = RUNNABLE;
    80001534:	478d                	li	a5,3
    80001536:	cc9c                	sw	a5,24(s1)
  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f0a080e7          	jalr	-246(ra) # 80001442 <sched>
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00005097          	auipc	ra,0x5
    80001546:	e78080e7          	jalr	-392(ra) # 800063ba <release>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret

0000000080001554 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001554:	7179                	addi	sp,sp,-48
    80001556:	f406                	sd	ra,40(sp)
    80001558:	f022                	sd	s0,32(sp)
    8000155a:	ec26                	sd	s1,24(sp)
    8000155c:	e84a                	sd	s2,16(sp)
    8000155e:	e44e                	sd	s3,8(sp)
    80001560:	1800                	addi	s0,sp,48
    80001562:	89aa                	mv	s3,a0
    80001564:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	916080e7          	jalr	-1770(ra) # 80000e7c <myproc>
    8000156e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	d96080e7          	jalr	-618(ra) # 80006306 <acquire>
  release(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	e40080e7          	jalr	-448(ra) # 800063ba <release>

  // Go to sleep.
  p->chan = chan;
    80001582:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001586:	4789                	li	a5,2
    80001588:	cc9c                	sw	a5,24(s1)

  sched();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	eb8080e7          	jalr	-328(ra) # 80001442 <sched>

  // Tidy up.
  p->chan = 0;
    80001592:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	e22080e7          	jalr	-478(ra) # 800063ba <release>
  acquire(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	d64080e7          	jalr	-668(ra) # 80006306 <acquire>
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <wait>:
{
    800015b8:	715d                	addi	sp,sp,-80
    800015ba:	e486                	sd	ra,72(sp)
    800015bc:	e0a2                	sd	s0,64(sp)
    800015be:	fc26                	sd	s1,56(sp)
    800015c0:	f84a                	sd	s2,48(sp)
    800015c2:	f44e                	sd	s3,40(sp)
    800015c4:	f052                	sd	s4,32(sp)
    800015c6:	ec56                	sd	s5,24(sp)
    800015c8:	e85a                	sd	s6,16(sp)
    800015ca:	e45e                	sd	s7,8(sp)
    800015cc:	e062                	sd	s8,0(sp)
    800015ce:	0880                	addi	s0,sp,80
    800015d0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	8aa080e7          	jalr	-1878(ra) # 80000e7c <myproc>
    800015da:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015dc:	0000b517          	auipc	a0,0xb
    800015e0:	a8c50513          	addi	a0,a0,-1396 # 8000c068 <wait_lock>
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	d22080e7          	jalr	-734(ra) # 80006306 <acquire>
    havekids = 0;
    800015ec:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ee:	4a15                	li	s4,5
        havekids = 1;
    800015f0:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	00015997          	auipc	s3,0x15
    800015f6:	68e98993          	addi	s3,s3,1678 # 80016c80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fa:	0000bc17          	auipc	s8,0xb
    800015fe:	a6ec0c13          	addi	s8,s8,-1426 # 8000c068 <wait_lock>
    80001602:	a87d                	j	800016c0 <wait+0x108>
          pid = np->pid;
    80001604:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001608:	000b0e63          	beqz	s6,80001624 <wait+0x6c>
    8000160c:	4691                	li	a3,4
    8000160e:	02c48613          	addi	a2,s1,44
    80001612:	85da                	mv	a1,s6
    80001614:	05093503          	ld	a0,80(s2)
    80001618:	fffff097          	auipc	ra,0xfffff
    8000161c:	500080e7          	jalr	1280(ra) # 80000b18 <copyout>
    80001620:	04054163          	bltz	a0,80001662 <wait+0xaa>
          freeproc(np);
    80001624:	8526                	mv	a0,s1
    80001626:	00000097          	auipc	ra,0x0
    8000162a:	a08080e7          	jalr	-1528(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000162e:	8526                	mv	a0,s1
    80001630:	00005097          	auipc	ra,0x5
    80001634:	d8a080e7          	jalr	-630(ra) # 800063ba <release>
          release(&wait_lock);
    80001638:	0000b517          	auipc	a0,0xb
    8000163c:	a3050513          	addi	a0,a0,-1488 # 8000c068 <wait_lock>
    80001640:	00005097          	auipc	ra,0x5
    80001644:	d7a080e7          	jalr	-646(ra) # 800063ba <release>
}
    80001648:	854e                	mv	a0,s3
    8000164a:	60a6                	ld	ra,72(sp)
    8000164c:	6406                	ld	s0,64(sp)
    8000164e:	74e2                	ld	s1,56(sp)
    80001650:	7942                	ld	s2,48(sp)
    80001652:	79a2                	ld	s3,40(sp)
    80001654:	7a02                	ld	s4,32(sp)
    80001656:	6ae2                	ld	s5,24(sp)
    80001658:	6b42                	ld	s6,16(sp)
    8000165a:	6ba2                	ld	s7,8(sp)
    8000165c:	6c02                	ld	s8,0(sp)
    8000165e:	6161                	addi	sp,sp,80
    80001660:	8082                	ret
            release(&np->lock);
    80001662:	8526                	mv	a0,s1
    80001664:	00005097          	auipc	ra,0x5
    80001668:	d56080e7          	jalr	-682(ra) # 800063ba <release>
            release(&wait_lock);
    8000166c:	0000b517          	auipc	a0,0xb
    80001670:	9fc50513          	addi	a0,a0,-1540 # 8000c068 <wait_lock>
    80001674:	00005097          	auipc	ra,0x5
    80001678:	d46080e7          	jalr	-698(ra) # 800063ba <release>
            return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	b7e9                	j	80001648 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001680:	2a048493          	addi	s1,s1,672
    80001684:	03348463          	beq	s1,s3,800016ac <wait+0xf4>
      if(np->parent == p){
    80001688:	7c9c                	ld	a5,56(s1)
    8000168a:	ff279be3          	bne	a5,s2,80001680 <wait+0xc8>
        acquire(&np->lock);
    8000168e:	8526                	mv	a0,s1
    80001690:	00005097          	auipc	ra,0x5
    80001694:	c76080e7          	jalr	-906(ra) # 80006306 <acquire>
        if(np->state == ZOMBIE){
    80001698:	4c9c                	lw	a5,24(s1)
    8000169a:	f74785e3          	beq	a5,s4,80001604 <wait+0x4c>
        release(&np->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	d1a080e7          	jalr	-742(ra) # 800063ba <release>
        havekids = 1;
    800016a8:	8756                	mv	a4,s5
    800016aa:	bfd9                	j	80001680 <wait+0xc8>
    if(!havekids || p->killed){
    800016ac:	c305                	beqz	a4,800016cc <wait+0x114>
    800016ae:	02892783          	lw	a5,40(s2)
    800016b2:	ef89                	bnez	a5,800016cc <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b4:	85e2                	mv	a1,s8
    800016b6:	854a                	mv	a0,s2
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	e9c080e7          	jalr	-356(ra) # 80001554 <sleep>
    havekids = 0;
    800016c0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016c2:	0000b497          	auipc	s1,0xb
    800016c6:	dbe48493          	addi	s1,s1,-578 # 8000c480 <proc>
    800016ca:	bf7d                	j	80001688 <wait+0xd0>
      release(&wait_lock);
    800016cc:	0000b517          	auipc	a0,0xb
    800016d0:	99c50513          	addi	a0,a0,-1636 # 8000c068 <wait_lock>
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	ce6080e7          	jalr	-794(ra) # 800063ba <release>
      return -1;
    800016dc:	59fd                	li	s3,-1
    800016de:	b7ad                	j	80001648 <wait+0x90>

00000000800016e0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e0:	7139                	addi	sp,sp,-64
    800016e2:	fc06                	sd	ra,56(sp)
    800016e4:	f822                	sd	s0,48(sp)
    800016e6:	f426                	sd	s1,40(sp)
    800016e8:	f04a                	sd	s2,32(sp)
    800016ea:	ec4e                	sd	s3,24(sp)
    800016ec:	e852                	sd	s4,16(sp)
    800016ee:	e456                	sd	s5,8(sp)
    800016f0:	0080                	addi	s0,sp,64
    800016f2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	0000b497          	auipc	s1,0xb
    800016f8:	d8c48493          	addi	s1,s1,-628 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016fe:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001700:	00015917          	auipc	s2,0x15
    80001704:	58090913          	addi	s2,s2,1408 # 80016c80 <tickslock>
    80001708:	a811                	j	8000171c <wakeup+0x3c>
      }
      release(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	cae080e7          	jalr	-850(ra) # 800063ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001714:	2a048493          	addi	s1,s1,672
    80001718:	03248663          	beq	s1,s2,80001744 <wakeup+0x64>
    if(p != myproc()){
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	760080e7          	jalr	1888(ra) # 80000e7c <myproc>
    80001724:	fea488e3          	beq	s1,a0,80001714 <wakeup+0x34>
      acquire(&p->lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	bdc080e7          	jalr	-1060(ra) # 80006306 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001732:	4c9c                	lw	a5,24(s1)
    80001734:	fd379be3          	bne	a5,s3,8000170a <wakeup+0x2a>
    80001738:	709c                	ld	a5,32(s1)
    8000173a:	fd4798e3          	bne	a5,s4,8000170a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000173e:	0154ac23          	sw	s5,24(s1)
    80001742:	b7e1                	j	8000170a <wakeup+0x2a>
    }
  }
}
    80001744:	70e2                	ld	ra,56(sp)
    80001746:	7442                	ld	s0,48(sp)
    80001748:	74a2                	ld	s1,40(sp)
    8000174a:	7902                	ld	s2,32(sp)
    8000174c:	69e2                	ld	s3,24(sp)
    8000174e:	6a42                	ld	s4,16(sp)
    80001750:	6aa2                	ld	s5,8(sp)
    80001752:	6121                	addi	sp,sp,64
    80001754:	8082                	ret

0000000080001756 <reparent>:
{
    80001756:	7179                	addi	sp,sp,-48
    80001758:	f406                	sd	ra,40(sp)
    8000175a:	f022                	sd	s0,32(sp)
    8000175c:	ec26                	sd	s1,24(sp)
    8000175e:	e84a                	sd	s2,16(sp)
    80001760:	e44e                	sd	s3,8(sp)
    80001762:	e052                	sd	s4,0(sp)
    80001764:	1800                	addi	s0,sp,48
    80001766:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001768:	0000b497          	auipc	s1,0xb
    8000176c:	d1848493          	addi	s1,s1,-744 # 8000c480 <proc>
      pp->parent = initproc;
    80001770:	0000ba17          	auipc	s4,0xb
    80001774:	8a0a0a13          	addi	s4,s4,-1888 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001778:	00015997          	auipc	s3,0x15
    8000177c:	50898993          	addi	s3,s3,1288 # 80016c80 <tickslock>
    80001780:	a029                	j	8000178a <reparent+0x34>
    80001782:	2a048493          	addi	s1,s1,672
    80001786:	01348d63          	beq	s1,s3,800017a0 <reparent+0x4a>
    if(pp->parent == p){
    8000178a:	7c9c                	ld	a5,56(s1)
    8000178c:	ff279be3          	bne	a5,s2,80001782 <reparent+0x2c>
      pp->parent = initproc;
    80001790:	000a3503          	ld	a0,0(s4)
    80001794:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	f4a080e7          	jalr	-182(ra) # 800016e0 <wakeup>
    8000179e:	b7d5                	j	80001782 <reparent+0x2c>
}
    800017a0:	70a2                	ld	ra,40(sp)
    800017a2:	7402                	ld	s0,32(sp)
    800017a4:	64e2                	ld	s1,24(sp)
    800017a6:	6942                	ld	s2,16(sp)
    800017a8:	69a2                	ld	s3,8(sp)
    800017aa:	6a02                	ld	s4,0(sp)
    800017ac:	6145                	addi	sp,sp,48
    800017ae:	8082                	ret

00000000800017b0 <exit>:
{
    800017b0:	7179                	addi	sp,sp,-48
    800017b2:	f406                	sd	ra,40(sp)
    800017b4:	f022                	sd	s0,32(sp)
    800017b6:	ec26                	sd	s1,24(sp)
    800017b8:	e84a                	sd	s2,16(sp)
    800017ba:	e44e                	sd	s3,8(sp)
    800017bc:	e052                	sd	s4,0(sp)
    800017be:	1800                	addi	s0,sp,48
    800017c0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c2:	fffff097          	auipc	ra,0xfffff
    800017c6:	6ba080e7          	jalr	1722(ra) # 80000e7c <myproc>
    800017ca:	89aa                	mv	s3,a0
  if(p == initproc)
    800017cc:	0000b797          	auipc	a5,0xb
    800017d0:	8447b783          	ld	a5,-1980(a5) # 8000c010 <initproc>
    800017d4:	0d050493          	addi	s1,a0,208
    800017d8:	15050913          	addi	s2,a0,336
    800017dc:	02a79363          	bne	a5,a0,80001802 <exit+0x52>
    panic("init exiting");
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	a0050513          	addi	a0,a0,-1536 # 800081e0 <etext+0x1e0>
    800017e8:	00004097          	auipc	ra,0x4
    800017ec:	5ce080e7          	jalr	1486(ra) # 80005db6 <panic>
      fileclose(f);
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	246080e7          	jalr	582(ra) # 80003a36 <fileclose>
      p->ofile[fd] = 0;
    800017f8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fc:	04a1                	addi	s1,s1,8
    800017fe:	01248563          	beq	s1,s2,80001808 <exit+0x58>
    if(p->ofile[fd]){
    80001802:	6088                	ld	a0,0(s1)
    80001804:	f575                	bnez	a0,800017f0 <exit+0x40>
    80001806:	bfdd                	j	800017fc <exit+0x4c>
  begin_op();
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	d64080e7          	jalr	-668(ra) # 8000356c <begin_op>
  iput(p->cwd);
    80001810:	1509b503          	ld	a0,336(s3)
    80001814:	00001097          	auipc	ra,0x1
    80001818:	544080e7          	jalr	1348(ra) # 80002d58 <iput>
  end_op();
    8000181c:	00002097          	auipc	ra,0x2
    80001820:	dca080e7          	jalr	-566(ra) # 800035e6 <end_op>
  p->cwd = 0;
    80001824:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001828:	0000b497          	auipc	s1,0xb
    8000182c:	84048493          	addi	s1,s1,-1984 # 8000c068 <wait_lock>
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	ad4080e7          	jalr	-1324(ra) # 80006306 <acquire>
  reparent(p);
    8000183a:	854e                	mv	a0,s3
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	f1a080e7          	jalr	-230(ra) # 80001756 <reparent>
  wakeup(p->parent);
    80001844:	0389b503          	ld	a0,56(s3)
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	e98080e7          	jalr	-360(ra) # 800016e0 <wakeup>
  acquire(&p->lock);
    80001850:	854e                	mv	a0,s3
    80001852:	00005097          	auipc	ra,0x5
    80001856:	ab4080e7          	jalr	-1356(ra) # 80006306 <acquire>
  p->xstate = status;
    8000185a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000185e:	4795                	li	a5,5
    80001860:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	b54080e7          	jalr	-1196(ra) # 800063ba <release>
  sched();
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	bd4080e7          	jalr	-1068(ra) # 80001442 <sched>
  panic("zombie exit");
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	97a50513          	addi	a0,a0,-1670 # 800081f0 <etext+0x1f0>
    8000187e:	00004097          	auipc	ra,0x4
    80001882:	538080e7          	jalr	1336(ra) # 80005db6 <panic>

0000000080001886 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001886:	7179                	addi	sp,sp,-48
    80001888:	f406                	sd	ra,40(sp)
    8000188a:	f022                	sd	s0,32(sp)
    8000188c:	ec26                	sd	s1,24(sp)
    8000188e:	e84a                	sd	s2,16(sp)
    80001890:	e44e                	sd	s3,8(sp)
    80001892:	1800                	addi	s0,sp,48
    80001894:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001896:	0000b497          	auipc	s1,0xb
    8000189a:	bea48493          	addi	s1,s1,-1046 # 8000c480 <proc>
    8000189e:	00015997          	auipc	s3,0x15
    800018a2:	3e298993          	addi	s3,s3,994 # 80016c80 <tickslock>
    acquire(&p->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	a5e080e7          	jalr	-1442(ra) # 80006306 <acquire>
    if(p->pid == pid){
    800018b0:	589c                	lw	a5,48(s1)
    800018b2:	01278d63          	beq	a5,s2,800018cc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	b02080e7          	jalr	-1278(ra) # 800063ba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c0:	2a048493          	addi	s1,s1,672
    800018c4:	ff3491e3          	bne	s1,s3,800018a6 <kill+0x20>
  }
  return -1;
    800018c8:	557d                	li	a0,-1
    800018ca:	a829                	j	800018e4 <kill+0x5e>
      p->killed = 1;
    800018cc:	4785                	li	a5,1
    800018ce:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d0:	4c98                	lw	a4,24(s1)
    800018d2:	4789                	li	a5,2
    800018d4:	00f70f63          	beq	a4,a5,800018f2 <kill+0x6c>
      release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	ae0080e7          	jalr	-1312(ra) # 800063ba <release>
      return 0;
    800018e2:	4501                	li	a0,0
}
    800018e4:	70a2                	ld	ra,40(sp)
    800018e6:	7402                	ld	s0,32(sp)
    800018e8:	64e2                	ld	s1,24(sp)
    800018ea:	6942                	ld	s2,16(sp)
    800018ec:	69a2                	ld	s3,8(sp)
    800018ee:	6145                	addi	sp,sp,48
    800018f0:	8082                	ret
        p->state = RUNNABLE;
    800018f2:	478d                	li	a5,3
    800018f4:	cc9c                	sw	a5,24(s1)
    800018f6:	b7cd                	j	800018d8 <kill+0x52>

00000000800018f8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018f8:	7179                	addi	sp,sp,-48
    800018fa:	f406                	sd	ra,40(sp)
    800018fc:	f022                	sd	s0,32(sp)
    800018fe:	ec26                	sd	s1,24(sp)
    80001900:	e84a                	sd	s2,16(sp)
    80001902:	e44e                	sd	s3,8(sp)
    80001904:	e052                	sd	s4,0(sp)
    80001906:	1800                	addi	s0,sp,48
    80001908:	84aa                	mv	s1,a0
    8000190a:	892e                	mv	s2,a1
    8000190c:	89b2                	mv	s3,a2
    8000190e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	56c080e7          	jalr	1388(ra) # 80000e7c <myproc>
  if(user_dst){
    80001918:	c08d                	beqz	s1,8000193a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191a:	86d2                	mv	a3,s4
    8000191c:	864e                	mv	a2,s3
    8000191e:	85ca                	mv	a1,s2
    80001920:	6928                	ld	a0,80(a0)
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	1f6080e7          	jalr	502(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192a:	70a2                	ld	ra,40(sp)
    8000192c:	7402                	ld	s0,32(sp)
    8000192e:	64e2                	ld	s1,24(sp)
    80001930:	6942                	ld	s2,16(sp)
    80001932:	69a2                	ld	s3,8(sp)
    80001934:	6a02                	ld	s4,0(sp)
    80001936:	6145                	addi	sp,sp,48
    80001938:	8082                	ret
    memmove((char *)dst, src, len);
    8000193a:	000a061b          	sext.w	a2,s4
    8000193e:	85ce                	mv	a1,s3
    80001940:	854a                	mv	a0,s2
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	894080e7          	jalr	-1900(ra) # 800001d6 <memmove>
    return 0;
    8000194a:	8526                	mv	a0,s1
    8000194c:	bff9                	j	8000192a <either_copyout+0x32>

000000008000194e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	e052                	sd	s4,0(sp)
    8000195c:	1800                	addi	s0,sp,48
    8000195e:	892a                	mv	s2,a0
    80001960:	84ae                	mv	s1,a1
    80001962:	89b2                	mv	s3,a2
    80001964:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	516080e7          	jalr	1302(ra) # 80000e7c <myproc>
  if(user_src){
    8000196e:	c08d                	beqz	s1,80001990 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001970:	86d2                	mv	a3,s4
    80001972:	864e                	mv	a2,s3
    80001974:	85ca                	mv	a1,s2
    80001976:	6928                	ld	a0,80(a0)
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	22c080e7          	jalr	556(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6942                	ld	s2,16(sp)
    80001988:	69a2                	ld	s3,8(sp)
    8000198a:	6a02                	ld	s4,0(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001990:	000a061b          	sext.w	a2,s4
    80001994:	85ce                	mv	a1,s3
    80001996:	854a                	mv	a0,s2
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	83e080e7          	jalr	-1986(ra) # 800001d6 <memmove>
    return 0;
    800019a0:	8526                	mv	a0,s1
    800019a2:	bff9                	j	80001980 <either_copyin+0x32>

00000000800019a4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a4:	715d                	addi	sp,sp,-80
    800019a6:	e486                	sd	ra,72(sp)
    800019a8:	e0a2                	sd	s0,64(sp)
    800019aa:	fc26                	sd	s1,56(sp)
    800019ac:	f84a                	sd	s2,48(sp)
    800019ae:	f44e                	sd	s3,40(sp)
    800019b0:	f052                	sd	s4,32(sp)
    800019b2:	ec56                	sd	s5,24(sp)
    800019b4:	e85a                	sd	s6,16(sp)
    800019b6:	e45e                	sd	s7,8(sp)
    800019b8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ba:	00006517          	auipc	a0,0x6
    800019be:	65e50513          	addi	a0,a0,1630 # 80008018 <etext+0x18>
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	446080e7          	jalr	1094(ra) # 80005e08 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	0000b497          	auipc	s1,0xb
    800019ce:	c0e48493          	addi	s1,s1,-1010 # 8000c5d8 <proc+0x158>
    800019d2:	00015917          	auipc	s2,0x15
    800019d6:	40690913          	addi	s2,s2,1030 # 80016dd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019da:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019dc:	00007997          	auipc	s3,0x7
    800019e0:	82498993          	addi	s3,s3,-2012 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e4:	00007a97          	auipc	s5,0x7
    800019e8:	824a8a93          	addi	s5,s5,-2012 # 80008208 <etext+0x208>
    printf("\n");
    800019ec:	00006a17          	auipc	s4,0x6
    800019f0:	62ca0a13          	addi	s4,s4,1580 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f4:	00007b97          	auipc	s7,0x7
    800019f8:	d24b8b93          	addi	s7,s7,-732 # 80008718 <states.0>
    800019fc:	a00d                	j	80001a1e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019fe:	ed86a583          	lw	a1,-296(a3)
    80001a02:	8556                	mv	a0,s5
    80001a04:	00004097          	auipc	ra,0x4
    80001a08:	404080e7          	jalr	1028(ra) # 80005e08 <printf>
    printf("\n");
    80001a0c:	8552                	mv	a0,s4
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	3fa080e7          	jalr	1018(ra) # 80005e08 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a16:	2a048493          	addi	s1,s1,672
    80001a1a:	03248263          	beq	s1,s2,80001a3e <procdump+0x9a>
    if(p->state == UNUSED)
    80001a1e:	86a6                	mv	a3,s1
    80001a20:	ec04a783          	lw	a5,-320(s1)
    80001a24:	dbed                	beqz	a5,80001a16 <procdump+0x72>
      state = "???";
    80001a26:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a28:	fcfb6be3          	bltu	s6,a5,800019fe <procdump+0x5a>
    80001a2c:	02079713          	slli	a4,a5,0x20
    80001a30:	01d75793          	srli	a5,a4,0x1d
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f279                	bnez	a2,800019fe <procdump+0x5a>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7c9                	j	800019fe <procdump+0x5a>
  }
}
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <swtch>:
    80001a54:	00153023          	sd	ra,0(a0)
    80001a58:	00253423          	sd	sp,8(a0)
    80001a5c:	e900                	sd	s0,16(a0)
    80001a5e:	ed04                	sd	s1,24(a0)
    80001a60:	03253023          	sd	s2,32(a0)
    80001a64:	03353423          	sd	s3,40(a0)
    80001a68:	03453823          	sd	s4,48(a0)
    80001a6c:	03553c23          	sd	s5,56(a0)
    80001a70:	05653023          	sd	s6,64(a0)
    80001a74:	05753423          	sd	s7,72(a0)
    80001a78:	05853823          	sd	s8,80(a0)
    80001a7c:	05953c23          	sd	s9,88(a0)
    80001a80:	07a53023          	sd	s10,96(a0)
    80001a84:	07b53423          	sd	s11,104(a0)
    80001a88:	0005b083          	ld	ra,0(a1)
    80001a8c:	0085b103          	ld	sp,8(a1)
    80001a90:	6980                	ld	s0,16(a1)
    80001a92:	6d84                	ld	s1,24(a1)
    80001a94:	0205b903          	ld	s2,32(a1)
    80001a98:	0285b983          	ld	s3,40(a1)
    80001a9c:	0305ba03          	ld	s4,48(a1)
    80001aa0:	0385ba83          	ld	s5,56(a1)
    80001aa4:	0405bb03          	ld	s6,64(a1)
    80001aa8:	0485bb83          	ld	s7,72(a1)
    80001aac:	0505bc03          	ld	s8,80(a1)
    80001ab0:	0585bc83          	ld	s9,88(a1)
    80001ab4:	0605bd03          	ld	s10,96(a1)
    80001ab8:	0685bd83          	ld	s11,104(a1)
    80001abc:	8082                	ret

0000000080001abe <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001abe:	1141                	addi	sp,sp,-16
    80001ac0:	e406                	sd	ra,8(sp)
    80001ac2:	e022                	sd	s0,0(sp)
    80001ac4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ac6:	00006597          	auipc	a1,0x6
    80001aca:	77a58593          	addi	a1,a1,1914 # 80008240 <etext+0x240>
    80001ace:	00015517          	auipc	a0,0x15
    80001ad2:	1b250513          	addi	a0,a0,434 # 80016c80 <tickslock>
    80001ad6:	00004097          	auipc	ra,0x4
    80001ada:	7a0080e7          	jalr	1952(ra) # 80006276 <initlock>
}
    80001ade:	60a2                	ld	ra,8(sp)
    80001ae0:	6402                	ld	s0,0(sp)
    80001ae2:	0141                	addi	sp,sp,16
    80001ae4:	8082                	ret

0000000080001ae6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e422                	sd	s0,8(sp)
    80001aea:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aec:	00003797          	auipc	a5,0x3
    80001af0:	63478793          	addi	a5,a5,1588 # 80005120 <kernelvec>
    80001af4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001af8:	6422                	ld	s0,8(sp)
    80001afa:	0141                	addi	sp,sp,16
    80001afc:	8082                	ret

0000000080001afe <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001afe:	1141                	addi	sp,sp,-16
    80001b00:	e406                	sd	ra,8(sp)
    80001b02:	e022                	sd	s0,0(sp)
    80001b04:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	376080e7          	jalr	886(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b12:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b14:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b18:	00005697          	auipc	a3,0x5
    80001b1c:	4e868693          	addi	a3,a3,1256 # 80007000 <_trampoline>
    80001b20:	00005717          	auipc	a4,0x5
    80001b24:	4e070713          	addi	a4,a4,1248 # 80007000 <_trampoline>
    80001b28:	8f15                	sub	a4,a4,a3
    80001b2a:	040007b7          	lui	a5,0x4000
    80001b2e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b30:	07b2                	slli	a5,a5,0xc
    80001b32:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b34:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b38:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b3a:	18002673          	csrr	a2,satp
    80001b3e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b40:	6d30                	ld	a2,88(a0)
    80001b42:	6138                	ld	a4,64(a0)
    80001b44:	6585                	lui	a1,0x1
    80001b46:	972e                	add	a4,a4,a1
    80001b48:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b4a:	6d38                	ld	a4,88(a0)
    80001b4c:	00000617          	auipc	a2,0x0
    80001b50:	14060613          	addi	a2,a2,320 # 80001c8c <usertrap>
    80001b54:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b56:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b58:	8612                	mv	a2,tp
    80001b5a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b60:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b64:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b68:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b6c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b6e:	6f18                	ld	a4,24(a4)
    80001b70:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b74:	692c                	ld	a1,80(a0)
    80001b76:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b78:	00005717          	auipc	a4,0x5
    80001b7c:	51870713          	addi	a4,a4,1304 # 80007090 <userret>
    80001b80:	8f15                	sub	a4,a4,a3
    80001b82:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b84:	577d                	li	a4,-1
    80001b86:	177e                	slli	a4,a4,0x3f
    80001b88:	8dd9                	or	a1,a1,a4
    80001b8a:	02000537          	lui	a0,0x2000
    80001b8e:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b90:	0536                	slli	a0,a0,0xd
    80001b92:	9782                	jalr	a5
}
    80001b94:	60a2                	ld	ra,8(sp)
    80001b96:	6402                	ld	s0,0(sp)
    80001b98:	0141                	addi	sp,sp,16
    80001b9a:	8082                	ret

0000000080001b9c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba6:	00015497          	auipc	s1,0x15
    80001baa:	0da48493          	addi	s1,s1,218 # 80016c80 <tickslock>
    80001bae:	8526                	mv	a0,s1
    80001bb0:	00004097          	auipc	ra,0x4
    80001bb4:	756080e7          	jalr	1878(ra) # 80006306 <acquire>
  ticks++;
    80001bb8:	0000a517          	auipc	a0,0xa
    80001bbc:	46050513          	addi	a0,a0,1120 # 8000c018 <ticks>
    80001bc0:	411c                	lw	a5,0(a0)
    80001bc2:	2785                	addiw	a5,a5,1
    80001bc4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc6:	00000097          	auipc	ra,0x0
    80001bca:	b1a080e7          	jalr	-1254(ra) # 800016e0 <wakeup>
  release(&tickslock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	00004097          	auipc	ra,0x4
    80001bd4:	7ea080e7          	jalr	2026(ra) # 800063ba <release>
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6105                	addi	sp,sp,32
    80001be0:	8082                	ret

0000000080001be2 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be2:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be6:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001be8:	0a07d163          	bgez	a5,80001c8a <devintr+0xa8>
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bf4:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bf8:	46a5                	li	a3,9
    80001bfa:	00d70c63          	beq	a4,a3,80001c12 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001bfe:	577d                	li	a4,-1
    80001c00:	177e                	slli	a4,a4,0x3f
    80001c02:	0705                	addi	a4,a4,1
    return 0;
    80001c04:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c06:	06e78163          	beq	a5,a4,80001c68 <devintr+0x86>
  }
}
    80001c0a:	60e2                	ld	ra,24(sp)
    80001c0c:	6442                	ld	s0,16(sp)
    80001c0e:	6105                	addi	sp,sp,32
    80001c10:	8082                	ret
    80001c12:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c14:	00003097          	auipc	ra,0x3
    80001c18:	618080e7          	jalr	1560(ra) # 8000522c <plic_claim>
    80001c1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1e:	47a9                	li	a5,10
    80001c20:	00f50963          	beq	a0,a5,80001c32 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c24:	4785                	li	a5,1
    80001c26:	00f50b63          	beq	a0,a5,80001c3c <devintr+0x5a>
    return 1;
    80001c2a:	4505                	li	a0,1
    } else if(irq){
    80001c2c:	ec89                	bnez	s1,80001c46 <devintr+0x64>
    80001c2e:	64a2                	ld	s1,8(sp)
    80001c30:	bfe9                	j	80001c0a <devintr+0x28>
      uartintr();
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	5f4080e7          	jalr	1524(ra) # 80006226 <uartintr>
    if(irq)
    80001c3a:	a839                	j	80001c58 <devintr+0x76>
      virtio_disk_intr();
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	ac4080e7          	jalr	-1340(ra) # 80005700 <virtio_disk_intr>
    if(irq)
    80001c44:	a811                	j	80001c58 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c46:	85a6                	mv	a1,s1
    80001c48:	00006517          	auipc	a0,0x6
    80001c4c:	60050513          	addi	a0,a0,1536 # 80008248 <etext+0x248>
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	1b8080e7          	jalr	440(ra) # 80005e08 <printf>
      plic_complete(irq);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	00003097          	auipc	ra,0x3
    80001c5e:	5f6080e7          	jalr	1526(ra) # 80005250 <plic_complete>
    return 1;
    80001c62:	4505                	li	a0,1
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	b755                	j	80001c0a <devintr+0x28>
    if(cpuid() == 0){
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	1e8080e7          	jalr	488(ra) # 80000e50 <cpuid>
    80001c70:	c901                	beqz	a0,80001c80 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c72:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c78:	14479073          	csrw	sip,a5
    return 2;
    80001c7c:	4509                	li	a0,2
    80001c7e:	b771                	j	80001c0a <devintr+0x28>
      clockintr();
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	f1c080e7          	jalr	-228(ra) # 80001b9c <clockintr>
    80001c88:	b7ed                	j	80001c72 <devintr+0x90>
}
    80001c8a:	8082                	ret

0000000080001c8c <usertrap>:
{
    80001c8c:	1101                	addi	sp,sp,-32
    80001c8e:	ec06                	sd	ra,24(sp)
    80001c90:	e822                	sd	s0,16(sp)
    80001c92:	e426                	sd	s1,8(sp)
    80001c94:	e04a                	sd	s2,0(sp)
    80001c96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c98:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c9c:	1007f793          	andi	a5,a5,256
    80001ca0:	e3ad                	bnez	a5,80001d02 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca2:	00003797          	auipc	a5,0x3
    80001ca6:	47e78793          	addi	a5,a5,1150 # 80005120 <kernelvec>
    80001caa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	1ce080e7          	jalr	462(ra) # 80000e7c <myproc>
    80001cb6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cba:	14102773          	csrr	a4,sepc
    80001cbe:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc4:	47a1                	li	a5,8
    80001cc6:	04f71c63          	bne	a4,a5,80001d1e <usertrap+0x92>
    if(p->killed)
    80001cca:	551c                	lw	a5,40(a0)
    80001ccc:	e3b9                	bnez	a5,80001d12 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cce:	6cb8                	ld	a4,88(s1)
    80001cd0:	6f1c                	ld	a5,24(a4)
    80001cd2:	0791                	addi	a5,a5,4
    80001cd4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cda:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cde:	10079073          	csrw	sstatus,a5
    syscall();
    80001ce2:	00000097          	auipc	ra,0x0
    80001ce6:	322080e7          	jalr	802(ra) # 80002004 <syscall>
  if(p->killed)
    80001cea:	549c                	lw	a5,40(s1)
    80001cec:	e7c5                	bnez	a5,80001d94 <usertrap+0x108>
  usertrapret();
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	e10080e7          	jalr	-496(ra) # 80001afe <usertrapret>
}
    80001cf6:	60e2                	ld	ra,24(sp)
    80001cf8:	6442                	ld	s0,16(sp)
    80001cfa:	64a2                	ld	s1,8(sp)
    80001cfc:	6902                	ld	s2,0(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret
    panic("usertrap: not from user mode");
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	56650513          	addi	a0,a0,1382 # 80008268 <etext+0x268>
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	0ac080e7          	jalr	172(ra) # 80005db6 <panic>
      exit(-1);
    80001d12:	557d                	li	a0,-1
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a9c080e7          	jalr	-1380(ra) # 800017b0 <exit>
    80001d1c:	bf4d                	j	80001cce <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	ec4080e7          	jalr	-316(ra) # 80001be2 <devintr>
    80001d26:	892a                	mv	s2,a0
    80001d28:	c501                	beqz	a0,80001d30 <usertrap+0xa4>
  if(p->killed)
    80001d2a:	549c                	lw	a5,40(s1)
    80001d2c:	c3a1                	beqz	a5,80001d6c <usertrap+0xe0>
    80001d2e:	a815                	j	80001d62 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d30:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d34:	5890                	lw	a2,48(s1)
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	55250513          	addi	a0,a0,1362 # 80008288 <etext+0x288>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	0ca080e7          	jalr	202(ra) # 80005e08 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d46:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d4a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d4e:	00006517          	auipc	a0,0x6
    80001d52:	56a50513          	addi	a0,a0,1386 # 800082b8 <etext+0x2b8>
    80001d56:	00004097          	auipc	ra,0x4
    80001d5a:	0b2080e7          	jalr	178(ra) # 80005e08 <printf>
    p->killed = 1;
    80001d5e:	4785                	li	a5,1
    80001d60:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d62:	557d                	li	a0,-1
    80001d64:	00000097          	auipc	ra,0x0
    80001d68:	a4c080e7          	jalr	-1460(ra) # 800017b0 <exit>
  if(which_dev == 2){
    80001d6c:	4789                	li	a5,2
    80001d6e:	f8f910e3          	bne	s2,a5,80001cee <usertrap+0x62>
    if(p->alarm_interval){
    80001d72:	1684a783          	lw	a5,360(s1)
    80001d76:	cb91                	beqz	a5,80001d8a <usertrap+0xfe>
      if(++p->alarm_ticks == p->alarm_interval && p->handler_exec==1){
    80001d78:	16c4a703          	lw	a4,364(s1)
    80001d7c:	2705                	addiw	a4,a4,1
    80001d7e:	0007069b          	sext.w	a3,a4
    80001d82:	16e4a623          	sw	a4,364(s1)
    80001d86:	00d78963          	beq	a5,a3,80001d98 <usertrap+0x10c>
    yield();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	78e080e7          	jalr	1934(ra) # 80001518 <yield>
    80001d92:	bfb1                	j	80001cee <usertrap+0x62>
  int which_dev = 0;
    80001d94:	4901                	li	s2,0
    80001d96:	b7f1                	j	80001d62 <usertrap+0xd6>
      if(++p->alarm_ticks == p->alarm_interval && p->handler_exec==1){
    80001d98:	1784a703          	lw	a4,376(s1)
    80001d9c:	4785                	li	a5,1
    80001d9e:	fef716e3          	bne	a4,a5,80001d8a <usertrap+0xfe>
        memmove(&(p->alarm_trapframe), p->trapframe, sizeof(*(p->trapframe)));
    80001da2:	12000613          	li	a2,288
    80001da6:	6cac                	ld	a1,88(s1)
    80001da8:	18048513          	addi	a0,s1,384
    80001dac:	ffffe097          	auipc	ra,0xffffe
    80001db0:	42a080e7          	jalr	1066(ra) # 800001d6 <memmove>
        p->trapframe->epc = p->alarm_handler;
    80001db4:	6cbc                	ld	a5,88(s1)
    80001db6:	1704b703          	ld	a4,368(s1)
    80001dba:	ef98                	sd	a4,24(a5)
        p->handler_exec = 0;
    80001dbc:	1604ac23          	sw	zero,376(s1)
    80001dc0:	b7e9                	j	80001d8a <usertrap+0xfe>

0000000080001dc2 <kerneltrap>:
{
    80001dc2:	7179                	addi	sp,sp,-48
    80001dc4:	f406                	sd	ra,40(sp)
    80001dc6:	f022                	sd	s0,32(sp)
    80001dc8:	ec26                	sd	s1,24(sp)
    80001dca:	e84a                	sd	s2,16(sp)
    80001dcc:	e44e                	sd	s3,8(sp)
    80001dce:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dd8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ddc:	1004f793          	andi	a5,s1,256
    80001de0:	cb85                	beqz	a5,80001e10 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001de6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001de8:	ef85                	bnez	a5,80001e20 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	df8080e7          	jalr	-520(ra) # 80001be2 <devintr>
    80001df2:	cd1d                	beqz	a0,80001e30 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001df4:	4789                	li	a5,2
    80001df6:	06f50a63          	beq	a0,a5,80001e6a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dfa:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dfe:	10049073          	csrw	sstatus,s1
}
    80001e02:	70a2                	ld	ra,40(sp)
    80001e04:	7402                	ld	s0,32(sp)
    80001e06:	64e2                	ld	s1,24(sp)
    80001e08:	6942                	ld	s2,16(sp)
    80001e0a:	69a2                	ld	s3,8(sp)
    80001e0c:	6145                	addi	sp,sp,48
    80001e0e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e10:	00006517          	auipc	a0,0x6
    80001e14:	4c850513          	addi	a0,a0,1224 # 800082d8 <etext+0x2d8>
    80001e18:	00004097          	auipc	ra,0x4
    80001e1c:	f9e080e7          	jalr	-98(ra) # 80005db6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	4e050513          	addi	a0,a0,1248 # 80008300 <etext+0x300>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	f8e080e7          	jalr	-114(ra) # 80005db6 <panic>
    printf("scause %p\n", scause);
    80001e30:	85ce                	mv	a1,s3
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	4ee50513          	addi	a0,a0,1262 # 80008320 <etext+0x320>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	fce080e7          	jalr	-50(ra) # 80005e08 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e42:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e46:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	4e650513          	addi	a0,a0,1254 # 80008330 <etext+0x330>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	fb6080e7          	jalr	-74(ra) # 80005e08 <printf>
    panic("kerneltrap");
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	4ee50513          	addi	a0,a0,1262 # 80008348 <etext+0x348>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	f54080e7          	jalr	-172(ra) # 80005db6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	012080e7          	jalr	18(ra) # 80000e7c <myproc>
    80001e72:	d541                	beqz	a0,80001dfa <kerneltrap+0x38>
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	008080e7          	jalr	8(ra) # 80000e7c <myproc>
    80001e7c:	4d18                	lw	a4,24(a0)
    80001e7e:	4791                	li	a5,4
    80001e80:	f6f71de3          	bne	a4,a5,80001dfa <kerneltrap+0x38>
    yield();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	694080e7          	jalr	1684(ra) # 80001518 <yield>
    80001e8c:	b7bd                	j	80001dfa <kerneltrap+0x38>

0000000080001e8e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e8e:	1101                	addi	sp,sp,-32
    80001e90:	ec06                	sd	ra,24(sp)
    80001e92:	e822                	sd	s0,16(sp)
    80001e94:	e426                	sd	s1,8(sp)
    80001e96:	1000                	addi	s0,sp,32
    80001e98:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	fe2080e7          	jalr	-30(ra) # 80000e7c <myproc>
  switch (n) {
    80001ea2:	4795                	li	a5,5
    80001ea4:	0497e163          	bltu	a5,s1,80001ee6 <argraw+0x58>
    80001ea8:	048a                	slli	s1,s1,0x2
    80001eaa:	00007717          	auipc	a4,0x7
    80001eae:	89e70713          	addi	a4,a4,-1890 # 80008748 <states.0+0x30>
    80001eb2:	94ba                	add	s1,s1,a4
    80001eb4:	409c                	lw	a5,0(s1)
    80001eb6:	97ba                	add	a5,a5,a4
    80001eb8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ebe:	60e2                	ld	ra,24(sp)
    80001ec0:	6442                	ld	s0,16(sp)
    80001ec2:	64a2                	ld	s1,8(sp)
    80001ec4:	6105                	addi	sp,sp,32
    80001ec6:	8082                	ret
    return p->trapframe->a1;
    80001ec8:	6d3c                	ld	a5,88(a0)
    80001eca:	7fa8                	ld	a0,120(a5)
    80001ecc:	bfcd                	j	80001ebe <argraw+0x30>
    return p->trapframe->a2;
    80001ece:	6d3c                	ld	a5,88(a0)
    80001ed0:	63c8                	ld	a0,128(a5)
    80001ed2:	b7f5                	j	80001ebe <argraw+0x30>
    return p->trapframe->a3;
    80001ed4:	6d3c                	ld	a5,88(a0)
    80001ed6:	67c8                	ld	a0,136(a5)
    80001ed8:	b7dd                	j	80001ebe <argraw+0x30>
    return p->trapframe->a4;
    80001eda:	6d3c                	ld	a5,88(a0)
    80001edc:	6bc8                	ld	a0,144(a5)
    80001ede:	b7c5                	j	80001ebe <argraw+0x30>
    return p->trapframe->a5;
    80001ee0:	6d3c                	ld	a5,88(a0)
    80001ee2:	6fc8                	ld	a0,152(a5)
    80001ee4:	bfe9                	j	80001ebe <argraw+0x30>
  panic("argraw");
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	47250513          	addi	a0,a0,1138 # 80008358 <etext+0x358>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	ec8080e7          	jalr	-312(ra) # 80005db6 <panic>

0000000080001ef6 <fetchaddr>:
{
    80001ef6:	1101                	addi	sp,sp,-32
    80001ef8:	ec06                	sd	ra,24(sp)
    80001efa:	e822                	sd	s0,16(sp)
    80001efc:	e426                	sd	s1,8(sp)
    80001efe:	e04a                	sd	s2,0(sp)
    80001f00:	1000                	addi	s0,sp,32
    80001f02:	84aa                	mv	s1,a0
    80001f04:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	f76080e7          	jalr	-138(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f0e:	653c                	ld	a5,72(a0)
    80001f10:	02f4f863          	bgeu	s1,a5,80001f40 <fetchaddr+0x4a>
    80001f14:	00848713          	addi	a4,s1,8
    80001f18:	02e7e663          	bltu	a5,a4,80001f44 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f1c:	46a1                	li	a3,8
    80001f1e:	8626                	mv	a2,s1
    80001f20:	85ca                	mv	a1,s2
    80001f22:	6928                	ld	a0,80(a0)
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	c80080e7          	jalr	-896(ra) # 80000ba4 <copyin>
    80001f2c:	00a03533          	snez	a0,a0
    80001f30:	40a00533          	neg	a0,a0
}
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	64a2                	ld	s1,8(sp)
    80001f3a:	6902                	ld	s2,0(sp)
    80001f3c:	6105                	addi	sp,sp,32
    80001f3e:	8082                	ret
    return -1;
    80001f40:	557d                	li	a0,-1
    80001f42:	bfcd                	j	80001f34 <fetchaddr+0x3e>
    80001f44:	557d                	li	a0,-1
    80001f46:	b7fd                	j	80001f34 <fetchaddr+0x3e>

0000000080001f48 <fetchstr>:
{
    80001f48:	7179                	addi	sp,sp,-48
    80001f4a:	f406                	sd	ra,40(sp)
    80001f4c:	f022                	sd	s0,32(sp)
    80001f4e:	ec26                	sd	s1,24(sp)
    80001f50:	e84a                	sd	s2,16(sp)
    80001f52:	e44e                	sd	s3,8(sp)
    80001f54:	1800                	addi	s0,sp,48
    80001f56:	892a                	mv	s2,a0
    80001f58:	84ae                	mv	s1,a1
    80001f5a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	f20080e7          	jalr	-224(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f64:	86ce                	mv	a3,s3
    80001f66:	864a                	mv	a2,s2
    80001f68:	85a6                	mv	a1,s1
    80001f6a:	6928                	ld	a0,80(a0)
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	cc6080e7          	jalr	-826(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f74:	00054763          	bltz	a0,80001f82 <fetchstr+0x3a>
  return strlen(buf);
    80001f78:	8526                	mv	a0,s1
    80001f7a:	ffffe097          	auipc	ra,0xffffe
    80001f7e:	374080e7          	jalr	884(ra) # 800002ee <strlen>
}
    80001f82:	70a2                	ld	ra,40(sp)
    80001f84:	7402                	ld	s0,32(sp)
    80001f86:	64e2                	ld	s1,24(sp)
    80001f88:	6942                	ld	s2,16(sp)
    80001f8a:	69a2                	ld	s3,8(sp)
    80001f8c:	6145                	addi	sp,sp,48
    80001f8e:	8082                	ret

0000000080001f90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f90:	1101                	addi	sp,sp,-32
    80001f92:	ec06                	sd	ra,24(sp)
    80001f94:	e822                	sd	s0,16(sp)
    80001f96:	e426                	sd	s1,8(sp)
    80001f98:	1000                	addi	s0,sp,32
    80001f9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	ef2080e7          	jalr	-270(ra) # 80001e8e <argraw>
    80001fa4:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fa6:	4501                	li	a0,0
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	64a2                	ld	s1,8(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret

0000000080001fb2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	1000                	addi	s0,sp,32
    80001fbc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fbe:	00000097          	auipc	ra,0x0
    80001fc2:	ed0080e7          	jalr	-304(ra) # 80001e8e <argraw>
    80001fc6:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fc8:	4501                	li	a0,0
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	e04a                	sd	s2,0(sp)
    80001fde:	1000                	addi	s0,sp,32
    80001fe0:	84ae                	mv	s1,a1
    80001fe2:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	eaa080e7          	jalr	-342(ra) # 80001e8e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fec:	864a                	mv	a2,s2
    80001fee:	85a6                	mv	a1,s1
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	f58080e7          	jalr	-168(ra) # 80001f48 <fetchstr>
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6902                	ld	s2,0(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	e04a                	sd	s2,0(sp)
    8000200e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e6c080e7          	jalr	-404(ra) # 80000e7c <myproc>
    80002018:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000201a:	05853903          	ld	s2,88(a0)
    8000201e:	0a893783          	ld	a5,168(s2)
    80002022:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002026:	37fd                	addiw	a5,a5,-1
    80002028:	4759                	li	a4,22
    8000202a:	00f76f63          	bltu	a4,a5,80002048 <syscall+0x44>
    8000202e:	00369713          	slli	a4,a3,0x3
    80002032:	00006797          	auipc	a5,0x6
    80002036:	72e78793          	addi	a5,a5,1838 # 80008760 <syscalls>
    8000203a:	97ba                	add	a5,a5,a4
    8000203c:	639c                	ld	a5,0(a5)
    8000203e:	c789                	beqz	a5,80002048 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002040:	9782                	jalr	a5
    80002042:	06a93823          	sd	a0,112(s2)
    80002046:	a839                	j	80002064 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002048:	15848613          	addi	a2,s1,344
    8000204c:	588c                	lw	a1,48(s1)
    8000204e:	00006517          	auipc	a0,0x6
    80002052:	31250513          	addi	a0,a0,786 # 80008360 <etext+0x360>
    80002056:	00004097          	auipc	ra,0x4
    8000205a:	db2080e7          	jalr	-590(ra) # 80005e08 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000205e:	6cbc                	ld	a5,88(s1)
    80002060:	577d                	li	a4,-1
    80002062:	fbb8                	sd	a4,112(a5)
  }
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6902                	ld	s2,0(sp)
    8000206c:	6105                	addi	sp,sp,32
    8000206e:	8082                	ret

0000000080002070 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002078:	fec40593          	addi	a1,s0,-20
    8000207c:	4501                	li	a0,0
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	f12080e7          	jalr	-238(ra) # 80001f90 <argint>
    return -1;
    80002086:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002088:	00054963          	bltz	a0,8000209a <sys_exit+0x2a>
  exit(n);
    8000208c:	fec42503          	lw	a0,-20(s0)
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	720080e7          	jalr	1824(ra) # 800017b0 <exit>
  return 0;  // not reached
    80002098:	4781                	li	a5,0
}
    8000209a:	853e                	mv	a0,a5
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020a4:	1141                	addi	sp,sp,-16
    800020a6:	e406                	sd	ra,8(sp)
    800020a8:	e022                	sd	s0,0(sp)
    800020aa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	dd0080e7          	jalr	-560(ra) # 80000e7c <myproc>
}
    800020b4:	5908                	lw	a0,48(a0)
    800020b6:	60a2                	ld	ra,8(sp)
    800020b8:	6402                	ld	s0,0(sp)
    800020ba:	0141                	addi	sp,sp,16
    800020bc:	8082                	ret

00000000800020be <sys_fork>:

uint64
sys_fork(void)
{
    800020be:	1141                	addi	sp,sp,-16
    800020c0:	e406                	sd	ra,8(sp)
    800020c2:	e022                	sd	s0,0(sp)
    800020c4:	0800                	addi	s0,sp,16
  return fork();
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	19a080e7          	jalr	410(ra) # 80001260 <fork>
}
    800020ce:	60a2                	ld	ra,8(sp)
    800020d0:	6402                	ld	s0,0(sp)
    800020d2:	0141                	addi	sp,sp,16
    800020d4:	8082                	ret

00000000800020d6 <sys_wait>:

uint64
sys_wait(void)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020de:	fe840593          	addi	a1,s0,-24
    800020e2:	4501                	li	a0,0
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	ece080e7          	jalr	-306(ra) # 80001fb2 <argaddr>
    800020ec:	87aa                	mv	a5,a0
    return -1;
    800020ee:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020f0:	0007c863          	bltz	a5,80002100 <sys_wait+0x2a>
  return wait(p);
    800020f4:	fe843503          	ld	a0,-24(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	4c0080e7          	jalr	1216(ra) # 800015b8 <wait>
}
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002108:	7179                	addi	sp,sp,-48
    8000210a:	f406                	sd	ra,40(sp)
    8000210c:	f022                	sd	s0,32(sp)
    8000210e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002110:	fdc40593          	addi	a1,s0,-36
    80002114:	4501                	li	a0,0
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	e7a080e7          	jalr	-390(ra) # 80001f90 <argint>
    8000211e:	87aa                	mv	a5,a0
    return -1;
    80002120:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002122:	0207c263          	bltz	a5,80002146 <sys_sbrk+0x3e>
    80002126:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	d54080e7          	jalr	-684(ra) # 80000e7c <myproc>
    80002130:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002132:	fdc42503          	lw	a0,-36(s0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	0b2080e7          	jalr	178(ra) # 800011e8 <growproc>
    8000213e:	00054863          	bltz	a0,8000214e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002142:	8526                	mv	a0,s1
    80002144:	64e2                	ld	s1,24(sp)
}
    80002146:	70a2                	ld	ra,40(sp)
    80002148:	7402                	ld	s0,32(sp)
    8000214a:	6145                	addi	sp,sp,48
    8000214c:	8082                	ret
    return -1;
    8000214e:	557d                	li	a0,-1
    80002150:	64e2                	ld	s1,24(sp)
    80002152:	bfd5                	j	80002146 <sys_sbrk+0x3e>

0000000080002154 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002154:	7139                	addi	sp,sp,-64
    80002156:	fc06                	sd	ra,56(sp)
    80002158:	f822                	sd	s0,48(sp)
    8000215a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000215c:	fcc40593          	addi	a1,s0,-52
    80002160:	4501                	li	a0,0
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e2e080e7          	jalr	-466(ra) # 80001f90 <argint>
    return -1;
    8000216a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000216c:	06054f63          	bltz	a0,800021ea <sys_sleep+0x96>
    80002170:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002172:	00015517          	auipc	a0,0x15
    80002176:	b0e50513          	addi	a0,a0,-1266 # 80016c80 <tickslock>
    8000217a:	00004097          	auipc	ra,0x4
    8000217e:	18c080e7          	jalr	396(ra) # 80006306 <acquire>
  ticks0 = ticks;
    80002182:	0000a917          	auipc	s2,0xa
    80002186:	e9692903          	lw	s2,-362(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    8000218a:	fcc42783          	lw	a5,-52(s0)
    8000218e:	c3a1                	beqz	a5,800021ce <sys_sleep+0x7a>
    80002190:	f426                	sd	s1,40(sp)
    80002192:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002194:	00015997          	auipc	s3,0x15
    80002198:	aec98993          	addi	s3,s3,-1300 # 80016c80 <tickslock>
    8000219c:	0000a497          	auipc	s1,0xa
    800021a0:	e7c48493          	addi	s1,s1,-388 # 8000c018 <ticks>
    if(myproc()->killed){
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	cd8080e7          	jalr	-808(ra) # 80000e7c <myproc>
    800021ac:	551c                	lw	a5,40(a0)
    800021ae:	e3b9                	bnez	a5,800021f4 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021b0:	85ce                	mv	a1,s3
    800021b2:	8526                	mv	a0,s1
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	3a0080e7          	jalr	928(ra) # 80001554 <sleep>
  while(ticks - ticks0 < n){
    800021bc:	409c                	lw	a5,0(s1)
    800021be:	412787bb          	subw	a5,a5,s2
    800021c2:	fcc42703          	lw	a4,-52(s0)
    800021c6:	fce7efe3          	bltu	a5,a4,800021a4 <sys_sleep+0x50>
    800021ca:	74a2                	ld	s1,40(sp)
    800021cc:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800021ce:	00015517          	auipc	a0,0x15
    800021d2:	ab250513          	addi	a0,a0,-1358 # 80016c80 <tickslock>
    800021d6:	00004097          	auipc	ra,0x4
    800021da:	1e4080e7          	jalr	484(ra) # 800063ba <release>
  backtrace();
    800021de:	00004097          	auipc	ra,0x4
    800021e2:	b60080e7          	jalr	-1184(ra) # 80005d3e <backtrace>
  return 0;
    800021e6:	4781                	li	a5,0
    800021e8:	7902                	ld	s2,32(sp)
}
    800021ea:	853e                	mv	a0,a5
    800021ec:	70e2                	ld	ra,56(sp)
    800021ee:	7442                	ld	s0,48(sp)
    800021f0:	6121                	addi	sp,sp,64
    800021f2:	8082                	ret
      release(&tickslock);
    800021f4:	00015517          	auipc	a0,0x15
    800021f8:	a8c50513          	addi	a0,a0,-1396 # 80016c80 <tickslock>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	1be080e7          	jalr	446(ra) # 800063ba <release>
      return -1;
    80002204:	57fd                	li	a5,-1
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	7902                	ld	s2,32(sp)
    8000220a:	69e2                	ld	s3,24(sp)
    8000220c:	bff9                	j	800021ea <sys_sleep+0x96>

000000008000220e <sys_kill>:

uint64
sys_kill(void)
{
    8000220e:	1101                	addi	sp,sp,-32
    80002210:	ec06                	sd	ra,24(sp)
    80002212:	e822                	sd	s0,16(sp)
    80002214:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002216:	fec40593          	addi	a1,s0,-20
    8000221a:	4501                	li	a0,0
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	d74080e7          	jalr	-652(ra) # 80001f90 <argint>
    80002224:	87aa                	mv	a5,a0
    return -1;
    80002226:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002228:	0007c863          	bltz	a5,80002238 <sys_kill+0x2a>
  return kill(pid);
    8000222c:	fec42503          	lw	a0,-20(s0)
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	656080e7          	jalr	1622(ra) # 80001886 <kill>
}
    80002238:	60e2                	ld	ra,24(sp)
    8000223a:	6442                	ld	s0,16(sp)
    8000223c:	6105                	addi	sp,sp,32
    8000223e:	8082                	ret

0000000080002240 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	e426                	sd	s1,8(sp)
    80002248:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000224a:	00015517          	auipc	a0,0x15
    8000224e:	a3650513          	addi	a0,a0,-1482 # 80016c80 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	0b4080e7          	jalr	180(ra) # 80006306 <acquire>
  xticks = ticks;
    8000225a:	0000a497          	auipc	s1,0xa
    8000225e:	dbe4a483          	lw	s1,-578(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002262:	00015517          	auipc	a0,0x15
    80002266:	a1e50513          	addi	a0,a0,-1506 # 80016c80 <tickslock>
    8000226a:	00004097          	auipc	ra,0x4
    8000226e:	150080e7          	jalr	336(ra) # 800063ba <release>
  return xticks;
}
    80002272:	02049513          	slli	a0,s1,0x20
    80002276:	9101                	srli	a0,a0,0x20
    80002278:	60e2                	ld	ra,24(sp)
    8000227a:	6442                	ld	s0,16(sp)
    8000227c:	64a2                	ld	s1,8(sp)
    8000227e:	6105                	addi	sp,sp,32
    80002280:	8082                	ret

0000000080002282 <sys_sigalarm>:

uint64 sys_sigalarm(void)
{
    80002282:	1101                	addi	sp,sp,-32
    80002284:	ec06                	sd	ra,24(sp)
    80002286:	e822                	sd	s0,16(sp)
    80002288:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;

  if(argint(0,&interval) < 0)
    8000228a:	fec40593          	addi	a1,s0,-20
    8000228e:	4501                	li	a0,0
    80002290:	00000097          	auipc	ra,0x0
    80002294:	d00080e7          	jalr	-768(ra) # 80001f90 <argint>
    return -1;
    80002298:	57fd                	li	a5,-1
  if(argint(0,&interval) < 0)
    8000229a:	02054963          	bltz	a0,800022cc <sys_sigalarm+0x4a>
  if(argaddr(1, &handler)<0)
    8000229e:	fe040593          	addi	a1,s0,-32
    800022a2:	4505                	li	a0,1
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	d0e080e7          	jalr	-754(ra) # 80001fb2 <argaddr>
    return -1;
    800022ac:	57fd                	li	a5,-1
  if(argaddr(1, &handler)<0)
    800022ae:	00054f63          	bltz	a0,800022cc <sys_sigalarm+0x4a>

  struct proc *p = myproc();
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	bca080e7          	jalr	-1078(ra) # 80000e7c <myproc>
  p->alarm_interval= interval;
    800022ba:	fec42783          	lw	a5,-20(s0)
    800022be:	16f52423          	sw	a5,360(a0)
  p->alarm_handler = handler;
    800022c2:	fe043783          	ld	a5,-32(s0)
    800022c6:	16f53823          	sd	a5,368(a0)
  return 0;
    800022ca:	4781                	li	a5,0
}
    800022cc:	853e                	mv	a0,a5
    800022ce:	60e2                	ld	ra,24(sp)
    800022d0:	6442                	ld	s0,16(sp)
    800022d2:	6105                	addi	sp,sp,32
    800022d4:	8082                	ret

00000000800022d6 <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    800022d6:	1101                	addi	sp,sp,-32
    800022d8:	ec06                	sd	ra,24(sp)
    800022da:	e822                	sd	s0,16(sp)
    800022dc:	e426                	sd	s1,8(sp)
    800022de:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	b9c080e7          	jalr	-1124(ra) # 80000e7c <myproc>
    800022e8:	84aa                	mv	s1,a0
  memmove(p->trapframe, &(p->alarm_trapframe),sizeof(struct trapframe));
    800022ea:	12000613          	li	a2,288
    800022ee:	18050593          	addi	a1,a0,384
    800022f2:	6d28                	ld	a0,88(a0)
    800022f4:	ffffe097          	auipc	ra,0xffffe
    800022f8:	ee2080e7          	jalr	-286(ra) # 800001d6 <memmove>
  p->alarm_ticks = 0;
    800022fc:	1604a623          	sw	zero,364(s1)
  p->handler_exec = 1;
    80002300:	4785                	li	a5,1
    80002302:	16f4ac23          	sw	a5,376(s1)
  return 0;
    80002306:	4501                	li	a0,0
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002312:	7179                	addi	sp,sp,-48
    80002314:	f406                	sd	ra,40(sp)
    80002316:	f022                	sd	s0,32(sp)
    80002318:	ec26                	sd	s1,24(sp)
    8000231a:	e84a                	sd	s2,16(sp)
    8000231c:	e44e                	sd	s3,8(sp)
    8000231e:	e052                	sd	s4,0(sp)
    80002320:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002322:	00006597          	auipc	a1,0x6
    80002326:	05e58593          	addi	a1,a1,94 # 80008380 <etext+0x380>
    8000232a:	00015517          	auipc	a0,0x15
    8000232e:	96e50513          	addi	a0,a0,-1682 # 80016c98 <bcache>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	f44080e7          	jalr	-188(ra) # 80006276 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000233a:	0001d797          	auipc	a5,0x1d
    8000233e:	95e78793          	addi	a5,a5,-1698 # 8001ec98 <bcache+0x8000>
    80002342:	0001d717          	auipc	a4,0x1d
    80002346:	bbe70713          	addi	a4,a4,-1090 # 8001ef00 <bcache+0x8268>
    8000234a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000234e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002352:	00015497          	auipc	s1,0x15
    80002356:	95e48493          	addi	s1,s1,-1698 # 80016cb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000235a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000235c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000235e:	00006a17          	auipc	s4,0x6
    80002362:	02aa0a13          	addi	s4,s4,42 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002366:	2b893783          	ld	a5,696(s2)
    8000236a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000236c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002370:	85d2                	mv	a1,s4
    80002372:	01048513          	addi	a0,s1,16
    80002376:	00001097          	auipc	ra,0x1
    8000237a:	4b2080e7          	jalr	1202(ra) # 80003828 <initsleeplock>
    bcache.head.next->prev = b;
    8000237e:	2b893783          	ld	a5,696(s2)
    80002382:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002384:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002388:	45848493          	addi	s1,s1,1112
    8000238c:	fd349de3          	bne	s1,s3,80002366 <binit+0x54>
  }
}
    80002390:	70a2                	ld	ra,40(sp)
    80002392:	7402                	ld	s0,32(sp)
    80002394:	64e2                	ld	s1,24(sp)
    80002396:	6942                	ld	s2,16(sp)
    80002398:	69a2                	ld	s3,8(sp)
    8000239a:	6a02                	ld	s4,0(sp)
    8000239c:	6145                	addi	sp,sp,48
    8000239e:	8082                	ret

00000000800023a0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023a0:	7179                	addi	sp,sp,-48
    800023a2:	f406                	sd	ra,40(sp)
    800023a4:	f022                	sd	s0,32(sp)
    800023a6:	ec26                	sd	s1,24(sp)
    800023a8:	e84a                	sd	s2,16(sp)
    800023aa:	e44e                	sd	s3,8(sp)
    800023ac:	1800                	addi	s0,sp,48
    800023ae:	892a                	mv	s2,a0
    800023b0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023b2:	00015517          	auipc	a0,0x15
    800023b6:	8e650513          	addi	a0,a0,-1818 # 80016c98 <bcache>
    800023ba:	00004097          	auipc	ra,0x4
    800023be:	f4c080e7          	jalr	-180(ra) # 80006306 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c2:	0001d497          	auipc	s1,0x1d
    800023c6:	b8e4b483          	ld	s1,-1138(s1) # 8001ef50 <bcache+0x82b8>
    800023ca:	0001d797          	auipc	a5,0x1d
    800023ce:	b3678793          	addi	a5,a5,-1226 # 8001ef00 <bcache+0x8268>
    800023d2:	02f48f63          	beq	s1,a5,80002410 <bread+0x70>
    800023d6:	873e                	mv	a4,a5
    800023d8:	a021                	j	800023e0 <bread+0x40>
    800023da:	68a4                	ld	s1,80(s1)
    800023dc:	02e48a63          	beq	s1,a4,80002410 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023e0:	449c                	lw	a5,8(s1)
    800023e2:	ff279ce3          	bne	a5,s2,800023da <bread+0x3a>
    800023e6:	44dc                	lw	a5,12(s1)
    800023e8:	ff3799e3          	bne	a5,s3,800023da <bread+0x3a>
      b->refcnt++;
    800023ec:	40bc                	lw	a5,64(s1)
    800023ee:	2785                	addiw	a5,a5,1
    800023f0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f2:	00015517          	auipc	a0,0x15
    800023f6:	8a650513          	addi	a0,a0,-1882 # 80016c98 <bcache>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	fc0080e7          	jalr	-64(ra) # 800063ba <release>
      acquiresleep(&b->lock);
    80002402:	01048513          	addi	a0,s1,16
    80002406:	00001097          	auipc	ra,0x1
    8000240a:	45c080e7          	jalr	1116(ra) # 80003862 <acquiresleep>
      return b;
    8000240e:	a8b9                	j	8000246c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002410:	0001d497          	auipc	s1,0x1d
    80002414:	b384b483          	ld	s1,-1224(s1) # 8001ef48 <bcache+0x82b0>
    80002418:	0001d797          	auipc	a5,0x1d
    8000241c:	ae878793          	addi	a5,a5,-1304 # 8001ef00 <bcache+0x8268>
    80002420:	00f48863          	beq	s1,a5,80002430 <bread+0x90>
    80002424:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002426:	40bc                	lw	a5,64(s1)
    80002428:	cf81                	beqz	a5,80002440 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242a:	64a4                	ld	s1,72(s1)
    8000242c:	fee49de3          	bne	s1,a4,80002426 <bread+0x86>
  panic("bget: no buffers");
    80002430:	00006517          	auipc	a0,0x6
    80002434:	f6050513          	addi	a0,a0,-160 # 80008390 <etext+0x390>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	97e080e7          	jalr	-1666(ra) # 80005db6 <panic>
      b->dev = dev;
    80002440:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002444:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002448:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000244c:	4785                	li	a5,1
    8000244e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002450:	00015517          	auipc	a0,0x15
    80002454:	84850513          	addi	a0,a0,-1976 # 80016c98 <bcache>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	f62080e7          	jalr	-158(ra) # 800063ba <release>
      acquiresleep(&b->lock);
    80002460:	01048513          	addi	a0,s1,16
    80002464:	00001097          	auipc	ra,0x1
    80002468:	3fe080e7          	jalr	1022(ra) # 80003862 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000246c:	409c                	lw	a5,0(s1)
    8000246e:	cb89                	beqz	a5,80002480 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002470:	8526                	mv	a0,s1
    80002472:	70a2                	ld	ra,40(sp)
    80002474:	7402                	ld	s0,32(sp)
    80002476:	64e2                	ld	s1,24(sp)
    80002478:	6942                	ld	s2,16(sp)
    8000247a:	69a2                	ld	s3,8(sp)
    8000247c:	6145                	addi	sp,sp,48
    8000247e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002480:	4581                	li	a1,0
    80002482:	8526                	mv	a0,s1
    80002484:	00003097          	auipc	ra,0x3
    80002488:	fee080e7          	jalr	-18(ra) # 80005472 <virtio_disk_rw>
    b->valid = 1;
    8000248c:	4785                	li	a5,1
    8000248e:	c09c                	sw	a5,0(s1)
  return b;
    80002490:	b7c5                	j	80002470 <bread+0xd0>

0000000080002492 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	addi	s0,sp,32
    8000249c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000249e:	0541                	addi	a0,a0,16
    800024a0:	00001097          	auipc	ra,0x1
    800024a4:	45c080e7          	jalr	1116(ra) # 800038fc <holdingsleep>
    800024a8:	cd01                	beqz	a0,800024c0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024aa:	4585                	li	a1,1
    800024ac:	8526                	mv	a0,s1
    800024ae:	00003097          	auipc	ra,0x3
    800024b2:	fc4080e7          	jalr	-60(ra) # 80005472 <virtio_disk_rw>
}
    800024b6:	60e2                	ld	ra,24(sp)
    800024b8:	6442                	ld	s0,16(sp)
    800024ba:	64a2                	ld	s1,8(sp)
    800024bc:	6105                	addi	sp,sp,32
    800024be:	8082                	ret
    panic("bwrite");
    800024c0:	00006517          	auipc	a0,0x6
    800024c4:	ee850513          	addi	a0,a0,-280 # 800083a8 <etext+0x3a8>
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	8ee080e7          	jalr	-1810(ra) # 80005db6 <panic>

00000000800024d0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	e04a                	sd	s2,0(sp)
    800024da:	1000                	addi	s0,sp,32
    800024dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024de:	01050913          	addi	s2,a0,16
    800024e2:	854a                	mv	a0,s2
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	418080e7          	jalr	1048(ra) # 800038fc <holdingsleep>
    800024ec:	c925                	beqz	a0,8000255c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024ee:	854a                	mv	a0,s2
    800024f0:	00001097          	auipc	ra,0x1
    800024f4:	3c8080e7          	jalr	968(ra) # 800038b8 <releasesleep>

  acquire(&bcache.lock);
    800024f8:	00014517          	auipc	a0,0x14
    800024fc:	7a050513          	addi	a0,a0,1952 # 80016c98 <bcache>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	e06080e7          	jalr	-506(ra) # 80006306 <acquire>
  b->refcnt--;
    80002508:	40bc                	lw	a5,64(s1)
    8000250a:	37fd                	addiw	a5,a5,-1
    8000250c:	0007871b          	sext.w	a4,a5
    80002510:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002512:	e71d                	bnez	a4,80002540 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002514:	68b8                	ld	a4,80(s1)
    80002516:	64bc                	ld	a5,72(s1)
    80002518:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000251a:	68b8                	ld	a4,80(s1)
    8000251c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000251e:	0001c797          	auipc	a5,0x1c
    80002522:	77a78793          	addi	a5,a5,1914 # 8001ec98 <bcache+0x8000>
    80002526:	2b87b703          	ld	a4,696(a5)
    8000252a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000252c:	0001d717          	auipc	a4,0x1d
    80002530:	9d470713          	addi	a4,a4,-1580 # 8001ef00 <bcache+0x8268>
    80002534:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000253c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002540:	00014517          	auipc	a0,0x14
    80002544:	75850513          	addi	a0,a0,1880 # 80016c98 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	e72080e7          	jalr	-398(ra) # 800063ba <release>
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6902                	ld	s2,0(sp)
    80002558:	6105                	addi	sp,sp,32
    8000255a:	8082                	ret
    panic("brelse");
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	e5450513          	addi	a0,a0,-428 # 800083b0 <etext+0x3b0>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	852080e7          	jalr	-1966(ra) # 80005db6 <panic>

000000008000256c <bpin>:

void
bpin(struct buf *b) {
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002578:	00014517          	auipc	a0,0x14
    8000257c:	72050513          	addi	a0,a0,1824 # 80016c98 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	d86080e7          	jalr	-634(ra) # 80006306 <acquire>
  b->refcnt++;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	2785                	addiw	a5,a5,1
    8000258c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000258e:	00014517          	auipc	a0,0x14
    80002592:	70a50513          	addi	a0,a0,1802 # 80016c98 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	e24080e7          	jalr	-476(ra) # 800063ba <release>
}
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <bunpin>:

void
bunpin(struct buf *b) {
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b4:	00014517          	auipc	a0,0x14
    800025b8:	6e450513          	addi	a0,a0,1764 # 80016c98 <bcache>
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	d4a080e7          	jalr	-694(ra) # 80006306 <acquire>
  b->refcnt--;
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	37fd                	addiw	a5,a5,-1
    800025c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ca:	00014517          	auipc	a0,0x14
    800025ce:	6ce50513          	addi	a0,a0,1742 # 80016c98 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	de8080e7          	jalr	-536(ra) # 800063ba <release>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6105                	addi	sp,sp,32
    800025e2:	8082                	ret

00000000800025e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	e04a                	sd	s2,0(sp)
    800025ee:	1000                	addi	s0,sp,32
    800025f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f2:	00d5d59b          	srliw	a1,a1,0xd
    800025f6:	0001d797          	auipc	a5,0x1d
    800025fa:	d7e7a783          	lw	a5,-642(a5) # 8001f374 <sb+0x1c>
    800025fe:	9dbd                	addw	a1,a1,a5
    80002600:	00000097          	auipc	ra,0x0
    80002604:	da0080e7          	jalr	-608(ra) # 800023a0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002608:	0074f713          	andi	a4,s1,7
    8000260c:	4785                	li	a5,1
    8000260e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002612:	14ce                	slli	s1,s1,0x33
    80002614:	90d9                	srli	s1,s1,0x36
    80002616:	00950733          	add	a4,a0,s1
    8000261a:	05874703          	lbu	a4,88(a4)
    8000261e:	00e7f6b3          	and	a3,a5,a4
    80002622:	c69d                	beqz	a3,80002650 <bfree+0x6c>
    80002624:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002626:	94aa                	add	s1,s1,a0
    80002628:	fff7c793          	not	a5,a5
    8000262c:	8f7d                	and	a4,a4,a5
    8000262e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002632:	00001097          	auipc	ra,0x1
    80002636:	112080e7          	jalr	274(ra) # 80003744 <log_write>
  brelse(bp);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00000097          	auipc	ra,0x0
    80002640:	e94080e7          	jalr	-364(ra) # 800024d0 <brelse>
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6902                	ld	s2,0(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret
    panic("freeing free block");
    80002650:	00006517          	auipc	a0,0x6
    80002654:	d6850513          	addi	a0,a0,-664 # 800083b8 <etext+0x3b8>
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	75e080e7          	jalr	1886(ra) # 80005db6 <panic>

0000000080002660 <balloc>:
{
    80002660:	711d                	addi	sp,sp,-96
    80002662:	ec86                	sd	ra,88(sp)
    80002664:	e8a2                	sd	s0,80(sp)
    80002666:	e4a6                	sd	s1,72(sp)
    80002668:	e0ca                	sd	s2,64(sp)
    8000266a:	fc4e                	sd	s3,56(sp)
    8000266c:	f852                	sd	s4,48(sp)
    8000266e:	f456                	sd	s5,40(sp)
    80002670:	f05a                	sd	s6,32(sp)
    80002672:	ec5e                	sd	s7,24(sp)
    80002674:	e862                	sd	s8,16(sp)
    80002676:	e466                	sd	s9,8(sp)
    80002678:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000267a:	0001d797          	auipc	a5,0x1d
    8000267e:	ce27a783          	lw	a5,-798(a5) # 8001f35c <sb+0x4>
    80002682:	cbc1                	beqz	a5,80002712 <balloc+0xb2>
    80002684:	8baa                	mv	s7,a0
    80002686:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002688:	0001db17          	auipc	s6,0x1d
    8000268c:	cd0b0b13          	addi	s6,s6,-816 # 8001f358 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002690:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002692:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002694:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002696:	6c89                	lui	s9,0x2
    80002698:	a831                	j	800026b4 <balloc+0x54>
    brelse(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00000097          	auipc	ra,0x0
    800026a0:	e34080e7          	jalr	-460(ra) # 800024d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a4:	015c87bb          	addw	a5,s9,s5
    800026a8:	00078a9b          	sext.w	s5,a5
    800026ac:	004b2703          	lw	a4,4(s6)
    800026b0:	06eaf163          	bgeu	s5,a4,80002712 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026b4:	41fad79b          	sraiw	a5,s5,0x1f
    800026b8:	0137d79b          	srliw	a5,a5,0x13
    800026bc:	015787bb          	addw	a5,a5,s5
    800026c0:	40d7d79b          	sraiw	a5,a5,0xd
    800026c4:	01cb2583          	lw	a1,28(s6)
    800026c8:	9dbd                	addw	a1,a1,a5
    800026ca:	855e                	mv	a0,s7
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	cd4080e7          	jalr	-812(ra) # 800023a0 <bread>
    800026d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d6:	004b2503          	lw	a0,4(s6)
    800026da:	000a849b          	sext.w	s1,s5
    800026de:	8762                	mv	a4,s8
    800026e0:	faa4fde3          	bgeu	s1,a0,8000269a <balloc+0x3a>
      m = 1 << (bi % 8);
    800026e4:	00777693          	andi	a3,a4,7
    800026e8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ec:	41f7579b          	sraiw	a5,a4,0x1f
    800026f0:	01d7d79b          	srliw	a5,a5,0x1d
    800026f4:	9fb9                	addw	a5,a5,a4
    800026f6:	4037d79b          	sraiw	a5,a5,0x3
    800026fa:	00f90633          	add	a2,s2,a5
    800026fe:	05864603          	lbu	a2,88(a2)
    80002702:	00c6f5b3          	and	a1,a3,a2
    80002706:	cd91                	beqz	a1,80002722 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002708:	2705                	addiw	a4,a4,1
    8000270a:	2485                	addiw	s1,s1,1
    8000270c:	fd471ae3          	bne	a4,s4,800026e0 <balloc+0x80>
    80002710:	b769                	j	8000269a <balloc+0x3a>
  panic("balloc: out of blocks");
    80002712:	00006517          	auipc	a0,0x6
    80002716:	cbe50513          	addi	a0,a0,-834 # 800083d0 <etext+0x3d0>
    8000271a:	00003097          	auipc	ra,0x3
    8000271e:	69c080e7          	jalr	1692(ra) # 80005db6 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002722:	97ca                	add	a5,a5,s2
    80002724:	8e55                	or	a2,a2,a3
    80002726:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00001097          	auipc	ra,0x1
    80002730:	018080e7          	jalr	24(ra) # 80003744 <log_write>
        brelse(bp);
    80002734:	854a                	mv	a0,s2
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	d9a080e7          	jalr	-614(ra) # 800024d0 <brelse>
  bp = bread(dev, bno);
    8000273e:	85a6                	mv	a1,s1
    80002740:	855e                	mv	a0,s7
    80002742:	00000097          	auipc	ra,0x0
    80002746:	c5e080e7          	jalr	-930(ra) # 800023a0 <bread>
    8000274a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000274c:	40000613          	li	a2,1024
    80002750:	4581                	li	a1,0
    80002752:	05850513          	addi	a0,a0,88
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	a24080e7          	jalr	-1500(ra) # 8000017a <memset>
  log_write(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	fe4080e7          	jalr	-28(ra) # 80003744 <log_write>
  brelse(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	d66080e7          	jalr	-666(ra) # 800024d0 <brelse>
}
    80002772:	8526                	mv	a0,s1
    80002774:	60e6                	ld	ra,88(sp)
    80002776:	6446                	ld	s0,80(sp)
    80002778:	64a6                	ld	s1,72(sp)
    8000277a:	6906                	ld	s2,64(sp)
    8000277c:	79e2                	ld	s3,56(sp)
    8000277e:	7a42                	ld	s4,48(sp)
    80002780:	7aa2                	ld	s5,40(sp)
    80002782:	7b02                	ld	s6,32(sp)
    80002784:	6be2                	ld	s7,24(sp)
    80002786:	6c42                	ld	s8,16(sp)
    80002788:	6ca2                	ld	s9,8(sp)
    8000278a:	6125                	addi	sp,sp,96
    8000278c:	8082                	ret

000000008000278e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000278e:	7179                	addi	sp,sp,-48
    80002790:	f406                	sd	ra,40(sp)
    80002792:	f022                	sd	s0,32(sp)
    80002794:	ec26                	sd	s1,24(sp)
    80002796:	e84a                	sd	s2,16(sp)
    80002798:	e44e                	sd	s3,8(sp)
    8000279a:	1800                	addi	s0,sp,48
    8000279c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000279e:	47ad                	li	a5,11
    800027a0:	04b7ff63          	bgeu	a5,a1,800027fe <bmap+0x70>
    800027a4:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027a6:	ff45849b          	addiw	s1,a1,-12
    800027aa:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027ae:	0ff00793          	li	a5,255
    800027b2:	0ae7e463          	bltu	a5,a4,8000285a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027b6:	08052583          	lw	a1,128(a0)
    800027ba:	c5b5                	beqz	a1,80002826 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027bc:	00092503          	lw	a0,0(s2)
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	be0080e7          	jalr	-1056(ra) # 800023a0 <bread>
    800027c8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027ca:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ce:	02049713          	slli	a4,s1,0x20
    800027d2:	01e75593          	srli	a1,a4,0x1e
    800027d6:	00b784b3          	add	s1,a5,a1
    800027da:	0004a983          	lw	s3,0(s1)
    800027de:	04098e63          	beqz	s3,8000283a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027e2:	8552                	mv	a0,s4
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	cec080e7          	jalr	-788(ra) # 800024d0 <brelse>
    return addr;
    800027ec:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800027ee:	854e                	mv	a0,s3
    800027f0:	70a2                	ld	ra,40(sp)
    800027f2:	7402                	ld	s0,32(sp)
    800027f4:	64e2                	ld	s1,24(sp)
    800027f6:	6942                	ld	s2,16(sp)
    800027f8:	69a2                	ld	s3,8(sp)
    800027fa:	6145                	addi	sp,sp,48
    800027fc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027fe:	02059793          	slli	a5,a1,0x20
    80002802:	01e7d593          	srli	a1,a5,0x1e
    80002806:	00b504b3          	add	s1,a0,a1
    8000280a:	0504a983          	lw	s3,80(s1)
    8000280e:	fe0990e3          	bnez	s3,800027ee <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002812:	4108                	lw	a0,0(a0)
    80002814:	00000097          	auipc	ra,0x0
    80002818:	e4c080e7          	jalr	-436(ra) # 80002660 <balloc>
    8000281c:	0005099b          	sext.w	s3,a0
    80002820:	0534a823          	sw	s3,80(s1)
    80002824:	b7e9                	j	800027ee <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002826:	4108                	lw	a0,0(a0)
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e38080e7          	jalr	-456(ra) # 80002660 <balloc>
    80002830:	0005059b          	sext.w	a1,a0
    80002834:	08b92023          	sw	a1,128(s2)
    80002838:	b751                	j	800027bc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000283a:	00092503          	lw	a0,0(s2)
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	e22080e7          	jalr	-478(ra) # 80002660 <balloc>
    80002846:	0005099b          	sext.w	s3,a0
    8000284a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000284e:	8552                	mv	a0,s4
    80002850:	00001097          	auipc	ra,0x1
    80002854:	ef4080e7          	jalr	-268(ra) # 80003744 <log_write>
    80002858:	b769                	j	800027e2 <bmap+0x54>
  panic("bmap: out of range");
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	b8e50513          	addi	a0,a0,-1138 # 800083e8 <etext+0x3e8>
    80002862:	00003097          	auipc	ra,0x3
    80002866:	554080e7          	jalr	1364(ra) # 80005db6 <panic>

000000008000286a <iget>:
{
    8000286a:	7179                	addi	sp,sp,-48
    8000286c:	f406                	sd	ra,40(sp)
    8000286e:	f022                	sd	s0,32(sp)
    80002870:	ec26                	sd	s1,24(sp)
    80002872:	e84a                	sd	s2,16(sp)
    80002874:	e44e                	sd	s3,8(sp)
    80002876:	e052                	sd	s4,0(sp)
    80002878:	1800                	addi	s0,sp,48
    8000287a:	89aa                	mv	s3,a0
    8000287c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000287e:	0001d517          	auipc	a0,0x1d
    80002882:	afa50513          	addi	a0,a0,-1286 # 8001f378 <itable>
    80002886:	00004097          	auipc	ra,0x4
    8000288a:	a80080e7          	jalr	-1408(ra) # 80006306 <acquire>
  empty = 0;
    8000288e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002890:	0001d497          	auipc	s1,0x1d
    80002894:	b0048493          	addi	s1,s1,-1280 # 8001f390 <itable+0x18>
    80002898:	0001e697          	auipc	a3,0x1e
    8000289c:	58868693          	addi	a3,a3,1416 # 80020e20 <log>
    800028a0:	a039                	j	800028ae <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a2:	02090b63          	beqz	s2,800028d8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a6:	08848493          	addi	s1,s1,136
    800028aa:	02d48a63          	beq	s1,a3,800028de <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028ae:	449c                	lw	a5,8(s1)
    800028b0:	fef059e3          	blez	a5,800028a2 <iget+0x38>
    800028b4:	4098                	lw	a4,0(s1)
    800028b6:	ff3716e3          	bne	a4,s3,800028a2 <iget+0x38>
    800028ba:	40d8                	lw	a4,4(s1)
    800028bc:	ff4713e3          	bne	a4,s4,800028a2 <iget+0x38>
      ip->ref++;
    800028c0:	2785                	addiw	a5,a5,1
    800028c2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028c4:	0001d517          	auipc	a0,0x1d
    800028c8:	ab450513          	addi	a0,a0,-1356 # 8001f378 <itable>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	aee080e7          	jalr	-1298(ra) # 800063ba <release>
      return ip;
    800028d4:	8926                	mv	s2,s1
    800028d6:	a03d                	j	80002904 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d8:	f7f9                	bnez	a5,800028a6 <iget+0x3c>
      empty = ip;
    800028da:	8926                	mv	s2,s1
    800028dc:	b7e9                	j	800028a6 <iget+0x3c>
  if(empty == 0)
    800028de:	02090c63          	beqz	s2,80002916 <iget+0xac>
  ip->dev = dev;
    800028e2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028e6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028ea:	4785                	li	a5,1
    800028ec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028f4:	0001d517          	auipc	a0,0x1d
    800028f8:	a8450513          	addi	a0,a0,-1404 # 8001f378 <itable>
    800028fc:	00004097          	auipc	ra,0x4
    80002900:	abe080e7          	jalr	-1346(ra) # 800063ba <release>
}
    80002904:	854a                	mv	a0,s2
    80002906:	70a2                	ld	ra,40(sp)
    80002908:	7402                	ld	s0,32(sp)
    8000290a:	64e2                	ld	s1,24(sp)
    8000290c:	6942                	ld	s2,16(sp)
    8000290e:	69a2                	ld	s3,8(sp)
    80002910:	6a02                	ld	s4,0(sp)
    80002912:	6145                	addi	sp,sp,48
    80002914:	8082                	ret
    panic("iget: no inodes");
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	aea50513          	addi	a0,a0,-1302 # 80008400 <etext+0x400>
    8000291e:	00003097          	auipc	ra,0x3
    80002922:	498080e7          	jalr	1176(ra) # 80005db6 <panic>

0000000080002926 <fsinit>:
fsinit(int dev) {
    80002926:	7179                	addi	sp,sp,-48
    80002928:	f406                	sd	ra,40(sp)
    8000292a:	f022                	sd	s0,32(sp)
    8000292c:	ec26                	sd	s1,24(sp)
    8000292e:	e84a                	sd	s2,16(sp)
    80002930:	e44e                	sd	s3,8(sp)
    80002932:	1800                	addi	s0,sp,48
    80002934:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002936:	4585                	li	a1,1
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	a68080e7          	jalr	-1432(ra) # 800023a0 <bread>
    80002940:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002942:	0001d997          	auipc	s3,0x1d
    80002946:	a1698993          	addi	s3,s3,-1514 # 8001f358 <sb>
    8000294a:	02000613          	li	a2,32
    8000294e:	05850593          	addi	a1,a0,88
    80002952:	854e                	mv	a0,s3
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	882080e7          	jalr	-1918(ra) # 800001d6 <memmove>
  brelse(bp);
    8000295c:	8526                	mv	a0,s1
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	b72080e7          	jalr	-1166(ra) # 800024d0 <brelse>
  if(sb.magic != FSMAGIC)
    80002966:	0009a703          	lw	a4,0(s3)
    8000296a:	102037b7          	lui	a5,0x10203
    8000296e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002972:	02f71263          	bne	a4,a5,80002996 <fsinit+0x70>
  initlog(dev, &sb);
    80002976:	0001d597          	auipc	a1,0x1d
    8000297a:	9e258593          	addi	a1,a1,-1566 # 8001f358 <sb>
    8000297e:	854a                	mv	a0,s2
    80002980:	00001097          	auipc	ra,0x1
    80002984:	b54080e7          	jalr	-1196(ra) # 800034d4 <initlog>
}
    80002988:	70a2                	ld	ra,40(sp)
    8000298a:	7402                	ld	s0,32(sp)
    8000298c:	64e2                	ld	s1,24(sp)
    8000298e:	6942                	ld	s2,16(sp)
    80002990:	69a2                	ld	s3,8(sp)
    80002992:	6145                	addi	sp,sp,48
    80002994:	8082                	ret
    panic("invalid file system");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	a7a50513          	addi	a0,a0,-1414 # 80008410 <etext+0x410>
    8000299e:	00003097          	auipc	ra,0x3
    800029a2:	418080e7          	jalr	1048(ra) # 80005db6 <panic>

00000000800029a6 <iinit>:
{
    800029a6:	7179                	addi	sp,sp,-48
    800029a8:	f406                	sd	ra,40(sp)
    800029aa:	f022                	sd	s0,32(sp)
    800029ac:	ec26                	sd	s1,24(sp)
    800029ae:	e84a                	sd	s2,16(sp)
    800029b0:	e44e                	sd	s3,8(sp)
    800029b2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029b4:	00006597          	auipc	a1,0x6
    800029b8:	a7458593          	addi	a1,a1,-1420 # 80008428 <etext+0x428>
    800029bc:	0001d517          	auipc	a0,0x1d
    800029c0:	9bc50513          	addi	a0,a0,-1604 # 8001f378 <itable>
    800029c4:	00004097          	auipc	ra,0x4
    800029c8:	8b2080e7          	jalr	-1870(ra) # 80006276 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029cc:	0001d497          	auipc	s1,0x1d
    800029d0:	9d448493          	addi	s1,s1,-1580 # 8001f3a0 <itable+0x28>
    800029d4:	0001e997          	auipc	s3,0x1e
    800029d8:	45c98993          	addi	s3,s3,1116 # 80020e30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029dc:	00006917          	auipc	s2,0x6
    800029e0:	a5490913          	addi	s2,s2,-1452 # 80008430 <etext+0x430>
    800029e4:	85ca                	mv	a1,s2
    800029e6:	8526                	mv	a0,s1
    800029e8:	00001097          	auipc	ra,0x1
    800029ec:	e40080e7          	jalr	-448(ra) # 80003828 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f0:	08848493          	addi	s1,s1,136
    800029f4:	ff3498e3          	bne	s1,s3,800029e4 <iinit+0x3e>
}
    800029f8:	70a2                	ld	ra,40(sp)
    800029fa:	7402                	ld	s0,32(sp)
    800029fc:	64e2                	ld	s1,24(sp)
    800029fe:	6942                	ld	s2,16(sp)
    80002a00:	69a2                	ld	s3,8(sp)
    80002a02:	6145                	addi	sp,sp,48
    80002a04:	8082                	ret

0000000080002a06 <ialloc>:
{
    80002a06:	7139                	addi	sp,sp,-64
    80002a08:	fc06                	sd	ra,56(sp)
    80002a0a:	f822                	sd	s0,48(sp)
    80002a0c:	f426                	sd	s1,40(sp)
    80002a0e:	f04a                	sd	s2,32(sp)
    80002a10:	ec4e                	sd	s3,24(sp)
    80002a12:	e852                	sd	s4,16(sp)
    80002a14:	e456                	sd	s5,8(sp)
    80002a16:	e05a                	sd	s6,0(sp)
    80002a18:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a1a:	0001d717          	auipc	a4,0x1d
    80002a1e:	94a72703          	lw	a4,-1718(a4) # 8001f364 <sb+0xc>
    80002a22:	4785                	li	a5,1
    80002a24:	04e7f863          	bgeu	a5,a4,80002a74 <ialloc+0x6e>
    80002a28:	8aaa                	mv	s5,a0
    80002a2a:	8b2e                	mv	s6,a1
    80002a2c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a2e:	0001da17          	auipc	s4,0x1d
    80002a32:	92aa0a13          	addi	s4,s4,-1750 # 8001f358 <sb>
    80002a36:	00495593          	srli	a1,s2,0x4
    80002a3a:	018a2783          	lw	a5,24(s4)
    80002a3e:	9dbd                	addw	a1,a1,a5
    80002a40:	8556                	mv	a0,s5
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	95e080e7          	jalr	-1698(ra) # 800023a0 <bread>
    80002a4a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a4c:	05850993          	addi	s3,a0,88
    80002a50:	00f97793          	andi	a5,s2,15
    80002a54:	079a                	slli	a5,a5,0x6
    80002a56:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a58:	00099783          	lh	a5,0(s3)
    80002a5c:	c785                	beqz	a5,80002a84 <ialloc+0x7e>
    brelse(bp);
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	a72080e7          	jalr	-1422(ra) # 800024d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a66:	0905                	addi	s2,s2,1
    80002a68:	00ca2703          	lw	a4,12(s4)
    80002a6c:	0009079b          	sext.w	a5,s2
    80002a70:	fce7e3e3          	bltu	a5,a4,80002a36 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	9c450513          	addi	a0,a0,-1596 # 80008438 <etext+0x438>
    80002a7c:	00003097          	auipc	ra,0x3
    80002a80:	33a080e7          	jalr	826(ra) # 80005db6 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a84:	04000613          	li	a2,64
    80002a88:	4581                	li	a1,0
    80002a8a:	854e                	mv	a0,s3
    80002a8c:	ffffd097          	auipc	ra,0xffffd
    80002a90:	6ee080e7          	jalr	1774(ra) # 8000017a <memset>
      dip->type = type;
    80002a94:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a98:	8526                	mv	a0,s1
    80002a9a:	00001097          	auipc	ra,0x1
    80002a9e:	caa080e7          	jalr	-854(ra) # 80003744 <log_write>
      brelse(bp);
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	a2c080e7          	jalr	-1492(ra) # 800024d0 <brelse>
      return iget(dev, inum);
    80002aac:	0009059b          	sext.w	a1,s2
    80002ab0:	8556                	mv	a0,s5
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	db8080e7          	jalr	-584(ra) # 8000286a <iget>
}
    80002aba:	70e2                	ld	ra,56(sp)
    80002abc:	7442                	ld	s0,48(sp)
    80002abe:	74a2                	ld	s1,40(sp)
    80002ac0:	7902                	ld	s2,32(sp)
    80002ac2:	69e2                	ld	s3,24(sp)
    80002ac4:	6a42                	ld	s4,16(sp)
    80002ac6:	6aa2                	ld	s5,8(sp)
    80002ac8:	6b02                	ld	s6,0(sp)
    80002aca:	6121                	addi	sp,sp,64
    80002acc:	8082                	ret

0000000080002ace <iupdate>:
{
    80002ace:	1101                	addi	sp,sp,-32
    80002ad0:	ec06                	sd	ra,24(sp)
    80002ad2:	e822                	sd	s0,16(sp)
    80002ad4:	e426                	sd	s1,8(sp)
    80002ad6:	e04a                	sd	s2,0(sp)
    80002ad8:	1000                	addi	s0,sp,32
    80002ada:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002adc:	415c                	lw	a5,4(a0)
    80002ade:	0047d79b          	srliw	a5,a5,0x4
    80002ae2:	0001d597          	auipc	a1,0x1d
    80002ae6:	88e5a583          	lw	a1,-1906(a1) # 8001f370 <sb+0x18>
    80002aea:	9dbd                	addw	a1,a1,a5
    80002aec:	4108                	lw	a0,0(a0)
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	8b2080e7          	jalr	-1870(ra) # 800023a0 <bread>
    80002af6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002af8:	05850793          	addi	a5,a0,88
    80002afc:	40d8                	lw	a4,4(s1)
    80002afe:	8b3d                	andi	a4,a4,15
    80002b00:	071a                	slli	a4,a4,0x6
    80002b02:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b04:	04449703          	lh	a4,68(s1)
    80002b08:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b0c:	04649703          	lh	a4,70(s1)
    80002b10:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b14:	04849703          	lh	a4,72(s1)
    80002b18:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b1c:	04a49703          	lh	a4,74(s1)
    80002b20:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b24:	44f8                	lw	a4,76(s1)
    80002b26:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b28:	03400613          	li	a2,52
    80002b2c:	05048593          	addi	a1,s1,80
    80002b30:	00c78513          	addi	a0,a5,12
    80002b34:	ffffd097          	auipc	ra,0xffffd
    80002b38:	6a2080e7          	jalr	1698(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b3c:	854a                	mv	a0,s2
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	c06080e7          	jalr	-1018(ra) # 80003744 <log_write>
  brelse(bp);
    80002b46:	854a                	mv	a0,s2
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	988080e7          	jalr	-1656(ra) # 800024d0 <brelse>
}
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	64a2                	ld	s1,8(sp)
    80002b56:	6902                	ld	s2,0(sp)
    80002b58:	6105                	addi	sp,sp,32
    80002b5a:	8082                	ret

0000000080002b5c <idup>:
{
    80002b5c:	1101                	addi	sp,sp,-32
    80002b5e:	ec06                	sd	ra,24(sp)
    80002b60:	e822                	sd	s0,16(sp)
    80002b62:	e426                	sd	s1,8(sp)
    80002b64:	1000                	addi	s0,sp,32
    80002b66:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b68:	0001d517          	auipc	a0,0x1d
    80002b6c:	81050513          	addi	a0,a0,-2032 # 8001f378 <itable>
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	796080e7          	jalr	1942(ra) # 80006306 <acquire>
  ip->ref++;
    80002b78:	449c                	lw	a5,8(s1)
    80002b7a:	2785                	addiw	a5,a5,1
    80002b7c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b7e:	0001c517          	auipc	a0,0x1c
    80002b82:	7fa50513          	addi	a0,a0,2042 # 8001f378 <itable>
    80002b86:	00004097          	auipc	ra,0x4
    80002b8a:	834080e7          	jalr	-1996(ra) # 800063ba <release>
}
    80002b8e:	8526                	mv	a0,s1
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6105                	addi	sp,sp,32
    80002b98:	8082                	ret

0000000080002b9a <ilock>:
{
    80002b9a:	1101                	addi	sp,sp,-32
    80002b9c:	ec06                	sd	ra,24(sp)
    80002b9e:	e822                	sd	s0,16(sp)
    80002ba0:	e426                	sd	s1,8(sp)
    80002ba2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ba4:	c10d                	beqz	a0,80002bc6 <ilock+0x2c>
    80002ba6:	84aa                	mv	s1,a0
    80002ba8:	451c                	lw	a5,8(a0)
    80002baa:	00f05e63          	blez	a5,80002bc6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002bae:	0541                	addi	a0,a0,16
    80002bb0:	00001097          	auipc	ra,0x1
    80002bb4:	cb2080e7          	jalr	-846(ra) # 80003862 <acquiresleep>
  if(ip->valid == 0){
    80002bb8:	40bc                	lw	a5,64(s1)
    80002bba:	cf99                	beqz	a5,80002bd8 <ilock+0x3e>
}
    80002bbc:	60e2                	ld	ra,24(sp)
    80002bbe:	6442                	ld	s0,16(sp)
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret
    80002bc6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	88850513          	addi	a0,a0,-1912 # 80008450 <etext+0x450>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	1e6080e7          	jalr	486(ra) # 80005db6 <panic>
    80002bd8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bda:	40dc                	lw	a5,4(s1)
    80002bdc:	0047d79b          	srliw	a5,a5,0x4
    80002be0:	0001c597          	auipc	a1,0x1c
    80002be4:	7905a583          	lw	a1,1936(a1) # 8001f370 <sb+0x18>
    80002be8:	9dbd                	addw	a1,a1,a5
    80002bea:	4088                	lw	a0,0(s1)
    80002bec:	fffff097          	auipc	ra,0xfffff
    80002bf0:	7b4080e7          	jalr	1972(ra) # 800023a0 <bread>
    80002bf4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf6:	05850593          	addi	a1,a0,88
    80002bfa:	40dc                	lw	a5,4(s1)
    80002bfc:	8bbd                	andi	a5,a5,15
    80002bfe:	079a                	slli	a5,a5,0x6
    80002c00:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c02:	00059783          	lh	a5,0(a1)
    80002c06:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c0a:	00259783          	lh	a5,2(a1)
    80002c0e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c12:	00459783          	lh	a5,4(a1)
    80002c16:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c1a:	00659783          	lh	a5,6(a1)
    80002c1e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c22:	459c                	lw	a5,8(a1)
    80002c24:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c26:	03400613          	li	a2,52
    80002c2a:	05b1                	addi	a1,a1,12
    80002c2c:	05048513          	addi	a0,s1,80
    80002c30:	ffffd097          	auipc	ra,0xffffd
    80002c34:	5a6080e7          	jalr	1446(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c38:	854a                	mv	a0,s2
    80002c3a:	00000097          	auipc	ra,0x0
    80002c3e:	896080e7          	jalr	-1898(ra) # 800024d0 <brelse>
    ip->valid = 1;
    80002c42:	4785                	li	a5,1
    80002c44:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c46:	04449783          	lh	a5,68(s1)
    80002c4a:	c399                	beqz	a5,80002c50 <ilock+0xb6>
    80002c4c:	6902                	ld	s2,0(sp)
    80002c4e:	b7bd                	j	80002bbc <ilock+0x22>
      panic("ilock: no type");
    80002c50:	00006517          	auipc	a0,0x6
    80002c54:	80850513          	addi	a0,a0,-2040 # 80008458 <etext+0x458>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	15e080e7          	jalr	350(ra) # 80005db6 <panic>

0000000080002c60 <iunlock>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c6c:	c905                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c6e:	84aa                	mv	s1,a0
    80002c70:	01050913          	addi	s2,a0,16
    80002c74:	854a                	mv	a0,s2
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	c86080e7          	jalr	-890(ra) # 800038fc <holdingsleep>
    80002c7e:	cd19                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c80:	449c                	lw	a5,8(s1)
    80002c82:	00f05d63          	blez	a5,80002c9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c86:	854a                	mv	a0,s2
    80002c88:	00001097          	auipc	ra,0x1
    80002c8c:	c30080e7          	jalr	-976(ra) # 800038b8 <releasesleep>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    panic("iunlock");
    80002c9c:	00005517          	auipc	a0,0x5
    80002ca0:	7cc50513          	addi	a0,a0,1996 # 80008468 <etext+0x468>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	112080e7          	jalr	274(ra) # 80005db6 <panic>

0000000080002cac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cac:	7179                	addi	sp,sp,-48
    80002cae:	f406                	sd	ra,40(sp)
    80002cb0:	f022                	sd	s0,32(sp)
    80002cb2:	ec26                	sd	s1,24(sp)
    80002cb4:	e84a                	sd	s2,16(sp)
    80002cb6:	e44e                	sd	s3,8(sp)
    80002cb8:	1800                	addi	s0,sp,48
    80002cba:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cbc:	05050493          	addi	s1,a0,80
    80002cc0:	08050913          	addi	s2,a0,128
    80002cc4:	a021                	j	80002ccc <itrunc+0x20>
    80002cc6:	0491                	addi	s1,s1,4
    80002cc8:	01248d63          	beq	s1,s2,80002ce2 <itrunc+0x36>
    if(ip->addrs[i]){
    80002ccc:	408c                	lw	a1,0(s1)
    80002cce:	dde5                	beqz	a1,80002cc6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002cd0:	0009a503          	lw	a0,0(s3)
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	910080e7          	jalr	-1776(ra) # 800025e4 <bfree>
      ip->addrs[i] = 0;
    80002cdc:	0004a023          	sw	zero,0(s1)
    80002ce0:	b7dd                	j	80002cc6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ce2:	0809a583          	lw	a1,128(s3)
    80002ce6:	ed99                	bnez	a1,80002d04 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ce8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cec:	854e                	mv	a0,s3
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	de0080e7          	jalr	-544(ra) # 80002ace <iupdate>
}
    80002cf6:	70a2                	ld	ra,40(sp)
    80002cf8:	7402                	ld	s0,32(sp)
    80002cfa:	64e2                	ld	s1,24(sp)
    80002cfc:	6942                	ld	s2,16(sp)
    80002cfe:	69a2                	ld	s3,8(sp)
    80002d00:	6145                	addi	sp,sp,48
    80002d02:	8082                	ret
    80002d04:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d06:	0009a503          	lw	a0,0(s3)
    80002d0a:	fffff097          	auipc	ra,0xfffff
    80002d0e:	696080e7          	jalr	1686(ra) # 800023a0 <bread>
    80002d12:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d14:	05850493          	addi	s1,a0,88
    80002d18:	45850913          	addi	s2,a0,1112
    80002d1c:	a021                	j	80002d24 <itrunc+0x78>
    80002d1e:	0491                	addi	s1,s1,4
    80002d20:	01248b63          	beq	s1,s2,80002d36 <itrunc+0x8a>
      if(a[j])
    80002d24:	408c                	lw	a1,0(s1)
    80002d26:	dde5                	beqz	a1,80002d1e <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d28:	0009a503          	lw	a0,0(s3)
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	8b8080e7          	jalr	-1864(ra) # 800025e4 <bfree>
    80002d34:	b7ed                	j	80002d1e <itrunc+0x72>
    brelse(bp);
    80002d36:	8552                	mv	a0,s4
    80002d38:	fffff097          	auipc	ra,0xfffff
    80002d3c:	798080e7          	jalr	1944(ra) # 800024d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d40:	0809a583          	lw	a1,128(s3)
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	89c080e7          	jalr	-1892(ra) # 800025e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d50:	0809a023          	sw	zero,128(s3)
    80002d54:	6a02                	ld	s4,0(sp)
    80002d56:	bf49                	j	80002ce8 <itrunc+0x3c>

0000000080002d58 <iput>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	1000                	addi	s0,sp,32
    80002d62:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d64:	0001c517          	auipc	a0,0x1c
    80002d68:	61450513          	addi	a0,a0,1556 # 8001f378 <itable>
    80002d6c:	00003097          	auipc	ra,0x3
    80002d70:	59a080e7          	jalr	1434(ra) # 80006306 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d74:	4498                	lw	a4,8(s1)
    80002d76:	4785                	li	a5,1
    80002d78:	02f70263          	beq	a4,a5,80002d9c <iput+0x44>
  ip->ref--;
    80002d7c:	449c                	lw	a5,8(s1)
    80002d7e:	37fd                	addiw	a5,a5,-1
    80002d80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d82:	0001c517          	auipc	a0,0x1c
    80002d86:	5f650513          	addi	a0,a0,1526 # 8001f378 <itable>
    80002d8a:	00003097          	auipc	ra,0x3
    80002d8e:	630080e7          	jalr	1584(ra) # 800063ba <release>
}
    80002d92:	60e2                	ld	ra,24(sp)
    80002d94:	6442                	ld	s0,16(sp)
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9c:	40bc                	lw	a5,64(s1)
    80002d9e:	dff9                	beqz	a5,80002d7c <iput+0x24>
    80002da0:	04a49783          	lh	a5,74(s1)
    80002da4:	ffe1                	bnez	a5,80002d7c <iput+0x24>
    80002da6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002da8:	01048913          	addi	s2,s1,16
    80002dac:	854a                	mv	a0,s2
    80002dae:	00001097          	auipc	ra,0x1
    80002db2:	ab4080e7          	jalr	-1356(ra) # 80003862 <acquiresleep>
    release(&itable.lock);
    80002db6:	0001c517          	auipc	a0,0x1c
    80002dba:	5c250513          	addi	a0,a0,1474 # 8001f378 <itable>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	5fc080e7          	jalr	1532(ra) # 800063ba <release>
    itrunc(ip);
    80002dc6:	8526                	mv	a0,s1
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	ee4080e7          	jalr	-284(ra) # 80002cac <itrunc>
    ip->type = 0;
    80002dd0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dd4:	8526                	mv	a0,s1
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	cf8080e7          	jalr	-776(ra) # 80002ace <iupdate>
    ip->valid = 0;
    80002dde:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	ad4080e7          	jalr	-1324(ra) # 800038b8 <releasesleep>
    acquire(&itable.lock);
    80002dec:	0001c517          	auipc	a0,0x1c
    80002df0:	58c50513          	addi	a0,a0,1420 # 8001f378 <itable>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	512080e7          	jalr	1298(ra) # 80006306 <acquire>
    80002dfc:	6902                	ld	s2,0(sp)
    80002dfe:	bfbd                	j	80002d7c <iput+0x24>

0000000080002e00 <iunlockput>:
{
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	e426                	sd	s1,8(sp)
    80002e08:	1000                	addi	s0,sp,32
    80002e0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	e54080e7          	jalr	-428(ra) # 80002c60 <iunlock>
  iput(ip);
    80002e14:	8526                	mv	a0,s1
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	f42080e7          	jalr	-190(ra) # 80002d58 <iput>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e28:	1141                	addi	sp,sp,-16
    80002e2a:	e422                	sd	s0,8(sp)
    80002e2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e2e:	411c                	lw	a5,0(a0)
    80002e30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e32:	415c                	lw	a5,4(a0)
    80002e34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e36:	04451783          	lh	a5,68(a0)
    80002e3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e3e:	04a51783          	lh	a5,74(a0)
    80002e42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e46:	04c56783          	lwu	a5,76(a0)
    80002e4a:	e99c                	sd	a5,16(a1)
}
    80002e4c:	6422                	ld	s0,8(sp)
    80002e4e:	0141                	addi	sp,sp,16
    80002e50:	8082                	ret

0000000080002e52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e52:	457c                	lw	a5,76(a0)
    80002e54:	0ed7ef63          	bltu	a5,a3,80002f52 <readi+0x100>
{
    80002e58:	7159                	addi	sp,sp,-112
    80002e5a:	f486                	sd	ra,104(sp)
    80002e5c:	f0a2                	sd	s0,96(sp)
    80002e5e:	eca6                	sd	s1,88(sp)
    80002e60:	fc56                	sd	s5,56(sp)
    80002e62:	f85a                	sd	s6,48(sp)
    80002e64:	f45e                	sd	s7,40(sp)
    80002e66:	f062                	sd	s8,32(sp)
    80002e68:	1880                	addi	s0,sp,112
    80002e6a:	8baa                	mv	s7,a0
    80002e6c:	8c2e                	mv	s8,a1
    80002e6e:	8ab2                	mv	s5,a2
    80002e70:	84b6                	mv	s1,a3
    80002e72:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e74:	9f35                	addw	a4,a4,a3
    return 0;
    80002e76:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e78:	0ad76c63          	bltu	a4,a3,80002f30 <readi+0xde>
    80002e7c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002e7e:	00e7f463          	bgeu	a5,a4,80002e86 <readi+0x34>
    n = ip->size - off;
    80002e82:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e86:	0c0b0463          	beqz	s6,80002f4e <readi+0xfc>
    80002e8a:	e8ca                	sd	s2,80(sp)
    80002e8c:	e0d2                	sd	s4,64(sp)
    80002e8e:	ec66                	sd	s9,24(sp)
    80002e90:	e86a                	sd	s10,16(sp)
    80002e92:	e46e                	sd	s11,8(sp)
    80002e94:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e96:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e9a:	5cfd                	li	s9,-1
    80002e9c:	a82d                	j	80002ed6 <readi+0x84>
    80002e9e:	020a1d93          	slli	s11,s4,0x20
    80002ea2:	020ddd93          	srli	s11,s11,0x20
    80002ea6:	05890613          	addi	a2,s2,88
    80002eaa:	86ee                	mv	a3,s11
    80002eac:	963a                	add	a2,a2,a4
    80002eae:	85d6                	mv	a1,s5
    80002eb0:	8562                	mv	a0,s8
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	a46080e7          	jalr	-1466(ra) # 800018f8 <either_copyout>
    80002eba:	05950d63          	beq	a0,s9,80002f14 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	fffff097          	auipc	ra,0xfffff
    80002ec4:	610080e7          	jalr	1552(ra) # 800024d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec8:	013a09bb          	addw	s3,s4,s3
    80002ecc:	009a04bb          	addw	s1,s4,s1
    80002ed0:	9aee                	add	s5,s5,s11
    80002ed2:	0769f863          	bgeu	s3,s6,80002f42 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ed6:	000ba903          	lw	s2,0(s7)
    80002eda:	00a4d59b          	srliw	a1,s1,0xa
    80002ede:	855e                	mv	a0,s7
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	8ae080e7          	jalr	-1874(ra) # 8000278e <bmap>
    80002ee8:	0005059b          	sext.w	a1,a0
    80002eec:	854a                	mv	a0,s2
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	4b2080e7          	jalr	1202(ra) # 800023a0 <bread>
    80002ef6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef8:	3ff4f713          	andi	a4,s1,1023
    80002efc:	40ed07bb          	subw	a5,s10,a4
    80002f00:	413b06bb          	subw	a3,s6,s3
    80002f04:	8a3e                	mv	s4,a5
    80002f06:	2781                	sext.w	a5,a5
    80002f08:	0006861b          	sext.w	a2,a3
    80002f0c:	f8f679e3          	bgeu	a2,a5,80002e9e <readi+0x4c>
    80002f10:	8a36                	mv	s4,a3
    80002f12:	b771                	j	80002e9e <readi+0x4c>
      brelse(bp);
    80002f14:	854a                	mv	a0,s2
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	5ba080e7          	jalr	1466(ra) # 800024d0 <brelse>
      tot = -1;
    80002f1e:	59fd                	li	s3,-1
      break;
    80002f20:	6946                	ld	s2,80(sp)
    80002f22:	6a06                	ld	s4,64(sp)
    80002f24:	6ce2                	ld	s9,24(sp)
    80002f26:	6d42                	ld	s10,16(sp)
    80002f28:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f2a:	0009851b          	sext.w	a0,s3
    80002f2e:	69a6                	ld	s3,72(sp)
}
    80002f30:	70a6                	ld	ra,104(sp)
    80002f32:	7406                	ld	s0,96(sp)
    80002f34:	64e6                	ld	s1,88(sp)
    80002f36:	7ae2                	ld	s5,56(sp)
    80002f38:	7b42                	ld	s6,48(sp)
    80002f3a:	7ba2                	ld	s7,40(sp)
    80002f3c:	7c02                	ld	s8,32(sp)
    80002f3e:	6165                	addi	sp,sp,112
    80002f40:	8082                	ret
    80002f42:	6946                	ld	s2,80(sp)
    80002f44:	6a06                	ld	s4,64(sp)
    80002f46:	6ce2                	ld	s9,24(sp)
    80002f48:	6d42                	ld	s10,16(sp)
    80002f4a:	6da2                	ld	s11,8(sp)
    80002f4c:	bff9                	j	80002f2a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4e:	89da                	mv	s3,s6
    80002f50:	bfe9                	j	80002f2a <readi+0xd8>
    return 0;
    80002f52:	4501                	li	a0,0
}
    80002f54:	8082                	ret

0000000080002f56 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f56:	457c                	lw	a5,76(a0)
    80002f58:	10d7ee63          	bltu	a5,a3,80003074 <writei+0x11e>
{
    80002f5c:	7159                	addi	sp,sp,-112
    80002f5e:	f486                	sd	ra,104(sp)
    80002f60:	f0a2                	sd	s0,96(sp)
    80002f62:	e8ca                	sd	s2,80(sp)
    80002f64:	fc56                	sd	s5,56(sp)
    80002f66:	f85a                	sd	s6,48(sp)
    80002f68:	f45e                	sd	s7,40(sp)
    80002f6a:	f062                	sd	s8,32(sp)
    80002f6c:	1880                	addi	s0,sp,112
    80002f6e:	8b2a                	mv	s6,a0
    80002f70:	8c2e                	mv	s8,a1
    80002f72:	8ab2                	mv	s5,a2
    80002f74:	8936                	mv	s2,a3
    80002f76:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f78:	00e687bb          	addw	a5,a3,a4
    80002f7c:	0ed7ee63          	bltu	a5,a3,80003078 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f80:	00043737          	lui	a4,0x43
    80002f84:	0ef76c63          	bltu	a4,a5,8000307c <writei+0x126>
    80002f88:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8a:	0c0b8d63          	beqz	s7,80003064 <writei+0x10e>
    80002f8e:	eca6                	sd	s1,88(sp)
    80002f90:	e4ce                	sd	s3,72(sp)
    80002f92:	ec66                	sd	s9,24(sp)
    80002f94:	e86a                	sd	s10,16(sp)
    80002f96:	e46e                	sd	s11,8(sp)
    80002f98:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f9a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f9e:	5cfd                	li	s9,-1
    80002fa0:	a091                	j	80002fe4 <writei+0x8e>
    80002fa2:	02099d93          	slli	s11,s3,0x20
    80002fa6:	020ddd93          	srli	s11,s11,0x20
    80002faa:	05848513          	addi	a0,s1,88
    80002fae:	86ee                	mv	a3,s11
    80002fb0:	8656                	mv	a2,s5
    80002fb2:	85e2                	mv	a1,s8
    80002fb4:	953a                	add	a0,a0,a4
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	998080e7          	jalr	-1640(ra) # 8000194e <either_copyin>
    80002fbe:	07950263          	beq	a0,s9,80003022 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fc2:	8526                	mv	a0,s1
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	780080e7          	jalr	1920(ra) # 80003744 <log_write>
    brelse(bp);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	502080e7          	jalr	1282(ra) # 800024d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd6:	01498a3b          	addw	s4,s3,s4
    80002fda:	0129893b          	addw	s2,s3,s2
    80002fde:	9aee                	add	s5,s5,s11
    80002fe0:	057a7663          	bgeu	s4,s7,8000302c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fe4:	000b2483          	lw	s1,0(s6)
    80002fe8:	00a9559b          	srliw	a1,s2,0xa
    80002fec:	855a                	mv	a0,s6
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	7a0080e7          	jalr	1952(ra) # 8000278e <bmap>
    80002ff6:	0005059b          	sext.w	a1,a0
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	3a4080e7          	jalr	932(ra) # 800023a0 <bread>
    80003004:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003006:	3ff97713          	andi	a4,s2,1023
    8000300a:	40ed07bb          	subw	a5,s10,a4
    8000300e:	414b86bb          	subw	a3,s7,s4
    80003012:	89be                	mv	s3,a5
    80003014:	2781                	sext.w	a5,a5
    80003016:	0006861b          	sext.w	a2,a3
    8000301a:	f8f674e3          	bgeu	a2,a5,80002fa2 <writei+0x4c>
    8000301e:	89b6                	mv	s3,a3
    80003020:	b749                	j	80002fa2 <writei+0x4c>
      brelse(bp);
    80003022:	8526                	mv	a0,s1
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	4ac080e7          	jalr	1196(ra) # 800024d0 <brelse>
  }

  if(off > ip->size)
    8000302c:	04cb2783          	lw	a5,76(s6)
    80003030:	0327fc63          	bgeu	a5,s2,80003068 <writei+0x112>
    ip->size = off;
    80003034:	052b2623          	sw	s2,76(s6)
    80003038:	64e6                	ld	s1,88(sp)
    8000303a:	69a6                	ld	s3,72(sp)
    8000303c:	6ce2                	ld	s9,24(sp)
    8000303e:	6d42                	ld	s10,16(sp)
    80003040:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003042:	855a                	mv	a0,s6
    80003044:	00000097          	auipc	ra,0x0
    80003048:	a8a080e7          	jalr	-1398(ra) # 80002ace <iupdate>

  return tot;
    8000304c:	000a051b          	sext.w	a0,s4
    80003050:	6a06                	ld	s4,64(sp)
}
    80003052:	70a6                	ld	ra,104(sp)
    80003054:	7406                	ld	s0,96(sp)
    80003056:	6946                	ld	s2,80(sp)
    80003058:	7ae2                	ld	s5,56(sp)
    8000305a:	7b42                	ld	s6,48(sp)
    8000305c:	7ba2                	ld	s7,40(sp)
    8000305e:	7c02                	ld	s8,32(sp)
    80003060:	6165                	addi	sp,sp,112
    80003062:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003064:	8a5e                	mv	s4,s7
    80003066:	bff1                	j	80003042 <writei+0xec>
    80003068:	64e6                	ld	s1,88(sp)
    8000306a:	69a6                	ld	s3,72(sp)
    8000306c:	6ce2                	ld	s9,24(sp)
    8000306e:	6d42                	ld	s10,16(sp)
    80003070:	6da2                	ld	s11,8(sp)
    80003072:	bfc1                	j	80003042 <writei+0xec>
    return -1;
    80003074:	557d                	li	a0,-1
}
    80003076:	8082                	ret
    return -1;
    80003078:	557d                	li	a0,-1
    8000307a:	bfe1                	j	80003052 <writei+0xfc>
    return -1;
    8000307c:	557d                	li	a0,-1
    8000307e:	bfd1                	j	80003052 <writei+0xfc>

0000000080003080 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003080:	1141                	addi	sp,sp,-16
    80003082:	e406                	sd	ra,8(sp)
    80003084:	e022                	sd	s0,0(sp)
    80003086:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003088:	4639                	li	a2,14
    8000308a:	ffffd097          	auipc	ra,0xffffd
    8000308e:	1c0080e7          	jalr	448(ra) # 8000024a <strncmp>
}
    80003092:	60a2                	ld	ra,8(sp)
    80003094:	6402                	ld	s0,0(sp)
    80003096:	0141                	addi	sp,sp,16
    80003098:	8082                	ret

000000008000309a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000309a:	7139                	addi	sp,sp,-64
    8000309c:	fc06                	sd	ra,56(sp)
    8000309e:	f822                	sd	s0,48(sp)
    800030a0:	f426                	sd	s1,40(sp)
    800030a2:	f04a                	sd	s2,32(sp)
    800030a4:	ec4e                	sd	s3,24(sp)
    800030a6:	e852                	sd	s4,16(sp)
    800030a8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030aa:	04451703          	lh	a4,68(a0)
    800030ae:	4785                	li	a5,1
    800030b0:	00f71a63          	bne	a4,a5,800030c4 <dirlookup+0x2a>
    800030b4:	892a                	mv	s2,a0
    800030b6:	89ae                	mv	s3,a1
    800030b8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ba:	457c                	lw	a5,76(a0)
    800030bc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030be:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c0:	e79d                	bnez	a5,800030ee <dirlookup+0x54>
    800030c2:	a8a5                	j	8000313a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030c4:	00005517          	auipc	a0,0x5
    800030c8:	3ac50513          	addi	a0,a0,940 # 80008470 <etext+0x470>
    800030cc:	00003097          	auipc	ra,0x3
    800030d0:	cea080e7          	jalr	-790(ra) # 80005db6 <panic>
      panic("dirlookup read");
    800030d4:	00005517          	auipc	a0,0x5
    800030d8:	3b450513          	addi	a0,a0,948 # 80008488 <etext+0x488>
    800030dc:	00003097          	auipc	ra,0x3
    800030e0:	cda080e7          	jalr	-806(ra) # 80005db6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e4:	24c1                	addiw	s1,s1,16
    800030e6:	04c92783          	lw	a5,76(s2)
    800030ea:	04f4f763          	bgeu	s1,a5,80003138 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ee:	4741                	li	a4,16
    800030f0:	86a6                	mv	a3,s1
    800030f2:	fc040613          	addi	a2,s0,-64
    800030f6:	4581                	li	a1,0
    800030f8:	854a                	mv	a0,s2
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	d58080e7          	jalr	-680(ra) # 80002e52 <readi>
    80003102:	47c1                	li	a5,16
    80003104:	fcf518e3          	bne	a0,a5,800030d4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003108:	fc045783          	lhu	a5,-64(s0)
    8000310c:	dfe1                	beqz	a5,800030e4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000310e:	fc240593          	addi	a1,s0,-62
    80003112:	854e                	mv	a0,s3
    80003114:	00000097          	auipc	ra,0x0
    80003118:	f6c080e7          	jalr	-148(ra) # 80003080 <namecmp>
    8000311c:	f561                	bnez	a0,800030e4 <dirlookup+0x4a>
      if(poff)
    8000311e:	000a0463          	beqz	s4,80003126 <dirlookup+0x8c>
        *poff = off;
    80003122:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003126:	fc045583          	lhu	a1,-64(s0)
    8000312a:	00092503          	lw	a0,0(s2)
    8000312e:	fffff097          	auipc	ra,0xfffff
    80003132:	73c080e7          	jalr	1852(ra) # 8000286a <iget>
    80003136:	a011                	j	8000313a <dirlookup+0xa0>
  return 0;
    80003138:	4501                	li	a0,0
}
    8000313a:	70e2                	ld	ra,56(sp)
    8000313c:	7442                	ld	s0,48(sp)
    8000313e:	74a2                	ld	s1,40(sp)
    80003140:	7902                	ld	s2,32(sp)
    80003142:	69e2                	ld	s3,24(sp)
    80003144:	6a42                	ld	s4,16(sp)
    80003146:	6121                	addi	sp,sp,64
    80003148:	8082                	ret

000000008000314a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000314a:	711d                	addi	sp,sp,-96
    8000314c:	ec86                	sd	ra,88(sp)
    8000314e:	e8a2                	sd	s0,80(sp)
    80003150:	e4a6                	sd	s1,72(sp)
    80003152:	e0ca                	sd	s2,64(sp)
    80003154:	fc4e                	sd	s3,56(sp)
    80003156:	f852                	sd	s4,48(sp)
    80003158:	f456                	sd	s5,40(sp)
    8000315a:	f05a                	sd	s6,32(sp)
    8000315c:	ec5e                	sd	s7,24(sp)
    8000315e:	e862                	sd	s8,16(sp)
    80003160:	e466                	sd	s9,8(sp)
    80003162:	1080                	addi	s0,sp,96
    80003164:	84aa                	mv	s1,a0
    80003166:	8b2e                	mv	s6,a1
    80003168:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000316a:	00054703          	lbu	a4,0(a0)
    8000316e:	02f00793          	li	a5,47
    80003172:	02f70263          	beq	a4,a5,80003196 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003176:	ffffe097          	auipc	ra,0xffffe
    8000317a:	d06080e7          	jalr	-762(ra) # 80000e7c <myproc>
    8000317e:	15053503          	ld	a0,336(a0)
    80003182:	00000097          	auipc	ra,0x0
    80003186:	9da080e7          	jalr	-1574(ra) # 80002b5c <idup>
    8000318a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000318c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003190:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003192:	4b85                	li	s7,1
    80003194:	a875                	j	80003250 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003196:	4585                	li	a1,1
    80003198:	4505                	li	a0,1
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	6d0080e7          	jalr	1744(ra) # 8000286a <iget>
    800031a2:	8a2a                	mv	s4,a0
    800031a4:	b7e5                	j	8000318c <namex+0x42>
      iunlockput(ip);
    800031a6:	8552                	mv	a0,s4
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	c58080e7          	jalr	-936(ra) # 80002e00 <iunlockput>
      return 0;
    800031b0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031b2:	8552                	mv	a0,s4
    800031b4:	60e6                	ld	ra,88(sp)
    800031b6:	6446                	ld	s0,80(sp)
    800031b8:	64a6                	ld	s1,72(sp)
    800031ba:	6906                	ld	s2,64(sp)
    800031bc:	79e2                	ld	s3,56(sp)
    800031be:	7a42                	ld	s4,48(sp)
    800031c0:	7aa2                	ld	s5,40(sp)
    800031c2:	7b02                	ld	s6,32(sp)
    800031c4:	6be2                	ld	s7,24(sp)
    800031c6:	6c42                	ld	s8,16(sp)
    800031c8:	6ca2                	ld	s9,8(sp)
    800031ca:	6125                	addi	sp,sp,96
    800031cc:	8082                	ret
      iunlock(ip);
    800031ce:	8552                	mv	a0,s4
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	a90080e7          	jalr	-1392(ra) # 80002c60 <iunlock>
      return ip;
    800031d8:	bfe9                	j	800031b2 <namex+0x68>
      iunlockput(ip);
    800031da:	8552                	mv	a0,s4
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	c24080e7          	jalr	-988(ra) # 80002e00 <iunlockput>
      return 0;
    800031e4:	8a4e                	mv	s4,s3
    800031e6:	b7f1                	j	800031b2 <namex+0x68>
  len = path - s;
    800031e8:	40998633          	sub	a2,s3,s1
    800031ec:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031f0:	099c5863          	bge	s8,s9,80003280 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800031f4:	4639                	li	a2,14
    800031f6:	85a6                	mv	a1,s1
    800031f8:	8556                	mv	a0,s5
    800031fa:	ffffd097          	auipc	ra,0xffffd
    800031fe:	fdc080e7          	jalr	-36(ra) # 800001d6 <memmove>
    80003202:	84ce                	mv	s1,s3
  while(*path == '/')
    80003204:	0004c783          	lbu	a5,0(s1)
    80003208:	01279763          	bne	a5,s2,80003216 <namex+0xcc>
    path++;
    8000320c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	ff278de3          	beq	a5,s2,8000320c <namex+0xc2>
    ilock(ip);
    80003216:	8552                	mv	a0,s4
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	982080e7          	jalr	-1662(ra) # 80002b9a <ilock>
    if(ip->type != T_DIR){
    80003220:	044a1783          	lh	a5,68(s4)
    80003224:	f97791e3          	bne	a5,s7,800031a6 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003228:	000b0563          	beqz	s6,80003232 <namex+0xe8>
    8000322c:	0004c783          	lbu	a5,0(s1)
    80003230:	dfd9                	beqz	a5,800031ce <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003232:	4601                	li	a2,0
    80003234:	85d6                	mv	a1,s5
    80003236:	8552                	mv	a0,s4
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	e62080e7          	jalr	-414(ra) # 8000309a <dirlookup>
    80003240:	89aa                	mv	s3,a0
    80003242:	dd41                	beqz	a0,800031da <namex+0x90>
    iunlockput(ip);
    80003244:	8552                	mv	a0,s4
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	bba080e7          	jalr	-1094(ra) # 80002e00 <iunlockput>
    ip = next;
    8000324e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003250:	0004c783          	lbu	a5,0(s1)
    80003254:	01279763          	bne	a5,s2,80003262 <namex+0x118>
    path++;
    80003258:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	ff278de3          	beq	a5,s2,80003258 <namex+0x10e>
  if(*path == 0)
    80003262:	cb9d                	beqz	a5,80003298 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	89a6                	mv	s3,s1
  len = path - s;
    8000326a:	4c81                	li	s9,0
    8000326c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000326e:	01278963          	beq	a5,s2,80003280 <namex+0x136>
    80003272:	dbbd                	beqz	a5,800031e8 <namex+0x9e>
    path++;
    80003274:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003276:	0009c783          	lbu	a5,0(s3)
    8000327a:	ff279ce3          	bne	a5,s2,80003272 <namex+0x128>
    8000327e:	b7ad                	j	800031e8 <namex+0x9e>
    memmove(name, s, len);
    80003280:	2601                	sext.w	a2,a2
    80003282:	85a6                	mv	a1,s1
    80003284:	8556                	mv	a0,s5
    80003286:	ffffd097          	auipc	ra,0xffffd
    8000328a:	f50080e7          	jalr	-176(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000328e:	9cd6                	add	s9,s9,s5
    80003290:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003294:	84ce                	mv	s1,s3
    80003296:	b7bd                	j	80003204 <namex+0xba>
  if(nameiparent){
    80003298:	f00b0de3          	beqz	s6,800031b2 <namex+0x68>
    iput(ip);
    8000329c:	8552                	mv	a0,s4
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	aba080e7          	jalr	-1350(ra) # 80002d58 <iput>
    return 0;
    800032a6:	4a01                	li	s4,0
    800032a8:	b729                	j	800031b2 <namex+0x68>

00000000800032aa <dirlink>:
{
    800032aa:	7139                	addi	sp,sp,-64
    800032ac:	fc06                	sd	ra,56(sp)
    800032ae:	f822                	sd	s0,48(sp)
    800032b0:	f04a                	sd	s2,32(sp)
    800032b2:	ec4e                	sd	s3,24(sp)
    800032b4:	e852                	sd	s4,16(sp)
    800032b6:	0080                	addi	s0,sp,64
    800032b8:	892a                	mv	s2,a0
    800032ba:	8a2e                	mv	s4,a1
    800032bc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032be:	4601                	li	a2,0
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	dda080e7          	jalr	-550(ra) # 8000309a <dirlookup>
    800032c8:	ed25                	bnez	a0,80003340 <dirlink+0x96>
    800032ca:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032cc:	04c92483          	lw	s1,76(s2)
    800032d0:	c49d                	beqz	s1,800032fe <dirlink+0x54>
    800032d2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d4:	4741                	li	a4,16
    800032d6:	86a6                	mv	a3,s1
    800032d8:	fc040613          	addi	a2,s0,-64
    800032dc:	4581                	li	a1,0
    800032de:	854a                	mv	a0,s2
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	b72080e7          	jalr	-1166(ra) # 80002e52 <readi>
    800032e8:	47c1                	li	a5,16
    800032ea:	06f51163          	bne	a0,a5,8000334c <dirlink+0xa2>
    if(de.inum == 0)
    800032ee:	fc045783          	lhu	a5,-64(s0)
    800032f2:	c791                	beqz	a5,800032fe <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f4:	24c1                	addiw	s1,s1,16
    800032f6:	04c92783          	lw	a5,76(s2)
    800032fa:	fcf4ede3          	bltu	s1,a5,800032d4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032fe:	4639                	li	a2,14
    80003300:	85d2                	mv	a1,s4
    80003302:	fc240513          	addi	a0,s0,-62
    80003306:	ffffd097          	auipc	ra,0xffffd
    8000330a:	f7a080e7          	jalr	-134(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000330e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003312:	4741                	li	a4,16
    80003314:	86a6                	mv	a3,s1
    80003316:	fc040613          	addi	a2,s0,-64
    8000331a:	4581                	li	a1,0
    8000331c:	854a                	mv	a0,s2
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	c38080e7          	jalr	-968(ra) # 80002f56 <writei>
    80003326:	872a                	mv	a4,a0
    80003328:	47c1                	li	a5,16
  return 0;
    8000332a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000332c:	02f71863          	bne	a4,a5,8000335c <dirlink+0xb2>
    80003330:	74a2                	ld	s1,40(sp)
}
    80003332:	70e2                	ld	ra,56(sp)
    80003334:	7442                	ld	s0,48(sp)
    80003336:	7902                	ld	s2,32(sp)
    80003338:	69e2                	ld	s3,24(sp)
    8000333a:	6a42                	ld	s4,16(sp)
    8000333c:	6121                	addi	sp,sp,64
    8000333e:	8082                	ret
    iput(ip);
    80003340:	00000097          	auipc	ra,0x0
    80003344:	a18080e7          	jalr	-1512(ra) # 80002d58 <iput>
    return -1;
    80003348:	557d                	li	a0,-1
    8000334a:	b7e5                	j	80003332 <dirlink+0x88>
      panic("dirlink read");
    8000334c:	00005517          	auipc	a0,0x5
    80003350:	14c50513          	addi	a0,a0,332 # 80008498 <etext+0x498>
    80003354:	00003097          	auipc	ra,0x3
    80003358:	a62080e7          	jalr	-1438(ra) # 80005db6 <panic>
    panic("dirlink");
    8000335c:	00005517          	auipc	a0,0x5
    80003360:	24c50513          	addi	a0,a0,588 # 800085a8 <etext+0x5a8>
    80003364:	00003097          	auipc	ra,0x3
    80003368:	a52080e7          	jalr	-1454(ra) # 80005db6 <panic>

000000008000336c <namei>:

struct inode*
namei(char *path)
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003374:	fe040613          	addi	a2,s0,-32
    80003378:	4581                	li	a1,0
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	dd0080e7          	jalr	-560(ra) # 8000314a <namex>
}
    80003382:	60e2                	ld	ra,24(sp)
    80003384:	6442                	ld	s0,16(sp)
    80003386:	6105                	addi	sp,sp,32
    80003388:	8082                	ret

000000008000338a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000338a:	1141                	addi	sp,sp,-16
    8000338c:	e406                	sd	ra,8(sp)
    8000338e:	e022                	sd	s0,0(sp)
    80003390:	0800                	addi	s0,sp,16
    80003392:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003394:	4585                	li	a1,1
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	db4080e7          	jalr	-588(ra) # 8000314a <namex>
}
    8000339e:	60a2                	ld	ra,8(sp)
    800033a0:	6402                	ld	s0,0(sp)
    800033a2:	0141                	addi	sp,sp,16
    800033a4:	8082                	ret

00000000800033a6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033a6:	1101                	addi	sp,sp,-32
    800033a8:	ec06                	sd	ra,24(sp)
    800033aa:	e822                	sd	s0,16(sp)
    800033ac:	e426                	sd	s1,8(sp)
    800033ae:	e04a                	sd	s2,0(sp)
    800033b0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033b2:	0001e917          	auipc	s2,0x1e
    800033b6:	a6e90913          	addi	s2,s2,-1426 # 80020e20 <log>
    800033ba:	01892583          	lw	a1,24(s2)
    800033be:	02892503          	lw	a0,40(s2)
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	fde080e7          	jalr	-34(ra) # 800023a0 <bread>
    800033ca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033cc:	02c92603          	lw	a2,44(s2)
    800033d0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033d2:	00c05f63          	blez	a2,800033f0 <write_head+0x4a>
    800033d6:	0001e717          	auipc	a4,0x1e
    800033da:	a7a70713          	addi	a4,a4,-1414 # 80020e50 <log+0x30>
    800033de:	87aa                	mv	a5,a0
    800033e0:	060a                	slli	a2,a2,0x2
    800033e2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800033e4:	4314                	lw	a3,0(a4)
    800033e6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800033e8:	0711                	addi	a4,a4,4
    800033ea:	0791                	addi	a5,a5,4
    800033ec:	fec79ce3          	bne	a5,a2,800033e4 <write_head+0x3e>
  }
  bwrite(buf);
    800033f0:	8526                	mv	a0,s1
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	0a0080e7          	jalr	160(ra) # 80002492 <bwrite>
  brelse(buf);
    800033fa:	8526                	mv	a0,s1
    800033fc:	fffff097          	auipc	ra,0xfffff
    80003400:	0d4080e7          	jalr	212(ra) # 800024d0 <brelse>
}
    80003404:	60e2                	ld	ra,24(sp)
    80003406:	6442                	ld	s0,16(sp)
    80003408:	64a2                	ld	s1,8(sp)
    8000340a:	6902                	ld	s2,0(sp)
    8000340c:	6105                	addi	sp,sp,32
    8000340e:	8082                	ret

0000000080003410 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003410:	0001e797          	auipc	a5,0x1e
    80003414:	a3c7a783          	lw	a5,-1476(a5) # 80020e4c <log+0x2c>
    80003418:	0af05d63          	blez	a5,800034d2 <install_trans+0xc2>
{
    8000341c:	7139                	addi	sp,sp,-64
    8000341e:	fc06                	sd	ra,56(sp)
    80003420:	f822                	sd	s0,48(sp)
    80003422:	f426                	sd	s1,40(sp)
    80003424:	f04a                	sd	s2,32(sp)
    80003426:	ec4e                	sd	s3,24(sp)
    80003428:	e852                	sd	s4,16(sp)
    8000342a:	e456                	sd	s5,8(sp)
    8000342c:	e05a                	sd	s6,0(sp)
    8000342e:	0080                	addi	s0,sp,64
    80003430:	8b2a                	mv	s6,a0
    80003432:	0001ea97          	auipc	s5,0x1e
    80003436:	a1ea8a93          	addi	s5,s5,-1506 # 80020e50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000343c:	0001e997          	auipc	s3,0x1e
    80003440:	9e498993          	addi	s3,s3,-1564 # 80020e20 <log>
    80003444:	a00d                	j	80003466 <install_trans+0x56>
    brelse(lbuf);
    80003446:	854a                	mv	a0,s2
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	088080e7          	jalr	136(ra) # 800024d0 <brelse>
    brelse(dbuf);
    80003450:	8526                	mv	a0,s1
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	07e080e7          	jalr	126(ra) # 800024d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345a:	2a05                	addiw	s4,s4,1
    8000345c:	0a91                	addi	s5,s5,4
    8000345e:	02c9a783          	lw	a5,44(s3)
    80003462:	04fa5e63          	bge	s4,a5,800034be <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003466:	0189a583          	lw	a1,24(s3)
    8000346a:	014585bb          	addw	a1,a1,s4
    8000346e:	2585                	addiw	a1,a1,1
    80003470:	0289a503          	lw	a0,40(s3)
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	f2c080e7          	jalr	-212(ra) # 800023a0 <bread>
    8000347c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000347e:	000aa583          	lw	a1,0(s5)
    80003482:	0289a503          	lw	a0,40(s3)
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f1a080e7          	jalr	-230(ra) # 800023a0 <bread>
    8000348e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003490:	40000613          	li	a2,1024
    80003494:	05890593          	addi	a1,s2,88
    80003498:	05850513          	addi	a0,a0,88
    8000349c:	ffffd097          	auipc	ra,0xffffd
    800034a0:	d3a080e7          	jalr	-710(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a4:	8526                	mv	a0,s1
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	fec080e7          	jalr	-20(ra) # 80002492 <bwrite>
    if(recovering == 0)
    800034ae:	f80b1ce3          	bnez	s6,80003446 <install_trans+0x36>
      bunpin(dbuf);
    800034b2:	8526                	mv	a0,s1
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	0f4080e7          	jalr	244(ra) # 800025a8 <bunpin>
    800034bc:	b769                	j	80003446 <install_trans+0x36>
}
    800034be:	70e2                	ld	ra,56(sp)
    800034c0:	7442                	ld	s0,48(sp)
    800034c2:	74a2                	ld	s1,40(sp)
    800034c4:	7902                	ld	s2,32(sp)
    800034c6:	69e2                	ld	s3,24(sp)
    800034c8:	6a42                	ld	s4,16(sp)
    800034ca:	6aa2                	ld	s5,8(sp)
    800034cc:	6b02                	ld	s6,0(sp)
    800034ce:	6121                	addi	sp,sp,64
    800034d0:	8082                	ret
    800034d2:	8082                	ret

00000000800034d4 <initlog>:
{
    800034d4:	7179                	addi	sp,sp,-48
    800034d6:	f406                	sd	ra,40(sp)
    800034d8:	f022                	sd	s0,32(sp)
    800034da:	ec26                	sd	s1,24(sp)
    800034dc:	e84a                	sd	s2,16(sp)
    800034de:	e44e                	sd	s3,8(sp)
    800034e0:	1800                	addi	s0,sp,48
    800034e2:	892a                	mv	s2,a0
    800034e4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e6:	0001e497          	auipc	s1,0x1e
    800034ea:	93a48493          	addi	s1,s1,-1734 # 80020e20 <log>
    800034ee:	00005597          	auipc	a1,0x5
    800034f2:	fba58593          	addi	a1,a1,-70 # 800084a8 <etext+0x4a8>
    800034f6:	8526                	mv	a0,s1
    800034f8:	00003097          	auipc	ra,0x3
    800034fc:	d7e080e7          	jalr	-642(ra) # 80006276 <initlock>
  log.start = sb->logstart;
    80003500:	0149a583          	lw	a1,20(s3)
    80003504:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003506:	0109a783          	lw	a5,16(s3)
    8000350a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000350c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003510:	854a                	mv	a0,s2
    80003512:	fffff097          	auipc	ra,0xfffff
    80003516:	e8e080e7          	jalr	-370(ra) # 800023a0 <bread>
  log.lh.n = lh->n;
    8000351a:	4d30                	lw	a2,88(a0)
    8000351c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000351e:	00c05f63          	blez	a2,8000353c <initlog+0x68>
    80003522:	87aa                	mv	a5,a0
    80003524:	0001e717          	auipc	a4,0x1e
    80003528:	92c70713          	addi	a4,a4,-1748 # 80020e50 <log+0x30>
    8000352c:	060a                	slli	a2,a2,0x2
    8000352e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003530:	4ff4                	lw	a3,92(a5)
    80003532:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003534:	0791                	addi	a5,a5,4
    80003536:	0711                	addi	a4,a4,4
    80003538:	fec79ce3          	bne	a5,a2,80003530 <initlog+0x5c>
  brelse(buf);
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	f94080e7          	jalr	-108(ra) # 800024d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003544:	4505                	li	a0,1
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	eca080e7          	jalr	-310(ra) # 80003410 <install_trans>
  log.lh.n = 0;
    8000354e:	0001e797          	auipc	a5,0x1e
    80003552:	8e07af23          	sw	zero,-1794(a5) # 80020e4c <log+0x2c>
  write_head(); // clear the log
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	e50080e7          	jalr	-432(ra) # 800033a6 <write_head>
}
    8000355e:	70a2                	ld	ra,40(sp)
    80003560:	7402                	ld	s0,32(sp)
    80003562:	64e2                	ld	s1,24(sp)
    80003564:	6942                	ld	s2,16(sp)
    80003566:	69a2                	ld	s3,8(sp)
    80003568:	6145                	addi	sp,sp,48
    8000356a:	8082                	ret

000000008000356c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	e426                	sd	s1,8(sp)
    80003574:	e04a                	sd	s2,0(sp)
    80003576:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003578:	0001e517          	auipc	a0,0x1e
    8000357c:	8a850513          	addi	a0,a0,-1880 # 80020e20 <log>
    80003580:	00003097          	auipc	ra,0x3
    80003584:	d86080e7          	jalr	-634(ra) # 80006306 <acquire>
  while(1){
    if(log.committing){
    80003588:	0001e497          	auipc	s1,0x1e
    8000358c:	89848493          	addi	s1,s1,-1896 # 80020e20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003590:	4979                	li	s2,30
    80003592:	a039                	j	800035a0 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003594:	85a6                	mv	a1,s1
    80003596:	8526                	mv	a0,s1
    80003598:	ffffe097          	auipc	ra,0xffffe
    8000359c:	fbc080e7          	jalr	-68(ra) # 80001554 <sleep>
    if(log.committing){
    800035a0:	50dc                	lw	a5,36(s1)
    800035a2:	fbed                	bnez	a5,80003594 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a4:	5098                	lw	a4,32(s1)
    800035a6:	2705                	addiw	a4,a4,1
    800035a8:	0027179b          	slliw	a5,a4,0x2
    800035ac:	9fb9                	addw	a5,a5,a4
    800035ae:	0017979b          	slliw	a5,a5,0x1
    800035b2:	54d4                	lw	a3,44(s1)
    800035b4:	9fb5                	addw	a5,a5,a3
    800035b6:	00f95963          	bge	s2,a5,800035c8 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ba:	85a6                	mv	a1,s1
    800035bc:	8526                	mv	a0,s1
    800035be:	ffffe097          	auipc	ra,0xffffe
    800035c2:	f96080e7          	jalr	-106(ra) # 80001554 <sleep>
    800035c6:	bfe9                	j	800035a0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035c8:	0001e517          	auipc	a0,0x1e
    800035cc:	85850513          	addi	a0,a0,-1960 # 80020e20 <log>
    800035d0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035d2:	00003097          	auipc	ra,0x3
    800035d6:	de8080e7          	jalr	-536(ra) # 800063ba <release>
      break;
    }
  }
}
    800035da:	60e2                	ld	ra,24(sp)
    800035dc:	6442                	ld	s0,16(sp)
    800035de:	64a2                	ld	s1,8(sp)
    800035e0:	6902                	ld	s2,0(sp)
    800035e2:	6105                	addi	sp,sp,32
    800035e4:	8082                	ret

00000000800035e6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e6:	7139                	addi	sp,sp,-64
    800035e8:	fc06                	sd	ra,56(sp)
    800035ea:	f822                	sd	s0,48(sp)
    800035ec:	f426                	sd	s1,40(sp)
    800035ee:	f04a                	sd	s2,32(sp)
    800035f0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035f2:	0001e497          	auipc	s1,0x1e
    800035f6:	82e48493          	addi	s1,s1,-2002 # 80020e20 <log>
    800035fa:	8526                	mv	a0,s1
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	d0a080e7          	jalr	-758(ra) # 80006306 <acquire>
  log.outstanding -= 1;
    80003604:	509c                	lw	a5,32(s1)
    80003606:	37fd                	addiw	a5,a5,-1
    80003608:	0007891b          	sext.w	s2,a5
    8000360c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000360e:	50dc                	lw	a5,36(s1)
    80003610:	e7b9                	bnez	a5,8000365e <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003612:	06091163          	bnez	s2,80003674 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003616:	0001e497          	auipc	s1,0x1e
    8000361a:	80a48493          	addi	s1,s1,-2038 # 80020e20 <log>
    8000361e:	4785                	li	a5,1
    80003620:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003622:	8526                	mv	a0,s1
    80003624:	00003097          	auipc	ra,0x3
    80003628:	d96080e7          	jalr	-618(ra) # 800063ba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000362c:	54dc                	lw	a5,44(s1)
    8000362e:	06f04763          	bgtz	a5,8000369c <end_op+0xb6>
    acquire(&log.lock);
    80003632:	0001d497          	auipc	s1,0x1d
    80003636:	7ee48493          	addi	s1,s1,2030 # 80020e20 <log>
    8000363a:	8526                	mv	a0,s1
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	cca080e7          	jalr	-822(ra) # 80006306 <acquire>
    log.committing = 0;
    80003644:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003648:	8526                	mv	a0,s1
    8000364a:	ffffe097          	auipc	ra,0xffffe
    8000364e:	096080e7          	jalr	150(ra) # 800016e0 <wakeup>
    release(&log.lock);
    80003652:	8526                	mv	a0,s1
    80003654:	00003097          	auipc	ra,0x3
    80003658:	d66080e7          	jalr	-666(ra) # 800063ba <release>
}
    8000365c:	a815                	j	80003690 <end_op+0xaa>
    8000365e:	ec4e                	sd	s3,24(sp)
    80003660:	e852                	sd	s4,16(sp)
    80003662:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003664:	00005517          	auipc	a0,0x5
    80003668:	e4c50513          	addi	a0,a0,-436 # 800084b0 <etext+0x4b0>
    8000366c:	00002097          	auipc	ra,0x2
    80003670:	74a080e7          	jalr	1866(ra) # 80005db6 <panic>
    wakeup(&log);
    80003674:	0001d497          	auipc	s1,0x1d
    80003678:	7ac48493          	addi	s1,s1,1964 # 80020e20 <log>
    8000367c:	8526                	mv	a0,s1
    8000367e:	ffffe097          	auipc	ra,0xffffe
    80003682:	062080e7          	jalr	98(ra) # 800016e0 <wakeup>
  release(&log.lock);
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	d32080e7          	jalr	-718(ra) # 800063ba <release>
}
    80003690:	70e2                	ld	ra,56(sp)
    80003692:	7442                	ld	s0,48(sp)
    80003694:	74a2                	ld	s1,40(sp)
    80003696:	7902                	ld	s2,32(sp)
    80003698:	6121                	addi	sp,sp,64
    8000369a:	8082                	ret
    8000369c:	ec4e                	sd	s3,24(sp)
    8000369e:	e852                	sd	s4,16(sp)
    800036a0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a2:	0001da97          	auipc	s5,0x1d
    800036a6:	7aea8a93          	addi	s5,s5,1966 # 80020e50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036aa:	0001da17          	auipc	s4,0x1d
    800036ae:	776a0a13          	addi	s4,s4,1910 # 80020e20 <log>
    800036b2:	018a2583          	lw	a1,24(s4)
    800036b6:	012585bb          	addw	a1,a1,s2
    800036ba:	2585                	addiw	a1,a1,1
    800036bc:	028a2503          	lw	a0,40(s4)
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	ce0080e7          	jalr	-800(ra) # 800023a0 <bread>
    800036c8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ca:	000aa583          	lw	a1,0(s5)
    800036ce:	028a2503          	lw	a0,40(s4)
    800036d2:	fffff097          	auipc	ra,0xfffff
    800036d6:	cce080e7          	jalr	-818(ra) # 800023a0 <bread>
    800036da:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036dc:	40000613          	li	a2,1024
    800036e0:	05850593          	addi	a1,a0,88
    800036e4:	05848513          	addi	a0,s1,88
    800036e8:	ffffd097          	auipc	ra,0xffffd
    800036ec:	aee080e7          	jalr	-1298(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036f0:	8526                	mv	a0,s1
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	da0080e7          	jalr	-608(ra) # 80002492 <bwrite>
    brelse(from);
    800036fa:	854e                	mv	a0,s3
    800036fc:	fffff097          	auipc	ra,0xfffff
    80003700:	dd4080e7          	jalr	-556(ra) # 800024d0 <brelse>
    brelse(to);
    80003704:	8526                	mv	a0,s1
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	dca080e7          	jalr	-566(ra) # 800024d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370e:	2905                	addiw	s2,s2,1
    80003710:	0a91                	addi	s5,s5,4
    80003712:	02ca2783          	lw	a5,44(s4)
    80003716:	f8f94ee3          	blt	s2,a5,800036b2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000371a:	00000097          	auipc	ra,0x0
    8000371e:	c8c080e7          	jalr	-884(ra) # 800033a6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003722:	4501                	li	a0,0
    80003724:	00000097          	auipc	ra,0x0
    80003728:	cec080e7          	jalr	-788(ra) # 80003410 <install_trans>
    log.lh.n = 0;
    8000372c:	0001d797          	auipc	a5,0x1d
    80003730:	7207a023          	sw	zero,1824(a5) # 80020e4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003734:	00000097          	auipc	ra,0x0
    80003738:	c72080e7          	jalr	-910(ra) # 800033a6 <write_head>
    8000373c:	69e2                	ld	s3,24(sp)
    8000373e:	6a42                	ld	s4,16(sp)
    80003740:	6aa2                	ld	s5,8(sp)
    80003742:	bdc5                	j	80003632 <end_op+0x4c>

0000000080003744 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	e426                	sd	s1,8(sp)
    8000374c:	e04a                	sd	s2,0(sp)
    8000374e:	1000                	addi	s0,sp,32
    80003750:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003752:	0001d917          	auipc	s2,0x1d
    80003756:	6ce90913          	addi	s2,s2,1742 # 80020e20 <log>
    8000375a:	854a                	mv	a0,s2
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	baa080e7          	jalr	-1110(ra) # 80006306 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003764:	02c92603          	lw	a2,44(s2)
    80003768:	47f5                	li	a5,29
    8000376a:	06c7c563          	blt	a5,a2,800037d4 <log_write+0x90>
    8000376e:	0001d797          	auipc	a5,0x1d
    80003772:	6ce7a783          	lw	a5,1742(a5) # 80020e3c <log+0x1c>
    80003776:	37fd                	addiw	a5,a5,-1
    80003778:	04f65e63          	bge	a2,a5,800037d4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000377c:	0001d797          	auipc	a5,0x1d
    80003780:	6c47a783          	lw	a5,1732(a5) # 80020e40 <log+0x20>
    80003784:	06f05063          	blez	a5,800037e4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003788:	4781                	li	a5,0
    8000378a:	06c05563          	blez	a2,800037f4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378e:	44cc                	lw	a1,12(s1)
    80003790:	0001d717          	auipc	a4,0x1d
    80003794:	6c070713          	addi	a4,a4,1728 # 80020e50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003798:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379a:	4314                	lw	a3,0(a4)
    8000379c:	04b68c63          	beq	a3,a1,800037f4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037a0:	2785                	addiw	a5,a5,1
    800037a2:	0711                	addi	a4,a4,4
    800037a4:	fef61be3          	bne	a2,a5,8000379a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a8:	0621                	addi	a2,a2,8
    800037aa:	060a                	slli	a2,a2,0x2
    800037ac:	0001d797          	auipc	a5,0x1d
    800037b0:	67478793          	addi	a5,a5,1652 # 80020e20 <log>
    800037b4:	97b2                	add	a5,a5,a2
    800037b6:	44d8                	lw	a4,12(s1)
    800037b8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ba:	8526                	mv	a0,s1
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	db0080e7          	jalr	-592(ra) # 8000256c <bpin>
    log.lh.n++;
    800037c4:	0001d717          	auipc	a4,0x1d
    800037c8:	65c70713          	addi	a4,a4,1628 # 80020e20 <log>
    800037cc:	575c                	lw	a5,44(a4)
    800037ce:	2785                	addiw	a5,a5,1
    800037d0:	d75c                	sw	a5,44(a4)
    800037d2:	a82d                	j	8000380c <log_write+0xc8>
    panic("too big a transaction");
    800037d4:	00005517          	auipc	a0,0x5
    800037d8:	cec50513          	addi	a0,a0,-788 # 800084c0 <etext+0x4c0>
    800037dc:	00002097          	auipc	ra,0x2
    800037e0:	5da080e7          	jalr	1498(ra) # 80005db6 <panic>
    panic("log_write outside of trans");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	cf450513          	addi	a0,a0,-780 # 800084d8 <etext+0x4d8>
    800037ec:	00002097          	auipc	ra,0x2
    800037f0:	5ca080e7          	jalr	1482(ra) # 80005db6 <panic>
  log.lh.block[i] = b->blockno;
    800037f4:	00878693          	addi	a3,a5,8
    800037f8:	068a                	slli	a3,a3,0x2
    800037fa:	0001d717          	auipc	a4,0x1d
    800037fe:	62670713          	addi	a4,a4,1574 # 80020e20 <log>
    80003802:	9736                	add	a4,a4,a3
    80003804:	44d4                	lw	a3,12(s1)
    80003806:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003808:	faf609e3          	beq	a2,a5,800037ba <log_write+0x76>
  }
  release(&log.lock);
    8000380c:	0001d517          	auipc	a0,0x1d
    80003810:	61450513          	addi	a0,a0,1556 # 80020e20 <log>
    80003814:	00003097          	auipc	ra,0x3
    80003818:	ba6080e7          	jalr	-1114(ra) # 800063ba <release>
}
    8000381c:	60e2                	ld	ra,24(sp)
    8000381e:	6442                	ld	s0,16(sp)
    80003820:	64a2                	ld	s1,8(sp)
    80003822:	6902                	ld	s2,0(sp)
    80003824:	6105                	addi	sp,sp,32
    80003826:	8082                	ret

0000000080003828 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003828:	1101                	addi	sp,sp,-32
    8000382a:	ec06                	sd	ra,24(sp)
    8000382c:	e822                	sd	s0,16(sp)
    8000382e:	e426                	sd	s1,8(sp)
    80003830:	e04a                	sd	s2,0(sp)
    80003832:	1000                	addi	s0,sp,32
    80003834:	84aa                	mv	s1,a0
    80003836:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003838:	00005597          	auipc	a1,0x5
    8000383c:	cc058593          	addi	a1,a1,-832 # 800084f8 <etext+0x4f8>
    80003840:	0521                	addi	a0,a0,8
    80003842:	00003097          	auipc	ra,0x3
    80003846:	a34080e7          	jalr	-1484(ra) # 80006276 <initlock>
  lk->name = name;
    8000384a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000384e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003852:	0204a423          	sw	zero,40(s1)
}
    80003856:	60e2                	ld	ra,24(sp)
    80003858:	6442                	ld	s0,16(sp)
    8000385a:	64a2                	ld	s1,8(sp)
    8000385c:	6902                	ld	s2,0(sp)
    8000385e:	6105                	addi	sp,sp,32
    80003860:	8082                	ret

0000000080003862 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003862:	1101                	addi	sp,sp,-32
    80003864:	ec06                	sd	ra,24(sp)
    80003866:	e822                	sd	s0,16(sp)
    80003868:	e426                	sd	s1,8(sp)
    8000386a:	e04a                	sd	s2,0(sp)
    8000386c:	1000                	addi	s0,sp,32
    8000386e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003870:	00850913          	addi	s2,a0,8
    80003874:	854a                	mv	a0,s2
    80003876:	00003097          	auipc	ra,0x3
    8000387a:	a90080e7          	jalr	-1392(ra) # 80006306 <acquire>
  while (lk->locked) {
    8000387e:	409c                	lw	a5,0(s1)
    80003880:	cb89                	beqz	a5,80003892 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003882:	85ca                	mv	a1,s2
    80003884:	8526                	mv	a0,s1
    80003886:	ffffe097          	auipc	ra,0xffffe
    8000388a:	cce080e7          	jalr	-818(ra) # 80001554 <sleep>
  while (lk->locked) {
    8000388e:	409c                	lw	a5,0(s1)
    80003890:	fbed                	bnez	a5,80003882 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003892:	4785                	li	a5,1
    80003894:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003896:	ffffd097          	auipc	ra,0xffffd
    8000389a:	5e6080e7          	jalr	1510(ra) # 80000e7c <myproc>
    8000389e:	591c                	lw	a5,48(a0)
    800038a0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038a2:	854a                	mv	a0,s2
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	b16080e7          	jalr	-1258(ra) # 800063ba <release>
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret

00000000800038b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	a3a080e7          	jalr	-1478(ra) # 80006306 <acquire>
  lk->locked = 0;
    800038d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038dc:	8526                	mv	a0,s1
    800038de:	ffffe097          	auipc	ra,0xffffe
    800038e2:	e02080e7          	jalr	-510(ra) # 800016e0 <wakeup>
  release(&lk->lk);
    800038e6:	854a                	mv	a0,s2
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	ad2080e7          	jalr	-1326(ra) # 800063ba <release>
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038fc:	7179                	addi	sp,sp,-48
    800038fe:	f406                	sd	ra,40(sp)
    80003900:	f022                	sd	s0,32(sp)
    80003902:	ec26                	sd	s1,24(sp)
    80003904:	e84a                	sd	s2,16(sp)
    80003906:	1800                	addi	s0,sp,48
    80003908:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000390a:	00850913          	addi	s2,a0,8
    8000390e:	854a                	mv	a0,s2
    80003910:	00003097          	auipc	ra,0x3
    80003914:	9f6080e7          	jalr	-1546(ra) # 80006306 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003918:	409c                	lw	a5,0(s1)
    8000391a:	ef91                	bnez	a5,80003936 <holdingsleep+0x3a>
    8000391c:	4481                	li	s1,0
  release(&lk->lk);
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	a9a080e7          	jalr	-1382(ra) # 800063ba <release>
  return r;
}
    80003928:	8526                	mv	a0,s1
    8000392a:	70a2                	ld	ra,40(sp)
    8000392c:	7402                	ld	s0,32(sp)
    8000392e:	64e2                	ld	s1,24(sp)
    80003930:	6942                	ld	s2,16(sp)
    80003932:	6145                	addi	sp,sp,48
    80003934:	8082                	ret
    80003936:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003938:	0284a983          	lw	s3,40(s1)
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	540080e7          	jalr	1344(ra) # 80000e7c <myproc>
    80003944:	5904                	lw	s1,48(a0)
    80003946:	413484b3          	sub	s1,s1,s3
    8000394a:	0014b493          	seqz	s1,s1
    8000394e:	69a2                	ld	s3,8(sp)
    80003950:	b7f9                	j	8000391e <holdingsleep+0x22>

0000000080003952 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003952:	1141                	addi	sp,sp,-16
    80003954:	e406                	sd	ra,8(sp)
    80003956:	e022                	sd	s0,0(sp)
    80003958:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000395a:	00005597          	auipc	a1,0x5
    8000395e:	bae58593          	addi	a1,a1,-1106 # 80008508 <etext+0x508>
    80003962:	0001d517          	auipc	a0,0x1d
    80003966:	60650513          	addi	a0,a0,1542 # 80020f68 <ftable>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	90c080e7          	jalr	-1780(ra) # 80006276 <initlock>
}
    80003972:	60a2                	ld	ra,8(sp)
    80003974:	6402                	ld	s0,0(sp)
    80003976:	0141                	addi	sp,sp,16
    80003978:	8082                	ret

000000008000397a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000397a:	1101                	addi	sp,sp,-32
    8000397c:	ec06                	sd	ra,24(sp)
    8000397e:	e822                	sd	s0,16(sp)
    80003980:	e426                	sd	s1,8(sp)
    80003982:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003984:	0001d517          	auipc	a0,0x1d
    80003988:	5e450513          	addi	a0,a0,1508 # 80020f68 <ftable>
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	97a080e7          	jalr	-1670(ra) # 80006306 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003994:	0001d497          	auipc	s1,0x1d
    80003998:	5ec48493          	addi	s1,s1,1516 # 80020f80 <ftable+0x18>
    8000399c:	0001e717          	auipc	a4,0x1e
    800039a0:	58470713          	addi	a4,a4,1412 # 80021f20 <ftable+0xfb8>
    if(f->ref == 0){
    800039a4:	40dc                	lw	a5,4(s1)
    800039a6:	cf99                	beqz	a5,800039c4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a8:	02848493          	addi	s1,s1,40
    800039ac:	fee49ce3          	bne	s1,a4,800039a4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039b0:	0001d517          	auipc	a0,0x1d
    800039b4:	5b850513          	addi	a0,a0,1464 # 80020f68 <ftable>
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	a02080e7          	jalr	-1534(ra) # 800063ba <release>
  return 0;
    800039c0:	4481                	li	s1,0
    800039c2:	a819                	j	800039d8 <filealloc+0x5e>
      f->ref = 1;
    800039c4:	4785                	li	a5,1
    800039c6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039c8:	0001d517          	auipc	a0,0x1d
    800039cc:	5a050513          	addi	a0,a0,1440 # 80020f68 <ftable>
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	9ea080e7          	jalr	-1558(ra) # 800063ba <release>
}
    800039d8:	8526                	mv	a0,s1
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6105                	addi	sp,sp,32
    800039e2:	8082                	ret

00000000800039e4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	1000                	addi	s0,sp,32
    800039ee:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039f0:	0001d517          	auipc	a0,0x1d
    800039f4:	57850513          	addi	a0,a0,1400 # 80020f68 <ftable>
    800039f8:	00003097          	auipc	ra,0x3
    800039fc:	90e080e7          	jalr	-1778(ra) # 80006306 <acquire>
  if(f->ref < 1)
    80003a00:	40dc                	lw	a5,4(s1)
    80003a02:	02f05263          	blez	a5,80003a26 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a06:	2785                	addiw	a5,a5,1
    80003a08:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a0a:	0001d517          	auipc	a0,0x1d
    80003a0e:	55e50513          	addi	a0,a0,1374 # 80020f68 <ftable>
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	9a8080e7          	jalr	-1624(ra) # 800063ba <release>
  return f;
}
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	60e2                	ld	ra,24(sp)
    80003a1e:	6442                	ld	s0,16(sp)
    80003a20:	64a2                	ld	s1,8(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret
    panic("filedup");
    80003a26:	00005517          	auipc	a0,0x5
    80003a2a:	aea50513          	addi	a0,a0,-1302 # 80008510 <etext+0x510>
    80003a2e:	00002097          	auipc	ra,0x2
    80003a32:	388080e7          	jalr	904(ra) # 80005db6 <panic>

0000000080003a36 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a36:	7139                	addi	sp,sp,-64
    80003a38:	fc06                	sd	ra,56(sp)
    80003a3a:	f822                	sd	s0,48(sp)
    80003a3c:	f426                	sd	s1,40(sp)
    80003a3e:	0080                	addi	s0,sp,64
    80003a40:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a42:	0001d517          	auipc	a0,0x1d
    80003a46:	52650513          	addi	a0,a0,1318 # 80020f68 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	8bc080e7          	jalr	-1860(ra) # 80006306 <acquire>
  if(f->ref < 1)
    80003a52:	40dc                	lw	a5,4(s1)
    80003a54:	04f05c63          	blez	a5,80003aac <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003a58:	37fd                	addiw	a5,a5,-1
    80003a5a:	0007871b          	sext.w	a4,a5
    80003a5e:	c0dc                	sw	a5,4(s1)
    80003a60:	06e04263          	bgtz	a4,80003ac4 <fileclose+0x8e>
    80003a64:	f04a                	sd	s2,32(sp)
    80003a66:	ec4e                	sd	s3,24(sp)
    80003a68:	e852                	sd	s4,16(sp)
    80003a6a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a6c:	0004a903          	lw	s2,0(s1)
    80003a70:	0094ca83          	lbu	s5,9(s1)
    80003a74:	0104ba03          	ld	s4,16(s1)
    80003a78:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a7c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a80:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a84:	0001d517          	auipc	a0,0x1d
    80003a88:	4e450513          	addi	a0,a0,1252 # 80020f68 <ftable>
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	92e080e7          	jalr	-1746(ra) # 800063ba <release>

  if(ff.type == FD_PIPE){
    80003a94:	4785                	li	a5,1
    80003a96:	04f90463          	beq	s2,a5,80003ade <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a9a:	3979                	addiw	s2,s2,-2
    80003a9c:	4785                	li	a5,1
    80003a9e:	0527fb63          	bgeu	a5,s2,80003af4 <fileclose+0xbe>
    80003aa2:	7902                	ld	s2,32(sp)
    80003aa4:	69e2                	ld	s3,24(sp)
    80003aa6:	6a42                	ld	s4,16(sp)
    80003aa8:	6aa2                	ld	s5,8(sp)
    80003aaa:	a02d                	j	80003ad4 <fileclose+0x9e>
    80003aac:	f04a                	sd	s2,32(sp)
    80003aae:	ec4e                	sd	s3,24(sp)
    80003ab0:	e852                	sd	s4,16(sp)
    80003ab2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	a6450513          	addi	a0,a0,-1436 # 80008518 <etext+0x518>
    80003abc:	00002097          	auipc	ra,0x2
    80003ac0:	2fa080e7          	jalr	762(ra) # 80005db6 <panic>
    release(&ftable.lock);
    80003ac4:	0001d517          	auipc	a0,0x1d
    80003ac8:	4a450513          	addi	a0,a0,1188 # 80020f68 <ftable>
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	8ee080e7          	jalr	-1810(ra) # 800063ba <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003ad4:	70e2                	ld	ra,56(sp)
    80003ad6:	7442                	ld	s0,48(sp)
    80003ad8:	74a2                	ld	s1,40(sp)
    80003ada:	6121                	addi	sp,sp,64
    80003adc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ade:	85d6                	mv	a1,s5
    80003ae0:	8552                	mv	a0,s4
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	3a2080e7          	jalr	930(ra) # 80003e84 <pipeclose>
    80003aea:	7902                	ld	s2,32(sp)
    80003aec:	69e2                	ld	s3,24(sp)
    80003aee:	6a42                	ld	s4,16(sp)
    80003af0:	6aa2                	ld	s5,8(sp)
    80003af2:	b7cd                	j	80003ad4 <fileclose+0x9e>
    begin_op();
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	a78080e7          	jalr	-1416(ra) # 8000356c <begin_op>
    iput(ff.ip);
    80003afc:	854e                	mv	a0,s3
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	25a080e7          	jalr	602(ra) # 80002d58 <iput>
    end_op();
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	ae0080e7          	jalr	-1312(ra) # 800035e6 <end_op>
    80003b0e:	7902                	ld	s2,32(sp)
    80003b10:	69e2                	ld	s3,24(sp)
    80003b12:	6a42                	ld	s4,16(sp)
    80003b14:	6aa2                	ld	s5,8(sp)
    80003b16:	bf7d                	j	80003ad4 <fileclose+0x9e>

0000000080003b18 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b18:	715d                	addi	sp,sp,-80
    80003b1a:	e486                	sd	ra,72(sp)
    80003b1c:	e0a2                	sd	s0,64(sp)
    80003b1e:	fc26                	sd	s1,56(sp)
    80003b20:	f44e                	sd	s3,40(sp)
    80003b22:	0880                	addi	s0,sp,80
    80003b24:	84aa                	mv	s1,a0
    80003b26:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	354080e7          	jalr	852(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b30:	409c                	lw	a5,0(s1)
    80003b32:	37f9                	addiw	a5,a5,-2
    80003b34:	4705                	li	a4,1
    80003b36:	04f76863          	bltu	a4,a5,80003b86 <filestat+0x6e>
    80003b3a:	f84a                	sd	s2,48(sp)
    80003b3c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b3e:	6c88                	ld	a0,24(s1)
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	05a080e7          	jalr	90(ra) # 80002b9a <ilock>
    stati(f->ip, &st);
    80003b48:	fb840593          	addi	a1,s0,-72
    80003b4c:	6c88                	ld	a0,24(s1)
    80003b4e:	fffff097          	auipc	ra,0xfffff
    80003b52:	2da080e7          	jalr	730(ra) # 80002e28 <stati>
    iunlock(f->ip);
    80003b56:	6c88                	ld	a0,24(s1)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	108080e7          	jalr	264(ra) # 80002c60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b60:	46e1                	li	a3,24
    80003b62:	fb840613          	addi	a2,s0,-72
    80003b66:	85ce                	mv	a1,s3
    80003b68:	05093503          	ld	a0,80(s2)
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	fac080e7          	jalr	-84(ra) # 80000b18 <copyout>
    80003b74:	41f5551b          	sraiw	a0,a0,0x1f
    80003b78:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b7a:	60a6                	ld	ra,72(sp)
    80003b7c:	6406                	ld	s0,64(sp)
    80003b7e:	74e2                	ld	s1,56(sp)
    80003b80:	79a2                	ld	s3,40(sp)
    80003b82:	6161                	addi	sp,sp,80
    80003b84:	8082                	ret
  return -1;
    80003b86:	557d                	li	a0,-1
    80003b88:	bfcd                	j	80003b7a <filestat+0x62>

0000000080003b8a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b8a:	7179                	addi	sp,sp,-48
    80003b8c:	f406                	sd	ra,40(sp)
    80003b8e:	f022                	sd	s0,32(sp)
    80003b90:	e84a                	sd	s2,16(sp)
    80003b92:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b94:	00854783          	lbu	a5,8(a0)
    80003b98:	cbc5                	beqz	a5,80003c48 <fileread+0xbe>
    80003b9a:	ec26                	sd	s1,24(sp)
    80003b9c:	e44e                	sd	s3,8(sp)
    80003b9e:	84aa                	mv	s1,a0
    80003ba0:	89ae                	mv	s3,a1
    80003ba2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ba4:	411c                	lw	a5,0(a0)
    80003ba6:	4705                	li	a4,1
    80003ba8:	04e78963          	beq	a5,a4,80003bfa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bac:	470d                	li	a4,3
    80003bae:	04e78f63          	beq	a5,a4,80003c0c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bb2:	4709                	li	a4,2
    80003bb4:	08e79263          	bne	a5,a4,80003c38 <fileread+0xae>
    ilock(f->ip);
    80003bb8:	6d08                	ld	a0,24(a0)
    80003bba:	fffff097          	auipc	ra,0xfffff
    80003bbe:	fe0080e7          	jalr	-32(ra) # 80002b9a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bc2:	874a                	mv	a4,s2
    80003bc4:	5094                	lw	a3,32(s1)
    80003bc6:	864e                	mv	a2,s3
    80003bc8:	4585                	li	a1,1
    80003bca:	6c88                	ld	a0,24(s1)
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	286080e7          	jalr	646(ra) # 80002e52 <readi>
    80003bd4:	892a                	mv	s2,a0
    80003bd6:	00a05563          	blez	a0,80003be0 <fileread+0x56>
      f->off += r;
    80003bda:	509c                	lw	a5,32(s1)
    80003bdc:	9fa9                	addw	a5,a5,a0
    80003bde:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	07e080e7          	jalr	126(ra) # 80002c60 <iunlock>
    80003bea:	64e2                	ld	s1,24(sp)
    80003bec:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003bee:	854a                	mv	a0,s2
    80003bf0:	70a2                	ld	ra,40(sp)
    80003bf2:	7402                	ld	s0,32(sp)
    80003bf4:	6942                	ld	s2,16(sp)
    80003bf6:	6145                	addi	sp,sp,48
    80003bf8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bfa:	6908                	ld	a0,16(a0)
    80003bfc:	00000097          	auipc	ra,0x0
    80003c00:	3fa080e7          	jalr	1018(ra) # 80003ff6 <piperead>
    80003c04:	892a                	mv	s2,a0
    80003c06:	64e2                	ld	s1,24(sp)
    80003c08:	69a2                	ld	s3,8(sp)
    80003c0a:	b7d5                	j	80003bee <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c0c:	02451783          	lh	a5,36(a0)
    80003c10:	03079693          	slli	a3,a5,0x30
    80003c14:	92c1                	srli	a3,a3,0x30
    80003c16:	4725                	li	a4,9
    80003c18:	02d76a63          	bltu	a4,a3,80003c4c <fileread+0xc2>
    80003c1c:	0792                	slli	a5,a5,0x4
    80003c1e:	0001d717          	auipc	a4,0x1d
    80003c22:	2aa70713          	addi	a4,a4,682 # 80020ec8 <devsw>
    80003c26:	97ba                	add	a5,a5,a4
    80003c28:	639c                	ld	a5,0(a5)
    80003c2a:	c78d                	beqz	a5,80003c54 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c2c:	4505                	li	a0,1
    80003c2e:	9782                	jalr	a5
    80003c30:	892a                	mv	s2,a0
    80003c32:	64e2                	ld	s1,24(sp)
    80003c34:	69a2                	ld	s3,8(sp)
    80003c36:	bf65                	j	80003bee <fileread+0x64>
    panic("fileread");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	8f050513          	addi	a0,a0,-1808 # 80008528 <etext+0x528>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	176080e7          	jalr	374(ra) # 80005db6 <panic>
    return -1;
    80003c48:	597d                	li	s2,-1
    80003c4a:	b755                	j	80003bee <fileread+0x64>
      return -1;
    80003c4c:	597d                	li	s2,-1
    80003c4e:	64e2                	ld	s1,24(sp)
    80003c50:	69a2                	ld	s3,8(sp)
    80003c52:	bf71                	j	80003bee <fileread+0x64>
    80003c54:	597d                	li	s2,-1
    80003c56:	64e2                	ld	s1,24(sp)
    80003c58:	69a2                	ld	s3,8(sp)
    80003c5a:	bf51                	j	80003bee <fileread+0x64>

0000000080003c5c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c5c:	00954783          	lbu	a5,9(a0)
    80003c60:	12078963          	beqz	a5,80003d92 <filewrite+0x136>
{
    80003c64:	715d                	addi	sp,sp,-80
    80003c66:	e486                	sd	ra,72(sp)
    80003c68:	e0a2                	sd	s0,64(sp)
    80003c6a:	f84a                	sd	s2,48(sp)
    80003c6c:	f052                	sd	s4,32(sp)
    80003c6e:	e85a                	sd	s6,16(sp)
    80003c70:	0880                	addi	s0,sp,80
    80003c72:	892a                	mv	s2,a0
    80003c74:	8b2e                	mv	s6,a1
    80003c76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c78:	411c                	lw	a5,0(a0)
    80003c7a:	4705                	li	a4,1
    80003c7c:	02e78763          	beq	a5,a4,80003caa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c80:	470d                	li	a4,3
    80003c82:	02e78a63          	beq	a5,a4,80003cb6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c86:	4709                	li	a4,2
    80003c88:	0ee79863          	bne	a5,a4,80003d78 <filewrite+0x11c>
    80003c8c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c8e:	0cc05463          	blez	a2,80003d56 <filewrite+0xfa>
    80003c92:	fc26                	sd	s1,56(sp)
    80003c94:	ec56                	sd	s5,24(sp)
    80003c96:	e45e                	sd	s7,8(sp)
    80003c98:	e062                	sd	s8,0(sp)
    int i = 0;
    80003c9a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c9c:	6b85                	lui	s7,0x1
    80003c9e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ca2:	6c05                	lui	s8,0x1
    80003ca4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ca8:	a851                	j	80003d3c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003caa:	6908                	ld	a0,16(a0)
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	248080e7          	jalr	584(ra) # 80003ef4 <pipewrite>
    80003cb4:	a85d                	j	80003d6a <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb6:	02451783          	lh	a5,36(a0)
    80003cba:	03079693          	slli	a3,a5,0x30
    80003cbe:	92c1                	srli	a3,a3,0x30
    80003cc0:	4725                	li	a4,9
    80003cc2:	0cd76a63          	bltu	a4,a3,80003d96 <filewrite+0x13a>
    80003cc6:	0792                	slli	a5,a5,0x4
    80003cc8:	0001d717          	auipc	a4,0x1d
    80003ccc:	20070713          	addi	a4,a4,512 # 80020ec8 <devsw>
    80003cd0:	97ba                	add	a5,a5,a4
    80003cd2:	679c                	ld	a5,8(a5)
    80003cd4:	c3f9                	beqz	a5,80003d9a <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003cd6:	4505                	li	a0,1
    80003cd8:	9782                	jalr	a5
    80003cda:	a841                	j	80003d6a <filewrite+0x10e>
      if(n1 > max)
    80003cdc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	88c080e7          	jalr	-1908(ra) # 8000356c <begin_op>
      ilock(f->ip);
    80003ce8:	01893503          	ld	a0,24(s2)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	eae080e7          	jalr	-338(ra) # 80002b9a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf4:	8756                	mv	a4,s5
    80003cf6:	02092683          	lw	a3,32(s2)
    80003cfa:	01698633          	add	a2,s3,s6
    80003cfe:	4585                	li	a1,1
    80003d00:	01893503          	ld	a0,24(s2)
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	252080e7          	jalr	594(ra) # 80002f56 <writei>
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	00a05763          	blez	a0,80003d1c <filewrite+0xc0>
        f->off += r;
    80003d12:	02092783          	lw	a5,32(s2)
    80003d16:	9fa9                	addw	a5,a5,a0
    80003d18:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d1c:	01893503          	ld	a0,24(s2)
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	f40080e7          	jalr	-192(ra) # 80002c60 <iunlock>
      end_op();
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	8be080e7          	jalr	-1858(ra) # 800035e6 <end_op>

      if(r != n1){
    80003d30:	029a9563          	bne	s5,s1,80003d5a <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d34:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d38:	0149da63          	bge	s3,s4,80003d4c <filewrite+0xf0>
      int n1 = n - i;
    80003d3c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d40:	0004879b          	sext.w	a5,s1
    80003d44:	f8fbdce3          	bge	s7,a5,80003cdc <filewrite+0x80>
    80003d48:	84e2                	mv	s1,s8
    80003d4a:	bf49                	j	80003cdc <filewrite+0x80>
    80003d4c:	74e2                	ld	s1,56(sp)
    80003d4e:	6ae2                	ld	s5,24(sp)
    80003d50:	6ba2                	ld	s7,8(sp)
    80003d52:	6c02                	ld	s8,0(sp)
    80003d54:	a039                	j	80003d62 <filewrite+0x106>
    int i = 0;
    80003d56:	4981                	li	s3,0
    80003d58:	a029                	j	80003d62 <filewrite+0x106>
    80003d5a:	74e2                	ld	s1,56(sp)
    80003d5c:	6ae2                	ld	s5,24(sp)
    80003d5e:	6ba2                	ld	s7,8(sp)
    80003d60:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003d62:	033a1e63          	bne	s4,s3,80003d9e <filewrite+0x142>
    80003d66:	8552                	mv	a0,s4
    80003d68:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d6a:	60a6                	ld	ra,72(sp)
    80003d6c:	6406                	ld	s0,64(sp)
    80003d6e:	7942                	ld	s2,48(sp)
    80003d70:	7a02                	ld	s4,32(sp)
    80003d72:	6b42                	ld	s6,16(sp)
    80003d74:	6161                	addi	sp,sp,80
    80003d76:	8082                	ret
    80003d78:	fc26                	sd	s1,56(sp)
    80003d7a:	f44e                	sd	s3,40(sp)
    80003d7c:	ec56                	sd	s5,24(sp)
    80003d7e:	e45e                	sd	s7,8(sp)
    80003d80:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003d82:	00004517          	auipc	a0,0x4
    80003d86:	7b650513          	addi	a0,a0,1974 # 80008538 <etext+0x538>
    80003d8a:	00002097          	auipc	ra,0x2
    80003d8e:	02c080e7          	jalr	44(ra) # 80005db6 <panic>
    return -1;
    80003d92:	557d                	li	a0,-1
}
    80003d94:	8082                	ret
      return -1;
    80003d96:	557d                	li	a0,-1
    80003d98:	bfc9                	j	80003d6a <filewrite+0x10e>
    80003d9a:	557d                	li	a0,-1
    80003d9c:	b7f9                	j	80003d6a <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003d9e:	557d                	li	a0,-1
    80003da0:	79a2                	ld	s3,40(sp)
    80003da2:	b7e1                	j	80003d6a <filewrite+0x10e>

0000000080003da4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003da4:	7179                	addi	sp,sp,-48
    80003da6:	f406                	sd	ra,40(sp)
    80003da8:	f022                	sd	s0,32(sp)
    80003daa:	ec26                	sd	s1,24(sp)
    80003dac:	e052                	sd	s4,0(sp)
    80003dae:	1800                	addi	s0,sp,48
    80003db0:	84aa                	mv	s1,a0
    80003db2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db4:	0005b023          	sd	zero,0(a1)
    80003db8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	bbe080e7          	jalr	-1090(ra) # 8000397a <filealloc>
    80003dc4:	e088                	sd	a0,0(s1)
    80003dc6:	cd49                	beqz	a0,80003e60 <pipealloc+0xbc>
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	bb2080e7          	jalr	-1102(ra) # 8000397a <filealloc>
    80003dd0:	00aa3023          	sd	a0,0(s4)
    80003dd4:	c141                	beqz	a0,80003e54 <pipealloc+0xb0>
    80003dd6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd8:	ffffc097          	auipc	ra,0xffffc
    80003ddc:	342080e7          	jalr	834(ra) # 8000011a <kalloc>
    80003de0:	892a                	mv	s2,a0
    80003de2:	c13d                	beqz	a0,80003e48 <pipealloc+0xa4>
    80003de4:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003de6:	4985                	li	s3,1
    80003de8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dec:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003df0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003df4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003df8:	00004597          	auipc	a1,0x4
    80003dfc:	75058593          	addi	a1,a1,1872 # 80008548 <etext+0x548>
    80003e00:	00002097          	auipc	ra,0x2
    80003e04:	476080e7          	jalr	1142(ra) # 80006276 <initlock>
  (*f0)->type = FD_PIPE;
    80003e08:	609c                	ld	a5,0(s1)
    80003e0a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e0e:	609c                	ld	a5,0(s1)
    80003e10:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e14:	609c                	ld	a5,0(s1)
    80003e16:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e1a:	609c                	ld	a5,0(s1)
    80003e1c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e20:	000a3783          	ld	a5,0(s4)
    80003e24:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e28:	000a3783          	ld	a5,0(s4)
    80003e2c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e30:	000a3783          	ld	a5,0(s4)
    80003e34:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e38:	000a3783          	ld	a5,0(s4)
    80003e3c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e40:	4501                	li	a0,0
    80003e42:	6942                	ld	s2,16(sp)
    80003e44:	69a2                	ld	s3,8(sp)
    80003e46:	a03d                	j	80003e74 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e48:	6088                	ld	a0,0(s1)
    80003e4a:	c119                	beqz	a0,80003e50 <pipealloc+0xac>
    80003e4c:	6942                	ld	s2,16(sp)
    80003e4e:	a029                	j	80003e58 <pipealloc+0xb4>
    80003e50:	6942                	ld	s2,16(sp)
    80003e52:	a039                	j	80003e60 <pipealloc+0xbc>
    80003e54:	6088                	ld	a0,0(s1)
    80003e56:	c50d                	beqz	a0,80003e80 <pipealloc+0xdc>
    fileclose(*f0);
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	bde080e7          	jalr	-1058(ra) # 80003a36 <fileclose>
  if(*f1)
    80003e60:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e64:	557d                	li	a0,-1
  if(*f1)
    80003e66:	c799                	beqz	a5,80003e74 <pipealloc+0xd0>
    fileclose(*f1);
    80003e68:	853e                	mv	a0,a5
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	bcc080e7          	jalr	-1076(ra) # 80003a36 <fileclose>
  return -1;
    80003e72:	557d                	li	a0,-1
}
    80003e74:	70a2                	ld	ra,40(sp)
    80003e76:	7402                	ld	s0,32(sp)
    80003e78:	64e2                	ld	s1,24(sp)
    80003e7a:	6a02                	ld	s4,0(sp)
    80003e7c:	6145                	addi	sp,sp,48
    80003e7e:	8082                	ret
  return -1;
    80003e80:	557d                	li	a0,-1
    80003e82:	bfcd                	j	80003e74 <pipealloc+0xd0>

0000000080003e84 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e84:	1101                	addi	sp,sp,-32
    80003e86:	ec06                	sd	ra,24(sp)
    80003e88:	e822                	sd	s0,16(sp)
    80003e8a:	e426                	sd	s1,8(sp)
    80003e8c:	e04a                	sd	s2,0(sp)
    80003e8e:	1000                	addi	s0,sp,32
    80003e90:	84aa                	mv	s1,a0
    80003e92:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e94:	00002097          	auipc	ra,0x2
    80003e98:	472080e7          	jalr	1138(ra) # 80006306 <acquire>
  if(writable){
    80003e9c:	02090d63          	beqz	s2,80003ed6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ea4:	21848513          	addi	a0,s1,536
    80003ea8:	ffffe097          	auipc	ra,0xffffe
    80003eac:	838080e7          	jalr	-1992(ra) # 800016e0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb0:	2204b783          	ld	a5,544(s1)
    80003eb4:	eb95                	bnez	a5,80003ee8 <pipeclose+0x64>
    release(&pi->lock);
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	00002097          	auipc	ra,0x2
    80003ebc:	502080e7          	jalr	1282(ra) # 800063ba <release>
    kfree((char*)pi);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	ffffc097          	auipc	ra,0xffffc
    80003ec6:	15a080e7          	jalr	346(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eca:	60e2                	ld	ra,24(sp)
    80003ecc:	6442                	ld	s0,16(sp)
    80003ece:	64a2                	ld	s1,8(sp)
    80003ed0:	6902                	ld	s2,0(sp)
    80003ed2:	6105                	addi	sp,sp,32
    80003ed4:	8082                	ret
    pi->readopen = 0;
    80003ed6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eda:	21c48513          	addi	a0,s1,540
    80003ede:	ffffe097          	auipc	ra,0xffffe
    80003ee2:	802080e7          	jalr	-2046(ra) # 800016e0 <wakeup>
    80003ee6:	b7e9                	j	80003eb0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ee8:	8526                	mv	a0,s1
    80003eea:	00002097          	auipc	ra,0x2
    80003eee:	4d0080e7          	jalr	1232(ra) # 800063ba <release>
}
    80003ef2:	bfe1                	j	80003eca <pipeclose+0x46>

0000000080003ef4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ef4:	711d                	addi	sp,sp,-96
    80003ef6:	ec86                	sd	ra,88(sp)
    80003ef8:	e8a2                	sd	s0,80(sp)
    80003efa:	e4a6                	sd	s1,72(sp)
    80003efc:	e0ca                	sd	s2,64(sp)
    80003efe:	fc4e                	sd	s3,56(sp)
    80003f00:	f852                	sd	s4,48(sp)
    80003f02:	f456                	sd	s5,40(sp)
    80003f04:	1080                	addi	s0,sp,96
    80003f06:	84aa                	mv	s1,a0
    80003f08:	8aae                	mv	s5,a1
    80003f0a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f0c:	ffffd097          	auipc	ra,0xffffd
    80003f10:	f70080e7          	jalr	-144(ra) # 80000e7c <myproc>
    80003f14:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	3ee080e7          	jalr	1006(ra) # 80006306 <acquire>
  while(i < n){
    80003f20:	0d405563          	blez	s4,80003fea <pipewrite+0xf6>
    80003f24:	f05a                	sd	s6,32(sp)
    80003f26:	ec5e                	sd	s7,24(sp)
    80003f28:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f2a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f2c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f2e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f32:	21c48b93          	addi	s7,s1,540
    80003f36:	a089                	j	80003f78 <pipewrite+0x84>
      release(&pi->lock);
    80003f38:	8526                	mv	a0,s1
    80003f3a:	00002097          	auipc	ra,0x2
    80003f3e:	480080e7          	jalr	1152(ra) # 800063ba <release>
      return -1;
    80003f42:	597d                	li	s2,-1
    80003f44:	7b02                	ld	s6,32(sp)
    80003f46:	6be2                	ld	s7,24(sp)
    80003f48:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f4a:	854a                	mv	a0,s2
    80003f4c:	60e6                	ld	ra,88(sp)
    80003f4e:	6446                	ld	s0,80(sp)
    80003f50:	64a6                	ld	s1,72(sp)
    80003f52:	6906                	ld	s2,64(sp)
    80003f54:	79e2                	ld	s3,56(sp)
    80003f56:	7a42                	ld	s4,48(sp)
    80003f58:	7aa2                	ld	s5,40(sp)
    80003f5a:	6125                	addi	sp,sp,96
    80003f5c:	8082                	ret
      wakeup(&pi->nread);
    80003f5e:	8562                	mv	a0,s8
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	780080e7          	jalr	1920(ra) # 800016e0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f68:	85a6                	mv	a1,s1
    80003f6a:	855e                	mv	a0,s7
    80003f6c:	ffffd097          	auipc	ra,0xffffd
    80003f70:	5e8080e7          	jalr	1512(ra) # 80001554 <sleep>
  while(i < n){
    80003f74:	05495c63          	bge	s2,s4,80003fcc <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003f78:	2204a783          	lw	a5,544(s1)
    80003f7c:	dfd5                	beqz	a5,80003f38 <pipewrite+0x44>
    80003f7e:	0289a783          	lw	a5,40(s3)
    80003f82:	fbdd                	bnez	a5,80003f38 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f84:	2184a783          	lw	a5,536(s1)
    80003f88:	21c4a703          	lw	a4,540(s1)
    80003f8c:	2007879b          	addiw	a5,a5,512
    80003f90:	fcf707e3          	beq	a4,a5,80003f5e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f94:	4685                	li	a3,1
    80003f96:	01590633          	add	a2,s2,s5
    80003f9a:	faf40593          	addi	a1,s0,-81
    80003f9e:	0509b503          	ld	a0,80(s3)
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	c02080e7          	jalr	-1022(ra) # 80000ba4 <copyin>
    80003faa:	05650263          	beq	a0,s6,80003fee <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fae:	21c4a783          	lw	a5,540(s1)
    80003fb2:	0017871b          	addiw	a4,a5,1
    80003fb6:	20e4ae23          	sw	a4,540(s1)
    80003fba:	1ff7f793          	andi	a5,a5,511
    80003fbe:	97a6                	add	a5,a5,s1
    80003fc0:	faf44703          	lbu	a4,-81(s0)
    80003fc4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fc8:	2905                	addiw	s2,s2,1
    80003fca:	b76d                	j	80003f74 <pipewrite+0x80>
    80003fcc:	7b02                	ld	s6,32(sp)
    80003fce:	6be2                	ld	s7,24(sp)
    80003fd0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003fd2:	21848513          	addi	a0,s1,536
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	70a080e7          	jalr	1802(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	3da080e7          	jalr	986(ra) # 800063ba <release>
  return i;
    80003fe8:	b78d                	j	80003f4a <pipewrite+0x56>
  int i = 0;
    80003fea:	4901                	li	s2,0
    80003fec:	b7dd                	j	80003fd2 <pipewrite+0xde>
    80003fee:	7b02                	ld	s6,32(sp)
    80003ff0:	6be2                	ld	s7,24(sp)
    80003ff2:	6c42                	ld	s8,16(sp)
    80003ff4:	bff9                	j	80003fd2 <pipewrite+0xde>

0000000080003ff6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff6:	715d                	addi	sp,sp,-80
    80003ff8:	e486                	sd	ra,72(sp)
    80003ffa:	e0a2                	sd	s0,64(sp)
    80003ffc:	fc26                	sd	s1,56(sp)
    80003ffe:	f84a                	sd	s2,48(sp)
    80004000:	f44e                	sd	s3,40(sp)
    80004002:	f052                	sd	s4,32(sp)
    80004004:	ec56                	sd	s5,24(sp)
    80004006:	0880                	addi	s0,sp,80
    80004008:	84aa                	mv	s1,a0
    8000400a:	892e                	mv	s2,a1
    8000400c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	e6e080e7          	jalr	-402(ra) # 80000e7c <myproc>
    80004016:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004018:	8526                	mv	a0,s1
    8000401a:	00002097          	auipc	ra,0x2
    8000401e:	2ec080e7          	jalr	748(ra) # 80006306 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004022:	2184a703          	lw	a4,536(s1)
    80004026:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000402a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402e:	02f71663          	bne	a4,a5,8000405a <piperead+0x64>
    80004032:	2244a783          	lw	a5,548(s1)
    80004036:	cb9d                	beqz	a5,8000406c <piperead+0x76>
    if(pr->killed){
    80004038:	028a2783          	lw	a5,40(s4)
    8000403c:	e38d                	bnez	a5,8000405e <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403e:	85a6                	mv	a1,s1
    80004040:	854e                	mv	a0,s3
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	512080e7          	jalr	1298(ra) # 80001554 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404a:	2184a703          	lw	a4,536(s1)
    8000404e:	21c4a783          	lw	a5,540(s1)
    80004052:	fef700e3          	beq	a4,a5,80004032 <piperead+0x3c>
    80004056:	e85a                	sd	s6,16(sp)
    80004058:	a819                	j	8000406e <piperead+0x78>
    8000405a:	e85a                	sd	s6,16(sp)
    8000405c:	a809                	j	8000406e <piperead+0x78>
      release(&pi->lock);
    8000405e:	8526                	mv	a0,s1
    80004060:	00002097          	auipc	ra,0x2
    80004064:	35a080e7          	jalr	858(ra) # 800063ba <release>
      return -1;
    80004068:	59fd                	li	s3,-1
    8000406a:	a0a5                	j	800040d2 <piperead+0xdc>
    8000406c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000406e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004070:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004072:	05505463          	blez	s5,800040ba <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004076:	2184a783          	lw	a5,536(s1)
    8000407a:	21c4a703          	lw	a4,540(s1)
    8000407e:	02f70e63          	beq	a4,a5,800040ba <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004082:	0017871b          	addiw	a4,a5,1
    80004086:	20e4ac23          	sw	a4,536(s1)
    8000408a:	1ff7f793          	andi	a5,a5,511
    8000408e:	97a6                	add	a5,a5,s1
    80004090:	0187c783          	lbu	a5,24(a5)
    80004094:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004098:	4685                	li	a3,1
    8000409a:	fbf40613          	addi	a2,s0,-65
    8000409e:	85ca                	mv	a1,s2
    800040a0:	050a3503          	ld	a0,80(s4)
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	a74080e7          	jalr	-1420(ra) # 80000b18 <copyout>
    800040ac:	01650763          	beq	a0,s6,800040ba <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b0:	2985                	addiw	s3,s3,1
    800040b2:	0905                	addi	s2,s2,1
    800040b4:	fd3a91e3          	bne	s5,s3,80004076 <piperead+0x80>
    800040b8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ba:	21c48513          	addi	a0,s1,540
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	622080e7          	jalr	1570(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	2f2080e7          	jalr	754(ra) # 800063ba <release>
    800040d0:	6b42                	ld	s6,16(sp)
  return i;
}
    800040d2:	854e                	mv	a0,s3
    800040d4:	60a6                	ld	ra,72(sp)
    800040d6:	6406                	ld	s0,64(sp)
    800040d8:	74e2                	ld	s1,56(sp)
    800040da:	7942                	ld	s2,48(sp)
    800040dc:	79a2                	ld	s3,40(sp)
    800040de:	7a02                	ld	s4,32(sp)
    800040e0:	6ae2                	ld	s5,24(sp)
    800040e2:	6161                	addi	sp,sp,80
    800040e4:	8082                	ret

00000000800040e6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040e6:	df010113          	addi	sp,sp,-528
    800040ea:	20113423          	sd	ra,520(sp)
    800040ee:	20813023          	sd	s0,512(sp)
    800040f2:	ffa6                	sd	s1,504(sp)
    800040f4:	fbca                	sd	s2,496(sp)
    800040f6:	0c00                	addi	s0,sp,528
    800040f8:	892a                	mv	s2,a0
    800040fa:	dea43c23          	sd	a0,-520(s0)
    800040fe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	d7a080e7          	jalr	-646(ra) # 80000e7c <myproc>
    8000410a:	84aa                	mv	s1,a0

  begin_op();
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	460080e7          	jalr	1120(ra) # 8000356c <begin_op>

  if((ip = namei(path)) == 0){
    80004114:	854a                	mv	a0,s2
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	256080e7          	jalr	598(ra) # 8000336c <namei>
    8000411e:	c135                	beqz	a0,80004182 <exec+0x9c>
    80004120:	f3d2                	sd	s4,480(sp)
    80004122:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	a76080e7          	jalr	-1418(ra) # 80002b9a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000412c:	04000713          	li	a4,64
    80004130:	4681                	li	a3,0
    80004132:	e5040613          	addi	a2,s0,-432
    80004136:	4581                	li	a1,0
    80004138:	8552                	mv	a0,s4
    8000413a:	fffff097          	auipc	ra,0xfffff
    8000413e:	d18080e7          	jalr	-744(ra) # 80002e52 <readi>
    80004142:	04000793          	li	a5,64
    80004146:	00f51a63          	bne	a0,a5,8000415a <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000414a:	e5042703          	lw	a4,-432(s0)
    8000414e:	464c47b7          	lui	a5,0x464c4
    80004152:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004156:	02f70c63          	beq	a4,a5,8000418e <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000415a:	8552                	mv	a0,s4
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	ca4080e7          	jalr	-860(ra) # 80002e00 <iunlockput>
    end_op();
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	482080e7          	jalr	1154(ra) # 800035e6 <end_op>
  }
  return -1;
    8000416c:	557d                	li	a0,-1
    8000416e:	7a1e                	ld	s4,480(sp)
}
    80004170:	20813083          	ld	ra,520(sp)
    80004174:	20013403          	ld	s0,512(sp)
    80004178:	74fe                	ld	s1,504(sp)
    8000417a:	795e                	ld	s2,496(sp)
    8000417c:	21010113          	addi	sp,sp,528
    80004180:	8082                	ret
    end_op();
    80004182:	fffff097          	auipc	ra,0xfffff
    80004186:	464080e7          	jalr	1124(ra) # 800035e6 <end_op>
    return -1;
    8000418a:	557d                	li	a0,-1
    8000418c:	b7d5                	j	80004170 <exec+0x8a>
    8000418e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004190:	8526                	mv	a0,s1
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	dae080e7          	jalr	-594(ra) # 80000f40 <proc_pagetable>
    8000419a:	8b2a                	mv	s6,a0
    8000419c:	30050563          	beqz	a0,800044a6 <exec+0x3c0>
    800041a0:	f7ce                	sd	s3,488(sp)
    800041a2:	efd6                	sd	s5,472(sp)
    800041a4:	e7de                	sd	s7,456(sp)
    800041a6:	e3e2                	sd	s8,448(sp)
    800041a8:	ff66                	sd	s9,440(sp)
    800041aa:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ac:	e7042d03          	lw	s10,-400(s0)
    800041b0:	e8845783          	lhu	a5,-376(s0)
    800041b4:	14078563          	beqz	a5,800042fe <exec+0x218>
    800041b8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ba:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041bc:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800041be:	6c85                	lui	s9,0x1
    800041c0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041c4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041c8:	6a85                	lui	s5,0x1
    800041ca:	a0b5                	j	80004236 <exec+0x150>
      panic("loadseg: address should exist");
    800041cc:	00004517          	auipc	a0,0x4
    800041d0:	38450513          	addi	a0,a0,900 # 80008550 <etext+0x550>
    800041d4:	00002097          	auipc	ra,0x2
    800041d8:	be2080e7          	jalr	-1054(ra) # 80005db6 <panic>
    if(sz - i < PGSIZE)
    800041dc:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041de:	8726                	mv	a4,s1
    800041e0:	012c06bb          	addw	a3,s8,s2
    800041e4:	4581                	li	a1,0
    800041e6:	8552                	mv	a0,s4
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	c6a080e7          	jalr	-918(ra) # 80002e52 <readi>
    800041f0:	2501                	sext.w	a0,a0
    800041f2:	26a49e63          	bne	s1,a0,8000446e <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800041f6:	012a893b          	addw	s2,s5,s2
    800041fa:	03397563          	bgeu	s2,s3,80004224 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800041fe:	02091593          	slli	a1,s2,0x20
    80004202:	9181                	srli	a1,a1,0x20
    80004204:	95de                	add	a1,a1,s7
    80004206:	855a                	mv	a0,s6
    80004208:	ffffc097          	auipc	ra,0xffffc
    8000420c:	2f0080e7          	jalr	752(ra) # 800004f8 <walkaddr>
    80004210:	862a                	mv	a2,a0
    if(pa == 0)
    80004212:	dd4d                	beqz	a0,800041cc <exec+0xe6>
    if(sz - i < PGSIZE)
    80004214:	412984bb          	subw	s1,s3,s2
    80004218:	0004879b          	sext.w	a5,s1
    8000421c:	fcfcf0e3          	bgeu	s9,a5,800041dc <exec+0xf6>
    80004220:	84d6                	mv	s1,s5
    80004222:	bf6d                	j	800041dc <exec+0xf6>
    sz = sz1;
    80004224:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004228:	2d85                	addiw	s11,s11,1
    8000422a:	038d0d1b          	addiw	s10,s10,56
    8000422e:	e8845783          	lhu	a5,-376(s0)
    80004232:	06fddf63          	bge	s11,a5,800042b0 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004236:	2d01                	sext.w	s10,s10
    80004238:	03800713          	li	a4,56
    8000423c:	86ea                	mv	a3,s10
    8000423e:	e1840613          	addi	a2,s0,-488
    80004242:	4581                	li	a1,0
    80004244:	8552                	mv	a0,s4
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	c0c080e7          	jalr	-1012(ra) # 80002e52 <readi>
    8000424e:	03800793          	li	a5,56
    80004252:	1ef51863          	bne	a0,a5,80004442 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004256:	e1842783          	lw	a5,-488(s0)
    8000425a:	4705                	li	a4,1
    8000425c:	fce796e3          	bne	a5,a4,80004228 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004260:	e4043603          	ld	a2,-448(s0)
    80004264:	e3843783          	ld	a5,-456(s0)
    80004268:	1ef66163          	bltu	a2,a5,8000444a <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000426c:	e2843783          	ld	a5,-472(s0)
    80004270:	963e                	add	a2,a2,a5
    80004272:	1ef66063          	bltu	a2,a5,80004452 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004276:	85a6                	mv	a1,s1
    80004278:	855a                	mv	a0,s6
    8000427a:	ffffc097          	auipc	ra,0xffffc
    8000427e:	642080e7          	jalr	1602(ra) # 800008bc <uvmalloc>
    80004282:	e0a43423          	sd	a0,-504(s0)
    80004286:	1c050a63          	beqz	a0,8000445a <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000428a:	e2843b83          	ld	s7,-472(s0)
    8000428e:	df043783          	ld	a5,-528(s0)
    80004292:	00fbf7b3          	and	a5,s7,a5
    80004296:	1c079a63          	bnez	a5,8000446a <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000429a:	e2042c03          	lw	s8,-480(s0)
    8000429e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042a2:	00098463          	beqz	s3,800042aa <exec+0x1c4>
    800042a6:	4901                	li	s2,0
    800042a8:	bf99                	j	800041fe <exec+0x118>
    sz = sz1;
    800042aa:	e0843483          	ld	s1,-504(s0)
    800042ae:	bfad                	j	80004228 <exec+0x142>
    800042b0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800042b2:	8552                	mv	a0,s4
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	b4c080e7          	jalr	-1204(ra) # 80002e00 <iunlockput>
  end_op();
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	32a080e7          	jalr	810(ra) # 800035e6 <end_op>
  p = myproc();
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	bb8080e7          	jalr	-1096(ra) # 80000e7c <myproc>
    800042cc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042ce:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800042d2:	6985                	lui	s3,0x1
    800042d4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042d6:	99a6                	add	s3,s3,s1
    800042d8:	77fd                	lui	a5,0xfffff
    800042da:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042de:	6609                	lui	a2,0x2
    800042e0:	964e                	add	a2,a2,s3
    800042e2:	85ce                	mv	a1,s3
    800042e4:	855a                	mv	a0,s6
    800042e6:	ffffc097          	auipc	ra,0xffffc
    800042ea:	5d6080e7          	jalr	1494(ra) # 800008bc <uvmalloc>
    800042ee:	892a                	mv	s2,a0
    800042f0:	e0a43423          	sd	a0,-504(s0)
    800042f4:	e519                	bnez	a0,80004302 <exec+0x21c>
  if(pagetable)
    800042f6:	e1343423          	sd	s3,-504(s0)
    800042fa:	4a01                	li	s4,0
    800042fc:	aa95                	j	80004470 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042fe:	4481                	li	s1,0
    80004300:	bf4d                	j	800042b2 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004302:	75f9                	lui	a1,0xffffe
    80004304:	95aa                	add	a1,a1,a0
    80004306:	855a                	mv	a0,s6
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	7de080e7          	jalr	2014(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004310:	7bfd                	lui	s7,0xfffff
    80004312:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004314:	e0043783          	ld	a5,-512(s0)
    80004318:	6388                	ld	a0,0(a5)
    8000431a:	c52d                	beqz	a0,80004384 <exec+0x29e>
    8000431c:	e9040993          	addi	s3,s0,-368
    80004320:	f9040c13          	addi	s8,s0,-112
    80004324:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004326:	ffffc097          	auipc	ra,0xffffc
    8000432a:	fc8080e7          	jalr	-56(ra) # 800002ee <strlen>
    8000432e:	0015079b          	addiw	a5,a0,1
    80004332:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004336:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000433a:	13796463          	bltu	s2,s7,80004462 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000433e:	e0043d03          	ld	s10,-512(s0)
    80004342:	000d3a03          	ld	s4,0(s10)
    80004346:	8552                	mv	a0,s4
    80004348:	ffffc097          	auipc	ra,0xffffc
    8000434c:	fa6080e7          	jalr	-90(ra) # 800002ee <strlen>
    80004350:	0015069b          	addiw	a3,a0,1
    80004354:	8652                	mv	a2,s4
    80004356:	85ca                	mv	a1,s2
    80004358:	855a                	mv	a0,s6
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	7be080e7          	jalr	1982(ra) # 80000b18 <copyout>
    80004362:	10054263          	bltz	a0,80004466 <exec+0x380>
    ustack[argc] = sp;
    80004366:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000436a:	0485                	addi	s1,s1,1
    8000436c:	008d0793          	addi	a5,s10,8
    80004370:	e0f43023          	sd	a5,-512(s0)
    80004374:	008d3503          	ld	a0,8(s10)
    80004378:	c909                	beqz	a0,8000438a <exec+0x2a4>
    if(argc >= MAXARG)
    8000437a:	09a1                	addi	s3,s3,8
    8000437c:	fb8995e3          	bne	s3,s8,80004326 <exec+0x240>
  ip = 0;
    80004380:	4a01                	li	s4,0
    80004382:	a0fd                	j	80004470 <exec+0x38a>
  sp = sz;
    80004384:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004388:	4481                	li	s1,0
  ustack[argc] = 0;
    8000438a:	00349793          	slli	a5,s1,0x3
    8000438e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd1d50>
    80004392:	97a2                	add	a5,a5,s0
    80004394:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004398:	00148693          	addi	a3,s1,1
    8000439c:	068e                	slli	a3,a3,0x3
    8000439e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043a2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800043a6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043aa:	f57966e3          	bltu	s2,s7,800042f6 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ae:	e9040613          	addi	a2,s0,-368
    800043b2:	85ca                	mv	a1,s2
    800043b4:	855a                	mv	a0,s6
    800043b6:	ffffc097          	auipc	ra,0xffffc
    800043ba:	762080e7          	jalr	1890(ra) # 80000b18 <copyout>
    800043be:	0e054663          	bltz	a0,800044aa <exec+0x3c4>
  p->trapframe->a1 = sp;
    800043c2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043c6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043ca:	df843783          	ld	a5,-520(s0)
    800043ce:	0007c703          	lbu	a4,0(a5)
    800043d2:	cf11                	beqz	a4,800043ee <exec+0x308>
    800043d4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043d6:	02f00693          	li	a3,47
    800043da:	a039                	j	800043e8 <exec+0x302>
      last = s+1;
    800043dc:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043e0:	0785                	addi	a5,a5,1
    800043e2:	fff7c703          	lbu	a4,-1(a5)
    800043e6:	c701                	beqz	a4,800043ee <exec+0x308>
    if(*s == '/')
    800043e8:	fed71ce3          	bne	a4,a3,800043e0 <exec+0x2fa>
    800043ec:	bfc5                	j	800043dc <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800043ee:	4641                	li	a2,16
    800043f0:	df843583          	ld	a1,-520(s0)
    800043f4:	158a8513          	addi	a0,s5,344
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	ec4080e7          	jalr	-316(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004400:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004404:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004408:	e0843783          	ld	a5,-504(s0)
    8000440c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004410:	058ab783          	ld	a5,88(s5)
    80004414:	e6843703          	ld	a4,-408(s0)
    80004418:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000441a:	058ab783          	ld	a5,88(s5)
    8000441e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004422:	85e6                	mv	a1,s9
    80004424:	ffffd097          	auipc	ra,0xffffd
    80004428:	bb8080e7          	jalr	-1096(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000442c:	0004851b          	sext.w	a0,s1
    80004430:	79be                	ld	s3,488(sp)
    80004432:	7a1e                	ld	s4,480(sp)
    80004434:	6afe                	ld	s5,472(sp)
    80004436:	6b5e                	ld	s6,464(sp)
    80004438:	6bbe                	ld	s7,456(sp)
    8000443a:	6c1e                	ld	s8,448(sp)
    8000443c:	7cfa                	ld	s9,440(sp)
    8000443e:	7d5a                	ld	s10,432(sp)
    80004440:	bb05                	j	80004170 <exec+0x8a>
    80004442:	e0943423          	sd	s1,-504(s0)
    80004446:	7dba                	ld	s11,424(sp)
    80004448:	a025                	j	80004470 <exec+0x38a>
    8000444a:	e0943423          	sd	s1,-504(s0)
    8000444e:	7dba                	ld	s11,424(sp)
    80004450:	a005                	j	80004470 <exec+0x38a>
    80004452:	e0943423          	sd	s1,-504(s0)
    80004456:	7dba                	ld	s11,424(sp)
    80004458:	a821                	j	80004470 <exec+0x38a>
    8000445a:	e0943423          	sd	s1,-504(s0)
    8000445e:	7dba                	ld	s11,424(sp)
    80004460:	a801                	j	80004470 <exec+0x38a>
  ip = 0;
    80004462:	4a01                	li	s4,0
    80004464:	a031                	j	80004470 <exec+0x38a>
    80004466:	4a01                	li	s4,0
  if(pagetable)
    80004468:	a021                	j	80004470 <exec+0x38a>
    8000446a:	7dba                	ld	s11,424(sp)
    8000446c:	a011                	j	80004470 <exec+0x38a>
    8000446e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004470:	e0843583          	ld	a1,-504(s0)
    80004474:	855a                	mv	a0,s6
    80004476:	ffffd097          	auipc	ra,0xffffd
    8000447a:	b66080e7          	jalr	-1178(ra) # 80000fdc <proc_freepagetable>
  return -1;
    8000447e:	557d                	li	a0,-1
  if(ip){
    80004480:	000a1b63          	bnez	s4,80004496 <exec+0x3b0>
    80004484:	79be                	ld	s3,488(sp)
    80004486:	7a1e                	ld	s4,480(sp)
    80004488:	6afe                	ld	s5,472(sp)
    8000448a:	6b5e                	ld	s6,464(sp)
    8000448c:	6bbe                	ld	s7,456(sp)
    8000448e:	6c1e                	ld	s8,448(sp)
    80004490:	7cfa                	ld	s9,440(sp)
    80004492:	7d5a                	ld	s10,432(sp)
    80004494:	b9f1                	j	80004170 <exec+0x8a>
    80004496:	79be                	ld	s3,488(sp)
    80004498:	6afe                	ld	s5,472(sp)
    8000449a:	6b5e                	ld	s6,464(sp)
    8000449c:	6bbe                	ld	s7,456(sp)
    8000449e:	6c1e                	ld	s8,448(sp)
    800044a0:	7cfa                	ld	s9,440(sp)
    800044a2:	7d5a                	ld	s10,432(sp)
    800044a4:	b95d                	j	8000415a <exec+0x74>
    800044a6:	6b5e                	ld	s6,464(sp)
    800044a8:	b94d                	j	8000415a <exec+0x74>
  sz = sz1;
    800044aa:	e0843983          	ld	s3,-504(s0)
    800044ae:	b5a1                	j	800042f6 <exec+0x210>

00000000800044b0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044b0:	7179                	addi	sp,sp,-48
    800044b2:	f406                	sd	ra,40(sp)
    800044b4:	f022                	sd	s0,32(sp)
    800044b6:	ec26                	sd	s1,24(sp)
    800044b8:	e84a                	sd	s2,16(sp)
    800044ba:	1800                	addi	s0,sp,48
    800044bc:	892e                	mv	s2,a1
    800044be:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800044c0:	fdc40593          	addi	a1,s0,-36
    800044c4:	ffffe097          	auipc	ra,0xffffe
    800044c8:	acc080e7          	jalr	-1332(ra) # 80001f90 <argint>
    800044cc:	04054063          	bltz	a0,8000450c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044d0:	fdc42703          	lw	a4,-36(s0)
    800044d4:	47bd                	li	a5,15
    800044d6:	02e7ed63          	bltu	a5,a4,80004510 <argfd+0x60>
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	9a2080e7          	jalr	-1630(ra) # 80000e7c <myproc>
    800044e2:	fdc42703          	lw	a4,-36(s0)
    800044e6:	01a70793          	addi	a5,a4,26
    800044ea:	078e                	slli	a5,a5,0x3
    800044ec:	953e                	add	a0,a0,a5
    800044ee:	611c                	ld	a5,0(a0)
    800044f0:	c395                	beqz	a5,80004514 <argfd+0x64>
    return -1;
  if(pfd)
    800044f2:	00090463          	beqz	s2,800044fa <argfd+0x4a>
    *pfd = fd;
    800044f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044fa:	4501                	li	a0,0
  if(pf)
    800044fc:	c091                	beqz	s1,80004500 <argfd+0x50>
    *pf = f;
    800044fe:	e09c                	sd	a5,0(s1)
}
    80004500:	70a2                	ld	ra,40(sp)
    80004502:	7402                	ld	s0,32(sp)
    80004504:	64e2                	ld	s1,24(sp)
    80004506:	6942                	ld	s2,16(sp)
    80004508:	6145                	addi	sp,sp,48
    8000450a:	8082                	ret
    return -1;
    8000450c:	557d                	li	a0,-1
    8000450e:	bfcd                	j	80004500 <argfd+0x50>
    return -1;
    80004510:	557d                	li	a0,-1
    80004512:	b7fd                	j	80004500 <argfd+0x50>
    80004514:	557d                	li	a0,-1
    80004516:	b7ed                	j	80004500 <argfd+0x50>

0000000080004518 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004518:	1101                	addi	sp,sp,-32
    8000451a:	ec06                	sd	ra,24(sp)
    8000451c:	e822                	sd	s0,16(sp)
    8000451e:	e426                	sd	s1,8(sp)
    80004520:	1000                	addi	s0,sp,32
    80004522:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004524:	ffffd097          	auipc	ra,0xffffd
    80004528:	958080e7          	jalr	-1704(ra) # 80000e7c <myproc>
    8000452c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000452e:	0d050793          	addi	a5,a0,208
    80004532:	4501                	li	a0,0
    80004534:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004536:	6398                	ld	a4,0(a5)
    80004538:	cb19                	beqz	a4,8000454e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000453a:	2505                	addiw	a0,a0,1
    8000453c:	07a1                	addi	a5,a5,8
    8000453e:	fed51ce3          	bne	a0,a3,80004536 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004542:	557d                	li	a0,-1
}
    80004544:	60e2                	ld	ra,24(sp)
    80004546:	6442                	ld	s0,16(sp)
    80004548:	64a2                	ld	s1,8(sp)
    8000454a:	6105                	addi	sp,sp,32
    8000454c:	8082                	ret
      p->ofile[fd] = f;
    8000454e:	01a50793          	addi	a5,a0,26
    80004552:	078e                	slli	a5,a5,0x3
    80004554:	963e                	add	a2,a2,a5
    80004556:	e204                	sd	s1,0(a2)
      return fd;
    80004558:	b7f5                	j	80004544 <fdalloc+0x2c>

000000008000455a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000455a:	715d                	addi	sp,sp,-80
    8000455c:	e486                	sd	ra,72(sp)
    8000455e:	e0a2                	sd	s0,64(sp)
    80004560:	fc26                	sd	s1,56(sp)
    80004562:	f84a                	sd	s2,48(sp)
    80004564:	f44e                	sd	s3,40(sp)
    80004566:	f052                	sd	s4,32(sp)
    80004568:	ec56                	sd	s5,24(sp)
    8000456a:	0880                	addi	s0,sp,80
    8000456c:	8aae                	mv	s5,a1
    8000456e:	8a32                	mv	s4,a2
    80004570:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004572:	fb040593          	addi	a1,s0,-80
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	e14080e7          	jalr	-492(ra) # 8000338a <nameiparent>
    8000457e:	892a                	mv	s2,a0
    80004580:	12050c63          	beqz	a0,800046b8 <create+0x15e>
    return 0;

  ilock(dp);
    80004584:	ffffe097          	auipc	ra,0xffffe
    80004588:	616080e7          	jalr	1558(ra) # 80002b9a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000458c:	4601                	li	a2,0
    8000458e:	fb040593          	addi	a1,s0,-80
    80004592:	854a                	mv	a0,s2
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	b06080e7          	jalr	-1274(ra) # 8000309a <dirlookup>
    8000459c:	84aa                	mv	s1,a0
    8000459e:	c539                	beqz	a0,800045ec <create+0x92>
    iunlockput(dp);
    800045a0:	854a                	mv	a0,s2
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	85e080e7          	jalr	-1954(ra) # 80002e00 <iunlockput>
    ilock(ip);
    800045aa:	8526                	mv	a0,s1
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	5ee080e7          	jalr	1518(ra) # 80002b9a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045b4:	4789                	li	a5,2
    800045b6:	02fa9463          	bne	s5,a5,800045de <create+0x84>
    800045ba:	0444d783          	lhu	a5,68(s1)
    800045be:	37f9                	addiw	a5,a5,-2
    800045c0:	17c2                	slli	a5,a5,0x30
    800045c2:	93c1                	srli	a5,a5,0x30
    800045c4:	4705                	li	a4,1
    800045c6:	00f76c63          	bltu	a4,a5,800045de <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045ca:	8526                	mv	a0,s1
    800045cc:	60a6                	ld	ra,72(sp)
    800045ce:	6406                	ld	s0,64(sp)
    800045d0:	74e2                	ld	s1,56(sp)
    800045d2:	7942                	ld	s2,48(sp)
    800045d4:	79a2                	ld	s3,40(sp)
    800045d6:	7a02                	ld	s4,32(sp)
    800045d8:	6ae2                	ld	s5,24(sp)
    800045da:	6161                	addi	sp,sp,80
    800045dc:	8082                	ret
    iunlockput(ip);
    800045de:	8526                	mv	a0,s1
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	820080e7          	jalr	-2016(ra) # 80002e00 <iunlockput>
    return 0;
    800045e8:	4481                	li	s1,0
    800045ea:	b7c5                	j	800045ca <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045ec:	85d6                	mv	a1,s5
    800045ee:	00092503          	lw	a0,0(s2)
    800045f2:	ffffe097          	auipc	ra,0xffffe
    800045f6:	414080e7          	jalr	1044(ra) # 80002a06 <ialloc>
    800045fa:	84aa                	mv	s1,a0
    800045fc:	c139                	beqz	a0,80004642 <create+0xe8>
  ilock(ip);
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	59c080e7          	jalr	1436(ra) # 80002b9a <ilock>
  ip->major = major;
    80004606:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000460a:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000460e:	4985                	li	s3,1
    80004610:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004614:	8526                	mv	a0,s1
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	4b8080e7          	jalr	1208(ra) # 80002ace <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000461e:	033a8a63          	beq	s5,s3,80004652 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004622:	40d0                	lw	a2,4(s1)
    80004624:	fb040593          	addi	a1,s0,-80
    80004628:	854a                	mv	a0,s2
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	c80080e7          	jalr	-896(ra) # 800032aa <dirlink>
    80004632:	06054b63          	bltz	a0,800046a8 <create+0x14e>
  iunlockput(dp);
    80004636:	854a                	mv	a0,s2
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	7c8080e7          	jalr	1992(ra) # 80002e00 <iunlockput>
  return ip;
    80004640:	b769                	j	800045ca <create+0x70>
    panic("create: ialloc");
    80004642:	00004517          	auipc	a0,0x4
    80004646:	f2e50513          	addi	a0,a0,-210 # 80008570 <etext+0x570>
    8000464a:	00001097          	auipc	ra,0x1
    8000464e:	76c080e7          	jalr	1900(ra) # 80005db6 <panic>
    dp->nlink++;  // for ".."
    80004652:	04a95783          	lhu	a5,74(s2)
    80004656:	2785                	addiw	a5,a5,1
    80004658:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000465c:	854a                	mv	a0,s2
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	470080e7          	jalr	1136(ra) # 80002ace <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004666:	40d0                	lw	a2,4(s1)
    80004668:	00004597          	auipc	a1,0x4
    8000466c:	f1858593          	addi	a1,a1,-232 # 80008580 <etext+0x580>
    80004670:	8526                	mv	a0,s1
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	c38080e7          	jalr	-968(ra) # 800032aa <dirlink>
    8000467a:	00054f63          	bltz	a0,80004698 <create+0x13e>
    8000467e:	00492603          	lw	a2,4(s2)
    80004682:	00004597          	auipc	a1,0x4
    80004686:	f0658593          	addi	a1,a1,-250 # 80008588 <etext+0x588>
    8000468a:	8526                	mv	a0,s1
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	c1e080e7          	jalr	-994(ra) # 800032aa <dirlink>
    80004694:	f80557e3          	bgez	a0,80004622 <create+0xc8>
      panic("create dots");
    80004698:	00004517          	auipc	a0,0x4
    8000469c:	ef850513          	addi	a0,a0,-264 # 80008590 <etext+0x590>
    800046a0:	00001097          	auipc	ra,0x1
    800046a4:	716080e7          	jalr	1814(ra) # 80005db6 <panic>
    panic("create: dirlink");
    800046a8:	00004517          	auipc	a0,0x4
    800046ac:	ef850513          	addi	a0,a0,-264 # 800085a0 <etext+0x5a0>
    800046b0:	00001097          	auipc	ra,0x1
    800046b4:	706080e7          	jalr	1798(ra) # 80005db6 <panic>
    return 0;
    800046b8:	84aa                	mv	s1,a0
    800046ba:	bf01                	j	800045ca <create+0x70>

00000000800046bc <sys_dup>:
{
    800046bc:	7179                	addi	sp,sp,-48
    800046be:	f406                	sd	ra,40(sp)
    800046c0:	f022                	sd	s0,32(sp)
    800046c2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046c4:	fd840613          	addi	a2,s0,-40
    800046c8:	4581                	li	a1,0
    800046ca:	4501                	li	a0,0
    800046cc:	00000097          	auipc	ra,0x0
    800046d0:	de4080e7          	jalr	-540(ra) # 800044b0 <argfd>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046d6:	02054763          	bltz	a0,80004704 <sys_dup+0x48>
    800046da:	ec26                	sd	s1,24(sp)
    800046dc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800046de:	fd843903          	ld	s2,-40(s0)
    800046e2:	854a                	mv	a0,s2
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	e34080e7          	jalr	-460(ra) # 80004518 <fdalloc>
    800046ec:	84aa                	mv	s1,a0
    return -1;
    800046ee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046f0:	00054f63          	bltz	a0,8000470e <sys_dup+0x52>
  filedup(f);
    800046f4:	854a                	mv	a0,s2
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	2ee080e7          	jalr	750(ra) # 800039e4 <filedup>
  return fd;
    800046fe:	87a6                	mv	a5,s1
    80004700:	64e2                	ld	s1,24(sp)
    80004702:	6942                	ld	s2,16(sp)
}
    80004704:	853e                	mv	a0,a5
    80004706:	70a2                	ld	ra,40(sp)
    80004708:	7402                	ld	s0,32(sp)
    8000470a:	6145                	addi	sp,sp,48
    8000470c:	8082                	ret
    8000470e:	64e2                	ld	s1,24(sp)
    80004710:	6942                	ld	s2,16(sp)
    80004712:	bfcd                	j	80004704 <sys_dup+0x48>

0000000080004714 <sys_read>:
{
    80004714:	7179                	addi	sp,sp,-48
    80004716:	f406                	sd	ra,40(sp)
    80004718:	f022                	sd	s0,32(sp)
    8000471a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	fe840613          	addi	a2,s0,-24
    80004720:	4581                	li	a1,0
    80004722:	4501                	li	a0,0
    80004724:	00000097          	auipc	ra,0x0
    80004728:	d8c080e7          	jalr	-628(ra) # 800044b0 <argfd>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	04054163          	bltz	a0,80004770 <sys_read+0x5c>
    80004732:	fe440593          	addi	a1,s0,-28
    80004736:	4509                	li	a0,2
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	858080e7          	jalr	-1960(ra) # 80001f90 <argint>
    return -1;
    80004740:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004742:	02054763          	bltz	a0,80004770 <sys_read+0x5c>
    80004746:	fd840593          	addi	a1,s0,-40
    8000474a:	4505                	li	a0,1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	866080e7          	jalr	-1946(ra) # 80001fb2 <argaddr>
    return -1;
    80004754:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004756:	00054d63          	bltz	a0,80004770 <sys_read+0x5c>
  return fileread(f, p, n);
    8000475a:	fe442603          	lw	a2,-28(s0)
    8000475e:	fd843583          	ld	a1,-40(s0)
    80004762:	fe843503          	ld	a0,-24(s0)
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	424080e7          	jalr	1060(ra) # 80003b8a <fileread>
    8000476e:	87aa                	mv	a5,a0
}
    80004770:	853e                	mv	a0,a5
    80004772:	70a2                	ld	ra,40(sp)
    80004774:	7402                	ld	s0,32(sp)
    80004776:	6145                	addi	sp,sp,48
    80004778:	8082                	ret

000000008000477a <sys_write>:
{
    8000477a:	7179                	addi	sp,sp,-48
    8000477c:	f406                	sd	ra,40(sp)
    8000477e:	f022                	sd	s0,32(sp)
    80004780:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	fe840613          	addi	a2,s0,-24
    80004786:	4581                	li	a1,0
    80004788:	4501                	li	a0,0
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	d26080e7          	jalr	-730(ra) # 800044b0 <argfd>
    return -1;
    80004792:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004794:	04054163          	bltz	a0,800047d6 <sys_write+0x5c>
    80004798:	fe440593          	addi	a1,s0,-28
    8000479c:	4509                	li	a0,2
    8000479e:	ffffd097          	auipc	ra,0xffffd
    800047a2:	7f2080e7          	jalr	2034(ra) # 80001f90 <argint>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a8:	02054763          	bltz	a0,800047d6 <sys_write+0x5c>
    800047ac:	fd840593          	addi	a1,s0,-40
    800047b0:	4505                	li	a0,1
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	800080e7          	jalr	-2048(ra) # 80001fb2 <argaddr>
    return -1;
    800047ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047bc:	00054d63          	bltz	a0,800047d6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047c0:	fe442603          	lw	a2,-28(s0)
    800047c4:	fd843583          	ld	a1,-40(s0)
    800047c8:	fe843503          	ld	a0,-24(s0)
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	490080e7          	jalr	1168(ra) # 80003c5c <filewrite>
    800047d4:	87aa                	mv	a5,a0
}
    800047d6:	853e                	mv	a0,a5
    800047d8:	70a2                	ld	ra,40(sp)
    800047da:	7402                	ld	s0,32(sp)
    800047dc:	6145                	addi	sp,sp,48
    800047de:	8082                	ret

00000000800047e0 <sys_close>:
{
    800047e0:	1101                	addi	sp,sp,-32
    800047e2:	ec06                	sd	ra,24(sp)
    800047e4:	e822                	sd	s0,16(sp)
    800047e6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047e8:	fe040613          	addi	a2,s0,-32
    800047ec:	fec40593          	addi	a1,s0,-20
    800047f0:	4501                	li	a0,0
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	cbe080e7          	jalr	-834(ra) # 800044b0 <argfd>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047fc:	02054463          	bltz	a0,80004824 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004800:	ffffc097          	auipc	ra,0xffffc
    80004804:	67c080e7          	jalr	1660(ra) # 80000e7c <myproc>
    80004808:	fec42783          	lw	a5,-20(s0)
    8000480c:	07e9                	addi	a5,a5,26
    8000480e:	078e                	slli	a5,a5,0x3
    80004810:	953e                	add	a0,a0,a5
    80004812:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004816:	fe043503          	ld	a0,-32(s0)
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	21c080e7          	jalr	540(ra) # 80003a36 <fileclose>
  return 0;
    80004822:	4781                	li	a5,0
}
    80004824:	853e                	mv	a0,a5
    80004826:	60e2                	ld	ra,24(sp)
    80004828:	6442                	ld	s0,16(sp)
    8000482a:	6105                	addi	sp,sp,32
    8000482c:	8082                	ret

000000008000482e <sys_fstat>:
{
    8000482e:	1101                	addi	sp,sp,-32
    80004830:	ec06                	sd	ra,24(sp)
    80004832:	e822                	sd	s0,16(sp)
    80004834:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004836:	fe840613          	addi	a2,s0,-24
    8000483a:	4581                	li	a1,0
    8000483c:	4501                	li	a0,0
    8000483e:	00000097          	auipc	ra,0x0
    80004842:	c72080e7          	jalr	-910(ra) # 800044b0 <argfd>
    return -1;
    80004846:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004848:	02054563          	bltz	a0,80004872 <sys_fstat+0x44>
    8000484c:	fe040593          	addi	a1,s0,-32
    80004850:	4505                	li	a0,1
    80004852:	ffffd097          	auipc	ra,0xffffd
    80004856:	760080e7          	jalr	1888(ra) # 80001fb2 <argaddr>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000485c:	00054b63          	bltz	a0,80004872 <sys_fstat+0x44>
  return filestat(f, st);
    80004860:	fe043583          	ld	a1,-32(s0)
    80004864:	fe843503          	ld	a0,-24(s0)
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	2b0080e7          	jalr	688(ra) # 80003b18 <filestat>
    80004870:	87aa                	mv	a5,a0
}
    80004872:	853e                	mv	a0,a5
    80004874:	60e2                	ld	ra,24(sp)
    80004876:	6442                	ld	s0,16(sp)
    80004878:	6105                	addi	sp,sp,32
    8000487a:	8082                	ret

000000008000487c <sys_link>:
{
    8000487c:	7169                	addi	sp,sp,-304
    8000487e:	f606                	sd	ra,296(sp)
    80004880:	f222                	sd	s0,288(sp)
    80004882:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004884:	08000613          	li	a2,128
    80004888:	ed040593          	addi	a1,s0,-304
    8000488c:	4501                	li	a0,0
    8000488e:	ffffd097          	auipc	ra,0xffffd
    80004892:	746080e7          	jalr	1862(ra) # 80001fd4 <argstr>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004898:	12054663          	bltz	a0,800049c4 <sys_link+0x148>
    8000489c:	08000613          	li	a2,128
    800048a0:	f5040593          	addi	a1,s0,-176
    800048a4:	4505                	li	a0,1
    800048a6:	ffffd097          	auipc	ra,0xffffd
    800048aa:	72e080e7          	jalr	1838(ra) # 80001fd4 <argstr>
    return -1;
    800048ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b0:	10054a63          	bltz	a0,800049c4 <sys_link+0x148>
    800048b4:	ee26                	sd	s1,280(sp)
  begin_op();
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	cb6080e7          	jalr	-842(ra) # 8000356c <begin_op>
  if((ip = namei(old)) == 0){
    800048be:	ed040513          	addi	a0,s0,-304
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	aaa080e7          	jalr	-1366(ra) # 8000336c <namei>
    800048ca:	84aa                	mv	s1,a0
    800048cc:	c949                	beqz	a0,8000495e <sys_link+0xe2>
  ilock(ip);
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	2cc080e7          	jalr	716(ra) # 80002b9a <ilock>
  if(ip->type == T_DIR){
    800048d6:	04449703          	lh	a4,68(s1)
    800048da:	4785                	li	a5,1
    800048dc:	08f70863          	beq	a4,a5,8000496c <sys_link+0xf0>
    800048e0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048e2:	04a4d783          	lhu	a5,74(s1)
    800048e6:	2785                	addiw	a5,a5,1
    800048e8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	1e0080e7          	jalr	480(ra) # 80002ace <iupdate>
  iunlock(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	368080e7          	jalr	872(ra) # 80002c60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004900:	fd040593          	addi	a1,s0,-48
    80004904:	f5040513          	addi	a0,s0,-176
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	a82080e7          	jalr	-1406(ra) # 8000338a <nameiparent>
    80004910:	892a                	mv	s2,a0
    80004912:	cd35                	beqz	a0,8000498e <sys_link+0x112>
  ilock(dp);
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	286080e7          	jalr	646(ra) # 80002b9a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000491c:	00092703          	lw	a4,0(s2)
    80004920:	409c                	lw	a5,0(s1)
    80004922:	06f71163          	bne	a4,a5,80004984 <sys_link+0x108>
    80004926:	40d0                	lw	a2,4(s1)
    80004928:	fd040593          	addi	a1,s0,-48
    8000492c:	854a                	mv	a0,s2
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	97c080e7          	jalr	-1668(ra) # 800032aa <dirlink>
    80004936:	04054763          	bltz	a0,80004984 <sys_link+0x108>
  iunlockput(dp);
    8000493a:	854a                	mv	a0,s2
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	4c4080e7          	jalr	1220(ra) # 80002e00 <iunlockput>
  iput(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	412080e7          	jalr	1042(ra) # 80002d58 <iput>
  end_op();
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	c98080e7          	jalr	-872(ra) # 800035e6 <end_op>
  return 0;
    80004956:	4781                	li	a5,0
    80004958:	64f2                	ld	s1,280(sp)
    8000495a:	6952                	ld	s2,272(sp)
    8000495c:	a0a5                	j	800049c4 <sys_link+0x148>
    end_op();
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	c88080e7          	jalr	-888(ra) # 800035e6 <end_op>
    return -1;
    80004966:	57fd                	li	a5,-1
    80004968:	64f2                	ld	s1,280(sp)
    8000496a:	a8a9                	j	800049c4 <sys_link+0x148>
    iunlockput(ip);
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	492080e7          	jalr	1170(ra) # 80002e00 <iunlockput>
    end_op();
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	c70080e7          	jalr	-912(ra) # 800035e6 <end_op>
    return -1;
    8000497e:	57fd                	li	a5,-1
    80004980:	64f2                	ld	s1,280(sp)
    80004982:	a089                	j	800049c4 <sys_link+0x148>
    iunlockput(dp);
    80004984:	854a                	mv	a0,s2
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	47a080e7          	jalr	1146(ra) # 80002e00 <iunlockput>
  ilock(ip);
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	20a080e7          	jalr	522(ra) # 80002b9a <ilock>
  ip->nlink--;
    80004998:	04a4d783          	lhu	a5,74(s1)
    8000499c:	37fd                	addiw	a5,a5,-1
    8000499e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	12a080e7          	jalr	298(ra) # 80002ace <iupdate>
  iunlockput(ip);
    800049ac:	8526                	mv	a0,s1
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	452080e7          	jalr	1106(ra) # 80002e00 <iunlockput>
  end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	c30080e7          	jalr	-976(ra) # 800035e6 <end_op>
  return -1;
    800049be:	57fd                	li	a5,-1
    800049c0:	64f2                	ld	s1,280(sp)
    800049c2:	6952                	ld	s2,272(sp)
}
    800049c4:	853e                	mv	a0,a5
    800049c6:	70b2                	ld	ra,296(sp)
    800049c8:	7412                	ld	s0,288(sp)
    800049ca:	6155                	addi	sp,sp,304
    800049cc:	8082                	ret

00000000800049ce <sys_unlink>:
{
    800049ce:	7151                	addi	sp,sp,-240
    800049d0:	f586                	sd	ra,232(sp)
    800049d2:	f1a2                	sd	s0,224(sp)
    800049d4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049d6:	08000613          	li	a2,128
    800049da:	f3040593          	addi	a1,s0,-208
    800049de:	4501                	li	a0,0
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	5f4080e7          	jalr	1524(ra) # 80001fd4 <argstr>
    800049e8:	1a054a63          	bltz	a0,80004b9c <sys_unlink+0x1ce>
    800049ec:	eda6                	sd	s1,216(sp)
  begin_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	b7e080e7          	jalr	-1154(ra) # 8000356c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049f6:	fb040593          	addi	a1,s0,-80
    800049fa:	f3040513          	addi	a0,s0,-208
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	98c080e7          	jalr	-1652(ra) # 8000338a <nameiparent>
    80004a06:	84aa                	mv	s1,a0
    80004a08:	cd71                	beqz	a0,80004ae4 <sys_unlink+0x116>
  ilock(dp);
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	190080e7          	jalr	400(ra) # 80002b9a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a12:	00004597          	auipc	a1,0x4
    80004a16:	b6e58593          	addi	a1,a1,-1170 # 80008580 <etext+0x580>
    80004a1a:	fb040513          	addi	a0,s0,-80
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	662080e7          	jalr	1634(ra) # 80003080 <namecmp>
    80004a26:	14050c63          	beqz	a0,80004b7e <sys_unlink+0x1b0>
    80004a2a:	00004597          	auipc	a1,0x4
    80004a2e:	b5e58593          	addi	a1,a1,-1186 # 80008588 <etext+0x588>
    80004a32:	fb040513          	addi	a0,s0,-80
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	64a080e7          	jalr	1610(ra) # 80003080 <namecmp>
    80004a3e:	14050063          	beqz	a0,80004b7e <sys_unlink+0x1b0>
    80004a42:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a44:	f2c40613          	addi	a2,s0,-212
    80004a48:	fb040593          	addi	a1,s0,-80
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	64c080e7          	jalr	1612(ra) # 8000309a <dirlookup>
    80004a56:	892a                	mv	s2,a0
    80004a58:	12050263          	beqz	a0,80004b7c <sys_unlink+0x1ae>
  ilock(ip);
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	13e080e7          	jalr	318(ra) # 80002b9a <ilock>
  if(ip->nlink < 1)
    80004a64:	04a91783          	lh	a5,74(s2)
    80004a68:	08f05563          	blez	a5,80004af2 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a6c:	04491703          	lh	a4,68(s2)
    80004a70:	4785                	li	a5,1
    80004a72:	08f70963          	beq	a4,a5,80004b04 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004a76:	4641                	li	a2,16
    80004a78:	4581                	li	a1,0
    80004a7a:	fc040513          	addi	a0,s0,-64
    80004a7e:	ffffb097          	auipc	ra,0xffffb
    80004a82:	6fc080e7          	jalr	1788(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a86:	4741                	li	a4,16
    80004a88:	f2c42683          	lw	a3,-212(s0)
    80004a8c:	fc040613          	addi	a2,s0,-64
    80004a90:	4581                	li	a1,0
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	4c2080e7          	jalr	1218(ra) # 80002f56 <writei>
    80004a9c:	47c1                	li	a5,16
    80004a9e:	0af51b63          	bne	a0,a5,80004b54 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004aa2:	04491703          	lh	a4,68(s2)
    80004aa6:	4785                	li	a5,1
    80004aa8:	0af70f63          	beq	a4,a5,80004b66 <sys_unlink+0x198>
  iunlockput(dp);
    80004aac:	8526                	mv	a0,s1
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	352080e7          	jalr	850(ra) # 80002e00 <iunlockput>
  ip->nlink--;
    80004ab6:	04a95783          	lhu	a5,74(s2)
    80004aba:	37fd                	addiw	a5,a5,-1
    80004abc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	00c080e7          	jalr	12(ra) # 80002ace <iupdate>
  iunlockput(ip);
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	334080e7          	jalr	820(ra) # 80002e00 <iunlockput>
  end_op();
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	b12080e7          	jalr	-1262(ra) # 800035e6 <end_op>
  return 0;
    80004adc:	4501                	li	a0,0
    80004ade:	64ee                	ld	s1,216(sp)
    80004ae0:	694e                	ld	s2,208(sp)
    80004ae2:	a84d                	j	80004b94 <sys_unlink+0x1c6>
    end_op();
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	b02080e7          	jalr	-1278(ra) # 800035e6 <end_op>
    return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	64ee                	ld	s1,216(sp)
    80004af0:	a055                	j	80004b94 <sys_unlink+0x1c6>
    80004af2:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004af4:	00004517          	auipc	a0,0x4
    80004af8:	abc50513          	addi	a0,a0,-1348 # 800085b0 <etext+0x5b0>
    80004afc:	00001097          	auipc	ra,0x1
    80004b00:	2ba080e7          	jalr	698(ra) # 80005db6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b04:	04c92703          	lw	a4,76(s2)
    80004b08:	02000793          	li	a5,32
    80004b0c:	f6e7f5e3          	bgeu	a5,a4,80004a76 <sys_unlink+0xa8>
    80004b10:	e5ce                	sd	s3,200(sp)
    80004b12:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b16:	4741                	li	a4,16
    80004b18:	86ce                	mv	a3,s3
    80004b1a:	f1840613          	addi	a2,s0,-232
    80004b1e:	4581                	li	a1,0
    80004b20:	854a                	mv	a0,s2
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	330080e7          	jalr	816(ra) # 80002e52 <readi>
    80004b2a:	47c1                	li	a5,16
    80004b2c:	00f51c63          	bne	a0,a5,80004b44 <sys_unlink+0x176>
    if(de.inum != 0)
    80004b30:	f1845783          	lhu	a5,-232(s0)
    80004b34:	e7b5                	bnez	a5,80004ba0 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b36:	29c1                	addiw	s3,s3,16
    80004b38:	04c92783          	lw	a5,76(s2)
    80004b3c:	fcf9ede3          	bltu	s3,a5,80004b16 <sys_unlink+0x148>
    80004b40:	69ae                	ld	s3,200(sp)
    80004b42:	bf15                	j	80004a76 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004b44:	00004517          	auipc	a0,0x4
    80004b48:	a8450513          	addi	a0,a0,-1404 # 800085c8 <etext+0x5c8>
    80004b4c:	00001097          	auipc	ra,0x1
    80004b50:	26a080e7          	jalr	618(ra) # 80005db6 <panic>
    80004b54:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004b56:	00004517          	auipc	a0,0x4
    80004b5a:	a8a50513          	addi	a0,a0,-1398 # 800085e0 <etext+0x5e0>
    80004b5e:	00001097          	auipc	ra,0x1
    80004b62:	258080e7          	jalr	600(ra) # 80005db6 <panic>
    dp->nlink--;
    80004b66:	04a4d783          	lhu	a5,74(s1)
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	f5c080e7          	jalr	-164(ra) # 80002ace <iupdate>
    80004b7a:	bf0d                	j	80004aac <sys_unlink+0xde>
    80004b7c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004b7e:	8526                	mv	a0,s1
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	280080e7          	jalr	640(ra) # 80002e00 <iunlockput>
  end_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	a5e080e7          	jalr	-1442(ra) # 800035e6 <end_op>
  return -1;
    80004b90:	557d                	li	a0,-1
    80004b92:	64ee                	ld	s1,216(sp)
}
    80004b94:	70ae                	ld	ra,232(sp)
    80004b96:	740e                	ld	s0,224(sp)
    80004b98:	616d                	addi	sp,sp,240
    80004b9a:	8082                	ret
    return -1;
    80004b9c:	557d                	li	a0,-1
    80004b9e:	bfdd                	j	80004b94 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	25e080e7          	jalr	606(ra) # 80002e00 <iunlockput>
    goto bad;
    80004baa:	694e                	ld	s2,208(sp)
    80004bac:	69ae                	ld	s3,200(sp)
    80004bae:	bfc1                	j	80004b7e <sys_unlink+0x1b0>

0000000080004bb0 <sys_open>:

uint64
sys_open(void)
{
    80004bb0:	7131                	addi	sp,sp,-192
    80004bb2:	fd06                	sd	ra,184(sp)
    80004bb4:	f922                	sd	s0,176(sp)
    80004bb6:	f526                	sd	s1,168(sp)
    80004bb8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bba:	08000613          	li	a2,128
    80004bbe:	f5040593          	addi	a1,s0,-176
    80004bc2:	4501                	li	a0,0
    80004bc4:	ffffd097          	auipc	ra,0xffffd
    80004bc8:	410080e7          	jalr	1040(ra) # 80001fd4 <argstr>
    return -1;
    80004bcc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bce:	0c054463          	bltz	a0,80004c96 <sys_open+0xe6>
    80004bd2:	f4c40593          	addi	a1,s0,-180
    80004bd6:	4505                	li	a0,1
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	3b8080e7          	jalr	952(ra) # 80001f90 <argint>
    80004be0:	0a054b63          	bltz	a0,80004c96 <sys_open+0xe6>
    80004be4:	f14a                	sd	s2,160(sp)

  begin_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	986080e7          	jalr	-1658(ra) # 8000356c <begin_op>

  if(omode & O_CREATE){
    80004bee:	f4c42783          	lw	a5,-180(s0)
    80004bf2:	2007f793          	andi	a5,a5,512
    80004bf6:	cfc5                	beqz	a5,80004cae <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bf8:	4681                	li	a3,0
    80004bfa:	4601                	li	a2,0
    80004bfc:	4589                	li	a1,2
    80004bfe:	f5040513          	addi	a0,s0,-176
    80004c02:	00000097          	auipc	ra,0x0
    80004c06:	958080e7          	jalr	-1704(ra) # 8000455a <create>
    80004c0a:	892a                	mv	s2,a0
    if(ip == 0){
    80004c0c:	c959                	beqz	a0,80004ca2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c0e:	04491703          	lh	a4,68(s2)
    80004c12:	478d                	li	a5,3
    80004c14:	00f71763          	bne	a4,a5,80004c22 <sys_open+0x72>
    80004c18:	04695703          	lhu	a4,70(s2)
    80004c1c:	47a5                	li	a5,9
    80004c1e:	0ce7ef63          	bltu	a5,a4,80004cfc <sys_open+0x14c>
    80004c22:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	d56080e7          	jalr	-682(ra) # 8000397a <filealloc>
    80004c2c:	89aa                	mv	s3,a0
    80004c2e:	c965                	beqz	a0,80004d1e <sys_open+0x16e>
    80004c30:	00000097          	auipc	ra,0x0
    80004c34:	8e8080e7          	jalr	-1816(ra) # 80004518 <fdalloc>
    80004c38:	84aa                	mv	s1,a0
    80004c3a:	0c054d63          	bltz	a0,80004d14 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c3e:	04491703          	lh	a4,68(s2)
    80004c42:	478d                	li	a5,3
    80004c44:	0ef70a63          	beq	a4,a5,80004d38 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c48:	4789                	li	a5,2
    80004c4a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c4e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c52:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c56:	f4c42783          	lw	a5,-180(s0)
    80004c5a:	0017c713          	xori	a4,a5,1
    80004c5e:	8b05                	andi	a4,a4,1
    80004c60:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c64:	0037f713          	andi	a4,a5,3
    80004c68:	00e03733          	snez	a4,a4
    80004c6c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c70:	4007f793          	andi	a5,a5,1024
    80004c74:	c791                	beqz	a5,80004c80 <sys_open+0xd0>
    80004c76:	04491703          	lh	a4,68(s2)
    80004c7a:	4789                	li	a5,2
    80004c7c:	0cf70563          	beq	a4,a5,80004d46 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004c80:	854a                	mv	a0,s2
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	fde080e7          	jalr	-34(ra) # 80002c60 <iunlock>
  end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	95c080e7          	jalr	-1700(ra) # 800035e6 <end_op>
    80004c92:	790a                	ld	s2,160(sp)
    80004c94:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c96:	8526                	mv	a0,s1
    80004c98:	70ea                	ld	ra,184(sp)
    80004c9a:	744a                	ld	s0,176(sp)
    80004c9c:	74aa                	ld	s1,168(sp)
    80004c9e:	6129                	addi	sp,sp,192
    80004ca0:	8082                	ret
      end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	944080e7          	jalr	-1724(ra) # 800035e6 <end_op>
      return -1;
    80004caa:	790a                	ld	s2,160(sp)
    80004cac:	b7ed                	j	80004c96 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004cae:	f5040513          	addi	a0,s0,-176
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	6ba080e7          	jalr	1722(ra) # 8000336c <namei>
    80004cba:	892a                	mv	s2,a0
    80004cbc:	c90d                	beqz	a0,80004cee <sys_open+0x13e>
    ilock(ip);
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	edc080e7          	jalr	-292(ra) # 80002b9a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cc6:	04491703          	lh	a4,68(s2)
    80004cca:	4785                	li	a5,1
    80004ccc:	f4f711e3          	bne	a4,a5,80004c0e <sys_open+0x5e>
    80004cd0:	f4c42783          	lw	a5,-180(s0)
    80004cd4:	d7b9                	beqz	a5,80004c22 <sys_open+0x72>
      iunlockput(ip);
    80004cd6:	854a                	mv	a0,s2
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	128080e7          	jalr	296(ra) # 80002e00 <iunlockput>
      end_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	906080e7          	jalr	-1786(ra) # 800035e6 <end_op>
      return -1;
    80004ce8:	54fd                	li	s1,-1
    80004cea:	790a                	ld	s2,160(sp)
    80004cec:	b76d                	j	80004c96 <sys_open+0xe6>
      end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	8f8080e7          	jalr	-1800(ra) # 800035e6 <end_op>
      return -1;
    80004cf6:	54fd                	li	s1,-1
    80004cf8:	790a                	ld	s2,160(sp)
    80004cfa:	bf71                	j	80004c96 <sys_open+0xe6>
    iunlockput(ip);
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	102080e7          	jalr	258(ra) # 80002e00 <iunlockput>
    end_op();
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	8e0080e7          	jalr	-1824(ra) # 800035e6 <end_op>
    return -1;
    80004d0e:	54fd                	li	s1,-1
    80004d10:	790a                	ld	s2,160(sp)
    80004d12:	b751                	j	80004c96 <sys_open+0xe6>
      fileclose(f);
    80004d14:	854e                	mv	a0,s3
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	d20080e7          	jalr	-736(ra) # 80003a36 <fileclose>
    iunlockput(ip);
    80004d1e:	854a                	mv	a0,s2
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	0e0080e7          	jalr	224(ra) # 80002e00 <iunlockput>
    end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	8be080e7          	jalr	-1858(ra) # 800035e6 <end_op>
    return -1;
    80004d30:	54fd                	li	s1,-1
    80004d32:	790a                	ld	s2,160(sp)
    80004d34:	69ea                	ld	s3,152(sp)
    80004d36:	b785                	j	80004c96 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004d38:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d3c:	04691783          	lh	a5,70(s2)
    80004d40:	02f99223          	sh	a5,36(s3)
    80004d44:	b739                	j	80004c52 <sys_open+0xa2>
    itrunc(ip);
    80004d46:	854a                	mv	a0,s2
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	f64080e7          	jalr	-156(ra) # 80002cac <itrunc>
    80004d50:	bf05                	j	80004c80 <sys_open+0xd0>

0000000080004d52 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d52:	7175                	addi	sp,sp,-144
    80004d54:	e506                	sd	ra,136(sp)
    80004d56:	e122                	sd	s0,128(sp)
    80004d58:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	812080e7          	jalr	-2030(ra) # 8000356c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d62:	08000613          	li	a2,128
    80004d66:	f7040593          	addi	a1,s0,-144
    80004d6a:	4501                	li	a0,0
    80004d6c:	ffffd097          	auipc	ra,0xffffd
    80004d70:	268080e7          	jalr	616(ra) # 80001fd4 <argstr>
    80004d74:	02054963          	bltz	a0,80004da6 <sys_mkdir+0x54>
    80004d78:	4681                	li	a3,0
    80004d7a:	4601                	li	a2,0
    80004d7c:	4585                	li	a1,1
    80004d7e:	f7040513          	addi	a0,s0,-144
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	7d8080e7          	jalr	2008(ra) # 8000455a <create>
    80004d8a:	cd11                	beqz	a0,80004da6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	074080e7          	jalr	116(ra) # 80002e00 <iunlockput>
  end_op();
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	852080e7          	jalr	-1966(ra) # 800035e6 <end_op>
  return 0;
    80004d9c:	4501                	li	a0,0
}
    80004d9e:	60aa                	ld	ra,136(sp)
    80004da0:	640a                	ld	s0,128(sp)
    80004da2:	6149                	addi	sp,sp,144
    80004da4:	8082                	ret
    end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	840080e7          	jalr	-1984(ra) # 800035e6 <end_op>
    return -1;
    80004dae:	557d                	li	a0,-1
    80004db0:	b7fd                	j	80004d9e <sys_mkdir+0x4c>

0000000080004db2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004db2:	7135                	addi	sp,sp,-160
    80004db4:	ed06                	sd	ra,152(sp)
    80004db6:	e922                	sd	s0,144(sp)
    80004db8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	7b2080e7          	jalr	1970(ra) # 8000356c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dc2:	08000613          	li	a2,128
    80004dc6:	f7040593          	addi	a1,s0,-144
    80004dca:	4501                	li	a0,0
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	208080e7          	jalr	520(ra) # 80001fd4 <argstr>
    80004dd4:	04054a63          	bltz	a0,80004e28 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004dd8:	f6c40593          	addi	a1,s0,-148
    80004ddc:	4505                	li	a0,1
    80004dde:	ffffd097          	auipc	ra,0xffffd
    80004de2:	1b2080e7          	jalr	434(ra) # 80001f90 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004de6:	04054163          	bltz	a0,80004e28 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dea:	f6840593          	addi	a1,s0,-152
    80004dee:	4509                	li	a0,2
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	1a0080e7          	jalr	416(ra) # 80001f90 <argint>
     argint(1, &major) < 0 ||
    80004df8:	02054863          	bltz	a0,80004e28 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dfc:	f6841683          	lh	a3,-152(s0)
    80004e00:	f6c41603          	lh	a2,-148(s0)
    80004e04:	458d                	li	a1,3
    80004e06:	f7040513          	addi	a0,s0,-144
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	750080e7          	jalr	1872(ra) # 8000455a <create>
     argint(2, &minor) < 0 ||
    80004e12:	c919                	beqz	a0,80004e28 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	fec080e7          	jalr	-20(ra) # 80002e00 <iunlockput>
  end_op();
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	7ca080e7          	jalr	1994(ra) # 800035e6 <end_op>
  return 0;
    80004e24:	4501                	li	a0,0
    80004e26:	a031                	j	80004e32 <sys_mknod+0x80>
    end_op();
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	7be080e7          	jalr	1982(ra) # 800035e6 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
}
    80004e32:	60ea                	ld	ra,152(sp)
    80004e34:	644a                	ld	s0,144(sp)
    80004e36:	610d                	addi	sp,sp,160
    80004e38:	8082                	ret

0000000080004e3a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e3a:	7135                	addi	sp,sp,-160
    80004e3c:	ed06                	sd	ra,152(sp)
    80004e3e:	e922                	sd	s0,144(sp)
    80004e40:	e14a                	sd	s2,128(sp)
    80004e42:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e44:	ffffc097          	auipc	ra,0xffffc
    80004e48:	038080e7          	jalr	56(ra) # 80000e7c <myproc>
    80004e4c:	892a                	mv	s2,a0
  
  begin_op();
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	71e080e7          	jalr	1822(ra) # 8000356c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e56:	08000613          	li	a2,128
    80004e5a:	f6040593          	addi	a1,s0,-160
    80004e5e:	4501                	li	a0,0
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	174080e7          	jalr	372(ra) # 80001fd4 <argstr>
    80004e68:	04054d63          	bltz	a0,80004ec2 <sys_chdir+0x88>
    80004e6c:	e526                	sd	s1,136(sp)
    80004e6e:	f6040513          	addi	a0,s0,-160
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	4fa080e7          	jalr	1274(ra) # 8000336c <namei>
    80004e7a:	84aa                	mv	s1,a0
    80004e7c:	c131                	beqz	a0,80004ec0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	d1c080e7          	jalr	-740(ra) # 80002b9a <ilock>
  if(ip->type != T_DIR){
    80004e86:	04449703          	lh	a4,68(s1)
    80004e8a:	4785                	li	a5,1
    80004e8c:	04f71163          	bne	a4,a5,80004ece <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	dce080e7          	jalr	-562(ra) # 80002c60 <iunlock>
  iput(p->cwd);
    80004e9a:	15093503          	ld	a0,336(s2)
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	eba080e7          	jalr	-326(ra) # 80002d58 <iput>
  end_op();
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	740080e7          	jalr	1856(ra) # 800035e6 <end_op>
  p->cwd = ip;
    80004eae:	14993823          	sd	s1,336(s2)
  return 0;
    80004eb2:	4501                	li	a0,0
    80004eb4:	64aa                	ld	s1,136(sp)
}
    80004eb6:	60ea                	ld	ra,152(sp)
    80004eb8:	644a                	ld	s0,144(sp)
    80004eba:	690a                	ld	s2,128(sp)
    80004ebc:	610d                	addi	sp,sp,160
    80004ebe:	8082                	ret
    80004ec0:	64aa                	ld	s1,136(sp)
    end_op();
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	724080e7          	jalr	1828(ra) # 800035e6 <end_op>
    return -1;
    80004eca:	557d                	li	a0,-1
    80004ecc:	b7ed                	j	80004eb6 <sys_chdir+0x7c>
    iunlockput(ip);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	f30080e7          	jalr	-208(ra) # 80002e00 <iunlockput>
    end_op();
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	70e080e7          	jalr	1806(ra) # 800035e6 <end_op>
    return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	64aa                	ld	s1,136(sp)
    80004ee4:	bfc9                	j	80004eb6 <sys_chdir+0x7c>

0000000080004ee6 <sys_exec>:

uint64
sys_exec(void)
{
    80004ee6:	7121                	addi	sp,sp,-448
    80004ee8:	ff06                	sd	ra,440(sp)
    80004eea:	fb22                	sd	s0,432(sp)
    80004eec:	f34a                	sd	s2,416(sp)
    80004eee:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ef0:	08000613          	li	a2,128
    80004ef4:	f5040593          	addi	a1,s0,-176
    80004ef8:	4501                	li	a0,0
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	0da080e7          	jalr	218(ra) # 80001fd4 <argstr>
    return -1;
    80004f02:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f04:	0e054a63          	bltz	a0,80004ff8 <sys_exec+0x112>
    80004f08:	e4840593          	addi	a1,s0,-440
    80004f0c:	4505                	li	a0,1
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	0a4080e7          	jalr	164(ra) # 80001fb2 <argaddr>
    80004f16:	0e054163          	bltz	a0,80004ff8 <sys_exec+0x112>
    80004f1a:	f726                	sd	s1,424(sp)
    80004f1c:	ef4e                	sd	s3,408(sp)
    80004f1e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f20:	10000613          	li	a2,256
    80004f24:	4581                	li	a1,0
    80004f26:	e5040513          	addi	a0,s0,-432
    80004f2a:	ffffb097          	auipc	ra,0xffffb
    80004f2e:	250080e7          	jalr	592(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f32:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f36:	89a6                	mv	s3,s1
    80004f38:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f3a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f3e:	00391513          	slli	a0,s2,0x3
    80004f42:	e4040593          	addi	a1,s0,-448
    80004f46:	e4843783          	ld	a5,-440(s0)
    80004f4a:	953e                	add	a0,a0,a5
    80004f4c:	ffffd097          	auipc	ra,0xffffd
    80004f50:	faa080e7          	jalr	-86(ra) # 80001ef6 <fetchaddr>
    80004f54:	02054a63          	bltz	a0,80004f88 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004f58:	e4043783          	ld	a5,-448(s0)
    80004f5c:	c7b1                	beqz	a5,80004fa8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f5e:	ffffb097          	auipc	ra,0xffffb
    80004f62:	1bc080e7          	jalr	444(ra) # 8000011a <kalloc>
    80004f66:	85aa                	mv	a1,a0
    80004f68:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f6c:	cd11                	beqz	a0,80004f88 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f6e:	6605                	lui	a2,0x1
    80004f70:	e4043503          	ld	a0,-448(s0)
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	fd4080e7          	jalr	-44(ra) # 80001f48 <fetchstr>
    80004f7c:	00054663          	bltz	a0,80004f88 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004f80:	0905                	addi	s2,s2,1
    80004f82:	09a1                	addi	s3,s3,8
    80004f84:	fb491de3          	bne	s2,s4,80004f3e <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f88:	f5040913          	addi	s2,s0,-176
    80004f8c:	6088                	ld	a0,0(s1)
    80004f8e:	c12d                	beqz	a0,80004ff0 <sys_exec+0x10a>
    kfree(argv[i]);
    80004f90:	ffffb097          	auipc	ra,0xffffb
    80004f94:	08c080e7          	jalr	140(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f98:	04a1                	addi	s1,s1,8
    80004f9a:	ff2499e3          	bne	s1,s2,80004f8c <sys_exec+0xa6>
  return -1;
    80004f9e:	597d                	li	s2,-1
    80004fa0:	74ba                	ld	s1,424(sp)
    80004fa2:	69fa                	ld	s3,408(sp)
    80004fa4:	6a5a                	ld	s4,400(sp)
    80004fa6:	a889                	j	80004ff8 <sys_exec+0x112>
      argv[i] = 0;
    80004fa8:	0009079b          	sext.w	a5,s2
    80004fac:	078e                	slli	a5,a5,0x3
    80004fae:	fd078793          	addi	a5,a5,-48
    80004fb2:	97a2                	add	a5,a5,s0
    80004fb4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004fb8:	e5040593          	addi	a1,s0,-432
    80004fbc:	f5040513          	addi	a0,s0,-176
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	126080e7          	jalr	294(ra) # 800040e6 <exec>
    80004fc8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fca:	f5040993          	addi	s3,s0,-176
    80004fce:	6088                	ld	a0,0(s1)
    80004fd0:	cd01                	beqz	a0,80004fe8 <sys_exec+0x102>
    kfree(argv[i]);
    80004fd2:	ffffb097          	auipc	ra,0xffffb
    80004fd6:	04a080e7          	jalr	74(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fda:	04a1                	addi	s1,s1,8
    80004fdc:	ff3499e3          	bne	s1,s3,80004fce <sys_exec+0xe8>
    80004fe0:	74ba                	ld	s1,424(sp)
    80004fe2:	69fa                	ld	s3,408(sp)
    80004fe4:	6a5a                	ld	s4,400(sp)
    80004fe6:	a809                	j	80004ff8 <sys_exec+0x112>
  return ret;
    80004fe8:	74ba                	ld	s1,424(sp)
    80004fea:	69fa                	ld	s3,408(sp)
    80004fec:	6a5a                	ld	s4,400(sp)
    80004fee:	a029                	j	80004ff8 <sys_exec+0x112>
  return -1;
    80004ff0:	597d                	li	s2,-1
    80004ff2:	74ba                	ld	s1,424(sp)
    80004ff4:	69fa                	ld	s3,408(sp)
    80004ff6:	6a5a                	ld	s4,400(sp)
}
    80004ff8:	854a                	mv	a0,s2
    80004ffa:	70fa                	ld	ra,440(sp)
    80004ffc:	745a                	ld	s0,432(sp)
    80004ffe:	791a                	ld	s2,416(sp)
    80005000:	6139                	addi	sp,sp,448
    80005002:	8082                	ret

0000000080005004 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005004:	7139                	addi	sp,sp,-64
    80005006:	fc06                	sd	ra,56(sp)
    80005008:	f822                	sd	s0,48(sp)
    8000500a:	f426                	sd	s1,40(sp)
    8000500c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000500e:	ffffc097          	auipc	ra,0xffffc
    80005012:	e6e080e7          	jalr	-402(ra) # 80000e7c <myproc>
    80005016:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005018:	fd840593          	addi	a1,s0,-40
    8000501c:	4501                	li	a0,0
    8000501e:	ffffd097          	auipc	ra,0xffffd
    80005022:	f94080e7          	jalr	-108(ra) # 80001fb2 <argaddr>
    return -1;
    80005026:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005028:	0e054063          	bltz	a0,80005108 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000502c:	fc840593          	addi	a1,s0,-56
    80005030:	fd040513          	addi	a0,s0,-48
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	d70080e7          	jalr	-656(ra) # 80003da4 <pipealloc>
    return -1;
    8000503c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000503e:	0c054563          	bltz	a0,80005108 <sys_pipe+0x104>
  fd0 = -1;
    80005042:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005046:	fd043503          	ld	a0,-48(s0)
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	4ce080e7          	jalr	1230(ra) # 80004518 <fdalloc>
    80005052:	fca42223          	sw	a0,-60(s0)
    80005056:	08054c63          	bltz	a0,800050ee <sys_pipe+0xea>
    8000505a:	fc843503          	ld	a0,-56(s0)
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	4ba080e7          	jalr	1210(ra) # 80004518 <fdalloc>
    80005066:	fca42023          	sw	a0,-64(s0)
    8000506a:	06054963          	bltz	a0,800050dc <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000506e:	4691                	li	a3,4
    80005070:	fc440613          	addi	a2,s0,-60
    80005074:	fd843583          	ld	a1,-40(s0)
    80005078:	68a8                	ld	a0,80(s1)
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	a9e080e7          	jalr	-1378(ra) # 80000b18 <copyout>
    80005082:	02054063          	bltz	a0,800050a2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005086:	4691                	li	a3,4
    80005088:	fc040613          	addi	a2,s0,-64
    8000508c:	fd843583          	ld	a1,-40(s0)
    80005090:	0591                	addi	a1,a1,4
    80005092:	68a8                	ld	a0,80(s1)
    80005094:	ffffc097          	auipc	ra,0xffffc
    80005098:	a84080e7          	jalr	-1404(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000509c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000509e:	06055563          	bgez	a0,80005108 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050a2:	fc442783          	lw	a5,-60(s0)
    800050a6:	07e9                	addi	a5,a5,26
    800050a8:	078e                	slli	a5,a5,0x3
    800050aa:	97a6                	add	a5,a5,s1
    800050ac:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050b0:	fc042783          	lw	a5,-64(s0)
    800050b4:	07e9                	addi	a5,a5,26
    800050b6:	078e                	slli	a5,a5,0x3
    800050b8:	00f48533          	add	a0,s1,a5
    800050bc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050c0:	fd043503          	ld	a0,-48(s0)
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	972080e7          	jalr	-1678(ra) # 80003a36 <fileclose>
    fileclose(wf);
    800050cc:	fc843503          	ld	a0,-56(s0)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	966080e7          	jalr	-1690(ra) # 80003a36 <fileclose>
    return -1;
    800050d8:	57fd                	li	a5,-1
    800050da:	a03d                	j	80005108 <sys_pipe+0x104>
    if(fd0 >= 0)
    800050dc:	fc442783          	lw	a5,-60(s0)
    800050e0:	0007c763          	bltz	a5,800050ee <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050e4:	07e9                	addi	a5,a5,26
    800050e6:	078e                	slli	a5,a5,0x3
    800050e8:	97a6                	add	a5,a5,s1
    800050ea:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050ee:	fd043503          	ld	a0,-48(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	944080e7          	jalr	-1724(ra) # 80003a36 <fileclose>
    fileclose(wf);
    800050fa:	fc843503          	ld	a0,-56(s0)
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	938080e7          	jalr	-1736(ra) # 80003a36 <fileclose>
    return -1;
    80005106:	57fd                	li	a5,-1
}
    80005108:	853e                	mv	a0,a5
    8000510a:	70e2                	ld	ra,56(sp)
    8000510c:	7442                	ld	s0,48(sp)
    8000510e:	74a2                	ld	s1,40(sp)
    80005110:	6121                	addi	sp,sp,64
    80005112:	8082                	ret
	...

0000000080005120 <kernelvec>:
    80005120:	7111                	addi	sp,sp,-256
    80005122:	e006                	sd	ra,0(sp)
    80005124:	e40a                	sd	sp,8(sp)
    80005126:	e80e                	sd	gp,16(sp)
    80005128:	ec12                	sd	tp,24(sp)
    8000512a:	f016                	sd	t0,32(sp)
    8000512c:	f41a                	sd	t1,40(sp)
    8000512e:	f81e                	sd	t2,48(sp)
    80005130:	fc22                	sd	s0,56(sp)
    80005132:	e0a6                	sd	s1,64(sp)
    80005134:	e4aa                	sd	a0,72(sp)
    80005136:	e8ae                	sd	a1,80(sp)
    80005138:	ecb2                	sd	a2,88(sp)
    8000513a:	f0b6                	sd	a3,96(sp)
    8000513c:	f4ba                	sd	a4,104(sp)
    8000513e:	f8be                	sd	a5,112(sp)
    80005140:	fcc2                	sd	a6,120(sp)
    80005142:	e146                	sd	a7,128(sp)
    80005144:	e54a                	sd	s2,136(sp)
    80005146:	e94e                	sd	s3,144(sp)
    80005148:	ed52                	sd	s4,152(sp)
    8000514a:	f156                	sd	s5,160(sp)
    8000514c:	f55a                	sd	s6,168(sp)
    8000514e:	f95e                	sd	s7,176(sp)
    80005150:	fd62                	sd	s8,184(sp)
    80005152:	e1e6                	sd	s9,192(sp)
    80005154:	e5ea                	sd	s10,200(sp)
    80005156:	e9ee                	sd	s11,208(sp)
    80005158:	edf2                	sd	t3,216(sp)
    8000515a:	f1f6                	sd	t4,224(sp)
    8000515c:	f5fa                	sd	t5,232(sp)
    8000515e:	f9fe                	sd	t6,240(sp)
    80005160:	c63fc0ef          	jal	80001dc2 <kerneltrap>
    80005164:	6082                	ld	ra,0(sp)
    80005166:	6122                	ld	sp,8(sp)
    80005168:	61c2                	ld	gp,16(sp)
    8000516a:	7282                	ld	t0,32(sp)
    8000516c:	7322                	ld	t1,40(sp)
    8000516e:	73c2                	ld	t2,48(sp)
    80005170:	7462                	ld	s0,56(sp)
    80005172:	6486                	ld	s1,64(sp)
    80005174:	6526                	ld	a0,72(sp)
    80005176:	65c6                	ld	a1,80(sp)
    80005178:	6666                	ld	a2,88(sp)
    8000517a:	7686                	ld	a3,96(sp)
    8000517c:	7726                	ld	a4,104(sp)
    8000517e:	77c6                	ld	a5,112(sp)
    80005180:	7866                	ld	a6,120(sp)
    80005182:	688a                	ld	a7,128(sp)
    80005184:	692a                	ld	s2,136(sp)
    80005186:	69ca                	ld	s3,144(sp)
    80005188:	6a6a                	ld	s4,152(sp)
    8000518a:	7a8a                	ld	s5,160(sp)
    8000518c:	7b2a                	ld	s6,168(sp)
    8000518e:	7bca                	ld	s7,176(sp)
    80005190:	7c6a                	ld	s8,184(sp)
    80005192:	6c8e                	ld	s9,192(sp)
    80005194:	6d2e                	ld	s10,200(sp)
    80005196:	6dce                	ld	s11,208(sp)
    80005198:	6e6e                	ld	t3,216(sp)
    8000519a:	7e8e                	ld	t4,224(sp)
    8000519c:	7f2e                	ld	t5,232(sp)
    8000519e:	7fce                	ld	t6,240(sp)
    800051a0:	6111                	addi	sp,sp,256
    800051a2:	10200073          	sret
    800051a6:	00000013          	nop
    800051aa:	00000013          	nop
    800051ae:	0001                	nop

00000000800051b0 <timervec>:
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	e10c                	sd	a1,0(a0)
    800051b6:	e510                	sd	a2,8(a0)
    800051b8:	e914                	sd	a3,16(a0)
    800051ba:	6d0c                	ld	a1,24(a0)
    800051bc:	7110                	ld	a2,32(a0)
    800051be:	6194                	ld	a3,0(a1)
    800051c0:	96b2                	add	a3,a3,a2
    800051c2:	e194                	sd	a3,0(a1)
    800051c4:	4589                	li	a1,2
    800051c6:	14459073          	csrw	sip,a1
    800051ca:	6914                	ld	a3,16(a0)
    800051cc:	6510                	ld	a2,8(a0)
    800051ce:	610c                	ld	a1,0(a0)
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	30200073          	mret
	...

00000000800051da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051da:	1141                	addi	sp,sp,-16
    800051dc:	e422                	sd	s0,8(sp)
    800051de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051e0:	0c0007b7          	lui	a5,0xc000
    800051e4:	4705                	li	a4,1
    800051e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051e8:	0c0007b7          	lui	a5,0xc000
    800051ec:	c3d8                	sw	a4,4(a5)
}
    800051ee:	6422                	ld	s0,8(sp)
    800051f0:	0141                	addi	sp,sp,16
    800051f2:	8082                	ret

00000000800051f4 <plicinithart>:

void
plicinithart(void)
{
    800051f4:	1141                	addi	sp,sp,-16
    800051f6:	e406                	sd	ra,8(sp)
    800051f8:	e022                	sd	s0,0(sp)
    800051fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	c54080e7          	jalr	-940(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005204:	0085171b          	slliw	a4,a0,0x8
    80005208:	0c0027b7          	lui	a5,0xc002
    8000520c:	97ba                	add	a5,a5,a4
    8000520e:	40200713          	li	a4,1026
    80005212:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005216:	00d5151b          	slliw	a0,a0,0xd
    8000521a:	0c2017b7          	lui	a5,0xc201
    8000521e:	97aa                	add	a5,a5,a0
    80005220:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005224:	60a2                	ld	ra,8(sp)
    80005226:	6402                	ld	s0,0(sp)
    80005228:	0141                	addi	sp,sp,16
    8000522a:	8082                	ret

000000008000522c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000522c:	1141                	addi	sp,sp,-16
    8000522e:	e406                	sd	ra,8(sp)
    80005230:	e022                	sd	s0,0(sp)
    80005232:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005234:	ffffc097          	auipc	ra,0xffffc
    80005238:	c1c080e7          	jalr	-996(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000523c:	00d5151b          	slliw	a0,a0,0xd
    80005240:	0c2017b7          	lui	a5,0xc201
    80005244:	97aa                	add	a5,a5,a0
  return irq;
}
    80005246:	43c8                	lw	a0,4(a5)
    80005248:	60a2                	ld	ra,8(sp)
    8000524a:	6402                	ld	s0,0(sp)
    8000524c:	0141                	addi	sp,sp,16
    8000524e:	8082                	ret

0000000080005250 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005250:	1101                	addi	sp,sp,-32
    80005252:	ec06                	sd	ra,24(sp)
    80005254:	e822                	sd	s0,16(sp)
    80005256:	e426                	sd	s1,8(sp)
    80005258:	1000                	addi	s0,sp,32
    8000525a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	bf4080e7          	jalr	-1036(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005264:	00d5151b          	slliw	a0,a0,0xd
    80005268:	0c2017b7          	lui	a5,0xc201
    8000526c:	97aa                	add	a5,a5,a0
    8000526e:	c3c4                	sw	s1,4(a5)
}
    80005270:	60e2                	ld	ra,24(sp)
    80005272:	6442                	ld	s0,16(sp)
    80005274:	64a2                	ld	s1,8(sp)
    80005276:	6105                	addi	sp,sp,32
    80005278:	8082                	ret

000000008000527a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000527a:	1141                	addi	sp,sp,-16
    8000527c:	e406                	sd	ra,8(sp)
    8000527e:	e022                	sd	s0,0(sp)
    80005280:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005282:	479d                	li	a5,7
    80005284:	06a7c863          	blt	a5,a0,800052f4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005288:	0001d717          	auipc	a4,0x1d
    8000528c:	d7870713          	addi	a4,a4,-648 # 80022000 <disk>
    80005290:	972a                	add	a4,a4,a0
    80005292:	6789                	lui	a5,0x2
    80005294:	97ba                	add	a5,a5,a4
    80005296:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000529a:	e7ad                	bnez	a5,80005304 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000529c:	00451793          	slli	a5,a0,0x4
    800052a0:	0001f717          	auipc	a4,0x1f
    800052a4:	d6070713          	addi	a4,a4,-672 # 80024000 <disk+0x2000>
    800052a8:	6314                	ld	a3,0(a4)
    800052aa:	96be                	add	a3,a3,a5
    800052ac:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052b0:	6314                	ld	a3,0(a4)
    800052b2:	96be                	add	a3,a3,a5
    800052b4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052b8:	6314                	ld	a3,0(a4)
    800052ba:	96be                	add	a3,a3,a5
    800052bc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052c0:	6318                	ld	a4,0(a4)
    800052c2:	97ba                	add	a5,a5,a4
    800052c4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052c8:	0001d717          	auipc	a4,0x1d
    800052cc:	d3870713          	addi	a4,a4,-712 # 80022000 <disk>
    800052d0:	972a                	add	a4,a4,a0
    800052d2:	6789                	lui	a5,0x2
    800052d4:	97ba                	add	a5,a5,a4
    800052d6:	4705                	li	a4,1
    800052d8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052dc:	0001f517          	auipc	a0,0x1f
    800052e0:	d3c50513          	addi	a0,a0,-708 # 80024018 <disk+0x2018>
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	3fc080e7          	jalr	1020(ra) # 800016e0 <wakeup>
}
    800052ec:	60a2                	ld	ra,8(sp)
    800052ee:	6402                	ld	s0,0(sp)
    800052f0:	0141                	addi	sp,sp,16
    800052f2:	8082                	ret
    panic("free_desc 1");
    800052f4:	00003517          	auipc	a0,0x3
    800052f8:	2fc50513          	addi	a0,a0,764 # 800085f0 <etext+0x5f0>
    800052fc:	00001097          	auipc	ra,0x1
    80005300:	aba080e7          	jalr	-1350(ra) # 80005db6 <panic>
    panic("free_desc 2");
    80005304:	00003517          	auipc	a0,0x3
    80005308:	2fc50513          	addi	a0,a0,764 # 80008600 <etext+0x600>
    8000530c:	00001097          	auipc	ra,0x1
    80005310:	aaa080e7          	jalr	-1366(ra) # 80005db6 <panic>

0000000080005314 <virtio_disk_init>:
{
    80005314:	1141                	addi	sp,sp,-16
    80005316:	e406                	sd	ra,8(sp)
    80005318:	e022                	sd	s0,0(sp)
    8000531a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000531c:	00003597          	auipc	a1,0x3
    80005320:	2f458593          	addi	a1,a1,756 # 80008610 <etext+0x610>
    80005324:	0001f517          	auipc	a0,0x1f
    80005328:	e0450513          	addi	a0,a0,-508 # 80024128 <disk+0x2128>
    8000532c:	00001097          	auipc	ra,0x1
    80005330:	f4a080e7          	jalr	-182(ra) # 80006276 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005334:	100017b7          	lui	a5,0x10001
    80005338:	4398                	lw	a4,0(a5)
    8000533a:	2701                	sext.w	a4,a4
    8000533c:	747277b7          	lui	a5,0x74727
    80005340:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005344:	0ef71f63          	bne	a4,a5,80005442 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005348:	100017b7          	lui	a5,0x10001
    8000534c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000534e:	439c                	lw	a5,0(a5)
    80005350:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005352:	4705                	li	a4,1
    80005354:	0ee79763          	bne	a5,a4,80005442 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005358:	100017b7          	lui	a5,0x10001
    8000535c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000535e:	439c                	lw	a5,0(a5)
    80005360:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005362:	4709                	li	a4,2
    80005364:	0ce79f63          	bne	a5,a4,80005442 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005368:	100017b7          	lui	a5,0x10001
    8000536c:	47d8                	lw	a4,12(a5)
    8000536e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005370:	554d47b7          	lui	a5,0x554d4
    80005374:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005378:	0cf71563          	bne	a4,a5,80005442 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537c:	100017b7          	lui	a5,0x10001
    80005380:	4705                	li	a4,1
    80005382:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005384:	470d                	li	a4,3
    80005386:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005388:	10001737          	lui	a4,0x10001
    8000538c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000538e:	c7ffe737          	lui	a4,0xc7ffe
    80005392:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd151f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005396:	8ef9                	and	a3,a3,a4
    80005398:	10001737          	lui	a4,0x10001
    8000539c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539e:	472d                	li	a4,11
    800053a0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a2:	473d                	li	a4,15
    800053a4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053a6:	100017b7          	lui	a5,0x10001
    800053aa:	6705                	lui	a4,0x1
    800053ac:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053ae:	100017b7          	lui	a5,0x10001
    800053b2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053b6:	100017b7          	lui	a5,0x10001
    800053ba:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800053be:	439c                	lw	a5,0(a5)
    800053c0:	2781                	sext.w	a5,a5
  if(max == 0)
    800053c2:	cbc1                	beqz	a5,80005452 <virtio_disk_init+0x13e>
  if(max < NUM)
    800053c4:	471d                	li	a4,7
    800053c6:	08f77e63          	bgeu	a4,a5,80005462 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053ca:	100017b7          	lui	a5,0x10001
    800053ce:	4721                	li	a4,8
    800053d0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053d2:	6609                	lui	a2,0x2
    800053d4:	4581                	li	a1,0
    800053d6:	0001d517          	auipc	a0,0x1d
    800053da:	c2a50513          	addi	a0,a0,-982 # 80022000 <disk>
    800053de:	ffffb097          	auipc	ra,0xffffb
    800053e2:	d9c080e7          	jalr	-612(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053e6:	0001d697          	auipc	a3,0x1d
    800053ea:	c1a68693          	addi	a3,a3,-998 # 80022000 <disk>
    800053ee:	00c6d713          	srli	a4,a3,0xc
    800053f2:	2701                	sext.w	a4,a4
    800053f4:	100017b7          	lui	a5,0x10001
    800053f8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053fa:	0001f797          	auipc	a5,0x1f
    800053fe:	c0678793          	addi	a5,a5,-1018 # 80024000 <disk+0x2000>
    80005402:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005404:	0001d717          	auipc	a4,0x1d
    80005408:	c7c70713          	addi	a4,a4,-900 # 80022080 <disk+0x80>
    8000540c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000540e:	0001e717          	auipc	a4,0x1e
    80005412:	bf270713          	addi	a4,a4,-1038 # 80023000 <disk+0x1000>
    80005416:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005418:	4705                	li	a4,1
    8000541a:	00e78c23          	sb	a4,24(a5)
    8000541e:	00e78ca3          	sb	a4,25(a5)
    80005422:	00e78d23          	sb	a4,26(a5)
    80005426:	00e78da3          	sb	a4,27(a5)
    8000542a:	00e78e23          	sb	a4,28(a5)
    8000542e:	00e78ea3          	sb	a4,29(a5)
    80005432:	00e78f23          	sb	a4,30(a5)
    80005436:	00e78fa3          	sb	a4,31(a5)
}
    8000543a:	60a2                	ld	ra,8(sp)
    8000543c:	6402                	ld	s0,0(sp)
    8000543e:	0141                	addi	sp,sp,16
    80005440:	8082                	ret
    panic("could not find virtio disk");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	1de50513          	addi	a0,a0,478 # 80008620 <etext+0x620>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	96c080e7          	jalr	-1684(ra) # 80005db6 <panic>
    panic("virtio disk has no queue 0");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	1ee50513          	addi	a0,a0,494 # 80008640 <etext+0x640>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	95c080e7          	jalr	-1700(ra) # 80005db6 <panic>
    panic("virtio disk max queue too short");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	1fe50513          	addi	a0,a0,510 # 80008660 <etext+0x660>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	94c080e7          	jalr	-1716(ra) # 80005db6 <panic>

0000000080005472 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005472:	7159                	addi	sp,sp,-112
    80005474:	f486                	sd	ra,104(sp)
    80005476:	f0a2                	sd	s0,96(sp)
    80005478:	eca6                	sd	s1,88(sp)
    8000547a:	e8ca                	sd	s2,80(sp)
    8000547c:	e4ce                	sd	s3,72(sp)
    8000547e:	e0d2                	sd	s4,64(sp)
    80005480:	fc56                	sd	s5,56(sp)
    80005482:	f85a                	sd	s6,48(sp)
    80005484:	f45e                	sd	s7,40(sp)
    80005486:	f062                	sd	s8,32(sp)
    80005488:	ec66                	sd	s9,24(sp)
    8000548a:	1880                	addi	s0,sp,112
    8000548c:	8a2a                	mv	s4,a0
    8000548e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005490:	00c52c03          	lw	s8,12(a0)
    80005494:	001c1c1b          	slliw	s8,s8,0x1
    80005498:	1c02                	slli	s8,s8,0x20
    8000549a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000549e:	0001f517          	auipc	a0,0x1f
    800054a2:	c8a50513          	addi	a0,a0,-886 # 80024128 <disk+0x2128>
    800054a6:	00001097          	auipc	ra,0x1
    800054aa:	e60080e7          	jalr	-416(ra) # 80006306 <acquire>
  for(int i = 0; i < 3; i++){
    800054ae:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054b0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054b2:	0001db97          	auipc	s7,0x1d
    800054b6:	b4eb8b93          	addi	s7,s7,-1202 # 80022000 <disk>
    800054ba:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054bc:	4a8d                	li	s5,3
    800054be:	a88d                	j	80005530 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800054c0:	00fb8733          	add	a4,s7,a5
    800054c4:	975a                	add	a4,a4,s6
    800054c6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054ca:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800054cc:	0207c563          	bltz	a5,800054f6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800054d0:	2905                	addiw	s2,s2,1
    800054d2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800054d4:	1b590163          	beq	s2,s5,80005676 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800054d8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800054da:	0001f717          	auipc	a4,0x1f
    800054de:	b3e70713          	addi	a4,a4,-1218 # 80024018 <disk+0x2018>
    800054e2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800054e4:	00074683          	lbu	a3,0(a4)
    800054e8:	fee1                	bnez	a3,800054c0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800054ea:	2785                	addiw	a5,a5,1
    800054ec:	0705                	addi	a4,a4,1
    800054ee:	fe979be3          	bne	a5,s1,800054e4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800054f2:	57fd                	li	a5,-1
    800054f4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800054f6:	03205163          	blez	s2,80005518 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800054fa:	f9042503          	lw	a0,-112(s0)
    800054fe:	00000097          	auipc	ra,0x0
    80005502:	d7c080e7          	jalr	-644(ra) # 8000527a <free_desc>
      for(int j = 0; j < i; j++)
    80005506:	4785                	li	a5,1
    80005508:	0127d863          	bge	a5,s2,80005518 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000550c:	f9442503          	lw	a0,-108(s0)
    80005510:	00000097          	auipc	ra,0x0
    80005514:	d6a080e7          	jalr	-662(ra) # 8000527a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005518:	0001f597          	auipc	a1,0x1f
    8000551c:	c1058593          	addi	a1,a1,-1008 # 80024128 <disk+0x2128>
    80005520:	0001f517          	auipc	a0,0x1f
    80005524:	af850513          	addi	a0,a0,-1288 # 80024018 <disk+0x2018>
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	02c080e7          	jalr	44(ra) # 80001554 <sleep>
  for(int i = 0; i < 3; i++){
    80005530:	f9040613          	addi	a2,s0,-112
    80005534:	894e                	mv	s2,s3
    80005536:	b74d                	j	800054d8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005538:	0001f717          	auipc	a4,0x1f
    8000553c:	ac873703          	ld	a4,-1336(a4) # 80024000 <disk+0x2000>
    80005540:	973e                	add	a4,a4,a5
    80005542:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005546:	0001d897          	auipc	a7,0x1d
    8000554a:	aba88893          	addi	a7,a7,-1350 # 80022000 <disk>
    8000554e:	0001f717          	auipc	a4,0x1f
    80005552:	ab270713          	addi	a4,a4,-1358 # 80024000 <disk+0x2000>
    80005556:	6314                	ld	a3,0(a4)
    80005558:	96be                	add	a3,a3,a5
    8000555a:	00c6d583          	lhu	a1,12(a3)
    8000555e:	0015e593          	ori	a1,a1,1
    80005562:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005566:	f9842683          	lw	a3,-104(s0)
    8000556a:	630c                	ld	a1,0(a4)
    8000556c:	97ae                	add	a5,a5,a1
    8000556e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005572:	20050593          	addi	a1,a0,512
    80005576:	0592                	slli	a1,a1,0x4
    80005578:	95c6                	add	a1,a1,a7
    8000557a:	57fd                	li	a5,-1
    8000557c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005580:	00469793          	slli	a5,a3,0x4
    80005584:	00073803          	ld	a6,0(a4)
    80005588:	983e                	add	a6,a6,a5
    8000558a:	6689                	lui	a3,0x2
    8000558c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005590:	96b2                	add	a3,a3,a2
    80005592:	96c6                	add	a3,a3,a7
    80005594:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005598:	6314                	ld	a3,0(a4)
    8000559a:	96be                	add	a3,a3,a5
    8000559c:	4605                	li	a2,1
    8000559e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055a0:	6314                	ld	a3,0(a4)
    800055a2:	96be                	add	a3,a3,a5
    800055a4:	4809                	li	a6,2
    800055a6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800055aa:	6314                	ld	a3,0(a4)
    800055ac:	97b6                	add	a5,a5,a3
    800055ae:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055b2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800055b6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055ba:	6714                	ld	a3,8(a4)
    800055bc:	0026d783          	lhu	a5,2(a3)
    800055c0:	8b9d                	andi	a5,a5,7
    800055c2:	0786                	slli	a5,a5,0x1
    800055c4:	96be                	add	a3,a3,a5
    800055c6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055ca:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055ce:	6718                	ld	a4,8(a4)
    800055d0:	00275783          	lhu	a5,2(a4)
    800055d4:	2785                	addiw	a5,a5,1
    800055d6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055da:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055de:	100017b7          	lui	a5,0x10001
    800055e2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055e6:	004a2783          	lw	a5,4(s4)
    800055ea:	02c79163          	bne	a5,a2,8000560c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800055ee:	0001f917          	auipc	s2,0x1f
    800055f2:	b3a90913          	addi	s2,s2,-1222 # 80024128 <disk+0x2128>
  while(b->disk == 1) {
    800055f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055f8:	85ca                	mv	a1,s2
    800055fa:	8552                	mv	a0,s4
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	f58080e7          	jalr	-168(ra) # 80001554 <sleep>
  while(b->disk == 1) {
    80005604:	004a2783          	lw	a5,4(s4)
    80005608:	fe9788e3          	beq	a5,s1,800055f8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000560c:	f9042903          	lw	s2,-112(s0)
    80005610:	20090713          	addi	a4,s2,512
    80005614:	0712                	slli	a4,a4,0x4
    80005616:	0001d797          	auipc	a5,0x1d
    8000561a:	9ea78793          	addi	a5,a5,-1558 # 80022000 <disk>
    8000561e:	97ba                	add	a5,a5,a4
    80005620:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005624:	0001f997          	auipc	s3,0x1f
    80005628:	9dc98993          	addi	s3,s3,-1572 # 80024000 <disk+0x2000>
    8000562c:	00491713          	slli	a4,s2,0x4
    80005630:	0009b783          	ld	a5,0(s3)
    80005634:	97ba                	add	a5,a5,a4
    80005636:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000563a:	854a                	mv	a0,s2
    8000563c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005640:	00000097          	auipc	ra,0x0
    80005644:	c3a080e7          	jalr	-966(ra) # 8000527a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005648:	8885                	andi	s1,s1,1
    8000564a:	f0ed                	bnez	s1,8000562c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000564c:	0001f517          	auipc	a0,0x1f
    80005650:	adc50513          	addi	a0,a0,-1316 # 80024128 <disk+0x2128>
    80005654:	00001097          	auipc	ra,0x1
    80005658:	d66080e7          	jalr	-666(ra) # 800063ba <release>
}
    8000565c:	70a6                	ld	ra,104(sp)
    8000565e:	7406                	ld	s0,96(sp)
    80005660:	64e6                	ld	s1,88(sp)
    80005662:	6946                	ld	s2,80(sp)
    80005664:	69a6                	ld	s3,72(sp)
    80005666:	6a06                	ld	s4,64(sp)
    80005668:	7ae2                	ld	s5,56(sp)
    8000566a:	7b42                	ld	s6,48(sp)
    8000566c:	7ba2                	ld	s7,40(sp)
    8000566e:	7c02                	ld	s8,32(sp)
    80005670:	6ce2                	ld	s9,24(sp)
    80005672:	6165                	addi	sp,sp,112
    80005674:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005676:	f9042503          	lw	a0,-112(s0)
    8000567a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000567e:	0001d597          	auipc	a1,0x1d
    80005682:	98258593          	addi	a1,a1,-1662 # 80022000 <disk>
    80005686:	20050793          	addi	a5,a0,512
    8000568a:	0792                	slli	a5,a5,0x4
    8000568c:	97ae                	add	a5,a5,a1
    8000568e:	01903733          	snez	a4,s9
    80005692:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005696:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000569a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000569e:	0001f717          	auipc	a4,0x1f
    800056a2:	96270713          	addi	a4,a4,-1694 # 80024000 <disk+0x2000>
    800056a6:	6314                	ld	a3,0(a4)
    800056a8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056aa:	6789                	lui	a5,0x2
    800056ac:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800056b0:	97b2                	add	a5,a5,a2
    800056b2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056b6:	631c                	ld	a5,0(a4)
    800056b8:	97b2                	add	a5,a5,a2
    800056ba:	46c1                	li	a3,16
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056be:	631c                	ld	a5,0(a4)
    800056c0:	97b2                	add	a5,a5,a2
    800056c2:	4685                	li	a3,1
    800056c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800056c8:	f9442783          	lw	a5,-108(s0)
    800056cc:	6314                	ld	a3,0(a4)
    800056ce:	96b2                	add	a3,a3,a2
    800056d0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800056d4:	0792                	slli	a5,a5,0x4
    800056d6:	6314                	ld	a3,0(a4)
    800056d8:	96be                	add	a3,a3,a5
    800056da:	058a0593          	addi	a1,s4,88
    800056de:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800056e0:	6318                	ld	a4,0(a4)
    800056e2:	973e                	add	a4,a4,a5
    800056e4:	40000693          	li	a3,1024
    800056e8:	c714                	sw	a3,8(a4)
  if(write)
    800056ea:	e40c97e3          	bnez	s9,80005538 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056ee:	0001f717          	auipc	a4,0x1f
    800056f2:	91273703          	ld	a4,-1774(a4) # 80024000 <disk+0x2000>
    800056f6:	973e                	add	a4,a4,a5
    800056f8:	4689                	li	a3,2
    800056fa:	00d71623          	sh	a3,12(a4)
    800056fe:	b5a1                	j	80005546 <virtio_disk_rw+0xd4>

0000000080005700 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005700:	1101                	addi	sp,sp,-32
    80005702:	ec06                	sd	ra,24(sp)
    80005704:	e822                	sd	s0,16(sp)
    80005706:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005708:	0001f517          	auipc	a0,0x1f
    8000570c:	a2050513          	addi	a0,a0,-1504 # 80024128 <disk+0x2128>
    80005710:	00001097          	auipc	ra,0x1
    80005714:	bf6080e7          	jalr	-1034(ra) # 80006306 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005718:	100017b7          	lui	a5,0x10001
    8000571c:	53b8                	lw	a4,96(a5)
    8000571e:	8b0d                	andi	a4,a4,3
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005726:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000572a:	0001f797          	auipc	a5,0x1f
    8000572e:	8d678793          	addi	a5,a5,-1834 # 80024000 <disk+0x2000>
    80005732:	6b94                	ld	a3,16(a5)
    80005734:	0207d703          	lhu	a4,32(a5)
    80005738:	0026d783          	lhu	a5,2(a3)
    8000573c:	06f70563          	beq	a4,a5,800057a6 <virtio_disk_intr+0xa6>
    80005740:	e426                	sd	s1,8(sp)
    80005742:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005744:	0001d917          	auipc	s2,0x1d
    80005748:	8bc90913          	addi	s2,s2,-1860 # 80022000 <disk>
    8000574c:	0001f497          	auipc	s1,0x1f
    80005750:	8b448493          	addi	s1,s1,-1868 # 80024000 <disk+0x2000>
    __sync_synchronize();
    80005754:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005758:	6898                	ld	a4,16(s1)
    8000575a:	0204d783          	lhu	a5,32(s1)
    8000575e:	8b9d                	andi	a5,a5,7
    80005760:	078e                	slli	a5,a5,0x3
    80005762:	97ba                	add	a5,a5,a4
    80005764:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005766:	20078713          	addi	a4,a5,512
    8000576a:	0712                	slli	a4,a4,0x4
    8000576c:	974a                	add	a4,a4,s2
    8000576e:	03074703          	lbu	a4,48(a4)
    80005772:	e731                	bnez	a4,800057be <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005774:	20078793          	addi	a5,a5,512
    80005778:	0792                	slli	a5,a5,0x4
    8000577a:	97ca                	add	a5,a5,s2
    8000577c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000577e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005782:	ffffc097          	auipc	ra,0xffffc
    80005786:	f5e080e7          	jalr	-162(ra) # 800016e0 <wakeup>

    disk.used_idx += 1;
    8000578a:	0204d783          	lhu	a5,32(s1)
    8000578e:	2785                	addiw	a5,a5,1
    80005790:	17c2                	slli	a5,a5,0x30
    80005792:	93c1                	srli	a5,a5,0x30
    80005794:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005798:	6898                	ld	a4,16(s1)
    8000579a:	00275703          	lhu	a4,2(a4)
    8000579e:	faf71be3          	bne	a4,a5,80005754 <virtio_disk_intr+0x54>
    800057a2:	64a2                	ld	s1,8(sp)
    800057a4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800057a6:	0001f517          	auipc	a0,0x1f
    800057aa:	98250513          	addi	a0,a0,-1662 # 80024128 <disk+0x2128>
    800057ae:	00001097          	auipc	ra,0x1
    800057b2:	c0c080e7          	jalr	-1012(ra) # 800063ba <release>
}
    800057b6:	60e2                	ld	ra,24(sp)
    800057b8:	6442                	ld	s0,16(sp)
    800057ba:	6105                	addi	sp,sp,32
    800057bc:	8082                	ret
      panic("virtio_disk_intr status");
    800057be:	00003517          	auipc	a0,0x3
    800057c2:	ec250513          	addi	a0,a0,-318 # 80008680 <etext+0x680>
    800057c6:	00000097          	auipc	ra,0x0
    800057ca:	5f0080e7          	jalr	1520(ra) # 80005db6 <panic>

00000000800057ce <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057ce:	1141                	addi	sp,sp,-16
    800057d0:	e422                	sd	s0,8(sp)
    800057d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057d4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057d8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057dc:	0037979b          	slliw	a5,a5,0x3
    800057e0:	02004737          	lui	a4,0x2004
    800057e4:	97ba                	add	a5,a5,a4
    800057e6:	0200c737          	lui	a4,0x200c
    800057ea:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800057ec:	6318                	ld	a4,0(a4)
    800057ee:	000f4637          	lui	a2,0xf4
    800057f2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057f6:	9732                	add	a4,a4,a2
    800057f8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057fa:	00259693          	slli	a3,a1,0x2
    800057fe:	96ae                	add	a3,a3,a1
    80005800:	068e                	slli	a3,a3,0x3
    80005802:	0001f717          	auipc	a4,0x1f
    80005806:	7fe70713          	addi	a4,a4,2046 # 80025000 <timer_scratch>
    8000580a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000580c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000580e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005810:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005814:	00000797          	auipc	a5,0x0
    80005818:	99c78793          	addi	a5,a5,-1636 # 800051b0 <timervec>
    8000581c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005820:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005824:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005828:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000582c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005830:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005834:	30479073          	csrw	mie,a5
}
    80005838:	6422                	ld	s0,8(sp)
    8000583a:	0141                	addi	sp,sp,16
    8000583c:	8082                	ret

000000008000583e <start>:
{
    8000583e:	1141                	addi	sp,sp,-16
    80005840:	e406                	sd	ra,8(sp)
    80005842:	e022                	sd	s0,0(sp)
    80005844:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005846:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000584a:	7779                	lui	a4,0xffffe
    8000584c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd15bf>
    80005850:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005852:	6705                	lui	a4,0x1
    80005854:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005858:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000585a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000585e:	ffffb797          	auipc	a5,0xffffb
    80005862:	aba78793          	addi	a5,a5,-1350 # 80000318 <main>
    80005866:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000586a:	4781                	li	a5,0
    8000586c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005870:	67c1                	lui	a5,0x10
    80005872:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005874:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005878:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000587c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005880:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005884:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005888:	57fd                	li	a5,-1
    8000588a:	83a9                	srli	a5,a5,0xa
    8000588c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005890:	47bd                	li	a5,15
    80005892:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005896:	00000097          	auipc	ra,0x0
    8000589a:	f38080e7          	jalr	-200(ra) # 800057ce <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000589e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058a2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058a4:	823e                	mv	tp,a5
  asm volatile("mret");
    800058a6:	30200073          	mret
}
    800058aa:	60a2                	ld	ra,8(sp)
    800058ac:	6402                	ld	s0,0(sp)
    800058ae:	0141                	addi	sp,sp,16
    800058b0:	8082                	ret

00000000800058b2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058b2:	715d                	addi	sp,sp,-80
    800058b4:	e486                	sd	ra,72(sp)
    800058b6:	e0a2                	sd	s0,64(sp)
    800058b8:	f84a                	sd	s2,48(sp)
    800058ba:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058bc:	04c05663          	blez	a2,80005908 <consolewrite+0x56>
    800058c0:	fc26                	sd	s1,56(sp)
    800058c2:	f44e                	sd	s3,40(sp)
    800058c4:	f052                	sd	s4,32(sp)
    800058c6:	ec56                	sd	s5,24(sp)
    800058c8:	8a2a                	mv	s4,a0
    800058ca:	84ae                	mv	s1,a1
    800058cc:	89b2                	mv	s3,a2
    800058ce:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058d0:	5afd                	li	s5,-1
    800058d2:	4685                	li	a3,1
    800058d4:	8626                	mv	a2,s1
    800058d6:	85d2                	mv	a1,s4
    800058d8:	fbf40513          	addi	a0,s0,-65
    800058dc:	ffffc097          	auipc	ra,0xffffc
    800058e0:	072080e7          	jalr	114(ra) # 8000194e <either_copyin>
    800058e4:	03550463          	beq	a0,s5,8000590c <consolewrite+0x5a>
      break;
    uartputc(c);
    800058e8:	fbf44503          	lbu	a0,-65(s0)
    800058ec:	00001097          	auipc	ra,0x1
    800058f0:	85e080e7          	jalr	-1954(ra) # 8000614a <uartputc>
  for(i = 0; i < n; i++){
    800058f4:	2905                	addiw	s2,s2,1
    800058f6:	0485                	addi	s1,s1,1
    800058f8:	fd299de3          	bne	s3,s2,800058d2 <consolewrite+0x20>
    800058fc:	894e                	mv	s2,s3
    800058fe:	74e2                	ld	s1,56(sp)
    80005900:	79a2                	ld	s3,40(sp)
    80005902:	7a02                	ld	s4,32(sp)
    80005904:	6ae2                	ld	s5,24(sp)
    80005906:	a039                	j	80005914 <consolewrite+0x62>
    80005908:	4901                	li	s2,0
    8000590a:	a029                	j	80005914 <consolewrite+0x62>
    8000590c:	74e2                	ld	s1,56(sp)
    8000590e:	79a2                	ld	s3,40(sp)
    80005910:	7a02                	ld	s4,32(sp)
    80005912:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005914:	854a                	mv	a0,s2
    80005916:	60a6                	ld	ra,72(sp)
    80005918:	6406                	ld	s0,64(sp)
    8000591a:	7942                	ld	s2,48(sp)
    8000591c:	6161                	addi	sp,sp,80
    8000591e:	8082                	ret

0000000080005920 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005920:	711d                	addi	sp,sp,-96
    80005922:	ec86                	sd	ra,88(sp)
    80005924:	e8a2                	sd	s0,80(sp)
    80005926:	e4a6                	sd	s1,72(sp)
    80005928:	e0ca                	sd	s2,64(sp)
    8000592a:	fc4e                	sd	s3,56(sp)
    8000592c:	f852                	sd	s4,48(sp)
    8000592e:	f456                	sd	s5,40(sp)
    80005930:	f05a                	sd	s6,32(sp)
    80005932:	1080                	addi	s0,sp,96
    80005934:	8aaa                	mv	s5,a0
    80005936:	8a2e                	mv	s4,a1
    80005938:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000593a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000593e:	00028517          	auipc	a0,0x28
    80005942:	80250513          	addi	a0,a0,-2046 # 8002d140 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	9c0080e7          	jalr	-1600(ra) # 80006306 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000594e:	00027497          	auipc	s1,0x27
    80005952:	7f248493          	addi	s1,s1,2034 # 8002d140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005956:	00028917          	auipc	s2,0x28
    8000595a:	88290913          	addi	s2,s2,-1918 # 8002d1d8 <cons+0x98>
  while(n > 0){
    8000595e:	0d305463          	blez	s3,80005a26 <consoleread+0x106>
    while(cons.r == cons.w){
    80005962:	0984a783          	lw	a5,152(s1)
    80005966:	09c4a703          	lw	a4,156(s1)
    8000596a:	0af71963          	bne	a4,a5,80005a1c <consoleread+0xfc>
      if(myproc()->killed){
    8000596e:	ffffb097          	auipc	ra,0xffffb
    80005972:	50e080e7          	jalr	1294(ra) # 80000e7c <myproc>
    80005976:	551c                	lw	a5,40(a0)
    80005978:	e7ad                	bnez	a5,800059e2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    8000597a:	85a6                	mv	a1,s1
    8000597c:	854a                	mv	a0,s2
    8000597e:	ffffc097          	auipc	ra,0xffffc
    80005982:	bd6080e7          	jalr	-1066(ra) # 80001554 <sleep>
    while(cons.r == cons.w){
    80005986:	0984a783          	lw	a5,152(s1)
    8000598a:	09c4a703          	lw	a4,156(s1)
    8000598e:	fef700e3          	beq	a4,a5,8000596e <consoleread+0x4e>
    80005992:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005994:	00027717          	auipc	a4,0x27
    80005998:	7ac70713          	addi	a4,a4,1964 # 8002d140 <cons>
    8000599c:	0017869b          	addiw	a3,a5,1
    800059a0:	08d72c23          	sw	a3,152(a4)
    800059a4:	07f7f693          	andi	a3,a5,127
    800059a8:	9736                	add	a4,a4,a3
    800059aa:	01874703          	lbu	a4,24(a4)
    800059ae:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800059b2:	4691                	li	a3,4
    800059b4:	04db8a63          	beq	s7,a3,80005a08 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800059b8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059bc:	4685                	li	a3,1
    800059be:	faf40613          	addi	a2,s0,-81
    800059c2:	85d2                	mv	a1,s4
    800059c4:	8556                	mv	a0,s5
    800059c6:	ffffc097          	auipc	ra,0xffffc
    800059ca:	f32080e7          	jalr	-206(ra) # 800018f8 <either_copyout>
    800059ce:	57fd                	li	a5,-1
    800059d0:	04f50a63          	beq	a0,a5,80005a24 <consoleread+0x104>
      break;

    dst++;
    800059d4:	0a05                	addi	s4,s4,1
    --n;
    800059d6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800059d8:	47a9                	li	a5,10
    800059da:	06fb8163          	beq	s7,a5,80005a3c <consoleread+0x11c>
    800059de:	6be2                	ld	s7,24(sp)
    800059e0:	bfbd                	j	8000595e <consoleread+0x3e>
        release(&cons.lock);
    800059e2:	00027517          	auipc	a0,0x27
    800059e6:	75e50513          	addi	a0,a0,1886 # 8002d140 <cons>
    800059ea:	00001097          	auipc	ra,0x1
    800059ee:	9d0080e7          	jalr	-1584(ra) # 800063ba <release>
        return -1;
    800059f2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800059f4:	60e6                	ld	ra,88(sp)
    800059f6:	6446                	ld	s0,80(sp)
    800059f8:	64a6                	ld	s1,72(sp)
    800059fa:	6906                	ld	s2,64(sp)
    800059fc:	79e2                	ld	s3,56(sp)
    800059fe:	7a42                	ld	s4,48(sp)
    80005a00:	7aa2                	ld	s5,40(sp)
    80005a02:	7b02                	ld	s6,32(sp)
    80005a04:	6125                	addi	sp,sp,96
    80005a06:	8082                	ret
      if(n < target){
    80005a08:	0009871b          	sext.w	a4,s3
    80005a0c:	01677a63          	bgeu	a4,s6,80005a20 <consoleread+0x100>
        cons.r--;
    80005a10:	00027717          	auipc	a4,0x27
    80005a14:	7cf72423          	sw	a5,1992(a4) # 8002d1d8 <cons+0x98>
    80005a18:	6be2                	ld	s7,24(sp)
    80005a1a:	a031                	j	80005a26 <consoleread+0x106>
    80005a1c:	ec5e                	sd	s7,24(sp)
    80005a1e:	bf9d                	j	80005994 <consoleread+0x74>
    80005a20:	6be2                	ld	s7,24(sp)
    80005a22:	a011                	j	80005a26 <consoleread+0x106>
    80005a24:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a26:	00027517          	auipc	a0,0x27
    80005a2a:	71a50513          	addi	a0,a0,1818 # 8002d140 <cons>
    80005a2e:	00001097          	auipc	ra,0x1
    80005a32:	98c080e7          	jalr	-1652(ra) # 800063ba <release>
  return target - n;
    80005a36:	413b053b          	subw	a0,s6,s3
    80005a3a:	bf6d                	j	800059f4 <consoleread+0xd4>
    80005a3c:	6be2                	ld	s7,24(sp)
    80005a3e:	b7e5                	j	80005a26 <consoleread+0x106>

0000000080005a40 <consputc>:
{
    80005a40:	1141                	addi	sp,sp,-16
    80005a42:	e406                	sd	ra,8(sp)
    80005a44:	e022                	sd	s0,0(sp)
    80005a46:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a48:	10000793          	li	a5,256
    80005a4c:	00f50a63          	beq	a0,a5,80005a60 <consputc+0x20>
    uartputc_sync(c);
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	61c080e7          	jalr	1564(ra) # 8000606c <uartputc_sync>
}
    80005a58:	60a2                	ld	ra,8(sp)
    80005a5a:	6402                	ld	s0,0(sp)
    80005a5c:	0141                	addi	sp,sp,16
    80005a5e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a60:	4521                	li	a0,8
    80005a62:	00000097          	auipc	ra,0x0
    80005a66:	60a080e7          	jalr	1546(ra) # 8000606c <uartputc_sync>
    80005a6a:	02000513          	li	a0,32
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	5fe080e7          	jalr	1534(ra) # 8000606c <uartputc_sync>
    80005a76:	4521                	li	a0,8
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	5f4080e7          	jalr	1524(ra) # 8000606c <uartputc_sync>
    80005a80:	bfe1                	j	80005a58 <consputc+0x18>

0000000080005a82 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a82:	1101                	addi	sp,sp,-32
    80005a84:	ec06                	sd	ra,24(sp)
    80005a86:	e822                	sd	s0,16(sp)
    80005a88:	e426                	sd	s1,8(sp)
    80005a8a:	1000                	addi	s0,sp,32
    80005a8c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a8e:	00027517          	auipc	a0,0x27
    80005a92:	6b250513          	addi	a0,a0,1714 # 8002d140 <cons>
    80005a96:	00001097          	auipc	ra,0x1
    80005a9a:	870080e7          	jalr	-1936(ra) # 80006306 <acquire>

  switch(c){
    80005a9e:	47d5                	li	a5,21
    80005aa0:	0af48563          	beq	s1,a5,80005b4a <consoleintr+0xc8>
    80005aa4:	0297c963          	blt	a5,s1,80005ad6 <consoleintr+0x54>
    80005aa8:	47a1                	li	a5,8
    80005aaa:	0ef48c63          	beq	s1,a5,80005ba2 <consoleintr+0x120>
    80005aae:	47c1                	li	a5,16
    80005ab0:	10f49f63          	bne	s1,a5,80005bce <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005ab4:	ffffc097          	auipc	ra,0xffffc
    80005ab8:	ef0080e7          	jalr	-272(ra) # 800019a4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005abc:	00027517          	auipc	a0,0x27
    80005ac0:	68450513          	addi	a0,a0,1668 # 8002d140 <cons>
    80005ac4:	00001097          	auipc	ra,0x1
    80005ac8:	8f6080e7          	jalr	-1802(ra) # 800063ba <release>
}
    80005acc:	60e2                	ld	ra,24(sp)
    80005ace:	6442                	ld	s0,16(sp)
    80005ad0:	64a2                	ld	s1,8(sp)
    80005ad2:	6105                	addi	sp,sp,32
    80005ad4:	8082                	ret
  switch(c){
    80005ad6:	07f00793          	li	a5,127
    80005ada:	0cf48463          	beq	s1,a5,80005ba2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ade:	00027717          	auipc	a4,0x27
    80005ae2:	66270713          	addi	a4,a4,1634 # 8002d140 <cons>
    80005ae6:	0a072783          	lw	a5,160(a4)
    80005aea:	09872703          	lw	a4,152(a4)
    80005aee:	9f99                	subw	a5,a5,a4
    80005af0:	07f00713          	li	a4,127
    80005af4:	fcf764e3          	bltu	a4,a5,80005abc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005af8:	47b5                	li	a5,13
    80005afa:	0cf48d63          	beq	s1,a5,80005bd4 <consoleintr+0x152>
      consputc(c);
    80005afe:	8526                	mv	a0,s1
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	f40080e7          	jalr	-192(ra) # 80005a40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b08:	00027797          	auipc	a5,0x27
    80005b0c:	63878793          	addi	a5,a5,1592 # 8002d140 <cons>
    80005b10:	0a07a703          	lw	a4,160(a5)
    80005b14:	0017069b          	addiw	a3,a4,1
    80005b18:	0006861b          	sext.w	a2,a3
    80005b1c:	0ad7a023          	sw	a3,160(a5)
    80005b20:	07f77713          	andi	a4,a4,127
    80005b24:	97ba                	add	a5,a5,a4
    80005b26:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b2a:	47a9                	li	a5,10
    80005b2c:	0cf48b63          	beq	s1,a5,80005c02 <consoleintr+0x180>
    80005b30:	4791                	li	a5,4
    80005b32:	0cf48863          	beq	s1,a5,80005c02 <consoleintr+0x180>
    80005b36:	00027797          	auipc	a5,0x27
    80005b3a:	6a27a783          	lw	a5,1698(a5) # 8002d1d8 <cons+0x98>
    80005b3e:	0807879b          	addiw	a5,a5,128
    80005b42:	f6f61de3          	bne	a2,a5,80005abc <consoleintr+0x3a>
    80005b46:	863e                	mv	a2,a5
    80005b48:	a86d                	j	80005c02 <consoleintr+0x180>
    80005b4a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005b4c:	00027717          	auipc	a4,0x27
    80005b50:	5f470713          	addi	a4,a4,1524 # 8002d140 <cons>
    80005b54:	0a072783          	lw	a5,160(a4)
    80005b58:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b5c:	00027497          	auipc	s1,0x27
    80005b60:	5e448493          	addi	s1,s1,1508 # 8002d140 <cons>
    while(cons.e != cons.w &&
    80005b64:	4929                	li	s2,10
    80005b66:	02f70a63          	beq	a4,a5,80005b9a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b6a:	37fd                	addiw	a5,a5,-1
    80005b6c:	07f7f713          	andi	a4,a5,127
    80005b70:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b72:	01874703          	lbu	a4,24(a4)
    80005b76:	03270463          	beq	a4,s2,80005b9e <consoleintr+0x11c>
      cons.e--;
    80005b7a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b7e:	10000513          	li	a0,256
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	ebe080e7          	jalr	-322(ra) # 80005a40 <consputc>
    while(cons.e != cons.w &&
    80005b8a:	0a04a783          	lw	a5,160(s1)
    80005b8e:	09c4a703          	lw	a4,156(s1)
    80005b92:	fcf71ce3          	bne	a4,a5,80005b6a <consoleintr+0xe8>
    80005b96:	6902                	ld	s2,0(sp)
    80005b98:	b715                	j	80005abc <consoleintr+0x3a>
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	b705                	j	80005abc <consoleintr+0x3a>
    80005b9e:	6902                	ld	s2,0(sp)
    80005ba0:	bf31                	j	80005abc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005ba2:	00027717          	auipc	a4,0x27
    80005ba6:	59e70713          	addi	a4,a4,1438 # 8002d140 <cons>
    80005baa:	0a072783          	lw	a5,160(a4)
    80005bae:	09c72703          	lw	a4,156(a4)
    80005bb2:	f0f705e3          	beq	a4,a5,80005abc <consoleintr+0x3a>
      cons.e--;
    80005bb6:	37fd                	addiw	a5,a5,-1
    80005bb8:	00027717          	auipc	a4,0x27
    80005bbc:	62f72423          	sw	a5,1576(a4) # 8002d1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bc0:	10000513          	li	a0,256
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	e7c080e7          	jalr	-388(ra) # 80005a40 <consputc>
    80005bcc:	bdc5                	j	80005abc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bce:	ee0487e3          	beqz	s1,80005abc <consoleintr+0x3a>
    80005bd2:	b731                	j	80005ade <consoleintr+0x5c>
      consputc(c);
    80005bd4:	4529                	li	a0,10
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	e6a080e7          	jalr	-406(ra) # 80005a40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bde:	00027797          	auipc	a5,0x27
    80005be2:	56278793          	addi	a5,a5,1378 # 8002d140 <cons>
    80005be6:	0a07a703          	lw	a4,160(a5)
    80005bea:	0017069b          	addiw	a3,a4,1
    80005bee:	0006861b          	sext.w	a2,a3
    80005bf2:	0ad7a023          	sw	a3,160(a5)
    80005bf6:	07f77713          	andi	a4,a4,127
    80005bfa:	97ba                	add	a5,a5,a4
    80005bfc:	4729                	li	a4,10
    80005bfe:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c02:	00027797          	auipc	a5,0x27
    80005c06:	5cc7ad23          	sw	a2,1498(a5) # 8002d1dc <cons+0x9c>
        wakeup(&cons.r);
    80005c0a:	00027517          	auipc	a0,0x27
    80005c0e:	5ce50513          	addi	a0,a0,1486 # 8002d1d8 <cons+0x98>
    80005c12:	ffffc097          	auipc	ra,0xffffc
    80005c16:	ace080e7          	jalr	-1330(ra) # 800016e0 <wakeup>
    80005c1a:	b54d                	j	80005abc <consoleintr+0x3a>

0000000080005c1c <consoleinit>:

void
consoleinit(void)
{
    80005c1c:	1141                	addi	sp,sp,-16
    80005c1e:	e406                	sd	ra,8(sp)
    80005c20:	e022                	sd	s0,0(sp)
    80005c22:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c24:	00003597          	auipc	a1,0x3
    80005c28:	a7458593          	addi	a1,a1,-1420 # 80008698 <etext+0x698>
    80005c2c:	00027517          	auipc	a0,0x27
    80005c30:	51450513          	addi	a0,a0,1300 # 8002d140 <cons>
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	642080e7          	jalr	1602(ra) # 80006276 <initlock>

  uartinit();
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	3d4080e7          	jalr	980(ra) # 80006010 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c44:	0001b797          	auipc	a5,0x1b
    80005c48:	28478793          	addi	a5,a5,644 # 80020ec8 <devsw>
    80005c4c:	00000717          	auipc	a4,0x0
    80005c50:	cd470713          	addi	a4,a4,-812 # 80005920 <consoleread>
    80005c54:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c56:	00000717          	auipc	a4,0x0
    80005c5a:	c5c70713          	addi	a4,a4,-932 # 800058b2 <consolewrite>
    80005c5e:	ef98                	sd	a4,24(a5)
}
    80005c60:	60a2                	ld	ra,8(sp)
    80005c62:	6402                	ld	s0,0(sp)
    80005c64:	0141                	addi	sp,sp,16
    80005c66:	8082                	ret

0000000080005c68 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c68:	7179                	addi	sp,sp,-48
    80005c6a:	f406                	sd	ra,40(sp)
    80005c6c:	f022                	sd	s0,32(sp)
    80005c6e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c70:	c219                	beqz	a2,80005c76 <printint+0xe>
    80005c72:	08054963          	bltz	a0,80005d04 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c76:	2501                	sext.w	a0,a0
    80005c78:	4881                	li	a7,0
    80005c7a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c7e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c80:	2581                	sext.w	a1,a1
    80005c82:	00003617          	auipc	a2,0x3
    80005c86:	b9e60613          	addi	a2,a2,-1122 # 80008820 <digits>
    80005c8a:	883a                	mv	a6,a4
    80005c8c:	2705                	addiw	a4,a4,1
    80005c8e:	02b577bb          	remuw	a5,a0,a1
    80005c92:	1782                	slli	a5,a5,0x20
    80005c94:	9381                	srli	a5,a5,0x20
    80005c96:	97b2                	add	a5,a5,a2
    80005c98:	0007c783          	lbu	a5,0(a5)
    80005c9c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ca0:	0005079b          	sext.w	a5,a0
    80005ca4:	02b5553b          	divuw	a0,a0,a1
    80005ca8:	0685                	addi	a3,a3,1
    80005caa:	feb7f0e3          	bgeu	a5,a1,80005c8a <printint+0x22>

  if(sign)
    80005cae:	00088c63          	beqz	a7,80005cc6 <printint+0x5e>
    buf[i++] = '-';
    80005cb2:	fe070793          	addi	a5,a4,-32
    80005cb6:	00878733          	add	a4,a5,s0
    80005cba:	02d00793          	li	a5,45
    80005cbe:	fef70823          	sb	a5,-16(a4)
    80005cc2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cc6:	02e05b63          	blez	a4,80005cfc <printint+0x94>
    80005cca:	ec26                	sd	s1,24(sp)
    80005ccc:	e84a                	sd	s2,16(sp)
    80005cce:	fd040793          	addi	a5,s0,-48
    80005cd2:	00e784b3          	add	s1,a5,a4
    80005cd6:	fff78913          	addi	s2,a5,-1
    80005cda:	993a                	add	s2,s2,a4
    80005cdc:	377d                	addiw	a4,a4,-1
    80005cde:	1702                	slli	a4,a4,0x20
    80005ce0:	9301                	srli	a4,a4,0x20
    80005ce2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ce6:	fff4c503          	lbu	a0,-1(s1)
    80005cea:	00000097          	auipc	ra,0x0
    80005cee:	d56080e7          	jalr	-682(ra) # 80005a40 <consputc>
  while(--i >= 0)
    80005cf2:	14fd                	addi	s1,s1,-1
    80005cf4:	ff2499e3          	bne	s1,s2,80005ce6 <printint+0x7e>
    80005cf8:	64e2                	ld	s1,24(sp)
    80005cfa:	6942                	ld	s2,16(sp)
}
    80005cfc:	70a2                	ld	ra,40(sp)
    80005cfe:	7402                	ld	s0,32(sp)
    80005d00:	6145                	addi	sp,sp,48
    80005d02:	8082                	ret
    x = -xx;
    80005d04:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d08:	4885                	li	a7,1
    x = -xx;
    80005d0a:	bf85                	j	80005c7a <printint+0x12>

0000000080005d0c <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d0c:	1101                	addi	sp,sp,-32
    80005d0e:	ec06                	sd	ra,24(sp)
    80005d10:	e822                	sd	s0,16(sp)
    80005d12:	e426                	sd	s1,8(sp)
    80005d14:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d16:	00027497          	auipc	s1,0x27
    80005d1a:	4d248493          	addi	s1,s1,1234 # 8002d1e8 <pr>
    80005d1e:	00003597          	auipc	a1,0x3
    80005d22:	98258593          	addi	a1,a1,-1662 # 800086a0 <etext+0x6a0>
    80005d26:	8526                	mv	a0,s1
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	54e080e7          	jalr	1358(ra) # 80006276 <initlock>
  pr.locking = 1;
    80005d30:	4785                	li	a5,1
    80005d32:	cc9c                	sw	a5,24(s1)
}
    80005d34:	60e2                	ld	ra,24(sp)
    80005d36:	6442                	ld	s0,16(sp)
    80005d38:	64a2                	ld	s1,8(sp)
    80005d3a:	6105                	addi	sp,sp,32
    80005d3c:	8082                	ret

0000000080005d3e <backtrace>:

void backtrace()
{
    80005d3e:	7179                	addi	sp,sp,-48
    80005d40:	f406                	sd	ra,40(sp)
    80005d42:	f022                	sd	s0,32(sp)
    80005d44:	e84a                	sd	s2,16(sp)
    80005d46:	e44e                	sd	s3,8(sp)
    80005d48:	1800                	addi	s0,sp,48
  printf("backtrace\n");
    80005d4a:	00003517          	auipc	a0,0x3
    80005d4e:	95e50513          	addi	a0,a0,-1698 # 800086a8 <etext+0x6a8>
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	0b6080e7          	jalr	182(ra) # 80005e08 <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80005d5a:	87a2                	mv	a5,s0
  uint64 fp = r_fp();
  uint64 *frame = (uint64 *)fp;
  uint64 up = PGROUNDUP(fp);
    80005d5c:	6905                	lui	s2,0x1
    80005d5e:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005d60:	993e                	add	s2,s2,a5
    80005d62:	79fd                	lui	s3,0xfffff
    80005d64:	01397933          	and	s2,s2,s3
  uint64 down = PGROUNDDOWN(fp);
    80005d68:	0137f9b3          	and	s3,a5,s3
  while(fp<up && fp>down)
    80005d6c:	0327ff63          	bgeu	a5,s2,80005daa <backtrace+0x6c>
    80005d70:	ec26                	sd	s1,24(sp)
    80005d72:	84be                	mv	s1,a5
    80005d74:	02f9f763          	bgeu	s3,a5,80005da2 <backtrace+0x64>
    80005d78:	e052                	sd	s4,0(sp)
  {
    printf("%p\n",frame[-1]);
    80005d7a:	00003a17          	auipc	s4,0x3
    80005d7e:	93ea0a13          	addi	s4,s4,-1730 # 800086b8 <etext+0x6b8>
    80005d82:	ff84b583          	ld	a1,-8(s1)
    80005d86:	8552                	mv	a0,s4
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	080080e7          	jalr	128(ra) # 80005e08 <printf>
    fp = frame[-2];
    80005d90:	ff04b483          	ld	s1,-16(s1)
  while(fp<up && fp>down)
    80005d94:	0124f963          	bgeu	s1,s2,80005da6 <backtrace+0x68>
    80005d98:	fe99e5e3          	bltu	s3,s1,80005d82 <backtrace+0x44>
    80005d9c:	64e2                	ld	s1,24(sp)
    80005d9e:	6a02                	ld	s4,0(sp)
    80005da0:	a029                	j	80005daa <backtrace+0x6c>
    80005da2:	64e2                	ld	s1,24(sp)
    80005da4:	a019                	j	80005daa <backtrace+0x6c>
    80005da6:	64e2                	ld	s1,24(sp)
    80005da8:	6a02                	ld	s4,0(sp)
    frame = (uint64 *)fp;
  }
}
    80005daa:	70a2                	ld	ra,40(sp)
    80005dac:	7402                	ld	s0,32(sp)
    80005dae:	6942                	ld	s2,16(sp)
    80005db0:	69a2                	ld	s3,8(sp)
    80005db2:	6145                	addi	sp,sp,48
    80005db4:	8082                	ret

0000000080005db6 <panic>:
{
    80005db6:	1101                	addi	sp,sp,-32
    80005db8:	ec06                	sd	ra,24(sp)
    80005dba:	e822                	sd	s0,16(sp)
    80005dbc:	e426                	sd	s1,8(sp)
    80005dbe:	1000                	addi	s0,sp,32
    80005dc0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dc2:	00027797          	auipc	a5,0x27
    80005dc6:	4207af23          	sw	zero,1086(a5) # 8002d200 <pr+0x18>
  printf("panic: ");
    80005dca:	00003517          	auipc	a0,0x3
    80005dce:	8f650513          	addi	a0,a0,-1802 # 800086c0 <etext+0x6c0>
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	036080e7          	jalr	54(ra) # 80005e08 <printf>
  printf(s);
    80005dda:	8526                	mv	a0,s1
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	02c080e7          	jalr	44(ra) # 80005e08 <printf>
  printf("\n");
    80005de4:	00002517          	auipc	a0,0x2
    80005de8:	23450513          	addi	a0,a0,564 # 80008018 <etext+0x18>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	01c080e7          	jalr	28(ra) # 80005e08 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005df4:	4785                	li	a5,1
    80005df6:	00006717          	auipc	a4,0x6
    80005dfa:	22f72323          	sw	a5,550(a4) # 8000c01c <panicked>
  backtrace();
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	f40080e7          	jalr	-192(ra) # 80005d3e <backtrace>
  for(;;)
    80005e06:	a001                	j	80005e06 <panic+0x50>

0000000080005e08 <printf>:
{
    80005e08:	7131                	addi	sp,sp,-192
    80005e0a:	fc86                	sd	ra,120(sp)
    80005e0c:	f8a2                	sd	s0,112(sp)
    80005e0e:	e8d2                	sd	s4,80(sp)
    80005e10:	f06a                	sd	s10,32(sp)
    80005e12:	0100                	addi	s0,sp,128
    80005e14:	8a2a                	mv	s4,a0
    80005e16:	e40c                	sd	a1,8(s0)
    80005e18:	e810                	sd	a2,16(s0)
    80005e1a:	ec14                	sd	a3,24(s0)
    80005e1c:	f018                	sd	a4,32(s0)
    80005e1e:	f41c                	sd	a5,40(s0)
    80005e20:	03043823          	sd	a6,48(s0)
    80005e24:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e28:	00027d17          	auipc	s10,0x27
    80005e2c:	3d8d2d03          	lw	s10,984(s10) # 8002d200 <pr+0x18>
  if(locking)
    80005e30:	040d1463          	bnez	s10,80005e78 <printf+0x70>
  if (fmt == 0)
    80005e34:	040a0b63          	beqz	s4,80005e8a <printf+0x82>
  va_start(ap, fmt);
    80005e38:	00840793          	addi	a5,s0,8
    80005e3c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e40:	000a4503          	lbu	a0,0(s4)
    80005e44:	18050b63          	beqz	a0,80005fda <printf+0x1d2>
    80005e48:	f4a6                	sd	s1,104(sp)
    80005e4a:	f0ca                	sd	s2,96(sp)
    80005e4c:	ecce                	sd	s3,88(sp)
    80005e4e:	e4d6                	sd	s5,72(sp)
    80005e50:	e0da                	sd	s6,64(sp)
    80005e52:	fc5e                	sd	s7,56(sp)
    80005e54:	f862                	sd	s8,48(sp)
    80005e56:	f466                	sd	s9,40(sp)
    80005e58:	ec6e                	sd	s11,24(sp)
    80005e5a:	4981                	li	s3,0
    if(c != '%'){
    80005e5c:	02500b13          	li	s6,37
    switch(c){
    80005e60:	07000b93          	li	s7,112
  consputc('x');
    80005e64:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e66:	00003a97          	auipc	s5,0x3
    80005e6a:	9baa8a93          	addi	s5,s5,-1606 # 80008820 <digits>
    switch(c){
    80005e6e:	07300c13          	li	s8,115
    80005e72:	06400d93          	li	s11,100
    80005e76:	a0b1                	j	80005ec2 <printf+0xba>
    acquire(&pr.lock);
    80005e78:	00027517          	auipc	a0,0x27
    80005e7c:	37050513          	addi	a0,a0,880 # 8002d1e8 <pr>
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	486080e7          	jalr	1158(ra) # 80006306 <acquire>
    80005e88:	b775                	j	80005e34 <printf+0x2c>
    80005e8a:	f4a6                	sd	s1,104(sp)
    80005e8c:	f0ca                	sd	s2,96(sp)
    80005e8e:	ecce                	sd	s3,88(sp)
    80005e90:	e4d6                	sd	s5,72(sp)
    80005e92:	e0da                	sd	s6,64(sp)
    80005e94:	fc5e                	sd	s7,56(sp)
    80005e96:	f862                	sd	s8,48(sp)
    80005e98:	f466                	sd	s9,40(sp)
    80005e9a:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e9c:	00003517          	auipc	a0,0x3
    80005ea0:	83450513          	addi	a0,a0,-1996 # 800086d0 <etext+0x6d0>
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	f12080e7          	jalr	-238(ra) # 80005db6 <panic>
      consputc(c);
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	b94080e7          	jalr	-1132(ra) # 80005a40 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb4:	2985                	addiw	s3,s3,1 # fffffffffffff001 <end+0xffffffff7ffd1dc1>
    80005eb6:	013a07b3          	add	a5,s4,s3
    80005eba:	0007c503          	lbu	a0,0(a5)
    80005ebe:	10050563          	beqz	a0,80005fc8 <printf+0x1c0>
    if(c != '%'){
    80005ec2:	ff6515e3          	bne	a0,s6,80005eac <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005ec6:	2985                	addiw	s3,s3,1
    80005ec8:	013a07b3          	add	a5,s4,s3
    80005ecc:	0007c783          	lbu	a5,0(a5)
    80005ed0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ed4:	10078b63          	beqz	a5,80005fea <printf+0x1e2>
    switch(c){
    80005ed8:	05778a63          	beq	a5,s7,80005f2c <printf+0x124>
    80005edc:	02fbf663          	bgeu	s7,a5,80005f08 <printf+0x100>
    80005ee0:	09878863          	beq	a5,s8,80005f70 <printf+0x168>
    80005ee4:	07800713          	li	a4,120
    80005ee8:	0ce79563          	bne	a5,a4,80005fb2 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005eec:	f8843783          	ld	a5,-120(s0)
    80005ef0:	00878713          	addi	a4,a5,8
    80005ef4:	f8e43423          	sd	a4,-120(s0)
    80005ef8:	4605                	li	a2,1
    80005efa:	85e6                	mv	a1,s9
    80005efc:	4388                	lw	a0,0(a5)
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	d6a080e7          	jalr	-662(ra) # 80005c68 <printint>
      break;
    80005f06:	b77d                	j	80005eb4 <printf+0xac>
    switch(c){
    80005f08:	09678f63          	beq	a5,s6,80005fa6 <printf+0x19e>
    80005f0c:	0bb79363          	bne	a5,s11,80005fb2 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005f10:	f8843783          	ld	a5,-120(s0)
    80005f14:	00878713          	addi	a4,a5,8
    80005f18:	f8e43423          	sd	a4,-120(s0)
    80005f1c:	4605                	li	a2,1
    80005f1e:	45a9                	li	a1,10
    80005f20:	4388                	lw	a0,0(a5)
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	d46080e7          	jalr	-698(ra) # 80005c68 <printint>
      break;
    80005f2a:	b769                	j	80005eb4 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f2c:	f8843783          	ld	a5,-120(s0)
    80005f30:	00878713          	addi	a4,a5,8
    80005f34:	f8e43423          	sd	a4,-120(s0)
    80005f38:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f3c:	03000513          	li	a0,48
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	b00080e7          	jalr	-1280(ra) # 80005a40 <consputc>
  consputc('x');
    80005f48:	07800513          	li	a0,120
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	af4080e7          	jalr	-1292(ra) # 80005a40 <consputc>
    80005f54:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f56:	03c95793          	srli	a5,s2,0x3c
    80005f5a:	97d6                	add	a5,a5,s5
    80005f5c:	0007c503          	lbu	a0,0(a5)
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	ae0080e7          	jalr	-1312(ra) # 80005a40 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f68:	0912                	slli	s2,s2,0x4
    80005f6a:	34fd                	addiw	s1,s1,-1
    80005f6c:	f4ed                	bnez	s1,80005f56 <printf+0x14e>
    80005f6e:	b799                	j	80005eb4 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f70:	f8843783          	ld	a5,-120(s0)
    80005f74:	00878713          	addi	a4,a5,8
    80005f78:	f8e43423          	sd	a4,-120(s0)
    80005f7c:	6384                	ld	s1,0(a5)
    80005f7e:	cc89                	beqz	s1,80005f98 <printf+0x190>
      for(; *s; s++)
    80005f80:	0004c503          	lbu	a0,0(s1)
    80005f84:	d905                	beqz	a0,80005eb4 <printf+0xac>
        consputc(*s);
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	aba080e7          	jalr	-1350(ra) # 80005a40 <consputc>
      for(; *s; s++)
    80005f8e:	0485                	addi	s1,s1,1
    80005f90:	0004c503          	lbu	a0,0(s1)
    80005f94:	f96d                	bnez	a0,80005f86 <printf+0x17e>
    80005f96:	bf39                	j	80005eb4 <printf+0xac>
        s = "(null)";
    80005f98:	00002497          	auipc	s1,0x2
    80005f9c:	73048493          	addi	s1,s1,1840 # 800086c8 <etext+0x6c8>
      for(; *s; s++)
    80005fa0:	02800513          	li	a0,40
    80005fa4:	b7cd                	j	80005f86 <printf+0x17e>
      consputc('%');
    80005fa6:	855a                	mv	a0,s6
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	a98080e7          	jalr	-1384(ra) # 80005a40 <consputc>
      break;
    80005fb0:	b711                	j	80005eb4 <printf+0xac>
      consputc('%');
    80005fb2:	855a                	mv	a0,s6
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	a8c080e7          	jalr	-1396(ra) # 80005a40 <consputc>
      consputc(c);
    80005fbc:	8526                	mv	a0,s1
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	a82080e7          	jalr	-1406(ra) # 80005a40 <consputc>
      break;
    80005fc6:	b5fd                	j	80005eb4 <printf+0xac>
    80005fc8:	74a6                	ld	s1,104(sp)
    80005fca:	7906                	ld	s2,96(sp)
    80005fcc:	69e6                	ld	s3,88(sp)
    80005fce:	6aa6                	ld	s5,72(sp)
    80005fd0:	6b06                	ld	s6,64(sp)
    80005fd2:	7be2                	ld	s7,56(sp)
    80005fd4:	7c42                	ld	s8,48(sp)
    80005fd6:	7ca2                	ld	s9,40(sp)
    80005fd8:	6de2                	ld	s11,24(sp)
  if(locking)
    80005fda:	020d1263          	bnez	s10,80005ffe <printf+0x1f6>
}
    80005fde:	70e6                	ld	ra,120(sp)
    80005fe0:	7446                	ld	s0,112(sp)
    80005fe2:	6a46                	ld	s4,80(sp)
    80005fe4:	7d02                	ld	s10,32(sp)
    80005fe6:	6129                	addi	sp,sp,192
    80005fe8:	8082                	ret
    80005fea:	74a6                	ld	s1,104(sp)
    80005fec:	7906                	ld	s2,96(sp)
    80005fee:	69e6                	ld	s3,88(sp)
    80005ff0:	6aa6                	ld	s5,72(sp)
    80005ff2:	6b06                	ld	s6,64(sp)
    80005ff4:	7be2                	ld	s7,56(sp)
    80005ff6:	7c42                	ld	s8,48(sp)
    80005ff8:	7ca2                	ld	s9,40(sp)
    80005ffa:	6de2                	ld	s11,24(sp)
    80005ffc:	bff9                	j	80005fda <printf+0x1d2>
    release(&pr.lock);
    80005ffe:	00027517          	auipc	a0,0x27
    80006002:	1ea50513          	addi	a0,a0,490 # 8002d1e8 <pr>
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	3b4080e7          	jalr	948(ra) # 800063ba <release>
}
    8000600e:	bfc1                	j	80005fde <printf+0x1d6>

0000000080006010 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006010:	1141                	addi	sp,sp,-16
    80006012:	e406                	sd	ra,8(sp)
    80006014:	e022                	sd	s0,0(sp)
    80006016:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006018:	100007b7          	lui	a5,0x10000
    8000601c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006020:	10000737          	lui	a4,0x10000
    80006024:	f8000693          	li	a3,-128
    80006028:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000602c:	468d                	li	a3,3
    8000602e:	10000637          	lui	a2,0x10000
    80006032:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006036:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000603e:	10000737          	lui	a4,0x10000
    80006042:	461d                	li	a2,7
    80006044:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006048:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000604c:	00002597          	auipc	a1,0x2
    80006050:	69458593          	addi	a1,a1,1684 # 800086e0 <etext+0x6e0>
    80006054:	00027517          	auipc	a0,0x27
    80006058:	1b450513          	addi	a0,a0,436 # 8002d208 <uart_tx_lock>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	21a080e7          	jalr	538(ra) # 80006276 <initlock>
}
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  push_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	242080e7          	jalr	578(ra) # 800062ba <push_off>

  if(panicked){
    80006080:	00006797          	auipc	a5,0x6
    80006084:	f9c7a783          	lw	a5,-100(a5) # 8000c01c <panicked>
    80006088:	eb85                	bnez	a5,800060b8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000608a:	10000737          	lui	a4,0x10000
    8000608e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006090:	00074783          	lbu	a5,0(a4)
    80006094:	0207f793          	andi	a5,a5,32
    80006098:	dfe5                	beqz	a5,80006090 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000609a:	0ff4f513          	zext.b	a0,s1
    8000609e:	100007b7          	lui	a5,0x10000
    800060a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	2b4080e7          	jalr	692(ra) # 8000635a <pop_off>
}
    800060ae:	60e2                	ld	ra,24(sp)
    800060b0:	6442                	ld	s0,16(sp)
    800060b2:	64a2                	ld	s1,8(sp)
    800060b4:	6105                	addi	sp,sp,32
    800060b6:	8082                	ret
    for(;;)
    800060b8:	a001                	j	800060b8 <uartputc_sync+0x4c>

00000000800060ba <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ba:	00006797          	auipc	a5,0x6
    800060be:	f667b783          	ld	a5,-154(a5) # 8000c020 <uart_tx_r>
    800060c2:	00006717          	auipc	a4,0x6
    800060c6:	f6673703          	ld	a4,-154(a4) # 8000c028 <uart_tx_w>
    800060ca:	06f70f63          	beq	a4,a5,80006148 <uartstart+0x8e>
{
    800060ce:	7139                	addi	sp,sp,-64
    800060d0:	fc06                	sd	ra,56(sp)
    800060d2:	f822                	sd	s0,48(sp)
    800060d4:	f426                	sd	s1,40(sp)
    800060d6:	f04a                	sd	s2,32(sp)
    800060d8:	ec4e                	sd	s3,24(sp)
    800060da:	e852                	sd	s4,16(sp)
    800060dc:	e456                	sd	s5,8(sp)
    800060de:	e05a                	sd	s6,0(sp)
    800060e0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e2:	10000937          	lui	s2,0x10000
    800060e6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e8:	00027a97          	auipc	s5,0x27
    800060ec:	120a8a93          	addi	s5,s5,288 # 8002d208 <uart_tx_lock>
    uart_tx_r += 1;
    800060f0:	00006497          	auipc	s1,0x6
    800060f4:	f3048493          	addi	s1,s1,-208 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060f8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800060fc:	00006997          	auipc	s3,0x6
    80006100:	f2c98993          	addi	s3,s3,-212 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006104:	00094703          	lbu	a4,0(s2)
    80006108:	02077713          	andi	a4,a4,32
    8000610c:	c705                	beqz	a4,80006134 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000610e:	01f7f713          	andi	a4,a5,31
    80006112:	9756                	add	a4,a4,s5
    80006114:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006118:	0785                	addi	a5,a5,1
    8000611a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000611c:	8526                	mv	a0,s1
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	5c2080e7          	jalr	1474(ra) # 800016e0 <wakeup>
    WriteReg(THR, c);
    80006126:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000612a:	609c                	ld	a5,0(s1)
    8000612c:	0009b703          	ld	a4,0(s3)
    80006130:	fcf71ae3          	bne	a4,a5,80006104 <uartstart+0x4a>
  }
}
    80006134:	70e2                	ld	ra,56(sp)
    80006136:	7442                	ld	s0,48(sp)
    80006138:	74a2                	ld	s1,40(sp)
    8000613a:	7902                	ld	s2,32(sp)
    8000613c:	69e2                	ld	s3,24(sp)
    8000613e:	6a42                	ld	s4,16(sp)
    80006140:	6aa2                	ld	s5,8(sp)
    80006142:	6b02                	ld	s6,0(sp)
    80006144:	6121                	addi	sp,sp,64
    80006146:	8082                	ret
    80006148:	8082                	ret

000000008000614a <uartputc>:
{
    8000614a:	7179                	addi	sp,sp,-48
    8000614c:	f406                	sd	ra,40(sp)
    8000614e:	f022                	sd	s0,32(sp)
    80006150:	e052                	sd	s4,0(sp)
    80006152:	1800                	addi	s0,sp,48
    80006154:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006156:	00027517          	auipc	a0,0x27
    8000615a:	0b250513          	addi	a0,a0,178 # 8002d208 <uart_tx_lock>
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	1a8080e7          	jalr	424(ra) # 80006306 <acquire>
  if(panicked){
    80006166:	00006797          	auipc	a5,0x6
    8000616a:	eb67a783          	lw	a5,-330(a5) # 8000c01c <panicked>
    8000616e:	c391                	beqz	a5,80006172 <uartputc+0x28>
    for(;;)
    80006170:	a001                	j	80006170 <uartputc+0x26>
    80006172:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006174:	00006717          	auipc	a4,0x6
    80006178:	eb473703          	ld	a4,-332(a4) # 8000c028 <uart_tx_w>
    8000617c:	00006797          	auipc	a5,0x6
    80006180:	ea47b783          	ld	a5,-348(a5) # 8000c020 <uart_tx_r>
    80006184:	02078793          	addi	a5,a5,32
    80006188:	02e79f63          	bne	a5,a4,800061c6 <uartputc+0x7c>
    8000618c:	e84a                	sd	s2,16(sp)
    8000618e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006190:	00027997          	auipc	s3,0x27
    80006194:	07898993          	addi	s3,s3,120 # 8002d208 <uart_tx_lock>
    80006198:	00006497          	auipc	s1,0x6
    8000619c:	e8848493          	addi	s1,s1,-376 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a0:	00006917          	auipc	s2,0x6
    800061a4:	e8890913          	addi	s2,s2,-376 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061a8:	85ce                	mv	a1,s3
    800061aa:	8526                	mv	a0,s1
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	3a8080e7          	jalr	936(ra) # 80001554 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b4:	00093703          	ld	a4,0(s2)
    800061b8:	609c                	ld	a5,0(s1)
    800061ba:	02078793          	addi	a5,a5,32
    800061be:	fee785e3          	beq	a5,a4,800061a8 <uartputc+0x5e>
    800061c2:	6942                	ld	s2,16(sp)
    800061c4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061c6:	00027497          	auipc	s1,0x27
    800061ca:	04248493          	addi	s1,s1,66 # 8002d208 <uart_tx_lock>
    800061ce:	01f77793          	andi	a5,a4,31
    800061d2:	97a6                	add	a5,a5,s1
    800061d4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061d8:	0705                	addi	a4,a4,1
    800061da:	00006797          	auipc	a5,0x6
    800061de:	e4e7b723          	sd	a4,-434(a5) # 8000c028 <uart_tx_w>
      uartstart();
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	ed8080e7          	jalr	-296(ra) # 800060ba <uartstart>
      release(&uart_tx_lock);
    800061ea:	8526                	mv	a0,s1
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	1ce080e7          	jalr	462(ra) # 800063ba <release>
    800061f4:	64e2                	ld	s1,24(sp)
}
    800061f6:	70a2                	ld	ra,40(sp)
    800061f8:	7402                	ld	s0,32(sp)
    800061fa:	6a02                	ld	s4,0(sp)
    800061fc:	6145                	addi	sp,sp,48
    800061fe:	8082                	ret

0000000080006200 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006200:	1141                	addi	sp,sp,-16
    80006202:	e422                	sd	s0,8(sp)
    80006204:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006206:	100007b7          	lui	a5,0x10000
    8000620a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000620c:	0007c783          	lbu	a5,0(a5)
    80006210:	8b85                	andi	a5,a5,1
    80006212:	cb81                	beqz	a5,80006222 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006214:	100007b7          	lui	a5,0x10000
    80006218:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000621c:	6422                	ld	s0,8(sp)
    8000621e:	0141                	addi	sp,sp,16
    80006220:	8082                	ret
    return -1;
    80006222:	557d                	li	a0,-1
    80006224:	bfe5                	j	8000621c <uartgetc+0x1c>

0000000080006226 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006226:	1101                	addi	sp,sp,-32
    80006228:	ec06                	sd	ra,24(sp)
    8000622a:	e822                	sd	s0,16(sp)
    8000622c:	e426                	sd	s1,8(sp)
    8000622e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006230:	54fd                	li	s1,-1
    80006232:	a029                	j	8000623c <uartintr+0x16>
      break;
    consoleintr(c);
    80006234:	00000097          	auipc	ra,0x0
    80006238:	84e080e7          	jalr	-1970(ra) # 80005a82 <consoleintr>
    int c = uartgetc();
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	fc4080e7          	jalr	-60(ra) # 80006200 <uartgetc>
    if(c == -1)
    80006244:	fe9518e3          	bne	a0,s1,80006234 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006248:	00027497          	auipc	s1,0x27
    8000624c:	fc048493          	addi	s1,s1,-64 # 8002d208 <uart_tx_lock>
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	0b4080e7          	jalr	180(ra) # 80006306 <acquire>
  uartstart();
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	e60080e7          	jalr	-416(ra) # 800060ba <uartstart>
  release(&uart_tx_lock);
    80006262:	8526                	mv	a0,s1
    80006264:	00000097          	auipc	ra,0x0
    80006268:	156080e7          	jalr	342(ra) # 800063ba <release>
}
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	64a2                	ld	s1,8(sp)
    80006272:	6105                	addi	sp,sp,32
    80006274:	8082                	ret

0000000080006276 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006276:	1141                	addi	sp,sp,-16
    80006278:	e422                	sd	s0,8(sp)
    8000627a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000627c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000627e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006282:	00053823          	sd	zero,16(a0)
}
    80006286:	6422                	ld	s0,8(sp)
    80006288:	0141                	addi	sp,sp,16
    8000628a:	8082                	ret

000000008000628c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000628c:	411c                	lw	a5,0(a0)
    8000628e:	e399                	bnez	a5,80006294 <holding+0x8>
    80006290:	4501                	li	a0,0
  return r;
}
    80006292:	8082                	ret
{
    80006294:	1101                	addi	sp,sp,-32
    80006296:	ec06                	sd	ra,24(sp)
    80006298:	e822                	sd	s0,16(sp)
    8000629a:	e426                	sd	s1,8(sp)
    8000629c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000629e:	6904                	ld	s1,16(a0)
    800062a0:	ffffb097          	auipc	ra,0xffffb
    800062a4:	bc0080e7          	jalr	-1088(ra) # 80000e60 <mycpu>
    800062a8:	40a48533          	sub	a0,s1,a0
    800062ac:	00153513          	seqz	a0,a0
}
    800062b0:	60e2                	ld	ra,24(sp)
    800062b2:	6442                	ld	s0,16(sp)
    800062b4:	64a2                	ld	s1,8(sp)
    800062b6:	6105                	addi	sp,sp,32
    800062b8:	8082                	ret

00000000800062ba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062ba:	1101                	addi	sp,sp,-32
    800062bc:	ec06                	sd	ra,24(sp)
    800062be:	e822                	sd	s0,16(sp)
    800062c0:	e426                	sd	s1,8(sp)
    800062c2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c4:	100024f3          	csrr	s1,sstatus
    800062c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	b8e080e7          	jalr	-1138(ra) # 80000e60 <mycpu>
    800062da:	5d3c                	lw	a5,120(a0)
    800062dc:	cf89                	beqz	a5,800062f6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	b82080e7          	jalr	-1150(ra) # 80000e60 <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	2785                	addiw	a5,a5,1
    800062ea:	dd3c                	sw	a5,120(a0)
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	addi	sp,sp,32
    800062f4:	8082                	ret
    mycpu()->intena = old;
    800062f6:	ffffb097          	auipc	ra,0xffffb
    800062fa:	b6a080e7          	jalr	-1174(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062fe:	8085                	srli	s1,s1,0x1
    80006300:	8885                	andi	s1,s1,1
    80006302:	dd64                	sw	s1,124(a0)
    80006304:	bfe9                	j	800062de <push_off+0x24>

0000000080006306 <acquire>:
{
    80006306:	1101                	addi	sp,sp,-32
    80006308:	ec06                	sd	ra,24(sp)
    8000630a:	e822                	sd	s0,16(sp)
    8000630c:	e426                	sd	s1,8(sp)
    8000630e:	1000                	addi	s0,sp,32
    80006310:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006312:	00000097          	auipc	ra,0x0
    80006316:	fa8080e7          	jalr	-88(ra) # 800062ba <push_off>
  if(holding(lk))
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	f70080e7          	jalr	-144(ra) # 8000628c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006324:	4705                	li	a4,1
  if(holding(lk))
    80006326:	e115                	bnez	a0,8000634a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006328:	87ba                	mv	a5,a4
    8000632a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000632e:	2781                	sext.w	a5,a5
    80006330:	ffe5                	bnez	a5,80006328 <acquire+0x22>
  __sync_synchronize();
    80006332:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006336:	ffffb097          	auipc	ra,0xffffb
    8000633a:	b2a080e7          	jalr	-1238(ra) # 80000e60 <mycpu>
    8000633e:	e888                	sd	a0,16(s1)
}
    80006340:	60e2                	ld	ra,24(sp)
    80006342:	6442                	ld	s0,16(sp)
    80006344:	64a2                	ld	s1,8(sp)
    80006346:	6105                	addi	sp,sp,32
    80006348:	8082                	ret
    panic("acquire");
    8000634a:	00002517          	auipc	a0,0x2
    8000634e:	39e50513          	addi	a0,a0,926 # 800086e8 <etext+0x6e8>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	a64080e7          	jalr	-1436(ra) # 80005db6 <panic>

000000008000635a <pop_off>:

void
pop_off(void)
{
    8000635a:	1141                	addi	sp,sp,-16
    8000635c:	e406                	sd	ra,8(sp)
    8000635e:	e022                	sd	s0,0(sp)
    80006360:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006362:	ffffb097          	auipc	ra,0xffffb
    80006366:	afe080e7          	jalr	-1282(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000636a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000636e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006370:	e78d                	bnez	a5,8000639a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006372:	5d3c                	lw	a5,120(a0)
    80006374:	02f05b63          	blez	a5,800063aa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006378:	37fd                	addiw	a5,a5,-1
    8000637a:	0007871b          	sext.w	a4,a5
    8000637e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006380:	eb09                	bnez	a4,80006392 <pop_off+0x38>
    80006382:	5d7c                	lw	a5,124(a0)
    80006384:	c799                	beqz	a5,80006392 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006386:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000638a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000638e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006392:	60a2                	ld	ra,8(sp)
    80006394:	6402                	ld	s0,0(sp)
    80006396:	0141                	addi	sp,sp,16
    80006398:	8082                	ret
    panic("pop_off - interruptible");
    8000639a:	00002517          	auipc	a0,0x2
    8000639e:	35650513          	addi	a0,a0,854 # 800086f0 <etext+0x6f0>
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	a14080e7          	jalr	-1516(ra) # 80005db6 <panic>
    panic("pop_off");
    800063aa:	00002517          	auipc	a0,0x2
    800063ae:	35e50513          	addi	a0,a0,862 # 80008708 <etext+0x708>
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	a04080e7          	jalr	-1532(ra) # 80005db6 <panic>

00000000800063ba <release>:
{
    800063ba:	1101                	addi	sp,sp,-32
    800063bc:	ec06                	sd	ra,24(sp)
    800063be:	e822                	sd	s0,16(sp)
    800063c0:	e426                	sd	s1,8(sp)
    800063c2:	1000                	addi	s0,sp,32
    800063c4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	ec6080e7          	jalr	-314(ra) # 8000628c <holding>
    800063ce:	c115                	beqz	a0,800063f2 <release+0x38>
  lk->cpu = 0;
    800063d0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063d4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800063d8:	0310000f          	fence	rw,w
    800063dc:	0004a023          	sw	zero,0(s1)
  pop_off();
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	f7a080e7          	jalr	-134(ra) # 8000635a <pop_off>
}
    800063e8:	60e2                	ld	ra,24(sp)
    800063ea:	6442                	ld	s0,16(sp)
    800063ec:	64a2                	ld	s1,8(sp)
    800063ee:	6105                	addi	sp,sp,32
    800063f0:	8082                	ret
    panic("release");
    800063f2:	00002517          	auipc	a0,0x2
    800063f6:	31e50513          	addi	a0,a0,798 # 80008710 <etext+0x710>
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	9bc080e7          	jalr	-1604(ra) # 80005db6 <panic>
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
