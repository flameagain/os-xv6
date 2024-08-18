
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	1c013103          	ld	sp,448(sp) # 8000b1c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2c9050ef          	jal	80005ade <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <pagecnt>:
  char *ref_page;
  char *end_;
} kmem;

int
pagecnt(void *pa_start, void *pa_end){
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
  char *p;
  int cnt = 0;
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000022:	6785                	lui	a5,0x1
    80000024:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000028:	953a                	add	a0,a0,a4
    8000002a:	777d                	lui	a4,0xfffff
    8000002c:	00e576b3          	and	a3,a0,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000030:	97b6                	add	a5,a5,a3
    80000032:	02f5ea63          	bltu	a1,a5,80000066 <pagecnt+0x4a>
    80000036:	6785                	lui	a5,0x1
    80000038:	97b6                	add	a5,a5,a3
    8000003a:	6705                	lui	a4,0x1
    8000003c:	97ba                	add	a5,a5,a4
    8000003e:	fef5ffe3          	bgeu	a1,a5,8000003c <pagecnt+0x20>
    80000042:	6785                	lui	a5,0x1
    80000044:	0785                	addi	a5,a5,1 # 1001 <_entry-0x7fffefff>
    80000046:	97b6                	add	a5,a5,a3
    80000048:	00158713          	addi	a4,a1,1
    8000004c:	4505                	li	a0,1
    8000004e:	00f76863          	bltu	a4,a5,8000005e <pagecnt+0x42>
    80000052:	77fd                	lui	a5,0xfffff
    80000054:	97ae                	add	a5,a5,a1
    80000056:	8f95                	sub	a5,a5,a3
    80000058:	83b1                	srli	a5,a5,0xc
    8000005a:	0017851b          	addiw	a0,a5,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    8000005e:	2501                	sext.w	a0,a0
    cnt++;
  return cnt;
}
    80000060:	6422                	ld	s0,8(sp)
    80000062:	0141                	addi	sp,sp,16
    80000064:	8082                	ret
  int cnt = 0;
    80000066:	4501                	li	a0,0
    80000068:	bfe5                	j	80000060 <pagecnt+0x44>

000000008000006a <page_index>:
  freerange(kmem.end_, (void*)PHYSTOP);
}

int page_index(uint64 pa)
{
  pa = PGROUNDDOWN(pa);
    8000006a:	77fd                	lui	a5,0xfffff
    8000006c:	8d7d                	and	a0,a0,a5
  int res = (pa - (uint64)kmem.end_)/PGSIZE;
    8000006e:	0000c797          	auipc	a5,0xc
    80000072:	ff27b783          	ld	a5,-14(a5) # 8000c060 <kmem+0x30>
    80000076:	8d1d                	sub	a0,a0,a5
    80000078:	8131                	srli	a0,a0,0xc
    8000007a:	2501                	sext.w	a0,a0
  if(res < 0 || res >= kmem.page_cnt){
    8000007c:	00054963          	bltz	a0,8000008e <page_index+0x24>
    80000080:	0000c797          	auipc	a5,0xc
    80000084:	fd07a783          	lw	a5,-48(a5) # 8000c050 <kmem+0x20>
    80000088:	00f55363          	bge	a0,a5,8000008e <page_index+0x24>
    panic("page_index illegal\n");
  }
  return res;
}
    8000008c:	8082                	ret
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
    panic("page_index illegal\n");
    80000096:	00008517          	auipc	a0,0x8
    8000009a:	f6a50513          	addi	a0,a0,-150 # 80008000 <etext>
    8000009e:	00006097          	auipc	ra,0x6
    800000a2:	f0e080e7          	jalr	-242(ra) # 80005fac <panic>

00000000800000a6 <incr>:

void incr(void *pa)
{
    800000a6:	1101                	addi	sp,sp,-32
    800000a8:	ec06                	sd	ra,24(sp)
    800000aa:	e822                	sd	s0,16(sp)
    800000ac:	e426                	sd	s1,8(sp)
    800000ae:	e04a                	sd	s2,0(sp)
    800000b0:	1000                	addi	s0,sp,32
  int index = page_index((uint64)pa);
    800000b2:	00000097          	auipc	ra,0x0
    800000b6:	fb8080e7          	jalr	-72(ra) # 8000006a <page_index>
    800000ba:	892a                	mv	s2,a0
  acquire(&kmem.lock);
    800000bc:	0000c497          	auipc	s1,0xc
    800000c0:	f7448493          	addi	s1,s1,-140 # 8000c030 <kmem>
    800000c4:	8526                	mv	a0,s1
    800000c6:	00006097          	auipc	ra,0x6
    800000ca:	460080e7          	jalr	1120(ra) # 80006526 <acquire>
  kmem.ref_page[index]++;
    800000ce:	749c                	ld	a5,40(s1)
    800000d0:	01278533          	add	a0,a5,s2
    800000d4:	00054783          	lbu	a5,0(a0)
    800000d8:	2785                	addiw	a5,a5,1
    800000da:	00f50023          	sb	a5,0(a0)
  release(&kmem.lock);
    800000de:	8526                	mv	a0,s1
    800000e0:	00006097          	auipc	ra,0x6
    800000e4:	4fa080e7          	jalr	1274(ra) # 800065da <release>
}
    800000e8:	60e2                	ld	ra,24(sp)
    800000ea:	6442                	ld	s0,16(sp)
    800000ec:	64a2                	ld	s1,8(sp)
    800000ee:	6902                	ld	s2,0(sp)
    800000f0:	6105                	addi	sp,sp,32
    800000f2:	8082                	ret

00000000800000f4 <desc>:

void desc(void *pa)
{
    800000f4:	1101                	addi	sp,sp,-32
    800000f6:	ec06                	sd	ra,24(sp)
    800000f8:	e822                	sd	s0,16(sp)
    800000fa:	e426                	sd	s1,8(sp)
    800000fc:	e04a                	sd	s2,0(sp)
    800000fe:	1000                	addi	s0,sp,32
  int index = page_index((uint64)pa);
    80000100:	00000097          	auipc	ra,0x0
    80000104:	f6a080e7          	jalr	-150(ra) # 8000006a <page_index>
    80000108:	892a                	mv	s2,a0
  acquire(&kmem.lock);
    8000010a:	0000c497          	auipc	s1,0xc
    8000010e:	f2648493          	addi	s1,s1,-218 # 8000c030 <kmem>
    80000112:	8526                	mv	a0,s1
    80000114:	00006097          	auipc	ra,0x6
    80000118:	412080e7          	jalr	1042(ra) # 80006526 <acquire>
  kmem.ref_page[index]--;
    8000011c:	749c                	ld	a5,40(s1)
    8000011e:	01278533          	add	a0,a5,s2
    80000122:	00054783          	lbu	a5,0(a0)
    80000126:	37fd                	addiw	a5,a5,-1
    80000128:	00f50023          	sb	a5,0(a0)
  release(&kmem.lock);
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	4ac080e7          	jalr	1196(ra) # 800065da <release>
}
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6902                	ld	s2,0(sp)
    8000013e:	6105                	addi	sp,sp,32
    80000140:	8082                	ret

0000000080000142 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000142:	1101                	addi	sp,sp,-32
    80000144:	ec06                	sd	ra,24(sp)
    80000146:	e822                	sd	s0,16(sp)
    80000148:	e426                	sd	s1,8(sp)
    8000014a:	e04a                	sd	s2,0(sp)
    8000014c:	1000                	addi	s0,sp,32
    8000014e:	84aa                	mv	s1,a0
  int index = page_index((uint64)pa);
    80000150:	892a                	mv	s2,a0
    80000152:	00000097          	auipc	ra,0x0
    80000156:	f18080e7          	jalr	-232(ra) # 8000006a <page_index>
  if(kmem.ref_page[index] > 1){
    8000015a:	0000c797          	auipc	a5,0xc
    8000015e:	efe7b783          	ld	a5,-258(a5) # 8000c058 <kmem+0x28>
    80000162:	97aa                	add	a5,a5,a0
    80000164:	0007c783          	lbu	a5,0(a5)
    80000168:	4705                	li	a4,1
    8000016a:	06f76263          	bltu	a4,a5,800001ce <kfree+0x8c>
    desc(pa);
    return;
  }
  if(kmem.ref_page[index] == 1){
    8000016e:	4705                	li	a4,1
    80000170:	06e78563          	beq	a5,a4,800001da <kfree+0x98>
    desc(pa);
  }
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000174:	03449793          	slli	a5,s1,0x34
    80000178:	e7bd                	bnez	a5,800001e6 <kfree+0xa4>
    8000017a:	00029797          	auipc	a5,0x29
    8000017e:	0c678793          	addi	a5,a5,198 # 80029240 <end>
    80000182:	06f4e263          	bltu	s1,a5,800001e6 <kfree+0xa4>
    80000186:	47c5                	li	a5,17
    80000188:	07ee                	slli	a5,a5,0x1b
    8000018a:	04f97e63          	bgeu	s2,a5,800001e6 <kfree+0xa4>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000018e:	6605                	lui	a2,0x1
    80000190:	4585                	li	a1,1
    80000192:	8526                	mv	a0,s1
    80000194:	00000097          	auipc	ra,0x0
    80000198:	1de080e7          	jalr	478(ra) # 80000372 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000019c:	0000c917          	auipc	s2,0xc
    800001a0:	e9490913          	addi	s2,s2,-364 # 8000c030 <kmem>
    800001a4:	854a                	mv	a0,s2
    800001a6:	00006097          	auipc	ra,0x6
    800001aa:	380080e7          	jalr	896(ra) # 80006526 <acquire>
  r->next = kmem.freelist;
    800001ae:	01893783          	ld	a5,24(s2)
    800001b2:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800001b4:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800001b8:	854a                	mv	a0,s2
    800001ba:	00006097          	auipc	ra,0x6
    800001be:	420080e7          	jalr	1056(ra) # 800065da <release>
}
    800001c2:	60e2                	ld	ra,24(sp)
    800001c4:	6442                	ld	s0,16(sp)
    800001c6:	64a2                	ld	s1,8(sp)
    800001c8:	6902                	ld	s2,0(sp)
    800001ca:	6105                	addi	sp,sp,32
    800001cc:	8082                	ret
    desc(pa);
    800001ce:	8526                	mv	a0,s1
    800001d0:	00000097          	auipc	ra,0x0
    800001d4:	f24080e7          	jalr	-220(ra) # 800000f4 <desc>
    return;
    800001d8:	b7ed                	j	800001c2 <kfree+0x80>
    desc(pa);
    800001da:	8526                	mv	a0,s1
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	f18080e7          	jalr	-232(ra) # 800000f4 <desc>
    800001e4:	bf41                	j	80000174 <kfree+0x32>
    panic("kfree");
    800001e6:	00008517          	auipc	a0,0x8
    800001ea:	e3250513          	addi	a0,a0,-462 # 80008018 <etext+0x18>
    800001ee:	00006097          	auipc	ra,0x6
    800001f2:	dbe080e7          	jalr	-578(ra) # 80005fac <panic>

00000000800001f6 <freerange>:
{
    800001f6:	7179                	addi	sp,sp,-48
    800001f8:	f406                	sd	ra,40(sp)
    800001fa:	f022                	sd	s0,32(sp)
    800001fc:	ec26                	sd	s1,24(sp)
    800001fe:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000200:	6785                	lui	a5,0x1
    80000202:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000206:	00e504b3          	add	s1,a0,a4
    8000020a:	777d                	lui	a4,0xfffff
    8000020c:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000020e:	94be                	add	s1,s1,a5
    80000210:	0295e463          	bltu	a1,s1,80000238 <freerange+0x42>
    80000214:	e84a                	sd	s2,16(sp)
    80000216:	e44e                	sd	s3,8(sp)
    80000218:	e052                	sd	s4,0(sp)
    8000021a:	892e                	mv	s2,a1
    kfree(p);
    8000021c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000021e:	6985                	lui	s3,0x1
    kfree(p);
    80000220:	01448533          	add	a0,s1,s4
    80000224:	00000097          	auipc	ra,0x0
    80000228:	f1e080e7          	jalr	-226(ra) # 80000142 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000022c:	94ce                	add	s1,s1,s3
    8000022e:	fe9979e3          	bgeu	s2,s1,80000220 <freerange+0x2a>
    80000232:	6942                	ld	s2,16(sp)
    80000234:	69a2                	ld	s3,8(sp)
    80000236:	6a02                	ld	s4,0(sp)
}
    80000238:	70a2                	ld	ra,40(sp)
    8000023a:	7402                	ld	s0,32(sp)
    8000023c:	64e2                	ld	s1,24(sp)
    8000023e:	6145                	addi	sp,sp,48
    80000240:	8082                	ret

0000000080000242 <kinit>:
{
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e406                	sd	ra,8(sp)
    80000246:	e022                	sd	s0,0(sp)
    80000248:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000024a:	00008597          	auipc	a1,0x8
    8000024e:	dd658593          	addi	a1,a1,-554 # 80008020 <etext+0x20>
    80000252:	0000c517          	auipc	a0,0xc
    80000256:	dde50513          	addi	a0,a0,-546 # 8000c030 <kmem>
    8000025a:	00006097          	auipc	ra,0x6
    8000025e:	23c080e7          	jalr	572(ra) # 80006496 <initlock>
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000262:	0002a617          	auipc	a2,0x2a
    80000266:	fdd60613          	addi	a2,a2,-35 # 8002a23f <end+0xfff>
    8000026a:	77fd                	lui	a5,0xfffff
    8000026c:	8e7d                	and	a2,a2,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000026e:	6705                	lui	a4,0x1
    80000270:	9732                	add	a4,a4,a2
    80000272:	47c5                	li	a5,17
    80000274:	07ee                	slli	a5,a5,0x1b
    80000276:	06e7ec63          	bltu	a5,a4,800002ee <kinit+0xac>
    8000027a:	6789                	lui	a5,0x2
    8000027c:	97b2                	add	a5,a5,a2
    8000027e:	6685                	lui	a3,0x1
    80000280:	44001737          	lui	a4,0x44001
    80000284:	0706                	slli	a4,a4,0x1
    80000286:	97b6                	add	a5,a5,a3
    80000288:	fee79fe3          	bne	a5,a4,80000286 <kinit+0x44>
    8000028c:	000887b7          	lui	a5,0x88
    80000290:	17fd                	addi	a5,a5,-1 # 87fff <_entry-0x7ff78001>
    80000292:	07b2                	slli	a5,a5,0xc
    80000294:	8f91                	sub	a5,a5,a2
    80000296:	83b1                	srli	a5,a5,0xc
    80000298:	2785                	addiw	a5,a5,1
    8000029a:	0007871b          	sext.w	a4,a5
  kmem.page_cnt = pagecnt(end, (void *)PHYSTOP);
    8000029e:	0000c697          	auipc	a3,0xc
    800002a2:	d9268693          	addi	a3,a3,-622 # 8000c030 <kmem>
    800002a6:	d29c                	sw	a5,32(a3)
  kmem.ref_page = end;
    800002a8:	00029797          	auipc	a5,0x29
    800002ac:	f9878793          	addi	a5,a5,-104 # 80029240 <end>
    800002b0:	f69c                	sd	a5,40(a3)
  for(int i = 0; i < kmem.page_cnt; i++){
    800002b2:	00e05d63          	blez	a4,800002cc <kinit+0x8a>
    800002b6:	4781                	li	a5,0
    kmem.ref_page[i] = 0;
    800002b8:	7698                	ld	a4,40(a3)
    800002ba:	973e                	add	a4,a4,a5
    800002bc:	00070023          	sb	zero,0(a4) # 44001000 <_entry-0x3bfff000>
  for(int i = 0; i < kmem.page_cnt; i++){
    800002c0:	5298                	lw	a4,32(a3)
    800002c2:	0785                	addi	a5,a5,1
    800002c4:	0007861b          	sext.w	a2,a5
    800002c8:	fee648e3          	blt	a2,a4,800002b8 <kinit+0x76>
  kmem.end_ = kmem.ref_page + kmem.page_cnt;
    800002cc:	0000c797          	auipc	a5,0xc
    800002d0:	d6478793          	addi	a5,a5,-668 # 8000c030 <kmem>
    800002d4:	7788                	ld	a0,40(a5)
    800002d6:	953a                	add	a0,a0,a4
    800002d8:	fb88                	sd	a0,48(a5)
  freerange(kmem.end_, (void*)PHYSTOP);
    800002da:	45c5                	li	a1,17
    800002dc:	05ee                	slli	a1,a1,0x1b
    800002de:	00000097          	auipc	ra,0x0
    800002e2:	f18080e7          	jalr	-232(ra) # 800001f6 <freerange>
}
    800002e6:	60a2                	ld	ra,8(sp)
    800002e8:	6402                	ld	s0,0(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret
  kmem.page_cnt = pagecnt(end, (void *)PHYSTOP);
    800002ee:	0000c797          	auipc	a5,0xc
    800002f2:	d4278793          	addi	a5,a5,-702 # 8000c030 <kmem>
    800002f6:	0207a023          	sw	zero,32(a5)
  kmem.ref_page = end;
    800002fa:	00029717          	auipc	a4,0x29
    800002fe:	f4670713          	addi	a4,a4,-186 # 80029240 <end>
    80000302:	f798                	sd	a4,40(a5)
  int cnt = 0;
    80000304:	4701                	li	a4,0
    80000306:	b7d9                	j	800002cc <kinit+0x8a>

0000000080000308 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000308:	1101                	addi	sp,sp,-32
    8000030a:	ec06                	sd	ra,24(sp)
    8000030c:	e822                	sd	s0,16(sp)
    8000030e:	e426                	sd	s1,8(sp)
    80000310:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000312:	0000c497          	auipc	s1,0xc
    80000316:	d1e48493          	addi	s1,s1,-738 # 8000c030 <kmem>
    8000031a:	8526                	mv	a0,s1
    8000031c:	00006097          	auipc	ra,0x6
    80000320:	20a080e7          	jalr	522(ra) # 80006526 <acquire>
  r = kmem.freelist;
    80000324:	6c84                	ld	s1,24(s1)
  if(r)
    80000326:	cc8d                	beqz	s1,80000360 <kalloc+0x58>
    kmem.freelist = r->next;
    80000328:	609c                	ld	a5,0(s1)
    8000032a:	0000c517          	auipc	a0,0xc
    8000032e:	d0650513          	addi	a0,a0,-762 # 8000c030 <kmem>
    80000332:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000334:	00006097          	auipc	ra,0x6
    80000338:	2a6080e7          	jalr	678(ra) # 800065da <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000033c:	6605                	lui	a2,0x1
    8000033e:	4595                	li	a1,5
    80000340:	8526                	mv	a0,s1
    80000342:	00000097          	auipc	ra,0x0
    80000346:	030080e7          	jalr	48(ra) # 80000372 <memset>
    incr(r);
    8000034a:	8526                	mv	a0,s1
    8000034c:	00000097          	auipc	ra,0x0
    80000350:	d5a080e7          	jalr	-678(ra) # 800000a6 <incr>
  }
    
  return (void*)r;
}
    80000354:	8526                	mv	a0,s1
    80000356:	60e2                	ld	ra,24(sp)
    80000358:	6442                	ld	s0,16(sp)
    8000035a:	64a2                	ld	s1,8(sp)
    8000035c:	6105                	addi	sp,sp,32
    8000035e:	8082                	ret
  release(&kmem.lock);
    80000360:	0000c517          	auipc	a0,0xc
    80000364:	cd050513          	addi	a0,a0,-816 # 8000c030 <kmem>
    80000368:	00006097          	auipc	ra,0x6
    8000036c:	272080e7          	jalr	626(ra) # 800065da <release>
  if(r){
    80000370:	b7d5                	j	80000354 <kalloc+0x4c>

0000000080000372 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e422                	sd	s0,8(sp)
    80000376:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000378:	ca19                	beqz	a2,8000038e <memset+0x1c>
    8000037a:	87aa                	mv	a5,a0
    8000037c:	1602                	slli	a2,a2,0x20
    8000037e:	9201                	srli	a2,a2,0x20
    80000380:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000384:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000388:	0785                	addi	a5,a5,1
    8000038a:	fee79de3          	bne	a5,a4,80000384 <memset+0x12>
  }
  return dst;
}
    8000038e:	6422                	ld	s0,8(sp)
    80000390:	0141                	addi	sp,sp,16
    80000392:	8082                	ret

0000000080000394 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000394:	1141                	addi	sp,sp,-16
    80000396:	e422                	sd	s0,8(sp)
    80000398:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000039a:	ca05                	beqz	a2,800003ca <memcmp+0x36>
    8000039c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800003a0:	1682                	slli	a3,a3,0x20
    800003a2:	9281                	srli	a3,a3,0x20
    800003a4:	0685                	addi	a3,a3,1
    800003a6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800003a8:	00054783          	lbu	a5,0(a0)
    800003ac:	0005c703          	lbu	a4,0(a1)
    800003b0:	00e79863          	bne	a5,a4,800003c0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800003b4:	0505                	addi	a0,a0,1
    800003b6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800003b8:	fed518e3          	bne	a0,a3,800003a8 <memcmp+0x14>
  }

  return 0;
    800003bc:	4501                	li	a0,0
    800003be:	a019                	j	800003c4 <memcmp+0x30>
      return *s1 - *s2;
    800003c0:	40e7853b          	subw	a0,a5,a4
}
    800003c4:	6422                	ld	s0,8(sp)
    800003c6:	0141                	addi	sp,sp,16
    800003c8:	8082                	ret
  return 0;
    800003ca:	4501                	li	a0,0
    800003cc:	bfe5                	j	800003c4 <memcmp+0x30>

00000000800003ce <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800003ce:	1141                	addi	sp,sp,-16
    800003d0:	e422                	sd	s0,8(sp)
    800003d2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800003d4:	c205                	beqz	a2,800003f4 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800003d6:	02a5e263          	bltu	a1,a0,800003fa <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800003da:	1602                	slli	a2,a2,0x20
    800003dc:	9201                	srli	a2,a2,0x20
    800003de:	00c587b3          	add	a5,a1,a2
{
    800003e2:	872a                	mv	a4,a0
      *d++ = *s++;
    800003e4:	0585                	addi	a1,a1,1
    800003e6:	0705                	addi	a4,a4,1
    800003e8:	fff5c683          	lbu	a3,-1(a1)
    800003ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800003f0:	feb79ae3          	bne	a5,a1,800003e4 <memmove+0x16>

  return dst;
}
    800003f4:	6422                	ld	s0,8(sp)
    800003f6:	0141                	addi	sp,sp,16
    800003f8:	8082                	ret
  if(s < d && s + n > d){
    800003fa:	02061693          	slli	a3,a2,0x20
    800003fe:	9281                	srli	a3,a3,0x20
    80000400:	00d58733          	add	a4,a1,a3
    80000404:	fce57be3          	bgeu	a0,a4,800003da <memmove+0xc>
    d += n;
    80000408:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000040a:	fff6079b          	addiw	a5,a2,-1
    8000040e:	1782                	slli	a5,a5,0x20
    80000410:	9381                	srli	a5,a5,0x20
    80000412:	fff7c793          	not	a5,a5
    80000416:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000418:	177d                	addi	a4,a4,-1
    8000041a:	16fd                	addi	a3,a3,-1
    8000041c:	00074603          	lbu	a2,0(a4)
    80000420:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000424:	fef71ae3          	bne	a4,a5,80000418 <memmove+0x4a>
    80000428:	b7f1                	j	800003f4 <memmove+0x26>

000000008000042a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000042a:	1141                	addi	sp,sp,-16
    8000042c:	e406                	sd	ra,8(sp)
    8000042e:	e022                	sd	s0,0(sp)
    80000430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000432:	00000097          	auipc	ra,0x0
    80000436:	f9c080e7          	jalr	-100(ra) # 800003ce <memmove>
}
    8000043a:	60a2                	ld	ra,8(sp)
    8000043c:	6402                	ld	s0,0(sp)
    8000043e:	0141                	addi	sp,sp,16
    80000440:	8082                	ret

0000000080000442 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000442:	1141                	addi	sp,sp,-16
    80000444:	e422                	sd	s0,8(sp)
    80000446:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000448:	ce11                	beqz	a2,80000464 <strncmp+0x22>
    8000044a:	00054783          	lbu	a5,0(a0)
    8000044e:	cf89                	beqz	a5,80000468 <strncmp+0x26>
    80000450:	0005c703          	lbu	a4,0(a1)
    80000454:	00f71a63          	bne	a4,a5,80000468 <strncmp+0x26>
    n--, p++, q++;
    80000458:	367d                	addiw	a2,a2,-1
    8000045a:	0505                	addi	a0,a0,1
    8000045c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000045e:	f675                	bnez	a2,8000044a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000460:	4501                	li	a0,0
    80000462:	a801                	j	80000472 <strncmp+0x30>
    80000464:	4501                	li	a0,0
    80000466:	a031                	j	80000472 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000468:	00054503          	lbu	a0,0(a0)
    8000046c:	0005c783          	lbu	a5,0(a1)
    80000470:	9d1d                	subw	a0,a0,a5
}
    80000472:	6422                	ld	s0,8(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000047e:	87aa                	mv	a5,a0
    80000480:	86b2                	mv	a3,a2
    80000482:	367d                	addiw	a2,a2,-1
    80000484:	02d05563          	blez	a3,800004ae <strncpy+0x36>
    80000488:	0785                	addi	a5,a5,1
    8000048a:	0005c703          	lbu	a4,0(a1)
    8000048e:	fee78fa3          	sb	a4,-1(a5)
    80000492:	0585                	addi	a1,a1,1
    80000494:	f775                	bnez	a4,80000480 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000496:	873e                	mv	a4,a5
    80000498:	9fb5                	addw	a5,a5,a3
    8000049a:	37fd                	addiw	a5,a5,-1
    8000049c:	00c05963          	blez	a2,800004ae <strncpy+0x36>
    *s++ = 0;
    800004a0:	0705                	addi	a4,a4,1
    800004a2:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800004a6:	40e786bb          	subw	a3,a5,a4
    800004aa:	fed04be3          	bgtz	a3,800004a0 <strncpy+0x28>
  return os;
}
    800004ae:	6422                	ld	s0,8(sp)
    800004b0:	0141                	addi	sp,sp,16
    800004b2:	8082                	ret

00000000800004b4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800004b4:	1141                	addi	sp,sp,-16
    800004b6:	e422                	sd	s0,8(sp)
    800004b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800004ba:	02c05363          	blez	a2,800004e0 <safestrcpy+0x2c>
    800004be:	fff6069b          	addiw	a3,a2,-1
    800004c2:	1682                	slli	a3,a3,0x20
    800004c4:	9281                	srli	a3,a3,0x20
    800004c6:	96ae                	add	a3,a3,a1
    800004c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800004ca:	00d58963          	beq	a1,a3,800004dc <safestrcpy+0x28>
    800004ce:	0585                	addi	a1,a1,1
    800004d0:	0785                	addi	a5,a5,1
    800004d2:	fff5c703          	lbu	a4,-1(a1)
    800004d6:	fee78fa3          	sb	a4,-1(a5)
    800004da:	fb65                	bnez	a4,800004ca <safestrcpy+0x16>
    ;
  *s = 0;
    800004dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800004e0:	6422                	ld	s0,8(sp)
    800004e2:	0141                	addi	sp,sp,16
    800004e4:	8082                	ret

00000000800004e6 <strlen>:

int
strlen(const char *s)
{
    800004e6:	1141                	addi	sp,sp,-16
    800004e8:	e422                	sd	s0,8(sp)
    800004ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800004ec:	00054783          	lbu	a5,0(a0)
    800004f0:	cf91                	beqz	a5,8000050c <strlen+0x26>
    800004f2:	0505                	addi	a0,a0,1
    800004f4:	87aa                	mv	a5,a0
    800004f6:	86be                	mv	a3,a5
    800004f8:	0785                	addi	a5,a5,1
    800004fa:	fff7c703          	lbu	a4,-1(a5)
    800004fe:	ff65                	bnez	a4,800004f6 <strlen+0x10>
    80000500:	40a6853b          	subw	a0,a3,a0
    80000504:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000506:	6422                	ld	s0,8(sp)
    80000508:	0141                	addi	sp,sp,16
    8000050a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000050c:	4501                	li	a0,0
    8000050e:	bfe5                	j	80000506 <strlen+0x20>

0000000080000510 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000518:	00001097          	auipc	ra,0x1
    8000051c:	c40080e7          	jalr	-960(ra) # 80001158 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000520:	0000c717          	auipc	a4,0xc
    80000524:	ae070713          	addi	a4,a4,-1312 # 8000c000 <started>
  if(cpuid() == 0){
    80000528:	c139                	beqz	a0,8000056e <main+0x5e>
    while(started == 0)
    8000052a:	431c                	lw	a5,0(a4)
    8000052c:	2781                	sext.w	a5,a5
    8000052e:	dff5                	beqz	a5,8000052a <main+0x1a>
      ;
    __sync_synchronize();
    80000530:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000534:	00001097          	auipc	ra,0x1
    80000538:	c24080e7          	jalr	-988(ra) # 80001158 <cpuid>
    8000053c:	85aa                	mv	a1,a0
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	b0a50513          	addi	a0,a0,-1270 # 80008048 <etext+0x48>
    80000546:	00006097          	auipc	ra,0x6
    8000054a:	ab0080e7          	jalr	-1360(ra) # 80005ff6 <printf>
    kvminithart();    // turn on paging
    8000054e:	00000097          	auipc	ra,0x0
    80000552:	0d8080e7          	jalr	216(ra) # 80000626 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000556:	00002097          	auipc	ra,0x2
    8000055a:	886080e7          	jalr	-1914(ra) # 80001ddc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000055e:	00005097          	auipc	ra,0x5
    80000562:	f36080e7          	jalr	-202(ra) # 80005494 <plicinithart>
  }

  scheduler();        
    80000566:	00001097          	auipc	ra,0x1
    8000056a:	132080e7          	jalr	306(ra) # 80001698 <scheduler>
    consoleinit();
    8000056e:	00006097          	auipc	ra,0x6
    80000572:	94e080e7          	jalr	-1714(ra) # 80005ebc <consoleinit>
    printfinit();
    80000576:	00006097          	auipc	ra,0x6
    8000057a:	c88080e7          	jalr	-888(ra) # 800061fe <printfinit>
    printf("\n");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	aaa50513          	addi	a0,a0,-1366 # 80008028 <etext+0x28>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	a70080e7          	jalr	-1424(ra) # 80005ff6 <printf>
    printf("xv6 kernel is booting\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	aa250513          	addi	a0,a0,-1374 # 80008030 <etext+0x30>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	a60080e7          	jalr	-1440(ra) # 80005ff6 <printf>
    printf("\n");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	a8a50513          	addi	a0,a0,-1398 # 80008028 <etext+0x28>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	a50080e7          	jalr	-1456(ra) # 80005ff6 <printf>
    kinit();         // physical page allocator
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	c94080e7          	jalr	-876(ra) # 80000242 <kinit>
    kvminit();       // create kernel page table
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	322080e7          	jalr	802(ra) # 800008d8 <kvminit>
    kvminithart();   // turn on paging
    800005be:	00000097          	auipc	ra,0x0
    800005c2:	068080e7          	jalr	104(ra) # 80000626 <kvminithart>
    procinit();      // process table
    800005c6:	00001097          	auipc	ra,0x1
    800005ca:	ad4080e7          	jalr	-1324(ra) # 8000109a <procinit>
    trapinit();      // trap vectors
    800005ce:	00001097          	auipc	ra,0x1
    800005d2:	7e6080e7          	jalr	2022(ra) # 80001db4 <trapinit>
    trapinithart();  // install kernel trap vector
    800005d6:	00002097          	auipc	ra,0x2
    800005da:	806080e7          	jalr	-2042(ra) # 80001ddc <trapinithart>
    plicinit();      // set up interrupt controller
    800005de:	00005097          	auipc	ra,0x5
    800005e2:	e9c080e7          	jalr	-356(ra) # 8000547a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800005e6:	00005097          	auipc	ra,0x5
    800005ea:	eae080e7          	jalr	-338(ra) # 80005494 <plicinithart>
    binit();         // buffer cache
    800005ee:	00002097          	auipc	ra,0x2
    800005f2:	fca080e7          	jalr	-54(ra) # 800025b8 <binit>
    iinit();         // inode table
    800005f6:	00002097          	auipc	ra,0x2
    800005fa:	656080e7          	jalr	1622(ra) # 80002c4c <iinit>
    fileinit();      // file table
    800005fe:	00003097          	auipc	ra,0x3
    80000602:	5fa080e7          	jalr	1530(ra) # 80003bf8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000606:	00005097          	auipc	ra,0x5
    8000060a:	fae080e7          	jalr	-82(ra) # 800055b4 <virtio_disk_init>
    userinit();      // first user process
    8000060e:	00001097          	auipc	ra,0x1
    80000612:	e4e080e7          	jalr	-434(ra) # 8000145c <userinit>
    __sync_synchronize();
    80000616:	0330000f          	fence	rw,rw
    started = 1;
    8000061a:	4785                	li	a5,1
    8000061c:	0000c717          	auipc	a4,0xc
    80000620:	9ef72223          	sw	a5,-1564(a4) # 8000c000 <started>
    80000624:	b789                	j	80000566 <main+0x56>

0000000080000626 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000626:	1141                	addi	sp,sp,-16
    80000628:	e422                	sd	s0,8(sp)
    8000062a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000062c:	0000c797          	auipc	a5,0xc
    80000630:	9dc7b783          	ld	a5,-1572(a5) # 8000c008 <kernel_pagetable>
    80000634:	83b1                	srli	a5,a5,0xc
    80000636:	577d                	li	a4,-1
    80000638:	177e                	slli	a4,a4,0x3f
    8000063a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000063c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000640:	12000073          	sfence.vma
  sfence_vma();
}
    80000644:	6422                	ld	s0,8(sp)
    80000646:	0141                	addi	sp,sp,16
    80000648:	8082                	ret

000000008000064a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000064a:	7139                	addi	sp,sp,-64
    8000064c:	fc06                	sd	ra,56(sp)
    8000064e:	f822                	sd	s0,48(sp)
    80000650:	f426                	sd	s1,40(sp)
    80000652:	f04a                	sd	s2,32(sp)
    80000654:	ec4e                	sd	s3,24(sp)
    80000656:	e852                	sd	s4,16(sp)
    80000658:	e456                	sd	s5,8(sp)
    8000065a:	e05a                	sd	s6,0(sp)
    8000065c:	0080                	addi	s0,sp,64
    8000065e:	84aa                	mv	s1,a0
    80000660:	89ae                	mv	s3,a1
    80000662:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000664:	57fd                	li	a5,-1
    80000666:	83e9                	srli	a5,a5,0x1a
    80000668:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000066a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000066c:	04b7f263          	bgeu	a5,a1,800006b0 <walk+0x66>
    panic("walk");
    80000670:	00008517          	auipc	a0,0x8
    80000674:	9f050513          	addi	a0,a0,-1552 # 80008060 <etext+0x60>
    80000678:	00006097          	auipc	ra,0x6
    8000067c:	934080e7          	jalr	-1740(ra) # 80005fac <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000680:	060a8663          	beqz	s5,800006ec <walk+0xa2>
    80000684:	00000097          	auipc	ra,0x0
    80000688:	c84080e7          	jalr	-892(ra) # 80000308 <kalloc>
    8000068c:	84aa                	mv	s1,a0
    8000068e:	c529                	beqz	a0,800006d8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000690:	6605                	lui	a2,0x1
    80000692:	4581                	li	a1,0
    80000694:	00000097          	auipc	ra,0x0
    80000698:	cde080e7          	jalr	-802(ra) # 80000372 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000069c:	00c4d793          	srli	a5,s1,0xc
    800006a0:	07aa                	slli	a5,a5,0xa
    800006a2:	0017e793          	ori	a5,a5,1
    800006a6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800006aa:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5db7>
    800006ac:	036a0063          	beq	s4,s6,800006cc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800006b0:	0149d933          	srl	s2,s3,s4
    800006b4:	1ff97913          	andi	s2,s2,511
    800006b8:	090e                	slli	s2,s2,0x3
    800006ba:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800006bc:	00093483          	ld	s1,0(s2)
    800006c0:	0014f793          	andi	a5,s1,1
    800006c4:	dfd5                	beqz	a5,80000680 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800006c6:	80a9                	srli	s1,s1,0xa
    800006c8:	04b2                	slli	s1,s1,0xc
    800006ca:	b7c5                	j	800006aa <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800006cc:	00c9d513          	srli	a0,s3,0xc
    800006d0:	1ff57513          	andi	a0,a0,511
    800006d4:	050e                	slli	a0,a0,0x3
    800006d6:	9526                	add	a0,a0,s1
}
    800006d8:	70e2                	ld	ra,56(sp)
    800006da:	7442                	ld	s0,48(sp)
    800006dc:	74a2                	ld	s1,40(sp)
    800006de:	7902                	ld	s2,32(sp)
    800006e0:	69e2                	ld	s3,24(sp)
    800006e2:	6a42                	ld	s4,16(sp)
    800006e4:	6aa2                	ld	s5,8(sp)
    800006e6:	6b02                	ld	s6,0(sp)
    800006e8:	6121                	addi	sp,sp,64
    800006ea:	8082                	ret
        return 0;
    800006ec:	4501                	li	a0,0
    800006ee:	b7ed                	j	800006d8 <walk+0x8e>

00000000800006f0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800006f0:	57fd                	li	a5,-1
    800006f2:	83e9                	srli	a5,a5,0x1a
    800006f4:	00b7f463          	bgeu	a5,a1,800006fc <walkaddr+0xc>
    return 0;
    800006f8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800006fa:	8082                	ret
{
    800006fc:	1141                	addi	sp,sp,-16
    800006fe:	e406                	sd	ra,8(sp)
    80000700:	e022                	sd	s0,0(sp)
    80000702:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000704:	4601                	li	a2,0
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	f44080e7          	jalr	-188(ra) # 8000064a <walk>
  if(pte == 0)
    8000070e:	c105                	beqz	a0,8000072e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000710:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000712:	0117f693          	andi	a3,a5,17
    80000716:	4745                	li	a4,17
    return 0;
    80000718:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000071a:	00e68663          	beq	a3,a4,80000726 <walkaddr+0x36>
}
    8000071e:	60a2                	ld	ra,8(sp)
    80000720:	6402                	ld	s0,0(sp)
    80000722:	0141                	addi	sp,sp,16
    80000724:	8082                	ret
  pa = PTE2PA(*pte);
    80000726:	83a9                	srli	a5,a5,0xa
    80000728:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000072c:	bfcd                	j	8000071e <walkaddr+0x2e>
    return 0;
    8000072e:	4501                	li	a0,0
    80000730:	b7fd                	j	8000071e <walkaddr+0x2e>

0000000080000732 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000732:	715d                	addi	sp,sp,-80
    80000734:	e486                	sd	ra,72(sp)
    80000736:	e0a2                	sd	s0,64(sp)
    80000738:	fc26                	sd	s1,56(sp)
    8000073a:	f84a                	sd	s2,48(sp)
    8000073c:	f44e                	sd	s3,40(sp)
    8000073e:	f052                	sd	s4,32(sp)
    80000740:	ec56                	sd	s5,24(sp)
    80000742:	e85a                	sd	s6,16(sp)
    80000744:	e45e                	sd	s7,8(sp)
    80000746:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000748:	c639                	beqz	a2,80000796 <mappages+0x64>
    8000074a:	8aaa                	mv	s5,a0
    8000074c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000074e:	777d                	lui	a4,0xfffff
    80000750:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000754:	fff58993          	addi	s3,a1,-1
    80000758:	99b2                	add	s3,s3,a2
    8000075a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000075e:	893e                	mv	s2,a5
    80000760:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000764:	6b85                	lui	s7,0x1
    80000766:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000076a:	4605                	li	a2,1
    8000076c:	85ca                	mv	a1,s2
    8000076e:	8556                	mv	a0,s5
    80000770:	00000097          	auipc	ra,0x0
    80000774:	eda080e7          	jalr	-294(ra) # 8000064a <walk>
    80000778:	cd1d                	beqz	a0,800007b6 <mappages+0x84>
    if(*pte & PTE_V)
    8000077a:	611c                	ld	a5,0(a0)
    8000077c:	8b85                	andi	a5,a5,1
    8000077e:	e785                	bnez	a5,800007a6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000780:	80b1                	srli	s1,s1,0xc
    80000782:	04aa                	slli	s1,s1,0xa
    80000784:	0164e4b3          	or	s1,s1,s6
    80000788:	0014e493          	ori	s1,s1,1
    8000078c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000078e:	05390063          	beq	s2,s3,800007ce <mappages+0x9c>
    a += PGSIZE;
    80000792:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000794:	bfc9                	j	80000766 <mappages+0x34>
    panic("mappages: size");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	8d250513          	addi	a0,a0,-1838 # 80008068 <etext+0x68>
    8000079e:	00006097          	auipc	ra,0x6
    800007a2:	80e080e7          	jalr	-2034(ra) # 80005fac <panic>
      panic("mappages: remap");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	8d250513          	addi	a0,a0,-1838 # 80008078 <etext+0x78>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	7fe080e7          	jalr	2046(ra) # 80005fac <panic>
      return -1;
    800007b6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800007b8:	60a6                	ld	ra,72(sp)
    800007ba:	6406                	ld	s0,64(sp)
    800007bc:	74e2                	ld	s1,56(sp)
    800007be:	7942                	ld	s2,48(sp)
    800007c0:	79a2                	ld	s3,40(sp)
    800007c2:	7a02                	ld	s4,32(sp)
    800007c4:	6ae2                	ld	s5,24(sp)
    800007c6:	6b42                	ld	s6,16(sp)
    800007c8:	6ba2                	ld	s7,8(sp)
    800007ca:	6161                	addi	sp,sp,80
    800007cc:	8082                	ret
  return 0;
    800007ce:	4501                	li	a0,0
    800007d0:	b7e5                	j	800007b8 <mappages+0x86>

00000000800007d2 <kvmmap>:
{
    800007d2:	1141                	addi	sp,sp,-16
    800007d4:	e406                	sd	ra,8(sp)
    800007d6:	e022                	sd	s0,0(sp)
    800007d8:	0800                	addi	s0,sp,16
    800007da:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800007dc:	86b2                	mv	a3,a2
    800007de:	863e                	mv	a2,a5
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	f52080e7          	jalr	-174(ra) # 80000732 <mappages>
    800007e8:	e509                	bnez	a0,800007f2 <kvmmap+0x20>
}
    800007ea:	60a2                	ld	ra,8(sp)
    800007ec:	6402                	ld	s0,0(sp)
    800007ee:	0141                	addi	sp,sp,16
    800007f0:	8082                	ret
    panic("kvmmap");
    800007f2:	00008517          	auipc	a0,0x8
    800007f6:	89650513          	addi	a0,a0,-1898 # 80008088 <etext+0x88>
    800007fa:	00005097          	auipc	ra,0x5
    800007fe:	7b2080e7          	jalr	1970(ra) # 80005fac <panic>

0000000080000802 <kvmmake>:
{
    80000802:	1101                	addi	sp,sp,-32
    80000804:	ec06                	sd	ra,24(sp)
    80000806:	e822                	sd	s0,16(sp)
    80000808:	e426                	sd	s1,8(sp)
    8000080a:	e04a                	sd	s2,0(sp)
    8000080c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	afa080e7          	jalr	-1286(ra) # 80000308 <kalloc>
    80000816:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	b56080e7          	jalr	-1194(ra) # 80000372 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000824:	4719                	li	a4,6
    80000826:	6685                	lui	a3,0x1
    80000828:	10000637          	lui	a2,0x10000
    8000082c:	100005b7          	lui	a1,0x10000
    80000830:	8526                	mv	a0,s1
    80000832:	00000097          	auipc	ra,0x0
    80000836:	fa0080e7          	jalr	-96(ra) # 800007d2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000083a:	4719                	li	a4,6
    8000083c:	6685                	lui	a3,0x1
    8000083e:	10001637          	lui	a2,0x10001
    80000842:	100015b7          	lui	a1,0x10001
    80000846:	8526                	mv	a0,s1
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	f8a080e7          	jalr	-118(ra) # 800007d2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000850:	4719                	li	a4,6
    80000852:	004006b7          	lui	a3,0x400
    80000856:	0c000637          	lui	a2,0xc000
    8000085a:	0c0005b7          	lui	a1,0xc000
    8000085e:	8526                	mv	a0,s1
    80000860:	00000097          	auipc	ra,0x0
    80000864:	f72080e7          	jalr	-142(ra) # 800007d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000868:	00007917          	auipc	s2,0x7
    8000086c:	79890913          	addi	s2,s2,1944 # 80008000 <etext>
    80000870:	4729                	li	a4,10
    80000872:	80007697          	auipc	a3,0x80007
    80000876:	78e68693          	addi	a3,a3,1934 # 8000 <_entry-0x7fff8000>
    8000087a:	4605                	li	a2,1
    8000087c:	067e                	slli	a2,a2,0x1f
    8000087e:	85b2                	mv	a1,a2
    80000880:	8526                	mv	a0,s1
    80000882:	00000097          	auipc	ra,0x0
    80000886:	f50080e7          	jalr	-176(ra) # 800007d2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000088a:	46c5                	li	a3,17
    8000088c:	06ee                	slli	a3,a3,0x1b
    8000088e:	4719                	li	a4,6
    80000890:	412686b3          	sub	a3,a3,s2
    80000894:	864a                	mv	a2,s2
    80000896:	85ca                	mv	a1,s2
    80000898:	8526                	mv	a0,s1
    8000089a:	00000097          	auipc	ra,0x0
    8000089e:	f38080e7          	jalr	-200(ra) # 800007d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800008a2:	4729                	li	a4,10
    800008a4:	6685                	lui	a3,0x1
    800008a6:	00006617          	auipc	a2,0x6
    800008aa:	75a60613          	addi	a2,a2,1882 # 80007000 <_trampoline>
    800008ae:	040005b7          	lui	a1,0x4000
    800008b2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800008b4:	05b2                	slli	a1,a1,0xc
    800008b6:	8526                	mv	a0,s1
    800008b8:	00000097          	auipc	ra,0x0
    800008bc:	f1a080e7          	jalr	-230(ra) # 800007d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800008c0:	8526                	mv	a0,s1
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	734080e7          	jalr	1844(ra) # 80000ff6 <proc_mapstacks>
}
    800008ca:	8526                	mv	a0,s1
    800008cc:	60e2                	ld	ra,24(sp)
    800008ce:	6442                	ld	s0,16(sp)
    800008d0:	64a2                	ld	s1,8(sp)
    800008d2:	6902                	ld	s2,0(sp)
    800008d4:	6105                	addi	sp,sp,32
    800008d6:	8082                	ret

00000000800008d8 <kvminit>:
{
    800008d8:	1141                	addi	sp,sp,-16
    800008da:	e406                	sd	ra,8(sp)
    800008dc:	e022                	sd	s0,0(sp)
    800008de:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	f22080e7          	jalr	-222(ra) # 80000802 <kvmmake>
    800008e8:	0000b797          	auipc	a5,0xb
    800008ec:	72a7b023          	sd	a0,1824(a5) # 8000c008 <kernel_pagetable>
}
    800008f0:	60a2                	ld	ra,8(sp)
    800008f2:	6402                	ld	s0,0(sp)
    800008f4:	0141                	addi	sp,sp,16
    800008f6:	8082                	ret

00000000800008f8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800008f8:	715d                	addi	sp,sp,-80
    800008fa:	e486                	sd	ra,72(sp)
    800008fc:	e0a2                	sd	s0,64(sp)
    800008fe:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000900:	03459793          	slli	a5,a1,0x34
    80000904:	e39d                	bnez	a5,8000092a <uvmunmap+0x32>
    80000906:	f84a                	sd	s2,48(sp)
    80000908:	f44e                	sd	s3,40(sp)
    8000090a:	f052                	sd	s4,32(sp)
    8000090c:	ec56                	sd	s5,24(sp)
    8000090e:	e85a                	sd	s6,16(sp)
    80000910:	e45e                	sd	s7,8(sp)
    80000912:	8a2a                	mv	s4,a0
    80000914:	892e                	mv	s2,a1
    80000916:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000918:	0632                	slli	a2,a2,0xc
    8000091a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000091e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000920:	6b05                	lui	s6,0x1
    80000922:	0935fb63          	bgeu	a1,s3,800009b8 <uvmunmap+0xc0>
    80000926:	fc26                	sd	s1,56(sp)
    80000928:	a8a9                	j	80000982 <uvmunmap+0x8a>
    8000092a:	fc26                	sd	s1,56(sp)
    8000092c:	f84a                	sd	s2,48(sp)
    8000092e:	f44e                	sd	s3,40(sp)
    80000930:	f052                	sd	s4,32(sp)
    80000932:	ec56                	sd	s5,24(sp)
    80000934:	e85a                	sd	s6,16(sp)
    80000936:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000938:	00007517          	auipc	a0,0x7
    8000093c:	75850513          	addi	a0,a0,1880 # 80008090 <etext+0x90>
    80000940:	00005097          	auipc	ra,0x5
    80000944:	66c080e7          	jalr	1644(ra) # 80005fac <panic>
      panic("uvmunmap: walk");
    80000948:	00007517          	auipc	a0,0x7
    8000094c:	76050513          	addi	a0,a0,1888 # 800080a8 <etext+0xa8>
    80000950:	00005097          	auipc	ra,0x5
    80000954:	65c080e7          	jalr	1628(ra) # 80005fac <panic>
      panic("uvmunmap: not mapped");
    80000958:	00007517          	auipc	a0,0x7
    8000095c:	76050513          	addi	a0,a0,1888 # 800080b8 <etext+0xb8>
    80000960:	00005097          	auipc	ra,0x5
    80000964:	64c080e7          	jalr	1612(ra) # 80005fac <panic>
      panic("uvmunmap: not a leaf");
    80000968:	00007517          	auipc	a0,0x7
    8000096c:	76850513          	addi	a0,a0,1896 # 800080d0 <etext+0xd0>
    80000970:	00005097          	auipc	ra,0x5
    80000974:	63c080e7          	jalr	1596(ra) # 80005fac <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000978:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000097c:	995a                	add	s2,s2,s6
    8000097e:	03397c63          	bgeu	s2,s3,800009b6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000982:	4601                	li	a2,0
    80000984:	85ca                	mv	a1,s2
    80000986:	8552                	mv	a0,s4
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	cc2080e7          	jalr	-830(ra) # 8000064a <walk>
    80000990:	84aa                	mv	s1,a0
    80000992:	d95d                	beqz	a0,80000948 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80000994:	6108                	ld	a0,0(a0)
    80000996:	00157793          	andi	a5,a0,1
    8000099a:	dfdd                	beqz	a5,80000958 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000099c:	3ff57793          	andi	a5,a0,1023
    800009a0:	fd7784e3          	beq	a5,s7,80000968 <uvmunmap+0x70>
    if(do_free){
    800009a4:	fc0a8ae3          	beqz	s5,80000978 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800009a8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800009aa:	0532                	slli	a0,a0,0xc
    800009ac:	fffff097          	auipc	ra,0xfffff
    800009b0:	796080e7          	jalr	1942(ra) # 80000142 <kfree>
    800009b4:	b7d1                	j	80000978 <uvmunmap+0x80>
    800009b6:	74e2                	ld	s1,56(sp)
    800009b8:	7942                	ld	s2,48(sp)
    800009ba:	79a2                	ld	s3,40(sp)
    800009bc:	7a02                	ld	s4,32(sp)
    800009be:	6ae2                	ld	s5,24(sp)
    800009c0:	6b42                	ld	s6,16(sp)
    800009c2:	6ba2                	ld	s7,8(sp)
  }
}
    800009c4:	60a6                	ld	ra,72(sp)
    800009c6:	6406                	ld	s0,64(sp)
    800009c8:	6161                	addi	sp,sp,80
    800009ca:	8082                	ret

00000000800009cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	932080e7          	jalr	-1742(ra) # 80000308 <kalloc>
    800009de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800009e0:	c519                	beqz	a0,800009ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800009e2:	6605                	lui	a2,0x1
    800009e4:	4581                	li	a1,0
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	98c080e7          	jalr	-1652(ra) # 80000372 <memset>
  return pagetable;
}
    800009ee:	8526                	mv	a0,s1
    800009f0:	60e2                	ld	ra,24(sp)
    800009f2:	6442                	ld	s0,16(sp)
    800009f4:	64a2                	ld	s1,8(sp)
    800009f6:	6105                	addi	sp,sp,32
    800009f8:	8082                	ret

00000000800009fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800009fa:	7179                	addi	sp,sp,-48
    800009fc:	f406                	sd	ra,40(sp)
    800009fe:	f022                	sd	s0,32(sp)
    80000a00:	ec26                	sd	s1,24(sp)
    80000a02:	e84a                	sd	s2,16(sp)
    80000a04:	e44e                	sd	s3,8(sp)
    80000a06:	e052                	sd	s4,0(sp)
    80000a08:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000a0a:	6785                	lui	a5,0x1
    80000a0c:	04f67863          	bgeu	a2,a5,80000a5c <uvminit+0x62>
    80000a10:	8a2a                	mv	s4,a0
    80000a12:	89ae                	mv	s3,a1
    80000a14:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	8f2080e7          	jalr	-1806(ra) # 80000308 <kalloc>
    80000a1e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	4581                	li	a1,0
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	94e080e7          	jalr	-1714(ra) # 80000372 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000a2c:	4779                	li	a4,30
    80000a2e:	86ca                	mv	a3,s2
    80000a30:	6605                	lui	a2,0x1
    80000a32:	4581                	li	a1,0
    80000a34:	8552                	mv	a0,s4
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	cfc080e7          	jalr	-772(ra) # 80000732 <mappages>
  memmove(mem, src, sz);
    80000a3e:	8626                	mv	a2,s1
    80000a40:	85ce                	mv	a1,s3
    80000a42:	854a                	mv	a0,s2
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	98a080e7          	jalr	-1654(ra) # 800003ce <memmove>
}
    80000a4c:	70a2                	ld	ra,40(sp)
    80000a4e:	7402                	ld	s0,32(sp)
    80000a50:	64e2                	ld	s1,24(sp)
    80000a52:	6942                	ld	s2,16(sp)
    80000a54:	69a2                	ld	s3,8(sp)
    80000a56:	6a02                	ld	s4,0(sp)
    80000a58:	6145                	addi	sp,sp,48
    80000a5a:	8082                	ret
    panic("inituvm: more than a page");
    80000a5c:	00007517          	auipc	a0,0x7
    80000a60:	68c50513          	addi	a0,a0,1676 # 800080e8 <etext+0xe8>
    80000a64:	00005097          	auipc	ra,0x5
    80000a68:	548080e7          	jalr	1352(ra) # 80005fac <panic>

0000000080000a6c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a6c:	1101                	addi	sp,sp,-32
    80000a6e:	ec06                	sd	ra,24(sp)
    80000a70:	e822                	sd	s0,16(sp)
    80000a72:	e426                	sd	s1,8(sp)
    80000a74:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a76:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a78:	00b67d63          	bgeu	a2,a1,80000a92 <uvmdealloc+0x26>
    80000a7c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a82:	00f60733          	add	a4,a2,a5
    80000a86:	76fd                	lui	a3,0xfffff
    80000a88:	8f75                	and	a4,a4,a3
    80000a8a:	97ae                	add	a5,a5,a1
    80000a8c:	8ff5                	and	a5,a5,a3
    80000a8e:	00f76863          	bltu	a4,a5,80000a9e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a92:	8526                	mv	a0,s1
    80000a94:	60e2                	ld	ra,24(sp)
    80000a96:	6442                	ld	s0,16(sp)
    80000a98:	64a2                	ld	s1,8(sp)
    80000a9a:	6105                	addi	sp,sp,32
    80000a9c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a9e:	8f99                	sub	a5,a5,a4
    80000aa0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	0007861b          	sext.w	a2,a5
    80000aa8:	85ba                	mv	a1,a4
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	e4e080e7          	jalr	-434(ra) # 800008f8 <uvmunmap>
    80000ab2:	b7c5                	j	80000a92 <uvmdealloc+0x26>

0000000080000ab4 <uvmalloc>:
  if(newsz < oldsz)
    80000ab4:	0ab66563          	bltu	a2,a1,80000b5e <uvmalloc+0xaa>
{
    80000ab8:	7139                	addi	sp,sp,-64
    80000aba:	fc06                	sd	ra,56(sp)
    80000abc:	f822                	sd	s0,48(sp)
    80000abe:	ec4e                	sd	s3,24(sp)
    80000ac0:	e852                	sd	s4,16(sp)
    80000ac2:	e456                	sd	s5,8(sp)
    80000ac4:	0080                	addi	s0,sp,64
    80000ac6:	8aaa                	mv	s5,a0
    80000ac8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000aca:	6785                	lui	a5,0x1
    80000acc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000ace:	95be                	add	a1,a1,a5
    80000ad0:	77fd                	lui	a5,0xfffff
    80000ad2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000ad6:	08c9f663          	bgeu	s3,a2,80000b62 <uvmalloc+0xae>
    80000ada:	f426                	sd	s1,40(sp)
    80000adc:	f04a                	sd	s2,32(sp)
    80000ade:	894e                	mv	s2,s3
    mem = kalloc();
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	828080e7          	jalr	-2008(ra) # 80000308 <kalloc>
    80000ae8:	84aa                	mv	s1,a0
    if(mem == 0){
    80000aea:	c90d                	beqz	a0,80000b1c <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000aec:	6605                	lui	a2,0x1
    80000aee:	4581                	li	a1,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	882080e7          	jalr	-1918(ra) # 80000372 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000af8:	4779                	li	a4,30
    80000afa:	86a6                	mv	a3,s1
    80000afc:	6605                	lui	a2,0x1
    80000afe:	85ca                	mv	a1,s2
    80000b00:	8556                	mv	a0,s5
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	c30080e7          	jalr	-976(ra) # 80000732 <mappages>
    80000b0a:	e915                	bnez	a0,80000b3e <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000b0c:	6785                	lui	a5,0x1
    80000b0e:	993e                	add	s2,s2,a5
    80000b10:	fd4968e3          	bltu	s2,s4,80000ae0 <uvmalloc+0x2c>
  return newsz;
    80000b14:	8552                	mv	a0,s4
    80000b16:	74a2                	ld	s1,40(sp)
    80000b18:	7902                	ld	s2,32(sp)
    80000b1a:	a819                	j	80000b30 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000b1c:	864e                	mv	a2,s3
    80000b1e:	85ca                	mv	a1,s2
    80000b20:	8556                	mv	a0,s5
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	f4a080e7          	jalr	-182(ra) # 80000a6c <uvmdealloc>
      return 0;
    80000b2a:	4501                	li	a0,0
    80000b2c:	74a2                	ld	s1,40(sp)
    80000b2e:	7902                	ld	s2,32(sp)
}
    80000b30:	70e2                	ld	ra,56(sp)
    80000b32:	7442                	ld	s0,48(sp)
    80000b34:	69e2                	ld	s3,24(sp)
    80000b36:	6a42                	ld	s4,16(sp)
    80000b38:	6aa2                	ld	s5,8(sp)
    80000b3a:	6121                	addi	sp,sp,64
    80000b3c:	8082                	ret
      kfree(mem);
    80000b3e:	8526                	mv	a0,s1
    80000b40:	fffff097          	auipc	ra,0xfffff
    80000b44:	602080e7          	jalr	1538(ra) # 80000142 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b48:	864e                	mv	a2,s3
    80000b4a:	85ca                	mv	a1,s2
    80000b4c:	8556                	mv	a0,s5
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	f1e080e7          	jalr	-226(ra) # 80000a6c <uvmdealloc>
      return 0;
    80000b56:	4501                	li	a0,0
    80000b58:	74a2                	ld	s1,40(sp)
    80000b5a:	7902                	ld	s2,32(sp)
    80000b5c:	bfd1                	j	80000b30 <uvmalloc+0x7c>
    return oldsz;
    80000b5e:	852e                	mv	a0,a1
}
    80000b60:	8082                	ret
  return newsz;
    80000b62:	8532                	mv	a0,a2
    80000b64:	b7f1                	j	80000b30 <uvmalloc+0x7c>

0000000080000b66 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b66:	7179                	addi	sp,sp,-48
    80000b68:	f406                	sd	ra,40(sp)
    80000b6a:	f022                	sd	s0,32(sp)
    80000b6c:	ec26                	sd	s1,24(sp)
    80000b6e:	e84a                	sd	s2,16(sp)
    80000b70:	e44e                	sd	s3,8(sp)
    80000b72:	e052                	sd	s4,0(sp)
    80000b74:	1800                	addi	s0,sp,48
    80000b76:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b78:	84aa                	mv	s1,a0
    80000b7a:	6905                	lui	s2,0x1
    80000b7c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b7e:	4985                	li	s3,1
    80000b80:	a829                	j	80000b9a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b82:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000b84:	00c79513          	slli	a0,a5,0xc
    80000b88:	00000097          	auipc	ra,0x0
    80000b8c:	fde080e7          	jalr	-34(ra) # 80000b66 <freewalk>
      pagetable[i] = 0;
    80000b90:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b94:	04a1                	addi	s1,s1,8
    80000b96:	03248163          	beq	s1,s2,80000bb8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b9a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b9c:	00f7f713          	andi	a4,a5,15
    80000ba0:	ff3701e3          	beq	a4,s3,80000b82 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ba4:	8b85                	andi	a5,a5,1
    80000ba6:	d7fd                	beqz	a5,80000b94 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	56050513          	addi	a0,a0,1376 # 80008108 <etext+0x108>
    80000bb0:	00005097          	auipc	ra,0x5
    80000bb4:	3fc080e7          	jalr	1020(ra) # 80005fac <panic>
    }
  }
  kfree((void*)pagetable);
    80000bb8:	8552                	mv	a0,s4
    80000bba:	fffff097          	auipc	ra,0xfffff
    80000bbe:	588080e7          	jalr	1416(ra) # 80000142 <kfree>
}
    80000bc2:	70a2                	ld	ra,40(sp)
    80000bc4:	7402                	ld	s0,32(sp)
    80000bc6:	64e2                	ld	s1,24(sp)
    80000bc8:	6942                	ld	s2,16(sp)
    80000bca:	69a2                	ld	s3,8(sp)
    80000bcc:	6a02                	ld	s4,0(sp)
    80000bce:	6145                	addi	sp,sp,48
    80000bd0:	8082                	ret

0000000080000bd2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000bd2:	1101                	addi	sp,sp,-32
    80000bd4:	ec06                	sd	ra,24(sp)
    80000bd6:	e822                	sd	s0,16(sp)
    80000bd8:	e426                	sd	s1,8(sp)
    80000bda:	1000                	addi	s0,sp,32
    80000bdc:	84aa                	mv	s1,a0
  if(sz > 0)
    80000bde:	e999                	bnez	a1,80000bf4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000be0:	8526                	mv	a0,s1
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	f84080e7          	jalr	-124(ra) # 80000b66 <freewalk>
}
    80000bea:	60e2                	ld	ra,24(sp)
    80000bec:	6442                	ld	s0,16(sp)
    80000bee:	64a2                	ld	s1,8(sp)
    80000bf0:	6105                	addi	sp,sp,32
    80000bf2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000bf4:	6785                	lui	a5,0x1
    80000bf6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000bf8:	95be                	add	a1,a1,a5
    80000bfa:	4685                	li	a3,1
    80000bfc:	00c5d613          	srli	a2,a1,0xc
    80000c00:	4581                	li	a1,0
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	cf6080e7          	jalr	-778(ra) # 800008f8 <uvmunmap>
    80000c0a:	bfd9                	j	80000be0 <uvmfree+0xe>

0000000080000c0c <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000c0c:	7139                	addi	sp,sp,-64
    80000c0e:	fc06                	sd	ra,56(sp)
    80000c10:	f822                	sd	s0,48(sp)
    80000c12:	e05a                	sd	s6,0(sp)
    80000c14:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000c16:	ce4d                	beqz	a2,80000cd0 <uvmcopy+0xc4>
    80000c18:	f426                	sd	s1,40(sp)
    80000c1a:	f04a                	sd	s2,32(sp)
    80000c1c:	ec4e                	sd	s3,24(sp)
    80000c1e:	e852                	sd	s4,16(sp)
    80000c20:	e456                	sd	s5,8(sp)
    80000c22:	8aaa                	mv	s5,a0
    80000c24:	8a2e                	mv	s4,a1
    80000c26:	89b2                	mv	s3,a2
    80000c28:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000c2a:	4601                	li	a2,0
    80000c2c:	85a6                	mv	a1,s1
    80000c2e:	8556                	mv	a0,s5
    80000c30:	00000097          	auipc	ra,0x0
    80000c34:	a1a080e7          	jalr	-1510(ra) # 8000064a <walk>
    80000c38:	c539                	beqz	a0,80000c86 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000c3a:	6118                	ld	a4,0(a0)
    80000c3c:	00177793          	andi	a5,a4,1
    80000c40:	cbb9                	beqz	a5,80000c96 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000c42:	00a75913          	srli	s2,a4,0xa
    80000c46:	0932                	slli	s2,s2,0xc
    *pte = *pte & ~(PTE_W);
    80000c48:	9b6d                	andi	a4,a4,-5
    *pte = *pte | PTE_COW;
    80000c4a:	10076713          	ori	a4,a4,256
    80000c4e:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000c50:	3fb77713          	andi	a4,a4,1019
    80000c54:	86ca                	mv	a3,s2
    80000c56:	6605                	lui	a2,0x1
    80000c58:	85a6                	mv	a1,s1
    80000c5a:	8552                	mv	a0,s4
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	ad6080e7          	jalr	-1322(ra) # 80000732 <mappages>
    80000c64:	8b2a                	mv	s6,a0
    80000c66:	e121                	bnez	a0,80000ca6 <uvmcopy+0x9a>
      goto err;
    }
    incr((void *)pa);
    80000c68:	854a                	mv	a0,s2
    80000c6a:	fffff097          	auipc	ra,0xfffff
    80000c6e:	43c080e7          	jalr	1084(ra) # 800000a6 <incr>
  for(i = 0; i < sz; i += PGSIZE){
    80000c72:	6785                	lui	a5,0x1
    80000c74:	94be                	add	s1,s1,a5
    80000c76:	fb34eae3          	bltu	s1,s3,80000c2a <uvmcopy+0x1e>
    80000c7a:	74a2                	ld	s1,40(sp)
    80000c7c:	7902                	ld	s2,32(sp)
    80000c7e:	69e2                	ld	s3,24(sp)
    80000c80:	6a42                	ld	s4,16(sp)
    80000c82:	6aa2                	ld	s5,8(sp)
    80000c84:	a081                	j	80000cc4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000c86:	00007517          	auipc	a0,0x7
    80000c8a:	49250513          	addi	a0,a0,1170 # 80008118 <etext+0x118>
    80000c8e:	00005097          	auipc	ra,0x5
    80000c92:	31e080e7          	jalr	798(ra) # 80005fac <panic>
      panic("uvmcopy: page not present");
    80000c96:	00007517          	auipc	a0,0x7
    80000c9a:	4a250513          	addi	a0,a0,1186 # 80008138 <etext+0x138>
    80000c9e:	00005097          	auipc	ra,0x5
    80000ca2:	30e080e7          	jalr	782(ra) # 80005fac <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ca6:	4685                	li	a3,1
    80000ca8:	00c4d613          	srli	a2,s1,0xc
    80000cac:	4581                	li	a1,0
    80000cae:	8552                	mv	a0,s4
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	c48080e7          	jalr	-952(ra) # 800008f8 <uvmunmap>
  return -1;
    80000cb8:	5b7d                	li	s6,-1
    80000cba:	74a2                	ld	s1,40(sp)
    80000cbc:	7902                	ld	s2,32(sp)
    80000cbe:	69e2                	ld	s3,24(sp)
    80000cc0:	6a42                	ld	s4,16(sp)
    80000cc2:	6aa2                	ld	s5,8(sp)
}
    80000cc4:	855a                	mv	a0,s6
    80000cc6:	70e2                	ld	ra,56(sp)
    80000cc8:	7442                	ld	s0,48(sp)
    80000cca:	6b02                	ld	s6,0(sp)
    80000ccc:	6121                	addi	sp,sp,64
    80000cce:	8082                	ret
  return 0;
    80000cd0:	4b01                	li	s6,0
    80000cd2:	bfcd                	j	80000cc4 <uvmcopy+0xb8>

0000000080000cd4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000cd4:	1141                	addi	sp,sp,-16
    80000cd6:	e406                	sd	ra,8(sp)
    80000cd8:	e022                	sd	s0,0(sp)
    80000cda:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000cdc:	4601                	li	a2,0
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	96c080e7          	jalr	-1684(ra) # 8000064a <walk>
  if(pte == 0)
    80000ce6:	c901                	beqz	a0,80000cf6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ce8:	611c                	ld	a5,0(a0)
    80000cea:	9bbd                	andi	a5,a5,-17
    80000cec:	e11c                	sd	a5,0(a0)
}
    80000cee:	60a2                	ld	ra,8(sp)
    80000cf0:	6402                	ld	s0,0(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
    panic("uvmclear");
    80000cf6:	00007517          	auipc	a0,0x7
    80000cfa:	46250513          	addi	a0,a0,1122 # 80008158 <etext+0x158>
    80000cfe:	00005097          	auipc	ra,0x5
    80000d02:	2ae080e7          	jalr	686(ra) # 80005fac <panic>

0000000080000d06 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d06:	caa5                	beqz	a3,80000d76 <copyin+0x70>
{
    80000d08:	715d                	addi	sp,sp,-80
    80000d0a:	e486                	sd	ra,72(sp)
    80000d0c:	e0a2                	sd	s0,64(sp)
    80000d0e:	fc26                	sd	s1,56(sp)
    80000d10:	f84a                	sd	s2,48(sp)
    80000d12:	f44e                	sd	s3,40(sp)
    80000d14:	f052                	sd	s4,32(sp)
    80000d16:	ec56                	sd	s5,24(sp)
    80000d18:	e85a                	sd	s6,16(sp)
    80000d1a:	e45e                	sd	s7,8(sp)
    80000d1c:	e062                	sd	s8,0(sp)
    80000d1e:	0880                	addi	s0,sp,80
    80000d20:	8b2a                	mv	s6,a0
    80000d22:	8a2e                	mv	s4,a1
    80000d24:	8c32                	mv	s8,a2
    80000d26:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d28:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d2a:	6a85                	lui	s5,0x1
    80000d2c:	a01d                	j	80000d52 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d2e:	018505b3          	add	a1,a0,s8
    80000d32:	0004861b          	sext.w	a2,s1
    80000d36:	412585b3          	sub	a1,a1,s2
    80000d3a:	8552                	mv	a0,s4
    80000d3c:	fffff097          	auipc	ra,0xfffff
    80000d40:	692080e7          	jalr	1682(ra) # 800003ce <memmove>

    len -= n;
    80000d44:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d48:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d4e:	02098263          	beqz	s3,80000d72 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d56:	85ca                	mv	a1,s2
    80000d58:	855a                	mv	a0,s6
    80000d5a:	00000097          	auipc	ra,0x0
    80000d5e:	996080e7          	jalr	-1642(ra) # 800006f0 <walkaddr>
    if(pa0 == 0)
    80000d62:	cd01                	beqz	a0,80000d7a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d64:	418904b3          	sub	s1,s2,s8
    80000d68:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d6a:	fc99f2e3          	bgeu	s3,s1,80000d2e <copyin+0x28>
    80000d6e:	84ce                	mv	s1,s3
    80000d70:	bf7d                	j	80000d2e <copyin+0x28>
  }
  return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	a021                	j	80000d7c <copyin+0x76>
    80000d76:	4501                	li	a0,0
}
    80000d78:	8082                	ret
      return -1;
    80000d7a:	557d                	li	a0,-1
}
    80000d7c:	60a6                	ld	ra,72(sp)
    80000d7e:	6406                	ld	s0,64(sp)
    80000d80:	74e2                	ld	s1,56(sp)
    80000d82:	7942                	ld	s2,48(sp)
    80000d84:	79a2                	ld	s3,40(sp)
    80000d86:	7a02                	ld	s4,32(sp)
    80000d88:	6ae2                	ld	s5,24(sp)
    80000d8a:	6b42                	ld	s6,16(sp)
    80000d8c:	6ba2                	ld	s7,8(sp)
    80000d8e:	6c02                	ld	s8,0(sp)
    80000d90:	6161                	addi	sp,sp,80
    80000d92:	8082                	ret

0000000080000d94 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d94:	cacd                	beqz	a3,80000e46 <copyinstr+0xb2>
{
    80000d96:	715d                	addi	sp,sp,-80
    80000d98:	e486                	sd	ra,72(sp)
    80000d9a:	e0a2                	sd	s0,64(sp)
    80000d9c:	fc26                	sd	s1,56(sp)
    80000d9e:	f84a                	sd	s2,48(sp)
    80000da0:	f44e                	sd	s3,40(sp)
    80000da2:	f052                	sd	s4,32(sp)
    80000da4:	ec56                	sd	s5,24(sp)
    80000da6:	e85a                	sd	s6,16(sp)
    80000da8:	e45e                	sd	s7,8(sp)
    80000daa:	0880                	addi	s0,sp,80
    80000dac:	8a2a                	mv	s4,a0
    80000dae:	8b2e                	mv	s6,a1
    80000db0:	8bb2                	mv	s7,a2
    80000db2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000db4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000db6:	6985                	lui	s3,0x1
    80000db8:	a825                	j	80000df0 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dba:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000dbe:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dc0:	37fd                	addiw	a5,a5,-1
    80000dc2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dc6:	60a6                	ld	ra,72(sp)
    80000dc8:	6406                	ld	s0,64(sp)
    80000dca:	74e2                	ld	s1,56(sp)
    80000dcc:	7942                	ld	s2,48(sp)
    80000dce:	79a2                	ld	s3,40(sp)
    80000dd0:	7a02                	ld	s4,32(sp)
    80000dd2:	6ae2                	ld	s5,24(sp)
    80000dd4:	6b42                	ld	s6,16(sp)
    80000dd6:	6ba2                	ld	s7,8(sp)
    80000dd8:	6161                	addi	sp,sp,80
    80000dda:	8082                	ret
    80000ddc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000de0:	9742                	add	a4,a4,a6
      --max;
    80000de2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000de6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000dea:	04e58663          	beq	a1,a4,80000e36 <copyinstr+0xa2>
{
    80000dee:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000df0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000df4:	85a6                	mv	a1,s1
    80000df6:	8552                	mv	a0,s4
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	8f8080e7          	jalr	-1800(ra) # 800006f0 <walkaddr>
    if(pa0 == 0)
    80000e00:	cd0d                	beqz	a0,80000e3a <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000e02:	417486b3          	sub	a3,s1,s7
    80000e06:	96ce                	add	a3,a3,s3
    if(n > max)
    80000e08:	00d97363          	bgeu	s2,a3,80000e0e <copyinstr+0x7a>
    80000e0c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000e0e:	955e                	add	a0,a0,s7
    80000e10:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000e12:	c695                	beqz	a3,80000e3e <copyinstr+0xaa>
    80000e14:	87da                	mv	a5,s6
    80000e16:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000e18:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000e1c:	96da                	add	a3,a3,s6
    80000e1e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000e20:	00f60733          	add	a4,a2,a5
    80000e24:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5dc0>
    80000e28:	db49                	beqz	a4,80000dba <copyinstr+0x26>
        *dst = *p;
    80000e2a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e2e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e30:	fed797e3          	bne	a5,a3,80000e1e <copyinstr+0x8a>
    80000e34:	b765                	j	80000ddc <copyinstr+0x48>
    80000e36:	4781                	li	a5,0
    80000e38:	b761                	j	80000dc0 <copyinstr+0x2c>
      return -1;
    80000e3a:	557d                	li	a0,-1
    80000e3c:	b769                	j	80000dc6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000e3e:	6b85                	lui	s7,0x1
    80000e40:	9ba6                	add	s7,s7,s1
    80000e42:	87da                	mv	a5,s6
    80000e44:	b76d                	j	80000dee <copyinstr+0x5a>
  int got_null = 0;
    80000e46:	4781                	li	a5,0
  if(got_null){
    80000e48:	37fd                	addiw	a5,a5,-1
    80000e4a:	0007851b          	sext.w	a0,a5
}
    80000e4e:	8082                	ret

0000000080000e50 <is_cow_fault>:

int is_cow_fault(pagetable_t pagetable, uint64 va){
  if(va >= MAXVA)
    80000e50:	57fd                	li	a5,-1
    80000e52:	83e9                	srli	a5,a5,0x1a
    80000e54:	00b7f463          	bgeu	a5,a1,80000e5c <is_cow_fault+0xc>
    return 0;
    80000e58:	4501                	li	a0,0
    return 0;
  if(*pte & PTE_COW){
    return 1;
  }
  return 0;
}
    80000e5a:	8082                	ret
int is_cow_fault(pagetable_t pagetable, uint64 va){
    80000e5c:	1141                	addi	sp,sp,-16
    80000e5e:	e406                	sd	ra,8(sp)
    80000e60:	e022                	sd	s0,0(sp)
    80000e62:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000e64:	4601                	li	a2,0
    80000e66:	77fd                	lui	a5,0xfffff
    80000e68:	8dfd                	and	a1,a1,a5
    80000e6a:	fffff097          	auipc	ra,0xfffff
    80000e6e:	7e0080e7          	jalr	2016(ra) # 8000064a <walk>
  if(pte == 0)
    80000e72:	c105                	beqz	a0,80000e92 <is_cow_fault+0x42>
  if((*pte & PTE_V) == 0)
    80000e74:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000e76:	0117f693          	andi	a3,a5,17
    80000e7a:	4745                	li	a4,17
    return 0;
    80000e7c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000e7e:	00e68663          	beq	a3,a4,80000e8a <is_cow_fault+0x3a>
}
    80000e82:	60a2                	ld	ra,8(sp)
    80000e84:	6402                	ld	s0,0(sp)
    80000e86:	0141                	addi	sp,sp,16
    80000e88:	8082                	ret
  if(*pte & PTE_COW){
    80000e8a:	83a1                	srli	a5,a5,0x8
    80000e8c:	0017f513          	andi	a0,a5,1
    80000e90:	bfcd                	j	80000e82 <is_cow_fault+0x32>
    return 0;
    80000e92:	4501                	li	a0,0
    80000e94:	b7fd                	j	80000e82 <is_cow_fault+0x32>

0000000080000e96 <cow_alloc>:

int cow_alloc(pagetable_t pagetable, uint64 va){
    80000e96:	7139                	addi	sp,sp,-64
    80000e98:	fc06                	sd	ra,56(sp)
    80000e9a:	f822                	sd	s0,48(sp)
    80000e9c:	f426                	sd	s1,40(sp)
    80000e9e:	ec4e                	sd	s3,24(sp)
    80000ea0:	e852                	sd	s4,16(sp)
    80000ea2:	e456                	sd	s5,8(sp)
    80000ea4:	0080                	addi	s0,sp,64
    80000ea6:	8a2a                	mv	s4,a0
  va = PGROUNDDOWN(va);
    80000ea8:	77fd                	lui	a5,0xfffff
    80000eaa:	00f5f9b3          	and	s3,a1,a5
  pte_t *pte = walk(pagetable, va, 0);
    80000eae:	4601                	li	a2,0
    80000eb0:	85ce                	mv	a1,s3
    80000eb2:	fffff097          	auipc	ra,0xfffff
    80000eb6:	798080e7          	jalr	1944(ra) # 8000064a <walk>
  uint64 pa = PTE2PA(*pte);
    80000eba:	6118                	ld	a4,0(a0)
    80000ebc:	00a75593          	srli	a1,a4,0xa
    80000ec0:	00c59a93          	slli	s5,a1,0xc
  int flag = PTE_FLAGS(*pte);
    80000ec4:	0007049b          	sext.w	s1,a4

  char *mem = kalloc();
    80000ec8:	fffff097          	auipc	ra,0xfffff
    80000ecc:	440080e7          	jalr	1088(ra) # 80000308 <kalloc>
  if(mem == 0){
    80000ed0:	c135                	beqz	a0,80000f34 <cow_alloc+0x9e>
    80000ed2:	f04a                	sd	s2,32(sp)
    80000ed4:	892a                	mv	s2,a0
    return -1;
  }
  memmove(mem, (char *)pa, PGSIZE);
    80000ed6:	6605                	lui	a2,0x1
    80000ed8:	85d6                	mv	a1,s5
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	4f4080e7          	jalr	1268(ra) # 800003ce <memmove>
  uvmunmap(pagetable, va, 1, 1);
    80000ee2:	4685                	li	a3,1
    80000ee4:	4605                	li	a2,1
    80000ee6:	85ce                	mv	a1,s3
    80000ee8:	8552                	mv	a0,s4
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	a0e080e7          	jalr	-1522(ra) # 800008f8 <uvmunmap>
  
  flag = flag & (~PTE_COW);
    80000ef2:	2ff4f713          	andi	a4,s1,767
  flag = flag | PTE_W;
  if(mappages(pagetable, va, PGSIZE, (uint64) mem, flag) < 0){
    80000ef6:	00476713          	ori	a4,a4,4
    80000efa:	86ca                	mv	a3,s2
    80000efc:	6605                	lui	a2,0x1
    80000efe:	85ce                	mv	a1,s3
    80000f00:	8552                	mv	a0,s4
    80000f02:	00000097          	auipc	ra,0x0
    80000f06:	830080e7          	jalr	-2000(ra) # 80000732 <mappages>
    80000f0a:	87aa                	mv	a5,a0
    kfree(mem);
    return -1;
  }
  return 0;
    80000f0c:	4501                	li	a0,0
  if(mappages(pagetable, va, PGSIZE, (uint64) mem, flag) < 0){
    80000f0e:	0007cb63          	bltz	a5,80000f24 <cow_alloc+0x8e>
    80000f12:	7902                	ld	s2,32(sp)
}
    80000f14:	70e2                	ld	ra,56(sp)
    80000f16:	7442                	ld	s0,48(sp)
    80000f18:	74a2                	ld	s1,40(sp)
    80000f1a:	69e2                	ld	s3,24(sp)
    80000f1c:	6a42                	ld	s4,16(sp)
    80000f1e:	6aa2                	ld	s5,8(sp)
    80000f20:	6121                	addi	sp,sp,64
    80000f22:	8082                	ret
    kfree(mem);
    80000f24:	854a                	mv	a0,s2
    80000f26:	fffff097          	auipc	ra,0xfffff
    80000f2a:	21c080e7          	jalr	540(ra) # 80000142 <kfree>
    return -1;
    80000f2e:	557d                	li	a0,-1
    80000f30:	7902                	ld	s2,32(sp)
    80000f32:	b7cd                	j	80000f14 <cow_alloc+0x7e>
    return -1;
    80000f34:	557d                	li	a0,-1
    80000f36:	bff9                	j	80000f14 <cow_alloc+0x7e>

0000000080000f38 <copyout>:
  while(len > 0){
    80000f38:	c2c5                	beqz	a3,80000fd8 <copyout+0xa0>
{
    80000f3a:	715d                	addi	sp,sp,-80
    80000f3c:	e486                	sd	ra,72(sp)
    80000f3e:	e0a2                	sd	s0,64(sp)
    80000f40:	fc26                	sd	s1,56(sp)
    80000f42:	f84a                	sd	s2,48(sp)
    80000f44:	f44e                	sd	s3,40(sp)
    80000f46:	f052                	sd	s4,32(sp)
    80000f48:	ec56                	sd	s5,24(sp)
    80000f4a:	e85a                	sd	s6,16(sp)
    80000f4c:	e45e                	sd	s7,8(sp)
    80000f4e:	e062                	sd	s8,0(sp)
    80000f50:	0880                	addi	s0,sp,80
    80000f52:	8b2a                	mv	s6,a0
    80000f54:	89ae                	mv	s3,a1
    80000f56:	8ab2                	mv	s5,a2
    80000f58:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000f5a:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80000f5c:	6b85                	lui	s7,0x1
    80000f5e:	a825                	j	80000f96 <copyout+0x5e>
        printf("copyout: cowalloc failed!\n");
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	20850513          	addi	a0,a0,520 # 80008168 <etext+0x168>
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	08e080e7          	jalr	142(ra) # 80005ff6 <printf>
        return -1;
    80000f70:	557d                	li	a0,-1
    80000f72:	a0b5                	j	80000fde <copyout+0xa6>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000f74:	412989b3          	sub	s3,s3,s2
    80000f78:	0004861b          	sext.w	a2,s1
    80000f7c:	85d6                	mv	a1,s5
    80000f7e:	954e                	add	a0,a0,s3
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	44e080e7          	jalr	1102(ra) # 800003ce <memmove>
    len -= n;
    80000f88:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000f8c:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000f8e:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000f92:	040a0163          	beqz	s4,80000fd4 <copyout+0x9c>
    va0 = PGROUNDDOWN(dstva);
    80000f96:	0189f933          	and	s2,s3,s8
    if(is_cow_fault(pagetable, va0)){
    80000f9a:	85ca                	mv	a1,s2
    80000f9c:	855a                	mv	a0,s6
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	eb2080e7          	jalr	-334(ra) # 80000e50 <is_cow_fault>
    80000fa6:	c909                	beqz	a0,80000fb8 <copyout+0x80>
      if(cow_alloc(pagetable, va0) < 0){
    80000fa8:	85ca                	mv	a1,s2
    80000faa:	855a                	mv	a0,s6
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	eea080e7          	jalr	-278(ra) # 80000e96 <cow_alloc>
    80000fb4:	fa0546e3          	bltz	a0,80000f60 <copyout+0x28>
    pa0 = walkaddr(pagetable, va0);
    80000fb8:	85ca                	mv	a1,s2
    80000fba:	855a                	mv	a0,s6
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	734080e7          	jalr	1844(ra) # 800006f0 <walkaddr>
    if(pa0 == 0)
    80000fc4:	cd01                	beqz	a0,80000fdc <copyout+0xa4>
    n = PGSIZE - (dstva - va0);
    80000fc6:	413904b3          	sub	s1,s2,s3
    80000fca:	94de                	add	s1,s1,s7
    if(n > len)
    80000fcc:	fa9a74e3          	bgeu	s4,s1,80000f74 <copyout+0x3c>
    80000fd0:	84d2                	mv	s1,s4
    80000fd2:	b74d                	j	80000f74 <copyout+0x3c>
  return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	a021                	j	80000fde <copyout+0xa6>
    80000fd8:	4501                	li	a0,0
}
    80000fda:	8082                	ret
      return -1;
    80000fdc:	557d                	li	a0,-1
}
    80000fde:	60a6                	ld	ra,72(sp)
    80000fe0:	6406                	ld	s0,64(sp)
    80000fe2:	74e2                	ld	s1,56(sp)
    80000fe4:	7942                	ld	s2,48(sp)
    80000fe6:	79a2                	ld	s3,40(sp)
    80000fe8:	7a02                	ld	s4,32(sp)
    80000fea:	6ae2                	ld	s5,24(sp)
    80000fec:	6b42                	ld	s6,16(sp)
    80000fee:	6ba2                	ld	s7,8(sp)
    80000ff0:	6c02                	ld	s8,0(sp)
    80000ff2:	6161                	addi	sp,sp,80
    80000ff4:	8082                	ret

0000000080000ff6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ff6:	7139                	addi	sp,sp,-64
    80000ff8:	fc06                	sd	ra,56(sp)
    80000ffa:	f822                	sd	s0,48(sp)
    80000ffc:	f426                	sd	s1,40(sp)
    80000ffe:	f04a                	sd	s2,32(sp)
    80001000:	ec4e                	sd	s3,24(sp)
    80001002:	e852                	sd	s4,16(sp)
    80001004:	e456                	sd	s5,8(sp)
    80001006:	e05a                	sd	s6,0(sp)
    80001008:	0080                	addi	s0,sp,64
    8000100a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000100c:	0000b497          	auipc	s1,0xb
    80001010:	48c48493          	addi	s1,s1,1164 # 8000c498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001014:	8b26                	mv	s6,s1
    80001016:	04fa5937          	lui	s2,0x4fa5
    8000101a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000101e:	0932                	slli	s2,s2,0xc
    80001020:	fa590913          	addi	s2,s2,-91
    80001024:	0932                	slli	s2,s2,0xc
    80001026:	fa590913          	addi	s2,s2,-91
    8000102a:	0932                	slli	s2,s2,0xc
    8000102c:	fa590913          	addi	s2,s2,-91
    80001030:	040009b7          	lui	s3,0x4000
    80001034:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001036:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001038:	00011a97          	auipc	s5,0x11
    8000103c:	e60a8a93          	addi	s5,s5,-416 # 80011e98 <tickslock>
    char *pa = kalloc();
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	2c8080e7          	jalr	712(ra) # 80000308 <kalloc>
    80001048:	862a                	mv	a2,a0
    if(pa == 0)
    8000104a:	c121                	beqz	a0,8000108a <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    8000104c:	416485b3          	sub	a1,s1,s6
    80001050:	858d                	srai	a1,a1,0x3
    80001052:	032585b3          	mul	a1,a1,s2
    80001056:	2585                	addiw	a1,a1,1
    80001058:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000105c:	4719                	li	a4,6
    8000105e:	6685                	lui	a3,0x1
    80001060:	40b985b3          	sub	a1,s3,a1
    80001064:	8552                	mv	a0,s4
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	76c080e7          	jalr	1900(ra) # 800007d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	16848493          	addi	s1,s1,360
    80001072:	fd5497e3          	bne	s1,s5,80001040 <proc_mapstacks+0x4a>
  }
}
    80001076:	70e2                	ld	ra,56(sp)
    80001078:	7442                	ld	s0,48(sp)
    8000107a:	74a2                	ld	s1,40(sp)
    8000107c:	7902                	ld	s2,32(sp)
    8000107e:	69e2                	ld	s3,24(sp)
    80001080:	6a42                	ld	s4,16(sp)
    80001082:	6aa2                	ld	s5,8(sp)
    80001084:	6b02                	ld	s6,0(sp)
    80001086:	6121                	addi	sp,sp,64
    80001088:	8082                	ret
      panic("kalloc");
    8000108a:	00007517          	auipc	a0,0x7
    8000108e:	0fe50513          	addi	a0,a0,254 # 80008188 <etext+0x188>
    80001092:	00005097          	auipc	ra,0x5
    80001096:	f1a080e7          	jalr	-230(ra) # 80005fac <panic>

000000008000109a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000109a:	7139                	addi	sp,sp,-64
    8000109c:	fc06                	sd	ra,56(sp)
    8000109e:	f822                	sd	s0,48(sp)
    800010a0:	f426                	sd	s1,40(sp)
    800010a2:	f04a                	sd	s2,32(sp)
    800010a4:	ec4e                	sd	s3,24(sp)
    800010a6:	e852                	sd	s4,16(sp)
    800010a8:	e456                	sd	s5,8(sp)
    800010aa:	e05a                	sd	s6,0(sp)
    800010ac:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800010ae:	00007597          	auipc	a1,0x7
    800010b2:	0e258593          	addi	a1,a1,226 # 80008190 <etext+0x190>
    800010b6:	0000b517          	auipc	a0,0xb
    800010ba:	fb250513          	addi	a0,a0,-78 # 8000c068 <pid_lock>
    800010be:	00005097          	auipc	ra,0x5
    800010c2:	3d8080e7          	jalr	984(ra) # 80006496 <initlock>
  initlock(&wait_lock, "wait_lock");
    800010c6:	00007597          	auipc	a1,0x7
    800010ca:	0d258593          	addi	a1,a1,210 # 80008198 <etext+0x198>
    800010ce:	0000b517          	auipc	a0,0xb
    800010d2:	fb250513          	addi	a0,a0,-78 # 8000c080 <wait_lock>
    800010d6:	00005097          	auipc	ra,0x5
    800010da:	3c0080e7          	jalr	960(ra) # 80006496 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010de:	0000b497          	auipc	s1,0xb
    800010e2:	3ba48493          	addi	s1,s1,954 # 8000c498 <proc>
      initlock(&p->lock, "proc");
    800010e6:	00007b17          	auipc	s6,0x7
    800010ea:	0c2b0b13          	addi	s6,s6,194 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    800010ee:	8aa6                	mv	s5,s1
    800010f0:	04fa5937          	lui	s2,0x4fa5
    800010f4:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800010f8:	0932                	slli	s2,s2,0xc
    800010fa:	fa590913          	addi	s2,s2,-91
    800010fe:	0932                	slli	s2,s2,0xc
    80001100:	fa590913          	addi	s2,s2,-91
    80001104:	0932                	slli	s2,s2,0xc
    80001106:	fa590913          	addi	s2,s2,-91
    8000110a:	040009b7          	lui	s3,0x4000
    8000110e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001110:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001112:	00011a17          	auipc	s4,0x11
    80001116:	d86a0a13          	addi	s4,s4,-634 # 80011e98 <tickslock>
      initlock(&p->lock, "proc");
    8000111a:	85da                	mv	a1,s6
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	378080e7          	jalr	888(ra) # 80006496 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001126:	415487b3          	sub	a5,s1,s5
    8000112a:	878d                	srai	a5,a5,0x3
    8000112c:	032787b3          	mul	a5,a5,s2
    80001130:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    80001132:	00d7979b          	slliw	a5,a5,0xd
    80001136:	40f987b3          	sub	a5,s3,a5
    8000113a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000113c:	16848493          	addi	s1,s1,360
    80001140:	fd449de3          	bne	s1,s4,8000111a <procinit+0x80>
  }
}
    80001144:	70e2                	ld	ra,56(sp)
    80001146:	7442                	ld	s0,48(sp)
    80001148:	74a2                	ld	s1,40(sp)
    8000114a:	7902                	ld	s2,32(sp)
    8000114c:	69e2                	ld	s3,24(sp)
    8000114e:	6a42                	ld	s4,16(sp)
    80001150:	6aa2                	ld	s5,8(sp)
    80001152:	6b02                	ld	s6,0(sp)
    80001154:	6121                	addi	sp,sp,64
    80001156:	8082                	ret

0000000080001158 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001158:	1141                	addi	sp,sp,-16
    8000115a:	e422                	sd	s0,8(sp)
    8000115c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000115e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001160:	2501                	sext.w	a0,a0
    80001162:	6422                	ld	s0,8(sp)
    80001164:	0141                	addi	sp,sp,16
    80001166:	8082                	ret

0000000080001168 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001168:	1141                	addi	sp,sp,-16
    8000116a:	e422                	sd	s0,8(sp)
    8000116c:	0800                	addi	s0,sp,16
    8000116e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001170:	2781                	sext.w	a5,a5
    80001172:	079e                	slli	a5,a5,0x7
  return c;
}
    80001174:	0000b517          	auipc	a0,0xb
    80001178:	f2450513          	addi	a0,a0,-220 # 8000c098 <cpus>
    8000117c:	953e                	add	a0,a0,a5
    8000117e:	6422                	ld	s0,8(sp)
    80001180:	0141                	addi	sp,sp,16
    80001182:	8082                	ret

0000000080001184 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	1000                	addi	s0,sp,32
  push_off();
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	34c080e7          	jalr	844(ra) # 800064da <push_off>
    80001196:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001198:	2781                	sext.w	a5,a5
    8000119a:	079e                	slli	a5,a5,0x7
    8000119c:	0000b717          	auipc	a4,0xb
    800011a0:	ecc70713          	addi	a4,a4,-308 # 8000c068 <pid_lock>
    800011a4:	97ba                	add	a5,a5,a4
    800011a6:	7b84                	ld	s1,48(a5)
  pop_off();
    800011a8:	00005097          	auipc	ra,0x5
    800011ac:	3d2080e7          	jalr	978(ra) # 8000657a <pop_off>
  return p;
}
    800011b0:	8526                	mv	a0,s1
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6105                	addi	sp,sp,32
    800011ba:	8082                	ret

00000000800011bc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800011bc:	1141                	addi	sp,sp,-16
    800011be:	e406                	sd	ra,8(sp)
    800011c0:	e022                	sd	s0,0(sp)
    800011c2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	fc0080e7          	jalr	-64(ra) # 80001184 <myproc>
    800011cc:	00005097          	auipc	ra,0x5
    800011d0:	40e080e7          	jalr	1038(ra) # 800065da <release>

  if (first) {
    800011d4:	0000a797          	auipc	a5,0xa
    800011d8:	f9c7a783          	lw	a5,-100(a5) # 8000b170 <first.1>
    800011dc:	eb89                	bnez	a5,800011ee <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800011de:	00001097          	auipc	ra,0x1
    800011e2:	c16080e7          	jalr	-1002(ra) # 80001df4 <usertrapret>
}
    800011e6:	60a2                	ld	ra,8(sp)
    800011e8:	6402                	ld	s0,0(sp)
    800011ea:	0141                	addi	sp,sp,16
    800011ec:	8082                	ret
    first = 0;
    800011ee:	0000a797          	auipc	a5,0xa
    800011f2:	f807a123          	sw	zero,-126(a5) # 8000b170 <first.1>
    fsinit(ROOTDEV);
    800011f6:	4505                	li	a0,1
    800011f8:	00002097          	auipc	ra,0x2
    800011fc:	9d4080e7          	jalr	-1580(ra) # 80002bcc <fsinit>
    80001200:	bff9                	j	800011de <forkret+0x22>

0000000080001202 <allocpid>:
allocpid() {
    80001202:	1101                	addi	sp,sp,-32
    80001204:	ec06                	sd	ra,24(sp)
    80001206:	e822                	sd	s0,16(sp)
    80001208:	e426                	sd	s1,8(sp)
    8000120a:	e04a                	sd	s2,0(sp)
    8000120c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000120e:	0000b917          	auipc	s2,0xb
    80001212:	e5a90913          	addi	s2,s2,-422 # 8000c068 <pid_lock>
    80001216:	854a                	mv	a0,s2
    80001218:	00005097          	auipc	ra,0x5
    8000121c:	30e080e7          	jalr	782(ra) # 80006526 <acquire>
  pid = nextpid;
    80001220:	0000a797          	auipc	a5,0xa
    80001224:	f5478793          	addi	a5,a5,-172 # 8000b174 <nextpid>
    80001228:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000122a:	0014871b          	addiw	a4,s1,1
    8000122e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001230:	854a                	mv	a0,s2
    80001232:	00005097          	auipc	ra,0x5
    80001236:	3a8080e7          	jalr	936(ra) # 800065da <release>
}
    8000123a:	8526                	mv	a0,s1
    8000123c:	60e2                	ld	ra,24(sp)
    8000123e:	6442                	ld	s0,16(sp)
    80001240:	64a2                	ld	s1,8(sp)
    80001242:	6902                	ld	s2,0(sp)
    80001244:	6105                	addi	sp,sp,32
    80001246:	8082                	ret

0000000080001248 <proc_pagetable>:
{
    80001248:	1101                	addi	sp,sp,-32
    8000124a:	ec06                	sd	ra,24(sp)
    8000124c:	e822                	sd	s0,16(sp)
    8000124e:	e426                	sd	s1,8(sp)
    80001250:	e04a                	sd	s2,0(sp)
    80001252:	1000                	addi	s0,sp,32
    80001254:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	776080e7          	jalr	1910(ra) # 800009cc <uvmcreate>
    8000125e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001260:	c121                	beqz	a0,800012a0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001262:	4729                	li	a4,10
    80001264:	00006697          	auipc	a3,0x6
    80001268:	d9c68693          	addi	a3,a3,-612 # 80007000 <_trampoline>
    8000126c:	6605                	lui	a2,0x1
    8000126e:	040005b7          	lui	a1,0x4000
    80001272:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001274:	05b2                	slli	a1,a1,0xc
    80001276:	fffff097          	auipc	ra,0xfffff
    8000127a:	4bc080e7          	jalr	1212(ra) # 80000732 <mappages>
    8000127e:	02054863          	bltz	a0,800012ae <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001282:	4719                	li	a4,6
    80001284:	05893683          	ld	a3,88(s2)
    80001288:	6605                	lui	a2,0x1
    8000128a:	020005b7          	lui	a1,0x2000
    8000128e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001290:	05b6                	slli	a1,a1,0xd
    80001292:	8526                	mv	a0,s1
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	49e080e7          	jalr	1182(ra) # 80000732 <mappages>
    8000129c:	02054163          	bltz	a0,800012be <proc_pagetable+0x76>
}
    800012a0:	8526                	mv	a0,s1
    800012a2:	60e2                	ld	ra,24(sp)
    800012a4:	6442                	ld	s0,16(sp)
    800012a6:	64a2                	ld	s1,8(sp)
    800012a8:	6902                	ld	s2,0(sp)
    800012aa:	6105                	addi	sp,sp,32
    800012ac:	8082                	ret
    uvmfree(pagetable, 0);
    800012ae:	4581                	li	a1,0
    800012b0:	8526                	mv	a0,s1
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	920080e7          	jalr	-1760(ra) # 80000bd2 <uvmfree>
    return 0;
    800012ba:	4481                	li	s1,0
    800012bc:	b7d5                	j	800012a0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012be:	4681                	li	a3,0
    800012c0:	4605                	li	a2,1
    800012c2:	040005b7          	lui	a1,0x4000
    800012c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012c8:	05b2                	slli	a1,a1,0xc
    800012ca:	8526                	mv	a0,s1
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	62c080e7          	jalr	1580(ra) # 800008f8 <uvmunmap>
    uvmfree(pagetable, 0);
    800012d4:	4581                	li	a1,0
    800012d6:	8526                	mv	a0,s1
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	8fa080e7          	jalr	-1798(ra) # 80000bd2 <uvmfree>
    return 0;
    800012e0:	4481                	li	s1,0
    800012e2:	bf7d                	j	800012a0 <proc_pagetable+0x58>

00000000800012e4 <proc_freepagetable>:
{
    800012e4:	1101                	addi	sp,sp,-32
    800012e6:	ec06                	sd	ra,24(sp)
    800012e8:	e822                	sd	s0,16(sp)
    800012ea:	e426                	sd	s1,8(sp)
    800012ec:	e04a                	sd	s2,0(sp)
    800012ee:	1000                	addi	s0,sp,32
    800012f0:	84aa                	mv	s1,a0
    800012f2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012f4:	4681                	li	a3,0
    800012f6:	4605                	li	a2,1
    800012f8:	040005b7          	lui	a1,0x4000
    800012fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012fe:	05b2                	slli	a1,a1,0xc
    80001300:	fffff097          	auipc	ra,0xfffff
    80001304:	5f8080e7          	jalr	1528(ra) # 800008f8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001308:	4681                	li	a3,0
    8000130a:	4605                	li	a2,1
    8000130c:	020005b7          	lui	a1,0x2000
    80001310:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001312:	05b6                	slli	a1,a1,0xd
    80001314:	8526                	mv	a0,s1
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	5e2080e7          	jalr	1506(ra) # 800008f8 <uvmunmap>
  uvmfree(pagetable, sz);
    8000131e:	85ca                	mv	a1,s2
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	8b0080e7          	jalr	-1872(ra) # 80000bd2 <uvmfree>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6902                	ld	s2,0(sp)
    80001332:	6105                	addi	sp,sp,32
    80001334:	8082                	ret

0000000080001336 <freeproc>:
{
    80001336:	1101                	addi	sp,sp,-32
    80001338:	ec06                	sd	ra,24(sp)
    8000133a:	e822                	sd	s0,16(sp)
    8000133c:	e426                	sd	s1,8(sp)
    8000133e:	1000                	addi	s0,sp,32
    80001340:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001342:	6d28                	ld	a0,88(a0)
    80001344:	c509                	beqz	a0,8000134e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	dfc080e7          	jalr	-516(ra) # 80000142 <kfree>
  p->trapframe = 0;
    8000134e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001352:	68a8                	ld	a0,80(s1)
    80001354:	c511                	beqz	a0,80001360 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001356:	64ac                	ld	a1,72(s1)
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	f8c080e7          	jalr	-116(ra) # 800012e4 <proc_freepagetable>
  p->pagetable = 0;
    80001360:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001364:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001368:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000136c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001370:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001374:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001378:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000137c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001380:	0004ac23          	sw	zero,24(s1)
}
    80001384:	60e2                	ld	ra,24(sp)
    80001386:	6442                	ld	s0,16(sp)
    80001388:	64a2                	ld	s1,8(sp)
    8000138a:	6105                	addi	sp,sp,32
    8000138c:	8082                	ret

000000008000138e <allocproc>:
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	e04a                	sd	s2,0(sp)
    80001398:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	0000b497          	auipc	s1,0xb
    8000139e:	0fe48493          	addi	s1,s1,254 # 8000c498 <proc>
    800013a2:	00011917          	auipc	s2,0x11
    800013a6:	af690913          	addi	s2,s2,-1290 # 80011e98 <tickslock>
    acquire(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	17a080e7          	jalr	378(ra) # 80006526 <acquire>
    if(p->state == UNUSED) {
    800013b4:	4c9c                	lw	a5,24(s1)
    800013b6:	cf81                	beqz	a5,800013ce <allocproc+0x40>
      release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	220080e7          	jalr	544(ra) # 800065da <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013c2:	16848493          	addi	s1,s1,360
    800013c6:	ff2492e3          	bne	s1,s2,800013aa <allocproc+0x1c>
  return 0;
    800013ca:	4481                	li	s1,0
    800013cc:	a889                	j	8000141e <allocproc+0x90>
  p->pid = allocpid();
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	e34080e7          	jalr	-460(ra) # 80001202 <allocpid>
    800013d6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800013d8:	4785                	li	a5,1
    800013da:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	f2c080e7          	jalr	-212(ra) # 80000308 <kalloc>
    800013e4:	892a                	mv	s2,a0
    800013e6:	eca8                	sd	a0,88(s1)
    800013e8:	c131                	beqz	a0,8000142c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800013ea:	8526                	mv	a0,s1
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	e5c080e7          	jalr	-420(ra) # 80001248 <proc_pagetable>
    800013f4:	892a                	mv	s2,a0
    800013f6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800013f8:	c531                	beqz	a0,80001444 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013fa:	07000613          	li	a2,112
    800013fe:	4581                	li	a1,0
    80001400:	06048513          	addi	a0,s1,96
    80001404:	fffff097          	auipc	ra,0xfffff
    80001408:	f6e080e7          	jalr	-146(ra) # 80000372 <memset>
  p->context.ra = (uint64)forkret;
    8000140c:	00000797          	auipc	a5,0x0
    80001410:	db078793          	addi	a5,a5,-592 # 800011bc <forkret>
    80001414:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001416:	60bc                	ld	a5,64(s1)
    80001418:	6705                	lui	a4,0x1
    8000141a:	97ba                	add	a5,a5,a4
    8000141c:	f4bc                	sd	a5,104(s1)
}
    8000141e:	8526                	mv	a0,s1
    80001420:	60e2                	ld	ra,24(sp)
    80001422:	6442                	ld	s0,16(sp)
    80001424:	64a2                	ld	s1,8(sp)
    80001426:	6902                	ld	s2,0(sp)
    80001428:	6105                	addi	sp,sp,32
    8000142a:	8082                	ret
    freeproc(p);
    8000142c:	8526                	mv	a0,s1
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	f08080e7          	jalr	-248(ra) # 80001336 <freeproc>
    release(&p->lock);
    80001436:	8526                	mv	a0,s1
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	1a2080e7          	jalr	418(ra) # 800065da <release>
    return 0;
    80001440:	84ca                	mv	s1,s2
    80001442:	bff1                	j	8000141e <allocproc+0x90>
    freeproc(p);
    80001444:	8526                	mv	a0,s1
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	ef0080e7          	jalr	-272(ra) # 80001336 <freeproc>
    release(&p->lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	00005097          	auipc	ra,0x5
    80001454:	18a080e7          	jalr	394(ra) # 800065da <release>
    return 0;
    80001458:	84ca                	mv	s1,s2
    8000145a:	b7d1                	j	8000141e <allocproc+0x90>

000000008000145c <userinit>:
{
    8000145c:	1101                	addi	sp,sp,-32
    8000145e:	ec06                	sd	ra,24(sp)
    80001460:	e822                	sd	s0,16(sp)
    80001462:	e426                	sd	s1,8(sp)
    80001464:	1000                	addi	s0,sp,32
  p = allocproc();
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f28080e7          	jalr	-216(ra) # 8000138e <allocproc>
    8000146e:	84aa                	mv	s1,a0
  initproc = p;
    80001470:	0000b797          	auipc	a5,0xb
    80001474:	baa7b023          	sd	a0,-1120(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001478:	03400613          	li	a2,52
    8000147c:	0000a597          	auipc	a1,0xa
    80001480:	d0458593          	addi	a1,a1,-764 # 8000b180 <initcode>
    80001484:	6928                	ld	a0,80(a0)
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	574080e7          	jalr	1396(ra) # 800009fa <uvminit>
  p->sz = PGSIZE;
    8000148e:	6785                	lui	a5,0x1
    80001490:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001492:	6cb8                	ld	a4,88(s1)
    80001494:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001498:	6cb8                	ld	a4,88(s1)
    8000149a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000149c:	4641                	li	a2,16
    8000149e:	00007597          	auipc	a1,0x7
    800014a2:	d1258593          	addi	a1,a1,-750 # 800081b0 <etext+0x1b0>
    800014a6:	15848513          	addi	a0,s1,344
    800014aa:	fffff097          	auipc	ra,0xfffff
    800014ae:	00a080e7          	jalr	10(ra) # 800004b4 <safestrcpy>
  p->cwd = namei("/");
    800014b2:	00007517          	auipc	a0,0x7
    800014b6:	d0e50513          	addi	a0,a0,-754 # 800081c0 <etext+0x1c0>
    800014ba:	00002097          	auipc	ra,0x2
    800014be:	158080e7          	jalr	344(ra) # 80003612 <namei>
    800014c2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800014c6:	478d                	li	a5,3
    800014c8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800014ca:	8526                	mv	a0,s1
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	10e080e7          	jalr	270(ra) # 800065da <release>
}
    800014d4:	60e2                	ld	ra,24(sp)
    800014d6:	6442                	ld	s0,16(sp)
    800014d8:	64a2                	ld	s1,8(sp)
    800014da:	6105                	addi	sp,sp,32
    800014dc:	8082                	ret

00000000800014de <growproc>:
{
    800014de:	1101                	addi	sp,sp,-32
    800014e0:	ec06                	sd	ra,24(sp)
    800014e2:	e822                	sd	s0,16(sp)
    800014e4:	e426                	sd	s1,8(sp)
    800014e6:	e04a                	sd	s2,0(sp)
    800014e8:	1000                	addi	s0,sp,32
    800014ea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	c98080e7          	jalr	-872(ra) # 80001184 <myproc>
    800014f4:	892a                	mv	s2,a0
  sz = p->sz;
    800014f6:	652c                	ld	a1,72(a0)
    800014f8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800014fc:	00904f63          	bgtz	s1,8000151a <growproc+0x3c>
  } else if(n < 0){
    80001500:	0204cd63          	bltz	s1,8000153a <growproc+0x5c>
  p->sz = sz;
    80001504:	1782                	slli	a5,a5,0x20
    80001506:	9381                	srli	a5,a5,0x20
    80001508:	04f93423          	sd	a5,72(s2)
  return 0;
    8000150c:	4501                	li	a0,0
}
    8000150e:	60e2                	ld	ra,24(sp)
    80001510:	6442                	ld	s0,16(sp)
    80001512:	64a2                	ld	s1,8(sp)
    80001514:	6902                	ld	s2,0(sp)
    80001516:	6105                	addi	sp,sp,32
    80001518:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000151a:	00f4863b          	addw	a2,s1,a5
    8000151e:	1602                	slli	a2,a2,0x20
    80001520:	9201                	srli	a2,a2,0x20
    80001522:	1582                	slli	a1,a1,0x20
    80001524:	9181                	srli	a1,a1,0x20
    80001526:	6928                	ld	a0,80(a0)
    80001528:	fffff097          	auipc	ra,0xfffff
    8000152c:	58c080e7          	jalr	1420(ra) # 80000ab4 <uvmalloc>
    80001530:	0005079b          	sext.w	a5,a0
    80001534:	fbe1                	bnez	a5,80001504 <growproc+0x26>
      return -1;
    80001536:	557d                	li	a0,-1
    80001538:	bfd9                	j	8000150e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000153a:	00f4863b          	addw	a2,s1,a5
    8000153e:	1602                	slli	a2,a2,0x20
    80001540:	9201                	srli	a2,a2,0x20
    80001542:	1582                	slli	a1,a1,0x20
    80001544:	9181                	srli	a1,a1,0x20
    80001546:	6928                	ld	a0,80(a0)
    80001548:	fffff097          	auipc	ra,0xfffff
    8000154c:	524080e7          	jalr	1316(ra) # 80000a6c <uvmdealloc>
    80001550:	0005079b          	sext.w	a5,a0
    80001554:	bf45                	j	80001504 <growproc+0x26>

0000000080001556 <fork>:
{
    80001556:	7139                	addi	sp,sp,-64
    80001558:	fc06                	sd	ra,56(sp)
    8000155a:	f822                	sd	s0,48(sp)
    8000155c:	f04a                	sd	s2,32(sp)
    8000155e:	e456                	sd	s5,8(sp)
    80001560:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	c22080e7          	jalr	-990(ra) # 80001184 <myproc>
    8000156a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	e22080e7          	jalr	-478(ra) # 8000138e <allocproc>
    80001574:	12050063          	beqz	a0,80001694 <fork+0x13e>
    80001578:	e852                	sd	s4,16(sp)
    8000157a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000157c:	048ab603          	ld	a2,72(s5)
    80001580:	692c                	ld	a1,80(a0)
    80001582:	050ab503          	ld	a0,80(s5)
    80001586:	fffff097          	auipc	ra,0xfffff
    8000158a:	686080e7          	jalr	1670(ra) # 80000c0c <uvmcopy>
    8000158e:	04054a63          	bltz	a0,800015e2 <fork+0x8c>
    80001592:	f426                	sd	s1,40(sp)
    80001594:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001596:	048ab783          	ld	a5,72(s5)
    8000159a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000159e:	058ab683          	ld	a3,88(s5)
    800015a2:	87b6                	mv	a5,a3
    800015a4:	058a3703          	ld	a4,88(s4)
    800015a8:	12068693          	addi	a3,a3,288
    800015ac:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800015b0:	6788                	ld	a0,8(a5)
    800015b2:	6b8c                	ld	a1,16(a5)
    800015b4:	6f90                	ld	a2,24(a5)
    800015b6:	01073023          	sd	a6,0(a4)
    800015ba:	e708                	sd	a0,8(a4)
    800015bc:	eb0c                	sd	a1,16(a4)
    800015be:	ef10                	sd	a2,24(a4)
    800015c0:	02078793          	addi	a5,a5,32
    800015c4:	02070713          	addi	a4,a4,32
    800015c8:	fed792e3          	bne	a5,a3,800015ac <fork+0x56>
  np->trapframe->a0 = 0;
    800015cc:	058a3783          	ld	a5,88(s4)
    800015d0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800015d4:	0d0a8493          	addi	s1,s5,208
    800015d8:	0d0a0913          	addi	s2,s4,208
    800015dc:	150a8993          	addi	s3,s5,336
    800015e0:	a015                	j	80001604 <fork+0xae>
    freeproc(np);
    800015e2:	8552                	mv	a0,s4
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	d52080e7          	jalr	-686(ra) # 80001336 <freeproc>
    release(&np->lock);
    800015ec:	8552                	mv	a0,s4
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	fec080e7          	jalr	-20(ra) # 800065da <release>
    return -1;
    800015f6:	597d                	li	s2,-1
    800015f8:	6a42                	ld	s4,16(sp)
    800015fa:	a071                	j	80001686 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800015fc:	04a1                	addi	s1,s1,8
    800015fe:	0921                	addi	s2,s2,8
    80001600:	01348b63          	beq	s1,s3,80001616 <fork+0xc0>
    if(p->ofile[i])
    80001604:	6088                	ld	a0,0(s1)
    80001606:	d97d                	beqz	a0,800015fc <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001608:	00002097          	auipc	ra,0x2
    8000160c:	682080e7          	jalr	1666(ra) # 80003c8a <filedup>
    80001610:	00a93023          	sd	a0,0(s2)
    80001614:	b7e5                	j	800015fc <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001616:	150ab503          	ld	a0,336(s5)
    8000161a:	00001097          	auipc	ra,0x1
    8000161e:	7e8080e7          	jalr	2024(ra) # 80002e02 <idup>
    80001622:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001626:	4641                	li	a2,16
    80001628:	158a8593          	addi	a1,s5,344
    8000162c:	158a0513          	addi	a0,s4,344
    80001630:	fffff097          	auipc	ra,0xfffff
    80001634:	e84080e7          	jalr	-380(ra) # 800004b4 <safestrcpy>
  pid = np->pid;
    80001638:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000163c:	8552                	mv	a0,s4
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	f9c080e7          	jalr	-100(ra) # 800065da <release>
  acquire(&wait_lock);
    80001646:	0000b497          	auipc	s1,0xb
    8000164a:	a3a48493          	addi	s1,s1,-1478 # 8000c080 <wait_lock>
    8000164e:	8526                	mv	a0,s1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	ed6080e7          	jalr	-298(ra) # 80006526 <acquire>
  np->parent = p;
    80001658:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	f7c080e7          	jalr	-132(ra) # 800065da <release>
  acquire(&np->lock);
    80001666:	8552                	mv	a0,s4
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	ebe080e7          	jalr	-322(ra) # 80006526 <acquire>
  np->state = RUNNABLE;
    80001670:	478d                	li	a5,3
    80001672:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001676:	8552                	mv	a0,s4
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	f62080e7          	jalr	-158(ra) # 800065da <release>
  return pid;
    80001680:	74a2                	ld	s1,40(sp)
    80001682:	69e2                	ld	s3,24(sp)
    80001684:	6a42                	ld	s4,16(sp)
}
    80001686:	854a                	mv	a0,s2
    80001688:	70e2                	ld	ra,56(sp)
    8000168a:	7442                	ld	s0,48(sp)
    8000168c:	7902                	ld	s2,32(sp)
    8000168e:	6aa2                	ld	s5,8(sp)
    80001690:	6121                	addi	sp,sp,64
    80001692:	8082                	ret
    return -1;
    80001694:	597d                	li	s2,-1
    80001696:	bfc5                	j	80001686 <fork+0x130>

0000000080001698 <scheduler>:
{
    80001698:	7139                	addi	sp,sp,-64
    8000169a:	fc06                	sd	ra,56(sp)
    8000169c:	f822                	sd	s0,48(sp)
    8000169e:	f426                	sd	s1,40(sp)
    800016a0:	f04a                	sd	s2,32(sp)
    800016a2:	ec4e                	sd	s3,24(sp)
    800016a4:	e852                	sd	s4,16(sp)
    800016a6:	e456                	sd	s5,8(sp)
    800016a8:	e05a                	sd	s6,0(sp)
    800016aa:	0080                	addi	s0,sp,64
    800016ac:	8792                	mv	a5,tp
  int id = r_tp();
    800016ae:	2781                	sext.w	a5,a5
  c->proc = 0;
    800016b0:	00779a93          	slli	s5,a5,0x7
    800016b4:	0000b717          	auipc	a4,0xb
    800016b8:	9b470713          	addi	a4,a4,-1612 # 8000c068 <pid_lock>
    800016bc:	9756                	add	a4,a4,s5
    800016be:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800016c2:	0000b717          	auipc	a4,0xb
    800016c6:	9de70713          	addi	a4,a4,-1570 # 8000c0a0 <cpus+0x8>
    800016ca:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800016cc:	498d                	li	s3,3
        p->state = RUNNING;
    800016ce:	4b11                	li	s6,4
        c->proc = p;
    800016d0:	079e                	slli	a5,a5,0x7
    800016d2:	0000ba17          	auipc	s4,0xb
    800016d6:	996a0a13          	addi	s4,s4,-1642 # 8000c068 <pid_lock>
    800016da:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800016dc:	00010917          	auipc	s2,0x10
    800016e0:	7bc90913          	addi	s2,s2,1980 # 80011e98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800016e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800016ec:	10079073          	csrw	sstatus,a5
    800016f0:	0000b497          	auipc	s1,0xb
    800016f4:	da848493          	addi	s1,s1,-600 # 8000c498 <proc>
    800016f8:	a811                	j	8000170c <scheduler+0x74>
      release(&p->lock);
    800016fa:	8526                	mv	a0,s1
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	ede080e7          	jalr	-290(ra) # 800065da <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001704:	16848493          	addi	s1,s1,360
    80001708:	fd248ee3          	beq	s1,s2,800016e4 <scheduler+0x4c>
      acquire(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	e18080e7          	jalr	-488(ra) # 80006526 <acquire>
      if(p->state == RUNNABLE) {
    80001716:	4c9c                	lw	a5,24(s1)
    80001718:	ff3791e3          	bne	a5,s3,800016fa <scheduler+0x62>
        p->state = RUNNING;
    8000171c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001720:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001724:	06048593          	addi	a1,s1,96
    80001728:	8556                	mv	a0,s5
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	620080e7          	jalr	1568(ra) # 80001d4a <swtch>
        c->proc = 0;
    80001732:	020a3823          	sd	zero,48(s4)
    80001736:	b7d1                	j	800016fa <scheduler+0x62>

0000000080001738 <sched>:
{
    80001738:	7179                	addi	sp,sp,-48
    8000173a:	f406                	sd	ra,40(sp)
    8000173c:	f022                	sd	s0,32(sp)
    8000173e:	ec26                	sd	s1,24(sp)
    80001740:	e84a                	sd	s2,16(sp)
    80001742:	e44e                	sd	s3,8(sp)
    80001744:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	a3e080e7          	jalr	-1474(ra) # 80001184 <myproc>
    8000174e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001750:	00005097          	auipc	ra,0x5
    80001754:	d5c080e7          	jalr	-676(ra) # 800064ac <holding>
    80001758:	c93d                	beqz	a0,800017ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000175a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000175c:	2781                	sext.w	a5,a5
    8000175e:	079e                	slli	a5,a5,0x7
    80001760:	0000b717          	auipc	a4,0xb
    80001764:	90870713          	addi	a4,a4,-1784 # 8000c068 <pid_lock>
    80001768:	97ba                	add	a5,a5,a4
    8000176a:	0a87a703          	lw	a4,168(a5)
    8000176e:	4785                	li	a5,1
    80001770:	06f71763          	bne	a4,a5,800017de <sched+0xa6>
  if(p->state == RUNNING)
    80001774:	4c98                	lw	a4,24(s1)
    80001776:	4791                	li	a5,4
    80001778:	06f70b63          	beq	a4,a5,800017ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000177c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001780:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001782:	efb5                	bnez	a5,800017fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001784:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001786:	0000b917          	auipc	s2,0xb
    8000178a:	8e290913          	addi	s2,s2,-1822 # 8000c068 <pid_lock>
    8000178e:	2781                	sext.w	a5,a5
    80001790:	079e                	slli	a5,a5,0x7
    80001792:	97ca                	add	a5,a5,s2
    80001794:	0ac7a983          	lw	s3,172(a5)
    80001798:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000179a:	2781                	sext.w	a5,a5
    8000179c:	079e                	slli	a5,a5,0x7
    8000179e:	0000b597          	auipc	a1,0xb
    800017a2:	90258593          	addi	a1,a1,-1790 # 8000c0a0 <cpus+0x8>
    800017a6:	95be                	add	a1,a1,a5
    800017a8:	06048513          	addi	a0,s1,96
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	59e080e7          	jalr	1438(ra) # 80001d4a <swtch>
    800017b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800017b6:	2781                	sext.w	a5,a5
    800017b8:	079e                	slli	a5,a5,0x7
    800017ba:	993e                	add	s2,s2,a5
    800017bc:	0b392623          	sw	s3,172(s2)
}
    800017c0:	70a2                	ld	ra,40(sp)
    800017c2:	7402                	ld	s0,32(sp)
    800017c4:	64e2                	ld	s1,24(sp)
    800017c6:	6942                	ld	s2,16(sp)
    800017c8:	69a2                	ld	s3,8(sp)
    800017ca:	6145                	addi	sp,sp,48
    800017cc:	8082                	ret
    panic("sched p->lock");
    800017ce:	00007517          	auipc	a0,0x7
    800017d2:	9fa50513          	addi	a0,a0,-1542 # 800081c8 <etext+0x1c8>
    800017d6:	00004097          	auipc	ra,0x4
    800017da:	7d6080e7          	jalr	2006(ra) # 80005fac <panic>
    panic("sched locks");
    800017de:	00007517          	auipc	a0,0x7
    800017e2:	9fa50513          	addi	a0,a0,-1542 # 800081d8 <etext+0x1d8>
    800017e6:	00004097          	auipc	ra,0x4
    800017ea:	7c6080e7          	jalr	1990(ra) # 80005fac <panic>
    panic("sched running");
    800017ee:	00007517          	auipc	a0,0x7
    800017f2:	9fa50513          	addi	a0,a0,-1542 # 800081e8 <etext+0x1e8>
    800017f6:	00004097          	auipc	ra,0x4
    800017fa:	7b6080e7          	jalr	1974(ra) # 80005fac <panic>
    panic("sched interruptible");
    800017fe:	00007517          	auipc	a0,0x7
    80001802:	9fa50513          	addi	a0,a0,-1542 # 800081f8 <etext+0x1f8>
    80001806:	00004097          	auipc	ra,0x4
    8000180a:	7a6080e7          	jalr	1958(ra) # 80005fac <panic>

000000008000180e <yield>:
{
    8000180e:	1101                	addi	sp,sp,-32
    80001810:	ec06                	sd	ra,24(sp)
    80001812:	e822                	sd	s0,16(sp)
    80001814:	e426                	sd	s1,8(sp)
    80001816:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001818:	00000097          	auipc	ra,0x0
    8000181c:	96c080e7          	jalr	-1684(ra) # 80001184 <myproc>
    80001820:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001822:	00005097          	auipc	ra,0x5
    80001826:	d04080e7          	jalr	-764(ra) # 80006526 <acquire>
  p->state = RUNNABLE;
    8000182a:	478d                	li	a5,3
    8000182c:	cc9c                	sw	a5,24(s1)
  sched();
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	f0a080e7          	jalr	-246(ra) # 80001738 <sched>
  release(&p->lock);
    80001836:	8526                	mv	a0,s1
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	da2080e7          	jalr	-606(ra) # 800065da <release>
}
    80001840:	60e2                	ld	ra,24(sp)
    80001842:	6442                	ld	s0,16(sp)
    80001844:	64a2                	ld	s1,8(sp)
    80001846:	6105                	addi	sp,sp,32
    80001848:	8082                	ret

000000008000184a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000184a:	7179                	addi	sp,sp,-48
    8000184c:	f406                	sd	ra,40(sp)
    8000184e:	f022                	sd	s0,32(sp)
    80001850:	ec26                	sd	s1,24(sp)
    80001852:	e84a                	sd	s2,16(sp)
    80001854:	e44e                	sd	s3,8(sp)
    80001856:	1800                	addi	s0,sp,48
    80001858:	89aa                	mv	s3,a0
    8000185a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	928080e7          	jalr	-1752(ra) # 80001184 <myproc>
    80001864:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	cc0080e7          	jalr	-832(ra) # 80006526 <acquire>
  release(lk);
    8000186e:	854a                	mv	a0,s2
    80001870:	00005097          	auipc	ra,0x5
    80001874:	d6a080e7          	jalr	-662(ra) # 800065da <release>

  // Go to sleep.
  p->chan = chan;
    80001878:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000187c:	4789                	li	a5,2
    8000187e:	cc9c                	sw	a5,24(s1)

  sched();
    80001880:	00000097          	auipc	ra,0x0
    80001884:	eb8080e7          	jalr	-328(ra) # 80001738 <sched>

  // Tidy up.
  p->chan = 0;
    80001888:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	d4c080e7          	jalr	-692(ra) # 800065da <release>
  acquire(lk);
    80001896:	854a                	mv	a0,s2
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	c8e080e7          	jalr	-882(ra) # 80006526 <acquire>
}
    800018a0:	70a2                	ld	ra,40(sp)
    800018a2:	7402                	ld	s0,32(sp)
    800018a4:	64e2                	ld	s1,24(sp)
    800018a6:	6942                	ld	s2,16(sp)
    800018a8:	69a2                	ld	s3,8(sp)
    800018aa:	6145                	addi	sp,sp,48
    800018ac:	8082                	ret

00000000800018ae <wait>:
{
    800018ae:	715d                	addi	sp,sp,-80
    800018b0:	e486                	sd	ra,72(sp)
    800018b2:	e0a2                	sd	s0,64(sp)
    800018b4:	fc26                	sd	s1,56(sp)
    800018b6:	f84a                	sd	s2,48(sp)
    800018b8:	f44e                	sd	s3,40(sp)
    800018ba:	f052                	sd	s4,32(sp)
    800018bc:	ec56                	sd	s5,24(sp)
    800018be:	e85a                	sd	s6,16(sp)
    800018c0:	e45e                	sd	s7,8(sp)
    800018c2:	e062                	sd	s8,0(sp)
    800018c4:	0880                	addi	s0,sp,80
    800018c6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018c8:	00000097          	auipc	ra,0x0
    800018cc:	8bc080e7          	jalr	-1860(ra) # 80001184 <myproc>
    800018d0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018d2:	0000a517          	auipc	a0,0xa
    800018d6:	7ae50513          	addi	a0,a0,1966 # 8000c080 <wait_lock>
    800018da:	00005097          	auipc	ra,0x5
    800018de:	c4c080e7          	jalr	-948(ra) # 80006526 <acquire>
    havekids = 0;
    800018e2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800018e4:	4a15                	li	s4,5
        havekids = 1;
    800018e6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800018e8:	00010997          	auipc	s3,0x10
    800018ec:	5b098993          	addi	s3,s3,1456 # 80011e98 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f0:	0000ac17          	auipc	s8,0xa
    800018f4:	790c0c13          	addi	s8,s8,1936 # 8000c080 <wait_lock>
    800018f8:	a87d                	j	800019b6 <wait+0x108>
          pid = np->pid;
    800018fa:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800018fe:	000b0e63          	beqz	s6,8000191a <wait+0x6c>
    80001902:	4691                	li	a3,4
    80001904:	02c48613          	addi	a2,s1,44
    80001908:	85da                	mv	a1,s6
    8000190a:	05093503          	ld	a0,80(s2)
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	62a080e7          	jalr	1578(ra) # 80000f38 <copyout>
    80001916:	04054163          	bltz	a0,80001958 <wait+0xaa>
          freeproc(np);
    8000191a:	8526                	mv	a0,s1
    8000191c:	00000097          	auipc	ra,0x0
    80001920:	a1a080e7          	jalr	-1510(ra) # 80001336 <freeproc>
          release(&np->lock);
    80001924:	8526                	mv	a0,s1
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	cb4080e7          	jalr	-844(ra) # 800065da <release>
          release(&wait_lock);
    8000192e:	0000a517          	auipc	a0,0xa
    80001932:	75250513          	addi	a0,a0,1874 # 8000c080 <wait_lock>
    80001936:	00005097          	auipc	ra,0x5
    8000193a:	ca4080e7          	jalr	-860(ra) # 800065da <release>
}
    8000193e:	854e                	mv	a0,s3
    80001940:	60a6                	ld	ra,72(sp)
    80001942:	6406                	ld	s0,64(sp)
    80001944:	74e2                	ld	s1,56(sp)
    80001946:	7942                	ld	s2,48(sp)
    80001948:	79a2                	ld	s3,40(sp)
    8000194a:	7a02                	ld	s4,32(sp)
    8000194c:	6ae2                	ld	s5,24(sp)
    8000194e:	6b42                	ld	s6,16(sp)
    80001950:	6ba2                	ld	s7,8(sp)
    80001952:	6c02                	ld	s8,0(sp)
    80001954:	6161                	addi	sp,sp,80
    80001956:	8082                	ret
            release(&np->lock);
    80001958:	8526                	mv	a0,s1
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	c80080e7          	jalr	-896(ra) # 800065da <release>
            release(&wait_lock);
    80001962:	0000a517          	auipc	a0,0xa
    80001966:	71e50513          	addi	a0,a0,1822 # 8000c080 <wait_lock>
    8000196a:	00005097          	auipc	ra,0x5
    8000196e:	c70080e7          	jalr	-912(ra) # 800065da <release>
            return -1;
    80001972:	59fd                	li	s3,-1
    80001974:	b7e9                	j	8000193e <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001976:	16848493          	addi	s1,s1,360
    8000197a:	03348463          	beq	s1,s3,800019a2 <wait+0xf4>
      if(np->parent == p){
    8000197e:	7c9c                	ld	a5,56(s1)
    80001980:	ff279be3          	bne	a5,s2,80001976 <wait+0xc8>
        acquire(&np->lock);
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	ba0080e7          	jalr	-1120(ra) # 80006526 <acquire>
        if(np->state == ZOMBIE){
    8000198e:	4c9c                	lw	a5,24(s1)
    80001990:	f74785e3          	beq	a5,s4,800018fa <wait+0x4c>
        release(&np->lock);
    80001994:	8526                	mv	a0,s1
    80001996:	00005097          	auipc	ra,0x5
    8000199a:	c44080e7          	jalr	-956(ra) # 800065da <release>
        havekids = 1;
    8000199e:	8756                	mv	a4,s5
    800019a0:	bfd9                	j	80001976 <wait+0xc8>
    if(!havekids || p->killed){
    800019a2:	c305                	beqz	a4,800019c2 <wait+0x114>
    800019a4:	02892783          	lw	a5,40(s2)
    800019a8:	ef89                	bnez	a5,800019c2 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019aa:	85e2                	mv	a1,s8
    800019ac:	854a                	mv	a0,s2
    800019ae:	00000097          	auipc	ra,0x0
    800019b2:	e9c080e7          	jalr	-356(ra) # 8000184a <sleep>
    havekids = 0;
    800019b6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800019b8:	0000b497          	auipc	s1,0xb
    800019bc:	ae048493          	addi	s1,s1,-1312 # 8000c498 <proc>
    800019c0:	bf7d                	j	8000197e <wait+0xd0>
      release(&wait_lock);
    800019c2:	0000a517          	auipc	a0,0xa
    800019c6:	6be50513          	addi	a0,a0,1726 # 8000c080 <wait_lock>
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	c10080e7          	jalr	-1008(ra) # 800065da <release>
      return -1;
    800019d2:	59fd                	li	s3,-1
    800019d4:	b7ad                	j	8000193e <wait+0x90>

00000000800019d6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800019d6:	7139                	addi	sp,sp,-64
    800019d8:	fc06                	sd	ra,56(sp)
    800019da:	f822                	sd	s0,48(sp)
    800019dc:	f426                	sd	s1,40(sp)
    800019de:	f04a                	sd	s2,32(sp)
    800019e0:	ec4e                	sd	s3,24(sp)
    800019e2:	e852                	sd	s4,16(sp)
    800019e4:	e456                	sd	s5,8(sp)
    800019e6:	0080                	addi	s0,sp,64
    800019e8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800019ea:	0000b497          	auipc	s1,0xb
    800019ee:	aae48493          	addi	s1,s1,-1362 # 8000c498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800019f2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800019f4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f6:	00010917          	auipc	s2,0x10
    800019fa:	4a290913          	addi	s2,s2,1186 # 80011e98 <tickslock>
    800019fe:	a811                	j	80001a12 <wakeup+0x3c>
      }
      release(&p->lock);
    80001a00:	8526                	mv	a0,s1
    80001a02:	00005097          	auipc	ra,0x5
    80001a06:	bd8080e7          	jalr	-1064(ra) # 800065da <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a0a:	16848493          	addi	s1,s1,360
    80001a0e:	03248663          	beq	s1,s2,80001a3a <wakeup+0x64>
    if(p != myproc()){
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	772080e7          	jalr	1906(ra) # 80001184 <myproc>
    80001a1a:	fea488e3          	beq	s1,a0,80001a0a <wakeup+0x34>
      acquire(&p->lock);
    80001a1e:	8526                	mv	a0,s1
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	b06080e7          	jalr	-1274(ra) # 80006526 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001a28:	4c9c                	lw	a5,24(s1)
    80001a2a:	fd379be3          	bne	a5,s3,80001a00 <wakeup+0x2a>
    80001a2e:	709c                	ld	a5,32(s1)
    80001a30:	fd4798e3          	bne	a5,s4,80001a00 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001a34:	0154ac23          	sw	s5,24(s1)
    80001a38:	b7e1                	j	80001a00 <wakeup+0x2a>
    }
  }
}
    80001a3a:	70e2                	ld	ra,56(sp)
    80001a3c:	7442                	ld	s0,48(sp)
    80001a3e:	74a2                	ld	s1,40(sp)
    80001a40:	7902                	ld	s2,32(sp)
    80001a42:	69e2                	ld	s3,24(sp)
    80001a44:	6a42                	ld	s4,16(sp)
    80001a46:	6aa2                	ld	s5,8(sp)
    80001a48:	6121                	addi	sp,sp,64
    80001a4a:	8082                	ret

0000000080001a4c <reparent>:
{
    80001a4c:	7179                	addi	sp,sp,-48
    80001a4e:	f406                	sd	ra,40(sp)
    80001a50:	f022                	sd	s0,32(sp)
    80001a52:	ec26                	sd	s1,24(sp)
    80001a54:	e84a                	sd	s2,16(sp)
    80001a56:	e44e                	sd	s3,8(sp)
    80001a58:	e052                	sd	s4,0(sp)
    80001a5a:	1800                	addi	s0,sp,48
    80001a5c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a5e:	0000b497          	auipc	s1,0xb
    80001a62:	a3a48493          	addi	s1,s1,-1478 # 8000c498 <proc>
      pp->parent = initproc;
    80001a66:	0000aa17          	auipc	s4,0xa
    80001a6a:	5aaa0a13          	addi	s4,s4,1450 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a6e:	00010997          	auipc	s3,0x10
    80001a72:	42a98993          	addi	s3,s3,1066 # 80011e98 <tickslock>
    80001a76:	a029                	j	80001a80 <reparent+0x34>
    80001a78:	16848493          	addi	s1,s1,360
    80001a7c:	01348d63          	beq	s1,s3,80001a96 <reparent+0x4a>
    if(pp->parent == p){
    80001a80:	7c9c                	ld	a5,56(s1)
    80001a82:	ff279be3          	bne	a5,s2,80001a78 <reparent+0x2c>
      pp->parent = initproc;
    80001a86:	000a3503          	ld	a0,0(s4)
    80001a8a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001a8c:	00000097          	auipc	ra,0x0
    80001a90:	f4a080e7          	jalr	-182(ra) # 800019d6 <wakeup>
    80001a94:	b7d5                	j	80001a78 <reparent+0x2c>
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret

0000000080001aa6 <exit>:
{
    80001aa6:	7179                	addi	sp,sp,-48
    80001aa8:	f406                	sd	ra,40(sp)
    80001aaa:	f022                	sd	s0,32(sp)
    80001aac:	ec26                	sd	s1,24(sp)
    80001aae:	e84a                	sd	s2,16(sp)
    80001ab0:	e44e                	sd	s3,8(sp)
    80001ab2:	e052                	sd	s4,0(sp)
    80001ab4:	1800                	addi	s0,sp,48
    80001ab6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	6cc080e7          	jalr	1740(ra) # 80001184 <myproc>
    80001ac0:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ac2:	0000a797          	auipc	a5,0xa
    80001ac6:	54e7b783          	ld	a5,1358(a5) # 8000c010 <initproc>
    80001aca:	0d050493          	addi	s1,a0,208
    80001ace:	15050913          	addi	s2,a0,336
    80001ad2:	02a79363          	bne	a5,a0,80001af8 <exit+0x52>
    panic("init exiting");
    80001ad6:	00006517          	auipc	a0,0x6
    80001ada:	73a50513          	addi	a0,a0,1850 # 80008210 <etext+0x210>
    80001ade:	00004097          	auipc	ra,0x4
    80001ae2:	4ce080e7          	jalr	1230(ra) # 80005fac <panic>
      fileclose(f);
    80001ae6:	00002097          	auipc	ra,0x2
    80001aea:	1f6080e7          	jalr	502(ra) # 80003cdc <fileclose>
      p->ofile[fd] = 0;
    80001aee:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001af2:	04a1                	addi	s1,s1,8
    80001af4:	01248563          	beq	s1,s2,80001afe <exit+0x58>
    if(p->ofile[fd]){
    80001af8:	6088                	ld	a0,0(s1)
    80001afa:	f575                	bnez	a0,80001ae6 <exit+0x40>
    80001afc:	bfdd                	j	80001af2 <exit+0x4c>
  begin_op();
    80001afe:	00002097          	auipc	ra,0x2
    80001b02:	d14080e7          	jalr	-748(ra) # 80003812 <begin_op>
  iput(p->cwd);
    80001b06:	1509b503          	ld	a0,336(s3)
    80001b0a:	00001097          	auipc	ra,0x1
    80001b0e:	4f4080e7          	jalr	1268(ra) # 80002ffe <iput>
  end_op();
    80001b12:	00002097          	auipc	ra,0x2
    80001b16:	d7a080e7          	jalr	-646(ra) # 8000388c <end_op>
  p->cwd = 0;
    80001b1a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001b1e:	0000a497          	auipc	s1,0xa
    80001b22:	56248493          	addi	s1,s1,1378 # 8000c080 <wait_lock>
    80001b26:	8526                	mv	a0,s1
    80001b28:	00005097          	auipc	ra,0x5
    80001b2c:	9fe080e7          	jalr	-1538(ra) # 80006526 <acquire>
  reparent(p);
    80001b30:	854e                	mv	a0,s3
    80001b32:	00000097          	auipc	ra,0x0
    80001b36:	f1a080e7          	jalr	-230(ra) # 80001a4c <reparent>
  wakeup(p->parent);
    80001b3a:	0389b503          	ld	a0,56(s3)
    80001b3e:	00000097          	auipc	ra,0x0
    80001b42:	e98080e7          	jalr	-360(ra) # 800019d6 <wakeup>
  acquire(&p->lock);
    80001b46:	854e                	mv	a0,s3
    80001b48:	00005097          	auipc	ra,0x5
    80001b4c:	9de080e7          	jalr	-1570(ra) # 80006526 <acquire>
  p->xstate = status;
    80001b50:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001b54:	4795                	li	a5,5
    80001b56:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	00005097          	auipc	ra,0x5
    80001b60:	a7e080e7          	jalr	-1410(ra) # 800065da <release>
  sched();
    80001b64:	00000097          	auipc	ra,0x0
    80001b68:	bd4080e7          	jalr	-1068(ra) # 80001738 <sched>
  panic("zombie exit");
    80001b6c:	00006517          	auipc	a0,0x6
    80001b70:	6b450513          	addi	a0,a0,1716 # 80008220 <etext+0x220>
    80001b74:	00004097          	auipc	ra,0x4
    80001b78:	438080e7          	jalr	1080(ra) # 80005fac <panic>

0000000080001b7c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001b7c:	7179                	addi	sp,sp,-48
    80001b7e:	f406                	sd	ra,40(sp)
    80001b80:	f022                	sd	s0,32(sp)
    80001b82:	ec26                	sd	s1,24(sp)
    80001b84:	e84a                	sd	s2,16(sp)
    80001b86:	e44e                	sd	s3,8(sp)
    80001b88:	1800                	addi	s0,sp,48
    80001b8a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b8c:	0000b497          	auipc	s1,0xb
    80001b90:	90c48493          	addi	s1,s1,-1780 # 8000c498 <proc>
    80001b94:	00010997          	auipc	s3,0x10
    80001b98:	30498993          	addi	s3,s3,772 # 80011e98 <tickslock>
    acquire(&p->lock);
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	00005097          	auipc	ra,0x5
    80001ba2:	988080e7          	jalr	-1656(ra) # 80006526 <acquire>
    if(p->pid == pid){
    80001ba6:	589c                	lw	a5,48(s1)
    80001ba8:	01278d63          	beq	a5,s2,80001bc2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001bac:	8526                	mv	a0,s1
    80001bae:	00005097          	auipc	ra,0x5
    80001bb2:	a2c080e7          	jalr	-1492(ra) # 800065da <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bb6:	16848493          	addi	s1,s1,360
    80001bba:	ff3491e3          	bne	s1,s3,80001b9c <kill+0x20>
  }
  return -1;
    80001bbe:	557d                	li	a0,-1
    80001bc0:	a829                	j	80001bda <kill+0x5e>
      p->killed = 1;
    80001bc2:	4785                	li	a5,1
    80001bc4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001bc6:	4c98                	lw	a4,24(s1)
    80001bc8:	4789                	li	a5,2
    80001bca:	00f70f63          	beq	a4,a5,80001be8 <kill+0x6c>
      release(&p->lock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	00005097          	auipc	ra,0x5
    80001bd4:	a0a080e7          	jalr	-1526(ra) # 800065da <release>
      return 0;
    80001bd8:	4501                	li	a0,0
}
    80001bda:	70a2                	ld	ra,40(sp)
    80001bdc:	7402                	ld	s0,32(sp)
    80001bde:	64e2                	ld	s1,24(sp)
    80001be0:	6942                	ld	s2,16(sp)
    80001be2:	69a2                	ld	s3,8(sp)
    80001be4:	6145                	addi	sp,sp,48
    80001be6:	8082                	ret
        p->state = RUNNABLE;
    80001be8:	478d                	li	a5,3
    80001bea:	cc9c                	sw	a5,24(s1)
    80001bec:	b7cd                	j	80001bce <kill+0x52>

0000000080001bee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001bee:	7179                	addi	sp,sp,-48
    80001bf0:	f406                	sd	ra,40(sp)
    80001bf2:	f022                	sd	s0,32(sp)
    80001bf4:	ec26                	sd	s1,24(sp)
    80001bf6:	e84a                	sd	s2,16(sp)
    80001bf8:	e44e                	sd	s3,8(sp)
    80001bfa:	e052                	sd	s4,0(sp)
    80001bfc:	1800                	addi	s0,sp,48
    80001bfe:	84aa                	mv	s1,a0
    80001c00:	892e                	mv	s2,a1
    80001c02:	89b2                	mv	s3,a2
    80001c04:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	57e080e7          	jalr	1406(ra) # 80001184 <myproc>
  if(user_dst){
    80001c0e:	c08d                	beqz	s1,80001c30 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001c10:	86d2                	mv	a3,s4
    80001c12:	864e                	mv	a2,s3
    80001c14:	85ca                	mv	a1,s2
    80001c16:	6928                	ld	a0,80(a0)
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	320080e7          	jalr	800(ra) # 80000f38 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001c20:	70a2                	ld	ra,40(sp)
    80001c22:	7402                	ld	s0,32(sp)
    80001c24:	64e2                	ld	s1,24(sp)
    80001c26:	6942                	ld	s2,16(sp)
    80001c28:	69a2                	ld	s3,8(sp)
    80001c2a:	6a02                	ld	s4,0(sp)
    80001c2c:	6145                	addi	sp,sp,48
    80001c2e:	8082                	ret
    memmove((char *)dst, src, len);
    80001c30:	000a061b          	sext.w	a2,s4
    80001c34:	85ce                	mv	a1,s3
    80001c36:	854a                	mv	a0,s2
    80001c38:	ffffe097          	auipc	ra,0xffffe
    80001c3c:	796080e7          	jalr	1942(ra) # 800003ce <memmove>
    return 0;
    80001c40:	8526                	mv	a0,s1
    80001c42:	bff9                	j	80001c20 <either_copyout+0x32>

0000000080001c44 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001c44:	7179                	addi	sp,sp,-48
    80001c46:	f406                	sd	ra,40(sp)
    80001c48:	f022                	sd	s0,32(sp)
    80001c4a:	ec26                	sd	s1,24(sp)
    80001c4c:	e84a                	sd	s2,16(sp)
    80001c4e:	e44e                	sd	s3,8(sp)
    80001c50:	e052                	sd	s4,0(sp)
    80001c52:	1800                	addi	s0,sp,48
    80001c54:	892a                	mv	s2,a0
    80001c56:	84ae                	mv	s1,a1
    80001c58:	89b2                	mv	s3,a2
    80001c5a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	528080e7          	jalr	1320(ra) # 80001184 <myproc>
  if(user_src){
    80001c64:	c08d                	beqz	s1,80001c86 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c66:	86d2                	mv	a3,s4
    80001c68:	864e                	mv	a2,s3
    80001c6a:	85ca                	mv	a1,s2
    80001c6c:	6928                	ld	a0,80(a0)
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	098080e7          	jalr	152(ra) # 80000d06 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	69a2                	ld	s3,8(sp)
    80001c80:	6a02                	ld	s4,0(sp)
    80001c82:	6145                	addi	sp,sp,48
    80001c84:	8082                	ret
    memmove(dst, (char*)src, len);
    80001c86:	000a061b          	sext.w	a2,s4
    80001c8a:	85ce                	mv	a1,s3
    80001c8c:	854a                	mv	a0,s2
    80001c8e:	ffffe097          	auipc	ra,0xffffe
    80001c92:	740080e7          	jalr	1856(ra) # 800003ce <memmove>
    return 0;
    80001c96:	8526                	mv	a0,s1
    80001c98:	bff9                	j	80001c76 <either_copyin+0x32>

0000000080001c9a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c9a:	715d                	addi	sp,sp,-80
    80001c9c:	e486                	sd	ra,72(sp)
    80001c9e:	e0a2                	sd	s0,64(sp)
    80001ca0:	fc26                	sd	s1,56(sp)
    80001ca2:	f84a                	sd	s2,48(sp)
    80001ca4:	f44e                	sd	s3,40(sp)
    80001ca6:	f052                	sd	s4,32(sp)
    80001ca8:	ec56                	sd	s5,24(sp)
    80001caa:	e85a                	sd	s6,16(sp)
    80001cac:	e45e                	sd	s7,8(sp)
    80001cae:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001cb0:	00006517          	auipc	a0,0x6
    80001cb4:	37850513          	addi	a0,a0,888 # 80008028 <etext+0x28>
    80001cb8:	00004097          	auipc	ra,0x4
    80001cbc:	33e080e7          	jalr	830(ra) # 80005ff6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001cc0:	0000b497          	auipc	s1,0xb
    80001cc4:	93048493          	addi	s1,s1,-1744 # 8000c5f0 <proc+0x158>
    80001cc8:	00010917          	auipc	s2,0x10
    80001ccc:	32890913          	addi	s2,s2,808 # 80011ff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cd0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001cd2:	00006997          	auipc	s3,0x6
    80001cd6:	55e98993          	addi	s3,s3,1374 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001cda:	00006a97          	auipc	s5,0x6
    80001cde:	55ea8a93          	addi	s5,s5,1374 # 80008238 <etext+0x238>
    printf("\n");
    80001ce2:	00006a17          	auipc	s4,0x6
    80001ce6:	346a0a13          	addi	s4,s4,838 # 80008028 <etext+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cea:	00007b97          	auipc	s7,0x7
    80001cee:	a66b8b93          	addi	s7,s7,-1434 # 80008750 <states.0>
    80001cf2:	a00d                	j	80001d14 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001cf4:	ed86a583          	lw	a1,-296(a3)
    80001cf8:	8556                	mv	a0,s5
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	2fc080e7          	jalr	764(ra) # 80005ff6 <printf>
    printf("\n");
    80001d02:	8552                	mv	a0,s4
    80001d04:	00004097          	auipc	ra,0x4
    80001d08:	2f2080e7          	jalr	754(ra) # 80005ff6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d0c:	16848493          	addi	s1,s1,360
    80001d10:	03248263          	beq	s1,s2,80001d34 <procdump+0x9a>
    if(p->state == UNUSED)
    80001d14:	86a6                	mv	a3,s1
    80001d16:	ec04a783          	lw	a5,-320(s1)
    80001d1a:	dbed                	beqz	a5,80001d0c <procdump+0x72>
      state = "???";
    80001d1c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d1e:	fcfb6be3          	bltu	s6,a5,80001cf4 <procdump+0x5a>
    80001d22:	02079713          	slli	a4,a5,0x20
    80001d26:	01d75793          	srli	a5,a4,0x1d
    80001d2a:	97de                	add	a5,a5,s7
    80001d2c:	6390                	ld	a2,0(a5)
    80001d2e:	f279                	bnez	a2,80001cf4 <procdump+0x5a>
      state = "???";
    80001d30:	864e                	mv	a2,s3
    80001d32:	b7c9                	j	80001cf4 <procdump+0x5a>
  }
}
    80001d34:	60a6                	ld	ra,72(sp)
    80001d36:	6406                	ld	s0,64(sp)
    80001d38:	74e2                	ld	s1,56(sp)
    80001d3a:	7942                	ld	s2,48(sp)
    80001d3c:	79a2                	ld	s3,40(sp)
    80001d3e:	7a02                	ld	s4,32(sp)
    80001d40:	6ae2                	ld	s5,24(sp)
    80001d42:	6b42                	ld	s6,16(sp)
    80001d44:	6ba2                	ld	s7,8(sp)
    80001d46:	6161                	addi	sp,sp,80
    80001d48:	8082                	ret

0000000080001d4a <swtch>:
    80001d4a:	00153023          	sd	ra,0(a0)
    80001d4e:	00253423          	sd	sp,8(a0)
    80001d52:	e900                	sd	s0,16(a0)
    80001d54:	ed04                	sd	s1,24(a0)
    80001d56:	03253023          	sd	s2,32(a0)
    80001d5a:	03353423          	sd	s3,40(a0)
    80001d5e:	03453823          	sd	s4,48(a0)
    80001d62:	03553c23          	sd	s5,56(a0)
    80001d66:	05653023          	sd	s6,64(a0)
    80001d6a:	05753423          	sd	s7,72(a0)
    80001d6e:	05853823          	sd	s8,80(a0)
    80001d72:	05953c23          	sd	s9,88(a0)
    80001d76:	07a53023          	sd	s10,96(a0)
    80001d7a:	07b53423          	sd	s11,104(a0)
    80001d7e:	0005b083          	ld	ra,0(a1)
    80001d82:	0085b103          	ld	sp,8(a1)
    80001d86:	6980                	ld	s0,16(a1)
    80001d88:	6d84                	ld	s1,24(a1)
    80001d8a:	0205b903          	ld	s2,32(a1)
    80001d8e:	0285b983          	ld	s3,40(a1)
    80001d92:	0305ba03          	ld	s4,48(a1)
    80001d96:	0385ba83          	ld	s5,56(a1)
    80001d9a:	0405bb03          	ld	s6,64(a1)
    80001d9e:	0485bb83          	ld	s7,72(a1)
    80001da2:	0505bc03          	ld	s8,80(a1)
    80001da6:	0585bc83          	ld	s9,88(a1)
    80001daa:	0605bd03          	ld	s10,96(a1)
    80001dae:	0685bd83          	ld	s11,104(a1)
    80001db2:	8082                	ret

0000000080001db4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001db4:	1141                	addi	sp,sp,-16
    80001db6:	e406                	sd	ra,8(sp)
    80001db8:	e022                	sd	s0,0(sp)
    80001dba:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001dbc:	00006597          	auipc	a1,0x6
    80001dc0:	4b458593          	addi	a1,a1,1204 # 80008270 <etext+0x270>
    80001dc4:	00010517          	auipc	a0,0x10
    80001dc8:	0d450513          	addi	a0,a0,212 # 80011e98 <tickslock>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	6ca080e7          	jalr	1738(ra) # 80006496 <initlock>
}
    80001dd4:	60a2                	ld	ra,8(sp)
    80001dd6:	6402                	ld	s0,0(sp)
    80001dd8:	0141                	addi	sp,sp,16
    80001dda:	8082                	ret

0000000080001ddc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ddc:	1141                	addi	sp,sp,-16
    80001dde:	e422                	sd	s0,8(sp)
    80001de0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001de2:	00003797          	auipc	a5,0x3
    80001de6:	5de78793          	addi	a5,a5,1502 # 800053c0 <kernelvec>
    80001dea:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001dee:	6422                	ld	s0,8(sp)
    80001df0:	0141                	addi	sp,sp,16
    80001df2:	8082                	ret

0000000080001df4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001df4:	1141                	addi	sp,sp,-16
    80001df6:	e406                	sd	ra,8(sp)
    80001df8:	e022                	sd	s0,0(sp)
    80001dfa:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	388080e7          	jalr	904(ra) # 80001184 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e08:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e0a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001e0e:	00005697          	auipc	a3,0x5
    80001e12:	1f268693          	addi	a3,a3,498 # 80007000 <_trampoline>
    80001e16:	00005717          	auipc	a4,0x5
    80001e1a:	1ea70713          	addi	a4,a4,490 # 80007000 <_trampoline>
    80001e1e:	8f15                	sub	a4,a4,a3
    80001e20:	040007b7          	lui	a5,0x4000
    80001e24:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001e26:	07b2                	slli	a5,a5,0xc
    80001e28:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001e2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001e30:	18002673          	csrr	a2,satp
    80001e34:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001e36:	6d30                	ld	a2,88(a0)
    80001e38:	6138                	ld	a4,64(a0)
    80001e3a:	6585                	lui	a1,0x1
    80001e3c:	972e                	add	a4,a4,a1
    80001e3e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e40:	6d38                	ld	a4,88(a0)
    80001e42:	00000617          	auipc	a2,0x0
    80001e46:	14060613          	addi	a2,a2,320 # 80001f82 <usertrap>
    80001e4a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001e4c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e4e:	8612                	mv	a2,tp
    80001e50:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e52:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001e56:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001e5a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e62:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e64:	6f18                	ld	a4,24(a4)
    80001e66:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e6a:	692c                	ld	a1,80(a0)
    80001e6c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001e6e:	00005717          	auipc	a4,0x5
    80001e72:	22270713          	addi	a4,a4,546 # 80007090 <userret>
    80001e76:	8f15                	sub	a4,a4,a3
    80001e78:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001e7a:	577d                	li	a4,-1
    80001e7c:	177e                	slli	a4,a4,0x3f
    80001e7e:	8dd9                	or	a1,a1,a4
    80001e80:	02000537          	lui	a0,0x2000
    80001e84:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001e86:	0536                	slli	a0,a0,0xd
    80001e88:	9782                	jalr	a5
}
    80001e8a:	60a2                	ld	ra,8(sp)
    80001e8c:	6402                	ld	s0,0(sp)
    80001e8e:	0141                	addi	sp,sp,16
    80001e90:	8082                	ret

0000000080001e92 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e92:	1101                	addi	sp,sp,-32
    80001e94:	ec06                	sd	ra,24(sp)
    80001e96:	e822                	sd	s0,16(sp)
    80001e98:	e426                	sd	s1,8(sp)
    80001e9a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e9c:	00010497          	auipc	s1,0x10
    80001ea0:	ffc48493          	addi	s1,s1,-4 # 80011e98 <tickslock>
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	680080e7          	jalr	1664(ra) # 80006526 <acquire>
  ticks++;
    80001eae:	0000a517          	auipc	a0,0xa
    80001eb2:	16a50513          	addi	a0,a0,362 # 8000c018 <ticks>
    80001eb6:	411c                	lw	a5,0(a0)
    80001eb8:	2785                	addiw	a5,a5,1
    80001eba:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	b1a080e7          	jalr	-1254(ra) # 800019d6 <wakeup>
  release(&tickslock);
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	714080e7          	jalr	1812(ra) # 800065da <release>
}
    80001ece:	60e2                	ld	ra,24(sp)
    80001ed0:	6442                	ld	s0,16(sp)
    80001ed2:	64a2                	ld	s1,8(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret

0000000080001ed8 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed8:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001edc:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ede:	0a07d163          	bgez	a5,80001f80 <devintr+0xa8>
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001eea:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001eee:	46a5                	li	a3,9
    80001ef0:	00d70c63          	beq	a4,a3,80001f08 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001ef4:	577d                	li	a4,-1
    80001ef6:	177e                	slli	a4,a4,0x3f
    80001ef8:	0705                	addi	a4,a4,1
    return 0;
    80001efa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001efc:	06e78163          	beq	a5,a4,80001f5e <devintr+0x86>
  }
}
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	6105                	addi	sp,sp,32
    80001f06:	8082                	ret
    80001f08:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001f0a:	00003097          	auipc	ra,0x3
    80001f0e:	5c2080e7          	jalr	1474(ra) # 800054cc <plic_claim>
    80001f12:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001f14:	47a9                	li	a5,10
    80001f16:	00f50963          	beq	a0,a5,80001f28 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001f1a:	4785                	li	a5,1
    80001f1c:	00f50b63          	beq	a0,a5,80001f32 <devintr+0x5a>
    return 1;
    80001f20:	4505                	li	a0,1
    } else if(irq){
    80001f22:	ec89                	bnez	s1,80001f3c <devintr+0x64>
    80001f24:	64a2                	ld	s1,8(sp)
    80001f26:	bfe9                	j	80001f00 <devintr+0x28>
      uartintr();
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	51e080e7          	jalr	1310(ra) # 80006446 <uartintr>
    if(irq)
    80001f30:	a839                	j	80001f4e <devintr+0x76>
      virtio_disk_intr();
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	a6e080e7          	jalr	-1426(ra) # 800059a0 <virtio_disk_intr>
    if(irq)
    80001f3a:	a811                	j	80001f4e <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f3c:	85a6                	mv	a1,s1
    80001f3e:	00006517          	auipc	a0,0x6
    80001f42:	33a50513          	addi	a0,a0,826 # 80008278 <etext+0x278>
    80001f46:	00004097          	auipc	ra,0x4
    80001f4a:	0b0080e7          	jalr	176(ra) # 80005ff6 <printf>
      plic_complete(irq);
    80001f4e:	8526                	mv	a0,s1
    80001f50:	00003097          	auipc	ra,0x3
    80001f54:	5a0080e7          	jalr	1440(ra) # 800054f0 <plic_complete>
    return 1;
    80001f58:	4505                	li	a0,1
    80001f5a:	64a2                	ld	s1,8(sp)
    80001f5c:	b755                	j	80001f00 <devintr+0x28>
    if(cpuid() == 0){
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	1fa080e7          	jalr	506(ra) # 80001158 <cpuid>
    80001f66:	c901                	beqz	a0,80001f76 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001f68:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f6e:	14479073          	csrw	sip,a5
    return 2;
    80001f72:	4509                	li	a0,2
    80001f74:	b771                	j	80001f00 <devintr+0x28>
      clockintr();
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	f1c080e7          	jalr	-228(ra) # 80001e92 <clockintr>
    80001f7e:	b7ed                	j	80001f68 <devintr+0x90>
}
    80001f80:	8082                	ret

0000000080001f82 <usertrap>:
{
    80001f82:	7179                	addi	sp,sp,-48
    80001f84:	f406                	sd	ra,40(sp)
    80001f86:	f022                	sd	s0,32(sp)
    80001f88:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f8a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f8e:	1007f793          	andi	a5,a5,256
    80001f92:	e7a5                	bnez	a5,80001ffa <usertrap+0x78>
    80001f94:	ec26                	sd	s1,24(sp)
    80001f96:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f98:	00003797          	auipc	a5,0x3
    80001f9c:	42878793          	addi	a5,a5,1064 # 800053c0 <kernelvec>
    80001fa0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	1e0080e7          	jalr	480(ra) # 80001184 <myproc>
    80001fac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001fae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb0:	14102773          	csrr	a4,sepc
    80001fb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fb6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001fba:	47a1                	li	a5,8
    80001fbc:	06f71063          	bne	a4,a5,8000201c <usertrap+0x9a>
    if(p->killed)
    80001fc0:	551c                	lw	a5,40(a0)
    80001fc2:	e7b9                	bnez	a5,80002010 <usertrap+0x8e>
    p->trapframe->epc += 4;
    80001fc4:	6cb8                	ld	a4,88(s1)
    80001fc6:	6f1c                	ld	a5,24(a4)
    80001fc8:	0791                	addi	a5,a5,4
    80001fca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fd0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fd4:	10079073          	csrw	sstatus,a5
    syscall();
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	36a080e7          	jalr	874(ra) # 80002342 <syscall>
  if(p->killed)
    80001fe0:	549c                	lw	a5,40(s1)
    80001fe2:	10079d63          	bnez	a5,800020fc <usertrap+0x17a>
  usertrapret();
    80001fe6:	00000097          	auipc	ra,0x0
    80001fea:	e0e080e7          	jalr	-498(ra) # 80001df4 <usertrapret>
    80001fee:	64e2                	ld	s1,24(sp)
    80001ff0:	6942                	ld	s2,16(sp)
}
    80001ff2:	70a2                	ld	ra,40(sp)
    80001ff4:	7402                	ld	s0,32(sp)
    80001ff6:	6145                	addi	sp,sp,48
    80001ff8:	8082                	ret
    80001ffa:	ec26                	sd	s1,24(sp)
    80001ffc:	e84a                	sd	s2,16(sp)
    80001ffe:	e44e                	sd	s3,8(sp)
    panic("usertrap: not from user mode");
    80002000:	00006517          	auipc	a0,0x6
    80002004:	29850513          	addi	a0,a0,664 # 80008298 <etext+0x298>
    80002008:	00004097          	auipc	ra,0x4
    8000200c:	fa4080e7          	jalr	-92(ra) # 80005fac <panic>
      exit(-1);
    80002010:	557d                	li	a0,-1
    80002012:	00000097          	auipc	ra,0x0
    80002016:	a94080e7          	jalr	-1388(ra) # 80001aa6 <exit>
    8000201a:	b76d                	j	80001fc4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	ebc080e7          	jalr	-324(ra) # 80001ed8 <devintr>
    80002024:	892a                	mv	s2,a0
    80002026:	e961                	bnez	a0,800020f6 <usertrap+0x174>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002028:	14202773          	csrr	a4,scause
  }else if(r_scause() == 15 || r_scause() == 13){
    8000202c:	47bd                	li	a5,15
    8000202e:	00f70763          	beq	a4,a5,8000203c <usertrap+0xba>
    80002032:	14202773          	csrr	a4,scause
    80002036:	47b5                	li	a5,13
    80002038:	06f71963          	bne	a4,a5,800020aa <usertrap+0x128>
    8000203c:	e44e                	sd	s3,8(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000203e:	143029f3          	csrr	s3,stval
    if(is_cow_fault(p->pagetable, va)){
    80002042:	85ce                	mv	a1,s3
    80002044:	68a8                	ld	a0,80(s1)
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	e0a080e7          	jalr	-502(ra) # 80000e50 <is_cow_fault>
    8000204e:	c50d                	beqz	a0,80002078 <usertrap+0xf6>
      if(cow_alloc(p->pagetable, va) < 0){
    80002050:	85ce                	mv	a1,s3
    80002052:	68a8                	ld	a0,80(s1)
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	e42080e7          	jalr	-446(ra) # 80000e96 <cow_alloc>
    8000205c:	00054463          	bltz	a0,80002064 <usertrap+0xe2>
    80002060:	69a2                	ld	s3,8(sp)
    80002062:	bfbd                	j	80001fe0 <usertrap+0x5e>
        printf("usertrap(): cow_alloc failed!\n");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	25450513          	addi	a0,a0,596 # 800082b8 <etext+0x2b8>
    8000206c:	00004097          	auipc	ra,0x4
    80002070:	f8a080e7          	jalr	-118(ra) # 80005ff6 <printf>
        p->killed = 1;
    80002074:	69a2                	ld	s3,8(sp)
    80002076:	a08d                	j	800020d8 <usertrap+0x156>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002078:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000207c:	5890                	lw	a2,48(s1)
    8000207e:	00006517          	auipc	a0,0x6
    80002082:	25a50513          	addi	a0,a0,602 # 800082d8 <etext+0x2d8>
    80002086:	00004097          	auipc	ra,0x4
    8000208a:	f70080e7          	jalr	-144(ra) # 80005ff6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000208e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002092:	14302673          	csrr	a2,stval
      printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	27250513          	addi	a0,a0,626 # 80008308 <etext+0x308>
    8000209e:	00004097          	auipc	ra,0x4
    800020a2:	f58080e7          	jalr	-168(ra) # 80005ff6 <printf>
      p->killed = 1;
    800020a6:	69a2                	ld	s3,8(sp)
    800020a8:	a805                	j	800020d8 <usertrap+0x156>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020aa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800020ae:	5890                	lw	a2,48(s1)
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	22850513          	addi	a0,a0,552 # 800082d8 <etext+0x2d8>
    800020b8:	00004097          	auipc	ra,0x4
    800020bc:	f3e080e7          	jalr	-194(ra) # 80005ff6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020c0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020c4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	24050513          	addi	a0,a0,576 # 80008308 <etext+0x308>
    800020d0:	00004097          	auipc	ra,0x4
    800020d4:	f26080e7          	jalr	-218(ra) # 80005ff6 <printf>
        p->killed = 1;
    800020d8:	4785                	li	a5,1
    800020da:	d49c                	sw	a5,40(s1)
    exit(-1);
    800020dc:	557d                	li	a0,-1
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	9c8080e7          	jalr	-1592(ra) # 80001aa6 <exit>
  if(which_dev == 2)
    800020e6:	4789                	li	a5,2
    800020e8:	eef91fe3          	bne	s2,a5,80001fe6 <usertrap+0x64>
    yield();
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	722080e7          	jalr	1826(ra) # 8000180e <yield>
    800020f4:	bdcd                	j	80001fe6 <usertrap+0x64>
  if(p->killed)
    800020f6:	549c                	lw	a5,40(s1)
    800020f8:	d7fd                	beqz	a5,800020e6 <usertrap+0x164>
    800020fa:	b7cd                	j	800020dc <usertrap+0x15a>
    800020fc:	4901                	li	s2,0
    800020fe:	bff9                	j	800020dc <usertrap+0x15a>

0000000080002100 <kerneltrap>:
{
    80002100:	7179                	addi	sp,sp,-48
    80002102:	f406                	sd	ra,40(sp)
    80002104:	f022                	sd	s0,32(sp)
    80002106:	ec26                	sd	s1,24(sp)
    80002108:	e84a                	sd	s2,16(sp)
    8000210a:	e44e                	sd	s3,8(sp)
    8000210c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000210e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002112:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002116:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000211a:	1004f793          	andi	a5,s1,256
    8000211e:	cb85                	beqz	a5,8000214e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002120:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002124:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002126:	ef85                	bnez	a5,8000215e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	db0080e7          	jalr	-592(ra) # 80001ed8 <devintr>
    80002130:	cd1d                	beqz	a0,8000216e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002132:	4789                	li	a5,2
    80002134:	06f50a63          	beq	a0,a5,800021a8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002138:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000213c:	10049073          	csrw	sstatus,s1
}
    80002140:	70a2                	ld	ra,40(sp)
    80002142:	7402                	ld	s0,32(sp)
    80002144:	64e2                	ld	s1,24(sp)
    80002146:	6942                	ld	s2,16(sp)
    80002148:	69a2                	ld	s3,8(sp)
    8000214a:	6145                	addi	sp,sp,48
    8000214c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000214e:	00006517          	auipc	a0,0x6
    80002152:	1da50513          	addi	a0,a0,474 # 80008328 <etext+0x328>
    80002156:	00004097          	auipc	ra,0x4
    8000215a:	e56080e7          	jalr	-426(ra) # 80005fac <panic>
    panic("kerneltrap: interrupts enabled");
    8000215e:	00006517          	auipc	a0,0x6
    80002162:	1f250513          	addi	a0,a0,498 # 80008350 <etext+0x350>
    80002166:	00004097          	auipc	ra,0x4
    8000216a:	e46080e7          	jalr	-442(ra) # 80005fac <panic>
    printf("scause %p\n", scause);
    8000216e:	85ce                	mv	a1,s3
    80002170:	00006517          	auipc	a0,0x6
    80002174:	20050513          	addi	a0,a0,512 # 80008370 <etext+0x370>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	e7e080e7          	jalr	-386(ra) # 80005ff6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002180:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002184:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002188:	00006517          	auipc	a0,0x6
    8000218c:	1f850513          	addi	a0,a0,504 # 80008380 <etext+0x380>
    80002190:	00004097          	auipc	ra,0x4
    80002194:	e66080e7          	jalr	-410(ra) # 80005ff6 <printf>
    panic("kerneltrap");
    80002198:	00006517          	auipc	a0,0x6
    8000219c:	20050513          	addi	a0,a0,512 # 80008398 <etext+0x398>
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	e0c080e7          	jalr	-500(ra) # 80005fac <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	fdc080e7          	jalr	-36(ra) # 80001184 <myproc>
    800021b0:	d541                	beqz	a0,80002138 <kerneltrap+0x38>
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	fd2080e7          	jalr	-46(ra) # 80001184 <myproc>
    800021ba:	4d18                	lw	a4,24(a0)
    800021bc:	4791                	li	a5,4
    800021be:	f6f71de3          	bne	a4,a5,80002138 <kerneltrap+0x38>
    yield();
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	64c080e7          	jalr	1612(ra) # 8000180e <yield>
    800021ca:	b7bd                	j	80002138 <kerneltrap+0x38>

00000000800021cc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	1000                	addi	s0,sp,32
    800021d6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	fac080e7          	jalr	-84(ra) # 80001184 <myproc>
  switch (n) {
    800021e0:	4795                	li	a5,5
    800021e2:	0497e163          	bltu	a5,s1,80002224 <argraw+0x58>
    800021e6:	048a                	slli	s1,s1,0x2
    800021e8:	00006717          	auipc	a4,0x6
    800021ec:	59870713          	addi	a4,a4,1432 # 80008780 <states.0+0x30>
    800021f0:	94ba                	add	s1,s1,a4
    800021f2:	409c                	lw	a5,0(s1)
    800021f4:	97ba                	add	a5,a5,a4
    800021f6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800021f8:	6d3c                	ld	a5,88(a0)
    800021fa:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021fc:	60e2                	ld	ra,24(sp)
    800021fe:	6442                	ld	s0,16(sp)
    80002200:	64a2                	ld	s1,8(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret
    return p->trapframe->a1;
    80002206:	6d3c                	ld	a5,88(a0)
    80002208:	7fa8                	ld	a0,120(a5)
    8000220a:	bfcd                	j	800021fc <argraw+0x30>
    return p->trapframe->a2;
    8000220c:	6d3c                	ld	a5,88(a0)
    8000220e:	63c8                	ld	a0,128(a5)
    80002210:	b7f5                	j	800021fc <argraw+0x30>
    return p->trapframe->a3;
    80002212:	6d3c                	ld	a5,88(a0)
    80002214:	67c8                	ld	a0,136(a5)
    80002216:	b7dd                	j	800021fc <argraw+0x30>
    return p->trapframe->a4;
    80002218:	6d3c                	ld	a5,88(a0)
    8000221a:	6bc8                	ld	a0,144(a5)
    8000221c:	b7c5                	j	800021fc <argraw+0x30>
    return p->trapframe->a5;
    8000221e:	6d3c                	ld	a5,88(a0)
    80002220:	6fc8                	ld	a0,152(a5)
    80002222:	bfe9                	j	800021fc <argraw+0x30>
  panic("argraw");
    80002224:	00006517          	auipc	a0,0x6
    80002228:	18450513          	addi	a0,a0,388 # 800083a8 <etext+0x3a8>
    8000222c:	00004097          	auipc	ra,0x4
    80002230:	d80080e7          	jalr	-640(ra) # 80005fac <panic>

0000000080002234 <fetchaddr>:
{
    80002234:	1101                	addi	sp,sp,-32
    80002236:	ec06                	sd	ra,24(sp)
    80002238:	e822                	sd	s0,16(sp)
    8000223a:	e426                	sd	s1,8(sp)
    8000223c:	e04a                	sd	s2,0(sp)
    8000223e:	1000                	addi	s0,sp,32
    80002240:	84aa                	mv	s1,a0
    80002242:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	f40080e7          	jalr	-192(ra) # 80001184 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000224c:	653c                	ld	a5,72(a0)
    8000224e:	02f4f863          	bgeu	s1,a5,8000227e <fetchaddr+0x4a>
    80002252:	00848713          	addi	a4,s1,8
    80002256:	02e7e663          	bltu	a5,a4,80002282 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000225a:	46a1                	li	a3,8
    8000225c:	8626                	mv	a2,s1
    8000225e:	85ca                	mv	a1,s2
    80002260:	6928                	ld	a0,80(a0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	aa4080e7          	jalr	-1372(ra) # 80000d06 <copyin>
    8000226a:	00a03533          	snez	a0,a0
    8000226e:	40a00533          	neg	a0,a0
}
    80002272:	60e2                	ld	ra,24(sp)
    80002274:	6442                	ld	s0,16(sp)
    80002276:	64a2                	ld	s1,8(sp)
    80002278:	6902                	ld	s2,0(sp)
    8000227a:	6105                	addi	sp,sp,32
    8000227c:	8082                	ret
    return -1;
    8000227e:	557d                	li	a0,-1
    80002280:	bfcd                	j	80002272 <fetchaddr+0x3e>
    80002282:	557d                	li	a0,-1
    80002284:	b7fd                	j	80002272 <fetchaddr+0x3e>

0000000080002286 <fetchstr>:
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	ec26                	sd	s1,24(sp)
    8000228e:	e84a                	sd	s2,16(sp)
    80002290:	e44e                	sd	s3,8(sp)
    80002292:	1800                	addi	s0,sp,48
    80002294:	892a                	mv	s2,a0
    80002296:	84ae                	mv	s1,a1
    80002298:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	eea080e7          	jalr	-278(ra) # 80001184 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800022a2:	86ce                	mv	a3,s3
    800022a4:	864a                	mv	a2,s2
    800022a6:	85a6                	mv	a1,s1
    800022a8:	6928                	ld	a0,80(a0)
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	aea080e7          	jalr	-1302(ra) # 80000d94 <copyinstr>
  if(err < 0)
    800022b2:	00054763          	bltz	a0,800022c0 <fetchstr+0x3a>
  return strlen(buf);
    800022b6:	8526                	mv	a0,s1
    800022b8:	ffffe097          	auipc	ra,0xffffe
    800022bc:	22e080e7          	jalr	558(ra) # 800004e6 <strlen>
}
    800022c0:	70a2                	ld	ra,40(sp)
    800022c2:	7402                	ld	s0,32(sp)
    800022c4:	64e2                	ld	s1,24(sp)
    800022c6:	6942                	ld	s2,16(sp)
    800022c8:	69a2                	ld	s3,8(sp)
    800022ca:	6145                	addi	sp,sp,48
    800022cc:	8082                	ret

00000000800022ce <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800022ce:	1101                	addi	sp,sp,-32
    800022d0:	ec06                	sd	ra,24(sp)
    800022d2:	e822                	sd	s0,16(sp)
    800022d4:	e426                	sd	s1,8(sp)
    800022d6:	1000                	addi	s0,sp,32
    800022d8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022da:	00000097          	auipc	ra,0x0
    800022de:	ef2080e7          	jalr	-270(ra) # 800021cc <argraw>
    800022e2:	c088                	sw	a0,0(s1)
  return 0;
}
    800022e4:	4501                	li	a0,0
    800022e6:	60e2                	ld	ra,24(sp)
    800022e8:	6442                	ld	s0,16(sp)
    800022ea:	64a2                	ld	s1,8(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800022f0:	1101                	addi	sp,sp,-32
    800022f2:	ec06                	sd	ra,24(sp)
    800022f4:	e822                	sd	s0,16(sp)
    800022f6:	e426                	sd	s1,8(sp)
    800022f8:	1000                	addi	s0,sp,32
    800022fa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	ed0080e7          	jalr	-304(ra) # 800021cc <argraw>
    80002304:	e088                	sd	a0,0(s1)
  return 0;
}
    80002306:	4501                	li	a0,0
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002312:	1101                	addi	sp,sp,-32
    80002314:	ec06                	sd	ra,24(sp)
    80002316:	e822                	sd	s0,16(sp)
    80002318:	e426                	sd	s1,8(sp)
    8000231a:	e04a                	sd	s2,0(sp)
    8000231c:	1000                	addi	s0,sp,32
    8000231e:	84ae                	mv	s1,a1
    80002320:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002322:	00000097          	auipc	ra,0x0
    80002326:	eaa080e7          	jalr	-342(ra) # 800021cc <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000232a:	864a                	mv	a2,s2
    8000232c:	85a6                	mv	a1,s1
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	f58080e7          	jalr	-168(ra) # 80002286 <fetchstr>
}
    80002336:	60e2                	ld	ra,24(sp)
    80002338:	6442                	ld	s0,16(sp)
    8000233a:	64a2                	ld	s1,8(sp)
    8000233c:	6902                	ld	s2,0(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002342:	1101                	addi	sp,sp,-32
    80002344:	ec06                	sd	ra,24(sp)
    80002346:	e822                	sd	s0,16(sp)
    80002348:	e426                	sd	s1,8(sp)
    8000234a:	e04a                	sd	s2,0(sp)
    8000234c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000234e:	fffff097          	auipc	ra,0xfffff
    80002352:	e36080e7          	jalr	-458(ra) # 80001184 <myproc>
    80002356:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002358:	05853903          	ld	s2,88(a0)
    8000235c:	0a893783          	ld	a5,168(s2)
    80002360:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002364:	37fd                	addiw	a5,a5,-1
    80002366:	4751                	li	a4,20
    80002368:	00f76f63          	bltu	a4,a5,80002386 <syscall+0x44>
    8000236c:	00369713          	slli	a4,a3,0x3
    80002370:	00006797          	auipc	a5,0x6
    80002374:	42878793          	addi	a5,a5,1064 # 80008798 <syscalls>
    80002378:	97ba                	add	a5,a5,a4
    8000237a:	639c                	ld	a5,0(a5)
    8000237c:	c789                	beqz	a5,80002386 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000237e:	9782                	jalr	a5
    80002380:	06a93823          	sd	a0,112(s2)
    80002384:	a839                	j	800023a2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002386:	15848613          	addi	a2,s1,344
    8000238a:	588c                	lw	a1,48(s1)
    8000238c:	00006517          	auipc	a0,0x6
    80002390:	02450513          	addi	a0,a0,36 # 800083b0 <etext+0x3b0>
    80002394:	00004097          	auipc	ra,0x4
    80002398:	c62080e7          	jalr	-926(ra) # 80005ff6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000239c:	6cbc                	ld	a5,88(s1)
    8000239e:	577d                	li	a4,-1
    800023a0:	fbb8                	sd	a4,112(a5)
  }
}
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	64a2                	ld	s1,8(sp)
    800023a8:	6902                	ld	s2,0(sp)
    800023aa:	6105                	addi	sp,sp,32
    800023ac:	8082                	ret

00000000800023ae <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800023b6:	fec40593          	addi	a1,s0,-20
    800023ba:	4501                	li	a0,0
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	f12080e7          	jalr	-238(ra) # 800022ce <argint>
    return -1;
    800023c4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023c6:	00054963          	bltz	a0,800023d8 <sys_exit+0x2a>
  exit(n);
    800023ca:	fec42503          	lw	a0,-20(s0)
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	6d8080e7          	jalr	1752(ra) # 80001aa6 <exit>
  return 0;  // not reached
    800023d6:	4781                	li	a5,0
}
    800023d8:	853e                	mv	a0,a5
    800023da:	60e2                	ld	ra,24(sp)
    800023dc:	6442                	ld	s0,16(sp)
    800023de:	6105                	addi	sp,sp,32
    800023e0:	8082                	ret

00000000800023e2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800023e2:	1141                	addi	sp,sp,-16
    800023e4:	e406                	sd	ra,8(sp)
    800023e6:	e022                	sd	s0,0(sp)
    800023e8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	d9a080e7          	jalr	-614(ra) # 80001184 <myproc>
}
    800023f2:	5908                	lw	a0,48(a0)
    800023f4:	60a2                	ld	ra,8(sp)
    800023f6:	6402                	ld	s0,0(sp)
    800023f8:	0141                	addi	sp,sp,16
    800023fa:	8082                	ret

00000000800023fc <sys_fork>:

uint64
sys_fork(void)
{
    800023fc:	1141                	addi	sp,sp,-16
    800023fe:	e406                	sd	ra,8(sp)
    80002400:	e022                	sd	s0,0(sp)
    80002402:	0800                	addi	s0,sp,16
  return fork();
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	152080e7          	jalr	338(ra) # 80001556 <fork>
}
    8000240c:	60a2                	ld	ra,8(sp)
    8000240e:	6402                	ld	s0,0(sp)
    80002410:	0141                	addi	sp,sp,16
    80002412:	8082                	ret

0000000080002414 <sys_wait>:

uint64
sys_wait(void)
{
    80002414:	1101                	addi	sp,sp,-32
    80002416:	ec06                	sd	ra,24(sp)
    80002418:	e822                	sd	s0,16(sp)
    8000241a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000241c:	fe840593          	addi	a1,s0,-24
    80002420:	4501                	li	a0,0
    80002422:	00000097          	auipc	ra,0x0
    80002426:	ece080e7          	jalr	-306(ra) # 800022f0 <argaddr>
    8000242a:	87aa                	mv	a5,a0
    return -1;
    8000242c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000242e:	0007c863          	bltz	a5,8000243e <sys_wait+0x2a>
  return wait(p);
    80002432:	fe843503          	ld	a0,-24(s0)
    80002436:	fffff097          	auipc	ra,0xfffff
    8000243a:	478080e7          	jalr	1144(ra) # 800018ae <wait>
}
    8000243e:	60e2                	ld	ra,24(sp)
    80002440:	6442                	ld	s0,16(sp)
    80002442:	6105                	addi	sp,sp,32
    80002444:	8082                	ret

0000000080002446 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002446:	7179                	addi	sp,sp,-48
    80002448:	f406                	sd	ra,40(sp)
    8000244a:	f022                	sd	s0,32(sp)
    8000244c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000244e:	fdc40593          	addi	a1,s0,-36
    80002452:	4501                	li	a0,0
    80002454:	00000097          	auipc	ra,0x0
    80002458:	e7a080e7          	jalr	-390(ra) # 800022ce <argint>
    8000245c:	87aa                	mv	a5,a0
    return -1;
    8000245e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002460:	0207c263          	bltz	a5,80002484 <sys_sbrk+0x3e>
    80002464:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	d1e080e7          	jalr	-738(ra) # 80001184 <myproc>
    8000246e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002470:	fdc42503          	lw	a0,-36(s0)
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	06a080e7          	jalr	106(ra) # 800014de <growproc>
    8000247c:	00054863          	bltz	a0,8000248c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002480:	8526                	mv	a0,s1
    80002482:	64e2                	ld	s1,24(sp)
}
    80002484:	70a2                	ld	ra,40(sp)
    80002486:	7402                	ld	s0,32(sp)
    80002488:	6145                	addi	sp,sp,48
    8000248a:	8082                	ret
    return -1;
    8000248c:	557d                	li	a0,-1
    8000248e:	64e2                	ld	s1,24(sp)
    80002490:	bfd5                	j	80002484 <sys_sbrk+0x3e>

0000000080002492 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002492:	7139                	addi	sp,sp,-64
    80002494:	fc06                	sd	ra,56(sp)
    80002496:	f822                	sd	s0,48(sp)
    80002498:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000249a:	fcc40593          	addi	a1,s0,-52
    8000249e:	4501                	li	a0,0
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	e2e080e7          	jalr	-466(ra) # 800022ce <argint>
    return -1;
    800024a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800024aa:	06054b63          	bltz	a0,80002520 <sys_sleep+0x8e>
    800024ae:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800024b0:	00010517          	auipc	a0,0x10
    800024b4:	9e850513          	addi	a0,a0,-1560 # 80011e98 <tickslock>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	06e080e7          	jalr	110(ra) # 80006526 <acquire>
  ticks0 = ticks;
    800024c0:	0000a917          	auipc	s2,0xa
    800024c4:	b5892903          	lw	s2,-1192(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800024c8:	fcc42783          	lw	a5,-52(s0)
    800024cc:	c3a1                	beqz	a5,8000250c <sys_sleep+0x7a>
    800024ce:	f426                	sd	s1,40(sp)
    800024d0:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024d2:	00010997          	auipc	s3,0x10
    800024d6:	9c698993          	addi	s3,s3,-1594 # 80011e98 <tickslock>
    800024da:	0000a497          	auipc	s1,0xa
    800024de:	b3e48493          	addi	s1,s1,-1218 # 8000c018 <ticks>
    if(myproc()->killed){
    800024e2:	fffff097          	auipc	ra,0xfffff
    800024e6:	ca2080e7          	jalr	-862(ra) # 80001184 <myproc>
    800024ea:	551c                	lw	a5,40(a0)
    800024ec:	ef9d                	bnez	a5,8000252a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800024ee:	85ce                	mv	a1,s3
    800024f0:	8526                	mv	a0,s1
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	358080e7          	jalr	856(ra) # 8000184a <sleep>
  while(ticks - ticks0 < n){
    800024fa:	409c                	lw	a5,0(s1)
    800024fc:	412787bb          	subw	a5,a5,s2
    80002500:	fcc42703          	lw	a4,-52(s0)
    80002504:	fce7efe3          	bltu	a5,a4,800024e2 <sys_sleep+0x50>
    80002508:	74a2                	ld	s1,40(sp)
    8000250a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000250c:	00010517          	auipc	a0,0x10
    80002510:	98c50513          	addi	a0,a0,-1652 # 80011e98 <tickslock>
    80002514:	00004097          	auipc	ra,0x4
    80002518:	0c6080e7          	jalr	198(ra) # 800065da <release>
  return 0;
    8000251c:	4781                	li	a5,0
    8000251e:	7902                	ld	s2,32(sp)
}
    80002520:	853e                	mv	a0,a5
    80002522:	70e2                	ld	ra,56(sp)
    80002524:	7442                	ld	s0,48(sp)
    80002526:	6121                	addi	sp,sp,64
    80002528:	8082                	ret
      release(&tickslock);
    8000252a:	00010517          	auipc	a0,0x10
    8000252e:	96e50513          	addi	a0,a0,-1682 # 80011e98 <tickslock>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	0a8080e7          	jalr	168(ra) # 800065da <release>
      return -1;
    8000253a:	57fd                	li	a5,-1
    8000253c:	74a2                	ld	s1,40(sp)
    8000253e:	7902                	ld	s2,32(sp)
    80002540:	69e2                	ld	s3,24(sp)
    80002542:	bff9                	j	80002520 <sys_sleep+0x8e>

0000000080002544 <sys_kill>:

uint64
sys_kill(void)
{
    80002544:	1101                	addi	sp,sp,-32
    80002546:	ec06                	sd	ra,24(sp)
    80002548:	e822                	sd	s0,16(sp)
    8000254a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000254c:	fec40593          	addi	a1,s0,-20
    80002550:	4501                	li	a0,0
    80002552:	00000097          	auipc	ra,0x0
    80002556:	d7c080e7          	jalr	-644(ra) # 800022ce <argint>
    8000255a:	87aa                	mv	a5,a0
    return -1;
    8000255c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000255e:	0007c863          	bltz	a5,8000256e <sys_kill+0x2a>
  return kill(pid);
    80002562:	fec42503          	lw	a0,-20(s0)
    80002566:	fffff097          	auipc	ra,0xfffff
    8000256a:	616080e7          	jalr	1558(ra) # 80001b7c <kill>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	6105                	addi	sp,sp,32
    80002574:	8082                	ret

0000000080002576 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002576:	1101                	addi	sp,sp,-32
    80002578:	ec06                	sd	ra,24(sp)
    8000257a:	e822                	sd	s0,16(sp)
    8000257c:	e426                	sd	s1,8(sp)
    8000257e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002580:	00010517          	auipc	a0,0x10
    80002584:	91850513          	addi	a0,a0,-1768 # 80011e98 <tickslock>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	f9e080e7          	jalr	-98(ra) # 80006526 <acquire>
  xticks = ticks;
    80002590:	0000a497          	auipc	s1,0xa
    80002594:	a884a483          	lw	s1,-1400(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002598:	00010517          	auipc	a0,0x10
    8000259c:	90050513          	addi	a0,a0,-1792 # 80011e98 <tickslock>
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	03a080e7          	jalr	58(ra) # 800065da <release>
  return xticks;
}
    800025a8:	02049513          	slli	a0,s1,0x20
    800025ac:	9101                	srli	a0,a0,0x20
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	64a2                	ld	s1,8(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret

00000000800025b8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800025b8:	7179                	addi	sp,sp,-48
    800025ba:	f406                	sd	ra,40(sp)
    800025bc:	f022                	sd	s0,32(sp)
    800025be:	ec26                	sd	s1,24(sp)
    800025c0:	e84a                	sd	s2,16(sp)
    800025c2:	e44e                	sd	s3,8(sp)
    800025c4:	e052                	sd	s4,0(sp)
    800025c6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025c8:	00006597          	auipc	a1,0x6
    800025cc:	e0858593          	addi	a1,a1,-504 # 800083d0 <etext+0x3d0>
    800025d0:	00010517          	auipc	a0,0x10
    800025d4:	8e050513          	addi	a0,a0,-1824 # 80011eb0 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	ebe080e7          	jalr	-322(ra) # 80006496 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025e0:	00018797          	auipc	a5,0x18
    800025e4:	8d078793          	addi	a5,a5,-1840 # 80019eb0 <bcache+0x8000>
    800025e8:	00018717          	auipc	a4,0x18
    800025ec:	b3070713          	addi	a4,a4,-1232 # 8001a118 <bcache+0x8268>
    800025f0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025f4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025f8:	00010497          	auipc	s1,0x10
    800025fc:	8d048493          	addi	s1,s1,-1840 # 80011ec8 <bcache+0x18>
    b->next = bcache.head.next;
    80002600:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002602:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002604:	00006a17          	auipc	s4,0x6
    80002608:	dd4a0a13          	addi	s4,s4,-556 # 800083d8 <etext+0x3d8>
    b->next = bcache.head.next;
    8000260c:	2b893783          	ld	a5,696(s2)
    80002610:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002612:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002616:	85d2                	mv	a1,s4
    80002618:	01048513          	addi	a0,s1,16
    8000261c:	00001097          	auipc	ra,0x1
    80002620:	4b2080e7          	jalr	1202(ra) # 80003ace <initsleeplock>
    bcache.head.next->prev = b;
    80002624:	2b893783          	ld	a5,696(s2)
    80002628:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000262a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000262e:	45848493          	addi	s1,s1,1112
    80002632:	fd349de3          	bne	s1,s3,8000260c <binit+0x54>
  }
}
    80002636:	70a2                	ld	ra,40(sp)
    80002638:	7402                	ld	s0,32(sp)
    8000263a:	64e2                	ld	s1,24(sp)
    8000263c:	6942                	ld	s2,16(sp)
    8000263e:	69a2                	ld	s3,8(sp)
    80002640:	6a02                	ld	s4,0(sp)
    80002642:	6145                	addi	sp,sp,48
    80002644:	8082                	ret

0000000080002646 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002646:	7179                	addi	sp,sp,-48
    80002648:	f406                	sd	ra,40(sp)
    8000264a:	f022                	sd	s0,32(sp)
    8000264c:	ec26                	sd	s1,24(sp)
    8000264e:	e84a                	sd	s2,16(sp)
    80002650:	e44e                	sd	s3,8(sp)
    80002652:	1800                	addi	s0,sp,48
    80002654:	892a                	mv	s2,a0
    80002656:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002658:	00010517          	auipc	a0,0x10
    8000265c:	85850513          	addi	a0,a0,-1960 # 80011eb0 <bcache>
    80002660:	00004097          	auipc	ra,0x4
    80002664:	ec6080e7          	jalr	-314(ra) # 80006526 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002668:	00018497          	auipc	s1,0x18
    8000266c:	b004b483          	ld	s1,-1280(s1) # 8001a168 <bcache+0x82b8>
    80002670:	00018797          	auipc	a5,0x18
    80002674:	aa878793          	addi	a5,a5,-1368 # 8001a118 <bcache+0x8268>
    80002678:	02f48f63          	beq	s1,a5,800026b6 <bread+0x70>
    8000267c:	873e                	mv	a4,a5
    8000267e:	a021                	j	80002686 <bread+0x40>
    80002680:	68a4                	ld	s1,80(s1)
    80002682:	02e48a63          	beq	s1,a4,800026b6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002686:	449c                	lw	a5,8(s1)
    80002688:	ff279ce3          	bne	a5,s2,80002680 <bread+0x3a>
    8000268c:	44dc                	lw	a5,12(s1)
    8000268e:	ff3799e3          	bne	a5,s3,80002680 <bread+0x3a>
      b->refcnt++;
    80002692:	40bc                	lw	a5,64(s1)
    80002694:	2785                	addiw	a5,a5,1
    80002696:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002698:	00010517          	auipc	a0,0x10
    8000269c:	81850513          	addi	a0,a0,-2024 # 80011eb0 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	f3a080e7          	jalr	-198(ra) # 800065da <release>
      acquiresleep(&b->lock);
    800026a8:	01048513          	addi	a0,s1,16
    800026ac:	00001097          	auipc	ra,0x1
    800026b0:	45c080e7          	jalr	1116(ra) # 80003b08 <acquiresleep>
      return b;
    800026b4:	a8b9                	j	80002712 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026b6:	00018497          	auipc	s1,0x18
    800026ba:	aaa4b483          	ld	s1,-1366(s1) # 8001a160 <bcache+0x82b0>
    800026be:	00018797          	auipc	a5,0x18
    800026c2:	a5a78793          	addi	a5,a5,-1446 # 8001a118 <bcache+0x8268>
    800026c6:	00f48863          	beq	s1,a5,800026d6 <bread+0x90>
    800026ca:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026cc:	40bc                	lw	a5,64(s1)
    800026ce:	cf81                	beqz	a5,800026e6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026d0:	64a4                	ld	s1,72(s1)
    800026d2:	fee49de3          	bne	s1,a4,800026cc <bread+0x86>
  panic("bget: no buffers");
    800026d6:	00006517          	auipc	a0,0x6
    800026da:	d0a50513          	addi	a0,a0,-758 # 800083e0 <etext+0x3e0>
    800026de:	00004097          	auipc	ra,0x4
    800026e2:	8ce080e7          	jalr	-1842(ra) # 80005fac <panic>
      b->dev = dev;
    800026e6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026ea:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026ee:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026f2:	4785                	li	a5,1
    800026f4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026f6:	0000f517          	auipc	a0,0xf
    800026fa:	7ba50513          	addi	a0,a0,1978 # 80011eb0 <bcache>
    800026fe:	00004097          	auipc	ra,0x4
    80002702:	edc080e7          	jalr	-292(ra) # 800065da <release>
      acquiresleep(&b->lock);
    80002706:	01048513          	addi	a0,s1,16
    8000270a:	00001097          	auipc	ra,0x1
    8000270e:	3fe080e7          	jalr	1022(ra) # 80003b08 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002712:	409c                	lw	a5,0(s1)
    80002714:	cb89                	beqz	a5,80002726 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002716:	8526                	mv	a0,s1
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret
    virtio_disk_rw(b, 0);
    80002726:	4581                	li	a1,0
    80002728:	8526                	mv	a0,s1
    8000272a:	00003097          	auipc	ra,0x3
    8000272e:	fe8080e7          	jalr	-24(ra) # 80005712 <virtio_disk_rw>
    b->valid = 1;
    80002732:	4785                	li	a5,1
    80002734:	c09c                	sw	a5,0(s1)
  return b;
    80002736:	b7c5                	j	80002716 <bread+0xd0>

0000000080002738 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002738:	1101                	addi	sp,sp,-32
    8000273a:	ec06                	sd	ra,24(sp)
    8000273c:	e822                	sd	s0,16(sp)
    8000273e:	e426                	sd	s1,8(sp)
    80002740:	1000                	addi	s0,sp,32
    80002742:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002744:	0541                	addi	a0,a0,16
    80002746:	00001097          	auipc	ra,0x1
    8000274a:	45c080e7          	jalr	1116(ra) # 80003ba2 <holdingsleep>
    8000274e:	cd01                	beqz	a0,80002766 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002750:	4585                	li	a1,1
    80002752:	8526                	mv	a0,s1
    80002754:	00003097          	auipc	ra,0x3
    80002758:	fbe080e7          	jalr	-66(ra) # 80005712 <virtio_disk_rw>
}
    8000275c:	60e2                	ld	ra,24(sp)
    8000275e:	6442                	ld	s0,16(sp)
    80002760:	64a2                	ld	s1,8(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
    panic("bwrite");
    80002766:	00006517          	auipc	a0,0x6
    8000276a:	c9250513          	addi	a0,a0,-878 # 800083f8 <etext+0x3f8>
    8000276e:	00004097          	auipc	ra,0x4
    80002772:	83e080e7          	jalr	-1986(ra) # 80005fac <panic>

0000000080002776 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	e04a                	sd	s2,0(sp)
    80002780:	1000                	addi	s0,sp,32
    80002782:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002784:	01050913          	addi	s2,a0,16
    80002788:	854a                	mv	a0,s2
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	418080e7          	jalr	1048(ra) # 80003ba2 <holdingsleep>
    80002792:	c925                	beqz	a0,80002802 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002794:	854a                	mv	a0,s2
    80002796:	00001097          	auipc	ra,0x1
    8000279a:	3c8080e7          	jalr	968(ra) # 80003b5e <releasesleep>

  acquire(&bcache.lock);
    8000279e:	0000f517          	auipc	a0,0xf
    800027a2:	71250513          	addi	a0,a0,1810 # 80011eb0 <bcache>
    800027a6:	00004097          	auipc	ra,0x4
    800027aa:	d80080e7          	jalr	-640(ra) # 80006526 <acquire>
  b->refcnt--;
    800027ae:	40bc                	lw	a5,64(s1)
    800027b0:	37fd                	addiw	a5,a5,-1
    800027b2:	0007871b          	sext.w	a4,a5
    800027b6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027b8:	e71d                	bnez	a4,800027e6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800027ba:	68b8                	ld	a4,80(s1)
    800027bc:	64bc                	ld	a5,72(s1)
    800027be:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800027c0:	68b8                	ld	a4,80(s1)
    800027c2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027c4:	00017797          	auipc	a5,0x17
    800027c8:	6ec78793          	addi	a5,a5,1772 # 80019eb0 <bcache+0x8000>
    800027cc:	2b87b703          	ld	a4,696(a5)
    800027d0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027d2:	00018717          	auipc	a4,0x18
    800027d6:	94670713          	addi	a4,a4,-1722 # 8001a118 <bcache+0x8268>
    800027da:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027dc:	2b87b703          	ld	a4,696(a5)
    800027e0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027e2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027e6:	0000f517          	auipc	a0,0xf
    800027ea:	6ca50513          	addi	a0,a0,1738 # 80011eb0 <bcache>
    800027ee:	00004097          	auipc	ra,0x4
    800027f2:	dec080e7          	jalr	-532(ra) # 800065da <release>
}
    800027f6:	60e2                	ld	ra,24(sp)
    800027f8:	6442                	ld	s0,16(sp)
    800027fa:	64a2                	ld	s1,8(sp)
    800027fc:	6902                	ld	s2,0(sp)
    800027fe:	6105                	addi	sp,sp,32
    80002800:	8082                	ret
    panic("brelse");
    80002802:	00006517          	auipc	a0,0x6
    80002806:	bfe50513          	addi	a0,a0,-1026 # 80008400 <etext+0x400>
    8000280a:	00003097          	auipc	ra,0x3
    8000280e:	7a2080e7          	jalr	1954(ra) # 80005fac <panic>

0000000080002812 <bpin>:

void
bpin(struct buf *b) {
    80002812:	1101                	addi	sp,sp,-32
    80002814:	ec06                	sd	ra,24(sp)
    80002816:	e822                	sd	s0,16(sp)
    80002818:	e426                	sd	s1,8(sp)
    8000281a:	1000                	addi	s0,sp,32
    8000281c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000281e:	0000f517          	auipc	a0,0xf
    80002822:	69250513          	addi	a0,a0,1682 # 80011eb0 <bcache>
    80002826:	00004097          	auipc	ra,0x4
    8000282a:	d00080e7          	jalr	-768(ra) # 80006526 <acquire>
  b->refcnt++;
    8000282e:	40bc                	lw	a5,64(s1)
    80002830:	2785                	addiw	a5,a5,1
    80002832:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002834:	0000f517          	auipc	a0,0xf
    80002838:	67c50513          	addi	a0,a0,1660 # 80011eb0 <bcache>
    8000283c:	00004097          	auipc	ra,0x4
    80002840:	d9e080e7          	jalr	-610(ra) # 800065da <release>
}
    80002844:	60e2                	ld	ra,24(sp)
    80002846:	6442                	ld	s0,16(sp)
    80002848:	64a2                	ld	s1,8(sp)
    8000284a:	6105                	addi	sp,sp,32
    8000284c:	8082                	ret

000000008000284e <bunpin>:

void
bunpin(struct buf *b) {
    8000284e:	1101                	addi	sp,sp,-32
    80002850:	ec06                	sd	ra,24(sp)
    80002852:	e822                	sd	s0,16(sp)
    80002854:	e426                	sd	s1,8(sp)
    80002856:	1000                	addi	s0,sp,32
    80002858:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000285a:	0000f517          	auipc	a0,0xf
    8000285e:	65650513          	addi	a0,a0,1622 # 80011eb0 <bcache>
    80002862:	00004097          	auipc	ra,0x4
    80002866:	cc4080e7          	jalr	-828(ra) # 80006526 <acquire>
  b->refcnt--;
    8000286a:	40bc                	lw	a5,64(s1)
    8000286c:	37fd                	addiw	a5,a5,-1
    8000286e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002870:	0000f517          	auipc	a0,0xf
    80002874:	64050513          	addi	a0,a0,1600 # 80011eb0 <bcache>
    80002878:	00004097          	auipc	ra,0x4
    8000287c:	d62080e7          	jalr	-670(ra) # 800065da <release>
}
    80002880:	60e2                	ld	ra,24(sp)
    80002882:	6442                	ld	s0,16(sp)
    80002884:	64a2                	ld	s1,8(sp)
    80002886:	6105                	addi	sp,sp,32
    80002888:	8082                	ret

000000008000288a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000288a:	1101                	addi	sp,sp,-32
    8000288c:	ec06                	sd	ra,24(sp)
    8000288e:	e822                	sd	s0,16(sp)
    80002890:	e426                	sd	s1,8(sp)
    80002892:	e04a                	sd	s2,0(sp)
    80002894:	1000                	addi	s0,sp,32
    80002896:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002898:	00d5d59b          	srliw	a1,a1,0xd
    8000289c:	00018797          	auipc	a5,0x18
    800028a0:	cf07a783          	lw	a5,-784(a5) # 8001a58c <sb+0x1c>
    800028a4:	9dbd                	addw	a1,a1,a5
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	da0080e7          	jalr	-608(ra) # 80002646 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028ae:	0074f713          	andi	a4,s1,7
    800028b2:	4785                	li	a5,1
    800028b4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028b8:	14ce                	slli	s1,s1,0x33
    800028ba:	90d9                	srli	s1,s1,0x36
    800028bc:	00950733          	add	a4,a0,s1
    800028c0:	05874703          	lbu	a4,88(a4)
    800028c4:	00e7f6b3          	and	a3,a5,a4
    800028c8:	c69d                	beqz	a3,800028f6 <bfree+0x6c>
    800028ca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028cc:	94aa                	add	s1,s1,a0
    800028ce:	fff7c793          	not	a5,a5
    800028d2:	8f7d                	and	a4,a4,a5
    800028d4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028d8:	00001097          	auipc	ra,0x1
    800028dc:	112080e7          	jalr	274(ra) # 800039ea <log_write>
  brelse(bp);
    800028e0:	854a                	mv	a0,s2
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	e94080e7          	jalr	-364(ra) # 80002776 <brelse>
}
    800028ea:	60e2                	ld	ra,24(sp)
    800028ec:	6442                	ld	s0,16(sp)
    800028ee:	64a2                	ld	s1,8(sp)
    800028f0:	6902                	ld	s2,0(sp)
    800028f2:	6105                	addi	sp,sp,32
    800028f4:	8082                	ret
    panic("freeing free block");
    800028f6:	00006517          	auipc	a0,0x6
    800028fa:	b1250513          	addi	a0,a0,-1262 # 80008408 <etext+0x408>
    800028fe:	00003097          	auipc	ra,0x3
    80002902:	6ae080e7          	jalr	1710(ra) # 80005fac <panic>

0000000080002906 <balloc>:
{
    80002906:	711d                	addi	sp,sp,-96
    80002908:	ec86                	sd	ra,88(sp)
    8000290a:	e8a2                	sd	s0,80(sp)
    8000290c:	e4a6                	sd	s1,72(sp)
    8000290e:	e0ca                	sd	s2,64(sp)
    80002910:	fc4e                	sd	s3,56(sp)
    80002912:	f852                	sd	s4,48(sp)
    80002914:	f456                	sd	s5,40(sp)
    80002916:	f05a                	sd	s6,32(sp)
    80002918:	ec5e                	sd	s7,24(sp)
    8000291a:	e862                	sd	s8,16(sp)
    8000291c:	e466                	sd	s9,8(sp)
    8000291e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002920:	00018797          	auipc	a5,0x18
    80002924:	c547a783          	lw	a5,-940(a5) # 8001a574 <sb+0x4>
    80002928:	cbc1                	beqz	a5,800029b8 <balloc+0xb2>
    8000292a:	8baa                	mv	s7,a0
    8000292c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000292e:	00018b17          	auipc	s6,0x18
    80002932:	c42b0b13          	addi	s6,s6,-958 # 8001a570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002936:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002938:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000293a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000293c:	6c89                	lui	s9,0x2
    8000293e:	a831                	j	8000295a <balloc+0x54>
    brelse(bp);
    80002940:	854a                	mv	a0,s2
    80002942:	00000097          	auipc	ra,0x0
    80002946:	e34080e7          	jalr	-460(ra) # 80002776 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000294a:	015c87bb          	addw	a5,s9,s5
    8000294e:	00078a9b          	sext.w	s5,a5
    80002952:	004b2703          	lw	a4,4(s6)
    80002956:	06eaf163          	bgeu	s5,a4,800029b8 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000295a:	41fad79b          	sraiw	a5,s5,0x1f
    8000295e:	0137d79b          	srliw	a5,a5,0x13
    80002962:	015787bb          	addw	a5,a5,s5
    80002966:	40d7d79b          	sraiw	a5,a5,0xd
    8000296a:	01cb2583          	lw	a1,28(s6)
    8000296e:	9dbd                	addw	a1,a1,a5
    80002970:	855e                	mv	a0,s7
    80002972:	00000097          	auipc	ra,0x0
    80002976:	cd4080e7          	jalr	-812(ra) # 80002646 <bread>
    8000297a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000297c:	004b2503          	lw	a0,4(s6)
    80002980:	000a849b          	sext.w	s1,s5
    80002984:	8762                	mv	a4,s8
    80002986:	faa4fde3          	bgeu	s1,a0,80002940 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000298a:	00777693          	andi	a3,a4,7
    8000298e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002992:	41f7579b          	sraiw	a5,a4,0x1f
    80002996:	01d7d79b          	srliw	a5,a5,0x1d
    8000299a:	9fb9                	addw	a5,a5,a4
    8000299c:	4037d79b          	sraiw	a5,a5,0x3
    800029a0:	00f90633          	add	a2,s2,a5
    800029a4:	05864603          	lbu	a2,88(a2)
    800029a8:	00c6f5b3          	and	a1,a3,a2
    800029ac:	cd91                	beqz	a1,800029c8 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029ae:	2705                	addiw	a4,a4,1
    800029b0:	2485                	addiw	s1,s1,1
    800029b2:	fd471ae3          	bne	a4,s4,80002986 <balloc+0x80>
    800029b6:	b769                	j	80002940 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	a6850513          	addi	a0,a0,-1432 # 80008420 <etext+0x420>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	5ec080e7          	jalr	1516(ra) # 80005fac <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029c8:	97ca                	add	a5,a5,s2
    800029ca:	8e55                	or	a2,a2,a3
    800029cc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800029d0:	854a                	mv	a0,s2
    800029d2:	00001097          	auipc	ra,0x1
    800029d6:	018080e7          	jalr	24(ra) # 800039ea <log_write>
        brelse(bp);
    800029da:	854a                	mv	a0,s2
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	d9a080e7          	jalr	-614(ra) # 80002776 <brelse>
  bp = bread(dev, bno);
    800029e4:	85a6                	mv	a1,s1
    800029e6:	855e                	mv	a0,s7
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	c5e080e7          	jalr	-930(ra) # 80002646 <bread>
    800029f0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029f2:	40000613          	li	a2,1024
    800029f6:	4581                	li	a1,0
    800029f8:	05850513          	addi	a0,a0,88
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	976080e7          	jalr	-1674(ra) # 80000372 <memset>
  log_write(bp);
    80002a04:	854a                	mv	a0,s2
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	fe4080e7          	jalr	-28(ra) # 800039ea <log_write>
  brelse(bp);
    80002a0e:	854a                	mv	a0,s2
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	d66080e7          	jalr	-666(ra) # 80002776 <brelse>
}
    80002a18:	8526                	mv	a0,s1
    80002a1a:	60e6                	ld	ra,88(sp)
    80002a1c:	6446                	ld	s0,80(sp)
    80002a1e:	64a6                	ld	s1,72(sp)
    80002a20:	6906                	ld	s2,64(sp)
    80002a22:	79e2                	ld	s3,56(sp)
    80002a24:	7a42                	ld	s4,48(sp)
    80002a26:	7aa2                	ld	s5,40(sp)
    80002a28:	7b02                	ld	s6,32(sp)
    80002a2a:	6be2                	ld	s7,24(sp)
    80002a2c:	6c42                	ld	s8,16(sp)
    80002a2e:	6ca2                	ld	s9,8(sp)
    80002a30:	6125                	addi	sp,sp,96
    80002a32:	8082                	ret

0000000080002a34 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a34:	7179                	addi	sp,sp,-48
    80002a36:	f406                	sd	ra,40(sp)
    80002a38:	f022                	sd	s0,32(sp)
    80002a3a:	ec26                	sd	s1,24(sp)
    80002a3c:	e84a                	sd	s2,16(sp)
    80002a3e:	e44e                	sd	s3,8(sp)
    80002a40:	1800                	addi	s0,sp,48
    80002a42:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a44:	47ad                	li	a5,11
    80002a46:	04b7ff63          	bgeu	a5,a1,80002aa4 <bmap+0x70>
    80002a4a:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a4c:	ff45849b          	addiw	s1,a1,-12
    80002a50:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a54:	0ff00793          	li	a5,255
    80002a58:	0ae7e463          	bltu	a5,a4,80002b00 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a5c:	08052583          	lw	a1,128(a0)
    80002a60:	c5b5                	beqz	a1,80002acc <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a62:	00092503          	lw	a0,0(s2)
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	be0080e7          	jalr	-1056(ra) # 80002646 <bread>
    80002a6e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a70:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a74:	02049713          	slli	a4,s1,0x20
    80002a78:	01e75593          	srli	a1,a4,0x1e
    80002a7c:	00b784b3          	add	s1,a5,a1
    80002a80:	0004a983          	lw	s3,0(s1)
    80002a84:	04098e63          	beqz	s3,80002ae0 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a88:	8552                	mv	a0,s4
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	cec080e7          	jalr	-788(ra) # 80002776 <brelse>
    return addr;
    80002a92:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002a94:	854e                	mv	a0,s3
    80002a96:	70a2                	ld	ra,40(sp)
    80002a98:	7402                	ld	s0,32(sp)
    80002a9a:	64e2                	ld	s1,24(sp)
    80002a9c:	6942                	ld	s2,16(sp)
    80002a9e:	69a2                	ld	s3,8(sp)
    80002aa0:	6145                	addi	sp,sp,48
    80002aa2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002aa4:	02059793          	slli	a5,a1,0x20
    80002aa8:	01e7d593          	srli	a1,a5,0x1e
    80002aac:	00b504b3          	add	s1,a0,a1
    80002ab0:	0504a983          	lw	s3,80(s1)
    80002ab4:	fe0990e3          	bnez	s3,80002a94 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002ab8:	4108                	lw	a0,0(a0)
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	e4c080e7          	jalr	-436(ra) # 80002906 <balloc>
    80002ac2:	0005099b          	sext.w	s3,a0
    80002ac6:	0534a823          	sw	s3,80(s1)
    80002aca:	b7e9                	j	80002a94 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002acc:	4108                	lw	a0,0(a0)
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	e38080e7          	jalr	-456(ra) # 80002906 <balloc>
    80002ad6:	0005059b          	sext.w	a1,a0
    80002ada:	08b92023          	sw	a1,128(s2)
    80002ade:	b751                	j	80002a62 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002ae0:	00092503          	lw	a0,0(s2)
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	e22080e7          	jalr	-478(ra) # 80002906 <balloc>
    80002aec:	0005099b          	sext.w	s3,a0
    80002af0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002af4:	8552                	mv	a0,s4
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	ef4080e7          	jalr	-268(ra) # 800039ea <log_write>
    80002afe:	b769                	j	80002a88 <bmap+0x54>
  panic("bmap: out of range");
    80002b00:	00006517          	auipc	a0,0x6
    80002b04:	93850513          	addi	a0,a0,-1736 # 80008438 <etext+0x438>
    80002b08:	00003097          	auipc	ra,0x3
    80002b0c:	4a4080e7          	jalr	1188(ra) # 80005fac <panic>

0000000080002b10 <iget>:
{
    80002b10:	7179                	addi	sp,sp,-48
    80002b12:	f406                	sd	ra,40(sp)
    80002b14:	f022                	sd	s0,32(sp)
    80002b16:	ec26                	sd	s1,24(sp)
    80002b18:	e84a                	sd	s2,16(sp)
    80002b1a:	e44e                	sd	s3,8(sp)
    80002b1c:	e052                	sd	s4,0(sp)
    80002b1e:	1800                	addi	s0,sp,48
    80002b20:	89aa                	mv	s3,a0
    80002b22:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b24:	00018517          	auipc	a0,0x18
    80002b28:	a6c50513          	addi	a0,a0,-1428 # 8001a590 <itable>
    80002b2c:	00004097          	auipc	ra,0x4
    80002b30:	9fa080e7          	jalr	-1542(ra) # 80006526 <acquire>
  empty = 0;
    80002b34:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b36:	00018497          	auipc	s1,0x18
    80002b3a:	a7248493          	addi	s1,s1,-1422 # 8001a5a8 <itable+0x18>
    80002b3e:	00019697          	auipc	a3,0x19
    80002b42:	4fa68693          	addi	a3,a3,1274 # 8001c038 <log>
    80002b46:	a039                	j	80002b54 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b48:	02090b63          	beqz	s2,80002b7e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b4c:	08848493          	addi	s1,s1,136
    80002b50:	02d48a63          	beq	s1,a3,80002b84 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b54:	449c                	lw	a5,8(s1)
    80002b56:	fef059e3          	blez	a5,80002b48 <iget+0x38>
    80002b5a:	4098                	lw	a4,0(s1)
    80002b5c:	ff3716e3          	bne	a4,s3,80002b48 <iget+0x38>
    80002b60:	40d8                	lw	a4,4(s1)
    80002b62:	ff4713e3          	bne	a4,s4,80002b48 <iget+0x38>
      ip->ref++;
    80002b66:	2785                	addiw	a5,a5,1
    80002b68:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b6a:	00018517          	auipc	a0,0x18
    80002b6e:	a2650513          	addi	a0,a0,-1498 # 8001a590 <itable>
    80002b72:	00004097          	auipc	ra,0x4
    80002b76:	a68080e7          	jalr	-1432(ra) # 800065da <release>
      return ip;
    80002b7a:	8926                	mv	s2,s1
    80002b7c:	a03d                	j	80002baa <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b7e:	f7f9                	bnez	a5,80002b4c <iget+0x3c>
      empty = ip;
    80002b80:	8926                	mv	s2,s1
    80002b82:	b7e9                	j	80002b4c <iget+0x3c>
  if(empty == 0)
    80002b84:	02090c63          	beqz	s2,80002bbc <iget+0xac>
  ip->dev = dev;
    80002b88:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b8c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b90:	4785                	li	a5,1
    80002b92:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b96:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b9a:	00018517          	auipc	a0,0x18
    80002b9e:	9f650513          	addi	a0,a0,-1546 # 8001a590 <itable>
    80002ba2:	00004097          	auipc	ra,0x4
    80002ba6:	a38080e7          	jalr	-1480(ra) # 800065da <release>
}
    80002baa:	854a                	mv	a0,s2
    80002bac:	70a2                	ld	ra,40(sp)
    80002bae:	7402                	ld	s0,32(sp)
    80002bb0:	64e2                	ld	s1,24(sp)
    80002bb2:	6942                	ld	s2,16(sp)
    80002bb4:	69a2                	ld	s3,8(sp)
    80002bb6:	6a02                	ld	s4,0(sp)
    80002bb8:	6145                	addi	sp,sp,48
    80002bba:	8082                	ret
    panic("iget: no inodes");
    80002bbc:	00006517          	auipc	a0,0x6
    80002bc0:	89450513          	addi	a0,a0,-1900 # 80008450 <etext+0x450>
    80002bc4:	00003097          	auipc	ra,0x3
    80002bc8:	3e8080e7          	jalr	1000(ra) # 80005fac <panic>

0000000080002bcc <fsinit>:
fsinit(int dev) {
    80002bcc:	7179                	addi	sp,sp,-48
    80002bce:	f406                	sd	ra,40(sp)
    80002bd0:	f022                	sd	s0,32(sp)
    80002bd2:	ec26                	sd	s1,24(sp)
    80002bd4:	e84a                	sd	s2,16(sp)
    80002bd6:	e44e                	sd	s3,8(sp)
    80002bd8:	1800                	addi	s0,sp,48
    80002bda:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bdc:	4585                	li	a1,1
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	a68080e7          	jalr	-1432(ra) # 80002646 <bread>
    80002be6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002be8:	00018997          	auipc	s3,0x18
    80002bec:	98898993          	addi	s3,s3,-1656 # 8001a570 <sb>
    80002bf0:	02000613          	li	a2,32
    80002bf4:	05850593          	addi	a1,a0,88
    80002bf8:	854e                	mv	a0,s3
    80002bfa:	ffffd097          	auipc	ra,0xffffd
    80002bfe:	7d4080e7          	jalr	2004(ra) # 800003ce <memmove>
  brelse(bp);
    80002c02:	8526                	mv	a0,s1
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	b72080e7          	jalr	-1166(ra) # 80002776 <brelse>
  if(sb.magic != FSMAGIC)
    80002c0c:	0009a703          	lw	a4,0(s3)
    80002c10:	102037b7          	lui	a5,0x10203
    80002c14:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c18:	02f71263          	bne	a4,a5,80002c3c <fsinit+0x70>
  initlog(dev, &sb);
    80002c1c:	00018597          	auipc	a1,0x18
    80002c20:	95458593          	addi	a1,a1,-1708 # 8001a570 <sb>
    80002c24:	854a                	mv	a0,s2
    80002c26:	00001097          	auipc	ra,0x1
    80002c2a:	b54080e7          	jalr	-1196(ra) # 8000377a <initlog>
}
    80002c2e:	70a2                	ld	ra,40(sp)
    80002c30:	7402                	ld	s0,32(sp)
    80002c32:	64e2                	ld	s1,24(sp)
    80002c34:	6942                	ld	s2,16(sp)
    80002c36:	69a2                	ld	s3,8(sp)
    80002c38:	6145                	addi	sp,sp,48
    80002c3a:	8082                	ret
    panic("invalid file system");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	82450513          	addi	a0,a0,-2012 # 80008460 <etext+0x460>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	368080e7          	jalr	872(ra) # 80005fac <panic>

0000000080002c4c <iinit>:
{
    80002c4c:	7179                	addi	sp,sp,-48
    80002c4e:	f406                	sd	ra,40(sp)
    80002c50:	f022                	sd	s0,32(sp)
    80002c52:	ec26                	sd	s1,24(sp)
    80002c54:	e84a                	sd	s2,16(sp)
    80002c56:	e44e                	sd	s3,8(sp)
    80002c58:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c5a:	00006597          	auipc	a1,0x6
    80002c5e:	81e58593          	addi	a1,a1,-2018 # 80008478 <etext+0x478>
    80002c62:	00018517          	auipc	a0,0x18
    80002c66:	92e50513          	addi	a0,a0,-1746 # 8001a590 <itable>
    80002c6a:	00004097          	auipc	ra,0x4
    80002c6e:	82c080e7          	jalr	-2004(ra) # 80006496 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c72:	00018497          	auipc	s1,0x18
    80002c76:	94648493          	addi	s1,s1,-1722 # 8001a5b8 <itable+0x28>
    80002c7a:	00019997          	auipc	s3,0x19
    80002c7e:	3ce98993          	addi	s3,s3,974 # 8001c048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c82:	00005917          	auipc	s2,0x5
    80002c86:	7fe90913          	addi	s2,s2,2046 # 80008480 <etext+0x480>
    80002c8a:	85ca                	mv	a1,s2
    80002c8c:	8526                	mv	a0,s1
    80002c8e:	00001097          	auipc	ra,0x1
    80002c92:	e40080e7          	jalr	-448(ra) # 80003ace <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c96:	08848493          	addi	s1,s1,136
    80002c9a:	ff3498e3          	bne	s1,s3,80002c8a <iinit+0x3e>
}
    80002c9e:	70a2                	ld	ra,40(sp)
    80002ca0:	7402                	ld	s0,32(sp)
    80002ca2:	64e2                	ld	s1,24(sp)
    80002ca4:	6942                	ld	s2,16(sp)
    80002ca6:	69a2                	ld	s3,8(sp)
    80002ca8:	6145                	addi	sp,sp,48
    80002caa:	8082                	ret

0000000080002cac <ialloc>:
{
    80002cac:	7139                	addi	sp,sp,-64
    80002cae:	fc06                	sd	ra,56(sp)
    80002cb0:	f822                	sd	s0,48(sp)
    80002cb2:	f426                	sd	s1,40(sp)
    80002cb4:	f04a                	sd	s2,32(sp)
    80002cb6:	ec4e                	sd	s3,24(sp)
    80002cb8:	e852                	sd	s4,16(sp)
    80002cba:	e456                	sd	s5,8(sp)
    80002cbc:	e05a                	sd	s6,0(sp)
    80002cbe:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cc0:	00018717          	auipc	a4,0x18
    80002cc4:	8bc72703          	lw	a4,-1860(a4) # 8001a57c <sb+0xc>
    80002cc8:	4785                	li	a5,1
    80002cca:	04e7f863          	bgeu	a5,a4,80002d1a <ialloc+0x6e>
    80002cce:	8aaa                	mv	s5,a0
    80002cd0:	8b2e                	mv	s6,a1
    80002cd2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cd4:	00018a17          	auipc	s4,0x18
    80002cd8:	89ca0a13          	addi	s4,s4,-1892 # 8001a570 <sb>
    80002cdc:	00495593          	srli	a1,s2,0x4
    80002ce0:	018a2783          	lw	a5,24(s4)
    80002ce4:	9dbd                	addw	a1,a1,a5
    80002ce6:	8556                	mv	a0,s5
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	95e080e7          	jalr	-1698(ra) # 80002646 <bread>
    80002cf0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cf2:	05850993          	addi	s3,a0,88
    80002cf6:	00f97793          	andi	a5,s2,15
    80002cfa:	079a                	slli	a5,a5,0x6
    80002cfc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cfe:	00099783          	lh	a5,0(s3)
    80002d02:	c785                	beqz	a5,80002d2a <ialloc+0x7e>
    brelse(bp);
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	a72080e7          	jalr	-1422(ra) # 80002776 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d0c:	0905                	addi	s2,s2,1
    80002d0e:	00ca2703          	lw	a4,12(s4)
    80002d12:	0009079b          	sext.w	a5,s2
    80002d16:	fce7e3e3          	bltu	a5,a4,80002cdc <ialloc+0x30>
  panic("ialloc: no inodes");
    80002d1a:	00005517          	auipc	a0,0x5
    80002d1e:	76e50513          	addi	a0,a0,1902 # 80008488 <etext+0x488>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	28a080e7          	jalr	650(ra) # 80005fac <panic>
      memset(dip, 0, sizeof(*dip));
    80002d2a:	04000613          	li	a2,64
    80002d2e:	4581                	li	a1,0
    80002d30:	854e                	mv	a0,s3
    80002d32:	ffffd097          	auipc	ra,0xffffd
    80002d36:	640080e7          	jalr	1600(ra) # 80000372 <memset>
      dip->type = type;
    80002d3a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d3e:	8526                	mv	a0,s1
    80002d40:	00001097          	auipc	ra,0x1
    80002d44:	caa080e7          	jalr	-854(ra) # 800039ea <log_write>
      brelse(bp);
    80002d48:	8526                	mv	a0,s1
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	a2c080e7          	jalr	-1492(ra) # 80002776 <brelse>
      return iget(dev, inum);
    80002d52:	0009059b          	sext.w	a1,s2
    80002d56:	8556                	mv	a0,s5
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	db8080e7          	jalr	-584(ra) # 80002b10 <iget>
}
    80002d60:	70e2                	ld	ra,56(sp)
    80002d62:	7442                	ld	s0,48(sp)
    80002d64:	74a2                	ld	s1,40(sp)
    80002d66:	7902                	ld	s2,32(sp)
    80002d68:	69e2                	ld	s3,24(sp)
    80002d6a:	6a42                	ld	s4,16(sp)
    80002d6c:	6aa2                	ld	s5,8(sp)
    80002d6e:	6b02                	ld	s6,0(sp)
    80002d70:	6121                	addi	sp,sp,64
    80002d72:	8082                	ret

0000000080002d74 <iupdate>:
{
    80002d74:	1101                	addi	sp,sp,-32
    80002d76:	ec06                	sd	ra,24(sp)
    80002d78:	e822                	sd	s0,16(sp)
    80002d7a:	e426                	sd	s1,8(sp)
    80002d7c:	e04a                	sd	s2,0(sp)
    80002d7e:	1000                	addi	s0,sp,32
    80002d80:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d82:	415c                	lw	a5,4(a0)
    80002d84:	0047d79b          	srliw	a5,a5,0x4
    80002d88:	00018597          	auipc	a1,0x18
    80002d8c:	8005a583          	lw	a1,-2048(a1) # 8001a588 <sb+0x18>
    80002d90:	9dbd                	addw	a1,a1,a5
    80002d92:	4108                	lw	a0,0(a0)
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	8b2080e7          	jalr	-1870(ra) # 80002646 <bread>
    80002d9c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d9e:	05850793          	addi	a5,a0,88
    80002da2:	40d8                	lw	a4,4(s1)
    80002da4:	8b3d                	andi	a4,a4,15
    80002da6:	071a                	slli	a4,a4,0x6
    80002da8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002daa:	04449703          	lh	a4,68(s1)
    80002dae:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002db2:	04649703          	lh	a4,70(s1)
    80002db6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dba:	04849703          	lh	a4,72(s1)
    80002dbe:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dc2:	04a49703          	lh	a4,74(s1)
    80002dc6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dca:	44f8                	lw	a4,76(s1)
    80002dcc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dce:	03400613          	li	a2,52
    80002dd2:	05048593          	addi	a1,s1,80
    80002dd6:	00c78513          	addi	a0,a5,12
    80002dda:	ffffd097          	auipc	ra,0xffffd
    80002dde:	5f4080e7          	jalr	1524(ra) # 800003ce <memmove>
  log_write(bp);
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	c06080e7          	jalr	-1018(ra) # 800039ea <log_write>
  brelse(bp);
    80002dec:	854a                	mv	a0,s2
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	988080e7          	jalr	-1656(ra) # 80002776 <brelse>
}
    80002df6:	60e2                	ld	ra,24(sp)
    80002df8:	6442                	ld	s0,16(sp)
    80002dfa:	64a2                	ld	s1,8(sp)
    80002dfc:	6902                	ld	s2,0(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret

0000000080002e02 <idup>:
{
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	1000                	addi	s0,sp,32
    80002e0c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e0e:	00017517          	auipc	a0,0x17
    80002e12:	78250513          	addi	a0,a0,1922 # 8001a590 <itable>
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	710080e7          	jalr	1808(ra) # 80006526 <acquire>
  ip->ref++;
    80002e1e:	449c                	lw	a5,8(s1)
    80002e20:	2785                	addiw	a5,a5,1
    80002e22:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e24:	00017517          	auipc	a0,0x17
    80002e28:	76c50513          	addi	a0,a0,1900 # 8001a590 <itable>
    80002e2c:	00003097          	auipc	ra,0x3
    80002e30:	7ae080e7          	jalr	1966(ra) # 800065da <release>
}
    80002e34:	8526                	mv	a0,s1
    80002e36:	60e2                	ld	ra,24(sp)
    80002e38:	6442                	ld	s0,16(sp)
    80002e3a:	64a2                	ld	s1,8(sp)
    80002e3c:	6105                	addi	sp,sp,32
    80002e3e:	8082                	ret

0000000080002e40 <ilock>:
{
    80002e40:	1101                	addi	sp,sp,-32
    80002e42:	ec06                	sd	ra,24(sp)
    80002e44:	e822                	sd	s0,16(sp)
    80002e46:	e426                	sd	s1,8(sp)
    80002e48:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e4a:	c10d                	beqz	a0,80002e6c <ilock+0x2c>
    80002e4c:	84aa                	mv	s1,a0
    80002e4e:	451c                	lw	a5,8(a0)
    80002e50:	00f05e63          	blez	a5,80002e6c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e54:	0541                	addi	a0,a0,16
    80002e56:	00001097          	auipc	ra,0x1
    80002e5a:	cb2080e7          	jalr	-846(ra) # 80003b08 <acquiresleep>
  if(ip->valid == 0){
    80002e5e:	40bc                	lw	a5,64(s1)
    80002e60:	cf99                	beqz	a5,80002e7e <ilock+0x3e>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret
    80002e6c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e6e:	00005517          	auipc	a0,0x5
    80002e72:	63250513          	addi	a0,a0,1586 # 800084a0 <etext+0x4a0>
    80002e76:	00003097          	auipc	ra,0x3
    80002e7a:	136080e7          	jalr	310(ra) # 80005fac <panic>
    80002e7e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e80:	40dc                	lw	a5,4(s1)
    80002e82:	0047d79b          	srliw	a5,a5,0x4
    80002e86:	00017597          	auipc	a1,0x17
    80002e8a:	7025a583          	lw	a1,1794(a1) # 8001a588 <sb+0x18>
    80002e8e:	9dbd                	addw	a1,a1,a5
    80002e90:	4088                	lw	a0,0(s1)
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	7b4080e7          	jalr	1972(ra) # 80002646 <bread>
    80002e9a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e9c:	05850593          	addi	a1,a0,88
    80002ea0:	40dc                	lw	a5,4(s1)
    80002ea2:	8bbd                	andi	a5,a5,15
    80002ea4:	079a                	slli	a5,a5,0x6
    80002ea6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ea8:	00059783          	lh	a5,0(a1)
    80002eac:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002eb0:	00259783          	lh	a5,2(a1)
    80002eb4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002eb8:	00459783          	lh	a5,4(a1)
    80002ebc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ec0:	00659783          	lh	a5,6(a1)
    80002ec4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ec8:	459c                	lw	a5,8(a1)
    80002eca:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ecc:	03400613          	li	a2,52
    80002ed0:	05b1                	addi	a1,a1,12
    80002ed2:	05048513          	addi	a0,s1,80
    80002ed6:	ffffd097          	auipc	ra,0xffffd
    80002eda:	4f8080e7          	jalr	1272(ra) # 800003ce <memmove>
    brelse(bp);
    80002ede:	854a                	mv	a0,s2
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	896080e7          	jalr	-1898(ra) # 80002776 <brelse>
    ip->valid = 1;
    80002ee8:	4785                	li	a5,1
    80002eea:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002eec:	04449783          	lh	a5,68(s1)
    80002ef0:	c399                	beqz	a5,80002ef6 <ilock+0xb6>
    80002ef2:	6902                	ld	s2,0(sp)
    80002ef4:	b7bd                	j	80002e62 <ilock+0x22>
      panic("ilock: no type");
    80002ef6:	00005517          	auipc	a0,0x5
    80002efa:	5b250513          	addi	a0,a0,1458 # 800084a8 <etext+0x4a8>
    80002efe:	00003097          	auipc	ra,0x3
    80002f02:	0ae080e7          	jalr	174(ra) # 80005fac <panic>

0000000080002f06 <iunlock>:
{
    80002f06:	1101                	addi	sp,sp,-32
    80002f08:	ec06                	sd	ra,24(sp)
    80002f0a:	e822                	sd	s0,16(sp)
    80002f0c:	e426                	sd	s1,8(sp)
    80002f0e:	e04a                	sd	s2,0(sp)
    80002f10:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f12:	c905                	beqz	a0,80002f42 <iunlock+0x3c>
    80002f14:	84aa                	mv	s1,a0
    80002f16:	01050913          	addi	s2,a0,16
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	00001097          	auipc	ra,0x1
    80002f20:	c86080e7          	jalr	-890(ra) # 80003ba2 <holdingsleep>
    80002f24:	cd19                	beqz	a0,80002f42 <iunlock+0x3c>
    80002f26:	449c                	lw	a5,8(s1)
    80002f28:	00f05d63          	blez	a5,80002f42 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	00001097          	auipc	ra,0x1
    80002f32:	c30080e7          	jalr	-976(ra) # 80003b5e <releasesleep>
}
    80002f36:	60e2                	ld	ra,24(sp)
    80002f38:	6442                	ld	s0,16(sp)
    80002f3a:	64a2                	ld	s1,8(sp)
    80002f3c:	6902                	ld	s2,0(sp)
    80002f3e:	6105                	addi	sp,sp,32
    80002f40:	8082                	ret
    panic("iunlock");
    80002f42:	00005517          	auipc	a0,0x5
    80002f46:	57650513          	addi	a0,a0,1398 # 800084b8 <etext+0x4b8>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	062080e7          	jalr	98(ra) # 80005fac <panic>

0000000080002f52 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f52:	7179                	addi	sp,sp,-48
    80002f54:	f406                	sd	ra,40(sp)
    80002f56:	f022                	sd	s0,32(sp)
    80002f58:	ec26                	sd	s1,24(sp)
    80002f5a:	e84a                	sd	s2,16(sp)
    80002f5c:	e44e                	sd	s3,8(sp)
    80002f5e:	1800                	addi	s0,sp,48
    80002f60:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f62:	05050493          	addi	s1,a0,80
    80002f66:	08050913          	addi	s2,a0,128
    80002f6a:	a021                	j	80002f72 <itrunc+0x20>
    80002f6c:	0491                	addi	s1,s1,4
    80002f6e:	01248d63          	beq	s1,s2,80002f88 <itrunc+0x36>
    if(ip->addrs[i]){
    80002f72:	408c                	lw	a1,0(s1)
    80002f74:	dde5                	beqz	a1,80002f6c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f76:	0009a503          	lw	a0,0(s3)
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	910080e7          	jalr	-1776(ra) # 8000288a <bfree>
      ip->addrs[i] = 0;
    80002f82:	0004a023          	sw	zero,0(s1)
    80002f86:	b7dd                	j	80002f6c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f88:	0809a583          	lw	a1,128(s3)
    80002f8c:	ed99                	bnez	a1,80002faa <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f8e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f92:	854e                	mv	a0,s3
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	de0080e7          	jalr	-544(ra) # 80002d74 <iupdate>
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	6145                	addi	sp,sp,48
    80002fa8:	8082                	ret
    80002faa:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fac:	0009a503          	lw	a0,0(s3)
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	696080e7          	jalr	1686(ra) # 80002646 <bread>
    80002fb8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fba:	05850493          	addi	s1,a0,88
    80002fbe:	45850913          	addi	s2,a0,1112
    80002fc2:	a021                	j	80002fca <itrunc+0x78>
    80002fc4:	0491                	addi	s1,s1,4
    80002fc6:	01248b63          	beq	s1,s2,80002fdc <itrunc+0x8a>
      if(a[j])
    80002fca:	408c                	lw	a1,0(s1)
    80002fcc:	dde5                	beqz	a1,80002fc4 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fce:	0009a503          	lw	a0,0(s3)
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	8b8080e7          	jalr	-1864(ra) # 8000288a <bfree>
    80002fda:	b7ed                	j	80002fc4 <itrunc+0x72>
    brelse(bp);
    80002fdc:	8552                	mv	a0,s4
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	798080e7          	jalr	1944(ra) # 80002776 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fe6:	0809a583          	lw	a1,128(s3)
    80002fea:	0009a503          	lw	a0,0(s3)
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	89c080e7          	jalr	-1892(ra) # 8000288a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ff6:	0809a023          	sw	zero,128(s3)
    80002ffa:	6a02                	ld	s4,0(sp)
    80002ffc:	bf49                	j	80002f8e <itrunc+0x3c>

0000000080002ffe <iput>:
{
    80002ffe:	1101                	addi	sp,sp,-32
    80003000:	ec06                	sd	ra,24(sp)
    80003002:	e822                	sd	s0,16(sp)
    80003004:	e426                	sd	s1,8(sp)
    80003006:	1000                	addi	s0,sp,32
    80003008:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000300a:	00017517          	auipc	a0,0x17
    8000300e:	58650513          	addi	a0,a0,1414 # 8001a590 <itable>
    80003012:	00003097          	auipc	ra,0x3
    80003016:	514080e7          	jalr	1300(ra) # 80006526 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000301a:	4498                	lw	a4,8(s1)
    8000301c:	4785                	li	a5,1
    8000301e:	02f70263          	beq	a4,a5,80003042 <iput+0x44>
  ip->ref--;
    80003022:	449c                	lw	a5,8(s1)
    80003024:	37fd                	addiw	a5,a5,-1
    80003026:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003028:	00017517          	auipc	a0,0x17
    8000302c:	56850513          	addi	a0,a0,1384 # 8001a590 <itable>
    80003030:	00003097          	auipc	ra,0x3
    80003034:	5aa080e7          	jalr	1450(ra) # 800065da <release>
}
    80003038:	60e2                	ld	ra,24(sp)
    8000303a:	6442                	ld	s0,16(sp)
    8000303c:	64a2                	ld	s1,8(sp)
    8000303e:	6105                	addi	sp,sp,32
    80003040:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003042:	40bc                	lw	a5,64(s1)
    80003044:	dff9                	beqz	a5,80003022 <iput+0x24>
    80003046:	04a49783          	lh	a5,74(s1)
    8000304a:	ffe1                	bnez	a5,80003022 <iput+0x24>
    8000304c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000304e:	01048913          	addi	s2,s1,16
    80003052:	854a                	mv	a0,s2
    80003054:	00001097          	auipc	ra,0x1
    80003058:	ab4080e7          	jalr	-1356(ra) # 80003b08 <acquiresleep>
    release(&itable.lock);
    8000305c:	00017517          	auipc	a0,0x17
    80003060:	53450513          	addi	a0,a0,1332 # 8001a590 <itable>
    80003064:	00003097          	auipc	ra,0x3
    80003068:	576080e7          	jalr	1398(ra) # 800065da <release>
    itrunc(ip);
    8000306c:	8526                	mv	a0,s1
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	ee4080e7          	jalr	-284(ra) # 80002f52 <itrunc>
    ip->type = 0;
    80003076:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000307a:	8526                	mv	a0,s1
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	cf8080e7          	jalr	-776(ra) # 80002d74 <iupdate>
    ip->valid = 0;
    80003084:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003088:	854a                	mv	a0,s2
    8000308a:	00001097          	auipc	ra,0x1
    8000308e:	ad4080e7          	jalr	-1324(ra) # 80003b5e <releasesleep>
    acquire(&itable.lock);
    80003092:	00017517          	auipc	a0,0x17
    80003096:	4fe50513          	addi	a0,a0,1278 # 8001a590 <itable>
    8000309a:	00003097          	auipc	ra,0x3
    8000309e:	48c080e7          	jalr	1164(ra) # 80006526 <acquire>
    800030a2:	6902                	ld	s2,0(sp)
    800030a4:	bfbd                	j	80003022 <iput+0x24>

00000000800030a6 <iunlockput>:
{
    800030a6:	1101                	addi	sp,sp,-32
    800030a8:	ec06                	sd	ra,24(sp)
    800030aa:	e822                	sd	s0,16(sp)
    800030ac:	e426                	sd	s1,8(sp)
    800030ae:	1000                	addi	s0,sp,32
    800030b0:	84aa                	mv	s1,a0
  iunlock(ip);
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	e54080e7          	jalr	-428(ra) # 80002f06 <iunlock>
  iput(ip);
    800030ba:	8526                	mv	a0,s1
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	f42080e7          	jalr	-190(ra) # 80002ffe <iput>
}
    800030c4:	60e2                	ld	ra,24(sp)
    800030c6:	6442                	ld	s0,16(sp)
    800030c8:	64a2                	ld	s1,8(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030ce:	1141                	addi	sp,sp,-16
    800030d0:	e422                	sd	s0,8(sp)
    800030d2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030d4:	411c                	lw	a5,0(a0)
    800030d6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030d8:	415c                	lw	a5,4(a0)
    800030da:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030dc:	04451783          	lh	a5,68(a0)
    800030e0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030e4:	04a51783          	lh	a5,74(a0)
    800030e8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030ec:	04c56783          	lwu	a5,76(a0)
    800030f0:	e99c                	sd	a5,16(a1)
}
    800030f2:	6422                	ld	s0,8(sp)
    800030f4:	0141                	addi	sp,sp,16
    800030f6:	8082                	ret

00000000800030f8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030f8:	457c                	lw	a5,76(a0)
    800030fa:	0ed7ef63          	bltu	a5,a3,800031f8 <readi+0x100>
{
    800030fe:	7159                	addi	sp,sp,-112
    80003100:	f486                	sd	ra,104(sp)
    80003102:	f0a2                	sd	s0,96(sp)
    80003104:	eca6                	sd	s1,88(sp)
    80003106:	fc56                	sd	s5,56(sp)
    80003108:	f85a                	sd	s6,48(sp)
    8000310a:	f45e                	sd	s7,40(sp)
    8000310c:	f062                	sd	s8,32(sp)
    8000310e:	1880                	addi	s0,sp,112
    80003110:	8baa                	mv	s7,a0
    80003112:	8c2e                	mv	s8,a1
    80003114:	8ab2                	mv	s5,a2
    80003116:	84b6                	mv	s1,a3
    80003118:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000311a:	9f35                	addw	a4,a4,a3
    return 0;
    8000311c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000311e:	0ad76c63          	bltu	a4,a3,800031d6 <readi+0xde>
    80003122:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003124:	00e7f463          	bgeu	a5,a4,8000312c <readi+0x34>
    n = ip->size - off;
    80003128:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000312c:	0c0b0463          	beqz	s6,800031f4 <readi+0xfc>
    80003130:	e8ca                	sd	s2,80(sp)
    80003132:	e0d2                	sd	s4,64(sp)
    80003134:	ec66                	sd	s9,24(sp)
    80003136:	e86a                	sd	s10,16(sp)
    80003138:	e46e                	sd	s11,8(sp)
    8000313a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000313c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003140:	5cfd                	li	s9,-1
    80003142:	a82d                	j	8000317c <readi+0x84>
    80003144:	020a1d93          	slli	s11,s4,0x20
    80003148:	020ddd93          	srli	s11,s11,0x20
    8000314c:	05890613          	addi	a2,s2,88
    80003150:	86ee                	mv	a3,s11
    80003152:	963a                	add	a2,a2,a4
    80003154:	85d6                	mv	a1,s5
    80003156:	8562                	mv	a0,s8
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	a96080e7          	jalr	-1386(ra) # 80001bee <either_copyout>
    80003160:	05950d63          	beq	a0,s9,800031ba <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003164:	854a                	mv	a0,s2
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	610080e7          	jalr	1552(ra) # 80002776 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000316e:	013a09bb          	addw	s3,s4,s3
    80003172:	009a04bb          	addw	s1,s4,s1
    80003176:	9aee                	add	s5,s5,s11
    80003178:	0769f863          	bgeu	s3,s6,800031e8 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000317c:	000ba903          	lw	s2,0(s7)
    80003180:	00a4d59b          	srliw	a1,s1,0xa
    80003184:	855e                	mv	a0,s7
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	8ae080e7          	jalr	-1874(ra) # 80002a34 <bmap>
    8000318e:	0005059b          	sext.w	a1,a0
    80003192:	854a                	mv	a0,s2
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	4b2080e7          	jalr	1202(ra) # 80002646 <bread>
    8000319c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000319e:	3ff4f713          	andi	a4,s1,1023
    800031a2:	40ed07bb          	subw	a5,s10,a4
    800031a6:	413b06bb          	subw	a3,s6,s3
    800031aa:	8a3e                	mv	s4,a5
    800031ac:	2781                	sext.w	a5,a5
    800031ae:	0006861b          	sext.w	a2,a3
    800031b2:	f8f679e3          	bgeu	a2,a5,80003144 <readi+0x4c>
    800031b6:	8a36                	mv	s4,a3
    800031b8:	b771                	j	80003144 <readi+0x4c>
      brelse(bp);
    800031ba:	854a                	mv	a0,s2
    800031bc:	fffff097          	auipc	ra,0xfffff
    800031c0:	5ba080e7          	jalr	1466(ra) # 80002776 <brelse>
      tot = -1;
    800031c4:	59fd                	li	s3,-1
      break;
    800031c6:	6946                	ld	s2,80(sp)
    800031c8:	6a06                	ld	s4,64(sp)
    800031ca:	6ce2                	ld	s9,24(sp)
    800031cc:	6d42                	ld	s10,16(sp)
    800031ce:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031d0:	0009851b          	sext.w	a0,s3
    800031d4:	69a6                	ld	s3,72(sp)
}
    800031d6:	70a6                	ld	ra,104(sp)
    800031d8:	7406                	ld	s0,96(sp)
    800031da:	64e6                	ld	s1,88(sp)
    800031dc:	7ae2                	ld	s5,56(sp)
    800031de:	7b42                	ld	s6,48(sp)
    800031e0:	7ba2                	ld	s7,40(sp)
    800031e2:	7c02                	ld	s8,32(sp)
    800031e4:	6165                	addi	sp,sp,112
    800031e6:	8082                	ret
    800031e8:	6946                	ld	s2,80(sp)
    800031ea:	6a06                	ld	s4,64(sp)
    800031ec:	6ce2                	ld	s9,24(sp)
    800031ee:	6d42                	ld	s10,16(sp)
    800031f0:	6da2                	ld	s11,8(sp)
    800031f2:	bff9                	j	800031d0 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031f4:	89da                	mv	s3,s6
    800031f6:	bfe9                	j	800031d0 <readi+0xd8>
    return 0;
    800031f8:	4501                	li	a0,0
}
    800031fa:	8082                	ret

00000000800031fc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031fc:	457c                	lw	a5,76(a0)
    800031fe:	10d7ee63          	bltu	a5,a3,8000331a <writei+0x11e>
{
    80003202:	7159                	addi	sp,sp,-112
    80003204:	f486                	sd	ra,104(sp)
    80003206:	f0a2                	sd	s0,96(sp)
    80003208:	e8ca                	sd	s2,80(sp)
    8000320a:	fc56                	sd	s5,56(sp)
    8000320c:	f85a                	sd	s6,48(sp)
    8000320e:	f45e                	sd	s7,40(sp)
    80003210:	f062                	sd	s8,32(sp)
    80003212:	1880                	addi	s0,sp,112
    80003214:	8b2a                	mv	s6,a0
    80003216:	8c2e                	mv	s8,a1
    80003218:	8ab2                	mv	s5,a2
    8000321a:	8936                	mv	s2,a3
    8000321c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000321e:	00e687bb          	addw	a5,a3,a4
    80003222:	0ed7ee63          	bltu	a5,a3,8000331e <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003226:	00043737          	lui	a4,0x43
    8000322a:	0ef76c63          	bltu	a4,a5,80003322 <writei+0x126>
    8000322e:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003230:	0c0b8d63          	beqz	s7,8000330a <writei+0x10e>
    80003234:	eca6                	sd	s1,88(sp)
    80003236:	e4ce                	sd	s3,72(sp)
    80003238:	ec66                	sd	s9,24(sp)
    8000323a:	e86a                	sd	s10,16(sp)
    8000323c:	e46e                	sd	s11,8(sp)
    8000323e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003240:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003244:	5cfd                	li	s9,-1
    80003246:	a091                	j	8000328a <writei+0x8e>
    80003248:	02099d93          	slli	s11,s3,0x20
    8000324c:	020ddd93          	srli	s11,s11,0x20
    80003250:	05848513          	addi	a0,s1,88
    80003254:	86ee                	mv	a3,s11
    80003256:	8656                	mv	a2,s5
    80003258:	85e2                	mv	a1,s8
    8000325a:	953a                	add	a0,a0,a4
    8000325c:	fffff097          	auipc	ra,0xfffff
    80003260:	9e8080e7          	jalr	-1560(ra) # 80001c44 <either_copyin>
    80003264:	07950263          	beq	a0,s9,800032c8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003268:	8526                	mv	a0,s1
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	780080e7          	jalr	1920(ra) # 800039ea <log_write>
    brelse(bp);
    80003272:	8526                	mv	a0,s1
    80003274:	fffff097          	auipc	ra,0xfffff
    80003278:	502080e7          	jalr	1282(ra) # 80002776 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000327c:	01498a3b          	addw	s4,s3,s4
    80003280:	0129893b          	addw	s2,s3,s2
    80003284:	9aee                	add	s5,s5,s11
    80003286:	057a7663          	bgeu	s4,s7,800032d2 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000328a:	000b2483          	lw	s1,0(s6)
    8000328e:	00a9559b          	srliw	a1,s2,0xa
    80003292:	855a                	mv	a0,s6
    80003294:	fffff097          	auipc	ra,0xfffff
    80003298:	7a0080e7          	jalr	1952(ra) # 80002a34 <bmap>
    8000329c:	0005059b          	sext.w	a1,a0
    800032a0:	8526                	mv	a0,s1
    800032a2:	fffff097          	auipc	ra,0xfffff
    800032a6:	3a4080e7          	jalr	932(ra) # 80002646 <bread>
    800032aa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032ac:	3ff97713          	andi	a4,s2,1023
    800032b0:	40ed07bb          	subw	a5,s10,a4
    800032b4:	414b86bb          	subw	a3,s7,s4
    800032b8:	89be                	mv	s3,a5
    800032ba:	2781                	sext.w	a5,a5
    800032bc:	0006861b          	sext.w	a2,a3
    800032c0:	f8f674e3          	bgeu	a2,a5,80003248 <writei+0x4c>
    800032c4:	89b6                	mv	s3,a3
    800032c6:	b749                	j	80003248 <writei+0x4c>
      brelse(bp);
    800032c8:	8526                	mv	a0,s1
    800032ca:	fffff097          	auipc	ra,0xfffff
    800032ce:	4ac080e7          	jalr	1196(ra) # 80002776 <brelse>
  }

  if(off > ip->size)
    800032d2:	04cb2783          	lw	a5,76(s6)
    800032d6:	0327fc63          	bgeu	a5,s2,8000330e <writei+0x112>
    ip->size = off;
    800032da:	052b2623          	sw	s2,76(s6)
    800032de:	64e6                	ld	s1,88(sp)
    800032e0:	69a6                	ld	s3,72(sp)
    800032e2:	6ce2                	ld	s9,24(sp)
    800032e4:	6d42                	ld	s10,16(sp)
    800032e6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032e8:	855a                	mv	a0,s6
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	a8a080e7          	jalr	-1398(ra) # 80002d74 <iupdate>

  return tot;
    800032f2:	000a051b          	sext.w	a0,s4
    800032f6:	6a06                	ld	s4,64(sp)
}
    800032f8:	70a6                	ld	ra,104(sp)
    800032fa:	7406                	ld	s0,96(sp)
    800032fc:	6946                	ld	s2,80(sp)
    800032fe:	7ae2                	ld	s5,56(sp)
    80003300:	7b42                	ld	s6,48(sp)
    80003302:	7ba2                	ld	s7,40(sp)
    80003304:	7c02                	ld	s8,32(sp)
    80003306:	6165                	addi	sp,sp,112
    80003308:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000330a:	8a5e                	mv	s4,s7
    8000330c:	bff1                	j	800032e8 <writei+0xec>
    8000330e:	64e6                	ld	s1,88(sp)
    80003310:	69a6                	ld	s3,72(sp)
    80003312:	6ce2                	ld	s9,24(sp)
    80003314:	6d42                	ld	s10,16(sp)
    80003316:	6da2                	ld	s11,8(sp)
    80003318:	bfc1                	j	800032e8 <writei+0xec>
    return -1;
    8000331a:	557d                	li	a0,-1
}
    8000331c:	8082                	ret
    return -1;
    8000331e:	557d                	li	a0,-1
    80003320:	bfe1                	j	800032f8 <writei+0xfc>
    return -1;
    80003322:	557d                	li	a0,-1
    80003324:	bfd1                	j	800032f8 <writei+0xfc>

0000000080003326 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003326:	1141                	addi	sp,sp,-16
    80003328:	e406                	sd	ra,8(sp)
    8000332a:	e022                	sd	s0,0(sp)
    8000332c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000332e:	4639                	li	a2,14
    80003330:	ffffd097          	auipc	ra,0xffffd
    80003334:	112080e7          	jalr	274(ra) # 80000442 <strncmp>
}
    80003338:	60a2                	ld	ra,8(sp)
    8000333a:	6402                	ld	s0,0(sp)
    8000333c:	0141                	addi	sp,sp,16
    8000333e:	8082                	ret

0000000080003340 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003340:	7139                	addi	sp,sp,-64
    80003342:	fc06                	sd	ra,56(sp)
    80003344:	f822                	sd	s0,48(sp)
    80003346:	f426                	sd	s1,40(sp)
    80003348:	f04a                	sd	s2,32(sp)
    8000334a:	ec4e                	sd	s3,24(sp)
    8000334c:	e852                	sd	s4,16(sp)
    8000334e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003350:	04451703          	lh	a4,68(a0)
    80003354:	4785                	li	a5,1
    80003356:	00f71a63          	bne	a4,a5,8000336a <dirlookup+0x2a>
    8000335a:	892a                	mv	s2,a0
    8000335c:	89ae                	mv	s3,a1
    8000335e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003360:	457c                	lw	a5,76(a0)
    80003362:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003364:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003366:	e79d                	bnez	a5,80003394 <dirlookup+0x54>
    80003368:	a8a5                	j	800033e0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000336a:	00005517          	auipc	a0,0x5
    8000336e:	15650513          	addi	a0,a0,342 # 800084c0 <etext+0x4c0>
    80003372:	00003097          	auipc	ra,0x3
    80003376:	c3a080e7          	jalr	-966(ra) # 80005fac <panic>
      panic("dirlookup read");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	15e50513          	addi	a0,a0,350 # 800084d8 <etext+0x4d8>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	c2a080e7          	jalr	-982(ra) # 80005fac <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000338a:	24c1                	addiw	s1,s1,16
    8000338c:	04c92783          	lw	a5,76(s2)
    80003390:	04f4f763          	bgeu	s1,a5,800033de <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003394:	4741                	li	a4,16
    80003396:	86a6                	mv	a3,s1
    80003398:	fc040613          	addi	a2,s0,-64
    8000339c:	4581                	li	a1,0
    8000339e:	854a                	mv	a0,s2
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	d58080e7          	jalr	-680(ra) # 800030f8 <readi>
    800033a8:	47c1                	li	a5,16
    800033aa:	fcf518e3          	bne	a0,a5,8000337a <dirlookup+0x3a>
    if(de.inum == 0)
    800033ae:	fc045783          	lhu	a5,-64(s0)
    800033b2:	dfe1                	beqz	a5,8000338a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033b4:	fc240593          	addi	a1,s0,-62
    800033b8:	854e                	mv	a0,s3
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	f6c080e7          	jalr	-148(ra) # 80003326 <namecmp>
    800033c2:	f561                	bnez	a0,8000338a <dirlookup+0x4a>
      if(poff)
    800033c4:	000a0463          	beqz	s4,800033cc <dirlookup+0x8c>
        *poff = off;
    800033c8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033cc:	fc045583          	lhu	a1,-64(s0)
    800033d0:	00092503          	lw	a0,0(s2)
    800033d4:	fffff097          	auipc	ra,0xfffff
    800033d8:	73c080e7          	jalr	1852(ra) # 80002b10 <iget>
    800033dc:	a011                	j	800033e0 <dirlookup+0xa0>
  return 0;
    800033de:	4501                	li	a0,0
}
    800033e0:	70e2                	ld	ra,56(sp)
    800033e2:	7442                	ld	s0,48(sp)
    800033e4:	74a2                	ld	s1,40(sp)
    800033e6:	7902                	ld	s2,32(sp)
    800033e8:	69e2                	ld	s3,24(sp)
    800033ea:	6a42                	ld	s4,16(sp)
    800033ec:	6121                	addi	sp,sp,64
    800033ee:	8082                	ret

00000000800033f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033f0:	711d                	addi	sp,sp,-96
    800033f2:	ec86                	sd	ra,88(sp)
    800033f4:	e8a2                	sd	s0,80(sp)
    800033f6:	e4a6                	sd	s1,72(sp)
    800033f8:	e0ca                	sd	s2,64(sp)
    800033fa:	fc4e                	sd	s3,56(sp)
    800033fc:	f852                	sd	s4,48(sp)
    800033fe:	f456                	sd	s5,40(sp)
    80003400:	f05a                	sd	s6,32(sp)
    80003402:	ec5e                	sd	s7,24(sp)
    80003404:	e862                	sd	s8,16(sp)
    80003406:	e466                	sd	s9,8(sp)
    80003408:	1080                	addi	s0,sp,96
    8000340a:	84aa                	mv	s1,a0
    8000340c:	8b2e                	mv	s6,a1
    8000340e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003410:	00054703          	lbu	a4,0(a0)
    80003414:	02f00793          	li	a5,47
    80003418:	02f70263          	beq	a4,a5,8000343c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000341c:	ffffe097          	auipc	ra,0xffffe
    80003420:	d68080e7          	jalr	-664(ra) # 80001184 <myproc>
    80003424:	15053503          	ld	a0,336(a0)
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	9da080e7          	jalr	-1574(ra) # 80002e02 <idup>
    80003430:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003432:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003436:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003438:	4b85                	li	s7,1
    8000343a:	a875                	j	800034f6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000343c:	4585                	li	a1,1
    8000343e:	4505                	li	a0,1
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	6d0080e7          	jalr	1744(ra) # 80002b10 <iget>
    80003448:	8a2a                	mv	s4,a0
    8000344a:	b7e5                	j	80003432 <namex+0x42>
      iunlockput(ip);
    8000344c:	8552                	mv	a0,s4
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	c58080e7          	jalr	-936(ra) # 800030a6 <iunlockput>
      return 0;
    80003456:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003458:	8552                	mv	a0,s4
    8000345a:	60e6                	ld	ra,88(sp)
    8000345c:	6446                	ld	s0,80(sp)
    8000345e:	64a6                	ld	s1,72(sp)
    80003460:	6906                	ld	s2,64(sp)
    80003462:	79e2                	ld	s3,56(sp)
    80003464:	7a42                	ld	s4,48(sp)
    80003466:	7aa2                	ld	s5,40(sp)
    80003468:	7b02                	ld	s6,32(sp)
    8000346a:	6be2                	ld	s7,24(sp)
    8000346c:	6c42                	ld	s8,16(sp)
    8000346e:	6ca2                	ld	s9,8(sp)
    80003470:	6125                	addi	sp,sp,96
    80003472:	8082                	ret
      iunlock(ip);
    80003474:	8552                	mv	a0,s4
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	a90080e7          	jalr	-1392(ra) # 80002f06 <iunlock>
      return ip;
    8000347e:	bfe9                	j	80003458 <namex+0x68>
      iunlockput(ip);
    80003480:	8552                	mv	a0,s4
    80003482:	00000097          	auipc	ra,0x0
    80003486:	c24080e7          	jalr	-988(ra) # 800030a6 <iunlockput>
      return 0;
    8000348a:	8a4e                	mv	s4,s3
    8000348c:	b7f1                	j	80003458 <namex+0x68>
  len = path - s;
    8000348e:	40998633          	sub	a2,s3,s1
    80003492:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003496:	099c5863          	bge	s8,s9,80003526 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000349a:	4639                	li	a2,14
    8000349c:	85a6                	mv	a1,s1
    8000349e:	8556                	mv	a0,s5
    800034a0:	ffffd097          	auipc	ra,0xffffd
    800034a4:	f2e080e7          	jalr	-210(ra) # 800003ce <memmove>
    800034a8:	84ce                	mv	s1,s3
  while(*path == '/')
    800034aa:	0004c783          	lbu	a5,0(s1)
    800034ae:	01279763          	bne	a5,s2,800034bc <namex+0xcc>
    path++;
    800034b2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034b4:	0004c783          	lbu	a5,0(s1)
    800034b8:	ff278de3          	beq	a5,s2,800034b2 <namex+0xc2>
    ilock(ip);
    800034bc:	8552                	mv	a0,s4
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	982080e7          	jalr	-1662(ra) # 80002e40 <ilock>
    if(ip->type != T_DIR){
    800034c6:	044a1783          	lh	a5,68(s4)
    800034ca:	f97791e3          	bne	a5,s7,8000344c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034ce:	000b0563          	beqz	s6,800034d8 <namex+0xe8>
    800034d2:	0004c783          	lbu	a5,0(s1)
    800034d6:	dfd9                	beqz	a5,80003474 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034d8:	4601                	li	a2,0
    800034da:	85d6                	mv	a1,s5
    800034dc:	8552                	mv	a0,s4
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	e62080e7          	jalr	-414(ra) # 80003340 <dirlookup>
    800034e6:	89aa                	mv	s3,a0
    800034e8:	dd41                	beqz	a0,80003480 <namex+0x90>
    iunlockput(ip);
    800034ea:	8552                	mv	a0,s4
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	bba080e7          	jalr	-1094(ra) # 800030a6 <iunlockput>
    ip = next;
    800034f4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034f6:	0004c783          	lbu	a5,0(s1)
    800034fa:	01279763          	bne	a5,s2,80003508 <namex+0x118>
    path++;
    800034fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003500:	0004c783          	lbu	a5,0(s1)
    80003504:	ff278de3          	beq	a5,s2,800034fe <namex+0x10e>
  if(*path == 0)
    80003508:	cb9d                	beqz	a5,8000353e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000350a:	0004c783          	lbu	a5,0(s1)
    8000350e:	89a6                	mv	s3,s1
  len = path - s;
    80003510:	4c81                	li	s9,0
    80003512:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003514:	01278963          	beq	a5,s2,80003526 <namex+0x136>
    80003518:	dbbd                	beqz	a5,8000348e <namex+0x9e>
    path++;
    8000351a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000351c:	0009c783          	lbu	a5,0(s3)
    80003520:	ff279ce3          	bne	a5,s2,80003518 <namex+0x128>
    80003524:	b7ad                	j	8000348e <namex+0x9e>
    memmove(name, s, len);
    80003526:	2601                	sext.w	a2,a2
    80003528:	85a6                	mv	a1,s1
    8000352a:	8556                	mv	a0,s5
    8000352c:	ffffd097          	auipc	ra,0xffffd
    80003530:	ea2080e7          	jalr	-350(ra) # 800003ce <memmove>
    name[len] = 0;
    80003534:	9cd6                	add	s9,s9,s5
    80003536:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000353a:	84ce                	mv	s1,s3
    8000353c:	b7bd                	j	800034aa <namex+0xba>
  if(nameiparent){
    8000353e:	f00b0de3          	beqz	s6,80003458 <namex+0x68>
    iput(ip);
    80003542:	8552                	mv	a0,s4
    80003544:	00000097          	auipc	ra,0x0
    80003548:	aba080e7          	jalr	-1350(ra) # 80002ffe <iput>
    return 0;
    8000354c:	4a01                	li	s4,0
    8000354e:	b729                	j	80003458 <namex+0x68>

0000000080003550 <dirlink>:
{
    80003550:	7139                	addi	sp,sp,-64
    80003552:	fc06                	sd	ra,56(sp)
    80003554:	f822                	sd	s0,48(sp)
    80003556:	f04a                	sd	s2,32(sp)
    80003558:	ec4e                	sd	s3,24(sp)
    8000355a:	e852                	sd	s4,16(sp)
    8000355c:	0080                	addi	s0,sp,64
    8000355e:	892a                	mv	s2,a0
    80003560:	8a2e                	mv	s4,a1
    80003562:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003564:	4601                	li	a2,0
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	dda080e7          	jalr	-550(ra) # 80003340 <dirlookup>
    8000356e:	ed25                	bnez	a0,800035e6 <dirlink+0x96>
    80003570:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003572:	04c92483          	lw	s1,76(s2)
    80003576:	c49d                	beqz	s1,800035a4 <dirlink+0x54>
    80003578:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000357a:	4741                	li	a4,16
    8000357c:	86a6                	mv	a3,s1
    8000357e:	fc040613          	addi	a2,s0,-64
    80003582:	4581                	li	a1,0
    80003584:	854a                	mv	a0,s2
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	b72080e7          	jalr	-1166(ra) # 800030f8 <readi>
    8000358e:	47c1                	li	a5,16
    80003590:	06f51163          	bne	a0,a5,800035f2 <dirlink+0xa2>
    if(de.inum == 0)
    80003594:	fc045783          	lhu	a5,-64(s0)
    80003598:	c791                	beqz	a5,800035a4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000359a:	24c1                	addiw	s1,s1,16
    8000359c:	04c92783          	lw	a5,76(s2)
    800035a0:	fcf4ede3          	bltu	s1,a5,8000357a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035a4:	4639                	li	a2,14
    800035a6:	85d2                	mv	a1,s4
    800035a8:	fc240513          	addi	a0,s0,-62
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	ecc080e7          	jalr	-308(ra) # 80000478 <strncpy>
  de.inum = inum;
    800035b4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035b8:	4741                	li	a4,16
    800035ba:	86a6                	mv	a3,s1
    800035bc:	fc040613          	addi	a2,s0,-64
    800035c0:	4581                	li	a1,0
    800035c2:	854a                	mv	a0,s2
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	c38080e7          	jalr	-968(ra) # 800031fc <writei>
    800035cc:	872a                	mv	a4,a0
    800035ce:	47c1                	li	a5,16
  return 0;
    800035d0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035d2:	02f71863          	bne	a4,a5,80003602 <dirlink+0xb2>
    800035d6:	74a2                	ld	s1,40(sp)
}
    800035d8:	70e2                	ld	ra,56(sp)
    800035da:	7442                	ld	s0,48(sp)
    800035dc:	7902                	ld	s2,32(sp)
    800035de:	69e2                	ld	s3,24(sp)
    800035e0:	6a42                	ld	s4,16(sp)
    800035e2:	6121                	addi	sp,sp,64
    800035e4:	8082                	ret
    iput(ip);
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	a18080e7          	jalr	-1512(ra) # 80002ffe <iput>
    return -1;
    800035ee:	557d                	li	a0,-1
    800035f0:	b7e5                	j	800035d8 <dirlink+0x88>
      panic("dirlink read");
    800035f2:	00005517          	auipc	a0,0x5
    800035f6:	ef650513          	addi	a0,a0,-266 # 800084e8 <etext+0x4e8>
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	9b2080e7          	jalr	-1614(ra) # 80005fac <panic>
    panic("dirlink");
    80003602:	00005517          	auipc	a0,0x5
    80003606:	ff650513          	addi	a0,a0,-10 # 800085f8 <etext+0x5f8>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	9a2080e7          	jalr	-1630(ra) # 80005fac <panic>

0000000080003612 <namei>:

struct inode*
namei(char *path)
{
    80003612:	1101                	addi	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000361a:	fe040613          	addi	a2,s0,-32
    8000361e:	4581                	li	a1,0
    80003620:	00000097          	auipc	ra,0x0
    80003624:	dd0080e7          	jalr	-560(ra) # 800033f0 <namex>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	6105                	addi	sp,sp,32
    8000362e:	8082                	ret

0000000080003630 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003630:	1141                	addi	sp,sp,-16
    80003632:	e406                	sd	ra,8(sp)
    80003634:	e022                	sd	s0,0(sp)
    80003636:	0800                	addi	s0,sp,16
    80003638:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000363a:	4585                	li	a1,1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	db4080e7          	jalr	-588(ra) # 800033f0 <namex>
}
    80003644:	60a2                	ld	ra,8(sp)
    80003646:	6402                	ld	s0,0(sp)
    80003648:	0141                	addi	sp,sp,16
    8000364a:	8082                	ret

000000008000364c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000364c:	1101                	addi	sp,sp,-32
    8000364e:	ec06                	sd	ra,24(sp)
    80003650:	e822                	sd	s0,16(sp)
    80003652:	e426                	sd	s1,8(sp)
    80003654:	e04a                	sd	s2,0(sp)
    80003656:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003658:	00019917          	auipc	s2,0x19
    8000365c:	9e090913          	addi	s2,s2,-1568 # 8001c038 <log>
    80003660:	01892583          	lw	a1,24(s2)
    80003664:	02892503          	lw	a0,40(s2)
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	fde080e7          	jalr	-34(ra) # 80002646 <bread>
    80003670:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003672:	02c92603          	lw	a2,44(s2)
    80003676:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003678:	00c05f63          	blez	a2,80003696 <write_head+0x4a>
    8000367c:	00019717          	auipc	a4,0x19
    80003680:	9ec70713          	addi	a4,a4,-1556 # 8001c068 <log+0x30>
    80003684:	87aa                	mv	a5,a0
    80003686:	060a                	slli	a2,a2,0x2
    80003688:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000368a:	4314                	lw	a3,0(a4)
    8000368c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000368e:	0711                	addi	a4,a4,4
    80003690:	0791                	addi	a5,a5,4
    80003692:	fec79ce3          	bne	a5,a2,8000368a <write_head+0x3e>
  }
  bwrite(buf);
    80003696:	8526                	mv	a0,s1
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	0a0080e7          	jalr	160(ra) # 80002738 <bwrite>
  brelse(buf);
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	0d4080e7          	jalr	212(ra) # 80002776 <brelse>
}
    800036aa:	60e2                	ld	ra,24(sp)
    800036ac:	6442                	ld	s0,16(sp)
    800036ae:	64a2                	ld	s1,8(sp)
    800036b0:	6902                	ld	s2,0(sp)
    800036b2:	6105                	addi	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b6:	00019797          	auipc	a5,0x19
    800036ba:	9ae7a783          	lw	a5,-1618(a5) # 8001c064 <log+0x2c>
    800036be:	0af05d63          	blez	a5,80003778 <install_trans+0xc2>
{
    800036c2:	7139                	addi	sp,sp,-64
    800036c4:	fc06                	sd	ra,56(sp)
    800036c6:	f822                	sd	s0,48(sp)
    800036c8:	f426                	sd	s1,40(sp)
    800036ca:	f04a                	sd	s2,32(sp)
    800036cc:	ec4e                	sd	s3,24(sp)
    800036ce:	e852                	sd	s4,16(sp)
    800036d0:	e456                	sd	s5,8(sp)
    800036d2:	e05a                	sd	s6,0(sp)
    800036d4:	0080                	addi	s0,sp,64
    800036d6:	8b2a                	mv	s6,a0
    800036d8:	00019a97          	auipc	s5,0x19
    800036dc:	990a8a93          	addi	s5,s5,-1648 # 8001c068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036e2:	00019997          	auipc	s3,0x19
    800036e6:	95698993          	addi	s3,s3,-1706 # 8001c038 <log>
    800036ea:	a00d                	j	8000370c <install_trans+0x56>
    brelse(lbuf);
    800036ec:	854a                	mv	a0,s2
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	088080e7          	jalr	136(ra) # 80002776 <brelse>
    brelse(dbuf);
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	07e080e7          	jalr	126(ra) # 80002776 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003700:	2a05                	addiw	s4,s4,1
    80003702:	0a91                	addi	s5,s5,4
    80003704:	02c9a783          	lw	a5,44(s3)
    80003708:	04fa5e63          	bge	s4,a5,80003764 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000370c:	0189a583          	lw	a1,24(s3)
    80003710:	014585bb          	addw	a1,a1,s4
    80003714:	2585                	addiw	a1,a1,1
    80003716:	0289a503          	lw	a0,40(s3)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	f2c080e7          	jalr	-212(ra) # 80002646 <bread>
    80003722:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	0289a503          	lw	a0,40(s3)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	f1a080e7          	jalr	-230(ra) # 80002646 <bread>
    80003734:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003736:	40000613          	li	a2,1024
    8000373a:	05890593          	addi	a1,s2,88
    8000373e:	05850513          	addi	a0,a0,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	c8c080e7          	jalr	-884(ra) # 800003ce <memmove>
    bwrite(dbuf);  // write dst to disk
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	fec080e7          	jalr	-20(ra) # 80002738 <bwrite>
    if(recovering == 0)
    80003754:	f80b1ce3          	bnez	s6,800036ec <install_trans+0x36>
      bunpin(dbuf);
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	0f4080e7          	jalr	244(ra) # 8000284e <bunpin>
    80003762:	b769                	j	800036ec <install_trans+0x36>
}
    80003764:	70e2                	ld	ra,56(sp)
    80003766:	7442                	ld	s0,48(sp)
    80003768:	74a2                	ld	s1,40(sp)
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	6b02                	ld	s6,0(sp)
    80003774:	6121                	addi	sp,sp,64
    80003776:	8082                	ret
    80003778:	8082                	ret

000000008000377a <initlog>:
{
    8000377a:	7179                	addi	sp,sp,-48
    8000377c:	f406                	sd	ra,40(sp)
    8000377e:	f022                	sd	s0,32(sp)
    80003780:	ec26                	sd	s1,24(sp)
    80003782:	e84a                	sd	s2,16(sp)
    80003784:	e44e                	sd	s3,8(sp)
    80003786:	1800                	addi	s0,sp,48
    80003788:	892a                	mv	s2,a0
    8000378a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000378c:	00019497          	auipc	s1,0x19
    80003790:	8ac48493          	addi	s1,s1,-1876 # 8001c038 <log>
    80003794:	00005597          	auipc	a1,0x5
    80003798:	d6458593          	addi	a1,a1,-668 # 800084f8 <etext+0x4f8>
    8000379c:	8526                	mv	a0,s1
    8000379e:	00003097          	auipc	ra,0x3
    800037a2:	cf8080e7          	jalr	-776(ra) # 80006496 <initlock>
  log.start = sb->logstart;
    800037a6:	0149a583          	lw	a1,20(s3)
    800037aa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037ac:	0109a783          	lw	a5,16(s3)
    800037b0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037b2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037b6:	854a                	mv	a0,s2
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	e8e080e7          	jalr	-370(ra) # 80002646 <bread>
  log.lh.n = lh->n;
    800037c0:	4d30                	lw	a2,88(a0)
    800037c2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	00c05f63          	blez	a2,800037e2 <initlog+0x68>
    800037c8:	87aa                	mv	a5,a0
    800037ca:	00019717          	auipc	a4,0x19
    800037ce:	89e70713          	addi	a4,a4,-1890 # 8001c068 <log+0x30>
    800037d2:	060a                	slli	a2,a2,0x2
    800037d4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037d6:	4ff4                	lw	a3,92(a5)
    800037d8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037da:	0791                	addi	a5,a5,4
    800037dc:	0711                	addi	a4,a4,4
    800037de:	fec79ce3          	bne	a5,a2,800037d6 <initlog+0x5c>
  brelse(buf);
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	f94080e7          	jalr	-108(ra) # 80002776 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037ea:	4505                	li	a0,1
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	eca080e7          	jalr	-310(ra) # 800036b6 <install_trans>
  log.lh.n = 0;
    800037f4:	00019797          	auipc	a5,0x19
    800037f8:	8607a823          	sw	zero,-1936(a5) # 8001c064 <log+0x2c>
  write_head(); // clear the log
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	e50080e7          	jalr	-432(ra) # 8000364c <write_head>
}
    80003804:	70a2                	ld	ra,40(sp)
    80003806:	7402                	ld	s0,32(sp)
    80003808:	64e2                	ld	s1,24(sp)
    8000380a:	6942                	ld	s2,16(sp)
    8000380c:	69a2                	ld	s3,8(sp)
    8000380e:	6145                	addi	sp,sp,48
    80003810:	8082                	ret

0000000080003812 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000381e:	00019517          	auipc	a0,0x19
    80003822:	81a50513          	addi	a0,a0,-2022 # 8001c038 <log>
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	d00080e7          	jalr	-768(ra) # 80006526 <acquire>
  while(1){
    if(log.committing){
    8000382e:	00019497          	auipc	s1,0x19
    80003832:	80a48493          	addi	s1,s1,-2038 # 8001c038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003836:	4979                	li	s2,30
    80003838:	a039                	j	80003846 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000383a:	85a6                	mv	a1,s1
    8000383c:	8526                	mv	a0,s1
    8000383e:	ffffe097          	auipc	ra,0xffffe
    80003842:	00c080e7          	jalr	12(ra) # 8000184a <sleep>
    if(log.committing){
    80003846:	50dc                	lw	a5,36(s1)
    80003848:	fbed                	bnez	a5,8000383a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000384a:	5098                	lw	a4,32(s1)
    8000384c:	2705                	addiw	a4,a4,1
    8000384e:	0027179b          	slliw	a5,a4,0x2
    80003852:	9fb9                	addw	a5,a5,a4
    80003854:	0017979b          	slliw	a5,a5,0x1
    80003858:	54d4                	lw	a3,44(s1)
    8000385a:	9fb5                	addw	a5,a5,a3
    8000385c:	00f95963          	bge	s2,a5,8000386e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003860:	85a6                	mv	a1,s1
    80003862:	8526                	mv	a0,s1
    80003864:	ffffe097          	auipc	ra,0xffffe
    80003868:	fe6080e7          	jalr	-26(ra) # 8000184a <sleep>
    8000386c:	bfe9                	j	80003846 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000386e:	00018517          	auipc	a0,0x18
    80003872:	7ca50513          	addi	a0,a0,1994 # 8001c038 <log>
    80003876:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	d62080e7          	jalr	-670(ra) # 800065da <release>
      break;
    }
  }
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000388c:	7139                	addi	sp,sp,-64
    8000388e:	fc06                	sd	ra,56(sp)
    80003890:	f822                	sd	s0,48(sp)
    80003892:	f426                	sd	s1,40(sp)
    80003894:	f04a                	sd	s2,32(sp)
    80003896:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003898:	00018497          	auipc	s1,0x18
    8000389c:	7a048493          	addi	s1,s1,1952 # 8001c038 <log>
    800038a0:	8526                	mv	a0,s1
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	c84080e7          	jalr	-892(ra) # 80006526 <acquire>
  log.outstanding -= 1;
    800038aa:	509c                	lw	a5,32(s1)
    800038ac:	37fd                	addiw	a5,a5,-1
    800038ae:	0007891b          	sext.w	s2,a5
    800038b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800038b4:	50dc                	lw	a5,36(s1)
    800038b6:	e7b9                	bnez	a5,80003904 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800038b8:	06091163          	bnez	s2,8000391a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038bc:	00018497          	auipc	s1,0x18
    800038c0:	77c48493          	addi	s1,s1,1916 # 8001c038 <log>
    800038c4:	4785                	li	a5,1
    800038c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038c8:	8526                	mv	a0,s1
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	d10080e7          	jalr	-752(ra) # 800065da <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038d2:	54dc                	lw	a5,44(s1)
    800038d4:	06f04763          	bgtz	a5,80003942 <end_op+0xb6>
    acquire(&log.lock);
    800038d8:	00018497          	auipc	s1,0x18
    800038dc:	76048493          	addi	s1,s1,1888 # 8001c038 <log>
    800038e0:	8526                	mv	a0,s1
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	c44080e7          	jalr	-956(ra) # 80006526 <acquire>
    log.committing = 0;
    800038ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038ee:	8526                	mv	a0,s1
    800038f0:	ffffe097          	auipc	ra,0xffffe
    800038f4:	0e6080e7          	jalr	230(ra) # 800019d6 <wakeup>
    release(&log.lock);
    800038f8:	8526                	mv	a0,s1
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	ce0080e7          	jalr	-800(ra) # 800065da <release>
}
    80003902:	a815                	j	80003936 <end_op+0xaa>
    80003904:	ec4e                	sd	s3,24(sp)
    80003906:	e852                	sd	s4,16(sp)
    80003908:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000390a:	00005517          	auipc	a0,0x5
    8000390e:	bf650513          	addi	a0,a0,-1034 # 80008500 <etext+0x500>
    80003912:	00002097          	auipc	ra,0x2
    80003916:	69a080e7          	jalr	1690(ra) # 80005fac <panic>
    wakeup(&log);
    8000391a:	00018497          	auipc	s1,0x18
    8000391e:	71e48493          	addi	s1,s1,1822 # 8001c038 <log>
    80003922:	8526                	mv	a0,s1
    80003924:	ffffe097          	auipc	ra,0xffffe
    80003928:	0b2080e7          	jalr	178(ra) # 800019d6 <wakeup>
  release(&log.lock);
    8000392c:	8526                	mv	a0,s1
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	cac080e7          	jalr	-852(ra) # 800065da <release>
}
    80003936:	70e2                	ld	ra,56(sp)
    80003938:	7442                	ld	s0,48(sp)
    8000393a:	74a2                	ld	s1,40(sp)
    8000393c:	7902                	ld	s2,32(sp)
    8000393e:	6121                	addi	sp,sp,64
    80003940:	8082                	ret
    80003942:	ec4e                	sd	s3,24(sp)
    80003944:	e852                	sd	s4,16(sp)
    80003946:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003948:	00018a97          	auipc	s5,0x18
    8000394c:	720a8a93          	addi	s5,s5,1824 # 8001c068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003950:	00018a17          	auipc	s4,0x18
    80003954:	6e8a0a13          	addi	s4,s4,1768 # 8001c038 <log>
    80003958:	018a2583          	lw	a1,24(s4)
    8000395c:	012585bb          	addw	a1,a1,s2
    80003960:	2585                	addiw	a1,a1,1
    80003962:	028a2503          	lw	a0,40(s4)
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	ce0080e7          	jalr	-800(ra) # 80002646 <bread>
    8000396e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003970:	000aa583          	lw	a1,0(s5)
    80003974:	028a2503          	lw	a0,40(s4)
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	cce080e7          	jalr	-818(ra) # 80002646 <bread>
    80003980:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003982:	40000613          	li	a2,1024
    80003986:	05850593          	addi	a1,a0,88
    8000398a:	05848513          	addi	a0,s1,88
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	a40080e7          	jalr	-1472(ra) # 800003ce <memmove>
    bwrite(to);  // write the log
    80003996:	8526                	mv	a0,s1
    80003998:	fffff097          	auipc	ra,0xfffff
    8000399c:	da0080e7          	jalr	-608(ra) # 80002738 <bwrite>
    brelse(from);
    800039a0:	854e                	mv	a0,s3
    800039a2:	fffff097          	auipc	ra,0xfffff
    800039a6:	dd4080e7          	jalr	-556(ra) # 80002776 <brelse>
    brelse(to);
    800039aa:	8526                	mv	a0,s1
    800039ac:	fffff097          	auipc	ra,0xfffff
    800039b0:	dca080e7          	jalr	-566(ra) # 80002776 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039b4:	2905                	addiw	s2,s2,1
    800039b6:	0a91                	addi	s5,s5,4
    800039b8:	02ca2783          	lw	a5,44(s4)
    800039bc:	f8f94ee3          	blt	s2,a5,80003958 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	c8c080e7          	jalr	-884(ra) # 8000364c <write_head>
    install_trans(0); // Now install writes to home locations
    800039c8:	4501                	li	a0,0
    800039ca:	00000097          	auipc	ra,0x0
    800039ce:	cec080e7          	jalr	-788(ra) # 800036b6 <install_trans>
    log.lh.n = 0;
    800039d2:	00018797          	auipc	a5,0x18
    800039d6:	6807a923          	sw	zero,1682(a5) # 8001c064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800039da:	00000097          	auipc	ra,0x0
    800039de:	c72080e7          	jalr	-910(ra) # 8000364c <write_head>
    800039e2:	69e2                	ld	s3,24(sp)
    800039e4:	6a42                	ld	s4,16(sp)
    800039e6:	6aa2                	ld	s5,8(sp)
    800039e8:	bdc5                	j	800038d8 <end_op+0x4c>

00000000800039ea <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039ea:	1101                	addi	sp,sp,-32
    800039ec:	ec06                	sd	ra,24(sp)
    800039ee:	e822                	sd	s0,16(sp)
    800039f0:	e426                	sd	s1,8(sp)
    800039f2:	e04a                	sd	s2,0(sp)
    800039f4:	1000                	addi	s0,sp,32
    800039f6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039f8:	00018917          	auipc	s2,0x18
    800039fc:	64090913          	addi	s2,s2,1600 # 8001c038 <log>
    80003a00:	854a                	mv	a0,s2
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	b24080e7          	jalr	-1244(ra) # 80006526 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a0a:	02c92603          	lw	a2,44(s2)
    80003a0e:	47f5                	li	a5,29
    80003a10:	06c7c563          	blt	a5,a2,80003a7a <log_write+0x90>
    80003a14:	00018797          	auipc	a5,0x18
    80003a18:	6407a783          	lw	a5,1600(a5) # 8001c054 <log+0x1c>
    80003a1c:	37fd                	addiw	a5,a5,-1
    80003a1e:	04f65e63          	bge	a2,a5,80003a7a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a22:	00018797          	auipc	a5,0x18
    80003a26:	6367a783          	lw	a5,1590(a5) # 8001c058 <log+0x20>
    80003a2a:	06f05063          	blez	a5,80003a8a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a2e:	4781                	li	a5,0
    80003a30:	06c05563          	blez	a2,80003a9a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a34:	44cc                	lw	a1,12(s1)
    80003a36:	00018717          	auipc	a4,0x18
    80003a3a:	63270713          	addi	a4,a4,1586 # 8001c068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a3e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a40:	4314                	lw	a3,0(a4)
    80003a42:	04b68c63          	beq	a3,a1,80003a9a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a46:	2785                	addiw	a5,a5,1
    80003a48:	0711                	addi	a4,a4,4
    80003a4a:	fef61be3          	bne	a2,a5,80003a40 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a4e:	0621                	addi	a2,a2,8
    80003a50:	060a                	slli	a2,a2,0x2
    80003a52:	00018797          	auipc	a5,0x18
    80003a56:	5e678793          	addi	a5,a5,1510 # 8001c038 <log>
    80003a5a:	97b2                	add	a5,a5,a2
    80003a5c:	44d8                	lw	a4,12(s1)
    80003a5e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a60:	8526                	mv	a0,s1
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	db0080e7          	jalr	-592(ra) # 80002812 <bpin>
    log.lh.n++;
    80003a6a:	00018717          	auipc	a4,0x18
    80003a6e:	5ce70713          	addi	a4,a4,1486 # 8001c038 <log>
    80003a72:	575c                	lw	a5,44(a4)
    80003a74:	2785                	addiw	a5,a5,1
    80003a76:	d75c                	sw	a5,44(a4)
    80003a78:	a82d                	j	80003ab2 <log_write+0xc8>
    panic("too big a transaction");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	a9650513          	addi	a0,a0,-1386 # 80008510 <etext+0x510>
    80003a82:	00002097          	auipc	ra,0x2
    80003a86:	52a080e7          	jalr	1322(ra) # 80005fac <panic>
    panic("log_write outside of trans");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	a9e50513          	addi	a0,a0,-1378 # 80008528 <etext+0x528>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	51a080e7          	jalr	1306(ra) # 80005fac <panic>
  log.lh.block[i] = b->blockno;
    80003a9a:	00878693          	addi	a3,a5,8
    80003a9e:	068a                	slli	a3,a3,0x2
    80003aa0:	00018717          	auipc	a4,0x18
    80003aa4:	59870713          	addi	a4,a4,1432 # 8001c038 <log>
    80003aa8:	9736                	add	a4,a4,a3
    80003aaa:	44d4                	lw	a3,12(s1)
    80003aac:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aae:	faf609e3          	beq	a2,a5,80003a60 <log_write+0x76>
  }
  release(&log.lock);
    80003ab2:	00018517          	auipc	a0,0x18
    80003ab6:	58650513          	addi	a0,a0,1414 # 8001c038 <log>
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	b20080e7          	jalr	-1248(ra) # 800065da <release>
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ace:	1101                	addi	sp,sp,-32
    80003ad0:	ec06                	sd	ra,24(sp)
    80003ad2:	e822                	sd	s0,16(sp)
    80003ad4:	e426                	sd	s1,8(sp)
    80003ad6:	e04a                	sd	s2,0(sp)
    80003ad8:	1000                	addi	s0,sp,32
    80003ada:	84aa                	mv	s1,a0
    80003adc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ade:	00005597          	auipc	a1,0x5
    80003ae2:	a6a58593          	addi	a1,a1,-1430 # 80008548 <etext+0x548>
    80003ae6:	0521                	addi	a0,a0,8
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	9ae080e7          	jalr	-1618(ra) # 80006496 <initlock>
  lk->name = name;
    80003af0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003af4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003af8:	0204a423          	sw	zero,40(s1)
}
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b08:	1101                	addi	sp,sp,-32
    80003b0a:	ec06                	sd	ra,24(sp)
    80003b0c:	e822                	sd	s0,16(sp)
    80003b0e:	e426                	sd	s1,8(sp)
    80003b10:	e04a                	sd	s2,0(sp)
    80003b12:	1000                	addi	s0,sp,32
    80003b14:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b16:	00850913          	addi	s2,a0,8
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	a0a080e7          	jalr	-1526(ra) # 80006526 <acquire>
  while (lk->locked) {
    80003b24:	409c                	lw	a5,0(s1)
    80003b26:	cb89                	beqz	a5,80003b38 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b28:	85ca                	mv	a1,s2
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	ffffe097          	auipc	ra,0xffffe
    80003b30:	d1e080e7          	jalr	-738(ra) # 8000184a <sleep>
  while (lk->locked) {
    80003b34:	409c                	lw	a5,0(s1)
    80003b36:	fbed                	bnez	a5,80003b28 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b38:	4785                	li	a5,1
    80003b3a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	648080e7          	jalr	1608(ra) # 80001184 <myproc>
    80003b44:	591c                	lw	a5,48(a0)
    80003b46:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b48:	854a                	mv	a0,s2
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	a90080e7          	jalr	-1392(ra) # 800065da <release>
}
    80003b52:	60e2                	ld	ra,24(sp)
    80003b54:	6442                	ld	s0,16(sp)
    80003b56:	64a2                	ld	s1,8(sp)
    80003b58:	6902                	ld	s2,0(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	e04a                	sd	s2,0(sp)
    80003b68:	1000                	addi	s0,sp,32
    80003b6a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b6c:	00850913          	addi	s2,a0,8
    80003b70:	854a                	mv	a0,s2
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	9b4080e7          	jalr	-1612(ra) # 80006526 <acquire>
  lk->locked = 0;
    80003b7a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b7e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b82:	8526                	mv	a0,s1
    80003b84:	ffffe097          	auipc	ra,0xffffe
    80003b88:	e52080e7          	jalr	-430(ra) # 800019d6 <wakeup>
  release(&lk->lk);
    80003b8c:	854a                	mv	a0,s2
    80003b8e:	00003097          	auipc	ra,0x3
    80003b92:	a4c080e7          	jalr	-1460(ra) # 800065da <release>
}
    80003b96:	60e2                	ld	ra,24(sp)
    80003b98:	6442                	ld	s0,16(sp)
    80003b9a:	64a2                	ld	s1,8(sp)
    80003b9c:	6902                	ld	s2,0(sp)
    80003b9e:	6105                	addi	sp,sp,32
    80003ba0:	8082                	ret

0000000080003ba2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ba2:	7179                	addi	sp,sp,-48
    80003ba4:	f406                	sd	ra,40(sp)
    80003ba6:	f022                	sd	s0,32(sp)
    80003ba8:	ec26                	sd	s1,24(sp)
    80003baa:	e84a                	sd	s2,16(sp)
    80003bac:	1800                	addi	s0,sp,48
    80003bae:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bb0:	00850913          	addi	s2,a0,8
    80003bb4:	854a                	mv	a0,s2
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	970080e7          	jalr	-1680(ra) # 80006526 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bbe:	409c                	lw	a5,0(s1)
    80003bc0:	ef91                	bnez	a5,80003bdc <holdingsleep+0x3a>
    80003bc2:	4481                	li	s1,0
  release(&lk->lk);
    80003bc4:	854a                	mv	a0,s2
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	a14080e7          	jalr	-1516(ra) # 800065da <release>
  return r;
}
    80003bce:	8526                	mv	a0,s1
    80003bd0:	70a2                	ld	ra,40(sp)
    80003bd2:	7402                	ld	s0,32(sp)
    80003bd4:	64e2                	ld	s1,24(sp)
    80003bd6:	6942                	ld	s2,16(sp)
    80003bd8:	6145                	addi	sp,sp,48
    80003bda:	8082                	ret
    80003bdc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bde:	0284a983          	lw	s3,40(s1)
    80003be2:	ffffd097          	auipc	ra,0xffffd
    80003be6:	5a2080e7          	jalr	1442(ra) # 80001184 <myproc>
    80003bea:	5904                	lw	s1,48(a0)
    80003bec:	413484b3          	sub	s1,s1,s3
    80003bf0:	0014b493          	seqz	s1,s1
    80003bf4:	69a2                	ld	s3,8(sp)
    80003bf6:	b7f9                	j	80003bc4 <holdingsleep+0x22>

0000000080003bf8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bf8:	1141                	addi	sp,sp,-16
    80003bfa:	e406                	sd	ra,8(sp)
    80003bfc:	e022                	sd	s0,0(sp)
    80003bfe:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c00:	00005597          	auipc	a1,0x5
    80003c04:	95858593          	addi	a1,a1,-1704 # 80008558 <etext+0x558>
    80003c08:	00018517          	auipc	a0,0x18
    80003c0c:	57850513          	addi	a0,a0,1400 # 8001c180 <ftable>
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	886080e7          	jalr	-1914(ra) # 80006496 <initlock>
}
    80003c18:	60a2                	ld	ra,8(sp)
    80003c1a:	6402                	ld	s0,0(sp)
    80003c1c:	0141                	addi	sp,sp,16
    80003c1e:	8082                	ret

0000000080003c20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c20:	1101                	addi	sp,sp,-32
    80003c22:	ec06                	sd	ra,24(sp)
    80003c24:	e822                	sd	s0,16(sp)
    80003c26:	e426                	sd	s1,8(sp)
    80003c28:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c2a:	00018517          	auipc	a0,0x18
    80003c2e:	55650513          	addi	a0,a0,1366 # 8001c180 <ftable>
    80003c32:	00003097          	auipc	ra,0x3
    80003c36:	8f4080e7          	jalr	-1804(ra) # 80006526 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c3a:	00018497          	auipc	s1,0x18
    80003c3e:	55e48493          	addi	s1,s1,1374 # 8001c198 <ftable+0x18>
    80003c42:	00019717          	auipc	a4,0x19
    80003c46:	4f670713          	addi	a4,a4,1270 # 8001d138 <ftable+0xfb8>
    if(f->ref == 0){
    80003c4a:	40dc                	lw	a5,4(s1)
    80003c4c:	cf99                	beqz	a5,80003c6a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c4e:	02848493          	addi	s1,s1,40
    80003c52:	fee49ce3          	bne	s1,a4,80003c4a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c56:	00018517          	auipc	a0,0x18
    80003c5a:	52a50513          	addi	a0,a0,1322 # 8001c180 <ftable>
    80003c5e:	00003097          	auipc	ra,0x3
    80003c62:	97c080e7          	jalr	-1668(ra) # 800065da <release>
  return 0;
    80003c66:	4481                	li	s1,0
    80003c68:	a819                	j	80003c7e <filealloc+0x5e>
      f->ref = 1;
    80003c6a:	4785                	li	a5,1
    80003c6c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c6e:	00018517          	auipc	a0,0x18
    80003c72:	51250513          	addi	a0,a0,1298 # 8001c180 <ftable>
    80003c76:	00003097          	auipc	ra,0x3
    80003c7a:	964080e7          	jalr	-1692(ra) # 800065da <release>
}
    80003c7e:	8526                	mv	a0,s1
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	64a2                	ld	s1,8(sp)
    80003c86:	6105                	addi	sp,sp,32
    80003c88:	8082                	ret

0000000080003c8a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c8a:	1101                	addi	sp,sp,-32
    80003c8c:	ec06                	sd	ra,24(sp)
    80003c8e:	e822                	sd	s0,16(sp)
    80003c90:	e426                	sd	s1,8(sp)
    80003c92:	1000                	addi	s0,sp,32
    80003c94:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c96:	00018517          	auipc	a0,0x18
    80003c9a:	4ea50513          	addi	a0,a0,1258 # 8001c180 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	888080e7          	jalr	-1912(ra) # 80006526 <acquire>
  if(f->ref < 1)
    80003ca6:	40dc                	lw	a5,4(s1)
    80003ca8:	02f05263          	blez	a5,80003ccc <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cac:	2785                	addiw	a5,a5,1
    80003cae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cb0:	00018517          	auipc	a0,0x18
    80003cb4:	4d050513          	addi	a0,a0,1232 # 8001c180 <ftable>
    80003cb8:	00003097          	auipc	ra,0x3
    80003cbc:	922080e7          	jalr	-1758(ra) # 800065da <release>
  return f;
}
    80003cc0:	8526                	mv	a0,s1
    80003cc2:	60e2                	ld	ra,24(sp)
    80003cc4:	6442                	ld	s0,16(sp)
    80003cc6:	64a2                	ld	s1,8(sp)
    80003cc8:	6105                	addi	sp,sp,32
    80003cca:	8082                	ret
    panic("filedup");
    80003ccc:	00005517          	auipc	a0,0x5
    80003cd0:	89450513          	addi	a0,a0,-1900 # 80008560 <etext+0x560>
    80003cd4:	00002097          	auipc	ra,0x2
    80003cd8:	2d8080e7          	jalr	728(ra) # 80005fac <panic>

0000000080003cdc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cdc:	7139                	addi	sp,sp,-64
    80003cde:	fc06                	sd	ra,56(sp)
    80003ce0:	f822                	sd	s0,48(sp)
    80003ce2:	f426                	sd	s1,40(sp)
    80003ce4:	0080                	addi	s0,sp,64
    80003ce6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ce8:	00018517          	auipc	a0,0x18
    80003cec:	49850513          	addi	a0,a0,1176 # 8001c180 <ftable>
    80003cf0:	00003097          	auipc	ra,0x3
    80003cf4:	836080e7          	jalr	-1994(ra) # 80006526 <acquire>
  if(f->ref < 1)
    80003cf8:	40dc                	lw	a5,4(s1)
    80003cfa:	04f05c63          	blez	a5,80003d52 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003cfe:	37fd                	addiw	a5,a5,-1
    80003d00:	0007871b          	sext.w	a4,a5
    80003d04:	c0dc                	sw	a5,4(s1)
    80003d06:	06e04263          	bgtz	a4,80003d6a <fileclose+0x8e>
    80003d0a:	f04a                	sd	s2,32(sp)
    80003d0c:	ec4e                	sd	s3,24(sp)
    80003d0e:	e852                	sd	s4,16(sp)
    80003d10:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d12:	0004a903          	lw	s2,0(s1)
    80003d16:	0094ca83          	lbu	s5,9(s1)
    80003d1a:	0104ba03          	ld	s4,16(s1)
    80003d1e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d22:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d26:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d2a:	00018517          	auipc	a0,0x18
    80003d2e:	45650513          	addi	a0,a0,1110 # 8001c180 <ftable>
    80003d32:	00003097          	auipc	ra,0x3
    80003d36:	8a8080e7          	jalr	-1880(ra) # 800065da <release>

  if(ff.type == FD_PIPE){
    80003d3a:	4785                	li	a5,1
    80003d3c:	04f90463          	beq	s2,a5,80003d84 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d40:	3979                	addiw	s2,s2,-2
    80003d42:	4785                	li	a5,1
    80003d44:	0527fb63          	bgeu	a5,s2,80003d9a <fileclose+0xbe>
    80003d48:	7902                	ld	s2,32(sp)
    80003d4a:	69e2                	ld	s3,24(sp)
    80003d4c:	6a42                	ld	s4,16(sp)
    80003d4e:	6aa2                	ld	s5,8(sp)
    80003d50:	a02d                	j	80003d7a <fileclose+0x9e>
    80003d52:	f04a                	sd	s2,32(sp)
    80003d54:	ec4e                	sd	s3,24(sp)
    80003d56:	e852                	sd	s4,16(sp)
    80003d58:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d5a:	00005517          	auipc	a0,0x5
    80003d5e:	80e50513          	addi	a0,a0,-2034 # 80008568 <etext+0x568>
    80003d62:	00002097          	auipc	ra,0x2
    80003d66:	24a080e7          	jalr	586(ra) # 80005fac <panic>
    release(&ftable.lock);
    80003d6a:	00018517          	auipc	a0,0x18
    80003d6e:	41650513          	addi	a0,a0,1046 # 8001c180 <ftable>
    80003d72:	00003097          	auipc	ra,0x3
    80003d76:	868080e7          	jalr	-1944(ra) # 800065da <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d7a:	70e2                	ld	ra,56(sp)
    80003d7c:	7442                	ld	s0,48(sp)
    80003d7e:	74a2                	ld	s1,40(sp)
    80003d80:	6121                	addi	sp,sp,64
    80003d82:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d84:	85d6                	mv	a1,s5
    80003d86:	8552                	mv	a0,s4
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	3a2080e7          	jalr	930(ra) # 8000412a <pipeclose>
    80003d90:	7902                	ld	s2,32(sp)
    80003d92:	69e2                	ld	s3,24(sp)
    80003d94:	6a42                	ld	s4,16(sp)
    80003d96:	6aa2                	ld	s5,8(sp)
    80003d98:	b7cd                	j	80003d7a <fileclose+0x9e>
    begin_op();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	a78080e7          	jalr	-1416(ra) # 80003812 <begin_op>
    iput(ff.ip);
    80003da2:	854e                	mv	a0,s3
    80003da4:	fffff097          	auipc	ra,0xfffff
    80003da8:	25a080e7          	jalr	602(ra) # 80002ffe <iput>
    end_op();
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	ae0080e7          	jalr	-1312(ra) # 8000388c <end_op>
    80003db4:	7902                	ld	s2,32(sp)
    80003db6:	69e2                	ld	s3,24(sp)
    80003db8:	6a42                	ld	s4,16(sp)
    80003dba:	6aa2                	ld	s5,8(sp)
    80003dbc:	bf7d                	j	80003d7a <fileclose+0x9e>

0000000080003dbe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003dbe:	715d                	addi	sp,sp,-80
    80003dc0:	e486                	sd	ra,72(sp)
    80003dc2:	e0a2                	sd	s0,64(sp)
    80003dc4:	fc26                	sd	s1,56(sp)
    80003dc6:	f44e                	sd	s3,40(sp)
    80003dc8:	0880                	addi	s0,sp,80
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dce:	ffffd097          	auipc	ra,0xffffd
    80003dd2:	3b6080e7          	jalr	950(ra) # 80001184 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003dd6:	409c                	lw	a5,0(s1)
    80003dd8:	37f9                	addiw	a5,a5,-2
    80003dda:	4705                	li	a4,1
    80003ddc:	04f76863          	bltu	a4,a5,80003e2c <filestat+0x6e>
    80003de0:	f84a                	sd	s2,48(sp)
    80003de2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003de4:	6c88                	ld	a0,24(s1)
    80003de6:	fffff097          	auipc	ra,0xfffff
    80003dea:	05a080e7          	jalr	90(ra) # 80002e40 <ilock>
    stati(f->ip, &st);
    80003dee:	fb840593          	addi	a1,s0,-72
    80003df2:	6c88                	ld	a0,24(s1)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	2da080e7          	jalr	730(ra) # 800030ce <stati>
    iunlock(f->ip);
    80003dfc:	6c88                	ld	a0,24(s1)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	108080e7          	jalr	264(ra) # 80002f06 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e06:	46e1                	li	a3,24
    80003e08:	fb840613          	addi	a2,s0,-72
    80003e0c:	85ce                	mv	a1,s3
    80003e0e:	05093503          	ld	a0,80(s2)
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	126080e7          	jalr	294(ra) # 80000f38 <copyout>
    80003e1a:	41f5551b          	sraiw	a0,a0,0x1f
    80003e1e:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e20:	60a6                	ld	ra,72(sp)
    80003e22:	6406                	ld	s0,64(sp)
    80003e24:	74e2                	ld	s1,56(sp)
    80003e26:	79a2                	ld	s3,40(sp)
    80003e28:	6161                	addi	sp,sp,80
    80003e2a:	8082                	ret
  return -1;
    80003e2c:	557d                	li	a0,-1
    80003e2e:	bfcd                	j	80003e20 <filestat+0x62>

0000000080003e30 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e30:	7179                	addi	sp,sp,-48
    80003e32:	f406                	sd	ra,40(sp)
    80003e34:	f022                	sd	s0,32(sp)
    80003e36:	e84a                	sd	s2,16(sp)
    80003e38:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e3a:	00854783          	lbu	a5,8(a0)
    80003e3e:	cbc5                	beqz	a5,80003eee <fileread+0xbe>
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e44e                	sd	s3,8(sp)
    80003e44:	84aa                	mv	s1,a0
    80003e46:	89ae                	mv	s3,a1
    80003e48:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e4a:	411c                	lw	a5,0(a0)
    80003e4c:	4705                	li	a4,1
    80003e4e:	04e78963          	beq	a5,a4,80003ea0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e52:	470d                	li	a4,3
    80003e54:	04e78f63          	beq	a5,a4,80003eb2 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e58:	4709                	li	a4,2
    80003e5a:	08e79263          	bne	a5,a4,80003ede <fileread+0xae>
    ilock(f->ip);
    80003e5e:	6d08                	ld	a0,24(a0)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	fe0080e7          	jalr	-32(ra) # 80002e40 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e68:	874a                	mv	a4,s2
    80003e6a:	5094                	lw	a3,32(s1)
    80003e6c:	864e                	mv	a2,s3
    80003e6e:	4585                	li	a1,1
    80003e70:	6c88                	ld	a0,24(s1)
    80003e72:	fffff097          	auipc	ra,0xfffff
    80003e76:	286080e7          	jalr	646(ra) # 800030f8 <readi>
    80003e7a:	892a                	mv	s2,a0
    80003e7c:	00a05563          	blez	a0,80003e86 <fileread+0x56>
      f->off += r;
    80003e80:	509c                	lw	a5,32(s1)
    80003e82:	9fa9                	addw	a5,a5,a0
    80003e84:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e86:	6c88                	ld	a0,24(s1)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	07e080e7          	jalr	126(ra) # 80002f06 <iunlock>
    80003e90:	64e2                	ld	s1,24(sp)
    80003e92:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e94:	854a                	mv	a0,s2
    80003e96:	70a2                	ld	ra,40(sp)
    80003e98:	7402                	ld	s0,32(sp)
    80003e9a:	6942                	ld	s2,16(sp)
    80003e9c:	6145                	addi	sp,sp,48
    80003e9e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ea0:	6908                	ld	a0,16(a0)
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	3fa080e7          	jalr	1018(ra) # 8000429c <piperead>
    80003eaa:	892a                	mv	s2,a0
    80003eac:	64e2                	ld	s1,24(sp)
    80003eae:	69a2                	ld	s3,8(sp)
    80003eb0:	b7d5                	j	80003e94 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003eb2:	02451783          	lh	a5,36(a0)
    80003eb6:	03079693          	slli	a3,a5,0x30
    80003eba:	92c1                	srli	a3,a3,0x30
    80003ebc:	4725                	li	a4,9
    80003ebe:	02d76a63          	bltu	a4,a3,80003ef2 <fileread+0xc2>
    80003ec2:	0792                	slli	a5,a5,0x4
    80003ec4:	00018717          	auipc	a4,0x18
    80003ec8:	21c70713          	addi	a4,a4,540 # 8001c0e0 <devsw>
    80003ecc:	97ba                	add	a5,a5,a4
    80003ece:	639c                	ld	a5,0(a5)
    80003ed0:	c78d                	beqz	a5,80003efa <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ed2:	4505                	li	a0,1
    80003ed4:	9782                	jalr	a5
    80003ed6:	892a                	mv	s2,a0
    80003ed8:	64e2                	ld	s1,24(sp)
    80003eda:	69a2                	ld	s3,8(sp)
    80003edc:	bf65                	j	80003e94 <fileread+0x64>
    panic("fileread");
    80003ede:	00004517          	auipc	a0,0x4
    80003ee2:	69a50513          	addi	a0,a0,1690 # 80008578 <etext+0x578>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	0c6080e7          	jalr	198(ra) # 80005fac <panic>
    return -1;
    80003eee:	597d                	li	s2,-1
    80003ef0:	b755                	j	80003e94 <fileread+0x64>
      return -1;
    80003ef2:	597d                	li	s2,-1
    80003ef4:	64e2                	ld	s1,24(sp)
    80003ef6:	69a2                	ld	s3,8(sp)
    80003ef8:	bf71                	j	80003e94 <fileread+0x64>
    80003efa:	597d                	li	s2,-1
    80003efc:	64e2                	ld	s1,24(sp)
    80003efe:	69a2                	ld	s3,8(sp)
    80003f00:	bf51                	j	80003e94 <fileread+0x64>

0000000080003f02 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f02:	00954783          	lbu	a5,9(a0)
    80003f06:	12078963          	beqz	a5,80004038 <filewrite+0x136>
{
    80003f0a:	715d                	addi	sp,sp,-80
    80003f0c:	e486                	sd	ra,72(sp)
    80003f0e:	e0a2                	sd	s0,64(sp)
    80003f10:	f84a                	sd	s2,48(sp)
    80003f12:	f052                	sd	s4,32(sp)
    80003f14:	e85a                	sd	s6,16(sp)
    80003f16:	0880                	addi	s0,sp,80
    80003f18:	892a                	mv	s2,a0
    80003f1a:	8b2e                	mv	s6,a1
    80003f1c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f1e:	411c                	lw	a5,0(a0)
    80003f20:	4705                	li	a4,1
    80003f22:	02e78763          	beq	a5,a4,80003f50 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f26:	470d                	li	a4,3
    80003f28:	02e78a63          	beq	a5,a4,80003f5c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f2c:	4709                	li	a4,2
    80003f2e:	0ee79863          	bne	a5,a4,8000401e <filewrite+0x11c>
    80003f32:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f34:	0cc05463          	blez	a2,80003ffc <filewrite+0xfa>
    80003f38:	fc26                	sd	s1,56(sp)
    80003f3a:	ec56                	sd	s5,24(sp)
    80003f3c:	e45e                	sd	s7,8(sp)
    80003f3e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f40:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f42:	6b85                	lui	s7,0x1
    80003f44:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f48:	6c05                	lui	s8,0x1
    80003f4a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f4e:	a851                	j	80003fe2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f50:	6908                	ld	a0,16(a0)
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	248080e7          	jalr	584(ra) # 8000419a <pipewrite>
    80003f5a:	a85d                	j	80004010 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f5c:	02451783          	lh	a5,36(a0)
    80003f60:	03079693          	slli	a3,a5,0x30
    80003f64:	92c1                	srli	a3,a3,0x30
    80003f66:	4725                	li	a4,9
    80003f68:	0cd76a63          	bltu	a4,a3,8000403c <filewrite+0x13a>
    80003f6c:	0792                	slli	a5,a5,0x4
    80003f6e:	00018717          	auipc	a4,0x18
    80003f72:	17270713          	addi	a4,a4,370 # 8001c0e0 <devsw>
    80003f76:	97ba                	add	a5,a5,a4
    80003f78:	679c                	ld	a5,8(a5)
    80003f7a:	c3f9                	beqz	a5,80004040 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f7c:	4505                	li	a0,1
    80003f7e:	9782                	jalr	a5
    80003f80:	a841                	j	80004010 <filewrite+0x10e>
      if(n1 > max)
    80003f82:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f86:	00000097          	auipc	ra,0x0
    80003f8a:	88c080e7          	jalr	-1908(ra) # 80003812 <begin_op>
      ilock(f->ip);
    80003f8e:	01893503          	ld	a0,24(s2)
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	eae080e7          	jalr	-338(ra) # 80002e40 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f9a:	8756                	mv	a4,s5
    80003f9c:	02092683          	lw	a3,32(s2)
    80003fa0:	01698633          	add	a2,s3,s6
    80003fa4:	4585                	li	a1,1
    80003fa6:	01893503          	ld	a0,24(s2)
    80003faa:	fffff097          	auipc	ra,0xfffff
    80003fae:	252080e7          	jalr	594(ra) # 800031fc <writei>
    80003fb2:	84aa                	mv	s1,a0
    80003fb4:	00a05763          	blez	a0,80003fc2 <filewrite+0xc0>
        f->off += r;
    80003fb8:	02092783          	lw	a5,32(s2)
    80003fbc:	9fa9                	addw	a5,a5,a0
    80003fbe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fc2:	01893503          	ld	a0,24(s2)
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	f40080e7          	jalr	-192(ra) # 80002f06 <iunlock>
      end_op();
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	8be080e7          	jalr	-1858(ra) # 8000388c <end_op>

      if(r != n1){
    80003fd6:	029a9563          	bne	s5,s1,80004000 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fda:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fde:	0149da63          	bge	s3,s4,80003ff2 <filewrite+0xf0>
      int n1 = n - i;
    80003fe2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fe6:	0004879b          	sext.w	a5,s1
    80003fea:	f8fbdce3          	bge	s7,a5,80003f82 <filewrite+0x80>
    80003fee:	84e2                	mv	s1,s8
    80003ff0:	bf49                	j	80003f82 <filewrite+0x80>
    80003ff2:	74e2                	ld	s1,56(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6ba2                	ld	s7,8(sp)
    80003ff8:	6c02                	ld	s8,0(sp)
    80003ffa:	a039                	j	80004008 <filewrite+0x106>
    int i = 0;
    80003ffc:	4981                	li	s3,0
    80003ffe:	a029                	j	80004008 <filewrite+0x106>
    80004000:	74e2                	ld	s1,56(sp)
    80004002:	6ae2                	ld	s5,24(sp)
    80004004:	6ba2                	ld	s7,8(sp)
    80004006:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004008:	033a1e63          	bne	s4,s3,80004044 <filewrite+0x142>
    8000400c:	8552                	mv	a0,s4
    8000400e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004010:	60a6                	ld	ra,72(sp)
    80004012:	6406                	ld	s0,64(sp)
    80004014:	7942                	ld	s2,48(sp)
    80004016:	7a02                	ld	s4,32(sp)
    80004018:	6b42                	ld	s6,16(sp)
    8000401a:	6161                	addi	sp,sp,80
    8000401c:	8082                	ret
    8000401e:	fc26                	sd	s1,56(sp)
    80004020:	f44e                	sd	s3,40(sp)
    80004022:	ec56                	sd	s5,24(sp)
    80004024:	e45e                	sd	s7,8(sp)
    80004026:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004028:	00004517          	auipc	a0,0x4
    8000402c:	56050513          	addi	a0,a0,1376 # 80008588 <etext+0x588>
    80004030:	00002097          	auipc	ra,0x2
    80004034:	f7c080e7          	jalr	-132(ra) # 80005fac <panic>
    return -1;
    80004038:	557d                	li	a0,-1
}
    8000403a:	8082                	ret
      return -1;
    8000403c:	557d                	li	a0,-1
    8000403e:	bfc9                	j	80004010 <filewrite+0x10e>
    80004040:	557d                	li	a0,-1
    80004042:	b7f9                	j	80004010 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004044:	557d                	li	a0,-1
    80004046:	79a2                	ld	s3,40(sp)
    80004048:	b7e1                	j	80004010 <filewrite+0x10e>

000000008000404a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000404a:	7179                	addi	sp,sp,-48
    8000404c:	f406                	sd	ra,40(sp)
    8000404e:	f022                	sd	s0,32(sp)
    80004050:	ec26                	sd	s1,24(sp)
    80004052:	e052                	sd	s4,0(sp)
    80004054:	1800                	addi	s0,sp,48
    80004056:	84aa                	mv	s1,a0
    80004058:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000405a:	0005b023          	sd	zero,0(a1)
    8000405e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004062:	00000097          	auipc	ra,0x0
    80004066:	bbe080e7          	jalr	-1090(ra) # 80003c20 <filealloc>
    8000406a:	e088                	sd	a0,0(s1)
    8000406c:	cd49                	beqz	a0,80004106 <pipealloc+0xbc>
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	bb2080e7          	jalr	-1102(ra) # 80003c20 <filealloc>
    80004076:	00aa3023          	sd	a0,0(s4)
    8000407a:	c141                	beqz	a0,800040fa <pipealloc+0xb0>
    8000407c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000407e:	ffffc097          	auipc	ra,0xffffc
    80004082:	28a080e7          	jalr	650(ra) # 80000308 <kalloc>
    80004086:	892a                	mv	s2,a0
    80004088:	c13d                	beqz	a0,800040ee <pipealloc+0xa4>
    8000408a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000408c:	4985                	li	s3,1
    8000408e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004092:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004096:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000409a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000409e:	00004597          	auipc	a1,0x4
    800040a2:	4fa58593          	addi	a1,a1,1274 # 80008598 <etext+0x598>
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	3f0080e7          	jalr	1008(ra) # 80006496 <initlock>
  (*f0)->type = FD_PIPE;
    800040ae:	609c                	ld	a5,0(s1)
    800040b0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040b4:	609c                	ld	a5,0(s1)
    800040b6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040ba:	609c                	ld	a5,0(s1)
    800040bc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040c0:	609c                	ld	a5,0(s1)
    800040c2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040c6:	000a3783          	ld	a5,0(s4)
    800040ca:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ce:	000a3783          	ld	a5,0(s4)
    800040d2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040d6:	000a3783          	ld	a5,0(s4)
    800040da:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040de:	000a3783          	ld	a5,0(s4)
    800040e2:	0127b823          	sd	s2,16(a5)
  return 0;
    800040e6:	4501                	li	a0,0
    800040e8:	6942                	ld	s2,16(sp)
    800040ea:	69a2                	ld	s3,8(sp)
    800040ec:	a03d                	j	8000411a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ee:	6088                	ld	a0,0(s1)
    800040f0:	c119                	beqz	a0,800040f6 <pipealloc+0xac>
    800040f2:	6942                	ld	s2,16(sp)
    800040f4:	a029                	j	800040fe <pipealloc+0xb4>
    800040f6:	6942                	ld	s2,16(sp)
    800040f8:	a039                	j	80004106 <pipealloc+0xbc>
    800040fa:	6088                	ld	a0,0(s1)
    800040fc:	c50d                	beqz	a0,80004126 <pipealloc+0xdc>
    fileclose(*f0);
    800040fe:	00000097          	auipc	ra,0x0
    80004102:	bde080e7          	jalr	-1058(ra) # 80003cdc <fileclose>
  if(*f1)
    80004106:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000410a:	557d                	li	a0,-1
  if(*f1)
    8000410c:	c799                	beqz	a5,8000411a <pipealloc+0xd0>
    fileclose(*f1);
    8000410e:	853e                	mv	a0,a5
    80004110:	00000097          	auipc	ra,0x0
    80004114:	bcc080e7          	jalr	-1076(ra) # 80003cdc <fileclose>
  return -1;
    80004118:	557d                	li	a0,-1
}
    8000411a:	70a2                	ld	ra,40(sp)
    8000411c:	7402                	ld	s0,32(sp)
    8000411e:	64e2                	ld	s1,24(sp)
    80004120:	6a02                	ld	s4,0(sp)
    80004122:	6145                	addi	sp,sp,48
    80004124:	8082                	ret
  return -1;
    80004126:	557d                	li	a0,-1
    80004128:	bfcd                	j	8000411a <pipealloc+0xd0>

000000008000412a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000412a:	1101                	addi	sp,sp,-32
    8000412c:	ec06                	sd	ra,24(sp)
    8000412e:	e822                	sd	s0,16(sp)
    80004130:	e426                	sd	s1,8(sp)
    80004132:	e04a                	sd	s2,0(sp)
    80004134:	1000                	addi	s0,sp,32
    80004136:	84aa                	mv	s1,a0
    80004138:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	3ec080e7          	jalr	1004(ra) # 80006526 <acquire>
  if(writable){
    80004142:	02090d63          	beqz	s2,8000417c <pipeclose+0x52>
    pi->writeopen = 0;
    80004146:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000414a:	21848513          	addi	a0,s1,536
    8000414e:	ffffe097          	auipc	ra,0xffffe
    80004152:	888080e7          	jalr	-1912(ra) # 800019d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004156:	2204b783          	ld	a5,544(s1)
    8000415a:	eb95                	bnez	a5,8000418e <pipeclose+0x64>
    release(&pi->lock);
    8000415c:	8526                	mv	a0,s1
    8000415e:	00002097          	auipc	ra,0x2
    80004162:	47c080e7          	jalr	1148(ra) # 800065da <release>
    kfree((char*)pi);
    80004166:	8526                	mv	a0,s1
    80004168:	ffffc097          	auipc	ra,0xffffc
    8000416c:	fda080e7          	jalr	-38(ra) # 80000142 <kfree>
  } else
    release(&pi->lock);
}
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6902                	ld	s2,0(sp)
    80004178:	6105                	addi	sp,sp,32
    8000417a:	8082                	ret
    pi->readopen = 0;
    8000417c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004180:	21c48513          	addi	a0,s1,540
    80004184:	ffffe097          	auipc	ra,0xffffe
    80004188:	852080e7          	jalr	-1966(ra) # 800019d6 <wakeup>
    8000418c:	b7e9                	j	80004156 <pipeclose+0x2c>
    release(&pi->lock);
    8000418e:	8526                	mv	a0,s1
    80004190:	00002097          	auipc	ra,0x2
    80004194:	44a080e7          	jalr	1098(ra) # 800065da <release>
}
    80004198:	bfe1                	j	80004170 <pipeclose+0x46>

000000008000419a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000419a:	711d                	addi	sp,sp,-96
    8000419c:	ec86                	sd	ra,88(sp)
    8000419e:	e8a2                	sd	s0,80(sp)
    800041a0:	e4a6                	sd	s1,72(sp)
    800041a2:	e0ca                	sd	s2,64(sp)
    800041a4:	fc4e                	sd	s3,56(sp)
    800041a6:	f852                	sd	s4,48(sp)
    800041a8:	f456                	sd	s5,40(sp)
    800041aa:	1080                	addi	s0,sp,96
    800041ac:	84aa                	mv	s1,a0
    800041ae:	8aae                	mv	s5,a1
    800041b0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	fd2080e7          	jalr	-46(ra) # 80001184 <myproc>
    800041ba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	368080e7          	jalr	872(ra) # 80006526 <acquire>
  while(i < n){
    800041c6:	0d405563          	blez	s4,80004290 <pipewrite+0xf6>
    800041ca:	f05a                	sd	s6,32(sp)
    800041cc:	ec5e                	sd	s7,24(sp)
    800041ce:	e862                	sd	s8,16(sp)
  int i = 0;
    800041d0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041d2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041d4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041d8:	21c48b93          	addi	s7,s1,540
    800041dc:	a089                	j	8000421e <pipewrite+0x84>
      release(&pi->lock);
    800041de:	8526                	mv	a0,s1
    800041e0:	00002097          	auipc	ra,0x2
    800041e4:	3fa080e7          	jalr	1018(ra) # 800065da <release>
      return -1;
    800041e8:	597d                	li	s2,-1
    800041ea:	7b02                	ld	s6,32(sp)
    800041ec:	6be2                	ld	s7,24(sp)
    800041ee:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041f0:	854a                	mv	a0,s2
    800041f2:	60e6                	ld	ra,88(sp)
    800041f4:	6446                	ld	s0,80(sp)
    800041f6:	64a6                	ld	s1,72(sp)
    800041f8:	6906                	ld	s2,64(sp)
    800041fa:	79e2                	ld	s3,56(sp)
    800041fc:	7a42                	ld	s4,48(sp)
    800041fe:	7aa2                	ld	s5,40(sp)
    80004200:	6125                	addi	sp,sp,96
    80004202:	8082                	ret
      wakeup(&pi->nread);
    80004204:	8562                	mv	a0,s8
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	7d0080e7          	jalr	2000(ra) # 800019d6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000420e:	85a6                	mv	a1,s1
    80004210:	855e                	mv	a0,s7
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	638080e7          	jalr	1592(ra) # 8000184a <sleep>
  while(i < n){
    8000421a:	05495c63          	bge	s2,s4,80004272 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000421e:	2204a783          	lw	a5,544(s1)
    80004222:	dfd5                	beqz	a5,800041de <pipewrite+0x44>
    80004224:	0289a783          	lw	a5,40(s3)
    80004228:	fbdd                	bnez	a5,800041de <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000422a:	2184a783          	lw	a5,536(s1)
    8000422e:	21c4a703          	lw	a4,540(s1)
    80004232:	2007879b          	addiw	a5,a5,512
    80004236:	fcf707e3          	beq	a4,a5,80004204 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000423a:	4685                	li	a3,1
    8000423c:	01590633          	add	a2,s2,s5
    80004240:	faf40593          	addi	a1,s0,-81
    80004244:	0509b503          	ld	a0,80(s3)
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	abe080e7          	jalr	-1346(ra) # 80000d06 <copyin>
    80004250:	05650263          	beq	a0,s6,80004294 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004254:	21c4a783          	lw	a5,540(s1)
    80004258:	0017871b          	addiw	a4,a5,1
    8000425c:	20e4ae23          	sw	a4,540(s1)
    80004260:	1ff7f793          	andi	a5,a5,511
    80004264:	97a6                	add	a5,a5,s1
    80004266:	faf44703          	lbu	a4,-81(s0)
    8000426a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000426e:	2905                	addiw	s2,s2,1
    80004270:	b76d                	j	8000421a <pipewrite+0x80>
    80004272:	7b02                	ld	s6,32(sp)
    80004274:	6be2                	ld	s7,24(sp)
    80004276:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004278:	21848513          	addi	a0,s1,536
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	75a080e7          	jalr	1882(ra) # 800019d6 <wakeup>
  release(&pi->lock);
    80004284:	8526                	mv	a0,s1
    80004286:	00002097          	auipc	ra,0x2
    8000428a:	354080e7          	jalr	852(ra) # 800065da <release>
  return i;
    8000428e:	b78d                	j	800041f0 <pipewrite+0x56>
  int i = 0;
    80004290:	4901                	li	s2,0
    80004292:	b7dd                	j	80004278 <pipewrite+0xde>
    80004294:	7b02                	ld	s6,32(sp)
    80004296:	6be2                	ld	s7,24(sp)
    80004298:	6c42                	ld	s8,16(sp)
    8000429a:	bff9                	j	80004278 <pipewrite+0xde>

000000008000429c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000429c:	715d                	addi	sp,sp,-80
    8000429e:	e486                	sd	ra,72(sp)
    800042a0:	e0a2                	sd	s0,64(sp)
    800042a2:	fc26                	sd	s1,56(sp)
    800042a4:	f84a                	sd	s2,48(sp)
    800042a6:	f44e                	sd	s3,40(sp)
    800042a8:	f052                	sd	s4,32(sp)
    800042aa:	ec56                	sd	s5,24(sp)
    800042ac:	0880                	addi	s0,sp,80
    800042ae:	84aa                	mv	s1,a0
    800042b0:	892e                	mv	s2,a1
    800042b2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	ed0080e7          	jalr	-304(ra) # 80001184 <myproc>
    800042bc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042be:	8526                	mv	a0,s1
    800042c0:	00002097          	auipc	ra,0x2
    800042c4:	266080e7          	jalr	614(ra) # 80006526 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042c8:	2184a703          	lw	a4,536(s1)
    800042cc:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042d0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042d4:	02f71663          	bne	a4,a5,80004300 <piperead+0x64>
    800042d8:	2244a783          	lw	a5,548(s1)
    800042dc:	cb9d                	beqz	a5,80004312 <piperead+0x76>
    if(pr->killed){
    800042de:	028a2783          	lw	a5,40(s4)
    800042e2:	e38d                	bnez	a5,80004304 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042e4:	85a6                	mv	a1,s1
    800042e6:	854e                	mv	a0,s3
    800042e8:	ffffd097          	auipc	ra,0xffffd
    800042ec:	562080e7          	jalr	1378(ra) # 8000184a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042f0:	2184a703          	lw	a4,536(s1)
    800042f4:	21c4a783          	lw	a5,540(s1)
    800042f8:	fef700e3          	beq	a4,a5,800042d8 <piperead+0x3c>
    800042fc:	e85a                	sd	s6,16(sp)
    800042fe:	a819                	j	80004314 <piperead+0x78>
    80004300:	e85a                	sd	s6,16(sp)
    80004302:	a809                	j	80004314 <piperead+0x78>
      release(&pi->lock);
    80004304:	8526                	mv	a0,s1
    80004306:	00002097          	auipc	ra,0x2
    8000430a:	2d4080e7          	jalr	724(ra) # 800065da <release>
      return -1;
    8000430e:	59fd                	li	s3,-1
    80004310:	a0a5                	j	80004378 <piperead+0xdc>
    80004312:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004314:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004316:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004318:	05505463          	blez	s5,80004360 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000431c:	2184a783          	lw	a5,536(s1)
    80004320:	21c4a703          	lw	a4,540(s1)
    80004324:	02f70e63          	beq	a4,a5,80004360 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004328:	0017871b          	addiw	a4,a5,1
    8000432c:	20e4ac23          	sw	a4,536(s1)
    80004330:	1ff7f793          	andi	a5,a5,511
    80004334:	97a6                	add	a5,a5,s1
    80004336:	0187c783          	lbu	a5,24(a5)
    8000433a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000433e:	4685                	li	a3,1
    80004340:	fbf40613          	addi	a2,s0,-65
    80004344:	85ca                	mv	a1,s2
    80004346:	050a3503          	ld	a0,80(s4)
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	bee080e7          	jalr	-1042(ra) # 80000f38 <copyout>
    80004352:	01650763          	beq	a0,s6,80004360 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004356:	2985                	addiw	s3,s3,1
    80004358:	0905                	addi	s2,s2,1
    8000435a:	fd3a91e3          	bne	s5,s3,8000431c <piperead+0x80>
    8000435e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004360:	21c48513          	addi	a0,s1,540
    80004364:	ffffd097          	auipc	ra,0xffffd
    80004368:	672080e7          	jalr	1650(ra) # 800019d6 <wakeup>
  release(&pi->lock);
    8000436c:	8526                	mv	a0,s1
    8000436e:	00002097          	auipc	ra,0x2
    80004372:	26c080e7          	jalr	620(ra) # 800065da <release>
    80004376:	6b42                	ld	s6,16(sp)
  return i;
}
    80004378:	854e                	mv	a0,s3
    8000437a:	60a6                	ld	ra,72(sp)
    8000437c:	6406                	ld	s0,64(sp)
    8000437e:	74e2                	ld	s1,56(sp)
    80004380:	7942                	ld	s2,48(sp)
    80004382:	79a2                	ld	s3,40(sp)
    80004384:	7a02                	ld	s4,32(sp)
    80004386:	6ae2                	ld	s5,24(sp)
    80004388:	6161                	addi	sp,sp,80
    8000438a:	8082                	ret

000000008000438c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000438c:	df010113          	addi	sp,sp,-528
    80004390:	20113423          	sd	ra,520(sp)
    80004394:	20813023          	sd	s0,512(sp)
    80004398:	ffa6                	sd	s1,504(sp)
    8000439a:	fbca                	sd	s2,496(sp)
    8000439c:	0c00                	addi	s0,sp,528
    8000439e:	892a                	mv	s2,a0
    800043a0:	dea43c23          	sd	a0,-520(s0)
    800043a4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043a8:	ffffd097          	auipc	ra,0xffffd
    800043ac:	ddc080e7          	jalr	-548(ra) # 80001184 <myproc>
    800043b0:	84aa                	mv	s1,a0

  begin_op();
    800043b2:	fffff097          	auipc	ra,0xfffff
    800043b6:	460080e7          	jalr	1120(ra) # 80003812 <begin_op>

  if((ip = namei(path)) == 0){
    800043ba:	854a                	mv	a0,s2
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	256080e7          	jalr	598(ra) # 80003612 <namei>
    800043c4:	c135                	beqz	a0,80004428 <exec+0x9c>
    800043c6:	f3d2                	sd	s4,480(sp)
    800043c8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	a76080e7          	jalr	-1418(ra) # 80002e40 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043d2:	04000713          	li	a4,64
    800043d6:	4681                	li	a3,0
    800043d8:	e5040613          	addi	a2,s0,-432
    800043dc:	4581                	li	a1,0
    800043de:	8552                	mv	a0,s4
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	d18080e7          	jalr	-744(ra) # 800030f8 <readi>
    800043e8:	04000793          	li	a5,64
    800043ec:	00f51a63          	bne	a0,a5,80004400 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800043f0:	e5042703          	lw	a4,-432(s0)
    800043f4:	464c47b7          	lui	a5,0x464c4
    800043f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043fc:	02f70c63          	beq	a4,a5,80004434 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004400:	8552                	mv	a0,s4
    80004402:	fffff097          	auipc	ra,0xfffff
    80004406:	ca4080e7          	jalr	-860(ra) # 800030a6 <iunlockput>
    end_op();
    8000440a:	fffff097          	auipc	ra,0xfffff
    8000440e:	482080e7          	jalr	1154(ra) # 8000388c <end_op>
  }
  return -1;
    80004412:	557d                	li	a0,-1
    80004414:	7a1e                	ld	s4,480(sp)
}
    80004416:	20813083          	ld	ra,520(sp)
    8000441a:	20013403          	ld	s0,512(sp)
    8000441e:	74fe                	ld	s1,504(sp)
    80004420:	795e                	ld	s2,496(sp)
    80004422:	21010113          	addi	sp,sp,528
    80004426:	8082                	ret
    end_op();
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	464080e7          	jalr	1124(ra) # 8000388c <end_op>
    return -1;
    80004430:	557d                	li	a0,-1
    80004432:	b7d5                	j	80004416 <exec+0x8a>
    80004434:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004436:	8526                	mv	a0,s1
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	e10080e7          	jalr	-496(ra) # 80001248 <proc_pagetable>
    80004440:	8b2a                	mv	s6,a0
    80004442:	30050563          	beqz	a0,8000474c <exec+0x3c0>
    80004446:	f7ce                	sd	s3,488(sp)
    80004448:	efd6                	sd	s5,472(sp)
    8000444a:	e7de                	sd	s7,456(sp)
    8000444c:	e3e2                	sd	s8,448(sp)
    8000444e:	ff66                	sd	s9,440(sp)
    80004450:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004452:	e7042d03          	lw	s10,-400(s0)
    80004456:	e8845783          	lhu	a5,-376(s0)
    8000445a:	14078563          	beqz	a5,800045a4 <exec+0x218>
    8000445e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004460:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004462:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004464:	6c85                	lui	s9,0x1
    80004466:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000446a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000446e:	6a85                	lui	s5,0x1
    80004470:	a0b5                	j	800044dc <exec+0x150>
      panic("loadseg: address should exist");
    80004472:	00004517          	auipc	a0,0x4
    80004476:	12e50513          	addi	a0,a0,302 # 800085a0 <etext+0x5a0>
    8000447a:	00002097          	auipc	ra,0x2
    8000447e:	b32080e7          	jalr	-1230(ra) # 80005fac <panic>
    if(sz - i < PGSIZE)
    80004482:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004484:	8726                	mv	a4,s1
    80004486:	012c06bb          	addw	a3,s8,s2
    8000448a:	4581                	li	a1,0
    8000448c:	8552                	mv	a0,s4
    8000448e:	fffff097          	auipc	ra,0xfffff
    80004492:	c6a080e7          	jalr	-918(ra) # 800030f8 <readi>
    80004496:	2501                	sext.w	a0,a0
    80004498:	26a49e63          	bne	s1,a0,80004714 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000449c:	012a893b          	addw	s2,s5,s2
    800044a0:	03397563          	bgeu	s2,s3,800044ca <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044a4:	02091593          	slli	a1,s2,0x20
    800044a8:	9181                	srli	a1,a1,0x20
    800044aa:	95de                	add	a1,a1,s7
    800044ac:	855a                	mv	a0,s6
    800044ae:	ffffc097          	auipc	ra,0xffffc
    800044b2:	242080e7          	jalr	578(ra) # 800006f0 <walkaddr>
    800044b6:	862a                	mv	a2,a0
    if(pa == 0)
    800044b8:	dd4d                	beqz	a0,80004472 <exec+0xe6>
    if(sz - i < PGSIZE)
    800044ba:	412984bb          	subw	s1,s3,s2
    800044be:	0004879b          	sext.w	a5,s1
    800044c2:	fcfcf0e3          	bgeu	s9,a5,80004482 <exec+0xf6>
    800044c6:	84d6                	mv	s1,s5
    800044c8:	bf6d                	j	80004482 <exec+0xf6>
    sz = sz1;
    800044ca:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ce:	2d85                	addiw	s11,s11,1
    800044d0:	038d0d1b          	addiw	s10,s10,56
    800044d4:	e8845783          	lhu	a5,-376(s0)
    800044d8:	06fddf63          	bge	s11,a5,80004556 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044dc:	2d01                	sext.w	s10,s10
    800044de:	03800713          	li	a4,56
    800044e2:	86ea                	mv	a3,s10
    800044e4:	e1840613          	addi	a2,s0,-488
    800044e8:	4581                	li	a1,0
    800044ea:	8552                	mv	a0,s4
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	c0c080e7          	jalr	-1012(ra) # 800030f8 <readi>
    800044f4:	03800793          	li	a5,56
    800044f8:	1ef51863          	bne	a0,a5,800046e8 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800044fc:	e1842783          	lw	a5,-488(s0)
    80004500:	4705                	li	a4,1
    80004502:	fce796e3          	bne	a5,a4,800044ce <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004506:	e4043603          	ld	a2,-448(s0)
    8000450a:	e3843783          	ld	a5,-456(s0)
    8000450e:	1ef66163          	bltu	a2,a5,800046f0 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004512:	e2843783          	ld	a5,-472(s0)
    80004516:	963e                	add	a2,a2,a5
    80004518:	1ef66063          	bltu	a2,a5,800046f8 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000451c:	85a6                	mv	a1,s1
    8000451e:	855a                	mv	a0,s6
    80004520:	ffffc097          	auipc	ra,0xffffc
    80004524:	594080e7          	jalr	1428(ra) # 80000ab4 <uvmalloc>
    80004528:	e0a43423          	sd	a0,-504(s0)
    8000452c:	1c050a63          	beqz	a0,80004700 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004530:	e2843b83          	ld	s7,-472(s0)
    80004534:	df043783          	ld	a5,-528(s0)
    80004538:	00fbf7b3          	and	a5,s7,a5
    8000453c:	1c079a63          	bnez	a5,80004710 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004540:	e2042c03          	lw	s8,-480(s0)
    80004544:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004548:	00098463          	beqz	s3,80004550 <exec+0x1c4>
    8000454c:	4901                	li	s2,0
    8000454e:	bf99                	j	800044a4 <exec+0x118>
    sz = sz1;
    80004550:	e0843483          	ld	s1,-504(s0)
    80004554:	bfad                	j	800044ce <exec+0x142>
    80004556:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004558:	8552                	mv	a0,s4
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	b4c080e7          	jalr	-1204(ra) # 800030a6 <iunlockput>
  end_op();
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	32a080e7          	jalr	810(ra) # 8000388c <end_op>
  p = myproc();
    8000456a:	ffffd097          	auipc	ra,0xffffd
    8000456e:	c1a080e7          	jalr	-998(ra) # 80001184 <myproc>
    80004572:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004574:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004578:	6985                	lui	s3,0x1
    8000457a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000457c:	99a6                	add	s3,s3,s1
    8000457e:	77fd                	lui	a5,0xfffff
    80004580:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004584:	6609                	lui	a2,0x2
    80004586:	964e                	add	a2,a2,s3
    80004588:	85ce                	mv	a1,s3
    8000458a:	855a                	mv	a0,s6
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	528080e7          	jalr	1320(ra) # 80000ab4 <uvmalloc>
    80004594:	892a                	mv	s2,a0
    80004596:	e0a43423          	sd	a0,-504(s0)
    8000459a:	e519                	bnez	a0,800045a8 <exec+0x21c>
  if(pagetable)
    8000459c:	e1343423          	sd	s3,-504(s0)
    800045a0:	4a01                	li	s4,0
    800045a2:	aa95                	j	80004716 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045a4:	4481                	li	s1,0
    800045a6:	bf4d                	j	80004558 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045a8:	75f9                	lui	a1,0xffffe
    800045aa:	95aa                	add	a1,a1,a0
    800045ac:	855a                	mv	a0,s6
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	726080e7          	jalr	1830(ra) # 80000cd4 <uvmclear>
  stackbase = sp - PGSIZE;
    800045b6:	7bfd                	lui	s7,0xfffff
    800045b8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045ba:	e0043783          	ld	a5,-512(s0)
    800045be:	6388                	ld	a0,0(a5)
    800045c0:	c52d                	beqz	a0,8000462a <exec+0x29e>
    800045c2:	e9040993          	addi	s3,s0,-368
    800045c6:	f9040c13          	addi	s8,s0,-112
    800045ca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045cc:	ffffc097          	auipc	ra,0xffffc
    800045d0:	f1a080e7          	jalr	-230(ra) # 800004e6 <strlen>
    800045d4:	0015079b          	addiw	a5,a0,1
    800045d8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045dc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800045e0:	13796463          	bltu	s2,s7,80004708 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045e4:	e0043d03          	ld	s10,-512(s0)
    800045e8:	000d3a03          	ld	s4,0(s10)
    800045ec:	8552                	mv	a0,s4
    800045ee:	ffffc097          	auipc	ra,0xffffc
    800045f2:	ef8080e7          	jalr	-264(ra) # 800004e6 <strlen>
    800045f6:	0015069b          	addiw	a3,a0,1
    800045fa:	8652                	mv	a2,s4
    800045fc:	85ca                	mv	a1,s2
    800045fe:	855a                	mv	a0,s6
    80004600:	ffffd097          	auipc	ra,0xffffd
    80004604:	938080e7          	jalr	-1736(ra) # 80000f38 <copyout>
    80004608:	10054263          	bltz	a0,8000470c <exec+0x380>
    ustack[argc] = sp;
    8000460c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004610:	0485                	addi	s1,s1,1
    80004612:	008d0793          	addi	a5,s10,8
    80004616:	e0f43023          	sd	a5,-512(s0)
    8000461a:	008d3503          	ld	a0,8(s10)
    8000461e:	c909                	beqz	a0,80004630 <exec+0x2a4>
    if(argc >= MAXARG)
    80004620:	09a1                	addi	s3,s3,8
    80004622:	fb8995e3          	bne	s3,s8,800045cc <exec+0x240>
  ip = 0;
    80004626:	4a01                	li	s4,0
    80004628:	a0fd                	j	80004716 <exec+0x38a>
  sp = sz;
    8000462a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000462e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004630:	00349793          	slli	a5,s1,0x3
    80004634:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    80004638:	97a2                	add	a5,a5,s0
    8000463a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000463e:	00148693          	addi	a3,s1,1
    80004642:	068e                	slli	a3,a3,0x3
    80004644:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004648:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000464c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004650:	f57966e3          	bltu	s2,s7,8000459c <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004654:	e9040613          	addi	a2,s0,-368
    80004658:	85ca                	mv	a1,s2
    8000465a:	855a                	mv	a0,s6
    8000465c:	ffffd097          	auipc	ra,0xffffd
    80004660:	8dc080e7          	jalr	-1828(ra) # 80000f38 <copyout>
    80004664:	0e054663          	bltz	a0,80004750 <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004668:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000466c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004670:	df843783          	ld	a5,-520(s0)
    80004674:	0007c703          	lbu	a4,0(a5)
    80004678:	cf11                	beqz	a4,80004694 <exec+0x308>
    8000467a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000467c:	02f00693          	li	a3,47
    80004680:	a039                	j	8000468e <exec+0x302>
      last = s+1;
    80004682:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004686:	0785                	addi	a5,a5,1
    80004688:	fff7c703          	lbu	a4,-1(a5)
    8000468c:	c701                	beqz	a4,80004694 <exec+0x308>
    if(*s == '/')
    8000468e:	fed71ce3          	bne	a4,a3,80004686 <exec+0x2fa>
    80004692:	bfc5                	j	80004682 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004694:	4641                	li	a2,16
    80004696:	df843583          	ld	a1,-520(s0)
    8000469a:	158a8513          	addi	a0,s5,344
    8000469e:	ffffc097          	auipc	ra,0xffffc
    800046a2:	e16080e7          	jalr	-490(ra) # 800004b4 <safestrcpy>
  oldpagetable = p->pagetable;
    800046a6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046aa:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046ae:	e0843783          	ld	a5,-504(s0)
    800046b2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046b6:	058ab783          	ld	a5,88(s5)
    800046ba:	e6843703          	ld	a4,-408(s0)
    800046be:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046c0:	058ab783          	ld	a5,88(s5)
    800046c4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046c8:	85e6                	mv	a1,s9
    800046ca:	ffffd097          	auipc	ra,0xffffd
    800046ce:	c1a080e7          	jalr	-998(ra) # 800012e4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046d2:	0004851b          	sext.w	a0,s1
    800046d6:	79be                	ld	s3,488(sp)
    800046d8:	7a1e                	ld	s4,480(sp)
    800046da:	6afe                	ld	s5,472(sp)
    800046dc:	6b5e                	ld	s6,464(sp)
    800046de:	6bbe                	ld	s7,456(sp)
    800046e0:	6c1e                	ld	s8,448(sp)
    800046e2:	7cfa                	ld	s9,440(sp)
    800046e4:	7d5a                	ld	s10,432(sp)
    800046e6:	bb05                	j	80004416 <exec+0x8a>
    800046e8:	e0943423          	sd	s1,-504(s0)
    800046ec:	7dba                	ld	s11,424(sp)
    800046ee:	a025                	j	80004716 <exec+0x38a>
    800046f0:	e0943423          	sd	s1,-504(s0)
    800046f4:	7dba                	ld	s11,424(sp)
    800046f6:	a005                	j	80004716 <exec+0x38a>
    800046f8:	e0943423          	sd	s1,-504(s0)
    800046fc:	7dba                	ld	s11,424(sp)
    800046fe:	a821                	j	80004716 <exec+0x38a>
    80004700:	e0943423          	sd	s1,-504(s0)
    80004704:	7dba                	ld	s11,424(sp)
    80004706:	a801                	j	80004716 <exec+0x38a>
  ip = 0;
    80004708:	4a01                	li	s4,0
    8000470a:	a031                	j	80004716 <exec+0x38a>
    8000470c:	4a01                	li	s4,0
  if(pagetable)
    8000470e:	a021                	j	80004716 <exec+0x38a>
    80004710:	7dba                	ld	s11,424(sp)
    80004712:	a011                	j	80004716 <exec+0x38a>
    80004714:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004716:	e0843583          	ld	a1,-504(s0)
    8000471a:	855a                	mv	a0,s6
    8000471c:	ffffd097          	auipc	ra,0xffffd
    80004720:	bc8080e7          	jalr	-1080(ra) # 800012e4 <proc_freepagetable>
  return -1;
    80004724:	557d                	li	a0,-1
  if(ip){
    80004726:	000a1b63          	bnez	s4,8000473c <exec+0x3b0>
    8000472a:	79be                	ld	s3,488(sp)
    8000472c:	7a1e                	ld	s4,480(sp)
    8000472e:	6afe                	ld	s5,472(sp)
    80004730:	6b5e                	ld	s6,464(sp)
    80004732:	6bbe                	ld	s7,456(sp)
    80004734:	6c1e                	ld	s8,448(sp)
    80004736:	7cfa                	ld	s9,440(sp)
    80004738:	7d5a                	ld	s10,432(sp)
    8000473a:	b9f1                	j	80004416 <exec+0x8a>
    8000473c:	79be                	ld	s3,488(sp)
    8000473e:	6afe                	ld	s5,472(sp)
    80004740:	6b5e                	ld	s6,464(sp)
    80004742:	6bbe                	ld	s7,456(sp)
    80004744:	6c1e                	ld	s8,448(sp)
    80004746:	7cfa                	ld	s9,440(sp)
    80004748:	7d5a                	ld	s10,432(sp)
    8000474a:	b95d                	j	80004400 <exec+0x74>
    8000474c:	6b5e                	ld	s6,464(sp)
    8000474e:	b94d                	j	80004400 <exec+0x74>
  sz = sz1;
    80004750:	e0843983          	ld	s3,-504(s0)
    80004754:	b5a1                	j	8000459c <exec+0x210>

0000000080004756 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004756:	7179                	addi	sp,sp,-48
    80004758:	f406                	sd	ra,40(sp)
    8000475a:	f022                	sd	s0,32(sp)
    8000475c:	ec26                	sd	s1,24(sp)
    8000475e:	e84a                	sd	s2,16(sp)
    80004760:	1800                	addi	s0,sp,48
    80004762:	892e                	mv	s2,a1
    80004764:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004766:	fdc40593          	addi	a1,s0,-36
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	b64080e7          	jalr	-1180(ra) # 800022ce <argint>
    80004772:	04054063          	bltz	a0,800047b2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004776:	fdc42703          	lw	a4,-36(s0)
    8000477a:	47bd                	li	a5,15
    8000477c:	02e7ed63          	bltu	a5,a4,800047b6 <argfd+0x60>
    80004780:	ffffd097          	auipc	ra,0xffffd
    80004784:	a04080e7          	jalr	-1532(ra) # 80001184 <myproc>
    80004788:	fdc42703          	lw	a4,-36(s0)
    8000478c:	01a70793          	addi	a5,a4,26
    80004790:	078e                	slli	a5,a5,0x3
    80004792:	953e                	add	a0,a0,a5
    80004794:	611c                	ld	a5,0(a0)
    80004796:	c395                	beqz	a5,800047ba <argfd+0x64>
    return -1;
  if(pfd)
    80004798:	00090463          	beqz	s2,800047a0 <argfd+0x4a>
    *pfd = fd;
    8000479c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047a0:	4501                	li	a0,0
  if(pf)
    800047a2:	c091                	beqz	s1,800047a6 <argfd+0x50>
    *pf = f;
    800047a4:	e09c                	sd	a5,0(s1)
}
    800047a6:	70a2                	ld	ra,40(sp)
    800047a8:	7402                	ld	s0,32(sp)
    800047aa:	64e2                	ld	s1,24(sp)
    800047ac:	6942                	ld	s2,16(sp)
    800047ae:	6145                	addi	sp,sp,48
    800047b0:	8082                	ret
    return -1;
    800047b2:	557d                	li	a0,-1
    800047b4:	bfcd                	j	800047a6 <argfd+0x50>
    return -1;
    800047b6:	557d                	li	a0,-1
    800047b8:	b7fd                	j	800047a6 <argfd+0x50>
    800047ba:	557d                	li	a0,-1
    800047bc:	b7ed                	j	800047a6 <argfd+0x50>

00000000800047be <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047be:	1101                	addi	sp,sp,-32
    800047c0:	ec06                	sd	ra,24(sp)
    800047c2:	e822                	sd	s0,16(sp)
    800047c4:	e426                	sd	s1,8(sp)
    800047c6:	1000                	addi	s0,sp,32
    800047c8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047ca:	ffffd097          	auipc	ra,0xffffd
    800047ce:	9ba080e7          	jalr	-1606(ra) # 80001184 <myproc>
    800047d2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047d4:	0d050793          	addi	a5,a0,208
    800047d8:	4501                	li	a0,0
    800047da:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047dc:	6398                	ld	a4,0(a5)
    800047de:	cb19                	beqz	a4,800047f4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047e0:	2505                	addiw	a0,a0,1
    800047e2:	07a1                	addi	a5,a5,8
    800047e4:	fed51ce3          	bne	a0,a3,800047dc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047e8:	557d                	li	a0,-1
}
    800047ea:	60e2                	ld	ra,24(sp)
    800047ec:	6442                	ld	s0,16(sp)
    800047ee:	64a2                	ld	s1,8(sp)
    800047f0:	6105                	addi	sp,sp,32
    800047f2:	8082                	ret
      p->ofile[fd] = f;
    800047f4:	01a50793          	addi	a5,a0,26
    800047f8:	078e                	slli	a5,a5,0x3
    800047fa:	963e                	add	a2,a2,a5
    800047fc:	e204                	sd	s1,0(a2)
      return fd;
    800047fe:	b7f5                	j	800047ea <fdalloc+0x2c>

0000000080004800 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004800:	715d                	addi	sp,sp,-80
    80004802:	e486                	sd	ra,72(sp)
    80004804:	e0a2                	sd	s0,64(sp)
    80004806:	fc26                	sd	s1,56(sp)
    80004808:	f84a                	sd	s2,48(sp)
    8000480a:	f44e                	sd	s3,40(sp)
    8000480c:	f052                	sd	s4,32(sp)
    8000480e:	ec56                	sd	s5,24(sp)
    80004810:	0880                	addi	s0,sp,80
    80004812:	8aae                	mv	s5,a1
    80004814:	8a32                	mv	s4,a2
    80004816:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004818:	fb040593          	addi	a1,s0,-80
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	e14080e7          	jalr	-492(ra) # 80003630 <nameiparent>
    80004824:	892a                	mv	s2,a0
    80004826:	12050c63          	beqz	a0,8000495e <create+0x15e>
    return 0;

  ilock(dp);
    8000482a:	ffffe097          	auipc	ra,0xffffe
    8000482e:	616080e7          	jalr	1558(ra) # 80002e40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004832:	4601                	li	a2,0
    80004834:	fb040593          	addi	a1,s0,-80
    80004838:	854a                	mv	a0,s2
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	b06080e7          	jalr	-1274(ra) # 80003340 <dirlookup>
    80004842:	84aa                	mv	s1,a0
    80004844:	c539                	beqz	a0,80004892 <create+0x92>
    iunlockput(dp);
    80004846:	854a                	mv	a0,s2
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	85e080e7          	jalr	-1954(ra) # 800030a6 <iunlockput>
    ilock(ip);
    80004850:	8526                	mv	a0,s1
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	5ee080e7          	jalr	1518(ra) # 80002e40 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000485a:	4789                	li	a5,2
    8000485c:	02fa9463          	bne	s5,a5,80004884 <create+0x84>
    80004860:	0444d783          	lhu	a5,68(s1)
    80004864:	37f9                	addiw	a5,a5,-2
    80004866:	17c2                	slli	a5,a5,0x30
    80004868:	93c1                	srli	a5,a5,0x30
    8000486a:	4705                	li	a4,1
    8000486c:	00f76c63          	bltu	a4,a5,80004884 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004870:	8526                	mv	a0,s1
    80004872:	60a6                	ld	ra,72(sp)
    80004874:	6406                	ld	s0,64(sp)
    80004876:	74e2                	ld	s1,56(sp)
    80004878:	7942                	ld	s2,48(sp)
    8000487a:	79a2                	ld	s3,40(sp)
    8000487c:	7a02                	ld	s4,32(sp)
    8000487e:	6ae2                	ld	s5,24(sp)
    80004880:	6161                	addi	sp,sp,80
    80004882:	8082                	ret
    iunlockput(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	820080e7          	jalr	-2016(ra) # 800030a6 <iunlockput>
    return 0;
    8000488e:	4481                	li	s1,0
    80004890:	b7c5                	j	80004870 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004892:	85d6                	mv	a1,s5
    80004894:	00092503          	lw	a0,0(s2)
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	414080e7          	jalr	1044(ra) # 80002cac <ialloc>
    800048a0:	84aa                	mv	s1,a0
    800048a2:	c139                	beqz	a0,800048e8 <create+0xe8>
  ilock(ip);
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	59c080e7          	jalr	1436(ra) # 80002e40 <ilock>
  ip->major = major;
    800048ac:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800048b0:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800048b4:	4985                	li	s3,1
    800048b6:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800048ba:	8526                	mv	a0,s1
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	4b8080e7          	jalr	1208(ra) # 80002d74 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048c4:	033a8a63          	beq	s5,s3,800048f8 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800048c8:	40d0                	lw	a2,4(s1)
    800048ca:	fb040593          	addi	a1,s0,-80
    800048ce:	854a                	mv	a0,s2
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	c80080e7          	jalr	-896(ra) # 80003550 <dirlink>
    800048d8:	06054b63          	bltz	a0,8000494e <create+0x14e>
  iunlockput(dp);
    800048dc:	854a                	mv	a0,s2
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	7c8080e7          	jalr	1992(ra) # 800030a6 <iunlockput>
  return ip;
    800048e6:	b769                	j	80004870 <create+0x70>
    panic("create: ialloc");
    800048e8:	00004517          	auipc	a0,0x4
    800048ec:	cd850513          	addi	a0,a0,-808 # 800085c0 <etext+0x5c0>
    800048f0:	00001097          	auipc	ra,0x1
    800048f4:	6bc080e7          	jalr	1724(ra) # 80005fac <panic>
    dp->nlink++;  // for ".."
    800048f8:	04a95783          	lhu	a5,74(s2)
    800048fc:	2785                	addiw	a5,a5,1
    800048fe:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004902:	854a                	mv	a0,s2
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	470080e7          	jalr	1136(ra) # 80002d74 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000490c:	40d0                	lw	a2,4(s1)
    8000490e:	00004597          	auipc	a1,0x4
    80004912:	cc258593          	addi	a1,a1,-830 # 800085d0 <etext+0x5d0>
    80004916:	8526                	mv	a0,s1
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	c38080e7          	jalr	-968(ra) # 80003550 <dirlink>
    80004920:	00054f63          	bltz	a0,8000493e <create+0x13e>
    80004924:	00492603          	lw	a2,4(s2)
    80004928:	00004597          	auipc	a1,0x4
    8000492c:	cb058593          	addi	a1,a1,-848 # 800085d8 <etext+0x5d8>
    80004930:	8526                	mv	a0,s1
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	c1e080e7          	jalr	-994(ra) # 80003550 <dirlink>
    8000493a:	f80557e3          	bgez	a0,800048c8 <create+0xc8>
      panic("create dots");
    8000493e:	00004517          	auipc	a0,0x4
    80004942:	ca250513          	addi	a0,a0,-862 # 800085e0 <etext+0x5e0>
    80004946:	00001097          	auipc	ra,0x1
    8000494a:	666080e7          	jalr	1638(ra) # 80005fac <panic>
    panic("create: dirlink");
    8000494e:	00004517          	auipc	a0,0x4
    80004952:	ca250513          	addi	a0,a0,-862 # 800085f0 <etext+0x5f0>
    80004956:	00001097          	auipc	ra,0x1
    8000495a:	656080e7          	jalr	1622(ra) # 80005fac <panic>
    return 0;
    8000495e:	84aa                	mv	s1,a0
    80004960:	bf01                	j	80004870 <create+0x70>

0000000080004962 <sys_dup>:
{
    80004962:	7179                	addi	sp,sp,-48
    80004964:	f406                	sd	ra,40(sp)
    80004966:	f022                	sd	s0,32(sp)
    80004968:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000496a:	fd840613          	addi	a2,s0,-40
    8000496e:	4581                	li	a1,0
    80004970:	4501                	li	a0,0
    80004972:	00000097          	auipc	ra,0x0
    80004976:	de4080e7          	jalr	-540(ra) # 80004756 <argfd>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000497c:	02054763          	bltz	a0,800049aa <sys_dup+0x48>
    80004980:	ec26                	sd	s1,24(sp)
    80004982:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004984:	fd843903          	ld	s2,-40(s0)
    80004988:	854a                	mv	a0,s2
    8000498a:	00000097          	auipc	ra,0x0
    8000498e:	e34080e7          	jalr	-460(ra) # 800047be <fdalloc>
    80004992:	84aa                	mv	s1,a0
    return -1;
    80004994:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004996:	00054f63          	bltz	a0,800049b4 <sys_dup+0x52>
  filedup(f);
    8000499a:	854a                	mv	a0,s2
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	2ee080e7          	jalr	750(ra) # 80003c8a <filedup>
  return fd;
    800049a4:	87a6                	mv	a5,s1
    800049a6:	64e2                	ld	s1,24(sp)
    800049a8:	6942                	ld	s2,16(sp)
}
    800049aa:	853e                	mv	a0,a5
    800049ac:	70a2                	ld	ra,40(sp)
    800049ae:	7402                	ld	s0,32(sp)
    800049b0:	6145                	addi	sp,sp,48
    800049b2:	8082                	ret
    800049b4:	64e2                	ld	s1,24(sp)
    800049b6:	6942                	ld	s2,16(sp)
    800049b8:	bfcd                	j	800049aa <sys_dup+0x48>

00000000800049ba <sys_read>:
{
    800049ba:	7179                	addi	sp,sp,-48
    800049bc:	f406                	sd	ra,40(sp)
    800049be:	f022                	sd	s0,32(sp)
    800049c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049c2:	fe840613          	addi	a2,s0,-24
    800049c6:	4581                	li	a1,0
    800049c8:	4501                	li	a0,0
    800049ca:	00000097          	auipc	ra,0x0
    800049ce:	d8c080e7          	jalr	-628(ra) # 80004756 <argfd>
    return -1;
    800049d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d4:	04054163          	bltz	a0,80004a16 <sys_read+0x5c>
    800049d8:	fe440593          	addi	a1,s0,-28
    800049dc:	4509                	li	a0,2
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	8f0080e7          	jalr	-1808(ra) # 800022ce <argint>
    return -1;
    800049e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049e8:	02054763          	bltz	a0,80004a16 <sys_read+0x5c>
    800049ec:	fd840593          	addi	a1,s0,-40
    800049f0:	4505                	li	a0,1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	8fe080e7          	jalr	-1794(ra) # 800022f0 <argaddr>
    return -1;
    800049fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049fc:	00054d63          	bltz	a0,80004a16 <sys_read+0x5c>
  return fileread(f, p, n);
    80004a00:	fe442603          	lw	a2,-28(s0)
    80004a04:	fd843583          	ld	a1,-40(s0)
    80004a08:	fe843503          	ld	a0,-24(s0)
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	424080e7          	jalr	1060(ra) # 80003e30 <fileread>
    80004a14:	87aa                	mv	a5,a0
}
    80004a16:	853e                	mv	a0,a5
    80004a18:	70a2                	ld	ra,40(sp)
    80004a1a:	7402                	ld	s0,32(sp)
    80004a1c:	6145                	addi	sp,sp,48
    80004a1e:	8082                	ret

0000000080004a20 <sys_write>:
{
    80004a20:	7179                	addi	sp,sp,-48
    80004a22:	f406                	sd	ra,40(sp)
    80004a24:	f022                	sd	s0,32(sp)
    80004a26:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a28:	fe840613          	addi	a2,s0,-24
    80004a2c:	4581                	li	a1,0
    80004a2e:	4501                	li	a0,0
    80004a30:	00000097          	auipc	ra,0x0
    80004a34:	d26080e7          	jalr	-730(ra) # 80004756 <argfd>
    return -1;
    80004a38:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a3a:	04054163          	bltz	a0,80004a7c <sys_write+0x5c>
    80004a3e:	fe440593          	addi	a1,s0,-28
    80004a42:	4509                	li	a0,2
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	88a080e7          	jalr	-1910(ra) # 800022ce <argint>
    return -1;
    80004a4c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a4e:	02054763          	bltz	a0,80004a7c <sys_write+0x5c>
    80004a52:	fd840593          	addi	a1,s0,-40
    80004a56:	4505                	li	a0,1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	898080e7          	jalr	-1896(ra) # 800022f0 <argaddr>
    return -1;
    80004a60:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a62:	00054d63          	bltz	a0,80004a7c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a66:	fe442603          	lw	a2,-28(s0)
    80004a6a:	fd843583          	ld	a1,-40(s0)
    80004a6e:	fe843503          	ld	a0,-24(s0)
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	490080e7          	jalr	1168(ra) # 80003f02 <filewrite>
    80004a7a:	87aa                	mv	a5,a0
}
    80004a7c:	853e                	mv	a0,a5
    80004a7e:	70a2                	ld	ra,40(sp)
    80004a80:	7402                	ld	s0,32(sp)
    80004a82:	6145                	addi	sp,sp,48
    80004a84:	8082                	ret

0000000080004a86 <sys_close>:
{
    80004a86:	1101                	addi	sp,sp,-32
    80004a88:	ec06                	sd	ra,24(sp)
    80004a8a:	e822                	sd	s0,16(sp)
    80004a8c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a8e:	fe040613          	addi	a2,s0,-32
    80004a92:	fec40593          	addi	a1,s0,-20
    80004a96:	4501                	li	a0,0
    80004a98:	00000097          	auipc	ra,0x0
    80004a9c:	cbe080e7          	jalr	-834(ra) # 80004756 <argfd>
    return -1;
    80004aa0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004aa2:	02054463          	bltz	a0,80004aca <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004aa6:	ffffc097          	auipc	ra,0xffffc
    80004aaa:	6de080e7          	jalr	1758(ra) # 80001184 <myproc>
    80004aae:	fec42783          	lw	a5,-20(s0)
    80004ab2:	07e9                	addi	a5,a5,26
    80004ab4:	078e                	slli	a5,a5,0x3
    80004ab6:	953e                	add	a0,a0,a5
    80004ab8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004abc:	fe043503          	ld	a0,-32(s0)
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	21c080e7          	jalr	540(ra) # 80003cdc <fileclose>
  return 0;
    80004ac8:	4781                	li	a5,0
}
    80004aca:	853e                	mv	a0,a5
    80004acc:	60e2                	ld	ra,24(sp)
    80004ace:	6442                	ld	s0,16(sp)
    80004ad0:	6105                	addi	sp,sp,32
    80004ad2:	8082                	ret

0000000080004ad4 <sys_fstat>:
{
    80004ad4:	1101                	addi	sp,sp,-32
    80004ad6:	ec06                	sd	ra,24(sp)
    80004ad8:	e822                	sd	s0,16(sp)
    80004ada:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004adc:	fe840613          	addi	a2,s0,-24
    80004ae0:	4581                	li	a1,0
    80004ae2:	4501                	li	a0,0
    80004ae4:	00000097          	auipc	ra,0x0
    80004ae8:	c72080e7          	jalr	-910(ra) # 80004756 <argfd>
    return -1;
    80004aec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004aee:	02054563          	bltz	a0,80004b18 <sys_fstat+0x44>
    80004af2:	fe040593          	addi	a1,s0,-32
    80004af6:	4505                	li	a0,1
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	7f8080e7          	jalr	2040(ra) # 800022f0 <argaddr>
    return -1;
    80004b00:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b02:	00054b63          	bltz	a0,80004b18 <sys_fstat+0x44>
  return filestat(f, st);
    80004b06:	fe043583          	ld	a1,-32(s0)
    80004b0a:	fe843503          	ld	a0,-24(s0)
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	2b0080e7          	jalr	688(ra) # 80003dbe <filestat>
    80004b16:	87aa                	mv	a5,a0
}
    80004b18:	853e                	mv	a0,a5
    80004b1a:	60e2                	ld	ra,24(sp)
    80004b1c:	6442                	ld	s0,16(sp)
    80004b1e:	6105                	addi	sp,sp,32
    80004b20:	8082                	ret

0000000080004b22 <sys_link>:
{
    80004b22:	7169                	addi	sp,sp,-304
    80004b24:	f606                	sd	ra,296(sp)
    80004b26:	f222                	sd	s0,288(sp)
    80004b28:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b2a:	08000613          	li	a2,128
    80004b2e:	ed040593          	addi	a1,s0,-304
    80004b32:	4501                	li	a0,0
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	7de080e7          	jalr	2014(ra) # 80002312 <argstr>
    return -1;
    80004b3c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b3e:	12054663          	bltz	a0,80004c6a <sys_link+0x148>
    80004b42:	08000613          	li	a2,128
    80004b46:	f5040593          	addi	a1,s0,-176
    80004b4a:	4505                	li	a0,1
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	7c6080e7          	jalr	1990(ra) # 80002312 <argstr>
    return -1;
    80004b54:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b56:	10054a63          	bltz	a0,80004c6a <sys_link+0x148>
    80004b5a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	cb6080e7          	jalr	-842(ra) # 80003812 <begin_op>
  if((ip = namei(old)) == 0){
    80004b64:	ed040513          	addi	a0,s0,-304
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	aaa080e7          	jalr	-1366(ra) # 80003612 <namei>
    80004b70:	84aa                	mv	s1,a0
    80004b72:	c949                	beqz	a0,80004c04 <sys_link+0xe2>
  ilock(ip);
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	2cc080e7          	jalr	716(ra) # 80002e40 <ilock>
  if(ip->type == T_DIR){
    80004b7c:	04449703          	lh	a4,68(s1)
    80004b80:	4785                	li	a5,1
    80004b82:	08f70863          	beq	a4,a5,80004c12 <sys_link+0xf0>
    80004b86:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b88:	04a4d783          	lhu	a5,74(s1)
    80004b8c:	2785                	addiw	a5,a5,1
    80004b8e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b92:	8526                	mv	a0,s1
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	1e0080e7          	jalr	480(ra) # 80002d74 <iupdate>
  iunlock(ip);
    80004b9c:	8526                	mv	a0,s1
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	368080e7          	jalr	872(ra) # 80002f06 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ba6:	fd040593          	addi	a1,s0,-48
    80004baa:	f5040513          	addi	a0,s0,-176
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	a82080e7          	jalr	-1406(ra) # 80003630 <nameiparent>
    80004bb6:	892a                	mv	s2,a0
    80004bb8:	cd35                	beqz	a0,80004c34 <sys_link+0x112>
  ilock(dp);
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	286080e7          	jalr	646(ra) # 80002e40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bc2:	00092703          	lw	a4,0(s2)
    80004bc6:	409c                	lw	a5,0(s1)
    80004bc8:	06f71163          	bne	a4,a5,80004c2a <sys_link+0x108>
    80004bcc:	40d0                	lw	a2,4(s1)
    80004bce:	fd040593          	addi	a1,s0,-48
    80004bd2:	854a                	mv	a0,s2
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	97c080e7          	jalr	-1668(ra) # 80003550 <dirlink>
    80004bdc:	04054763          	bltz	a0,80004c2a <sys_link+0x108>
  iunlockput(dp);
    80004be0:	854a                	mv	a0,s2
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	4c4080e7          	jalr	1220(ra) # 800030a6 <iunlockput>
  iput(ip);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	412080e7          	jalr	1042(ra) # 80002ffe <iput>
  end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	c98080e7          	jalr	-872(ra) # 8000388c <end_op>
  return 0;
    80004bfc:	4781                	li	a5,0
    80004bfe:	64f2                	ld	s1,280(sp)
    80004c00:	6952                	ld	s2,272(sp)
    80004c02:	a0a5                	j	80004c6a <sys_link+0x148>
    end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	c88080e7          	jalr	-888(ra) # 8000388c <end_op>
    return -1;
    80004c0c:	57fd                	li	a5,-1
    80004c0e:	64f2                	ld	s1,280(sp)
    80004c10:	a8a9                	j	80004c6a <sys_link+0x148>
    iunlockput(ip);
    80004c12:	8526                	mv	a0,s1
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	492080e7          	jalr	1170(ra) # 800030a6 <iunlockput>
    end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	c70080e7          	jalr	-912(ra) # 8000388c <end_op>
    return -1;
    80004c24:	57fd                	li	a5,-1
    80004c26:	64f2                	ld	s1,280(sp)
    80004c28:	a089                	j	80004c6a <sys_link+0x148>
    iunlockput(dp);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	47a080e7          	jalr	1146(ra) # 800030a6 <iunlockput>
  ilock(ip);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	20a080e7          	jalr	522(ra) # 80002e40 <ilock>
  ip->nlink--;
    80004c3e:	04a4d783          	lhu	a5,74(s1)
    80004c42:	37fd                	addiw	a5,a5,-1
    80004c44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c48:	8526                	mv	a0,s1
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	12a080e7          	jalr	298(ra) # 80002d74 <iupdate>
  iunlockput(ip);
    80004c52:	8526                	mv	a0,s1
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	452080e7          	jalr	1106(ra) # 800030a6 <iunlockput>
  end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	c30080e7          	jalr	-976(ra) # 8000388c <end_op>
  return -1;
    80004c64:	57fd                	li	a5,-1
    80004c66:	64f2                	ld	s1,280(sp)
    80004c68:	6952                	ld	s2,272(sp)
}
    80004c6a:	853e                	mv	a0,a5
    80004c6c:	70b2                	ld	ra,296(sp)
    80004c6e:	7412                	ld	s0,288(sp)
    80004c70:	6155                	addi	sp,sp,304
    80004c72:	8082                	ret

0000000080004c74 <sys_unlink>:
{
    80004c74:	7151                	addi	sp,sp,-240
    80004c76:	f586                	sd	ra,232(sp)
    80004c78:	f1a2                	sd	s0,224(sp)
    80004c7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c7c:	08000613          	li	a2,128
    80004c80:	f3040593          	addi	a1,s0,-208
    80004c84:	4501                	li	a0,0
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	68c080e7          	jalr	1676(ra) # 80002312 <argstr>
    80004c8e:	1a054a63          	bltz	a0,80004e42 <sys_unlink+0x1ce>
    80004c92:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	b7e080e7          	jalr	-1154(ra) # 80003812 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c9c:	fb040593          	addi	a1,s0,-80
    80004ca0:	f3040513          	addi	a0,s0,-208
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	98c080e7          	jalr	-1652(ra) # 80003630 <nameiparent>
    80004cac:	84aa                	mv	s1,a0
    80004cae:	cd71                	beqz	a0,80004d8a <sys_unlink+0x116>
  ilock(dp);
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	190080e7          	jalr	400(ra) # 80002e40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cb8:	00004597          	auipc	a1,0x4
    80004cbc:	91858593          	addi	a1,a1,-1768 # 800085d0 <etext+0x5d0>
    80004cc0:	fb040513          	addi	a0,s0,-80
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	662080e7          	jalr	1634(ra) # 80003326 <namecmp>
    80004ccc:	14050c63          	beqz	a0,80004e24 <sys_unlink+0x1b0>
    80004cd0:	00004597          	auipc	a1,0x4
    80004cd4:	90858593          	addi	a1,a1,-1784 # 800085d8 <etext+0x5d8>
    80004cd8:	fb040513          	addi	a0,s0,-80
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	64a080e7          	jalr	1610(ra) # 80003326 <namecmp>
    80004ce4:	14050063          	beqz	a0,80004e24 <sys_unlink+0x1b0>
    80004ce8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cea:	f2c40613          	addi	a2,s0,-212
    80004cee:	fb040593          	addi	a1,s0,-80
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	64c080e7          	jalr	1612(ra) # 80003340 <dirlookup>
    80004cfc:	892a                	mv	s2,a0
    80004cfe:	12050263          	beqz	a0,80004e22 <sys_unlink+0x1ae>
  ilock(ip);
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	13e080e7          	jalr	318(ra) # 80002e40 <ilock>
  if(ip->nlink < 1)
    80004d0a:	04a91783          	lh	a5,74(s2)
    80004d0e:	08f05563          	blez	a5,80004d98 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d12:	04491703          	lh	a4,68(s2)
    80004d16:	4785                	li	a5,1
    80004d18:	08f70963          	beq	a4,a5,80004daa <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d1c:	4641                	li	a2,16
    80004d1e:	4581                	li	a1,0
    80004d20:	fc040513          	addi	a0,s0,-64
    80004d24:	ffffb097          	auipc	ra,0xffffb
    80004d28:	64e080e7          	jalr	1614(ra) # 80000372 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d2c:	4741                	li	a4,16
    80004d2e:	f2c42683          	lw	a3,-212(s0)
    80004d32:	fc040613          	addi	a2,s0,-64
    80004d36:	4581                	li	a1,0
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	4c2080e7          	jalr	1218(ra) # 800031fc <writei>
    80004d42:	47c1                	li	a5,16
    80004d44:	0af51b63          	bne	a0,a5,80004dfa <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d48:	04491703          	lh	a4,68(s2)
    80004d4c:	4785                	li	a5,1
    80004d4e:	0af70f63          	beq	a4,a5,80004e0c <sys_unlink+0x198>
  iunlockput(dp);
    80004d52:	8526                	mv	a0,s1
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	352080e7          	jalr	850(ra) # 800030a6 <iunlockput>
  ip->nlink--;
    80004d5c:	04a95783          	lhu	a5,74(s2)
    80004d60:	37fd                	addiw	a5,a5,-1
    80004d62:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d66:	854a                	mv	a0,s2
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	00c080e7          	jalr	12(ra) # 80002d74 <iupdate>
  iunlockput(ip);
    80004d70:	854a                	mv	a0,s2
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	334080e7          	jalr	820(ra) # 800030a6 <iunlockput>
  end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	b12080e7          	jalr	-1262(ra) # 8000388c <end_op>
  return 0;
    80004d82:	4501                	li	a0,0
    80004d84:	64ee                	ld	s1,216(sp)
    80004d86:	694e                	ld	s2,208(sp)
    80004d88:	a84d                	j	80004e3a <sys_unlink+0x1c6>
    end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	b02080e7          	jalr	-1278(ra) # 8000388c <end_op>
    return -1;
    80004d92:	557d                	li	a0,-1
    80004d94:	64ee                	ld	s1,216(sp)
    80004d96:	a055                	j	80004e3a <sys_unlink+0x1c6>
    80004d98:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d9a:	00004517          	auipc	a0,0x4
    80004d9e:	86650513          	addi	a0,a0,-1946 # 80008600 <etext+0x600>
    80004da2:	00001097          	auipc	ra,0x1
    80004da6:	20a080e7          	jalr	522(ra) # 80005fac <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004daa:	04c92703          	lw	a4,76(s2)
    80004dae:	02000793          	li	a5,32
    80004db2:	f6e7f5e3          	bgeu	a5,a4,80004d1c <sys_unlink+0xa8>
    80004db6:	e5ce                	sd	s3,200(sp)
    80004db8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dbc:	4741                	li	a4,16
    80004dbe:	86ce                	mv	a3,s3
    80004dc0:	f1840613          	addi	a2,s0,-232
    80004dc4:	4581                	li	a1,0
    80004dc6:	854a                	mv	a0,s2
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	330080e7          	jalr	816(ra) # 800030f8 <readi>
    80004dd0:	47c1                	li	a5,16
    80004dd2:	00f51c63          	bne	a0,a5,80004dea <sys_unlink+0x176>
    if(de.inum != 0)
    80004dd6:	f1845783          	lhu	a5,-232(s0)
    80004dda:	e7b5                	bnez	a5,80004e46 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ddc:	29c1                	addiw	s3,s3,16
    80004dde:	04c92783          	lw	a5,76(s2)
    80004de2:	fcf9ede3          	bltu	s3,a5,80004dbc <sys_unlink+0x148>
    80004de6:	69ae                	ld	s3,200(sp)
    80004de8:	bf15                	j	80004d1c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004dea:	00004517          	auipc	a0,0x4
    80004dee:	82e50513          	addi	a0,a0,-2002 # 80008618 <etext+0x618>
    80004df2:	00001097          	auipc	ra,0x1
    80004df6:	1ba080e7          	jalr	442(ra) # 80005fac <panic>
    80004dfa:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004dfc:	00004517          	auipc	a0,0x4
    80004e00:	83450513          	addi	a0,a0,-1996 # 80008630 <etext+0x630>
    80004e04:	00001097          	auipc	ra,0x1
    80004e08:	1a8080e7          	jalr	424(ra) # 80005fac <panic>
    dp->nlink--;
    80004e0c:	04a4d783          	lhu	a5,74(s1)
    80004e10:	37fd                	addiw	a5,a5,-1
    80004e12:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e16:	8526                	mv	a0,s1
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	f5c080e7          	jalr	-164(ra) # 80002d74 <iupdate>
    80004e20:	bf0d                	j	80004d52 <sys_unlink+0xde>
    80004e22:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	280080e7          	jalr	640(ra) # 800030a6 <iunlockput>
  end_op();
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	a5e080e7          	jalr	-1442(ra) # 8000388c <end_op>
  return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	64ee                	ld	s1,216(sp)
}
    80004e3a:	70ae                	ld	ra,232(sp)
    80004e3c:	740e                	ld	s0,224(sp)
    80004e3e:	616d                	addi	sp,sp,240
    80004e40:	8082                	ret
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	bfdd                	j	80004e3a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e46:	854a                	mv	a0,s2
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	25e080e7          	jalr	606(ra) # 800030a6 <iunlockput>
    goto bad;
    80004e50:	694e                	ld	s2,208(sp)
    80004e52:	69ae                	ld	s3,200(sp)
    80004e54:	bfc1                	j	80004e24 <sys_unlink+0x1b0>

0000000080004e56 <sys_open>:

uint64
sys_open(void)
{
    80004e56:	7131                	addi	sp,sp,-192
    80004e58:	fd06                	sd	ra,184(sp)
    80004e5a:	f922                	sd	s0,176(sp)
    80004e5c:	f526                	sd	s1,168(sp)
    80004e5e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e60:	08000613          	li	a2,128
    80004e64:	f5040593          	addi	a1,s0,-176
    80004e68:	4501                	li	a0,0
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	4a8080e7          	jalr	1192(ra) # 80002312 <argstr>
    return -1;
    80004e72:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e74:	0c054463          	bltz	a0,80004f3c <sys_open+0xe6>
    80004e78:	f4c40593          	addi	a1,s0,-180
    80004e7c:	4505                	li	a0,1
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	450080e7          	jalr	1104(ra) # 800022ce <argint>
    80004e86:	0a054b63          	bltz	a0,80004f3c <sys_open+0xe6>
    80004e8a:	f14a                	sd	s2,160(sp)

  begin_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	986080e7          	jalr	-1658(ra) # 80003812 <begin_op>

  if(omode & O_CREATE){
    80004e94:	f4c42783          	lw	a5,-180(s0)
    80004e98:	2007f793          	andi	a5,a5,512
    80004e9c:	cfc5                	beqz	a5,80004f54 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e9e:	4681                	li	a3,0
    80004ea0:	4601                	li	a2,0
    80004ea2:	4589                	li	a1,2
    80004ea4:	f5040513          	addi	a0,s0,-176
    80004ea8:	00000097          	auipc	ra,0x0
    80004eac:	958080e7          	jalr	-1704(ra) # 80004800 <create>
    80004eb0:	892a                	mv	s2,a0
    if(ip == 0){
    80004eb2:	c959                	beqz	a0,80004f48 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004eb4:	04491703          	lh	a4,68(s2)
    80004eb8:	478d                	li	a5,3
    80004eba:	00f71763          	bne	a4,a5,80004ec8 <sys_open+0x72>
    80004ebe:	04695703          	lhu	a4,70(s2)
    80004ec2:	47a5                	li	a5,9
    80004ec4:	0ce7ef63          	bltu	a5,a4,80004fa2 <sys_open+0x14c>
    80004ec8:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	d56080e7          	jalr	-682(ra) # 80003c20 <filealloc>
    80004ed2:	89aa                	mv	s3,a0
    80004ed4:	c965                	beqz	a0,80004fc4 <sys_open+0x16e>
    80004ed6:	00000097          	auipc	ra,0x0
    80004eda:	8e8080e7          	jalr	-1816(ra) # 800047be <fdalloc>
    80004ede:	84aa                	mv	s1,a0
    80004ee0:	0c054d63          	bltz	a0,80004fba <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ee4:	04491703          	lh	a4,68(s2)
    80004ee8:	478d                	li	a5,3
    80004eea:	0ef70a63          	beq	a4,a5,80004fde <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004eee:	4789                	li	a5,2
    80004ef0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ef4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ef8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004efc:	f4c42783          	lw	a5,-180(s0)
    80004f00:	0017c713          	xori	a4,a5,1
    80004f04:	8b05                	andi	a4,a4,1
    80004f06:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f0a:	0037f713          	andi	a4,a5,3
    80004f0e:	00e03733          	snez	a4,a4
    80004f12:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f16:	4007f793          	andi	a5,a5,1024
    80004f1a:	c791                	beqz	a5,80004f26 <sys_open+0xd0>
    80004f1c:	04491703          	lh	a4,68(s2)
    80004f20:	4789                	li	a5,2
    80004f22:	0cf70563          	beq	a4,a5,80004fec <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004f26:	854a                	mv	a0,s2
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	fde080e7          	jalr	-34(ra) # 80002f06 <iunlock>
  end_op();
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	95c080e7          	jalr	-1700(ra) # 8000388c <end_op>
    80004f38:	790a                	ld	s2,160(sp)
    80004f3a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	70ea                	ld	ra,184(sp)
    80004f40:	744a                	ld	s0,176(sp)
    80004f42:	74aa                	ld	s1,168(sp)
    80004f44:	6129                	addi	sp,sp,192
    80004f46:	8082                	ret
      end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	944080e7          	jalr	-1724(ra) # 8000388c <end_op>
      return -1;
    80004f50:	790a                	ld	s2,160(sp)
    80004f52:	b7ed                	j	80004f3c <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004f54:	f5040513          	addi	a0,s0,-176
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	6ba080e7          	jalr	1722(ra) # 80003612 <namei>
    80004f60:	892a                	mv	s2,a0
    80004f62:	c90d                	beqz	a0,80004f94 <sys_open+0x13e>
    ilock(ip);
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	edc080e7          	jalr	-292(ra) # 80002e40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f6c:	04491703          	lh	a4,68(s2)
    80004f70:	4785                	li	a5,1
    80004f72:	f4f711e3          	bne	a4,a5,80004eb4 <sys_open+0x5e>
    80004f76:	f4c42783          	lw	a5,-180(s0)
    80004f7a:	d7b9                	beqz	a5,80004ec8 <sys_open+0x72>
      iunlockput(ip);
    80004f7c:	854a                	mv	a0,s2
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	128080e7          	jalr	296(ra) # 800030a6 <iunlockput>
      end_op();
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	906080e7          	jalr	-1786(ra) # 8000388c <end_op>
      return -1;
    80004f8e:	54fd                	li	s1,-1
    80004f90:	790a                	ld	s2,160(sp)
    80004f92:	b76d                	j	80004f3c <sys_open+0xe6>
      end_op();
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	8f8080e7          	jalr	-1800(ra) # 8000388c <end_op>
      return -1;
    80004f9c:	54fd                	li	s1,-1
    80004f9e:	790a                	ld	s2,160(sp)
    80004fa0:	bf71                	j	80004f3c <sys_open+0xe6>
    iunlockput(ip);
    80004fa2:	854a                	mv	a0,s2
    80004fa4:	ffffe097          	auipc	ra,0xffffe
    80004fa8:	102080e7          	jalr	258(ra) # 800030a6 <iunlockput>
    end_op();
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	8e0080e7          	jalr	-1824(ra) # 8000388c <end_op>
    return -1;
    80004fb4:	54fd                	li	s1,-1
    80004fb6:	790a                	ld	s2,160(sp)
    80004fb8:	b751                	j	80004f3c <sys_open+0xe6>
      fileclose(f);
    80004fba:	854e                	mv	a0,s3
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	d20080e7          	jalr	-736(ra) # 80003cdc <fileclose>
    iunlockput(ip);
    80004fc4:	854a                	mv	a0,s2
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	0e0080e7          	jalr	224(ra) # 800030a6 <iunlockput>
    end_op();
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	8be080e7          	jalr	-1858(ra) # 8000388c <end_op>
    return -1;
    80004fd6:	54fd                	li	s1,-1
    80004fd8:	790a                	ld	s2,160(sp)
    80004fda:	69ea                	ld	s3,152(sp)
    80004fdc:	b785                	j	80004f3c <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004fde:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fe2:	04691783          	lh	a5,70(s2)
    80004fe6:	02f99223          	sh	a5,36(s3)
    80004fea:	b739                	j	80004ef8 <sys_open+0xa2>
    itrunc(ip);
    80004fec:	854a                	mv	a0,s2
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	f64080e7          	jalr	-156(ra) # 80002f52 <itrunc>
    80004ff6:	bf05                	j	80004f26 <sys_open+0xd0>

0000000080004ff8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ff8:	7175                	addi	sp,sp,-144
    80004ffa:	e506                	sd	ra,136(sp)
    80004ffc:	e122                	sd	s0,128(sp)
    80004ffe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	812080e7          	jalr	-2030(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005008:	08000613          	li	a2,128
    8000500c:	f7040593          	addi	a1,s0,-144
    80005010:	4501                	li	a0,0
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	300080e7          	jalr	768(ra) # 80002312 <argstr>
    8000501a:	02054963          	bltz	a0,8000504c <sys_mkdir+0x54>
    8000501e:	4681                	li	a3,0
    80005020:	4601                	li	a2,0
    80005022:	4585                	li	a1,1
    80005024:	f7040513          	addi	a0,s0,-144
    80005028:	fffff097          	auipc	ra,0xfffff
    8000502c:	7d8080e7          	jalr	2008(ra) # 80004800 <create>
    80005030:	cd11                	beqz	a0,8000504c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	074080e7          	jalr	116(ra) # 800030a6 <iunlockput>
  end_op();
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	852080e7          	jalr	-1966(ra) # 8000388c <end_op>
  return 0;
    80005042:	4501                	li	a0,0
}
    80005044:	60aa                	ld	ra,136(sp)
    80005046:	640a                	ld	s0,128(sp)
    80005048:	6149                	addi	sp,sp,144
    8000504a:	8082                	ret
    end_op();
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	840080e7          	jalr	-1984(ra) # 8000388c <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	b7fd                	j	80005044 <sys_mkdir+0x4c>

0000000080005058 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005058:	7135                	addi	sp,sp,-160
    8000505a:	ed06                	sd	ra,152(sp)
    8000505c:	e922                	sd	s0,144(sp)
    8000505e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005060:	ffffe097          	auipc	ra,0xffffe
    80005064:	7b2080e7          	jalr	1970(ra) # 80003812 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005068:	08000613          	li	a2,128
    8000506c:	f7040593          	addi	a1,s0,-144
    80005070:	4501                	li	a0,0
    80005072:	ffffd097          	auipc	ra,0xffffd
    80005076:	2a0080e7          	jalr	672(ra) # 80002312 <argstr>
    8000507a:	04054a63          	bltz	a0,800050ce <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000507e:	f6c40593          	addi	a1,s0,-148
    80005082:	4505                	li	a0,1
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	24a080e7          	jalr	586(ra) # 800022ce <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000508c:	04054163          	bltz	a0,800050ce <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005090:	f6840593          	addi	a1,s0,-152
    80005094:	4509                	li	a0,2
    80005096:	ffffd097          	auipc	ra,0xffffd
    8000509a:	238080e7          	jalr	568(ra) # 800022ce <argint>
     argint(1, &major) < 0 ||
    8000509e:	02054863          	bltz	a0,800050ce <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050a2:	f6841683          	lh	a3,-152(s0)
    800050a6:	f6c41603          	lh	a2,-148(s0)
    800050aa:	458d                	li	a1,3
    800050ac:	f7040513          	addi	a0,s0,-144
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	750080e7          	jalr	1872(ra) # 80004800 <create>
     argint(2, &minor) < 0 ||
    800050b8:	c919                	beqz	a0,800050ce <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050ba:	ffffe097          	auipc	ra,0xffffe
    800050be:	fec080e7          	jalr	-20(ra) # 800030a6 <iunlockput>
  end_op();
    800050c2:	ffffe097          	auipc	ra,0xffffe
    800050c6:	7ca080e7          	jalr	1994(ra) # 8000388c <end_op>
  return 0;
    800050ca:	4501                	li	a0,0
    800050cc:	a031                	j	800050d8 <sys_mknod+0x80>
    end_op();
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	7be080e7          	jalr	1982(ra) # 8000388c <end_op>
    return -1;
    800050d6:	557d                	li	a0,-1
}
    800050d8:	60ea                	ld	ra,152(sp)
    800050da:	644a                	ld	s0,144(sp)
    800050dc:	610d                	addi	sp,sp,160
    800050de:	8082                	ret

00000000800050e0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050e0:	7135                	addi	sp,sp,-160
    800050e2:	ed06                	sd	ra,152(sp)
    800050e4:	e922                	sd	s0,144(sp)
    800050e6:	e14a                	sd	s2,128(sp)
    800050e8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050ea:	ffffc097          	auipc	ra,0xffffc
    800050ee:	09a080e7          	jalr	154(ra) # 80001184 <myproc>
    800050f2:	892a                	mv	s2,a0
  
  begin_op();
    800050f4:	ffffe097          	auipc	ra,0xffffe
    800050f8:	71e080e7          	jalr	1822(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050fc:	08000613          	li	a2,128
    80005100:	f6040593          	addi	a1,s0,-160
    80005104:	4501                	li	a0,0
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	20c080e7          	jalr	524(ra) # 80002312 <argstr>
    8000510e:	04054d63          	bltz	a0,80005168 <sys_chdir+0x88>
    80005112:	e526                	sd	s1,136(sp)
    80005114:	f6040513          	addi	a0,s0,-160
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	4fa080e7          	jalr	1274(ra) # 80003612 <namei>
    80005120:	84aa                	mv	s1,a0
    80005122:	c131                	beqz	a0,80005166 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005124:	ffffe097          	auipc	ra,0xffffe
    80005128:	d1c080e7          	jalr	-740(ra) # 80002e40 <ilock>
  if(ip->type != T_DIR){
    8000512c:	04449703          	lh	a4,68(s1)
    80005130:	4785                	li	a5,1
    80005132:	04f71163          	bne	a4,a5,80005174 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005136:	8526                	mv	a0,s1
    80005138:	ffffe097          	auipc	ra,0xffffe
    8000513c:	dce080e7          	jalr	-562(ra) # 80002f06 <iunlock>
  iput(p->cwd);
    80005140:	15093503          	ld	a0,336(s2)
    80005144:	ffffe097          	auipc	ra,0xffffe
    80005148:	eba080e7          	jalr	-326(ra) # 80002ffe <iput>
  end_op();
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	740080e7          	jalr	1856(ra) # 8000388c <end_op>
  p->cwd = ip;
    80005154:	14993823          	sd	s1,336(s2)
  return 0;
    80005158:	4501                	li	a0,0
    8000515a:	64aa                	ld	s1,136(sp)
}
    8000515c:	60ea                	ld	ra,152(sp)
    8000515e:	644a                	ld	s0,144(sp)
    80005160:	690a                	ld	s2,128(sp)
    80005162:	610d                	addi	sp,sp,160
    80005164:	8082                	ret
    80005166:	64aa                	ld	s1,136(sp)
    end_op();
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	724080e7          	jalr	1828(ra) # 8000388c <end_op>
    return -1;
    80005170:	557d                	li	a0,-1
    80005172:	b7ed                	j	8000515c <sys_chdir+0x7c>
    iunlockput(ip);
    80005174:	8526                	mv	a0,s1
    80005176:	ffffe097          	auipc	ra,0xffffe
    8000517a:	f30080e7          	jalr	-208(ra) # 800030a6 <iunlockput>
    end_op();
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	70e080e7          	jalr	1806(ra) # 8000388c <end_op>
    return -1;
    80005186:	557d                	li	a0,-1
    80005188:	64aa                	ld	s1,136(sp)
    8000518a:	bfc9                	j	8000515c <sys_chdir+0x7c>

000000008000518c <sys_exec>:

uint64
sys_exec(void)
{
    8000518c:	7121                	addi	sp,sp,-448
    8000518e:	ff06                	sd	ra,440(sp)
    80005190:	fb22                	sd	s0,432(sp)
    80005192:	f34a                	sd	s2,416(sp)
    80005194:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005196:	08000613          	li	a2,128
    8000519a:	f5040593          	addi	a1,s0,-176
    8000519e:	4501                	li	a0,0
    800051a0:	ffffd097          	auipc	ra,0xffffd
    800051a4:	172080e7          	jalr	370(ra) # 80002312 <argstr>
    return -1;
    800051a8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051aa:	0e054a63          	bltz	a0,8000529e <sys_exec+0x112>
    800051ae:	e4840593          	addi	a1,s0,-440
    800051b2:	4505                	li	a0,1
    800051b4:	ffffd097          	auipc	ra,0xffffd
    800051b8:	13c080e7          	jalr	316(ra) # 800022f0 <argaddr>
    800051bc:	0e054163          	bltz	a0,8000529e <sys_exec+0x112>
    800051c0:	f726                	sd	s1,424(sp)
    800051c2:	ef4e                	sd	s3,408(sp)
    800051c4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051c6:	10000613          	li	a2,256
    800051ca:	4581                	li	a1,0
    800051cc:	e5040513          	addi	a0,s0,-432
    800051d0:	ffffb097          	auipc	ra,0xffffb
    800051d4:	1a2080e7          	jalr	418(ra) # 80000372 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051d8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051dc:	89a6                	mv	s3,s1
    800051de:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051e0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051e4:	00391513          	slli	a0,s2,0x3
    800051e8:	e4040593          	addi	a1,s0,-448
    800051ec:	e4843783          	ld	a5,-440(s0)
    800051f0:	953e                	add	a0,a0,a5
    800051f2:	ffffd097          	auipc	ra,0xffffd
    800051f6:	042080e7          	jalr	66(ra) # 80002234 <fetchaddr>
    800051fa:	02054a63          	bltz	a0,8000522e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800051fe:	e4043783          	ld	a5,-448(s0)
    80005202:	c7b1                	beqz	a5,8000524e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005204:	ffffb097          	auipc	ra,0xffffb
    80005208:	104080e7          	jalr	260(ra) # 80000308 <kalloc>
    8000520c:	85aa                	mv	a1,a0
    8000520e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005212:	cd11                	beqz	a0,8000522e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005214:	6605                	lui	a2,0x1
    80005216:	e4043503          	ld	a0,-448(s0)
    8000521a:	ffffd097          	auipc	ra,0xffffd
    8000521e:	06c080e7          	jalr	108(ra) # 80002286 <fetchstr>
    80005222:	00054663          	bltz	a0,8000522e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005226:	0905                	addi	s2,s2,1
    80005228:	09a1                	addi	s3,s3,8
    8000522a:	fb491de3          	bne	s2,s4,800051e4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000522e:	f5040913          	addi	s2,s0,-176
    80005232:	6088                	ld	a0,0(s1)
    80005234:	c12d                	beqz	a0,80005296 <sys_exec+0x10a>
    kfree(argv[i]);
    80005236:	ffffb097          	auipc	ra,0xffffb
    8000523a:	f0c080e7          	jalr	-244(ra) # 80000142 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000523e:	04a1                	addi	s1,s1,8
    80005240:	ff2499e3          	bne	s1,s2,80005232 <sys_exec+0xa6>
  return -1;
    80005244:	597d                	li	s2,-1
    80005246:	74ba                	ld	s1,424(sp)
    80005248:	69fa                	ld	s3,408(sp)
    8000524a:	6a5a                	ld	s4,400(sp)
    8000524c:	a889                	j	8000529e <sys_exec+0x112>
      argv[i] = 0;
    8000524e:	0009079b          	sext.w	a5,s2
    80005252:	078e                	slli	a5,a5,0x3
    80005254:	fd078793          	addi	a5,a5,-48
    80005258:	97a2                	add	a5,a5,s0
    8000525a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000525e:	e5040593          	addi	a1,s0,-432
    80005262:	f5040513          	addi	a0,s0,-176
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	126080e7          	jalr	294(ra) # 8000438c <exec>
    8000526e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005270:	f5040993          	addi	s3,s0,-176
    80005274:	6088                	ld	a0,0(s1)
    80005276:	cd01                	beqz	a0,8000528e <sys_exec+0x102>
    kfree(argv[i]);
    80005278:	ffffb097          	auipc	ra,0xffffb
    8000527c:	eca080e7          	jalr	-310(ra) # 80000142 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005280:	04a1                	addi	s1,s1,8
    80005282:	ff3499e3          	bne	s1,s3,80005274 <sys_exec+0xe8>
    80005286:	74ba                	ld	s1,424(sp)
    80005288:	69fa                	ld	s3,408(sp)
    8000528a:	6a5a                	ld	s4,400(sp)
    8000528c:	a809                	j	8000529e <sys_exec+0x112>
  return ret;
    8000528e:	74ba                	ld	s1,424(sp)
    80005290:	69fa                	ld	s3,408(sp)
    80005292:	6a5a                	ld	s4,400(sp)
    80005294:	a029                	j	8000529e <sys_exec+0x112>
  return -1;
    80005296:	597d                	li	s2,-1
    80005298:	74ba                	ld	s1,424(sp)
    8000529a:	69fa                	ld	s3,408(sp)
    8000529c:	6a5a                	ld	s4,400(sp)
}
    8000529e:	854a                	mv	a0,s2
    800052a0:	70fa                	ld	ra,440(sp)
    800052a2:	745a                	ld	s0,432(sp)
    800052a4:	791a                	ld	s2,416(sp)
    800052a6:	6139                	addi	sp,sp,448
    800052a8:	8082                	ret

00000000800052aa <sys_pipe>:

uint64
sys_pipe(void)
{
    800052aa:	7139                	addi	sp,sp,-64
    800052ac:	fc06                	sd	ra,56(sp)
    800052ae:	f822                	sd	s0,48(sp)
    800052b0:	f426                	sd	s1,40(sp)
    800052b2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052b4:	ffffc097          	auipc	ra,0xffffc
    800052b8:	ed0080e7          	jalr	-304(ra) # 80001184 <myproc>
    800052bc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800052be:	fd840593          	addi	a1,s0,-40
    800052c2:	4501                	li	a0,0
    800052c4:	ffffd097          	auipc	ra,0xffffd
    800052c8:	02c080e7          	jalr	44(ra) # 800022f0 <argaddr>
    return -1;
    800052cc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800052ce:	0e054063          	bltz	a0,800053ae <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800052d2:	fc840593          	addi	a1,s0,-56
    800052d6:	fd040513          	addi	a0,s0,-48
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	d70080e7          	jalr	-656(ra) # 8000404a <pipealloc>
    return -1;
    800052e2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052e4:	0c054563          	bltz	a0,800053ae <sys_pipe+0x104>
  fd0 = -1;
    800052e8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052ec:	fd043503          	ld	a0,-48(s0)
    800052f0:	fffff097          	auipc	ra,0xfffff
    800052f4:	4ce080e7          	jalr	1230(ra) # 800047be <fdalloc>
    800052f8:	fca42223          	sw	a0,-60(s0)
    800052fc:	08054c63          	bltz	a0,80005394 <sys_pipe+0xea>
    80005300:	fc843503          	ld	a0,-56(s0)
    80005304:	fffff097          	auipc	ra,0xfffff
    80005308:	4ba080e7          	jalr	1210(ra) # 800047be <fdalloc>
    8000530c:	fca42023          	sw	a0,-64(s0)
    80005310:	06054963          	bltz	a0,80005382 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005314:	4691                	li	a3,4
    80005316:	fc440613          	addi	a2,s0,-60
    8000531a:	fd843583          	ld	a1,-40(s0)
    8000531e:	68a8                	ld	a0,80(s1)
    80005320:	ffffc097          	auipc	ra,0xffffc
    80005324:	c18080e7          	jalr	-1000(ra) # 80000f38 <copyout>
    80005328:	02054063          	bltz	a0,80005348 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000532c:	4691                	li	a3,4
    8000532e:	fc040613          	addi	a2,s0,-64
    80005332:	fd843583          	ld	a1,-40(s0)
    80005336:	0591                	addi	a1,a1,4
    80005338:	68a8                	ld	a0,80(s1)
    8000533a:	ffffc097          	auipc	ra,0xffffc
    8000533e:	bfe080e7          	jalr	-1026(ra) # 80000f38 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005342:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005344:	06055563          	bgez	a0,800053ae <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005348:	fc442783          	lw	a5,-60(s0)
    8000534c:	07e9                	addi	a5,a5,26
    8000534e:	078e                	slli	a5,a5,0x3
    80005350:	97a6                	add	a5,a5,s1
    80005352:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005356:	fc042783          	lw	a5,-64(s0)
    8000535a:	07e9                	addi	a5,a5,26
    8000535c:	078e                	slli	a5,a5,0x3
    8000535e:	00f48533          	add	a0,s1,a5
    80005362:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005366:	fd043503          	ld	a0,-48(s0)
    8000536a:	fffff097          	auipc	ra,0xfffff
    8000536e:	972080e7          	jalr	-1678(ra) # 80003cdc <fileclose>
    fileclose(wf);
    80005372:	fc843503          	ld	a0,-56(s0)
    80005376:	fffff097          	auipc	ra,0xfffff
    8000537a:	966080e7          	jalr	-1690(ra) # 80003cdc <fileclose>
    return -1;
    8000537e:	57fd                	li	a5,-1
    80005380:	a03d                	j	800053ae <sys_pipe+0x104>
    if(fd0 >= 0)
    80005382:	fc442783          	lw	a5,-60(s0)
    80005386:	0007c763          	bltz	a5,80005394 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000538a:	07e9                	addi	a5,a5,26
    8000538c:	078e                	slli	a5,a5,0x3
    8000538e:	97a6                	add	a5,a5,s1
    80005390:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005394:	fd043503          	ld	a0,-48(s0)
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	944080e7          	jalr	-1724(ra) # 80003cdc <fileclose>
    fileclose(wf);
    800053a0:	fc843503          	ld	a0,-56(s0)
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	938080e7          	jalr	-1736(ra) # 80003cdc <fileclose>
    return -1;
    800053ac:	57fd                	li	a5,-1
}
    800053ae:	853e                	mv	a0,a5
    800053b0:	70e2                	ld	ra,56(sp)
    800053b2:	7442                	ld	s0,48(sp)
    800053b4:	74a2                	ld	s1,40(sp)
    800053b6:	6121                	addi	sp,sp,64
    800053b8:	8082                	ret
    800053ba:	0000                	unimp
    800053bc:	0000                	unimp
	...

00000000800053c0 <kernelvec>:
    800053c0:	7111                	addi	sp,sp,-256
    800053c2:	e006                	sd	ra,0(sp)
    800053c4:	e40a                	sd	sp,8(sp)
    800053c6:	e80e                	sd	gp,16(sp)
    800053c8:	ec12                	sd	tp,24(sp)
    800053ca:	f016                	sd	t0,32(sp)
    800053cc:	f41a                	sd	t1,40(sp)
    800053ce:	f81e                	sd	t2,48(sp)
    800053d0:	fc22                	sd	s0,56(sp)
    800053d2:	e0a6                	sd	s1,64(sp)
    800053d4:	e4aa                	sd	a0,72(sp)
    800053d6:	e8ae                	sd	a1,80(sp)
    800053d8:	ecb2                	sd	a2,88(sp)
    800053da:	f0b6                	sd	a3,96(sp)
    800053dc:	f4ba                	sd	a4,104(sp)
    800053de:	f8be                	sd	a5,112(sp)
    800053e0:	fcc2                	sd	a6,120(sp)
    800053e2:	e146                	sd	a7,128(sp)
    800053e4:	e54a                	sd	s2,136(sp)
    800053e6:	e94e                	sd	s3,144(sp)
    800053e8:	ed52                	sd	s4,152(sp)
    800053ea:	f156                	sd	s5,160(sp)
    800053ec:	f55a                	sd	s6,168(sp)
    800053ee:	f95e                	sd	s7,176(sp)
    800053f0:	fd62                	sd	s8,184(sp)
    800053f2:	e1e6                	sd	s9,192(sp)
    800053f4:	e5ea                	sd	s10,200(sp)
    800053f6:	e9ee                	sd	s11,208(sp)
    800053f8:	edf2                	sd	t3,216(sp)
    800053fa:	f1f6                	sd	t4,224(sp)
    800053fc:	f5fa                	sd	t5,232(sp)
    800053fe:	f9fe                	sd	t6,240(sp)
    80005400:	d01fc0ef          	jal	80002100 <kerneltrap>
    80005404:	6082                	ld	ra,0(sp)
    80005406:	6122                	ld	sp,8(sp)
    80005408:	61c2                	ld	gp,16(sp)
    8000540a:	7282                	ld	t0,32(sp)
    8000540c:	7322                	ld	t1,40(sp)
    8000540e:	73c2                	ld	t2,48(sp)
    80005410:	7462                	ld	s0,56(sp)
    80005412:	6486                	ld	s1,64(sp)
    80005414:	6526                	ld	a0,72(sp)
    80005416:	65c6                	ld	a1,80(sp)
    80005418:	6666                	ld	a2,88(sp)
    8000541a:	7686                	ld	a3,96(sp)
    8000541c:	7726                	ld	a4,104(sp)
    8000541e:	77c6                	ld	a5,112(sp)
    80005420:	7866                	ld	a6,120(sp)
    80005422:	688a                	ld	a7,128(sp)
    80005424:	692a                	ld	s2,136(sp)
    80005426:	69ca                	ld	s3,144(sp)
    80005428:	6a6a                	ld	s4,152(sp)
    8000542a:	7a8a                	ld	s5,160(sp)
    8000542c:	7b2a                	ld	s6,168(sp)
    8000542e:	7bca                	ld	s7,176(sp)
    80005430:	7c6a                	ld	s8,184(sp)
    80005432:	6c8e                	ld	s9,192(sp)
    80005434:	6d2e                	ld	s10,200(sp)
    80005436:	6dce                	ld	s11,208(sp)
    80005438:	6e6e                	ld	t3,216(sp)
    8000543a:	7e8e                	ld	t4,224(sp)
    8000543c:	7f2e                	ld	t5,232(sp)
    8000543e:	7fce                	ld	t6,240(sp)
    80005440:	6111                	addi	sp,sp,256
    80005442:	10200073          	sret
    80005446:	00000013          	nop
    8000544a:	00000013          	nop
    8000544e:	0001                	nop

0000000080005450 <timervec>:
    80005450:	34051573          	csrrw	a0,mscratch,a0
    80005454:	e10c                	sd	a1,0(a0)
    80005456:	e510                	sd	a2,8(a0)
    80005458:	e914                	sd	a3,16(a0)
    8000545a:	6d0c                	ld	a1,24(a0)
    8000545c:	7110                	ld	a2,32(a0)
    8000545e:	6194                	ld	a3,0(a1)
    80005460:	96b2                	add	a3,a3,a2
    80005462:	e194                	sd	a3,0(a1)
    80005464:	4589                	li	a1,2
    80005466:	14459073          	csrw	sip,a1
    8000546a:	6914                	ld	a3,16(a0)
    8000546c:	6510                	ld	a2,8(a0)
    8000546e:	610c                	ld	a1,0(a0)
    80005470:	34051573          	csrrw	a0,mscratch,a0
    80005474:	30200073          	mret
	...

000000008000547a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000547a:	1141                	addi	sp,sp,-16
    8000547c:	e422                	sd	s0,8(sp)
    8000547e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005480:	0c0007b7          	lui	a5,0xc000
    80005484:	4705                	li	a4,1
    80005486:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005488:	0c0007b7          	lui	a5,0xc000
    8000548c:	c3d8                	sw	a4,4(a5)
}
    8000548e:	6422                	ld	s0,8(sp)
    80005490:	0141                	addi	sp,sp,16
    80005492:	8082                	ret

0000000080005494 <plicinithart>:

void
plicinithart(void)
{
    80005494:	1141                	addi	sp,sp,-16
    80005496:	e406                	sd	ra,8(sp)
    80005498:	e022                	sd	s0,0(sp)
    8000549a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	cbc080e7          	jalr	-836(ra) # 80001158 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054a4:	0085171b          	slliw	a4,a0,0x8
    800054a8:	0c0027b7          	lui	a5,0xc002
    800054ac:	97ba                	add	a5,a5,a4
    800054ae:	40200713          	li	a4,1026
    800054b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054b6:	00d5151b          	slliw	a0,a0,0xd
    800054ba:	0c2017b7          	lui	a5,0xc201
    800054be:	97aa                	add	a5,a5,a0
    800054c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054c4:	60a2                	ld	ra,8(sp)
    800054c6:	6402                	ld	s0,0(sp)
    800054c8:	0141                	addi	sp,sp,16
    800054ca:	8082                	ret

00000000800054cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054cc:	1141                	addi	sp,sp,-16
    800054ce:	e406                	sd	ra,8(sp)
    800054d0:	e022                	sd	s0,0(sp)
    800054d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054d4:	ffffc097          	auipc	ra,0xffffc
    800054d8:	c84080e7          	jalr	-892(ra) # 80001158 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054dc:	00d5151b          	slliw	a0,a0,0xd
    800054e0:	0c2017b7          	lui	a5,0xc201
    800054e4:	97aa                	add	a5,a5,a0
  return irq;
}
    800054e6:	43c8                	lw	a0,4(a5)
    800054e8:	60a2                	ld	ra,8(sp)
    800054ea:	6402                	ld	s0,0(sp)
    800054ec:	0141                	addi	sp,sp,16
    800054ee:	8082                	ret

00000000800054f0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054f0:	1101                	addi	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	1000                	addi	s0,sp,32
    800054fa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054fc:	ffffc097          	auipc	ra,0xffffc
    80005500:	c5c080e7          	jalr	-932(ra) # 80001158 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005504:	00d5151b          	slliw	a0,a0,0xd
    80005508:	0c2017b7          	lui	a5,0xc201
    8000550c:	97aa                	add	a5,a5,a0
    8000550e:	c3c4                	sw	s1,4(a5)
}
    80005510:	60e2                	ld	ra,24(sp)
    80005512:	6442                	ld	s0,16(sp)
    80005514:	64a2                	ld	s1,8(sp)
    80005516:	6105                	addi	sp,sp,32
    80005518:	8082                	ret

000000008000551a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000551a:	1141                	addi	sp,sp,-16
    8000551c:	e406                	sd	ra,8(sp)
    8000551e:	e022                	sd	s0,0(sp)
    80005520:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005522:	479d                	li	a5,7
    80005524:	06a7c863          	blt	a5,a0,80005594 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005528:	00019717          	auipc	a4,0x19
    8000552c:	ad870713          	addi	a4,a4,-1320 # 8001e000 <disk>
    80005530:	972a                	add	a4,a4,a0
    80005532:	6789                	lui	a5,0x2
    80005534:	97ba                	add	a5,a5,a4
    80005536:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000553a:	e7ad                	bnez	a5,800055a4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000553c:	00451793          	slli	a5,a0,0x4
    80005540:	0001b717          	auipc	a4,0x1b
    80005544:	ac070713          	addi	a4,a4,-1344 # 80020000 <disk+0x2000>
    80005548:	6314                	ld	a3,0(a4)
    8000554a:	96be                	add	a3,a3,a5
    8000554c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005550:	6314                	ld	a3,0(a4)
    80005552:	96be                	add	a3,a3,a5
    80005554:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005558:	6314                	ld	a3,0(a4)
    8000555a:	96be                	add	a3,a3,a5
    8000555c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005560:	6318                	ld	a4,0(a4)
    80005562:	97ba                	add	a5,a5,a4
    80005564:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005568:	00019717          	auipc	a4,0x19
    8000556c:	a9870713          	addi	a4,a4,-1384 # 8001e000 <disk>
    80005570:	972a                	add	a4,a4,a0
    80005572:	6789                	lui	a5,0x2
    80005574:	97ba                	add	a5,a5,a4
    80005576:	4705                	li	a4,1
    80005578:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000557c:	0001b517          	auipc	a0,0x1b
    80005580:	a9c50513          	addi	a0,a0,-1380 # 80020018 <disk+0x2018>
    80005584:	ffffc097          	auipc	ra,0xffffc
    80005588:	452080e7          	jalr	1106(ra) # 800019d6 <wakeup>
}
    8000558c:	60a2                	ld	ra,8(sp)
    8000558e:	6402                	ld	s0,0(sp)
    80005590:	0141                	addi	sp,sp,16
    80005592:	8082                	ret
    panic("free_desc 1");
    80005594:	00003517          	auipc	a0,0x3
    80005598:	0ac50513          	addi	a0,a0,172 # 80008640 <etext+0x640>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	a10080e7          	jalr	-1520(ra) # 80005fac <panic>
    panic("free_desc 2");
    800055a4:	00003517          	auipc	a0,0x3
    800055a8:	0ac50513          	addi	a0,a0,172 # 80008650 <etext+0x650>
    800055ac:	00001097          	auipc	ra,0x1
    800055b0:	a00080e7          	jalr	-1536(ra) # 80005fac <panic>

00000000800055b4 <virtio_disk_init>:
{
    800055b4:	1141                	addi	sp,sp,-16
    800055b6:	e406                	sd	ra,8(sp)
    800055b8:	e022                	sd	s0,0(sp)
    800055ba:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055bc:	00003597          	auipc	a1,0x3
    800055c0:	0a458593          	addi	a1,a1,164 # 80008660 <etext+0x660>
    800055c4:	0001b517          	auipc	a0,0x1b
    800055c8:	b6450513          	addi	a0,a0,-1180 # 80020128 <disk+0x2128>
    800055cc:	00001097          	auipc	ra,0x1
    800055d0:	eca080e7          	jalr	-310(ra) # 80006496 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055d4:	100017b7          	lui	a5,0x10001
    800055d8:	4398                	lw	a4,0(a5)
    800055da:	2701                	sext.w	a4,a4
    800055dc:	747277b7          	lui	a5,0x74727
    800055e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055e4:	0ef71f63          	bne	a4,a5,800056e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055e8:	100017b7          	lui	a5,0x10001
    800055ec:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800055ee:	439c                	lw	a5,0(a5)
    800055f0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f2:	4705                	li	a4,1
    800055f4:	0ee79763          	bne	a5,a4,800056e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800055fe:	439c                	lw	a5,0(a5)
    80005600:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005602:	4709                	li	a4,2
    80005604:	0ce79f63          	bne	a5,a4,800056e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005608:	100017b7          	lui	a5,0x10001
    8000560c:	47d8                	lw	a4,12(a5)
    8000560e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005610:	554d47b7          	lui	a5,0x554d4
    80005614:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005618:	0cf71563          	bne	a4,a5,800056e2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000561c:	100017b7          	lui	a5,0x10001
    80005620:	4705                	li	a4,1
    80005622:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005624:	470d                	li	a4,3
    80005626:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005628:	10001737          	lui	a4,0x10001
    8000562c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000562e:	c7ffe737          	lui	a4,0xc7ffe
    80005632:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005636:	8ef9                	and	a3,a3,a4
    80005638:	10001737          	lui	a4,0x10001
    8000563c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563e:	472d                	li	a4,11
    80005640:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005642:	473d                	li	a4,15
    80005644:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005646:	100017b7          	lui	a5,0x10001
    8000564a:	6705                	lui	a4,0x1
    8000564c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000564e:	100017b7          	lui	a5,0x10001
    80005652:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000565e:	439c                	lw	a5,0(a5)
    80005660:	2781                	sext.w	a5,a5
  if(max == 0)
    80005662:	cbc1                	beqz	a5,800056f2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005664:	471d                	li	a4,7
    80005666:	08f77e63          	bgeu	a4,a5,80005702 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000566a:	100017b7          	lui	a5,0x10001
    8000566e:	4721                	li	a4,8
    80005670:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005672:	6609                	lui	a2,0x2
    80005674:	4581                	li	a1,0
    80005676:	00019517          	auipc	a0,0x19
    8000567a:	98a50513          	addi	a0,a0,-1654 # 8001e000 <disk>
    8000567e:	ffffb097          	auipc	ra,0xffffb
    80005682:	cf4080e7          	jalr	-780(ra) # 80000372 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005686:	00019697          	auipc	a3,0x19
    8000568a:	97a68693          	addi	a3,a3,-1670 # 8001e000 <disk>
    8000568e:	00c6d713          	srli	a4,a3,0xc
    80005692:	2701                	sext.w	a4,a4
    80005694:	100017b7          	lui	a5,0x10001
    80005698:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000569a:	0001b797          	auipc	a5,0x1b
    8000569e:	96678793          	addi	a5,a5,-1690 # 80020000 <disk+0x2000>
    800056a2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800056a4:	00019717          	auipc	a4,0x19
    800056a8:	9dc70713          	addi	a4,a4,-1572 # 8001e080 <disk+0x80>
    800056ac:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056ae:	0001a717          	auipc	a4,0x1a
    800056b2:	95270713          	addi	a4,a4,-1710 # 8001f000 <disk+0x1000>
    800056b6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056b8:	4705                	li	a4,1
    800056ba:	00e78c23          	sb	a4,24(a5)
    800056be:	00e78ca3          	sb	a4,25(a5)
    800056c2:	00e78d23          	sb	a4,26(a5)
    800056c6:	00e78da3          	sb	a4,27(a5)
    800056ca:	00e78e23          	sb	a4,28(a5)
    800056ce:	00e78ea3          	sb	a4,29(a5)
    800056d2:	00e78f23          	sb	a4,30(a5)
    800056d6:	00e78fa3          	sb	a4,31(a5)
}
    800056da:	60a2                	ld	ra,8(sp)
    800056dc:	6402                	ld	s0,0(sp)
    800056de:	0141                	addi	sp,sp,16
    800056e0:	8082                	ret
    panic("could not find virtio disk");
    800056e2:	00003517          	auipc	a0,0x3
    800056e6:	f8e50513          	addi	a0,a0,-114 # 80008670 <etext+0x670>
    800056ea:	00001097          	auipc	ra,0x1
    800056ee:	8c2080e7          	jalr	-1854(ra) # 80005fac <panic>
    panic("virtio disk has no queue 0");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	f9e50513          	addi	a0,a0,-98 # 80008690 <etext+0x690>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	8b2080e7          	jalr	-1870(ra) # 80005fac <panic>
    panic("virtio disk max queue too short");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	fae50513          	addi	a0,a0,-82 # 800086b0 <etext+0x6b0>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	8a2080e7          	jalr	-1886(ra) # 80005fac <panic>

0000000080005712 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005712:	7159                	addi	sp,sp,-112
    80005714:	f486                	sd	ra,104(sp)
    80005716:	f0a2                	sd	s0,96(sp)
    80005718:	eca6                	sd	s1,88(sp)
    8000571a:	e8ca                	sd	s2,80(sp)
    8000571c:	e4ce                	sd	s3,72(sp)
    8000571e:	e0d2                	sd	s4,64(sp)
    80005720:	fc56                	sd	s5,56(sp)
    80005722:	f85a                	sd	s6,48(sp)
    80005724:	f45e                	sd	s7,40(sp)
    80005726:	f062                	sd	s8,32(sp)
    80005728:	ec66                	sd	s9,24(sp)
    8000572a:	1880                	addi	s0,sp,112
    8000572c:	8a2a                	mv	s4,a0
    8000572e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005730:	00c52c03          	lw	s8,12(a0)
    80005734:	001c1c1b          	slliw	s8,s8,0x1
    80005738:	1c02                	slli	s8,s8,0x20
    8000573a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000573e:	0001b517          	auipc	a0,0x1b
    80005742:	9ea50513          	addi	a0,a0,-1558 # 80020128 <disk+0x2128>
    80005746:	00001097          	auipc	ra,0x1
    8000574a:	de0080e7          	jalr	-544(ra) # 80006526 <acquire>
  for(int i = 0; i < 3; i++){
    8000574e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005750:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005752:	00019b97          	auipc	s7,0x19
    80005756:	8aeb8b93          	addi	s7,s7,-1874 # 8001e000 <disk>
    8000575a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000575c:	4a8d                	li	s5,3
    8000575e:	a88d                	j	800057d0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005760:	00fb8733          	add	a4,s7,a5
    80005764:	975a                	add	a4,a4,s6
    80005766:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000576a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000576c:	0207c563          	bltz	a5,80005796 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005770:	2905                	addiw	s2,s2,1
    80005772:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005774:	1b590163          	beq	s2,s5,80005916 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005778:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000577a:	0001b717          	auipc	a4,0x1b
    8000577e:	89e70713          	addi	a4,a4,-1890 # 80020018 <disk+0x2018>
    80005782:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005784:	00074683          	lbu	a3,0(a4)
    80005788:	fee1                	bnez	a3,80005760 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000578a:	2785                	addiw	a5,a5,1
    8000578c:	0705                	addi	a4,a4,1
    8000578e:	fe979be3          	bne	a5,s1,80005784 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005792:	57fd                	li	a5,-1
    80005794:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005796:	03205163          	blez	s2,800057b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000579a:	f9042503          	lw	a0,-112(s0)
    8000579e:	00000097          	auipc	ra,0x0
    800057a2:	d7c080e7          	jalr	-644(ra) # 8000551a <free_desc>
      for(int j = 0; j < i; j++)
    800057a6:	4785                	li	a5,1
    800057a8:	0127d863          	bge	a5,s2,800057b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800057ac:	f9442503          	lw	a0,-108(s0)
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	d6a080e7          	jalr	-662(ra) # 8000551a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057b8:	0001b597          	auipc	a1,0x1b
    800057bc:	97058593          	addi	a1,a1,-1680 # 80020128 <disk+0x2128>
    800057c0:	0001b517          	auipc	a0,0x1b
    800057c4:	85850513          	addi	a0,a0,-1960 # 80020018 <disk+0x2018>
    800057c8:	ffffc097          	auipc	ra,0xffffc
    800057cc:	082080e7          	jalr	130(ra) # 8000184a <sleep>
  for(int i = 0; i < 3; i++){
    800057d0:	f9040613          	addi	a2,s0,-112
    800057d4:	894e                	mv	s2,s3
    800057d6:	b74d                	j	80005778 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800057d8:	0001b717          	auipc	a4,0x1b
    800057dc:	82873703          	ld	a4,-2008(a4) # 80020000 <disk+0x2000>
    800057e0:	973e                	add	a4,a4,a5
    800057e2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057e6:	00019897          	auipc	a7,0x19
    800057ea:	81a88893          	addi	a7,a7,-2022 # 8001e000 <disk>
    800057ee:	0001b717          	auipc	a4,0x1b
    800057f2:	81270713          	addi	a4,a4,-2030 # 80020000 <disk+0x2000>
    800057f6:	6314                	ld	a3,0(a4)
    800057f8:	96be                	add	a3,a3,a5
    800057fa:	00c6d583          	lhu	a1,12(a3)
    800057fe:	0015e593          	ori	a1,a1,1
    80005802:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005806:	f9842683          	lw	a3,-104(s0)
    8000580a:	630c                	ld	a1,0(a4)
    8000580c:	97ae                	add	a5,a5,a1
    8000580e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005812:	20050593          	addi	a1,a0,512
    80005816:	0592                	slli	a1,a1,0x4
    80005818:	95c6                	add	a1,a1,a7
    8000581a:	57fd                	li	a5,-1
    8000581c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005820:	00469793          	slli	a5,a3,0x4
    80005824:	00073803          	ld	a6,0(a4)
    80005828:	983e                	add	a6,a6,a5
    8000582a:	6689                	lui	a3,0x2
    8000582c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005830:	96b2                	add	a3,a3,a2
    80005832:	96c6                	add	a3,a3,a7
    80005834:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005838:	6314                	ld	a3,0(a4)
    8000583a:	96be                	add	a3,a3,a5
    8000583c:	4605                	li	a2,1
    8000583e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005840:	6314                	ld	a3,0(a4)
    80005842:	96be                	add	a3,a3,a5
    80005844:	4809                	li	a6,2
    80005846:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000584a:	6314                	ld	a3,0(a4)
    8000584c:	97b6                	add	a5,a5,a3
    8000584e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005852:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005856:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000585a:	6714                	ld	a3,8(a4)
    8000585c:	0026d783          	lhu	a5,2(a3)
    80005860:	8b9d                	andi	a5,a5,7
    80005862:	0786                	slli	a5,a5,0x1
    80005864:	96be                	add	a3,a3,a5
    80005866:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000586a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000586e:	6718                	ld	a4,8(a4)
    80005870:	00275783          	lhu	a5,2(a4)
    80005874:	2785                	addiw	a5,a5,1
    80005876:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000587a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000587e:	100017b7          	lui	a5,0x10001
    80005882:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005886:	004a2783          	lw	a5,4(s4)
    8000588a:	02c79163          	bne	a5,a2,800058ac <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000588e:	0001b917          	auipc	s2,0x1b
    80005892:	89a90913          	addi	s2,s2,-1894 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005896:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005898:	85ca                	mv	a1,s2
    8000589a:	8552                	mv	a0,s4
    8000589c:	ffffc097          	auipc	ra,0xffffc
    800058a0:	fae080e7          	jalr	-82(ra) # 8000184a <sleep>
  while(b->disk == 1) {
    800058a4:	004a2783          	lw	a5,4(s4)
    800058a8:	fe9788e3          	beq	a5,s1,80005898 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800058ac:	f9042903          	lw	s2,-112(s0)
    800058b0:	20090713          	addi	a4,s2,512
    800058b4:	0712                	slli	a4,a4,0x4
    800058b6:	00018797          	auipc	a5,0x18
    800058ba:	74a78793          	addi	a5,a5,1866 # 8001e000 <disk>
    800058be:	97ba                	add	a5,a5,a4
    800058c0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800058c4:	0001a997          	auipc	s3,0x1a
    800058c8:	73c98993          	addi	s3,s3,1852 # 80020000 <disk+0x2000>
    800058cc:	00491713          	slli	a4,s2,0x4
    800058d0:	0009b783          	ld	a5,0(s3)
    800058d4:	97ba                	add	a5,a5,a4
    800058d6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058da:	854a                	mv	a0,s2
    800058dc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058e0:	00000097          	auipc	ra,0x0
    800058e4:	c3a080e7          	jalr	-966(ra) # 8000551a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058e8:	8885                	andi	s1,s1,1
    800058ea:	f0ed                	bnez	s1,800058cc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058ec:	0001b517          	auipc	a0,0x1b
    800058f0:	83c50513          	addi	a0,a0,-1988 # 80020128 <disk+0x2128>
    800058f4:	00001097          	auipc	ra,0x1
    800058f8:	ce6080e7          	jalr	-794(ra) # 800065da <release>
}
    800058fc:	70a6                	ld	ra,104(sp)
    800058fe:	7406                	ld	s0,96(sp)
    80005900:	64e6                	ld	s1,88(sp)
    80005902:	6946                	ld	s2,80(sp)
    80005904:	69a6                	ld	s3,72(sp)
    80005906:	6a06                	ld	s4,64(sp)
    80005908:	7ae2                	ld	s5,56(sp)
    8000590a:	7b42                	ld	s6,48(sp)
    8000590c:	7ba2                	ld	s7,40(sp)
    8000590e:	7c02                	ld	s8,32(sp)
    80005910:	6ce2                	ld	s9,24(sp)
    80005912:	6165                	addi	sp,sp,112
    80005914:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005916:	f9042503          	lw	a0,-112(s0)
    8000591a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000591e:	00018597          	auipc	a1,0x18
    80005922:	6e258593          	addi	a1,a1,1762 # 8001e000 <disk>
    80005926:	20050793          	addi	a5,a0,512
    8000592a:	0792                	slli	a5,a5,0x4
    8000592c:	97ae                	add	a5,a5,a1
    8000592e:	01903733          	snez	a4,s9
    80005932:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005936:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000593a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000593e:	0001a717          	auipc	a4,0x1a
    80005942:	6c270713          	addi	a4,a4,1730 # 80020000 <disk+0x2000>
    80005946:	6314                	ld	a3,0(a4)
    80005948:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000594a:	6789                	lui	a5,0x2
    8000594c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005950:	97b2                	add	a5,a5,a2
    80005952:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005954:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005956:	631c                	ld	a5,0(a4)
    80005958:	97b2                	add	a5,a5,a2
    8000595a:	46c1                	li	a3,16
    8000595c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000595e:	631c                	ld	a5,0(a4)
    80005960:	97b2                	add	a5,a5,a2
    80005962:	4685                	li	a3,1
    80005964:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005968:	f9442783          	lw	a5,-108(s0)
    8000596c:	6314                	ld	a3,0(a4)
    8000596e:	96b2                	add	a3,a3,a2
    80005970:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005974:	0792                	slli	a5,a5,0x4
    80005976:	6314                	ld	a3,0(a4)
    80005978:	96be                	add	a3,a3,a5
    8000597a:	058a0593          	addi	a1,s4,88
    8000597e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005980:	6318                	ld	a4,0(a4)
    80005982:	973e                	add	a4,a4,a5
    80005984:	40000693          	li	a3,1024
    80005988:	c714                	sw	a3,8(a4)
  if(write)
    8000598a:	e40c97e3          	bnez	s9,800057d8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000598e:	0001a717          	auipc	a4,0x1a
    80005992:	67273703          	ld	a4,1650(a4) # 80020000 <disk+0x2000>
    80005996:	973e                	add	a4,a4,a5
    80005998:	4689                	li	a3,2
    8000599a:	00d71623          	sh	a3,12(a4)
    8000599e:	b5a1                	j	800057e6 <virtio_disk_rw+0xd4>

00000000800059a0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059a0:	1101                	addi	sp,sp,-32
    800059a2:	ec06                	sd	ra,24(sp)
    800059a4:	e822                	sd	s0,16(sp)
    800059a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059a8:	0001a517          	auipc	a0,0x1a
    800059ac:	78050513          	addi	a0,a0,1920 # 80020128 <disk+0x2128>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	b76080e7          	jalr	-1162(ra) # 80006526 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059b8:	100017b7          	lui	a5,0x10001
    800059bc:	53b8                	lw	a4,96(a5)
    800059be:	8b0d                	andi	a4,a4,3
    800059c0:	100017b7          	lui	a5,0x10001
    800059c4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800059c6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059ca:	0001a797          	auipc	a5,0x1a
    800059ce:	63678793          	addi	a5,a5,1590 # 80020000 <disk+0x2000>
    800059d2:	6b94                	ld	a3,16(a5)
    800059d4:	0207d703          	lhu	a4,32(a5)
    800059d8:	0026d783          	lhu	a5,2(a3)
    800059dc:	06f70563          	beq	a4,a5,80005a46 <virtio_disk_intr+0xa6>
    800059e0:	e426                	sd	s1,8(sp)
    800059e2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059e4:	00018917          	auipc	s2,0x18
    800059e8:	61c90913          	addi	s2,s2,1564 # 8001e000 <disk>
    800059ec:	0001a497          	auipc	s1,0x1a
    800059f0:	61448493          	addi	s1,s1,1556 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800059f4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059f8:	6898                	ld	a4,16(s1)
    800059fa:	0204d783          	lhu	a5,32(s1)
    800059fe:	8b9d                	andi	a5,a5,7
    80005a00:	078e                	slli	a5,a5,0x3
    80005a02:	97ba                	add	a5,a5,a4
    80005a04:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a06:	20078713          	addi	a4,a5,512
    80005a0a:	0712                	slli	a4,a4,0x4
    80005a0c:	974a                	add	a4,a4,s2
    80005a0e:	03074703          	lbu	a4,48(a4)
    80005a12:	e731                	bnez	a4,80005a5e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a14:	20078793          	addi	a5,a5,512
    80005a18:	0792                	slli	a5,a5,0x4
    80005a1a:	97ca                	add	a5,a5,s2
    80005a1c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a1e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a22:	ffffc097          	auipc	ra,0xffffc
    80005a26:	fb4080e7          	jalr	-76(ra) # 800019d6 <wakeup>

    disk.used_idx += 1;
    80005a2a:	0204d783          	lhu	a5,32(s1)
    80005a2e:	2785                	addiw	a5,a5,1
    80005a30:	17c2                	slli	a5,a5,0x30
    80005a32:	93c1                	srli	a5,a5,0x30
    80005a34:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a38:	6898                	ld	a4,16(s1)
    80005a3a:	00275703          	lhu	a4,2(a4)
    80005a3e:	faf71be3          	bne	a4,a5,800059f4 <virtio_disk_intr+0x54>
    80005a42:	64a2                	ld	s1,8(sp)
    80005a44:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005a46:	0001a517          	auipc	a0,0x1a
    80005a4a:	6e250513          	addi	a0,a0,1762 # 80020128 <disk+0x2128>
    80005a4e:	00001097          	auipc	ra,0x1
    80005a52:	b8c080e7          	jalr	-1140(ra) # 800065da <release>
}
    80005a56:	60e2                	ld	ra,24(sp)
    80005a58:	6442                	ld	s0,16(sp)
    80005a5a:	6105                	addi	sp,sp,32
    80005a5c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a5e:	00003517          	auipc	a0,0x3
    80005a62:	c7250513          	addi	a0,a0,-910 # 800086d0 <etext+0x6d0>
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	546080e7          	jalr	1350(ra) # 80005fac <panic>

0000000080005a6e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a6e:	1141                	addi	sp,sp,-16
    80005a70:	e422                	sd	s0,8(sp)
    80005a72:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a74:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a78:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a7c:	0037979b          	slliw	a5,a5,0x3
    80005a80:	02004737          	lui	a4,0x2004
    80005a84:	97ba                	add	a5,a5,a4
    80005a86:	0200c737          	lui	a4,0x200c
    80005a8a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005a8c:	6318                	ld	a4,0(a4)
    80005a8e:	000f4637          	lui	a2,0xf4
    80005a92:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a96:	9732                	add	a4,a4,a2
    80005a98:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a9a:	00259693          	slli	a3,a1,0x2
    80005a9e:	96ae                	add	a3,a3,a1
    80005aa0:	068e                	slli	a3,a3,0x3
    80005aa2:	0001b717          	auipc	a4,0x1b
    80005aa6:	55e70713          	addi	a4,a4,1374 # 80021000 <timer_scratch>
    80005aaa:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005aac:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005aae:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005ab0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ab4:	00000797          	auipc	a5,0x0
    80005ab8:	99c78793          	addi	a5,a5,-1636 # 80005450 <timervec>
    80005abc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ac0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ac4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ac8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005acc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ad0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ad4:	30479073          	csrw	mie,a5
}
    80005ad8:	6422                	ld	s0,8(sp)
    80005ada:	0141                	addi	sp,sp,16
    80005adc:	8082                	ret

0000000080005ade <start>:
{
    80005ade:	1141                	addi	sp,sp,-16
    80005ae0:	e406                	sd	ra,8(sp)
    80005ae2:	e022                	sd	s0,0(sp)
    80005ae4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ae6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005aea:	7779                	lui	a4,0xffffe
    80005aec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    80005af0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005af2:	6705                	lui	a4,0x1
    80005af4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005af8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005afa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005afe:	ffffb797          	auipc	a5,0xffffb
    80005b02:	a1278793          	addi	a5,a5,-1518 # 80000510 <main>
    80005b06:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b0a:	4781                	li	a5,0
    80005b0c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b10:	67c1                	lui	a5,0x10
    80005b12:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b14:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b18:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b1c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b20:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b24:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b28:	57fd                	li	a5,-1
    80005b2a:	83a9                	srli	a5,a5,0xa
    80005b2c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b30:	47bd                	li	a5,15
    80005b32:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b36:	00000097          	auipc	ra,0x0
    80005b3a:	f38080e7          	jalr	-200(ra) # 80005a6e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b3e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b42:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b44:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b46:	30200073          	mret
}
    80005b4a:	60a2                	ld	ra,8(sp)
    80005b4c:	6402                	ld	s0,0(sp)
    80005b4e:	0141                	addi	sp,sp,16
    80005b50:	8082                	ret

0000000080005b52 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b52:	715d                	addi	sp,sp,-80
    80005b54:	e486                	sd	ra,72(sp)
    80005b56:	e0a2                	sd	s0,64(sp)
    80005b58:	f84a                	sd	s2,48(sp)
    80005b5a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b5c:	04c05663          	blez	a2,80005ba8 <consolewrite+0x56>
    80005b60:	fc26                	sd	s1,56(sp)
    80005b62:	f44e                	sd	s3,40(sp)
    80005b64:	f052                	sd	s4,32(sp)
    80005b66:	ec56                	sd	s5,24(sp)
    80005b68:	8a2a                	mv	s4,a0
    80005b6a:	84ae                	mv	s1,a1
    80005b6c:	89b2                	mv	s3,a2
    80005b6e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b70:	5afd                	li	s5,-1
    80005b72:	4685                	li	a3,1
    80005b74:	8626                	mv	a2,s1
    80005b76:	85d2                	mv	a1,s4
    80005b78:	fbf40513          	addi	a0,s0,-65
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	0c8080e7          	jalr	200(ra) # 80001c44 <either_copyin>
    80005b84:	03550463          	beq	a0,s5,80005bac <consolewrite+0x5a>
      break;
    uartputc(c);
    80005b88:	fbf44503          	lbu	a0,-65(s0)
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	7de080e7          	jalr	2014(ra) # 8000636a <uartputc>
  for(i = 0; i < n; i++){
    80005b94:	2905                	addiw	s2,s2,1
    80005b96:	0485                	addi	s1,s1,1
    80005b98:	fd299de3          	bne	s3,s2,80005b72 <consolewrite+0x20>
    80005b9c:	894e                	mv	s2,s3
    80005b9e:	74e2                	ld	s1,56(sp)
    80005ba0:	79a2                	ld	s3,40(sp)
    80005ba2:	7a02                	ld	s4,32(sp)
    80005ba4:	6ae2                	ld	s5,24(sp)
    80005ba6:	a039                	j	80005bb4 <consolewrite+0x62>
    80005ba8:	4901                	li	s2,0
    80005baa:	a029                	j	80005bb4 <consolewrite+0x62>
    80005bac:	74e2                	ld	s1,56(sp)
    80005bae:	79a2                	ld	s3,40(sp)
    80005bb0:	7a02                	ld	s4,32(sp)
    80005bb2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005bb4:	854a                	mv	a0,s2
    80005bb6:	60a6                	ld	ra,72(sp)
    80005bb8:	6406                	ld	s0,64(sp)
    80005bba:	7942                	ld	s2,48(sp)
    80005bbc:	6161                	addi	sp,sp,80
    80005bbe:	8082                	ret

0000000080005bc0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bc0:	711d                	addi	sp,sp,-96
    80005bc2:	ec86                	sd	ra,88(sp)
    80005bc4:	e8a2                	sd	s0,80(sp)
    80005bc6:	e4a6                	sd	s1,72(sp)
    80005bc8:	e0ca                	sd	s2,64(sp)
    80005bca:	fc4e                	sd	s3,56(sp)
    80005bcc:	f852                	sd	s4,48(sp)
    80005bce:	f456                	sd	s5,40(sp)
    80005bd0:	f05a                	sd	s6,32(sp)
    80005bd2:	1080                	addi	s0,sp,96
    80005bd4:	8aaa                	mv	s5,a0
    80005bd6:	8a2e                	mv	s4,a1
    80005bd8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bda:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005bde:	00023517          	auipc	a0,0x23
    80005be2:	56250513          	addi	a0,a0,1378 # 80029140 <cons>
    80005be6:	00001097          	auipc	ra,0x1
    80005bea:	940080e7          	jalr	-1728(ra) # 80006526 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bee:	00023497          	auipc	s1,0x23
    80005bf2:	55248493          	addi	s1,s1,1362 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005bf6:	00023917          	auipc	s2,0x23
    80005bfa:	5e290913          	addi	s2,s2,1506 # 800291d8 <cons+0x98>
  while(n > 0){
    80005bfe:	0d305463          	blez	s3,80005cc6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005c02:	0984a783          	lw	a5,152(s1)
    80005c06:	09c4a703          	lw	a4,156(s1)
    80005c0a:	0af71963          	bne	a4,a5,80005cbc <consoleread+0xfc>
      if(myproc()->killed){
    80005c0e:	ffffb097          	auipc	ra,0xffffb
    80005c12:	576080e7          	jalr	1398(ra) # 80001184 <myproc>
    80005c16:	551c                	lw	a5,40(a0)
    80005c18:	e7ad                	bnez	a5,80005c82 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005c1a:	85a6                	mv	a1,s1
    80005c1c:	854a                	mv	a0,s2
    80005c1e:	ffffc097          	auipc	ra,0xffffc
    80005c22:	c2c080e7          	jalr	-980(ra) # 8000184a <sleep>
    while(cons.r == cons.w){
    80005c26:	0984a783          	lw	a5,152(s1)
    80005c2a:	09c4a703          	lw	a4,156(s1)
    80005c2e:	fef700e3          	beq	a4,a5,80005c0e <consoleread+0x4e>
    80005c32:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005c34:	00023717          	auipc	a4,0x23
    80005c38:	50c70713          	addi	a4,a4,1292 # 80029140 <cons>
    80005c3c:	0017869b          	addiw	a3,a5,1
    80005c40:	08d72c23          	sw	a3,152(a4)
    80005c44:	07f7f693          	andi	a3,a5,127
    80005c48:	9736                	add	a4,a4,a3
    80005c4a:	01874703          	lbu	a4,24(a4)
    80005c4e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005c52:	4691                	li	a3,4
    80005c54:	04db8a63          	beq	s7,a3,80005ca8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005c58:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c5c:	4685                	li	a3,1
    80005c5e:	faf40613          	addi	a2,s0,-81
    80005c62:	85d2                	mv	a1,s4
    80005c64:	8556                	mv	a0,s5
    80005c66:	ffffc097          	auipc	ra,0xffffc
    80005c6a:	f88080e7          	jalr	-120(ra) # 80001bee <either_copyout>
    80005c6e:	57fd                	li	a5,-1
    80005c70:	04f50a63          	beq	a0,a5,80005cc4 <consoleread+0x104>
      break;

    dst++;
    80005c74:	0a05                	addi	s4,s4,1
    --n;
    80005c76:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005c78:	47a9                	li	a5,10
    80005c7a:	06fb8163          	beq	s7,a5,80005cdc <consoleread+0x11c>
    80005c7e:	6be2                	ld	s7,24(sp)
    80005c80:	bfbd                	j	80005bfe <consoleread+0x3e>
        release(&cons.lock);
    80005c82:	00023517          	auipc	a0,0x23
    80005c86:	4be50513          	addi	a0,a0,1214 # 80029140 <cons>
    80005c8a:	00001097          	auipc	ra,0x1
    80005c8e:	950080e7          	jalr	-1712(ra) # 800065da <release>
        return -1;
    80005c92:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005c94:	60e6                	ld	ra,88(sp)
    80005c96:	6446                	ld	s0,80(sp)
    80005c98:	64a6                	ld	s1,72(sp)
    80005c9a:	6906                	ld	s2,64(sp)
    80005c9c:	79e2                	ld	s3,56(sp)
    80005c9e:	7a42                	ld	s4,48(sp)
    80005ca0:	7aa2                	ld	s5,40(sp)
    80005ca2:	7b02                	ld	s6,32(sp)
    80005ca4:	6125                	addi	sp,sp,96
    80005ca6:	8082                	ret
      if(n < target){
    80005ca8:	0009871b          	sext.w	a4,s3
    80005cac:	01677a63          	bgeu	a4,s6,80005cc0 <consoleread+0x100>
        cons.r--;
    80005cb0:	00023717          	auipc	a4,0x23
    80005cb4:	52f72423          	sw	a5,1320(a4) # 800291d8 <cons+0x98>
    80005cb8:	6be2                	ld	s7,24(sp)
    80005cba:	a031                	j	80005cc6 <consoleread+0x106>
    80005cbc:	ec5e                	sd	s7,24(sp)
    80005cbe:	bf9d                	j	80005c34 <consoleread+0x74>
    80005cc0:	6be2                	ld	s7,24(sp)
    80005cc2:	a011                	j	80005cc6 <consoleread+0x106>
    80005cc4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005cc6:	00023517          	auipc	a0,0x23
    80005cca:	47a50513          	addi	a0,a0,1146 # 80029140 <cons>
    80005cce:	00001097          	auipc	ra,0x1
    80005cd2:	90c080e7          	jalr	-1780(ra) # 800065da <release>
  return target - n;
    80005cd6:	413b053b          	subw	a0,s6,s3
    80005cda:	bf6d                	j	80005c94 <consoleread+0xd4>
    80005cdc:	6be2                	ld	s7,24(sp)
    80005cde:	b7e5                	j	80005cc6 <consoleread+0x106>

0000000080005ce0 <consputc>:
{
    80005ce0:	1141                	addi	sp,sp,-16
    80005ce2:	e406                	sd	ra,8(sp)
    80005ce4:	e022                	sd	s0,0(sp)
    80005ce6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ce8:	10000793          	li	a5,256
    80005cec:	00f50a63          	beq	a0,a5,80005d00 <consputc+0x20>
    uartputc_sync(c);
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	59c080e7          	jalr	1436(ra) # 8000628c <uartputc_sync>
}
    80005cf8:	60a2                	ld	ra,8(sp)
    80005cfa:	6402                	ld	s0,0(sp)
    80005cfc:	0141                	addi	sp,sp,16
    80005cfe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d00:	4521                	li	a0,8
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	58a080e7          	jalr	1418(ra) # 8000628c <uartputc_sync>
    80005d0a:	02000513          	li	a0,32
    80005d0e:	00000097          	auipc	ra,0x0
    80005d12:	57e080e7          	jalr	1406(ra) # 8000628c <uartputc_sync>
    80005d16:	4521                	li	a0,8
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	574080e7          	jalr	1396(ra) # 8000628c <uartputc_sync>
    80005d20:	bfe1                	j	80005cf8 <consputc+0x18>

0000000080005d22 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d22:	1101                	addi	sp,sp,-32
    80005d24:	ec06                	sd	ra,24(sp)
    80005d26:	e822                	sd	s0,16(sp)
    80005d28:	e426                	sd	s1,8(sp)
    80005d2a:	1000                	addi	s0,sp,32
    80005d2c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d2e:	00023517          	auipc	a0,0x23
    80005d32:	41250513          	addi	a0,a0,1042 # 80029140 <cons>
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	7f0080e7          	jalr	2032(ra) # 80006526 <acquire>

  switch(c){
    80005d3e:	47d5                	li	a5,21
    80005d40:	0af48563          	beq	s1,a5,80005dea <consoleintr+0xc8>
    80005d44:	0297c963          	blt	a5,s1,80005d76 <consoleintr+0x54>
    80005d48:	47a1                	li	a5,8
    80005d4a:	0ef48c63          	beq	s1,a5,80005e42 <consoleintr+0x120>
    80005d4e:	47c1                	li	a5,16
    80005d50:	10f49f63          	bne	s1,a5,80005e6e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005d54:	ffffc097          	auipc	ra,0xffffc
    80005d58:	f46080e7          	jalr	-186(ra) # 80001c9a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d5c:	00023517          	auipc	a0,0x23
    80005d60:	3e450513          	addi	a0,a0,996 # 80029140 <cons>
    80005d64:	00001097          	auipc	ra,0x1
    80005d68:	876080e7          	jalr	-1930(ra) # 800065da <release>
}
    80005d6c:	60e2                	ld	ra,24(sp)
    80005d6e:	6442                	ld	s0,16(sp)
    80005d70:	64a2                	ld	s1,8(sp)
    80005d72:	6105                	addi	sp,sp,32
    80005d74:	8082                	ret
  switch(c){
    80005d76:	07f00793          	li	a5,127
    80005d7a:	0cf48463          	beq	s1,a5,80005e42 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d7e:	00023717          	auipc	a4,0x23
    80005d82:	3c270713          	addi	a4,a4,962 # 80029140 <cons>
    80005d86:	0a072783          	lw	a5,160(a4)
    80005d8a:	09872703          	lw	a4,152(a4)
    80005d8e:	9f99                	subw	a5,a5,a4
    80005d90:	07f00713          	li	a4,127
    80005d94:	fcf764e3          	bltu	a4,a5,80005d5c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005d98:	47b5                	li	a5,13
    80005d9a:	0cf48d63          	beq	s1,a5,80005e74 <consoleintr+0x152>
      consputc(c);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	f40080e7          	jalr	-192(ra) # 80005ce0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005da8:	00023797          	auipc	a5,0x23
    80005dac:	39878793          	addi	a5,a5,920 # 80029140 <cons>
    80005db0:	0a07a703          	lw	a4,160(a5)
    80005db4:	0017069b          	addiw	a3,a4,1
    80005db8:	0006861b          	sext.w	a2,a3
    80005dbc:	0ad7a023          	sw	a3,160(a5)
    80005dc0:	07f77713          	andi	a4,a4,127
    80005dc4:	97ba                	add	a5,a5,a4
    80005dc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005dca:	47a9                	li	a5,10
    80005dcc:	0cf48b63          	beq	s1,a5,80005ea2 <consoleintr+0x180>
    80005dd0:	4791                	li	a5,4
    80005dd2:	0cf48863          	beq	s1,a5,80005ea2 <consoleintr+0x180>
    80005dd6:	00023797          	auipc	a5,0x23
    80005dda:	4027a783          	lw	a5,1026(a5) # 800291d8 <cons+0x98>
    80005dde:	0807879b          	addiw	a5,a5,128
    80005de2:	f6f61de3          	bne	a2,a5,80005d5c <consoleintr+0x3a>
    80005de6:	863e                	mv	a2,a5
    80005de8:	a86d                	j	80005ea2 <consoleintr+0x180>
    80005dea:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005dec:	00023717          	auipc	a4,0x23
    80005df0:	35470713          	addi	a4,a4,852 # 80029140 <cons>
    80005df4:	0a072783          	lw	a5,160(a4)
    80005df8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005dfc:	00023497          	auipc	s1,0x23
    80005e00:	34448493          	addi	s1,s1,836 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005e04:	4929                	li	s2,10
    80005e06:	02f70a63          	beq	a4,a5,80005e3a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e0a:	37fd                	addiw	a5,a5,-1
    80005e0c:	07f7f713          	andi	a4,a5,127
    80005e10:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e12:	01874703          	lbu	a4,24(a4)
    80005e16:	03270463          	beq	a4,s2,80005e3e <consoleintr+0x11c>
      cons.e--;
    80005e1a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e1e:	10000513          	li	a0,256
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	ebe080e7          	jalr	-322(ra) # 80005ce0 <consputc>
    while(cons.e != cons.w &&
    80005e2a:	0a04a783          	lw	a5,160(s1)
    80005e2e:	09c4a703          	lw	a4,156(s1)
    80005e32:	fcf71ce3          	bne	a4,a5,80005e0a <consoleintr+0xe8>
    80005e36:	6902                	ld	s2,0(sp)
    80005e38:	b715                	j	80005d5c <consoleintr+0x3a>
    80005e3a:	6902                	ld	s2,0(sp)
    80005e3c:	b705                	j	80005d5c <consoleintr+0x3a>
    80005e3e:	6902                	ld	s2,0(sp)
    80005e40:	bf31                	j	80005d5c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005e42:	00023717          	auipc	a4,0x23
    80005e46:	2fe70713          	addi	a4,a4,766 # 80029140 <cons>
    80005e4a:	0a072783          	lw	a5,160(a4)
    80005e4e:	09c72703          	lw	a4,156(a4)
    80005e52:	f0f705e3          	beq	a4,a5,80005d5c <consoleintr+0x3a>
      cons.e--;
    80005e56:	37fd                	addiw	a5,a5,-1
    80005e58:	00023717          	auipc	a4,0x23
    80005e5c:	38f72423          	sw	a5,904(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e60:	10000513          	li	a0,256
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	e7c080e7          	jalr	-388(ra) # 80005ce0 <consputc>
    80005e6c:	bdc5                	j	80005d5c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e6e:	ee0487e3          	beqz	s1,80005d5c <consoleintr+0x3a>
    80005e72:	b731                	j	80005d7e <consoleintr+0x5c>
      consputc(c);
    80005e74:	4529                	li	a0,10
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	e6a080e7          	jalr	-406(ra) # 80005ce0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e7e:	00023797          	auipc	a5,0x23
    80005e82:	2c278793          	addi	a5,a5,706 # 80029140 <cons>
    80005e86:	0a07a703          	lw	a4,160(a5)
    80005e8a:	0017069b          	addiw	a3,a4,1
    80005e8e:	0006861b          	sext.w	a2,a3
    80005e92:	0ad7a023          	sw	a3,160(a5)
    80005e96:	07f77713          	andi	a4,a4,127
    80005e9a:	97ba                	add	a5,a5,a4
    80005e9c:	4729                	li	a4,10
    80005e9e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ea2:	00023797          	auipc	a5,0x23
    80005ea6:	32c7ad23          	sw	a2,826(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005eaa:	00023517          	auipc	a0,0x23
    80005eae:	32e50513          	addi	a0,a0,814 # 800291d8 <cons+0x98>
    80005eb2:	ffffc097          	auipc	ra,0xffffc
    80005eb6:	b24080e7          	jalr	-1244(ra) # 800019d6 <wakeup>
    80005eba:	b54d                	j	80005d5c <consoleintr+0x3a>

0000000080005ebc <consoleinit>:

void
consoleinit(void)
{
    80005ebc:	1141                	addi	sp,sp,-16
    80005ebe:	e406                	sd	ra,8(sp)
    80005ec0:	e022                	sd	s0,0(sp)
    80005ec2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ec4:	00003597          	auipc	a1,0x3
    80005ec8:	82458593          	addi	a1,a1,-2012 # 800086e8 <etext+0x6e8>
    80005ecc:	00023517          	auipc	a0,0x23
    80005ed0:	27450513          	addi	a0,a0,628 # 80029140 <cons>
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	5c2080e7          	jalr	1474(ra) # 80006496 <initlock>

  uartinit();
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	354080e7          	jalr	852(ra) # 80006230 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ee4:	00016797          	auipc	a5,0x16
    80005ee8:	1fc78793          	addi	a5,a5,508 # 8001c0e0 <devsw>
    80005eec:	00000717          	auipc	a4,0x0
    80005ef0:	cd470713          	addi	a4,a4,-812 # 80005bc0 <consoleread>
    80005ef4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ef6:	00000717          	auipc	a4,0x0
    80005efa:	c5c70713          	addi	a4,a4,-932 # 80005b52 <consolewrite>
    80005efe:	ef98                	sd	a4,24(a5)
}
    80005f00:	60a2                	ld	ra,8(sp)
    80005f02:	6402                	ld	s0,0(sp)
    80005f04:	0141                	addi	sp,sp,16
    80005f06:	8082                	ret

0000000080005f08 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f08:	7179                	addi	sp,sp,-48
    80005f0a:	f406                	sd	ra,40(sp)
    80005f0c:	f022                	sd	s0,32(sp)
    80005f0e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f10:	c219                	beqz	a2,80005f16 <printint+0xe>
    80005f12:	08054963          	bltz	a0,80005fa4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f16:	2501                	sext.w	a0,a0
    80005f18:	4881                	li	a7,0
    80005f1a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f1e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f20:	2581                	sext.w	a1,a1
    80005f22:	00003617          	auipc	a2,0x3
    80005f26:	92660613          	addi	a2,a2,-1754 # 80008848 <digits>
    80005f2a:	883a                	mv	a6,a4
    80005f2c:	2705                	addiw	a4,a4,1
    80005f2e:	02b577bb          	remuw	a5,a0,a1
    80005f32:	1782                	slli	a5,a5,0x20
    80005f34:	9381                	srli	a5,a5,0x20
    80005f36:	97b2                	add	a5,a5,a2
    80005f38:	0007c783          	lbu	a5,0(a5)
    80005f3c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f40:	0005079b          	sext.w	a5,a0
    80005f44:	02b5553b          	divuw	a0,a0,a1
    80005f48:	0685                	addi	a3,a3,1
    80005f4a:	feb7f0e3          	bgeu	a5,a1,80005f2a <printint+0x22>

  if(sign)
    80005f4e:	00088c63          	beqz	a7,80005f66 <printint+0x5e>
    buf[i++] = '-';
    80005f52:	fe070793          	addi	a5,a4,-32
    80005f56:	00878733          	add	a4,a5,s0
    80005f5a:	02d00793          	li	a5,45
    80005f5e:	fef70823          	sb	a5,-16(a4)
    80005f62:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f66:	02e05b63          	blez	a4,80005f9c <printint+0x94>
    80005f6a:	ec26                	sd	s1,24(sp)
    80005f6c:	e84a                	sd	s2,16(sp)
    80005f6e:	fd040793          	addi	a5,s0,-48
    80005f72:	00e784b3          	add	s1,a5,a4
    80005f76:	fff78913          	addi	s2,a5,-1
    80005f7a:	993a                	add	s2,s2,a4
    80005f7c:	377d                	addiw	a4,a4,-1
    80005f7e:	1702                	slli	a4,a4,0x20
    80005f80:	9301                	srli	a4,a4,0x20
    80005f82:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f86:	fff4c503          	lbu	a0,-1(s1)
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	d56080e7          	jalr	-682(ra) # 80005ce0 <consputc>
  while(--i >= 0)
    80005f92:	14fd                	addi	s1,s1,-1
    80005f94:	ff2499e3          	bne	s1,s2,80005f86 <printint+0x7e>
    80005f98:	64e2                	ld	s1,24(sp)
    80005f9a:	6942                	ld	s2,16(sp)
}
    80005f9c:	70a2                	ld	ra,40(sp)
    80005f9e:	7402                	ld	s0,32(sp)
    80005fa0:	6145                	addi	sp,sp,48
    80005fa2:	8082                	ret
    x = -xx;
    80005fa4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fa8:	4885                	li	a7,1
    x = -xx;
    80005faa:	bf85                	j	80005f1a <printint+0x12>

0000000080005fac <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	1000                	addi	s0,sp,32
    80005fb6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fb8:	00023797          	auipc	a5,0x23
    80005fbc:	2407a423          	sw	zero,584(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005fc0:	00002517          	auipc	a0,0x2
    80005fc4:	73050513          	addi	a0,a0,1840 # 800086f0 <etext+0x6f0>
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	02e080e7          	jalr	46(ra) # 80005ff6 <printf>
  printf(s);
    80005fd0:	8526                	mv	a0,s1
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	024080e7          	jalr	36(ra) # 80005ff6 <printf>
  printf("\n");
    80005fda:	00002517          	auipc	a0,0x2
    80005fde:	04e50513          	addi	a0,a0,78 # 80008028 <etext+0x28>
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	014080e7          	jalr	20(ra) # 80005ff6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005fea:	4785                	li	a5,1
    80005fec:	00006717          	auipc	a4,0x6
    80005ff0:	02f72823          	sw	a5,48(a4) # 8000c01c <panicked>
  for(;;)
    80005ff4:	a001                	j	80005ff4 <panic+0x48>

0000000080005ff6 <printf>:
{
    80005ff6:	7131                	addi	sp,sp,-192
    80005ff8:	fc86                	sd	ra,120(sp)
    80005ffa:	f8a2                	sd	s0,112(sp)
    80005ffc:	e8d2                	sd	s4,80(sp)
    80005ffe:	f06a                	sd	s10,32(sp)
    80006000:	0100                	addi	s0,sp,128
    80006002:	8a2a                	mv	s4,a0
    80006004:	e40c                	sd	a1,8(s0)
    80006006:	e810                	sd	a2,16(s0)
    80006008:	ec14                	sd	a3,24(s0)
    8000600a:	f018                	sd	a4,32(s0)
    8000600c:	f41c                	sd	a5,40(s0)
    8000600e:	03043823          	sd	a6,48(s0)
    80006012:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006016:	00023d17          	auipc	s10,0x23
    8000601a:	1ead2d03          	lw	s10,490(s10) # 80029200 <pr+0x18>
  if(locking)
    8000601e:	040d1463          	bnez	s10,80006066 <printf+0x70>
  if (fmt == 0)
    80006022:	040a0b63          	beqz	s4,80006078 <printf+0x82>
  va_start(ap, fmt);
    80006026:	00840793          	addi	a5,s0,8
    8000602a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000602e:	000a4503          	lbu	a0,0(s4)
    80006032:	18050b63          	beqz	a0,800061c8 <printf+0x1d2>
    80006036:	f4a6                	sd	s1,104(sp)
    80006038:	f0ca                	sd	s2,96(sp)
    8000603a:	ecce                	sd	s3,88(sp)
    8000603c:	e4d6                	sd	s5,72(sp)
    8000603e:	e0da                	sd	s6,64(sp)
    80006040:	fc5e                	sd	s7,56(sp)
    80006042:	f862                	sd	s8,48(sp)
    80006044:	f466                	sd	s9,40(sp)
    80006046:	ec6e                	sd	s11,24(sp)
    80006048:	4981                	li	s3,0
    if(c != '%'){
    8000604a:	02500b13          	li	s6,37
    switch(c){
    8000604e:	07000b93          	li	s7,112
  consputc('x');
    80006052:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006054:	00002a97          	auipc	s5,0x2
    80006058:	7f4a8a93          	addi	s5,s5,2036 # 80008848 <digits>
    switch(c){
    8000605c:	07300c13          	li	s8,115
    80006060:	06400d93          	li	s11,100
    80006064:	a0b1                	j	800060b0 <printf+0xba>
    acquire(&pr.lock);
    80006066:	00023517          	auipc	a0,0x23
    8000606a:	18250513          	addi	a0,a0,386 # 800291e8 <pr>
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	4b8080e7          	jalr	1208(ra) # 80006526 <acquire>
    80006076:	b775                	j	80006022 <printf+0x2c>
    80006078:	f4a6                	sd	s1,104(sp)
    8000607a:	f0ca                	sd	s2,96(sp)
    8000607c:	ecce                	sd	s3,88(sp)
    8000607e:	e4d6                	sd	s5,72(sp)
    80006080:	e0da                	sd	s6,64(sp)
    80006082:	fc5e                	sd	s7,56(sp)
    80006084:	f862                	sd	s8,48(sp)
    80006086:	f466                	sd	s9,40(sp)
    80006088:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000608a:	00002517          	auipc	a0,0x2
    8000608e:	67650513          	addi	a0,a0,1654 # 80008700 <etext+0x700>
    80006092:	00000097          	auipc	ra,0x0
    80006096:	f1a080e7          	jalr	-230(ra) # 80005fac <panic>
      consputc(c);
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	c46080e7          	jalr	-954(ra) # 80005ce0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060a2:	2985                	addiw	s3,s3,1
    800060a4:	013a07b3          	add	a5,s4,s3
    800060a8:	0007c503          	lbu	a0,0(a5)
    800060ac:	10050563          	beqz	a0,800061b6 <printf+0x1c0>
    if(c != '%'){
    800060b0:	ff6515e3          	bne	a0,s6,8000609a <printf+0xa4>
    c = fmt[++i] & 0xff;
    800060b4:	2985                	addiw	s3,s3,1
    800060b6:	013a07b3          	add	a5,s4,s3
    800060ba:	0007c783          	lbu	a5,0(a5)
    800060be:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800060c2:	10078b63          	beqz	a5,800061d8 <printf+0x1e2>
    switch(c){
    800060c6:	05778a63          	beq	a5,s7,8000611a <printf+0x124>
    800060ca:	02fbf663          	bgeu	s7,a5,800060f6 <printf+0x100>
    800060ce:	09878863          	beq	a5,s8,8000615e <printf+0x168>
    800060d2:	07800713          	li	a4,120
    800060d6:	0ce79563          	bne	a5,a4,800061a0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800060da:	f8843783          	ld	a5,-120(s0)
    800060de:	00878713          	addi	a4,a5,8
    800060e2:	f8e43423          	sd	a4,-120(s0)
    800060e6:	4605                	li	a2,1
    800060e8:	85e6                	mv	a1,s9
    800060ea:	4388                	lw	a0,0(a5)
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	e1c080e7          	jalr	-484(ra) # 80005f08 <printint>
      break;
    800060f4:	b77d                	j	800060a2 <printf+0xac>
    switch(c){
    800060f6:	09678f63          	beq	a5,s6,80006194 <printf+0x19e>
    800060fa:	0bb79363          	bne	a5,s11,800061a0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800060fe:	f8843783          	ld	a5,-120(s0)
    80006102:	00878713          	addi	a4,a5,8
    80006106:	f8e43423          	sd	a4,-120(s0)
    8000610a:	4605                	li	a2,1
    8000610c:	45a9                	li	a1,10
    8000610e:	4388                	lw	a0,0(a5)
    80006110:	00000097          	auipc	ra,0x0
    80006114:	df8080e7          	jalr	-520(ra) # 80005f08 <printint>
      break;
    80006118:	b769                	j	800060a2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000611a:	f8843783          	ld	a5,-120(s0)
    8000611e:	00878713          	addi	a4,a5,8
    80006122:	f8e43423          	sd	a4,-120(s0)
    80006126:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000612a:	03000513          	li	a0,48
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	bb2080e7          	jalr	-1102(ra) # 80005ce0 <consputc>
  consputc('x');
    80006136:	07800513          	li	a0,120
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	ba6080e7          	jalr	-1114(ra) # 80005ce0 <consputc>
    80006142:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006144:	03c95793          	srli	a5,s2,0x3c
    80006148:	97d6                	add	a5,a5,s5
    8000614a:	0007c503          	lbu	a0,0(a5)
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	b92080e7          	jalr	-1134(ra) # 80005ce0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006156:	0912                	slli	s2,s2,0x4
    80006158:	34fd                	addiw	s1,s1,-1
    8000615a:	f4ed                	bnez	s1,80006144 <printf+0x14e>
    8000615c:	b799                	j	800060a2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000615e:	f8843783          	ld	a5,-120(s0)
    80006162:	00878713          	addi	a4,a5,8
    80006166:	f8e43423          	sd	a4,-120(s0)
    8000616a:	6384                	ld	s1,0(a5)
    8000616c:	cc89                	beqz	s1,80006186 <printf+0x190>
      for(; *s; s++)
    8000616e:	0004c503          	lbu	a0,0(s1)
    80006172:	d905                	beqz	a0,800060a2 <printf+0xac>
        consputc(*s);
    80006174:	00000097          	auipc	ra,0x0
    80006178:	b6c080e7          	jalr	-1172(ra) # 80005ce0 <consputc>
      for(; *s; s++)
    8000617c:	0485                	addi	s1,s1,1
    8000617e:	0004c503          	lbu	a0,0(s1)
    80006182:	f96d                	bnez	a0,80006174 <printf+0x17e>
    80006184:	bf39                	j	800060a2 <printf+0xac>
        s = "(null)";
    80006186:	00002497          	auipc	s1,0x2
    8000618a:	57248493          	addi	s1,s1,1394 # 800086f8 <etext+0x6f8>
      for(; *s; s++)
    8000618e:	02800513          	li	a0,40
    80006192:	b7cd                	j	80006174 <printf+0x17e>
      consputc('%');
    80006194:	855a                	mv	a0,s6
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	b4a080e7          	jalr	-1206(ra) # 80005ce0 <consputc>
      break;
    8000619e:	b711                	j	800060a2 <printf+0xac>
      consputc('%');
    800061a0:	855a                	mv	a0,s6
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	b3e080e7          	jalr	-1218(ra) # 80005ce0 <consputc>
      consputc(c);
    800061aa:	8526                	mv	a0,s1
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	b34080e7          	jalr	-1228(ra) # 80005ce0 <consputc>
      break;
    800061b4:	b5fd                	j	800060a2 <printf+0xac>
    800061b6:	74a6                	ld	s1,104(sp)
    800061b8:	7906                	ld	s2,96(sp)
    800061ba:	69e6                	ld	s3,88(sp)
    800061bc:	6aa6                	ld	s5,72(sp)
    800061be:	6b06                	ld	s6,64(sp)
    800061c0:	7be2                	ld	s7,56(sp)
    800061c2:	7c42                	ld	s8,48(sp)
    800061c4:	7ca2                	ld	s9,40(sp)
    800061c6:	6de2                	ld	s11,24(sp)
  if(locking)
    800061c8:	020d1263          	bnez	s10,800061ec <printf+0x1f6>
}
    800061cc:	70e6                	ld	ra,120(sp)
    800061ce:	7446                	ld	s0,112(sp)
    800061d0:	6a46                	ld	s4,80(sp)
    800061d2:	7d02                	ld	s10,32(sp)
    800061d4:	6129                	addi	sp,sp,192
    800061d6:	8082                	ret
    800061d8:	74a6                	ld	s1,104(sp)
    800061da:	7906                	ld	s2,96(sp)
    800061dc:	69e6                	ld	s3,88(sp)
    800061de:	6aa6                	ld	s5,72(sp)
    800061e0:	6b06                	ld	s6,64(sp)
    800061e2:	7be2                	ld	s7,56(sp)
    800061e4:	7c42                	ld	s8,48(sp)
    800061e6:	7ca2                	ld	s9,40(sp)
    800061e8:	6de2                	ld	s11,24(sp)
    800061ea:	bff9                	j	800061c8 <printf+0x1d2>
    release(&pr.lock);
    800061ec:	00023517          	auipc	a0,0x23
    800061f0:	ffc50513          	addi	a0,a0,-4 # 800291e8 <pr>
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	3e6080e7          	jalr	998(ra) # 800065da <release>
}
    800061fc:	bfc1                	j	800061cc <printf+0x1d6>

00000000800061fe <printfinit>:
    ;
}

void
printfinit(void)
{
    800061fe:	1101                	addi	sp,sp,-32
    80006200:	ec06                	sd	ra,24(sp)
    80006202:	e822                	sd	s0,16(sp)
    80006204:	e426                	sd	s1,8(sp)
    80006206:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006208:	00023497          	auipc	s1,0x23
    8000620c:	fe048493          	addi	s1,s1,-32 # 800291e8 <pr>
    80006210:	00002597          	auipc	a1,0x2
    80006214:	50058593          	addi	a1,a1,1280 # 80008710 <etext+0x710>
    80006218:	8526                	mv	a0,s1
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	27c080e7          	jalr	636(ra) # 80006496 <initlock>
  pr.locking = 1;
    80006222:	4785                	li	a5,1
    80006224:	cc9c                	sw	a5,24(s1)
}
    80006226:	60e2                	ld	ra,24(sp)
    80006228:	6442                	ld	s0,16(sp)
    8000622a:	64a2                	ld	s1,8(sp)
    8000622c:	6105                	addi	sp,sp,32
    8000622e:	8082                	ret

0000000080006230 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006230:	1141                	addi	sp,sp,-16
    80006232:	e406                	sd	ra,8(sp)
    80006234:	e022                	sd	s0,0(sp)
    80006236:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006238:	100007b7          	lui	a5,0x10000
    8000623c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006240:	10000737          	lui	a4,0x10000
    80006244:	f8000693          	li	a3,-128
    80006248:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000624c:	468d                	li	a3,3
    8000624e:	10000637          	lui	a2,0x10000
    80006252:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006256:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000625a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000625e:	10000737          	lui	a4,0x10000
    80006262:	461d                	li	a2,7
    80006264:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006268:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000626c:	00002597          	auipc	a1,0x2
    80006270:	4ac58593          	addi	a1,a1,1196 # 80008718 <etext+0x718>
    80006274:	00023517          	auipc	a0,0x23
    80006278:	f9450513          	addi	a0,a0,-108 # 80029208 <uart_tx_lock>
    8000627c:	00000097          	auipc	ra,0x0
    80006280:	21a080e7          	jalr	538(ra) # 80006496 <initlock>
}
    80006284:	60a2                	ld	ra,8(sp)
    80006286:	6402                	ld	s0,0(sp)
    80006288:	0141                	addi	sp,sp,16
    8000628a:	8082                	ret

000000008000628c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000628c:	1101                	addi	sp,sp,-32
    8000628e:	ec06                	sd	ra,24(sp)
    80006290:	e822                	sd	s0,16(sp)
    80006292:	e426                	sd	s1,8(sp)
    80006294:	1000                	addi	s0,sp,32
    80006296:	84aa                	mv	s1,a0
  push_off();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	242080e7          	jalr	578(ra) # 800064da <push_off>

  if(panicked){
    800062a0:	00006797          	auipc	a5,0x6
    800062a4:	d7c7a783          	lw	a5,-644(a5) # 8000c01c <panicked>
    800062a8:	eb85                	bnez	a5,800062d8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062aa:	10000737          	lui	a4,0x10000
    800062ae:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800062b0:	00074783          	lbu	a5,0(a4)
    800062b4:	0207f793          	andi	a5,a5,32
    800062b8:	dfe5                	beqz	a5,800062b0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062ba:	0ff4f513          	zext.b	a0,s1
    800062be:	100007b7          	lui	a5,0x10000
    800062c2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	2b4080e7          	jalr	692(ra) # 8000657a <pop_off>
}
    800062ce:	60e2                	ld	ra,24(sp)
    800062d0:	6442                	ld	s0,16(sp)
    800062d2:	64a2                	ld	s1,8(sp)
    800062d4:	6105                	addi	sp,sp,32
    800062d6:	8082                	ret
    for(;;)
    800062d8:	a001                	j	800062d8 <uartputc_sync+0x4c>

00000000800062da <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062da:	00006797          	auipc	a5,0x6
    800062de:	d467b783          	ld	a5,-698(a5) # 8000c020 <uart_tx_r>
    800062e2:	00006717          	auipc	a4,0x6
    800062e6:	d4673703          	ld	a4,-698(a4) # 8000c028 <uart_tx_w>
    800062ea:	06f70f63          	beq	a4,a5,80006368 <uartstart+0x8e>
{
    800062ee:	7139                	addi	sp,sp,-64
    800062f0:	fc06                	sd	ra,56(sp)
    800062f2:	f822                	sd	s0,48(sp)
    800062f4:	f426                	sd	s1,40(sp)
    800062f6:	f04a                	sd	s2,32(sp)
    800062f8:	ec4e                	sd	s3,24(sp)
    800062fa:	e852                	sd	s4,16(sp)
    800062fc:	e456                	sd	s5,8(sp)
    800062fe:	e05a                	sd	s6,0(sp)
    80006300:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006302:	10000937          	lui	s2,0x10000
    80006306:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006308:	00023a97          	auipc	s5,0x23
    8000630c:	f00a8a93          	addi	s5,s5,-256 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    80006310:	00006497          	auipc	s1,0x6
    80006314:	d1048493          	addi	s1,s1,-752 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006318:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000631c:	00006997          	auipc	s3,0x6
    80006320:	d0c98993          	addi	s3,s3,-756 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006324:	00094703          	lbu	a4,0(s2)
    80006328:	02077713          	andi	a4,a4,32
    8000632c:	c705                	beqz	a4,80006354 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000632e:	01f7f713          	andi	a4,a5,31
    80006332:	9756                	add	a4,a4,s5
    80006334:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006338:	0785                	addi	a5,a5,1
    8000633a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000633c:	8526                	mv	a0,s1
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	698080e7          	jalr	1688(ra) # 800019d6 <wakeup>
    WriteReg(THR, c);
    80006346:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000634a:	609c                	ld	a5,0(s1)
    8000634c:	0009b703          	ld	a4,0(s3)
    80006350:	fcf71ae3          	bne	a4,a5,80006324 <uartstart+0x4a>
  }
}
    80006354:	70e2                	ld	ra,56(sp)
    80006356:	7442                	ld	s0,48(sp)
    80006358:	74a2                	ld	s1,40(sp)
    8000635a:	7902                	ld	s2,32(sp)
    8000635c:	69e2                	ld	s3,24(sp)
    8000635e:	6a42                	ld	s4,16(sp)
    80006360:	6aa2                	ld	s5,8(sp)
    80006362:	6b02                	ld	s6,0(sp)
    80006364:	6121                	addi	sp,sp,64
    80006366:	8082                	ret
    80006368:	8082                	ret

000000008000636a <uartputc>:
{
    8000636a:	7179                	addi	sp,sp,-48
    8000636c:	f406                	sd	ra,40(sp)
    8000636e:	f022                	sd	s0,32(sp)
    80006370:	e052                	sd	s4,0(sp)
    80006372:	1800                	addi	s0,sp,48
    80006374:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006376:	00023517          	auipc	a0,0x23
    8000637a:	e9250513          	addi	a0,a0,-366 # 80029208 <uart_tx_lock>
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	1a8080e7          	jalr	424(ra) # 80006526 <acquire>
  if(panicked){
    80006386:	00006797          	auipc	a5,0x6
    8000638a:	c967a783          	lw	a5,-874(a5) # 8000c01c <panicked>
    8000638e:	c391                	beqz	a5,80006392 <uartputc+0x28>
    for(;;)
    80006390:	a001                	j	80006390 <uartputc+0x26>
    80006392:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006394:	00006717          	auipc	a4,0x6
    80006398:	c9473703          	ld	a4,-876(a4) # 8000c028 <uart_tx_w>
    8000639c:	00006797          	auipc	a5,0x6
    800063a0:	c847b783          	ld	a5,-892(a5) # 8000c020 <uart_tx_r>
    800063a4:	02078793          	addi	a5,a5,32
    800063a8:	02e79f63          	bne	a5,a4,800063e6 <uartputc+0x7c>
    800063ac:	e84a                	sd	s2,16(sp)
    800063ae:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800063b0:	00023997          	auipc	s3,0x23
    800063b4:	e5898993          	addi	s3,s3,-424 # 80029208 <uart_tx_lock>
    800063b8:	00006497          	auipc	s1,0x6
    800063bc:	c6848493          	addi	s1,s1,-920 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063c0:	00006917          	auipc	s2,0x6
    800063c4:	c6890913          	addi	s2,s2,-920 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063c8:	85ce                	mv	a1,s3
    800063ca:	8526                	mv	a0,s1
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	47e080e7          	jalr	1150(ra) # 8000184a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d4:	00093703          	ld	a4,0(s2)
    800063d8:	609c                	ld	a5,0(s1)
    800063da:	02078793          	addi	a5,a5,32
    800063de:	fee785e3          	beq	a5,a4,800063c8 <uartputc+0x5e>
    800063e2:	6942                	ld	s2,16(sp)
    800063e4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063e6:	00023497          	auipc	s1,0x23
    800063ea:	e2248493          	addi	s1,s1,-478 # 80029208 <uart_tx_lock>
    800063ee:	01f77793          	andi	a5,a4,31
    800063f2:	97a6                	add	a5,a5,s1
    800063f4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800063f8:	0705                	addi	a4,a4,1
    800063fa:	00006797          	auipc	a5,0x6
    800063fe:	c2e7b723          	sd	a4,-978(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006402:	00000097          	auipc	ra,0x0
    80006406:	ed8080e7          	jalr	-296(ra) # 800062da <uartstart>
      release(&uart_tx_lock);
    8000640a:	8526                	mv	a0,s1
    8000640c:	00000097          	auipc	ra,0x0
    80006410:	1ce080e7          	jalr	462(ra) # 800065da <release>
    80006414:	64e2                	ld	s1,24(sp)
}
    80006416:	70a2                	ld	ra,40(sp)
    80006418:	7402                	ld	s0,32(sp)
    8000641a:	6a02                	ld	s4,0(sp)
    8000641c:	6145                	addi	sp,sp,48
    8000641e:	8082                	ret

0000000080006420 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006420:	1141                	addi	sp,sp,-16
    80006422:	e422                	sd	s0,8(sp)
    80006424:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006426:	100007b7          	lui	a5,0x10000
    8000642a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000642c:	0007c783          	lbu	a5,0(a5)
    80006430:	8b85                	andi	a5,a5,1
    80006432:	cb81                	beqz	a5,80006442 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006434:	100007b7          	lui	a5,0x10000
    80006438:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000643c:	6422                	ld	s0,8(sp)
    8000643e:	0141                	addi	sp,sp,16
    80006440:	8082                	ret
    return -1;
    80006442:	557d                	li	a0,-1
    80006444:	bfe5                	j	8000643c <uartgetc+0x1c>

0000000080006446 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006446:	1101                	addi	sp,sp,-32
    80006448:	ec06                	sd	ra,24(sp)
    8000644a:	e822                	sd	s0,16(sp)
    8000644c:	e426                	sd	s1,8(sp)
    8000644e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006450:	54fd                	li	s1,-1
    80006452:	a029                	j	8000645c <uartintr+0x16>
      break;
    consoleintr(c);
    80006454:	00000097          	auipc	ra,0x0
    80006458:	8ce080e7          	jalr	-1842(ra) # 80005d22 <consoleintr>
    int c = uartgetc();
    8000645c:	00000097          	auipc	ra,0x0
    80006460:	fc4080e7          	jalr	-60(ra) # 80006420 <uartgetc>
    if(c == -1)
    80006464:	fe9518e3          	bne	a0,s1,80006454 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006468:	00023497          	auipc	s1,0x23
    8000646c:	da048493          	addi	s1,s1,-608 # 80029208 <uart_tx_lock>
    80006470:	8526                	mv	a0,s1
    80006472:	00000097          	auipc	ra,0x0
    80006476:	0b4080e7          	jalr	180(ra) # 80006526 <acquire>
  uartstart();
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	e60080e7          	jalr	-416(ra) # 800062da <uartstart>
  release(&uart_tx_lock);
    80006482:	8526                	mv	a0,s1
    80006484:	00000097          	auipc	ra,0x0
    80006488:	156080e7          	jalr	342(ra) # 800065da <release>
}
    8000648c:	60e2                	ld	ra,24(sp)
    8000648e:	6442                	ld	s0,16(sp)
    80006490:	64a2                	ld	s1,8(sp)
    80006492:	6105                	addi	sp,sp,32
    80006494:	8082                	ret

0000000080006496 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006496:	1141                	addi	sp,sp,-16
    80006498:	e422                	sd	s0,8(sp)
    8000649a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000649c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000649e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064a2:	00053823          	sd	zero,16(a0)
}
    800064a6:	6422                	ld	s0,8(sp)
    800064a8:	0141                	addi	sp,sp,16
    800064aa:	8082                	ret

00000000800064ac <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064ac:	411c                	lw	a5,0(a0)
    800064ae:	e399                	bnez	a5,800064b4 <holding+0x8>
    800064b0:	4501                	li	a0,0
  return r;
}
    800064b2:	8082                	ret
{
    800064b4:	1101                	addi	sp,sp,-32
    800064b6:	ec06                	sd	ra,24(sp)
    800064b8:	e822                	sd	s0,16(sp)
    800064ba:	e426                	sd	s1,8(sp)
    800064bc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064be:	6904                	ld	s1,16(a0)
    800064c0:	ffffb097          	auipc	ra,0xffffb
    800064c4:	ca8080e7          	jalr	-856(ra) # 80001168 <mycpu>
    800064c8:	40a48533          	sub	a0,s1,a0
    800064cc:	00153513          	seqz	a0,a0
}
    800064d0:	60e2                	ld	ra,24(sp)
    800064d2:	6442                	ld	s0,16(sp)
    800064d4:	64a2                	ld	s1,8(sp)
    800064d6:	6105                	addi	sp,sp,32
    800064d8:	8082                	ret

00000000800064da <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064da:	1101                	addi	sp,sp,-32
    800064dc:	ec06                	sd	ra,24(sp)
    800064de:	e822                	sd	s0,16(sp)
    800064e0:	e426                	sd	s1,8(sp)
    800064e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064e4:	100024f3          	csrr	s1,sstatus
    800064e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064ee:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064f2:	ffffb097          	auipc	ra,0xffffb
    800064f6:	c76080e7          	jalr	-906(ra) # 80001168 <mycpu>
    800064fa:	5d3c                	lw	a5,120(a0)
    800064fc:	cf89                	beqz	a5,80006516 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064fe:	ffffb097          	auipc	ra,0xffffb
    80006502:	c6a080e7          	jalr	-918(ra) # 80001168 <mycpu>
    80006506:	5d3c                	lw	a5,120(a0)
    80006508:	2785                	addiw	a5,a5,1
    8000650a:	dd3c                	sw	a5,120(a0)
}
    8000650c:	60e2                	ld	ra,24(sp)
    8000650e:	6442                	ld	s0,16(sp)
    80006510:	64a2                	ld	s1,8(sp)
    80006512:	6105                	addi	sp,sp,32
    80006514:	8082                	ret
    mycpu()->intena = old;
    80006516:	ffffb097          	auipc	ra,0xffffb
    8000651a:	c52080e7          	jalr	-942(ra) # 80001168 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000651e:	8085                	srli	s1,s1,0x1
    80006520:	8885                	andi	s1,s1,1
    80006522:	dd64                	sw	s1,124(a0)
    80006524:	bfe9                	j	800064fe <push_off+0x24>

0000000080006526 <acquire>:
{
    80006526:	1101                	addi	sp,sp,-32
    80006528:	ec06                	sd	ra,24(sp)
    8000652a:	e822                	sd	s0,16(sp)
    8000652c:	e426                	sd	s1,8(sp)
    8000652e:	1000                	addi	s0,sp,32
    80006530:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006532:	00000097          	auipc	ra,0x0
    80006536:	fa8080e7          	jalr	-88(ra) # 800064da <push_off>
  if(holding(lk))
    8000653a:	8526                	mv	a0,s1
    8000653c:	00000097          	auipc	ra,0x0
    80006540:	f70080e7          	jalr	-144(ra) # 800064ac <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006544:	4705                	li	a4,1
  if(holding(lk))
    80006546:	e115                	bnez	a0,8000656a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006548:	87ba                	mv	a5,a4
    8000654a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000654e:	2781                	sext.w	a5,a5
    80006550:	ffe5                	bnez	a5,80006548 <acquire+0x22>
  __sync_synchronize();
    80006552:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006556:	ffffb097          	auipc	ra,0xffffb
    8000655a:	c12080e7          	jalr	-1006(ra) # 80001168 <mycpu>
    8000655e:	e888                	sd	a0,16(s1)
}
    80006560:	60e2                	ld	ra,24(sp)
    80006562:	6442                	ld	s0,16(sp)
    80006564:	64a2                	ld	s1,8(sp)
    80006566:	6105                	addi	sp,sp,32
    80006568:	8082                	ret
    panic("acquire");
    8000656a:	00002517          	auipc	a0,0x2
    8000656e:	1b650513          	addi	a0,a0,438 # 80008720 <etext+0x720>
    80006572:	00000097          	auipc	ra,0x0
    80006576:	a3a080e7          	jalr	-1478(ra) # 80005fac <panic>

000000008000657a <pop_off>:

void
pop_off(void)
{
    8000657a:	1141                	addi	sp,sp,-16
    8000657c:	e406                	sd	ra,8(sp)
    8000657e:	e022                	sd	s0,0(sp)
    80006580:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006582:	ffffb097          	auipc	ra,0xffffb
    80006586:	be6080e7          	jalr	-1050(ra) # 80001168 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000658a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000658e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006590:	e78d                	bnez	a5,800065ba <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006592:	5d3c                	lw	a5,120(a0)
    80006594:	02f05b63          	blez	a5,800065ca <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006598:	37fd                	addiw	a5,a5,-1
    8000659a:	0007871b          	sext.w	a4,a5
    8000659e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065a0:	eb09                	bnez	a4,800065b2 <pop_off+0x38>
    800065a2:	5d7c                	lw	a5,124(a0)
    800065a4:	c799                	beqz	a5,800065b2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065ae:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065b2:	60a2                	ld	ra,8(sp)
    800065b4:	6402                	ld	s0,0(sp)
    800065b6:	0141                	addi	sp,sp,16
    800065b8:	8082                	ret
    panic("pop_off - interruptible");
    800065ba:	00002517          	auipc	a0,0x2
    800065be:	16e50513          	addi	a0,a0,366 # 80008728 <etext+0x728>
    800065c2:	00000097          	auipc	ra,0x0
    800065c6:	9ea080e7          	jalr	-1558(ra) # 80005fac <panic>
    panic("pop_off");
    800065ca:	00002517          	auipc	a0,0x2
    800065ce:	17650513          	addi	a0,a0,374 # 80008740 <etext+0x740>
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	9da080e7          	jalr	-1574(ra) # 80005fac <panic>

00000000800065da <release>:
{
    800065da:	1101                	addi	sp,sp,-32
    800065dc:	ec06                	sd	ra,24(sp)
    800065de:	e822                	sd	s0,16(sp)
    800065e0:	e426                	sd	s1,8(sp)
    800065e2:	1000                	addi	s0,sp,32
    800065e4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065e6:	00000097          	auipc	ra,0x0
    800065ea:	ec6080e7          	jalr	-314(ra) # 800064ac <holding>
    800065ee:	c115                	beqz	a0,80006612 <release+0x38>
  lk->cpu = 0;
    800065f0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065f4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800065f8:	0310000f          	fence	rw,w
    800065fc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006600:	00000097          	auipc	ra,0x0
    80006604:	f7a080e7          	jalr	-134(ra) # 8000657a <pop_off>
}
    80006608:	60e2                	ld	ra,24(sp)
    8000660a:	6442                	ld	s0,16(sp)
    8000660c:	64a2                	ld	s1,8(sp)
    8000660e:	6105                	addi	sp,sp,32
    80006610:	8082                	ret
    panic("release");
    80006612:	00002517          	auipc	a0,0x2
    80006616:	13650513          	addi	a0,a0,310 # 80008748 <etext+0x748>
    8000661a:	00000097          	auipc	ra,0x0
    8000661e:	992080e7          	jalr	-1646(ra) # 80005fac <panic>
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
