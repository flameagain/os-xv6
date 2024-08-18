
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
    80000016:	249050ef          	jal	80005a5e <start>

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
    80000030:	00024797          	auipc	a5,0x24
    80000034:	21078793          	addi	a5,a5,528 # 80024240 <end>
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
    8000005e:	44c080e7          	jalr	1100(ra) # 800064a6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4ec080e7          	jalr	1260(ra) # 8000655a <release>
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
    8000008e:	ea2080e7          	jalr	-350(ra) # 80005f2c <panic>

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
    800000fa:	320080e7          	jalr	800(ra) # 80006416 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00024517          	auipc	a0,0x24
    80000106:	13e50513          	addi	a0,a0,318 # 80024240 <end>
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
    80000132:	378080e7          	jalr	888(ra) # 800064a6 <acquire>
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
    8000014a:	414080e7          	jalr	1044(ra) # 8000655a <release>

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
    80000174:	3ea080e7          	jalr	1002(ra) # 8000655a <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdadc1>
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
    80000352:	c28080e7          	jalr	-984(ra) # 80005f76 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	770080e7          	jalr	1904(ra) # 80001ace <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	0ae080e7          	jalr	174(ra) # 80005414 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	022080e7          	jalr	34(ra) # 80001390 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	ac6080e7          	jalr	-1338(ra) # 80005e3c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	e00080e7          	jalr	-512(ra) # 8000617e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	be8080e7          	jalr	-1048(ra) # 80005f76 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	bd8080e7          	jalr	-1064(ra) # 80005f76 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	bc8080e7          	jalr	-1080(ra) # 80005f76 <printf>
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
    800003da:	6d0080e7          	jalr	1744(ra) # 80001aa6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6f0080e7          	jalr	1776(ra) # 80001ace <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	014080e7          	jalr	20(ra) # 800053fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	026080e7          	jalr	38(ra) # 80005414 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	e2a080e7          	jalr	-470(ra) # 80002220 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	580080e7          	jalr	1408(ra) # 8000297e <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5d4080e7          	jalr	1492(ra) # 800039da <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	126080e7          	jalr	294(ra) # 80005534 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d3e080e7          	jalr	-706(ra) # 80001154 <userinit>
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
    80000484:	aac080e7          	jalr	-1364(ra) # 80005f2c <panic>
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
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdadb7>
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
    800005aa:	986080e7          	jalr	-1658(ra) # 80005f2c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	976080e7          	jalr	-1674(ra) # 80005f2c <panic>
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
    80000606:	92a080e7          	jalr	-1750(ra) # 80005f2c <panic>

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
    8000074c:	7e4080e7          	jalr	2020(ra) # 80005f2c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	7d4080e7          	jalr	2004(ra) # 80005f2c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	7c4080e7          	jalr	1988(ra) # 80005f2c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	7b4080e7          	jalr	1972(ra) # 80005f2c <panic>
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
    80000870:	6c0080e7          	jalr	1728(ra) # 80005f2c <panic>

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
    800009bc:	574080e7          	jalr	1396(ra) # 80005f2c <panic>
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
    80000a9a:	496080e7          	jalr	1174(ra) # 80005f2c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	486080e7          	jalr	1158(ra) # 80005f2c <panic>
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
    80000b14:	41c080e7          	jalr	1052(ra) # 80005f2c <panic>

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
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdadc0>
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
    80000d0e:	04fa5937          	lui	s2,0x4fa5
    80000d12:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	fa590913          	addi	s2,s2,-91
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	0000ca97          	auipc	s5,0xc
    80000d34:	560a8a93          	addi	s5,s5,1376 # 8000d290 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	srai	a1,a1,0x3
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
    80000d66:	16848493          	addi	s1,s1,360
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
    80000d8e:	1a2080e7          	jalr	418(ra) # 80005f2c <panic>

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
    80000dba:	660080e7          	jalr	1632(ra) # 80006416 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	0000b517          	auipc	a0,0xb
    80000dca:	2a250513          	addi	a0,a0,674 # 8000c068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	648080e7          	jalr	1608(ra) # 80006416 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000b497          	auipc	s1,0xb
    80000dda:	6aa48493          	addi	s1,s1,1706 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	04fa5937          	lui	s2,0x4fa5
    80000dec:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	fa590913          	addi	s2,s2,-91
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	fa590913          	addi	s2,s2,-91
    80000dfc:	0932                	slli	s2,s2,0xc
    80000dfe:	fa590913          	addi	s2,s2,-91
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	0000ca17          	auipc	s4,0xc
    80000e0e:	486a0a13          	addi	s4,s4,1158 # 8000d290 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	600080e7          	jalr	1536(ra) # 80006416 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	srai	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	16848493          	addi	s1,s1,360
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
    80000e8a:	5d4080e7          	jalr	1492(ra) # 8000645a <push_off>
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
    80000ea4:	65a080e7          	jalr	1626(ra) # 800064fa <pop_off>
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
    80000ec8:	696080e7          	jalr	1686(ra) # 8000655a <release>

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
    80000eda:	c10080e7          	jalr	-1008(ra) # 80001ae6 <usertrapret>
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
    80000ef4:	a0e080e7          	jalr	-1522(ra) # 800028fe <fsinit>
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
    80000f14:	596080e7          	jalr	1430(ra) # 800064a6 <acquire>
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
    80000f2e:	630080e7          	jalr	1584(ra) # 8000655a <release>
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
    8000109a:	0000c917          	auipc	s2,0xc
    8000109e:	1f690913          	addi	s2,s2,502 # 8000d290 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	402080e7          	jalr	1026(ra) # 800064a6 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	c395                	beqz	a5,800010d2 <allocproc+0x4c>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	4a8080e7          	jalr	1192(ra) # 8000655a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	16848493          	addi	s1,s1,360
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
}
    800010c4:	8526                	mv	a0,s1
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6902                	ld	s2,0(sp)
    800010ce:	6105                	addi	sp,sp,32
    800010d0:	8082                	ret
  p->pid = allocpid();
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	e28080e7          	jalr	-472(ra) # 80000efa <allocpid>
    800010da:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010dc:	4785                	li	a5,1
    800010de:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	03a080e7          	jalr	58(ra) # 8000011a <kalloc>
    800010e8:	892a                	mv	s2,a0
    800010ea:	eca8                	sd	a0,88(s1)
    800010ec:	cd05                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	e50080e7          	jalr	-432(ra) # 80000f40 <proc_pagetable>
    800010f8:	892a                	mv	s2,a0
    800010fa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010fc:	c121                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010fe:	07000613          	li	a2,112
    80001102:	4581                	li	a1,0
    80001104:	06048513          	addi	a0,s1,96
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	072080e7          	jalr	114(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001110:	00000797          	auipc	a5,0x0
    80001114:	da478793          	addi	a5,a5,-604 # 80000eb4 <forkret>
    80001118:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111a:	60bc                	ld	a5,64(s1)
    8000111c:	6705                	lui	a4,0x1
    8000111e:	97ba                	add	a5,a5,a4
    80001120:	f4bc                	sd	a5,104(s1)
  return p;
    80001122:	b74d                	j	800010c4 <allocproc+0x3e>
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	42a080e7          	jalr	1066(ra) # 8000655a <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	b769                	j	800010c4 <allocproc+0x3e>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	412080e7          	jalr	1042(ra) # 8000655a <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	bf8d                	j	800010c4 <allocproc+0x3e>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	0000b797          	auipc	a5,0xb
    8000116c:	eaa7b423          	sd	a0,-344(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	0000a597          	auipc	a1,0xa
    80001178:	f2c58593          	addi	a1,a1,-212 # 8000b0a0 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	684080e7          	jalr	1668(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	11a080e7          	jalr	282(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	242080e7          	jalr	578(ra) # 800033f4 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	396080e7          	jalr	918(ra) # 8000655a <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	892a                	mv	s2,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
    800011f0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011f4:	00904f63          	bgtz	s1,80001212 <growproc+0x3c>
  } else if(n < 0){
    800011f8:	0204cd63          	bltz	s1,80001232 <growproc+0x5c>
  p->sz = sz;
    800011fc:	1782                	slli	a5,a5,0x20
    800011fe:	9381                	srli	a5,a5,0x20
    80001200:	04f93423          	sd	a5,72(s2)
  return 0;
    80001204:	4501                	li	a0,0
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6902                	ld	s2,0(sp)
    8000120e:	6105                	addi	sp,sp,32
    80001210:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001212:	00f4863b          	addw	a2,s1,a5
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	1582                	slli	a1,a1,0x20
    8000121c:	9181                	srli	a1,a1,0x20
    8000121e:	6928                	ld	a0,80(a0)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	69c080e7          	jalr	1692(ra) # 800008bc <uvmalloc>
    80001228:	0005079b          	sext.w	a5,a0
    8000122c:	fbe1                	bnez	a5,800011fc <growproc+0x26>
      return -1;
    8000122e:	557d                	li	a0,-1
    80001230:	bfd9                	j	80001206 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001232:	00f4863b          	addw	a2,s1,a5
    80001236:	1602                	slli	a2,a2,0x20
    80001238:	9201                	srli	a2,a2,0x20
    8000123a:	1582                	slli	a1,a1,0x20
    8000123c:	9181                	srli	a1,a1,0x20
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	634080e7          	jalr	1588(ra) # 80000874 <uvmdealloc>
    80001248:	0005079b          	sext.w	a5,a0
    8000124c:	bf45                	j	800011fc <growproc+0x26>

000000008000124e <fork>:
{
    8000124e:	7139                	addi	sp,sp,-64
    80001250:	fc06                	sd	ra,56(sp)
    80001252:	f822                	sd	s0,48(sp)
    80001254:	f04a                	sd	s2,32(sp)
    80001256:	e456                	sd	s5,8(sp)
    80001258:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	c22080e7          	jalr	-990(ra) # 80000e7c <myproc>
    80001262:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001264:	00000097          	auipc	ra,0x0
    80001268:	e22080e7          	jalr	-478(ra) # 80001086 <allocproc>
    8000126c:	12050063          	beqz	a0,8000138c <fork+0x13e>
    80001270:	e852                	sd	s4,16(sp)
    80001272:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	048ab603          	ld	a2,72(s5)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	050ab503          	ld	a0,80(s5)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	796080e7          	jalr	1942(ra) # 80000a14 <uvmcopy>
    80001286:	04054a63          	bltz	a0,800012da <fork+0x8c>
    8000128a:	f426                	sd	s1,40(sp)
    8000128c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000128e:	048ab783          	ld	a5,72(s5)
    80001292:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001296:	058ab683          	ld	a3,88(s5)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	058a3703          	ld	a4,88(s4)
    800012a0:	12068693          	addi	a3,a3,288
    800012a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a8:	6788                	ld	a0,8(a5)
    800012aa:	6b8c                	ld	a1,16(a5)
    800012ac:	6f90                	ld	a2,24(a5)
    800012ae:	01073023          	sd	a6,0(a4)
    800012b2:	e708                	sd	a0,8(a4)
    800012b4:	eb0c                	sd	a1,16(a4)
    800012b6:	ef10                	sd	a2,24(a4)
    800012b8:	02078793          	addi	a5,a5,32
    800012bc:	02070713          	addi	a4,a4,32
    800012c0:	fed792e3          	bne	a5,a3,800012a4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012c4:	058a3783          	ld	a5,88(s4)
    800012c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012cc:	0d0a8493          	addi	s1,s5,208
    800012d0:	0d0a0913          	addi	s2,s4,208
    800012d4:	150a8993          	addi	s3,s5,336
    800012d8:	a015                	j	800012fc <fork+0xae>
    freeproc(np);
    800012da:	8552                	mv	a0,s4
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	d52080e7          	jalr	-686(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012e4:	8552                	mv	a0,s4
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	274080e7          	jalr	628(ra) # 8000655a <release>
    return -1;
    800012ee:	597d                	li	s2,-1
    800012f0:	6a42                	ld	s4,16(sp)
    800012f2:	a071                	j	8000137e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012f4:	04a1                	addi	s1,s1,8
    800012f6:	0921                	addi	s2,s2,8
    800012f8:	01348b63          	beq	s1,s3,8000130e <fork+0xc0>
    if(p->ofile[i])
    800012fc:	6088                	ld	a0,0(s1)
    800012fe:	d97d                	beqz	a0,800012f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	76c080e7          	jalr	1900(ra) # 80003a6c <filedup>
    80001308:	00a93023          	sd	a0,0(s2)
    8000130c:	b7e5                	j	800012f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000130e:	150ab503          	ld	a0,336(s5)
    80001312:	00002097          	auipc	ra,0x2
    80001316:	822080e7          	jalr	-2014(ra) # 80002b34 <idup>
    8000131a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	158a8593          	addi	a1,s5,344
    80001324:	158a0513          	addi	a0,s4,344
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	f94080e7          	jalr	-108(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001330:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	224080e7          	jalr	548(ra) # 8000655a <release>
  acquire(&wait_lock);
    8000133e:	0000b497          	auipc	s1,0xb
    80001342:	d2a48493          	addi	s1,s1,-726 # 8000c068 <wait_lock>
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	15e080e7          	jalr	350(ra) # 800064a6 <acquire>
  np->parent = p;
    80001350:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	204080e7          	jalr	516(ra) # 8000655a <release>
  acquire(&np->lock);
    8000135e:	8552                	mv	a0,s4
    80001360:	00005097          	auipc	ra,0x5
    80001364:	146080e7          	jalr	326(ra) # 800064a6 <acquire>
  np->state = RUNNABLE;
    80001368:	478d                	li	a5,3
    8000136a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00005097          	auipc	ra,0x5
    80001374:	1ea080e7          	jalr	490(ra) # 8000655a <release>
  return pid;
    80001378:	74a2                	ld	s1,40(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
}
    8000137e:	854a                	mv	a0,s2
    80001380:	70e2                	ld	ra,56(sp)
    80001382:	7442                	ld	s0,48(sp)
    80001384:	7902                	ld	s2,32(sp)
    80001386:	6aa2                	ld	s5,8(sp)
    80001388:	6121                	addi	sp,sp,64
    8000138a:	8082                	ret
    return -1;
    8000138c:	597d                	li	s2,-1
    8000138e:	bfc5                	j	8000137e <fork+0x130>

0000000080001390 <scheduler>:
{
    80001390:	7139                	addi	sp,sp,-64
    80001392:	fc06                	sd	ra,56(sp)
    80001394:	f822                	sd	s0,48(sp)
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	ec4e                	sd	s3,24(sp)
    8000139c:	e852                	sd	s4,16(sp)
    8000139e:	e456                	sd	s5,8(sp)
    800013a0:	e05a                	sd	s6,0(sp)
    800013a2:	0080                	addi	s0,sp,64
    800013a4:	8792                	mv	a5,tp
  int id = r_tp();
    800013a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a8:	00779a93          	slli	s5,a5,0x7
    800013ac:	0000b717          	auipc	a4,0xb
    800013b0:	ca470713          	addi	a4,a4,-860 # 8000c050 <pid_lock>
    800013b4:	9756                	add	a4,a4,s5
    800013b6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ba:	0000b717          	auipc	a4,0xb
    800013be:	cce70713          	addi	a4,a4,-818 # 8000c088 <cpus+0x8>
    800013c2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013c4:	498d                	li	s3,3
        p->state = RUNNING;
    800013c6:	4b11                	li	s6,4
        c->proc = p;
    800013c8:	079e                	slli	a5,a5,0x7
    800013ca:	0000ba17          	auipc	s4,0xb
    800013ce:	c86a0a13          	addi	s4,s4,-890 # 8000c050 <pid_lock>
    800013d2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	0000c917          	auipc	s2,0xc
    800013d8:	ebc90913          	addi	s2,s2,-324 # 8000d290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e4:	10079073          	csrw	sstatus,a5
    800013e8:	0000b497          	auipc	s1,0xb
    800013ec:	09848493          	addi	s1,s1,152 # 8000c480 <proc>
    800013f0:	a811                	j	80001404 <scheduler+0x74>
      release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	166080e7          	jalr	358(ra) # 8000655a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	16848493          	addi	s1,s1,360
    80001400:	fd248ee3          	beq	s1,s2,800013dc <scheduler+0x4c>
      acquire(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	0a0080e7          	jalr	160(ra) # 800064a6 <acquire>
      if(p->state == RUNNABLE) {
    8000140e:	4c9c                	lw	a5,24(s1)
    80001410:	ff3791e3          	bne	a5,s3,800013f2 <scheduler+0x62>
        p->state = RUNNING;
    80001414:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001418:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141c:	06048593          	addi	a1,s1,96
    80001420:	8556                	mv	a0,s5
    80001422:	00000097          	auipc	ra,0x0
    80001426:	61a080e7          	jalr	1562(ra) # 80001a3c <swtch>
        c->proc = 0;
    8000142a:	020a3823          	sd	zero,48(s4)
    8000142e:	b7d1                	j	800013f2 <scheduler+0x62>

0000000080001430 <sched>:
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	a3e080e7          	jalr	-1474(ra) # 80000e7c <myproc>
    80001446:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	fe4080e7          	jalr	-28(ra) # 8000642c <holding>
    80001450:	c93d                	beqz	a0,800014c6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001452:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	0000b717          	auipc	a4,0xb
    8000145c:	bf870713          	addi	a4,a4,-1032 # 8000c050 <pid_lock>
    80001460:	97ba                	add	a5,a5,a4
    80001462:	0a87a703          	lw	a4,168(a5)
    80001466:	4785                	li	a5,1
    80001468:	06f71763          	bne	a4,a5,800014d6 <sched+0xa6>
  if(p->state == RUNNING)
    8000146c:	4c98                	lw	a4,24(s1)
    8000146e:	4791                	li	a5,4
    80001470:	06f70b63          	beq	a4,a5,800014e6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001474:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001478:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000147a:	efb5                	bnez	a5,800014f6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147e:	0000b917          	auipc	s2,0xb
    80001482:	bd290913          	addi	s2,s2,-1070 # 8000c050 <pid_lock>
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	97ca                	add	a5,a5,s2
    8000148c:	0ac7a983          	lw	s3,172(a5)
    80001490:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001492:	2781                	sext.w	a5,a5
    80001494:	079e                	slli	a5,a5,0x7
    80001496:	0000b597          	auipc	a1,0xb
    8000149a:	bf258593          	addi	a1,a1,-1038 # 8000c088 <cpus+0x8>
    8000149e:	95be                	add	a1,a1,a5
    800014a0:	06048513          	addi	a0,s1,96
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	598080e7          	jalr	1432(ra) # 80001a3c <swtch>
    800014ac:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	993e                	add	s2,s2,a5
    800014b4:	0b392623          	sw	s3,172(s2)
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6145                	addi	sp,sp,48
    800014c4:	8082                	ret
    panic("sched p->lock");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	cd250513          	addi	a0,a0,-814 # 80008198 <etext+0x198>
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	a5e080e7          	jalr	-1442(ra) # 80005f2c <panic>
    panic("sched locks");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	cd250513          	addi	a0,a0,-814 # 800081a8 <etext+0x1a8>
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	a4e080e7          	jalr	-1458(ra) # 80005f2c <panic>
    panic("sched running");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	cd250513          	addi	a0,a0,-814 # 800081b8 <etext+0x1b8>
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	a3e080e7          	jalr	-1474(ra) # 80005f2c <panic>
    panic("sched interruptible");
    800014f6:	00007517          	auipc	a0,0x7
    800014fa:	cd250513          	addi	a0,a0,-814 # 800081c8 <etext+0x1c8>
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	a2e080e7          	jalr	-1490(ra) # 80005f2c <panic>

0000000080001506 <yield>:
{
    80001506:	1101                	addi	sp,sp,-32
    80001508:	ec06                	sd	ra,24(sp)
    8000150a:	e822                	sd	s0,16(sp)
    8000150c:	e426                	sd	s1,8(sp)
    8000150e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	96c080e7          	jalr	-1684(ra) # 80000e7c <myproc>
    80001518:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	f8c080e7          	jalr	-116(ra) # 800064a6 <acquire>
  p->state = RUNNABLE;
    80001522:	478d                	li	a5,3
    80001524:	cc9c                	sw	a5,24(s1)
  sched();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	f0a080e7          	jalr	-246(ra) # 80001430 <sched>
  release(&p->lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	02a080e7          	jalr	42(ra) # 8000655a <release>
}
    80001538:	60e2                	ld	ra,24(sp)
    8000153a:	6442                	ld	s0,16(sp)
    8000153c:	64a2                	ld	s1,8(sp)
    8000153e:	6105                	addi	sp,sp,32
    80001540:	8082                	ret

0000000080001542 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001542:	7179                	addi	sp,sp,-48
    80001544:	f406                	sd	ra,40(sp)
    80001546:	f022                	sd	s0,32(sp)
    80001548:	ec26                	sd	s1,24(sp)
    8000154a:	e84a                	sd	s2,16(sp)
    8000154c:	e44e                	sd	s3,8(sp)
    8000154e:	1800                	addi	s0,sp,48
    80001550:	89aa                	mv	s3,a0
    80001552:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	928080e7          	jalr	-1752(ra) # 80000e7c <myproc>
    8000155c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	f48080e7          	jalr	-184(ra) # 800064a6 <acquire>
  release(lk);
    80001566:	854a                	mv	a0,s2
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	ff2080e7          	jalr	-14(ra) # 8000655a <release>

  // Go to sleep.
  p->chan = chan;
    80001570:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001574:	4789                	li	a5,2
    80001576:	cc9c                	sw	a5,24(s1)

  sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	eb8080e7          	jalr	-328(ra) # 80001430 <sched>

  // Tidy up.
  p->chan = 0;
    80001580:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	fd4080e7          	jalr	-44(ra) # 8000655a <release>
  acquire(lk);
    8000158e:	854a                	mv	a0,s2
    80001590:	00005097          	auipc	ra,0x5
    80001594:	f16080e7          	jalr	-234(ra) # 800064a6 <acquire>
}
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <wait>:
{
    800015a6:	715d                	addi	sp,sp,-80
    800015a8:	e486                	sd	ra,72(sp)
    800015aa:	e0a2                	sd	s0,64(sp)
    800015ac:	fc26                	sd	s1,56(sp)
    800015ae:	f84a                	sd	s2,48(sp)
    800015b0:	f44e                	sd	s3,40(sp)
    800015b2:	f052                	sd	s4,32(sp)
    800015b4:	ec56                	sd	s5,24(sp)
    800015b6:	e85a                	sd	s6,16(sp)
    800015b8:	e45e                	sd	s7,8(sp)
    800015ba:	e062                	sd	s8,0(sp)
    800015bc:	0880                	addi	s0,sp,80
    800015be:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	8bc080e7          	jalr	-1860(ra) # 80000e7c <myproc>
    800015c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ca:	0000b517          	auipc	a0,0xb
    800015ce:	a9e50513          	addi	a0,a0,-1378 # 8000c068 <wait_lock>
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	ed4080e7          	jalr	-300(ra) # 800064a6 <acquire>
    havekids = 0;
    800015da:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    800015dc:	4a15                	li	s4,5
        havekids = 1;
    800015de:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015e0:	0000c997          	auipc	s3,0xc
    800015e4:	cb098993          	addi	s3,s3,-848 # 8000d290 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e8:	0000bb97          	auipc	s7,0xb
    800015ec:	a80b8b93          	addi	s7,s7,-1408 # 8000c068 <wait_lock>
    800015f0:	a87d                	j	800016ae <wait+0x108>
          pid = np->pid;
    800015f2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f6:	000c0e63          	beqz	s8,80001612 <wait+0x6c>
    800015fa:	4691                	li	a3,4
    800015fc:	02c48613          	addi	a2,s1,44
    80001600:	85e2                	mv	a1,s8
    80001602:	05093503          	ld	a0,80(s2)
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	512080e7          	jalr	1298(ra) # 80000b18 <copyout>
    8000160e:	04054163          	bltz	a0,80001650 <wait+0xaa>
          freeproc(np);
    80001612:	8526                	mv	a0,s1
    80001614:	00000097          	auipc	ra,0x0
    80001618:	a1a080e7          	jalr	-1510(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	f3c080e7          	jalr	-196(ra) # 8000655a <release>
          release(&wait_lock);
    80001626:	0000b517          	auipc	a0,0xb
    8000162a:	a4250513          	addi	a0,a0,-1470 # 8000c068 <wait_lock>
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	f2c080e7          	jalr	-212(ra) # 8000655a <release>
}
    80001636:	854e                	mv	a0,s3
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret
            release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	f08080e7          	jalr	-248(ra) # 8000655a <release>
            release(&wait_lock);
    8000165a:	0000b517          	auipc	a0,0xb
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 8000c068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	ef8080e7          	jalr	-264(ra) # 8000655a <release>
            return -1;
    8000166a:	59fd                	li	s3,-1
    8000166c:	b7e9                	j	80001636 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166e:	16848493          	addi	s1,s1,360
    80001672:	03348463          	beq	s1,s3,8000169a <wait+0xf4>
      if(np->parent == p){
    80001676:	7c9c                	ld	a5,56(s1)
    80001678:	ff279be3          	bne	a5,s2,8000166e <wait+0xc8>
        acquire(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	e28080e7          	jalr	-472(ra) # 800064a6 <acquire>
        if(np->state == ZOMBIE){
    80001686:	4c9c                	lw	a5,24(s1)
    80001688:	f74785e3          	beq	a5,s4,800015f2 <wait+0x4c>
        release(&np->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	ecc080e7          	jalr	-308(ra) # 8000655a <release>
        havekids = 1;
    80001696:	8756                	mv	a4,s5
    80001698:	bfd9                	j	8000166e <wait+0xc8>
    if(!havekids || p->killed){
    8000169a:	c305                	beqz	a4,800016ba <wait+0x114>
    8000169c:	02892783          	lw	a5,40(s2)
    800016a0:	ef89                	bnez	a5,800016ba <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016a2:	85de                	mv	a1,s7
    800016a4:	854a                	mv	a0,s2
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	e9c080e7          	jalr	-356(ra) # 80001542 <sleep>
    havekids = 0;
    800016ae:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    800016b0:	0000b497          	auipc	s1,0xb
    800016b4:	dd048493          	addi	s1,s1,-560 # 8000c480 <proc>
    800016b8:	bf7d                	j	80001676 <wait+0xd0>
      release(&wait_lock);
    800016ba:	0000b517          	auipc	a0,0xb
    800016be:	9ae50513          	addi	a0,a0,-1618 # 8000c068 <wait_lock>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	e98080e7          	jalr	-360(ra) # 8000655a <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b7ad                	j	80001636 <wait+0x90>

00000000800016ce <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	0000b497          	auipc	s1,0xb
    800016e4:	da048493          	addi	s1,s1,-608 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e8:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	0000c917          	auipc	s2,0xc
    800016ee:	ba690913          	addi	s2,s2,-1114 # 8000d290 <tickslock>
    800016f2:	a811                	j	80001706 <wakeup+0x38>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	e64080e7          	jalr	-412(ra) # 8000655a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	16848493          	addi	s1,s1,360
    80001702:	03248663          	beq	s1,s2,8000172e <wakeup+0x60>
    if(p != myproc()){
    80001706:	fffff097          	auipc	ra,0xfffff
    8000170a:	776080e7          	jalr	1910(ra) # 80000e7c <myproc>
    8000170e:	fea488e3          	beq	s1,a0,800016fe <wakeup+0x30>
      acquire(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	d92080e7          	jalr	-622(ra) # 800064a6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171c:	4c9c                	lw	a5,24(s1)
    8000171e:	fd379be3          	bne	a5,s3,800016f4 <wakeup+0x26>
    80001722:	709c                	ld	a5,32(s1)
    80001724:	fd4798e3          	bne	a5,s4,800016f4 <wakeup+0x26>
        p->state = RUNNABLE;
    80001728:	478d                	li	a5,3
    8000172a:	cc9c                	sw	a5,24(s1)
    8000172c:	b7e1                	j	800016f4 <wakeup+0x26>
    }
  }
}
    8000172e:	70a2                	ld	ra,40(sp)
    80001730:	7402                	ld	s0,32(sp)
    80001732:	64e2                	ld	s1,24(sp)
    80001734:	6942                	ld	s2,16(sp)
    80001736:	69a2                	ld	s3,8(sp)
    80001738:	6a02                	ld	s4,0(sp)
    8000173a:	6145                	addi	sp,sp,48
    8000173c:	8082                	ret

000000008000173e <reparent>:
{
    8000173e:	7179                	addi	sp,sp,-48
    80001740:	f406                	sd	ra,40(sp)
    80001742:	f022                	sd	s0,32(sp)
    80001744:	ec26                	sd	s1,24(sp)
    80001746:	e84a                	sd	s2,16(sp)
    80001748:	e44e                	sd	s3,8(sp)
    8000174a:	e052                	sd	s4,0(sp)
    8000174c:	1800                	addi	s0,sp,48
    8000174e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001750:	0000b497          	auipc	s1,0xb
    80001754:	d3048493          	addi	s1,s1,-720 # 8000c480 <proc>
      pp->parent = initproc;
    80001758:	0000ba17          	auipc	s4,0xb
    8000175c:	8b8a0a13          	addi	s4,s4,-1864 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	0000c997          	auipc	s3,0xc
    80001764:	b3098993          	addi	s3,s3,-1232 # 8000d290 <tickslock>
    80001768:	a029                	j	80001772 <reparent+0x34>
    8000176a:	16848493          	addi	s1,s1,360
    8000176e:	01348d63          	beq	s1,s3,80001788 <reparent+0x4a>
    if(pp->parent == p){
    80001772:	7c9c                	ld	a5,56(s1)
    80001774:	ff279be3          	bne	a5,s2,8000176a <reparent+0x2c>
      pp->parent = initproc;
    80001778:	000a3503          	ld	a0,0(s4)
    8000177c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	f50080e7          	jalr	-176(ra) # 800016ce <wakeup>
    80001786:	b7d5                	j	8000176a <reparent+0x2c>
}
    80001788:	70a2                	ld	ra,40(sp)
    8000178a:	7402                	ld	s0,32(sp)
    8000178c:	64e2                	ld	s1,24(sp)
    8000178e:	6942                	ld	s2,16(sp)
    80001790:	69a2                	ld	s3,8(sp)
    80001792:	6a02                	ld	s4,0(sp)
    80001794:	6145                	addi	sp,sp,48
    80001796:	8082                	ret

0000000080001798 <exit>:
{
    80001798:	7179                	addi	sp,sp,-48
    8000179a:	f406                	sd	ra,40(sp)
    8000179c:	f022                	sd	s0,32(sp)
    8000179e:	ec26                	sd	s1,24(sp)
    800017a0:	e84a                	sd	s2,16(sp)
    800017a2:	e44e                	sd	s3,8(sp)
    800017a4:	e052                	sd	s4,0(sp)
    800017a6:	1800                	addi	s0,sp,48
    800017a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017aa:	fffff097          	auipc	ra,0xfffff
    800017ae:	6d2080e7          	jalr	1746(ra) # 80000e7c <myproc>
    800017b2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b4:	0000b797          	auipc	a5,0xb
    800017b8:	85c7b783          	ld	a5,-1956(a5) # 8000c010 <initproc>
    800017bc:	0d050493          	addi	s1,a0,208
    800017c0:	15050913          	addi	s2,a0,336
    800017c4:	02a79363          	bne	a5,a0,800017ea <exit+0x52>
    panic("init exiting");
    800017c8:	00007517          	auipc	a0,0x7
    800017cc:	a1850513          	addi	a0,a0,-1512 # 800081e0 <etext+0x1e0>
    800017d0:	00004097          	auipc	ra,0x4
    800017d4:	75c080e7          	jalr	1884(ra) # 80005f2c <panic>
      fileclose(f);
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	2e6080e7          	jalr	742(ra) # 80003abe <fileclose>
      p->ofile[fd] = 0;
    800017e0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e4:	04a1                	addi	s1,s1,8
    800017e6:	01248563          	beq	s1,s2,800017f0 <exit+0x58>
    if(p->ofile[fd]){
    800017ea:	6088                	ld	a0,0(s1)
    800017ec:	f575                	bnez	a0,800017d8 <exit+0x40>
    800017ee:	bfdd                	j	800017e4 <exit+0x4c>
  begin_op();
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	e04080e7          	jalr	-508(ra) # 800035f4 <begin_op>
  iput(p->cwd);
    800017f8:	1509b503          	ld	a0,336(s3)
    800017fc:	00001097          	auipc	ra,0x1
    80001800:	5e2080e7          	jalr	1506(ra) # 80002dde <iput>
  end_op();
    80001804:	00002097          	auipc	ra,0x2
    80001808:	e6a080e7          	jalr	-406(ra) # 8000366e <end_op>
  p->cwd = 0;
    8000180c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001810:	0000b497          	auipc	s1,0xb
    80001814:	85848493          	addi	s1,s1,-1960 # 8000c068 <wait_lock>
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	c8c080e7          	jalr	-884(ra) # 800064a6 <acquire>
  reparent(p);
    80001822:	854e                	mv	a0,s3
    80001824:	00000097          	auipc	ra,0x0
    80001828:	f1a080e7          	jalr	-230(ra) # 8000173e <reparent>
  wakeup(p->parent);
    8000182c:	0389b503          	ld	a0,56(s3)
    80001830:	00000097          	auipc	ra,0x0
    80001834:	e9e080e7          	jalr	-354(ra) # 800016ce <wakeup>
  acquire(&p->lock);
    80001838:	854e                	mv	a0,s3
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	c6c080e7          	jalr	-916(ra) # 800064a6 <acquire>
  p->xstate = status;
    80001842:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001846:	4795                	li	a5,5
    80001848:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	d0c080e7          	jalr	-756(ra) # 8000655a <release>
  sched();
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	bda080e7          	jalr	-1062(ra) # 80001430 <sched>
  panic("zombie exit");
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	99250513          	addi	a0,a0,-1646 # 800081f0 <etext+0x1f0>
    80001866:	00004097          	auipc	ra,0x4
    8000186a:	6c6080e7          	jalr	1734(ra) # 80005f2c <panic>

000000008000186e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000186e:	7179                	addi	sp,sp,-48
    80001870:	f406                	sd	ra,40(sp)
    80001872:	f022                	sd	s0,32(sp)
    80001874:	ec26                	sd	s1,24(sp)
    80001876:	e84a                	sd	s2,16(sp)
    80001878:	e44e                	sd	s3,8(sp)
    8000187a:	1800                	addi	s0,sp,48
    8000187c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000187e:	0000b497          	auipc	s1,0xb
    80001882:	c0248493          	addi	s1,s1,-1022 # 8000c480 <proc>
    80001886:	0000c997          	auipc	s3,0xc
    8000188a:	a0a98993          	addi	s3,s3,-1526 # 8000d290 <tickslock>
    acquire(&p->lock);
    8000188e:	8526                	mv	a0,s1
    80001890:	00005097          	auipc	ra,0x5
    80001894:	c16080e7          	jalr	-1002(ra) # 800064a6 <acquire>
    if(p->pid == pid){
    80001898:	589c                	lw	a5,48(s1)
    8000189a:	03278363          	beq	a5,s2,800018c0 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	cba080e7          	jalr	-838(ra) # 8000655a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a8:	16848493          	addi	s1,s1,360
    800018ac:	ff3491e3          	bne	s1,s3,8000188e <kill+0x20>
  }
  return -1;
    800018b0:	557d                	li	a0,-1
}
    800018b2:	70a2                	ld	ra,40(sp)
    800018b4:	7402                	ld	s0,32(sp)
    800018b6:	64e2                	ld	s1,24(sp)
    800018b8:	6942                	ld	s2,16(sp)
    800018ba:	69a2                	ld	s3,8(sp)
    800018bc:	6145                	addi	sp,sp,48
    800018be:	8082                	ret
      p->killed = 1;
    800018c0:	4785                	li	a5,1
    800018c2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018c4:	4c98                	lw	a4,24(s1)
    800018c6:	4789                	li	a5,2
    800018c8:	00f70963          	beq	a4,a5,800018da <kill+0x6c>
      release(&p->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	c8c080e7          	jalr	-884(ra) # 8000655a <release>
      return 0;
    800018d6:	4501                	li	a0,0
    800018d8:	bfe9                	j	800018b2 <kill+0x44>
        p->state = RUNNABLE;
    800018da:	478d                	li	a5,3
    800018dc:	cc9c                	sw	a5,24(s1)
    800018de:	b7fd                	j	800018cc <kill+0x5e>

00000000800018e0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e0:	7179                	addi	sp,sp,-48
    800018e2:	f406                	sd	ra,40(sp)
    800018e4:	f022                	sd	s0,32(sp)
    800018e6:	ec26                	sd	s1,24(sp)
    800018e8:	e84a                	sd	s2,16(sp)
    800018ea:	e44e                	sd	s3,8(sp)
    800018ec:	e052                	sd	s4,0(sp)
    800018ee:	1800                	addi	s0,sp,48
    800018f0:	84aa                	mv	s1,a0
    800018f2:	892e                	mv	s2,a1
    800018f4:	89b2                	mv	s3,a2
    800018f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f8:	fffff097          	auipc	ra,0xfffff
    800018fc:	584080e7          	jalr	1412(ra) # 80000e7c <myproc>
  if(user_dst){
    80001900:	c08d                	beqz	s1,80001922 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001902:	86d2                	mv	a3,s4
    80001904:	864e                	mv	a2,s3
    80001906:	85ca                	mv	a1,s2
    80001908:	6928                	ld	a0,80(a0)
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	20e080e7          	jalr	526(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001912:	70a2                	ld	ra,40(sp)
    80001914:	7402                	ld	s0,32(sp)
    80001916:	64e2                	ld	s1,24(sp)
    80001918:	6942                	ld	s2,16(sp)
    8000191a:	69a2                	ld	s3,8(sp)
    8000191c:	6a02                	ld	s4,0(sp)
    8000191e:	6145                	addi	sp,sp,48
    80001920:	8082                	ret
    memmove((char *)dst, src, len);
    80001922:	000a061b          	sext.w	a2,s4
    80001926:	85ce                	mv	a1,s3
    80001928:	854a                	mv	a0,s2
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	8ac080e7          	jalr	-1876(ra) # 800001d6 <memmove>
    return 0;
    80001932:	8526                	mv	a0,s1
    80001934:	bff9                	j	80001912 <either_copyout+0x32>

0000000080001936 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001936:	7179                	addi	sp,sp,-48
    80001938:	f406                	sd	ra,40(sp)
    8000193a:	f022                	sd	s0,32(sp)
    8000193c:	ec26                	sd	s1,24(sp)
    8000193e:	e84a                	sd	s2,16(sp)
    80001940:	e44e                	sd	s3,8(sp)
    80001942:	e052                	sd	s4,0(sp)
    80001944:	1800                	addi	s0,sp,48
    80001946:	892a                	mv	s2,a0
    80001948:	84ae                	mv	s1,a1
    8000194a:	89b2                	mv	s3,a2
    8000194c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	52e080e7          	jalr	1326(ra) # 80000e7c <myproc>
  if(user_src){
    80001956:	c08d                	beqz	s1,80001978 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001958:	86d2                	mv	a3,s4
    8000195a:	864e                	mv	a2,s3
    8000195c:	85ca                	mv	a1,s2
    8000195e:	6928                	ld	a0,80(a0)
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	244080e7          	jalr	580(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001968:	70a2                	ld	ra,40(sp)
    8000196a:	7402                	ld	s0,32(sp)
    8000196c:	64e2                	ld	s1,24(sp)
    8000196e:	6942                	ld	s2,16(sp)
    80001970:	69a2                	ld	s3,8(sp)
    80001972:	6a02                	ld	s4,0(sp)
    80001974:	6145                	addi	sp,sp,48
    80001976:	8082                	ret
    memmove(dst, (char*)src, len);
    80001978:	000a061b          	sext.w	a2,s4
    8000197c:	85ce                	mv	a1,s3
    8000197e:	854a                	mv	a0,s2
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	856080e7          	jalr	-1962(ra) # 800001d6 <memmove>
    return 0;
    80001988:	8526                	mv	a0,s1
    8000198a:	bff9                	j	80001968 <either_copyin+0x32>

000000008000198c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000198c:	715d                	addi	sp,sp,-80
    8000198e:	e486                	sd	ra,72(sp)
    80001990:	e0a2                	sd	s0,64(sp)
    80001992:	fc26                	sd	s1,56(sp)
    80001994:	f84a                	sd	s2,48(sp)
    80001996:	f44e                	sd	s3,40(sp)
    80001998:	f052                	sd	s4,32(sp)
    8000199a:	ec56                	sd	s5,24(sp)
    8000199c:	e85a                	sd	s6,16(sp)
    8000199e:	e45e                	sd	s7,8(sp)
    800019a0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a2:	00006517          	auipc	a0,0x6
    800019a6:	67650513          	addi	a0,a0,1654 # 80008018 <etext+0x18>
    800019aa:	00004097          	auipc	ra,0x4
    800019ae:	5cc080e7          	jalr	1484(ra) # 80005f76 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b2:	0000b497          	auipc	s1,0xb
    800019b6:	c2648493          	addi	s1,s1,-986 # 8000c5d8 <proc+0x158>
    800019ba:	0000c917          	auipc	s2,0xc
    800019be:	a2e90913          	addi	s2,s2,-1490 # 8000d3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019c4:	00007997          	auipc	s3,0x7
    800019c8:	83c98993          	addi	s3,s3,-1988 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019cc:	00007a97          	auipc	s5,0x7
    800019d0:	83ca8a93          	addi	s5,s5,-1988 # 80008208 <etext+0x208>
    printf("\n");
    800019d4:	00006a17          	auipc	s4,0x6
    800019d8:	644a0a13          	addi	s4,s4,1604 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	00007b97          	auipc	s7,0x7
    800019e0:	d24b8b93          	addi	s7,s7,-732 # 80008700 <states.0>
    800019e4:	a00d                	j	80001a06 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	ed86a583          	lw	a1,-296(a3)
    800019ea:	8556                	mv	a0,s5
    800019ec:	00004097          	auipc	ra,0x4
    800019f0:	58a080e7          	jalr	1418(ra) # 80005f76 <printf>
    printf("\n");
    800019f4:	8552                	mv	a0,s4
    800019f6:	00004097          	auipc	ra,0x4
    800019fa:	580080e7          	jalr	1408(ra) # 80005f76 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fe:	16848493          	addi	s1,s1,360
    80001a02:	03248263          	beq	s1,s2,80001a26 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a06:	86a6                	mv	a3,s1
    80001a08:	ec04a783          	lw	a5,-320(s1)
    80001a0c:	dbed                	beqz	a5,800019fe <procdump+0x72>
      state = "???";
    80001a0e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a10:	fcfb6be3          	bltu	s6,a5,800019e6 <procdump+0x5a>
    80001a14:	02079713          	slli	a4,a5,0x20
    80001a18:	01d75793          	srli	a5,a4,0x1d
    80001a1c:	97de                	add	a5,a5,s7
    80001a1e:	6390                	ld	a2,0(a5)
    80001a20:	f279                	bnez	a2,800019e6 <procdump+0x5a>
      state = "???";
    80001a22:	864e                	mv	a2,s3
    80001a24:	b7c9                	j	800019e6 <procdump+0x5a>
  }
}
    80001a26:	60a6                	ld	ra,72(sp)
    80001a28:	6406                	ld	s0,64(sp)
    80001a2a:	74e2                	ld	s1,56(sp)
    80001a2c:	7942                	ld	s2,48(sp)
    80001a2e:	79a2                	ld	s3,40(sp)
    80001a30:	7a02                	ld	s4,32(sp)
    80001a32:	6ae2                	ld	s5,24(sp)
    80001a34:	6b42                	ld	s6,16(sp)
    80001a36:	6ba2                	ld	s7,8(sp)
    80001a38:	6161                	addi	sp,sp,80
    80001a3a:	8082                	ret

0000000080001a3c <swtch>:
    80001a3c:	00153023          	sd	ra,0(a0)
    80001a40:	00253423          	sd	sp,8(a0)
    80001a44:	e900                	sd	s0,16(a0)
    80001a46:	ed04                	sd	s1,24(a0)
    80001a48:	03253023          	sd	s2,32(a0)
    80001a4c:	03353423          	sd	s3,40(a0)
    80001a50:	03453823          	sd	s4,48(a0)
    80001a54:	03553c23          	sd	s5,56(a0)
    80001a58:	05653023          	sd	s6,64(a0)
    80001a5c:	05753423          	sd	s7,72(a0)
    80001a60:	05853823          	sd	s8,80(a0)
    80001a64:	05953c23          	sd	s9,88(a0)
    80001a68:	07a53023          	sd	s10,96(a0)
    80001a6c:	07b53423          	sd	s11,104(a0)
    80001a70:	0005b083          	ld	ra,0(a1)
    80001a74:	0085b103          	ld	sp,8(a1)
    80001a78:	6980                	ld	s0,16(a1)
    80001a7a:	6d84                	ld	s1,24(a1)
    80001a7c:	0205b903          	ld	s2,32(a1)
    80001a80:	0285b983          	ld	s3,40(a1)
    80001a84:	0305ba03          	ld	s4,48(a1)
    80001a88:	0385ba83          	ld	s5,56(a1)
    80001a8c:	0405bb03          	ld	s6,64(a1)
    80001a90:	0485bb83          	ld	s7,72(a1)
    80001a94:	0505bc03          	ld	s8,80(a1)
    80001a98:	0585bc83          	ld	s9,88(a1)
    80001a9c:	0605bd03          	ld	s10,96(a1)
    80001aa0:	0685bd83          	ld	s11,104(a1)
    80001aa4:	8082                	ret

0000000080001aa6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aa6:	1141                	addi	sp,sp,-16
    80001aa8:	e406                	sd	ra,8(sp)
    80001aaa:	e022                	sd	s0,0(sp)
    80001aac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aae:	00006597          	auipc	a1,0x6
    80001ab2:	79258593          	addi	a1,a1,1938 # 80008240 <etext+0x240>
    80001ab6:	0000b517          	auipc	a0,0xb
    80001aba:	7da50513          	addi	a0,a0,2010 # 8000d290 <tickslock>
    80001abe:	00005097          	auipc	ra,0x5
    80001ac2:	958080e7          	jalr	-1704(ra) # 80006416 <initlock>
}
    80001ac6:	60a2                	ld	ra,8(sp)
    80001ac8:	6402                	ld	s0,0(sp)
    80001aca:	0141                	addi	sp,sp,16
    80001acc:	8082                	ret

0000000080001ace <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ace:	1141                	addi	sp,sp,-16
    80001ad0:	e422                	sd	s0,8(sp)
    80001ad2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ad4:	00004797          	auipc	a5,0x4
    80001ad8:	86c78793          	addi	a5,a5,-1940 # 80005340 <kernelvec>
    80001adc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae0:	6422                	ld	s0,8(sp)
    80001ae2:	0141                	addi	sp,sp,16
    80001ae4:	8082                	ret

0000000080001ae6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e406                	sd	ra,8(sp)
    80001aea:	e022                	sd	s0,0(sp)
    80001aec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	38e080e7          	jalr	910(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001afa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001afc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b00:	00005697          	auipc	a3,0x5
    80001b04:	50068693          	addi	a3,a3,1280 # 80007000 <_trampoline>
    80001b08:	00005717          	auipc	a4,0x5
    80001b0c:	4f870713          	addi	a4,a4,1272 # 80007000 <_trampoline>
    80001b10:	8f15                	sub	a4,a4,a3
    80001b12:	040007b7          	lui	a5,0x4000
    80001b16:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b18:	07b2                	slli	a5,a5,0xc
    80001b1a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b1c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b20:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b22:	18002673          	csrr	a2,satp
    80001b26:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b28:	6d30                	ld	a2,88(a0)
    80001b2a:	6138                	ld	a4,64(a0)
    80001b2c:	6585                	lui	a1,0x1
    80001b2e:	972e                	add	a4,a4,a1
    80001b30:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b32:	6d38                	ld	a4,88(a0)
    80001b34:	00000617          	auipc	a2,0x0
    80001b38:	14060613          	addi	a2,a2,320 # 80001c74 <usertrap>
    80001b3c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b3e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b40:	8612                	mv	a2,tp
    80001b42:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b44:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b48:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b4c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b50:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b54:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b56:	6f18                	ld	a4,24(a4)
    80001b58:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b5c:	692c                	ld	a1,80(a0)
    80001b5e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b60:	00005717          	auipc	a4,0x5
    80001b64:	53070713          	addi	a4,a4,1328 # 80007090 <userret>
    80001b68:	8f15                	sub	a4,a4,a3
    80001b6a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b6c:	577d                	li	a4,-1
    80001b6e:	177e                	slli	a4,a4,0x3f
    80001b70:	8dd9                	or	a1,a1,a4
    80001b72:	02000537          	lui	a0,0x2000
    80001b76:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b78:	0536                	slli	a0,a0,0xd
    80001b7a:	9782                	jalr	a5
}
    80001b7c:	60a2                	ld	ra,8(sp)
    80001b7e:	6402                	ld	s0,0(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8e:	0000b497          	auipc	s1,0xb
    80001b92:	70248493          	addi	s1,s1,1794 # 8000d290 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00005097          	auipc	ra,0x5
    80001b9c:	90e080e7          	jalr	-1778(ra) # 800064a6 <acquire>
  ticks++;
    80001ba0:	0000a517          	auipc	a0,0xa
    80001ba4:	47850513          	addi	a0,a0,1144 # 8000c018 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	b20080e7          	jalr	-1248(ra) # 800016ce <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00005097          	auipc	ra,0x5
    80001bbc:	9a2080e7          	jalr	-1630(ra) # 8000655a <release>
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bca:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bce:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bd0:	0a07d163          	bgez	a5,80001c72 <devintr+0xa8>
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bdc:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001be0:	46a5                	li	a3,9
    80001be2:	00d70c63          	beq	a4,a3,80001bfa <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001be6:	577d                	li	a4,-1
    80001be8:	177e                	slli	a4,a4,0x3f
    80001bea:	0705                	addi	a4,a4,1
    return 0;
    80001bec:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bee:	06e78163          	beq	a5,a4,80001c50 <devintr+0x86>
  }
}
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	6105                	addi	sp,sp,32
    80001bf8:	8082                	ret
    80001bfa:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	850080e7          	jalr	-1968(ra) # 8000544c <plic_claim>
    80001c04:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c06:	47a9                	li	a5,10
    80001c08:	00f50963          	beq	a0,a5,80001c1a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c0c:	4785                	li	a5,1
    80001c0e:	00f50b63          	beq	a0,a5,80001c24 <devintr+0x5a>
    return 1;
    80001c12:	4505                	li	a0,1
    } else if(irq){
    80001c14:	ec89                	bnez	s1,80001c2e <devintr+0x64>
    80001c16:	64a2                	ld	s1,8(sp)
    80001c18:	bfe9                	j	80001bf2 <devintr+0x28>
      uartintr();
    80001c1a:	00004097          	auipc	ra,0x4
    80001c1e:	7ac080e7          	jalr	1964(ra) # 800063c6 <uartintr>
    if(irq)
    80001c22:	a839                	j	80001c40 <devintr+0x76>
      virtio_disk_intr();
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	cfc080e7          	jalr	-772(ra) # 80005920 <virtio_disk_intr>
    if(irq)
    80001c2c:	a811                	j	80001c40 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2e:	85a6                	mv	a1,s1
    80001c30:	00006517          	auipc	a0,0x6
    80001c34:	61850513          	addi	a0,a0,1560 # 80008248 <etext+0x248>
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	33e080e7          	jalr	830(ra) # 80005f76 <printf>
      plic_complete(irq);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	82e080e7          	jalr	-2002(ra) # 80005470 <plic_complete>
    return 1;
    80001c4a:	4505                	li	a0,1
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	b755                	j	80001bf2 <devintr+0x28>
    if(cpuid() == 0){
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	200080e7          	jalr	512(ra) # 80000e50 <cpuid>
    80001c58:	c901                	beqz	a0,80001c68 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c60:	14479073          	csrw	sip,a5
    return 2;
    80001c64:	4509                	li	a0,2
    80001c66:	b771                	j	80001bf2 <devintr+0x28>
      clockintr();
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	f1c080e7          	jalr	-228(ra) # 80001b84 <clockintr>
    80001c70:	b7ed                	j	80001c5a <devintr+0x90>
}
    80001c72:	8082                	ret

0000000080001c74 <usertrap>:
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	e04a                	sd	s2,0(sp)
    80001c7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c80:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c84:	1007f793          	andi	a5,a5,256
    80001c88:	e3ad                	bnez	a5,80001cea <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8a:	00003797          	auipc	a5,0x3
    80001c8e:	6b678793          	addi	a5,a5,1718 # 80005340 <kernelvec>
    80001c92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	1e6080e7          	jalr	486(ra) # 80000e7c <myproc>
    80001c9e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ca0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ca2:	14102773          	csrr	a4,sepc
    80001ca6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cac:	47a1                	li	a5,8
    80001cae:	04f71c63          	bne	a4,a5,80001d06 <usertrap+0x92>
    if(p->killed)
    80001cb2:	551c                	lw	a5,40(a0)
    80001cb4:	e3b9                	bnez	a5,80001cfa <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cb6:	6cb8                	ld	a4,88(s1)
    80001cb8:	6f1c                	ld	a5,24(a4)
    80001cba:	0791                	addi	a5,a5,4
    80001cbc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cc2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc6:	10079073          	csrw	sstatus,a5
    syscall();
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	2e0080e7          	jalr	736(ra) # 80001faa <syscall>
  if(p->killed)
    80001cd2:	549c                	lw	a5,40(s1)
    80001cd4:	ebc1                	bnez	a5,80001d64 <usertrap+0xf0>
  usertrapret();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	e10080e7          	jalr	-496(ra) # 80001ae6 <usertrapret>
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6902                	ld	s2,0(sp)
    80001ce6:	6105                	addi	sp,sp,32
    80001ce8:	8082                	ret
    panic("usertrap: not from user mode");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	57e50513          	addi	a0,a0,1406 # 80008268 <etext+0x268>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	23a080e7          	jalr	570(ra) # 80005f2c <panic>
      exit(-1);
    80001cfa:	557d                	li	a0,-1
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	a9c080e7          	jalr	-1380(ra) # 80001798 <exit>
    80001d04:	bf4d                	j	80001cb6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	ec4080e7          	jalr	-316(ra) # 80001bca <devintr>
    80001d0e:	892a                	mv	s2,a0
    80001d10:	c501                	beqz	a0,80001d18 <usertrap+0xa4>
  if(p->killed)
    80001d12:	549c                	lw	a5,40(s1)
    80001d14:	c3a1                	beqz	a5,80001d54 <usertrap+0xe0>
    80001d16:	a815                	j	80001d4a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d18:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d1c:	5890                	lw	a2,48(s1)
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	56a50513          	addi	a0,a0,1386 # 80008288 <etext+0x288>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	250080e7          	jalr	592(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d32:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	58250513          	addi	a0,a0,1410 # 800082b8 <etext+0x2b8>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	238080e7          	jalr	568(ra) # 80005f76 <printf>
    p->killed = 1;
    80001d46:	4785                	li	a5,1
    80001d48:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d4a:	557d                	li	a0,-1
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	a4c080e7          	jalr	-1460(ra) # 80001798 <exit>
  if(which_dev == 2)
    80001d54:	4789                	li	a5,2
    80001d56:	f8f910e3          	bne	s2,a5,80001cd6 <usertrap+0x62>
    yield();
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	7ac080e7          	jalr	1964(ra) # 80001506 <yield>
    80001d62:	bf95                	j	80001cd6 <usertrap+0x62>
  int which_dev = 0;
    80001d64:	4901                	li	s2,0
    80001d66:	b7d5                	j	80001d4a <usertrap+0xd6>

0000000080001d68 <kerneltrap>:
{
    80001d68:	7179                	addi	sp,sp,-48
    80001d6a:	f406                	sd	ra,40(sp)
    80001d6c:	f022                	sd	s0,32(sp)
    80001d6e:	ec26                	sd	s1,24(sp)
    80001d70:	e84a                	sd	s2,16(sp)
    80001d72:	e44e                	sd	s3,8(sp)
    80001d74:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d76:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d82:	1004f793          	andi	a5,s1,256
    80001d86:	cb85                	beqz	a5,80001db6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d8c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d8e:	ef85                	bnez	a5,80001dc6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	e3a080e7          	jalr	-454(ra) # 80001bca <devintr>
    80001d98:	cd1d                	beqz	a0,80001dd6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d9a:	4789                	li	a5,2
    80001d9c:	06f50a63          	beq	a0,a5,80001e10 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da4:	10049073          	csrw	sstatus,s1
}
    80001da8:	70a2                	ld	ra,40(sp)
    80001daa:	7402                	ld	s0,32(sp)
    80001dac:	64e2                	ld	s1,24(sp)
    80001dae:	6942                	ld	s2,16(sp)
    80001db0:	69a2                	ld	s3,8(sp)
    80001db2:	6145                	addi	sp,sp,48
    80001db4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001db6:	00006517          	auipc	a0,0x6
    80001dba:	52250513          	addi	a0,a0,1314 # 800082d8 <etext+0x2d8>
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	16e080e7          	jalr	366(ra) # 80005f2c <panic>
    panic("kerneltrap: interrupts enabled");
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	53a50513          	addi	a0,a0,1338 # 80008300 <etext+0x300>
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	15e080e7          	jalr	350(ra) # 80005f2c <panic>
    printf("scause %p\n", scause);
    80001dd6:	85ce                	mv	a1,s3
    80001dd8:	00006517          	auipc	a0,0x6
    80001ddc:	54850513          	addi	a0,a0,1352 # 80008320 <etext+0x320>
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	196080e7          	jalr	406(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dec:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	54050513          	addi	a0,a0,1344 # 80008330 <etext+0x330>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	17e080e7          	jalr	382(ra) # 80005f76 <printf>
    panic("kerneltrap");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	54850513          	addi	a0,a0,1352 # 80008348 <etext+0x348>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	124080e7          	jalr	292(ra) # 80005f2c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	06c080e7          	jalr	108(ra) # 80000e7c <myproc>
    80001e18:	d541                	beqz	a0,80001da0 <kerneltrap+0x38>
    80001e1a:	fffff097          	auipc	ra,0xfffff
    80001e1e:	062080e7          	jalr	98(ra) # 80000e7c <myproc>
    80001e22:	4d18                	lw	a4,24(a0)
    80001e24:	4791                	li	a5,4
    80001e26:	f6f71de3          	bne	a4,a5,80001da0 <kerneltrap+0x38>
    yield();
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	6dc080e7          	jalr	1756(ra) # 80001506 <yield>
    80001e32:	b7bd                	j	80001da0 <kerneltrap+0x38>

0000000080001e34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e34:	1101                	addi	sp,sp,-32
    80001e36:	ec06                	sd	ra,24(sp)
    80001e38:	e822                	sd	s0,16(sp)
    80001e3a:	e426                	sd	s1,8(sp)
    80001e3c:	1000                	addi	s0,sp,32
    80001e3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	03c080e7          	jalr	60(ra) # 80000e7c <myproc>
  switch (n) {
    80001e48:	4795                	li	a5,5
    80001e4a:	0497e163          	bltu	a5,s1,80001e8c <argraw+0x58>
    80001e4e:	048a                	slli	s1,s1,0x2
    80001e50:	00007717          	auipc	a4,0x7
    80001e54:	8e070713          	addi	a4,a4,-1824 # 80008730 <states.0+0x30>
    80001e58:	94ba                	add	s1,s1,a4
    80001e5a:	409c                	lw	a5,0(s1)
    80001e5c:	97ba                	add	a5,a5,a4
    80001e5e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e60:	6d3c                	ld	a5,88(a0)
    80001e62:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e64:	60e2                	ld	ra,24(sp)
    80001e66:	6442                	ld	s0,16(sp)
    80001e68:	64a2                	ld	s1,8(sp)
    80001e6a:	6105                	addi	sp,sp,32
    80001e6c:	8082                	ret
    return p->trapframe->a1;
    80001e6e:	6d3c                	ld	a5,88(a0)
    80001e70:	7fa8                	ld	a0,120(a5)
    80001e72:	bfcd                	j	80001e64 <argraw+0x30>
    return p->trapframe->a2;
    80001e74:	6d3c                	ld	a5,88(a0)
    80001e76:	63c8                	ld	a0,128(a5)
    80001e78:	b7f5                	j	80001e64 <argraw+0x30>
    return p->trapframe->a3;
    80001e7a:	6d3c                	ld	a5,88(a0)
    80001e7c:	67c8                	ld	a0,136(a5)
    80001e7e:	b7dd                	j	80001e64 <argraw+0x30>
    return p->trapframe->a4;
    80001e80:	6d3c                	ld	a5,88(a0)
    80001e82:	6bc8                	ld	a0,144(a5)
    80001e84:	b7c5                	j	80001e64 <argraw+0x30>
    return p->trapframe->a5;
    80001e86:	6d3c                	ld	a5,88(a0)
    80001e88:	6fc8                	ld	a0,152(a5)
    80001e8a:	bfe9                	j	80001e64 <argraw+0x30>
  panic("argraw");
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	4cc50513          	addi	a0,a0,1228 # 80008358 <etext+0x358>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	098080e7          	jalr	152(ra) # 80005f2c <panic>

0000000080001e9c <fetchaddr>:
{
    80001e9c:	1101                	addi	sp,sp,-32
    80001e9e:	ec06                	sd	ra,24(sp)
    80001ea0:	e822                	sd	s0,16(sp)
    80001ea2:	e426                	sd	s1,8(sp)
    80001ea4:	e04a                	sd	s2,0(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	84aa                	mv	s1,a0
    80001eaa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	fd0080e7          	jalr	-48(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001eb4:	653c                	ld	a5,72(a0)
    80001eb6:	02f4f863          	bgeu	s1,a5,80001ee6 <fetchaddr+0x4a>
    80001eba:	00848713          	addi	a4,s1,8
    80001ebe:	02e7e663          	bltu	a5,a4,80001eea <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ec2:	46a1                	li	a3,8
    80001ec4:	8626                	mv	a2,s1
    80001ec6:	85ca                	mv	a1,s2
    80001ec8:	6928                	ld	a0,80(a0)
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	cda080e7          	jalr	-806(ra) # 80000ba4 <copyin>
    80001ed2:	00a03533          	snez	a0,a0
    80001ed6:	40a00533          	neg	a0,a0
}
    80001eda:	60e2                	ld	ra,24(sp)
    80001edc:	6442                	ld	s0,16(sp)
    80001ede:	64a2                	ld	s1,8(sp)
    80001ee0:	6902                	ld	s2,0(sp)
    80001ee2:	6105                	addi	sp,sp,32
    80001ee4:	8082                	ret
    return -1;
    80001ee6:	557d                	li	a0,-1
    80001ee8:	bfcd                	j	80001eda <fetchaddr+0x3e>
    80001eea:	557d                	li	a0,-1
    80001eec:	b7fd                	j	80001eda <fetchaddr+0x3e>

0000000080001eee <fetchstr>:
{
    80001eee:	7179                	addi	sp,sp,-48
    80001ef0:	f406                	sd	ra,40(sp)
    80001ef2:	f022                	sd	s0,32(sp)
    80001ef4:	ec26                	sd	s1,24(sp)
    80001ef6:	e84a                	sd	s2,16(sp)
    80001ef8:	e44e                	sd	s3,8(sp)
    80001efa:	1800                	addi	s0,sp,48
    80001efc:	892a                	mv	s2,a0
    80001efe:	84ae                	mv	s1,a1
    80001f00:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f7a080e7          	jalr	-134(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f0a:	86ce                	mv	a3,s3
    80001f0c:	864a                	mv	a2,s2
    80001f0e:	85a6                	mv	a1,s1
    80001f10:	6928                	ld	a0,80(a0)
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	d20080e7          	jalr	-736(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f1a:	00054763          	bltz	a0,80001f28 <fetchstr+0x3a>
  return strlen(buf);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	ffffe097          	auipc	ra,0xffffe
    80001f24:	3ce080e7          	jalr	974(ra) # 800002ee <strlen>
}
    80001f28:	70a2                	ld	ra,40(sp)
    80001f2a:	7402                	ld	s0,32(sp)
    80001f2c:	64e2                	ld	s1,24(sp)
    80001f2e:	6942                	ld	s2,16(sp)
    80001f30:	69a2                	ld	s3,8(sp)
    80001f32:	6145                	addi	sp,sp,48
    80001f34:	8082                	ret

0000000080001f36 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	e426                	sd	s1,8(sp)
    80001f3e:	1000                	addi	s0,sp,32
    80001f40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	ef2080e7          	jalr	-270(ra) # 80001e34 <argraw>
    80001f4a:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f4c:	4501                	li	a0,0
    80001f4e:	60e2                	ld	ra,24(sp)
    80001f50:	6442                	ld	s0,16(sp)
    80001f52:	64a2                	ld	s1,8(sp)
    80001f54:	6105                	addi	sp,sp,32
    80001f56:	8082                	ret

0000000080001f58 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f58:	1101                	addi	sp,sp,-32
    80001f5a:	ec06                	sd	ra,24(sp)
    80001f5c:	e822                	sd	s0,16(sp)
    80001f5e:	e426                	sd	s1,8(sp)
    80001f60:	1000                	addi	s0,sp,32
    80001f62:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	ed0080e7          	jalr	-304(ra) # 80001e34 <argraw>
    80001f6c:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f6e:	4501                	li	a0,0
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret

0000000080001f7a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	e04a                	sd	s2,0(sp)
    80001f84:	1000                	addi	s0,sp,32
    80001f86:	84ae                	mv	s1,a1
    80001f88:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	eaa080e7          	jalr	-342(ra) # 80001e34 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f92:	864a                	mv	a2,s2
    80001f94:	85a6                	mv	a1,s1
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	f58080e7          	jalr	-168(ra) # 80001eee <fetchstr>
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6902                	ld	s2,0(sp)
    80001fa6:	6105                	addi	sp,sp,32
    80001fa8:	8082                	ret

0000000080001faa <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	e04a                	sd	s2,0(sp)
    80001fb4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	ec6080e7          	jalr	-314(ra) # 80000e7c <myproc>
    80001fbe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fc0:	05853903          	ld	s2,88(a0)
    80001fc4:	0a893783          	ld	a5,168(s2)
    80001fc8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fcc:	37fd                	addiw	a5,a5,-1
    80001fce:	4755                	li	a4,21
    80001fd0:	00f76f63          	bltu	a4,a5,80001fee <syscall+0x44>
    80001fd4:	00369713          	slli	a4,a3,0x3
    80001fd8:	00006797          	auipc	a5,0x6
    80001fdc:	77078793          	addi	a5,a5,1904 # 80008748 <syscalls>
    80001fe0:	97ba                	add	a5,a5,a4
    80001fe2:	639c                	ld	a5,0(a5)
    80001fe4:	c789                	beqz	a5,80001fee <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fe6:	9782                	jalr	a5
    80001fe8:	06a93823          	sd	a0,112(s2)
    80001fec:	a839                	j	8000200a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fee:	15848613          	addi	a2,s1,344
    80001ff2:	588c                	lw	a1,48(s1)
    80001ff4:	00006517          	auipc	a0,0x6
    80001ff8:	36c50513          	addi	a0,a0,876 # 80008360 <etext+0x360>
    80001ffc:	00004097          	auipc	ra,0x4
    80002000:	f7a080e7          	jalr	-134(ra) # 80005f76 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002004:	6cbc                	ld	a5,88(s1)
    80002006:	577d                	li	a4,-1
    80002008:	fbb8                	sd	a4,112(a5)
  }
}
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6902                	ld	s2,0(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000201e:	fec40593          	addi	a1,s0,-20
    80002022:	4501                	li	a0,0
    80002024:	00000097          	auipc	ra,0x0
    80002028:	f12080e7          	jalr	-238(ra) # 80001f36 <argint>
    return -1;
    8000202c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000202e:	00054963          	bltz	a0,80002040 <sys_exit+0x2a>
  exit(n);
    80002032:	fec42503          	lw	a0,-20(s0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	762080e7          	jalr	1890(ra) # 80001798 <exit>
  return 0;  // not reached
    8000203e:	4781                	li	a5,0
}
    80002040:	853e                	mv	a0,a5
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000204a:	1141                	addi	sp,sp,-16
    8000204c:	e406                	sd	ra,8(sp)
    8000204e:	e022                	sd	s0,0(sp)
    80002050:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	e2a080e7          	jalr	-470(ra) # 80000e7c <myproc>
}
    8000205a:	5908                	lw	a0,48(a0)
    8000205c:	60a2                	ld	ra,8(sp)
    8000205e:	6402                	ld	s0,0(sp)
    80002060:	0141                	addi	sp,sp,16
    80002062:	8082                	ret

0000000080002064 <sys_fork>:

uint64
sys_fork(void)
{
    80002064:	1141                	addi	sp,sp,-16
    80002066:	e406                	sd	ra,8(sp)
    80002068:	e022                	sd	s0,0(sp)
    8000206a:	0800                	addi	s0,sp,16
  return fork();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	1e2080e7          	jalr	482(ra) # 8000124e <fork>
}
    80002074:	60a2                	ld	ra,8(sp)
    80002076:	6402                	ld	s0,0(sp)
    80002078:	0141                	addi	sp,sp,16
    8000207a:	8082                	ret

000000008000207c <sys_wait>:

uint64
sys_wait(void)
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002084:	fe840593          	addi	a1,s0,-24
    80002088:	4501                	li	a0,0
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	ece080e7          	jalr	-306(ra) # 80001f58 <argaddr>
    80002092:	87aa                	mv	a5,a0
    return -1;
    80002094:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002096:	0007c863          	bltz	a5,800020a6 <sys_wait+0x2a>
  return wait(p);
    8000209a:	fe843503          	ld	a0,-24(s0)
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	508080e7          	jalr	1288(ra) # 800015a6 <wait>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020b6:	fdc40593          	addi	a1,s0,-36
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	e7a080e7          	jalr	-390(ra) # 80001f36 <argint>
    800020c4:	87aa                	mv	a5,a0
    return -1;
    800020c6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020c8:	0207c263          	bltz	a5,800020ec <sys_sbrk+0x3e>
    800020cc:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	dae080e7          	jalr	-594(ra) # 80000e7c <myproc>
    800020d6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020d8:	fdc42503          	lw	a0,-36(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	0fa080e7          	jalr	250(ra) # 800011d6 <growproc>
    800020e4:	00054863          	bltz	a0,800020f4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020e8:	8526                	mv	a0,s1
    800020ea:	64e2                	ld	s1,24(sp)
}
    800020ec:	70a2                	ld	ra,40(sp)
    800020ee:	7402                	ld	s0,32(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret
    return -1;
    800020f4:	557d                	li	a0,-1
    800020f6:	64e2                	ld	s1,24(sp)
    800020f8:	bfd5                	j	800020ec <sys_sbrk+0x3e>

00000000800020fa <sys_sleep>:

uint64
sys_sleep(void)
{
    800020fa:	7139                	addi	sp,sp,-64
    800020fc:	fc06                	sd	ra,56(sp)
    800020fe:	f822                	sd	s0,48(sp)
    80002100:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002102:	fcc40593          	addi	a1,s0,-52
    80002106:	4501                	li	a0,0
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	e2e080e7          	jalr	-466(ra) # 80001f36 <argint>
    return -1;
    80002110:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002112:	06054b63          	bltz	a0,80002188 <sys_sleep+0x8e>
    80002116:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002118:	0000b517          	auipc	a0,0xb
    8000211c:	17850513          	addi	a0,a0,376 # 8000d290 <tickslock>
    80002120:	00004097          	auipc	ra,0x4
    80002124:	386080e7          	jalr	902(ra) # 800064a6 <acquire>
  ticks0 = ticks;
    80002128:	0000a917          	auipc	s2,0xa
    8000212c:	ef092903          	lw	s2,-272(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	c3a1                	beqz	a5,80002174 <sys_sleep+0x7a>
    80002136:	f426                	sd	s1,40(sp)
    80002138:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000213a:	0000b997          	auipc	s3,0xb
    8000213e:	15698993          	addi	s3,s3,342 # 8000d290 <tickslock>
    80002142:	0000a497          	auipc	s1,0xa
    80002146:	ed648493          	addi	s1,s1,-298 # 8000c018 <ticks>
    if(myproc()->killed){
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	d32080e7          	jalr	-718(ra) # 80000e7c <myproc>
    80002152:	551c                	lw	a5,40(a0)
    80002154:	ef9d                	bnez	a5,80002192 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002156:	85ce                	mv	a1,s3
    80002158:	8526                	mv	a0,s1
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	3e8080e7          	jalr	1000(ra) # 80001542 <sleep>
  while(ticks - ticks0 < n){
    80002162:	409c                	lw	a5,0(s1)
    80002164:	412787bb          	subw	a5,a5,s2
    80002168:	fcc42703          	lw	a4,-52(s0)
    8000216c:	fce7efe3          	bltu	a5,a4,8000214a <sys_sleep+0x50>
    80002170:	74a2                	ld	s1,40(sp)
    80002172:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002174:	0000b517          	auipc	a0,0xb
    80002178:	11c50513          	addi	a0,a0,284 # 8000d290 <tickslock>
    8000217c:	00004097          	auipc	ra,0x4
    80002180:	3de080e7          	jalr	990(ra) # 8000655a <release>
  return 0;
    80002184:	4781                	li	a5,0
    80002186:	7902                	ld	s2,32(sp)
}
    80002188:	853e                	mv	a0,a5
    8000218a:	70e2                	ld	ra,56(sp)
    8000218c:	7442                	ld	s0,48(sp)
    8000218e:	6121                	addi	sp,sp,64
    80002190:	8082                	ret
      release(&tickslock);
    80002192:	0000b517          	auipc	a0,0xb
    80002196:	0fe50513          	addi	a0,a0,254 # 8000d290 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	3c0080e7          	jalr	960(ra) # 8000655a <release>
      return -1;
    800021a2:	57fd                	li	a5,-1
    800021a4:	74a2                	ld	s1,40(sp)
    800021a6:	7902                	ld	s2,32(sp)
    800021a8:	69e2                	ld	s3,24(sp)
    800021aa:	bff9                	j	80002188 <sys_sleep+0x8e>

00000000800021ac <sys_kill>:

uint64
sys_kill(void)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021b4:	fec40593          	addi	a1,s0,-20
    800021b8:	4501                	li	a0,0
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	d7c080e7          	jalr	-644(ra) # 80001f36 <argint>
    800021c2:	87aa                	mv	a5,a0
    return -1;
    800021c4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021c6:	0007c863          	bltz	a5,800021d6 <sys_kill+0x2a>
  return kill(pid);
    800021ca:	fec42503          	lw	a0,-20(s0)
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	6a0080e7          	jalr	1696(ra) # 8000186e <kill>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	e426                	sd	s1,8(sp)
    800021e6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021e8:	0000b517          	auipc	a0,0xb
    800021ec:	0a850513          	addi	a0,a0,168 # 8000d290 <tickslock>
    800021f0:	00004097          	auipc	ra,0x4
    800021f4:	2b6080e7          	jalr	694(ra) # 800064a6 <acquire>
  xticks = ticks;
    800021f8:	0000a497          	auipc	s1,0xa
    800021fc:	e204a483          	lw	s1,-480(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002200:	0000b517          	auipc	a0,0xb
    80002204:	09050513          	addi	a0,a0,144 # 8000d290 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	352080e7          	jalr	850(ra) # 8000655a <release>
  return xticks;
}
    80002210:	02049513          	slli	a0,s1,0x20
    80002214:	9101                	srli	a0,a0,0x20
    80002216:	60e2                	ld	ra,24(sp)
    80002218:	6442                	ld	s0,16(sp)
    8000221a:	64a2                	ld	s1,8(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002220:	7179                	addi	sp,sp,-48
    80002222:	f406                	sd	ra,40(sp)
    80002224:	f022                	sd	s0,32(sp)
    80002226:	ec26                	sd	s1,24(sp)
    80002228:	e84a                	sd	s2,16(sp)
    8000222a:	e44e                	sd	s3,8(sp)
    8000222c:	e052                	sd	s4,0(sp)
    8000222e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002230:	00006597          	auipc	a1,0x6
    80002234:	15058593          	addi	a1,a1,336 # 80008380 <etext+0x380>
    80002238:	0000b517          	auipc	a0,0xb
    8000223c:	07050513          	addi	a0,a0,112 # 8000d2a8 <bcache>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	1d6080e7          	jalr	470(ra) # 80006416 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002248:	00013797          	auipc	a5,0x13
    8000224c:	06078793          	addi	a5,a5,96 # 800152a8 <bcache+0x8000>
    80002250:	00013717          	auipc	a4,0x13
    80002254:	2c070713          	addi	a4,a4,704 # 80015510 <bcache+0x8268>
    80002258:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000225c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002260:	0000b497          	auipc	s1,0xb
    80002264:	06048493          	addi	s1,s1,96 # 8000d2c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002268:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000226a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000226c:	00006a17          	auipc	s4,0x6
    80002270:	11ca0a13          	addi	s4,s4,284 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002274:	2b893783          	ld	a5,696(s2)
    80002278:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000227a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000227e:	85d2                	mv	a1,s4
    80002280:	01048513          	addi	a0,s1,16
    80002284:	00001097          	auipc	ra,0x1
    80002288:	62c080e7          	jalr	1580(ra) # 800038b0 <initsleeplock>
    bcache.head.next->prev = b;
    8000228c:	2b893783          	ld	a5,696(s2)
    80002290:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002292:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002296:	45848493          	addi	s1,s1,1112
    8000229a:	fd349de3          	bne	s1,s3,80002274 <binit+0x54>
  }
}
    8000229e:	70a2                	ld	ra,40(sp)
    800022a0:	7402                	ld	s0,32(sp)
    800022a2:	64e2                	ld	s1,24(sp)
    800022a4:	6942                	ld	s2,16(sp)
    800022a6:	69a2                	ld	s3,8(sp)
    800022a8:	6a02                	ld	s4,0(sp)
    800022aa:	6145                	addi	sp,sp,48
    800022ac:	8082                	ret

00000000800022ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	e44e                	sd	s3,8(sp)
    800022ba:	1800                	addi	s0,sp,48
    800022bc:	892a                	mv	s2,a0
    800022be:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022c0:	0000b517          	auipc	a0,0xb
    800022c4:	fe850513          	addi	a0,a0,-24 # 8000d2a8 <bcache>
    800022c8:	00004097          	auipc	ra,0x4
    800022cc:	1de080e7          	jalr	478(ra) # 800064a6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022d0:	00013497          	auipc	s1,0x13
    800022d4:	2904b483          	ld	s1,656(s1) # 80015560 <bcache+0x82b8>
    800022d8:	00013797          	auipc	a5,0x13
    800022dc:	23878793          	addi	a5,a5,568 # 80015510 <bcache+0x8268>
    800022e0:	02f48f63          	beq	s1,a5,8000231e <bread+0x70>
    800022e4:	873e                	mv	a4,a5
    800022e6:	a021                	j	800022ee <bread+0x40>
    800022e8:	68a4                	ld	s1,80(s1)
    800022ea:	02e48a63          	beq	s1,a4,8000231e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022ee:	449c                	lw	a5,8(s1)
    800022f0:	ff279ce3          	bne	a5,s2,800022e8 <bread+0x3a>
    800022f4:	44dc                	lw	a5,12(s1)
    800022f6:	ff3799e3          	bne	a5,s3,800022e8 <bread+0x3a>
      b->refcnt++;
    800022fa:	40bc                	lw	a5,64(s1)
    800022fc:	2785                	addiw	a5,a5,1
    800022fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002300:	0000b517          	auipc	a0,0xb
    80002304:	fa850513          	addi	a0,a0,-88 # 8000d2a8 <bcache>
    80002308:	00004097          	auipc	ra,0x4
    8000230c:	252080e7          	jalr	594(ra) # 8000655a <release>
      acquiresleep(&b->lock);
    80002310:	01048513          	addi	a0,s1,16
    80002314:	00001097          	auipc	ra,0x1
    80002318:	5d6080e7          	jalr	1494(ra) # 800038ea <acquiresleep>
      return b;
    8000231c:	a8b9                	j	8000237a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000231e:	00013497          	auipc	s1,0x13
    80002322:	23a4b483          	ld	s1,570(s1) # 80015558 <bcache+0x82b0>
    80002326:	00013797          	auipc	a5,0x13
    8000232a:	1ea78793          	addi	a5,a5,490 # 80015510 <bcache+0x8268>
    8000232e:	00f48863          	beq	s1,a5,8000233e <bread+0x90>
    80002332:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002334:	40bc                	lw	a5,64(s1)
    80002336:	cf81                	beqz	a5,8000234e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002338:	64a4                	ld	s1,72(s1)
    8000233a:	fee49de3          	bne	s1,a4,80002334 <bread+0x86>
  panic("bget: no buffers");
    8000233e:	00006517          	auipc	a0,0x6
    80002342:	05250513          	addi	a0,a0,82 # 80008390 <etext+0x390>
    80002346:	00004097          	auipc	ra,0x4
    8000234a:	be6080e7          	jalr	-1050(ra) # 80005f2c <panic>
      b->dev = dev;
    8000234e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002352:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002356:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000235a:	4785                	li	a5,1
    8000235c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000235e:	0000b517          	auipc	a0,0xb
    80002362:	f4a50513          	addi	a0,a0,-182 # 8000d2a8 <bcache>
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	1f4080e7          	jalr	500(ra) # 8000655a <release>
      acquiresleep(&b->lock);
    8000236e:	01048513          	addi	a0,s1,16
    80002372:	00001097          	auipc	ra,0x1
    80002376:	578080e7          	jalr	1400(ra) # 800038ea <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000237a:	409c                	lw	a5,0(s1)
    8000237c:	cb89                	beqz	a5,8000238e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000237e:	8526                	mv	a0,s1
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6145                	addi	sp,sp,48
    8000238c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000238e:	4581                	li	a1,0
    80002390:	8526                	mv	a0,s1
    80002392:	00003097          	auipc	ra,0x3
    80002396:	300080e7          	jalr	768(ra) # 80005692 <virtio_disk_rw>
    b->valid = 1;
    8000239a:	4785                	li	a5,1
    8000239c:	c09c                	sw	a5,0(s1)
  return b;
    8000239e:	b7c5                	j	8000237e <bread+0xd0>

00000000800023a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023a0:	1101                	addi	sp,sp,-32
    800023a2:	ec06                	sd	ra,24(sp)
    800023a4:	e822                	sd	s0,16(sp)
    800023a6:	e426                	sd	s1,8(sp)
    800023a8:	1000                	addi	s0,sp,32
    800023aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ac:	0541                	addi	a0,a0,16
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	5d6080e7          	jalr	1494(ra) # 80003984 <holdingsleep>
    800023b6:	cd01                	beqz	a0,800023ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023b8:	4585                	li	a1,1
    800023ba:	8526                	mv	a0,s1
    800023bc:	00003097          	auipc	ra,0x3
    800023c0:	2d6080e7          	jalr	726(ra) # 80005692 <virtio_disk_rw>
}
    800023c4:	60e2                	ld	ra,24(sp)
    800023c6:	6442                	ld	s0,16(sp)
    800023c8:	64a2                	ld	s1,8(sp)
    800023ca:	6105                	addi	sp,sp,32
    800023cc:	8082                	ret
    panic("bwrite");
    800023ce:	00006517          	auipc	a0,0x6
    800023d2:	fda50513          	addi	a0,a0,-38 # 800083a8 <etext+0x3a8>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	b56080e7          	jalr	-1194(ra) # 80005f2c <panic>

00000000800023de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023de:	1101                	addi	sp,sp,-32
    800023e0:	ec06                	sd	ra,24(sp)
    800023e2:	e822                	sd	s0,16(sp)
    800023e4:	e426                	sd	s1,8(sp)
    800023e6:	e04a                	sd	s2,0(sp)
    800023e8:	1000                	addi	s0,sp,32
    800023ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ec:	01050913          	addi	s2,a0,16
    800023f0:	854a                	mv	a0,s2
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	592080e7          	jalr	1426(ra) # 80003984 <holdingsleep>
    800023fa:	c925                	beqz	a0,8000246a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800023fc:	854a                	mv	a0,s2
    800023fe:	00001097          	auipc	ra,0x1
    80002402:	542080e7          	jalr	1346(ra) # 80003940 <releasesleep>

  acquire(&bcache.lock);
    80002406:	0000b517          	auipc	a0,0xb
    8000240a:	ea250513          	addi	a0,a0,-350 # 8000d2a8 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	098080e7          	jalr	152(ra) # 800064a6 <acquire>
  b->refcnt--;
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	37fd                	addiw	a5,a5,-1
    8000241a:	0007871b          	sext.w	a4,a5
    8000241e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002420:	e71d                	bnez	a4,8000244e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002422:	68b8                	ld	a4,80(s1)
    80002424:	64bc                	ld	a5,72(s1)
    80002426:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002428:	68b8                	ld	a4,80(s1)
    8000242a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000242c:	00013797          	auipc	a5,0x13
    80002430:	e7c78793          	addi	a5,a5,-388 # 800152a8 <bcache+0x8000>
    80002434:	2b87b703          	ld	a4,696(a5)
    80002438:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000243a:	00013717          	auipc	a4,0x13
    8000243e:	0d670713          	addi	a4,a4,214 # 80015510 <bcache+0x8268>
    80002442:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002444:	2b87b703          	ld	a4,696(a5)
    80002448:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000244a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000244e:	0000b517          	auipc	a0,0xb
    80002452:	e5a50513          	addi	a0,a0,-422 # 8000d2a8 <bcache>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	104080e7          	jalr	260(ra) # 8000655a <release>
}
    8000245e:	60e2                	ld	ra,24(sp)
    80002460:	6442                	ld	s0,16(sp)
    80002462:	64a2                	ld	s1,8(sp)
    80002464:	6902                	ld	s2,0(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret
    panic("brelse");
    8000246a:	00006517          	auipc	a0,0x6
    8000246e:	f4650513          	addi	a0,a0,-186 # 800083b0 <etext+0x3b0>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	aba080e7          	jalr	-1350(ra) # 80005f2c <panic>

000000008000247a <bpin>:

void
bpin(struct buf *b) {
    8000247a:	1101                	addi	sp,sp,-32
    8000247c:	ec06                	sd	ra,24(sp)
    8000247e:	e822                	sd	s0,16(sp)
    80002480:	e426                	sd	s1,8(sp)
    80002482:	1000                	addi	s0,sp,32
    80002484:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002486:	0000b517          	auipc	a0,0xb
    8000248a:	e2250513          	addi	a0,a0,-478 # 8000d2a8 <bcache>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	018080e7          	jalr	24(ra) # 800064a6 <acquire>
  b->refcnt++;
    80002496:	40bc                	lw	a5,64(s1)
    80002498:	2785                	addiw	a5,a5,1
    8000249a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000249c:	0000b517          	auipc	a0,0xb
    800024a0:	e0c50513          	addi	a0,a0,-500 # 8000d2a8 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	0b6080e7          	jalr	182(ra) # 8000655a <release>
}
    800024ac:	60e2                	ld	ra,24(sp)
    800024ae:	6442                	ld	s0,16(sp)
    800024b0:	64a2                	ld	s1,8(sp)
    800024b2:	6105                	addi	sp,sp,32
    800024b4:	8082                	ret

00000000800024b6 <bunpin>:

void
bunpin(struct buf *b) {
    800024b6:	1101                	addi	sp,sp,-32
    800024b8:	ec06                	sd	ra,24(sp)
    800024ba:	e822                	sd	s0,16(sp)
    800024bc:	e426                	sd	s1,8(sp)
    800024be:	1000                	addi	s0,sp,32
    800024c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024c2:	0000b517          	auipc	a0,0xb
    800024c6:	de650513          	addi	a0,a0,-538 # 8000d2a8 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	fdc080e7          	jalr	-36(ra) # 800064a6 <acquire>
  b->refcnt--;
    800024d2:	40bc                	lw	a5,64(s1)
    800024d4:	37fd                	addiw	a5,a5,-1
    800024d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024d8:	0000b517          	auipc	a0,0xb
    800024dc:	dd050513          	addi	a0,a0,-560 # 8000d2a8 <bcache>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	07a080e7          	jalr	122(ra) # 8000655a <release>
}
    800024e8:	60e2                	ld	ra,24(sp)
    800024ea:	6442                	ld	s0,16(sp)
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret

00000000800024f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	e04a                	sd	s2,0(sp)
    800024fc:	1000                	addi	s0,sp,32
    800024fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002500:	00d5d59b          	srliw	a1,a1,0xd
    80002504:	00013797          	auipc	a5,0x13
    80002508:	4807a783          	lw	a5,1152(a5) # 80015984 <sb+0x1c>
    8000250c:	9dbd                	addw	a1,a1,a5
    8000250e:	00000097          	auipc	ra,0x0
    80002512:	da0080e7          	jalr	-608(ra) # 800022ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002516:	0074f713          	andi	a4,s1,7
    8000251a:	4785                	li	a5,1
    8000251c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002520:	14ce                	slli	s1,s1,0x33
    80002522:	90d9                	srli	s1,s1,0x36
    80002524:	00950733          	add	a4,a0,s1
    80002528:	05874703          	lbu	a4,88(a4)
    8000252c:	00e7f6b3          	and	a3,a5,a4
    80002530:	c69d                	beqz	a3,8000255e <bfree+0x6c>
    80002532:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002534:	94aa                	add	s1,s1,a0
    80002536:	fff7c793          	not	a5,a5
    8000253a:	8f7d                	and	a4,a4,a5
    8000253c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002540:	00001097          	auipc	ra,0x1
    80002544:	28c080e7          	jalr	652(ra) # 800037cc <log_write>
  brelse(bp);
    80002548:	854a                	mv	a0,s2
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	e94080e7          	jalr	-364(ra) # 800023de <brelse>
}
    80002552:	60e2                	ld	ra,24(sp)
    80002554:	6442                	ld	s0,16(sp)
    80002556:	64a2                	ld	s1,8(sp)
    80002558:	6902                	ld	s2,0(sp)
    8000255a:	6105                	addi	sp,sp,32
    8000255c:	8082                	ret
    panic("freeing free block");
    8000255e:	00006517          	auipc	a0,0x6
    80002562:	e5a50513          	addi	a0,a0,-422 # 800083b8 <etext+0x3b8>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	9c6080e7          	jalr	-1594(ra) # 80005f2c <panic>

000000008000256e <balloc>:
{
    8000256e:	711d                	addi	sp,sp,-96
    80002570:	ec86                	sd	ra,88(sp)
    80002572:	e8a2                	sd	s0,80(sp)
    80002574:	e4a6                	sd	s1,72(sp)
    80002576:	e0ca                	sd	s2,64(sp)
    80002578:	fc4e                	sd	s3,56(sp)
    8000257a:	f852                	sd	s4,48(sp)
    8000257c:	f456                	sd	s5,40(sp)
    8000257e:	f05a                	sd	s6,32(sp)
    80002580:	ec5e                	sd	s7,24(sp)
    80002582:	e862                	sd	s8,16(sp)
    80002584:	e466                	sd	s9,8(sp)
    80002586:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002588:	00013797          	auipc	a5,0x13
    8000258c:	3e47a783          	lw	a5,996(a5) # 8001596c <sb+0x4>
    80002590:	cbc1                	beqz	a5,80002620 <balloc+0xb2>
    80002592:	8baa                	mv	s7,a0
    80002594:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002596:	00013b17          	auipc	s6,0x13
    8000259a:	3d2b0b13          	addi	s6,s6,978 # 80015968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025a4:	6c89                	lui	s9,0x2
    800025a6:	a831                	j	800025c2 <balloc+0x54>
    brelse(bp);
    800025a8:	854a                	mv	a0,s2
    800025aa:	00000097          	auipc	ra,0x0
    800025ae:	e34080e7          	jalr	-460(ra) # 800023de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025b2:	015c87bb          	addw	a5,s9,s5
    800025b6:	00078a9b          	sext.w	s5,a5
    800025ba:	004b2703          	lw	a4,4(s6)
    800025be:	06eaf163          	bgeu	s5,a4,80002620 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025c2:	41fad79b          	sraiw	a5,s5,0x1f
    800025c6:	0137d79b          	srliw	a5,a5,0x13
    800025ca:	015787bb          	addw	a5,a5,s5
    800025ce:	40d7d79b          	sraiw	a5,a5,0xd
    800025d2:	01cb2583          	lw	a1,28(s6)
    800025d6:	9dbd                	addw	a1,a1,a5
    800025d8:	855e                	mv	a0,s7
    800025da:	00000097          	auipc	ra,0x0
    800025de:	cd4080e7          	jalr	-812(ra) # 800022ae <bread>
    800025e2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e4:	004b2503          	lw	a0,4(s6)
    800025e8:	000a849b          	sext.w	s1,s5
    800025ec:	8762                	mv	a4,s8
    800025ee:	faa4fde3          	bgeu	s1,a0,800025a8 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025f2:	00777693          	andi	a3,a4,7
    800025f6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025fa:	41f7579b          	sraiw	a5,a4,0x1f
    800025fe:	01d7d79b          	srliw	a5,a5,0x1d
    80002602:	9fb9                	addw	a5,a5,a4
    80002604:	4037d79b          	sraiw	a5,a5,0x3
    80002608:	00f90633          	add	a2,s2,a5
    8000260c:	05864603          	lbu	a2,88(a2)
    80002610:	00c6f5b3          	and	a1,a3,a2
    80002614:	cd91                	beqz	a1,80002630 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002616:	2705                	addiw	a4,a4,1
    80002618:	2485                	addiw	s1,s1,1
    8000261a:	fd471ae3          	bne	a4,s4,800025ee <balloc+0x80>
    8000261e:	b769                	j	800025a8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002620:	00006517          	auipc	a0,0x6
    80002624:	db050513          	addi	a0,a0,-592 # 800083d0 <etext+0x3d0>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	904080e7          	jalr	-1788(ra) # 80005f2c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002630:	97ca                	add	a5,a5,s2
    80002632:	8e55                	or	a2,a2,a3
    80002634:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002638:	854a                	mv	a0,s2
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	192080e7          	jalr	402(ra) # 800037cc <log_write>
        brelse(bp);
    80002642:	854a                	mv	a0,s2
    80002644:	00000097          	auipc	ra,0x0
    80002648:	d9a080e7          	jalr	-614(ra) # 800023de <brelse>
  bp = bread(dev, bno);
    8000264c:	85a6                	mv	a1,s1
    8000264e:	855e                	mv	a0,s7
    80002650:	00000097          	auipc	ra,0x0
    80002654:	c5e080e7          	jalr	-930(ra) # 800022ae <bread>
    80002658:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000265a:	40000613          	li	a2,1024
    8000265e:	4581                	li	a1,0
    80002660:	05850513          	addi	a0,a0,88
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	b16080e7          	jalr	-1258(ra) # 8000017a <memset>
  log_write(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	15e080e7          	jalr	350(ra) # 800037cc <log_write>
  brelse(bp);
    80002676:	854a                	mv	a0,s2
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	d66080e7          	jalr	-666(ra) # 800023de <brelse>
}
    80002680:	8526                	mv	a0,s1
    80002682:	60e6                	ld	ra,88(sp)
    80002684:	6446                	ld	s0,80(sp)
    80002686:	64a6                	ld	s1,72(sp)
    80002688:	6906                	ld	s2,64(sp)
    8000268a:	79e2                	ld	s3,56(sp)
    8000268c:	7a42                	ld	s4,48(sp)
    8000268e:	7aa2                	ld	s5,40(sp)
    80002690:	7b02                	ld	s6,32(sp)
    80002692:	6be2                	ld	s7,24(sp)
    80002694:	6c42                	ld	s8,16(sp)
    80002696:	6ca2                	ld	s9,8(sp)
    80002698:	6125                	addi	sp,sp,96
    8000269a:	8082                	ret

000000008000269c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000269c:	7139                	addi	sp,sp,-64
    8000269e:	fc06                	sd	ra,56(sp)
    800026a0:	f822                	sd	s0,48(sp)
    800026a2:	f426                	sd	s1,40(sp)
    800026a4:	f04a                	sd	s2,32(sp)
    800026a6:	ec4e                	sd	s3,24(sp)
    800026a8:	0080                	addi	s0,sp,64
    800026aa:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026ac:	47a9                	li	a5,10
    800026ae:	08b7ff63          	bgeu	a5,a1,8000274c <bmap+0xb0>
    800026b2:	e852                	sd	s4,16(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026b4:	ff55849b          	addiw	s1,a1,-11
    800026b8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026bc:	0ff00793          	li	a5,255
    800026c0:	0ae7fa63          	bgeu	a5,a4,80002774 <bmap+0xd8>
    800026c4:	e456                	sd	s5,8(sp)
    }
    brelse(bp);
    return addr;
  }

  bn-=NINDIRECT;
    800026c6:	ef55849b          	addiw	s1,a1,-267
    800026ca:	0004871b          	sext.w	a4,s1
  if(bn < NDINDIRECT){
    800026ce:	67c1                	lui	a5,0x10
    800026d0:	16f77163          	bgeu	a4,a5,80002832 <bmap+0x196>
    // 加载索引块, 若无则分配
    addr = ip->addrs[NDIRECT+1];
    800026d4:	08052583          	lw	a1,128(a0)
    if(addr==0){
    800026d8:	10058363          	beqz	a1,800027de <bmap+0x142>
      addr = balloc(ip->dev);
      ip->addrs[NDIRECT+1] = addr;
    }
    // 找第二级索引,若无则分配
    bp = bread(ip->dev, addr);
    800026dc:	0009a503          	lw	a0,0(s3)
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	bce080e7          	jalr	-1074(ra) # 800022ae <bread>
    800026e8:	892a                	mv	s2,a0
    a = (uint*)bp->data;
    800026ea:	05850a13          	addi	s4,a0,88
    addr=a[bn/NINDIRECT];
    800026ee:	0084d79b          	srliw	a5,s1,0x8
    800026f2:	078a                	slli	a5,a5,0x2
    800026f4:	9a3e                	add	s4,s4,a5
    800026f6:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    if(addr==0){
    800026fa:	0e0a8c63          	beqz	s5,800027f2 <bmap+0x156>
      addr=balloc(ip->dev);
      a[bn/NINDIRECT] = addr;
      log_write(bp);
    }
    brelse(bp);
    800026fe:	854a                	mv	a0,s2
    80002700:	00000097          	auipc	ra,0x0
    80002704:	cde080e7          	jalr	-802(ra) # 800023de <brelse>
    // 找目标块,若无则分配
    bp = bread(ip->dev, addr);
    80002708:	85d6                	mv	a1,s5
    8000270a:	0009a503          	lw	a0,0(s3)
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	ba0080e7          	jalr	-1120(ra) # 800022ae <bread>
    80002716:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002718:	05850793          	addi	a5,a0,88
    addr=a[bn%NINDIRECT];
    8000271c:	0ff4f593          	zext.b	a1,s1
    80002720:	058a                	slli	a1,a1,0x2
    80002722:	00b784b3          	add	s1,a5,a1
    80002726:	0004a903          	lw	s2,0(s1)
    if(addr==0){
    8000272a:	0e090463          	beqz	s2,80002812 <bmap+0x176>
      addr=balloc(ip->dev);
      a[bn%NINDIRECT] = addr;
      log_write(bp);
    }
    brelse(bp);
    8000272e:	8552                	mv	a0,s4
    80002730:	00000097          	auipc	ra,0x0
    80002734:	cae080e7          	jalr	-850(ra) # 800023de <brelse>
    return addr;
    80002738:	6a42                	ld	s4,16(sp)
    8000273a:	6aa2                	ld	s5,8(sp)
  }
  panic("bmap: out of range");
}
    8000273c:	854a                	mv	a0,s2
    8000273e:	70e2                	ld	ra,56(sp)
    80002740:	7442                	ld	s0,48(sp)
    80002742:	74a2                	ld	s1,40(sp)
    80002744:	7902                	ld	s2,32(sp)
    80002746:	69e2                	ld	s3,24(sp)
    80002748:	6121                	addi	sp,sp,64
    8000274a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000274c:	02059793          	slli	a5,a1,0x20
    80002750:	01e7d593          	srli	a1,a5,0x1e
    80002754:	00b504b3          	add	s1,a0,a1
    80002758:	0504a903          	lw	s2,80(s1)
    8000275c:	fe0910e3          	bnez	s2,8000273c <bmap+0xa0>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002760:	4108                	lw	a0,0(a0)
    80002762:	00000097          	auipc	ra,0x0
    80002766:	e0c080e7          	jalr	-500(ra) # 8000256e <balloc>
    8000276a:	0005091b          	sext.w	s2,a0
    8000276e:	0524a823          	sw	s2,80(s1)
    80002772:	b7e9                	j	8000273c <bmap+0xa0>
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002774:	5d6c                	lw	a1,124(a0)
    80002776:	c995                	beqz	a1,800027aa <bmap+0x10e>
    bp = bread(ip->dev, addr);
    80002778:	0009a503          	lw	a0,0(s3)
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	b32080e7          	jalr	-1230(ra) # 800022ae <bread>
    80002784:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002786:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000278a:	02049713          	slli	a4,s1,0x20
    8000278e:	01e75493          	srli	s1,a4,0x1e
    80002792:	94be                	add	s1,s1,a5
    80002794:	0004a903          	lw	s2,0(s1)
    80002798:	02090363          	beqz	s2,800027be <bmap+0x122>
    brelse(bp);
    8000279c:	8552                	mv	a0,s4
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	c40080e7          	jalr	-960(ra) # 800023de <brelse>
    return addr;
    800027a6:	6a42                	ld	s4,16(sp)
    800027a8:	bf51                	j	8000273c <bmap+0xa0>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027aa:	4108                	lw	a0,0(a0)
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	dc2080e7          	jalr	-574(ra) # 8000256e <balloc>
    800027b4:	0005059b          	sext.w	a1,a0
    800027b8:	06b9ae23          	sw	a1,124(s3)
    800027bc:	bf75                	j	80002778 <bmap+0xdc>
      a[bn] = addr = balloc(ip->dev);
    800027be:	0009a503          	lw	a0,0(s3)
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	dac080e7          	jalr	-596(ra) # 8000256e <balloc>
    800027ca:	0005091b          	sext.w	s2,a0
    800027ce:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800027d2:	8552                	mv	a0,s4
    800027d4:	00001097          	auipc	ra,0x1
    800027d8:	ff8080e7          	jalr	-8(ra) # 800037cc <log_write>
    800027dc:	b7c1                	j	8000279c <bmap+0x100>
      addr = balloc(ip->dev);
    800027de:	4108                	lw	a0,0(a0)
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	d8e080e7          	jalr	-626(ra) # 8000256e <balloc>
    800027e8:	0005059b          	sext.w	a1,a0
      ip->addrs[NDIRECT+1] = addr;
    800027ec:	08b9a023          	sw	a1,128(s3)
    800027f0:	b5f5                	j	800026dc <bmap+0x40>
      addr=balloc(ip->dev);
    800027f2:	0009a503          	lw	a0,0(s3)
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	d78080e7          	jalr	-648(ra) # 8000256e <balloc>
    800027fe:	00050a9b          	sext.w	s5,a0
      a[bn/NINDIRECT] = addr;
    80002802:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    80002806:	854a                	mv	a0,s2
    80002808:	00001097          	auipc	ra,0x1
    8000280c:	fc4080e7          	jalr	-60(ra) # 800037cc <log_write>
    80002810:	b5fd                	j	800026fe <bmap+0x62>
      addr=balloc(ip->dev);
    80002812:	0009a503          	lw	a0,0(s3)
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	d58080e7          	jalr	-680(ra) # 8000256e <balloc>
    8000281e:	0005091b          	sext.w	s2,a0
      a[bn%NINDIRECT] = addr;
    80002822:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    80002826:	8552                	mv	a0,s4
    80002828:	00001097          	auipc	ra,0x1
    8000282c:	fa4080e7          	jalr	-92(ra) # 800037cc <log_write>
    80002830:	bdfd                	j	8000272e <bmap+0x92>
  panic("bmap: out of range");
    80002832:	00006517          	auipc	a0,0x6
    80002836:	bb650513          	addi	a0,a0,-1098 # 800083e8 <etext+0x3e8>
    8000283a:	00003097          	auipc	ra,0x3
    8000283e:	6f2080e7          	jalr	1778(ra) # 80005f2c <panic>

0000000080002842 <iget>:
{
    80002842:	7179                	addi	sp,sp,-48
    80002844:	f406                	sd	ra,40(sp)
    80002846:	f022                	sd	s0,32(sp)
    80002848:	ec26                	sd	s1,24(sp)
    8000284a:	e84a                	sd	s2,16(sp)
    8000284c:	e44e                	sd	s3,8(sp)
    8000284e:	e052                	sd	s4,0(sp)
    80002850:	1800                	addi	s0,sp,48
    80002852:	89aa                	mv	s3,a0
    80002854:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002856:	00013517          	auipc	a0,0x13
    8000285a:	13250513          	addi	a0,a0,306 # 80015988 <itable>
    8000285e:	00004097          	auipc	ra,0x4
    80002862:	c48080e7          	jalr	-952(ra) # 800064a6 <acquire>
  empty = 0;
    80002866:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002868:	00013497          	auipc	s1,0x13
    8000286c:	13848493          	addi	s1,s1,312 # 800159a0 <itable+0x18>
    80002870:	00015697          	auipc	a3,0x15
    80002874:	bc068693          	addi	a3,a3,-1088 # 80017430 <log>
    80002878:	a039                	j	80002886 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000287a:	02090b63          	beqz	s2,800028b0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000287e:	08848493          	addi	s1,s1,136
    80002882:	02d48a63          	beq	s1,a3,800028b6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002886:	449c                	lw	a5,8(s1)
    80002888:	fef059e3          	blez	a5,8000287a <iget+0x38>
    8000288c:	4098                	lw	a4,0(s1)
    8000288e:	ff3716e3          	bne	a4,s3,8000287a <iget+0x38>
    80002892:	40d8                	lw	a4,4(s1)
    80002894:	ff4713e3          	bne	a4,s4,8000287a <iget+0x38>
      ip->ref++;
    80002898:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    8000289a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000289c:	00013517          	auipc	a0,0x13
    800028a0:	0ec50513          	addi	a0,a0,236 # 80015988 <itable>
    800028a4:	00004097          	auipc	ra,0x4
    800028a8:	cb6080e7          	jalr	-842(ra) # 8000655a <release>
      return ip;
    800028ac:	8926                	mv	s2,s1
    800028ae:	a03d                	j	800028dc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028b0:	f7f9                	bnez	a5,8000287e <iget+0x3c>
      empty = ip;
    800028b2:	8926                	mv	s2,s1
    800028b4:	b7e9                	j	8000287e <iget+0x3c>
  if(empty == 0)
    800028b6:	02090c63          	beqz	s2,800028ee <iget+0xac>
  ip->dev = dev;
    800028ba:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028be:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028c2:	4785                	li	a5,1
    800028c4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028c8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028cc:	00013517          	auipc	a0,0x13
    800028d0:	0bc50513          	addi	a0,a0,188 # 80015988 <itable>
    800028d4:	00004097          	auipc	ra,0x4
    800028d8:	c86080e7          	jalr	-890(ra) # 8000655a <release>
}
    800028dc:	854a                	mv	a0,s2
    800028de:	70a2                	ld	ra,40(sp)
    800028e0:	7402                	ld	s0,32(sp)
    800028e2:	64e2                	ld	s1,24(sp)
    800028e4:	6942                	ld	s2,16(sp)
    800028e6:	69a2                	ld	s3,8(sp)
    800028e8:	6a02                	ld	s4,0(sp)
    800028ea:	6145                	addi	sp,sp,48
    800028ec:	8082                	ret
    panic("iget: no inodes");
    800028ee:	00006517          	auipc	a0,0x6
    800028f2:	b1250513          	addi	a0,a0,-1262 # 80008400 <etext+0x400>
    800028f6:	00003097          	auipc	ra,0x3
    800028fa:	636080e7          	jalr	1590(ra) # 80005f2c <panic>

00000000800028fe <fsinit>:
fsinit(int dev) {
    800028fe:	7179                	addi	sp,sp,-48
    80002900:	f406                	sd	ra,40(sp)
    80002902:	f022                	sd	s0,32(sp)
    80002904:	ec26                	sd	s1,24(sp)
    80002906:	e84a                	sd	s2,16(sp)
    80002908:	e44e                	sd	s3,8(sp)
    8000290a:	1800                	addi	s0,sp,48
    8000290c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000290e:	4585                	li	a1,1
    80002910:	00000097          	auipc	ra,0x0
    80002914:	99e080e7          	jalr	-1634(ra) # 800022ae <bread>
    80002918:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000291a:	00013997          	auipc	s3,0x13
    8000291e:	04e98993          	addi	s3,s3,78 # 80015968 <sb>
    80002922:	02000613          	li	a2,32
    80002926:	05850593          	addi	a1,a0,88
    8000292a:	854e                	mv	a0,s3
    8000292c:	ffffe097          	auipc	ra,0xffffe
    80002930:	8aa080e7          	jalr	-1878(ra) # 800001d6 <memmove>
  brelse(bp);
    80002934:	8526                	mv	a0,s1
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	aa8080e7          	jalr	-1368(ra) # 800023de <brelse>
  if(sb.magic != FSMAGIC)
    8000293e:	0009a703          	lw	a4,0(s3)
    80002942:	102037b7          	lui	a5,0x10203
    80002946:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000294a:	02f71263          	bne	a4,a5,8000296e <fsinit+0x70>
  initlog(dev, &sb);
    8000294e:	00013597          	auipc	a1,0x13
    80002952:	01a58593          	addi	a1,a1,26 # 80015968 <sb>
    80002956:	854a                	mv	a0,s2
    80002958:	00001097          	auipc	ra,0x1
    8000295c:	c04080e7          	jalr	-1020(ra) # 8000355c <initlog>
}
    80002960:	70a2                	ld	ra,40(sp)
    80002962:	7402                	ld	s0,32(sp)
    80002964:	64e2                	ld	s1,24(sp)
    80002966:	6942                	ld	s2,16(sp)
    80002968:	69a2                	ld	s3,8(sp)
    8000296a:	6145                	addi	sp,sp,48
    8000296c:	8082                	ret
    panic("invalid file system");
    8000296e:	00006517          	auipc	a0,0x6
    80002972:	aa250513          	addi	a0,a0,-1374 # 80008410 <etext+0x410>
    80002976:	00003097          	auipc	ra,0x3
    8000297a:	5b6080e7          	jalr	1462(ra) # 80005f2c <panic>

000000008000297e <iinit>:
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	e44e                	sd	s3,8(sp)
    8000298a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000298c:	00006597          	auipc	a1,0x6
    80002990:	a9c58593          	addi	a1,a1,-1380 # 80008428 <etext+0x428>
    80002994:	00013517          	auipc	a0,0x13
    80002998:	ff450513          	addi	a0,a0,-12 # 80015988 <itable>
    8000299c:	00004097          	auipc	ra,0x4
    800029a0:	a7a080e7          	jalr	-1414(ra) # 80006416 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029a4:	00013497          	auipc	s1,0x13
    800029a8:	00c48493          	addi	s1,s1,12 # 800159b0 <itable+0x28>
    800029ac:	00015997          	auipc	s3,0x15
    800029b0:	a9498993          	addi	s3,s3,-1388 # 80017440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029b4:	00006917          	auipc	s2,0x6
    800029b8:	a7c90913          	addi	s2,s2,-1412 # 80008430 <etext+0x430>
    800029bc:	85ca                	mv	a1,s2
    800029be:	8526                	mv	a0,s1
    800029c0:	00001097          	auipc	ra,0x1
    800029c4:	ef0080e7          	jalr	-272(ra) # 800038b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029c8:	08848493          	addi	s1,s1,136
    800029cc:	ff3498e3          	bne	s1,s3,800029bc <iinit+0x3e>
}
    800029d0:	70a2                	ld	ra,40(sp)
    800029d2:	7402                	ld	s0,32(sp)
    800029d4:	64e2                	ld	s1,24(sp)
    800029d6:	6942                	ld	s2,16(sp)
    800029d8:	69a2                	ld	s3,8(sp)
    800029da:	6145                	addi	sp,sp,48
    800029dc:	8082                	ret

00000000800029de <ialloc>:
{
    800029de:	7139                	addi	sp,sp,-64
    800029e0:	fc06                	sd	ra,56(sp)
    800029e2:	f822                	sd	s0,48(sp)
    800029e4:	f426                	sd	s1,40(sp)
    800029e6:	f04a                	sd	s2,32(sp)
    800029e8:	ec4e                	sd	s3,24(sp)
    800029ea:	e852                	sd	s4,16(sp)
    800029ec:	e456                	sd	s5,8(sp)
    800029ee:	e05a                	sd	s6,0(sp)
    800029f0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f2:	00013717          	auipc	a4,0x13
    800029f6:	f8272703          	lw	a4,-126(a4) # 80015974 <sb+0xc>
    800029fa:	4785                	li	a5,1
    800029fc:	04e7f863          	bgeu	a5,a4,80002a4c <ialloc+0x6e>
    80002a00:	8aaa                	mv	s5,a0
    80002a02:	8b2e                	mv	s6,a1
    80002a04:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a06:	00013a17          	auipc	s4,0x13
    80002a0a:	f62a0a13          	addi	s4,s4,-158 # 80015968 <sb>
    80002a0e:	00495593          	srli	a1,s2,0x4
    80002a12:	018a2783          	lw	a5,24(s4)
    80002a16:	9dbd                	addw	a1,a1,a5
    80002a18:	8556                	mv	a0,s5
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	894080e7          	jalr	-1900(ra) # 800022ae <bread>
    80002a22:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a24:	05850993          	addi	s3,a0,88
    80002a28:	00f97793          	andi	a5,s2,15
    80002a2c:	079a                	slli	a5,a5,0x6
    80002a2e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a30:	00099783          	lh	a5,0(s3)
    80002a34:	c785                	beqz	a5,80002a5c <ialloc+0x7e>
    brelse(bp);
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	9a8080e7          	jalr	-1624(ra) # 800023de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a3e:	0905                	addi	s2,s2,1
    80002a40:	00ca2703          	lw	a4,12(s4)
    80002a44:	0009079b          	sext.w	a5,s2
    80002a48:	fce7e3e3          	bltu	a5,a4,80002a0e <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a4c:	00006517          	auipc	a0,0x6
    80002a50:	9ec50513          	addi	a0,a0,-1556 # 80008438 <etext+0x438>
    80002a54:	00003097          	auipc	ra,0x3
    80002a58:	4d8080e7          	jalr	1240(ra) # 80005f2c <panic>
      memset(dip, 0, sizeof(*dip));
    80002a5c:	04000613          	li	a2,64
    80002a60:	4581                	li	a1,0
    80002a62:	854e                	mv	a0,s3
    80002a64:	ffffd097          	auipc	ra,0xffffd
    80002a68:	716080e7          	jalr	1814(ra) # 8000017a <memset>
      dip->type = type;
    80002a6c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a70:	8526                	mv	a0,s1
    80002a72:	00001097          	auipc	ra,0x1
    80002a76:	d5a080e7          	jalr	-678(ra) # 800037cc <log_write>
      brelse(bp);
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	962080e7          	jalr	-1694(ra) # 800023de <brelse>
      return iget(dev, inum);
    80002a84:	0009059b          	sext.w	a1,s2
    80002a88:	8556                	mv	a0,s5
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	db8080e7          	jalr	-584(ra) # 80002842 <iget>
}
    80002a92:	70e2                	ld	ra,56(sp)
    80002a94:	7442                	ld	s0,48(sp)
    80002a96:	74a2                	ld	s1,40(sp)
    80002a98:	7902                	ld	s2,32(sp)
    80002a9a:	69e2                	ld	s3,24(sp)
    80002a9c:	6a42                	ld	s4,16(sp)
    80002a9e:	6aa2                	ld	s5,8(sp)
    80002aa0:	6b02                	ld	s6,0(sp)
    80002aa2:	6121                	addi	sp,sp,64
    80002aa4:	8082                	ret

0000000080002aa6 <iupdate>:
{
    80002aa6:	1101                	addi	sp,sp,-32
    80002aa8:	ec06                	sd	ra,24(sp)
    80002aaa:	e822                	sd	s0,16(sp)
    80002aac:	e426                	sd	s1,8(sp)
    80002aae:	e04a                	sd	s2,0(sp)
    80002ab0:	1000                	addi	s0,sp,32
    80002ab2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ab4:	415c                	lw	a5,4(a0)
    80002ab6:	0047d79b          	srliw	a5,a5,0x4
    80002aba:	00013597          	auipc	a1,0x13
    80002abe:	ec65a583          	lw	a1,-314(a1) # 80015980 <sb+0x18>
    80002ac2:	9dbd                	addw	a1,a1,a5
    80002ac4:	4108                	lw	a0,0(a0)
    80002ac6:	fffff097          	auipc	ra,0xfffff
    80002aca:	7e8080e7          	jalr	2024(ra) # 800022ae <bread>
    80002ace:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ad0:	05850793          	addi	a5,a0,88
    80002ad4:	40d8                	lw	a4,4(s1)
    80002ad6:	8b3d                	andi	a4,a4,15
    80002ad8:	071a                	slli	a4,a4,0x6
    80002ada:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002adc:	04449703          	lh	a4,68(s1)
    80002ae0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ae4:	04649703          	lh	a4,70(s1)
    80002ae8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002aec:	04849703          	lh	a4,72(s1)
    80002af0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002af4:	04a49703          	lh	a4,74(s1)
    80002af8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002afc:	44f8                	lw	a4,76(s1)
    80002afe:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b00:	03400613          	li	a2,52
    80002b04:	05048593          	addi	a1,s1,80
    80002b08:	00c78513          	addi	a0,a5,12
    80002b0c:	ffffd097          	auipc	ra,0xffffd
    80002b10:	6ca080e7          	jalr	1738(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b14:	854a                	mv	a0,s2
    80002b16:	00001097          	auipc	ra,0x1
    80002b1a:	cb6080e7          	jalr	-842(ra) # 800037cc <log_write>
  brelse(bp);
    80002b1e:	854a                	mv	a0,s2
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	8be080e7          	jalr	-1858(ra) # 800023de <brelse>
}
    80002b28:	60e2                	ld	ra,24(sp)
    80002b2a:	6442                	ld	s0,16(sp)
    80002b2c:	64a2                	ld	s1,8(sp)
    80002b2e:	6902                	ld	s2,0(sp)
    80002b30:	6105                	addi	sp,sp,32
    80002b32:	8082                	ret

0000000080002b34 <idup>:
{
    80002b34:	1101                	addi	sp,sp,-32
    80002b36:	ec06                	sd	ra,24(sp)
    80002b38:	e822                	sd	s0,16(sp)
    80002b3a:	e426                	sd	s1,8(sp)
    80002b3c:	1000                	addi	s0,sp,32
    80002b3e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b40:	00013517          	auipc	a0,0x13
    80002b44:	e4850513          	addi	a0,a0,-440 # 80015988 <itable>
    80002b48:	00004097          	auipc	ra,0x4
    80002b4c:	95e080e7          	jalr	-1698(ra) # 800064a6 <acquire>
  ip->ref++;
    80002b50:	449c                	lw	a5,8(s1)
    80002b52:	2785                	addiw	a5,a5,1
    80002b54:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b56:	00013517          	auipc	a0,0x13
    80002b5a:	e3250513          	addi	a0,a0,-462 # 80015988 <itable>
    80002b5e:	00004097          	auipc	ra,0x4
    80002b62:	9fc080e7          	jalr	-1540(ra) # 8000655a <release>
}
    80002b66:	8526                	mv	a0,s1
    80002b68:	60e2                	ld	ra,24(sp)
    80002b6a:	6442                	ld	s0,16(sp)
    80002b6c:	64a2                	ld	s1,8(sp)
    80002b6e:	6105                	addi	sp,sp,32
    80002b70:	8082                	ret

0000000080002b72 <ilock>:
{
    80002b72:	1101                	addi	sp,sp,-32
    80002b74:	ec06                	sd	ra,24(sp)
    80002b76:	e822                	sd	s0,16(sp)
    80002b78:	e426                	sd	s1,8(sp)
    80002b7a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b7c:	c10d                	beqz	a0,80002b9e <ilock+0x2c>
    80002b7e:	84aa                	mv	s1,a0
    80002b80:	451c                	lw	a5,8(a0)
    80002b82:	00f05e63          	blez	a5,80002b9e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b86:	0541                	addi	a0,a0,16
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	d62080e7          	jalr	-670(ra) # 800038ea <acquiresleep>
  if(ip->valid == 0){
    80002b90:	40bc                	lw	a5,64(s1)
    80002b92:	cf99                	beqz	a5,80002bb0 <ilock+0x3e>
}
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	64a2                	ld	s1,8(sp)
    80002b9a:	6105                	addi	sp,sp,32
    80002b9c:	8082                	ret
    80002b9e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ba0:	00006517          	auipc	a0,0x6
    80002ba4:	8b050513          	addi	a0,a0,-1872 # 80008450 <etext+0x450>
    80002ba8:	00003097          	auipc	ra,0x3
    80002bac:	384080e7          	jalr	900(ra) # 80005f2c <panic>
    80002bb0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bb2:	40dc                	lw	a5,4(s1)
    80002bb4:	0047d79b          	srliw	a5,a5,0x4
    80002bb8:	00013597          	auipc	a1,0x13
    80002bbc:	dc85a583          	lw	a1,-568(a1) # 80015980 <sb+0x18>
    80002bc0:	9dbd                	addw	a1,a1,a5
    80002bc2:	4088                	lw	a0,0(s1)
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	6ea080e7          	jalr	1770(ra) # 800022ae <bread>
    80002bcc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bce:	05850593          	addi	a1,a0,88
    80002bd2:	40dc                	lw	a5,4(s1)
    80002bd4:	8bbd                	andi	a5,a5,15
    80002bd6:	079a                	slli	a5,a5,0x6
    80002bd8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bda:	00059783          	lh	a5,0(a1)
    80002bde:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002be2:	00259783          	lh	a5,2(a1)
    80002be6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bea:	00459783          	lh	a5,4(a1)
    80002bee:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bf2:	00659783          	lh	a5,6(a1)
    80002bf6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bfa:	459c                	lw	a5,8(a1)
    80002bfc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bfe:	03400613          	li	a2,52
    80002c02:	05b1                	addi	a1,a1,12
    80002c04:	05048513          	addi	a0,s1,80
    80002c08:	ffffd097          	auipc	ra,0xffffd
    80002c0c:	5ce080e7          	jalr	1486(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c10:	854a                	mv	a0,s2
    80002c12:	fffff097          	auipc	ra,0xfffff
    80002c16:	7cc080e7          	jalr	1996(ra) # 800023de <brelse>
    ip->valid = 1;
    80002c1a:	4785                	li	a5,1
    80002c1c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c1e:	04449783          	lh	a5,68(s1)
    80002c22:	c399                	beqz	a5,80002c28 <ilock+0xb6>
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	b7bd                	j	80002b94 <ilock+0x22>
      panic("ilock: no type");
    80002c28:	00006517          	auipc	a0,0x6
    80002c2c:	83050513          	addi	a0,a0,-2000 # 80008458 <etext+0x458>
    80002c30:	00003097          	auipc	ra,0x3
    80002c34:	2fc080e7          	jalr	764(ra) # 80005f2c <panic>

0000000080002c38 <iunlock>:
{
    80002c38:	1101                	addi	sp,sp,-32
    80002c3a:	ec06                	sd	ra,24(sp)
    80002c3c:	e822                	sd	s0,16(sp)
    80002c3e:	e426                	sd	s1,8(sp)
    80002c40:	e04a                	sd	s2,0(sp)
    80002c42:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c44:	c905                	beqz	a0,80002c74 <iunlock+0x3c>
    80002c46:	84aa                	mv	s1,a0
    80002c48:	01050913          	addi	s2,a0,16
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	00001097          	auipc	ra,0x1
    80002c52:	d36080e7          	jalr	-714(ra) # 80003984 <holdingsleep>
    80002c56:	cd19                	beqz	a0,80002c74 <iunlock+0x3c>
    80002c58:	449c                	lw	a5,8(s1)
    80002c5a:	00f05d63          	blez	a5,80002c74 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c5e:	854a                	mv	a0,s2
    80002c60:	00001097          	auipc	ra,0x1
    80002c64:	ce0080e7          	jalr	-800(ra) # 80003940 <releasesleep>
}
    80002c68:	60e2                	ld	ra,24(sp)
    80002c6a:	6442                	ld	s0,16(sp)
    80002c6c:	64a2                	ld	s1,8(sp)
    80002c6e:	6902                	ld	s2,0(sp)
    80002c70:	6105                	addi	sp,sp,32
    80002c72:	8082                	ret
    panic("iunlock");
    80002c74:	00005517          	auipc	a0,0x5
    80002c78:	7f450513          	addi	a0,a0,2036 # 80008468 <etext+0x468>
    80002c7c:	00003097          	auipc	ra,0x3
    80002c80:	2b0080e7          	jalr	688(ra) # 80005f2c <panic>

0000000080002c84 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c84:	715d                	addi	sp,sp,-80
    80002c86:	e486                	sd	ra,72(sp)
    80002c88:	e0a2                	sd	s0,64(sp)
    80002c8a:	fc26                	sd	s1,56(sp)
    80002c8c:	f84a                	sd	s2,48(sp)
    80002c8e:	f44e                	sd	s3,40(sp)
    80002c90:	0880                	addi	s0,sp,80
    80002c92:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp, *bp2;
  uint *a, *a2;

  for(i = 0; i < NDIRECT; i++){
    80002c94:	05050493          	addi	s1,a0,80
    80002c98:	07c50913          	addi	s2,a0,124
    80002c9c:	a021                	j	80002ca4 <itrunc+0x20>
    80002c9e:	0491                	addi	s1,s1,4
    80002ca0:	01248d63          	beq	s1,s2,80002cba <itrunc+0x36>
    if(ip->addrs[i]){
    80002ca4:	408c                	lw	a1,0(s1)
    80002ca6:	dde5                	beqz	a1,80002c9e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ca8:	0009a503          	lw	a0,0(s3)
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	846080e7          	jalr	-1978(ra) # 800024f2 <bfree>
      ip->addrs[i] = 0;
    80002cb4:	0004a023          	sw	zero,0(s1)
    80002cb8:	b7dd                	j	80002c9e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cba:	07c9a583          	lw	a1,124(s3)
    80002cbe:	e195                	bnez	a1,80002ce2 <itrunc+0x5e>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

   if(ip->addrs[NDIRECT+1]) {
    80002cc0:	0809a583          	lw	a1,128(s3)
    80002cc4:	e9ad                	bnez	a1,80002d36 <itrunc+0xb2>
      brelse(bp);
      bfree(ip->dev, ip->addrs[NDIRECT+1]);
      ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cc6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cca:	854e                	mv	a0,s3
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	dda080e7          	jalr	-550(ra) # 80002aa6 <iupdate>
}
    80002cd4:	60a6                	ld	ra,72(sp)
    80002cd6:	6406                	ld	s0,64(sp)
    80002cd8:	74e2                	ld	s1,56(sp)
    80002cda:	7942                	ld	s2,48(sp)
    80002cdc:	79a2                	ld	s3,40(sp)
    80002cde:	6161                	addi	sp,sp,80
    80002ce0:	8082                	ret
    80002ce2:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ce4:	0009a503          	lw	a0,0(s3)
    80002ce8:	fffff097          	auipc	ra,0xfffff
    80002cec:	5c6080e7          	jalr	1478(ra) # 800022ae <bread>
    80002cf0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cf2:	05850493          	addi	s1,a0,88
    80002cf6:	45850913          	addi	s2,a0,1112
    80002cfa:	a021                	j	80002d02 <itrunc+0x7e>
    80002cfc:	0491                	addi	s1,s1,4
    80002cfe:	01248b63          	beq	s1,s2,80002d14 <itrunc+0x90>
      if(a[j])
    80002d02:	408c                	lw	a1,0(s1)
    80002d04:	dde5                	beqz	a1,80002cfc <itrunc+0x78>
        bfree(ip->dev, a[j]);
    80002d06:	0009a503          	lw	a0,0(s3)
    80002d0a:	fffff097          	auipc	ra,0xfffff
    80002d0e:	7e8080e7          	jalr	2024(ra) # 800024f2 <bfree>
    80002d12:	b7ed                	j	80002cfc <itrunc+0x78>
    brelse(bp);
    80002d14:	8552                	mv	a0,s4
    80002d16:	fffff097          	auipc	ra,0xfffff
    80002d1a:	6c8080e7          	jalr	1736(ra) # 800023de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d1e:	07c9a583          	lw	a1,124(s3)
    80002d22:	0009a503          	lw	a0,0(s3)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	7cc080e7          	jalr	1996(ra) # 800024f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d2e:	0609ae23          	sw	zero,124(s3)
    80002d32:	7a02                	ld	s4,32(sp)
    80002d34:	b771                	j	80002cc0 <itrunc+0x3c>
    80002d36:	f052                	sd	s4,32(sp)
    80002d38:	ec56                	sd	s5,24(sp)
    80002d3a:	e85a                	sd	s6,16(sp)
    80002d3c:	e45e                	sd	s7,8(sp)
    80002d3e:	e062                	sd	s8,0(sp)
      bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    80002d40:	0009a503          	lw	a0,0(s3)
    80002d44:	fffff097          	auipc	ra,0xfffff
    80002d48:	56a080e7          	jalr	1386(ra) # 800022ae <bread>
    80002d4c:	8c2a                	mv	s8,a0
      for(j = 0; j < NINDIRECT; j++) {
    80002d4e:	05850a13          	addi	s4,a0,88
    80002d52:	45850b13          	addi	s6,a0,1112
    80002d56:	a83d                	j	80002d94 <itrunc+0x110>
          for(i = 0; i < NINDIRECT; i++) {
    80002d58:	0491                	addi	s1,s1,4
    80002d5a:	01248b63          	beq	s1,s2,80002d70 <itrunc+0xec>
            if(a2[i]) {
    80002d5e:	408c                	lw	a1,0(s1)
    80002d60:	dde5                	beqz	a1,80002d58 <itrunc+0xd4>
              bfree(ip->dev, a2[i]);
    80002d62:	0009a503          	lw	a0,0(s3)
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	78c080e7          	jalr	1932(ra) # 800024f2 <bfree>
    80002d6e:	b7ed                	j	80002d58 <itrunc+0xd4>
          brelse(bp2);
    80002d70:	855e                	mv	a0,s7
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	66c080e7          	jalr	1644(ra) # 800023de <brelse>
          bfree(ip->dev, a[j]);
    80002d7a:	000aa583          	lw	a1,0(s5)
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	770080e7          	jalr	1904(ra) # 800024f2 <bfree>
          a[j] = 0;
    80002d8a:	000aa023          	sw	zero,0(s5)
      for(j = 0; j < NINDIRECT; j++) {
    80002d8e:	0a11                	addi	s4,s4,4
    80002d90:	036a0263          	beq	s4,s6,80002db4 <itrunc+0x130>
        if(a[j]) {
    80002d94:	8ad2                	mv	s5,s4
    80002d96:	000a2583          	lw	a1,0(s4)
    80002d9a:	d9f5                	beqz	a1,80002d8e <itrunc+0x10a>
          bp2 = bread(ip->dev, a[j]);
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	fffff097          	auipc	ra,0xfffff
    80002da4:	50e080e7          	jalr	1294(ra) # 800022ae <bread>
    80002da8:	8baa                	mv	s7,a0
          for(i = 0; i < NINDIRECT; i++) {
    80002daa:	05850493          	addi	s1,a0,88
    80002dae:	45850913          	addi	s2,a0,1112
    80002db2:	b775                	j	80002d5e <itrunc+0xda>
      brelse(bp);
    80002db4:	8562                	mv	a0,s8
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	628080e7          	jalr	1576(ra) # 800023de <brelse>
      bfree(ip->dev, ip->addrs[NDIRECT+1]);
    80002dbe:	0809a583          	lw	a1,128(s3)
    80002dc2:	0009a503          	lw	a0,0(s3)
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	72c080e7          	jalr	1836(ra) # 800024f2 <bfree>
      ip->addrs[NDIRECT] = 0;
    80002dce:	0609ae23          	sw	zero,124(s3)
    80002dd2:	7a02                	ld	s4,32(sp)
    80002dd4:	6ae2                	ld	s5,24(sp)
    80002dd6:	6b42                	ld	s6,16(sp)
    80002dd8:	6ba2                	ld	s7,8(sp)
    80002dda:	6c02                	ld	s8,0(sp)
    80002ddc:	b5ed                	j	80002cc6 <itrunc+0x42>

0000000080002dde <iput>:
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	1000                	addi	s0,sp,32
    80002de8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dea:	00013517          	auipc	a0,0x13
    80002dee:	b9e50513          	addi	a0,a0,-1122 # 80015988 <itable>
    80002df2:	00003097          	auipc	ra,0x3
    80002df6:	6b4080e7          	jalr	1716(ra) # 800064a6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfa:	4498                	lw	a4,8(s1)
    80002dfc:	4785                	li	a5,1
    80002dfe:	02f70263          	beq	a4,a5,80002e22 <iput+0x44>
  ip->ref--;
    80002e02:	449c                	lw	a5,8(s1)
    80002e04:	37fd                	addiw	a5,a5,-1
    80002e06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e08:	00013517          	auipc	a0,0x13
    80002e0c:	b8050513          	addi	a0,a0,-1152 # 80015988 <itable>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	74a080e7          	jalr	1866(ra) # 8000655a <release>
}
    80002e18:	60e2                	ld	ra,24(sp)
    80002e1a:	6442                	ld	s0,16(sp)
    80002e1c:	64a2                	ld	s1,8(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e22:	40bc                	lw	a5,64(s1)
    80002e24:	dff9                	beqz	a5,80002e02 <iput+0x24>
    80002e26:	04a49783          	lh	a5,74(s1)
    80002e2a:	ffe1                	bnez	a5,80002e02 <iput+0x24>
    80002e2c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e2e:	01048913          	addi	s2,s1,16
    80002e32:	854a                	mv	a0,s2
    80002e34:	00001097          	auipc	ra,0x1
    80002e38:	ab6080e7          	jalr	-1354(ra) # 800038ea <acquiresleep>
    release(&itable.lock);
    80002e3c:	00013517          	auipc	a0,0x13
    80002e40:	b4c50513          	addi	a0,a0,-1204 # 80015988 <itable>
    80002e44:	00003097          	auipc	ra,0x3
    80002e48:	716080e7          	jalr	1814(ra) # 8000655a <release>
    itrunc(ip);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	e36080e7          	jalr	-458(ra) # 80002c84 <itrunc>
    ip->type = 0;
    80002e56:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	c4a080e7          	jalr	-950(ra) # 80002aa6 <iupdate>
    ip->valid = 0;
    80002e64:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00001097          	auipc	ra,0x1
    80002e6e:	ad6080e7          	jalr	-1322(ra) # 80003940 <releasesleep>
    acquire(&itable.lock);
    80002e72:	00013517          	auipc	a0,0x13
    80002e76:	b1650513          	addi	a0,a0,-1258 # 80015988 <itable>
    80002e7a:	00003097          	auipc	ra,0x3
    80002e7e:	62c080e7          	jalr	1580(ra) # 800064a6 <acquire>
    80002e82:	6902                	ld	s2,0(sp)
    80002e84:	bfbd                	j	80002e02 <iput+0x24>

0000000080002e86 <iunlockput>:
{
    80002e86:	1101                	addi	sp,sp,-32
    80002e88:	ec06                	sd	ra,24(sp)
    80002e8a:	e822                	sd	s0,16(sp)
    80002e8c:	e426                	sd	s1,8(sp)
    80002e8e:	1000                	addi	s0,sp,32
    80002e90:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	da6080e7          	jalr	-602(ra) # 80002c38 <iunlock>
  iput(ip);
    80002e9a:	8526                	mv	a0,s1
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	f42080e7          	jalr	-190(ra) # 80002dde <iput>
}
    80002ea4:	60e2                	ld	ra,24(sp)
    80002ea6:	6442                	ld	s0,16(sp)
    80002ea8:	64a2                	ld	s1,8(sp)
    80002eaa:	6105                	addi	sp,sp,32
    80002eac:	8082                	ret

0000000080002eae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eae:	1141                	addi	sp,sp,-16
    80002eb0:	e422                	sd	s0,8(sp)
    80002eb2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eb4:	411c                	lw	a5,0(a0)
    80002eb6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eb8:	415c                	lw	a5,4(a0)
    80002eba:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ebc:	04451783          	lh	a5,68(a0)
    80002ec0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ec4:	04a51783          	lh	a5,74(a0)
    80002ec8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ecc:	04c56783          	lwu	a5,76(a0)
    80002ed0:	e99c                	sd	a5,16(a1)
}
    80002ed2:	6422                	ld	s0,8(sp)
    80002ed4:	0141                	addi	sp,sp,16
    80002ed6:	8082                	ret

0000000080002ed8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ed8:	457c                	lw	a5,76(a0)
    80002eda:	0ed7ef63          	bltu	a5,a3,80002fd8 <readi+0x100>
{
    80002ede:	7159                	addi	sp,sp,-112
    80002ee0:	f486                	sd	ra,104(sp)
    80002ee2:	f0a2                	sd	s0,96(sp)
    80002ee4:	eca6                	sd	s1,88(sp)
    80002ee6:	fc56                	sd	s5,56(sp)
    80002ee8:	f85a                	sd	s6,48(sp)
    80002eea:	f45e                	sd	s7,40(sp)
    80002eec:	f062                	sd	s8,32(sp)
    80002eee:	1880                	addi	s0,sp,112
    80002ef0:	8baa                	mv	s7,a0
    80002ef2:	8c2e                	mv	s8,a1
    80002ef4:	8ab2                	mv	s5,a2
    80002ef6:	84b6                	mv	s1,a3
    80002ef8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002efa:	9f35                	addw	a4,a4,a3
    return 0;
    80002efc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002efe:	0ad76c63          	bltu	a4,a3,80002fb6 <readi+0xde>
    80002f02:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f04:	00e7f463          	bgeu	a5,a4,80002f0c <readi+0x34>
    n = ip->size - off;
    80002f08:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0c:	0c0b0463          	beqz	s6,80002fd4 <readi+0xfc>
    80002f10:	e8ca                	sd	s2,80(sp)
    80002f12:	e0d2                	sd	s4,64(sp)
    80002f14:	ec66                	sd	s9,24(sp)
    80002f16:	e86a                	sd	s10,16(sp)
    80002f18:	e46e                	sd	s11,8(sp)
    80002f1a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f20:	5cfd                	li	s9,-1
    80002f22:	a82d                	j	80002f5c <readi+0x84>
    80002f24:	020a1d93          	slli	s11,s4,0x20
    80002f28:	020ddd93          	srli	s11,s11,0x20
    80002f2c:	05890613          	addi	a2,s2,88
    80002f30:	86ee                	mv	a3,s11
    80002f32:	963a                	add	a2,a2,a4
    80002f34:	85d6                	mv	a1,s5
    80002f36:	8562                	mv	a0,s8
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	9a8080e7          	jalr	-1624(ra) # 800018e0 <either_copyout>
    80002f40:	05950d63          	beq	a0,s9,80002f9a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f44:	854a                	mv	a0,s2
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	498080e7          	jalr	1176(ra) # 800023de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4e:	013a09bb          	addw	s3,s4,s3
    80002f52:	009a04bb          	addw	s1,s4,s1
    80002f56:	9aee                	add	s5,s5,s11
    80002f58:	0769f863          	bgeu	s3,s6,80002fc8 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f5c:	000ba903          	lw	s2,0(s7)
    80002f60:	00a4d59b          	srliw	a1,s1,0xa
    80002f64:	855e                	mv	a0,s7
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	736080e7          	jalr	1846(ra) # 8000269c <bmap>
    80002f6e:	0005059b          	sext.w	a1,a0
    80002f72:	854a                	mv	a0,s2
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	33a080e7          	jalr	826(ra) # 800022ae <bread>
    80002f7c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7e:	3ff4f713          	andi	a4,s1,1023
    80002f82:	40ed07bb          	subw	a5,s10,a4
    80002f86:	413b06bb          	subw	a3,s6,s3
    80002f8a:	8a3e                	mv	s4,a5
    80002f8c:	2781                	sext.w	a5,a5
    80002f8e:	0006861b          	sext.w	a2,a3
    80002f92:	f8f679e3          	bgeu	a2,a5,80002f24 <readi+0x4c>
    80002f96:	8a36                	mv	s4,a3
    80002f98:	b771                	j	80002f24 <readi+0x4c>
      brelse(bp);
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	442080e7          	jalr	1090(ra) # 800023de <brelse>
      tot = -1;
    80002fa4:	59fd                	li	s3,-1
      break;
    80002fa6:	6946                	ld	s2,80(sp)
    80002fa8:	6a06                	ld	s4,64(sp)
    80002faa:	6ce2                	ld	s9,24(sp)
    80002fac:	6d42                	ld	s10,16(sp)
    80002fae:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fb0:	0009851b          	sext.w	a0,s3
    80002fb4:	69a6                	ld	s3,72(sp)
}
    80002fb6:	70a6                	ld	ra,104(sp)
    80002fb8:	7406                	ld	s0,96(sp)
    80002fba:	64e6                	ld	s1,88(sp)
    80002fbc:	7ae2                	ld	s5,56(sp)
    80002fbe:	7b42                	ld	s6,48(sp)
    80002fc0:	7ba2                	ld	s7,40(sp)
    80002fc2:	7c02                	ld	s8,32(sp)
    80002fc4:	6165                	addi	sp,sp,112
    80002fc6:	8082                	ret
    80002fc8:	6946                	ld	s2,80(sp)
    80002fca:	6a06                	ld	s4,64(sp)
    80002fcc:	6ce2                	ld	s9,24(sp)
    80002fce:	6d42                	ld	s10,16(sp)
    80002fd0:	6da2                	ld	s11,8(sp)
    80002fd2:	bff9                	j	80002fb0 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd4:	89da                	mv	s3,s6
    80002fd6:	bfe9                	j	80002fb0 <readi+0xd8>
    return 0;
    80002fd8:	4501                	li	a0,0
}
    80002fda:	8082                	ret

0000000080002fdc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fdc:	457c                	lw	a5,76(a0)
    80002fde:	10d7ef63          	bltu	a5,a3,800030fc <writei+0x120>
{
    80002fe2:	7159                	addi	sp,sp,-112
    80002fe4:	f486                	sd	ra,104(sp)
    80002fe6:	f0a2                	sd	s0,96(sp)
    80002fe8:	e8ca                	sd	s2,80(sp)
    80002fea:	fc56                	sd	s5,56(sp)
    80002fec:	f85a                	sd	s6,48(sp)
    80002fee:	f45e                	sd	s7,40(sp)
    80002ff0:	f062                	sd	s8,32(sp)
    80002ff2:	1880                	addi	s0,sp,112
    80002ff4:	8b2a                	mv	s6,a0
    80002ff6:	8c2e                	mv	s8,a1
    80002ff8:	8ab2                	mv	s5,a2
    80002ffa:	8936                	mv	s2,a3
    80002ffc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ffe:	9f35                	addw	a4,a4,a3
    80003000:	10d76063          	bltu	a4,a3,80003100 <writei+0x124>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003004:	040437b7          	lui	a5,0x4043
    80003008:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    8000300c:	0ee7ec63          	bltu	a5,a4,80003104 <writei+0x128>
    80003010:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003012:	0c0b8d63          	beqz	s7,800030ec <writei+0x110>
    80003016:	eca6                	sd	s1,88(sp)
    80003018:	e4ce                	sd	s3,72(sp)
    8000301a:	ec66                	sd	s9,24(sp)
    8000301c:	e86a                	sd	s10,16(sp)
    8000301e:	e46e                	sd	s11,8(sp)
    80003020:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003022:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003026:	5cfd                	li	s9,-1
    80003028:	a091                	j	8000306c <writei+0x90>
    8000302a:	02099d93          	slli	s11,s3,0x20
    8000302e:	020ddd93          	srli	s11,s11,0x20
    80003032:	05848513          	addi	a0,s1,88
    80003036:	86ee                	mv	a3,s11
    80003038:	8656                	mv	a2,s5
    8000303a:	85e2                	mv	a1,s8
    8000303c:	953a                	add	a0,a0,a4
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	8f8080e7          	jalr	-1800(ra) # 80001936 <either_copyin>
    80003046:	07950263          	beq	a0,s9,800030aa <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000304a:	8526                	mv	a0,s1
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	780080e7          	jalr	1920(ra) # 800037cc <log_write>
    brelse(bp);
    80003054:	8526                	mv	a0,s1
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	388080e7          	jalr	904(ra) # 800023de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305e:	01498a3b          	addw	s4,s3,s4
    80003062:	0129893b          	addw	s2,s3,s2
    80003066:	9aee                	add	s5,s5,s11
    80003068:	057a7663          	bgeu	s4,s7,800030b4 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000306c:	000b2483          	lw	s1,0(s6)
    80003070:	00a9559b          	srliw	a1,s2,0xa
    80003074:	855a                	mv	a0,s6
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	626080e7          	jalr	1574(ra) # 8000269c <bmap>
    8000307e:	0005059b          	sext.w	a1,a0
    80003082:	8526                	mv	a0,s1
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	22a080e7          	jalr	554(ra) # 800022ae <bread>
    8000308c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308e:	3ff97713          	andi	a4,s2,1023
    80003092:	40ed07bb          	subw	a5,s10,a4
    80003096:	414b86bb          	subw	a3,s7,s4
    8000309a:	89be                	mv	s3,a5
    8000309c:	2781                	sext.w	a5,a5
    8000309e:	0006861b          	sext.w	a2,a3
    800030a2:	f8f674e3          	bgeu	a2,a5,8000302a <writei+0x4e>
    800030a6:	89b6                	mv	s3,a3
    800030a8:	b749                	j	8000302a <writei+0x4e>
      brelse(bp);
    800030aa:	8526                	mv	a0,s1
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	332080e7          	jalr	818(ra) # 800023de <brelse>
  }

  if(off > ip->size)
    800030b4:	04cb2783          	lw	a5,76(s6)
    800030b8:	0327fc63          	bgeu	a5,s2,800030f0 <writei+0x114>
    ip->size = off;
    800030bc:	052b2623          	sw	s2,76(s6)
    800030c0:	64e6                	ld	s1,88(sp)
    800030c2:	69a6                	ld	s3,72(sp)
    800030c4:	6ce2                	ld	s9,24(sp)
    800030c6:	6d42                	ld	s10,16(sp)
    800030c8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030ca:	855a                	mv	a0,s6
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	9da080e7          	jalr	-1574(ra) # 80002aa6 <iupdate>

  return tot;
    800030d4:	000a051b          	sext.w	a0,s4
    800030d8:	6a06                	ld	s4,64(sp)
}
    800030da:	70a6                	ld	ra,104(sp)
    800030dc:	7406                	ld	s0,96(sp)
    800030de:	6946                	ld	s2,80(sp)
    800030e0:	7ae2                	ld	s5,56(sp)
    800030e2:	7b42                	ld	s6,48(sp)
    800030e4:	7ba2                	ld	s7,40(sp)
    800030e6:	7c02                	ld	s8,32(sp)
    800030e8:	6165                	addi	sp,sp,112
    800030ea:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ec:	8a5e                	mv	s4,s7
    800030ee:	bff1                	j	800030ca <writei+0xee>
    800030f0:	64e6                	ld	s1,88(sp)
    800030f2:	69a6                	ld	s3,72(sp)
    800030f4:	6ce2                	ld	s9,24(sp)
    800030f6:	6d42                	ld	s10,16(sp)
    800030f8:	6da2                	ld	s11,8(sp)
    800030fa:	bfc1                	j	800030ca <writei+0xee>
    return -1;
    800030fc:	557d                	li	a0,-1
}
    800030fe:	8082                	ret
    return -1;
    80003100:	557d                	li	a0,-1
    80003102:	bfe1                	j	800030da <writei+0xfe>
    return -1;
    80003104:	557d                	li	a0,-1
    80003106:	bfd1                	j	800030da <writei+0xfe>

0000000080003108 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003108:	1141                	addi	sp,sp,-16
    8000310a:	e406                	sd	ra,8(sp)
    8000310c:	e022                	sd	s0,0(sp)
    8000310e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003110:	4639                	li	a2,14
    80003112:	ffffd097          	auipc	ra,0xffffd
    80003116:	138080e7          	jalr	312(ra) # 8000024a <strncmp>
}
    8000311a:	60a2                	ld	ra,8(sp)
    8000311c:	6402                	ld	s0,0(sp)
    8000311e:	0141                	addi	sp,sp,16
    80003120:	8082                	ret

0000000080003122 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003122:	7139                	addi	sp,sp,-64
    80003124:	fc06                	sd	ra,56(sp)
    80003126:	f822                	sd	s0,48(sp)
    80003128:	f426                	sd	s1,40(sp)
    8000312a:	f04a                	sd	s2,32(sp)
    8000312c:	ec4e                	sd	s3,24(sp)
    8000312e:	e852                	sd	s4,16(sp)
    80003130:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003132:	04451703          	lh	a4,68(a0)
    80003136:	4785                	li	a5,1
    80003138:	00f71a63          	bne	a4,a5,8000314c <dirlookup+0x2a>
    8000313c:	892a                	mv	s2,a0
    8000313e:	89ae                	mv	s3,a1
    80003140:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003142:	457c                	lw	a5,76(a0)
    80003144:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003146:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003148:	e79d                	bnez	a5,80003176 <dirlookup+0x54>
    8000314a:	a8a5                	j	800031c2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000314c:	00005517          	auipc	a0,0x5
    80003150:	32450513          	addi	a0,a0,804 # 80008470 <etext+0x470>
    80003154:	00003097          	auipc	ra,0x3
    80003158:	dd8080e7          	jalr	-552(ra) # 80005f2c <panic>
      panic("dirlookup read");
    8000315c:	00005517          	auipc	a0,0x5
    80003160:	32c50513          	addi	a0,a0,812 # 80008488 <etext+0x488>
    80003164:	00003097          	auipc	ra,0x3
    80003168:	dc8080e7          	jalr	-568(ra) # 80005f2c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316c:	24c1                	addiw	s1,s1,16
    8000316e:	04c92783          	lw	a5,76(s2)
    80003172:	04f4f763          	bgeu	s1,a5,800031c0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003176:	4741                	li	a4,16
    80003178:	86a6                	mv	a3,s1
    8000317a:	fc040613          	addi	a2,s0,-64
    8000317e:	4581                	li	a1,0
    80003180:	854a                	mv	a0,s2
    80003182:	00000097          	auipc	ra,0x0
    80003186:	d56080e7          	jalr	-682(ra) # 80002ed8 <readi>
    8000318a:	47c1                	li	a5,16
    8000318c:	fcf518e3          	bne	a0,a5,8000315c <dirlookup+0x3a>
    if(de.inum == 0)
    80003190:	fc045783          	lhu	a5,-64(s0)
    80003194:	dfe1                	beqz	a5,8000316c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003196:	fc240593          	addi	a1,s0,-62
    8000319a:	854e                	mv	a0,s3
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	f6c080e7          	jalr	-148(ra) # 80003108 <namecmp>
    800031a4:	f561                	bnez	a0,8000316c <dirlookup+0x4a>
      if(poff)
    800031a6:	000a0463          	beqz	s4,800031ae <dirlookup+0x8c>
        *poff = off;
    800031aa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ae:	fc045583          	lhu	a1,-64(s0)
    800031b2:	00092503          	lw	a0,0(s2)
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	68c080e7          	jalr	1676(ra) # 80002842 <iget>
    800031be:	a011                	j	800031c2 <dirlookup+0xa0>
  return 0;
    800031c0:	4501                	li	a0,0
}
    800031c2:	70e2                	ld	ra,56(sp)
    800031c4:	7442                	ld	s0,48(sp)
    800031c6:	74a2                	ld	s1,40(sp)
    800031c8:	7902                	ld	s2,32(sp)
    800031ca:	69e2                	ld	s3,24(sp)
    800031cc:	6a42                	ld	s4,16(sp)
    800031ce:	6121                	addi	sp,sp,64
    800031d0:	8082                	ret

00000000800031d2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031d2:	711d                	addi	sp,sp,-96
    800031d4:	ec86                	sd	ra,88(sp)
    800031d6:	e8a2                	sd	s0,80(sp)
    800031d8:	e4a6                	sd	s1,72(sp)
    800031da:	e0ca                	sd	s2,64(sp)
    800031dc:	fc4e                	sd	s3,56(sp)
    800031de:	f852                	sd	s4,48(sp)
    800031e0:	f456                	sd	s5,40(sp)
    800031e2:	f05a                	sd	s6,32(sp)
    800031e4:	ec5e                	sd	s7,24(sp)
    800031e6:	e862                	sd	s8,16(sp)
    800031e8:	e466                	sd	s9,8(sp)
    800031ea:	1080                	addi	s0,sp,96
    800031ec:	84aa                	mv	s1,a0
    800031ee:	8b2e                	mv	s6,a1
    800031f0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031f2:	00054703          	lbu	a4,0(a0)
    800031f6:	02f00793          	li	a5,47
    800031fa:	02f70263          	beq	a4,a5,8000321e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031fe:	ffffe097          	auipc	ra,0xffffe
    80003202:	c7e080e7          	jalr	-898(ra) # 80000e7c <myproc>
    80003206:	15053503          	ld	a0,336(a0)
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	92a080e7          	jalr	-1750(ra) # 80002b34 <idup>
    80003212:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003214:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003218:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000321a:	4b85                	li	s7,1
    8000321c:	a875                	j	800032d8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000321e:	4585                	li	a1,1
    80003220:	4505                	li	a0,1
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	620080e7          	jalr	1568(ra) # 80002842 <iget>
    8000322a:	8a2a                	mv	s4,a0
    8000322c:	b7e5                	j	80003214 <namex+0x42>
      iunlockput(ip);
    8000322e:	8552                	mv	a0,s4
    80003230:	00000097          	auipc	ra,0x0
    80003234:	c56080e7          	jalr	-938(ra) # 80002e86 <iunlockput>
      return 0;
    80003238:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000323a:	8552                	mv	a0,s4
    8000323c:	60e6                	ld	ra,88(sp)
    8000323e:	6446                	ld	s0,80(sp)
    80003240:	64a6                	ld	s1,72(sp)
    80003242:	6906                	ld	s2,64(sp)
    80003244:	79e2                	ld	s3,56(sp)
    80003246:	7a42                	ld	s4,48(sp)
    80003248:	7aa2                	ld	s5,40(sp)
    8000324a:	7b02                	ld	s6,32(sp)
    8000324c:	6be2                	ld	s7,24(sp)
    8000324e:	6c42                	ld	s8,16(sp)
    80003250:	6ca2                	ld	s9,8(sp)
    80003252:	6125                	addi	sp,sp,96
    80003254:	8082                	ret
      iunlock(ip);
    80003256:	8552                	mv	a0,s4
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	9e0080e7          	jalr	-1568(ra) # 80002c38 <iunlock>
      return ip;
    80003260:	bfe9                	j	8000323a <namex+0x68>
      iunlockput(ip);
    80003262:	8552                	mv	a0,s4
    80003264:	00000097          	auipc	ra,0x0
    80003268:	c22080e7          	jalr	-990(ra) # 80002e86 <iunlockput>
      return 0;
    8000326c:	8a4e                	mv	s4,s3
    8000326e:	b7f1                	j	8000323a <namex+0x68>
  len = path - s;
    80003270:	40998633          	sub	a2,s3,s1
    80003274:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003278:	099c5863          	bge	s8,s9,80003308 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000327c:	4639                	li	a2,14
    8000327e:	85a6                	mv	a1,s1
    80003280:	8556                	mv	a0,s5
    80003282:	ffffd097          	auipc	ra,0xffffd
    80003286:	f54080e7          	jalr	-172(ra) # 800001d6 <memmove>
    8000328a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	01279763          	bne	a5,s2,8000329e <namex+0xcc>
    path++;
    80003294:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	ff278de3          	beq	a5,s2,80003294 <namex+0xc2>
    ilock(ip);
    8000329e:	8552                	mv	a0,s4
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	8d2080e7          	jalr	-1838(ra) # 80002b72 <ilock>
    if(ip->type != T_DIR){
    800032a8:	044a1783          	lh	a5,68(s4)
    800032ac:	f97791e3          	bne	a5,s7,8000322e <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032b0:	000b0563          	beqz	s6,800032ba <namex+0xe8>
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	dfd9                	beqz	a5,80003256 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ba:	4601                	li	a2,0
    800032bc:	85d6                	mv	a1,s5
    800032be:	8552                	mv	a0,s4
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	e62080e7          	jalr	-414(ra) # 80003122 <dirlookup>
    800032c8:	89aa                	mv	s3,a0
    800032ca:	dd41                	beqz	a0,80003262 <namex+0x90>
    iunlockput(ip);
    800032cc:	8552                	mv	a0,s4
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	bb8080e7          	jalr	-1096(ra) # 80002e86 <iunlockput>
    ip = next;
    800032d6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	01279763          	bne	a5,s2,800032ea <namex+0x118>
    path++;
    800032e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e2:	0004c783          	lbu	a5,0(s1)
    800032e6:	ff278de3          	beq	a5,s2,800032e0 <namex+0x10e>
  if(*path == 0)
    800032ea:	cb9d                	beqz	a5,80003320 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032ec:	0004c783          	lbu	a5,0(s1)
    800032f0:	89a6                	mv	s3,s1
  len = path - s;
    800032f2:	4c81                	li	s9,0
    800032f4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032f6:	01278963          	beq	a5,s2,80003308 <namex+0x136>
    800032fa:	dbbd                	beqz	a5,80003270 <namex+0x9e>
    path++;
    800032fc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032fe:	0009c783          	lbu	a5,0(s3)
    80003302:	ff279ce3          	bne	a5,s2,800032fa <namex+0x128>
    80003306:	b7ad                	j	80003270 <namex+0x9e>
    memmove(name, s, len);
    80003308:	2601                	sext.w	a2,a2
    8000330a:	85a6                	mv	a1,s1
    8000330c:	8556                	mv	a0,s5
    8000330e:	ffffd097          	auipc	ra,0xffffd
    80003312:	ec8080e7          	jalr	-312(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003316:	9cd6                	add	s9,s9,s5
    80003318:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000331c:	84ce                	mv	s1,s3
    8000331e:	b7bd                	j	8000328c <namex+0xba>
  if(nameiparent){
    80003320:	f00b0de3          	beqz	s6,8000323a <namex+0x68>
    iput(ip);
    80003324:	8552                	mv	a0,s4
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	ab8080e7          	jalr	-1352(ra) # 80002dde <iput>
    return 0;
    8000332e:	4a01                	li	s4,0
    80003330:	b729                	j	8000323a <namex+0x68>

0000000080003332 <dirlink>:
{
    80003332:	7139                	addi	sp,sp,-64
    80003334:	fc06                	sd	ra,56(sp)
    80003336:	f822                	sd	s0,48(sp)
    80003338:	f04a                	sd	s2,32(sp)
    8000333a:	ec4e                	sd	s3,24(sp)
    8000333c:	e852                	sd	s4,16(sp)
    8000333e:	0080                	addi	s0,sp,64
    80003340:	892a                	mv	s2,a0
    80003342:	8a2e                	mv	s4,a1
    80003344:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003346:	4601                	li	a2,0
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	dda080e7          	jalr	-550(ra) # 80003122 <dirlookup>
    80003350:	ed25                	bnez	a0,800033c8 <dirlink+0x96>
    80003352:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003354:	04c92483          	lw	s1,76(s2)
    80003358:	c49d                	beqz	s1,80003386 <dirlink+0x54>
    8000335a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335c:	4741                	li	a4,16
    8000335e:	86a6                	mv	a3,s1
    80003360:	fc040613          	addi	a2,s0,-64
    80003364:	4581                	li	a1,0
    80003366:	854a                	mv	a0,s2
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	b70080e7          	jalr	-1168(ra) # 80002ed8 <readi>
    80003370:	47c1                	li	a5,16
    80003372:	06f51163          	bne	a0,a5,800033d4 <dirlink+0xa2>
    if(de.inum == 0)
    80003376:	fc045783          	lhu	a5,-64(s0)
    8000337a:	c791                	beqz	a5,80003386 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337c:	24c1                	addiw	s1,s1,16
    8000337e:	04c92783          	lw	a5,76(s2)
    80003382:	fcf4ede3          	bltu	s1,a5,8000335c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003386:	4639                	li	a2,14
    80003388:	85d2                	mv	a1,s4
    8000338a:	fc240513          	addi	a0,s0,-62
    8000338e:	ffffd097          	auipc	ra,0xffffd
    80003392:	ef2080e7          	jalr	-270(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003396:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339a:	4741                	li	a4,16
    8000339c:	86a6                	mv	a3,s1
    8000339e:	fc040613          	addi	a2,s0,-64
    800033a2:	4581                	li	a1,0
    800033a4:	854a                	mv	a0,s2
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	c36080e7          	jalr	-970(ra) # 80002fdc <writei>
    800033ae:	872a                	mv	a4,a0
    800033b0:	47c1                	li	a5,16
  return 0;
    800033b2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b4:	02f71863          	bne	a4,a5,800033e4 <dirlink+0xb2>
    800033b8:	74a2                	ld	s1,40(sp)
}
    800033ba:	70e2                	ld	ra,56(sp)
    800033bc:	7442                	ld	s0,48(sp)
    800033be:	7902                	ld	s2,32(sp)
    800033c0:	69e2                	ld	s3,24(sp)
    800033c2:	6a42                	ld	s4,16(sp)
    800033c4:	6121                	addi	sp,sp,64
    800033c6:	8082                	ret
    iput(ip);
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	a16080e7          	jalr	-1514(ra) # 80002dde <iput>
    return -1;
    800033d0:	557d                	li	a0,-1
    800033d2:	b7e5                	j	800033ba <dirlink+0x88>
      panic("dirlink read");
    800033d4:	00005517          	auipc	a0,0x5
    800033d8:	0c450513          	addi	a0,a0,196 # 80008498 <etext+0x498>
    800033dc:	00003097          	auipc	ra,0x3
    800033e0:	b50080e7          	jalr	-1200(ra) # 80005f2c <panic>
    panic("dirlink");
    800033e4:	00005517          	auipc	a0,0x5
    800033e8:	1c450513          	addi	a0,a0,452 # 800085a8 <etext+0x5a8>
    800033ec:	00003097          	auipc	ra,0x3
    800033f0:	b40080e7          	jalr	-1216(ra) # 80005f2c <panic>

00000000800033f4 <namei>:

struct inode*
namei(char *path)
{
    800033f4:	1101                	addi	sp,sp,-32
    800033f6:	ec06                	sd	ra,24(sp)
    800033f8:	e822                	sd	s0,16(sp)
    800033fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033fc:	fe040613          	addi	a2,s0,-32
    80003400:	4581                	li	a1,0
    80003402:	00000097          	auipc	ra,0x0
    80003406:	dd0080e7          	jalr	-560(ra) # 800031d2 <namex>
}
    8000340a:	60e2                	ld	ra,24(sp)
    8000340c:	6442                	ld	s0,16(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret

0000000080003412 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003412:	1141                	addi	sp,sp,-16
    80003414:	e406                	sd	ra,8(sp)
    80003416:	e022                	sd	s0,0(sp)
    80003418:	0800                	addi	s0,sp,16
    8000341a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000341c:	4585                	li	a1,1
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	db4080e7          	jalr	-588(ra) # 800031d2 <namex>
}
    80003426:	60a2                	ld	ra,8(sp)
    80003428:	6402                	ld	s0,0(sp)
    8000342a:	0141                	addi	sp,sp,16
    8000342c:	8082                	ret

000000008000342e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000342e:	1101                	addi	sp,sp,-32
    80003430:	ec06                	sd	ra,24(sp)
    80003432:	e822                	sd	s0,16(sp)
    80003434:	e426                	sd	s1,8(sp)
    80003436:	e04a                	sd	s2,0(sp)
    80003438:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000343a:	00014917          	auipc	s2,0x14
    8000343e:	ff690913          	addi	s2,s2,-10 # 80017430 <log>
    80003442:	01892583          	lw	a1,24(s2)
    80003446:	02892503          	lw	a0,40(s2)
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	e64080e7          	jalr	-412(ra) # 800022ae <bread>
    80003452:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003454:	02c92603          	lw	a2,44(s2)
    80003458:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000345a:	00c05f63          	blez	a2,80003478 <write_head+0x4a>
    8000345e:	00014717          	auipc	a4,0x14
    80003462:	00270713          	addi	a4,a4,2 # 80017460 <log+0x30>
    80003466:	87aa                	mv	a5,a0
    80003468:	060a                	slli	a2,a2,0x2
    8000346a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000346c:	4314                	lw	a3,0(a4)
    8000346e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003470:	0711                	addi	a4,a4,4
    80003472:	0791                	addi	a5,a5,4
    80003474:	fec79ce3          	bne	a5,a2,8000346c <write_head+0x3e>
  }
  bwrite(buf);
    80003478:	8526                	mv	a0,s1
    8000347a:	fffff097          	auipc	ra,0xfffff
    8000347e:	f26080e7          	jalr	-218(ra) # 800023a0 <bwrite>
  brelse(buf);
    80003482:	8526                	mv	a0,s1
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	f5a080e7          	jalr	-166(ra) # 800023de <brelse>
}
    8000348c:	60e2                	ld	ra,24(sp)
    8000348e:	6442                	ld	s0,16(sp)
    80003490:	64a2                	ld	s1,8(sp)
    80003492:	6902                	ld	s2,0(sp)
    80003494:	6105                	addi	sp,sp,32
    80003496:	8082                	ret

0000000080003498 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003498:	00014797          	auipc	a5,0x14
    8000349c:	fc47a783          	lw	a5,-60(a5) # 8001745c <log+0x2c>
    800034a0:	0af05d63          	blez	a5,8000355a <install_trans+0xc2>
{
    800034a4:	7139                	addi	sp,sp,-64
    800034a6:	fc06                	sd	ra,56(sp)
    800034a8:	f822                	sd	s0,48(sp)
    800034aa:	f426                	sd	s1,40(sp)
    800034ac:	f04a                	sd	s2,32(sp)
    800034ae:	ec4e                	sd	s3,24(sp)
    800034b0:	e852                	sd	s4,16(sp)
    800034b2:	e456                	sd	s5,8(sp)
    800034b4:	e05a                	sd	s6,0(sp)
    800034b6:	0080                	addi	s0,sp,64
    800034b8:	8b2a                	mv	s6,a0
    800034ba:	00014a97          	auipc	s5,0x14
    800034be:	fa6a8a93          	addi	s5,s5,-90 # 80017460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c4:	00014997          	auipc	s3,0x14
    800034c8:	f6c98993          	addi	s3,s3,-148 # 80017430 <log>
    800034cc:	a00d                	j	800034ee <install_trans+0x56>
    brelse(lbuf);
    800034ce:	854a                	mv	a0,s2
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	f0e080e7          	jalr	-242(ra) # 800023de <brelse>
    brelse(dbuf);
    800034d8:	8526                	mv	a0,s1
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	f04080e7          	jalr	-252(ra) # 800023de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e2:	2a05                	addiw	s4,s4,1
    800034e4:	0a91                	addi	s5,s5,4
    800034e6:	02c9a783          	lw	a5,44(s3)
    800034ea:	04fa5e63          	bge	s4,a5,80003546 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ee:	0189a583          	lw	a1,24(s3)
    800034f2:	014585bb          	addw	a1,a1,s4
    800034f6:	2585                	addiw	a1,a1,1
    800034f8:	0289a503          	lw	a0,40(s3)
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	db2080e7          	jalr	-590(ra) # 800022ae <bread>
    80003504:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003506:	000aa583          	lw	a1,0(s5)
    8000350a:	0289a503          	lw	a0,40(s3)
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	da0080e7          	jalr	-608(ra) # 800022ae <bread>
    80003516:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003518:	40000613          	li	a2,1024
    8000351c:	05890593          	addi	a1,s2,88
    80003520:	05850513          	addi	a0,a0,88
    80003524:	ffffd097          	auipc	ra,0xffffd
    80003528:	cb2080e7          	jalr	-846(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000352c:	8526                	mv	a0,s1
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	e72080e7          	jalr	-398(ra) # 800023a0 <bwrite>
    if(recovering == 0)
    80003536:	f80b1ce3          	bnez	s6,800034ce <install_trans+0x36>
      bunpin(dbuf);
    8000353a:	8526                	mv	a0,s1
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	f7a080e7          	jalr	-134(ra) # 800024b6 <bunpin>
    80003544:	b769                	j	800034ce <install_trans+0x36>
}
    80003546:	70e2                	ld	ra,56(sp)
    80003548:	7442                	ld	s0,48(sp)
    8000354a:	74a2                	ld	s1,40(sp)
    8000354c:	7902                	ld	s2,32(sp)
    8000354e:	69e2                	ld	s3,24(sp)
    80003550:	6a42                	ld	s4,16(sp)
    80003552:	6aa2                	ld	s5,8(sp)
    80003554:	6b02                	ld	s6,0(sp)
    80003556:	6121                	addi	sp,sp,64
    80003558:	8082                	ret
    8000355a:	8082                	ret

000000008000355c <initlog>:
{
    8000355c:	7179                	addi	sp,sp,-48
    8000355e:	f406                	sd	ra,40(sp)
    80003560:	f022                	sd	s0,32(sp)
    80003562:	ec26                	sd	s1,24(sp)
    80003564:	e84a                	sd	s2,16(sp)
    80003566:	e44e                	sd	s3,8(sp)
    80003568:	1800                	addi	s0,sp,48
    8000356a:	892a                	mv	s2,a0
    8000356c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000356e:	00014497          	auipc	s1,0x14
    80003572:	ec248493          	addi	s1,s1,-318 # 80017430 <log>
    80003576:	00005597          	auipc	a1,0x5
    8000357a:	f3258593          	addi	a1,a1,-206 # 800084a8 <etext+0x4a8>
    8000357e:	8526                	mv	a0,s1
    80003580:	00003097          	auipc	ra,0x3
    80003584:	e96080e7          	jalr	-362(ra) # 80006416 <initlock>
  log.start = sb->logstart;
    80003588:	0149a583          	lw	a1,20(s3)
    8000358c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000358e:	0109a783          	lw	a5,16(s3)
    80003592:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003594:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003598:	854a                	mv	a0,s2
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	d14080e7          	jalr	-748(ra) # 800022ae <bread>
  log.lh.n = lh->n;
    800035a2:	4d30                	lw	a2,88(a0)
    800035a4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035a6:	00c05f63          	blez	a2,800035c4 <initlog+0x68>
    800035aa:	87aa                	mv	a5,a0
    800035ac:	00014717          	auipc	a4,0x14
    800035b0:	eb470713          	addi	a4,a4,-332 # 80017460 <log+0x30>
    800035b4:	060a                	slli	a2,a2,0x2
    800035b6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035b8:	4ff4                	lw	a3,92(a5)
    800035ba:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035bc:	0791                	addi	a5,a5,4
    800035be:	0711                	addi	a4,a4,4
    800035c0:	fec79ce3          	bne	a5,a2,800035b8 <initlog+0x5c>
  brelse(buf);
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	e1a080e7          	jalr	-486(ra) # 800023de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035cc:	4505                	li	a0,1
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	eca080e7          	jalr	-310(ra) # 80003498 <install_trans>
  log.lh.n = 0;
    800035d6:	00014797          	auipc	a5,0x14
    800035da:	e807a323          	sw	zero,-378(a5) # 8001745c <log+0x2c>
  write_head(); // clear the log
    800035de:	00000097          	auipc	ra,0x0
    800035e2:	e50080e7          	jalr	-432(ra) # 8000342e <write_head>
}
    800035e6:	70a2                	ld	ra,40(sp)
    800035e8:	7402                	ld	s0,32(sp)
    800035ea:	64e2                	ld	s1,24(sp)
    800035ec:	6942                	ld	s2,16(sp)
    800035ee:	69a2                	ld	s3,8(sp)
    800035f0:	6145                	addi	sp,sp,48
    800035f2:	8082                	ret

00000000800035f4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f4:	1101                	addi	sp,sp,-32
    800035f6:	ec06                	sd	ra,24(sp)
    800035f8:	e822                	sd	s0,16(sp)
    800035fa:	e426                	sd	s1,8(sp)
    800035fc:	e04a                	sd	s2,0(sp)
    800035fe:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003600:	00014517          	auipc	a0,0x14
    80003604:	e3050513          	addi	a0,a0,-464 # 80017430 <log>
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	e9e080e7          	jalr	-354(ra) # 800064a6 <acquire>
  while(1){
    if(log.committing){
    80003610:	00014497          	auipc	s1,0x14
    80003614:	e2048493          	addi	s1,s1,-480 # 80017430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003618:	4979                	li	s2,30
    8000361a:	a039                	j	80003628 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000361c:	85a6                	mv	a1,s1
    8000361e:	8526                	mv	a0,s1
    80003620:	ffffe097          	auipc	ra,0xffffe
    80003624:	f22080e7          	jalr	-222(ra) # 80001542 <sleep>
    if(log.committing){
    80003628:	50dc                	lw	a5,36(s1)
    8000362a:	fbed                	bnez	a5,8000361c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362c:	5098                	lw	a4,32(s1)
    8000362e:	2705                	addiw	a4,a4,1
    80003630:	0027179b          	slliw	a5,a4,0x2
    80003634:	9fb9                	addw	a5,a5,a4
    80003636:	0017979b          	slliw	a5,a5,0x1
    8000363a:	54d4                	lw	a3,44(s1)
    8000363c:	9fb5                	addw	a5,a5,a3
    8000363e:	00f95963          	bge	s2,a5,80003650 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003642:	85a6                	mv	a1,s1
    80003644:	8526                	mv	a0,s1
    80003646:	ffffe097          	auipc	ra,0xffffe
    8000364a:	efc080e7          	jalr	-260(ra) # 80001542 <sleep>
    8000364e:	bfe9                	j	80003628 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003650:	00014517          	auipc	a0,0x14
    80003654:	de050513          	addi	a0,a0,-544 # 80017430 <log>
    80003658:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000365a:	00003097          	auipc	ra,0x3
    8000365e:	f00080e7          	jalr	-256(ra) # 8000655a <release>
      break;
    }
  }
}
    80003662:	60e2                	ld	ra,24(sp)
    80003664:	6442                	ld	s0,16(sp)
    80003666:	64a2                	ld	s1,8(sp)
    80003668:	6902                	ld	s2,0(sp)
    8000366a:	6105                	addi	sp,sp,32
    8000366c:	8082                	ret

000000008000366e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000366e:	7139                	addi	sp,sp,-64
    80003670:	fc06                	sd	ra,56(sp)
    80003672:	f822                	sd	s0,48(sp)
    80003674:	f426                	sd	s1,40(sp)
    80003676:	f04a                	sd	s2,32(sp)
    80003678:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367a:	00014497          	auipc	s1,0x14
    8000367e:	db648493          	addi	s1,s1,-586 # 80017430 <log>
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	e22080e7          	jalr	-478(ra) # 800064a6 <acquire>
  log.outstanding -= 1;
    8000368c:	509c                	lw	a5,32(s1)
    8000368e:	37fd                	addiw	a5,a5,-1
    80003690:	0007891b          	sext.w	s2,a5
    80003694:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003696:	50dc                	lw	a5,36(s1)
    80003698:	e7b9                	bnez	a5,800036e6 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000369a:	06091163          	bnez	s2,800036fc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000369e:	00014497          	auipc	s1,0x14
    800036a2:	d9248493          	addi	s1,s1,-622 # 80017430 <log>
    800036a6:	4785                	li	a5,1
    800036a8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036aa:	8526                	mv	a0,s1
    800036ac:	00003097          	auipc	ra,0x3
    800036b0:	eae080e7          	jalr	-338(ra) # 8000655a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036b4:	54dc                	lw	a5,44(s1)
    800036b6:	06f04763          	bgtz	a5,80003724 <end_op+0xb6>
    acquire(&log.lock);
    800036ba:	00014497          	auipc	s1,0x14
    800036be:	d7648493          	addi	s1,s1,-650 # 80017430 <log>
    800036c2:	8526                	mv	a0,s1
    800036c4:	00003097          	auipc	ra,0x3
    800036c8:	de2080e7          	jalr	-542(ra) # 800064a6 <acquire>
    log.committing = 0;
    800036cc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d0:	8526                	mv	a0,s1
    800036d2:	ffffe097          	auipc	ra,0xffffe
    800036d6:	ffc080e7          	jalr	-4(ra) # 800016ce <wakeup>
    release(&log.lock);
    800036da:	8526                	mv	a0,s1
    800036dc:	00003097          	auipc	ra,0x3
    800036e0:	e7e080e7          	jalr	-386(ra) # 8000655a <release>
}
    800036e4:	a815                	j	80003718 <end_op+0xaa>
    800036e6:	ec4e                	sd	s3,24(sp)
    800036e8:	e852                	sd	s4,16(sp)
    800036ea:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036ec:	00005517          	auipc	a0,0x5
    800036f0:	dc450513          	addi	a0,a0,-572 # 800084b0 <etext+0x4b0>
    800036f4:	00003097          	auipc	ra,0x3
    800036f8:	838080e7          	jalr	-1992(ra) # 80005f2c <panic>
    wakeup(&log);
    800036fc:	00014497          	auipc	s1,0x14
    80003700:	d3448493          	addi	s1,s1,-716 # 80017430 <log>
    80003704:	8526                	mv	a0,s1
    80003706:	ffffe097          	auipc	ra,0xffffe
    8000370a:	fc8080e7          	jalr	-56(ra) # 800016ce <wakeup>
  release(&log.lock);
    8000370e:	8526                	mv	a0,s1
    80003710:	00003097          	auipc	ra,0x3
    80003714:	e4a080e7          	jalr	-438(ra) # 8000655a <release>
}
    80003718:	70e2                	ld	ra,56(sp)
    8000371a:	7442                	ld	s0,48(sp)
    8000371c:	74a2                	ld	s1,40(sp)
    8000371e:	7902                	ld	s2,32(sp)
    80003720:	6121                	addi	sp,sp,64
    80003722:	8082                	ret
    80003724:	ec4e                	sd	s3,24(sp)
    80003726:	e852                	sd	s4,16(sp)
    80003728:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372a:	00014a97          	auipc	s5,0x14
    8000372e:	d36a8a93          	addi	s5,s5,-714 # 80017460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003732:	00014a17          	auipc	s4,0x14
    80003736:	cfea0a13          	addi	s4,s4,-770 # 80017430 <log>
    8000373a:	018a2583          	lw	a1,24(s4)
    8000373e:	012585bb          	addw	a1,a1,s2
    80003742:	2585                	addiw	a1,a1,1
    80003744:	028a2503          	lw	a0,40(s4)
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	b66080e7          	jalr	-1178(ra) # 800022ae <bread>
    80003750:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003752:	000aa583          	lw	a1,0(s5)
    80003756:	028a2503          	lw	a0,40(s4)
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	b54080e7          	jalr	-1196(ra) # 800022ae <bread>
    80003762:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003764:	40000613          	li	a2,1024
    80003768:	05850593          	addi	a1,a0,88
    8000376c:	05848513          	addi	a0,s1,88
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	a66080e7          	jalr	-1434(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003778:	8526                	mv	a0,s1
    8000377a:	fffff097          	auipc	ra,0xfffff
    8000377e:	c26080e7          	jalr	-986(ra) # 800023a0 <bwrite>
    brelse(from);
    80003782:	854e                	mv	a0,s3
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	c5a080e7          	jalr	-934(ra) # 800023de <brelse>
    brelse(to);
    8000378c:	8526                	mv	a0,s1
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	c50080e7          	jalr	-944(ra) # 800023de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003796:	2905                	addiw	s2,s2,1
    80003798:	0a91                	addi	s5,s5,4
    8000379a:	02ca2783          	lw	a5,44(s4)
    8000379e:	f8f94ee3          	blt	s2,a5,8000373a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	c8c080e7          	jalr	-884(ra) # 8000342e <write_head>
    install_trans(0); // Now install writes to home locations
    800037aa:	4501                	li	a0,0
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	cec080e7          	jalr	-788(ra) # 80003498 <install_trans>
    log.lh.n = 0;
    800037b4:	00014797          	auipc	a5,0x14
    800037b8:	ca07a423          	sw	zero,-856(a5) # 8001745c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	c72080e7          	jalr	-910(ra) # 8000342e <write_head>
    800037c4:	69e2                	ld	s3,24(sp)
    800037c6:	6a42                	ld	s4,16(sp)
    800037c8:	6aa2                	ld	s5,8(sp)
    800037ca:	bdc5                	j	800036ba <end_op+0x4c>

00000000800037cc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037cc:	1101                	addi	sp,sp,-32
    800037ce:	ec06                	sd	ra,24(sp)
    800037d0:	e822                	sd	s0,16(sp)
    800037d2:	e426                	sd	s1,8(sp)
    800037d4:	e04a                	sd	s2,0(sp)
    800037d6:	1000                	addi	s0,sp,32
    800037d8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037da:	00014917          	auipc	s2,0x14
    800037de:	c5690913          	addi	s2,s2,-938 # 80017430 <log>
    800037e2:	854a                	mv	a0,s2
    800037e4:	00003097          	auipc	ra,0x3
    800037e8:	cc2080e7          	jalr	-830(ra) # 800064a6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ec:	02c92603          	lw	a2,44(s2)
    800037f0:	47f5                	li	a5,29
    800037f2:	06c7c563          	blt	a5,a2,8000385c <log_write+0x90>
    800037f6:	00014797          	auipc	a5,0x14
    800037fa:	c567a783          	lw	a5,-938(a5) # 8001744c <log+0x1c>
    800037fe:	37fd                	addiw	a5,a5,-1
    80003800:	04f65e63          	bge	a2,a5,8000385c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003804:	00014797          	auipc	a5,0x14
    80003808:	c4c7a783          	lw	a5,-948(a5) # 80017450 <log+0x20>
    8000380c:	06f05063          	blez	a5,8000386c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003810:	4781                	li	a5,0
    80003812:	06c05563          	blez	a2,8000387c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003816:	44cc                	lw	a1,12(s1)
    80003818:	00014717          	auipc	a4,0x14
    8000381c:	c4870713          	addi	a4,a4,-952 # 80017460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003820:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003822:	4314                	lw	a3,0(a4)
    80003824:	04b68c63          	beq	a3,a1,8000387c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003828:	2785                	addiw	a5,a5,1
    8000382a:	0711                	addi	a4,a4,4
    8000382c:	fef61be3          	bne	a2,a5,80003822 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003830:	0621                	addi	a2,a2,8
    80003832:	060a                	slli	a2,a2,0x2
    80003834:	00014797          	auipc	a5,0x14
    80003838:	bfc78793          	addi	a5,a5,-1028 # 80017430 <log>
    8000383c:	97b2                	add	a5,a5,a2
    8000383e:	44d8                	lw	a4,12(s1)
    80003840:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003842:	8526                	mv	a0,s1
    80003844:	fffff097          	auipc	ra,0xfffff
    80003848:	c36080e7          	jalr	-970(ra) # 8000247a <bpin>
    log.lh.n++;
    8000384c:	00014717          	auipc	a4,0x14
    80003850:	be470713          	addi	a4,a4,-1052 # 80017430 <log>
    80003854:	575c                	lw	a5,44(a4)
    80003856:	2785                	addiw	a5,a5,1
    80003858:	d75c                	sw	a5,44(a4)
    8000385a:	a82d                	j	80003894 <log_write+0xc8>
    panic("too big a transaction");
    8000385c:	00005517          	auipc	a0,0x5
    80003860:	c6450513          	addi	a0,a0,-924 # 800084c0 <etext+0x4c0>
    80003864:	00002097          	auipc	ra,0x2
    80003868:	6c8080e7          	jalr	1736(ra) # 80005f2c <panic>
    panic("log_write outside of trans");
    8000386c:	00005517          	auipc	a0,0x5
    80003870:	c6c50513          	addi	a0,a0,-916 # 800084d8 <etext+0x4d8>
    80003874:	00002097          	auipc	ra,0x2
    80003878:	6b8080e7          	jalr	1720(ra) # 80005f2c <panic>
  log.lh.block[i] = b->blockno;
    8000387c:	00878693          	addi	a3,a5,8
    80003880:	068a                	slli	a3,a3,0x2
    80003882:	00014717          	auipc	a4,0x14
    80003886:	bae70713          	addi	a4,a4,-1106 # 80017430 <log>
    8000388a:	9736                	add	a4,a4,a3
    8000388c:	44d4                	lw	a3,12(s1)
    8000388e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003890:	faf609e3          	beq	a2,a5,80003842 <log_write+0x76>
  }
  release(&log.lock);
    80003894:	00014517          	auipc	a0,0x14
    80003898:	b9c50513          	addi	a0,a0,-1124 # 80017430 <log>
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	cbe080e7          	jalr	-834(ra) # 8000655a <release>
}
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6902                	ld	s2,0(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
    800038bc:	84aa                	mv	s1,a0
    800038be:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038c0:	00005597          	auipc	a1,0x5
    800038c4:	c3858593          	addi	a1,a1,-968 # 800084f8 <etext+0x4f8>
    800038c8:	0521                	addi	a0,a0,8
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	b4c080e7          	jalr	-1204(ra) # 80006416 <initlock>
  lk->name = name;
    800038d2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038da:	0204a423          	sw	zero,40(s1)
}
    800038de:	60e2                	ld	ra,24(sp)
    800038e0:	6442                	ld	s0,16(sp)
    800038e2:	64a2                	ld	s1,8(sp)
    800038e4:	6902                	ld	s2,0(sp)
    800038e6:	6105                	addi	sp,sp,32
    800038e8:	8082                	ret

00000000800038ea <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ea:	1101                	addi	sp,sp,-32
    800038ec:	ec06                	sd	ra,24(sp)
    800038ee:	e822                	sd	s0,16(sp)
    800038f0:	e426                	sd	s1,8(sp)
    800038f2:	e04a                	sd	s2,0(sp)
    800038f4:	1000                	addi	s0,sp,32
    800038f6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f8:	00850913          	addi	s2,a0,8
    800038fc:	854a                	mv	a0,s2
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	ba8080e7          	jalr	-1112(ra) # 800064a6 <acquire>
  while (lk->locked) {
    80003906:	409c                	lw	a5,0(s1)
    80003908:	cb89                	beqz	a5,8000391a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000390a:	85ca                	mv	a1,s2
    8000390c:	8526                	mv	a0,s1
    8000390e:	ffffe097          	auipc	ra,0xffffe
    80003912:	c34080e7          	jalr	-972(ra) # 80001542 <sleep>
  while (lk->locked) {
    80003916:	409c                	lw	a5,0(s1)
    80003918:	fbed                	bnez	a5,8000390a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000391a:	4785                	li	a5,1
    8000391c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000391e:	ffffd097          	auipc	ra,0xffffd
    80003922:	55e080e7          	jalr	1374(ra) # 80000e7c <myproc>
    80003926:	591c                	lw	a5,48(a0)
    80003928:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000392a:	854a                	mv	a0,s2
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	c2e080e7          	jalr	-978(ra) # 8000655a <release>
}
    80003934:	60e2                	ld	ra,24(sp)
    80003936:	6442                	ld	s0,16(sp)
    80003938:	64a2                	ld	s1,8(sp)
    8000393a:	6902                	ld	s2,0(sp)
    8000393c:	6105                	addi	sp,sp,32
    8000393e:	8082                	ret

0000000080003940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	e04a                	sd	s2,0(sp)
    8000394a:	1000                	addi	s0,sp,32
    8000394c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000394e:	00850913          	addi	s2,a0,8
    80003952:	854a                	mv	a0,s2
    80003954:	00003097          	auipc	ra,0x3
    80003958:	b52080e7          	jalr	-1198(ra) # 800064a6 <acquire>
  lk->locked = 0;
    8000395c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003960:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003964:	8526                	mv	a0,s1
    80003966:	ffffe097          	auipc	ra,0xffffe
    8000396a:	d68080e7          	jalr	-664(ra) # 800016ce <wakeup>
  release(&lk->lk);
    8000396e:	854a                	mv	a0,s2
    80003970:	00003097          	auipc	ra,0x3
    80003974:	bea080e7          	jalr	-1046(ra) # 8000655a <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6902                	ld	s2,0(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret

0000000080003984 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003984:	7179                	addi	sp,sp,-48
    80003986:	f406                	sd	ra,40(sp)
    80003988:	f022                	sd	s0,32(sp)
    8000398a:	ec26                	sd	s1,24(sp)
    8000398c:	e84a                	sd	s2,16(sp)
    8000398e:	1800                	addi	s0,sp,48
    80003990:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003992:	00850913          	addi	s2,a0,8
    80003996:	854a                	mv	a0,s2
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	b0e080e7          	jalr	-1266(ra) # 800064a6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a0:	409c                	lw	a5,0(s1)
    800039a2:	ef91                	bnez	a5,800039be <holdingsleep+0x3a>
    800039a4:	4481                	li	s1,0
  release(&lk->lk);
    800039a6:	854a                	mv	a0,s2
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	bb2080e7          	jalr	-1102(ra) # 8000655a <release>
  return r;
}
    800039b0:	8526                	mv	a0,s1
    800039b2:	70a2                	ld	ra,40(sp)
    800039b4:	7402                	ld	s0,32(sp)
    800039b6:	64e2                	ld	s1,24(sp)
    800039b8:	6942                	ld	s2,16(sp)
    800039ba:	6145                	addi	sp,sp,48
    800039bc:	8082                	ret
    800039be:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c0:	0284a983          	lw	s3,40(s1)
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	4b8080e7          	jalr	1208(ra) # 80000e7c <myproc>
    800039cc:	5904                	lw	s1,48(a0)
    800039ce:	413484b3          	sub	s1,s1,s3
    800039d2:	0014b493          	seqz	s1,s1
    800039d6:	69a2                	ld	s3,8(sp)
    800039d8:	b7f9                	j	800039a6 <holdingsleep+0x22>

00000000800039da <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039da:	1141                	addi	sp,sp,-16
    800039dc:	e406                	sd	ra,8(sp)
    800039de:	e022                	sd	s0,0(sp)
    800039e0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039e2:	00005597          	auipc	a1,0x5
    800039e6:	b2658593          	addi	a1,a1,-1242 # 80008508 <etext+0x508>
    800039ea:	00014517          	auipc	a0,0x14
    800039ee:	b8e50513          	addi	a0,a0,-1138 # 80017578 <ftable>
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	a24080e7          	jalr	-1500(ra) # 80006416 <initlock>
}
    800039fa:	60a2                	ld	ra,8(sp)
    800039fc:	6402                	ld	s0,0(sp)
    800039fe:	0141                	addi	sp,sp,16
    80003a00:	8082                	ret

0000000080003a02 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a02:	1101                	addi	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a0c:	00014517          	auipc	a0,0x14
    80003a10:	b6c50513          	addi	a0,a0,-1172 # 80017578 <ftable>
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	a92080e7          	jalr	-1390(ra) # 800064a6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a1c:	00014497          	auipc	s1,0x14
    80003a20:	b7448493          	addi	s1,s1,-1164 # 80017590 <ftable+0x18>
    80003a24:	00015717          	auipc	a4,0x15
    80003a28:	b0c70713          	addi	a4,a4,-1268 # 80018530 <ftable+0xfb8>
    if(f->ref == 0){
    80003a2c:	40dc                	lw	a5,4(s1)
    80003a2e:	cf99                	beqz	a5,80003a4c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a30:	02848493          	addi	s1,s1,40
    80003a34:	fee49ce3          	bne	s1,a4,80003a2c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a38:	00014517          	auipc	a0,0x14
    80003a3c:	b4050513          	addi	a0,a0,-1216 # 80017578 <ftable>
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	b1a080e7          	jalr	-1254(ra) # 8000655a <release>
  return 0;
    80003a48:	4481                	li	s1,0
    80003a4a:	a819                	j	80003a60 <filealloc+0x5e>
      f->ref = 1;
    80003a4c:	4785                	li	a5,1
    80003a4e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a50:	00014517          	auipc	a0,0x14
    80003a54:	b2850513          	addi	a0,a0,-1240 # 80017578 <ftable>
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	b02080e7          	jalr	-1278(ra) # 8000655a <release>
}
    80003a60:	8526                	mv	a0,s1
    80003a62:	60e2                	ld	ra,24(sp)
    80003a64:	6442                	ld	s0,16(sp)
    80003a66:	64a2                	ld	s1,8(sp)
    80003a68:	6105                	addi	sp,sp,32
    80003a6a:	8082                	ret

0000000080003a6c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a6c:	1101                	addi	sp,sp,-32
    80003a6e:	ec06                	sd	ra,24(sp)
    80003a70:	e822                	sd	s0,16(sp)
    80003a72:	e426                	sd	s1,8(sp)
    80003a74:	1000                	addi	s0,sp,32
    80003a76:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a78:	00014517          	auipc	a0,0x14
    80003a7c:	b0050513          	addi	a0,a0,-1280 # 80017578 <ftable>
    80003a80:	00003097          	auipc	ra,0x3
    80003a84:	a26080e7          	jalr	-1498(ra) # 800064a6 <acquire>
  if(f->ref < 1)
    80003a88:	40dc                	lw	a5,4(s1)
    80003a8a:	02f05263          	blez	a5,80003aae <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a8e:	2785                	addiw	a5,a5,1
    80003a90:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a92:	00014517          	auipc	a0,0x14
    80003a96:	ae650513          	addi	a0,a0,-1306 # 80017578 <ftable>
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	ac0080e7          	jalr	-1344(ra) # 8000655a <release>
  return f;
}
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	60e2                	ld	ra,24(sp)
    80003aa6:	6442                	ld	s0,16(sp)
    80003aa8:	64a2                	ld	s1,8(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret
    panic("filedup");
    80003aae:	00005517          	auipc	a0,0x5
    80003ab2:	a6250513          	addi	a0,a0,-1438 # 80008510 <etext+0x510>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	476080e7          	jalr	1142(ra) # 80005f2c <panic>

0000000080003abe <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003abe:	7139                	addi	sp,sp,-64
    80003ac0:	fc06                	sd	ra,56(sp)
    80003ac2:	f822                	sd	s0,48(sp)
    80003ac4:	f426                	sd	s1,40(sp)
    80003ac6:	0080                	addi	s0,sp,64
    80003ac8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aca:	00014517          	auipc	a0,0x14
    80003ace:	aae50513          	addi	a0,a0,-1362 # 80017578 <ftable>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	9d4080e7          	jalr	-1580(ra) # 800064a6 <acquire>
  if(f->ref < 1)
    80003ada:	40dc                	lw	a5,4(s1)
    80003adc:	04f05c63          	blez	a5,80003b34 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae0:	37fd                	addiw	a5,a5,-1
    80003ae2:	0007871b          	sext.w	a4,a5
    80003ae6:	c0dc                	sw	a5,4(s1)
    80003ae8:	06e04263          	bgtz	a4,80003b4c <fileclose+0x8e>
    80003aec:	f04a                	sd	s2,32(sp)
    80003aee:	ec4e                	sd	s3,24(sp)
    80003af0:	e852                	sd	s4,16(sp)
    80003af2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003af4:	0004a903          	lw	s2,0(s1)
    80003af8:	0094ca83          	lbu	s5,9(s1)
    80003afc:	0104ba03          	ld	s4,16(s1)
    80003b00:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b04:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b08:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b0c:	00014517          	auipc	a0,0x14
    80003b10:	a6c50513          	addi	a0,a0,-1428 # 80017578 <ftable>
    80003b14:	00003097          	auipc	ra,0x3
    80003b18:	a46080e7          	jalr	-1466(ra) # 8000655a <release>

  if(ff.type == FD_PIPE){
    80003b1c:	4785                	li	a5,1
    80003b1e:	04f90463          	beq	s2,a5,80003b66 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b22:	3979                	addiw	s2,s2,-2
    80003b24:	4785                	li	a5,1
    80003b26:	0527fb63          	bgeu	a5,s2,80003b7c <fileclose+0xbe>
    80003b2a:	7902                	ld	s2,32(sp)
    80003b2c:	69e2                	ld	s3,24(sp)
    80003b2e:	6a42                	ld	s4,16(sp)
    80003b30:	6aa2                	ld	s5,8(sp)
    80003b32:	a02d                	j	80003b5c <fileclose+0x9e>
    80003b34:	f04a                	sd	s2,32(sp)
    80003b36:	ec4e                	sd	s3,24(sp)
    80003b38:	e852                	sd	s4,16(sp)
    80003b3a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b3c:	00005517          	auipc	a0,0x5
    80003b40:	9dc50513          	addi	a0,a0,-1572 # 80008518 <etext+0x518>
    80003b44:	00002097          	auipc	ra,0x2
    80003b48:	3e8080e7          	jalr	1000(ra) # 80005f2c <panic>
    release(&ftable.lock);
    80003b4c:	00014517          	auipc	a0,0x14
    80003b50:	a2c50513          	addi	a0,a0,-1492 # 80017578 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	a06080e7          	jalr	-1530(ra) # 8000655a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b5c:	70e2                	ld	ra,56(sp)
    80003b5e:	7442                	ld	s0,48(sp)
    80003b60:	74a2                	ld	s1,40(sp)
    80003b62:	6121                	addi	sp,sp,64
    80003b64:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b66:	85d6                	mv	a1,s5
    80003b68:	8552                	mv	a0,s4
    80003b6a:	00000097          	auipc	ra,0x0
    80003b6e:	3a2080e7          	jalr	930(ra) # 80003f0c <pipeclose>
    80003b72:	7902                	ld	s2,32(sp)
    80003b74:	69e2                	ld	s3,24(sp)
    80003b76:	6a42                	ld	s4,16(sp)
    80003b78:	6aa2                	ld	s5,8(sp)
    80003b7a:	b7cd                	j	80003b5c <fileclose+0x9e>
    begin_op();
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	a78080e7          	jalr	-1416(ra) # 800035f4 <begin_op>
    iput(ff.ip);
    80003b84:	854e                	mv	a0,s3
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	258080e7          	jalr	600(ra) # 80002dde <iput>
    end_op();
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	ae0080e7          	jalr	-1312(ra) # 8000366e <end_op>
    80003b96:	7902                	ld	s2,32(sp)
    80003b98:	69e2                	ld	s3,24(sp)
    80003b9a:	6a42                	ld	s4,16(sp)
    80003b9c:	6aa2                	ld	s5,8(sp)
    80003b9e:	bf7d                	j	80003b5c <fileclose+0x9e>

0000000080003ba0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ba0:	715d                	addi	sp,sp,-80
    80003ba2:	e486                	sd	ra,72(sp)
    80003ba4:	e0a2                	sd	s0,64(sp)
    80003ba6:	fc26                	sd	s1,56(sp)
    80003ba8:	f44e                	sd	s3,40(sp)
    80003baa:	0880                	addi	s0,sp,80
    80003bac:	84aa                	mv	s1,a0
    80003bae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bb0:	ffffd097          	auipc	ra,0xffffd
    80003bb4:	2cc080e7          	jalr	716(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bb8:	409c                	lw	a5,0(s1)
    80003bba:	37f9                	addiw	a5,a5,-2
    80003bbc:	4705                	li	a4,1
    80003bbe:	04f76863          	bltu	a4,a5,80003c0e <filestat+0x6e>
    80003bc2:	f84a                	sd	s2,48(sp)
    80003bc4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bc6:	6c88                	ld	a0,24(s1)
    80003bc8:	fffff097          	auipc	ra,0xfffff
    80003bcc:	faa080e7          	jalr	-86(ra) # 80002b72 <ilock>
    stati(f->ip, &st);
    80003bd0:	fb840593          	addi	a1,s0,-72
    80003bd4:	6c88                	ld	a0,24(s1)
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	2d8080e7          	jalr	728(ra) # 80002eae <stati>
    iunlock(f->ip);
    80003bde:	6c88                	ld	a0,24(s1)
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	058080e7          	jalr	88(ra) # 80002c38 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003be8:	46e1                	li	a3,24
    80003bea:	fb840613          	addi	a2,s0,-72
    80003bee:	85ce                	mv	a1,s3
    80003bf0:	05093503          	ld	a0,80(s2)
    80003bf4:	ffffd097          	auipc	ra,0xffffd
    80003bf8:	f24080e7          	jalr	-220(ra) # 80000b18 <copyout>
    80003bfc:	41f5551b          	sraiw	a0,a0,0x1f
    80003c00:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c02:	60a6                	ld	ra,72(sp)
    80003c04:	6406                	ld	s0,64(sp)
    80003c06:	74e2                	ld	s1,56(sp)
    80003c08:	79a2                	ld	s3,40(sp)
    80003c0a:	6161                	addi	sp,sp,80
    80003c0c:	8082                	ret
  return -1;
    80003c0e:	557d                	li	a0,-1
    80003c10:	bfcd                	j	80003c02 <filestat+0x62>

0000000080003c12 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c12:	7179                	addi	sp,sp,-48
    80003c14:	f406                	sd	ra,40(sp)
    80003c16:	f022                	sd	s0,32(sp)
    80003c18:	e84a                	sd	s2,16(sp)
    80003c1a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c1c:	00854783          	lbu	a5,8(a0)
    80003c20:	cbc5                	beqz	a5,80003cd0 <fileread+0xbe>
    80003c22:	ec26                	sd	s1,24(sp)
    80003c24:	e44e                	sd	s3,8(sp)
    80003c26:	84aa                	mv	s1,a0
    80003c28:	89ae                	mv	s3,a1
    80003c2a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c2c:	411c                	lw	a5,0(a0)
    80003c2e:	4705                	li	a4,1
    80003c30:	04e78963          	beq	a5,a4,80003c82 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c34:	470d                	li	a4,3
    80003c36:	04e78f63          	beq	a5,a4,80003c94 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c3a:	4709                	li	a4,2
    80003c3c:	08e79263          	bne	a5,a4,80003cc0 <fileread+0xae>
    ilock(f->ip);
    80003c40:	6d08                	ld	a0,24(a0)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	f30080e7          	jalr	-208(ra) # 80002b72 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c4a:	874a                	mv	a4,s2
    80003c4c:	5094                	lw	a3,32(s1)
    80003c4e:	864e                	mv	a2,s3
    80003c50:	4585                	li	a1,1
    80003c52:	6c88                	ld	a0,24(s1)
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	284080e7          	jalr	644(ra) # 80002ed8 <readi>
    80003c5c:	892a                	mv	s2,a0
    80003c5e:	00a05563          	blez	a0,80003c68 <fileread+0x56>
      f->off += r;
    80003c62:	509c                	lw	a5,32(s1)
    80003c64:	9fa9                	addw	a5,a5,a0
    80003c66:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c68:	6c88                	ld	a0,24(s1)
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	fce080e7          	jalr	-50(ra) # 80002c38 <iunlock>
    80003c72:	64e2                	ld	s1,24(sp)
    80003c74:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c76:	854a                	mv	a0,s2
    80003c78:	70a2                	ld	ra,40(sp)
    80003c7a:	7402                	ld	s0,32(sp)
    80003c7c:	6942                	ld	s2,16(sp)
    80003c7e:	6145                	addi	sp,sp,48
    80003c80:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c82:	6908                	ld	a0,16(a0)
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	3fa080e7          	jalr	1018(ra) # 8000407e <piperead>
    80003c8c:	892a                	mv	s2,a0
    80003c8e:	64e2                	ld	s1,24(sp)
    80003c90:	69a2                	ld	s3,8(sp)
    80003c92:	b7d5                	j	80003c76 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c94:	02451783          	lh	a5,36(a0)
    80003c98:	03079693          	slli	a3,a5,0x30
    80003c9c:	92c1                	srli	a3,a3,0x30
    80003c9e:	4725                	li	a4,9
    80003ca0:	02d76a63          	bltu	a4,a3,80003cd4 <fileread+0xc2>
    80003ca4:	0792                	slli	a5,a5,0x4
    80003ca6:	00014717          	auipc	a4,0x14
    80003caa:	83270713          	addi	a4,a4,-1998 # 800174d8 <devsw>
    80003cae:	97ba                	add	a5,a5,a4
    80003cb0:	639c                	ld	a5,0(a5)
    80003cb2:	c78d                	beqz	a5,80003cdc <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cb4:	4505                	li	a0,1
    80003cb6:	9782                	jalr	a5
    80003cb8:	892a                	mv	s2,a0
    80003cba:	64e2                	ld	s1,24(sp)
    80003cbc:	69a2                	ld	s3,8(sp)
    80003cbe:	bf65                	j	80003c76 <fileread+0x64>
    panic("fileread");
    80003cc0:	00005517          	auipc	a0,0x5
    80003cc4:	86850513          	addi	a0,a0,-1944 # 80008528 <etext+0x528>
    80003cc8:	00002097          	auipc	ra,0x2
    80003ccc:	264080e7          	jalr	612(ra) # 80005f2c <panic>
    return -1;
    80003cd0:	597d                	li	s2,-1
    80003cd2:	b755                	j	80003c76 <fileread+0x64>
      return -1;
    80003cd4:	597d                	li	s2,-1
    80003cd6:	64e2                	ld	s1,24(sp)
    80003cd8:	69a2                	ld	s3,8(sp)
    80003cda:	bf71                	j	80003c76 <fileread+0x64>
    80003cdc:	597d                	li	s2,-1
    80003cde:	64e2                	ld	s1,24(sp)
    80003ce0:	69a2                	ld	s3,8(sp)
    80003ce2:	bf51                	j	80003c76 <fileread+0x64>

0000000080003ce4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ce4:	00954783          	lbu	a5,9(a0)
    80003ce8:	12078963          	beqz	a5,80003e1a <filewrite+0x136>
{
    80003cec:	715d                	addi	sp,sp,-80
    80003cee:	e486                	sd	ra,72(sp)
    80003cf0:	e0a2                	sd	s0,64(sp)
    80003cf2:	f84a                	sd	s2,48(sp)
    80003cf4:	f052                	sd	s4,32(sp)
    80003cf6:	e85a                	sd	s6,16(sp)
    80003cf8:	0880                	addi	s0,sp,80
    80003cfa:	892a                	mv	s2,a0
    80003cfc:	8b2e                	mv	s6,a1
    80003cfe:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d00:	411c                	lw	a5,0(a0)
    80003d02:	4705                	li	a4,1
    80003d04:	02e78763          	beq	a5,a4,80003d32 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d08:	470d                	li	a4,3
    80003d0a:	02e78a63          	beq	a5,a4,80003d3e <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0e:	4709                	li	a4,2
    80003d10:	0ee79863          	bne	a5,a4,80003e00 <filewrite+0x11c>
    80003d14:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d16:	0cc05463          	blez	a2,80003dde <filewrite+0xfa>
    80003d1a:	fc26                	sd	s1,56(sp)
    80003d1c:	ec56                	sd	s5,24(sp)
    80003d1e:	e45e                	sd	s7,8(sp)
    80003d20:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d22:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d24:	6b85                	lui	s7,0x1
    80003d26:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d2a:	6c05                	lui	s8,0x1
    80003d2c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d30:	a851                	j	80003dc4 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d32:	6908                	ld	a0,16(a0)
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	248080e7          	jalr	584(ra) # 80003f7c <pipewrite>
    80003d3c:	a85d                	j	80003df2 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d3e:	02451783          	lh	a5,36(a0)
    80003d42:	03079693          	slli	a3,a5,0x30
    80003d46:	92c1                	srli	a3,a3,0x30
    80003d48:	4725                	li	a4,9
    80003d4a:	0cd76a63          	bltu	a4,a3,80003e1e <filewrite+0x13a>
    80003d4e:	0792                	slli	a5,a5,0x4
    80003d50:	00013717          	auipc	a4,0x13
    80003d54:	78870713          	addi	a4,a4,1928 # 800174d8 <devsw>
    80003d58:	97ba                	add	a5,a5,a4
    80003d5a:	679c                	ld	a5,8(a5)
    80003d5c:	c3f9                	beqz	a5,80003e22 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d5e:	4505                	li	a0,1
    80003d60:	9782                	jalr	a5
    80003d62:	a841                	j	80003df2 <filewrite+0x10e>
      if(n1 > max)
    80003d64:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	88c080e7          	jalr	-1908(ra) # 800035f4 <begin_op>
      ilock(f->ip);
    80003d70:	01893503          	ld	a0,24(s2)
    80003d74:	fffff097          	auipc	ra,0xfffff
    80003d78:	dfe080e7          	jalr	-514(ra) # 80002b72 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d7c:	8756                	mv	a4,s5
    80003d7e:	02092683          	lw	a3,32(s2)
    80003d82:	01698633          	add	a2,s3,s6
    80003d86:	4585                	li	a1,1
    80003d88:	01893503          	ld	a0,24(s2)
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	250080e7          	jalr	592(ra) # 80002fdc <writei>
    80003d94:	84aa                	mv	s1,a0
    80003d96:	00a05763          	blez	a0,80003da4 <filewrite+0xc0>
        f->off += r;
    80003d9a:	02092783          	lw	a5,32(s2)
    80003d9e:	9fa9                	addw	a5,a5,a0
    80003da0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003da4:	01893503          	ld	a0,24(s2)
    80003da8:	fffff097          	auipc	ra,0xfffff
    80003dac:	e90080e7          	jalr	-368(ra) # 80002c38 <iunlock>
      end_op();
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	8be080e7          	jalr	-1858(ra) # 8000366e <end_op>

      if(r != n1){
    80003db8:	029a9563          	bne	s5,s1,80003de2 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003dbc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dc0:	0149da63          	bge	s3,s4,80003dd4 <filewrite+0xf0>
      int n1 = n - i;
    80003dc4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dc8:	0004879b          	sext.w	a5,s1
    80003dcc:	f8fbdce3          	bge	s7,a5,80003d64 <filewrite+0x80>
    80003dd0:	84e2                	mv	s1,s8
    80003dd2:	bf49                	j	80003d64 <filewrite+0x80>
    80003dd4:	74e2                	ld	s1,56(sp)
    80003dd6:	6ae2                	ld	s5,24(sp)
    80003dd8:	6ba2                	ld	s7,8(sp)
    80003dda:	6c02                	ld	s8,0(sp)
    80003ddc:	a039                	j	80003dea <filewrite+0x106>
    int i = 0;
    80003dde:	4981                	li	s3,0
    80003de0:	a029                	j	80003dea <filewrite+0x106>
    80003de2:	74e2                	ld	s1,56(sp)
    80003de4:	6ae2                	ld	s5,24(sp)
    80003de6:	6ba2                	ld	s7,8(sp)
    80003de8:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dea:	033a1e63          	bne	s4,s3,80003e26 <filewrite+0x142>
    80003dee:	8552                	mv	a0,s4
    80003df0:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003df2:	60a6                	ld	ra,72(sp)
    80003df4:	6406                	ld	s0,64(sp)
    80003df6:	7942                	ld	s2,48(sp)
    80003df8:	7a02                	ld	s4,32(sp)
    80003dfa:	6b42                	ld	s6,16(sp)
    80003dfc:	6161                	addi	sp,sp,80
    80003dfe:	8082                	ret
    80003e00:	fc26                	sd	s1,56(sp)
    80003e02:	f44e                	sd	s3,40(sp)
    80003e04:	ec56                	sd	s5,24(sp)
    80003e06:	e45e                	sd	s7,8(sp)
    80003e08:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e0a:	00004517          	auipc	a0,0x4
    80003e0e:	72e50513          	addi	a0,a0,1838 # 80008538 <etext+0x538>
    80003e12:	00002097          	auipc	ra,0x2
    80003e16:	11a080e7          	jalr	282(ra) # 80005f2c <panic>
    return -1;
    80003e1a:	557d                	li	a0,-1
}
    80003e1c:	8082                	ret
      return -1;
    80003e1e:	557d                	li	a0,-1
    80003e20:	bfc9                	j	80003df2 <filewrite+0x10e>
    80003e22:	557d                	li	a0,-1
    80003e24:	b7f9                	j	80003df2 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e26:	557d                	li	a0,-1
    80003e28:	79a2                	ld	s3,40(sp)
    80003e2a:	b7e1                	j	80003df2 <filewrite+0x10e>

0000000080003e2c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e2c:	7179                	addi	sp,sp,-48
    80003e2e:	f406                	sd	ra,40(sp)
    80003e30:	f022                	sd	s0,32(sp)
    80003e32:	ec26                	sd	s1,24(sp)
    80003e34:	e052                	sd	s4,0(sp)
    80003e36:	1800                	addi	s0,sp,48
    80003e38:	84aa                	mv	s1,a0
    80003e3a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e3c:	0005b023          	sd	zero,0(a1)
    80003e40:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	bbe080e7          	jalr	-1090(ra) # 80003a02 <filealloc>
    80003e4c:	e088                	sd	a0,0(s1)
    80003e4e:	cd49                	beqz	a0,80003ee8 <pipealloc+0xbc>
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	bb2080e7          	jalr	-1102(ra) # 80003a02 <filealloc>
    80003e58:	00aa3023          	sd	a0,0(s4)
    80003e5c:	c141                	beqz	a0,80003edc <pipealloc+0xb0>
    80003e5e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e60:	ffffc097          	auipc	ra,0xffffc
    80003e64:	2ba080e7          	jalr	698(ra) # 8000011a <kalloc>
    80003e68:	892a                	mv	s2,a0
    80003e6a:	c13d                	beqz	a0,80003ed0 <pipealloc+0xa4>
    80003e6c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e6e:	4985                	li	s3,1
    80003e70:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e74:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e78:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e7c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e80:	00004597          	auipc	a1,0x4
    80003e84:	6c858593          	addi	a1,a1,1736 # 80008548 <etext+0x548>
    80003e88:	00002097          	auipc	ra,0x2
    80003e8c:	58e080e7          	jalr	1422(ra) # 80006416 <initlock>
  (*f0)->type = FD_PIPE;
    80003e90:	609c                	ld	a5,0(s1)
    80003e92:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e96:	609c                	ld	a5,0(s1)
    80003e98:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e9c:	609c                	ld	a5,0(s1)
    80003e9e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea2:	609c                	ld	a5,0(s1)
    80003ea4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ea8:	000a3783          	ld	a5,0(s4)
    80003eac:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eb0:	000a3783          	ld	a5,0(s4)
    80003eb4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eb8:	000a3783          	ld	a5,0(s4)
    80003ebc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ec0:	000a3783          	ld	a5,0(s4)
    80003ec4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ec8:	4501                	li	a0,0
    80003eca:	6942                	ld	s2,16(sp)
    80003ecc:	69a2                	ld	s3,8(sp)
    80003ece:	a03d                	j	80003efc <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed0:	6088                	ld	a0,0(s1)
    80003ed2:	c119                	beqz	a0,80003ed8 <pipealloc+0xac>
    80003ed4:	6942                	ld	s2,16(sp)
    80003ed6:	a029                	j	80003ee0 <pipealloc+0xb4>
    80003ed8:	6942                	ld	s2,16(sp)
    80003eda:	a039                	j	80003ee8 <pipealloc+0xbc>
    80003edc:	6088                	ld	a0,0(s1)
    80003ede:	c50d                	beqz	a0,80003f08 <pipealloc+0xdc>
    fileclose(*f0);
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	bde080e7          	jalr	-1058(ra) # 80003abe <fileclose>
  if(*f1)
    80003ee8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eec:	557d                	li	a0,-1
  if(*f1)
    80003eee:	c799                	beqz	a5,80003efc <pipealloc+0xd0>
    fileclose(*f1);
    80003ef0:	853e                	mv	a0,a5
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	bcc080e7          	jalr	-1076(ra) # 80003abe <fileclose>
  return -1;
    80003efa:	557d                	li	a0,-1
}
    80003efc:	70a2                	ld	ra,40(sp)
    80003efe:	7402                	ld	s0,32(sp)
    80003f00:	64e2                	ld	s1,24(sp)
    80003f02:	6a02                	ld	s4,0(sp)
    80003f04:	6145                	addi	sp,sp,48
    80003f06:	8082                	ret
  return -1;
    80003f08:	557d                	li	a0,-1
    80003f0a:	bfcd                	j	80003efc <pipealloc+0xd0>

0000000080003f0c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f0c:	1101                	addi	sp,sp,-32
    80003f0e:	ec06                	sd	ra,24(sp)
    80003f10:	e822                	sd	s0,16(sp)
    80003f12:	e426                	sd	s1,8(sp)
    80003f14:	e04a                	sd	s2,0(sp)
    80003f16:	1000                	addi	s0,sp,32
    80003f18:	84aa                	mv	s1,a0
    80003f1a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	58a080e7          	jalr	1418(ra) # 800064a6 <acquire>
  if(writable){
    80003f24:	02090d63          	beqz	s2,80003f5e <pipeclose+0x52>
    pi->writeopen = 0;
    80003f28:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f2c:	21848513          	addi	a0,s1,536
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	79e080e7          	jalr	1950(ra) # 800016ce <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f38:	2204b783          	ld	a5,544(s1)
    80003f3c:	eb95                	bnez	a5,80003f70 <pipeclose+0x64>
    release(&pi->lock);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	00002097          	auipc	ra,0x2
    80003f44:	61a080e7          	jalr	1562(ra) # 8000655a <release>
    kfree((char*)pi);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	ffffc097          	auipc	ra,0xffffc
    80003f4e:	0d2080e7          	jalr	210(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f52:	60e2                	ld	ra,24(sp)
    80003f54:	6442                	ld	s0,16(sp)
    80003f56:	64a2                	ld	s1,8(sp)
    80003f58:	6902                	ld	s2,0(sp)
    80003f5a:	6105                	addi	sp,sp,32
    80003f5c:	8082                	ret
    pi->readopen = 0;
    80003f5e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f62:	21c48513          	addi	a0,s1,540
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	768080e7          	jalr	1896(ra) # 800016ce <wakeup>
    80003f6e:	b7e9                	j	80003f38 <pipeclose+0x2c>
    release(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	5e8080e7          	jalr	1512(ra) # 8000655a <release>
}
    80003f7a:	bfe1                	j	80003f52 <pipeclose+0x46>

0000000080003f7c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f7c:	711d                	addi	sp,sp,-96
    80003f7e:	ec86                	sd	ra,88(sp)
    80003f80:	e8a2                	sd	s0,80(sp)
    80003f82:	e4a6                	sd	s1,72(sp)
    80003f84:	e0ca                	sd	s2,64(sp)
    80003f86:	fc4e                	sd	s3,56(sp)
    80003f88:	f852                	sd	s4,48(sp)
    80003f8a:	f456                	sd	s5,40(sp)
    80003f8c:	1080                	addi	s0,sp,96
    80003f8e:	84aa                	mv	s1,a0
    80003f90:	8aae                	mv	s5,a1
    80003f92:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	ee8080e7          	jalr	-280(ra) # 80000e7c <myproc>
    80003f9c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	00002097          	auipc	ra,0x2
    80003fa4:	506080e7          	jalr	1286(ra) # 800064a6 <acquire>
  while(i < n){
    80003fa8:	0d405563          	blez	s4,80004072 <pipewrite+0xf6>
    80003fac:	f05a                	sd	s6,32(sp)
    80003fae:	ec5e                	sd	s7,24(sp)
    80003fb0:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fb2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fb6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fba:	21c48b93          	addi	s7,s1,540
    80003fbe:	a089                	j	80004000 <pipewrite+0x84>
      release(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	598080e7          	jalr	1432(ra) # 8000655a <release>
      return -1;
    80003fca:	597d                	li	s2,-1
    80003fcc:	7b02                	ld	s6,32(sp)
    80003fce:	6be2                	ld	s7,24(sp)
    80003fd0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	60e6                	ld	ra,88(sp)
    80003fd6:	6446                	ld	s0,80(sp)
    80003fd8:	64a6                	ld	s1,72(sp)
    80003fda:	6906                	ld	s2,64(sp)
    80003fdc:	79e2                	ld	s3,56(sp)
    80003fde:	7a42                	ld	s4,48(sp)
    80003fe0:	7aa2                	ld	s5,40(sp)
    80003fe2:	6125                	addi	sp,sp,96
    80003fe4:	8082                	ret
      wakeup(&pi->nread);
    80003fe6:	8562                	mv	a0,s8
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	6e6080e7          	jalr	1766(ra) # 800016ce <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ff0:	85a6                	mv	a1,s1
    80003ff2:	855e                	mv	a0,s7
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	54e080e7          	jalr	1358(ra) # 80001542 <sleep>
  while(i < n){
    80003ffc:	05495c63          	bge	s2,s4,80004054 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004000:	2204a783          	lw	a5,544(s1)
    80004004:	dfd5                	beqz	a5,80003fc0 <pipewrite+0x44>
    80004006:	0289a783          	lw	a5,40(s3)
    8000400a:	fbdd                	bnez	a5,80003fc0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000400c:	2184a783          	lw	a5,536(s1)
    80004010:	21c4a703          	lw	a4,540(s1)
    80004014:	2007879b          	addiw	a5,a5,512
    80004018:	fcf707e3          	beq	a4,a5,80003fe6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401c:	4685                	li	a3,1
    8000401e:	01590633          	add	a2,s2,s5
    80004022:	faf40593          	addi	a1,s0,-81
    80004026:	0509b503          	ld	a0,80(s3)
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	b7a080e7          	jalr	-1158(ra) # 80000ba4 <copyin>
    80004032:	05650263          	beq	a0,s6,80004076 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004036:	21c4a783          	lw	a5,540(s1)
    8000403a:	0017871b          	addiw	a4,a5,1
    8000403e:	20e4ae23          	sw	a4,540(s1)
    80004042:	1ff7f793          	andi	a5,a5,511
    80004046:	97a6                	add	a5,a5,s1
    80004048:	faf44703          	lbu	a4,-81(s0)
    8000404c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004050:	2905                	addiw	s2,s2,1
    80004052:	b76d                	j	80003ffc <pipewrite+0x80>
    80004054:	7b02                	ld	s6,32(sp)
    80004056:	6be2                	ld	s7,24(sp)
    80004058:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000405a:	21848513          	addi	a0,s1,536
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	670080e7          	jalr	1648(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	4f2080e7          	jalr	1266(ra) # 8000655a <release>
  return i;
    80004070:	b78d                	j	80003fd2 <pipewrite+0x56>
  int i = 0;
    80004072:	4901                	li	s2,0
    80004074:	b7dd                	j	8000405a <pipewrite+0xde>
    80004076:	7b02                	ld	s6,32(sp)
    80004078:	6be2                	ld	s7,24(sp)
    8000407a:	6c42                	ld	s8,16(sp)
    8000407c:	bff9                	j	8000405a <pipewrite+0xde>

000000008000407e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000407e:	715d                	addi	sp,sp,-80
    80004080:	e486                	sd	ra,72(sp)
    80004082:	e0a2                	sd	s0,64(sp)
    80004084:	fc26                	sd	s1,56(sp)
    80004086:	f84a                	sd	s2,48(sp)
    80004088:	f44e                	sd	s3,40(sp)
    8000408a:	f052                	sd	s4,32(sp)
    8000408c:	ec56                	sd	s5,24(sp)
    8000408e:	0880                	addi	s0,sp,80
    80004090:	84aa                	mv	s1,a0
    80004092:	892e                	mv	s2,a1
    80004094:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	de6080e7          	jalr	-538(ra) # 80000e7c <myproc>
    8000409e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	404080e7          	jalr	1028(ra) # 800064a6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040aa:	2184a703          	lw	a4,536(s1)
    800040ae:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b6:	02f71663          	bne	a4,a5,800040e2 <piperead+0x64>
    800040ba:	2244a783          	lw	a5,548(s1)
    800040be:	cb9d                	beqz	a5,800040f4 <piperead+0x76>
    if(pr->killed){
    800040c0:	028a2783          	lw	a5,40(s4)
    800040c4:	e38d                	bnez	a5,800040e6 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c6:	85a6                	mv	a1,s1
    800040c8:	854e                	mv	a0,s3
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	478080e7          	jalr	1144(ra) # 80001542 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d2:	2184a703          	lw	a4,536(s1)
    800040d6:	21c4a783          	lw	a5,540(s1)
    800040da:	fef700e3          	beq	a4,a5,800040ba <piperead+0x3c>
    800040de:	e85a                	sd	s6,16(sp)
    800040e0:	a819                	j	800040f6 <piperead+0x78>
    800040e2:	e85a                	sd	s6,16(sp)
    800040e4:	a809                	j	800040f6 <piperead+0x78>
      release(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	472080e7          	jalr	1138(ra) # 8000655a <release>
      return -1;
    800040f0:	59fd                	li	s3,-1
    800040f2:	a0a5                	j	8000415a <piperead+0xdc>
    800040f4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fa:	05505463          	blez	s5,80004142 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800040fe:	2184a783          	lw	a5,536(s1)
    80004102:	21c4a703          	lw	a4,540(s1)
    80004106:	02f70e63          	beq	a4,a5,80004142 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410a:	0017871b          	addiw	a4,a5,1
    8000410e:	20e4ac23          	sw	a4,536(s1)
    80004112:	1ff7f793          	andi	a5,a5,511
    80004116:	97a6                	add	a5,a5,s1
    80004118:	0187c783          	lbu	a5,24(a5)
    8000411c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004120:	4685                	li	a3,1
    80004122:	fbf40613          	addi	a2,s0,-65
    80004126:	85ca                	mv	a1,s2
    80004128:	050a3503          	ld	a0,80(s4)
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	9ec080e7          	jalr	-1556(ra) # 80000b18 <copyout>
    80004134:	01650763          	beq	a0,s6,80004142 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004138:	2985                	addiw	s3,s3,1
    8000413a:	0905                	addi	s2,s2,1
    8000413c:	fd3a91e3          	bne	s5,s3,800040fe <piperead+0x80>
    80004140:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004142:	21c48513          	addi	a0,s1,540
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	588080e7          	jalr	1416(ra) # 800016ce <wakeup>
  release(&pi->lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	00002097          	auipc	ra,0x2
    80004154:	40a080e7          	jalr	1034(ra) # 8000655a <release>
    80004158:	6b42                	ld	s6,16(sp)
  return i;
}
    8000415a:	854e                	mv	a0,s3
    8000415c:	60a6                	ld	ra,72(sp)
    8000415e:	6406                	ld	s0,64(sp)
    80004160:	74e2                	ld	s1,56(sp)
    80004162:	7942                	ld	s2,48(sp)
    80004164:	79a2                	ld	s3,40(sp)
    80004166:	7a02                	ld	s4,32(sp)
    80004168:	6ae2                	ld	s5,24(sp)
    8000416a:	6161                	addi	sp,sp,80
    8000416c:	8082                	ret

000000008000416e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000416e:	df010113          	addi	sp,sp,-528
    80004172:	20113423          	sd	ra,520(sp)
    80004176:	20813023          	sd	s0,512(sp)
    8000417a:	ffa6                	sd	s1,504(sp)
    8000417c:	fbca                	sd	s2,496(sp)
    8000417e:	0c00                	addi	s0,sp,528
    80004180:	892a                	mv	s2,a0
    80004182:	dea43c23          	sd	a0,-520(s0)
    80004186:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	cf2080e7          	jalr	-782(ra) # 80000e7c <myproc>
    80004192:	84aa                	mv	s1,a0

  begin_op();
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	460080e7          	jalr	1120(ra) # 800035f4 <begin_op>

  if((ip = namei(path)) == 0){
    8000419c:	854a                	mv	a0,s2
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	256080e7          	jalr	598(ra) # 800033f4 <namei>
    800041a6:	c135                	beqz	a0,8000420a <exec+0x9c>
    800041a8:	f3d2                	sd	s4,480(sp)
    800041aa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	9c6080e7          	jalr	-1594(ra) # 80002b72 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b4:	04000713          	li	a4,64
    800041b8:	4681                	li	a3,0
    800041ba:	e5040613          	addi	a2,s0,-432
    800041be:	4581                	li	a1,0
    800041c0:	8552                	mv	a0,s4
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	d16080e7          	jalr	-746(ra) # 80002ed8 <readi>
    800041ca:	04000793          	li	a5,64
    800041ce:	00f51a63          	bne	a0,a5,800041e2 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041d2:	e5042703          	lw	a4,-432(s0)
    800041d6:	464c47b7          	lui	a5,0x464c4
    800041da:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041de:	02f70c63          	beq	a4,a5,80004216 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e2:	8552                	mv	a0,s4
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	ca2080e7          	jalr	-862(ra) # 80002e86 <iunlockput>
    end_op();
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	482080e7          	jalr	1154(ra) # 8000366e <end_op>
  }
  return -1;
    800041f4:	557d                	li	a0,-1
    800041f6:	7a1e                	ld	s4,480(sp)
}
    800041f8:	20813083          	ld	ra,520(sp)
    800041fc:	20013403          	ld	s0,512(sp)
    80004200:	74fe                	ld	s1,504(sp)
    80004202:	795e                	ld	s2,496(sp)
    80004204:	21010113          	addi	sp,sp,528
    80004208:	8082                	ret
    end_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	464080e7          	jalr	1124(ra) # 8000366e <end_op>
    return -1;
    80004212:	557d                	li	a0,-1
    80004214:	b7d5                	j	800041f8 <exec+0x8a>
    80004216:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004218:	8526                	mv	a0,s1
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	d26080e7          	jalr	-730(ra) # 80000f40 <proc_pagetable>
    80004222:	8b2a                	mv	s6,a0
    80004224:	30050563          	beqz	a0,8000452e <exec+0x3c0>
    80004228:	f7ce                	sd	s3,488(sp)
    8000422a:	efd6                	sd	s5,472(sp)
    8000422c:	e7de                	sd	s7,456(sp)
    8000422e:	e3e2                	sd	s8,448(sp)
    80004230:	ff66                	sd	s9,440(sp)
    80004232:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004234:	e7042d03          	lw	s10,-400(s0)
    80004238:	e8845783          	lhu	a5,-376(s0)
    8000423c:	14078563          	beqz	a5,80004386 <exec+0x218>
    80004240:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004242:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004244:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004246:	6c85                	lui	s9,0x1
    80004248:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004250:	6a85                	lui	s5,0x1
    80004252:	a0b5                	j	800042be <exec+0x150>
      panic("loadseg: address should exist");
    80004254:	00004517          	auipc	a0,0x4
    80004258:	2fc50513          	addi	a0,a0,764 # 80008550 <etext+0x550>
    8000425c:	00002097          	auipc	ra,0x2
    80004260:	cd0080e7          	jalr	-816(ra) # 80005f2c <panic>
    if(sz - i < PGSIZE)
    80004264:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004266:	8726                	mv	a4,s1
    80004268:	012c06bb          	addw	a3,s8,s2
    8000426c:	4581                	li	a1,0
    8000426e:	8552                	mv	a0,s4
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	c68080e7          	jalr	-920(ra) # 80002ed8 <readi>
    80004278:	2501                	sext.w	a0,a0
    8000427a:	26a49e63          	bne	s1,a0,800044f6 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000427e:	012a893b          	addw	s2,s5,s2
    80004282:	03397563          	bgeu	s2,s3,800042ac <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004286:	02091593          	slli	a1,s2,0x20
    8000428a:	9181                	srli	a1,a1,0x20
    8000428c:	95de                	add	a1,a1,s7
    8000428e:	855a                	mv	a0,s6
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	268080e7          	jalr	616(ra) # 800004f8 <walkaddr>
    80004298:	862a                	mv	a2,a0
    if(pa == 0)
    8000429a:	dd4d                	beqz	a0,80004254 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000429c:	412984bb          	subw	s1,s3,s2
    800042a0:	0004879b          	sext.w	a5,s1
    800042a4:	fcfcf0e3          	bgeu	s9,a5,80004264 <exec+0xf6>
    800042a8:	84d6                	mv	s1,s5
    800042aa:	bf6d                	j	80004264 <exec+0xf6>
    sz = sz1;
    800042ac:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b0:	2d85                	addiw	s11,s11,1
    800042b2:	038d0d1b          	addiw	s10,s10,56
    800042b6:	e8845783          	lhu	a5,-376(s0)
    800042ba:	06fddf63          	bge	s11,a5,80004338 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042be:	2d01                	sext.w	s10,s10
    800042c0:	03800713          	li	a4,56
    800042c4:	86ea                	mv	a3,s10
    800042c6:	e1840613          	addi	a2,s0,-488
    800042ca:	4581                	li	a1,0
    800042cc:	8552                	mv	a0,s4
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	c0a080e7          	jalr	-1014(ra) # 80002ed8 <readi>
    800042d6:	03800793          	li	a5,56
    800042da:	1ef51863          	bne	a0,a5,800044ca <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042de:	e1842783          	lw	a5,-488(s0)
    800042e2:	4705                	li	a4,1
    800042e4:	fce796e3          	bne	a5,a4,800042b0 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042e8:	e4043603          	ld	a2,-448(s0)
    800042ec:	e3843783          	ld	a5,-456(s0)
    800042f0:	1ef66163          	bltu	a2,a5,800044d2 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042f4:	e2843783          	ld	a5,-472(s0)
    800042f8:	963e                	add	a2,a2,a5
    800042fa:	1ef66063          	bltu	a2,a5,800044da <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042fe:	85a6                	mv	a1,s1
    80004300:	855a                	mv	a0,s6
    80004302:	ffffc097          	auipc	ra,0xffffc
    80004306:	5ba080e7          	jalr	1466(ra) # 800008bc <uvmalloc>
    8000430a:	e0a43423          	sd	a0,-504(s0)
    8000430e:	1c050a63          	beqz	a0,800044e2 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004312:	e2843b83          	ld	s7,-472(s0)
    80004316:	df043783          	ld	a5,-528(s0)
    8000431a:	00fbf7b3          	and	a5,s7,a5
    8000431e:	1c079a63          	bnez	a5,800044f2 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004322:	e2042c03          	lw	s8,-480(s0)
    80004326:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000432a:	00098463          	beqz	s3,80004332 <exec+0x1c4>
    8000432e:	4901                	li	s2,0
    80004330:	bf99                	j	80004286 <exec+0x118>
    sz = sz1;
    80004332:	e0843483          	ld	s1,-504(s0)
    80004336:	bfad                	j	800042b0 <exec+0x142>
    80004338:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000433a:	8552                	mv	a0,s4
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	b4a080e7          	jalr	-1206(ra) # 80002e86 <iunlockput>
  end_op();
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	32a080e7          	jalr	810(ra) # 8000366e <end_op>
  p = myproc();
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	b30080e7          	jalr	-1232(ra) # 80000e7c <myproc>
    80004354:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004356:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000435a:	6985                	lui	s3,0x1
    8000435c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000435e:	99a6                	add	s3,s3,s1
    80004360:	77fd                	lui	a5,0xfffff
    80004362:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004366:	6609                	lui	a2,0x2
    80004368:	964e                	add	a2,a2,s3
    8000436a:	85ce                	mv	a1,s3
    8000436c:	855a                	mv	a0,s6
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	54e080e7          	jalr	1358(ra) # 800008bc <uvmalloc>
    80004376:	892a                	mv	s2,a0
    80004378:	e0a43423          	sd	a0,-504(s0)
    8000437c:	e519                	bnez	a0,8000438a <exec+0x21c>
  if(pagetable)
    8000437e:	e1343423          	sd	s3,-504(s0)
    80004382:	4a01                	li	s4,0
    80004384:	aa95                	j	800044f8 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004386:	4481                	li	s1,0
    80004388:	bf4d                	j	8000433a <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438a:	75f9                	lui	a1,0xffffe
    8000438c:	95aa                	add	a1,a1,a0
    8000438e:	855a                	mv	a0,s6
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	756080e7          	jalr	1878(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004398:	7bfd                	lui	s7,0xfffff
    8000439a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000439c:	e0043783          	ld	a5,-512(s0)
    800043a0:	6388                	ld	a0,0(a5)
    800043a2:	c52d                	beqz	a0,8000440c <exec+0x29e>
    800043a4:	e9040993          	addi	s3,s0,-368
    800043a8:	f9040c13          	addi	s8,s0,-112
    800043ac:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	f40080e7          	jalr	-192(ra) # 800002ee <strlen>
    800043b6:	0015079b          	addiw	a5,a0,1
    800043ba:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043be:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043c2:	13796463          	bltu	s2,s7,800044ea <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c6:	e0043d03          	ld	s10,-512(s0)
    800043ca:	000d3a03          	ld	s4,0(s10)
    800043ce:	8552                	mv	a0,s4
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	f1e080e7          	jalr	-226(ra) # 800002ee <strlen>
    800043d8:	0015069b          	addiw	a3,a0,1
    800043dc:	8652                	mv	a2,s4
    800043de:	85ca                	mv	a1,s2
    800043e0:	855a                	mv	a0,s6
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	736080e7          	jalr	1846(ra) # 80000b18 <copyout>
    800043ea:	10054263          	bltz	a0,800044ee <exec+0x380>
    ustack[argc] = sp;
    800043ee:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f2:	0485                	addi	s1,s1,1
    800043f4:	008d0793          	addi	a5,s10,8
    800043f8:	e0f43023          	sd	a5,-512(s0)
    800043fc:	008d3503          	ld	a0,8(s10)
    80004400:	c909                	beqz	a0,80004412 <exec+0x2a4>
    if(argc >= MAXARG)
    80004402:	09a1                	addi	s3,s3,8
    80004404:	fb8995e3          	bne	s3,s8,800043ae <exec+0x240>
  ip = 0;
    80004408:	4a01                	li	s4,0
    8000440a:	a0fd                	j	800044f8 <exec+0x38a>
  sp = sz;
    8000440c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004410:	4481                	li	s1,0
  ustack[argc] = 0;
    80004412:	00349793          	slli	a5,s1,0x3
    80004416:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdad50>
    8000441a:	97a2                	add	a5,a5,s0
    8000441c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004420:	00148693          	addi	a3,s1,1
    80004424:	068e                	slli	a3,a3,0x3
    80004426:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000442e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004432:	f57966e3          	bltu	s2,s7,8000437e <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004436:	e9040613          	addi	a2,s0,-368
    8000443a:	85ca                	mv	a1,s2
    8000443c:	855a                	mv	a0,s6
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	6da080e7          	jalr	1754(ra) # 80000b18 <copyout>
    80004446:	0e054663          	bltz	a0,80004532 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000444a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000444e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004452:	df843783          	ld	a5,-520(s0)
    80004456:	0007c703          	lbu	a4,0(a5)
    8000445a:	cf11                	beqz	a4,80004476 <exec+0x308>
    8000445c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000445e:	02f00693          	li	a3,47
    80004462:	a039                	j	80004470 <exec+0x302>
      last = s+1;
    80004464:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004468:	0785                	addi	a5,a5,1
    8000446a:	fff7c703          	lbu	a4,-1(a5)
    8000446e:	c701                	beqz	a4,80004476 <exec+0x308>
    if(*s == '/')
    80004470:	fed71ce3          	bne	a4,a3,80004468 <exec+0x2fa>
    80004474:	bfc5                	j	80004464 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004476:	4641                	li	a2,16
    80004478:	df843583          	ld	a1,-520(s0)
    8000447c:	158a8513          	addi	a0,s5,344
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	e3c080e7          	jalr	-452(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004488:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000448c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004490:	e0843783          	ld	a5,-504(s0)
    80004494:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004498:	058ab783          	ld	a5,88(s5)
    8000449c:	e6843703          	ld	a4,-408(s0)
    800044a0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a2:	058ab783          	ld	a5,88(s5)
    800044a6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044aa:	85e6                	mv	a1,s9
    800044ac:	ffffd097          	auipc	ra,0xffffd
    800044b0:	b30080e7          	jalr	-1232(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044b4:	0004851b          	sext.w	a0,s1
    800044b8:	79be                	ld	s3,488(sp)
    800044ba:	7a1e                	ld	s4,480(sp)
    800044bc:	6afe                	ld	s5,472(sp)
    800044be:	6b5e                	ld	s6,464(sp)
    800044c0:	6bbe                	ld	s7,456(sp)
    800044c2:	6c1e                	ld	s8,448(sp)
    800044c4:	7cfa                	ld	s9,440(sp)
    800044c6:	7d5a                	ld	s10,432(sp)
    800044c8:	bb05                	j	800041f8 <exec+0x8a>
    800044ca:	e0943423          	sd	s1,-504(s0)
    800044ce:	7dba                	ld	s11,424(sp)
    800044d0:	a025                	j	800044f8 <exec+0x38a>
    800044d2:	e0943423          	sd	s1,-504(s0)
    800044d6:	7dba                	ld	s11,424(sp)
    800044d8:	a005                	j	800044f8 <exec+0x38a>
    800044da:	e0943423          	sd	s1,-504(s0)
    800044de:	7dba                	ld	s11,424(sp)
    800044e0:	a821                	j	800044f8 <exec+0x38a>
    800044e2:	e0943423          	sd	s1,-504(s0)
    800044e6:	7dba                	ld	s11,424(sp)
    800044e8:	a801                	j	800044f8 <exec+0x38a>
  ip = 0;
    800044ea:	4a01                	li	s4,0
    800044ec:	a031                	j	800044f8 <exec+0x38a>
    800044ee:	4a01                	li	s4,0
  if(pagetable)
    800044f0:	a021                	j	800044f8 <exec+0x38a>
    800044f2:	7dba                	ld	s11,424(sp)
    800044f4:	a011                	j	800044f8 <exec+0x38a>
    800044f6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044f8:	e0843583          	ld	a1,-504(s0)
    800044fc:	855a                	mv	a0,s6
    800044fe:	ffffd097          	auipc	ra,0xffffd
    80004502:	ade080e7          	jalr	-1314(ra) # 80000fdc <proc_freepagetable>
  return -1;
    80004506:	557d                	li	a0,-1
  if(ip){
    80004508:	000a1b63          	bnez	s4,8000451e <exec+0x3b0>
    8000450c:	79be                	ld	s3,488(sp)
    8000450e:	7a1e                	ld	s4,480(sp)
    80004510:	6afe                	ld	s5,472(sp)
    80004512:	6b5e                	ld	s6,464(sp)
    80004514:	6bbe                	ld	s7,456(sp)
    80004516:	6c1e                	ld	s8,448(sp)
    80004518:	7cfa                	ld	s9,440(sp)
    8000451a:	7d5a                	ld	s10,432(sp)
    8000451c:	b9f1                	j	800041f8 <exec+0x8a>
    8000451e:	79be                	ld	s3,488(sp)
    80004520:	6afe                	ld	s5,472(sp)
    80004522:	6b5e                	ld	s6,464(sp)
    80004524:	6bbe                	ld	s7,456(sp)
    80004526:	6c1e                	ld	s8,448(sp)
    80004528:	7cfa                	ld	s9,440(sp)
    8000452a:	7d5a                	ld	s10,432(sp)
    8000452c:	b95d                	j	800041e2 <exec+0x74>
    8000452e:	6b5e                	ld	s6,464(sp)
    80004530:	b94d                	j	800041e2 <exec+0x74>
  sz = sz1;
    80004532:	e0843983          	ld	s3,-504(s0)
    80004536:	b5a1                	j	8000437e <exec+0x210>

0000000080004538 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004538:	7179                	addi	sp,sp,-48
    8000453a:	f406                	sd	ra,40(sp)
    8000453c:	f022                	sd	s0,32(sp)
    8000453e:	ec26                	sd	s1,24(sp)
    80004540:	e84a                	sd	s2,16(sp)
    80004542:	1800                	addi	s0,sp,48
    80004544:	892e                	mv	s2,a1
    80004546:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004548:	fdc40593          	addi	a1,s0,-36
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	9ea080e7          	jalr	-1558(ra) # 80001f36 <argint>
    80004554:	04054063          	bltz	a0,80004594 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004558:	fdc42703          	lw	a4,-36(s0)
    8000455c:	47bd                	li	a5,15
    8000455e:	02e7ed63          	bltu	a5,a4,80004598 <argfd+0x60>
    80004562:	ffffd097          	auipc	ra,0xffffd
    80004566:	91a080e7          	jalr	-1766(ra) # 80000e7c <myproc>
    8000456a:	fdc42703          	lw	a4,-36(s0)
    8000456e:	01a70793          	addi	a5,a4,26
    80004572:	078e                	slli	a5,a5,0x3
    80004574:	953e                	add	a0,a0,a5
    80004576:	611c                	ld	a5,0(a0)
    80004578:	c395                	beqz	a5,8000459c <argfd+0x64>
    return -1;
  if(pfd)
    8000457a:	00090463          	beqz	s2,80004582 <argfd+0x4a>
    *pfd = fd;
    8000457e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004582:	4501                	li	a0,0
  if(pf)
    80004584:	c091                	beqz	s1,80004588 <argfd+0x50>
    *pf = f;
    80004586:	e09c                	sd	a5,0(s1)
}
    80004588:	70a2                	ld	ra,40(sp)
    8000458a:	7402                	ld	s0,32(sp)
    8000458c:	64e2                	ld	s1,24(sp)
    8000458e:	6942                	ld	s2,16(sp)
    80004590:	6145                	addi	sp,sp,48
    80004592:	8082                	ret
    return -1;
    80004594:	557d                	li	a0,-1
    80004596:	bfcd                	j	80004588 <argfd+0x50>
    return -1;
    80004598:	557d                	li	a0,-1
    8000459a:	b7fd                	j	80004588 <argfd+0x50>
    8000459c:	557d                	li	a0,-1
    8000459e:	b7ed                	j	80004588 <argfd+0x50>

00000000800045a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045a0:	1101                	addi	sp,sp,-32
    800045a2:	ec06                	sd	ra,24(sp)
    800045a4:	e822                	sd	s0,16(sp)
    800045a6:	e426                	sd	s1,8(sp)
    800045a8:	1000                	addi	s0,sp,32
    800045aa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045ac:	ffffd097          	auipc	ra,0xffffd
    800045b0:	8d0080e7          	jalr	-1840(ra) # 80000e7c <myproc>
    800045b4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045b6:	0d050793          	addi	a5,a0,208
    800045ba:	4501                	li	a0,0
    800045bc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045be:	6398                	ld	a4,0(a5)
    800045c0:	cb19                	beqz	a4,800045d6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045c2:	2505                	addiw	a0,a0,1
    800045c4:	07a1                	addi	a5,a5,8
    800045c6:	fed51ce3          	bne	a0,a3,800045be <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045ca:	557d                	li	a0,-1
}
    800045cc:	60e2                	ld	ra,24(sp)
    800045ce:	6442                	ld	s0,16(sp)
    800045d0:	64a2                	ld	s1,8(sp)
    800045d2:	6105                	addi	sp,sp,32
    800045d4:	8082                	ret
      p->ofile[fd] = f;
    800045d6:	01a50793          	addi	a5,a0,26
    800045da:	078e                	slli	a5,a5,0x3
    800045dc:	963e                	add	a2,a2,a5
    800045de:	e204                	sd	s1,0(a2)
      return fd;
    800045e0:	b7f5                	j	800045cc <fdalloc+0x2c>

00000000800045e2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045e2:	715d                	addi	sp,sp,-80
    800045e4:	e486                	sd	ra,72(sp)
    800045e6:	e0a2                	sd	s0,64(sp)
    800045e8:	fc26                	sd	s1,56(sp)
    800045ea:	f84a                	sd	s2,48(sp)
    800045ec:	f44e                	sd	s3,40(sp)
    800045ee:	f052                	sd	s4,32(sp)
    800045f0:	ec56                	sd	s5,24(sp)
    800045f2:	0880                	addi	s0,sp,80
    800045f4:	8aae                	mv	s5,a1
    800045f6:	8a32                	mv	s4,a2
    800045f8:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045fa:	fb040593          	addi	a1,s0,-80
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	e14080e7          	jalr	-492(ra) # 80003412 <nameiparent>
    80004606:	892a                	mv	s2,a0
    80004608:	12050c63          	beqz	a0,80004740 <create+0x15e>
    return 0;

  ilock(dp);
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	566080e7          	jalr	1382(ra) # 80002b72 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004614:	4601                	li	a2,0
    80004616:	fb040593          	addi	a1,s0,-80
    8000461a:	854a                	mv	a0,s2
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	b06080e7          	jalr	-1274(ra) # 80003122 <dirlookup>
    80004624:	84aa                	mv	s1,a0
    80004626:	c539                	beqz	a0,80004674 <create+0x92>
    iunlockput(dp);
    80004628:	854a                	mv	a0,s2
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	85c080e7          	jalr	-1956(ra) # 80002e86 <iunlockput>
    ilock(ip);
    80004632:	8526                	mv	a0,s1
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	53e080e7          	jalr	1342(ra) # 80002b72 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000463c:	4789                	li	a5,2
    8000463e:	02fa9463          	bne	s5,a5,80004666 <create+0x84>
    80004642:	0444d783          	lhu	a5,68(s1)
    80004646:	37f9                	addiw	a5,a5,-2
    80004648:	17c2                	slli	a5,a5,0x30
    8000464a:	93c1                	srli	a5,a5,0x30
    8000464c:	4705                	li	a4,1
    8000464e:	00f76c63          	bltu	a4,a5,80004666 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004652:	8526                	mv	a0,s1
    80004654:	60a6                	ld	ra,72(sp)
    80004656:	6406                	ld	s0,64(sp)
    80004658:	74e2                	ld	s1,56(sp)
    8000465a:	7942                	ld	s2,48(sp)
    8000465c:	79a2                	ld	s3,40(sp)
    8000465e:	7a02                	ld	s4,32(sp)
    80004660:	6ae2                	ld	s5,24(sp)
    80004662:	6161                	addi	sp,sp,80
    80004664:	8082                	ret
    iunlockput(ip);
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	81e080e7          	jalr	-2018(ra) # 80002e86 <iunlockput>
    return 0;
    80004670:	4481                	li	s1,0
    80004672:	b7c5                	j	80004652 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004674:	85d6                	mv	a1,s5
    80004676:	00092503          	lw	a0,0(s2)
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	364080e7          	jalr	868(ra) # 800029de <ialloc>
    80004682:	84aa                	mv	s1,a0
    80004684:	c139                	beqz	a0,800046ca <create+0xe8>
  ilock(ip);
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	4ec080e7          	jalr	1260(ra) # 80002b72 <ilock>
  ip->major = major;
    8000468e:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004692:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004696:	4985                	li	s3,1
    80004698:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000469c:	8526                	mv	a0,s1
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	408080e7          	jalr	1032(ra) # 80002aa6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a6:	033a8a63          	beq	s5,s3,800046da <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800046aa:	40d0                	lw	a2,4(s1)
    800046ac:	fb040593          	addi	a1,s0,-80
    800046b0:	854a                	mv	a0,s2
    800046b2:	fffff097          	auipc	ra,0xfffff
    800046b6:	c80080e7          	jalr	-896(ra) # 80003332 <dirlink>
    800046ba:	06054b63          	bltz	a0,80004730 <create+0x14e>
  iunlockput(dp);
    800046be:	854a                	mv	a0,s2
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	7c6080e7          	jalr	1990(ra) # 80002e86 <iunlockput>
  return ip;
    800046c8:	b769                	j	80004652 <create+0x70>
    panic("create: ialloc");
    800046ca:	00004517          	auipc	a0,0x4
    800046ce:	ea650513          	addi	a0,a0,-346 # 80008570 <etext+0x570>
    800046d2:	00002097          	auipc	ra,0x2
    800046d6:	85a080e7          	jalr	-1958(ra) # 80005f2c <panic>
    dp->nlink++;  // for ".."
    800046da:	04a95783          	lhu	a5,74(s2)
    800046de:	2785                	addiw	a5,a5,1
    800046e0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046e4:	854a                	mv	a0,s2
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	3c0080e7          	jalr	960(ra) # 80002aa6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ee:	40d0                	lw	a2,4(s1)
    800046f0:	00004597          	auipc	a1,0x4
    800046f4:	e9058593          	addi	a1,a1,-368 # 80008580 <etext+0x580>
    800046f8:	8526                	mv	a0,s1
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	c38080e7          	jalr	-968(ra) # 80003332 <dirlink>
    80004702:	00054f63          	bltz	a0,80004720 <create+0x13e>
    80004706:	00492603          	lw	a2,4(s2)
    8000470a:	00004597          	auipc	a1,0x4
    8000470e:	e7e58593          	addi	a1,a1,-386 # 80008588 <etext+0x588>
    80004712:	8526                	mv	a0,s1
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	c1e080e7          	jalr	-994(ra) # 80003332 <dirlink>
    8000471c:	f80557e3          	bgez	a0,800046aa <create+0xc8>
      panic("create dots");
    80004720:	00004517          	auipc	a0,0x4
    80004724:	e7050513          	addi	a0,a0,-400 # 80008590 <etext+0x590>
    80004728:	00002097          	auipc	ra,0x2
    8000472c:	804080e7          	jalr	-2044(ra) # 80005f2c <panic>
    panic("create: dirlink");
    80004730:	00004517          	auipc	a0,0x4
    80004734:	e7050513          	addi	a0,a0,-400 # 800085a0 <etext+0x5a0>
    80004738:	00001097          	auipc	ra,0x1
    8000473c:	7f4080e7          	jalr	2036(ra) # 80005f2c <panic>
    return 0;
    80004740:	84aa                	mv	s1,a0
    80004742:	bf01                	j	80004652 <create+0x70>

0000000080004744 <sys_dup>:
{
    80004744:	7179                	addi	sp,sp,-48
    80004746:	f406                	sd	ra,40(sp)
    80004748:	f022                	sd	s0,32(sp)
    8000474a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000474c:	fd840613          	addi	a2,s0,-40
    80004750:	4581                	li	a1,0
    80004752:	4501                	li	a0,0
    80004754:	00000097          	auipc	ra,0x0
    80004758:	de4080e7          	jalr	-540(ra) # 80004538 <argfd>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000475e:	02054763          	bltz	a0,8000478c <sys_dup+0x48>
    80004762:	ec26                	sd	s1,24(sp)
    80004764:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004766:	fd843903          	ld	s2,-40(s0)
    8000476a:	854a                	mv	a0,s2
    8000476c:	00000097          	auipc	ra,0x0
    80004770:	e34080e7          	jalr	-460(ra) # 800045a0 <fdalloc>
    80004774:	84aa                	mv	s1,a0
    return -1;
    80004776:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004778:	00054f63          	bltz	a0,80004796 <sys_dup+0x52>
  filedup(f);
    8000477c:	854a                	mv	a0,s2
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	2ee080e7          	jalr	750(ra) # 80003a6c <filedup>
  return fd;
    80004786:	87a6                	mv	a5,s1
    80004788:	64e2                	ld	s1,24(sp)
    8000478a:	6942                	ld	s2,16(sp)
}
    8000478c:	853e                	mv	a0,a5
    8000478e:	70a2                	ld	ra,40(sp)
    80004790:	7402                	ld	s0,32(sp)
    80004792:	6145                	addi	sp,sp,48
    80004794:	8082                	ret
    80004796:	64e2                	ld	s1,24(sp)
    80004798:	6942                	ld	s2,16(sp)
    8000479a:	bfcd                	j	8000478c <sys_dup+0x48>

000000008000479c <sys_read>:
{
    8000479c:	7179                	addi	sp,sp,-48
    8000479e:	f406                	sd	ra,40(sp)
    800047a0:	f022                	sd	s0,32(sp)
    800047a2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a4:	fe840613          	addi	a2,s0,-24
    800047a8:	4581                	li	a1,0
    800047aa:	4501                	li	a0,0
    800047ac:	00000097          	auipc	ra,0x0
    800047b0:	d8c080e7          	jalr	-628(ra) # 80004538 <argfd>
    return -1;
    800047b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b6:	04054163          	bltz	a0,800047f8 <sys_read+0x5c>
    800047ba:	fe440593          	addi	a1,s0,-28
    800047be:	4509                	li	a0,2
    800047c0:	ffffd097          	auipc	ra,0xffffd
    800047c4:	776080e7          	jalr	1910(ra) # 80001f36 <argint>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ca:	02054763          	bltz	a0,800047f8 <sys_read+0x5c>
    800047ce:	fd840593          	addi	a1,s0,-40
    800047d2:	4505                	li	a0,1
    800047d4:	ffffd097          	auipc	ra,0xffffd
    800047d8:	784080e7          	jalr	1924(ra) # 80001f58 <argaddr>
    return -1;
    800047dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047de:	00054d63          	bltz	a0,800047f8 <sys_read+0x5c>
  return fileread(f, p, n);
    800047e2:	fe442603          	lw	a2,-28(s0)
    800047e6:	fd843583          	ld	a1,-40(s0)
    800047ea:	fe843503          	ld	a0,-24(s0)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	424080e7          	jalr	1060(ra) # 80003c12 <fileread>
    800047f6:	87aa                	mv	a5,a0
}
    800047f8:	853e                	mv	a0,a5
    800047fa:	70a2                	ld	ra,40(sp)
    800047fc:	7402                	ld	s0,32(sp)
    800047fe:	6145                	addi	sp,sp,48
    80004800:	8082                	ret

0000000080004802 <sys_write>:
{
    80004802:	7179                	addi	sp,sp,-48
    80004804:	f406                	sd	ra,40(sp)
    80004806:	f022                	sd	s0,32(sp)
    80004808:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480a:	fe840613          	addi	a2,s0,-24
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	d26080e7          	jalr	-730(ra) # 80004538 <argfd>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481c:	04054163          	bltz	a0,8000485e <sys_write+0x5c>
    80004820:	fe440593          	addi	a1,s0,-28
    80004824:	4509                	li	a0,2
    80004826:	ffffd097          	auipc	ra,0xffffd
    8000482a:	710080e7          	jalr	1808(ra) # 80001f36 <argint>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004830:	02054763          	bltz	a0,8000485e <sys_write+0x5c>
    80004834:	fd840593          	addi	a1,s0,-40
    80004838:	4505                	li	a0,1
    8000483a:	ffffd097          	auipc	ra,0xffffd
    8000483e:	71e080e7          	jalr	1822(ra) # 80001f58 <argaddr>
    return -1;
    80004842:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004844:	00054d63          	bltz	a0,8000485e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004848:	fe442603          	lw	a2,-28(s0)
    8000484c:	fd843583          	ld	a1,-40(s0)
    80004850:	fe843503          	ld	a0,-24(s0)
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	490080e7          	jalr	1168(ra) # 80003ce4 <filewrite>
    8000485c:	87aa                	mv	a5,a0
}
    8000485e:	853e                	mv	a0,a5
    80004860:	70a2                	ld	ra,40(sp)
    80004862:	7402                	ld	s0,32(sp)
    80004864:	6145                	addi	sp,sp,48
    80004866:	8082                	ret

0000000080004868 <sys_close>:
{
    80004868:	1101                	addi	sp,sp,-32
    8000486a:	ec06                	sd	ra,24(sp)
    8000486c:	e822                	sd	s0,16(sp)
    8000486e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004870:	fe040613          	addi	a2,s0,-32
    80004874:	fec40593          	addi	a1,s0,-20
    80004878:	4501                	li	a0,0
    8000487a:	00000097          	auipc	ra,0x0
    8000487e:	cbe080e7          	jalr	-834(ra) # 80004538 <argfd>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004884:	02054463          	bltz	a0,800048ac <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004888:	ffffc097          	auipc	ra,0xffffc
    8000488c:	5f4080e7          	jalr	1524(ra) # 80000e7c <myproc>
    80004890:	fec42783          	lw	a5,-20(s0)
    80004894:	07e9                	addi	a5,a5,26
    80004896:	078e                	slli	a5,a5,0x3
    80004898:	953e                	add	a0,a0,a5
    8000489a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000489e:	fe043503          	ld	a0,-32(s0)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	21c080e7          	jalr	540(ra) # 80003abe <fileclose>
  return 0;
    800048aa:	4781                	li	a5,0
}
    800048ac:	853e                	mv	a0,a5
    800048ae:	60e2                	ld	ra,24(sp)
    800048b0:	6442                	ld	s0,16(sp)
    800048b2:	6105                	addi	sp,sp,32
    800048b4:	8082                	ret

00000000800048b6 <sys_fstat>:
{
    800048b6:	1101                	addi	sp,sp,-32
    800048b8:	ec06                	sd	ra,24(sp)
    800048ba:	e822                	sd	s0,16(sp)
    800048bc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048be:	fe840613          	addi	a2,s0,-24
    800048c2:	4581                	li	a1,0
    800048c4:	4501                	li	a0,0
    800048c6:	00000097          	auipc	ra,0x0
    800048ca:	c72080e7          	jalr	-910(ra) # 80004538 <argfd>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d0:	02054563          	bltz	a0,800048fa <sys_fstat+0x44>
    800048d4:	fe040593          	addi	a1,s0,-32
    800048d8:	4505                	li	a0,1
    800048da:	ffffd097          	auipc	ra,0xffffd
    800048de:	67e080e7          	jalr	1662(ra) # 80001f58 <argaddr>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e4:	00054b63          	bltz	a0,800048fa <sys_fstat+0x44>
  return filestat(f, st);
    800048e8:	fe043583          	ld	a1,-32(s0)
    800048ec:	fe843503          	ld	a0,-24(s0)
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	2b0080e7          	jalr	688(ra) # 80003ba0 <filestat>
    800048f8:	87aa                	mv	a5,a0
}
    800048fa:	853e                	mv	a0,a5
    800048fc:	60e2                	ld	ra,24(sp)
    800048fe:	6442                	ld	s0,16(sp)
    80004900:	6105                	addi	sp,sp,32
    80004902:	8082                	ret

0000000080004904 <sys_link>:
{
    80004904:	7169                	addi	sp,sp,-304
    80004906:	f606                	sd	ra,296(sp)
    80004908:	f222                	sd	s0,288(sp)
    8000490a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490c:	08000613          	li	a2,128
    80004910:	ed040593          	addi	a1,s0,-304
    80004914:	4501                	li	a0,0
    80004916:	ffffd097          	auipc	ra,0xffffd
    8000491a:	664080e7          	jalr	1636(ra) # 80001f7a <argstr>
    return -1;
    8000491e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004920:	12054663          	bltz	a0,80004a4c <sys_link+0x148>
    80004924:	08000613          	li	a2,128
    80004928:	f5040593          	addi	a1,s0,-176
    8000492c:	4505                	li	a0,1
    8000492e:	ffffd097          	auipc	ra,0xffffd
    80004932:	64c080e7          	jalr	1612(ra) # 80001f7a <argstr>
    return -1;
    80004936:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004938:	10054a63          	bltz	a0,80004a4c <sys_link+0x148>
    8000493c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	cb6080e7          	jalr	-842(ra) # 800035f4 <begin_op>
  if((ip = namei(old)) == 0){
    80004946:	ed040513          	addi	a0,s0,-304
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	aaa080e7          	jalr	-1366(ra) # 800033f4 <namei>
    80004952:	84aa                	mv	s1,a0
    80004954:	c949                	beqz	a0,800049e6 <sys_link+0xe2>
  ilock(ip);
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	21c080e7          	jalr	540(ra) # 80002b72 <ilock>
  if(ip->type == T_DIR){
    8000495e:	04449703          	lh	a4,68(s1)
    80004962:	4785                	li	a5,1
    80004964:	08f70863          	beq	a4,a5,800049f4 <sys_link+0xf0>
    80004968:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000496a:	04a4d783          	lhu	a5,74(s1)
    8000496e:	2785                	addiw	a5,a5,1
    80004970:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	130080e7          	jalr	304(ra) # 80002aa6 <iupdate>
  iunlock(ip);
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	2b8080e7          	jalr	696(ra) # 80002c38 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004988:	fd040593          	addi	a1,s0,-48
    8000498c:	f5040513          	addi	a0,s0,-176
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	a82080e7          	jalr	-1406(ra) # 80003412 <nameiparent>
    80004998:	892a                	mv	s2,a0
    8000499a:	cd35                	beqz	a0,80004a16 <sys_link+0x112>
  ilock(dp);
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	1d6080e7          	jalr	470(ra) # 80002b72 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049a4:	00092703          	lw	a4,0(s2)
    800049a8:	409c                	lw	a5,0(s1)
    800049aa:	06f71163          	bne	a4,a5,80004a0c <sys_link+0x108>
    800049ae:	40d0                	lw	a2,4(s1)
    800049b0:	fd040593          	addi	a1,s0,-48
    800049b4:	854a                	mv	a0,s2
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	97c080e7          	jalr	-1668(ra) # 80003332 <dirlink>
    800049be:	04054763          	bltz	a0,80004a0c <sys_link+0x108>
  iunlockput(dp);
    800049c2:	854a                	mv	a0,s2
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	4c2080e7          	jalr	1218(ra) # 80002e86 <iunlockput>
  iput(ip);
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	410080e7          	jalr	1040(ra) # 80002dde <iput>
  end_op();
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	c98080e7          	jalr	-872(ra) # 8000366e <end_op>
  return 0;
    800049de:	4781                	li	a5,0
    800049e0:	64f2                	ld	s1,280(sp)
    800049e2:	6952                	ld	s2,272(sp)
    800049e4:	a0a5                	j	80004a4c <sys_link+0x148>
    end_op();
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	c88080e7          	jalr	-888(ra) # 8000366e <end_op>
    return -1;
    800049ee:	57fd                	li	a5,-1
    800049f0:	64f2                	ld	s1,280(sp)
    800049f2:	a8a9                	j	80004a4c <sys_link+0x148>
    iunlockput(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	490080e7          	jalr	1168(ra) # 80002e86 <iunlockput>
    end_op();
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	c70080e7          	jalr	-912(ra) # 8000366e <end_op>
    return -1;
    80004a06:	57fd                	li	a5,-1
    80004a08:	64f2                	ld	s1,280(sp)
    80004a0a:	a089                	j	80004a4c <sys_link+0x148>
    iunlockput(dp);
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	478080e7          	jalr	1144(ra) # 80002e86 <iunlockput>
  ilock(ip);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	15a080e7          	jalr	346(ra) # 80002b72 <ilock>
  ip->nlink--;
    80004a20:	04a4d783          	lhu	a5,74(s1)
    80004a24:	37fd                	addiw	a5,a5,-1
    80004a26:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	07a080e7          	jalr	122(ra) # 80002aa6 <iupdate>
  iunlockput(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	450080e7          	jalr	1104(ra) # 80002e86 <iunlockput>
  end_op();
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	c30080e7          	jalr	-976(ra) # 8000366e <end_op>
  return -1;
    80004a46:	57fd                	li	a5,-1
    80004a48:	64f2                	ld	s1,280(sp)
    80004a4a:	6952                	ld	s2,272(sp)
}
    80004a4c:	853e                	mv	a0,a5
    80004a4e:	70b2                	ld	ra,296(sp)
    80004a50:	7412                	ld	s0,288(sp)
    80004a52:	6155                	addi	sp,sp,304
    80004a54:	8082                	ret

0000000080004a56 <sys_unlink>:
{
    80004a56:	7151                	addi	sp,sp,-240
    80004a58:	f586                	sd	ra,232(sp)
    80004a5a:	f1a2                	sd	s0,224(sp)
    80004a5c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a5e:	08000613          	li	a2,128
    80004a62:	f3040593          	addi	a1,s0,-208
    80004a66:	4501                	li	a0,0
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	512080e7          	jalr	1298(ra) # 80001f7a <argstr>
    80004a70:	1a054a63          	bltz	a0,80004c24 <sys_unlink+0x1ce>
    80004a74:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	b7e080e7          	jalr	-1154(ra) # 800035f4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a7e:	fb040593          	addi	a1,s0,-80
    80004a82:	f3040513          	addi	a0,s0,-208
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	98c080e7          	jalr	-1652(ra) # 80003412 <nameiparent>
    80004a8e:	84aa                	mv	s1,a0
    80004a90:	cd71                	beqz	a0,80004b6c <sys_unlink+0x116>
  ilock(dp);
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	0e0080e7          	jalr	224(ra) # 80002b72 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9a:	00004597          	auipc	a1,0x4
    80004a9e:	ae658593          	addi	a1,a1,-1306 # 80008580 <etext+0x580>
    80004aa2:	fb040513          	addi	a0,s0,-80
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	662080e7          	jalr	1634(ra) # 80003108 <namecmp>
    80004aae:	14050c63          	beqz	a0,80004c06 <sys_unlink+0x1b0>
    80004ab2:	00004597          	auipc	a1,0x4
    80004ab6:	ad658593          	addi	a1,a1,-1322 # 80008588 <etext+0x588>
    80004aba:	fb040513          	addi	a0,s0,-80
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	64a080e7          	jalr	1610(ra) # 80003108 <namecmp>
    80004ac6:	14050063          	beqz	a0,80004c06 <sys_unlink+0x1b0>
    80004aca:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004acc:	f2c40613          	addi	a2,s0,-212
    80004ad0:	fb040593          	addi	a1,s0,-80
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	64c080e7          	jalr	1612(ra) # 80003122 <dirlookup>
    80004ade:	892a                	mv	s2,a0
    80004ae0:	12050263          	beqz	a0,80004c04 <sys_unlink+0x1ae>
  ilock(ip);
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	08e080e7          	jalr	142(ra) # 80002b72 <ilock>
  if(ip->nlink < 1)
    80004aec:	04a91783          	lh	a5,74(s2)
    80004af0:	08f05563          	blez	a5,80004b7a <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004af4:	04491703          	lh	a4,68(s2)
    80004af8:	4785                	li	a5,1
    80004afa:	08f70963          	beq	a4,a5,80004b8c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004afe:	4641                	li	a2,16
    80004b00:	4581                	li	a1,0
    80004b02:	fc040513          	addi	a0,s0,-64
    80004b06:	ffffb097          	auipc	ra,0xffffb
    80004b0a:	674080e7          	jalr	1652(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b0e:	4741                	li	a4,16
    80004b10:	f2c42683          	lw	a3,-212(s0)
    80004b14:	fc040613          	addi	a2,s0,-64
    80004b18:	4581                	li	a1,0
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	4c0080e7          	jalr	1216(ra) # 80002fdc <writei>
    80004b24:	47c1                	li	a5,16
    80004b26:	0af51b63          	bne	a0,a5,80004bdc <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b2a:	04491703          	lh	a4,68(s2)
    80004b2e:	4785                	li	a5,1
    80004b30:	0af70f63          	beq	a4,a5,80004bee <sys_unlink+0x198>
  iunlockput(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	350080e7          	jalr	848(ra) # 80002e86 <iunlockput>
  ip->nlink--;
    80004b3e:	04a95783          	lhu	a5,74(s2)
    80004b42:	37fd                	addiw	a5,a5,-1
    80004b44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b48:	854a                	mv	a0,s2
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	f5c080e7          	jalr	-164(ra) # 80002aa6 <iupdate>
  iunlockput(ip);
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	332080e7          	jalr	818(ra) # 80002e86 <iunlockput>
  end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	b12080e7          	jalr	-1262(ra) # 8000366e <end_op>
  return 0;
    80004b64:	4501                	li	a0,0
    80004b66:	64ee                	ld	s1,216(sp)
    80004b68:	694e                	ld	s2,208(sp)
    80004b6a:	a84d                	j	80004c1c <sys_unlink+0x1c6>
    end_op();
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	b02080e7          	jalr	-1278(ra) # 8000366e <end_op>
    return -1;
    80004b74:	557d                	li	a0,-1
    80004b76:	64ee                	ld	s1,216(sp)
    80004b78:	a055                	j	80004c1c <sys_unlink+0x1c6>
    80004b7a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b7c:	00004517          	auipc	a0,0x4
    80004b80:	a3450513          	addi	a0,a0,-1484 # 800085b0 <etext+0x5b0>
    80004b84:	00001097          	auipc	ra,0x1
    80004b88:	3a8080e7          	jalr	936(ra) # 80005f2c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8c:	04c92703          	lw	a4,76(s2)
    80004b90:	02000793          	li	a5,32
    80004b94:	f6e7f5e3          	bgeu	a5,a4,80004afe <sys_unlink+0xa8>
    80004b98:	e5ce                	sd	s3,200(sp)
    80004b9a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b9e:	4741                	li	a4,16
    80004ba0:	86ce                	mv	a3,s3
    80004ba2:	f1840613          	addi	a2,s0,-232
    80004ba6:	4581                	li	a1,0
    80004ba8:	854a                	mv	a0,s2
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	32e080e7          	jalr	814(ra) # 80002ed8 <readi>
    80004bb2:	47c1                	li	a5,16
    80004bb4:	00f51c63          	bne	a0,a5,80004bcc <sys_unlink+0x176>
    if(de.inum != 0)
    80004bb8:	f1845783          	lhu	a5,-232(s0)
    80004bbc:	e7b5                	bnez	a5,80004c28 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bbe:	29c1                	addiw	s3,s3,16
    80004bc0:	04c92783          	lw	a5,76(s2)
    80004bc4:	fcf9ede3          	bltu	s3,a5,80004b9e <sys_unlink+0x148>
    80004bc8:	69ae                	ld	s3,200(sp)
    80004bca:	bf15                	j	80004afe <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	9fc50513          	addi	a0,a0,-1540 # 800085c8 <etext+0x5c8>
    80004bd4:	00001097          	auipc	ra,0x1
    80004bd8:	358080e7          	jalr	856(ra) # 80005f2c <panic>
    80004bdc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bde:	00004517          	auipc	a0,0x4
    80004be2:	a0250513          	addi	a0,a0,-1534 # 800085e0 <etext+0x5e0>
    80004be6:	00001097          	auipc	ra,0x1
    80004bea:	346080e7          	jalr	838(ra) # 80005f2c <panic>
    dp->nlink--;
    80004bee:	04a4d783          	lhu	a5,74(s1)
    80004bf2:	37fd                	addiw	a5,a5,-1
    80004bf4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	eac080e7          	jalr	-340(ra) # 80002aa6 <iupdate>
    80004c02:	bf0d                	j	80004b34 <sys_unlink+0xde>
    80004c04:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c06:	8526                	mv	a0,s1
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	27e080e7          	jalr	638(ra) # 80002e86 <iunlockput>
  end_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	a5e080e7          	jalr	-1442(ra) # 8000366e <end_op>
  return -1;
    80004c18:	557d                	li	a0,-1
    80004c1a:	64ee                	ld	s1,216(sp)
}
    80004c1c:	70ae                	ld	ra,232(sp)
    80004c1e:	740e                	ld	s0,224(sp)
    80004c20:	616d                	addi	sp,sp,240
    80004c22:	8082                	ret
    return -1;
    80004c24:	557d                	li	a0,-1
    80004c26:	bfdd                	j	80004c1c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c28:	854a                	mv	a0,s2
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	25c080e7          	jalr	604(ra) # 80002e86 <iunlockput>
    goto bad;
    80004c32:	694e                	ld	s2,208(sp)
    80004c34:	69ae                	ld	s3,200(sp)
    80004c36:	bfc1                	j	80004c06 <sys_unlink+0x1b0>

0000000080004c38 <sys_open>:

uint64
sys_open(void)
{
    80004c38:	7155                	addi	sp,sp,-208
    80004c3a:	e586                	sd	ra,200(sp)
    80004c3c:	e1a2                	sd	s0,192(sp)
    80004c3e:	f94a                	sd	s2,176(sp)
    80004c40:	0980                	addi	s0,sp,208
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c42:	08000613          	li	a2,128
    80004c46:	f4040593          	addi	a1,s0,-192
    80004c4a:	4501                	li	a0,0
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	32e080e7          	jalr	814(ra) # 80001f7a <argstr>
    return -1;
    80004c54:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c56:	1c054e63          	bltz	a0,80004e32 <sys_open+0x1fa>
    80004c5a:	f3c40593          	addi	a1,s0,-196
    80004c5e:	4505                	li	a0,1
    80004c60:	ffffd097          	auipc	ra,0xffffd
    80004c64:	2d6080e7          	jalr	726(ra) # 80001f36 <argint>
    80004c68:	1c054563          	bltz	a0,80004e32 <sys_open+0x1fa>
    80004c6c:	fd26                	sd	s1,184(sp)

  begin_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	986080e7          	jalr	-1658(ra) # 800035f4 <begin_op>

  if(omode & O_CREATE){
    80004c76:	f3c42783          	lw	a5,-196(s0)
    80004c7a:	2007f793          	andi	a5,a5,512
    80004c7e:	c3dd                	beqz	a5,80004d24 <sys_open+0xec>
    ip = create(path, T_FILE, 0, 0);
    80004c80:	4681                	li	a3,0
    80004c82:	4601                	li	a2,0
    80004c84:	4589                	li	a1,2
    80004c86:	f4040513          	addi	a0,s0,-192
    80004c8a:	00000097          	auipc	ra,0x0
    80004c8e:	958080e7          	jalr	-1704(ra) # 800045e2 <create>
    80004c92:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c94:	c151                	beqz	a0,80004d18 <sys_open+0xe0>
    80004c96:	f54e                	sd	s3,168(sp)
    80004c98:	f152                	sd	s4,160(sp)
    80004c9a:	ed56                	sd	s5,152(sp)
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c9c:	04449783          	lh	a5,68(s1)
    80004ca0:	470d                	li	a4,3
    80004ca2:	0ce78a63          	beq	a5,a4,80004d76 <sys_open+0x13e>
    end_op();
    return -1;
  }

  int layer=0;
  while(ip->type == T_SYMLINK && !(omode & O_NOFOLLOW)){
    80004ca6:	4711                	li	a4,4
    80004ca8:	4929                	li	s2,10
    80004caa:	1ce79663          	bne	a5,a4,80004e76 <sys_open+0x23e>
    80004cae:	6985                	lui	s3,0x1
    80004cb0:	80098993          	addi	s3,s3,-2048 # 800 <_entry-0x7ffff800>
      end_op();
      return -1;
    }
    else{
      // 读取 inode
      if(readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) {
    80004cb4:	07f00a13          	li	s4,127
  while(ip->type == T_SYMLINK && !(omode & O_NOFOLLOW)){
    80004cb8:	4a91                	li	s5,4
    80004cba:	f3c42783          	lw	a5,-196(s0)
    80004cbe:	0137f7b3          	and	a5,a5,s3
    80004cc2:	1a079763          	bnez	a5,80004e70 <sys_open+0x238>
    if(layer==10){
    80004cc6:	397d                	addiw	s2,s2,-1
    80004cc8:	14090763          	beqz	s2,80004e16 <sys_open+0x1de>
      if(readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) {
    80004ccc:	08000713          	li	a4,128
    80004cd0:	4681                	li	a3,0
    80004cd2:	f4040613          	addi	a2,s0,-192
    80004cd6:	4581                	li	a1,0
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	1fe080e7          	jalr	510(ra) # 80002ed8 <readi>
    80004ce2:	14aa5e63          	bge	s4,a0,80004e3e <sys_open+0x206>
        iunlockput(ip);
        end_op();
        return -1;
      }
      iunlockput(ip);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	19e080e7          	jalr	414(ra) # 80002e86 <iunlockput>
      // 文件名匹配inode
      ip = namei(path);
    80004cf0:	f4040513          	addi	a0,s0,-192
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	700080e7          	jalr	1792(ra) # 800033f4 <namei>
    80004cfc:	84aa                	mv	s1,a0
      if(ip==0){
    80004cfe:	14050f63          	beqz	a0,80004e5c <sys_open+0x224>
        end_op();
        return -1;
      }
      ilock(ip);
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	e70080e7          	jalr	-400(ra) # 80002b72 <ilock>
  while(ip->type == T_SYMLINK && !(omode & O_NOFOLLOW)){
    80004d0a:	04449783          	lh	a5,68(s1)
    80004d0e:	fb5786e3          	beq	a5,s5,80004cba <sys_open+0x82>
    80004d12:	7a0a                	ld	s4,160(sp)
    80004d14:	6aea                	ld	s5,152(sp)
    80004d16:	a0bd                	j	80004d84 <sys_open+0x14c>
      end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	956080e7          	jalr	-1706(ra) # 8000366e <end_op>
      return -1;
    80004d20:	74ea                	ld	s1,184(sp)
    80004d22:	aa01                	j	80004e32 <sys_open+0x1fa>
    if((ip = namei(path)) == 0){
    80004d24:	f4040513          	addi	a0,s0,-192
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	6cc080e7          	jalr	1740(ra) # 800033f4 <namei>
    80004d30:	84aa                	mv	s1,a0
    80004d32:	cd19                	beqz	a0,80004d50 <sys_open+0x118>
    ilock(ip);
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	e3e080e7          	jalr	-450(ra) # 80002b72 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d3c:	04449703          	lh	a4,68(s1)
    80004d40:	4785                	li	a5,1
    80004d42:	f4f71ae3          	bne	a4,a5,80004c96 <sys_open+0x5e>
    80004d46:	f3c42783          	lw	a5,-196(s0)
    80004d4a:	eb91                	bnez	a5,80004d5e <sys_open+0x126>
    80004d4c:	f54e                	sd	s3,168(sp)
    80004d4e:	a81d                	j	80004d84 <sys_open+0x14c>
      end_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	91e080e7          	jalr	-1762(ra) # 8000366e <end_op>
      return -1;
    80004d58:	597d                	li	s2,-1
    80004d5a:	74ea                	ld	s1,184(sp)
    80004d5c:	a8d9                	j	80004e32 <sys_open+0x1fa>
      iunlockput(ip);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	126080e7          	jalr	294(ra) # 80002e86 <iunlockput>
      end_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	906080e7          	jalr	-1786(ra) # 8000366e <end_op>
      return -1;
    80004d70:	597d                	li	s2,-1
    80004d72:	74ea                	ld	s1,184(sp)
    80004d74:	a87d                	j	80004e32 <sys_open+0x1fa>
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d76:	0464d703          	lhu	a4,70(s1)
    80004d7a:	47a5                	li	a5,9
    80004d7c:	06e7ee63          	bltu	a5,a4,80004df8 <sys_open+0x1c0>
    80004d80:	7a0a                	ld	s4,160(sp)
    80004d82:	6aea                	ld	s5,152(sp)
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	c7e080e7          	jalr	-898(ra) # 80003a02 <filealloc>
    80004d8c:	89aa                	mv	s3,a0
    80004d8e:	cd65                	beqz	a0,80004e86 <sys_open+0x24e>
    80004d90:	00000097          	auipc	ra,0x0
    80004d94:	810080e7          	jalr	-2032(ra) # 800045a0 <fdalloc>
    80004d98:	892a                	mv	s2,a0
    80004d9a:	0e054163          	bltz	a0,80004e7c <sys_open+0x244>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d9e:	04449703          	lh	a4,68(s1)
    80004da2:	478d                	li	a5,3
    80004da4:	0ef70e63          	beq	a4,a5,80004ea0 <sys_open+0x268>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004da8:	4789                	li	a5,2
    80004daa:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dae:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004db2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004db6:	f3c42783          	lw	a5,-196(s0)
    80004dba:	0017c713          	xori	a4,a5,1
    80004dbe:	8b05                	andi	a4,a4,1
    80004dc0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dc4:	0037f713          	andi	a4,a5,3
    80004dc8:	00e03733          	snez	a4,a4
    80004dcc:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dd0:	4007f793          	andi	a5,a5,1024
    80004dd4:	c791                	beqz	a5,80004de0 <sys_open+0x1a8>
    80004dd6:	04449703          	lh	a4,68(s1)
    80004dda:	4789                	li	a5,2
    80004ddc:	0cf70963          	beq	a4,a5,80004eae <sys_open+0x276>
    itrunc(ip);
  }

  iunlock(ip);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	e56080e7          	jalr	-426(ra) # 80002c38 <iunlock>
  end_op();
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	884080e7          	jalr	-1916(ra) # 8000366e <end_op>
    80004df2:	74ea                	ld	s1,184(sp)
    80004df4:	79aa                	ld	s3,168(sp)

  return fd;
    80004df6:	a835                	j	80004e32 <sys_open+0x1fa>
    iunlockput(ip);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	08c080e7          	jalr	140(ra) # 80002e86 <iunlockput>
    end_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	86c080e7          	jalr	-1940(ra) # 8000366e <end_op>
    return -1;
    80004e0a:	597d                	li	s2,-1
    80004e0c:	74ea                	ld	s1,184(sp)
    80004e0e:	79aa                	ld	s3,168(sp)
    80004e10:	7a0a                	ld	s4,160(sp)
    80004e12:	6aea                	ld	s5,152(sp)
    80004e14:	a839                	j	80004e32 <sys_open+0x1fa>
      iunlockput(ip);
    80004e16:	8526                	mv	a0,s1
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	06e080e7          	jalr	110(ra) # 80002e86 <iunlockput>
      end_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	84e080e7          	jalr	-1970(ra) # 8000366e <end_op>
      return -1;
    80004e28:	597d                	li	s2,-1
    80004e2a:	74ea                	ld	s1,184(sp)
    80004e2c:	79aa                	ld	s3,168(sp)
    80004e2e:	7a0a                	ld	s4,160(sp)
    80004e30:	6aea                	ld	s5,152(sp)
}
    80004e32:	854a                	mv	a0,s2
    80004e34:	60ae                	ld	ra,200(sp)
    80004e36:	640e                	ld	s0,192(sp)
    80004e38:	794a                	ld	s2,176(sp)
    80004e3a:	6169                	addi	sp,sp,208
    80004e3c:	8082                	ret
        iunlockput(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	046080e7          	jalr	70(ra) # 80002e86 <iunlockput>
        end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	826080e7          	jalr	-2010(ra) # 8000366e <end_op>
        return -1;
    80004e50:	597d                	li	s2,-1
    80004e52:	74ea                	ld	s1,184(sp)
    80004e54:	79aa                	ld	s3,168(sp)
    80004e56:	7a0a                	ld	s4,160(sp)
    80004e58:	6aea                	ld	s5,152(sp)
    80004e5a:	bfe1                	j	80004e32 <sys_open+0x1fa>
        end_op();
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	812080e7          	jalr	-2030(ra) # 8000366e <end_op>
        return -1;
    80004e64:	597d                	li	s2,-1
    80004e66:	74ea                	ld	s1,184(sp)
    80004e68:	79aa                	ld	s3,168(sp)
    80004e6a:	7a0a                	ld	s4,160(sp)
    80004e6c:	6aea                	ld	s5,152(sp)
    80004e6e:	b7d1                	j	80004e32 <sys_open+0x1fa>
    80004e70:	7a0a                	ld	s4,160(sp)
    80004e72:	6aea                	ld	s5,152(sp)
    80004e74:	bf01                	j	80004d84 <sys_open+0x14c>
    80004e76:	7a0a                	ld	s4,160(sp)
    80004e78:	6aea                	ld	s5,152(sp)
    80004e7a:	b729                	j	80004d84 <sys_open+0x14c>
      fileclose(f);
    80004e7c:	854e                	mv	a0,s3
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	c40080e7          	jalr	-960(ra) # 80003abe <fileclose>
    iunlockput(ip);
    80004e86:	8526                	mv	a0,s1
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	ffe080e7          	jalr	-2(ra) # 80002e86 <iunlockput>
    end_op();
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	7de080e7          	jalr	2014(ra) # 8000366e <end_op>
    return -1;
    80004e98:	597d                	li	s2,-1
    80004e9a:	74ea                	ld	s1,184(sp)
    80004e9c:	79aa                	ld	s3,168(sp)
    80004e9e:	bf51                	j	80004e32 <sys_open+0x1fa>
    f->type = FD_DEVICE;
    80004ea0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ea4:	04649783          	lh	a5,70(s1)
    80004ea8:	02f99223          	sh	a5,36(s3)
    80004eac:	b719                	j	80004db2 <sys_open+0x17a>
    itrunc(ip);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	dd4080e7          	jalr	-556(ra) # 80002c84 <itrunc>
    80004eb8:	b725                	j	80004de0 <sys_open+0x1a8>

0000000080004eba <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eba:	7175                	addi	sp,sp,-144
    80004ebc:	e506                	sd	ra,136(sp)
    80004ebe:	e122                	sd	s0,128(sp)
    80004ec0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	732080e7          	jalr	1842(ra) # 800035f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004eca:	08000613          	li	a2,128
    80004ece:	f7040593          	addi	a1,s0,-144
    80004ed2:	4501                	li	a0,0
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	0a6080e7          	jalr	166(ra) # 80001f7a <argstr>
    80004edc:	02054963          	bltz	a0,80004f0e <sys_mkdir+0x54>
    80004ee0:	4681                	li	a3,0
    80004ee2:	4601                	li	a2,0
    80004ee4:	4585                	li	a1,1
    80004ee6:	f7040513          	addi	a0,s0,-144
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	6f8080e7          	jalr	1784(ra) # 800045e2 <create>
    80004ef2:	cd11                	beqz	a0,80004f0e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	f92080e7          	jalr	-110(ra) # 80002e86 <iunlockput>
  end_op();
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	772080e7          	jalr	1906(ra) # 8000366e <end_op>
  return 0;
    80004f04:	4501                	li	a0,0
}
    80004f06:	60aa                	ld	ra,136(sp)
    80004f08:	640a                	ld	s0,128(sp)
    80004f0a:	6149                	addi	sp,sp,144
    80004f0c:	8082                	ret
    end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	760080e7          	jalr	1888(ra) # 8000366e <end_op>
    return -1;
    80004f16:	557d                	li	a0,-1
    80004f18:	b7fd                	j	80004f06 <sys_mkdir+0x4c>

0000000080004f1a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f1a:	7135                	addi	sp,sp,-160
    80004f1c:	ed06                	sd	ra,152(sp)
    80004f1e:	e922                	sd	s0,144(sp)
    80004f20:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	6d2080e7          	jalr	1746(ra) # 800035f4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f2a:	08000613          	li	a2,128
    80004f2e:	f7040593          	addi	a1,s0,-144
    80004f32:	4501                	li	a0,0
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	046080e7          	jalr	70(ra) # 80001f7a <argstr>
    80004f3c:	04054a63          	bltz	a0,80004f90 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f40:	f6c40593          	addi	a1,s0,-148
    80004f44:	4505                	li	a0,1
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	ff0080e7          	jalr	-16(ra) # 80001f36 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f4e:	04054163          	bltz	a0,80004f90 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f52:	f6840593          	addi	a1,s0,-152
    80004f56:	4509                	li	a0,2
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	fde080e7          	jalr	-34(ra) # 80001f36 <argint>
     argint(1, &major) < 0 ||
    80004f60:	02054863          	bltz	a0,80004f90 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f64:	f6841683          	lh	a3,-152(s0)
    80004f68:	f6c41603          	lh	a2,-148(s0)
    80004f6c:	458d                	li	a1,3
    80004f6e:	f7040513          	addi	a0,s0,-144
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	670080e7          	jalr	1648(ra) # 800045e2 <create>
     argint(2, &minor) < 0 ||
    80004f7a:	c919                	beqz	a0,80004f90 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	f0a080e7          	jalr	-246(ra) # 80002e86 <iunlockput>
  end_op();
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	6ea080e7          	jalr	1770(ra) # 8000366e <end_op>
  return 0;
    80004f8c:	4501                	li	a0,0
    80004f8e:	a031                	j	80004f9a <sys_mknod+0x80>
    end_op();
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	6de080e7          	jalr	1758(ra) # 8000366e <end_op>
    return -1;
    80004f98:	557d                	li	a0,-1
}
    80004f9a:	60ea                	ld	ra,152(sp)
    80004f9c:	644a                	ld	s0,144(sp)
    80004f9e:	610d                	addi	sp,sp,160
    80004fa0:	8082                	ret

0000000080004fa2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fa2:	7135                	addi	sp,sp,-160
    80004fa4:	ed06                	sd	ra,152(sp)
    80004fa6:	e922                	sd	s0,144(sp)
    80004fa8:	e14a                	sd	s2,128(sp)
    80004faa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	ed0080e7          	jalr	-304(ra) # 80000e7c <myproc>
    80004fb4:	892a                	mv	s2,a0
  
  begin_op();
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	63e080e7          	jalr	1598(ra) # 800035f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fbe:	08000613          	li	a2,128
    80004fc2:	f6040593          	addi	a1,s0,-160
    80004fc6:	4501                	li	a0,0
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	fb2080e7          	jalr	-78(ra) # 80001f7a <argstr>
    80004fd0:	04054d63          	bltz	a0,8000502a <sys_chdir+0x88>
    80004fd4:	e526                	sd	s1,136(sp)
    80004fd6:	f6040513          	addi	a0,s0,-160
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	41a080e7          	jalr	1050(ra) # 800033f4 <namei>
    80004fe2:	84aa                	mv	s1,a0
    80004fe4:	c131                	beqz	a0,80005028 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	b8c080e7          	jalr	-1140(ra) # 80002b72 <ilock>
  if(ip->type != T_DIR){
    80004fee:	04449703          	lh	a4,68(s1)
    80004ff2:	4785                	li	a5,1
    80004ff4:	04f71163          	bne	a4,a5,80005036 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	c3e080e7          	jalr	-962(ra) # 80002c38 <iunlock>
  iput(p->cwd);
    80005002:	15093503          	ld	a0,336(s2)
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	dd8080e7          	jalr	-552(ra) # 80002dde <iput>
  end_op();
    8000500e:	ffffe097          	auipc	ra,0xffffe
    80005012:	660080e7          	jalr	1632(ra) # 8000366e <end_op>
  p->cwd = ip;
    80005016:	14993823          	sd	s1,336(s2)
  return 0;
    8000501a:	4501                	li	a0,0
    8000501c:	64aa                	ld	s1,136(sp)
}
    8000501e:	60ea                	ld	ra,152(sp)
    80005020:	644a                	ld	s0,144(sp)
    80005022:	690a                	ld	s2,128(sp)
    80005024:	610d                	addi	sp,sp,160
    80005026:	8082                	ret
    80005028:	64aa                	ld	s1,136(sp)
    end_op();
    8000502a:	ffffe097          	auipc	ra,0xffffe
    8000502e:	644080e7          	jalr	1604(ra) # 8000366e <end_op>
    return -1;
    80005032:	557d                	li	a0,-1
    80005034:	b7ed                	j	8000501e <sys_chdir+0x7c>
    iunlockput(ip);
    80005036:	8526                	mv	a0,s1
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	e4e080e7          	jalr	-434(ra) # 80002e86 <iunlockput>
    end_op();
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	62e080e7          	jalr	1582(ra) # 8000366e <end_op>
    return -1;
    80005048:	557d                	li	a0,-1
    8000504a:	64aa                	ld	s1,136(sp)
    8000504c:	bfc9                	j	8000501e <sys_chdir+0x7c>

000000008000504e <sys_exec>:

uint64
sys_exec(void)
{
    8000504e:	7121                	addi	sp,sp,-448
    80005050:	ff06                	sd	ra,440(sp)
    80005052:	fb22                	sd	s0,432(sp)
    80005054:	f34a                	sd	s2,416(sp)
    80005056:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005058:	08000613          	li	a2,128
    8000505c:	f5040593          	addi	a1,s0,-176
    80005060:	4501                	li	a0,0
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	f18080e7          	jalr	-232(ra) # 80001f7a <argstr>
    return -1;
    8000506a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000506c:	0e054a63          	bltz	a0,80005160 <sys_exec+0x112>
    80005070:	e4840593          	addi	a1,s0,-440
    80005074:	4505                	li	a0,1
    80005076:	ffffd097          	auipc	ra,0xffffd
    8000507a:	ee2080e7          	jalr	-286(ra) # 80001f58 <argaddr>
    8000507e:	0e054163          	bltz	a0,80005160 <sys_exec+0x112>
    80005082:	f726                	sd	s1,424(sp)
    80005084:	ef4e                	sd	s3,408(sp)
    80005086:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005088:	10000613          	li	a2,256
    8000508c:	4581                	li	a1,0
    8000508e:	e5040513          	addi	a0,s0,-432
    80005092:	ffffb097          	auipc	ra,0xffffb
    80005096:	0e8080e7          	jalr	232(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000509a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000509e:	89a6                	mv	s3,s1
    800050a0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050a2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050a6:	00391513          	slli	a0,s2,0x3
    800050aa:	e4040593          	addi	a1,s0,-448
    800050ae:	e4843783          	ld	a5,-440(s0)
    800050b2:	953e                	add	a0,a0,a5
    800050b4:	ffffd097          	auipc	ra,0xffffd
    800050b8:	de8080e7          	jalr	-536(ra) # 80001e9c <fetchaddr>
    800050bc:	02054a63          	bltz	a0,800050f0 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800050c0:	e4043783          	ld	a5,-448(s0)
    800050c4:	c7b1                	beqz	a5,80005110 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050c6:	ffffb097          	auipc	ra,0xffffb
    800050ca:	054080e7          	jalr	84(ra) # 8000011a <kalloc>
    800050ce:	85aa                	mv	a1,a0
    800050d0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050d4:	cd11                	beqz	a0,800050f0 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050d6:	6605                	lui	a2,0x1
    800050d8:	e4043503          	ld	a0,-448(s0)
    800050dc:	ffffd097          	auipc	ra,0xffffd
    800050e0:	e12080e7          	jalr	-494(ra) # 80001eee <fetchstr>
    800050e4:	00054663          	bltz	a0,800050f0 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800050e8:	0905                	addi	s2,s2,1
    800050ea:	09a1                	addi	s3,s3,8
    800050ec:	fb491de3          	bne	s2,s4,800050a6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f0:	f5040913          	addi	s2,s0,-176
    800050f4:	6088                	ld	a0,0(s1)
    800050f6:	c12d                	beqz	a0,80005158 <sys_exec+0x10a>
    kfree(argv[i]);
    800050f8:	ffffb097          	auipc	ra,0xffffb
    800050fc:	f24080e7          	jalr	-220(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005100:	04a1                	addi	s1,s1,8
    80005102:	ff2499e3          	bne	s1,s2,800050f4 <sys_exec+0xa6>
  return -1;
    80005106:	597d                	li	s2,-1
    80005108:	74ba                	ld	s1,424(sp)
    8000510a:	69fa                	ld	s3,408(sp)
    8000510c:	6a5a                	ld	s4,400(sp)
    8000510e:	a889                	j	80005160 <sys_exec+0x112>
      argv[i] = 0;
    80005110:	0009079b          	sext.w	a5,s2
    80005114:	078e                	slli	a5,a5,0x3
    80005116:	fd078793          	addi	a5,a5,-48
    8000511a:	97a2                	add	a5,a5,s0
    8000511c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005120:	e5040593          	addi	a1,s0,-432
    80005124:	f5040513          	addi	a0,s0,-176
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	046080e7          	jalr	70(ra) # 8000416e <exec>
    80005130:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005132:	f5040993          	addi	s3,s0,-176
    80005136:	6088                	ld	a0,0(s1)
    80005138:	cd01                	beqz	a0,80005150 <sys_exec+0x102>
    kfree(argv[i]);
    8000513a:	ffffb097          	auipc	ra,0xffffb
    8000513e:	ee2080e7          	jalr	-286(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005142:	04a1                	addi	s1,s1,8
    80005144:	ff3499e3          	bne	s1,s3,80005136 <sys_exec+0xe8>
    80005148:	74ba                	ld	s1,424(sp)
    8000514a:	69fa                	ld	s3,408(sp)
    8000514c:	6a5a                	ld	s4,400(sp)
    8000514e:	a809                	j	80005160 <sys_exec+0x112>
  return ret;
    80005150:	74ba                	ld	s1,424(sp)
    80005152:	69fa                	ld	s3,408(sp)
    80005154:	6a5a                	ld	s4,400(sp)
    80005156:	a029                	j	80005160 <sys_exec+0x112>
  return -1;
    80005158:	597d                	li	s2,-1
    8000515a:	74ba                	ld	s1,424(sp)
    8000515c:	69fa                	ld	s3,408(sp)
    8000515e:	6a5a                	ld	s4,400(sp)
}
    80005160:	854a                	mv	a0,s2
    80005162:	70fa                	ld	ra,440(sp)
    80005164:	745a                	ld	s0,432(sp)
    80005166:	791a                	ld	s2,416(sp)
    80005168:	6139                	addi	sp,sp,448
    8000516a:	8082                	ret

000000008000516c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000516c:	7139                	addi	sp,sp,-64
    8000516e:	fc06                	sd	ra,56(sp)
    80005170:	f822                	sd	s0,48(sp)
    80005172:	f426                	sd	s1,40(sp)
    80005174:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005176:	ffffc097          	auipc	ra,0xffffc
    8000517a:	d06080e7          	jalr	-762(ra) # 80000e7c <myproc>
    8000517e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005180:	fd840593          	addi	a1,s0,-40
    80005184:	4501                	li	a0,0
    80005186:	ffffd097          	auipc	ra,0xffffd
    8000518a:	dd2080e7          	jalr	-558(ra) # 80001f58 <argaddr>
    return -1;
    8000518e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005190:	0e054063          	bltz	a0,80005270 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005194:	fc840593          	addi	a1,s0,-56
    80005198:	fd040513          	addi	a0,s0,-48
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	c90080e7          	jalr	-880(ra) # 80003e2c <pipealloc>
    return -1;
    800051a4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051a6:	0c054563          	bltz	a0,80005270 <sys_pipe+0x104>
  fd0 = -1;
    800051aa:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051ae:	fd043503          	ld	a0,-48(s0)
    800051b2:	fffff097          	auipc	ra,0xfffff
    800051b6:	3ee080e7          	jalr	1006(ra) # 800045a0 <fdalloc>
    800051ba:	fca42223          	sw	a0,-60(s0)
    800051be:	08054c63          	bltz	a0,80005256 <sys_pipe+0xea>
    800051c2:	fc843503          	ld	a0,-56(s0)
    800051c6:	fffff097          	auipc	ra,0xfffff
    800051ca:	3da080e7          	jalr	986(ra) # 800045a0 <fdalloc>
    800051ce:	fca42023          	sw	a0,-64(s0)
    800051d2:	06054963          	bltz	a0,80005244 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051d6:	4691                	li	a3,4
    800051d8:	fc440613          	addi	a2,s0,-60
    800051dc:	fd843583          	ld	a1,-40(s0)
    800051e0:	68a8                	ld	a0,80(s1)
    800051e2:	ffffc097          	auipc	ra,0xffffc
    800051e6:	936080e7          	jalr	-1738(ra) # 80000b18 <copyout>
    800051ea:	02054063          	bltz	a0,8000520a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051ee:	4691                	li	a3,4
    800051f0:	fc040613          	addi	a2,s0,-64
    800051f4:	fd843583          	ld	a1,-40(s0)
    800051f8:	0591                	addi	a1,a1,4
    800051fa:	68a8                	ld	a0,80(s1)
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	91c080e7          	jalr	-1764(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005204:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005206:	06055563          	bgez	a0,80005270 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000520a:	fc442783          	lw	a5,-60(s0)
    8000520e:	07e9                	addi	a5,a5,26
    80005210:	078e                	slli	a5,a5,0x3
    80005212:	97a6                	add	a5,a5,s1
    80005214:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005218:	fc042783          	lw	a5,-64(s0)
    8000521c:	07e9                	addi	a5,a5,26
    8000521e:	078e                	slli	a5,a5,0x3
    80005220:	00f48533          	add	a0,s1,a5
    80005224:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005228:	fd043503          	ld	a0,-48(s0)
    8000522c:	fffff097          	auipc	ra,0xfffff
    80005230:	892080e7          	jalr	-1902(ra) # 80003abe <fileclose>
    fileclose(wf);
    80005234:	fc843503          	ld	a0,-56(s0)
    80005238:	fffff097          	auipc	ra,0xfffff
    8000523c:	886080e7          	jalr	-1914(ra) # 80003abe <fileclose>
    return -1;
    80005240:	57fd                	li	a5,-1
    80005242:	a03d                	j	80005270 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005244:	fc442783          	lw	a5,-60(s0)
    80005248:	0007c763          	bltz	a5,80005256 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000524c:	07e9                	addi	a5,a5,26
    8000524e:	078e                	slli	a5,a5,0x3
    80005250:	97a6                	add	a5,a5,s1
    80005252:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005256:	fd043503          	ld	a0,-48(s0)
    8000525a:	fffff097          	auipc	ra,0xfffff
    8000525e:	864080e7          	jalr	-1948(ra) # 80003abe <fileclose>
    fileclose(wf);
    80005262:	fc843503          	ld	a0,-56(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	858080e7          	jalr	-1960(ra) # 80003abe <fileclose>
    return -1;
    8000526e:	57fd                	li	a5,-1
}
    80005270:	853e                	mv	a0,a5
    80005272:	70e2                	ld	ra,56(sp)
    80005274:	7442                	ld	s0,48(sp)
    80005276:	74a2                	ld	s1,40(sp)
    80005278:	6121                	addi	sp,sp,64
    8000527a:	8082                	ret

000000008000527c <sys_symlink>:

uint64
sys_symlink(void){
    8000527c:	712d                	addi	sp,sp,-288
    8000527e:	ee06                	sd	ra,280(sp)
    80005280:	ea22                	sd	s0,272(sp)
    80005282:	1200                	addi	s0,sp,288
  char path[MAXPATH];
  char target[MAXPATH];

  if(argstr(0, target, MAXPATH)<0){
    80005284:	08000613          	li	a2,128
    80005288:	ee040593          	addi	a1,s0,-288
    8000528c:	4501                	li	a0,0
    8000528e:	ffffd097          	auipc	ra,0xffffd
    80005292:	cec080e7          	jalr	-788(ra) # 80001f7a <argstr>
    return -1;
    80005296:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH)<0){
    80005298:	06054763          	bltz	a0,80005306 <sys_symlink+0x8a>
  }
  if(argstr(1, path, MAXPATH)<0){
    8000529c:	08000613          	li	a2,128
    800052a0:	f6040593          	addi	a1,s0,-160
    800052a4:	4505                	li	a0,1
    800052a6:	ffffd097          	auipc	ra,0xffffd
    800052aa:	cd4080e7          	jalr	-812(ra) # 80001f7a <argstr>
    return -1;
    800052ae:	57fd                	li	a5,-1
  if(argstr(1, path, MAXPATH)<0){
    800052b0:	04054b63          	bltz	a0,80005306 <sys_symlink+0x8a>
    800052b4:	e626                	sd	s1,264(sp)
  }

  begin_op();
    800052b6:	ffffe097          	auipc	ra,0xffffe
    800052ba:	33e080e7          	jalr	830(ra) # 800035f4 <begin_op>
  // 为此符号链接新建 inode
  struct inode *sym_ip=create(path,T_SYMLINK,0,0);
    800052be:	4681                	li	a3,0
    800052c0:	4601                	li	a2,0
    800052c2:	4591                	li	a1,4
    800052c4:	f6040513          	addi	a0,s0,-160
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	31a080e7          	jalr	794(ra) # 800045e2 <create>
    800052d0:	84aa                	mv	s1,a0
  if(sym_ip==0){
    800052d2:	cd1d                	beqz	a0,80005310 <sys_symlink+0x94>
    end_op();
    return -1;
  }

  // 写入被链接的文件
  if(writei(sym_ip,0,(uint64)target,0,MAXPATH)<MAXPATH){
    800052d4:	08000713          	li	a4,128
    800052d8:	4681                	li	a3,0
    800052da:	ee040613          	addi	a2,s0,-288
    800052de:	4581                	li	a1,0
    800052e0:	ffffe097          	auipc	ra,0xffffe
    800052e4:	cfc080e7          	jalr	-772(ra) # 80002fdc <writei>
    800052e8:	07f00793          	li	a5,127
    800052ec:	02a7d963          	bge	a5,a0,8000531e <sys_symlink+0xa2>
    iunlockput(sym_ip);
    end_op();
    return -1;
  }
  iunlockput(sym_ip);
    800052f0:	8526                	mv	a0,s1
    800052f2:	ffffe097          	auipc	ra,0xffffe
    800052f6:	b94080e7          	jalr	-1132(ra) # 80002e86 <iunlockput>
  end_op();
    800052fa:	ffffe097          	auipc	ra,0xffffe
    800052fe:	374080e7          	jalr	884(ra) # 8000366e <end_op>
  return 0;
    80005302:	4781                	li	a5,0
    80005304:	64b2                	ld	s1,264(sp)
    80005306:	853e                	mv	a0,a5
    80005308:	60f2                	ld	ra,280(sp)
    8000530a:	6452                	ld	s0,272(sp)
    8000530c:	6115                	addi	sp,sp,288
    8000530e:	8082                	ret
    end_op();
    80005310:	ffffe097          	auipc	ra,0xffffe
    80005314:	35e080e7          	jalr	862(ra) # 8000366e <end_op>
    return -1;
    80005318:	57fd                	li	a5,-1
    8000531a:	64b2                	ld	s1,264(sp)
    8000531c:	b7ed                	j	80005306 <sys_symlink+0x8a>
    iunlockput(sym_ip);
    8000531e:	8526                	mv	a0,s1
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	b66080e7          	jalr	-1178(ra) # 80002e86 <iunlockput>
    end_op();
    80005328:	ffffe097          	auipc	ra,0xffffe
    8000532c:	346080e7          	jalr	838(ra) # 8000366e <end_op>
    return -1;
    80005330:	57fd                	li	a5,-1
    80005332:	64b2                	ld	s1,264(sp)
    80005334:	bfc9                	j	80005306 <sys_symlink+0x8a>
	...

0000000080005340 <kernelvec>:
    80005340:	7111                	addi	sp,sp,-256
    80005342:	e006                	sd	ra,0(sp)
    80005344:	e40a                	sd	sp,8(sp)
    80005346:	e80e                	sd	gp,16(sp)
    80005348:	ec12                	sd	tp,24(sp)
    8000534a:	f016                	sd	t0,32(sp)
    8000534c:	f41a                	sd	t1,40(sp)
    8000534e:	f81e                	sd	t2,48(sp)
    80005350:	fc22                	sd	s0,56(sp)
    80005352:	e0a6                	sd	s1,64(sp)
    80005354:	e4aa                	sd	a0,72(sp)
    80005356:	e8ae                	sd	a1,80(sp)
    80005358:	ecb2                	sd	a2,88(sp)
    8000535a:	f0b6                	sd	a3,96(sp)
    8000535c:	f4ba                	sd	a4,104(sp)
    8000535e:	f8be                	sd	a5,112(sp)
    80005360:	fcc2                	sd	a6,120(sp)
    80005362:	e146                	sd	a7,128(sp)
    80005364:	e54a                	sd	s2,136(sp)
    80005366:	e94e                	sd	s3,144(sp)
    80005368:	ed52                	sd	s4,152(sp)
    8000536a:	f156                	sd	s5,160(sp)
    8000536c:	f55a                	sd	s6,168(sp)
    8000536e:	f95e                	sd	s7,176(sp)
    80005370:	fd62                	sd	s8,184(sp)
    80005372:	e1e6                	sd	s9,192(sp)
    80005374:	e5ea                	sd	s10,200(sp)
    80005376:	e9ee                	sd	s11,208(sp)
    80005378:	edf2                	sd	t3,216(sp)
    8000537a:	f1f6                	sd	t4,224(sp)
    8000537c:	f5fa                	sd	t5,232(sp)
    8000537e:	f9fe                	sd	t6,240(sp)
    80005380:	9e9fc0ef          	jal	80001d68 <kerneltrap>
    80005384:	6082                	ld	ra,0(sp)
    80005386:	6122                	ld	sp,8(sp)
    80005388:	61c2                	ld	gp,16(sp)
    8000538a:	7282                	ld	t0,32(sp)
    8000538c:	7322                	ld	t1,40(sp)
    8000538e:	73c2                	ld	t2,48(sp)
    80005390:	7462                	ld	s0,56(sp)
    80005392:	6486                	ld	s1,64(sp)
    80005394:	6526                	ld	a0,72(sp)
    80005396:	65c6                	ld	a1,80(sp)
    80005398:	6666                	ld	a2,88(sp)
    8000539a:	7686                	ld	a3,96(sp)
    8000539c:	7726                	ld	a4,104(sp)
    8000539e:	77c6                	ld	a5,112(sp)
    800053a0:	7866                	ld	a6,120(sp)
    800053a2:	688a                	ld	a7,128(sp)
    800053a4:	692a                	ld	s2,136(sp)
    800053a6:	69ca                	ld	s3,144(sp)
    800053a8:	6a6a                	ld	s4,152(sp)
    800053aa:	7a8a                	ld	s5,160(sp)
    800053ac:	7b2a                	ld	s6,168(sp)
    800053ae:	7bca                	ld	s7,176(sp)
    800053b0:	7c6a                	ld	s8,184(sp)
    800053b2:	6c8e                	ld	s9,192(sp)
    800053b4:	6d2e                	ld	s10,200(sp)
    800053b6:	6dce                	ld	s11,208(sp)
    800053b8:	6e6e                	ld	t3,216(sp)
    800053ba:	7e8e                	ld	t4,224(sp)
    800053bc:	7f2e                	ld	t5,232(sp)
    800053be:	7fce                	ld	t6,240(sp)
    800053c0:	6111                	addi	sp,sp,256
    800053c2:	10200073          	sret
    800053c6:	00000013          	nop
    800053ca:	00000013          	nop
    800053ce:	0001                	nop

00000000800053d0 <timervec>:
    800053d0:	34051573          	csrrw	a0,mscratch,a0
    800053d4:	e10c                	sd	a1,0(a0)
    800053d6:	e510                	sd	a2,8(a0)
    800053d8:	e914                	sd	a3,16(a0)
    800053da:	6d0c                	ld	a1,24(a0)
    800053dc:	7110                	ld	a2,32(a0)
    800053de:	6194                	ld	a3,0(a1)
    800053e0:	96b2                	add	a3,a3,a2
    800053e2:	e194                	sd	a3,0(a1)
    800053e4:	4589                	li	a1,2
    800053e6:	14459073          	csrw	sip,a1
    800053ea:	6914                	ld	a3,16(a0)
    800053ec:	6510                	ld	a2,8(a0)
    800053ee:	610c                	ld	a1,0(a0)
    800053f0:	34051573          	csrrw	a0,mscratch,a0
    800053f4:	30200073          	mret
	...

00000000800053fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053fa:	1141                	addi	sp,sp,-16
    800053fc:	e422                	sd	s0,8(sp)
    800053fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005400:	0c0007b7          	lui	a5,0xc000
    80005404:	4705                	li	a4,1
    80005406:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005408:	0c0007b7          	lui	a5,0xc000
    8000540c:	c3d8                	sw	a4,4(a5)
}
    8000540e:	6422                	ld	s0,8(sp)
    80005410:	0141                	addi	sp,sp,16
    80005412:	8082                	ret

0000000080005414 <plicinithart>:

void
plicinithart(void)
{
    80005414:	1141                	addi	sp,sp,-16
    80005416:	e406                	sd	ra,8(sp)
    80005418:	e022                	sd	s0,0(sp)
    8000541a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000541c:	ffffc097          	auipc	ra,0xffffc
    80005420:	a34080e7          	jalr	-1484(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005424:	0085171b          	slliw	a4,a0,0x8
    80005428:	0c0027b7          	lui	a5,0xc002
    8000542c:	97ba                	add	a5,a5,a4
    8000542e:	40200713          	li	a4,1026
    80005432:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005436:	00d5151b          	slliw	a0,a0,0xd
    8000543a:	0c2017b7          	lui	a5,0xc201
    8000543e:	97aa                	add	a5,a5,a0
    80005440:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005444:	60a2                	ld	ra,8(sp)
    80005446:	6402                	ld	s0,0(sp)
    80005448:	0141                	addi	sp,sp,16
    8000544a:	8082                	ret

000000008000544c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000544c:	1141                	addi	sp,sp,-16
    8000544e:	e406                	sd	ra,8(sp)
    80005450:	e022                	sd	s0,0(sp)
    80005452:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005454:	ffffc097          	auipc	ra,0xffffc
    80005458:	9fc080e7          	jalr	-1540(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000545c:	00d5151b          	slliw	a0,a0,0xd
    80005460:	0c2017b7          	lui	a5,0xc201
    80005464:	97aa                	add	a5,a5,a0
  return irq;
}
    80005466:	43c8                	lw	a0,4(a5)
    80005468:	60a2                	ld	ra,8(sp)
    8000546a:	6402                	ld	s0,0(sp)
    8000546c:	0141                	addi	sp,sp,16
    8000546e:	8082                	ret

0000000080005470 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005470:	1101                	addi	sp,sp,-32
    80005472:	ec06                	sd	ra,24(sp)
    80005474:	e822                	sd	s0,16(sp)
    80005476:	e426                	sd	s1,8(sp)
    80005478:	1000                	addi	s0,sp,32
    8000547a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000547c:	ffffc097          	auipc	ra,0xffffc
    80005480:	9d4080e7          	jalr	-1580(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005484:	00d5151b          	slliw	a0,a0,0xd
    80005488:	0c2017b7          	lui	a5,0xc201
    8000548c:	97aa                	add	a5,a5,a0
    8000548e:	c3c4                	sw	s1,4(a5)
}
    80005490:	60e2                	ld	ra,24(sp)
    80005492:	6442                	ld	s0,16(sp)
    80005494:	64a2                	ld	s1,8(sp)
    80005496:	6105                	addi	sp,sp,32
    80005498:	8082                	ret

000000008000549a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000549a:	1141                	addi	sp,sp,-16
    8000549c:	e406                	sd	ra,8(sp)
    8000549e:	e022                	sd	s0,0(sp)
    800054a0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054a2:	479d                	li	a5,7
    800054a4:	06a7c863          	blt	a5,a0,80005514 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800054a8:	00014717          	auipc	a4,0x14
    800054ac:	b5870713          	addi	a4,a4,-1192 # 80019000 <disk>
    800054b0:	972a                	add	a4,a4,a0
    800054b2:	6789                	lui	a5,0x2
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054ba:	e7ad                	bnez	a5,80005524 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054bc:	00451793          	slli	a5,a0,0x4
    800054c0:	00016717          	auipc	a4,0x16
    800054c4:	b4070713          	addi	a4,a4,-1216 # 8001b000 <disk+0x2000>
    800054c8:	6314                	ld	a3,0(a4)
    800054ca:	96be                	add	a3,a3,a5
    800054cc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054d0:	6314                	ld	a3,0(a4)
    800054d2:	96be                	add	a3,a3,a5
    800054d4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054d8:	6314                	ld	a3,0(a4)
    800054da:	96be                	add	a3,a3,a5
    800054dc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054e0:	6318                	ld	a4,0(a4)
    800054e2:	97ba                	add	a5,a5,a4
    800054e4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054e8:	00014717          	auipc	a4,0x14
    800054ec:	b1870713          	addi	a4,a4,-1256 # 80019000 <disk>
    800054f0:	972a                	add	a4,a4,a0
    800054f2:	6789                	lui	a5,0x2
    800054f4:	97ba                	add	a5,a5,a4
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054fc:	00016517          	auipc	a0,0x16
    80005500:	b1c50513          	addi	a0,a0,-1252 # 8001b018 <disk+0x2018>
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	1ca080e7          	jalr	458(ra) # 800016ce <wakeup>
}
    8000550c:	60a2                	ld	ra,8(sp)
    8000550e:	6402                	ld	s0,0(sp)
    80005510:	0141                	addi	sp,sp,16
    80005512:	8082                	ret
    panic("free_desc 1");
    80005514:	00003517          	auipc	a0,0x3
    80005518:	0dc50513          	addi	a0,a0,220 # 800085f0 <etext+0x5f0>
    8000551c:	00001097          	auipc	ra,0x1
    80005520:	a10080e7          	jalr	-1520(ra) # 80005f2c <panic>
    panic("free_desc 2");
    80005524:	00003517          	auipc	a0,0x3
    80005528:	0dc50513          	addi	a0,a0,220 # 80008600 <etext+0x600>
    8000552c:	00001097          	auipc	ra,0x1
    80005530:	a00080e7          	jalr	-1536(ra) # 80005f2c <panic>

0000000080005534 <virtio_disk_init>:
{
    80005534:	1141                	addi	sp,sp,-16
    80005536:	e406                	sd	ra,8(sp)
    80005538:	e022                	sd	s0,0(sp)
    8000553a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000553c:	00003597          	auipc	a1,0x3
    80005540:	0d458593          	addi	a1,a1,212 # 80008610 <etext+0x610>
    80005544:	00016517          	auipc	a0,0x16
    80005548:	be450513          	addi	a0,a0,-1052 # 8001b128 <disk+0x2128>
    8000554c:	00001097          	auipc	ra,0x1
    80005550:	eca080e7          	jalr	-310(ra) # 80006416 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005554:	100017b7          	lui	a5,0x10001
    80005558:	4398                	lw	a4,0(a5)
    8000555a:	2701                	sext.w	a4,a4
    8000555c:	747277b7          	lui	a5,0x74727
    80005560:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005564:	0ef71f63          	bne	a4,a5,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000556e:	439c                	lw	a5,0(a5)
    80005570:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005572:	4705                	li	a4,1
    80005574:	0ee79763          	bne	a5,a4,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005578:	100017b7          	lui	a5,0x10001
    8000557c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000557e:	439c                	lw	a5,0(a5)
    80005580:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005582:	4709                	li	a4,2
    80005584:	0ce79f63          	bne	a5,a4,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005588:	100017b7          	lui	a5,0x10001
    8000558c:	47d8                	lw	a4,12(a5)
    8000558e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005590:	554d47b7          	lui	a5,0x554d4
    80005594:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005598:	0cf71563          	bne	a4,a5,80005662 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559c:	100017b7          	lui	a5,0x10001
    800055a0:	4705                	li	a4,1
    800055a2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a4:	470d                	li	a4,3
    800055a6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055a8:	10001737          	lui	a4,0x10001
    800055ac:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055ae:	c7ffe737          	lui	a4,0xc7ffe
    800055b2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda51f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055b6:	8ef9                	and	a3,a3,a4
    800055b8:	10001737          	lui	a4,0x10001
    800055bc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055be:	472d                	li	a4,11
    800055c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c2:	473d                	li	a4,15
    800055c4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055c6:	100017b7          	lui	a5,0x10001
    800055ca:	6705                	lui	a4,0x1
    800055cc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055ce:	100017b7          	lui	a5,0x10001
    800055d2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055de:	439c                	lw	a5,0(a5)
    800055e0:	2781                	sext.w	a5,a5
  if(max == 0)
    800055e2:	cbc1                	beqz	a5,80005672 <virtio_disk_init+0x13e>
  if(max < NUM)
    800055e4:	471d                	li	a4,7
    800055e6:	08f77e63          	bgeu	a4,a5,80005682 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	4721                	li	a4,8
    800055f0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055f2:	6609                	lui	a2,0x2
    800055f4:	4581                	li	a1,0
    800055f6:	00014517          	auipc	a0,0x14
    800055fa:	a0a50513          	addi	a0,a0,-1526 # 80019000 <disk>
    800055fe:	ffffb097          	auipc	ra,0xffffb
    80005602:	b7c080e7          	jalr	-1156(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005606:	00014697          	auipc	a3,0x14
    8000560a:	9fa68693          	addi	a3,a3,-1542 # 80019000 <disk>
    8000560e:	00c6d713          	srli	a4,a3,0xc
    80005612:	2701                	sext.w	a4,a4
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000561a:	00016797          	auipc	a5,0x16
    8000561e:	9e678793          	addi	a5,a5,-1562 # 8001b000 <disk+0x2000>
    80005622:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005624:	00014717          	auipc	a4,0x14
    80005628:	a5c70713          	addi	a4,a4,-1444 # 80019080 <disk+0x80>
    8000562c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000562e:	00015717          	auipc	a4,0x15
    80005632:	9d270713          	addi	a4,a4,-1582 # 8001a000 <disk+0x1000>
    80005636:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005638:	4705                	li	a4,1
    8000563a:	00e78c23          	sb	a4,24(a5)
    8000563e:	00e78ca3          	sb	a4,25(a5)
    80005642:	00e78d23          	sb	a4,26(a5)
    80005646:	00e78da3          	sb	a4,27(a5)
    8000564a:	00e78e23          	sb	a4,28(a5)
    8000564e:	00e78ea3          	sb	a4,29(a5)
    80005652:	00e78f23          	sb	a4,30(a5)
    80005656:	00e78fa3          	sb	a4,31(a5)
}
    8000565a:	60a2                	ld	ra,8(sp)
    8000565c:	6402                	ld	s0,0(sp)
    8000565e:	0141                	addi	sp,sp,16
    80005660:	8082                	ret
    panic("could not find virtio disk");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	fbe50513          	addi	a0,a0,-66 # 80008620 <etext+0x620>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	8c2080e7          	jalr	-1854(ra) # 80005f2c <panic>
    panic("virtio disk has no queue 0");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	fce50513          	addi	a0,a0,-50 # 80008640 <etext+0x640>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	8b2080e7          	jalr	-1870(ra) # 80005f2c <panic>
    panic("virtio disk max queue too short");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	fde50513          	addi	a0,a0,-34 # 80008660 <etext+0x660>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	8a2080e7          	jalr	-1886(ra) # 80005f2c <panic>

0000000080005692 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005692:	7159                	addi	sp,sp,-112
    80005694:	f486                	sd	ra,104(sp)
    80005696:	f0a2                	sd	s0,96(sp)
    80005698:	eca6                	sd	s1,88(sp)
    8000569a:	e8ca                	sd	s2,80(sp)
    8000569c:	e4ce                	sd	s3,72(sp)
    8000569e:	e0d2                	sd	s4,64(sp)
    800056a0:	fc56                	sd	s5,56(sp)
    800056a2:	f85a                	sd	s6,48(sp)
    800056a4:	f45e                	sd	s7,40(sp)
    800056a6:	f062                	sd	s8,32(sp)
    800056a8:	ec66                	sd	s9,24(sp)
    800056aa:	1880                	addi	s0,sp,112
    800056ac:	8a2a                	mv	s4,a0
    800056ae:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056b0:	00c52c03          	lw	s8,12(a0)
    800056b4:	001c1c1b          	slliw	s8,s8,0x1
    800056b8:	1c02                	slli	s8,s8,0x20
    800056ba:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800056be:	00016517          	auipc	a0,0x16
    800056c2:	a6a50513          	addi	a0,a0,-1430 # 8001b128 <disk+0x2128>
    800056c6:	00001097          	auipc	ra,0x1
    800056ca:	de0080e7          	jalr	-544(ra) # 800064a6 <acquire>
  for(int i = 0; i < 3; i++){
    800056ce:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056d0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056d2:	00014b97          	auipc	s7,0x14
    800056d6:	92eb8b93          	addi	s7,s7,-1746 # 80019000 <disk>
    800056da:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800056dc:	4a8d                	li	s5,3
    800056de:	a88d                	j	80005750 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800056e0:	00fb8733          	add	a4,s7,a5
    800056e4:	975a                	add	a4,a4,s6
    800056e6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056ea:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056ec:	0207c563          	bltz	a5,80005716 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056f0:	2905                	addiw	s2,s2,1
    800056f2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056f4:	1b590163          	beq	s2,s5,80005896 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800056f8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056fa:	00016717          	auipc	a4,0x16
    800056fe:	91e70713          	addi	a4,a4,-1762 # 8001b018 <disk+0x2018>
    80005702:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005704:	00074683          	lbu	a3,0(a4)
    80005708:	fee1                	bnez	a3,800056e0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000570a:	2785                	addiw	a5,a5,1
    8000570c:	0705                	addi	a4,a4,1
    8000570e:	fe979be3          	bne	a5,s1,80005704 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005712:	57fd                	li	a5,-1
    80005714:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005716:	03205163          	blez	s2,80005738 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000571a:	f9042503          	lw	a0,-112(s0)
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	d7c080e7          	jalr	-644(ra) # 8000549a <free_desc>
      for(int j = 0; j < i; j++)
    80005726:	4785                	li	a5,1
    80005728:	0127d863          	bge	a5,s2,80005738 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000572c:	f9442503          	lw	a0,-108(s0)
    80005730:	00000097          	auipc	ra,0x0
    80005734:	d6a080e7          	jalr	-662(ra) # 8000549a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005738:	00016597          	auipc	a1,0x16
    8000573c:	9f058593          	addi	a1,a1,-1552 # 8001b128 <disk+0x2128>
    80005740:	00016517          	auipc	a0,0x16
    80005744:	8d850513          	addi	a0,a0,-1832 # 8001b018 <disk+0x2018>
    80005748:	ffffc097          	auipc	ra,0xffffc
    8000574c:	dfa080e7          	jalr	-518(ra) # 80001542 <sleep>
  for(int i = 0; i < 3; i++){
    80005750:	f9040613          	addi	a2,s0,-112
    80005754:	894e                	mv	s2,s3
    80005756:	b74d                	j	800056f8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005758:	00016717          	auipc	a4,0x16
    8000575c:	8a873703          	ld	a4,-1880(a4) # 8001b000 <disk+0x2000>
    80005760:	973e                	add	a4,a4,a5
    80005762:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005766:	00014897          	auipc	a7,0x14
    8000576a:	89a88893          	addi	a7,a7,-1894 # 80019000 <disk>
    8000576e:	00016717          	auipc	a4,0x16
    80005772:	89270713          	addi	a4,a4,-1902 # 8001b000 <disk+0x2000>
    80005776:	6314                	ld	a3,0(a4)
    80005778:	96be                	add	a3,a3,a5
    8000577a:	00c6d583          	lhu	a1,12(a3)
    8000577e:	0015e593          	ori	a1,a1,1
    80005782:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005786:	f9842683          	lw	a3,-104(s0)
    8000578a:	630c                	ld	a1,0(a4)
    8000578c:	97ae                	add	a5,a5,a1
    8000578e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005792:	20050593          	addi	a1,a0,512
    80005796:	0592                	slli	a1,a1,0x4
    80005798:	95c6                	add	a1,a1,a7
    8000579a:	57fd                	li	a5,-1
    8000579c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057a0:	00469793          	slli	a5,a3,0x4
    800057a4:	00073803          	ld	a6,0(a4)
    800057a8:	983e                	add	a6,a6,a5
    800057aa:	6689                	lui	a3,0x2
    800057ac:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800057b0:	96b2                	add	a3,a3,a2
    800057b2:	96c6                	add	a3,a3,a7
    800057b4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800057b8:	6314                	ld	a3,0(a4)
    800057ba:	96be                	add	a3,a3,a5
    800057bc:	4605                	li	a2,1
    800057be:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057c0:	6314                	ld	a3,0(a4)
    800057c2:	96be                	add	a3,a3,a5
    800057c4:	4809                	li	a6,2
    800057c6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800057ca:	6314                	ld	a3,0(a4)
    800057cc:	97b6                	add	a5,a5,a3
    800057ce:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057d2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800057d6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057da:	6714                	ld	a3,8(a4)
    800057dc:	0026d783          	lhu	a5,2(a3)
    800057e0:	8b9d                	andi	a5,a5,7
    800057e2:	0786                	slli	a5,a5,0x1
    800057e4:	96be                	add	a3,a3,a5
    800057e6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057ea:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ee:	6718                	ld	a4,8(a4)
    800057f0:	00275783          	lhu	a5,2(a4)
    800057f4:	2785                	addiw	a5,a5,1
    800057f6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057fa:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057fe:	100017b7          	lui	a5,0x10001
    80005802:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005806:	004a2783          	lw	a5,4(s4)
    8000580a:	02c79163          	bne	a5,a2,8000582c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000580e:	00016917          	auipc	s2,0x16
    80005812:	91a90913          	addi	s2,s2,-1766 # 8001b128 <disk+0x2128>
  while(b->disk == 1) {
    80005816:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005818:	85ca                	mv	a1,s2
    8000581a:	8552                	mv	a0,s4
    8000581c:	ffffc097          	auipc	ra,0xffffc
    80005820:	d26080e7          	jalr	-730(ra) # 80001542 <sleep>
  while(b->disk == 1) {
    80005824:	004a2783          	lw	a5,4(s4)
    80005828:	fe9788e3          	beq	a5,s1,80005818 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000582c:	f9042903          	lw	s2,-112(s0)
    80005830:	20090713          	addi	a4,s2,512
    80005834:	0712                	slli	a4,a4,0x4
    80005836:	00013797          	auipc	a5,0x13
    8000583a:	7ca78793          	addi	a5,a5,1994 # 80019000 <disk>
    8000583e:	97ba                	add	a5,a5,a4
    80005840:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005844:	00015997          	auipc	s3,0x15
    80005848:	7bc98993          	addi	s3,s3,1980 # 8001b000 <disk+0x2000>
    8000584c:	00491713          	slli	a4,s2,0x4
    80005850:	0009b783          	ld	a5,0(s3)
    80005854:	97ba                	add	a5,a5,a4
    80005856:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000585a:	854a                	mv	a0,s2
    8000585c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005860:	00000097          	auipc	ra,0x0
    80005864:	c3a080e7          	jalr	-966(ra) # 8000549a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005868:	8885                	andi	s1,s1,1
    8000586a:	f0ed                	bnez	s1,8000584c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000586c:	00016517          	auipc	a0,0x16
    80005870:	8bc50513          	addi	a0,a0,-1860 # 8001b128 <disk+0x2128>
    80005874:	00001097          	auipc	ra,0x1
    80005878:	ce6080e7          	jalr	-794(ra) # 8000655a <release>
}
    8000587c:	70a6                	ld	ra,104(sp)
    8000587e:	7406                	ld	s0,96(sp)
    80005880:	64e6                	ld	s1,88(sp)
    80005882:	6946                	ld	s2,80(sp)
    80005884:	69a6                	ld	s3,72(sp)
    80005886:	6a06                	ld	s4,64(sp)
    80005888:	7ae2                	ld	s5,56(sp)
    8000588a:	7b42                	ld	s6,48(sp)
    8000588c:	7ba2                	ld	s7,40(sp)
    8000588e:	7c02                	ld	s8,32(sp)
    80005890:	6ce2                	ld	s9,24(sp)
    80005892:	6165                	addi	sp,sp,112
    80005894:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005896:	f9042503          	lw	a0,-112(s0)
    8000589a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000589e:	00013597          	auipc	a1,0x13
    800058a2:	76258593          	addi	a1,a1,1890 # 80019000 <disk>
    800058a6:	20050793          	addi	a5,a0,512
    800058aa:	0792                	slli	a5,a5,0x4
    800058ac:	97ae                	add	a5,a5,a1
    800058ae:	01903733          	snez	a4,s9
    800058b2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800058b6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800058ba:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058be:	00015717          	auipc	a4,0x15
    800058c2:	74270713          	addi	a4,a4,1858 # 8001b000 <disk+0x2000>
    800058c6:	6314                	ld	a3,0(a4)
    800058c8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058ca:	6789                	lui	a5,0x2
    800058cc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800058d0:	97b2                	add	a5,a5,a2
    800058d2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058d4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058d6:	631c                	ld	a5,0(a4)
    800058d8:	97b2                	add	a5,a5,a2
    800058da:	46c1                	li	a3,16
    800058dc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058de:	631c                	ld	a5,0(a4)
    800058e0:	97b2                	add	a5,a5,a2
    800058e2:	4685                	li	a3,1
    800058e4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058e8:	f9442783          	lw	a5,-108(s0)
    800058ec:	6314                	ld	a3,0(a4)
    800058ee:	96b2                	add	a3,a3,a2
    800058f0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058f4:	0792                	slli	a5,a5,0x4
    800058f6:	6314                	ld	a3,0(a4)
    800058f8:	96be                	add	a3,a3,a5
    800058fa:	058a0593          	addi	a1,s4,88
    800058fe:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005900:	6318                	ld	a4,0(a4)
    80005902:	973e                	add	a4,a4,a5
    80005904:	40000693          	li	a3,1024
    80005908:	c714                	sw	a3,8(a4)
  if(write)
    8000590a:	e40c97e3          	bnez	s9,80005758 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000590e:	00015717          	auipc	a4,0x15
    80005912:	6f273703          	ld	a4,1778(a4) # 8001b000 <disk+0x2000>
    80005916:	973e                	add	a4,a4,a5
    80005918:	4689                	li	a3,2
    8000591a:	00d71623          	sh	a3,12(a4)
    8000591e:	b5a1                	j	80005766 <virtio_disk_rw+0xd4>

0000000080005920 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005920:	1101                	addi	sp,sp,-32
    80005922:	ec06                	sd	ra,24(sp)
    80005924:	e822                	sd	s0,16(sp)
    80005926:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005928:	00016517          	auipc	a0,0x16
    8000592c:	80050513          	addi	a0,a0,-2048 # 8001b128 <disk+0x2128>
    80005930:	00001097          	auipc	ra,0x1
    80005934:	b76080e7          	jalr	-1162(ra) # 800064a6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	53b8                	lw	a4,96(a5)
    8000593e:	8b0d                	andi	a4,a4,3
    80005940:	100017b7          	lui	a5,0x10001
    80005944:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005946:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000594a:	00015797          	auipc	a5,0x15
    8000594e:	6b678793          	addi	a5,a5,1718 # 8001b000 <disk+0x2000>
    80005952:	6b94                	ld	a3,16(a5)
    80005954:	0207d703          	lhu	a4,32(a5)
    80005958:	0026d783          	lhu	a5,2(a3)
    8000595c:	06f70563          	beq	a4,a5,800059c6 <virtio_disk_intr+0xa6>
    80005960:	e426                	sd	s1,8(sp)
    80005962:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005964:	00013917          	auipc	s2,0x13
    80005968:	69c90913          	addi	s2,s2,1692 # 80019000 <disk>
    8000596c:	00015497          	auipc	s1,0x15
    80005970:	69448493          	addi	s1,s1,1684 # 8001b000 <disk+0x2000>
    __sync_synchronize();
    80005974:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005978:	6898                	ld	a4,16(s1)
    8000597a:	0204d783          	lhu	a5,32(s1)
    8000597e:	8b9d                	andi	a5,a5,7
    80005980:	078e                	slli	a5,a5,0x3
    80005982:	97ba                	add	a5,a5,a4
    80005984:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005986:	20078713          	addi	a4,a5,512
    8000598a:	0712                	slli	a4,a4,0x4
    8000598c:	974a                	add	a4,a4,s2
    8000598e:	03074703          	lbu	a4,48(a4)
    80005992:	e731                	bnez	a4,800059de <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005994:	20078793          	addi	a5,a5,512
    80005998:	0792                	slli	a5,a5,0x4
    8000599a:	97ca                	add	a5,a5,s2
    8000599c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000599e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059a2:	ffffc097          	auipc	ra,0xffffc
    800059a6:	d2c080e7          	jalr	-724(ra) # 800016ce <wakeup>

    disk.used_idx += 1;
    800059aa:	0204d783          	lhu	a5,32(s1)
    800059ae:	2785                	addiw	a5,a5,1
    800059b0:	17c2                	slli	a5,a5,0x30
    800059b2:	93c1                	srli	a5,a5,0x30
    800059b4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059b8:	6898                	ld	a4,16(s1)
    800059ba:	00275703          	lhu	a4,2(a4)
    800059be:	faf71be3          	bne	a4,a5,80005974 <virtio_disk_intr+0x54>
    800059c2:	64a2                	ld	s1,8(sp)
    800059c4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800059c6:	00015517          	auipc	a0,0x15
    800059ca:	76250513          	addi	a0,a0,1890 # 8001b128 <disk+0x2128>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	b8c080e7          	jalr	-1140(ra) # 8000655a <release>
}
    800059d6:	60e2                	ld	ra,24(sp)
    800059d8:	6442                	ld	s0,16(sp)
    800059da:	6105                	addi	sp,sp,32
    800059dc:	8082                	ret
      panic("virtio_disk_intr status");
    800059de:	00003517          	auipc	a0,0x3
    800059e2:	ca250513          	addi	a0,a0,-862 # 80008680 <etext+0x680>
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	546080e7          	jalr	1350(ra) # 80005f2c <panic>

00000000800059ee <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059ee:	1141                	addi	sp,sp,-16
    800059f0:	e422                	sd	s0,8(sp)
    800059f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059f4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059f8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059fc:	0037979b          	slliw	a5,a5,0x3
    80005a00:	02004737          	lui	a4,0x2004
    80005a04:	97ba                	add	a5,a5,a4
    80005a06:	0200c737          	lui	a4,0x200c
    80005a0a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005a0c:	6318                	ld	a4,0(a4)
    80005a0e:	000f4637          	lui	a2,0xf4
    80005a12:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a16:	9732                	add	a4,a4,a2
    80005a18:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a1a:	00259693          	slli	a3,a1,0x2
    80005a1e:	96ae                	add	a3,a3,a1
    80005a20:	068e                	slli	a3,a3,0x3
    80005a22:	00016717          	auipc	a4,0x16
    80005a26:	5de70713          	addi	a4,a4,1502 # 8001c000 <timer_scratch>
    80005a2a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a2c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a2e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a30:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a34:	00000797          	auipc	a5,0x0
    80005a38:	99c78793          	addi	a5,a5,-1636 # 800053d0 <timervec>
    80005a3c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a40:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a44:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a48:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a4c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a50:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a54:	30479073          	csrw	mie,a5
}
    80005a58:	6422                	ld	s0,8(sp)
    80005a5a:	0141                	addi	sp,sp,16
    80005a5c:	8082                	ret

0000000080005a5e <start>:
{
    80005a5e:	1141                	addi	sp,sp,-16
    80005a60:	e406                	sd	ra,8(sp)
    80005a62:	e022                	sd	s0,0(sp)
    80005a64:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a66:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a6a:	7779                	lui	a4,0xffffe
    80005a6c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda5bf>
    80005a70:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a72:	6705                	lui	a4,0x1
    80005a74:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a78:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a7a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a7e:	ffffb797          	auipc	a5,0xffffb
    80005a82:	89a78793          	addi	a5,a5,-1894 # 80000318 <main>
    80005a86:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a8a:	4781                	li	a5,0
    80005a8c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a90:	67c1                	lui	a5,0x10
    80005a92:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a94:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a98:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a9c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005aa0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005aa4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005aa8:	57fd                	li	a5,-1
    80005aaa:	83a9                	srli	a5,a5,0xa
    80005aac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ab0:	47bd                	li	a5,15
    80005ab2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ab6:	00000097          	auipc	ra,0x0
    80005aba:	f38080e7          	jalr	-200(ra) # 800059ee <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005abe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ac2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ac4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ac6:	30200073          	mret
}
    80005aca:	60a2                	ld	ra,8(sp)
    80005acc:	6402                	ld	s0,0(sp)
    80005ace:	0141                	addi	sp,sp,16
    80005ad0:	8082                	ret

0000000080005ad2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ad2:	715d                	addi	sp,sp,-80
    80005ad4:	e486                	sd	ra,72(sp)
    80005ad6:	e0a2                	sd	s0,64(sp)
    80005ad8:	f84a                	sd	s2,48(sp)
    80005ada:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005adc:	04c05663          	blez	a2,80005b28 <consolewrite+0x56>
    80005ae0:	fc26                	sd	s1,56(sp)
    80005ae2:	f44e                	sd	s3,40(sp)
    80005ae4:	f052                	sd	s4,32(sp)
    80005ae6:	ec56                	sd	s5,24(sp)
    80005ae8:	8a2a                	mv	s4,a0
    80005aea:	84ae                	mv	s1,a1
    80005aec:	89b2                	mv	s3,a2
    80005aee:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005af0:	5afd                	li	s5,-1
    80005af2:	4685                	li	a3,1
    80005af4:	8626                	mv	a2,s1
    80005af6:	85d2                	mv	a1,s4
    80005af8:	fbf40513          	addi	a0,s0,-65
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	e3a080e7          	jalr	-454(ra) # 80001936 <either_copyin>
    80005b04:	03550463          	beq	a0,s5,80005b2c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005b08:	fbf44503          	lbu	a0,-65(s0)
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	7de080e7          	jalr	2014(ra) # 800062ea <uartputc>
  for(i = 0; i < n; i++){
    80005b14:	2905                	addiw	s2,s2,1
    80005b16:	0485                	addi	s1,s1,1
    80005b18:	fd299de3          	bne	s3,s2,80005af2 <consolewrite+0x20>
    80005b1c:	894e                	mv	s2,s3
    80005b1e:	74e2                	ld	s1,56(sp)
    80005b20:	79a2                	ld	s3,40(sp)
    80005b22:	7a02                	ld	s4,32(sp)
    80005b24:	6ae2                	ld	s5,24(sp)
    80005b26:	a039                	j	80005b34 <consolewrite+0x62>
    80005b28:	4901                	li	s2,0
    80005b2a:	a029                	j	80005b34 <consolewrite+0x62>
    80005b2c:	74e2                	ld	s1,56(sp)
    80005b2e:	79a2                	ld	s3,40(sp)
    80005b30:	7a02                	ld	s4,32(sp)
    80005b32:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005b34:	854a                	mv	a0,s2
    80005b36:	60a6                	ld	ra,72(sp)
    80005b38:	6406                	ld	s0,64(sp)
    80005b3a:	7942                	ld	s2,48(sp)
    80005b3c:	6161                	addi	sp,sp,80
    80005b3e:	8082                	ret

0000000080005b40 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b40:	711d                	addi	sp,sp,-96
    80005b42:	ec86                	sd	ra,88(sp)
    80005b44:	e8a2                	sd	s0,80(sp)
    80005b46:	e4a6                	sd	s1,72(sp)
    80005b48:	e0ca                	sd	s2,64(sp)
    80005b4a:	fc4e                	sd	s3,56(sp)
    80005b4c:	f852                	sd	s4,48(sp)
    80005b4e:	f456                	sd	s5,40(sp)
    80005b50:	f05a                	sd	s6,32(sp)
    80005b52:	1080                	addi	s0,sp,96
    80005b54:	8aaa                	mv	s5,a0
    80005b56:	8a2e                	mv	s4,a1
    80005b58:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b5a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b5e:	0001e517          	auipc	a0,0x1e
    80005b62:	5e250513          	addi	a0,a0,1506 # 80024140 <cons>
    80005b66:	00001097          	auipc	ra,0x1
    80005b6a:	940080e7          	jalr	-1728(ra) # 800064a6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b6e:	0001e497          	auipc	s1,0x1e
    80005b72:	5d248493          	addi	s1,s1,1490 # 80024140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b76:	0001e917          	auipc	s2,0x1e
    80005b7a:	66290913          	addi	s2,s2,1634 # 800241d8 <cons+0x98>
  while(n > 0){
    80005b7e:	0d305463          	blez	s3,80005c46 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b82:	0984a783          	lw	a5,152(s1)
    80005b86:	09c4a703          	lw	a4,156(s1)
    80005b8a:	0af71963          	bne	a4,a5,80005c3c <consoleread+0xfc>
      if(myproc()->killed){
    80005b8e:	ffffb097          	auipc	ra,0xffffb
    80005b92:	2ee080e7          	jalr	750(ra) # 80000e7c <myproc>
    80005b96:	551c                	lw	a5,40(a0)
    80005b98:	e7ad                	bnez	a5,80005c02 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b9a:	85a6                	mv	a1,s1
    80005b9c:	854a                	mv	a0,s2
    80005b9e:	ffffc097          	auipc	ra,0xffffc
    80005ba2:	9a4080e7          	jalr	-1628(ra) # 80001542 <sleep>
    while(cons.r == cons.w){
    80005ba6:	0984a783          	lw	a5,152(s1)
    80005baa:	09c4a703          	lw	a4,156(s1)
    80005bae:	fef700e3          	beq	a4,a5,80005b8e <consoleread+0x4e>
    80005bb2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005bb4:	0001e717          	auipc	a4,0x1e
    80005bb8:	58c70713          	addi	a4,a4,1420 # 80024140 <cons>
    80005bbc:	0017869b          	addiw	a3,a5,1
    80005bc0:	08d72c23          	sw	a3,152(a4)
    80005bc4:	07f7f693          	andi	a3,a5,127
    80005bc8:	9736                	add	a4,a4,a3
    80005bca:	01874703          	lbu	a4,24(a4)
    80005bce:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005bd2:	4691                	li	a3,4
    80005bd4:	04db8a63          	beq	s7,a3,80005c28 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005bd8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bdc:	4685                	li	a3,1
    80005bde:	faf40613          	addi	a2,s0,-81
    80005be2:	85d2                	mv	a1,s4
    80005be4:	8556                	mv	a0,s5
    80005be6:	ffffc097          	auipc	ra,0xffffc
    80005bea:	cfa080e7          	jalr	-774(ra) # 800018e0 <either_copyout>
    80005bee:	57fd                	li	a5,-1
    80005bf0:	04f50a63          	beq	a0,a5,80005c44 <consoleread+0x104>
      break;

    dst++;
    80005bf4:	0a05                	addi	s4,s4,1
    --n;
    80005bf6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005bf8:	47a9                	li	a5,10
    80005bfa:	06fb8163          	beq	s7,a5,80005c5c <consoleread+0x11c>
    80005bfe:	6be2                	ld	s7,24(sp)
    80005c00:	bfbd                	j	80005b7e <consoleread+0x3e>
        release(&cons.lock);
    80005c02:	0001e517          	auipc	a0,0x1e
    80005c06:	53e50513          	addi	a0,a0,1342 # 80024140 <cons>
    80005c0a:	00001097          	auipc	ra,0x1
    80005c0e:	950080e7          	jalr	-1712(ra) # 8000655a <release>
        return -1;
    80005c12:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005c14:	60e6                	ld	ra,88(sp)
    80005c16:	6446                	ld	s0,80(sp)
    80005c18:	64a6                	ld	s1,72(sp)
    80005c1a:	6906                	ld	s2,64(sp)
    80005c1c:	79e2                	ld	s3,56(sp)
    80005c1e:	7a42                	ld	s4,48(sp)
    80005c20:	7aa2                	ld	s5,40(sp)
    80005c22:	7b02                	ld	s6,32(sp)
    80005c24:	6125                	addi	sp,sp,96
    80005c26:	8082                	ret
      if(n < target){
    80005c28:	0009871b          	sext.w	a4,s3
    80005c2c:	01677a63          	bgeu	a4,s6,80005c40 <consoleread+0x100>
        cons.r--;
    80005c30:	0001e717          	auipc	a4,0x1e
    80005c34:	5af72423          	sw	a5,1448(a4) # 800241d8 <cons+0x98>
    80005c38:	6be2                	ld	s7,24(sp)
    80005c3a:	a031                	j	80005c46 <consoleread+0x106>
    80005c3c:	ec5e                	sd	s7,24(sp)
    80005c3e:	bf9d                	j	80005bb4 <consoleread+0x74>
    80005c40:	6be2                	ld	s7,24(sp)
    80005c42:	a011                	j	80005c46 <consoleread+0x106>
    80005c44:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c46:	0001e517          	auipc	a0,0x1e
    80005c4a:	4fa50513          	addi	a0,a0,1274 # 80024140 <cons>
    80005c4e:	00001097          	auipc	ra,0x1
    80005c52:	90c080e7          	jalr	-1780(ra) # 8000655a <release>
  return target - n;
    80005c56:	413b053b          	subw	a0,s6,s3
    80005c5a:	bf6d                	j	80005c14 <consoleread+0xd4>
    80005c5c:	6be2                	ld	s7,24(sp)
    80005c5e:	b7e5                	j	80005c46 <consoleread+0x106>

0000000080005c60 <consputc>:
{
    80005c60:	1141                	addi	sp,sp,-16
    80005c62:	e406                	sd	ra,8(sp)
    80005c64:	e022                	sd	s0,0(sp)
    80005c66:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c68:	10000793          	li	a5,256
    80005c6c:	00f50a63          	beq	a0,a5,80005c80 <consputc+0x20>
    uartputc_sync(c);
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	59c080e7          	jalr	1436(ra) # 8000620c <uartputc_sync>
}
    80005c78:	60a2                	ld	ra,8(sp)
    80005c7a:	6402                	ld	s0,0(sp)
    80005c7c:	0141                	addi	sp,sp,16
    80005c7e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c80:	4521                	li	a0,8
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	58a080e7          	jalr	1418(ra) # 8000620c <uartputc_sync>
    80005c8a:	02000513          	li	a0,32
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	57e080e7          	jalr	1406(ra) # 8000620c <uartputc_sync>
    80005c96:	4521                	li	a0,8
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	574080e7          	jalr	1396(ra) # 8000620c <uartputc_sync>
    80005ca0:	bfe1                	j	80005c78 <consputc+0x18>

0000000080005ca2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ca2:	1101                	addi	sp,sp,-32
    80005ca4:	ec06                	sd	ra,24(sp)
    80005ca6:	e822                	sd	s0,16(sp)
    80005ca8:	e426                	sd	s1,8(sp)
    80005caa:	1000                	addi	s0,sp,32
    80005cac:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cae:	0001e517          	auipc	a0,0x1e
    80005cb2:	49250513          	addi	a0,a0,1170 # 80024140 <cons>
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	7f0080e7          	jalr	2032(ra) # 800064a6 <acquire>

  switch(c){
    80005cbe:	47d5                	li	a5,21
    80005cc0:	0af48563          	beq	s1,a5,80005d6a <consoleintr+0xc8>
    80005cc4:	0297c963          	blt	a5,s1,80005cf6 <consoleintr+0x54>
    80005cc8:	47a1                	li	a5,8
    80005cca:	0ef48c63          	beq	s1,a5,80005dc2 <consoleintr+0x120>
    80005cce:	47c1                	li	a5,16
    80005cd0:	10f49f63          	bne	s1,a5,80005dee <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005cd4:	ffffc097          	auipc	ra,0xffffc
    80005cd8:	cb8080e7          	jalr	-840(ra) # 8000198c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cdc:	0001e517          	auipc	a0,0x1e
    80005ce0:	46450513          	addi	a0,a0,1124 # 80024140 <cons>
    80005ce4:	00001097          	auipc	ra,0x1
    80005ce8:	876080e7          	jalr	-1930(ra) # 8000655a <release>
}
    80005cec:	60e2                	ld	ra,24(sp)
    80005cee:	6442                	ld	s0,16(sp)
    80005cf0:	64a2                	ld	s1,8(sp)
    80005cf2:	6105                	addi	sp,sp,32
    80005cf4:	8082                	ret
  switch(c){
    80005cf6:	07f00793          	li	a5,127
    80005cfa:	0cf48463          	beq	s1,a5,80005dc2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cfe:	0001e717          	auipc	a4,0x1e
    80005d02:	44270713          	addi	a4,a4,1090 # 80024140 <cons>
    80005d06:	0a072783          	lw	a5,160(a4)
    80005d0a:	09872703          	lw	a4,152(a4)
    80005d0e:	9f99                	subw	a5,a5,a4
    80005d10:	07f00713          	li	a4,127
    80005d14:	fcf764e3          	bltu	a4,a5,80005cdc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005d18:	47b5                	li	a5,13
    80005d1a:	0cf48d63          	beq	s1,a5,80005df4 <consoleintr+0x152>
      consputc(c);
    80005d1e:	8526                	mv	a0,s1
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	f40080e7          	jalr	-192(ra) # 80005c60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d28:	0001e797          	auipc	a5,0x1e
    80005d2c:	41878793          	addi	a5,a5,1048 # 80024140 <cons>
    80005d30:	0a07a703          	lw	a4,160(a5)
    80005d34:	0017069b          	addiw	a3,a4,1
    80005d38:	0006861b          	sext.w	a2,a3
    80005d3c:	0ad7a023          	sw	a3,160(a5)
    80005d40:	07f77713          	andi	a4,a4,127
    80005d44:	97ba                	add	a5,a5,a4
    80005d46:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d4a:	47a9                	li	a5,10
    80005d4c:	0cf48b63          	beq	s1,a5,80005e22 <consoleintr+0x180>
    80005d50:	4791                	li	a5,4
    80005d52:	0cf48863          	beq	s1,a5,80005e22 <consoleintr+0x180>
    80005d56:	0001e797          	auipc	a5,0x1e
    80005d5a:	4827a783          	lw	a5,1154(a5) # 800241d8 <cons+0x98>
    80005d5e:	0807879b          	addiw	a5,a5,128
    80005d62:	f6f61de3          	bne	a2,a5,80005cdc <consoleintr+0x3a>
    80005d66:	863e                	mv	a2,a5
    80005d68:	a86d                	j	80005e22 <consoleintr+0x180>
    80005d6a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005d6c:	0001e717          	auipc	a4,0x1e
    80005d70:	3d470713          	addi	a4,a4,980 # 80024140 <cons>
    80005d74:	0a072783          	lw	a5,160(a4)
    80005d78:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d7c:	0001e497          	auipc	s1,0x1e
    80005d80:	3c448493          	addi	s1,s1,964 # 80024140 <cons>
    while(cons.e != cons.w &&
    80005d84:	4929                	li	s2,10
    80005d86:	02f70a63          	beq	a4,a5,80005dba <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d8a:	37fd                	addiw	a5,a5,-1
    80005d8c:	07f7f713          	andi	a4,a5,127
    80005d90:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d92:	01874703          	lbu	a4,24(a4)
    80005d96:	03270463          	beq	a4,s2,80005dbe <consoleintr+0x11c>
      cons.e--;
    80005d9a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d9e:	10000513          	li	a0,256
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	ebe080e7          	jalr	-322(ra) # 80005c60 <consputc>
    while(cons.e != cons.w &&
    80005daa:	0a04a783          	lw	a5,160(s1)
    80005dae:	09c4a703          	lw	a4,156(s1)
    80005db2:	fcf71ce3          	bne	a4,a5,80005d8a <consoleintr+0xe8>
    80005db6:	6902                	ld	s2,0(sp)
    80005db8:	b715                	j	80005cdc <consoleintr+0x3a>
    80005dba:	6902                	ld	s2,0(sp)
    80005dbc:	b705                	j	80005cdc <consoleintr+0x3a>
    80005dbe:	6902                	ld	s2,0(sp)
    80005dc0:	bf31                	j	80005cdc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005dc2:	0001e717          	auipc	a4,0x1e
    80005dc6:	37e70713          	addi	a4,a4,894 # 80024140 <cons>
    80005dca:	0a072783          	lw	a5,160(a4)
    80005dce:	09c72703          	lw	a4,156(a4)
    80005dd2:	f0f705e3          	beq	a4,a5,80005cdc <consoleintr+0x3a>
      cons.e--;
    80005dd6:	37fd                	addiw	a5,a5,-1
    80005dd8:	0001e717          	auipc	a4,0x1e
    80005ddc:	40f72423          	sw	a5,1032(a4) # 800241e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005de0:	10000513          	li	a0,256
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	e7c080e7          	jalr	-388(ra) # 80005c60 <consputc>
    80005dec:	bdc5                	j	80005cdc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dee:	ee0487e3          	beqz	s1,80005cdc <consoleintr+0x3a>
    80005df2:	b731                	j	80005cfe <consoleintr+0x5c>
      consputc(c);
    80005df4:	4529                	li	a0,10
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	e6a080e7          	jalr	-406(ra) # 80005c60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dfe:	0001e797          	auipc	a5,0x1e
    80005e02:	34278793          	addi	a5,a5,834 # 80024140 <cons>
    80005e06:	0a07a703          	lw	a4,160(a5)
    80005e0a:	0017069b          	addiw	a3,a4,1
    80005e0e:	0006861b          	sext.w	a2,a3
    80005e12:	0ad7a023          	sw	a3,160(a5)
    80005e16:	07f77713          	andi	a4,a4,127
    80005e1a:	97ba                	add	a5,a5,a4
    80005e1c:	4729                	li	a4,10
    80005e1e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e22:	0001e797          	auipc	a5,0x1e
    80005e26:	3ac7ad23          	sw	a2,954(a5) # 800241dc <cons+0x9c>
        wakeup(&cons.r);
    80005e2a:	0001e517          	auipc	a0,0x1e
    80005e2e:	3ae50513          	addi	a0,a0,942 # 800241d8 <cons+0x98>
    80005e32:	ffffc097          	auipc	ra,0xffffc
    80005e36:	89c080e7          	jalr	-1892(ra) # 800016ce <wakeup>
    80005e3a:	b54d                	j	80005cdc <consoleintr+0x3a>

0000000080005e3c <consoleinit>:

void
consoleinit(void)
{
    80005e3c:	1141                	addi	sp,sp,-16
    80005e3e:	e406                	sd	ra,8(sp)
    80005e40:	e022                	sd	s0,0(sp)
    80005e42:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e44:	00003597          	auipc	a1,0x3
    80005e48:	85458593          	addi	a1,a1,-1964 # 80008698 <etext+0x698>
    80005e4c:	0001e517          	auipc	a0,0x1e
    80005e50:	2f450513          	addi	a0,a0,756 # 80024140 <cons>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	5c2080e7          	jalr	1474(ra) # 80006416 <initlock>

  uartinit();
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	354080e7          	jalr	852(ra) # 800061b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e64:	00011797          	auipc	a5,0x11
    80005e68:	67478793          	addi	a5,a5,1652 # 800174d8 <devsw>
    80005e6c:	00000717          	auipc	a4,0x0
    80005e70:	cd470713          	addi	a4,a4,-812 # 80005b40 <consoleread>
    80005e74:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e76:	00000717          	auipc	a4,0x0
    80005e7a:	c5c70713          	addi	a4,a4,-932 # 80005ad2 <consolewrite>
    80005e7e:	ef98                	sd	a4,24(a5)
}
    80005e80:	60a2                	ld	ra,8(sp)
    80005e82:	6402                	ld	s0,0(sp)
    80005e84:	0141                	addi	sp,sp,16
    80005e86:	8082                	ret

0000000080005e88 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e88:	7179                	addi	sp,sp,-48
    80005e8a:	f406                	sd	ra,40(sp)
    80005e8c:	f022                	sd	s0,32(sp)
    80005e8e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e90:	c219                	beqz	a2,80005e96 <printint+0xe>
    80005e92:	08054963          	bltz	a0,80005f24 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e96:	2501                	sext.w	a0,a0
    80005e98:	4881                	li	a7,0
    80005e9a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e9e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ea0:	2581                	sext.w	a1,a1
    80005ea2:	00003617          	auipc	a2,0x3
    80005ea6:	95e60613          	addi	a2,a2,-1698 # 80008800 <digits>
    80005eaa:	883a                	mv	a6,a4
    80005eac:	2705                	addiw	a4,a4,1
    80005eae:	02b577bb          	remuw	a5,a0,a1
    80005eb2:	1782                	slli	a5,a5,0x20
    80005eb4:	9381                	srli	a5,a5,0x20
    80005eb6:	97b2                	add	a5,a5,a2
    80005eb8:	0007c783          	lbu	a5,0(a5)
    80005ebc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ec0:	0005079b          	sext.w	a5,a0
    80005ec4:	02b5553b          	divuw	a0,a0,a1
    80005ec8:	0685                	addi	a3,a3,1
    80005eca:	feb7f0e3          	bgeu	a5,a1,80005eaa <printint+0x22>

  if(sign)
    80005ece:	00088c63          	beqz	a7,80005ee6 <printint+0x5e>
    buf[i++] = '-';
    80005ed2:	fe070793          	addi	a5,a4,-32
    80005ed6:	00878733          	add	a4,a5,s0
    80005eda:	02d00793          	li	a5,45
    80005ede:	fef70823          	sb	a5,-16(a4)
    80005ee2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ee6:	02e05b63          	blez	a4,80005f1c <printint+0x94>
    80005eea:	ec26                	sd	s1,24(sp)
    80005eec:	e84a                	sd	s2,16(sp)
    80005eee:	fd040793          	addi	a5,s0,-48
    80005ef2:	00e784b3          	add	s1,a5,a4
    80005ef6:	fff78913          	addi	s2,a5,-1
    80005efa:	993a                	add	s2,s2,a4
    80005efc:	377d                	addiw	a4,a4,-1
    80005efe:	1702                	slli	a4,a4,0x20
    80005f00:	9301                	srli	a4,a4,0x20
    80005f02:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f06:	fff4c503          	lbu	a0,-1(s1)
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	d56080e7          	jalr	-682(ra) # 80005c60 <consputc>
  while(--i >= 0)
    80005f12:	14fd                	addi	s1,s1,-1
    80005f14:	ff2499e3          	bne	s1,s2,80005f06 <printint+0x7e>
    80005f18:	64e2                	ld	s1,24(sp)
    80005f1a:	6942                	ld	s2,16(sp)
}
    80005f1c:	70a2                	ld	ra,40(sp)
    80005f1e:	7402                	ld	s0,32(sp)
    80005f20:	6145                	addi	sp,sp,48
    80005f22:	8082                	ret
    x = -xx;
    80005f24:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f28:	4885                	li	a7,1
    x = -xx;
    80005f2a:	bf85                	j	80005e9a <printint+0x12>

0000000080005f2c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f2c:	1101                	addi	sp,sp,-32
    80005f2e:	ec06                	sd	ra,24(sp)
    80005f30:	e822                	sd	s0,16(sp)
    80005f32:	e426                	sd	s1,8(sp)
    80005f34:	1000                	addi	s0,sp,32
    80005f36:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f38:	0001e797          	auipc	a5,0x1e
    80005f3c:	2c07a423          	sw	zero,712(a5) # 80024200 <pr+0x18>
  printf("panic: ");
    80005f40:	00002517          	auipc	a0,0x2
    80005f44:	76050513          	addi	a0,a0,1888 # 800086a0 <etext+0x6a0>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	02e080e7          	jalr	46(ra) # 80005f76 <printf>
  printf(s);
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	024080e7          	jalr	36(ra) # 80005f76 <printf>
  printf("\n");
    80005f5a:	00002517          	auipc	a0,0x2
    80005f5e:	0be50513          	addi	a0,a0,190 # 80008018 <etext+0x18>
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	014080e7          	jalr	20(ra) # 80005f76 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f6a:	4785                	li	a5,1
    80005f6c:	00006717          	auipc	a4,0x6
    80005f70:	0af72823          	sw	a5,176(a4) # 8000c01c <panicked>
  for(;;)
    80005f74:	a001                	j	80005f74 <panic+0x48>

0000000080005f76 <printf>:
{
    80005f76:	7131                	addi	sp,sp,-192
    80005f78:	fc86                	sd	ra,120(sp)
    80005f7a:	f8a2                	sd	s0,112(sp)
    80005f7c:	e8d2                	sd	s4,80(sp)
    80005f7e:	f06a                	sd	s10,32(sp)
    80005f80:	0100                	addi	s0,sp,128
    80005f82:	8a2a                	mv	s4,a0
    80005f84:	e40c                	sd	a1,8(s0)
    80005f86:	e810                	sd	a2,16(s0)
    80005f88:	ec14                	sd	a3,24(s0)
    80005f8a:	f018                	sd	a4,32(s0)
    80005f8c:	f41c                	sd	a5,40(s0)
    80005f8e:	03043823          	sd	a6,48(s0)
    80005f92:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f96:	0001ed17          	auipc	s10,0x1e
    80005f9a:	26ad2d03          	lw	s10,618(s10) # 80024200 <pr+0x18>
  if(locking)
    80005f9e:	040d1463          	bnez	s10,80005fe6 <printf+0x70>
  if (fmt == 0)
    80005fa2:	040a0b63          	beqz	s4,80005ff8 <printf+0x82>
  va_start(ap, fmt);
    80005fa6:	00840793          	addi	a5,s0,8
    80005faa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fae:	000a4503          	lbu	a0,0(s4)
    80005fb2:	18050b63          	beqz	a0,80006148 <printf+0x1d2>
    80005fb6:	f4a6                	sd	s1,104(sp)
    80005fb8:	f0ca                	sd	s2,96(sp)
    80005fba:	ecce                	sd	s3,88(sp)
    80005fbc:	e4d6                	sd	s5,72(sp)
    80005fbe:	e0da                	sd	s6,64(sp)
    80005fc0:	fc5e                	sd	s7,56(sp)
    80005fc2:	f862                	sd	s8,48(sp)
    80005fc4:	f466                	sd	s9,40(sp)
    80005fc6:	ec6e                	sd	s11,24(sp)
    80005fc8:	4981                	li	s3,0
    if(c != '%'){
    80005fca:	02500b13          	li	s6,37
    switch(c){
    80005fce:	07000b93          	li	s7,112
  consputc('x');
    80005fd2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd4:	00003a97          	auipc	s5,0x3
    80005fd8:	82ca8a93          	addi	s5,s5,-2004 # 80008800 <digits>
    switch(c){
    80005fdc:	07300c13          	li	s8,115
    80005fe0:	06400d93          	li	s11,100
    80005fe4:	a0b1                	j	80006030 <printf+0xba>
    acquire(&pr.lock);
    80005fe6:	0001e517          	auipc	a0,0x1e
    80005fea:	20250513          	addi	a0,a0,514 # 800241e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	4b8080e7          	jalr	1208(ra) # 800064a6 <acquire>
    80005ff6:	b775                	j	80005fa2 <printf+0x2c>
    80005ff8:	f4a6                	sd	s1,104(sp)
    80005ffa:	f0ca                	sd	s2,96(sp)
    80005ffc:	ecce                	sd	s3,88(sp)
    80005ffe:	e4d6                	sd	s5,72(sp)
    80006000:	e0da                	sd	s6,64(sp)
    80006002:	fc5e                	sd	s7,56(sp)
    80006004:	f862                	sd	s8,48(sp)
    80006006:	f466                	sd	s9,40(sp)
    80006008:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000600a:	00002517          	auipc	a0,0x2
    8000600e:	6a650513          	addi	a0,a0,1702 # 800086b0 <etext+0x6b0>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	f1a080e7          	jalr	-230(ra) # 80005f2c <panic>
      consputc(c);
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	c46080e7          	jalr	-954(ra) # 80005c60 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006022:	2985                	addiw	s3,s3,1
    80006024:	013a07b3          	add	a5,s4,s3
    80006028:	0007c503          	lbu	a0,0(a5)
    8000602c:	10050563          	beqz	a0,80006136 <printf+0x1c0>
    if(c != '%'){
    80006030:	ff6515e3          	bne	a0,s6,8000601a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006034:	2985                	addiw	s3,s3,1
    80006036:	013a07b3          	add	a5,s4,s3
    8000603a:	0007c783          	lbu	a5,0(a5)
    8000603e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006042:	10078b63          	beqz	a5,80006158 <printf+0x1e2>
    switch(c){
    80006046:	05778a63          	beq	a5,s7,8000609a <printf+0x124>
    8000604a:	02fbf663          	bgeu	s7,a5,80006076 <printf+0x100>
    8000604e:	09878863          	beq	a5,s8,800060de <printf+0x168>
    80006052:	07800713          	li	a4,120
    80006056:	0ce79563          	bne	a5,a4,80006120 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000605a:	f8843783          	ld	a5,-120(s0)
    8000605e:	00878713          	addi	a4,a5,8
    80006062:	f8e43423          	sd	a4,-120(s0)
    80006066:	4605                	li	a2,1
    80006068:	85e6                	mv	a1,s9
    8000606a:	4388                	lw	a0,0(a5)
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	e1c080e7          	jalr	-484(ra) # 80005e88 <printint>
      break;
    80006074:	b77d                	j	80006022 <printf+0xac>
    switch(c){
    80006076:	09678f63          	beq	a5,s6,80006114 <printf+0x19e>
    8000607a:	0bb79363          	bne	a5,s11,80006120 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000607e:	f8843783          	ld	a5,-120(s0)
    80006082:	00878713          	addi	a4,a5,8
    80006086:	f8e43423          	sd	a4,-120(s0)
    8000608a:	4605                	li	a2,1
    8000608c:	45a9                	li	a1,10
    8000608e:	4388                	lw	a0,0(a5)
    80006090:	00000097          	auipc	ra,0x0
    80006094:	df8080e7          	jalr	-520(ra) # 80005e88 <printint>
      break;
    80006098:	b769                	j	80006022 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000609a:	f8843783          	ld	a5,-120(s0)
    8000609e:	00878713          	addi	a4,a5,8
    800060a2:	f8e43423          	sd	a4,-120(s0)
    800060a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800060aa:	03000513          	li	a0,48
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	bb2080e7          	jalr	-1102(ra) # 80005c60 <consputc>
  consputc('x');
    800060b6:	07800513          	li	a0,120
    800060ba:	00000097          	auipc	ra,0x0
    800060be:	ba6080e7          	jalr	-1114(ra) # 80005c60 <consputc>
    800060c2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060c4:	03c95793          	srli	a5,s2,0x3c
    800060c8:	97d6                	add	a5,a5,s5
    800060ca:	0007c503          	lbu	a0,0(a5)
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	b92080e7          	jalr	-1134(ra) # 80005c60 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060d6:	0912                	slli	s2,s2,0x4
    800060d8:	34fd                	addiw	s1,s1,-1
    800060da:	f4ed                	bnez	s1,800060c4 <printf+0x14e>
    800060dc:	b799                	j	80006022 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800060de:	f8843783          	ld	a5,-120(s0)
    800060e2:	00878713          	addi	a4,a5,8
    800060e6:	f8e43423          	sd	a4,-120(s0)
    800060ea:	6384                	ld	s1,0(a5)
    800060ec:	cc89                	beqz	s1,80006106 <printf+0x190>
      for(; *s; s++)
    800060ee:	0004c503          	lbu	a0,0(s1)
    800060f2:	d905                	beqz	a0,80006022 <printf+0xac>
        consputc(*s);
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	b6c080e7          	jalr	-1172(ra) # 80005c60 <consputc>
      for(; *s; s++)
    800060fc:	0485                	addi	s1,s1,1
    800060fe:	0004c503          	lbu	a0,0(s1)
    80006102:	f96d                	bnez	a0,800060f4 <printf+0x17e>
    80006104:	bf39                	j	80006022 <printf+0xac>
        s = "(null)";
    80006106:	00002497          	auipc	s1,0x2
    8000610a:	5a248493          	addi	s1,s1,1442 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    8000610e:	02800513          	li	a0,40
    80006112:	b7cd                	j	800060f4 <printf+0x17e>
      consputc('%');
    80006114:	855a                	mv	a0,s6
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	b4a080e7          	jalr	-1206(ra) # 80005c60 <consputc>
      break;
    8000611e:	b711                	j	80006022 <printf+0xac>
      consputc('%');
    80006120:	855a                	mv	a0,s6
    80006122:	00000097          	auipc	ra,0x0
    80006126:	b3e080e7          	jalr	-1218(ra) # 80005c60 <consputc>
      consputc(c);
    8000612a:	8526                	mv	a0,s1
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	b34080e7          	jalr	-1228(ra) # 80005c60 <consputc>
      break;
    80006134:	b5fd                	j	80006022 <printf+0xac>
    80006136:	74a6                	ld	s1,104(sp)
    80006138:	7906                	ld	s2,96(sp)
    8000613a:	69e6                	ld	s3,88(sp)
    8000613c:	6aa6                	ld	s5,72(sp)
    8000613e:	6b06                	ld	s6,64(sp)
    80006140:	7be2                	ld	s7,56(sp)
    80006142:	7c42                	ld	s8,48(sp)
    80006144:	7ca2                	ld	s9,40(sp)
    80006146:	6de2                	ld	s11,24(sp)
  if(locking)
    80006148:	020d1263          	bnez	s10,8000616c <printf+0x1f6>
}
    8000614c:	70e6                	ld	ra,120(sp)
    8000614e:	7446                	ld	s0,112(sp)
    80006150:	6a46                	ld	s4,80(sp)
    80006152:	7d02                	ld	s10,32(sp)
    80006154:	6129                	addi	sp,sp,192
    80006156:	8082                	ret
    80006158:	74a6                	ld	s1,104(sp)
    8000615a:	7906                	ld	s2,96(sp)
    8000615c:	69e6                	ld	s3,88(sp)
    8000615e:	6aa6                	ld	s5,72(sp)
    80006160:	6b06                	ld	s6,64(sp)
    80006162:	7be2                	ld	s7,56(sp)
    80006164:	7c42                	ld	s8,48(sp)
    80006166:	7ca2                	ld	s9,40(sp)
    80006168:	6de2                	ld	s11,24(sp)
    8000616a:	bff9                	j	80006148 <printf+0x1d2>
    release(&pr.lock);
    8000616c:	0001e517          	auipc	a0,0x1e
    80006170:	07c50513          	addi	a0,a0,124 # 800241e8 <pr>
    80006174:	00000097          	auipc	ra,0x0
    80006178:	3e6080e7          	jalr	998(ra) # 8000655a <release>
}
    8000617c:	bfc1                	j	8000614c <printf+0x1d6>

000000008000617e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000617e:	1101                	addi	sp,sp,-32
    80006180:	ec06                	sd	ra,24(sp)
    80006182:	e822                	sd	s0,16(sp)
    80006184:	e426                	sd	s1,8(sp)
    80006186:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006188:	0001e497          	auipc	s1,0x1e
    8000618c:	06048493          	addi	s1,s1,96 # 800241e8 <pr>
    80006190:	00002597          	auipc	a1,0x2
    80006194:	53058593          	addi	a1,a1,1328 # 800086c0 <etext+0x6c0>
    80006198:	8526                	mv	a0,s1
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	27c080e7          	jalr	636(ra) # 80006416 <initlock>
  pr.locking = 1;
    800061a2:	4785                	li	a5,1
    800061a4:	cc9c                	sw	a5,24(s1)
}
    800061a6:	60e2                	ld	ra,24(sp)
    800061a8:	6442                	ld	s0,16(sp)
    800061aa:	64a2                	ld	s1,8(sp)
    800061ac:	6105                	addi	sp,sp,32
    800061ae:	8082                	ret

00000000800061b0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061b0:	1141                	addi	sp,sp,-16
    800061b2:	e406                	sd	ra,8(sp)
    800061b4:	e022                	sd	s0,0(sp)
    800061b6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061b8:	100007b7          	lui	a5,0x10000
    800061bc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061c0:	10000737          	lui	a4,0x10000
    800061c4:	f8000693          	li	a3,-128
    800061c8:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061cc:	468d                	li	a3,3
    800061ce:	10000637          	lui	a2,0x10000
    800061d2:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061d6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061da:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061de:	10000737          	lui	a4,0x10000
    800061e2:	461d                	li	a2,7
    800061e4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061e8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061ec:	00002597          	auipc	a1,0x2
    800061f0:	4dc58593          	addi	a1,a1,1244 # 800086c8 <etext+0x6c8>
    800061f4:	0001e517          	auipc	a0,0x1e
    800061f8:	01450513          	addi	a0,a0,20 # 80024208 <uart_tx_lock>
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	21a080e7          	jalr	538(ra) # 80006416 <initlock>
}
    80006204:	60a2                	ld	ra,8(sp)
    80006206:	6402                	ld	s0,0(sp)
    80006208:	0141                	addi	sp,sp,16
    8000620a:	8082                	ret

000000008000620c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000620c:	1101                	addi	sp,sp,-32
    8000620e:	ec06                	sd	ra,24(sp)
    80006210:	e822                	sd	s0,16(sp)
    80006212:	e426                	sd	s1,8(sp)
    80006214:	1000                	addi	s0,sp,32
    80006216:	84aa                	mv	s1,a0
  push_off();
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	242080e7          	jalr	578(ra) # 8000645a <push_off>

  if(panicked){
    80006220:	00006797          	auipc	a5,0x6
    80006224:	dfc7a783          	lw	a5,-516(a5) # 8000c01c <panicked>
    80006228:	eb85                	bnez	a5,80006258 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000622a:	10000737          	lui	a4,0x10000
    8000622e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006230:	00074783          	lbu	a5,0(a4)
    80006234:	0207f793          	andi	a5,a5,32
    80006238:	dfe5                	beqz	a5,80006230 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000623a:	0ff4f513          	zext.b	a0,s1
    8000623e:	100007b7          	lui	a5,0x10000
    80006242:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	2b4080e7          	jalr	692(ra) # 800064fa <pop_off>
}
    8000624e:	60e2                	ld	ra,24(sp)
    80006250:	6442                	ld	s0,16(sp)
    80006252:	64a2                	ld	s1,8(sp)
    80006254:	6105                	addi	sp,sp,32
    80006256:	8082                	ret
    for(;;)
    80006258:	a001                	j	80006258 <uartputc_sync+0x4c>

000000008000625a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000625a:	00006797          	auipc	a5,0x6
    8000625e:	dc67b783          	ld	a5,-570(a5) # 8000c020 <uart_tx_r>
    80006262:	00006717          	auipc	a4,0x6
    80006266:	dc673703          	ld	a4,-570(a4) # 8000c028 <uart_tx_w>
    8000626a:	06f70f63          	beq	a4,a5,800062e8 <uartstart+0x8e>
{
    8000626e:	7139                	addi	sp,sp,-64
    80006270:	fc06                	sd	ra,56(sp)
    80006272:	f822                	sd	s0,48(sp)
    80006274:	f426                	sd	s1,40(sp)
    80006276:	f04a                	sd	s2,32(sp)
    80006278:	ec4e                	sd	s3,24(sp)
    8000627a:	e852                	sd	s4,16(sp)
    8000627c:	e456                	sd	s5,8(sp)
    8000627e:	e05a                	sd	s6,0(sp)
    80006280:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006282:	10000937          	lui	s2,0x10000
    80006286:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006288:	0001ea97          	auipc	s5,0x1e
    8000628c:	f80a8a93          	addi	s5,s5,-128 # 80024208 <uart_tx_lock>
    uart_tx_r += 1;
    80006290:	00006497          	auipc	s1,0x6
    80006294:	d9048493          	addi	s1,s1,-624 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006298:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000629c:	00006997          	auipc	s3,0x6
    800062a0:	d8c98993          	addi	s3,s3,-628 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062a4:	00094703          	lbu	a4,0(s2)
    800062a8:	02077713          	andi	a4,a4,32
    800062ac:	c705                	beqz	a4,800062d4 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062ae:	01f7f713          	andi	a4,a5,31
    800062b2:	9756                	add	a4,a4,s5
    800062b4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800062b8:	0785                	addi	a5,a5,1
    800062ba:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800062bc:	8526                	mv	a0,s1
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	410080e7          	jalr	1040(ra) # 800016ce <wakeup>
    WriteReg(THR, c);
    800062c6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062ca:	609c                	ld	a5,0(s1)
    800062cc:	0009b703          	ld	a4,0(s3)
    800062d0:	fcf71ae3          	bne	a4,a5,800062a4 <uartstart+0x4a>
  }
}
    800062d4:	70e2                	ld	ra,56(sp)
    800062d6:	7442                	ld	s0,48(sp)
    800062d8:	74a2                	ld	s1,40(sp)
    800062da:	7902                	ld	s2,32(sp)
    800062dc:	69e2                	ld	s3,24(sp)
    800062de:	6a42                	ld	s4,16(sp)
    800062e0:	6aa2                	ld	s5,8(sp)
    800062e2:	6b02                	ld	s6,0(sp)
    800062e4:	6121                	addi	sp,sp,64
    800062e6:	8082                	ret
    800062e8:	8082                	ret

00000000800062ea <uartputc>:
{
    800062ea:	7179                	addi	sp,sp,-48
    800062ec:	f406                	sd	ra,40(sp)
    800062ee:	f022                	sd	s0,32(sp)
    800062f0:	e052                	sd	s4,0(sp)
    800062f2:	1800                	addi	s0,sp,48
    800062f4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062f6:	0001e517          	auipc	a0,0x1e
    800062fa:	f1250513          	addi	a0,a0,-238 # 80024208 <uart_tx_lock>
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	1a8080e7          	jalr	424(ra) # 800064a6 <acquire>
  if(panicked){
    80006306:	00006797          	auipc	a5,0x6
    8000630a:	d167a783          	lw	a5,-746(a5) # 8000c01c <panicked>
    8000630e:	c391                	beqz	a5,80006312 <uartputc+0x28>
    for(;;)
    80006310:	a001                	j	80006310 <uartputc+0x26>
    80006312:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006314:	00006717          	auipc	a4,0x6
    80006318:	d1473703          	ld	a4,-748(a4) # 8000c028 <uart_tx_w>
    8000631c:	00006797          	auipc	a5,0x6
    80006320:	d047b783          	ld	a5,-764(a5) # 8000c020 <uart_tx_r>
    80006324:	02078793          	addi	a5,a5,32
    80006328:	02e79f63          	bne	a5,a4,80006366 <uartputc+0x7c>
    8000632c:	e84a                	sd	s2,16(sp)
    8000632e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006330:	0001e997          	auipc	s3,0x1e
    80006334:	ed898993          	addi	s3,s3,-296 # 80024208 <uart_tx_lock>
    80006338:	00006497          	auipc	s1,0x6
    8000633c:	ce848493          	addi	s1,s1,-792 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006340:	00006917          	auipc	s2,0x6
    80006344:	ce890913          	addi	s2,s2,-792 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006348:	85ce                	mv	a1,s3
    8000634a:	8526                	mv	a0,s1
    8000634c:	ffffb097          	auipc	ra,0xffffb
    80006350:	1f6080e7          	jalr	502(ra) # 80001542 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006354:	00093703          	ld	a4,0(s2)
    80006358:	609c                	ld	a5,0(s1)
    8000635a:	02078793          	addi	a5,a5,32
    8000635e:	fee785e3          	beq	a5,a4,80006348 <uartputc+0x5e>
    80006362:	6942                	ld	s2,16(sp)
    80006364:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006366:	0001e497          	auipc	s1,0x1e
    8000636a:	ea248493          	addi	s1,s1,-350 # 80024208 <uart_tx_lock>
    8000636e:	01f77793          	andi	a5,a4,31
    80006372:	97a6                	add	a5,a5,s1
    80006374:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006378:	0705                	addi	a4,a4,1
    8000637a:	00006797          	auipc	a5,0x6
    8000637e:	cae7b723          	sd	a4,-850(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006382:	00000097          	auipc	ra,0x0
    80006386:	ed8080e7          	jalr	-296(ra) # 8000625a <uartstart>
      release(&uart_tx_lock);
    8000638a:	8526                	mv	a0,s1
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	1ce080e7          	jalr	462(ra) # 8000655a <release>
    80006394:	64e2                	ld	s1,24(sp)
}
    80006396:	70a2                	ld	ra,40(sp)
    80006398:	7402                	ld	s0,32(sp)
    8000639a:	6a02                	ld	s4,0(sp)
    8000639c:	6145                	addi	sp,sp,48
    8000639e:	8082                	ret

00000000800063a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063a0:	1141                	addi	sp,sp,-16
    800063a2:	e422                	sd	s0,8(sp)
    800063a4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063a6:	100007b7          	lui	a5,0x10000
    800063aa:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800063ac:	0007c783          	lbu	a5,0(a5)
    800063b0:	8b85                	andi	a5,a5,1
    800063b2:	cb81                	beqz	a5,800063c2 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800063b4:	100007b7          	lui	a5,0x10000
    800063b8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063bc:	6422                	ld	s0,8(sp)
    800063be:	0141                	addi	sp,sp,16
    800063c0:	8082                	ret
    return -1;
    800063c2:	557d                	li	a0,-1
    800063c4:	bfe5                	j	800063bc <uartgetc+0x1c>

00000000800063c6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063d0:	54fd                	li	s1,-1
    800063d2:	a029                	j	800063dc <uartintr+0x16>
      break;
    consoleintr(c);
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	8ce080e7          	jalr	-1842(ra) # 80005ca2 <consoleintr>
    int c = uartgetc();
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	fc4080e7          	jalr	-60(ra) # 800063a0 <uartgetc>
    if(c == -1)
    800063e4:	fe9518e3          	bne	a0,s1,800063d4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063e8:	0001e497          	auipc	s1,0x1e
    800063ec:	e2048493          	addi	s1,s1,-480 # 80024208 <uart_tx_lock>
    800063f0:	8526                	mv	a0,s1
    800063f2:	00000097          	auipc	ra,0x0
    800063f6:	0b4080e7          	jalr	180(ra) # 800064a6 <acquire>
  uartstart();
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	e60080e7          	jalr	-416(ra) # 8000625a <uartstart>
  release(&uart_tx_lock);
    80006402:	8526                	mv	a0,s1
    80006404:	00000097          	auipc	ra,0x0
    80006408:	156080e7          	jalr	342(ra) # 8000655a <release>
}
    8000640c:	60e2                	ld	ra,24(sp)
    8000640e:	6442                	ld	s0,16(sp)
    80006410:	64a2                	ld	s1,8(sp)
    80006412:	6105                	addi	sp,sp,32
    80006414:	8082                	ret

0000000080006416 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006416:	1141                	addi	sp,sp,-16
    80006418:	e422                	sd	s0,8(sp)
    8000641a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000641c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000641e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006422:	00053823          	sd	zero,16(a0)
}
    80006426:	6422                	ld	s0,8(sp)
    80006428:	0141                	addi	sp,sp,16
    8000642a:	8082                	ret

000000008000642c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000642c:	411c                	lw	a5,0(a0)
    8000642e:	e399                	bnez	a5,80006434 <holding+0x8>
    80006430:	4501                	li	a0,0
  return r;
}
    80006432:	8082                	ret
{
    80006434:	1101                	addi	sp,sp,-32
    80006436:	ec06                	sd	ra,24(sp)
    80006438:	e822                	sd	s0,16(sp)
    8000643a:	e426                	sd	s1,8(sp)
    8000643c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000643e:	6904                	ld	s1,16(a0)
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	a20080e7          	jalr	-1504(ra) # 80000e60 <mycpu>
    80006448:	40a48533          	sub	a0,s1,a0
    8000644c:	00153513          	seqz	a0,a0
}
    80006450:	60e2                	ld	ra,24(sp)
    80006452:	6442                	ld	s0,16(sp)
    80006454:	64a2                	ld	s1,8(sp)
    80006456:	6105                	addi	sp,sp,32
    80006458:	8082                	ret

000000008000645a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000645a:	1101                	addi	sp,sp,-32
    8000645c:	ec06                	sd	ra,24(sp)
    8000645e:	e822                	sd	s0,16(sp)
    80006460:	e426                	sd	s1,8(sp)
    80006462:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006464:	100024f3          	csrr	s1,sstatus
    80006468:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000646c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000646e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006472:	ffffb097          	auipc	ra,0xffffb
    80006476:	9ee080e7          	jalr	-1554(ra) # 80000e60 <mycpu>
    8000647a:	5d3c                	lw	a5,120(a0)
    8000647c:	cf89                	beqz	a5,80006496 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000647e:	ffffb097          	auipc	ra,0xffffb
    80006482:	9e2080e7          	jalr	-1566(ra) # 80000e60 <mycpu>
    80006486:	5d3c                	lw	a5,120(a0)
    80006488:	2785                	addiw	a5,a5,1
    8000648a:	dd3c                	sw	a5,120(a0)
}
    8000648c:	60e2                	ld	ra,24(sp)
    8000648e:	6442                	ld	s0,16(sp)
    80006490:	64a2                	ld	s1,8(sp)
    80006492:	6105                	addi	sp,sp,32
    80006494:	8082                	ret
    mycpu()->intena = old;
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	9ca080e7          	jalr	-1590(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000649e:	8085                	srli	s1,s1,0x1
    800064a0:	8885                	andi	s1,s1,1
    800064a2:	dd64                	sw	s1,124(a0)
    800064a4:	bfe9                	j	8000647e <push_off+0x24>

00000000800064a6 <acquire>:
{
    800064a6:	1101                	addi	sp,sp,-32
    800064a8:	ec06                	sd	ra,24(sp)
    800064aa:	e822                	sd	s0,16(sp)
    800064ac:	e426                	sd	s1,8(sp)
    800064ae:	1000                	addi	s0,sp,32
    800064b0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	fa8080e7          	jalr	-88(ra) # 8000645a <push_off>
  if(holding(lk))
    800064ba:	8526                	mv	a0,s1
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	f70080e7          	jalr	-144(ra) # 8000642c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c4:	4705                	li	a4,1
  if(holding(lk))
    800064c6:	e115                	bnez	a0,800064ea <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c8:	87ba                	mv	a5,a4
    800064ca:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064ce:	2781                	sext.w	a5,a5
    800064d0:	ffe5                	bnez	a5,800064c8 <acquire+0x22>
  __sync_synchronize();
    800064d2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800064d6:	ffffb097          	auipc	ra,0xffffb
    800064da:	98a080e7          	jalr	-1654(ra) # 80000e60 <mycpu>
    800064de:	e888                	sd	a0,16(s1)
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret
    panic("acquire");
    800064ea:	00002517          	auipc	a0,0x2
    800064ee:	1e650513          	addi	a0,a0,486 # 800086d0 <etext+0x6d0>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	a3a080e7          	jalr	-1478(ra) # 80005f2c <panic>

00000000800064fa <pop_off>:

void
pop_off(void)
{
    800064fa:	1141                	addi	sp,sp,-16
    800064fc:	e406                	sd	ra,8(sp)
    800064fe:	e022                	sd	s0,0(sp)
    80006500:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006502:	ffffb097          	auipc	ra,0xffffb
    80006506:	95e080e7          	jalr	-1698(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000650a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000650e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006510:	e78d                	bnez	a5,8000653a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006512:	5d3c                	lw	a5,120(a0)
    80006514:	02f05b63          	blez	a5,8000654a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006518:	37fd                	addiw	a5,a5,-1
    8000651a:	0007871b          	sext.w	a4,a5
    8000651e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006520:	eb09                	bnez	a4,80006532 <pop_off+0x38>
    80006522:	5d7c                	lw	a5,124(a0)
    80006524:	c799                	beqz	a5,80006532 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006526:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000652a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000652e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006532:	60a2                	ld	ra,8(sp)
    80006534:	6402                	ld	s0,0(sp)
    80006536:	0141                	addi	sp,sp,16
    80006538:	8082                	ret
    panic("pop_off - interruptible");
    8000653a:	00002517          	auipc	a0,0x2
    8000653e:	19e50513          	addi	a0,a0,414 # 800086d8 <etext+0x6d8>
    80006542:	00000097          	auipc	ra,0x0
    80006546:	9ea080e7          	jalr	-1558(ra) # 80005f2c <panic>
    panic("pop_off");
    8000654a:	00002517          	auipc	a0,0x2
    8000654e:	1a650513          	addi	a0,a0,422 # 800086f0 <etext+0x6f0>
    80006552:	00000097          	auipc	ra,0x0
    80006556:	9da080e7          	jalr	-1574(ra) # 80005f2c <panic>

000000008000655a <release>:
{
    8000655a:	1101                	addi	sp,sp,-32
    8000655c:	ec06                	sd	ra,24(sp)
    8000655e:	e822                	sd	s0,16(sp)
    80006560:	e426                	sd	s1,8(sp)
    80006562:	1000                	addi	s0,sp,32
    80006564:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006566:	00000097          	auipc	ra,0x0
    8000656a:	ec6080e7          	jalr	-314(ra) # 8000642c <holding>
    8000656e:	c115                	beqz	a0,80006592 <release+0x38>
  lk->cpu = 0;
    80006570:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006574:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006578:	0310000f          	fence	rw,w
    8000657c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006580:	00000097          	auipc	ra,0x0
    80006584:	f7a080e7          	jalr	-134(ra) # 800064fa <pop_off>
}
    80006588:	60e2                	ld	ra,24(sp)
    8000658a:	6442                	ld	s0,16(sp)
    8000658c:	64a2                	ld	s1,8(sp)
    8000658e:	6105                	addi	sp,sp,32
    80006590:	8082                	ret
    panic("release");
    80006592:	00002517          	auipc	a0,0x2
    80006596:	16650513          	addi	a0,a0,358 # 800086f8 <etext+0x6f8>
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	992080e7          	jalr	-1646(ra) # 80005f2c <panic>
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
