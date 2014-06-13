
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 bf 33 10 80       	mov    $0x801033bf,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 4c 8b 10 	movl   $0x80108b4c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 58 4f 00 00       	call   80104fa6 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 05 4f 00 00       	call   80104fc7 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 20 4f 00 00       	call   80105029 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 a4 47 00 00       	call   801048c8 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 eb 10 80       	mov    0x8010ebb0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 a8 4e 00 00       	call   80105029 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 53 8b 10 80 	movl   $0x80108b53,(%esp)
8010019f:	e8 92 03 00 00       	call   80100536 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 ad 25 00 00       	call   80102785 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 64 8b 10 80 	movl   $0x80108b64,(%esp)
801001f6:	e8 3b 03 00 00       	call   80100536 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 70 25 00 00       	call   80102785 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 6b 8b 10 80 	movl   $0x80108b6b,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 86 4d 00 00       	call   80104fc7 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 ff 46 00 00       	call   801049a1 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 7b 4d 00 00       	call   80105029 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	8b 55 e8             	mov    -0x18(%ebp),%edx
801002c1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801002c9:	ec                   	in     (%dx),%al
801002ca:	88 c3                	mov    %al,%bl
801002cc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002cf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002d2:	83 c4 14             	add    $0x14,%esp
801002d5:	5b                   	pop    %ebx
801002d6:	5d                   	pop    %ebp
801002d7:	c3                   	ret    

801002d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 08             	sub    $0x8,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801002e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002e8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002eb:	8a 45 f8             	mov    -0x8(%ebp),%al
801002ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801002f1:	ee                   	out    %al,(%dx)
}
801002f2:	c9                   	leave  
801002f3:	c3                   	ret    

801002f4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f4:	55                   	push   %ebp
801002f5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f7:	fa                   	cli    
}
801002f8:	5d                   	pop    %ebp
801002f9:	c3                   	ret    

801002fa <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fa:	55                   	push   %ebp
801002fb:	89 e5                	mov    %esp,%ebp
801002fd:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100300:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100304:	74 1c                	je     80100322 <printint+0x28>
80100306:	8b 45 08             	mov    0x8(%ebp),%eax
80100309:	c1 e8 1f             	shr    $0x1f,%eax
8010030c:	0f b6 c0             	movzbl %al,%eax
8010030f:	89 45 10             	mov    %eax,0x10(%ebp)
80100312:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100316:	74 0a                	je     80100322 <printint+0x28>
    x = -xx;
80100318:	8b 45 08             	mov    0x8(%ebp),%eax
8010031b:	f7 d8                	neg    %eax
8010031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100320:	eb 06                	jmp    80100328 <printint+0x2e>
  else
    x = xx;
80100322:	8b 45 08             	mov    0x8(%ebp),%eax
80100325:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010032f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100335:	ba 00 00 00 00       	mov    $0x0,%edx
8010033a:	f7 f1                	div    %ecx
8010033c:	89 d0                	mov    %edx,%eax
8010033e:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
80100344:	8d 4d e0             	lea    -0x20(%ebp),%ecx
80100347:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034a:	01 ca                	add    %ecx,%edx
8010034c:	88 02                	mov    %al,(%edx)
8010034e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100351:	8b 55 0c             	mov    0xc(%ebp),%edx
80100354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035a:	ba 00 00 00 00       	mov    $0x0,%edx
8010035f:	f7 75 d4             	divl   -0x2c(%ebp)
80100362:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100365:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100369:	75 c4                	jne    8010032f <printint+0x35>

  if(sign)
8010036b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036f:	74 25                	je     80100396 <printint+0x9c>
    buf[i++] = '-';
80100371:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100377:	01 d0                	add    %edx,%eax
80100379:	c6 00 2d             	movb   $0x2d,(%eax)
8010037c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 15                	jmp    80100396 <printint+0x9c>
    consputc(buf[i]);
80100381:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100387:	01 d0                	add    %edx,%eax
80100389:	8a 00                	mov    (%eax),%al
8010038b:	0f be c0             	movsbl %al,%eax
8010038e:	89 04 24             	mov    %eax,(%esp)
80100391:	e8 9d 03 00 00       	call   80100733 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100396:	ff 4d f4             	decl   -0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x87>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bc:	e8 06 4c 00 00       	call   80104fc7 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 72 8b 10 80 	movl   $0x80108b72,(%esp)
801003cf:	e8 62 01 00 00       	call   80100536 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 1a 01 00 00       	jmp    80100500 <cprintf+0x15f>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 3c 03 00 00       	call   80100733 <consputc>
      continue;
801003f7:	e9 01 01 00 00       	jmp    801004fd <cprintf+0x15c>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	ff 45 f4             	incl   -0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	8a 00                	mov    (%eax),%al
80100409:	0f be c0             	movsbl %al,%eax
8010040c:	25 ff 00 00 00       	and    $0xff,%eax
80100411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100418:	0f 84 03 01 00 00    	je     80100521 <cprintf+0x180>
      break;
    switch(c){
8010041e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100421:	83 f8 70             	cmp    $0x70,%eax
80100424:	74 4d                	je     80100473 <cprintf+0xd2>
80100426:	83 f8 70             	cmp    $0x70,%eax
80100429:	7f 13                	jg     8010043e <cprintf+0x9d>
8010042b:	83 f8 25             	cmp    $0x25,%eax
8010042e:	0f 84 a3 00 00 00    	je     801004d7 <cprintf+0x136>
80100434:	83 f8 64             	cmp    $0x64,%eax
80100437:	74 14                	je     8010044d <cprintf+0xac>
80100439:	e9 a7 00 00 00       	jmp    801004e5 <cprintf+0x144>
8010043e:	83 f8 73             	cmp    $0x73,%eax
80100441:	74 53                	je     80100496 <cprintf+0xf5>
80100443:	83 f8 78             	cmp    $0x78,%eax
80100446:	74 2b                	je     80100473 <cprintf+0xd2>
80100448:	e9 98 00 00 00       	jmp    801004e5 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100450:	8b 00                	mov    (%eax),%eax
80100452:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100456:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045d:	00 
8010045e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100465:	00 
80100466:	89 04 24             	mov    %eax,(%esp)
80100469:	e8 8c fe ff ff       	call   801002fa <printint>
      break;
8010046e:	e9 8a 00 00 00       	jmp    801004fd <cprintf+0x15c>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100476:	8b 00                	mov    (%eax),%eax
80100478:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048b:	00 
8010048c:	89 04 24             	mov    %eax,(%esp)
8010048f:	e8 66 fe ff ff       	call   801002fa <printint>
      break;
80100494:	eb 67                	jmp    801004fd <cprintf+0x15c>
    case 's':
      if((s = (char*)*argp++) == 0)
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8b 00                	mov    (%eax),%eax
8010049b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010049e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a2:	0f 94 c0             	sete   %al
801004a5:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a9:	84 c0                	test   %al,%al
801004ab:	74 1e                	je     801004cb <cprintf+0x12a>
        s = "(null)";
801004ad:	c7 45 ec 7b 8b 10 80 	movl   $0x80108b7b,-0x14(%ebp)
      for(; *s; s++)
801004b4:	eb 15                	jmp    801004cb <cprintf+0x12a>
        consputc(*s);
801004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004b9:	8a 00                	mov    (%eax),%al
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 6d 02 00 00       	call   80100733 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	ff 45 ec             	incl   -0x14(%ebp)
801004c9:	eb 01                	jmp    801004cc <cprintf+0x12b>
801004cb:	90                   	nop
801004cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004cf:	8a 00                	mov    (%eax),%al
801004d1:	84 c0                	test   %al,%al
801004d3:	75 e1                	jne    801004b6 <cprintf+0x115>
        consputc(*s);
      break;
801004d5:	eb 26                	jmp    801004fd <cprintf+0x15c>
    case '%':
      consputc('%');
801004d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004de:	e8 50 02 00 00       	call   80100733 <consputc>
      break;
801004e3:	eb 18                	jmp    801004fd <cprintf+0x15c>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 42 02 00 00       	call   80100733 <consputc>
      consputc(c);
801004f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f4:	89 04 24             	mov    %eax,(%esp)
801004f7:	e8 37 02 00 00       	call   80100733 <consputc>
      break;
801004fc:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fd:	ff 45 f4             	incl   -0xc(%ebp)
80100500:	8b 55 08             	mov    0x8(%ebp),%edx
80100503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100506:	01 d0                	add    %edx,%eax
80100508:	8a 00                	mov    (%eax),%al
8010050a:	0f be c0             	movsbl %al,%eax
8010050d:	25 ff 00 00 00       	and    $0xff,%eax
80100512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100519:	0f 85 c7 fe ff ff    	jne    801003e6 <cprintf+0x45>
8010051f:	eb 01                	jmp    80100522 <cprintf+0x181>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100521:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100526:	74 0c                	je     80100534 <cprintf+0x193>
    release(&cons.lock);
80100528:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010052f:	e8 f5 4a 00 00       	call   80105029 <release>
}
80100534:	c9                   	leave  
80100535:	c3                   	ret    

80100536 <panic>:

void
panic(char *s)
{
80100536:	55                   	push   %ebp
80100537:	89 e5                	mov    %esp,%ebp
80100539:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010053c:	e8 b3 fd ff ff       	call   801002f4 <cli>
  cons.locking = 0;
80100541:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 82 8b 10 80 	movl   $0x80108b82,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 91 8b 10 80 	movl   $0x80108b91,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 e9 4a 00 00       	call   80105078 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 93 8b 10 80 	movl   $0x80108b93,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005b8:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005bf:	00 00 00 
  for(;;)
    ;
801005c2:	eb fe                	jmp    801005c2 <panic+0x8c>

801005c4 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005c4:	55                   	push   %ebp
801005c5:	89 e5                	mov    %esp,%ebp
801005c7:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005ca:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d1:	00 
801005d2:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005d9:	e8 fa fc ff ff       	call   801002d8 <outb>
  pos = inb(CRTPORT+1) << 8;
801005de:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005e5:	e8 c6 fc ff ff       	call   801002b0 <inb>
801005ea:	0f b6 c0             	movzbl %al,%eax
801005ed:	c1 e0 08             	shl    $0x8,%eax
801005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801005fa:	00 
801005fb:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100602:	e8 d1 fc ff ff       	call   801002d8 <outb>
  pos |= inb(CRTPORT+1);
80100607:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060e:	e8 9d fc ff ff       	call   801002b0 <inb>
80100613:	0f b6 c0             	movzbl %al,%eax
80100616:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100619:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010061d:	75 1d                	jne    8010063c <cgaputc+0x78>
    pos += 80 - pos%80;
8010061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100622:	b9 50 00 00 00       	mov    $0x50,%ecx
80100627:	99                   	cltd   
80100628:	f7 f9                	idiv   %ecx
8010062a:	89 d0                	mov    %edx,%eax
8010062c:	ba 50 00 00 00       	mov    $0x50,%edx
80100631:	89 d1                	mov    %edx,%ecx
80100633:	29 c1                	sub    %eax,%ecx
80100635:	89 c8                	mov    %ecx,%eax
80100637:	01 45 f4             	add    %eax,-0xc(%ebp)
8010063a:	eb 31                	jmp    8010066d <cgaputc+0xa9>
  else if(c == BACKSPACE){
8010063c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100643:	75 0b                	jne    80100650 <cgaputc+0x8c>
    if(pos > 0) --pos;
80100645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100649:	7e 22                	jle    8010066d <cgaputc+0xa9>
8010064b:	ff 4d f4             	decl   -0xc(%ebp)
8010064e:	eb 1d                	jmp    8010066d <cgaputc+0xa9>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100650:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100658:	d1 e2                	shl    %edx
8010065a:	01 c2                	add    %eax,%edx
8010065c:	8b 45 08             	mov    0x8(%ebp),%eax
8010065f:	25 ff 00 00 00       	and    $0xff,%eax
80100664:	80 cc 07             	or     $0x7,%ah
80100667:	66 89 02             	mov    %ax,(%edx)
8010066a:	ff 45 f4             	incl   -0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010066d:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100674:	7e 53                	jle    801006c9 <cgaputc+0x105>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100676:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010067b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100681:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100686:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
8010068d:	00 
8010068e:	89 54 24 04          	mov    %edx,0x4(%esp)
80100692:	89 04 24             	mov    %eax,(%esp)
80100695:	e8 4c 4c 00 00       	call   801052e6 <memmove>
    pos -= 80;
8010069a:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010069e:	b8 80 07 00 00       	mov    $0x780,%eax
801006a3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006a6:	d1 e0                	shl    %eax
801006a8:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006b1:	d1 e1                	shl    %ecx
801006b3:	01 ca                	add    %ecx,%edx
801006b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801006b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006c0:	00 
801006c1:	89 14 24             	mov    %edx,(%esp)
801006c4:	e8 51 4b 00 00       	call   8010521a <memset>
  }
  
  outb(CRTPORT, 14);
801006c9:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006d0:	00 
801006d1:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006d8:	e8 fb fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos>>8);
801006dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006e0:	c1 f8 08             	sar    $0x8,%eax
801006e3:	0f b6 c0             	movzbl %al,%eax
801006e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801006ea:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801006f1:	e8 e2 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT, 15);
801006f6:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801006fd:	00 
801006fe:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100705:	e8 ce fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos);
8010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010070d:	0f b6 c0             	movzbl %al,%eax
80100710:	89 44 24 04          	mov    %eax,0x4(%esp)
80100714:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010071b:	e8 b8 fb ff ff       	call   801002d8 <outb>
  crt[pos] = ' ' | 0x0700;
80100720:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100728:	d1 e2                	shl    %edx
8010072a:	01 d0                	add    %edx,%eax
8010072c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100731:	c9                   	leave  
80100732:	c3                   	ret    

80100733 <consputc>:

void
consputc(int c)
{
80100733:	55                   	push   %ebp
80100734:	89 e5                	mov    %esp,%ebp
80100736:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100739:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010073e:	85 c0                	test   %eax,%eax
80100740:	74 07                	je     80100749 <consputc+0x16>
    cli();
80100742:	e8 ad fb ff ff       	call   801002f4 <cli>
    for(;;)
      ;
80100747:	eb fe                	jmp    80100747 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100749:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100750:	75 26                	jne    80100778 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100752:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100759:	e8 94 64 00 00       	call   80106bf2 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 88 64 00 00       	call   80106bf2 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 7c 64 00 00       	call   80106bf2 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 6f 64 00 00       	call   80106bf2 <uartputc>
  cgaputc(c);
80100783:	8b 45 08             	mov    0x8(%ebp),%eax
80100786:	89 04 24             	mov    %eax,(%esp)
80100789:	e8 36 fe ff ff       	call   801005c4 <cgaputc>
}
8010078e:	c9                   	leave  
8010078f:	c3                   	ret    

80100790 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100790:	55                   	push   %ebp
80100791:	89 e5                	mov    %esp,%ebp
80100793:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
80100796:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
8010079d:	e8 25 48 00 00       	call   80104fc7 <acquire>
  while((c = getc()) >= 0){
801007a2:	e9 35 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    switch(c){
801007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007aa:	83 f8 10             	cmp    $0x10,%eax
801007ad:	74 1b                	je     801007ca <consoleintr+0x3a>
801007af:	83 f8 10             	cmp    $0x10,%eax
801007b2:	7f 0a                	jg     801007be <consoleintr+0x2e>
801007b4:	83 f8 08             	cmp    $0x8,%eax
801007b7:	74 60                	je     80100819 <consoleintr+0x89>
801007b9:	e9 8a 00 00 00       	jmp    80100848 <consoleintr+0xb8>
801007be:	83 f8 15             	cmp    $0x15,%eax
801007c1:	74 2a                	je     801007ed <consoleintr+0x5d>
801007c3:	83 f8 7f             	cmp    $0x7f,%eax
801007c6:	74 51                	je     80100819 <consoleintr+0x89>
801007c8:	eb 7e                	jmp    80100848 <consoleintr+0xb8>
    case C('P'):  // Process listing.
      procdump();
801007ca:	e8 75 42 00 00       	call   80104a44 <procdump>
      break;
801007cf:	e9 08 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007d4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801007d9:	48                   	dec    %eax
801007da:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
801007df:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801007e6:	e8 48 ff ff ff       	call   80100733 <consputc>
801007eb:	eb 01                	jmp    801007ee <consoleintr+0x5e>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801007ed:	90                   	nop
801007ee:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
801007f4:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
801007f9:	39 c2                	cmp    %eax,%edx
801007fb:	0f 84 d4 00 00 00    	je     801008d5 <consoleintr+0x145>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100801:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100806:	48                   	dec    %eax
80100807:	83 e0 7f             	and    $0x7f,%eax
8010080a:	8a 80 f4 ed 10 80    	mov    -0x7fef120c(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100810:	3c 0a                	cmp    $0xa,%al
80100812:	75 c0                	jne    801007d4 <consoleintr+0x44>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100814:	e9 bc 00 00 00       	jmp    801008d5 <consoleintr+0x145>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100819:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
8010081f:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 ac 00 00 00    	je     801008d8 <consoleintr+0x148>
        input.e--;
8010082c:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100831:	48                   	dec    %eax
80100832:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100837:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010083e:	e8 f0 fe ff ff       	call   80100733 <consputc>
      }
      break;
80100843:	e9 90 00 00 00       	jmp    801008d8 <consoleintr+0x148>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010084c:	0f 84 89 00 00 00    	je     801008db <consoleintr+0x14b>
80100852:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100858:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
8010085d:	89 d1                	mov    %edx,%ecx
8010085f:	29 c1                	sub    %eax,%ecx
80100861:	89 c8                	mov    %ecx,%eax
80100863:	83 f8 7f             	cmp    $0x7f,%eax
80100866:	77 73                	ja     801008db <consoleintr+0x14b>
        c = (c == '\r') ? '\n' : c;
80100868:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010086c:	74 05                	je     80100873 <consoleintr+0xe3>
8010086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100871:	eb 05                	jmp    80100878 <consoleintr+0xe8>
80100873:	b8 0a 00 00 00       	mov    $0xa,%eax
80100878:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010087b:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100880:	89 c1                	mov    %eax,%ecx
80100882:	83 e1 7f             	and    $0x7f,%ecx
80100885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100888:	88 91 f4 ed 10 80    	mov    %dl,-0x7fef120c(%ecx)
8010088e:	40                   	inc    %eax
8010088f:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(c);
80100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100897:	89 04 24             	mov    %eax,(%esp)
8010089a:	e8 94 fe ff ff       	call   80100733 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010089f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008a3:	74 18                	je     801008bd <consoleintr+0x12d>
801008a5:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008a9:	74 12                	je     801008bd <consoleintr+0x12d>
801008ab:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008b0:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
801008b6:	83 ea 80             	sub    $0xffffff80,%edx
801008b9:	39 d0                	cmp    %edx,%eax
801008bb:	75 1e                	jne    801008db <consoleintr+0x14b>
          input.w = input.e;
801008bd:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008c2:	a3 78 ee 10 80       	mov    %eax,0x8010ee78
          wakeup(&input.r);
801008c7:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
801008ce:	e8 ce 40 00 00       	call   801049a1 <wakeup>
        }
      }
      break;
801008d3:	eb 06                	jmp    801008db <consoleintr+0x14b>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d5:	90                   	nop
801008d6:	eb 04                	jmp    801008dc <consoleintr+0x14c>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d8:	90                   	nop
801008d9:	eb 01                	jmp    801008dc <consoleintr+0x14c>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
801008db:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008dc:	8b 45 08             	mov    0x8(%ebp),%eax
801008df:	ff d0                	call   *%eax
801008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801008e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008e8:	0f 89 b9 fe ff ff    	jns    801007a7 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
801008ee:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801008f5:	e8 2f 47 00 00       	call   80105029 <release>
}
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801008fc:	55                   	push   %ebp
801008fd:	89 e5                	mov    %esp,%ebp
801008ff:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100902:	8b 45 08             	mov    0x8(%ebp),%eax
80100905:	89 04 24             	mov    %eax,(%esp)
80100908:	e8 88 10 00 00       	call   80101995 <iunlock>
  target = n;
8010090d:	8b 45 10             	mov    0x10(%ebp),%eax
80100910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100913:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
8010091a:	e8 a8 46 00 00       	call   80104fc7 <acquire>
  while(n > 0){
8010091f:	e9 a1 00 00 00       	jmp    801009c5 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010092a:	8b 40 24             	mov    0x24(%eax),%eax
8010092d:	85 c0                	test   %eax,%eax
8010092f:	74 21                	je     80100952 <consoleread+0x56>
        release(&input.lock);
80100931:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100938:	e8 ec 46 00 00       	call   80105029 <release>
        ilock(ip);
8010093d:	8b 45 08             	mov    0x8(%ebp),%eax
80100940:	89 04 24             	mov    %eax,(%esp)
80100943:	e8 02 0f 00 00       	call   8010184a <ilock>
        return -1;
80100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010094d:	e9 a2 00 00 00       	jmp    801009f4 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100952:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
80100959:	80 
8010095a:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100961:	e8 62 3f 00 00       	call   801048c8 <sleep>
80100966:	eb 01                	jmp    80100969 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100968:	90                   	nop
80100969:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
8010096f:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100974:	39 c2                	cmp    %eax,%edx
80100976:	74 ac                	je     80100924 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100978:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
8010097d:	89 c2                	mov    %eax,%edx
8010097f:	83 e2 7f             	and    $0x7f,%edx
80100982:	8a 92 f4 ed 10 80    	mov    -0x7fef120c(%edx),%dl
80100988:	0f be d2             	movsbl %dl,%edx
8010098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010098e:	40                   	inc    %eax
8010098f:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
    if(c == C('D')){  // EOF
80100994:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100998:	75 15                	jne    801009af <consoleread+0xb3>
      if(n < target){
8010099a:	8b 45 10             	mov    0x10(%ebp),%eax
8010099d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009a0:	73 2b                	jae    801009cd <consoleread+0xd1>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009a2:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009a7:	48                   	dec    %eax
801009a8:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
      }
      break;
801009ad:	eb 1e                	jmp    801009cd <consoleread+0xd1>
    }
    *dst++ = c;
801009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b2:	88 c2                	mov    %al,%dl
801009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801009b7:	88 10                	mov    %dl,(%eax)
801009b9:	ff 45 0c             	incl   0xc(%ebp)
    --n;
801009bc:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
801009bf:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009c3:	74 0b                	je     801009d0 <consoleread+0xd4>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009c9:	7f 9d                	jg     80100968 <consoleread+0x6c>
801009cb:	eb 04                	jmp    801009d1 <consoleread+0xd5>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009cd:	90                   	nop
801009ce:	eb 01                	jmp    801009d1 <consoleread+0xd5>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
801009d0:	90                   	nop
  }
  release(&input.lock);
801009d1:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801009d8:	e8 4c 46 00 00       	call   80105029 <release>
  ilock(ip);
801009dd:	8b 45 08             	mov    0x8(%ebp),%eax
801009e0:	89 04 24             	mov    %eax,(%esp)
801009e3:	e8 62 0e 00 00       	call   8010184a <ilock>

  return target - n;
801009e8:	8b 45 10             	mov    0x10(%ebp),%eax
801009eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801009ee:	89 d1                	mov    %edx,%ecx
801009f0:	29 c1                	sub    %eax,%ecx
801009f2:	89 c8                	mov    %ecx,%eax
}
801009f4:	c9                   	leave  
801009f5:	c3                   	ret    

801009f6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801009f6:	55                   	push   %ebp
801009f7:	89 e5                	mov    %esp,%ebp
801009f9:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
801009fc:	8b 45 08             	mov    0x8(%ebp),%eax
801009ff:	89 04 24             	mov    %eax,(%esp)
80100a02:	e8 8e 0f 00 00       	call   80101995 <iunlock>
  acquire(&cons.lock);
80100a07:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a0e:	e8 b4 45 00 00       	call   80104fc7 <acquire>
  for(i = 0; i < n; i++)
80100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a1a:	eb 1d                	jmp    80100a39 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a22:	01 d0                	add    %edx,%eax
80100a24:	8a 00                	mov    (%eax),%al
80100a26:	0f be c0             	movsbl %al,%eax
80100a29:	25 ff 00 00 00       	and    $0xff,%eax
80100a2e:	89 04 24             	mov    %eax,(%esp)
80100a31:	e8 fd fc ff ff       	call   80100733 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a36:	ff 45 f4             	incl   -0xc(%ebp)
80100a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a3c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a3f:	7c db                	jl     80100a1c <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a41:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a48:	e8 dc 45 00 00       	call   80105029 <release>
  ilock(ip);
80100a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a50:	89 04 24             	mov    %eax,(%esp)
80100a53:	e8 f2 0d 00 00       	call   8010184a <ilock>

  return n;
80100a58:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a5b:	c9                   	leave  
80100a5c:	c3                   	ret    

80100a5d <consoleinit>:

void
consoleinit(void)
{
80100a5d:	55                   	push   %ebp
80100a5e:	89 e5                	mov    %esp,%ebp
80100a60:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a63:	c7 44 24 04 97 8b 10 	movl   $0x80108b97,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a72:	e8 2f 45 00 00       	call   80104fa6 <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 9f 8b 10 	movl   $0x80108b9f,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100a86:	e8 1b 45 00 00       	call   80104fa6 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100a8b:	c7 05 2c f8 10 80 f6 	movl   $0x801009f6,0x8010f82c
80100a92:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80100a95:	c7 05 28 f8 10 80 fc 	movl   $0x801008fc,0x8010f828
80100a9c:	08 10 80 
  cons.locking = 1;
80100a9f:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aa6:	00 00 00 

  picenable(IRQ_KBD);
80100aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ab0:	e8 07 30 00 00       	call   80103abc <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ab5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100abc:	00 
80100abd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ac4:	e8 78 1e 00 00       	call   80102941 <ioapicenable>
}
80100ac9:	c9                   	leave  
80100aca:	c3                   	ret    
80100acb:	90                   	nop

80100acc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100acc:	55                   	push   %ebp
80100acd:	89 e5                	mov    %esp,%ebp
80100acf:	53                   	push   %ebx
80100ad0:	81 ec 34 01 00 00    	sub    $0x134,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ad9:	89 04 24             	mov    %eax,(%esp)
80100adc:	e8 03 19 00 00       	call   801023e4 <namei>
80100ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ae4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ae8:	75 0a                	jne    80100af4 <exec+0x28>
    return -1;
80100aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100aef:	e9 01 04 00 00       	jmp    80100ef5 <exec+0x429>
  ilock(ip);
80100af4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100af7:	89 04 24             	mov    %eax,(%esp)
80100afa:	e8 4b 0d 00 00       	call   8010184a <ilock>
  pgdir = 0;
80100aff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b06:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b0d:	00 
80100b0e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b15:	00 
80100b16:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b23:	89 04 24             	mov    %eax,(%esp)
80100b26:	e8 26 12 00 00       	call   80101d51 <readi>
80100b2b:	83 f8 33             	cmp    $0x33,%eax
80100b2e:	0f 86 7b 03 00 00    	jbe    80100eaf <exec+0x3e3>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b34:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100b3a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b3f:	0f 85 6d 03 00 00    	jne    80100eb2 <exec+0x3e6>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80100b45:	c7 04 24 c7 2a 10 80 	movl   $0x80102ac7,(%esp)
80100b4c:	e8 18 72 00 00       	call   80107d69 <setupkvm>
80100b51:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b54:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b58:	0f 84 57 03 00 00    	je     80100eb5 <exec+0x3e9>
    goto bad;

  // Load program into memory.
  /*sz = 0*/
  sz = PGSIZE - 1; //3.2
80100b5e:	c7 45 e0 ff 0f 00 00 	movl   $0xfff,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b6c:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100b72:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b75:	e9 db 00 00 00       	jmp    80100c55 <exec+0x189>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100b7d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100b84:	00 
80100b85:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b89:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b93:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b96:	89 04 24             	mov    %eax,(%esp)
80100b99:	e8 b3 11 00 00       	call   80101d51 <readi>
80100b9e:	83 f8 20             	cmp    $0x20,%eax
80100ba1:	0f 85 11 03 00 00    	jne    80100eb8 <exec+0x3ec>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ba7:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100bad:	83 f8 01             	cmp    $0x1,%eax
80100bb0:	0f 85 92 00 00 00    	jne    80100c48 <exec+0x17c>
      continue;
    if(ph.memsz < ph.filesz)
80100bb6:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100bbc:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100bc2:	39 c2                	cmp    %eax,%edx
80100bc4:	0f 82 f1 02 00 00    	jb     80100ebb <exec+0x3ef>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100bd0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bd6:	01 d0                	add    %edx,%eax
80100bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80100be3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100be6:	89 04 24             	mov    %eax,(%esp)
80100be9:	e8 5c 75 00 00       	call   8010814a <allocuvm>
80100bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100bf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100bf5:	0f 84 c3 02 00 00    	je     80100ebe <exec+0x3f2>
      goto bad;

    uint flagWriteELF = ph.flags & ELF_PROG_FLAG_WRITE; //3.3
80100bfb:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c01:	83 e0 02             	and    $0x2,%eax
80100c04:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz,flagWriteELF) < 0)
80100c07:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100c0d:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c13:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c19:	8b 5d d0             	mov    -0x30(%ebp),%ebx
80100c1c:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80100c20:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c24:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c28:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c2b:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c36:	89 04 24             	mov    %eax,(%esp)
80100c39:	e8 02 74 00 00       	call   80108040 <loaduvm>
80100c3e:	85 c0                	test   %eax,%eax
80100c40:	0f 88 7b 02 00 00    	js     80100ec1 <exec+0x3f5>
80100c46:	eb 01                	jmp    80100c49 <exec+0x17d>
  sz = PGSIZE - 1; //3.2
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c48:	90                   	nop
    goto bad;

  // Load program into memory.
  /*sz = 0*/
  sz = PGSIZE - 1; //3.2
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c49:	ff 45 ec             	incl   -0x14(%ebp)
80100c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c4f:	83 c0 20             	add    $0x20,%eax
80100c52:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c55:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
80100c5b:	0f b7 c0             	movzwl %ax,%eax
80100c5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c61:	0f 8f 13 ff ff ff    	jg     80100b7a <exec+0xae>

    uint flagWriteELF = ph.flags & ELF_PROG_FLAG_WRITE; //3.3
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz,flagWriteELF) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c6a:	89 04 24             	mov    %eax,(%esp)
80100c6d:	e8 59 0e 00 00       	call   80101acb <iunlockput>
  ip = 0;
80100c72:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c7c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c8c:	05 00 20 00 00       	add    $0x2000,%eax
80100c91:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c98:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c9f:	89 04 24             	mov    %eax,(%esp)
80100ca2:	e8 a3 74 00 00       	call   8010814a <allocuvm>
80100ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100caa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cae:	0f 84 10 02 00 00    	je     80100ec4 <exec+0x3f8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 95 78 00 00       	call   80108560 <clearpteu>
  sp = sz;
80100ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cce:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cd8:	e9 94 00 00 00       	jmp    80100d71 <exec+0x2a5>
    if(argc >= MAXARG)
80100cdd:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100ce1:	0f 87 e0 01 00 00    	ja     80100ec7 <exec+0x3fb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf4:	01 d0                	add    %edx,%eax
80100cf6:	8b 00                	mov    (%eax),%eax
80100cf8:	89 04 24             	mov    %eax,(%esp)
80100cfb:	e8 75 47 00 00       	call   80105475 <strlen>
80100d00:	f7 d0                	not    %eax
80100d02:	89 c2                	mov    %eax,%edx
80100d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d07:	01 d0                	add    %edx,%eax
80100d09:	83 e0 fc             	and    $0xfffffffc,%eax
80100d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d1c:	01 d0                	add    %edx,%eax
80100d1e:	8b 00                	mov    (%eax),%eax
80100d20:	89 04 24             	mov    %eax,(%esp)
80100d23:	e8 4d 47 00 00       	call   80105475 <strlen>
80100d28:	40                   	inc    %eax
80100d29:	89 c2                	mov    %eax,%edx
80100d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d2e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d35:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d38:	01 c8                	add    %ecx,%eax
80100d3a:	8b 00                	mov    (%eax),%eax
80100d3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d4e:	89 04 24             	mov    %eax,(%esp)
80100d51:	e8 05 7a 00 00       	call   8010875b <copyout>
80100d56:	85 c0                	test   %eax,%eax
80100d58:	0f 88 6c 01 00 00    	js     80100eca <exec+0x3fe>
      goto bad;
    ustack[3+argc] = sp;
80100d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d61:	8d 50 03             	lea    0x3(%eax),%edx
80100d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d67:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d6e:	ff 45 e4             	incl   -0x1c(%ebp)
80100d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7e:	01 d0                	add    %edx,%eax
80100d80:	8b 00                	mov    (%eax),%eax
80100d82:	85 c0                	test   %eax,%eax
80100d84:	0f 85 53 ff ff ff    	jne    80100cdd <exec+0x211>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8d:	83 c0 03             	add    $0x3,%eax
80100d90:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100d97:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d9b:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100da2:	ff ff ff 
  ustack[1] = argc;
80100da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da8:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db1:	40                   	inc    %eax
80100db2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dbc:	29 d0                	sub    %edx,%eax
80100dbe:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc7:	83 c0 04             	add    $0x4,%eax
80100dca:	c1 e0 02             	shl    $0x2,%eax
80100dcd:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	83 c0 04             	add    $0x4,%eax
80100dd6:	c1 e0 02             	shl    $0x2,%eax
80100dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ddd:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100de3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100de7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dea:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100df1:	89 04 24             	mov    %eax,(%esp)
80100df4:	e8 62 79 00 00       	call   8010875b <copyout>
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	0f 88 cc 00 00 00    	js     80100ecd <exec+0x401>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e01:	8b 45 08             	mov    0x8(%ebp),%eax
80100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e0d:	eb 13                	jmp    80100e22 <exec+0x356>
    if(*s == '/')
80100e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e12:	8a 00                	mov    (%eax),%al
80100e14:	3c 2f                	cmp    $0x2f,%al
80100e16:	75 07                	jne    80100e1f <exec+0x353>
      last = s+1;
80100e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e1b:	40                   	inc    %eax
80100e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e1f:	ff 45 f4             	incl   -0xc(%ebp)
80100e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e25:	8a 00                	mov    (%eax),%al
80100e27:	84 c0                	test   %al,%al
80100e29:	75 e4                	jne    80100e0f <exec+0x343>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e31:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e34:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e3b:	00 
80100e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e43:	89 14 24             	mov    %edx,(%esp)
80100e46:	e8 e1 45 00 00       	call   8010542c <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e51:	8b 40 04             	mov    0x4(%eax),%eax
80100e54:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100e57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e60:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e69:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e6c:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e74:	8b 40 18             	mov    0x18(%eax),%eax
80100e77:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100e7d:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e86:	8b 40 18             	mov    0x18(%eax),%eax
80100e89:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e8c:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e95:	89 04 24             	mov    %eax,(%esp)
80100e98:	e8 bd 6f 00 00       	call   80107e5a <switchuvm>
  freevm(oldpgdir);
80100e9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100ea0:	89 04 24             	mov    %eax,(%esp)
80100ea3:	e8 1f 76 00 00       	call   801084c7 <freevm>
  return 0;
80100ea8:	b8 00 00 00 00       	mov    $0x0,%eax
80100ead:	eb 46                	jmp    80100ef5 <exec+0x429>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100eaf:	90                   	nop
80100eb0:	eb 1c                	jmp    80100ece <exec+0x402>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eb2:	90                   	nop
80100eb3:	eb 19                	jmp    80100ece <exec+0x402>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
80100eb5:	90                   	nop
80100eb6:	eb 16                	jmp    80100ece <exec+0x402>
  // Load program into memory.
  /*sz = 0*/
  sz = PGSIZE - 1; //3.2
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100eb8:	90                   	nop
80100eb9:	eb 13                	jmp    80100ece <exec+0x402>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ebb:	90                   	nop
80100ebc:	eb 10                	jmp    80100ece <exec+0x402>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ebe:	90                   	nop
80100ebf:	eb 0d                	jmp    80100ece <exec+0x402>

    uint flagWriteELF = ph.flags & ELF_PROG_FLAG_WRITE; //3.3
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz,flagWriteELF) < 0)
      goto bad;
80100ec1:	90                   	nop
80100ec2:	eb 0a                	jmp    80100ece <exec+0x402>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ec4:	90                   	nop
80100ec5:	eb 07                	jmp    80100ece <exec+0x402>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ec7:	90                   	nop
80100ec8:	eb 04                	jmp    80100ece <exec+0x402>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100eca:	90                   	nop
80100ecb:	eb 01                	jmp    80100ece <exec+0x402>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ecd:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ece:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ed2:	74 0b                	je     80100edf <exec+0x413>
    freevm(pgdir);
80100ed4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ed7:	89 04 24             	mov    %eax,(%esp)
80100eda:	e8 e8 75 00 00       	call   801084c7 <freevm>
  if(ip)
80100edf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ee3:	74 0b                	je     80100ef0 <exec+0x424>
    iunlockput(ip);
80100ee5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ee8:	89 04 24             	mov    %eax,(%esp)
80100eeb:	e8 db 0b 00 00       	call   80101acb <iunlockput>
  return -1;
80100ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ef5:	81 c4 34 01 00 00    	add    $0x134,%esp
80100efb:	5b                   	pop    %ebx
80100efc:	5d                   	pop    %ebp
80100efd:	c3                   	ret    
80100efe:	66 90                	xchg   %ax,%ax

80100f00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f06:	c7 44 24 04 a5 8b 10 	movl   $0x80108ba5,0x4(%esp)
80100f0d:	80 
80100f0e:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f15:	e8 8c 40 00 00       	call   80104fa6 <initlock>
}
80100f1a:	c9                   	leave  
80100f1b:	c3                   	ret    

80100f1c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f1c:	55                   	push   %ebp
80100f1d:	89 e5                	mov    %esp,%ebp
80100f1f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f22:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f29:	e8 99 40 00 00       	call   80104fc7 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2e:	c7 45 f4 b4 ee 10 80 	movl   $0x8010eeb4,-0xc(%ebp)
80100f35:	eb 29                	jmp    80100f60 <filealloc+0x44>
    if(f->ref == 0){
80100f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3a:	8b 40 04             	mov    0x4(%eax),%eax
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	75 1b                	jne    80100f5c <filealloc+0x40>
      f->ref = 1;
80100f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f44:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f4b:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f52:	e8 d2 40 00 00       	call   80105029 <release>
      return f;
80100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5a:	eb 1e                	jmp    80100f7a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f60:	81 7d f4 14 f8 10 80 	cmpl   $0x8010f814,-0xc(%ebp)
80100f67:	72 ce                	jb     80100f37 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f69:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f70:	e8 b4 40 00 00       	call   80105029 <release>
  return 0;
80100f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f7a:	c9                   	leave  
80100f7b:	c3                   	ret    

80100f7c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f7c:	55                   	push   %ebp
80100f7d:	89 e5                	mov    %esp,%ebp
80100f7f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f82:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f89:	e8 39 40 00 00       	call   80104fc7 <acquire>
  if(f->ref < 1)
80100f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80100f91:	8b 40 04             	mov    0x4(%eax),%eax
80100f94:	85 c0                	test   %eax,%eax
80100f96:	7f 0c                	jg     80100fa4 <filedup+0x28>
    panic("filedup");
80100f98:	c7 04 24 ac 8b 10 80 	movl   $0x80108bac,(%esp)
80100f9f:	e8 92 f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa7:	8b 40 04             	mov    0x4(%eax),%eax
80100faa:	8d 50 01             	lea    0x1(%eax),%edx
80100fad:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb3:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fba:	e8 6a 40 00 00       	call   80105029 <release>
  return f;
80100fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fc2:	c9                   	leave  
80100fc3:	c3                   	ret    

80100fc4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	57                   	push   %edi
80100fc8:	56                   	push   %esi
80100fc9:	53                   	push   %ebx
80100fca:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fcd:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fd4:	e8 ee 3f 00 00       	call   80104fc7 <acquire>
  if(f->ref < 1)
80100fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdc:	8b 40 04             	mov    0x4(%eax),%eax
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	7f 0c                	jg     80100fef <fileclose+0x2b>
    panic("fileclose");
80100fe3:	c7 04 24 b4 8b 10 80 	movl   $0x80108bb4,(%esp)
80100fea:	e8 47 f5 ff ff       	call   80100536 <panic>
  if(--f->ref > 0){
80100fef:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff2:	8b 40 04             	mov    0x4(%eax),%eax
80100ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	89 50 04             	mov    %edx,0x4(%eax)
80100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80101001:	8b 40 04             	mov    0x4(%eax),%eax
80101004:	85 c0                	test   %eax,%eax
80101006:	7e 0e                	jle    80101016 <fileclose+0x52>
    release(&ftable.lock);
80101008:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
8010100f:	e8 15 40 00 00       	call   80105029 <release>
80101014:	eb 70                	jmp    80101086 <fileclose+0xc2>
    return;
  }
  ff = *f;
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8d 55 d0             	lea    -0x30(%ebp),%edx
8010101c:	89 c3                	mov    %eax,%ebx
8010101e:	b8 06 00 00 00       	mov    $0x6,%eax
80101023:	89 d7                	mov    %edx,%edi
80101025:	89 de                	mov    %ebx,%esi
80101027:	89 c1                	mov    %eax,%ecx
80101029:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010102b:	8b 45 08             	mov    0x8(%ebp),%eax
8010102e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101035:	8b 45 08             	mov    0x8(%ebp),%eax
80101038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010103e:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80101045:	e8 df 3f 00 00       	call   80105029 <release>
  
  if(ff.type == FD_PIPE)
8010104a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010104d:	83 f8 01             	cmp    $0x1,%eax
80101050:	75 17                	jne    80101069 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
80101052:	8a 45 d9             	mov    -0x27(%ebp),%al
80101055:	0f be d0             	movsbl %al,%edx
80101058:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010105b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010105f:	89 04 24             	mov    %eax,(%esp)
80101062:	e8 0c 2d 00 00       	call   80103d73 <pipeclose>
80101067:	eb 1d                	jmp    80101086 <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101069:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010106c:	83 f8 02             	cmp    $0x2,%eax
8010106f:	75 15                	jne    80101086 <fileclose+0xc2>
    begin_trans();
80101071:	e8 61 21 00 00       	call   801031d7 <begin_trans>
    iput(ff.ip);
80101076:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101079:	89 04 24             	mov    %eax,(%esp)
8010107c:	e8 79 09 00 00       	call   801019fa <iput>
    commit_trans();
80101081:	e8 9a 21 00 00       	call   80103220 <commit_trans>
  }
}
80101086:	83 c4 3c             	add    $0x3c,%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
8010108d:	c3                   	ret    

8010108e <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010108e:	55                   	push   %ebp
8010108f:	89 e5                	mov    %esp,%ebp
80101091:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101094:	8b 45 08             	mov    0x8(%ebp),%eax
80101097:	8b 00                	mov    (%eax),%eax
80101099:	83 f8 02             	cmp    $0x2,%eax
8010109c:	75 38                	jne    801010d6 <filestat+0x48>
    ilock(f->ip);
8010109e:	8b 45 08             	mov    0x8(%ebp),%eax
801010a1:	8b 40 10             	mov    0x10(%eax),%eax
801010a4:	89 04 24             	mov    %eax,(%esp)
801010a7:	e8 9e 07 00 00       	call   8010184a <ilock>
    stati(f->ip, st);
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 40 10             	mov    0x10(%eax),%eax
801010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801010b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801010b9:	89 04 24             	mov    %eax,(%esp)
801010bc:	e8 4c 0c 00 00       	call   80101d0d <stati>
    iunlock(f->ip);
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	8b 40 10             	mov    0x10(%eax),%eax
801010c7:	89 04 24             	mov    %eax,(%esp)
801010ca:	e8 c6 08 00 00       	call   80101995 <iunlock>
    return 0;
801010cf:	b8 00 00 00 00       	mov    $0x0,%eax
801010d4:	eb 05                	jmp    801010db <filestat+0x4d>
  }
  return -1;
801010d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010db:	c9                   	leave  
801010dc:	c3                   	ret    

801010dd <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010dd:	55                   	push   %ebp
801010de:	89 e5                	mov    %esp,%ebp
801010e0:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010e3:	8b 45 08             	mov    0x8(%ebp),%eax
801010e6:	8a 40 08             	mov    0x8(%eax),%al
801010e9:	84 c0                	test   %al,%al
801010eb:	75 0a                	jne    801010f7 <fileread+0x1a>
    return -1;
801010ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010f2:	e9 9f 00 00 00       	jmp    80101196 <fileread+0xb9>
  if(f->type == FD_PIPE)
801010f7:	8b 45 08             	mov    0x8(%ebp),%eax
801010fa:	8b 00                	mov    (%eax),%eax
801010fc:	83 f8 01             	cmp    $0x1,%eax
801010ff:	75 1e                	jne    8010111f <fileread+0x42>
    return piperead(f->pipe, addr, n);
80101101:	8b 45 08             	mov    0x8(%ebp),%eax
80101104:	8b 40 0c             	mov    0xc(%eax),%eax
80101107:	8b 55 10             	mov    0x10(%ebp),%edx
8010110a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010110e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101111:	89 54 24 04          	mov    %edx,0x4(%esp)
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 d8 2d 00 00       	call   80103ef5 <piperead>
8010111d:	eb 77                	jmp    80101196 <fileread+0xb9>
  if(f->type == FD_INODE){
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
80101122:	8b 00                	mov    (%eax),%eax
80101124:	83 f8 02             	cmp    $0x2,%eax
80101127:	75 61                	jne    8010118a <fileread+0xad>
    ilock(f->ip);
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 10             	mov    0x10(%eax),%eax
8010112f:	89 04 24             	mov    %eax,(%esp)
80101132:	e8 13 07 00 00       	call   8010184a <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101137:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010113a:	8b 45 08             	mov    0x8(%ebp),%eax
8010113d:	8b 50 14             	mov    0x14(%eax),%edx
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010114a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010114e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101151:	89 54 24 04          	mov    %edx,0x4(%esp)
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 f4 0b 00 00       	call   80101d51 <readi>
8010115d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101164:	7e 11                	jle    80101177 <fileread+0x9a>
      f->off += r;
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 50 14             	mov    0x14(%eax),%edx
8010116c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010116f:	01 c2                	add    %eax,%edx
80101171:	8b 45 08             	mov    0x8(%ebp),%eax
80101174:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	8b 40 10             	mov    0x10(%eax),%eax
8010117d:	89 04 24             	mov    %eax,(%esp)
80101180:	e8 10 08 00 00       	call   80101995 <iunlock>
    return r;
80101185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101188:	eb 0c                	jmp    80101196 <fileread+0xb9>
  }
  panic("fileread");
8010118a:	c7 04 24 be 8b 10 80 	movl   $0x80108bbe,(%esp)
80101191:	e8 a0 f3 ff ff       	call   80100536 <panic>
}
80101196:	c9                   	leave  
80101197:	c3                   	ret    

80101198 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101198:	55                   	push   %ebp
80101199:	89 e5                	mov    %esp,%ebp
8010119b:	53                   	push   %ebx
8010119c:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8a 40 09             	mov    0x9(%eax),%al
801011a5:	84 c0                	test   %al,%al
801011a7:	75 0a                	jne    801011b3 <filewrite+0x1b>
    return -1;
801011a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ae:	e9 23 01 00 00       	jmp    801012d6 <filewrite+0x13e>
  if(f->type == FD_PIPE)
801011b3:	8b 45 08             	mov    0x8(%ebp),%eax
801011b6:	8b 00                	mov    (%eax),%eax
801011b8:	83 f8 01             	cmp    $0x1,%eax
801011bb:	75 21                	jne    801011de <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
801011bd:	8b 45 08             	mov    0x8(%ebp),%eax
801011c0:	8b 40 0c             	mov    0xc(%eax),%eax
801011c3:	8b 55 10             	mov    0x10(%ebp),%edx
801011c6:	89 54 24 08          	mov    %edx,0x8(%esp)
801011ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801011cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801011d1:	89 04 24             	mov    %eax,(%esp)
801011d4:	e8 2c 2c 00 00       	call   80103e05 <pipewrite>
801011d9:	e9 f8 00 00 00       	jmp    801012d6 <filewrite+0x13e>
  if(f->type == FD_INODE){
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	8b 00                	mov    (%eax),%eax
801011e3:	83 f8 02             	cmp    $0x2,%eax
801011e6:	0f 85 de 00 00 00    	jne    801012ca <filewrite+0x132>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011ec:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801011f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801011fa:	e9 a8 00 00 00       	jmp    801012a7 <filewrite+0x10f>
      int n1 = n - i;
801011ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101202:	8b 55 10             	mov    0x10(%ebp),%edx
80101205:	89 d1                	mov    %edx,%ecx
80101207:	29 c1                	sub    %eax,%ecx
80101209:	89 c8                	mov    %ecx,%eax
8010120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101211:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101214:	7e 06                	jle    8010121c <filewrite+0x84>
        n1 = max;
80101216:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101219:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010121c:	e8 b6 1f 00 00       	call   801031d7 <begin_trans>
      ilock(f->ip);
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	8b 40 10             	mov    0x10(%eax),%eax
80101227:	89 04 24             	mov    %eax,(%esp)
8010122a:	e8 1b 06 00 00       	call   8010184a <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101232:	8b 45 08             	mov    0x8(%ebp),%eax
80101235:	8b 50 14             	mov    0x14(%eax),%edx
80101238:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010123b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010123e:	01 c3                	add    %eax,%ebx
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 40 10             	mov    0x10(%eax),%eax
80101246:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010124a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010124e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101252:	89 04 24             	mov    %eax,(%esp)
80101255:	e8 5c 0c 00 00       	call   80101eb6 <writei>
8010125a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010125d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101261:	7e 11                	jle    80101274 <filewrite+0xdc>
        f->off += r;
80101263:	8b 45 08             	mov    0x8(%ebp),%eax
80101266:	8b 50 14             	mov    0x14(%eax),%edx
80101269:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010126c:	01 c2                	add    %eax,%edx
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101274:	8b 45 08             	mov    0x8(%ebp),%eax
80101277:	8b 40 10             	mov    0x10(%eax),%eax
8010127a:	89 04 24             	mov    %eax,(%esp)
8010127d:	e8 13 07 00 00       	call   80101995 <iunlock>
      commit_trans();
80101282:	e8 99 1f 00 00       	call   80103220 <commit_trans>

      if(r < 0)
80101287:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010128b:	78 28                	js     801012b5 <filewrite+0x11d>
        break;
      if(r != n1)
8010128d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101293:	74 0c                	je     801012a1 <filewrite+0x109>
        panic("short filewrite");
80101295:	c7 04 24 c7 8b 10 80 	movl   $0x80108bc7,(%esp)
8010129c:	e8 95 f2 ff ff       	call   80100536 <panic>
      i += r;
801012a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012aa:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ad:	0f 8c 4c ff ff ff    	jl     801011ff <filewrite+0x67>
801012b3:	eb 01                	jmp    801012b6 <filewrite+0x11e>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012b5:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b9:	3b 45 10             	cmp    0x10(%ebp),%eax
801012bc:	75 05                	jne    801012c3 <filewrite+0x12b>
801012be:	8b 45 10             	mov    0x10(%ebp),%eax
801012c1:	eb 05                	jmp    801012c8 <filewrite+0x130>
801012c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012c8:	eb 0c                	jmp    801012d6 <filewrite+0x13e>
  }
  panic("filewrite");
801012ca:	c7 04 24 d7 8b 10 80 	movl   $0x80108bd7,(%esp)
801012d1:	e8 60 f2 ff ff       	call   80100536 <panic>
}
801012d6:	83 c4 24             	add    $0x24,%esp
801012d9:	5b                   	pop    %ebx
801012da:	5d                   	pop    %ebp
801012db:	c3                   	ret    

801012dc <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012dc:	55                   	push   %ebp
801012dd:	89 e5                	mov    %esp,%ebp
801012df:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012e2:	8b 45 08             	mov    0x8(%ebp),%eax
801012e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012ec:	00 
801012ed:	89 04 24             	mov    %eax,(%esp)
801012f0:	e8 b1 ee ff ff       	call   801001a6 <bread>
801012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012fb:	83 c0 18             	add    $0x18,%eax
801012fe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101305:	00 
80101306:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010130d:	89 04 24             	mov    %eax,(%esp)
80101310:	e8 d1 3f 00 00       	call   801052e6 <memmove>
  brelse(bp);
80101315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101318:	89 04 24             	mov    %eax,(%esp)
8010131b:	e8 f7 ee ff ff       	call   80100217 <brelse>
}
80101320:	c9                   	leave  
80101321:	c3                   	ret    

80101322 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101322:	55                   	push   %ebp
80101323:	89 e5                	mov    %esp,%ebp
80101325:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010132b:	8b 45 08             	mov    0x8(%ebp),%eax
8010132e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101332:	89 04 24             	mov    %eax,(%esp)
80101335:	e8 6c ee ff ff       	call   801001a6 <bread>
8010133a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101340:	83 c0 18             	add    $0x18,%eax
80101343:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010134a:	00 
8010134b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101352:	00 
80101353:	89 04 24             	mov    %eax,(%esp)
80101356:	e8 bf 3e 00 00       	call   8010521a <memset>
  log_write(bp);
8010135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135e:	89 04 24             	mov    %eax,(%esp)
80101361:	e8 12 1f 00 00       	call   80103278 <log_write>
  brelse(bp);
80101366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101369:	89 04 24             	mov    %eax,(%esp)
8010136c:	e8 a6 ee ff ff       	call   80100217 <brelse>
}
80101371:	c9                   	leave  
80101372:	c3                   	ret    

80101373 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101373:	55                   	push   %ebp
80101374:	89 e5                	mov    %esp,%ebp
80101376:	53                   	push   %ebx
80101377:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010137a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101381:	8b 45 08             	mov    0x8(%ebp),%eax
80101384:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101387:	89 54 24 04          	mov    %edx,0x4(%esp)
8010138b:	89 04 24             	mov    %eax,(%esp)
8010138e:	e8 49 ff ff ff       	call   801012dc <readsb>
  for(b = 0; b < sb.size; b += BPB){
80101393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010139a:	e9 05 01 00 00       	jmp    801014a4 <balloc+0x131>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a2:	85 c0                	test   %eax,%eax
801013a4:	79 05                	jns    801013ab <balloc+0x38>
801013a6:	05 ff 0f 00 00       	add    $0xfff,%eax
801013ab:	c1 f8 0c             	sar    $0xc,%eax
801013ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013b1:	c1 ea 03             	shr    $0x3,%edx
801013b4:	01 d0                	add    %edx,%eax
801013b6:	83 c0 03             	add    $0x3,%eax
801013b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801013bd:	8b 45 08             	mov    0x8(%ebp),%eax
801013c0:	89 04 24             	mov    %eax,(%esp)
801013c3:	e8 de ed ff ff       	call   801001a6 <bread>
801013c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013d2:	e9 9d 00 00 00       	jmp    80101474 <balloc+0x101>
      m = 1 << (bi % 8);
801013d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013da:	25 07 00 00 80       	and    $0x80000007,%eax
801013df:	85 c0                	test   %eax,%eax
801013e1:	79 05                	jns    801013e8 <balloc+0x75>
801013e3:	48                   	dec    %eax
801013e4:	83 c8 f8             	or     $0xfffffff8,%eax
801013e7:	40                   	inc    %eax
801013e8:	ba 01 00 00 00       	mov    $0x1,%edx
801013ed:	89 d3                	mov    %edx,%ebx
801013ef:	88 c1                	mov    %al,%cl
801013f1:	d3 e3                	shl    %cl,%ebx
801013f3:	89 d8                	mov    %ebx,%eax
801013f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013fb:	85 c0                	test   %eax,%eax
801013fd:	79 03                	jns    80101402 <balloc+0x8f>
801013ff:	83 c0 07             	add    $0x7,%eax
80101402:	c1 f8 03             	sar    $0x3,%eax
80101405:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101408:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010140c:	0f b6 c0             	movzbl %al,%eax
8010140f:	23 45 e8             	and    -0x18(%ebp),%eax
80101412:	85 c0                	test   %eax,%eax
80101414:	75 5b                	jne    80101471 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101416:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101419:	85 c0                	test   %eax,%eax
8010141b:	79 03                	jns    80101420 <balloc+0xad>
8010141d:	83 c0 07             	add    $0x7,%eax
80101420:	c1 f8 03             	sar    $0x3,%eax
80101423:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101426:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
8010142a:	88 d1                	mov    %dl,%cl
8010142c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010142f:	09 ca                	or     %ecx,%edx
80101431:	88 d1                	mov    %dl,%cl
80101433:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101436:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010143a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010143d:	89 04 24             	mov    %eax,(%esp)
80101440:	e8 33 1e 00 00       	call   80103278 <log_write>
        brelse(bp);
80101445:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101448:	89 04 24             	mov    %eax,(%esp)
8010144b:	e8 c7 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101453:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101456:	01 c2                	add    %eax,%edx
80101458:	8b 45 08             	mov    0x8(%ebp),%eax
8010145b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010145f:	89 04 24             	mov    %eax,(%esp)
80101462:	e8 bb fe ff ff       	call   80101322 <bzero>
        return b + bi;
80101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146d:	01 d0                	add    %edx,%eax
8010146f:	eb 4d                	jmp    801014be <balloc+0x14b>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101471:	ff 45 f0             	incl   -0x10(%ebp)
80101474:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010147b:	7f 15                	jg     80101492 <balloc+0x11f>
8010147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101480:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101483:	01 d0                	add    %edx,%eax
80101485:	89 c2                	mov    %eax,%edx
80101487:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010148a:	39 c2                	cmp    %eax,%edx
8010148c:	0f 82 45 ff ff ff    	jb     801013d7 <balloc+0x64>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101492:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101495:	89 04 24             	mov    %eax,(%esp)
80101498:	e8 7a ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
8010149d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014aa:	39 c2                	cmp    %eax,%edx
801014ac:	0f 82 ed fe ff ff    	jb     8010139f <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014b2:	c7 04 24 e1 8b 10 80 	movl   $0x80108be1,(%esp)
801014b9:	e8 78 f0 ff ff       	call   80100536 <panic>
}
801014be:	83 c4 34             	add    $0x34,%esp
801014c1:	5b                   	pop    %ebx
801014c2:	5d                   	pop    %ebp
801014c3:	c3                   	ret    

801014c4 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	53                   	push   %ebx
801014c8:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014cb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801014d2:	8b 45 08             	mov    0x8(%ebp),%eax
801014d5:	89 04 24             	mov    %eax,(%esp)
801014d8:	e8 ff fd ff ff       	call   801012dc <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801014e0:	89 c2                	mov    %eax,%edx
801014e2:	c1 ea 0c             	shr    $0xc,%edx
801014e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014e8:	c1 e8 03             	shr    $0x3,%eax
801014eb:	01 d0                	add    %edx,%eax
801014ed:	8d 50 03             	lea    0x3(%eax),%edx
801014f0:	8b 45 08             	mov    0x8(%ebp),%eax
801014f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801014f7:	89 04 24             	mov    %eax,(%esp)
801014fa:	e8 a7 ec ff ff       	call   801001a6 <bread>
801014ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101502:	8b 45 0c             	mov    0xc(%ebp),%eax
80101505:	25 ff 0f 00 00       	and    $0xfff,%eax
8010150a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101510:	25 07 00 00 80       	and    $0x80000007,%eax
80101515:	85 c0                	test   %eax,%eax
80101517:	79 05                	jns    8010151e <bfree+0x5a>
80101519:	48                   	dec    %eax
8010151a:	83 c8 f8             	or     $0xfffffff8,%eax
8010151d:	40                   	inc    %eax
8010151e:	ba 01 00 00 00       	mov    $0x1,%edx
80101523:	89 d3                	mov    %edx,%ebx
80101525:	88 c1                	mov    %al,%cl
80101527:	d3 e3                	shl    %cl,%ebx
80101529:	89 d8                	mov    %ebx,%eax
8010152b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101531:	85 c0                	test   %eax,%eax
80101533:	79 03                	jns    80101538 <bfree+0x74>
80101535:	83 c0 07             	add    $0x7,%eax
80101538:	c1 f8 03             	sar    $0x3,%eax
8010153b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153e:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
80101542:	0f b6 c0             	movzbl %al,%eax
80101545:	23 45 ec             	and    -0x14(%ebp),%eax
80101548:	85 c0                	test   %eax,%eax
8010154a:	75 0c                	jne    80101558 <bfree+0x94>
    panic("freeing free block");
8010154c:	c7 04 24 f7 8b 10 80 	movl   $0x80108bf7,(%esp)
80101553:	e8 de ef ff ff       	call   80100536 <panic>
  bp->data[bi/8] &= ~m;
80101558:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155b:	85 c0                	test   %eax,%eax
8010155d:	79 03                	jns    80101562 <bfree+0x9e>
8010155f:	83 c0 07             	add    $0x7,%eax
80101562:	c1 f8 03             	sar    $0x3,%eax
80101565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101568:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
8010156c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010156f:	f7 d1                	not    %ecx
80101571:	21 ca                	and    %ecx,%edx
80101573:	88 d1                	mov    %dl,%cl
80101575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101578:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010157f:	89 04 24             	mov    %eax,(%esp)
80101582:	e8 f1 1c 00 00       	call   80103278 <log_write>
  brelse(bp);
80101587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158a:	89 04 24             	mov    %eax,(%esp)
8010158d:	e8 85 ec ff ff       	call   80100217 <brelse>
}
80101592:	83 c4 34             	add    $0x34,%esp
80101595:	5b                   	pop    %ebx
80101596:	5d                   	pop    %ebp
80101597:	c3                   	ret    

80101598 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101598:	55                   	push   %ebp
80101599:	89 e5                	mov    %esp,%ebp
8010159b:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
8010159e:	c7 44 24 04 0a 8c 10 	movl   $0x80108c0a,0x4(%esp)
801015a5:	80 
801015a6:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801015ad:	e8 f4 39 00 00       	call   80104fa6 <initlock>
}
801015b2:	c9                   	leave  
801015b3:	c3                   	ret    

801015b4 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	83 ec 48             	sub    $0x48,%esp
801015ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801015bd:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015c1:	8b 45 08             	mov    0x8(%ebp),%eax
801015c4:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801015cb:	89 04 24             	mov    %eax,(%esp)
801015ce:	e8 09 fd ff ff       	call   801012dc <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015da:	e9 95 00 00 00       	jmp    80101674 <ialloc+0xc0>
    bp = bread(dev, IBLOCK(inum));
801015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e2:	c1 e8 03             	shr    $0x3,%eax
801015e5:	83 c0 02             	add    $0x2,%eax
801015e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801015ec:	8b 45 08             	mov    0x8(%ebp),%eax
801015ef:	89 04 24             	mov    %eax,(%esp)
801015f2:	e8 af eb ff ff       	call   801001a6 <bread>
801015f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fd:	8d 50 18             	lea    0x18(%eax),%edx
80101600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	01 d0                	add    %edx,%eax
8010160b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010160e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101611:	8b 00                	mov    (%eax),%eax
80101613:	66 85 c0             	test   %ax,%ax
80101616:	75 4e                	jne    80101666 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
80101618:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010161f:	00 
80101620:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101627:	00 
80101628:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162b:	89 04 24             	mov    %eax,(%esp)
8010162e:	e8 e7 3b 00 00       	call   8010521a <memset>
      dip->type = type;
80101633:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101639:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
8010163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163f:	89 04 24             	mov    %eax,(%esp)
80101642:	e8 31 1c 00 00       	call   80103278 <log_write>
      brelse(bp);
80101647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164a:	89 04 24             	mov    %eax,(%esp)
8010164d:	e8 c5 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101655:	89 44 24 04          	mov    %eax,0x4(%esp)
80101659:	8b 45 08             	mov    0x8(%ebp),%eax
8010165c:	89 04 24             	mov    %eax,(%esp)
8010165f:	e8 e2 00 00 00       	call   80101746 <iget>
80101664:	eb 28                	jmp    8010168e <ialloc+0xda>
    }
    brelse(bp);
80101666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101669:	89 04 24             	mov    %eax,(%esp)
8010166c:	e8 a6 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101671:	ff 45 f4             	incl   -0xc(%ebp)
80101674:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010167a:	39 c2                	cmp    %eax,%edx
8010167c:	0f 82 5d ff ff ff    	jb     801015df <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101682:	c7 04 24 11 8c 10 80 	movl   $0x80108c11,(%esp)
80101689:	e8 a8 ee ff ff       	call   80100536 <panic>
}
8010168e:	c9                   	leave  
8010168f:	c3                   	ret    

80101690 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101696:	8b 45 08             	mov    0x8(%ebp),%eax
80101699:	8b 40 04             	mov    0x4(%eax),%eax
8010169c:	c1 e8 03             	shr    $0x3,%eax
8010169f:	8d 50 02             	lea    0x2(%eax),%edx
801016a2:	8b 45 08             	mov    0x8(%ebp),%eax
801016a5:	8b 00                	mov    (%eax),%eax
801016a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801016ab:	89 04 24             	mov    %eax,(%esp)
801016ae:	e8 f3 ea ff ff       	call   801001a6 <bread>
801016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b9:	8d 50 18             	lea    0x18(%eax),%edx
801016bc:	8b 45 08             	mov    0x8(%ebp),%eax
801016bf:	8b 40 04             	mov    0x4(%eax),%eax
801016c2:	83 e0 07             	and    $0x7,%eax
801016c5:	c1 e0 06             	shl    $0x6,%eax
801016c8:	01 d0                	add    %edx,%eax
801016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016cd:	8b 45 08             	mov    0x8(%ebp),%eax
801016d0:	8b 40 10             	mov    0x10(%eax),%eax
801016d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016d6:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801016d9:	8b 45 08             	mov    0x8(%ebp),%eax
801016dc:	66 8b 40 12          	mov    0x12(%eax),%ax
801016e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016e3:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801016e7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ea:	8b 40 14             	mov    0x14(%eax),%eax
801016ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016f0:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801016f4:	8b 45 08             	mov    0x8(%ebp),%eax
801016f7:	66 8b 40 16          	mov    0x16(%eax),%ax
801016fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016fe:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
80101702:	8b 45 08             	mov    0x8(%ebp),%eax
80101705:	8b 50 18             	mov    0x18(%eax),%edx
80101708:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170e:	8b 45 08             	mov    0x8(%ebp),%eax
80101711:	8d 50 1c             	lea    0x1c(%eax),%edx
80101714:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101717:	83 c0 0c             	add    $0xc,%eax
8010171a:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101721:	00 
80101722:	89 54 24 04          	mov    %edx,0x4(%esp)
80101726:	89 04 24             	mov    %eax,(%esp)
80101729:	e8 b8 3b 00 00       	call   801052e6 <memmove>
  log_write(bp);
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	89 04 24             	mov    %eax,(%esp)
80101734:	e8 3f 1b 00 00       	call   80103278 <log_write>
  brelse(bp);
80101739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173c:	89 04 24             	mov    %eax,(%esp)
8010173f:	e8 d3 ea ff ff       	call   80100217 <brelse>
}
80101744:	c9                   	leave  
80101745:	c3                   	ret    

80101746 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101746:	55                   	push   %ebp
80101747:	89 e5                	mov    %esp,%ebp
80101749:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010174c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101753:	e8 6f 38 00 00       	call   80104fc7 <acquire>

  // Is the inode already cached?
  empty = 0;
80101758:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175f:	c7 45 f4 b4 f8 10 80 	movl   $0x8010f8b4,-0xc(%ebp)
80101766:	eb 59                	jmp    801017c1 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176b:	8b 40 08             	mov    0x8(%eax),%eax
8010176e:	85 c0                	test   %eax,%eax
80101770:	7e 35                	jle    801017a7 <iget+0x61>
80101772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101775:	8b 00                	mov    (%eax),%eax
80101777:	3b 45 08             	cmp    0x8(%ebp),%eax
8010177a:	75 2b                	jne    801017a7 <iget+0x61>
8010177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177f:	8b 40 04             	mov    0x4(%eax),%eax
80101782:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101785:	75 20                	jne    801017a7 <iget+0x61>
      ip->ref++;
80101787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178a:	8b 40 08             	mov    0x8(%eax),%eax
8010178d:	8d 50 01             	lea    0x1(%eax),%edx
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101796:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010179d:	e8 87 38 00 00       	call   80105029 <release>
      return ip;
801017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a5:	eb 6f                	jmp    80101816 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ab:	75 10                	jne    801017bd <iget+0x77>
801017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b0:	8b 40 08             	mov    0x8(%eax),%eax
801017b3:	85 c0                	test   %eax,%eax
801017b5:	75 06                	jne    801017bd <iget+0x77>
      empty = ip;
801017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017bd:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017c1:	81 7d f4 54 08 11 80 	cmpl   $0x80110854,-0xc(%ebp)
801017c8:	72 9e                	jb     80101768 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ce:	75 0c                	jne    801017dc <iget+0x96>
    panic("iget: no inodes");
801017d0:	c7 04 24 23 8c 10 80 	movl   $0x80108c23,(%esp)
801017d7:	e8 5a ed ff ff       	call   80100536 <panic>

  ip = empty;
801017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e5:	8b 55 08             	mov    0x8(%ebp),%edx
801017e8:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
801017f0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101800:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101807:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010180e:	e8 16 38 00 00       	call   80105029 <release>

  return ip;
80101813:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101816:	c9                   	leave  
80101817:	c3                   	ret    

80101818 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101818:	55                   	push   %ebp
80101819:	89 e5                	mov    %esp,%ebp
8010181b:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010181e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101825:	e8 9d 37 00 00       	call   80104fc7 <acquire>
  ip->ref++;
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	8b 40 08             	mov    0x8(%eax),%eax
80101830:	8d 50 01             	lea    0x1(%eax),%edx
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101839:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101840:	e8 e4 37 00 00       	call   80105029 <release>
  return ip;
80101845:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101848:	c9                   	leave  
80101849:	c3                   	ret    

8010184a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010184a:	55                   	push   %ebp
8010184b:	89 e5                	mov    %esp,%ebp
8010184d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101850:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101854:	74 0a                	je     80101860 <ilock+0x16>
80101856:	8b 45 08             	mov    0x8(%ebp),%eax
80101859:	8b 40 08             	mov    0x8(%eax),%eax
8010185c:	85 c0                	test   %eax,%eax
8010185e:	7f 0c                	jg     8010186c <ilock+0x22>
    panic("ilock");
80101860:	c7 04 24 33 8c 10 80 	movl   $0x80108c33,(%esp)
80101867:	e8 ca ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
8010186c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101873:	e8 4f 37 00 00       	call   80104fc7 <acquire>
  while(ip->flags & I_BUSY)
80101878:	eb 13                	jmp    8010188d <ilock+0x43>
    sleep(ip, &icache.lock);
8010187a:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80101881:	80 
80101882:	8b 45 08             	mov    0x8(%ebp),%eax
80101885:	89 04 24             	mov    %eax,(%esp)
80101888:	e8 3b 30 00 00       	call   801048c8 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010188d:	8b 45 08             	mov    0x8(%ebp),%eax
80101890:	8b 40 0c             	mov    0xc(%eax),%eax
80101893:	83 e0 01             	and    $0x1,%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	75 e0                	jne    8010187a <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010189a:	8b 45 08             	mov    0x8(%ebp),%eax
8010189d:	8b 40 0c             	mov    0xc(%eax),%eax
801018a0:	89 c2                	mov    %eax,%edx
801018a2:	83 ca 01             	or     $0x1,%edx
801018a5:	8b 45 08             	mov    0x8(%ebp),%eax
801018a8:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018ab:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801018b2:	e8 72 37 00 00       	call   80105029 <release>

  if(!(ip->flags & I_VALID)){
801018b7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ba:	8b 40 0c             	mov    0xc(%eax),%eax
801018bd:	83 e0 02             	and    $0x2,%eax
801018c0:	85 c0                	test   %eax,%eax
801018c2:	0f 85 cb 00 00 00    	jne    80101993 <ilock+0x149>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018c8:	8b 45 08             	mov    0x8(%ebp),%eax
801018cb:	8b 40 04             	mov    0x4(%eax),%eax
801018ce:	c1 e8 03             	shr    $0x3,%eax
801018d1:	8d 50 02             	lea    0x2(%eax),%edx
801018d4:	8b 45 08             	mov    0x8(%ebp),%eax
801018d7:	8b 00                	mov    (%eax),%eax
801018d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801018dd:	89 04 24             	mov    %eax,(%esp)
801018e0:	e8 c1 e8 ff ff       	call   801001a6 <bread>
801018e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018eb:	8d 50 18             	lea    0x18(%eax),%edx
801018ee:	8b 45 08             	mov    0x8(%ebp),%eax
801018f1:	8b 40 04             	mov    0x4(%eax),%eax
801018f4:	83 e0 07             	and    $0x7,%eax
801018f7:	c1 e0 06             	shl    $0x6,%eax
801018fa:	01 d0                	add    %edx,%eax
801018fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101902:	8b 00                	mov    (%eax),%eax
80101904:	8b 55 08             	mov    0x8(%ebp),%edx
80101907:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
8010190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010190e:	66 8b 40 02          	mov    0x2(%eax),%ax
80101912:	8b 55 08             	mov    0x8(%ebp),%edx
80101915:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191c:	8b 40 04             	mov    0x4(%eax),%eax
8010191f:	8b 55 08             	mov    0x8(%ebp),%edx
80101922:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101929:	66 8b 40 06          	mov    0x6(%eax),%ax
8010192d:	8b 55 08             	mov    0x8(%ebp),%edx
80101930:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
80101934:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101937:	8b 50 08             	mov    0x8(%eax),%edx
8010193a:	8b 45 08             	mov    0x8(%ebp),%eax
8010193d:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101940:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101943:	8d 50 0c             	lea    0xc(%eax),%edx
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	83 c0 1c             	add    $0x1c,%eax
8010194c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101953:	00 
80101954:	89 54 24 04          	mov    %edx,0x4(%esp)
80101958:	89 04 24             	mov    %eax,(%esp)
8010195b:	e8 86 39 00 00       	call   801052e6 <memmove>
    brelse(bp);
80101960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101963:	89 04 24             	mov    %eax,(%esp)
80101966:	e8 ac e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	8b 40 0c             	mov    0xc(%eax),%eax
80101971:	89 c2                	mov    %eax,%edx
80101973:	83 ca 02             	or     $0x2,%edx
80101976:	8b 45 08             	mov    0x8(%ebp),%eax
80101979:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	8b 40 10             	mov    0x10(%eax),%eax
80101982:	66 85 c0             	test   %ax,%ax
80101985:	75 0c                	jne    80101993 <ilock+0x149>
      panic("ilock: no type");
80101987:	c7 04 24 39 8c 10 80 	movl   $0x80108c39,(%esp)
8010198e:	e8 a3 eb ff ff       	call   80100536 <panic>
  }
}
80101993:	c9                   	leave  
80101994:	c3                   	ret    

80101995 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101995:	55                   	push   %ebp
80101996:	89 e5                	mov    %esp,%ebp
80101998:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010199b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010199f:	74 17                	je     801019b8 <iunlock+0x23>
801019a1:	8b 45 08             	mov    0x8(%ebp),%eax
801019a4:	8b 40 0c             	mov    0xc(%eax),%eax
801019a7:	83 e0 01             	and    $0x1,%eax
801019aa:	85 c0                	test   %eax,%eax
801019ac:	74 0a                	je     801019b8 <iunlock+0x23>
801019ae:	8b 45 08             	mov    0x8(%ebp),%eax
801019b1:	8b 40 08             	mov    0x8(%eax),%eax
801019b4:	85 c0                	test   %eax,%eax
801019b6:	7f 0c                	jg     801019c4 <iunlock+0x2f>
    panic("iunlock");
801019b8:	c7 04 24 48 8c 10 80 	movl   $0x80108c48,(%esp)
801019bf:	e8 72 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019c4:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019cb:	e8 f7 35 00 00       	call   80104fc7 <acquire>
  ip->flags &= ~I_BUSY;
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	8b 40 0c             	mov    0xc(%eax),%eax
801019d6:	89 c2                	mov    %eax,%edx
801019d8:	83 e2 fe             	and    $0xfffffffe,%edx
801019db:	8b 45 08             	mov    0x8(%ebp),%eax
801019de:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	89 04 24             	mov    %eax,(%esp)
801019e7:	e8 b5 2f 00 00       	call   801049a1 <wakeup>
  release(&icache.lock);
801019ec:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019f3:	e8 31 36 00 00       	call   80105029 <release>
}
801019f8:	c9                   	leave  
801019f9:	c3                   	ret    

801019fa <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
801019fa:	55                   	push   %ebp
801019fb:	89 e5                	mov    %esp,%ebp
801019fd:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a00:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a07:	e8 bb 35 00 00       	call   80104fc7 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 40 08             	mov    0x8(%eax),%eax
80101a12:	83 f8 01             	cmp    $0x1,%eax
80101a15:	0f 85 93 00 00 00    	jne    80101aae <iput+0xb4>
80101a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101a21:	83 e0 02             	and    $0x2,%eax
80101a24:	85 c0                	test   %eax,%eax
80101a26:	0f 84 82 00 00 00    	je     80101aae <iput+0xb4>
80101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2f:	66 8b 40 16          	mov    0x16(%eax),%ax
80101a33:	66 85 c0             	test   %ax,%ax
80101a36:	75 76                	jne    80101aae <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a38:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3e:	83 e0 01             	and    $0x1,%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <iput+0x57>
      panic("iput busy");
80101a45:	c7 04 24 50 8c 10 80 	movl   $0x80108c50,(%esp)
80101a4c:	e8 e5 ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 0c             	mov    0xc(%eax),%eax
80101a57:	89 c2                	mov    %eax,%edx
80101a59:	83 ca 01             	or     $0x1,%edx
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a62:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a69:	e8 bb 35 00 00       	call   80105029 <release>
    itrunc(ip);
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	89 04 24             	mov    %eax,(%esp)
80101a74:	e8 7d 01 00 00       	call   80101bf6 <itrunc>
    ip->type = 0;
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a82:	8b 45 08             	mov    0x8(%ebp),%eax
80101a85:	89 04 24             	mov    %eax,(%esp)
80101a88:	e8 03 fc ff ff       	call   80101690 <iupdate>
    acquire(&icache.lock);
80101a8d:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a94:	e8 2e 35 00 00       	call   80104fc7 <acquire>
    ip->flags = 0;
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	89 04 24             	mov    %eax,(%esp)
80101aa9:	e8 f3 2e 00 00       	call   801049a1 <wakeup>
  }
  ip->ref--;
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	8b 40 08             	mov    0x8(%eax),%eax
80101ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101abd:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101ac4:	e8 60 35 00 00       	call   80105029 <release>
}
80101ac9:	c9                   	leave  
80101aca:	c3                   	ret    

80101acb <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101acb:	55                   	push   %ebp
80101acc:	89 e5                	mov    %esp,%ebp
80101ace:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	89 04 24             	mov    %eax,(%esp)
80101ad7:	e8 b9 fe ff ff       	call   80101995 <iunlock>
  iput(ip);
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	89 04 24             	mov    %eax,(%esp)
80101ae2:	e8 13 ff ff ff       	call   801019fa <iput>
}
80101ae7:	c9                   	leave  
80101ae8:	c3                   	ret    

80101ae9 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ae9:	55                   	push   %ebp
80101aea:	89 e5                	mov    %esp,%ebp
80101aec:	53                   	push   %ebx
80101aed:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101af0:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101af4:	77 3e                	ja     80101b34 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101afc:	83 c2 04             	add    $0x4,%edx
80101aff:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b0a:	75 20                	jne    80101b2c <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0f:	8b 00                	mov    (%eax),%eax
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 5a f8 ff ff       	call   80101373 <balloc>
80101b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b22:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b28:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b2f:	e9 bc 00 00 00       	jmp    80101bf0 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b34:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b38:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b3c:	0f 87 a2 00 00 00    	ja     80101be4 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b4f:	75 19                	jne    80101b6a <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8b 00                	mov    (%eax),%eax
80101b56:	89 04 24             	mov    %eax,(%esp)
80101b59:	e8 15 f8 ff ff       	call   80101373 <balloc>
80101b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b67:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6d:	8b 00                	mov    (%eax),%eax
80101b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b72:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b76:	89 04 24             	mov    %eax,(%esp)
80101b79:	e8 28 e6 ff ff       	call   801001a6 <bread>
80101b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b84:	83 c0 18             	add    $0x18,%eax
80101b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b97:	01 d0                	add    %edx,%eax
80101b99:	8b 00                	mov    (%eax),%eax
80101b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba2:	75 30                	jne    80101bd4 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bb1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb7:	8b 00                	mov    (%eax),%eax
80101bb9:	89 04 24             	mov    %eax,(%esp)
80101bbc:	e8 b2 f7 ff ff       	call   80101373 <balloc>
80101bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc7:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bcc:	89 04 24             	mov    %eax,(%esp)
80101bcf:	e8 a4 16 00 00       	call   80103278 <log_write>
    }
    brelse(bp);
80101bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd7:	89 04 24             	mov    %eax,(%esp)
80101bda:	e8 38 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be2:	eb 0c                	jmp    80101bf0 <bmap+0x107>
  }

  panic("bmap: out of range");
80101be4:	c7 04 24 5a 8c 10 80 	movl   $0x80108c5a,(%esp)
80101beb:	e8 46 e9 ff ff       	call   80100536 <panic>
}
80101bf0:	83 c4 24             	add    $0x24,%esp
80101bf3:	5b                   	pop    %ebx
80101bf4:	5d                   	pop    %ebp
80101bf5:	c3                   	ret    

80101bf6 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101bf6:	55                   	push   %ebp
80101bf7:	89 e5                	mov    %esp,%ebp
80101bf9:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c03:	eb 43                	jmp    80101c48 <itrunc+0x52>
    if(ip->addrs[i]){
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0b:	83 c2 04             	add    $0x4,%edx
80101c0e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c12:	85 c0                	test   %eax,%eax
80101c14:	74 2f                	je     80101c45 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c1c:	83 c2 04             	add    $0x4,%edx
80101c1f:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c23:	8b 45 08             	mov    0x8(%ebp),%eax
80101c26:	8b 00                	mov    (%eax),%eax
80101c28:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c2c:	89 04 24             	mov    %eax,(%esp)
80101c2f:	e8 90 f8 ff ff       	call   801014c4 <bfree>
      ip->addrs[i] = 0;
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3a:	83 c2 04             	add    $0x4,%edx
80101c3d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c44:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c45:	ff 45 f4             	incl   -0xc(%ebp)
80101c48:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c4c:	7e b7                	jle    80101c05 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c51:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c54:	85 c0                	test   %eax,%eax
80101c56:	0f 84 9a 00 00 00    	je     80101cf6 <itrunc+0x100>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 00                	mov    (%eax),%eax
80101c67:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c6b:	89 04 24             	mov    %eax,(%esp)
80101c6e:	e8 33 e5 ff ff       	call   801001a6 <bread>
80101c73:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c79:	83 c0 18             	add    $0x18,%eax
80101c7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c86:	eb 3a                	jmp    80101cc2 <itrunc+0xcc>
      if(a[j])
80101c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101c95:	01 d0                	add    %edx,%eax
80101c97:	8b 00                	mov    (%eax),%eax
80101c99:	85 c0                	test   %eax,%eax
80101c9b:	74 22                	je     80101cbf <itrunc+0xc9>
        bfree(ip->dev, a[j]);
80101c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101caa:	01 d0                	add    %edx,%eax
80101cac:	8b 10                	mov    (%eax),%edx
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 00                	mov    (%eax),%eax
80101cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb7:	89 04 24             	mov    %eax,(%esp)
80101cba:	e8 05 f8 ff ff       	call   801014c4 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cbf:	ff 45 f0             	incl   -0x10(%ebp)
80101cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc5:	83 f8 7f             	cmp    $0x7f,%eax
80101cc8:	76 be                	jbe    80101c88 <itrunc+0x92>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ccd:	89 04 24             	mov    %eax,(%esp)
80101cd0:	e8 42 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	8b 00                	mov    (%eax),%eax
80101ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce4:	89 04 24             	mov    %eax,(%esp)
80101ce7:	e8 d8 f7 ff ff       	call   801014c4 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cec:	8b 45 08             	mov    0x8(%ebp),%eax
80101cef:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf9:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	89 04 24             	mov    %eax,(%esp)
80101d06:	e8 85 f9 ff ff       	call   80101690 <iupdate>
}
80101d0b:	c9                   	leave  
80101d0c:	c3                   	ret    

80101d0d <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d0d:	55                   	push   %ebp
80101d0e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 00                	mov    (%eax),%eax
80101d15:	89 c2                	mov    %eax,%edx
80101d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d20:	8b 50 04             	mov    0x4(%eax),%edx
80101d23:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d26:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 40 10             	mov    0x10(%eax),%eax
80101d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d32:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	66 8b 40 16          	mov    0x16(%eax),%ax
80101d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d3f:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101d43:	8b 45 08             	mov    0x8(%ebp),%eax
80101d46:	8b 50 18             	mov    0x18(%eax),%edx
80101d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4c:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d4f:	5d                   	pop    %ebp
80101d50:	c3                   	ret    

80101d51 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d51:	55                   	push   %ebp
80101d52:	89 e5                	mov    %esp,%ebp
80101d54:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d57:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5a:	8b 40 10             	mov    0x10(%eax),%eax
80101d5d:	66 83 f8 03          	cmp    $0x3,%ax
80101d61:	75 60                	jne    80101dc3 <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d6a:	66 85 c0             	test   %ax,%ax
80101d6d:	78 20                	js     80101d8f <readi+0x3e>
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d76:	66 83 f8 09          	cmp    $0x9,%ax
80101d7a:	7f 13                	jg     80101d8f <readi+0x3e>
80101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7f:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d83:	98                   	cwtl   
80101d84:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101d8b:	85 c0                	test   %eax,%eax
80101d8d:	75 0a                	jne    80101d99 <readi+0x48>
      return -1;
80101d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d94:	e9 1b 01 00 00       	jmp    80101eb4 <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9c:	66 8b 40 12          	mov    0x12(%eax),%ax
80101da0:	98                   	cwtl   
80101da1:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101da8:	8b 55 14             	mov    0x14(%ebp),%edx
80101dab:	89 54 24 08          	mov    %edx,0x8(%esp)
80101daf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101db2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101db6:	8b 55 08             	mov    0x8(%ebp),%edx
80101db9:	89 14 24             	mov    %edx,(%esp)
80101dbc:	ff d0                	call   *%eax
80101dbe:	e9 f1 00 00 00       	jmp    80101eb4 <readi+0x163>
  }

  if(off > ip->size || off + n < off)
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	8b 40 18             	mov    0x18(%eax),%eax
80101dc9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dcc:	72 0d                	jb     80101ddb <readi+0x8a>
80101dce:	8b 45 14             	mov    0x14(%ebp),%eax
80101dd1:	8b 55 10             	mov    0x10(%ebp),%edx
80101dd4:	01 d0                	add    %edx,%eax
80101dd6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dd9:	73 0a                	jae    80101de5 <readi+0x94>
    return -1;
80101ddb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de0:	e9 cf 00 00 00       	jmp    80101eb4 <readi+0x163>
  if(off + n > ip->size)
80101de5:	8b 45 14             	mov    0x14(%ebp),%eax
80101de8:	8b 55 10             	mov    0x10(%ebp),%edx
80101deb:	01 c2                	add    %eax,%edx
80101ded:	8b 45 08             	mov    0x8(%ebp),%eax
80101df0:	8b 40 18             	mov    0x18(%eax),%eax
80101df3:	39 c2                	cmp    %eax,%edx
80101df5:	76 0c                	jbe    80101e03 <readi+0xb2>
    n = ip->size - off;
80101df7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfa:	8b 40 18             	mov    0x18(%eax),%eax
80101dfd:	2b 45 10             	sub    0x10(%ebp),%eax
80101e00:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e0a:	e9 96 00 00 00       	jmp    80101ea5 <readi+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e0f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e12:	c1 e8 09             	shr    $0x9,%eax
80101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	89 04 24             	mov    %eax,(%esp)
80101e1f:	e8 c5 fc ff ff       	call   80101ae9 <bmap>
80101e24:	8b 55 08             	mov    0x8(%ebp),%edx
80101e27:	8b 12                	mov    (%edx),%edx
80101e29:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2d:	89 14 24             	mov    %edx,(%esp)
80101e30:	e8 71 e3 ff ff       	call   801001a6 <bread>
80101e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e38:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3b:	89 c2                	mov    %eax,%edx
80101e3d:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e43:	b8 00 02 00 00       	mov    $0x200,%eax
80101e48:	89 c1                	mov    %eax,%ecx
80101e4a:	29 d1                	sub    %edx,%ecx
80101e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e4f:	8b 55 14             	mov    0x14(%ebp),%edx
80101e52:	29 c2                	sub    %eax,%edx
80101e54:	89 c8                	mov    %ecx,%eax
80101e56:	39 d0                	cmp    %edx,%eax
80101e58:	76 02                	jbe    80101e5c <readi+0x10b>
80101e5a:	89 d0                	mov    %edx,%eax
80101e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e5f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e62:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e67:	8d 50 10             	lea    0x10(%eax),%edx
80101e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6d:	01 d0                	add    %edx,%eax
80101e6f:	8d 50 08             	lea    0x8(%eax),%edx
80101e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e75:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e79:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 5e 34 00 00       	call   801052e6 <memmove>
    brelse(bp);
80101e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8b:	89 04 24             	mov    %eax,(%esp)
80101e8e:	e8 84 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e96:	01 45 f4             	add    %eax,-0xc(%ebp)
80101e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9c:	01 45 10             	add    %eax,0x10(%ebp)
80101e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea2:	01 45 0c             	add    %eax,0xc(%ebp)
80101ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea8:	3b 45 14             	cmp    0x14(%ebp),%eax
80101eab:	0f 82 5e ff ff ff    	jb     80101e0f <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101eb1:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eb4:	c9                   	leave  
80101eb5:	c3                   	ret    

80101eb6 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eb6:	55                   	push   %ebp
80101eb7:	89 e5                	mov    %esp,%ebp
80101eb9:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	8b 40 10             	mov    0x10(%eax),%eax
80101ec2:	66 83 f8 03          	cmp    $0x3,%ax
80101ec6:	75 60                	jne    80101f28 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ecf:	66 85 c0             	test   %ax,%ax
80101ed2:	78 20                	js     80101ef4 <writei+0x3e>
80101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed7:	66 8b 40 12          	mov    0x12(%eax),%ax
80101edb:	66 83 f8 09          	cmp    $0x9,%ax
80101edf:	7f 13                	jg     80101ef4 <writei+0x3e>
80101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee4:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ee8:	98                   	cwtl   
80101ee9:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101ef0:	85 c0                	test   %eax,%eax
80101ef2:	75 0a                	jne    80101efe <writei+0x48>
      return -1;
80101ef4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef9:	e9 46 01 00 00       	jmp    80102044 <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101efe:	8b 45 08             	mov    0x8(%ebp),%eax
80101f01:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f05:	98                   	cwtl   
80101f06:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101f0d:	8b 55 14             	mov    0x14(%ebp),%edx
80101f10:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f14:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f17:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f1b:	8b 55 08             	mov    0x8(%ebp),%edx
80101f1e:	89 14 24             	mov    %edx,(%esp)
80101f21:	ff d0                	call   *%eax
80101f23:	e9 1c 01 00 00       	jmp    80102044 <writei+0x18e>
  }

  if(off > ip->size || off + n < off)
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8b 40 18             	mov    0x18(%eax),%eax
80101f2e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f31:	72 0d                	jb     80101f40 <writei+0x8a>
80101f33:	8b 45 14             	mov    0x14(%ebp),%eax
80101f36:	8b 55 10             	mov    0x10(%ebp),%edx
80101f39:	01 d0                	add    %edx,%eax
80101f3b:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f3e:	73 0a                	jae    80101f4a <writei+0x94>
    return -1;
80101f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f45:	e9 fa 00 00 00       	jmp    80102044 <writei+0x18e>
  if(off + n > MAXFILE*BSIZE)
80101f4a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f4d:	8b 55 10             	mov    0x10(%ebp),%edx
80101f50:	01 d0                	add    %edx,%eax
80101f52:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f57:	76 0a                	jbe    80101f63 <writei+0xad>
    return -1;
80101f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5e:	e9 e1 00 00 00       	jmp    80102044 <writei+0x18e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f6a:	e9 a1 00 00 00       	jmp    80102010 <writei+0x15a>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f6f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f72:	c1 e8 09             	shr    $0x9,%eax
80101f75:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	89 04 24             	mov    %eax,(%esp)
80101f7f:	e8 65 fb ff ff       	call   80101ae9 <bmap>
80101f84:	8b 55 08             	mov    0x8(%ebp),%edx
80101f87:	8b 12                	mov    (%edx),%edx
80101f89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f8d:	89 14 24             	mov    %edx,(%esp)
80101f90:	e8 11 e2 ff ff       	call   801001a6 <bread>
80101f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f98:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9b:	89 c2                	mov    %eax,%edx
80101f9d:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fa3:	b8 00 02 00 00       	mov    $0x200,%eax
80101fa8:	89 c1                	mov    %eax,%ecx
80101faa:	29 d1                	sub    %edx,%ecx
80101fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101faf:	8b 55 14             	mov    0x14(%ebp),%edx
80101fb2:	29 c2                	sub    %eax,%edx
80101fb4:	89 c8                	mov    %ecx,%eax
80101fb6:	39 d0                	cmp    %edx,%eax
80101fb8:	76 02                	jbe    80101fbc <writei+0x106>
80101fba:	89 d0                	mov    %edx,%eax
80101fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc7:	8d 50 10             	lea    0x10(%eax),%edx
80101fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fcd:	01 d0                	add    %edx,%eax
80101fcf:	8d 50 08             	lea    0x8(%eax),%edx
80101fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd5:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe0:	89 14 24             	mov    %edx,(%esp)
80101fe3:	e8 fe 32 00 00       	call   801052e6 <memmove>
    log_write(bp);
80101fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101feb:	89 04 24             	mov    %eax,(%esp)
80101fee:	e8 85 12 00 00       	call   80103278 <log_write>
    brelse(bp);
80101ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff6:	89 04 24             	mov    %eax,(%esp)
80101ff9:	e8 19 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102001:	01 45 f4             	add    %eax,-0xc(%ebp)
80102004:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102007:	01 45 10             	add    %eax,0x10(%ebp)
8010200a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200d:	01 45 0c             	add    %eax,0xc(%ebp)
80102010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102013:	3b 45 14             	cmp    0x14(%ebp),%eax
80102016:	0f 82 53 ff ff ff    	jb     80101f6f <writei+0xb9>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010201c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102020:	74 1f                	je     80102041 <writei+0x18b>
80102022:	8b 45 08             	mov    0x8(%ebp),%eax
80102025:	8b 40 18             	mov    0x18(%eax),%eax
80102028:	3b 45 10             	cmp    0x10(%ebp),%eax
8010202b:	73 14                	jae    80102041 <writei+0x18b>
    ip->size = off;
8010202d:	8b 45 08             	mov    0x8(%ebp),%eax
80102030:	8b 55 10             	mov    0x10(%ebp),%edx
80102033:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102036:	8b 45 08             	mov    0x8(%ebp),%eax
80102039:	89 04 24             	mov    %eax,(%esp)
8010203c:	e8 4f f6 ff ff       	call   80101690 <iupdate>
  }
  return n;
80102041:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102044:	c9                   	leave  
80102045:	c3                   	ret    

80102046 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102046:	55                   	push   %ebp
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010204c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102053:	00 
80102054:	8b 45 0c             	mov    0xc(%ebp),%eax
80102057:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	89 04 24             	mov    %eax,(%esp)
80102061:	e8 1c 33 00 00       	call   80105382 <strncmp>
}
80102066:	c9                   	leave  
80102067:	c3                   	ret    

80102068 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102068:	55                   	push   %ebp
80102069:	89 e5                	mov    %esp,%ebp
8010206b:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010206e:	8b 45 08             	mov    0x8(%ebp),%eax
80102071:	8b 40 10             	mov    0x10(%eax),%eax
80102074:	66 83 f8 01          	cmp    $0x1,%ax
80102078:	74 0c                	je     80102086 <dirlookup+0x1e>
    panic("dirlookup not DIR");
8010207a:	c7 04 24 6d 8c 10 80 	movl   $0x80108c6d,(%esp)
80102081:	e8 b0 e4 ff ff       	call   80100536 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010208d:	e9 85 00 00 00       	jmp    80102117 <dirlookup+0xaf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102092:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102099:	00 
8010209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010209d:	89 44 24 08          	mov    %eax,0x8(%esp)
801020a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	89 04 24             	mov    %eax,(%esp)
801020ae:	e8 9e fc ff ff       	call   80101d51 <readi>
801020b3:	83 f8 10             	cmp    $0x10,%eax
801020b6:	74 0c                	je     801020c4 <dirlookup+0x5c>
      panic("dirlink read");
801020b8:	c7 04 24 7f 8c 10 80 	movl   $0x80108c7f,(%esp)
801020bf:	e8 72 e4 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
801020c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020c7:	66 85 c0             	test   %ax,%ax
801020ca:	74 46                	je     80102112 <dirlookup+0xaa>
      continue;
    if(namecmp(name, de.name) == 0){
801020cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020cf:	83 c0 02             	add    $0x2,%eax
801020d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d9:	89 04 24             	mov    %eax,(%esp)
801020dc:	e8 65 ff ff ff       	call   80102046 <namecmp>
801020e1:	85 c0                	test   %eax,%eax
801020e3:	75 2e                	jne    80102113 <dirlookup+0xab>
      // entry matches path element
      if(poff)
801020e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801020e9:	74 08                	je     801020f3 <dirlookup+0x8b>
        *poff = off;
801020eb:	8b 45 10             	mov    0x10(%ebp),%eax
801020ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020f1:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801020f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020f6:	0f b7 c0             	movzwl %ax,%eax
801020f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801020fc:	8b 45 08             	mov    0x8(%ebp),%eax
801020ff:	8b 00                	mov    (%eax),%eax
80102101:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102104:	89 54 24 04          	mov    %edx,0x4(%esp)
80102108:	89 04 24             	mov    %eax,(%esp)
8010210b:	e8 36 f6 ff ff       	call   80101746 <iget>
80102110:	eb 19                	jmp    8010212b <dirlookup+0xc3>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102112:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102113:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102117:	8b 45 08             	mov    0x8(%ebp),%eax
8010211a:	8b 40 18             	mov    0x18(%eax),%eax
8010211d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102120:	0f 87 6c ff ff ff    	ja     80102092 <dirlookup+0x2a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102126:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010212b:	c9                   	leave  
8010212c:	c3                   	ret    

8010212d <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010212d:	55                   	push   %ebp
8010212e:	89 e5                	mov    %esp,%ebp
80102130:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102133:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010213a:	00 
8010213b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010213e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102142:	8b 45 08             	mov    0x8(%ebp),%eax
80102145:	89 04 24             	mov    %eax,(%esp)
80102148:	e8 1b ff ff ff       	call   80102068 <dirlookup>
8010214d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102154:	74 15                	je     8010216b <dirlink+0x3e>
    iput(ip);
80102156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102159:	89 04 24             	mov    %eax,(%esp)
8010215c:	e8 99 f8 ff ff       	call   801019fa <iput>
    return -1;
80102161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102166:	e9 b7 00 00 00       	jmp    80102222 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010216b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102172:	eb 43                	jmp    801021b7 <dirlink+0x8a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102177:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010217e:	00 
8010217f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102183:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102186:	89 44 24 04          	mov    %eax,0x4(%esp)
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	89 04 24             	mov    %eax,(%esp)
80102190:	e8 bc fb ff ff       	call   80101d51 <readi>
80102195:	83 f8 10             	cmp    $0x10,%eax
80102198:	74 0c                	je     801021a6 <dirlink+0x79>
      panic("dirlink read");
8010219a:	c7 04 24 7f 8c 10 80 	movl   $0x80108c7f,(%esp)
801021a1:	e8 90 e3 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
801021a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021a9:	66 85 c0             	test   %ax,%ax
801021ac:	74 18                	je     801021c6 <dirlink+0x99>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b1:	83 c0 10             	add    $0x10,%eax
801021b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021ba:	8b 45 08             	mov    0x8(%ebp),%eax
801021bd:	8b 40 18             	mov    0x18(%eax),%eax
801021c0:	39 c2                	cmp    %eax,%edx
801021c2:	72 b0                	jb     80102174 <dirlink+0x47>
801021c4:	eb 01                	jmp    801021c7 <dirlink+0x9a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801021c6:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021c7:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021ce:	00 
801021cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801021d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021d9:	83 c0 02             	add    $0x2,%eax
801021dc:	89 04 24             	mov    %eax,(%esp)
801021df:	e8 ee 31 00 00       	call   801053d2 <strncpy>
  de.inum = inum;
801021e4:	8b 45 10             	mov    0x10(%ebp),%eax
801021e7:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021f5:	00 
801021f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801021fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102201:	8b 45 08             	mov    0x8(%ebp),%eax
80102204:	89 04 24             	mov    %eax,(%esp)
80102207:	e8 aa fc ff ff       	call   80101eb6 <writei>
8010220c:	83 f8 10             	cmp    $0x10,%eax
8010220f:	74 0c                	je     8010221d <dirlink+0xf0>
    panic("dirlink");
80102211:	c7 04 24 8c 8c 10 80 	movl   $0x80108c8c,(%esp)
80102218:	e8 19 e3 ff ff       	call   80100536 <panic>
  
  return 0;
8010221d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102222:	c9                   	leave  
80102223:	c3                   	ret    

80102224 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102224:	55                   	push   %ebp
80102225:	89 e5                	mov    %esp,%ebp
80102227:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010222a:	eb 03                	jmp    8010222f <skipelem+0xb>
    path++;
8010222c:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010222f:	8b 45 08             	mov    0x8(%ebp),%eax
80102232:	8a 00                	mov    (%eax),%al
80102234:	3c 2f                	cmp    $0x2f,%al
80102236:	74 f4                	je     8010222c <skipelem+0x8>
    path++;
  if(*path == 0)
80102238:	8b 45 08             	mov    0x8(%ebp),%eax
8010223b:	8a 00                	mov    (%eax),%al
8010223d:	84 c0                	test   %al,%al
8010223f:	75 0a                	jne    8010224b <skipelem+0x27>
    return 0;
80102241:	b8 00 00 00 00       	mov    $0x0,%eax
80102246:	e9 83 00 00 00       	jmp    801022ce <skipelem+0xaa>
  s = path;
8010224b:	8b 45 08             	mov    0x8(%ebp),%eax
8010224e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102251:	eb 03                	jmp    80102256 <skipelem+0x32>
    path++;
80102253:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102256:	8b 45 08             	mov    0x8(%ebp),%eax
80102259:	8a 00                	mov    (%eax),%al
8010225b:	3c 2f                	cmp    $0x2f,%al
8010225d:	74 09                	je     80102268 <skipelem+0x44>
8010225f:	8b 45 08             	mov    0x8(%ebp),%eax
80102262:	8a 00                	mov    (%eax),%al
80102264:	84 c0                	test   %al,%al
80102266:	75 eb                	jne    80102253 <skipelem+0x2f>
    path++;
  len = path - s;
80102268:	8b 55 08             	mov    0x8(%ebp),%edx
8010226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010226e:	89 d1                	mov    %edx,%ecx
80102270:	29 c1                	sub    %eax,%ecx
80102272:	89 c8                	mov    %ecx,%eax
80102274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102277:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010227b:	7e 1c                	jle    80102299 <skipelem+0x75>
    memmove(name, s, DIRSIZ);
8010227d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102284:	00 
80102285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102288:	89 44 24 04          	mov    %eax,0x4(%esp)
8010228c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010228f:	89 04 24             	mov    %eax,(%esp)
80102292:	e8 4f 30 00 00       	call   801052e6 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102297:	eb 29                	jmp    801022c2 <skipelem+0x9e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102299:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010229c:	89 44 24 08          	mov    %eax,0x8(%esp)
801022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022aa:	89 04 24             	mov    %eax,(%esp)
801022ad:	e8 34 30 00 00       	call   801052e6 <memmove>
    name[len] = 0;
801022b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b8:	01 d0                	add    %edx,%eax
801022ba:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022bd:	eb 03                	jmp    801022c2 <skipelem+0x9e>
    path++;
801022bf:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c2:	8b 45 08             	mov    0x8(%ebp),%eax
801022c5:	8a 00                	mov    (%eax),%al
801022c7:	3c 2f                	cmp    $0x2f,%al
801022c9:	74 f4                	je     801022bf <skipelem+0x9b>
    path++;
  return path;
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ce:	c9                   	leave  
801022cf:	c3                   	ret    

801022d0 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022d6:	8b 45 08             	mov    0x8(%ebp),%eax
801022d9:	8a 00                	mov    (%eax),%al
801022db:	3c 2f                	cmp    $0x2f,%al
801022dd:	75 1c                	jne    801022fb <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801022df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022e6:	00 
801022e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801022ee:	e8 53 f4 ff ff       	call   80101746 <iget>
801022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801022f6:	e9 ad 00 00 00       	jmp    801023a8 <namex+0xd8>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801022fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102301:	8b 40 68             	mov    0x68(%eax),%eax
80102304:	89 04 24             	mov    %eax,(%esp)
80102307:	e8 0c f5 ff ff       	call   80101818 <idup>
8010230c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010230f:	e9 94 00 00 00       	jmp    801023a8 <namex+0xd8>
    ilock(ip);
80102314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102317:	89 04 24             	mov    %eax,(%esp)
8010231a:	e8 2b f5 ff ff       	call   8010184a <ilock>
    if(ip->type != T_DIR){
8010231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102322:	8b 40 10             	mov    0x10(%eax),%eax
80102325:	66 83 f8 01          	cmp    $0x1,%ax
80102329:	74 15                	je     80102340 <namex+0x70>
      iunlockput(ip);
8010232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232e:	89 04 24             	mov    %eax,(%esp)
80102331:	e8 95 f7 ff ff       	call   80101acb <iunlockput>
      return 0;
80102336:	b8 00 00 00 00       	mov    $0x0,%eax
8010233b:	e9 a2 00 00 00       	jmp    801023e2 <namex+0x112>
    }
    if(nameiparent && *path == '\0'){
80102340:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102344:	74 1c                	je     80102362 <namex+0x92>
80102346:	8b 45 08             	mov    0x8(%ebp),%eax
80102349:	8a 00                	mov    (%eax),%al
8010234b:	84 c0                	test   %al,%al
8010234d:	75 13                	jne    80102362 <namex+0x92>
      // Stop one level early.
      iunlock(ip);
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	89 04 24             	mov    %eax,(%esp)
80102355:	e8 3b f6 ff ff       	call   80101995 <iunlock>
      return ip;
8010235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010235d:	e9 80 00 00 00       	jmp    801023e2 <namex+0x112>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102362:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102369:	00 
8010236a:	8b 45 10             	mov    0x10(%ebp),%eax
8010236d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102374:	89 04 24             	mov    %eax,(%esp)
80102377:	e8 ec fc ff ff       	call   80102068 <dirlookup>
8010237c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010237f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102383:	75 12                	jne    80102397 <namex+0xc7>
      iunlockput(ip);
80102385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102388:	89 04 24             	mov    %eax,(%esp)
8010238b:	e8 3b f7 ff ff       	call   80101acb <iunlockput>
      return 0;
80102390:	b8 00 00 00 00       	mov    $0x0,%eax
80102395:	eb 4b                	jmp    801023e2 <namex+0x112>
    }
    iunlockput(ip);
80102397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239a:	89 04 24             	mov    %eax,(%esp)
8010239d:	e8 29 f7 ff ff       	call   80101acb <iunlockput>
    ip = next;
801023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023a8:	8b 45 10             	mov    0x10(%ebp),%eax
801023ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801023af:	8b 45 08             	mov    0x8(%ebp),%eax
801023b2:	89 04 24             	mov    %eax,(%esp)
801023b5:	e8 6a fe ff ff       	call   80102224 <skipelem>
801023ba:	89 45 08             	mov    %eax,0x8(%ebp)
801023bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023c1:	0f 85 4d ff ff ff    	jne    80102314 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023cb:	74 12                	je     801023df <namex+0x10f>
    iput(ip);
801023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d0:	89 04 24             	mov    %eax,(%esp)
801023d3:	e8 22 f6 ff ff       	call   801019fa <iput>
    return 0;
801023d8:	b8 00 00 00 00       	mov    $0x0,%eax
801023dd:	eb 03                	jmp    801023e2 <namex+0x112>
  }
  return ip;
801023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023e2:	c9                   	leave  
801023e3:	c3                   	ret    

801023e4 <namei>:

struct inode*
namei(char *path)
{
801023e4:	55                   	push   %ebp
801023e5:	89 e5                	mov    %esp,%ebp
801023e7:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023ea:	8d 45 ea             	lea    -0x16(%ebp),%eax
801023ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801023f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801023f8:	00 
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
801023fc:	89 04 24             	mov    %eax,(%esp)
801023ff:	e8 cc fe ff ff       	call   801022d0 <namex>
}
80102404:	c9                   	leave  
80102405:	c3                   	ret    

80102406 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102406:	55                   	push   %ebp
80102407:	89 e5                	mov    %esp,%ebp
80102409:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010240c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010240f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102413:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010241a:	00 
8010241b:	8b 45 08             	mov    0x8(%ebp),%eax
8010241e:	89 04 24             	mov    %eax,(%esp)
80102421:	e8 aa fe ff ff       	call   801022d0 <namex>
}
80102426:	c9                   	leave  
80102427:	c3                   	ret    

80102428 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102428:	55                   	push   %ebp
80102429:	89 e5                	mov    %esp,%ebp
8010242b:	53                   	push   %ebx
8010242c:	83 ec 14             	sub    $0x14,%esp
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
80102432:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102436:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102439:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010243d:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102441:	ec                   	in     (%dx),%al
80102442:	88 c3                	mov    %al,%bl
80102444:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102447:	8a 45 fb             	mov    -0x5(%ebp),%al
}
8010244a:	83 c4 14             	add    $0x14,%esp
8010244d:	5b                   	pop    %ebx
8010244e:	5d                   	pop    %ebp
8010244f:	c3                   	ret    

80102450 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102455:	8b 55 08             	mov    0x8(%ebp),%edx
80102458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010245b:	8b 45 10             	mov    0x10(%ebp),%eax
8010245e:	89 cb                	mov    %ecx,%ebx
80102460:	89 df                	mov    %ebx,%edi
80102462:	89 c1                	mov    %eax,%ecx
80102464:	fc                   	cld    
80102465:	f3 6d                	rep insl (%dx),%es:(%edi)
80102467:	89 c8                	mov    %ecx,%eax
80102469:	89 fb                	mov    %edi,%ebx
8010246b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010246e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102471:	5b                   	pop    %ebx
80102472:	5f                   	pop    %edi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    

80102475 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102475:	55                   	push   %ebp
80102476:	89 e5                	mov    %esp,%ebp
80102478:	83 ec 08             	sub    $0x8,%esp
8010247b:	8b 45 08             	mov    0x8(%ebp),%eax
8010247e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102481:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102485:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102488:	8a 45 f8             	mov    -0x8(%ebp),%al
8010248b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010248e:	ee                   	out    %al,(%dx)
}
8010248f:	c9                   	leave  
80102490:	c3                   	ret    

80102491 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102491:	55                   	push   %ebp
80102492:	89 e5                	mov    %esp,%ebp
80102494:	56                   	push   %esi
80102495:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102496:	8b 55 08             	mov    0x8(%ebp),%edx
80102499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010249c:	8b 45 10             	mov    0x10(%ebp),%eax
8010249f:	89 cb                	mov    %ecx,%ebx
801024a1:	89 de                	mov    %ebx,%esi
801024a3:	89 c1                	mov    %eax,%ecx
801024a5:	fc                   	cld    
801024a6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024a8:	89 c8                	mov    %ecx,%eax
801024aa:	89 f3                	mov    %esi,%ebx
801024ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024af:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024b2:	5b                   	pop    %ebx
801024b3:	5e                   	pop    %esi
801024b4:	5d                   	pop    %ebp
801024b5:	c3                   	ret    

801024b6 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024b6:	55                   	push   %ebp
801024b7:	89 e5                	mov    %esp,%ebp
801024b9:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024bc:	90                   	nop
801024bd:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024c4:	e8 5f ff ff ff       	call   80102428 <inb>
801024c9:	0f b6 c0             	movzbl %al,%eax
801024cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024d2:	25 c0 00 00 00       	and    $0xc0,%eax
801024d7:	83 f8 40             	cmp    $0x40,%eax
801024da:	75 e1                	jne    801024bd <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024e0:	74 11                	je     801024f3 <idewait+0x3d>
801024e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024e5:	83 e0 21             	and    $0x21,%eax
801024e8:	85 c0                	test   %eax,%eax
801024ea:	74 07                	je     801024f3 <idewait+0x3d>
    return -1;
801024ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024f1:	eb 05                	jmp    801024f8 <idewait+0x42>
  return 0;
801024f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <ideinit>:

void
ideinit(void)
{
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102500:	c7 44 24 04 94 8c 10 	movl   $0x80108c94,0x4(%esp)
80102507:	80 
80102508:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010250f:	e8 92 2a 00 00       	call   80104fa6 <initlock>
  picenable(IRQ_IDE);
80102514:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010251b:	e8 9c 15 00 00       	call   80103abc <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102520:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80102525:	48                   	dec    %eax
80102526:	89 44 24 04          	mov    %eax,0x4(%esp)
8010252a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102531:	e8 0b 04 00 00       	call   80102941 <ioapicenable>
  idewait(0);
80102536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010253d:	e8 74 ff ff ff       	call   801024b6 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102542:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102549:	00 
8010254a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102551:	e8 1f ff ff ff       	call   80102475 <outb>
  for(i=0; i<1000; i++){
80102556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010255d:	eb 1f                	jmp    8010257e <ideinit+0x84>
    if(inb(0x1f7) != 0){
8010255f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102566:	e8 bd fe ff ff       	call   80102428 <inb>
8010256b:	84 c0                	test   %al,%al
8010256d:	74 0c                	je     8010257b <ideinit+0x81>
      havedisk1 = 1;
8010256f:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102576:	00 00 00 
      break;
80102579:	eb 0c                	jmp    80102587 <ideinit+0x8d>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010257b:	ff 45 f4             	incl   -0xc(%ebp)
8010257e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102585:	7e d8                	jle    8010255f <ideinit+0x65>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102587:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010258e:	00 
8010258f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102596:	e8 da fe ff ff       	call   80102475 <outb>
}
8010259b:	c9                   	leave  
8010259c:	c3                   	ret    

8010259d <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010259d:	55                   	push   %ebp
8010259e:	89 e5                	mov    %esp,%ebp
801025a0:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a7:	75 0c                	jne    801025b5 <idestart+0x18>
    panic("idestart");
801025a9:	c7 04 24 98 8c 10 80 	movl   $0x80108c98,(%esp)
801025b0:	e8 81 df ff ff       	call   80100536 <panic>

  idewait(0);
801025b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025bc:	e8 f5 fe ff ff       	call   801024b6 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025c8:	00 
801025c9:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025d0:	e8 a0 fe ff ff       	call   80102475 <outb>
  outb(0x1f2, 1);  // number of sectors
801025d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025dc:	00 
801025dd:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801025e4:	e8 8c fe ff ff       	call   80102475 <outb>
  outb(0x1f3, b->sector & 0xff);
801025e9:	8b 45 08             	mov    0x8(%ebp),%eax
801025ec:	8b 40 08             	mov    0x8(%eax),%eax
801025ef:	0f b6 c0             	movzbl %al,%eax
801025f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801025f6:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801025fd:	e8 73 fe ff ff       	call   80102475 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102602:	8b 45 08             	mov    0x8(%ebp),%eax
80102605:	8b 40 08             	mov    0x8(%eax),%eax
80102608:	c1 e8 08             	shr    $0x8,%eax
8010260b:	0f b6 c0             	movzbl %al,%eax
8010260e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102612:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102619:	e8 57 fe ff ff       	call   80102475 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010261e:	8b 45 08             	mov    0x8(%ebp),%eax
80102621:	8b 40 08             	mov    0x8(%eax),%eax
80102624:	c1 e8 10             	shr    $0x10,%eax
80102627:	0f b6 c0             	movzbl %al,%eax
8010262a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010262e:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102635:	e8 3b fe ff ff       	call   80102475 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
8010263d:	8b 40 04             	mov    0x4(%eax),%eax
80102640:	83 e0 01             	and    $0x1,%eax
80102643:	88 c2                	mov    %al,%dl
80102645:	c1 e2 04             	shl    $0x4,%edx
80102648:	8b 45 08             	mov    0x8(%ebp),%eax
8010264b:	8b 40 08             	mov    0x8(%eax),%eax
8010264e:	c1 e8 18             	shr    $0x18,%eax
80102651:	83 e0 0f             	and    $0xf,%eax
80102654:	09 d0                	or     %edx,%eax
80102656:	83 c8 e0             	or     $0xffffffe0,%eax
80102659:	0f b6 c0             	movzbl %al,%eax
8010265c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102660:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102667:	e8 09 fe ff ff       	call   80102475 <outb>
  if(b->flags & B_DIRTY){
8010266c:	8b 45 08             	mov    0x8(%ebp),%eax
8010266f:	8b 00                	mov    (%eax),%eax
80102671:	83 e0 04             	and    $0x4,%eax
80102674:	85 c0                	test   %eax,%eax
80102676:	74 34                	je     801026ac <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102678:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010267f:	00 
80102680:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102687:	e8 e9 fd ff ff       	call   80102475 <outb>
    outsl(0x1f0, b->data, 512/4);
8010268c:	8b 45 08             	mov    0x8(%ebp),%eax
8010268f:	83 c0 18             	add    $0x18,%eax
80102692:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102699:	00 
8010269a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010269e:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026a5:	e8 e7 fd ff ff       	call   80102491 <outsl>
801026aa:	eb 14                	jmp    801026c0 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026ac:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026b3:	00 
801026b4:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026bb:	e8 b5 fd ff ff       	call   80102475 <outb>
  }
}
801026c0:	c9                   	leave  
801026c1:	c3                   	ret    

801026c2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026c2:	55                   	push   %ebp
801026c3:	89 e5                	mov    %esp,%ebp
801026c5:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026c8:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026cf:	e8 f3 28 00 00       	call   80104fc7 <acquire>
  if((b = idequeue) == 0){
801026d4:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026e0:	75 11                	jne    801026f3 <ideintr+0x31>
    release(&idelock);
801026e2:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026e9:	e8 3b 29 00 00       	call   80105029 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026ee:	e9 90 00 00 00       	jmp    80102783 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f6:	8b 40 14             	mov    0x14(%eax),%eax
801026f9:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102701:	8b 00                	mov    (%eax),%eax
80102703:	83 e0 04             	and    $0x4,%eax
80102706:	85 c0                	test   %eax,%eax
80102708:	75 2e                	jne    80102738 <ideintr+0x76>
8010270a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102711:	e8 a0 fd ff ff       	call   801024b6 <idewait>
80102716:	85 c0                	test   %eax,%eax
80102718:	78 1e                	js     80102738 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010271d:	83 c0 18             	add    $0x18,%eax
80102720:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102727:	00 
80102728:	89 44 24 04          	mov    %eax,0x4(%esp)
8010272c:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102733:	e8 18 fd ff ff       	call   80102450 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273b:	8b 00                	mov    (%eax),%eax
8010273d:	89 c2                	mov    %eax,%edx
8010273f:	83 ca 02             	or     $0x2,%edx
80102742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102745:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274a:	8b 00                	mov    (%eax),%eax
8010274c:	89 c2                	mov    %eax,%edx
8010274e:	83 e2 fb             	and    $0xfffffffb,%edx
80102751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102754:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102759:	89 04 24             	mov    %eax,(%esp)
8010275c:	e8 40 22 00 00       	call   801049a1 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102761:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102766:	85 c0                	test   %eax,%eax
80102768:	74 0d                	je     80102777 <ideintr+0xb5>
    idestart(idequeue);
8010276a:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010276f:	89 04 24             	mov    %eax,(%esp)
80102772:	e8 26 fe ff ff       	call   8010259d <idestart>

  release(&idelock);
80102777:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010277e:	e8 a6 28 00 00       	call   80105029 <release>
}
80102783:	c9                   	leave  
80102784:	c3                   	ret    

80102785 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
80102788:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010278b:	8b 45 08             	mov    0x8(%ebp),%eax
8010278e:	8b 00                	mov    (%eax),%eax
80102790:	83 e0 01             	and    $0x1,%eax
80102793:	85 c0                	test   %eax,%eax
80102795:	75 0c                	jne    801027a3 <iderw+0x1e>
    panic("iderw: buf not busy");
80102797:	c7 04 24 a1 8c 10 80 	movl   $0x80108ca1,(%esp)
8010279e:	e8 93 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027a3:	8b 45 08             	mov    0x8(%ebp),%eax
801027a6:	8b 00                	mov    (%eax),%eax
801027a8:	83 e0 06             	and    $0x6,%eax
801027ab:	83 f8 02             	cmp    $0x2,%eax
801027ae:	75 0c                	jne    801027bc <iderw+0x37>
    panic("iderw: nothing to do");
801027b0:	c7 04 24 b5 8c 10 80 	movl   $0x80108cb5,(%esp)
801027b7:	e8 7a dd ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
801027bc:	8b 45 08             	mov    0x8(%ebp),%eax
801027bf:	8b 40 04             	mov    0x4(%eax),%eax
801027c2:	85 c0                	test   %eax,%eax
801027c4:	74 15                	je     801027db <iderw+0x56>
801027c6:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801027cb:	85 c0                	test   %eax,%eax
801027cd:	75 0c                	jne    801027db <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027cf:	c7 04 24 ca 8c 10 80 	movl   $0x80108cca,(%esp)
801027d6:	e8 5b dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC: acquire-lock
801027db:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027e2:	e8 e0 27 00 00       	call   80104fc7 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027e7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ea:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
801027f1:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801027f8:	eb 0b                	jmp    80102805 <iderw+0x80>
801027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fd:	8b 00                	mov    (%eax),%eax
801027ff:	83 c0 14             	add    $0x14,%eax
80102802:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102808:	8b 00                	mov    (%eax),%eax
8010280a:	85 c0                	test   %eax,%eax
8010280c:	75 ec                	jne    801027fa <iderw+0x75>
    ;
  *pp = b;
8010280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102811:	8b 55 08             	mov    0x8(%ebp),%edx
80102814:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102816:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010281b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010281e:	75 22                	jne    80102842 <iderw+0xbd>
    idestart(b);
80102820:	8b 45 08             	mov    0x8(%ebp),%eax
80102823:	89 04 24             	mov    %eax,(%esp)
80102826:	e8 72 fd ff ff       	call   8010259d <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010282b:	eb 15                	jmp    80102842 <iderw+0xbd>
    sleep(b, &idelock);
8010282d:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102834:	80 
80102835:	8b 45 08             	mov    0x8(%ebp),%eax
80102838:	89 04 24             	mov    %eax,(%esp)
8010283b:	e8 88 20 00 00       	call   801048c8 <sleep>
80102840:	eb 01                	jmp    80102843 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102842:	90                   	nop
80102843:	8b 45 08             	mov    0x8(%ebp),%eax
80102846:	8b 00                	mov    (%eax),%eax
80102848:	83 e0 06             	and    $0x6,%eax
8010284b:	83 f8 02             	cmp    $0x2,%eax
8010284e:	75 dd                	jne    8010282d <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
80102850:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102857:	e8 cd 27 00 00       	call   80105029 <release>
}
8010285c:	c9                   	leave  
8010285d:	c3                   	ret    
8010285e:	66 90                	xchg   %ax,%ax

80102860 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102863:	a1 54 08 11 80       	mov    0x80110854,%eax
80102868:	8b 55 08             	mov    0x8(%ebp),%edx
8010286b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010286d:	a1 54 08 11 80       	mov    0x80110854,%eax
80102872:	8b 40 10             	mov    0x10(%eax),%eax
}
80102875:	5d                   	pop    %ebp
80102876:	c3                   	ret    

80102877 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102877:	55                   	push   %ebp
80102878:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010287a:	a1 54 08 11 80       	mov    0x80110854,%eax
8010287f:	8b 55 08             	mov    0x8(%ebp),%edx
80102882:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102884:	a1 54 08 11 80       	mov    0x80110854,%eax
80102889:	8b 55 0c             	mov    0xc(%ebp),%edx
8010288c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010288f:	5d                   	pop    %ebp
80102890:	c3                   	ret    

80102891 <ioapicinit>:

void
ioapicinit(void)
{
80102891:	55                   	push   %ebp
80102892:	89 e5                	mov    %esp,%ebp
80102894:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102897:	a1 24 09 11 80       	mov    0x80110924,%eax
8010289c:	85 c0                	test   %eax,%eax
8010289e:	0f 84 9a 00 00 00    	je     8010293e <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028a4:	c7 05 54 08 11 80 00 	movl   $0xfec00000,0x80110854
801028ab:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028b5:	e8 a6 ff ff ff       	call   80102860 <ioapicread>
801028ba:	c1 e8 10             	shr    $0x10,%eax
801028bd:	25 ff 00 00 00       	and    $0xff,%eax
801028c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028cc:	e8 8f ff ff ff       	call   80102860 <ioapicread>
801028d1:	c1 e8 18             	shr    $0x18,%eax
801028d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028d7:	a0 20 09 11 80       	mov    0x80110920,%al
801028dc:	0f b6 c0             	movzbl %al,%eax
801028df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028e2:	74 0c                	je     801028f0 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028e4:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
801028eb:	e8 b1 da ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801028f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801028f7:	eb 3b                	jmp    80102934 <ioapicinit+0xa3>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fc:	83 c0 20             	add    $0x20,%eax
801028ff:	0d 00 00 01 00       	or     $0x10000,%eax
80102904:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102907:	83 c2 08             	add    $0x8,%edx
8010290a:	d1 e2                	shl    %edx
8010290c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102910:	89 14 24             	mov    %edx,(%esp)
80102913:	e8 5f ff ff ff       	call   80102877 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291b:	83 c0 08             	add    $0x8,%eax
8010291e:	d1 e0                	shl    %eax
80102920:	40                   	inc    %eax
80102921:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102928:	00 
80102929:	89 04 24             	mov    %eax,(%esp)
8010292c:	e8 46 ff ff ff       	call   80102877 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102931:	ff 45 f4             	incl   -0xc(%ebp)
80102934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102937:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010293a:	7e bd                	jle    801028f9 <ioapicinit+0x68>
8010293c:	eb 01                	jmp    8010293f <ioapicinit+0xae>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
8010293e:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010293f:	c9                   	leave  
80102940:	c3                   	ret    

80102941 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102941:	55                   	push   %ebp
80102942:	89 e5                	mov    %esp,%ebp
80102944:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102947:	a1 24 09 11 80       	mov    0x80110924,%eax
8010294c:	85 c0                	test   %eax,%eax
8010294e:	74 37                	je     80102987 <ioapicenable+0x46>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102950:	8b 45 08             	mov    0x8(%ebp),%eax
80102953:	83 c0 20             	add    $0x20,%eax
80102956:	8b 55 08             	mov    0x8(%ebp),%edx
80102959:	83 c2 08             	add    $0x8,%edx
8010295c:	d1 e2                	shl    %edx
8010295e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102962:	89 14 24             	mov    %edx,(%esp)
80102965:	e8 0d ff ff ff       	call   80102877 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010296d:	c1 e0 18             	shl    $0x18,%eax
80102970:	8b 55 08             	mov    0x8(%ebp),%edx
80102973:	83 c2 08             	add    $0x8,%edx
80102976:	d1 e2                	shl    %edx
80102978:	42                   	inc    %edx
80102979:	89 44 24 04          	mov    %eax,0x4(%esp)
8010297d:	89 14 24             	mov    %edx,(%esp)
80102980:	e8 f2 fe ff ff       	call   80102877 <ioapicwrite>
80102985:	eb 01                	jmp    80102988 <ioapicenable+0x47>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102987:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102988:	c9                   	leave  
80102989:	c3                   	ret    
8010298a:	66 90                	xchg   %ax,%ax

8010298c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010298c:	55                   	push   %ebp
8010298d:	89 e5                	mov    %esp,%ebp
8010298f:	8b 45 08             	mov    0x8(%ebp),%eax
80102992:	05 00 00 00 80       	add    $0x80000000,%eax
80102997:	5d                   	pop    %ebp
80102998:	c3                   	ret    

80102999 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102999:	55                   	push   %ebp
8010299a:	89 e5                	mov    %esp,%ebp
8010299c:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
8010299f:	c7 44 24 04 1a 8d 10 	movl   $0x80108d1a,0x4(%esp)
801029a6:	80 
801029a7:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
801029ae:	e8 f3 25 00 00       	call   80104fa6 <initlock>
  kmem.use_lock = 0;
801029b3:	c7 05 94 08 11 80 00 	movl   $0x0,0x80110894
801029ba:	00 00 00 
  freerange(vstart, vend);
801029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801029c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c4:	8b 45 08             	mov    0x8(%ebp),%eax
801029c7:	89 04 24             	mov    %eax,(%esp)
801029ca:	e8 26 00 00 00       	call   801029f5 <freerange>
}
801029cf:	c9                   	leave  
801029d0:	c3                   	ret    

801029d1 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029d1:	55                   	push   %ebp
801029d2:	89 e5                	mov    %esp,%ebp
801029d4:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801029da:	89 44 24 04          	mov    %eax,0x4(%esp)
801029de:	8b 45 08             	mov    0x8(%ebp),%eax
801029e1:	89 04 24             	mov    %eax,(%esp)
801029e4:	e8 0c 00 00 00       	call   801029f5 <freerange>
  kmem.use_lock = 1;
801029e9:	c7 05 94 08 11 80 01 	movl   $0x1,0x80110894
801029f0:	00 00 00 
}
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    

801029f5 <freerange>:

void
freerange(void *vstart, void *vend)
{
801029f5:	55                   	push   %ebp
801029f6:	89 e5                	mov    %esp,%ebp
801029f8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801029fb:	8b 45 08             	mov    0x8(%ebp),%eax
801029fe:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0b:	eb 12                	jmp    80102a1f <freerange+0x2a>
    kfree(p);
80102a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a10:	89 04 24             	mov    %eax,(%esp)
80102a13:	e8 16 00 00 00       	call   80102a2e <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a18:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a22:	05 00 10 00 00       	add    $0x1000,%eax
80102a27:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a2a:	76 e1                	jbe    80102a0d <freerange+0x18>
    kfree(p);
}
80102a2c:	c9                   	leave  
80102a2d:	c3                   	ret    

80102a2e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a34:	8b 45 08             	mov    0x8(%ebp),%eax
80102a37:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a3c:	85 c0                	test   %eax,%eax
80102a3e:	75 1b                	jne    80102a5b <kfree+0x2d>
80102a40:	81 7d 08 54 b7 14 80 	cmpl   $0x8014b754,0x8(%ebp)
80102a47:	72 12                	jb     80102a5b <kfree+0x2d>
80102a49:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4c:	89 04 24             	mov    %eax,(%esp)
80102a4f:	e8 38 ff ff ff       	call   8010298c <v2p>
80102a54:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a59:	76 0c                	jbe    80102a67 <kfree+0x39>
    panic("kfree");
80102a5b:	c7 04 24 1f 8d 10 80 	movl   $0x80108d1f,(%esp)
80102a62:	e8 cf da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a67:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a6e:	00 
80102a6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a76:	00 
80102a77:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7a:	89 04 24             	mov    %eax,(%esp)
80102a7d:	e8 98 27 00 00       	call   8010521a <memset>

  if(kmem.use_lock)
80102a82:	a1 94 08 11 80       	mov    0x80110894,%eax
80102a87:	85 c0                	test   %eax,%eax
80102a89:	74 0c                	je     80102a97 <kfree+0x69>
    acquire(&kmem.lock);
80102a8b:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102a92:	e8 30 25 00 00       	call   80104fc7 <acquire>
  r = (struct run*)v;
80102a97:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102a9d:	8b 15 98 08 11 80    	mov    0x80110898,%edx
80102aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa6:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aab:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102ab0:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 0c                	je     80102ac5 <kfree+0x97>
    release(&kmem.lock);
80102ab9:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102ac0:	e8 64 25 00 00       	call   80105029 <release>
}
80102ac5:	c9                   	leave  
80102ac6:	c3                   	ret    

80102ac7 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ac7:	55                   	push   %ebp
80102ac8:	89 e5                	mov    %esp,%ebp
80102aca:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102acd:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ad2:	85 c0                	test   %eax,%eax
80102ad4:	74 0c                	je     80102ae2 <kalloc+0x1b>
    acquire(&kmem.lock);
80102ad6:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102add:	e8 e5 24 00 00       	call   80104fc7 <acquire>
  r = kmem.freelist;
80102ae2:	a1 98 08 11 80       	mov    0x80110898,%eax
80102ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102aee:	74 0a                	je     80102afa <kalloc+0x33>
    kmem.freelist = r->next;
80102af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af3:	8b 00                	mov    (%eax),%eax
80102af5:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102afa:	a1 94 08 11 80       	mov    0x80110894,%eax
80102aff:	85 c0                	test   %eax,%eax
80102b01:	74 0c                	je     80102b0f <kalloc+0x48>
    release(&kmem.lock);
80102b03:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b0a:	e8 1a 25 00 00       	call   80105029 <release>
  return (char*)r;
80102b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b12:	c9                   	leave  
80102b13:	c3                   	ret    

80102b14 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	53                   	push   %ebx
80102b18:	83 ec 14             	sub    $0x14,%esp
80102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b22:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102b25:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102b29:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102b2d:	ec                   	in     (%dx),%al
80102b2e:	88 c3                	mov    %al,%bl
80102b30:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102b33:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102b36:	83 c4 14             	add    $0x14,%esp
80102b39:	5b                   	pop    %ebx
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    

80102b3c <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b3c:	55                   	push   %ebp
80102b3d:	89 e5                	mov    %esp,%ebp
80102b3f:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b42:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b49:	e8 c6 ff ff ff       	call   80102b14 <inb>
80102b4e:	0f b6 c0             	movzbl %al,%eax
80102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b57:	83 e0 01             	and    $0x1,%eax
80102b5a:	85 c0                	test   %eax,%eax
80102b5c:	75 0a                	jne    80102b68 <kbdgetc+0x2c>
    return -1;
80102b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b63:	e9 21 01 00 00       	jmp    80102c89 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102b68:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b6f:	e8 a0 ff ff ff       	call   80102b14 <inb>
80102b74:	0f b6 c0             	movzbl %al,%eax
80102b77:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b7a:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b81:	75 17                	jne    80102b9a <kbdgetc+0x5e>
    shift |= E0ESC;
80102b83:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102b88:	83 c8 40             	or     $0x40,%eax
80102b8b:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102b90:	b8 00 00 00 00       	mov    $0x0,%eax
80102b95:	e9 ef 00 00 00       	jmp    80102c89 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b9d:	25 80 00 00 00       	and    $0x80,%eax
80102ba2:	85 c0                	test   %eax,%eax
80102ba4:	74 44                	je     80102bea <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ba6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bab:	83 e0 40             	and    $0x40,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	75 08                	jne    80102bba <kbdgetc+0x7e>
80102bb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb5:	83 e0 7f             	and    $0x7f,%eax
80102bb8:	eb 03                	jmp    80102bbd <kbdgetc+0x81>
80102bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc3:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bc8:	8a 00                	mov    (%eax),%al
80102bca:	83 c8 40             	or     $0x40,%eax
80102bcd:	0f b6 c0             	movzbl %al,%eax
80102bd0:	f7 d0                	not    %eax
80102bd2:	89 c2                	mov    %eax,%edx
80102bd4:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bd9:	21 d0                	and    %edx,%eax
80102bdb:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102be0:	b8 00 00 00 00       	mov    $0x0,%eax
80102be5:	e9 9f 00 00 00       	jmp    80102c89 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102bea:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bef:	83 e0 40             	and    $0x40,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	74 14                	je     80102c0a <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bf6:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102bfd:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c02:	83 e0 bf             	and    $0xffffffbf,%eax
80102c05:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c0d:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c12:	8a 00                	mov    (%eax),%al
80102c14:	0f b6 d0             	movzbl %al,%edx
80102c17:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c1c:	09 d0                	or     %edx,%eax
80102c1e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c26:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c2b:	8a 00                	mov    (%eax),%al
80102c2d:	0f b6 d0             	movzbl %al,%edx
80102c30:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c35:	31 d0                	xor    %edx,%eax
80102c37:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c3c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c41:	83 e0 03             	and    $0x3,%eax
80102c44:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4e:	01 d0                	add    %edx,%eax
80102c50:	8a 00                	mov    (%eax),%al
80102c52:	0f b6 c0             	movzbl %al,%eax
80102c55:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c58:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c5d:	83 e0 08             	and    $0x8,%eax
80102c60:	85 c0                	test   %eax,%eax
80102c62:	74 22                	je     80102c86 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102c64:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c68:	76 0c                	jbe    80102c76 <kbdgetc+0x13a>
80102c6a:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c6e:	77 06                	ja     80102c76 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102c70:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c74:	eb 10                	jmp    80102c86 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102c76:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c7a:	76 0a                	jbe    80102c86 <kbdgetc+0x14a>
80102c7c:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c80:	77 04                	ja     80102c86 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102c82:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    

80102c8b <kbdintr>:

void
kbdintr(void)
{
80102c8b:	55                   	push   %ebp
80102c8c:	89 e5                	mov    %esp,%ebp
80102c8e:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102c91:	c7 04 24 3c 2b 10 80 	movl   $0x80102b3c,(%esp)
80102c98:	e8 f3 da ff ff       	call   80100790 <consoleintr>
}
80102c9d:	c9                   	leave  
80102c9e:	c3                   	ret    
80102c9f:	90                   	nop

80102ca0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 08             	sub    $0x8,%esp
80102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102cac:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102cb0:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	8a 45 f8             	mov    -0x8(%ebp),%al
80102cb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102cb9:	ee                   	out    %al,(%dx)
}
80102cba:	c9                   	leave  
80102cbb:	c3                   	ret    

80102cbc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cbc:	55                   	push   %ebp
80102cbd:	89 e5                	mov    %esp,%ebp
80102cbf:	53                   	push   %ebx
80102cc0:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cc3:	9c                   	pushf  
80102cc4:	5b                   	pop    %ebx
80102cc5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102cc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ccb:	83 c4 10             	add    $0x10,%esp
80102cce:	5b                   	pop    %ebx
80102ccf:	5d                   	pop    %ebp
80102cd0:	c3                   	ret    

80102cd1 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cd1:	55                   	push   %ebp
80102cd2:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cd4:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102cd9:	8b 55 08             	mov    0x8(%ebp),%edx
80102cdc:	c1 e2 02             	shl    $0x2,%edx
80102cdf:	01 c2                	add    %eax,%edx
80102ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce4:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ce6:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102ceb:	83 c0 20             	add    $0x20,%eax
80102cee:	8b 00                	mov    (%eax),%eax
}
80102cf0:	5d                   	pop    %ebp
80102cf1:	c3                   	ret    

80102cf2 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102cf2:	55                   	push   %ebp
80102cf3:	89 e5                	mov    %esp,%ebp
80102cf5:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102cf8:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102cfd:	85 c0                	test   %eax,%eax
80102cff:	0f 84 47 01 00 00    	je     80102e4c <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d05:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d0c:	00 
80102d0d:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d14:	e8 b8 ff ff ff       	call   80102cd1 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d19:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d20:	00 
80102d21:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d28:	e8 a4 ff ff ff       	call   80102cd1 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d2d:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d34:	00 
80102d35:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d3c:	e8 90 ff ff ff       	call   80102cd1 <lapicw>
  lapicw(TICR, 10000000); 
80102d41:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d48:	00 
80102d49:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d50:	e8 7c ff ff ff       	call   80102cd1 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d55:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d5c:	00 
80102d5d:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d64:	e8 68 ff ff ff       	call   80102cd1 <lapicw>
  lapicw(LINT1, MASKED);
80102d69:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d70:	00 
80102d71:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d78:	e8 54 ff ff ff       	call   80102cd1 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d7d:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102d82:	83 c0 30             	add    $0x30,%eax
80102d85:	8b 00                	mov    (%eax),%eax
80102d87:	c1 e8 10             	shr    $0x10,%eax
80102d8a:	25 ff 00 00 00       	and    $0xff,%eax
80102d8f:	83 f8 03             	cmp    $0x3,%eax
80102d92:	76 14                	jbe    80102da8 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102d94:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9b:	00 
80102d9c:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102da3:	e8 29 ff ff ff       	call   80102cd1 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102da8:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102daf:	00 
80102db0:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102db7:	e8 15 ff ff ff       	call   80102cd1 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dbc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dc3:	00 
80102dc4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dcb:	e8 01 ff ff ff       	call   80102cd1 <lapicw>
  lapicw(ESR, 0);
80102dd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dd7:	00 
80102dd8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ddf:	e8 ed fe ff ff       	call   80102cd1 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102de4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102deb:	00 
80102dec:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102df3:	e8 d9 fe ff ff       	call   80102cd1 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102df8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dff:	00 
80102e00:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e07:	e8 c5 fe ff ff       	call   80102cd1 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e0c:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e13:	00 
80102e14:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e1b:	e8 b1 fe ff ff       	call   80102cd1 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e20:	90                   	nop
80102e21:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e26:	05 00 03 00 00       	add    $0x300,%eax
80102e2b:	8b 00                	mov    (%eax),%eax
80102e2d:	25 00 10 00 00       	and    $0x1000,%eax
80102e32:	85 c0                	test   %eax,%eax
80102e34:	75 eb                	jne    80102e21 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e45:	e8 87 fe ff ff       	call   80102cd1 <lapicw>
80102e4a:	eb 01                	jmp    80102e4d <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
80102e4c:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e4d:	c9                   	leave  
80102e4e:	c3                   	ret    

80102e4f <cpunum>:

int
cpunum(void)
{
80102e4f:	55                   	push   %ebp
80102e50:	89 e5                	mov    %esp,%ebp
80102e52:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e55:	e8 62 fe ff ff       	call   80102cbc <readeflags>
80102e5a:	25 00 02 00 00       	and    $0x200,%eax
80102e5f:	85 c0                	test   %eax,%eax
80102e61:	74 27                	je     80102e8a <cpunum+0x3b>
    static int n;
    if(n++ == 0)
80102e63:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102e68:	85 c0                	test   %eax,%eax
80102e6a:	0f 94 c2             	sete   %dl
80102e6d:	40                   	inc    %eax
80102e6e:	a3 60 c6 10 80       	mov    %eax,0x8010c660
80102e73:	84 d2                	test   %dl,%dl
80102e75:	74 13                	je     80102e8a <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e77:	8b 45 04             	mov    0x4(%ebp),%eax
80102e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e7e:	c7 04 24 28 8d 10 80 	movl   $0x80108d28,(%esp)
80102e85:	e8 17 d5 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e8a:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e8f:	85 c0                	test   %eax,%eax
80102e91:	74 0f                	je     80102ea2 <cpunum+0x53>
    return lapic[ID]>>24;
80102e93:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e98:	83 c0 20             	add    $0x20,%eax
80102e9b:	8b 00                	mov    (%eax),%eax
80102e9d:	c1 e8 18             	shr    $0x18,%eax
80102ea0:	eb 05                	jmp    80102ea7 <cpunum+0x58>
  return 0;
80102ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ea7:	c9                   	leave  
80102ea8:	c3                   	ret    

80102ea9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ea9:	55                   	push   %ebp
80102eaa:	89 e5                	mov    %esp,%ebp
80102eac:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eaf:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102eb4:	85 c0                	test   %eax,%eax
80102eb6:	74 14                	je     80102ecc <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ebf:	00 
80102ec0:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ec7:	e8 05 fe ff ff       	call   80102cd1 <lapicw>
}
80102ecc:	c9                   	leave  
80102ecd:	c3                   	ret    

80102ece <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ece:	55                   	push   %ebp
80102ecf:	89 e5                	mov    %esp,%ebp
}
80102ed1:	5d                   	pop    %ebp
80102ed2:	c3                   	ret    

80102ed3 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ed3:	55                   	push   %ebp
80102ed4:	89 e5                	mov    %esp,%ebp
80102ed6:	83 ec 1c             	sub    $0x1c,%esp
80102ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80102edc:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102edf:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ee6:	00 
80102ee7:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102eee:	e8 ad fd ff ff       	call   80102ca0 <outb>
  outb(IO_RTC+1, 0x0A);
80102ef3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102efa:	00 
80102efb:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f02:	e8 99 fd ff ff       	call   80102ca0 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f07:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f11:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f16:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f19:	8d 50 02             	lea    0x2(%eax),%edx
80102f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f1f:	c1 e8 04             	shr    $0x4,%eax
80102f22:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f25:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f29:	c1 e0 18             	shl    $0x18,%eax
80102f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f30:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f37:	e8 95 fd ff ff       	call   80102cd1 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f3c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f43:	00 
80102f44:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f4b:	e8 81 fd ff ff       	call   80102cd1 <lapicw>
  microdelay(200);
80102f50:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f57:	e8 72 ff ff ff       	call   80102ece <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f5c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f63:	00 
80102f64:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f6b:	e8 61 fd ff ff       	call   80102cd1 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f70:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f77:	e8 52 ff ff ff       	call   80102ece <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f83:	eb 3f                	jmp    80102fc4 <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
80102f85:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f89:	c1 e0 18             	shl    $0x18,%eax
80102f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f90:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f97:	e8 35 fd ff ff       	call   80102cd1 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9f:	c1 e8 0c             	shr    $0xc,%eax
80102fa2:	80 cc 06             	or     $0x6,%ah
80102fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fa9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fb0:	e8 1c fd ff ff       	call   80102cd1 <lapicw>
    microdelay(200);
80102fb5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fbc:	e8 0d ff ff ff       	call   80102ece <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fc1:	ff 45 fc             	incl   -0x4(%ebp)
80102fc4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fc8:	7e bb                	jle    80102f85 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fca:	c9                   	leave  
80102fcb:	c3                   	ret    

80102fcc <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fcc:	55                   	push   %ebp
80102fcd:	89 e5                	mov    %esp,%ebp
80102fcf:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fd2:	c7 44 24 04 54 8d 10 	movl   $0x80108d54,0x4(%esp)
80102fd9:	80 
80102fda:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80102fe1:	e8 c0 1f 00 00       	call   80104fa6 <initlock>
  readsb(ROOTDEV, &sb);
80102fe6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102ff4:	e8 e3 e2 ff ff       	call   801012dc <readsb>
  log.start = sb.size - sb.nlog;
80102ff9:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fff:	89 d1                	mov    %edx,%ecx
80103001:	29 c1                	sub    %eax,%ecx
80103003:	89 c8                	mov    %ecx,%eax
80103005:	a3 d4 08 11 80       	mov    %eax,0x801108d4
  log.size = sb.nlog;
8010300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010300d:	a3 d8 08 11 80       	mov    %eax,0x801108d8
  log.dev = ROOTDEV;
80103012:	c7 05 e0 08 11 80 01 	movl   $0x1,0x801108e0
80103019:	00 00 00 
  recover_from_log();
8010301c:	e8 95 01 00 00       	call   801031b6 <recover_from_log>
}
80103021:	c9                   	leave  
80103022:	c3                   	ret    

80103023 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103023:	55                   	push   %ebp
80103024:	89 e5                	mov    %esp,%ebp
80103026:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103029:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103030:	e9 89 00 00 00       	jmp    801030be <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103035:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
8010303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303e:	01 d0                	add    %edx,%eax
80103040:	40                   	inc    %eax
80103041:	89 c2                	mov    %eax,%edx
80103043:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103048:	89 54 24 04          	mov    %edx,0x4(%esp)
8010304c:	89 04 24             	mov    %eax,(%esp)
8010304f:	e8 52 d1 ff ff       	call   801001a6 <bread>
80103054:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010305a:	83 c0 10             	add    $0x10,%eax
8010305d:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
80103064:	89 c2                	mov    %eax,%edx
80103066:	a1 e0 08 11 80       	mov    0x801108e0,%eax
8010306b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010306f:	89 04 24             	mov    %eax,(%esp)
80103072:	e8 2f d1 ff ff       	call   801001a6 <bread>
80103077:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010307a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010307d:	8d 50 18             	lea    0x18(%eax),%edx
80103080:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103083:	83 c0 18             	add    $0x18,%eax
80103086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010308d:	00 
8010308e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103092:	89 04 24             	mov    %eax,(%esp)
80103095:	e8 4c 22 00 00       	call   801052e6 <memmove>
    bwrite(dbuf);  // write dst to disk
8010309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010309d:	89 04 24             	mov    %eax,(%esp)
801030a0:	e8 38 d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030a8:	89 04 24             	mov    %eax,(%esp)
801030ab:	e8 67 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030b3:	89 04 24             	mov    %eax,(%esp)
801030b6:	e8 5c d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030bb:	ff 45 f4             	incl   -0xc(%ebp)
801030be:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801030c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030c6:	0f 8f 69 ff ff ff    	jg     80103035 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030cc:	c9                   	leave  
801030cd:	c3                   	ret    

801030ce <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030ce:	55                   	push   %ebp
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030d4:	a1 d4 08 11 80       	mov    0x801108d4,%eax
801030d9:	89 c2                	mov    %eax,%edx
801030db:	a1 e0 08 11 80       	mov    0x801108e0,%eax
801030e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801030e4:	89 04 24             	mov    %eax,(%esp)
801030e7:	e8 ba d0 ff ff       	call   801001a6 <bread>
801030ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030f2:	83 c0 18             	add    $0x18,%eax
801030f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801030f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030fb:	8b 00                	mov    (%eax),%eax
801030fd:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  for (i = 0; i < log.lh.n; i++) {
80103102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103109:	eb 1a                	jmp    80103125 <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
8010310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010310e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103111:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103118:	83 c2 10             	add    $0x10,%edx
8010311b:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103122:	ff 45 f4             	incl   -0xc(%ebp)
80103125:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010312a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010312d:	7f dc                	jg     8010310b <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103132:	89 04 24             	mov    %eax,(%esp)
80103135:	e8 dd d0 ff ff       	call   80100217 <brelse>
}
8010313a:	c9                   	leave  
8010313b:	c3                   	ret    

8010313c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010313c:	55                   	push   %ebp
8010313d:	89 e5                	mov    %esp,%ebp
8010313f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103142:	a1 d4 08 11 80       	mov    0x801108d4,%eax
80103147:	89 c2                	mov    %eax,%edx
80103149:	a1 e0 08 11 80       	mov    0x801108e0,%eax
8010314e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103152:	89 04 24             	mov    %eax,(%esp)
80103155:	e8 4c d0 ff ff       	call   801001a6 <bread>
8010315a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103160:	83 c0 18             	add    $0x18,%eax
80103163:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103166:	8b 15 e4 08 11 80    	mov    0x801108e4,%edx
8010316c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103178:	eb 1a                	jmp    80103194 <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
8010317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317d:	83 c0 10             	add    $0x10,%eax
80103180:	8b 0c 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%ecx
80103187:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010318a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010318d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103191:	ff 45 f4             	incl   -0xc(%ebp)
80103194:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103199:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010319c:	7f dc                	jg     8010317a <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a1:	89 04 24             	mov    %eax,(%esp)
801031a4:	e8 34 d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031ac:	89 04 24             	mov    %eax,(%esp)
801031af:	e8 63 d0 ff ff       	call   80100217 <brelse>
}
801031b4:	c9                   	leave  
801031b5:	c3                   	ret    

801031b6 <recover_from_log>:

static void
recover_from_log(void)
{
801031b6:	55                   	push   %ebp
801031b7:	89 e5                	mov    %esp,%ebp
801031b9:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031bc:	e8 0d ff ff ff       	call   801030ce <read_head>
  install_trans(); // if committed, copy from log to disk
801031c1:	e8 5d fe ff ff       	call   80103023 <install_trans>
  log.lh.n = 0;
801031c6:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
801031cd:	00 00 00 
  write_head(); // clear the log
801031d0:	e8 67 ff ff ff       	call   8010313c <write_head>
}
801031d5:	c9                   	leave  
801031d6:	c3                   	ret    

801031d7 <begin_trans>:

void
begin_trans(void)
{
801031d7:	55                   	push   %ebp
801031d8:	89 e5                	mov    %esp,%ebp
801031da:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031dd:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801031e4:	e8 de 1d 00 00       	call   80104fc7 <acquire>
  while (log.busy) {
801031e9:	eb 14                	jmp    801031ff <begin_trans+0x28>
    sleep(&log, &log.lock);
801031eb:	c7 44 24 04 a0 08 11 	movl   $0x801108a0,0x4(%esp)
801031f2:	80 
801031f3:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801031fa:	e8 c9 16 00 00       	call   801048c8 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801031ff:	a1 dc 08 11 80       	mov    0x801108dc,%eax
80103204:	85 c0                	test   %eax,%eax
80103206:	75 e3                	jne    801031eb <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103208:	c7 05 dc 08 11 80 01 	movl   $0x1,0x801108dc
8010320f:	00 00 00 
  release(&log.lock);
80103212:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103219:	e8 0b 1e 00 00       	call   80105029 <release>
}
8010321e:	c9                   	leave  
8010321f:	c3                   	ret    

80103220 <commit_trans>:

void
commit_trans(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103226:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010322b:	85 c0                	test   %eax,%eax
8010322d:	7e 19                	jle    80103248 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010322f:	e8 08 ff ff ff       	call   8010313c <write_head>
    install_trans(); // Now install writes to home locations
80103234:	e8 ea fd ff ff       	call   80103023 <install_trans>
    log.lh.n = 0; 
80103239:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
80103240:	00 00 00 
    write_head();    // Erase the transaction from the log
80103243:	e8 f4 fe ff ff       	call   8010313c <write_head>
  }
  
  acquire(&log.lock);
80103248:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010324f:	e8 73 1d 00 00       	call   80104fc7 <acquire>
  log.busy = 0;
80103254:	c7 05 dc 08 11 80 00 	movl   $0x0,0x801108dc
8010325b:	00 00 00 
  wakeup(&log);
8010325e:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103265:	e8 37 17 00 00       	call   801049a1 <wakeup>
  release(&log.lock);
8010326a:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103271:	e8 b3 1d 00 00       	call   80105029 <release>
}
80103276:	c9                   	leave  
80103277:	c3                   	ret    

80103278 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103278:	55                   	push   %ebp
80103279:	89 e5                	mov    %esp,%ebp
8010327b:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010327e:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103283:	83 f8 09             	cmp    $0x9,%eax
80103286:	7f 10                	jg     80103298 <log_write+0x20>
80103288:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010328d:	8b 15 d8 08 11 80    	mov    0x801108d8,%edx
80103293:	4a                   	dec    %edx
80103294:	39 d0                	cmp    %edx,%eax
80103296:	7c 0c                	jl     801032a4 <log_write+0x2c>
    panic("too big a transaction");
80103298:	c7 04 24 58 8d 10 80 	movl   $0x80108d58,(%esp)
8010329f:	e8 92 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
801032a4:	a1 dc 08 11 80       	mov    0x801108dc,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	75 0c                	jne    801032b9 <log_write+0x41>
    panic("write outside of trans");
801032ad:	c7 04 24 6e 8d 10 80 	movl   $0x80108d6e,(%esp)
801032b4:	e8 7d d2 ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
801032b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032c0:	eb 1c                	jmp    801032de <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c5:	83 c0 10             	add    $0x10,%eax
801032c8:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
801032cf:	89 c2                	mov    %eax,%edx
801032d1:	8b 45 08             	mov    0x8(%ebp),%eax
801032d4:	8b 40 08             	mov    0x8(%eax),%eax
801032d7:	39 c2                	cmp    %eax,%edx
801032d9:	74 0f                	je     801032ea <log_write+0x72>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032db:	ff 45 f4             	incl   -0xc(%ebp)
801032de:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801032e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032e6:	7f da                	jg     801032c2 <log_write+0x4a>
801032e8:	eb 01                	jmp    801032eb <log_write+0x73>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
801032ea:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801032eb:	8b 45 08             	mov    0x8(%ebp),%eax
801032ee:	8b 40 08             	mov    0x8(%eax),%eax
801032f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032f4:	83 c2 10             	add    $0x10,%edx
801032f7:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801032fe:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
80103304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103307:	01 d0                	add    %edx,%eax
80103309:	40                   	inc    %eax
8010330a:	89 c2                	mov    %eax,%edx
8010330c:	8b 45 08             	mov    0x8(%ebp),%eax
8010330f:	8b 40 04             	mov    0x4(%eax),%eax
80103312:	89 54 24 04          	mov    %edx,0x4(%esp)
80103316:	89 04 24             	mov    %eax,(%esp)
80103319:	e8 88 ce ff ff       	call   801001a6 <bread>
8010331e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103321:	8b 45 08             	mov    0x8(%ebp),%eax
80103324:	8d 50 18             	lea    0x18(%eax),%edx
80103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332a:	83 c0 18             	add    $0x18,%eax
8010332d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103334:	00 
80103335:	89 54 24 04          	mov    %edx,0x4(%esp)
80103339:	89 04 24             	mov    %eax,(%esp)
8010333c:	e8 a5 1f 00 00       	call   801052e6 <memmove>
  bwrite(lbuf);
80103341:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103344:	89 04 24             	mov    %eax,(%esp)
80103347:	e8 91 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
8010334c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334f:	89 04 24             	mov    %eax,(%esp)
80103352:	e8 c0 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103357:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010335c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010335f:	75 0b                	jne    8010336c <log_write+0xf4>
    log.lh.n++;
80103361:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103366:	40                   	inc    %eax
80103367:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  b->flags |= B_DIRTY; // XXX prevent eviction
8010336c:	8b 45 08             	mov    0x8(%ebp),%eax
8010336f:	8b 00                	mov    (%eax),%eax
80103371:	89 c2                	mov    %eax,%edx
80103373:	83 ca 04             	or     $0x4,%edx
80103376:	8b 45 08             	mov    0x8(%ebp),%eax
80103379:	89 10                	mov    %edx,(%eax)
}
8010337b:	c9                   	leave  
8010337c:	c3                   	ret    
8010337d:	66 90                	xchg   %ax,%ax
8010337f:	90                   	nop

80103380 <v2p>:
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	8b 45 08             	mov    0x8(%ebp),%eax
80103386:	05 00 00 00 80       	add    $0x80000000,%eax
8010338b:	5d                   	pop    %ebp
8010338c:	c3                   	ret    

8010338d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010338d:	55                   	push   %ebp
8010338e:	89 e5                	mov    %esp,%ebp
80103390:	8b 45 08             	mov    0x8(%ebp),%eax
80103393:	05 00 00 00 80       	add    $0x80000000,%eax
80103398:	5d                   	pop    %ebp
80103399:	c3                   	ret    

8010339a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	53                   	push   %ebx
8010339e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801033a1:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801033a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033aa:	89 c3                	mov    %eax,%ebx
801033ac:	89 d8                	mov    %ebx,%eax
801033ae:	f0 87 02             	lock xchg %eax,(%edx)
801033b1:	89 c3                	mov    %eax,%ebx
801033b3:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	5b                   	pop    %ebx
801033bd:	5d                   	pop    %ebp
801033be:	c3                   	ret    

801033bf <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033bf:	55                   	push   %ebp
801033c0:	89 e5                	mov    %esp,%ebp
801033c2:	83 e4 f0             	and    $0xfffffff0,%esp
801033c5:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033c8:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033cf:	80 
801033d0:	c7 04 24 54 b7 14 80 	movl   $0x8014b754,(%esp)
801033d7:	e8 bd f5 ff ff       	call   80102999 <kinit1>
  kvmalloc();      // kernel page table
801033dc:	e8 45 4a 00 00       	call   80107e26 <kvmalloc>
  mpinit();        // collect info about this machine
801033e1:	e8 a3 04 00 00       	call   80103889 <mpinit>
  lapicinit(mpbcpu());
801033e6:	e8 3a 02 00 00       	call   80103625 <mpbcpu>
801033eb:	89 04 24             	mov    %eax,(%esp)
801033ee:	e8 ff f8 ff ff       	call   80102cf2 <lapicinit>
  seginit();       // set up segments
801033f3:	e8 af 43 00 00       	call   801077a7 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033fe:	8a 00                	mov    (%eax),%al
80103400:	0f b6 c0             	movzbl %al,%eax
80103403:	89 44 24 04          	mov    %eax,0x4(%esp)
80103407:	c7 04 24 85 8d 10 80 	movl   $0x80108d85,(%esp)
8010340e:	e8 8e cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103413:	e8 d8 06 00 00       	call   80103af0 <picinit>
  ioapicinit();    // another interrupt controller
80103418:	e8 74 f4 ff ff       	call   80102891 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010341d:	e8 3b d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103422:	e8 bd 36 00 00       	call   80106ae4 <uartinit>
  pinit();         // process table
80103427:	e8 e4 0b 00 00       	call   80104010 <pinit>
  tvinit();        // trap vectors
8010342c:	e8 54 32 00 00       	call   80106685 <tvinit>
  binit();         // buffer cache
80103431:	e8 fe cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103436:	e8 c5 da ff ff       	call   80100f00 <fileinit>
  iinit();         // inode cache
8010343b:	e8 58 e1 ff ff       	call   80101598 <iinit>
  ideinit();       // disk
80103440:	e8 b5 f0 ff ff       	call   801024fa <ideinit>
  if(!ismp)
80103445:	a1 24 09 11 80       	mov    0x80110924,%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	75 05                	jne    80103453 <main+0x94>
    timerinit();   // uniprocessor timer
8010344e:	e8 79 31 00 00       	call   801065cc <timerinit>
  startothers();   // start other processors
80103453:	e8 86 00 00 00       	call   801034de <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103458:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010345f:	8e 
80103460:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103467:	e8 65 f5 ff ff       	call   801029d1 <kinit2>
  userinit();      // first user process
8010346c:	e8 b8 0c 00 00       	call   80104129 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103471:	e8 22 00 00 00       	call   80103498 <mpmain>

80103476 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103476:	55                   	push   %ebp
80103477:	89 e5                	mov    %esp,%ebp
80103479:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
8010347c:	e8 bc 49 00 00       	call   80107e3d <switchkvm>
  seginit();
80103481:	e8 21 43 00 00       	call   801077a7 <seginit>
  lapicinit(cpunum());
80103486:	e8 c4 f9 ff ff       	call   80102e4f <cpunum>
8010348b:	89 04 24             	mov    %eax,(%esp)
8010348e:	e8 5f f8 ff ff       	call   80102cf2 <lapicinit>
  mpmain();
80103493:	e8 00 00 00 00       	call   80103498 <mpmain>

80103498 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103498:	55                   	push   %ebp
80103499:	89 e5                	mov    %esp,%ebp
8010349b:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010349e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034a4:	8a 00                	mov    (%eax),%al
801034a6:	0f b6 c0             	movzbl %al,%eax
801034a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801034ad:	c7 04 24 9c 8d 10 80 	movl   $0x80108d9c,(%esp)
801034b4:	e8 e8 ce ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
801034b9:	e8 24 33 00 00       	call   801067e2 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034c4:	05 a8 00 00 00       	add    $0xa8,%eax
801034c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034d0:	00 
801034d1:	89 04 24             	mov    %eax,(%esp)
801034d4:	e8 c1 fe ff ff       	call   8010339a <xchg>
  scheduler();     // start running processes
801034d9:	e8 41 12 00 00       	call   8010471f <scheduler>

801034de <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034de:	55                   	push   %ebp
801034df:	89 e5                	mov    %esp,%ebp
801034e1:	53                   	push   %ebx
801034e2:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034e5:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034ec:	e8 9c fe ff ff       	call   8010338d <p2v>
801034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034f4:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801034fd:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103504:	80 
80103505:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103508:	89 04 24             	mov    %eax,(%esp)
8010350b:	e8 d6 1d 00 00       	call   801052e6 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103510:	c7 45 f4 40 09 11 80 	movl   $0x80110940,-0xc(%ebp)
80103517:	e9 8f 00 00 00       	jmp    801035ab <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
8010351c:	e8 2e f9 ff ff       	call   80102e4f <cpunum>
80103521:	89 c2                	mov    %eax,%edx
80103523:	89 d0                	mov    %edx,%eax
80103525:	d1 e0                	shl    %eax
80103527:	01 d0                	add    %edx,%eax
80103529:	c1 e0 04             	shl    $0x4,%eax
8010352c:	29 d0                	sub    %edx,%eax
8010352e:	c1 e0 02             	shl    $0x2,%eax
80103531:	05 40 09 11 80       	add    $0x80110940,%eax
80103536:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103539:	74 68                	je     801035a3 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010353b:	e8 87 f5 ff ff       	call   80102ac7 <kalloc>
80103540:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103543:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103546:	83 e8 04             	sub    $0x4,%eax
80103549:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010354c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103552:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103557:	83 e8 08             	sub    $0x8,%eax
8010355a:	c7 00 76 34 10 80    	movl   $0x80103476,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103560:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103563:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103566:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
8010356d:	e8 0e fe ff ff       	call   80103380 <v2p>
80103572:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103577:	89 04 24             	mov    %eax,(%esp)
8010357a:	e8 01 fe ff ff       	call   80103380 <v2p>
8010357f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103582:	8a 12                	mov    (%edx),%dl
80103584:	0f b6 d2             	movzbl %dl,%edx
80103587:	89 44 24 04          	mov    %eax,0x4(%esp)
8010358b:	89 14 24             	mov    %edx,(%esp)
8010358e:	e8 40 f9 ff ff       	call   80102ed3 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103593:	90                   	nop
80103594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103597:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010359d:	85 c0                	test   %eax,%eax
8010359f:	74 f3                	je     80103594 <startothers+0xb6>
801035a1:	eb 01                	jmp    801035a4 <startothers+0xc6>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035a3:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035a4:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035ab:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801035b0:	89 c2                	mov    %eax,%edx
801035b2:	89 d0                	mov    %edx,%eax
801035b4:	d1 e0                	shl    %eax
801035b6:	01 d0                	add    %edx,%eax
801035b8:	c1 e0 04             	shl    $0x4,%eax
801035bb:	29 d0                	sub    %edx,%eax
801035bd:	c1 e0 02             	shl    $0x2,%eax
801035c0:	05 40 09 11 80       	add    $0x80110940,%eax
801035c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035c8:	0f 87 4e ff ff ff    	ja     8010351c <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035ce:	83 c4 24             	add    $0x24,%esp
801035d1:	5b                   	pop    %ebx
801035d2:	5d                   	pop    %ebp
801035d3:	c3                   	ret    

801035d4 <p2v>:
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	8b 45 08             	mov    0x8(%ebp),%eax
801035da:	05 00 00 00 80       	add    $0x80000000,%eax
801035df:	5d                   	pop    %ebp
801035e0:	c3                   	ret    

801035e1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035e1:	55                   	push   %ebp
801035e2:	89 e5                	mov    %esp,%ebp
801035e4:	53                   	push   %ebx
801035e5:	83 ec 14             	sub    $0x14,%esp
801035e8:	8b 45 08             	mov    0x8(%ebp),%eax
801035eb:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035f2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801035f6:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801035fa:	ec                   	in     (%dx),%al
801035fb:	88 c3                	mov    %al,%bl
801035fd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103600:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80103603:	83 c4 14             	add    $0x14,%esp
80103606:	5b                   	pop    %ebx
80103607:	5d                   	pop    %ebp
80103608:	c3                   	ret    

80103609 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103609:	55                   	push   %ebp
8010360a:	89 e5                	mov    %esp,%ebp
8010360c:	83 ec 08             	sub    $0x8,%esp
8010360f:	8b 45 08             	mov    0x8(%ebp),%eax
80103612:	8b 55 0c             	mov    0xc(%ebp),%edx
80103615:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103619:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010361c:	8a 45 f8             	mov    -0x8(%ebp),%al
8010361f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103622:	ee                   	out    %al,(%dx)
}
80103623:	c9                   	leave  
80103624:	c3                   	ret    

80103625 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103625:	55                   	push   %ebp
80103626:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103628:	a1 64 c6 10 80       	mov    0x8010c664,%eax
8010362d:	89 c2                	mov    %eax,%edx
8010362f:	b8 40 09 11 80       	mov    $0x80110940,%eax
80103634:	89 d1                	mov    %edx,%ecx
80103636:	29 c1                	sub    %eax,%ecx
80103638:	89 c8                	mov    %ecx,%eax
8010363a:	89 c2                	mov    %eax,%edx
8010363c:	c1 fa 02             	sar    $0x2,%edx
8010363f:	89 d0                	mov    %edx,%eax
80103641:	c1 e0 03             	shl    $0x3,%eax
80103644:	01 d0                	add    %edx,%eax
80103646:	c1 e0 03             	shl    $0x3,%eax
80103649:	01 d0                	add    %edx,%eax
8010364b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103652:	01 c8                	add    %ecx,%eax
80103654:	c1 e0 03             	shl    $0x3,%eax
80103657:	01 d0                	add    %edx,%eax
80103659:	c1 e0 03             	shl    $0x3,%eax
8010365c:	29 d0                	sub    %edx,%eax
8010365e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103665:	01 c8                	add    %ecx,%eax
80103667:	c1 e0 02             	shl    $0x2,%eax
8010366a:	01 d0                	add    %edx,%eax
8010366c:	c1 e0 03             	shl    $0x3,%eax
8010366f:	29 d0                	sub    %edx,%eax
80103671:	89 c1                	mov    %eax,%ecx
80103673:	c1 e1 07             	shl    $0x7,%ecx
80103676:	01 c8                	add    %ecx,%eax
80103678:	d1 e0                	shl    %eax
8010367a:	01 d0                	add    %edx,%eax
}
8010367c:	5d                   	pop    %ebp
8010367d:	c3                   	ret    

8010367e <sum>:

static uchar
sum(uchar *addr, int len)
{
8010367e:	55                   	push   %ebp
8010367f:	89 e5                	mov    %esp,%ebp
80103681:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103684:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010368b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103692:	eb 13                	jmp    801036a7 <sum+0x29>
    sum += addr[i];
80103694:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103697:	8b 45 08             	mov    0x8(%ebp),%eax
8010369a:	01 d0                	add    %edx,%eax
8010369c:	8a 00                	mov    (%eax),%al
8010369e:	0f b6 c0             	movzbl %al,%eax
801036a1:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036a4:	ff 45 fc             	incl   -0x4(%ebp)
801036a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036ad:	7c e5                	jl     80103694 <sum+0x16>
    sum += addr[i];
  return sum;
801036af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036b2:	c9                   	leave  
801036b3:	c3                   	ret    

801036b4 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036ba:	8b 45 08             	mov    0x8(%ebp),%eax
801036bd:	89 04 24             	mov    %eax,(%esp)
801036c0:	e8 0f ff ff ff       	call   801035d4 <p2v>
801036c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801036c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801036cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ce:	01 d0                	add    %edx,%eax
801036d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036d9:	eb 3f                	jmp    8010371a <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036db:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036e2:	00 
801036e3:	c7 44 24 04 b0 8d 10 	movl   $0x80108db0,0x4(%esp)
801036ea:	80 
801036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ee:	89 04 24             	mov    %eax,(%esp)
801036f1:	e8 9b 1b 00 00       	call   80105291 <memcmp>
801036f6:	85 c0                	test   %eax,%eax
801036f8:	75 1c                	jne    80103716 <mpsearch1+0x62>
801036fa:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103701:	00 
80103702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103705:	89 04 24             	mov    %eax,(%esp)
80103708:	e8 71 ff ff ff       	call   8010367e <sum>
8010370d:	84 c0                	test   %al,%al
8010370f:	75 05                	jne    80103716 <mpsearch1+0x62>
      return (struct mp*)p;
80103711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103714:	eb 11                	jmp    80103727 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103716:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103720:	72 b9                	jb     801036db <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103722:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103727:	c9                   	leave  
80103728:	c3                   	ret    

80103729 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103729:	55                   	push   %ebp
8010372a:	89 e5                	mov    %esp,%ebp
8010372c:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
8010372f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103739:	83 c0 0f             	add    $0xf,%eax
8010373c:	8a 00                	mov    (%eax),%al
8010373e:	0f b6 c0             	movzbl %al,%eax
80103741:	89 c2                	mov    %eax,%edx
80103743:	c1 e2 08             	shl    $0x8,%edx
80103746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103749:	83 c0 0e             	add    $0xe,%eax
8010374c:	8a 00                	mov    (%eax),%al
8010374e:	0f b6 c0             	movzbl %al,%eax
80103751:	09 d0                	or     %edx,%eax
80103753:	c1 e0 04             	shl    $0x4,%eax
80103756:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010375d:	74 21                	je     80103780 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
8010375f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103766:	00 
80103767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376a:	89 04 24             	mov    %eax,(%esp)
8010376d:	e8 42 ff ff ff       	call   801036b4 <mpsearch1>
80103772:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103779:	74 4e                	je     801037c9 <mpsearch+0xa0>
      return mp;
8010377b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010377e:	eb 5d                	jmp    801037dd <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103783:	83 c0 14             	add    $0x14,%eax
80103786:	8a 00                	mov    (%eax),%al
80103788:	0f b6 c0             	movzbl %al,%eax
8010378b:	89 c2                	mov    %eax,%edx
8010378d:	c1 e2 08             	shl    $0x8,%edx
80103790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103793:	83 c0 13             	add    $0x13,%eax
80103796:	8a 00                	mov    (%eax),%al
80103798:	0f b6 c0             	movzbl %al,%eax
8010379b:	09 d0                	or     %edx,%eax
8010379d:	c1 e0 0a             	shl    $0xa,%eax
801037a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a6:	2d 00 04 00 00       	sub    $0x400,%eax
801037ab:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037b2:	00 
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	e8 f9 fe ff ff       	call   801036b4 <mpsearch1>
801037bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037c2:	74 05                	je     801037c9 <mpsearch+0xa0>
      return mp;
801037c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037c7:	eb 14                	jmp    801037dd <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
801037c9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037d0:	00 
801037d1:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037d8:	e8 d7 fe ff ff       	call   801036b4 <mpsearch1>
}
801037dd:	c9                   	leave  
801037de:	c3                   	ret    

801037df <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037df:	55                   	push   %ebp
801037e0:	89 e5                	mov    %esp,%ebp
801037e2:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037e5:	e8 3f ff ff ff       	call   80103729 <mpsearch>
801037ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f1:	74 0a                	je     801037fd <mpconfig+0x1e>
801037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f6:	8b 40 04             	mov    0x4(%eax),%eax
801037f9:	85 c0                	test   %eax,%eax
801037fb:	75 0a                	jne    80103807 <mpconfig+0x28>
    return 0;
801037fd:	b8 00 00 00 00       	mov    $0x0,%eax
80103802:	e9 80 00 00 00       	jmp    80103887 <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380a:	8b 40 04             	mov    0x4(%eax),%eax
8010380d:	89 04 24             	mov    %eax,(%esp)
80103810:	e8 bf fd ff ff       	call   801035d4 <p2v>
80103815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103818:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010381f:	00 
80103820:	c7 44 24 04 b5 8d 10 	movl   $0x80108db5,0x4(%esp)
80103827:	80 
80103828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382b:	89 04 24             	mov    %eax,(%esp)
8010382e:	e8 5e 1a 00 00       	call   80105291 <memcmp>
80103833:	85 c0                	test   %eax,%eax
80103835:	74 07                	je     8010383e <mpconfig+0x5f>
    return 0;
80103837:	b8 00 00 00 00       	mov    $0x0,%eax
8010383c:	eb 49                	jmp    80103887 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
8010383e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103841:	8a 40 06             	mov    0x6(%eax),%al
80103844:	3c 01                	cmp    $0x1,%al
80103846:	74 11                	je     80103859 <mpconfig+0x7a>
80103848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384b:	8a 40 06             	mov    0x6(%eax),%al
8010384e:	3c 04                	cmp    $0x4,%al
80103850:	74 07                	je     80103859 <mpconfig+0x7a>
    return 0;
80103852:	b8 00 00 00 00       	mov    $0x0,%eax
80103857:	eb 2e                	jmp    80103887 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103859:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385c:	8b 40 04             	mov    0x4(%eax),%eax
8010385f:	0f b7 c0             	movzwl %ax,%eax
80103862:	89 44 24 04          	mov    %eax,0x4(%esp)
80103866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103869:	89 04 24             	mov    %eax,(%esp)
8010386c:	e8 0d fe ff ff       	call   8010367e <sum>
80103871:	84 c0                	test   %al,%al
80103873:	74 07                	je     8010387c <mpconfig+0x9d>
    return 0;
80103875:	b8 00 00 00 00       	mov    $0x0,%eax
8010387a:	eb 0b                	jmp    80103887 <mpconfig+0xa8>
  *pmp = mp;
8010387c:	8b 45 08             	mov    0x8(%ebp),%eax
8010387f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103882:	89 10                	mov    %edx,(%eax)
  return conf;
80103884:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103887:	c9                   	leave  
80103888:	c3                   	ret    

80103889 <mpinit>:

void
mpinit(void)
{
80103889:	55                   	push   %ebp
8010388a:	89 e5                	mov    %esp,%ebp
8010388c:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010388f:	c7 05 64 c6 10 80 40 	movl   $0x80110940,0x8010c664
80103896:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103899:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010389c:	89 04 24             	mov    %eax,(%esp)
8010389f:	e8 3b ff ff ff       	call   801037df <mpconfig>
801038a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038ab:	0f 84 a4 01 00 00    	je     80103a55 <mpinit+0x1cc>
    return;
  ismp = 1;
801038b1:	c7 05 24 09 11 80 01 	movl   $0x1,0x80110924
801038b8:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038be:	8b 40 24             	mov    0x24(%eax),%eax
801038c1:	a3 9c 08 11 80       	mov    %eax,0x8011089c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c9:	83 c0 2c             	add    $0x2c,%eax
801038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d2:	8b 40 04             	mov    0x4(%eax),%eax
801038d5:	0f b7 d0             	movzwl %ax,%edx
801038d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038db:	01 d0                	add    %edx,%eax
801038dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038e0:	e9 fe 00 00 00       	jmp    801039e3 <mpinit+0x15a>
    switch(*p){
801038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e8:	8a 00                	mov    (%eax),%al
801038ea:	0f b6 c0             	movzbl %al,%eax
801038ed:	83 f8 04             	cmp    $0x4,%eax
801038f0:	0f 87 cb 00 00 00    	ja     801039c1 <mpinit+0x138>
801038f6:	8b 04 85 f8 8d 10 80 	mov    -0x7fef7208(,%eax,4),%eax
801038fd:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103902:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103905:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103908:	8a 40 01             	mov    0x1(%eax),%al
8010390b:	0f b6 d0             	movzbl %al,%edx
8010390e:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103913:	39 c2                	cmp    %eax,%edx
80103915:	74 2c                	je     80103943 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103917:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010391a:	8a 40 01             	mov    0x1(%eax),%al
8010391d:	0f b6 d0             	movzbl %al,%edx
80103920:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103925:	89 54 24 08          	mov    %edx,0x8(%esp)
80103929:	89 44 24 04          	mov    %eax,0x4(%esp)
8010392d:	c7 04 24 ba 8d 10 80 	movl   $0x80108dba,(%esp)
80103934:	e8 68 ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80103939:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
80103940:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103943:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103946:	8a 40 03             	mov    0x3(%eax),%al
80103949:	0f b6 c0             	movzbl %al,%eax
8010394c:	83 e0 02             	and    $0x2,%eax
8010394f:	85 c0                	test   %eax,%eax
80103951:	74 1e                	je     80103971 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103953:	8b 15 20 0f 11 80    	mov    0x80110f20,%edx
80103959:	89 d0                	mov    %edx,%eax
8010395b:	d1 e0                	shl    %eax
8010395d:	01 d0                	add    %edx,%eax
8010395f:	c1 e0 04             	shl    $0x4,%eax
80103962:	29 d0                	sub    %edx,%eax
80103964:	c1 e0 02             	shl    $0x2,%eax
80103967:	05 40 09 11 80       	add    $0x80110940,%eax
8010396c:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103971:	8b 15 20 0f 11 80    	mov    0x80110f20,%edx
80103977:	a1 20 0f 11 80       	mov    0x80110f20,%eax
8010397c:	88 c1                	mov    %al,%cl
8010397e:	89 d0                	mov    %edx,%eax
80103980:	d1 e0                	shl    %eax
80103982:	01 d0                	add    %edx,%eax
80103984:	c1 e0 04             	shl    $0x4,%eax
80103987:	29 d0                	sub    %edx,%eax
80103989:	c1 e0 02             	shl    $0x2,%eax
8010398c:	05 40 09 11 80       	add    $0x80110940,%eax
80103991:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103993:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103998:	40                   	inc    %eax
80103999:	a3 20 0f 11 80       	mov    %eax,0x80110f20
      p += sizeof(struct mpproc);
8010399e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801039a2:	eb 3f                	jmp    801039e3 <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801039a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039ad:	8a 40 01             	mov    0x1(%eax),%al
801039b0:	a2 20 09 11 80       	mov    %al,0x80110920
      p += sizeof(struct mpioapic);
801039b5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039b9:	eb 28                	jmp    801039e3 <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039bb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039bf:	eb 22                	jmp    801039e3 <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c4:	8a 00                	mov    (%eax),%al
801039c6:	0f b6 c0             	movzbl %al,%eax
801039c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801039cd:	c7 04 24 d8 8d 10 80 	movl   $0x80108dd8,(%esp)
801039d4:	e8 c8 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039d9:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
801039e0:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039e9:	0f 82 f6 fe ff ff    	jb     801038e5 <mpinit+0x5c>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039ef:	a1 24 09 11 80       	mov    0x80110924,%eax
801039f4:	85 c0                	test   %eax,%eax
801039f6:	75 1d                	jne    80103a15 <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039f8:	c7 05 20 0f 11 80 01 	movl   $0x1,0x80110f20
801039ff:	00 00 00 
    lapic = 0;
80103a02:	c7 05 9c 08 11 80 00 	movl   $0x0,0x8011089c
80103a09:	00 00 00 
    ioapicid = 0;
80103a0c:	c6 05 20 09 11 80 00 	movb   $0x0,0x80110920
80103a13:	eb 40                	jmp    80103a55 <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
80103a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a18:	8a 40 0c             	mov    0xc(%eax),%al
80103a1b:	84 c0                	test   %al,%al
80103a1d:	74 36                	je     80103a55 <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a1f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a26:	00 
80103a27:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a2e:	e8 d6 fb ff ff       	call   80103609 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a33:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a3a:	e8 a2 fb ff ff       	call   801035e1 <inb>
80103a3f:	83 c8 01             	or     $0x1,%eax
80103a42:	0f b6 c0             	movzbl %al,%eax
80103a45:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a49:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a50:	e8 b4 fb ff ff       	call   80103609 <outb>
  }
}
80103a55:	c9                   	leave  
80103a56:	c3                   	ret    
80103a57:	90                   	nop

80103a58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a58:	55                   	push   %ebp
80103a59:	89 e5                	mov    %esp,%ebp
80103a5b:	83 ec 08             	sub    $0x8,%esp
80103a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a61:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a68:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a6b:	8a 45 f8             	mov    -0x8(%ebp),%al
80103a6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a71:	ee                   	out    %al,(%dx)
}
80103a72:	c9                   	leave  
80103a73:	c3                   	ret    

80103a74 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 0c             	sub    $0xc,%esp
80103a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a84:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a8d:	0f b6 c0             	movzbl %al,%eax
80103a90:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a94:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9b:	e8 b8 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103aa3:	66 c1 e8 08          	shr    $0x8,%ax
80103aa7:	0f b6 c0             	movzbl %al,%eax
80103aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aae:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ab5:	e8 9e ff ff ff       	call   80103a58 <outb>
}
80103aba:	c9                   	leave  
80103abb:	c3                   	ret    

80103abc <picenable>:

void
picenable(int irq)
{
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	53                   	push   %ebx
80103ac0:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac6:	ba 01 00 00 00       	mov    $0x1,%edx
80103acb:	89 d3                	mov    %edx,%ebx
80103acd:	88 c1                	mov    %al,%cl
80103acf:	d3 e3                	shl    %cl,%ebx
80103ad1:	89 d8                	mov    %ebx,%eax
80103ad3:	89 c2                	mov    %eax,%edx
80103ad5:	f7 d2                	not    %edx
80103ad7:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103add:	21 d0                	and    %edx,%eax
80103adf:	0f b7 c0             	movzwl %ax,%eax
80103ae2:	89 04 24             	mov    %eax,(%esp)
80103ae5:	e8 8a ff ff ff       	call   80103a74 <picsetmask>
}
80103aea:	83 c4 04             	add    $0x4,%esp
80103aed:	5b                   	pop    %ebx
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    

80103af0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103af6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103afd:	00 
80103afe:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b05:	e8 4e ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b0a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b11:	00 
80103b12:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b19:	e8 3a ff ff ff       	call   80103a58 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b1e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b25:	00 
80103b26:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b2d:	e8 26 ff ff ff       	call   80103a58 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b32:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b39:	00 
80103b3a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b41:	e8 12 ff ff ff       	call   80103a58 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b46:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b4d:	00 
80103b4e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b55:	e8 fe fe ff ff       	call   80103a58 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b5a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b61:	00 
80103b62:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b69:	e8 ea fe ff ff       	call   80103a58 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b6e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b75:	00 
80103b76:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b7d:	e8 d6 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b82:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b89:	00 
80103b8a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b91:	e8 c2 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b96:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b9d:	00 
80103b9e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ba5:	e8 ae fe ff ff       	call   80103a58 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103baa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bb1:	00 
80103bb2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bb9:	e8 9a fe ff ff       	call   80103a58 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bbe:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bc5:	00 
80103bc6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bcd:	e8 86 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bd2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bd9:	00 
80103bda:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be1:	e8 72 fe ff ff       	call   80103a58 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103be6:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bed:	00 
80103bee:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bf5:	e8 5e fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bfa:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c01:	00 
80103c02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c09:	e8 4a fe ff ff       	call   80103a58 <outb>

  if(irqmask != 0xFFFF)
80103c0e:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103c14:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c18:	74 11                	je     80103c2b <picinit+0x13b>
    picsetmask(irqmask);
80103c1a:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103c20:	0f b7 c0             	movzwl %ax,%eax
80103c23:	89 04 24             	mov    %eax,(%esp)
80103c26:	e8 49 fe ff ff       	call   80103a74 <picsetmask>
}
80103c2b:	c9                   	leave  
80103c2c:	c3                   	ret    
80103c2d:	66 90                	xchg   %ax,%ax
80103c2f:	90                   	nop

80103c30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c46:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c49:	8b 10                	mov    (%eax),%edx
80103c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c50:	e8 c7 d2 ff ff       	call   80100f1c <filealloc>
80103c55:	8b 55 08             	mov    0x8(%ebp),%edx
80103c58:	89 02                	mov    %eax,(%edx)
80103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5d:	8b 00                	mov    (%eax),%eax
80103c5f:	85 c0                	test   %eax,%eax
80103c61:	0f 84 c8 00 00 00    	je     80103d2f <pipealloc+0xff>
80103c67:	e8 b0 d2 ff ff       	call   80100f1c <filealloc>
80103c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c6f:	89 02                	mov    %eax,(%edx)
80103c71:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c74:	8b 00                	mov    (%eax),%eax
80103c76:	85 c0                	test   %eax,%eax
80103c78:	0f 84 b1 00 00 00    	je     80103d2f <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c7e:	e8 44 ee ff ff       	call   80102ac7 <kalloc>
80103c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c8a:	0f 84 9e 00 00 00    	je     80103d2e <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c93:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c9a:	00 00 00 
  p->writeopen = 1;
80103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca0:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ca7:	00 00 00 
  p->nwrite = 0;
80103caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cad:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cb4:	00 00 00 
  p->nread = 0;
80103cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cba:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cc1:	00 00 00 
  initlock(&p->lock, "pipe");
80103cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc7:	c7 44 24 04 0c 8e 10 	movl   $0x80108e0c,0x4(%esp)
80103cce:	80 
80103ccf:	89 04 24             	mov    %eax,(%esp)
80103cd2:	e8 cf 12 00 00       	call   80104fa6 <initlock>
  (*f0)->type = FD_PIPE;
80103cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cda:	8b 00                	mov    (%eax),%eax
80103cdc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce5:	8b 00                	mov    (%eax),%eax
80103ce7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80103cee:	8b 00                	mov    (%eax),%eax
80103cf0:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf7:	8b 00                	mov    (%eax),%eax
80103cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cfc:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d02:	8b 00                	mov    (%eax),%eax
80103d04:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d0d:	8b 00                	mov    (%eax),%eax
80103d0f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d16:	8b 00                	mov    (%eax),%eax
80103d18:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1f:	8b 00                	mov    (%eax),%eax
80103d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d24:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d27:	b8 00 00 00 00       	mov    $0x0,%eax
80103d2c:	eb 43                	jmp    80103d71 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d2e:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d33:	74 0b                	je     80103d40 <pipealloc+0x110>
    kfree((char*)p);
80103d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d38:	89 04 24             	mov    %eax,(%esp)
80103d3b:	e8 ee ec ff ff       	call   80102a2e <kfree>
  if(*f0)
80103d40:	8b 45 08             	mov    0x8(%ebp),%eax
80103d43:	8b 00                	mov    (%eax),%eax
80103d45:	85 c0                	test   %eax,%eax
80103d47:	74 0d                	je     80103d56 <pipealloc+0x126>
    fileclose(*f0);
80103d49:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4c:	8b 00                	mov    (%eax),%eax
80103d4e:	89 04 24             	mov    %eax,(%esp)
80103d51:	e8 6e d2 ff ff       	call   80100fc4 <fileclose>
  if(*f1)
80103d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d59:	8b 00                	mov    (%eax),%eax
80103d5b:	85 c0                	test   %eax,%eax
80103d5d:	74 0d                	je     80103d6c <pipealloc+0x13c>
    fileclose(*f1);
80103d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d62:	8b 00                	mov    (%eax),%eax
80103d64:	89 04 24             	mov    %eax,(%esp)
80103d67:	e8 58 d2 ff ff       	call   80100fc4 <fileclose>
  return -1;
80103d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d71:	c9                   	leave  
80103d72:	c3                   	ret    

80103d73 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d73:	55                   	push   %ebp
80103d74:	89 e5                	mov    %esp,%ebp
80103d76:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d79:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7c:	89 04 24             	mov    %eax,(%esp)
80103d7f:	e8 43 12 00 00       	call   80104fc7 <acquire>
  if(writable){
80103d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d88:	74 1f                	je     80103da9 <pipeclose+0x36>
    p->writeopen = 0;
80103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8d:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d94:	00 00 00 
    wakeup(&p->nread);
80103d97:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9a:	05 34 02 00 00       	add    $0x234,%eax
80103d9f:	89 04 24             	mov    %eax,(%esp)
80103da2:	e8 fa 0b 00 00       	call   801049a1 <wakeup>
80103da7:	eb 1d                	jmp    80103dc6 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103da9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dac:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103db3:	00 00 00 
    wakeup(&p->nwrite);
80103db6:	8b 45 08             	mov    0x8(%ebp),%eax
80103db9:	05 38 02 00 00       	add    $0x238,%eax
80103dbe:	89 04 24             	mov    %eax,(%esp)
80103dc1:	e8 db 0b 00 00       	call   801049a1 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc9:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dcf:	85 c0                	test   %eax,%eax
80103dd1:	75 25                	jne    80103df8 <pipeclose+0x85>
80103dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ddc:	85 c0                	test   %eax,%eax
80103dde:	75 18                	jne    80103df8 <pipeclose+0x85>
    release(&p->lock);
80103de0:	8b 45 08             	mov    0x8(%ebp),%eax
80103de3:	89 04 24             	mov    %eax,(%esp)
80103de6:	e8 3e 12 00 00       	call   80105029 <release>
    kfree((char*)p);
80103deb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dee:	89 04 24             	mov    %eax,(%esp)
80103df1:	e8 38 ec ff ff       	call   80102a2e <kfree>
80103df6:	eb 0b                	jmp    80103e03 <pipeclose+0x90>
  } else
    release(&p->lock);
80103df8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfb:	89 04 24             	mov    %eax,(%esp)
80103dfe:	e8 26 12 00 00       	call   80105029 <release>
}
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    

80103e05 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e05:	55                   	push   %ebp
80103e06:	89 e5                	mov    %esp,%ebp
80103e08:	53                   	push   %ebx
80103e09:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0f:	89 04 24             	mov    %eax,(%esp)
80103e12:	e8 b0 11 00 00       	call   80104fc7 <acquire>
  for(i = 0; i < n; i++){
80103e17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e1e:	e9 a6 00 00 00       	jmp    80103ec9 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e2c:	85 c0                	test   %eax,%eax
80103e2e:	74 0d                	je     80103e3d <pipewrite+0x38>
80103e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e36:	8b 40 24             	mov    0x24(%eax),%eax
80103e39:	85 c0                	test   %eax,%eax
80103e3b:	74 15                	je     80103e52 <pipewrite+0x4d>
        release(&p->lock);
80103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e40:	89 04 24             	mov    %eax,(%esp)
80103e43:	e8 e1 11 00 00       	call   80105029 <release>
        return -1;
80103e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e4d:	e9 9d 00 00 00       	jmp    80103eef <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e52:	8b 45 08             	mov    0x8(%ebp),%eax
80103e55:	05 34 02 00 00       	add    $0x234,%eax
80103e5a:	89 04 24             	mov    %eax,(%esp)
80103e5d:	e8 3f 0b 00 00       	call   801049a1 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e62:	8b 45 08             	mov    0x8(%ebp),%eax
80103e65:	8b 55 08             	mov    0x8(%ebp),%edx
80103e68:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e72:	89 14 24             	mov    %edx,(%esp)
80103e75:	e8 4e 0a 00 00       	call   801048c8 <sleep>
80103e7a:	eb 01                	jmp    80103e7d <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e7c:	90                   	nop
80103e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e80:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e86:	8b 45 08             	mov    0x8(%ebp),%eax
80103e89:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e8f:	05 00 02 00 00       	add    $0x200,%eax
80103e94:	39 c2                	cmp    %eax,%edx
80103e96:	74 8b                	je     80103e23 <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e98:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ea1:	89 c3                	mov    %eax,%ebx
80103ea3:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ea9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103eac:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eaf:	01 ca                	add    %ecx,%edx
80103eb1:	8a 0a                	mov    (%edx),%cl
80103eb3:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb6:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103eba:	8d 50 01             	lea    0x1(%eax),%edx
80103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec0:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ec6:	ff 45 f4             	incl   -0xc(%ebp)
80103ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ecc:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ecf:	7c ab                	jl     80103e7c <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed4:	05 34 02 00 00       	add    $0x234,%eax
80103ed9:	89 04 24             	mov    %eax,(%esp)
80103edc:	e8 c0 0a 00 00       	call   801049a1 <wakeup>
  release(&p->lock);
80103ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee4:	89 04 24             	mov    %eax,(%esp)
80103ee7:	e8 3d 11 00 00       	call   80105029 <release>
  return n;
80103eec:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eef:	83 c4 24             	add    $0x24,%esp
80103ef2:	5b                   	pop    %ebx
80103ef3:	5d                   	pop    %ebp
80103ef4:	c3                   	ret    

80103ef5 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ef5:	55                   	push   %ebp
80103ef6:	89 e5                	mov    %esp,%ebp
80103ef8:	53                   	push   %ebx
80103ef9:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103efc:	8b 45 08             	mov    0x8(%ebp),%eax
80103eff:	89 04 24             	mov    %eax,(%esp)
80103f02:	e8 c0 10 00 00       	call   80104fc7 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f07:	eb 3a                	jmp    80103f43 <piperead+0x4e>
    if(proc->killed){
80103f09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f0f:	8b 40 24             	mov    0x24(%eax),%eax
80103f12:	85 c0                	test   %eax,%eax
80103f14:	74 15                	je     80103f2b <piperead+0x36>
      release(&p->lock);
80103f16:	8b 45 08             	mov    0x8(%ebp),%eax
80103f19:	89 04 24             	mov    %eax,(%esp)
80103f1c:	e8 08 11 00 00       	call   80105029 <release>
      return -1;
80103f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f26:	e9 b5 00 00 00       	jmp    80103fe0 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2e:	8b 55 08             	mov    0x8(%ebp),%edx
80103f31:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f37:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3b:	89 14 24             	mov    %edx,(%esp)
80103f3e:	e8 85 09 00 00       	call   801048c8 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f43:	8b 45 08             	mov    0x8(%ebp),%eax
80103f46:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f55:	39 c2                	cmp    %eax,%edx
80103f57:	75 0d                	jne    80103f66 <piperead+0x71>
80103f59:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5c:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	75 a3                	jne    80103f09 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f6d:	eb 48                	jmp    80103fb7 <piperead+0xc2>
    if(p->nread == p->nwrite)
80103f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f72:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f78:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f81:	39 c2                	cmp    %eax,%edx
80103f83:	74 3c                	je     80103fc1 <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f8b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f91:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f97:	89 c3                	mov    %eax,%ebx
80103f99:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f9f:	8b 55 08             	mov    0x8(%ebp),%edx
80103fa2:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
80103fa6:	88 11                	mov    %dl,(%ecx)
80103fa8:	8d 50 01             	lea    0x1(%eax),%edx
80103fab:	8b 45 08             	mov    0x8(%ebp),%eax
80103fae:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb4:	ff 45 f4             	incl   -0xc(%ebp)
80103fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fba:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fbd:	7c b0                	jl     80103f6f <piperead+0x7a>
80103fbf:	eb 01                	jmp    80103fc2 <piperead+0xcd>
    if(p->nread == p->nwrite)
      break;
80103fc1:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc5:	05 38 02 00 00       	add    $0x238,%eax
80103fca:	89 04 24             	mov    %eax,(%esp)
80103fcd:	e8 cf 09 00 00       	call   801049a1 <wakeup>
  release(&p->lock);
80103fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd5:	89 04 24             	mov    %eax,(%esp)
80103fd8:	e8 4c 10 00 00       	call   80105029 <release>
  return i;
80103fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fe0:	83 c4 24             	add    $0x24,%esp
80103fe3:	5b                   	pop    %ebx
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
80103fe6:	66 90                	xchg   %ax,%ax

80103fe8 <p2v>:
80103fe8:	55                   	push   %ebp
80103fe9:	89 e5                	mov    %esp,%ebp
80103feb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fee:	05 00 00 00 80       	add    $0x80000000,%eax
80103ff3:	5d                   	pop    %ebp
80103ff4:	c3                   	ret    

80103ff5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103ff5:	55                   	push   %ebp
80103ff6:	89 e5                	mov    %esp,%ebp
80103ff8:	53                   	push   %ebx
80103ff9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ffc:	9c                   	pushf  
80103ffd:	5b                   	pop    %ebx
80103ffe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104001:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104004:	83 c4 10             	add    $0x10,%esp
80104007:	5b                   	pop    %ebx
80104008:	5d                   	pop    %ebp
80104009:	c3                   	ret    

8010400a <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010400a:	55                   	push   %ebp
8010400b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010400d:	fb                   	sti    
}
8010400e:	5d                   	pop    %ebp
8010400f:	c3                   	ret    

80104010 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104016:	c7 44 24 04 14 8e 10 	movl   $0x80108e14,0x4(%esp)
8010401d:	80 
8010401e:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104025:	e8 7c 0f 00 00       	call   80104fa6 <initlock>
}
8010402a:	c9                   	leave  
8010402b:	c3                   	ret    

8010402c <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010402c:	55                   	push   %ebp
8010402d:	89 e5                	mov    %esp,%ebp
8010402f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104032:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104039:	e8 89 0f 00 00       	call   80104fc7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403e:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104045:	eb 0e                	jmp    80104055 <allocproc+0x29>
    if(p->state == UNUSED)
80104047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404a:	8b 40 0c             	mov    0xc(%eax),%eax
8010404d:	85 c0                	test   %eax,%eax
8010404f:	74 23                	je     80104074 <allocproc+0x48>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104051:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104055:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
8010405c:	72 e9                	jb     80104047 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010405e:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104065:	e8 bf 0f 00 00       	call   80105029 <release>
  return 0;
8010406a:	b8 00 00 00 00       	mov    $0x0,%eax
8010406f:	e9 b3 00 00 00       	jmp    80104127 <allocproc+0xfb>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104074:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104078:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010407f:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104084:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104087:	89 42 10             	mov    %eax,0x10(%edx)
8010408a:	40                   	inc    %eax
8010408b:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
80104090:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104097:	e8 8d 0f 00 00       	call   80105029 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010409c:	e8 26 ea ff ff       	call   80102ac7 <kalloc>
801040a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a4:	89 42 08             	mov    %eax,0x8(%edx)
801040a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040aa:	8b 40 08             	mov    0x8(%eax),%eax
801040ad:	85 c0                	test   %eax,%eax
801040af:	75 11                	jne    801040c2 <allocproc+0x96>
    p->state = UNUSED;
801040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040bb:	b8 00 00 00 00       	mov    $0x0,%eax
801040c0:	eb 65                	jmp    80104127 <allocproc+0xfb>
  }
  sp = p->kstack + KSTACKSIZE;
801040c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c5:	8b 40 08             	mov    0x8(%eax),%eax
801040c8:	05 00 10 00 00       	add    $0x1000,%eax
801040cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040d0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801040d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040da:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040dd:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801040e1:	ba 3c 66 10 80       	mov    $0x8010663c,%edx
801040e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040e9:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801040eb:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040f5:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	8b 40 1c             	mov    0x1c(%eax),%eax
801040fe:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104105:	00 
80104106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010410d:	00 
8010410e:	89 04 24             	mov    %eax,(%esp)
80104111:	e8 04 11 00 00       	call   8010521a <memset>
  p->context->eip = (uint)forkret;
80104116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104119:	8b 40 1c             	mov    0x1c(%eax),%eax
8010411c:	ba 9c 48 10 80       	mov    $0x8010489c,%edx
80104121:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104124:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104127:	c9                   	leave  
80104128:	c3                   	ret    

80104129 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104129:	55                   	push   %ebp
8010412a:	89 e5                	mov    %esp,%ebp
8010412c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010412f:	e8 f8 fe ff ff       	call   8010402c <allocproc>
80104134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413a:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm(kalloc)) == 0)
8010413f:	c7 04 24 c7 2a 10 80 	movl   $0x80102ac7,(%esp)
80104146:	e8 1e 3c 00 00       	call   80107d69 <setupkvm>
8010414b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414e:	89 42 04             	mov    %eax,0x4(%edx)
80104151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104154:	8b 40 04             	mov    0x4(%eax),%eax
80104157:	85 c0                	test   %eax,%eax
80104159:	75 0c                	jne    80104167 <userinit+0x3e>
    panic("userinit: out of memory?");
8010415b:	c7 04 24 1b 8e 10 80 	movl   $0x80108e1b,(%esp)
80104162:	e8 cf c3 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104167:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416f:	8b 40 04             	mov    0x4(%eax),%eax
80104172:	89 54 24 08          	mov    %edx,0x8(%esp)
80104176:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
8010417d:	80 
8010417e:	89 04 24             	mov    %eax,(%esp)
80104181:	e8 2f 3e 00 00       	call   80107fb5 <inituvm>
  p->sz = PGSIZE;
80104186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104189:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010418f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104192:	8b 40 18             	mov    0x18(%eax),%eax
80104195:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010419c:	00 
8010419d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041a4:	00 
801041a5:	89 04 24             	mov    %eax,(%esp)
801041a8:	e8 6d 10 00 00       	call   8010521a <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b0:	8b 40 18             	mov    0x18(%eax),%eax
801041b3:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bc:	8b 40 18             	mov    0x18(%eax),%eax
801041bf:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c8:	8b 50 18             	mov    0x18(%eax),%edx
801041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ce:	8b 40 18             	mov    0x18(%eax),%eax
801041d1:	8b 40 2c             	mov    0x2c(%eax),%eax
801041d4:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801041d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041db:	8b 50 18             	mov    0x18(%eax),%edx
801041de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e1:	8b 40 18             	mov    0x18(%eax),%eax
801041e4:	8b 40 2c             	mov    0x2c(%eax),%eax
801041e7:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ee:	8b 40 18             	mov    0x18(%eax),%eax
801041f1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fb:	8b 40 18             	mov    0x18(%eax),%eax
801041fe:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104208:	8b 40 18             	mov    0x18(%eax),%eax
8010420b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104215:	83 c0 6c             	add    $0x6c,%eax
80104218:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010421f:	00 
80104220:	c7 44 24 04 34 8e 10 	movl   $0x80108e34,0x4(%esp)
80104227:	80 
80104228:	89 04 24             	mov    %eax,(%esp)
8010422b:	e8 fc 11 00 00       	call   8010542c <safestrcpy>
  p->cwd = namei("/");
80104230:	c7 04 24 3d 8e 10 80 	movl   $0x80108e3d,(%esp)
80104237:	e8 a8 e1 ff ff       	call   801023e4 <namei>
8010423c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423f:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104245:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010424c:	c9                   	leave  
8010424d:	c3                   	ret    

8010424e <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010424e:	55                   	push   %ebp
8010424f:	89 e5                	mov    %esp,%ebp
80104251:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104254:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010425a:	8b 00                	mov    (%eax),%eax
8010425c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010425f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104263:	7e 34                	jle    80104299 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104265:	8b 55 08             	mov    0x8(%ebp),%edx
80104268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426b:	01 c2                	add    %eax,%edx
8010426d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104273:	8b 40 04             	mov    0x4(%eax),%eax
80104276:	89 54 24 08          	mov    %edx,0x8(%esp)
8010427a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010427d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104281:	89 04 24             	mov    %eax,(%esp)
80104284:	e8 c1 3e 00 00       	call   8010814a <allocuvm>
80104289:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010428c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104290:	75 41                	jne    801042d3 <growproc+0x85>
      return -1;
80104292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104297:	eb 58                	jmp    801042f1 <growproc+0xa3>
  } else if(n < 0){
80104299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010429d:	79 34                	jns    801042d3 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010429f:	8b 55 08             	mov    0x8(%ebp),%edx
801042a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a5:	01 c2                	add    %eax,%edx
801042a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ad:	8b 40 04             	mov    0x4(%eax),%eax
801042b0:	89 54 24 08          	mov    %edx,0x8(%esp)
801042b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801042bb:	89 04 24             	mov    %eax,(%esp)
801042be:	e8 61 3f 00 00       	call   80108224 <deallocuvm>
801042c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042ca:	75 07                	jne    801042d3 <growproc+0x85>
      return -1;
801042cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d1:	eb 1e                	jmp    801042f1 <growproc+0xa3>
  }
  proc->sz = sz;
801042d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042dc:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801042de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e4:	89 04 24             	mov    %eax,(%esp)
801042e7:	e8 6e 3b 00 00       	call   80107e5a <switchuvm>
  return 0;
801042ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042f1:	c9                   	leave  
801042f2:	c3                   	ret    

801042f3 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801042f3:	55                   	push   %ebp
801042f4:	89 e5                	mov    %esp,%ebp
801042f6:	57                   	push   %edi
801042f7:	56                   	push   %esi
801042f8:	53                   	push   %ebx
801042f9:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042fc:	e8 2b fd ff ff       	call   8010402c <allocproc>
80104301:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104304:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104308:	75 0a                	jne    80104314 <fork+0x21>
    return -1;
8010430a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430f:	e9 39 01 00 00       	jmp    8010444d <fork+0x15a>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104314:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431a:	8b 10                	mov    (%eax),%edx
8010431c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104322:	8b 40 04             	mov    0x4(%eax),%eax
80104325:	89 54 24 04          	mov    %edx,0x4(%esp)
80104329:	89 04 24             	mov    %eax,(%esp)
8010432c:	e8 75 42 00 00       	call   801085a6 <copyuvm>
80104331:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104334:	89 42 04             	mov    %eax,0x4(%edx)
80104337:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433a:	8b 40 04             	mov    0x4(%eax),%eax
8010433d:	85 c0                	test   %eax,%eax
8010433f:	75 2c                	jne    8010436d <fork+0x7a>
    kfree(np->kstack);
80104341:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104344:	8b 40 08             	mov    0x8(%eax),%eax
80104347:	89 04 24             	mov    %eax,(%esp)
8010434a:	e8 df e6 ff ff       	call   80102a2e <kfree>
    np->kstack = 0;
8010434f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104352:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104359:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010435c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104368:	e9 e0 00 00 00       	jmp    8010444d <fork+0x15a>
  }
  np->sz = proc->sz;
8010436d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104373:	8b 10                	mov    (%eax),%edx
80104375:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104378:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010437a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104381:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104384:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104387:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438a:	8b 50 18             	mov    0x18(%eax),%edx
8010438d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104393:	8b 40 18             	mov    0x18(%eax),%eax
80104396:	89 c3                	mov    %eax,%ebx
80104398:	b8 13 00 00 00       	mov    $0x13,%eax
8010439d:	89 d7                	mov    %edx,%edi
8010439f:	89 de                	mov    %ebx,%esi
801043a1:	89 c1                	mov    %eax,%ecx
801043a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043a8:	8b 40 18             	mov    0x18(%eax),%eax
801043ab:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801043b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801043b9:	eb 3c                	jmp    801043f7 <fork+0x104>
    if(proc->ofile[i])
801043bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043c4:	83 c2 08             	add    $0x8,%edx
801043c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043cb:	85 c0                	test   %eax,%eax
801043cd:	74 25                	je     801043f4 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801043cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043d8:	83 c2 08             	add    $0x8,%edx
801043db:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043df:	89 04 24             	mov    %eax,(%esp)
801043e2:	e8 95 cb ff ff       	call   80100f7c <filedup>
801043e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043ed:	83 c1 08             	add    $0x8,%ecx
801043f0:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801043f4:	ff 45 e4             	incl   -0x1c(%ebp)
801043f7:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043fb:	7e be                	jle    801043bb <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801043fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104403:	8b 40 68             	mov    0x68(%eax),%eax
80104406:	89 04 24             	mov    %eax,(%esp)
80104409:	e8 0a d4 ff ff       	call   80101818 <idup>
8010440e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104411:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104414:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104417:	8b 40 10             	mov    0x10(%eax),%eax
8010441a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
8010441d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104420:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104427:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104430:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104433:	83 c0 6c             	add    $0x6c,%eax
80104436:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010443d:	00 
8010443e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104442:	89 04 24             	mov    %eax,(%esp)
80104445:	e8 e2 0f 00 00       	call   8010542c <safestrcpy>
  return pid;
8010444a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010444d:	83 c4 2c             	add    $0x2c,%esp
80104450:	5b                   	pop    %ebx
80104451:	5e                   	pop    %esi
80104452:	5f                   	pop    %edi
80104453:	5d                   	pop    %ebp
80104454:	c3                   	ret    

80104455 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104455:	55                   	push   %ebp
80104456:	89 e5                	mov    %esp,%ebp
80104458:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010445b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104462:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104467:	39 c2                	cmp    %eax,%edx
80104469:	75 0c                	jne    80104477 <exit+0x22>
    panic("init exiting");
8010446b:	c7 04 24 3f 8e 10 80 	movl   $0x80108e3f,(%esp)
80104472:	e8 bf c0 ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010447e:	eb 43                	jmp    801044c3 <exit+0x6e>
    if(proc->ofile[fd]){
80104480:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104489:	83 c2 08             	add    $0x8,%edx
8010448c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104490:	85 c0                	test   %eax,%eax
80104492:	74 2c                	je     801044c0 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104494:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010449d:	83 c2 08             	add    $0x8,%edx
801044a0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044a4:	89 04 24             	mov    %eax,(%esp)
801044a7:	e8 18 cb ff ff       	call   80100fc4 <fileclose>
      proc->ofile[fd] = 0;
801044ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044b5:	83 c2 08             	add    $0x8,%edx
801044b8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801044bf:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044c0:	ff 45 f0             	incl   -0x10(%ebp)
801044c3:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801044c7:	7e b7                	jle    80104480 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801044c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044cf:	8b 40 68             	mov    0x68(%eax),%eax
801044d2:	89 04 24             	mov    %eax,(%esp)
801044d5:	e8 20 d5 ff ff       	call   801019fa <iput>
  proc->cwd = 0;
801044da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801044e7:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801044ee:	e8 d4 0a 00 00       	call   80104fc7 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f9:	8b 40 14             	mov    0x14(%eax),%eax
801044fc:	89 04 24             	mov    %eax,(%esp)
801044ff:	e8 5f 04 00 00       	call   80104963 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104504:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
8010450b:	eb 38                	jmp    80104545 <exit+0xf0>
    if(p->parent == proc){
8010450d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104510:	8b 50 14             	mov    0x14(%eax),%edx
80104513:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104519:	39 c2                	cmp    %eax,%edx
8010451b:	75 24                	jne    80104541 <exit+0xec>
      p->parent = initproc;
8010451d:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104526:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452c:	8b 40 0c             	mov    0xc(%eax),%eax
8010452f:	83 f8 05             	cmp    $0x5,%eax
80104532:	75 0d                	jne    80104541 <exit+0xec>
        wakeup1(initproc);
80104534:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104539:	89 04 24             	mov    %eax,(%esp)
8010453c:	e8 22 04 00 00       	call   80104963 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104541:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104545:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
8010454c:	72 bf                	jb     8010450d <exit+0xb8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010454e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104554:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010455b:	e8 58 02 00 00       	call   801047b8 <sched>
  panic("zombie exit");
80104560:	c7 04 24 4c 8e 10 80 	movl   $0x80108e4c,(%esp)
80104567:	e8 ca bf ff ff       	call   80100536 <panic>

8010456c <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010456c:	55                   	push   %ebp
8010456d:	89 e5                	mov    %esp,%ebp
8010456f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104572:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104579:	e8 49 0a 00 00       	call   80104fc7 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010457e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104585:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
8010458c:	e9 9a 00 00 00       	jmp    8010462b <wait+0xbf>
      if(p->parent != proc)
80104591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104594:	8b 50 14             	mov    0x14(%eax),%edx
80104597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459d:	39 c2                	cmp    %eax,%edx
8010459f:	0f 85 81 00 00 00    	jne    80104626 <wait+0xba>
        continue;
      havekids = 1;
801045a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	8b 40 0c             	mov    0xc(%eax),%eax
801045b2:	83 f8 05             	cmp    $0x5,%eax
801045b5:	75 70                	jne    80104627 <wait+0xbb>
        // Found one.
        pid = p->pid;
801045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ba:	8b 40 10             	mov    0x10(%eax),%eax
801045bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	8b 40 08             	mov    0x8(%eax),%eax
801045c6:	89 04 24             	mov    %eax,(%esp)
801045c9:	e8 60 e4 ff ff       	call   80102a2e <kfree>
        p->kstack = 0;
801045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045db:	8b 40 04             	mov    0x4(%eax),%eax
801045de:	89 04 24             	mov    %eax,(%esp)
801045e1:	e8 e1 3e 00 00       	call   801084c7 <freevm>
        p->state = UNUSED;
801045e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104607:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104615:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010461c:	e8 08 0a 00 00       	call   80105029 <release>
        return pid;
80104621:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104624:	eb 53                	jmp    80104679 <wait+0x10d>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104626:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104627:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010462b:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
80104632:	0f 82 59 ff ff ff    	jb     80104591 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104638:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010463c:	74 0d                	je     8010464b <wait+0xdf>
8010463e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104644:	8b 40 24             	mov    0x24(%eax),%eax
80104647:	85 c0                	test   %eax,%eax
80104649:	74 13                	je     8010465e <wait+0xf2>
      release(&ptable.lock);
8010464b:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104652:	e8 d2 09 00 00       	call   80105029 <release>
      return -1;
80104657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010465c:	eb 1b                	jmp    80104679 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010465e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104664:	c7 44 24 04 40 0f 11 	movl   $0x80110f40,0x4(%esp)
8010466b:	80 
8010466c:	89 04 24             	mov    %eax,(%esp)
8010466f:	e8 54 02 00 00       	call   801048c8 <sleep>
  }
80104674:	e9 05 ff ff ff       	jmp    8010457e <wait+0x12>
}
80104679:	c9                   	leave  
8010467a:	c3                   	ret    

8010467b <register_handler>:

void
register_handler(sighandler_t sighandler)
{
8010467b:	55                   	push   %ebp
8010467c:	89 e5                	mov    %esp,%ebp
8010467e:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
80104681:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104687:	8b 40 18             	mov    0x18(%eax),%eax
8010468a:	8b 40 44             	mov    0x44(%eax),%eax
8010468d:	89 c2                	mov    %eax,%edx
8010468f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104695:	8b 40 04             	mov    0x4(%eax),%eax
80104698:	89 54 24 04          	mov    %edx,0x4(%esp)
8010469c:	89 04 24             	mov    %eax,(%esp)
8010469f:	e8 5a 40 00 00       	call   801086fe <uva2ka>
801046a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
801046a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ad:	8b 40 18             	mov    0x18(%eax),%eax
801046b0:	8b 40 44             	mov    0x44(%eax),%eax
801046b3:	25 ff 0f 00 00       	and    $0xfff,%eax
801046b8:	85 c0                	test   %eax,%eax
801046ba:	75 0c                	jne    801046c8 <register_handler+0x4d>
    panic("esp_offset == 0");
801046bc:	c7 04 24 58 8e 10 80 	movl   $0x80108e58,(%esp)
801046c3:	e8 6e be ff ff       	call   80100536 <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
801046c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ce:	8b 40 18             	mov    0x18(%eax),%eax
801046d1:	8b 40 44             	mov    0x44(%eax),%eax
801046d4:	83 e8 04             	sub    $0x4,%eax
801046d7:	89 c2                	mov    %eax,%edx
801046d9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
801046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e2:	01 c2                	add    %eax,%edx
          = proc->tf->eip;
801046e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ea:	8b 40 18             	mov    0x18(%eax),%eax
801046ed:	8b 40 38             	mov    0x38(%eax),%eax
801046f0:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 4;
801046f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104702:	8b 52 18             	mov    0x18(%edx),%edx
80104705:	8b 52 44             	mov    0x44(%edx),%edx
80104708:	83 ea 04             	sub    $0x4,%edx
8010470b:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
8010470e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104714:	8b 40 18             	mov    0x18(%eax),%eax
80104717:	8b 55 08             	mov    0x8(%ebp),%edx
8010471a:	89 50 38             	mov    %edx,0x38(%eax)
}
8010471d:	c9                   	leave  
8010471e:	c3                   	ret    

8010471f <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010471f:	55                   	push   %ebp
80104720:	89 e5                	mov    %esp,%ebp
80104722:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104725:	e8 e0 f8 ff ff       	call   8010400a <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010472a:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104731:	e8 91 08 00 00       	call   80104fc7 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104736:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
8010473d:	eb 5f                	jmp    8010479e <scheduler+0x7f>
      if(p->state != RUNNABLE)
8010473f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104742:	8b 40 0c             	mov    0xc(%eax),%eax
80104745:	83 f8 03             	cmp    $0x3,%eax
80104748:	75 4f                	jne    80104799 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
8010474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474d:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104756:	89 04 24             	mov    %eax,(%esp)
80104759:	e8 fc 36 00 00       	call   80107e5a <switchuvm>
      p->state = RUNNING;
8010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104761:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104768:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010476e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104771:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104778:	83 c2 04             	add    $0x4,%edx
8010477b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010477f:	89 14 24             	mov    %edx,(%esp)
80104782:	e8 15 0d 00 00       	call   8010549c <swtch>
      switchkvm();
80104787:	e8 b1 36 00 00       	call   80107e3d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010478c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104793:	00 00 00 00 
80104797:	eb 01                	jmp    8010479a <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104799:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010479a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010479e:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
801047a5:	72 98                	jb     8010473f <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
801047a7:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801047ae:	e8 76 08 00 00       	call   80105029 <release>

  }
801047b3:	e9 6d ff ff ff       	jmp    80104725 <scheduler+0x6>

801047b8 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801047b8:	55                   	push   %ebp
801047b9:	89 e5                	mov    %esp,%ebp
801047bb:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801047be:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801047c5:	e8 25 09 00 00       	call   801050ef <holding>
801047ca:	85 c0                	test   %eax,%eax
801047cc:	75 0c                	jne    801047da <sched+0x22>
    panic("sched ptable.lock");
801047ce:	c7 04 24 68 8e 10 80 	movl   $0x80108e68,(%esp)
801047d5:	e8 5c bd ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
801047da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047e0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801047e6:	83 f8 01             	cmp    $0x1,%eax
801047e9:	74 0c                	je     801047f7 <sched+0x3f>
    panic("sched locks");
801047eb:	c7 04 24 7a 8e 10 80 	movl   $0x80108e7a,(%esp)
801047f2:	e8 3f bd ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801047f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fd:	8b 40 0c             	mov    0xc(%eax),%eax
80104800:	83 f8 04             	cmp    $0x4,%eax
80104803:	75 0c                	jne    80104811 <sched+0x59>
    panic("sched running");
80104805:	c7 04 24 86 8e 10 80 	movl   $0x80108e86,(%esp)
8010480c:	e8 25 bd ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104811:	e8 df f7 ff ff       	call   80103ff5 <readeflags>
80104816:	25 00 02 00 00       	and    $0x200,%eax
8010481b:	85 c0                	test   %eax,%eax
8010481d:	74 0c                	je     8010482b <sched+0x73>
    panic("sched interruptible");
8010481f:	c7 04 24 94 8e 10 80 	movl   $0x80108e94,(%esp)
80104826:	e8 0b bd ff ff       	call   80100536 <panic>
  intena = cpu->intena;
8010482b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104831:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010483a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104840:	8b 40 04             	mov    0x4(%eax),%eax
80104843:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010484a:	83 c2 1c             	add    $0x1c,%edx
8010484d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104851:	89 14 24             	mov    %edx,(%esp)
80104854:	e8 43 0c 00 00       	call   8010549c <swtch>
  cpu->intena = intena;
80104859:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010485f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104862:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104868:	c9                   	leave  
80104869:	c3                   	ret    

8010486a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010486a:	55                   	push   %ebp
8010486b:	89 e5                	mov    %esp,%ebp
8010486d:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104870:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104877:	e8 4b 07 00 00       	call   80104fc7 <acquire>
  proc->state = RUNNABLE;
8010487c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104882:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104889:	e8 2a ff ff ff       	call   801047b8 <sched>
  release(&ptable.lock);
8010488e:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104895:	e8 8f 07 00 00       	call   80105029 <release>
}
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    

8010489c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010489c:	55                   	push   %ebp
8010489d:	89 e5                	mov    %esp,%ebp
8010489f:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801048a2:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801048a9:	e8 7b 07 00 00       	call   80105029 <release>

  if (first) {
801048ae:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801048b3:	85 c0                	test   %eax,%eax
801048b5:	74 0f                	je     801048c6 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801048b7:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
801048be:	00 00 00 
    initlog();
801048c1:	e8 06 e7 ff ff       	call   80102fcc <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801048c6:	c9                   	leave  
801048c7:	c3                   	ret    

801048c8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801048c8:	55                   	push   %ebp
801048c9:	89 e5                	mov    %esp,%ebp
801048cb:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801048ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d4:	85 c0                	test   %eax,%eax
801048d6:	75 0c                	jne    801048e4 <sleep+0x1c>
    panic("sleep");
801048d8:	c7 04 24 a8 8e 10 80 	movl   $0x80108ea8,(%esp)
801048df:	e8 52 bc ff ff       	call   80100536 <panic>

  if(lk == 0)
801048e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801048e8:	75 0c                	jne    801048f6 <sleep+0x2e>
    panic("sleep without lk");
801048ea:	c7 04 24 ae 8e 10 80 	movl   $0x80108eae,(%esp)
801048f1:	e8 40 bc ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048f6:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
801048fd:	74 17                	je     80104916 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048ff:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104906:	e8 bc 06 00 00       	call   80104fc7 <acquire>
    release(lk);
8010490b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 13 07 00 00       	call   80105029 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104916:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491c:	8b 55 08             	mov    0x8(%ebp),%edx
8010491f:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104922:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104928:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010492f:	e8 84 fe ff ff       	call   801047b8 <sched>

  // Tidy up.
  proc->chan = 0;
80104934:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493a:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104941:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
80104948:	74 17                	je     80104961 <sleep+0x99>
    release(&ptable.lock);
8010494a:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104951:	e8 d3 06 00 00       	call   80105029 <release>
    acquire(lk);
80104956:	8b 45 0c             	mov    0xc(%ebp),%eax
80104959:	89 04 24             	mov    %eax,(%esp)
8010495c:	e8 66 06 00 00       	call   80104fc7 <acquire>
  }
}
80104961:	c9                   	leave  
80104962:	c3                   	ret    

80104963 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104963:	55                   	push   %ebp
80104964:	89 e5                	mov    %esp,%ebp
80104966:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104969:	c7 45 fc 74 0f 11 80 	movl   $0x80110f74,-0x4(%ebp)
80104970:	eb 24                	jmp    80104996 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104972:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104975:	8b 40 0c             	mov    0xc(%eax),%eax
80104978:	83 f8 02             	cmp    $0x2,%eax
8010497b:	75 15                	jne    80104992 <wakeup1+0x2f>
8010497d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104980:	8b 40 20             	mov    0x20(%eax),%eax
80104983:	3b 45 08             	cmp    0x8(%ebp),%eax
80104986:	75 0a                	jne    80104992 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104988:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010498b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104992:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104996:	81 7d fc 74 2e 11 80 	cmpl   $0x80112e74,-0x4(%ebp)
8010499d:	72 d3                	jb     80104972 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010499f:	c9                   	leave  
801049a0:	c3                   	ret    

801049a1 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049a1:	55                   	push   %ebp
801049a2:	89 e5                	mov    %esp,%ebp
801049a4:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801049a7:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801049ae:	e8 14 06 00 00       	call   80104fc7 <acquire>
  wakeup1(chan);
801049b3:	8b 45 08             	mov    0x8(%ebp),%eax
801049b6:	89 04 24             	mov    %eax,(%esp)
801049b9:	e8 a5 ff ff ff       	call   80104963 <wakeup1>
  release(&ptable.lock);
801049be:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801049c5:	e8 5f 06 00 00       	call   80105029 <release>
}
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    

801049cc <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049cc:	55                   	push   %ebp
801049cd:	89 e5                	mov    %esp,%ebp
801049cf:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
801049d2:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801049d9:	e8 e9 05 00 00       	call   80104fc7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049de:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
801049e5:	eb 41                	jmp    80104a28 <kill+0x5c>
    if(p->pid == pid){
801049e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ea:	8b 40 10             	mov    0x10(%eax),%eax
801049ed:	3b 45 08             	cmp    0x8(%ebp),%eax
801049f0:	75 32                	jne    80104a24 <kill+0x58>
      p->killed = 1;
801049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ff:	8b 40 0c             	mov    0xc(%eax),%eax
80104a02:	83 f8 02             	cmp    $0x2,%eax
80104a05:	75 0a                	jne    80104a11 <kill+0x45>
        p->state = RUNNABLE;
80104a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a11:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104a18:	e8 0c 06 00 00       	call   80105029 <release>
      return 0;
80104a1d:	b8 00 00 00 00       	mov    $0x0,%eax
80104a22:	eb 1e                	jmp    80104a42 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a24:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a28:	81 7d f4 74 2e 11 80 	cmpl   $0x80112e74,-0xc(%ebp)
80104a2f:	72 b6                	jb     801049e7 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104a31:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104a38:	e8 ec 05 00 00       	call   80105029 <release>
  return -1;
80104a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a42:	c9                   	leave  
80104a43:	c3                   	ret    

80104a44 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  cprintf("\n------------------------------procdump-----------------------------------\n");
80104a4d:	c7 04 24 c0 8e 10 80 	movl   $0x80108ec0,(%esp)
80104a54:	e8 48 b9 ff ff       	call   801003a1 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a59:	c7 45 f0 74 0f 11 80 	movl   $0x80110f74,-0x10(%ebp)
80104a60:	e9 89 03 00 00       	jmp    80104dee <procdump+0x3aa>
      if(p->state == UNUSED)
80104a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a68:	8b 40 0c             	mov    0xc(%eax),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	0f 84 76 03 00 00    	je     80104de9 <procdump+0x3a5>
          continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a76:	8b 40 0c             	mov    0xc(%eax),%eax
80104a79:	83 f8 05             	cmp    $0x5,%eax
80104a7c:	77 23                	ja     80104aa1 <procdump+0x5d>
80104a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a81:	8b 40 0c             	mov    0xc(%eax),%eax
80104a84:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104a8b:	85 c0                	test   %eax,%eax
80104a8d:	74 12                	je     80104aa1 <procdump+0x5d>
          state = states[p->state];
80104a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a92:	8b 40 0c             	mov    0xc(%eax),%eax
80104a95:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a9f:	eb 07                	jmp    80104aa8 <procdump+0x64>
      else
          state = "???";
80104aa1:	c7 45 ec 0c 8f 10 80 	movl   $0x80108f0c,-0x14(%ebp)
      cprintf("%d %s %s", p->pid, state, p->name);
80104aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aab:	8d 50 6c             	lea    0x6c(%eax),%edx
80104aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ab1:	8b 40 10             	mov    0x10(%eax),%eax
80104ab4:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104ab8:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104abb:	89 54 24 08          	mov    %edx,0x8(%esp)
80104abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac3:	c7 04 24 10 8f 10 80 	movl   $0x80108f10,(%esp)
80104aca:	e8 d2 b8 ff ff       	call   801003a1 <cprintf>
      if(p->state == SLEEPING || p->state == RUNNABLE || p->state == RUNNING){
80104acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ad5:	83 f8 02             	cmp    $0x2,%eax
80104ad8:	74 1a                	je     80104af4 <procdump+0xb0>
80104ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104add:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae0:	83 f8 03             	cmp    $0x3,%eax
80104ae3:	74 0f                	je     80104af4 <procdump+0xb0>
80104ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ae8:	8b 40 0c             	mov    0xc(%eax),%eax
80104aeb:	83 f8 04             	cmp    $0x4,%eax
80104aee:	0f 85 e7 02 00 00    	jne    80104ddb <procdump+0x397>
          getcallerpcs((uint*)p->context->ebp+2, pc);
80104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af7:	8b 40 1c             	mov    0x1c(%eax),%eax
80104afa:	8b 40 0c             	mov    0xc(%eax),%eax
80104afd:	83 c0 08             	add    $0x8,%eax
80104b00:	8d 55 80             	lea    -0x80(%ebp),%edx
80104b03:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b07:	89 04 24             	mov    %eax,(%esp)
80104b0a:	e8 69 05 00 00       	call   80105078 <getcallerpcs>
          for(i=0; i<10 && pc[i] != 0; i++)
80104b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b16:	eb 1a                	jmp    80104b32 <procdump+0xee>
              cprintf(" %p", pc[i]);
80104b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1b:	8b 44 85 80          	mov    -0x80(%ebp,%eax,4),%eax
80104b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b23:	c7 04 24 19 8f 10 80 	movl   $0x80108f19,(%esp)
80104b2a:	e8 72 b8 ff ff       	call   801003a1 <cprintf>
      else
          state = "???";
      cprintf("%d %s %s", p->pid, state, p->name);
      if(p->state == SLEEPING || p->state == RUNNABLE || p->state == RUNNING){
          getcallerpcs((uint*)p->context->ebp+2, pc);
          for(i=0; i<10 && pc[i] != 0; i++)
80104b2f:	ff 45 f4             	incl   -0xc(%ebp)
80104b32:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104b36:	7f 0b                	jg     80104b43 <procdump+0xff>
80104b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3b:	8b 44 85 80          	mov    -0x80(%ebp,%eax,4),%eax
80104b3f:	85 c0                	test   %eax,%eax
80104b41:	75 d5                	jne    80104b18 <procdump+0xd4>
              cprintf(" %p", pc[i]);
          //3.1
          cprintf("\n*Page tables:\n");
80104b43:	c7 04 24 1d 8f 10 80 	movl   $0x80108f1d,(%esp)
80104b4a:	e8 52 b8 ff ff       	call   801003a1 <cprintf>
          cprintf("memory location of page directory = %d\n",p->pgdir);
80104b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b52:	8b 40 04             	mov    0x4(%eax),%eax
80104b55:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b59:	c7 04 24 30 8f 10 80 	movl   $0x80108f30,(%esp)
80104b60:	e8 3c b8 ff ff       	call   801003a1 <cprintf>
          int n = 1;
80104b65:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
          for(i=0 ; i < NPDENTRIES ;i++) {
80104b6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b73:	e9 1d 01 00 00       	jmp    80104c95 <procdump+0x251>
              //1.3
              int j;
              pde_t *pde = &p->pgdir[i];              // page drivetory entry
80104b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b7b:	8b 40 04             	mov    0x4(%eax),%eax
80104b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b81:	c1 e2 02             	shl    $0x2,%edx
80104b84:	01 d0                	add    %edx,%eax
80104b86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
              pte_t *pgtab;                           // page table address
              pde_t *pte;                             // page table entry

              if((*pde & PTE_P) && (*pde & PTE_U) && (*pde & PTE_A)) {
80104b89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b8c:	8b 00                	mov    (%eax),%eax
80104b8e:	83 e0 01             	and    $0x1,%eax
80104b91:	85 c0                	test   %eax,%eax
80104b93:	0f 84 f9 00 00 00    	je     80104c92 <procdump+0x24e>
80104b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b9c:	8b 00                	mov    (%eax),%eax
80104b9e:	83 e0 04             	and    $0x4,%eax
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	0f 84 e9 00 00 00    	je     80104c92 <procdump+0x24e>
80104ba9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104bac:	8b 00                	mov    (%eax),%eax
80104bae:	83 e0 20             	and    $0x20,%eax
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	0f 84 d9 00 00 00    	je     80104c92 <procdump+0x24e>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
80104bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104bbc:	8b 00                	mov    (%eax),%eax
80104bbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104bc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
80104bc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104bc9:	89 04 24             	mov    %eax,(%esp)
80104bcc:	e8 17 f4 ff ff       	call   80103fe8 <p2v>
80104bd1:	89 45 cc             	mov    %eax,-0x34(%ebp)
                  uint phyppn;
                  uint pte_ppn;

                  cprintf("\n%d) pdir PTE %d, %p \n",n,i,pde_ppn);
80104bd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bde:	89 44 24 08          	mov    %eax,0x8(%esp)
80104be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104be5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be9:	c7 04 24 58 8f 10 80 	movl   $0x80108f58,(%esp)
80104bf0:	e8 ac b7 ff ff       	call   801003a1 <cprintf>
                  n++;
80104bf5:	ff 45 e8             	incl   -0x18(%ebp)
                  cprintf("memory location of page table = %p\n",pgtab);
80104bf8:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bff:	c7 04 24 70 8f 10 80 	movl   $0x80108f70,(%esp)
80104c06:	e8 96 b7 ff ff       	call   801003a1 <cprintf>
                  for(j=0 ; j < NPTENTRIES ; j++) {
80104c0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104c12:	eb 75                	jmp    80104c89 <procdump+0x245>
                      pte = &pgtab[j];
80104c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104c1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104c21:	01 d0                	add    %edx,%eax
80104c23:	89 45 c8             	mov    %eax,-0x38(%ebp)

                      if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)) {
80104c26:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104c29:	8b 00                	mov    (%eax),%eax
80104c2b:	83 e0 01             	and    $0x1,%eax
80104c2e:	85 c0                	test   %eax,%eax
80104c30:	74 54                	je     80104c86 <procdump+0x242>
80104c32:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104c35:	8b 00                	mov    (%eax),%eax
80104c37:	83 e0 04             	and    $0x4,%eax
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	74 48                	je     80104c86 <procdump+0x242>
80104c3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104c41:	8b 00                	mov    (%eax),%eax
80104c43:	83 e0 20             	and    $0x20,%eax
80104c46:	85 c0                	test   %eax,%eax
80104c48:	74 3c                	je     80104c86 <procdump+0x242>
                          pte_ppn = PTE_ADDR(*pte);
80104c4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104c4d:	8b 00                	mov    (%eax),%eax
80104c4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104c54:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                          phyppn = (pte_t)p2v(pte_ppn);
80104c57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c5a:	89 04 24             	mov    %eax,(%esp)
80104c5d:	e8 86 f3 ff ff       	call   80103fe8 <p2v>
80104c62:	89 45 c0             	mov    %eax,-0x40(%ebp)
                          cprintf("    |__ptble PTE %d, %d, %p\n",j,pte_ppn,phyppn);
80104c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c68:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104c6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c6f:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c76:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c7a:	c7 04 24 94 8f 10 80 	movl   $0x80108f94,(%esp)
80104c81:	e8 1b b7 ff ff       	call   801003a1 <cprintf>
                  uint pte_ppn;

                  cprintf("\n%d) pdir PTE %d, %p \n",n,i,pde_ppn);
                  n++;
                  cprintf("memory location of page table = %p\n",pgtab);
                  for(j=0 ; j < NPTENTRIES ; j++) {
80104c86:	ff 45 e4             	incl   -0x1c(%ebp)
80104c89:	81 7d e4 ff 03 00 00 	cmpl   $0x3ff,-0x1c(%ebp)
80104c90:	7e 82                	jle    80104c14 <procdump+0x1d0>
              cprintf(" %p", pc[i]);
          //3.1
          cprintf("\n*Page tables:\n");
          cprintf("memory location of page directory = %d\n",p->pgdir);
          int n = 1;
          for(i=0 ; i < NPDENTRIES ;i++) {
80104c92:	ff 45 f4             	incl   -0xc(%ebp)
80104c95:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80104c9c:	0f 8e d6 fe ff ff    	jle    80104b78 <procdump+0x134>
                          cprintf("    |__ptble PTE %d, %d, %p\n",j,pte_ppn,phyppn);
                      }
                  }
              }
          }
          cprintf("\n\n**Page mapping**\n"); 
80104ca2:	c7 04 24 b1 8f 10 80 	movl   $0x80108fb1,(%esp)
80104ca9:	e8 f3 b6 ff ff       	call   801003a1 <cprintf>
          for(i=0 ; i < NPDENTRIES ;i++) {
80104cae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104cb5:	e9 14 01 00 00       	jmp    80104dce <procdump+0x38a>
              //1.3
              int j;
              pde_t *pde = &p->pgdir[i];              // page drivetory entry
80104cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cbd:	8b 40 04             	mov    0x4(%eax),%eax
80104cc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cc3:	c1 e2 02             	shl    $0x2,%edx
80104cc6:	01 d0                	add    %edx,%eax
80104cc8:	89 45 bc             	mov    %eax,-0x44(%ebp)
              pte_t *pgtab;                           // page table address
              pde_t *pte;                             // page table entry

              if((*pde & PTE_P) && (*pde & PTE_U)  ) {
80104ccb:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104cce:	8b 00                	mov    (%eax),%eax
80104cd0:	83 e0 01             	and    $0x1,%eax
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	0f 84 f0 00 00 00    	je     80104dcb <procdump+0x387>
80104cdb:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104cde:	8b 00                	mov    (%eax),%eax
80104ce0:	83 e0 04             	and    $0x4,%eax
80104ce3:	85 c0                	test   %eax,%eax
80104ce5:	0f 84 e0 00 00 00    	je     80104dcb <procdump+0x387>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
80104ceb:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104cee:	8b 00                	mov    (%eax),%eax
80104cf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104cf5:	89 45 b8             	mov    %eax,-0x48(%ebp)
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
80104cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80104cfb:	89 04 24             	mov    %eax,(%esp)
80104cfe:	e8 e5 f2 ff ff       	call   80103fe8 <p2v>
80104d03:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                  uint virppn;
                  uint pte_ppn;

                  for(j=0 ; j < NPTENTRIES ; j++) {
80104d06:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80104d0d:	e9 ac 00 00 00       	jmp    80104dbe <procdump+0x37a>
                      pte = &pgtab[j];
80104d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d1c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d1f:	01 d0                	add    %edx,%eax
80104d21:	89 45 b0             	mov    %eax,-0x50(%ebp)

                      if((*pte & PTE_P) && (*pte & PTE_U) ) {
80104d24:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d27:	8b 00                	mov    (%eax),%eax
80104d29:	83 e0 01             	and    $0x1,%eax
80104d2c:	85 c0                	test   %eax,%eax
80104d2e:	0f 84 87 00 00 00    	je     80104dbb <procdump+0x377>
80104d34:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d37:	8b 00                	mov    (%eax),%eax
80104d39:	83 e0 04             	and    $0x4,%eax
80104d3c:	85 c0                	test   %eax,%eax
80104d3e:	74 7b                	je     80104dbb <procdump+0x377>
                          pte_ppn = PTE_ADDR(*pte);
80104d40:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d43:	8b 00                	mov    (%eax),%eax
80104d45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104d4a:	89 45 ac             	mov    %eax,-0x54(%ebp)
                          virppn = (pte_t)p2v(pte_ppn);
80104d4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
80104d50:	89 04 24             	mov    %eax,(%esp)
80104d53:	e8 90 f2 ff ff       	call   80103fe8 <p2v>
80104d58:	89 45 a8             	mov    %eax,-0x58(%ebp)

                          char *readOnly = "n";
80104d5b:	c7 45 dc c5 8f 10 80 	movl   $0x80108fc5,-0x24(%ebp)
                          char *shared   = "n";
80104d62:	c7 45 d8 c5 8f 10 80 	movl   $0x80108fc5,-0x28(%ebp)
                          
                          if((*pte & PTE_SHARED)) {
80104d69:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d6c:	8b 00                	mov    (%eax),%eax
80104d6e:	25 00 02 00 00       	and    $0x200,%eax
80104d73:	85 c0                	test   %eax,%eax
80104d75:	74 09                	je     80104d80 <procdump+0x33c>
                              shared = "y";
80104d77:	c7 45 d8 c7 8f 10 80 	movl   $0x80108fc7,-0x28(%ebp)
80104d7e:	eb 13                	jmp    80104d93 <procdump+0x34f>
                          } else if (!(*pte & PTE_W)) {
80104d80:	8b 45 b0             	mov    -0x50(%ebp),%eax
80104d83:	8b 00                	mov    (%eax),%eax
80104d85:	83 e0 02             	and    $0x2,%eax
80104d88:	85 c0                	test   %eax,%eax
80104d8a:	75 07                	jne    80104d93 <procdump+0x34f>
                              readOnly = "y";
80104d8c:	c7 45 dc c7 8f 10 80 	movl   $0x80108fc7,-0x24(%ebp)
                          }
                          cprintf("%d -> %d , %s , %s \n",virppn,pte_ppn,readOnly,shared);
80104d93:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104d96:	89 44 24 10          	mov    %eax,0x10(%esp)
80104d9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104d9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104da1:	8b 45 ac             	mov    -0x54(%ebp),%eax
80104da4:	89 44 24 08          	mov    %eax,0x8(%esp)
80104da8:	8b 45 a8             	mov    -0x58(%ebp),%eax
80104dab:	89 44 24 04          	mov    %eax,0x4(%esp)
80104daf:	c7 04 24 c9 8f 10 80 	movl   $0x80108fc9,(%esp)
80104db6:	e8 e6 b5 ff ff       	call   801003a1 <cprintf>
                  uint pde_ppn    =  PTE_ADDR(*pde);          // 20 MSBs in pgdir entry.
                  pgtab = (pte_t*)p2v(pde_ppn);               // address of relevant page table
                  uint virppn;
                  uint pte_ppn;

                  for(j=0 ; j < NPTENTRIES ; j++) {
80104dbb:	ff 45 e0             	incl   -0x20(%ebp)
80104dbe:	81 7d e0 ff 03 00 00 	cmpl   $0x3ff,-0x20(%ebp)
80104dc5:	0f 8e 47 ff ff ff    	jle    80104d12 <procdump+0x2ce>
                      }
                  }
              }
          }
          cprintf("\n\n**Page mapping**\n"); 
          for(i=0 ; i < NPDENTRIES ;i++) {
80104dcb:	ff 45 f4             	incl   -0xc(%ebp)
80104dce:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80104dd5:	0f 8e df fe ff ff    	jle    80104cba <procdump+0x276>
                      }
                  }
              }
          }
      }
    cprintf("-------------------------------------------------------------------------\n");
80104ddb:	c7 04 24 e0 8f 10 80 	movl   $0x80108fe0,(%esp)
80104de2:	e8 ba b5 ff ff       	call   801003a1 <cprintf>
80104de7:	eb 01                	jmp    80104dea <procdump+0x3a6>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == UNUSED)
          continue;
80104de9:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dea:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104dee:	81 7d f0 74 2e 11 80 	cmpl   $0x80112e74,-0x10(%ebp)
80104df5:	0f 82 6a fc ff ff    	jb     80104a65 <procdump+0x21>
              }
          }
      }
    cprintf("-------------------------------------------------------------------------\n");
  }
}
80104dfb:	c9                   	leave  
80104dfc:	c3                   	ret    

80104dfd <cowfork>:
// 3.4 Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
cowfork(void)
{
80104dfd:	55                   	push   %ebp
80104dfe:	89 e5                	mov    %esp,%ebp
80104e00:	57                   	push   %edi
80104e01:	56                   	push   %esi
80104e02:	53                   	push   %ebx
80104e03:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104e06:	e8 21 f2 ff ff       	call   8010402c <allocproc>
80104e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104e12:	75 0a                	jne    80104e1e <cowfork+0x21>
    return -1;
80104e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e19:	e9 39 01 00 00       	jmp    80104f57 <cowfork+0x15a>

  // Copy process state from p.
  if((np->pgdir = copyuvm_cow(proc->pgdir, proc->sz)) == 0){
80104e1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e24:	8b 10                	mov    (%eax),%edx
80104e26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2c:	8b 40 04             	mov    0x4(%eax),%eax
80104e2f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e33:	89 04 24             	mov    %eax,(%esp)
80104e36:	e8 cb 39 00 00       	call   80108806 <copyuvm_cow>
80104e3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104e3e:	89 42 04             	mov    %eax,0x4(%edx)
80104e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e44:	8b 40 04             	mov    0x4(%eax),%eax
80104e47:	85 c0                	test   %eax,%eax
80104e49:	75 2c                	jne    80104e77 <cowfork+0x7a>
    kfree(np->kstack);
80104e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e4e:	8b 40 08             	mov    0x8(%eax),%eax
80104e51:	89 04 24             	mov    %eax,(%esp)
80104e54:	e8 d5 db ff ff       	call   80102a2e <kfree>
    np->kstack = 0;
80104e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e72:	e9 e0 00 00 00       	jmp    80104f57 <cowfork+0x15a>
  }
  np->sz = proc->sz;
80104e77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7d:	8b 10                	mov    (%eax),%edx
80104e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e82:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104e84:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e8e:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e94:	8b 50 18             	mov    0x18(%eax),%edx
80104e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ea0:	89 c3                	mov    %eax,%ebx
80104ea2:	b8 13 00 00 00       	mov    $0x13,%eax
80104ea7:	89 d7                	mov    %edx,%edi
80104ea9:	89 de                	mov    %ebx,%esi
80104eab:	89 c1                	mov    %eax,%ecx
80104ead:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb2:	8b 40 18             	mov    0x18(%eax),%eax
80104eb5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104ebc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ec3:	eb 3c                	jmp    80104f01 <cowfork+0x104>
    if(proc->ofile[i])
80104ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ece:	83 c2 08             	add    $0x8,%edx
80104ed1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ed5:	85 c0                	test   %eax,%eax
80104ed7:	74 25                	je     80104efe <cowfork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104ed9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104edf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ee2:	83 c2 08             	add    $0x8,%edx
80104ee5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ee9:	89 04 24             	mov    %eax,(%esp)
80104eec:	e8 8b c0 ff ff       	call   80100f7c <filedup>
80104ef1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104ef4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104ef7:	83 c1 08             	add    $0x8,%ecx
80104efa:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104efe:	ff 45 e4             	incl   -0x1c(%ebp)
80104f01:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104f05:	7e be                	jle    80104ec5 <cowfork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f0d:	8b 40 68             	mov    0x68(%eax),%eax
80104f10:	89 04 24             	mov    %eax,(%esp)
80104f13:	e8 00 c9 ff ff       	call   80101818 <idup>
80104f18:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104f1b:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f21:	8b 40 10             	mov    0x10(%eax),%eax
80104f24:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104f27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f2a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104f31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f37:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f3d:	83 c0 6c             	add    $0x6c,%eax
80104f40:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104f47:	00 
80104f48:	89 54 24 04          	mov    %edx,0x4(%esp)
80104f4c:	89 04 24             	mov    %eax,(%esp)
80104f4f:	e8 d8 04 00 00       	call   8010542c <safestrcpy>
  return pid;
80104f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104f57:	83 c4 2c             	add    $0x2c,%esp
80104f5a:	5b                   	pop    %ebx
80104f5b:	5e                   	pop    %esi
80104f5c:	5f                   	pop    %edi
80104f5d:	5d                   	pop    %ebp
80104f5e:	c3                   	ret    
80104f5f:	90                   	nop

80104f60 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f67:	9c                   	pushf  
80104f68:	5b                   	pop    %ebx
80104f69:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	5b                   	pop    %ebx
80104f73:	5d                   	pop    %ebp
80104f74:	c3                   	ret    

80104f75 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f75:	55                   	push   %ebp
80104f76:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f78:	fa                   	cli    
}
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    

80104f7b <sti>:

static inline void
sti(void)
{
80104f7b:	55                   	push   %ebp
80104f7c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f7e:	fb                   	sti    
}
80104f7f:	5d                   	pop    %ebp
80104f80:	c3                   	ret    

80104f81 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f81:	55                   	push   %ebp
80104f82:	89 e5                	mov    %esp,%ebp
80104f84:	53                   	push   %ebx
80104f85:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104f88:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f91:	89 c3                	mov    %eax,%ebx
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	f0 87 02             	lock xchg %eax,(%edx)
80104f98:	89 c3                	mov    %eax,%ebx
80104f9a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104fa0:	83 c4 10             	add    $0x10,%esp
80104fa3:	5b                   	pop    %ebx
80104fa4:	5d                   	pop    %ebp
80104fa5:	c3                   	ret    

80104fa6 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fa6:	55                   	push   %ebp
80104fa7:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fac:	8b 55 0c             	mov    0xc(%ebp),%edx
80104faf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fc5:	5d                   	pop    %ebp
80104fc6:	c3                   	ret    

80104fc7 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104fc7:	55                   	push   %ebp
80104fc8:	89 e5                	mov    %esp,%ebp
80104fca:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104fcd:	e8 47 01 00 00       	call   80105119 <pushcli>
  if(holding(lk))
80104fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd5:	89 04 24             	mov    %eax,(%esp)
80104fd8:	e8 12 01 00 00       	call   801050ef <holding>
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	74 0c                	je     80104fed <acquire+0x26>
    panic("acquire");
80104fe1:	c7 04 24 55 90 10 80 	movl   $0x80109055,(%esp)
80104fe8:	e8 49 b5 ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fed:	90                   	nop
80104fee:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104ff8:	00 
80104ff9:	89 04 24             	mov    %eax,(%esp)
80104ffc:	e8 80 ff ff ff       	call   80104f81 <xchg>
80105001:	85 c0                	test   %eax,%eax
80105003:	75 e9                	jne    80104fee <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010500f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105012:	8b 45 08             	mov    0x8(%ebp),%eax
80105015:	83 c0 0c             	add    $0xc,%eax
80105018:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501c:	8d 45 08             	lea    0x8(%ebp),%eax
8010501f:	89 04 24             	mov    %eax,(%esp)
80105022:	e8 51 00 00 00       	call   80105078 <getcallerpcs>
}
80105027:	c9                   	leave  
80105028:	c3                   	ret    

80105029 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105029:	55                   	push   %ebp
8010502a:	89 e5                	mov    %esp,%ebp
8010502c:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010502f:	8b 45 08             	mov    0x8(%ebp),%eax
80105032:	89 04 24             	mov    %eax,(%esp)
80105035:	e8 b5 00 00 00       	call   801050ef <holding>
8010503a:	85 c0                	test   %eax,%eax
8010503c:	75 0c                	jne    8010504a <release+0x21>
    panic("release");
8010503e:	c7 04 24 5d 90 10 80 	movl   $0x8010905d,(%esp)
80105045:	e8 ec b4 ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
8010504a:	8b 45 08             	mov    0x8(%ebp),%eax
8010504d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105054:	8b 45 08             	mov    0x8(%ebp),%eax
80105057:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010505e:	8b 45 08             	mov    0x8(%ebp),%eax
80105061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105068:	00 
80105069:	89 04 24             	mov    %eax,(%esp)
8010506c:	e8 10 ff ff ff       	call   80104f81 <xchg>

  popcli();
80105071:	e8 e9 00 00 00       	call   8010515f <popcli>
}
80105076:	c9                   	leave  
80105077:	c3                   	ret    

80105078 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105078:	55                   	push   %ebp
80105079:	89 e5                	mov    %esp,%ebp
8010507b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010507e:	8b 45 08             	mov    0x8(%ebp),%eax
80105081:	83 e8 08             	sub    $0x8,%eax
80105084:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105087:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010508e:	eb 37                	jmp    801050c7 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105090:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105094:	74 51                	je     801050e7 <getcallerpcs+0x6f>
80105096:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010509d:	76 48                	jbe    801050e7 <getcallerpcs+0x6f>
8010509f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801050a3:	74 42                	je     801050e7 <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050af:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b2:	01 c2                	add    %eax,%edx
801050b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b7:	8b 40 04             	mov    0x4(%eax),%eax
801050ba:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801050bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050bf:	8b 00                	mov    (%eax),%eax
801050c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050c4:	ff 45 f8             	incl   -0x8(%ebp)
801050c7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050cb:	7e c3                	jle    80105090 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050cd:	eb 18                	jmp    801050e7 <getcallerpcs+0x6f>
    pcs[i] = 0;
801050cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050dc:	01 d0                	add    %edx,%eax
801050de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050e4:	ff 45 f8             	incl   -0x8(%ebp)
801050e7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050eb:	7e e2                	jle    801050cf <getcallerpcs+0x57>
    pcs[i] = 0;
}
801050ed:	c9                   	leave  
801050ee:	c3                   	ret    

801050ef <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050ef:	55                   	push   %ebp
801050f0:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050f2:	8b 45 08             	mov    0x8(%ebp),%eax
801050f5:	8b 00                	mov    (%eax),%eax
801050f7:	85 c0                	test   %eax,%eax
801050f9:	74 17                	je     80105112 <holding+0x23>
801050fb:	8b 45 08             	mov    0x8(%ebp),%eax
801050fe:	8b 50 08             	mov    0x8(%eax),%edx
80105101:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105107:	39 c2                	cmp    %eax,%edx
80105109:	75 07                	jne    80105112 <holding+0x23>
8010510b:	b8 01 00 00 00       	mov    $0x1,%eax
80105110:	eb 05                	jmp    80105117 <holding+0x28>
80105112:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105117:	5d                   	pop    %ebp
80105118:	c3                   	ret    

80105119 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105119:	55                   	push   %ebp
8010511a:	89 e5                	mov    %esp,%ebp
8010511c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010511f:	e8 3c fe ff ff       	call   80104f60 <readeflags>
80105124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105127:	e8 49 fe ff ff       	call   80104f75 <cli>
  if(cpu->ncli++ == 0)
8010512c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105132:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105138:	85 d2                	test   %edx,%edx
8010513a:	0f 94 c1             	sete   %cl
8010513d:	42                   	inc    %edx
8010513e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105144:	84 c9                	test   %cl,%cl
80105146:	74 15                	je     8010515d <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80105148:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010514e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105151:	81 e2 00 02 00 00    	and    $0x200,%edx
80105157:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010515d:	c9                   	leave  
8010515e:	c3                   	ret    

8010515f <popcli>:

void
popcli(void)
{
8010515f:	55                   	push   %ebp
80105160:	89 e5                	mov    %esp,%ebp
80105162:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105165:	e8 f6 fd ff ff       	call   80104f60 <readeflags>
8010516a:	25 00 02 00 00       	and    $0x200,%eax
8010516f:	85 c0                	test   %eax,%eax
80105171:	74 0c                	je     8010517f <popcli+0x20>
    panic("popcli - interruptible");
80105173:	c7 04 24 65 90 10 80 	movl   $0x80109065,(%esp)
8010517a:	e8 b7 b3 ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
8010517f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105185:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010518b:	4a                   	dec    %edx
8010518c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105192:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105198:	85 c0                	test   %eax,%eax
8010519a:	79 0c                	jns    801051a8 <popcli+0x49>
    panic("popcli");
8010519c:	c7 04 24 7c 90 10 80 	movl   $0x8010907c,(%esp)
801051a3:	e8 8e b3 ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801051a8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051ae:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051b4:	85 c0                	test   %eax,%eax
801051b6:	75 15                	jne    801051cd <popcli+0x6e>
801051b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051be:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051c4:	85 c0                	test   %eax,%eax
801051c6:	74 05                	je     801051cd <popcli+0x6e>
    sti();
801051c8:	e8 ae fd ff ff       	call   80104f7b <sti>
}
801051cd:	c9                   	leave  
801051ce:	c3                   	ret    
801051cf:	90                   	nop

801051d0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801051d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051d8:	8b 55 10             	mov    0x10(%ebp),%edx
801051db:	8b 45 0c             	mov    0xc(%ebp),%eax
801051de:	89 cb                	mov    %ecx,%ebx
801051e0:	89 df                	mov    %ebx,%edi
801051e2:	89 d1                	mov    %edx,%ecx
801051e4:	fc                   	cld    
801051e5:	f3 aa                	rep stos %al,%es:(%edi)
801051e7:	89 ca                	mov    %ecx,%edx
801051e9:	89 fb                	mov    %edi,%ebx
801051eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051ee:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051f1:	5b                   	pop    %ebx
801051f2:	5f                   	pop    %edi
801051f3:	5d                   	pop    %ebp
801051f4:	c3                   	ret    

801051f5 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051f5:	55                   	push   %ebp
801051f6:	89 e5                	mov    %esp,%ebp
801051f8:	57                   	push   %edi
801051f9:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051fd:	8b 55 10             	mov    0x10(%ebp),%edx
80105200:	8b 45 0c             	mov    0xc(%ebp),%eax
80105203:	89 cb                	mov    %ecx,%ebx
80105205:	89 df                	mov    %ebx,%edi
80105207:	89 d1                	mov    %edx,%ecx
80105209:	fc                   	cld    
8010520a:	f3 ab                	rep stos %eax,%es:(%edi)
8010520c:	89 ca                	mov    %ecx,%edx
8010520e:	89 fb                	mov    %edi,%ebx
80105210:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105213:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105216:	5b                   	pop    %ebx
80105217:	5f                   	pop    %edi
80105218:	5d                   	pop    %ebp
80105219:	c3                   	ret    

8010521a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010521a:	55                   	push   %ebp
8010521b:	89 e5                	mov    %esp,%ebp
8010521d:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105220:	8b 45 08             	mov    0x8(%ebp),%eax
80105223:	83 e0 03             	and    $0x3,%eax
80105226:	85 c0                	test   %eax,%eax
80105228:	75 49                	jne    80105273 <memset+0x59>
8010522a:	8b 45 10             	mov    0x10(%ebp),%eax
8010522d:	83 e0 03             	and    $0x3,%eax
80105230:	85 c0                	test   %eax,%eax
80105232:	75 3f                	jne    80105273 <memset+0x59>
    c &= 0xFF;
80105234:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010523b:	8b 45 10             	mov    0x10(%ebp),%eax
8010523e:	c1 e8 02             	shr    $0x2,%eax
80105241:	89 c2                	mov    %eax,%edx
80105243:	8b 45 0c             	mov    0xc(%ebp),%eax
80105246:	89 c1                	mov    %eax,%ecx
80105248:	c1 e1 18             	shl    $0x18,%ecx
8010524b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524e:	c1 e0 10             	shl    $0x10,%eax
80105251:	09 c1                	or     %eax,%ecx
80105253:	8b 45 0c             	mov    0xc(%ebp),%eax
80105256:	c1 e0 08             	shl    $0x8,%eax
80105259:	09 c8                	or     %ecx,%eax
8010525b:	0b 45 0c             	or     0xc(%ebp),%eax
8010525e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105262:	89 44 24 04          	mov    %eax,0x4(%esp)
80105266:	8b 45 08             	mov    0x8(%ebp),%eax
80105269:	89 04 24             	mov    %eax,(%esp)
8010526c:	e8 84 ff ff ff       	call   801051f5 <stosl>
80105271:	eb 19                	jmp    8010528c <memset+0x72>
  } else
    stosb(dst, c, n);
80105273:	8b 45 10             	mov    0x10(%ebp),%eax
80105276:	89 44 24 08          	mov    %eax,0x8(%esp)
8010527a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105281:	8b 45 08             	mov    0x8(%ebp),%eax
80105284:	89 04 24             	mov    %eax,(%esp)
80105287:	e8 44 ff ff ff       	call   801051d0 <stosb>
  return dst;
8010528c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010528f:	c9                   	leave  
80105290:	c3                   	ret    

80105291 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105291:	55                   	push   %ebp
80105292:	89 e5                	mov    %esp,%ebp
80105294:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105297:	8b 45 08             	mov    0x8(%ebp),%eax
8010529a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010529d:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801052a3:	eb 2c                	jmp    801052d1 <memcmp+0x40>
    if(*s1 != *s2)
801052a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052a8:	8a 10                	mov    (%eax),%dl
801052aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ad:	8a 00                	mov    (%eax),%al
801052af:	38 c2                	cmp    %al,%dl
801052b1:	74 18                	je     801052cb <memcmp+0x3a>
      return *s1 - *s2;
801052b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052b6:	8a 00                	mov    (%eax),%al
801052b8:	0f b6 d0             	movzbl %al,%edx
801052bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052be:	8a 00                	mov    (%eax),%al
801052c0:	0f b6 c0             	movzbl %al,%eax
801052c3:	89 d1                	mov    %edx,%ecx
801052c5:	29 c1                	sub    %eax,%ecx
801052c7:	89 c8                	mov    %ecx,%eax
801052c9:	eb 19                	jmp    801052e4 <memcmp+0x53>
    s1++, s2++;
801052cb:	ff 45 fc             	incl   -0x4(%ebp)
801052ce:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052d5:	0f 95 c0             	setne  %al
801052d8:	ff 4d 10             	decl   0x10(%ebp)
801052db:	84 c0                	test   %al,%al
801052dd:	75 c6                	jne    801052a5 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801052df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052e4:	c9                   	leave  
801052e5:	c3                   	ret    

801052e6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052e6:	55                   	push   %ebp
801052e7:	89 e5                	mov    %esp,%ebp
801052e9:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801052ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052f2:	8b 45 08             	mov    0x8(%ebp),%eax
801052f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052fe:	73 4d                	jae    8010534d <memmove+0x67>
80105300:	8b 45 10             	mov    0x10(%ebp),%eax
80105303:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105306:	01 d0                	add    %edx,%eax
80105308:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010530b:	76 40                	jbe    8010534d <memmove+0x67>
    s += n;
8010530d:	8b 45 10             	mov    0x10(%ebp),%eax
80105310:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105313:	8b 45 10             	mov    0x10(%ebp),%eax
80105316:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105319:	eb 10                	jmp    8010532b <memmove+0x45>
      *--d = *--s;
8010531b:	ff 4d f8             	decl   -0x8(%ebp)
8010531e:	ff 4d fc             	decl   -0x4(%ebp)
80105321:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105324:	8a 10                	mov    (%eax),%dl
80105326:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105329:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010532b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010532f:	0f 95 c0             	setne  %al
80105332:	ff 4d 10             	decl   0x10(%ebp)
80105335:	84 c0                	test   %al,%al
80105337:	75 e2                	jne    8010531b <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105339:	eb 21                	jmp    8010535c <memmove+0x76>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010533b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010533e:	8a 10                	mov    (%eax),%dl
80105340:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105343:	88 10                	mov    %dl,(%eax)
80105345:	ff 45 f8             	incl   -0x8(%ebp)
80105348:	ff 45 fc             	incl   -0x4(%ebp)
8010534b:	eb 01                	jmp    8010534e <memmove+0x68>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010534d:	90                   	nop
8010534e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105352:	0f 95 c0             	setne  %al
80105355:	ff 4d 10             	decl   0x10(%ebp)
80105358:	84 c0                	test   %al,%al
8010535a:	75 df                	jne    8010533b <memmove+0x55>
      *d++ = *s++;

  return dst;
8010535c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010535f:	c9                   	leave  
80105360:	c3                   	ret    

80105361 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105361:	55                   	push   %ebp
80105362:	89 e5                	mov    %esp,%ebp
80105364:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105367:	8b 45 10             	mov    0x10(%ebp),%eax
8010536a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010536e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105371:	89 44 24 04          	mov    %eax,0x4(%esp)
80105375:	8b 45 08             	mov    0x8(%ebp),%eax
80105378:	89 04 24             	mov    %eax,(%esp)
8010537b:	e8 66 ff ff ff       	call   801052e6 <memmove>
}
80105380:	c9                   	leave  
80105381:	c3                   	ret    

80105382 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105382:	55                   	push   %ebp
80105383:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105385:	eb 09                	jmp    80105390 <strncmp+0xe>
    n--, p++, q++;
80105387:	ff 4d 10             	decl   0x10(%ebp)
8010538a:	ff 45 08             	incl   0x8(%ebp)
8010538d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105394:	74 17                	je     801053ad <strncmp+0x2b>
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
80105399:	8a 00                	mov    (%eax),%al
8010539b:	84 c0                	test   %al,%al
8010539d:	74 0e                	je     801053ad <strncmp+0x2b>
8010539f:	8b 45 08             	mov    0x8(%ebp),%eax
801053a2:	8a 10                	mov    (%eax),%dl
801053a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a7:	8a 00                	mov    (%eax),%al
801053a9:	38 c2                	cmp    %al,%dl
801053ab:	74 da                	je     80105387 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801053ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b1:	75 07                	jne    801053ba <strncmp+0x38>
    return 0;
801053b3:	b8 00 00 00 00       	mov    $0x0,%eax
801053b8:	eb 16                	jmp    801053d0 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
801053ba:	8b 45 08             	mov    0x8(%ebp),%eax
801053bd:	8a 00                	mov    (%eax),%al
801053bf:	0f b6 d0             	movzbl %al,%edx
801053c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c5:	8a 00                	mov    (%eax),%al
801053c7:	0f b6 c0             	movzbl %al,%eax
801053ca:	89 d1                	mov    %edx,%ecx
801053cc:	29 c1                	sub    %eax,%ecx
801053ce:	89 c8                	mov    %ecx,%eax
}
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    

801053d2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053d2:	55                   	push   %ebp
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053d8:	8b 45 08             	mov    0x8(%ebp),%eax
801053db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801053de:	90                   	nop
801053df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053e3:	0f 9f c0             	setg   %al
801053e6:	ff 4d 10             	decl   0x10(%ebp)
801053e9:	84 c0                	test   %al,%al
801053eb:	74 2b                	je     80105418 <strncpy+0x46>
801053ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f0:	8a 10                	mov    (%eax),%dl
801053f2:	8b 45 08             	mov    0x8(%ebp),%eax
801053f5:	88 10                	mov    %dl,(%eax)
801053f7:	8b 45 08             	mov    0x8(%ebp),%eax
801053fa:	8a 00                	mov    (%eax),%al
801053fc:	84 c0                	test   %al,%al
801053fe:	0f 95 c0             	setne  %al
80105401:	ff 45 08             	incl   0x8(%ebp)
80105404:	ff 45 0c             	incl   0xc(%ebp)
80105407:	84 c0                	test   %al,%al
80105409:	75 d4                	jne    801053df <strncpy+0xd>
    ;
  while(n-- > 0)
8010540b:	eb 0b                	jmp    80105418 <strncpy+0x46>
    *s++ = 0;
8010540d:	8b 45 08             	mov    0x8(%ebp),%eax
80105410:	c6 00 00             	movb   $0x0,(%eax)
80105413:	ff 45 08             	incl   0x8(%ebp)
80105416:	eb 01                	jmp    80105419 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105418:	90                   	nop
80105419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010541d:	0f 9f c0             	setg   %al
80105420:	ff 4d 10             	decl   0x10(%ebp)
80105423:	84 c0                	test   %al,%al
80105425:	75 e6                	jne    8010540d <strncpy+0x3b>
    *s++ = 0;
  return os;
80105427:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010542a:	c9                   	leave  
8010542b:	c3                   	ret    

8010542c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010542c:	55                   	push   %ebp
8010542d:	89 e5                	mov    %esp,%ebp
8010542f:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105432:	8b 45 08             	mov    0x8(%ebp),%eax
80105435:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105438:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010543c:	7f 05                	jg     80105443 <safestrcpy+0x17>
    return os;
8010543e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105441:	eb 30                	jmp    80105473 <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105443:	ff 4d 10             	decl   0x10(%ebp)
80105446:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010544a:	7e 1e                	jle    8010546a <safestrcpy+0x3e>
8010544c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544f:	8a 10                	mov    (%eax),%dl
80105451:	8b 45 08             	mov    0x8(%ebp),%eax
80105454:	88 10                	mov    %dl,(%eax)
80105456:	8b 45 08             	mov    0x8(%ebp),%eax
80105459:	8a 00                	mov    (%eax),%al
8010545b:	84 c0                	test   %al,%al
8010545d:	0f 95 c0             	setne  %al
80105460:	ff 45 08             	incl   0x8(%ebp)
80105463:	ff 45 0c             	incl   0xc(%ebp)
80105466:	84 c0                	test   %al,%al
80105468:	75 d9                	jne    80105443 <safestrcpy+0x17>
    ;
  *s = 0;
8010546a:	8b 45 08             	mov    0x8(%ebp),%eax
8010546d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105470:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105473:	c9                   	leave  
80105474:	c3                   	ret    

80105475 <strlen>:

int
strlen(const char *s)
{
80105475:	55                   	push   %ebp
80105476:	89 e5                	mov    %esp,%ebp
80105478:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010547b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105482:	eb 03                	jmp    80105487 <strlen+0x12>
80105484:	ff 45 fc             	incl   -0x4(%ebp)
80105487:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010548a:	8b 45 08             	mov    0x8(%ebp),%eax
8010548d:	01 d0                	add    %edx,%eax
8010548f:	8a 00                	mov    (%eax),%al
80105491:	84 c0                	test   %al,%al
80105493:	75 ef                	jne    80105484 <strlen+0xf>
    ;
  return n;
80105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105498:	c9                   	leave  
80105499:	c3                   	ret    
8010549a:	66 90                	xchg   %ax,%ax

8010549c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010549c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054a0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801054a4:	55                   	push   %ebp
  pushl %ebx
801054a5:	53                   	push   %ebx
  pushl %esi
801054a6:	56                   	push   %esi
  pushl %edi
801054a7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054a8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054aa:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801054ac:	5f                   	pop    %edi
  popl %esi
801054ad:	5e                   	pop    %esi
  popl %ebx
801054ae:	5b                   	pop    %ebx
  popl %ebp
801054af:	5d                   	pop    %ebp
  ret
801054b0:	c3                   	ret    
801054b1:	66 90                	xchg   %ax,%ax
801054b3:	90                   	nop

801054b4 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
801054b7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ba:	8b 00                	mov    (%eax),%eax
801054bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801054bf:	76 0f                	jbe    801054d0 <fetchint+0x1c>
801054c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c4:	8d 50 04             	lea    0x4(%eax),%edx
801054c7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ca:	8b 00                	mov    (%eax),%eax
801054cc:	39 c2                	cmp    %eax,%edx
801054ce:	76 07                	jbe    801054d7 <fetchint+0x23>
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	eb 0f                	jmp    801054e6 <fetchint+0x32>
  *ip = *(int*)(addr);
801054d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054da:	8b 10                	mov    (%eax),%edx
801054dc:	8b 45 10             	mov    0x10(%ebp),%eax
801054df:	89 10                	mov    %edx,(%eax)
  return 0;
801054e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054e6:	5d                   	pop    %ebp
801054e7:	c3                   	ret    

801054e8 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
801054ee:	8b 45 08             	mov    0x8(%ebp),%eax
801054f1:	8b 00                	mov    (%eax),%eax
801054f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801054f6:	77 07                	ja     801054ff <fetchstr+0x17>
    return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb 43                	jmp    80105542 <fetchstr+0x5a>
  *pp = (char*)addr;
801054ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105502:	8b 45 10             	mov    0x10(%ebp),%eax
80105505:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105507:	8b 45 08             	mov    0x8(%ebp),%eax
8010550a:	8b 00                	mov    (%eax),%eax
8010550c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010550f:	8b 45 10             	mov    0x10(%ebp),%eax
80105512:	8b 00                	mov    (%eax),%eax
80105514:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105517:	eb 1c                	jmp    80105535 <fetchstr+0x4d>
    if(*s == 0)
80105519:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010551c:	8a 00                	mov    (%eax),%al
8010551e:	84 c0                	test   %al,%al
80105520:	75 10                	jne    80105532 <fetchstr+0x4a>
      return s - *pp;
80105522:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105525:	8b 45 10             	mov    0x10(%ebp),%eax
80105528:	8b 00                	mov    (%eax),%eax
8010552a:	89 d1                	mov    %edx,%ecx
8010552c:	29 c1                	sub    %eax,%ecx
8010552e:	89 c8                	mov    %ecx,%eax
80105530:	eb 10                	jmp    80105542 <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
80105532:	ff 45 fc             	incl   -0x4(%ebp)
80105535:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010553b:	72 dc                	jb     80105519 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
8010553d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105542:	c9                   	leave  
80105543:	c3                   	ret    

80105544 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
8010554a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105550:	8b 40 18             	mov    0x18(%eax),%eax
80105553:	8b 50 44             	mov    0x44(%eax),%edx
80105556:	8b 45 08             	mov    0x8(%ebp),%eax
80105559:	c1 e0 02             	shl    $0x2,%eax
8010555c:	01 d0                	add    %edx,%eax
8010555e:	8d 48 04             	lea    0x4(%eax),%ecx
80105561:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105567:	8b 55 0c             	mov    0xc(%ebp),%edx
8010556a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010556e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105572:	89 04 24             	mov    %eax,(%esp)
80105575:	e8 3a ff ff ff       	call   801054b4 <fetchint>
}
8010557a:	c9                   	leave  
8010557b:	c3                   	ret    

8010557c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010557c:	55                   	push   %ebp
8010557d:	89 e5                	mov    %esp,%ebp
8010557f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105582:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105585:	89 44 24 04          	mov    %eax,0x4(%esp)
80105589:	8b 45 08             	mov    0x8(%ebp),%eax
8010558c:	89 04 24             	mov    %eax,(%esp)
8010558f:	e8 b0 ff ff ff       	call   80105544 <argint>
80105594:	85 c0                	test   %eax,%eax
80105596:	79 07                	jns    8010559f <argptr+0x23>
    return -1;
80105598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559d:	eb 3d                	jmp    801055dc <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010559f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a2:	89 c2                	mov    %eax,%edx
801055a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055aa:	8b 00                	mov    (%eax),%eax
801055ac:	39 c2                	cmp    %eax,%edx
801055ae:	73 16                	jae    801055c6 <argptr+0x4a>
801055b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b3:	89 c2                	mov    %eax,%edx
801055b5:	8b 45 10             	mov    0x10(%ebp),%eax
801055b8:	01 c2                	add    %eax,%edx
801055ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c0:	8b 00                	mov    (%eax),%eax
801055c2:	39 c2                	cmp    %eax,%edx
801055c4:	76 07                	jbe    801055cd <argptr+0x51>
    return -1;
801055c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cb:	eb 0f                	jmp    801055dc <argptr+0x60>
  *pp = (char*)i;
801055cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055d0:	89 c2                	mov    %eax,%edx
801055d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d5:	89 10                	mov    %edx,(%eax)
  return 0;
801055d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055dc:	c9                   	leave  
801055dd:	c3                   	ret    

801055de <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055de:	55                   	push   %ebp
801055df:	89 e5                	mov    %esp,%ebp
801055e1:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055e4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055eb:	8b 45 08             	mov    0x8(%ebp),%eax
801055ee:	89 04 24             	mov    %eax,(%esp)
801055f1:	e8 4e ff ff ff       	call   80105544 <argint>
801055f6:	85 c0                	test   %eax,%eax
801055f8:	79 07                	jns    80105601 <argstr+0x23>
    return -1;
801055fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ff:	eb 1e                	jmp    8010561f <argstr+0x41>
  return fetchstr(proc, addr, pp);
80105601:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105604:	89 c2                	mov    %eax,%edx
80105606:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010560c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010560f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105613:	89 54 24 04          	mov    %edx,0x4(%esp)
80105617:	89 04 24             	mov    %eax,(%esp)
8010561a:	e8 c9 fe ff ff       	call   801054e8 <fetchstr>
}
8010561f:	c9                   	leave  
80105620:	c3                   	ret    

80105621 <syscall>:
[SYS_cowfork]   sys_cowfork,
};

void
syscall(void)
{
80105621:	55                   	push   %ebp
80105622:	89 e5                	mov    %esp,%ebp
80105624:	53                   	push   %ebx
80105625:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562e:	8b 40 18             	mov    0x18(%eax),%eax
80105631:	8b 40 1c             	mov    0x1c(%eax),%eax
80105634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010563b:	78 2e                	js     8010566b <syscall+0x4a>
8010563d:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105641:	7f 28                	jg     8010566b <syscall+0x4a>
80105643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105646:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010564d:	85 c0                	test   %eax,%eax
8010564f:	74 1a                	je     8010566b <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105651:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105657:	8b 58 18             	mov    0x18(%eax),%ebx
8010565a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105664:	ff d0                	call   *%eax
80105666:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105669:	eb 73                	jmp    801056de <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
8010566b:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
8010566f:	7e 30                	jle    801056a1 <syscall+0x80>
80105671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105674:	83 f8 16             	cmp    $0x16,%eax
80105677:	77 28                	ja     801056a1 <syscall+0x80>
80105679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567c:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105683:	85 c0                	test   %eax,%eax
80105685:	74 1a                	je     801056a1 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105687:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568d:	8b 58 18             	mov    0x18(%eax),%ebx
80105690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105693:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010569a:	ff d0                	call   *%eax
8010569c:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010569f:	eb 3d                	jmp    801056de <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801056a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a7:	8d 48 6c             	lea    0x6c(%eax),%ecx
801056aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801056b0:	8b 40 10             	mov    0x10(%eax),%eax
801056b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
801056ba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056be:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c2:	c7 04 24 83 90 10 80 	movl   $0x80109083,(%esp)
801056c9:	e8 d3 ac ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801056ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d4:	8b 40 18             	mov    0x18(%eax),%eax
801056d7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801056de:	83 c4 24             	add    $0x24,%esp
801056e1:	5b                   	pop    %ebx
801056e2:	5d                   	pop    %ebp
801056e3:	c3                   	ret    

801056e4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f1:	8b 45 08             	mov    0x8(%ebp),%eax
801056f4:	89 04 24             	mov    %eax,(%esp)
801056f7:	e8 48 fe ff ff       	call   80105544 <argint>
801056fc:	85 c0                	test   %eax,%eax
801056fe:	79 07                	jns    80105707 <argfd+0x23>
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb 50                	jmp    80105757 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105707:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010570a:	85 c0                	test   %eax,%eax
8010570c:	78 21                	js     8010572f <argfd+0x4b>
8010570e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105711:	83 f8 0f             	cmp    $0xf,%eax
80105714:	7f 19                	jg     8010572f <argfd+0x4b>
80105716:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010571c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010571f:	83 c2 08             	add    $0x8,%edx
80105722:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105726:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010572d:	75 07                	jne    80105736 <argfd+0x52>
    return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105734:	eb 21                	jmp    80105757 <argfd+0x73>
  if(pfd)
80105736:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010573a:	74 08                	je     80105744 <argfd+0x60>
    *pfd = fd;
8010573c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010573f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105742:	89 10                	mov    %edx,(%eax)
  if(pf)
80105744:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105748:	74 08                	je     80105752 <argfd+0x6e>
    *pf = f;
8010574a:	8b 45 10             	mov    0x10(%ebp),%eax
8010574d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105750:	89 10                	mov    %edx,(%eax)
  return 0;
80105752:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105757:	c9                   	leave  
80105758:	c3                   	ret    

80105759 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105759:	55                   	push   %ebp
8010575a:	89 e5                	mov    %esp,%ebp
8010575c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010575f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105766:	eb 2f                	jmp    80105797 <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105768:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010576e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105771:	83 c2 08             	add    $0x8,%edx
80105774:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105778:	85 c0                	test   %eax,%eax
8010577a:	75 18                	jne    80105794 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010577c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105782:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105785:	8d 4a 08             	lea    0x8(%edx),%ecx
80105788:	8b 55 08             	mov    0x8(%ebp),%edx
8010578b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010578f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105792:	eb 0e                	jmp    801057a2 <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105794:	ff 45 fc             	incl   -0x4(%ebp)
80105797:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010579b:	7e cb                	jle    80105768 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010579d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a2:	c9                   	leave  
801057a3:	c3                   	ret    

801057a4 <sys_dup>:

int
sys_dup(void)
{
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801057aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057ad:	89 44 24 08          	mov    %eax,0x8(%esp)
801057b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057b8:	00 
801057b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057c0:	e8 1f ff ff ff       	call   801056e4 <argfd>
801057c5:	85 c0                	test   %eax,%eax
801057c7:	79 07                	jns    801057d0 <sys_dup+0x2c>
    return -1;
801057c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ce:	eb 29                	jmp    801057f9 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d3:	89 04 24             	mov    %eax,(%esp)
801057d6:	e8 7e ff ff ff       	call   80105759 <fdalloc>
801057db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057e2:	79 07                	jns    801057eb <sys_dup+0x47>
    return -1;
801057e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e9:	eb 0e                	jmp    801057f9 <sys_dup+0x55>
  filedup(f);
801057eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ee:	89 04 24             	mov    %eax,(%esp)
801057f1:	e8 86 b7 ff ff       	call   80100f7c <filedup>
  return fd;
801057f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057f9:	c9                   	leave  
801057fa:	c3                   	ret    

801057fb <sys_read>:

int
sys_read(void)
{
801057fb:	55                   	push   %ebp
801057fc:	89 e5                	mov    %esp,%ebp
801057fe:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105801:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105804:	89 44 24 08          	mov    %eax,0x8(%esp)
80105808:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010580f:	00 
80105810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105817:	e8 c8 fe ff ff       	call   801056e4 <argfd>
8010581c:	85 c0                	test   %eax,%eax
8010581e:	78 35                	js     80105855 <sys_read+0x5a>
80105820:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105823:	89 44 24 04          	mov    %eax,0x4(%esp)
80105827:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010582e:	e8 11 fd ff ff       	call   80105544 <argint>
80105833:	85 c0                	test   %eax,%eax
80105835:	78 1e                	js     80105855 <sys_read+0x5a>
80105837:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010583a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010583e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105841:	89 44 24 04          	mov    %eax,0x4(%esp)
80105845:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010584c:	e8 2b fd ff ff       	call   8010557c <argptr>
80105851:	85 c0                	test   %eax,%eax
80105853:	79 07                	jns    8010585c <sys_read+0x61>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	eb 19                	jmp    80105875 <sys_read+0x7a>
  return fileread(f, p, n);
8010585c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010585f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105865:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105869:	89 54 24 04          	mov    %edx,0x4(%esp)
8010586d:	89 04 24             	mov    %eax,(%esp)
80105870:	e8 68 b8 ff ff       	call   801010dd <fileread>
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    

80105877 <sys_write>:

int
sys_write(void)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010587d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105880:	89 44 24 08          	mov    %eax,0x8(%esp)
80105884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010588b:	00 
8010588c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105893:	e8 4c fe ff ff       	call   801056e4 <argfd>
80105898:	85 c0                	test   %eax,%eax
8010589a:	78 35                	js     801058d1 <sys_write+0x5a>
8010589c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010589f:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058aa:	e8 95 fc ff ff       	call   80105544 <argint>
801058af:	85 c0                	test   %eax,%eax
801058b1:	78 1e                	js     801058d1 <sys_write+0x5a>
801058b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058c8:	e8 af fc ff ff       	call   8010557c <argptr>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	79 07                	jns    801058d8 <sys_write+0x61>
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d6:	eb 19                	jmp    801058f1 <sys_write+0x7a>
  return filewrite(f, p, n);
801058d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801058e9:	89 04 24             	mov    %eax,(%esp)
801058ec:	e8 a7 b8 ff ff       	call   80101198 <filewrite>
}
801058f1:	c9                   	leave  
801058f2:	c3                   	ret    

801058f3 <sys_close>:

int
sys_close(void)
{
801058f3:	55                   	push   %ebp
801058f4:	89 e5                	mov    %esp,%ebp
801058f6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801058f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105900:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105903:	89 44 24 04          	mov    %eax,0x4(%esp)
80105907:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010590e:	e8 d1 fd ff ff       	call   801056e4 <argfd>
80105913:	85 c0                	test   %eax,%eax
80105915:	79 07                	jns    8010591e <sys_close+0x2b>
    return -1;
80105917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591c:	eb 24                	jmp    80105942 <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010591e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105924:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105927:	83 c2 08             	add    $0x8,%edx
8010592a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105931:	00 
  fileclose(f);
80105932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105935:	89 04 24             	mov    %eax,(%esp)
80105938:	e8 87 b6 ff ff       	call   80100fc4 <fileclose>
  return 0;
8010593d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105942:	c9                   	leave  
80105943:	c3                   	ret    

80105944 <sys_fstat>:

int
sys_fstat(void)
{
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010594a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105951:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105958:	00 
80105959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105960:	e8 7f fd ff ff       	call   801056e4 <argfd>
80105965:	85 c0                	test   %eax,%eax
80105967:	78 1f                	js     80105988 <sys_fstat+0x44>
80105969:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105970:	00 
80105971:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105974:	89 44 24 04          	mov    %eax,0x4(%esp)
80105978:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010597f:	e8 f8 fb ff ff       	call   8010557c <argptr>
80105984:	85 c0                	test   %eax,%eax
80105986:	79 07                	jns    8010598f <sys_fstat+0x4b>
    return -1;
80105988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598d:	eb 12                	jmp    801059a1 <sys_fstat+0x5d>
  return filestat(f, st);
8010598f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105995:	89 54 24 04          	mov    %edx,0x4(%esp)
80105999:	89 04 24             	mov    %eax,(%esp)
8010599c:	e8 ed b6 ff ff       	call   8010108e <filestat>
}
801059a1:	c9                   	leave  
801059a2:	c3                   	ret    

801059a3 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059a3:	55                   	push   %ebp
801059a4:	89 e5                	mov    %esp,%ebp
801059a6:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059a9:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059b7:	e8 22 fc ff ff       	call   801055de <argstr>
801059bc:	85 c0                	test   %eax,%eax
801059be:	78 17                	js     801059d7 <sys_link+0x34>
801059c0:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059ce:	e8 0b fc ff ff       	call   801055de <argstr>
801059d3:	85 c0                	test   %eax,%eax
801059d5:	79 0a                	jns    801059e1 <sys_link+0x3e>
    return -1;
801059d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dc:	e9 37 01 00 00       	jmp    80105b18 <sys_link+0x175>
  if((ip = namei(old)) == 0)
801059e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801059e4:	89 04 24             	mov    %eax,(%esp)
801059e7:	e8 f8 c9 ff ff       	call   801023e4 <namei>
801059ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059f3:	75 0a                	jne    801059ff <sys_link+0x5c>
    return -1;
801059f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fa:	e9 19 01 00 00       	jmp    80105b18 <sys_link+0x175>

  begin_trans();
801059ff:	e8 d3 d7 ff ff       	call   801031d7 <begin_trans>

  ilock(ip);
80105a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a07:	89 04 24             	mov    %eax,(%esp)
80105a0a:	e8 3b be ff ff       	call   8010184a <ilock>
  if(ip->type == T_DIR){
80105a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a12:	8b 40 10             	mov    0x10(%eax),%eax
80105a15:	66 83 f8 01          	cmp    $0x1,%ax
80105a19:	75 1a                	jne    80105a35 <sys_link+0x92>
    iunlockput(ip);
80105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1e:	89 04 24             	mov    %eax,(%esp)
80105a21:	e8 a5 c0 ff ff       	call   80101acb <iunlockput>
    commit_trans();
80105a26:	e8 f5 d7 ff ff       	call   80103220 <commit_trans>
    return -1;
80105a2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a30:	e9 e3 00 00 00       	jmp    80105b18 <sys_link+0x175>
  }

  ip->nlink++;
80105a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a38:	66 8b 40 16          	mov    0x16(%eax),%ax
80105a3c:	40                   	inc    %eax
80105a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a40:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a47:	89 04 24             	mov    %eax,(%esp)
80105a4a:	e8 41 bc ff ff       	call   80101690 <iupdate>
  iunlock(ip);
80105a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a52:	89 04 24             	mov    %eax,(%esp)
80105a55:	e8 3b bf ff ff       	call   80101995 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a5d:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a60:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a64:	89 04 24             	mov    %eax,(%esp)
80105a67:	e8 9a c9 ff ff       	call   80102406 <nameiparent>
80105a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a73:	74 68                	je     80105add <sys_link+0x13a>
    goto bad;
  ilock(dp);
80105a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a78:	89 04 24             	mov    %eax,(%esp)
80105a7b:	e8 ca bd ff ff       	call   8010184a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a83:	8b 10                	mov    (%eax),%edx
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	8b 00                	mov    (%eax),%eax
80105a8a:	39 c2                	cmp    %eax,%edx
80105a8c:	75 20                	jne    80105aae <sys_link+0x10b>
80105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a91:	8b 40 04             	mov    0x4(%eax),%eax
80105a94:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a98:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa2:	89 04 24             	mov    %eax,(%esp)
80105aa5:	e8 83 c6 ff ff       	call   8010212d <dirlink>
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	79 0d                	jns    80105abb <sys_link+0x118>
    iunlockput(dp);
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	89 04 24             	mov    %eax,(%esp)
80105ab4:	e8 12 c0 ff ff       	call   80101acb <iunlockput>
    goto bad;
80105ab9:	eb 23                	jmp    80105ade <sys_link+0x13b>
  }
  iunlockput(dp);
80105abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abe:	89 04 24             	mov    %eax,(%esp)
80105ac1:	e8 05 c0 ff ff       	call   80101acb <iunlockput>
  iput(ip);
80105ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac9:	89 04 24             	mov    %eax,(%esp)
80105acc:	e8 29 bf ff ff       	call   801019fa <iput>

  commit_trans();
80105ad1:	e8 4a d7 ff ff       	call   80103220 <commit_trans>

  return 0;
80105ad6:	b8 00 00 00 00       	mov    $0x0,%eax
80105adb:	eb 3b                	jmp    80105b18 <sys_link+0x175>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105add:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae1:	89 04 24             	mov    %eax,(%esp)
80105ae4:	e8 61 bd ff ff       	call   8010184a <ilock>
  ip->nlink--;
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	66 8b 40 16          	mov    0x16(%eax),%ax
80105af0:	48                   	dec    %eax
80105af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105af4:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afb:	89 04 24             	mov    %eax,(%esp)
80105afe:	e8 8d bb ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
80105b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b06:	89 04 24             	mov    %eax,(%esp)
80105b09:	e8 bd bf ff ff       	call   80101acb <iunlockput>
  commit_trans();
80105b0e:	e8 0d d7 ff ff       	call   80103220 <commit_trans>
  return -1;
80105b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b18:	c9                   	leave  
80105b19:	c3                   	ret    

80105b1a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105b1a:	55                   	push   %ebp
80105b1b:	89 e5                	mov    %esp,%ebp
80105b1d:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b20:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b27:	eb 4a                	jmp    80105b73 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b33:	00 
80105b34:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b38:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b42:	89 04 24             	mov    %eax,(%esp)
80105b45:	e8 07 c2 ff ff       	call   80101d51 <readi>
80105b4a:	83 f8 10             	cmp    $0x10,%eax
80105b4d:	74 0c                	je     80105b5b <isdirempty+0x41>
      panic("isdirempty: readi");
80105b4f:	c7 04 24 9f 90 10 80 	movl   $0x8010909f,(%esp)
80105b56:	e8 db a9 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80105b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b5e:	66 85 c0             	test   %ax,%ax
80105b61:	74 07                	je     80105b6a <isdirempty+0x50>
      return 0;
80105b63:	b8 00 00 00 00       	mov    $0x0,%eax
80105b68:	eb 1b                	jmp    80105b85 <isdirempty+0x6b>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6d:	83 c0 10             	add    $0x10,%eax
80105b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b76:	8b 45 08             	mov    0x8(%ebp),%eax
80105b79:	8b 40 18             	mov    0x18(%eax),%eax
80105b7c:	39 c2                	cmp    %eax,%edx
80105b7e:	72 a9                	jb     80105b29 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105b80:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    

80105b87 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b87:	55                   	push   %ebp
80105b88:	89 e5                	mov    %esp,%ebp
80105b8a:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b8d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b90:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b9b:	e8 3e fa ff ff       	call   801055de <argstr>
80105ba0:	85 c0                	test   %eax,%eax
80105ba2:	79 0a                	jns    80105bae <sys_unlink+0x27>
    return -1;
80105ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba9:	e9 a4 01 00 00       	jmp    80105d52 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80105bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105bb1:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bb8:	89 04 24             	mov    %eax,(%esp)
80105bbb:	e8 46 c8 ff ff       	call   80102406 <nameiparent>
80105bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bc7:	75 0a                	jne    80105bd3 <sys_unlink+0x4c>
    return -1;
80105bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bce:	e9 7f 01 00 00       	jmp    80105d52 <sys_unlink+0x1cb>

  begin_trans();
80105bd3:	e8 ff d5 ff ff       	call   801031d7 <begin_trans>

  ilock(dp);
80105bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdb:	89 04 24             	mov    %eax,(%esp)
80105bde:	e8 67 bc ff ff       	call   8010184a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105be3:	c7 44 24 04 b1 90 10 	movl   $0x801090b1,0x4(%esp)
80105bea:	80 
80105beb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bee:	89 04 24             	mov    %eax,(%esp)
80105bf1:	e8 50 c4 ff ff       	call   80102046 <namecmp>
80105bf6:	85 c0                	test   %eax,%eax
80105bf8:	0f 84 3f 01 00 00    	je     80105d3d <sys_unlink+0x1b6>
80105bfe:	c7 44 24 04 b3 90 10 	movl   $0x801090b3,0x4(%esp)
80105c05:	80 
80105c06:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c09:	89 04 24             	mov    %eax,(%esp)
80105c0c:	e8 35 c4 ff ff       	call   80102046 <namecmp>
80105c11:	85 c0                	test   %eax,%eax
80105c13:	0f 84 24 01 00 00    	je     80105d3d <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c19:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105c1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c20:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c23:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2a:	89 04 24             	mov    %eax,(%esp)
80105c2d:	e8 36 c4 ff ff       	call   80102068 <dirlookup>
80105c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c39:	0f 84 fd 00 00 00    	je     80105d3c <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80105c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c42:	89 04 24             	mov    %eax,(%esp)
80105c45:	e8 00 bc ff ff       	call   8010184a <ilock>

  if(ip->nlink < 1)
80105c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4d:	66 8b 40 16          	mov    0x16(%eax),%ax
80105c51:	66 85 c0             	test   %ax,%ax
80105c54:	7f 0c                	jg     80105c62 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105c56:	c7 04 24 b6 90 10 80 	movl   $0x801090b6,(%esp)
80105c5d:	e8 d4 a8 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c65:	8b 40 10             	mov    0x10(%eax),%eax
80105c68:	66 83 f8 01          	cmp    $0x1,%ax
80105c6c:	75 1f                	jne    80105c8d <sys_unlink+0x106>
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	89 04 24             	mov    %eax,(%esp)
80105c74:	e8 a1 fe ff ff       	call   80105b1a <isdirempty>
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	75 10                	jne    80105c8d <sys_unlink+0x106>
    iunlockput(ip);
80105c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c80:	89 04 24             	mov    %eax,(%esp)
80105c83:	e8 43 be ff ff       	call   80101acb <iunlockput>
    goto bad;
80105c88:	e9 b0 00 00 00       	jmp    80105d3d <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80105c8d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c94:	00 
80105c95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c9c:	00 
80105c9d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 72 f5 ff ff       	call   8010521a <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105cab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105cb2:	00 
80105cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cb7:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cba:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc1:	89 04 24             	mov    %eax,(%esp)
80105cc4:	e8 ed c1 ff ff       	call   80101eb6 <writei>
80105cc9:	83 f8 10             	cmp    $0x10,%eax
80105ccc:	74 0c                	je     80105cda <sys_unlink+0x153>
    panic("unlink: writei");
80105cce:	c7 04 24 c8 90 10 80 	movl   $0x801090c8,(%esp)
80105cd5:	e8 5c a8 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
80105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdd:	8b 40 10             	mov    0x10(%eax),%eax
80105ce0:	66 83 f8 01          	cmp    $0x1,%ax
80105ce4:	75 1a                	jne    80105d00 <sys_unlink+0x179>
    dp->nlink--;
80105ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce9:	66 8b 40 16          	mov    0x16(%eax),%ax
80105ced:	48                   	dec    %eax
80105cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cf1:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf8:	89 04 24             	mov    %eax,(%esp)
80105cfb:	e8 90 b9 ff ff       	call   80101690 <iupdate>
  }
  iunlockput(dp);
80105d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d03:	89 04 24             	mov    %eax,(%esp)
80105d06:	e8 c0 bd ff ff       	call   80101acb <iunlockput>

  ip->nlink--;
80105d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0e:	66 8b 40 16          	mov    0x16(%eax),%ax
80105d12:	48                   	dec    %eax
80105d13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d16:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1d:	89 04 24             	mov    %eax,(%esp)
80105d20:	e8 6b b9 ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
80105d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d28:	89 04 24             	mov    %eax,(%esp)
80105d2b:	e8 9b bd ff ff       	call   80101acb <iunlockput>

  commit_trans();
80105d30:	e8 eb d4 ff ff       	call   80103220 <commit_trans>

  return 0;
80105d35:	b8 00 00 00 00       	mov    $0x0,%eax
80105d3a:	eb 16                	jmp    80105d52 <sys_unlink+0x1cb>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105d3c:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d40:	89 04 24             	mov    %eax,(%esp)
80105d43:	e8 83 bd ff ff       	call   80101acb <iunlockput>
  commit_trans();
80105d48:	e8 d3 d4 ff ff       	call   80103220 <commit_trans>
  return -1;
80105d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d52:	c9                   	leave  
80105d53:	c3                   	ret    

80105d54 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d54:	55                   	push   %ebp
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	83 ec 48             	sub    $0x48,%esp
80105d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d5d:	8b 55 10             	mov    0x10(%ebp),%edx
80105d60:	8b 45 14             	mov    0x14(%ebp),%eax
80105d63:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d67:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d6b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d6f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d76:	8b 45 08             	mov    0x8(%ebp),%eax
80105d79:	89 04 24             	mov    %eax,(%esp)
80105d7c:	e8 85 c6 ff ff       	call   80102406 <nameiparent>
80105d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d88:	75 0a                	jne    80105d94 <create+0x40>
    return 0;
80105d8a:	b8 00 00 00 00       	mov    $0x0,%eax
80105d8f:	e9 79 01 00 00       	jmp    80105f0d <create+0x1b9>
  ilock(dp);
80105d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d97:	89 04 24             	mov    %eax,(%esp)
80105d9a:	e8 ab ba ff ff       	call   8010184a <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105da2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105da6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105da9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	89 04 24             	mov    %eax,(%esp)
80105db3:	e8 b0 c2 ff ff       	call   80102068 <dirlookup>
80105db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dbf:	74 46                	je     80105e07 <create+0xb3>
    iunlockput(dp);
80105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc4:	89 04 24             	mov    %eax,(%esp)
80105dc7:	e8 ff bc ff ff       	call   80101acb <iunlockput>
    ilock(ip);
80105dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcf:	89 04 24             	mov    %eax,(%esp)
80105dd2:	e8 73 ba ff ff       	call   8010184a <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105dd7:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ddc:	75 14                	jne    80105df2 <create+0x9e>
80105dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de1:	8b 40 10             	mov    0x10(%eax),%eax
80105de4:	66 83 f8 02          	cmp    $0x2,%ax
80105de8:	75 08                	jne    80105df2 <create+0x9e>
      return ip;
80105dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ded:	e9 1b 01 00 00       	jmp    80105f0d <create+0x1b9>
    iunlockput(ip);
80105df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df5:	89 04 24             	mov    %eax,(%esp)
80105df8:	e8 ce bc ff ff       	call   80101acb <iunlockput>
    return 0;
80105dfd:	b8 00 00 00 00       	mov    $0x0,%eax
80105e02:	e9 06 01 00 00       	jmp    80105f0d <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105e07:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0e:	8b 00                	mov    (%eax),%eax
80105e10:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e14:	89 04 24             	mov    %eax,(%esp)
80105e17:	e8 98 b7 ff ff       	call   801015b4 <ialloc>
80105e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e23:	75 0c                	jne    80105e31 <create+0xdd>
    panic("create: ialloc");
80105e25:	c7 04 24 d7 90 10 80 	movl   $0x801090d7,(%esp)
80105e2c:	e8 05 a7 ff ff       	call   80100536 <panic>

  ilock(ip);
80105e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e34:	89 04 24             	mov    %eax,(%esp)
80105e37:	e8 0e ba ff ff       	call   8010184a <ilock>
  ip->major = major;
80105e3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105e42:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105e46:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e4c:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e53:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5c:	89 04 24             	mov    %eax,(%esp)
80105e5f:	e8 2c b8 ff ff       	call   80101690 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e64:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e69:	75 68                	jne    80105ed3 <create+0x17f>
    dp->nlink++;  // for ".."
80105e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6e:	66 8b 40 16          	mov    0x16(%eax),%ax
80105e72:	40                   	inc    %eax
80105e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e76:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7d:	89 04 24             	mov    %eax,(%esp)
80105e80:	e8 0b b8 ff ff       	call   80101690 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	8b 40 04             	mov    0x4(%eax),%eax
80105e8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e8f:	c7 44 24 04 b1 90 10 	movl   $0x801090b1,0x4(%esp)
80105e96:	80 
80105e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9a:	89 04 24             	mov    %eax,(%esp)
80105e9d:	e8 8b c2 ff ff       	call   8010212d <dirlink>
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	78 21                	js     80105ec7 <create+0x173>
80105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea9:	8b 40 04             	mov    0x4(%eax),%eax
80105eac:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eb0:	c7 44 24 04 b3 90 10 	movl   $0x801090b3,0x4(%esp)
80105eb7:	80 
80105eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebb:	89 04 24             	mov    %eax,(%esp)
80105ebe:	e8 6a c2 ff ff       	call   8010212d <dirlink>
80105ec3:	85 c0                	test   %eax,%eax
80105ec5:	79 0c                	jns    80105ed3 <create+0x17f>
      panic("create dots");
80105ec7:	c7 04 24 e6 90 10 80 	movl   $0x801090e6,(%esp)
80105ece:	e8 63 a6 ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed6:	8b 40 04             	mov    0x4(%eax),%eax
80105ed9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105edd:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee7:	89 04 24             	mov    %eax,(%esp)
80105eea:	e8 3e c2 ff ff       	call   8010212d <dirlink>
80105eef:	85 c0                	test   %eax,%eax
80105ef1:	79 0c                	jns    80105eff <create+0x1ab>
    panic("create: dirlink");
80105ef3:	c7 04 24 f2 90 10 80 	movl   $0x801090f2,(%esp)
80105efa:	e8 37 a6 ff ff       	call   80100536 <panic>

  iunlockput(dp);
80105eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f02:	89 04 24             	mov    %eax,(%esp)
80105f05:	e8 c1 bb ff ff       	call   80101acb <iunlockput>

  return ip;
80105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f0d:	c9                   	leave  
80105f0e:	c3                   	ret    

80105f0f <sys_open>:

int
sys_open(void)
{
80105f0f:	55                   	push   %ebp
80105f10:	89 e5                	mov    %esp,%ebp
80105f12:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f15:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f18:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f23:	e8 b6 f6 ff ff       	call   801055de <argstr>
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	78 17                	js     80105f43 <sys_open+0x34>
80105f2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f3a:	e8 05 f6 ff ff       	call   80105544 <argint>
80105f3f:	85 c0                	test   %eax,%eax
80105f41:	79 0a                	jns    80105f4d <sys_open+0x3e>
    return -1;
80105f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f48:	e9 47 01 00 00       	jmp    80106094 <sys_open+0x185>
  if(omode & O_CREATE){
80105f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f50:	25 00 02 00 00       	and    $0x200,%eax
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 40                	je     80105f99 <sys_open+0x8a>
    begin_trans();
80105f59:	e8 79 d2 ff ff       	call   801031d7 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f61:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f68:	00 
80105f69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f70:	00 
80105f71:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f78:	00 
80105f79:	89 04 24             	mov    %eax,(%esp)
80105f7c:	e8 d3 fd ff ff       	call   80105d54 <create>
80105f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105f84:	e8 97 d2 ff ff       	call   80103220 <commit_trans>
    if(ip == 0)
80105f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f8d:	75 5b                	jne    80105fea <sys_open+0xdb>
      return -1;
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f94:	e9 fb 00 00 00       	jmp    80106094 <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
80105f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f9c:	89 04 24             	mov    %eax,(%esp)
80105f9f:	e8 40 c4 ff ff       	call   801023e4 <namei>
80105fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fab:	75 0a                	jne    80105fb7 <sys_open+0xa8>
      return -1;
80105fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb2:	e9 dd 00 00 00       	jmp    80106094 <sys_open+0x185>
    ilock(ip);
80105fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fba:	89 04 24             	mov    %eax,(%esp)
80105fbd:	e8 88 b8 ff ff       	call   8010184a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc5:	8b 40 10             	mov    0x10(%eax),%eax
80105fc8:	66 83 f8 01          	cmp    $0x1,%ax
80105fcc:	75 1c                	jne    80105fea <sys_open+0xdb>
80105fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fd1:	85 c0                	test   %eax,%eax
80105fd3:	74 15                	je     80105fea <sys_open+0xdb>
      iunlockput(ip);
80105fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd8:	89 04 24             	mov    %eax,(%esp)
80105fdb:	e8 eb ba ff ff       	call   80101acb <iunlockput>
      return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe5:	e9 aa 00 00 00       	jmp    80106094 <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105fea:	e8 2d af ff ff       	call   80100f1c <filealloc>
80105fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ff2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ff6:	74 14                	je     8010600c <sys_open+0xfd>
80105ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffb:	89 04 24             	mov    %eax,(%esp)
80105ffe:	e8 56 f7 ff ff       	call   80105759 <fdalloc>
80106003:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106006:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010600a:	79 23                	jns    8010602f <sys_open+0x120>
    if(f)
8010600c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106010:	74 0b                	je     8010601d <sys_open+0x10e>
      fileclose(f);
80106012:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106015:	89 04 24             	mov    %eax,(%esp)
80106018:	e8 a7 af ff ff       	call   80100fc4 <fileclose>
    iunlockput(ip);
8010601d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106020:	89 04 24             	mov    %eax,(%esp)
80106023:	e8 a3 ba ff ff       	call   80101acb <iunlockput>
    return -1;
80106028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602d:	eb 65                	jmp    80106094 <sys_open+0x185>
  }
  iunlock(ip);
8010602f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106032:	89 04 24             	mov    %eax,(%esp)
80106035:	e8 5b b9 ff ff       	call   80101995 <iunlock>

  f->type = FD_INODE;
8010603a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106046:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106049:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106059:	83 e0 01             	and    $0x1,%eax
8010605c:	85 c0                	test   %eax,%eax
8010605e:	0f 94 c0             	sete   %al
80106061:	88 c2                	mov    %al,%dl
80106063:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106066:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010606c:	83 e0 01             	and    $0x1,%eax
8010606f:	85 c0                	test   %eax,%eax
80106071:	75 0a                	jne    8010607d <sys_open+0x16e>
80106073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106076:	83 e0 02             	and    $0x2,%eax
80106079:	85 c0                	test   %eax,%eax
8010607b:	74 07                	je     80106084 <sys_open+0x175>
8010607d:	b8 01 00 00 00       	mov    $0x1,%eax
80106082:	eb 05                	jmp    80106089 <sys_open+0x17a>
80106084:	b8 00 00 00 00       	mov    $0x0,%eax
80106089:	88 c2                	mov    %al,%dl
8010608b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106091:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106094:	c9                   	leave  
80106095:	c3                   	ret    

80106096 <sys_mkdir>:

int
sys_mkdir(void)
{
80106096:	55                   	push   %ebp
80106097:	89 e5                	mov    %esp,%ebp
80106099:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
8010609c:	e8 36 d1 ff ff       	call   801031d7 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801060a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060af:	e8 2a f5 ff ff       	call   801055de <argstr>
801060b4:	85 c0                	test   %eax,%eax
801060b6:	78 2c                	js     801060e4 <sys_mkdir+0x4e>
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801060c2:	00 
801060c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801060ca:	00 
801060cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801060d2:	00 
801060d3:	89 04 24             	mov    %eax,(%esp)
801060d6:	e8 79 fc ff ff       	call   80105d54 <create>
801060db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060e2:	75 0c                	jne    801060f0 <sys_mkdir+0x5a>
    commit_trans();
801060e4:	e8 37 d1 ff ff       	call   80103220 <commit_trans>
    return -1;
801060e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ee:	eb 15                	jmp    80106105 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801060f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f3:	89 04 24             	mov    %eax,(%esp)
801060f6:	e8 d0 b9 ff ff       	call   80101acb <iunlockput>
  commit_trans();
801060fb:	e8 20 d1 ff ff       	call   80103220 <commit_trans>
  return 0;
80106100:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106105:	c9                   	leave  
80106106:	c3                   	ret    

80106107 <sys_mknod>:

int
sys_mknod(void)
{
80106107:	55                   	push   %ebp
80106108:	89 e5                	mov    %esp,%ebp
8010610a:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
8010610d:	e8 c5 d0 ff ff       	call   801031d7 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106112:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106115:	89 44 24 04          	mov    %eax,0x4(%esp)
80106119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106120:	e8 b9 f4 ff ff       	call   801055de <argstr>
80106125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010612c:	78 5e                	js     8010618c <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010612e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106131:	89 44 24 04          	mov    %eax,0x4(%esp)
80106135:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010613c:	e8 03 f4 ff ff       	call   80105544 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106141:	85 c0                	test   %eax,%eax
80106143:	78 47                	js     8010618c <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106148:	89 44 24 04          	mov    %eax,0x4(%esp)
8010614c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106153:	e8 ec f3 ff ff       	call   80105544 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106158:	85 c0                	test   %eax,%eax
8010615a:	78 30                	js     8010618c <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010615c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010615f:	0f bf c8             	movswl %ax,%ecx
80106162:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106165:	0f bf d0             	movswl %ax,%edx
80106168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010616b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010616f:	89 54 24 08          	mov    %edx,0x8(%esp)
80106173:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010617a:	00 
8010617b:	89 04 24             	mov    %eax,(%esp)
8010617e:	e8 d1 fb ff ff       	call   80105d54 <create>
80106183:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010618a:	75 0c                	jne    80106198 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
8010618c:	e8 8f d0 ff ff       	call   80103220 <commit_trans>
    return -1;
80106191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106196:	eb 15                	jmp    801061ad <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619b:	89 04 24             	mov    %eax,(%esp)
8010619e:	e8 28 b9 ff ff       	call   80101acb <iunlockput>
  commit_trans();
801061a3:	e8 78 d0 ff ff       	call   80103220 <commit_trans>
  return 0;
801061a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061ad:	c9                   	leave  
801061ae:	c3                   	ret    

801061af <sys_chdir>:

int
sys_chdir(void)
{
801061af:	55                   	push   %ebp
801061b0:	89 e5                	mov    %esp,%ebp
801061b2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801061b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801061bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061c3:	e8 16 f4 ff ff       	call   801055de <argstr>
801061c8:	85 c0                	test   %eax,%eax
801061ca:	78 14                	js     801061e0 <sys_chdir+0x31>
801061cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061cf:	89 04 24             	mov    %eax,(%esp)
801061d2:	e8 0d c2 ff ff       	call   801023e4 <namei>
801061d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061de:	75 07                	jne    801061e7 <sys_chdir+0x38>
    return -1;
801061e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e5:	eb 56                	jmp    8010623d <sys_chdir+0x8e>
  ilock(ip);
801061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ea:	89 04 24             	mov    %eax,(%esp)
801061ed:	e8 58 b6 ff ff       	call   8010184a <ilock>
  if(ip->type != T_DIR){
801061f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f5:	8b 40 10             	mov    0x10(%eax),%eax
801061f8:	66 83 f8 01          	cmp    $0x1,%ax
801061fc:	74 12                	je     80106210 <sys_chdir+0x61>
    iunlockput(ip);
801061fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106201:	89 04 24             	mov    %eax,(%esp)
80106204:	e8 c2 b8 ff ff       	call   80101acb <iunlockput>
    return -1;
80106209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620e:	eb 2d                	jmp    8010623d <sys_chdir+0x8e>
  }
  iunlock(ip);
80106210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106213:	89 04 24             	mov    %eax,(%esp)
80106216:	e8 7a b7 ff ff       	call   80101995 <iunlock>
  iput(proc->cwd);
8010621b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106221:	8b 40 68             	mov    0x68(%eax),%eax
80106224:	89 04 24             	mov    %eax,(%esp)
80106227:	e8 ce b7 ff ff       	call   801019fa <iput>
  proc->cwd = ip;
8010622c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106232:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106235:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106238:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010623d:	c9                   	leave  
8010623e:	c3                   	ret    

8010623f <sys_exec>:

int
sys_exec(void)
{
8010623f:	55                   	push   %ebp
80106240:	89 e5                	mov    %esp,%ebp
80106242:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106248:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010624b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010624f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106256:	e8 83 f3 ff ff       	call   801055de <argstr>
8010625b:	85 c0                	test   %eax,%eax
8010625d:	78 1a                	js     80106279 <sys_exec+0x3a>
8010625f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106265:	89 44 24 04          	mov    %eax,0x4(%esp)
80106269:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106270:	e8 cf f2 ff ff       	call   80105544 <argint>
80106275:	85 c0                	test   %eax,%eax
80106277:	79 0a                	jns    80106283 <sys_exec+0x44>
    return -1;
80106279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627e:	e9 dd 00 00 00       	jmp    80106360 <sys_exec+0x121>
  }
  memset(argv, 0, sizeof(argv));
80106283:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010628a:	00 
8010628b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106292:	00 
80106293:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106299:	89 04 24             	mov    %eax,(%esp)
8010629c:	e8 79 ef ff ff       	call   8010521a <memset>
  for(i=0;; i++){
801062a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801062a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ab:	83 f8 1f             	cmp    $0x1f,%eax
801062ae:	76 0a                	jbe    801062ba <sys_exec+0x7b>
      return -1;
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b5:	e9 a6 00 00 00       	jmp    80106360 <sys_exec+0x121>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
801062ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062bd:	c1 e0 02             	shl    $0x2,%eax
801062c0:	89 c2                	mov    %eax,%edx
801062c2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801062c8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801062cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062d1:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801062d7:	89 54 24 08          	mov    %edx,0x8(%esp)
801062db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801062df:	89 04 24             	mov    %eax,(%esp)
801062e2:	e8 cd f1 ff ff       	call   801054b4 <fetchint>
801062e7:	85 c0                	test   %eax,%eax
801062e9:	79 07                	jns    801062f2 <sys_exec+0xb3>
      return -1;
801062eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f0:	eb 6e                	jmp    80106360 <sys_exec+0x121>
    if(uarg == 0){
801062f2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062f8:	85 c0                	test   %eax,%eax
801062fa:	75 26                	jne    80106322 <sys_exec+0xe3>
      argv[i] = 0;
801062fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ff:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106306:	00 00 00 00 
      break;
8010630a:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010630b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106314:	89 54 24 04          	mov    %edx,0x4(%esp)
80106318:	89 04 24             	mov    %eax,(%esp)
8010631b:	e8 ac a7 ff ff       	call   80100acc <exec>
80106320:	eb 3e                	jmp    80106360 <sys_exec+0x121>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80106322:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106328:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010632b:	c1 e2 02             	shl    $0x2,%edx
8010632e:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80106331:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106337:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010633d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106341:	89 54 24 04          	mov    %edx,0x4(%esp)
80106345:	89 04 24             	mov    %eax,(%esp)
80106348:	e8 9b f1 ff ff       	call   801054e8 <fetchstr>
8010634d:	85 c0                	test   %eax,%eax
8010634f:	79 07                	jns    80106358 <sys_exec+0x119>
      return -1;
80106351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106356:	eb 08                	jmp    80106360 <sys_exec+0x121>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106358:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
8010635b:	e9 48 ff ff ff       	jmp    801062a8 <sys_exec+0x69>
  return exec(path, argv);
}
80106360:	c9                   	leave  
80106361:	c3                   	ret    

80106362 <sys_pipe>:

int
sys_pipe(void)
{
80106362:	55                   	push   %ebp
80106363:	89 e5                	mov    %esp,%ebp
80106365:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106368:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010636f:	00 
80106370:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106373:	89 44 24 04          	mov    %eax,0x4(%esp)
80106377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010637e:	e8 f9 f1 ff ff       	call   8010557c <argptr>
80106383:	85 c0                	test   %eax,%eax
80106385:	79 0a                	jns    80106391 <sys_pipe+0x2f>
    return -1;
80106387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638c:	e9 9b 00 00 00       	jmp    8010642c <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106394:	89 44 24 04          	mov    %eax,0x4(%esp)
80106398:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010639b:	89 04 24             	mov    %eax,(%esp)
8010639e:	e8 8d d8 ff ff       	call   80103c30 <pipealloc>
801063a3:	85 c0                	test   %eax,%eax
801063a5:	79 07                	jns    801063ae <sys_pipe+0x4c>
    return -1;
801063a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ac:	eb 7e                	jmp    8010642c <sys_pipe+0xca>
  fd0 = -1;
801063ae:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063b8:	89 04 24             	mov    %eax,(%esp)
801063bb:	e8 99 f3 ff ff       	call   80105759 <fdalloc>
801063c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063c7:	78 14                	js     801063dd <sys_pipe+0x7b>
801063c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063cc:	89 04 24             	mov    %eax,(%esp)
801063cf:	e8 85 f3 ff ff       	call   80105759 <fdalloc>
801063d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063db:	79 37                	jns    80106414 <sys_pipe+0xb2>
    if(fd0 >= 0)
801063dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063e1:	78 14                	js     801063f7 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801063e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063ec:	83 c2 08             	add    $0x8,%edx
801063ef:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063f6:	00 
    fileclose(rf);
801063f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063fa:	89 04 24             	mov    %eax,(%esp)
801063fd:	e8 c2 ab ff ff       	call   80100fc4 <fileclose>
    fileclose(wf);
80106402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106405:	89 04 24             	mov    %eax,(%esp)
80106408:	e8 b7 ab ff ff       	call   80100fc4 <fileclose>
    return -1;
8010640d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106412:	eb 18                	jmp    8010642c <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106414:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106417:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010641a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010641c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010641f:	8d 50 04             	lea    0x4(%eax),%edx
80106422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106425:	89 02                	mov    %eax,(%edx)
  return 0;
80106427:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010642c:	c9                   	leave  
8010642d:	c3                   	ret    
8010642e:	66 90                	xchg   %ax,%ax

80106430 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106436:	e8 b8 de ff ff       	call   801042f3 <fork>
}
8010643b:	c9                   	leave  
8010643c:	c3                   	ret    

8010643d <sys_exit>:

int
sys_exit(void)
{
8010643d:	55                   	push   %ebp
8010643e:	89 e5                	mov    %esp,%ebp
80106440:	83 ec 08             	sub    $0x8,%esp
  exit();
80106443:	e8 0d e0 ff ff       	call   80104455 <exit>
  return 0;  // not reached
80106448:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010644d:	c9                   	leave  
8010644e:	c3                   	ret    

8010644f <sys_wait>:

int
sys_wait(void)
{
8010644f:	55                   	push   %ebp
80106450:	89 e5                	mov    %esp,%ebp
80106452:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106455:	e8 12 e1 ff ff       	call   8010456c <wait>
}
8010645a:	c9                   	leave  
8010645b:	c3                   	ret    

8010645c <sys_kill>:

int
sys_kill(void)
{
8010645c:	55                   	push   %ebp
8010645d:	89 e5                	mov    %esp,%ebp
8010645f:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106462:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106465:	89 44 24 04          	mov    %eax,0x4(%esp)
80106469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106470:	e8 cf f0 ff ff       	call   80105544 <argint>
80106475:	85 c0                	test   %eax,%eax
80106477:	79 07                	jns    80106480 <sys_kill+0x24>
    return -1;
80106479:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647e:	eb 0b                	jmp    8010648b <sys_kill+0x2f>
  return kill(pid);
80106480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106483:	89 04 24             	mov    %eax,(%esp)
80106486:	e8 41 e5 ff ff       	call   801049cc <kill>
}
8010648b:	c9                   	leave  
8010648c:	c3                   	ret    

8010648d <sys_getpid>:

int
sys_getpid(void)
{
8010648d:	55                   	push   %ebp
8010648e:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106490:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106496:	8b 40 10             	mov    0x10(%eax),%eax
}
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    

8010649b <sys_sbrk>:

int
sys_sbrk(void)
{
8010649b:	55                   	push   %ebp
8010649c:	89 e5                	mov    %esp,%ebp
8010649e:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801064a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801064a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064af:	e8 90 f0 ff ff       	call   80105544 <argint>
801064b4:	85 c0                	test   %eax,%eax
801064b6:	79 07                	jns    801064bf <sys_sbrk+0x24>
    return -1;
801064b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064bd:	eb 24                	jmp    801064e3 <sys_sbrk+0x48>
  addr = proc->sz;
801064bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064c5:	8b 00                	mov    (%eax),%eax
801064c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801064ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064cd:	89 04 24             	mov    %eax,(%esp)
801064d0:	e8 79 dd ff ff       	call   8010424e <growproc>
801064d5:	85 c0                	test   %eax,%eax
801064d7:	79 07                	jns    801064e0 <sys_sbrk+0x45>
    return -1;
801064d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064de:	eb 03                	jmp    801064e3 <sys_sbrk+0x48>
  return addr;
801064e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064e3:	c9                   	leave  
801064e4:	c3                   	ret    

801064e5 <sys_sleep>:

int
sys_sleep(void)
{
801064e5:	55                   	push   %ebp
801064e6:	89 e5                	mov    %esp,%ebp
801064e8:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801064eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801064f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064f9:	e8 46 f0 ff ff       	call   80105544 <argint>
801064fe:	85 c0                	test   %eax,%eax
80106500:	79 07                	jns    80106509 <sys_sleep+0x24>
    return -1;
80106502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106507:	eb 6c                	jmp    80106575 <sys_sleep+0x90>
  acquire(&tickslock);
80106509:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106510:	e8 b2 ea ff ff       	call   80104fc7 <acquire>
  ticks0 = ticks;
80106515:	a1 c0 36 11 80       	mov    0x801136c0,%eax
8010651a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010651d:	eb 34                	jmp    80106553 <sys_sleep+0x6e>
    if(proc->killed){
8010651f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106525:	8b 40 24             	mov    0x24(%eax),%eax
80106528:	85 c0                	test   %eax,%eax
8010652a:	74 13                	je     8010653f <sys_sleep+0x5a>
      release(&tickslock);
8010652c:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106533:	e8 f1 ea ff ff       	call   80105029 <release>
      return -1;
80106538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010653d:	eb 36                	jmp    80106575 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010653f:	c7 44 24 04 80 2e 11 	movl   $0x80112e80,0x4(%esp)
80106546:	80 
80106547:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
8010654e:	e8 75 e3 ff ff       	call   801048c8 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106553:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80106558:	89 c2                	mov    %eax,%edx
8010655a:	2b 55 f4             	sub    -0xc(%ebp),%edx
8010655d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106560:	39 c2                	cmp    %eax,%edx
80106562:	72 bb                	jb     8010651f <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106564:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
8010656b:	e8 b9 ea ff ff       	call   80105029 <release>
  return 0;
80106570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106575:	c9                   	leave  
80106576:	c3                   	ret    

80106577 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106577:	55                   	push   %ebp
80106578:	89 e5                	mov    %esp,%ebp
8010657a:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010657d:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106584:	e8 3e ea ff ff       	call   80104fc7 <acquire>
  xticks = ticks;
80106589:	a1 c0 36 11 80       	mov    0x801136c0,%eax
8010658e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106591:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
80106598:	e8 8c ea ff ff       	call   80105029 <release>
  return xticks;
8010659d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065a0:	c9                   	leave  
801065a1:	c3                   	ret    

801065a2 <sys_cowfork>:

//3.4
int
sys_cowfork(void)
{
801065a2:	55                   	push   %ebp
801065a3:	89 e5                	mov    %esp,%ebp
801065a5:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
801065a8:	e8 50 e8 ff ff       	call   80104dfd <cowfork>
}
801065ad:	c9                   	leave  
801065ae:	c3                   	ret    
801065af:	90                   	nop

801065b0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 08             	sub    $0x8,%esp
801065b6:	8b 45 08             	mov    0x8(%ebp),%eax
801065b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801065bc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801065c0:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065c3:	8a 45 f8             	mov    -0x8(%ebp),%al
801065c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065c9:	ee                   	out    %al,(%dx)
}
801065ca:	c9                   	leave  
801065cb:	c3                   	ret    

801065cc <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801065cc:	55                   	push   %ebp
801065cd:	89 e5                	mov    %esp,%ebp
801065cf:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801065d2:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801065d9:	00 
801065da:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801065e1:	e8 ca ff ff ff       	call   801065b0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801065e6:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801065ed:	00 
801065ee:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065f5:	e8 b6 ff ff ff       	call   801065b0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065fa:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106601:	00 
80106602:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106609:	e8 a2 ff ff ff       	call   801065b0 <outb>
  picenable(IRQ_TIMER);
8010660e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106615:	e8 a2 d4 ff ff       	call   80103abc <picenable>
}
8010661a:	c9                   	leave  
8010661b:	c3                   	ret    

8010661c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010661c:	1e                   	push   %ds
  pushl %es
8010661d:	06                   	push   %es
  pushl %fs
8010661e:	0f a0                	push   %fs
  pushl %gs
80106620:	0f a8                	push   %gs
  pushal
80106622:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106623:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106627:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106629:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010662b:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010662f:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106631:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106633:	54                   	push   %esp
  call trap
80106634:	e8 c5 01 00 00       	call   801067fe <trap>
  addl $4, %esp
80106639:	83 c4 04             	add    $0x4,%esp

8010663c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010663c:	61                   	popa   
  popl %gs
8010663d:	0f a9                	pop    %gs
  popl %fs
8010663f:	0f a1                	pop    %fs
  popl %es
80106641:	07                   	pop    %es
  popl %ds
80106642:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106643:	83 c4 08             	add    $0x8,%esp
  iret
80106646:	cf                   	iret   
80106647:	90                   	nop

80106648 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106648:	55                   	push   %ebp
80106649:	89 e5                	mov    %esp,%ebp
8010664b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010664e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106651:	48                   	dec    %eax
80106652:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106656:	8b 45 08             	mov    0x8(%ebp),%eax
80106659:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010665d:	8b 45 08             	mov    0x8(%ebp),%eax
80106660:	c1 e8 10             	shr    $0x10,%eax
80106663:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106667:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010666a:	0f 01 18             	lidtl  (%eax)
}
8010666d:	c9                   	leave  
8010666e:	c3                   	ret    

8010666f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010666f:	55                   	push   %ebp
80106670:	89 e5                	mov    %esp,%ebp
80106672:	53                   	push   %ebx
80106673:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106676:	0f 20 d3             	mov    %cr2,%ebx
80106679:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
8010667c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010667f:	83 c4 10             	add    $0x10,%esp
80106682:	5b                   	pop    %ebx
80106683:	5d                   	pop    %ebp
80106684:	c3                   	ret    

80106685 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106685:	55                   	push   %ebp
80106686:	89 e5                	mov    %esp,%ebp
80106688:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010668b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106692:	e9 b8 00 00 00       	jmp    8010674f <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669a:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
801066a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066a4:	66 89 04 d5 c0 2e 11 	mov    %ax,-0x7feed140(,%edx,8)
801066ab:	80 
801066ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066af:	66 c7 04 c5 c2 2e 11 	movw   $0x8,-0x7feed13e(,%eax,8)
801066b6:	80 08 00 
801066b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066bc:	8a 14 c5 c4 2e 11 80 	mov    -0x7feed13c(,%eax,8),%dl
801066c3:	83 e2 e0             	and    $0xffffffe0,%edx
801066c6:	88 14 c5 c4 2e 11 80 	mov    %dl,-0x7feed13c(,%eax,8)
801066cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d0:	8a 14 c5 c4 2e 11 80 	mov    -0x7feed13c(,%eax,8),%dl
801066d7:	83 e2 1f             	and    $0x1f,%edx
801066da:	88 14 c5 c4 2e 11 80 	mov    %dl,-0x7feed13c(,%eax,8)
801066e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e4:	8a 14 c5 c5 2e 11 80 	mov    -0x7feed13b(,%eax,8),%dl
801066eb:	83 e2 f0             	and    $0xfffffff0,%edx
801066ee:	83 ca 0e             	or     $0xe,%edx
801066f1:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
801066f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fb:	8a 14 c5 c5 2e 11 80 	mov    -0x7feed13b(,%eax,8),%dl
80106702:	83 e2 ef             	and    $0xffffffef,%edx
80106705:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
8010670c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670f:	8a 14 c5 c5 2e 11 80 	mov    -0x7feed13b(,%eax,8),%dl
80106716:	83 e2 9f             	and    $0xffffff9f,%edx
80106719:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
80106720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106723:	8a 14 c5 c5 2e 11 80 	mov    -0x7feed13b(,%eax,8),%dl
8010672a:	83 ca 80             	or     $0xffffff80,%edx
8010672d:	88 14 c5 c5 2e 11 80 	mov    %dl,-0x7feed13b(,%eax,8)
80106734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106737:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
8010673e:	c1 e8 10             	shr    $0x10,%eax
80106741:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106744:	66 89 04 d5 c6 2e 11 	mov    %ax,-0x7feed13a(,%edx,8)
8010674b:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010674c:	ff 45 f4             	incl   -0xc(%ebp)
8010674f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106756:	0f 8e 3b ff ff ff    	jle    80106697 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010675c:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106761:	66 a3 c0 30 11 80    	mov    %ax,0x801130c0
80106767:	66 c7 05 c2 30 11 80 	movw   $0x8,0x801130c2
8010676e:	08 00 
80106770:	a0 c4 30 11 80       	mov    0x801130c4,%al
80106775:	83 e0 e0             	and    $0xffffffe0,%eax
80106778:	a2 c4 30 11 80       	mov    %al,0x801130c4
8010677d:	a0 c4 30 11 80       	mov    0x801130c4,%al
80106782:	83 e0 1f             	and    $0x1f,%eax
80106785:	a2 c4 30 11 80       	mov    %al,0x801130c4
8010678a:	a0 c5 30 11 80       	mov    0x801130c5,%al
8010678f:	83 c8 0f             	or     $0xf,%eax
80106792:	a2 c5 30 11 80       	mov    %al,0x801130c5
80106797:	a0 c5 30 11 80       	mov    0x801130c5,%al
8010679c:	83 e0 ef             	and    $0xffffffef,%eax
8010679f:	a2 c5 30 11 80       	mov    %al,0x801130c5
801067a4:	a0 c5 30 11 80       	mov    0x801130c5,%al
801067a9:	83 c8 60             	or     $0x60,%eax
801067ac:	a2 c5 30 11 80       	mov    %al,0x801130c5
801067b1:	a0 c5 30 11 80       	mov    0x801130c5,%al
801067b6:	83 c8 80             	or     $0xffffff80,%eax
801067b9:	a2 c5 30 11 80       	mov    %al,0x801130c5
801067be:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
801067c3:	c1 e8 10             	shr    $0x10,%eax
801067c6:	66 a3 c6 30 11 80    	mov    %ax,0x801130c6
  
  initlock(&tickslock, "time");
801067cc:	c7 44 24 04 04 91 10 	movl   $0x80109104,0x4(%esp)
801067d3:	80 
801067d4:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801067db:	e8 c6 e7 ff ff       	call   80104fa6 <initlock>
}
801067e0:	c9                   	leave  
801067e1:	c3                   	ret    

801067e2 <idtinit>:

void
idtinit(void)
{
801067e2:	55                   	push   %ebp
801067e3:	89 e5                	mov    %esp,%ebp
801067e5:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801067e8:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801067ef:	00 
801067f0:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
801067f7:	e8 4c fe ff ff       	call   80106648 <lidt>
}
801067fc:	c9                   	leave  
801067fd:	c3                   	ret    

801067fe <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801067fe:	55                   	push   %ebp
801067ff:	89 e5                	mov    %esp,%ebp
80106801:	57                   	push   %edi
80106802:	56                   	push   %esi
80106803:	53                   	push   %ebx
80106804:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106807:	8b 45 08             	mov    0x8(%ebp),%eax
8010680a:	8b 40 30             	mov    0x30(%eax),%eax
8010680d:	83 f8 40             	cmp    $0x40,%eax
80106810:	75 3e                	jne    80106850 <trap+0x52>
    if(proc->killed)
80106812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106818:	8b 40 24             	mov    0x24(%eax),%eax
8010681b:	85 c0                	test   %eax,%eax
8010681d:	74 05                	je     80106824 <trap+0x26>
      exit();
8010681f:	e8 31 dc ff ff       	call   80104455 <exit>
    proc->tf = tf;
80106824:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010682a:	8b 55 08             	mov    0x8(%ebp),%edx
8010682d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106830:	e8 ec ed ff ff       	call   80105621 <syscall>
    if(proc->killed)
80106835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010683b:	8b 40 24             	mov    0x24(%eax),%eax
8010683e:	85 c0                	test   %eax,%eax
80106840:	0f 84 4e 02 00 00    	je     80106a94 <trap+0x296>
      exit();
80106846:	e8 0a dc ff ff       	call   80104455 <exit>
    return;
8010684b:	e9 44 02 00 00       	jmp    80106a94 <trap+0x296>
  }

  if( tf->trapno == T_PGFLT ) // 3.4
80106850:	8b 45 08             	mov    0x8(%ebp),%eax
80106853:	8b 40 30             	mov    0x30(%eax),%eax
80106856:	83 f8 0e             	cmp    $0xe,%eax
80106859:	75 19                	jne    80106874 <trap+0x76>
  {
	  proc->tf = tf ;
8010685b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106861:	8b 55 08             	mov    0x8(%ebp),%edx
80106864:	89 50 18             	mov    %edx,0x18(%eax)
	  if(handler_pgflt()) {
80106867:	e8 43 21 00 00       	call   801089af <handler_pgflt>
8010686c:	85 c0                	test   %eax,%eax
8010686e:	0f 85 23 02 00 00    	jne    80106a97 <trap+0x299>
		  return;
	  }
  }
  switch(tf->trapno){
80106874:	8b 45 08             	mov    0x8(%ebp),%eax
80106877:	8b 40 30             	mov    0x30(%eax),%eax
8010687a:	83 e8 20             	sub    $0x20,%eax
8010687d:	83 f8 1f             	cmp    $0x1f,%eax
80106880:	0f 87 b7 00 00 00    	ja     8010693d <trap+0x13f>
80106886:	8b 04 85 ac 91 10 80 	mov    -0x7fef6e54(,%eax,4),%eax
8010688d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010688f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106895:	8a 00                	mov    (%eax),%al
80106897:	84 c0                	test   %al,%al
80106899:	75 2f                	jne    801068ca <trap+0xcc>
      acquire(&tickslock);
8010689b:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801068a2:	e8 20 e7 ff ff       	call   80104fc7 <acquire>
      ticks++;
801068a7:	a1 c0 36 11 80       	mov    0x801136c0,%eax
801068ac:	40                   	inc    %eax
801068ad:	a3 c0 36 11 80       	mov    %eax,0x801136c0
      wakeup(&ticks);
801068b2:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801068b9:	e8 e3 e0 ff ff       	call   801049a1 <wakeup>
      release(&tickslock);
801068be:	c7 04 24 80 2e 11 80 	movl   $0x80112e80,(%esp)
801068c5:	e8 5f e7 ff ff       	call   80105029 <release>
    }
    lapiceoi();
801068ca:	e8 da c5 ff ff       	call   80102ea9 <lapiceoi>
    break;
801068cf:	e9 3c 01 00 00       	jmp    80106a10 <trap+0x212>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801068d4:	e8 e9 bd ff ff       	call   801026c2 <ideintr>
    lapiceoi();
801068d9:	e8 cb c5 ff ff       	call   80102ea9 <lapiceoi>
    break;
801068de:	e9 2d 01 00 00       	jmp    80106a10 <trap+0x212>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801068e3:	e8 a3 c3 ff ff       	call   80102c8b <kbdintr>
    lapiceoi();
801068e8:	e8 bc c5 ff ff       	call   80102ea9 <lapiceoi>
    break;
801068ed:	e9 1e 01 00 00       	jmp    80106a10 <trap+0x212>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801068f2:	e8 9d 03 00 00       	call   80106c94 <uartintr>
    lapiceoi();
801068f7:	e8 ad c5 ff ff       	call   80102ea9 <lapiceoi>
    break;
801068fc:	e9 0f 01 00 00       	jmp    80106a10 <trap+0x212>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106901:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106904:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106907:	8b 45 08             	mov    0x8(%ebp),%eax
8010690a:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010690d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106910:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106916:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106918:	0f b6 c0             	movzbl %al,%eax
8010691b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010691f:	89 54 24 08          	mov    %edx,0x8(%esp)
80106923:	89 44 24 04          	mov    %eax,0x4(%esp)
80106927:	c7 04 24 0c 91 10 80 	movl   $0x8010910c,(%esp)
8010692e:	e8 6e 9a ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106933:	e8 71 c5 ff ff       	call   80102ea9 <lapiceoi>
    break;
80106938:	e9 d3 00 00 00       	jmp    80106a10 <trap+0x212>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010693d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106943:	85 c0                	test   %eax,%eax
80106945:	74 10                	je     80106957 <trap+0x159>
80106947:	8b 45 08             	mov    0x8(%ebp),%eax
8010694a:	8b 40 3c             	mov    0x3c(%eax),%eax
8010694d:	0f b7 c0             	movzwl %ax,%eax
80106950:	83 e0 03             	and    $0x3,%eax
80106953:	85 c0                	test   %eax,%eax
80106955:	75 45                	jne    8010699c <trap+0x19e>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106957:	e8 13 fd ff ff       	call   8010666f <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010695c:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010695f:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106962:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106969:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010696b:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010696e:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106971:	8b 52 30             	mov    0x30(%edx),%edx
80106974:	89 44 24 10          	mov    %eax,0x10(%esp)
80106978:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010697c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106980:	89 54 24 04          	mov    %edx,0x4(%esp)
80106984:	c7 04 24 30 91 10 80 	movl   $0x80109130,(%esp)
8010698b:	e8 11 9a ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106990:	c7 04 24 62 91 10 80 	movl   $0x80109162,(%esp)
80106997:	e8 9a 9b ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010699c:	e8 ce fc ff ff       	call   8010666f <rcr2>
801069a1:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069a3:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069a6:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069a9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069af:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069b1:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069b4:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069b7:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069ba:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069bd:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c6:	83 c0 6c             	add    $0x6c,%eax
801069c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069d2:	8b 40 10             	mov    0x10(%eax),%eax
801069d5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801069d9:	89 7c 24 18          	mov    %edi,0x18(%esp)
801069dd:	89 74 24 14          	mov    %esi,0x14(%esp)
801069e1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801069e5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801069e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069ec:	89 54 24 08          	mov    %edx,0x8(%esp)
801069f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f4:	c7 04 24 68 91 10 80 	movl   $0x80109168,(%esp)
801069fb:	e8 a1 99 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106a00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a06:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a0d:	eb 01                	jmp    80106a10 <trap+0x212>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106a0f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a16:	85 c0                	test   %eax,%eax
80106a18:	74 23                	je     80106a3d <trap+0x23f>
80106a1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a20:	8b 40 24             	mov    0x24(%eax),%eax
80106a23:	85 c0                	test   %eax,%eax
80106a25:	74 16                	je     80106a3d <trap+0x23f>
80106a27:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2a:	8b 40 3c             	mov    0x3c(%eax),%eax
80106a2d:	0f b7 c0             	movzwl %ax,%eax
80106a30:	83 e0 03             	and    $0x3,%eax
80106a33:	83 f8 03             	cmp    $0x3,%eax
80106a36:	75 05                	jne    80106a3d <trap+0x23f>
    exit();
80106a38:	e8 18 da ff ff       	call   80104455 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a43:	85 c0                	test   %eax,%eax
80106a45:	74 1e                	je     80106a65 <trap+0x267>
80106a47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a4d:	8b 40 0c             	mov    0xc(%eax),%eax
80106a50:	83 f8 04             	cmp    $0x4,%eax
80106a53:	75 10                	jne    80106a65 <trap+0x267>
80106a55:	8b 45 08             	mov    0x8(%ebp),%eax
80106a58:	8b 40 30             	mov    0x30(%eax),%eax
80106a5b:	83 f8 20             	cmp    $0x20,%eax
80106a5e:	75 05                	jne    80106a65 <trap+0x267>
    yield();
80106a60:	e8 05 de ff ff       	call   8010486a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6b:	85 c0                	test   %eax,%eax
80106a6d:	74 29                	je     80106a98 <trap+0x29a>
80106a6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a75:	8b 40 24             	mov    0x24(%eax),%eax
80106a78:	85 c0                	test   %eax,%eax
80106a7a:	74 1c                	je     80106a98 <trap+0x29a>
80106a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7f:	8b 40 3c             	mov    0x3c(%eax),%eax
80106a82:	0f b7 c0             	movzwl %ax,%eax
80106a85:	83 e0 03             	and    $0x3,%eax
80106a88:	83 f8 03             	cmp    $0x3,%eax
80106a8b:	75 0b                	jne    80106a98 <trap+0x29a>
    exit();
80106a8d:	e8 c3 d9 ff ff       	call   80104455 <exit>
80106a92:	eb 04                	jmp    80106a98 <trap+0x29a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106a94:	90                   	nop
80106a95:	eb 01                	jmp    80106a98 <trap+0x29a>

  if( tf->trapno == T_PGFLT ) // 3.4
  {
	  proc->tf = tf ;
	  if(handler_pgflt()) {
		  return;
80106a97:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106a98:	83 c4 3c             	add    $0x3c,%esp
80106a9b:	5b                   	pop    %ebx
80106a9c:	5e                   	pop    %esi
80106a9d:	5f                   	pop    %edi
80106a9e:	5d                   	pop    %ebp
80106a9f:	c3                   	ret    

80106aa0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	53                   	push   %ebx
80106aa4:	83 ec 14             	sub    $0x14,%esp
80106aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaa:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106aae:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106ab1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106ab5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80106ab9:	ec                   	in     (%dx),%al
80106aba:	88 c3                	mov    %al,%bl
80106abc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106abf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106ac2:	83 c4 14             	add    $0x14,%esp
80106ac5:	5b                   	pop    %ebx
80106ac6:	5d                   	pop    %ebp
80106ac7:	c3                   	ret    

80106ac8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106ac8:	55                   	push   %ebp
80106ac9:	89 e5                	mov    %esp,%ebp
80106acb:	83 ec 08             	sub    $0x8,%esp
80106ace:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ad4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106ad8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106adb:	8a 45 f8             	mov    -0x8(%ebp),%al
80106ade:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106ae1:	ee                   	out    %al,(%dx)
}
80106ae2:	c9                   	leave  
80106ae3:	c3                   	ret    

80106ae4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ae4:	55                   	push   %ebp
80106ae5:	89 e5                	mov    %esp,%ebp
80106ae7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106aea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106af1:	00 
80106af2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106af9:	e8 ca ff ff ff       	call   80106ac8 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106afe:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106b05:	00 
80106b06:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b0d:	e8 b6 ff ff ff       	call   80106ac8 <outb>
  outb(COM1+0, 115200/9600);
80106b12:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106b19:	00 
80106b1a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b21:	e8 a2 ff ff ff       	call   80106ac8 <outb>
  outb(COM1+1, 0);
80106b26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b2d:	00 
80106b2e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b35:	e8 8e ff ff ff       	call   80106ac8 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b3a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b41:	00 
80106b42:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b49:	e8 7a ff ff ff       	call   80106ac8 <outb>
  outb(COM1+4, 0);
80106b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b55:	00 
80106b56:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106b5d:	e8 66 ff ff ff       	call   80106ac8 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106b69:	00 
80106b6a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b71:	e8 52 ff ff ff       	call   80106ac8 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b76:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b7d:	e8 1e ff ff ff       	call   80106aa0 <inb>
80106b82:	3c ff                	cmp    $0xff,%al
80106b84:	74 69                	je     80106bef <uartinit+0x10b>
    return;
  uart = 1;
80106b86:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80106b8d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b90:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b97:	e8 04 ff ff ff       	call   80106aa0 <inb>
  inb(COM1+0);
80106b9c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ba3:	e8 f8 fe ff ff       	call   80106aa0 <inb>
  picenable(IRQ_COM1);
80106ba8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106baf:	e8 08 cf ff ff       	call   80103abc <picenable>
  ioapicenable(IRQ_COM1, 0);
80106bb4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bbb:	00 
80106bbc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106bc3:	e8 79 bd ff ff       	call   80102941 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bc8:	c7 45 f4 2c 92 10 80 	movl   $0x8010922c,-0xc(%ebp)
80106bcf:	eb 13                	jmp    80106be4 <uartinit+0x100>
    uartputc(*p);
80106bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bd4:	8a 00                	mov    (%eax),%al
80106bd6:	0f be c0             	movsbl %al,%eax
80106bd9:	89 04 24             	mov    %eax,(%esp)
80106bdc:	e8 11 00 00 00       	call   80106bf2 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106be1:	ff 45 f4             	incl   -0xc(%ebp)
80106be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be7:	8a 00                	mov    (%eax),%al
80106be9:	84 c0                	test   %al,%al
80106beb:	75 e4                	jne    80106bd1 <uartinit+0xed>
80106bed:	eb 01                	jmp    80106bf0 <uartinit+0x10c>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106bef:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106bf0:	c9                   	leave  
80106bf1:	c3                   	ret    

80106bf2 <uartputc>:

void
uartputc(int c)
{
80106bf2:	55                   	push   %ebp
80106bf3:	89 e5                	mov    %esp,%ebp
80106bf5:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106bf8:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106bfd:	85 c0                	test   %eax,%eax
80106bff:	74 4c                	je     80106c4d <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c08:	eb 0f                	jmp    80106c19 <uartputc+0x27>
    microdelay(10);
80106c0a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106c11:	e8 b8 c2 ff ff       	call   80102ece <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c16:	ff 45 f4             	incl   -0xc(%ebp)
80106c19:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c1d:	7f 16                	jg     80106c35 <uartputc+0x43>
80106c1f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c26:	e8 75 fe ff ff       	call   80106aa0 <inb>
80106c2b:	0f b6 c0             	movzbl %al,%eax
80106c2e:	83 e0 20             	and    $0x20,%eax
80106c31:	85 c0                	test   %eax,%eax
80106c33:	74 d5                	je     80106c0a <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106c35:	8b 45 08             	mov    0x8(%ebp),%eax
80106c38:	0f b6 c0             	movzbl %al,%eax
80106c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c3f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c46:	e8 7d fe ff ff       	call   80106ac8 <outb>
80106c4b:	eb 01                	jmp    80106c4e <uartputc+0x5c>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106c4d:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106c4e:	c9                   	leave  
80106c4f:	c3                   	ret    

80106c50 <uartgetc>:

static int
uartgetc(void)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106c56:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106c5b:	85 c0                	test   %eax,%eax
80106c5d:	75 07                	jne    80106c66 <uartgetc+0x16>
    return -1;
80106c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c64:	eb 2c                	jmp    80106c92 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106c66:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c6d:	e8 2e fe ff ff       	call   80106aa0 <inb>
80106c72:	0f b6 c0             	movzbl %al,%eax
80106c75:	83 e0 01             	and    $0x1,%eax
80106c78:	85 c0                	test   %eax,%eax
80106c7a:	75 07                	jne    80106c83 <uartgetc+0x33>
    return -1;
80106c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c81:	eb 0f                	jmp    80106c92 <uartgetc+0x42>
  return inb(COM1+0);
80106c83:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c8a:	e8 11 fe ff ff       	call   80106aa0 <inb>
80106c8f:	0f b6 c0             	movzbl %al,%eax
}
80106c92:	c9                   	leave  
80106c93:	c3                   	ret    

80106c94 <uartintr>:

void
uartintr(void)
{
80106c94:	55                   	push   %ebp
80106c95:	89 e5                	mov    %esp,%ebp
80106c97:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106c9a:	c7 04 24 50 6c 10 80 	movl   $0x80106c50,(%esp)
80106ca1:	e8 ea 9a ff ff       	call   80100790 <consoleintr>
}
80106ca6:	c9                   	leave  
80106ca7:	c3                   	ret    

80106ca8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $0
80106caa:	6a 00                	push   $0x0
  jmp alltraps
80106cac:	e9 6b f9 ff ff       	jmp    8010661c <alltraps>

80106cb1 <vector1>:
.globl vector1
vector1:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $1
80106cb3:	6a 01                	push   $0x1
  jmp alltraps
80106cb5:	e9 62 f9 ff ff       	jmp    8010661c <alltraps>

80106cba <vector2>:
.globl vector2
vector2:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $2
80106cbc:	6a 02                	push   $0x2
  jmp alltraps
80106cbe:	e9 59 f9 ff ff       	jmp    8010661c <alltraps>

80106cc3 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $3
80106cc5:	6a 03                	push   $0x3
  jmp alltraps
80106cc7:	e9 50 f9 ff ff       	jmp    8010661c <alltraps>

80106ccc <vector4>:
.globl vector4
vector4:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $4
80106cce:	6a 04                	push   $0x4
  jmp alltraps
80106cd0:	e9 47 f9 ff ff       	jmp    8010661c <alltraps>

80106cd5 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $5
80106cd7:	6a 05                	push   $0x5
  jmp alltraps
80106cd9:	e9 3e f9 ff ff       	jmp    8010661c <alltraps>

80106cde <vector6>:
.globl vector6
vector6:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $6
80106ce0:	6a 06                	push   $0x6
  jmp alltraps
80106ce2:	e9 35 f9 ff ff       	jmp    8010661c <alltraps>

80106ce7 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $7
80106ce9:	6a 07                	push   $0x7
  jmp alltraps
80106ceb:	e9 2c f9 ff ff       	jmp    8010661c <alltraps>

80106cf0 <vector8>:
.globl vector8
vector8:
  pushl $8
80106cf0:	6a 08                	push   $0x8
  jmp alltraps
80106cf2:	e9 25 f9 ff ff       	jmp    8010661c <alltraps>

80106cf7 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $9
80106cf9:	6a 09                	push   $0x9
  jmp alltraps
80106cfb:	e9 1c f9 ff ff       	jmp    8010661c <alltraps>

80106d00 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d00:	6a 0a                	push   $0xa
  jmp alltraps
80106d02:	e9 15 f9 ff ff       	jmp    8010661c <alltraps>

80106d07 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d07:	6a 0b                	push   $0xb
  jmp alltraps
80106d09:	e9 0e f9 ff ff       	jmp    8010661c <alltraps>

80106d0e <vector12>:
.globl vector12
vector12:
  pushl $12
80106d0e:	6a 0c                	push   $0xc
  jmp alltraps
80106d10:	e9 07 f9 ff ff       	jmp    8010661c <alltraps>

80106d15 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d15:	6a 0d                	push   $0xd
  jmp alltraps
80106d17:	e9 00 f9 ff ff       	jmp    8010661c <alltraps>

80106d1c <vector14>:
.globl vector14
vector14:
  pushl $14
80106d1c:	6a 0e                	push   $0xe
  jmp alltraps
80106d1e:	e9 f9 f8 ff ff       	jmp    8010661c <alltraps>

80106d23 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $15
80106d25:	6a 0f                	push   $0xf
  jmp alltraps
80106d27:	e9 f0 f8 ff ff       	jmp    8010661c <alltraps>

80106d2c <vector16>:
.globl vector16
vector16:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $16
80106d2e:	6a 10                	push   $0x10
  jmp alltraps
80106d30:	e9 e7 f8 ff ff       	jmp    8010661c <alltraps>

80106d35 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d35:	6a 11                	push   $0x11
  jmp alltraps
80106d37:	e9 e0 f8 ff ff       	jmp    8010661c <alltraps>

80106d3c <vector18>:
.globl vector18
vector18:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $18
80106d3e:	6a 12                	push   $0x12
  jmp alltraps
80106d40:	e9 d7 f8 ff ff       	jmp    8010661c <alltraps>

80106d45 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $19
80106d47:	6a 13                	push   $0x13
  jmp alltraps
80106d49:	e9 ce f8 ff ff       	jmp    8010661c <alltraps>

80106d4e <vector20>:
.globl vector20
vector20:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $20
80106d50:	6a 14                	push   $0x14
  jmp alltraps
80106d52:	e9 c5 f8 ff ff       	jmp    8010661c <alltraps>

80106d57 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $21
80106d59:	6a 15                	push   $0x15
  jmp alltraps
80106d5b:	e9 bc f8 ff ff       	jmp    8010661c <alltraps>

80106d60 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $22
80106d62:	6a 16                	push   $0x16
  jmp alltraps
80106d64:	e9 b3 f8 ff ff       	jmp    8010661c <alltraps>

80106d69 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $23
80106d6b:	6a 17                	push   $0x17
  jmp alltraps
80106d6d:	e9 aa f8 ff ff       	jmp    8010661c <alltraps>

80106d72 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $24
80106d74:	6a 18                	push   $0x18
  jmp alltraps
80106d76:	e9 a1 f8 ff ff       	jmp    8010661c <alltraps>

80106d7b <vector25>:
.globl vector25
vector25:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $25
80106d7d:	6a 19                	push   $0x19
  jmp alltraps
80106d7f:	e9 98 f8 ff ff       	jmp    8010661c <alltraps>

80106d84 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $26
80106d86:	6a 1a                	push   $0x1a
  jmp alltraps
80106d88:	e9 8f f8 ff ff       	jmp    8010661c <alltraps>

80106d8d <vector27>:
.globl vector27
vector27:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $27
80106d8f:	6a 1b                	push   $0x1b
  jmp alltraps
80106d91:	e9 86 f8 ff ff       	jmp    8010661c <alltraps>

80106d96 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $28
80106d98:	6a 1c                	push   $0x1c
  jmp alltraps
80106d9a:	e9 7d f8 ff ff       	jmp    8010661c <alltraps>

80106d9f <vector29>:
.globl vector29
vector29:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $29
80106da1:	6a 1d                	push   $0x1d
  jmp alltraps
80106da3:	e9 74 f8 ff ff       	jmp    8010661c <alltraps>

80106da8 <vector30>:
.globl vector30
vector30:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $30
80106daa:	6a 1e                	push   $0x1e
  jmp alltraps
80106dac:	e9 6b f8 ff ff       	jmp    8010661c <alltraps>

80106db1 <vector31>:
.globl vector31
vector31:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $31
80106db3:	6a 1f                	push   $0x1f
  jmp alltraps
80106db5:	e9 62 f8 ff ff       	jmp    8010661c <alltraps>

80106dba <vector32>:
.globl vector32
vector32:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $32
80106dbc:	6a 20                	push   $0x20
  jmp alltraps
80106dbe:	e9 59 f8 ff ff       	jmp    8010661c <alltraps>

80106dc3 <vector33>:
.globl vector33
vector33:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $33
80106dc5:	6a 21                	push   $0x21
  jmp alltraps
80106dc7:	e9 50 f8 ff ff       	jmp    8010661c <alltraps>

80106dcc <vector34>:
.globl vector34
vector34:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $34
80106dce:	6a 22                	push   $0x22
  jmp alltraps
80106dd0:	e9 47 f8 ff ff       	jmp    8010661c <alltraps>

80106dd5 <vector35>:
.globl vector35
vector35:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $35
80106dd7:	6a 23                	push   $0x23
  jmp alltraps
80106dd9:	e9 3e f8 ff ff       	jmp    8010661c <alltraps>

80106dde <vector36>:
.globl vector36
vector36:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $36
80106de0:	6a 24                	push   $0x24
  jmp alltraps
80106de2:	e9 35 f8 ff ff       	jmp    8010661c <alltraps>

80106de7 <vector37>:
.globl vector37
vector37:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $37
80106de9:	6a 25                	push   $0x25
  jmp alltraps
80106deb:	e9 2c f8 ff ff       	jmp    8010661c <alltraps>

80106df0 <vector38>:
.globl vector38
vector38:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $38
80106df2:	6a 26                	push   $0x26
  jmp alltraps
80106df4:	e9 23 f8 ff ff       	jmp    8010661c <alltraps>

80106df9 <vector39>:
.globl vector39
vector39:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $39
80106dfb:	6a 27                	push   $0x27
  jmp alltraps
80106dfd:	e9 1a f8 ff ff       	jmp    8010661c <alltraps>

80106e02 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $40
80106e04:	6a 28                	push   $0x28
  jmp alltraps
80106e06:	e9 11 f8 ff ff       	jmp    8010661c <alltraps>

80106e0b <vector41>:
.globl vector41
vector41:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $41
80106e0d:	6a 29                	push   $0x29
  jmp alltraps
80106e0f:	e9 08 f8 ff ff       	jmp    8010661c <alltraps>

80106e14 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $42
80106e16:	6a 2a                	push   $0x2a
  jmp alltraps
80106e18:	e9 ff f7 ff ff       	jmp    8010661c <alltraps>

80106e1d <vector43>:
.globl vector43
vector43:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $43
80106e1f:	6a 2b                	push   $0x2b
  jmp alltraps
80106e21:	e9 f6 f7 ff ff       	jmp    8010661c <alltraps>

80106e26 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $44
80106e28:	6a 2c                	push   $0x2c
  jmp alltraps
80106e2a:	e9 ed f7 ff ff       	jmp    8010661c <alltraps>

80106e2f <vector45>:
.globl vector45
vector45:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $45
80106e31:	6a 2d                	push   $0x2d
  jmp alltraps
80106e33:	e9 e4 f7 ff ff       	jmp    8010661c <alltraps>

80106e38 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $46
80106e3a:	6a 2e                	push   $0x2e
  jmp alltraps
80106e3c:	e9 db f7 ff ff       	jmp    8010661c <alltraps>

80106e41 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $47
80106e43:	6a 2f                	push   $0x2f
  jmp alltraps
80106e45:	e9 d2 f7 ff ff       	jmp    8010661c <alltraps>

80106e4a <vector48>:
.globl vector48
vector48:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $48
80106e4c:	6a 30                	push   $0x30
  jmp alltraps
80106e4e:	e9 c9 f7 ff ff       	jmp    8010661c <alltraps>

80106e53 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $49
80106e55:	6a 31                	push   $0x31
  jmp alltraps
80106e57:	e9 c0 f7 ff ff       	jmp    8010661c <alltraps>

80106e5c <vector50>:
.globl vector50
vector50:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $50
80106e5e:	6a 32                	push   $0x32
  jmp alltraps
80106e60:	e9 b7 f7 ff ff       	jmp    8010661c <alltraps>

80106e65 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $51
80106e67:	6a 33                	push   $0x33
  jmp alltraps
80106e69:	e9 ae f7 ff ff       	jmp    8010661c <alltraps>

80106e6e <vector52>:
.globl vector52
vector52:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $52
80106e70:	6a 34                	push   $0x34
  jmp alltraps
80106e72:	e9 a5 f7 ff ff       	jmp    8010661c <alltraps>

80106e77 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $53
80106e79:	6a 35                	push   $0x35
  jmp alltraps
80106e7b:	e9 9c f7 ff ff       	jmp    8010661c <alltraps>

80106e80 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $54
80106e82:	6a 36                	push   $0x36
  jmp alltraps
80106e84:	e9 93 f7 ff ff       	jmp    8010661c <alltraps>

80106e89 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $55
80106e8b:	6a 37                	push   $0x37
  jmp alltraps
80106e8d:	e9 8a f7 ff ff       	jmp    8010661c <alltraps>

80106e92 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $56
80106e94:	6a 38                	push   $0x38
  jmp alltraps
80106e96:	e9 81 f7 ff ff       	jmp    8010661c <alltraps>

80106e9b <vector57>:
.globl vector57
vector57:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $57
80106e9d:	6a 39                	push   $0x39
  jmp alltraps
80106e9f:	e9 78 f7 ff ff       	jmp    8010661c <alltraps>

80106ea4 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $58
80106ea6:	6a 3a                	push   $0x3a
  jmp alltraps
80106ea8:	e9 6f f7 ff ff       	jmp    8010661c <alltraps>

80106ead <vector59>:
.globl vector59
vector59:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $59
80106eaf:	6a 3b                	push   $0x3b
  jmp alltraps
80106eb1:	e9 66 f7 ff ff       	jmp    8010661c <alltraps>

80106eb6 <vector60>:
.globl vector60
vector60:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $60
80106eb8:	6a 3c                	push   $0x3c
  jmp alltraps
80106eba:	e9 5d f7 ff ff       	jmp    8010661c <alltraps>

80106ebf <vector61>:
.globl vector61
vector61:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $61
80106ec1:	6a 3d                	push   $0x3d
  jmp alltraps
80106ec3:	e9 54 f7 ff ff       	jmp    8010661c <alltraps>

80106ec8 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $62
80106eca:	6a 3e                	push   $0x3e
  jmp alltraps
80106ecc:	e9 4b f7 ff ff       	jmp    8010661c <alltraps>

80106ed1 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $63
80106ed3:	6a 3f                	push   $0x3f
  jmp alltraps
80106ed5:	e9 42 f7 ff ff       	jmp    8010661c <alltraps>

80106eda <vector64>:
.globl vector64
vector64:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $64
80106edc:	6a 40                	push   $0x40
  jmp alltraps
80106ede:	e9 39 f7 ff ff       	jmp    8010661c <alltraps>

80106ee3 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $65
80106ee5:	6a 41                	push   $0x41
  jmp alltraps
80106ee7:	e9 30 f7 ff ff       	jmp    8010661c <alltraps>

80106eec <vector66>:
.globl vector66
vector66:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $66
80106eee:	6a 42                	push   $0x42
  jmp alltraps
80106ef0:	e9 27 f7 ff ff       	jmp    8010661c <alltraps>

80106ef5 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $67
80106ef7:	6a 43                	push   $0x43
  jmp alltraps
80106ef9:	e9 1e f7 ff ff       	jmp    8010661c <alltraps>

80106efe <vector68>:
.globl vector68
vector68:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $68
80106f00:	6a 44                	push   $0x44
  jmp alltraps
80106f02:	e9 15 f7 ff ff       	jmp    8010661c <alltraps>

80106f07 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $69
80106f09:	6a 45                	push   $0x45
  jmp alltraps
80106f0b:	e9 0c f7 ff ff       	jmp    8010661c <alltraps>

80106f10 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $70
80106f12:	6a 46                	push   $0x46
  jmp alltraps
80106f14:	e9 03 f7 ff ff       	jmp    8010661c <alltraps>

80106f19 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $71
80106f1b:	6a 47                	push   $0x47
  jmp alltraps
80106f1d:	e9 fa f6 ff ff       	jmp    8010661c <alltraps>

80106f22 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $72
80106f24:	6a 48                	push   $0x48
  jmp alltraps
80106f26:	e9 f1 f6 ff ff       	jmp    8010661c <alltraps>

80106f2b <vector73>:
.globl vector73
vector73:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $73
80106f2d:	6a 49                	push   $0x49
  jmp alltraps
80106f2f:	e9 e8 f6 ff ff       	jmp    8010661c <alltraps>

80106f34 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $74
80106f36:	6a 4a                	push   $0x4a
  jmp alltraps
80106f38:	e9 df f6 ff ff       	jmp    8010661c <alltraps>

80106f3d <vector75>:
.globl vector75
vector75:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $75
80106f3f:	6a 4b                	push   $0x4b
  jmp alltraps
80106f41:	e9 d6 f6 ff ff       	jmp    8010661c <alltraps>

80106f46 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $76
80106f48:	6a 4c                	push   $0x4c
  jmp alltraps
80106f4a:	e9 cd f6 ff ff       	jmp    8010661c <alltraps>

80106f4f <vector77>:
.globl vector77
vector77:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $77
80106f51:	6a 4d                	push   $0x4d
  jmp alltraps
80106f53:	e9 c4 f6 ff ff       	jmp    8010661c <alltraps>

80106f58 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $78
80106f5a:	6a 4e                	push   $0x4e
  jmp alltraps
80106f5c:	e9 bb f6 ff ff       	jmp    8010661c <alltraps>

80106f61 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $79
80106f63:	6a 4f                	push   $0x4f
  jmp alltraps
80106f65:	e9 b2 f6 ff ff       	jmp    8010661c <alltraps>

80106f6a <vector80>:
.globl vector80
vector80:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $80
80106f6c:	6a 50                	push   $0x50
  jmp alltraps
80106f6e:	e9 a9 f6 ff ff       	jmp    8010661c <alltraps>

80106f73 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $81
80106f75:	6a 51                	push   $0x51
  jmp alltraps
80106f77:	e9 a0 f6 ff ff       	jmp    8010661c <alltraps>

80106f7c <vector82>:
.globl vector82
vector82:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $82
80106f7e:	6a 52                	push   $0x52
  jmp alltraps
80106f80:	e9 97 f6 ff ff       	jmp    8010661c <alltraps>

80106f85 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $83
80106f87:	6a 53                	push   $0x53
  jmp alltraps
80106f89:	e9 8e f6 ff ff       	jmp    8010661c <alltraps>

80106f8e <vector84>:
.globl vector84
vector84:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $84
80106f90:	6a 54                	push   $0x54
  jmp alltraps
80106f92:	e9 85 f6 ff ff       	jmp    8010661c <alltraps>

80106f97 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $85
80106f99:	6a 55                	push   $0x55
  jmp alltraps
80106f9b:	e9 7c f6 ff ff       	jmp    8010661c <alltraps>

80106fa0 <vector86>:
.globl vector86
vector86:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $86
80106fa2:	6a 56                	push   $0x56
  jmp alltraps
80106fa4:	e9 73 f6 ff ff       	jmp    8010661c <alltraps>

80106fa9 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $87
80106fab:	6a 57                	push   $0x57
  jmp alltraps
80106fad:	e9 6a f6 ff ff       	jmp    8010661c <alltraps>

80106fb2 <vector88>:
.globl vector88
vector88:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $88
80106fb4:	6a 58                	push   $0x58
  jmp alltraps
80106fb6:	e9 61 f6 ff ff       	jmp    8010661c <alltraps>

80106fbb <vector89>:
.globl vector89
vector89:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $89
80106fbd:	6a 59                	push   $0x59
  jmp alltraps
80106fbf:	e9 58 f6 ff ff       	jmp    8010661c <alltraps>

80106fc4 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $90
80106fc6:	6a 5a                	push   $0x5a
  jmp alltraps
80106fc8:	e9 4f f6 ff ff       	jmp    8010661c <alltraps>

80106fcd <vector91>:
.globl vector91
vector91:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $91
80106fcf:	6a 5b                	push   $0x5b
  jmp alltraps
80106fd1:	e9 46 f6 ff ff       	jmp    8010661c <alltraps>

80106fd6 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $92
80106fd8:	6a 5c                	push   $0x5c
  jmp alltraps
80106fda:	e9 3d f6 ff ff       	jmp    8010661c <alltraps>

80106fdf <vector93>:
.globl vector93
vector93:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $93
80106fe1:	6a 5d                	push   $0x5d
  jmp alltraps
80106fe3:	e9 34 f6 ff ff       	jmp    8010661c <alltraps>

80106fe8 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $94
80106fea:	6a 5e                	push   $0x5e
  jmp alltraps
80106fec:	e9 2b f6 ff ff       	jmp    8010661c <alltraps>

80106ff1 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $95
80106ff3:	6a 5f                	push   $0x5f
  jmp alltraps
80106ff5:	e9 22 f6 ff ff       	jmp    8010661c <alltraps>

80106ffa <vector96>:
.globl vector96
vector96:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $96
80106ffc:	6a 60                	push   $0x60
  jmp alltraps
80106ffe:	e9 19 f6 ff ff       	jmp    8010661c <alltraps>

80107003 <vector97>:
.globl vector97
vector97:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $97
80107005:	6a 61                	push   $0x61
  jmp alltraps
80107007:	e9 10 f6 ff ff       	jmp    8010661c <alltraps>

8010700c <vector98>:
.globl vector98
vector98:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $98
8010700e:	6a 62                	push   $0x62
  jmp alltraps
80107010:	e9 07 f6 ff ff       	jmp    8010661c <alltraps>

80107015 <vector99>:
.globl vector99
vector99:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $99
80107017:	6a 63                	push   $0x63
  jmp alltraps
80107019:	e9 fe f5 ff ff       	jmp    8010661c <alltraps>

8010701e <vector100>:
.globl vector100
vector100:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $100
80107020:	6a 64                	push   $0x64
  jmp alltraps
80107022:	e9 f5 f5 ff ff       	jmp    8010661c <alltraps>

80107027 <vector101>:
.globl vector101
vector101:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $101
80107029:	6a 65                	push   $0x65
  jmp alltraps
8010702b:	e9 ec f5 ff ff       	jmp    8010661c <alltraps>

80107030 <vector102>:
.globl vector102
vector102:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $102
80107032:	6a 66                	push   $0x66
  jmp alltraps
80107034:	e9 e3 f5 ff ff       	jmp    8010661c <alltraps>

80107039 <vector103>:
.globl vector103
vector103:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $103
8010703b:	6a 67                	push   $0x67
  jmp alltraps
8010703d:	e9 da f5 ff ff       	jmp    8010661c <alltraps>

80107042 <vector104>:
.globl vector104
vector104:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $104
80107044:	6a 68                	push   $0x68
  jmp alltraps
80107046:	e9 d1 f5 ff ff       	jmp    8010661c <alltraps>

8010704b <vector105>:
.globl vector105
vector105:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $105
8010704d:	6a 69                	push   $0x69
  jmp alltraps
8010704f:	e9 c8 f5 ff ff       	jmp    8010661c <alltraps>

80107054 <vector106>:
.globl vector106
vector106:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $106
80107056:	6a 6a                	push   $0x6a
  jmp alltraps
80107058:	e9 bf f5 ff ff       	jmp    8010661c <alltraps>

8010705d <vector107>:
.globl vector107
vector107:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $107
8010705f:	6a 6b                	push   $0x6b
  jmp alltraps
80107061:	e9 b6 f5 ff ff       	jmp    8010661c <alltraps>

80107066 <vector108>:
.globl vector108
vector108:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $108
80107068:	6a 6c                	push   $0x6c
  jmp alltraps
8010706a:	e9 ad f5 ff ff       	jmp    8010661c <alltraps>

8010706f <vector109>:
.globl vector109
vector109:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $109
80107071:	6a 6d                	push   $0x6d
  jmp alltraps
80107073:	e9 a4 f5 ff ff       	jmp    8010661c <alltraps>

80107078 <vector110>:
.globl vector110
vector110:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $110
8010707a:	6a 6e                	push   $0x6e
  jmp alltraps
8010707c:	e9 9b f5 ff ff       	jmp    8010661c <alltraps>

80107081 <vector111>:
.globl vector111
vector111:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $111
80107083:	6a 6f                	push   $0x6f
  jmp alltraps
80107085:	e9 92 f5 ff ff       	jmp    8010661c <alltraps>

8010708a <vector112>:
.globl vector112
vector112:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $112
8010708c:	6a 70                	push   $0x70
  jmp alltraps
8010708e:	e9 89 f5 ff ff       	jmp    8010661c <alltraps>

80107093 <vector113>:
.globl vector113
vector113:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $113
80107095:	6a 71                	push   $0x71
  jmp alltraps
80107097:	e9 80 f5 ff ff       	jmp    8010661c <alltraps>

8010709c <vector114>:
.globl vector114
vector114:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $114
8010709e:	6a 72                	push   $0x72
  jmp alltraps
801070a0:	e9 77 f5 ff ff       	jmp    8010661c <alltraps>

801070a5 <vector115>:
.globl vector115
vector115:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $115
801070a7:	6a 73                	push   $0x73
  jmp alltraps
801070a9:	e9 6e f5 ff ff       	jmp    8010661c <alltraps>

801070ae <vector116>:
.globl vector116
vector116:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $116
801070b0:	6a 74                	push   $0x74
  jmp alltraps
801070b2:	e9 65 f5 ff ff       	jmp    8010661c <alltraps>

801070b7 <vector117>:
.globl vector117
vector117:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $117
801070b9:	6a 75                	push   $0x75
  jmp alltraps
801070bb:	e9 5c f5 ff ff       	jmp    8010661c <alltraps>

801070c0 <vector118>:
.globl vector118
vector118:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $118
801070c2:	6a 76                	push   $0x76
  jmp alltraps
801070c4:	e9 53 f5 ff ff       	jmp    8010661c <alltraps>

801070c9 <vector119>:
.globl vector119
vector119:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $119
801070cb:	6a 77                	push   $0x77
  jmp alltraps
801070cd:	e9 4a f5 ff ff       	jmp    8010661c <alltraps>

801070d2 <vector120>:
.globl vector120
vector120:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $120
801070d4:	6a 78                	push   $0x78
  jmp alltraps
801070d6:	e9 41 f5 ff ff       	jmp    8010661c <alltraps>

801070db <vector121>:
.globl vector121
vector121:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $121
801070dd:	6a 79                	push   $0x79
  jmp alltraps
801070df:	e9 38 f5 ff ff       	jmp    8010661c <alltraps>

801070e4 <vector122>:
.globl vector122
vector122:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $122
801070e6:	6a 7a                	push   $0x7a
  jmp alltraps
801070e8:	e9 2f f5 ff ff       	jmp    8010661c <alltraps>

801070ed <vector123>:
.globl vector123
vector123:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $123
801070ef:	6a 7b                	push   $0x7b
  jmp alltraps
801070f1:	e9 26 f5 ff ff       	jmp    8010661c <alltraps>

801070f6 <vector124>:
.globl vector124
vector124:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $124
801070f8:	6a 7c                	push   $0x7c
  jmp alltraps
801070fa:	e9 1d f5 ff ff       	jmp    8010661c <alltraps>

801070ff <vector125>:
.globl vector125
vector125:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $125
80107101:	6a 7d                	push   $0x7d
  jmp alltraps
80107103:	e9 14 f5 ff ff       	jmp    8010661c <alltraps>

80107108 <vector126>:
.globl vector126
vector126:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $126
8010710a:	6a 7e                	push   $0x7e
  jmp alltraps
8010710c:	e9 0b f5 ff ff       	jmp    8010661c <alltraps>

80107111 <vector127>:
.globl vector127
vector127:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $127
80107113:	6a 7f                	push   $0x7f
  jmp alltraps
80107115:	e9 02 f5 ff ff       	jmp    8010661c <alltraps>

8010711a <vector128>:
.globl vector128
vector128:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $128
8010711c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107121:	e9 f6 f4 ff ff       	jmp    8010661c <alltraps>

80107126 <vector129>:
.globl vector129
vector129:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $129
80107128:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010712d:	e9 ea f4 ff ff       	jmp    8010661c <alltraps>

80107132 <vector130>:
.globl vector130
vector130:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $130
80107134:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107139:	e9 de f4 ff ff       	jmp    8010661c <alltraps>

8010713e <vector131>:
.globl vector131
vector131:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $131
80107140:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107145:	e9 d2 f4 ff ff       	jmp    8010661c <alltraps>

8010714a <vector132>:
.globl vector132
vector132:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $132
8010714c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107151:	e9 c6 f4 ff ff       	jmp    8010661c <alltraps>

80107156 <vector133>:
.globl vector133
vector133:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $133
80107158:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010715d:	e9 ba f4 ff ff       	jmp    8010661c <alltraps>

80107162 <vector134>:
.globl vector134
vector134:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $134
80107164:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107169:	e9 ae f4 ff ff       	jmp    8010661c <alltraps>

8010716e <vector135>:
.globl vector135
vector135:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $135
80107170:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107175:	e9 a2 f4 ff ff       	jmp    8010661c <alltraps>

8010717a <vector136>:
.globl vector136
vector136:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $136
8010717c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107181:	e9 96 f4 ff ff       	jmp    8010661c <alltraps>

80107186 <vector137>:
.globl vector137
vector137:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $137
80107188:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010718d:	e9 8a f4 ff ff       	jmp    8010661c <alltraps>

80107192 <vector138>:
.globl vector138
vector138:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $138
80107194:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107199:	e9 7e f4 ff ff       	jmp    8010661c <alltraps>

8010719e <vector139>:
.globl vector139
vector139:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $139
801071a0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071a5:	e9 72 f4 ff ff       	jmp    8010661c <alltraps>

801071aa <vector140>:
.globl vector140
vector140:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $140
801071ac:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071b1:	e9 66 f4 ff ff       	jmp    8010661c <alltraps>

801071b6 <vector141>:
.globl vector141
vector141:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $141
801071b8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071bd:	e9 5a f4 ff ff       	jmp    8010661c <alltraps>

801071c2 <vector142>:
.globl vector142
vector142:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $142
801071c4:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071c9:	e9 4e f4 ff ff       	jmp    8010661c <alltraps>

801071ce <vector143>:
.globl vector143
vector143:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $143
801071d0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071d5:	e9 42 f4 ff ff       	jmp    8010661c <alltraps>

801071da <vector144>:
.globl vector144
vector144:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $144
801071dc:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071e1:	e9 36 f4 ff ff       	jmp    8010661c <alltraps>

801071e6 <vector145>:
.globl vector145
vector145:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $145
801071e8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ed:	e9 2a f4 ff ff       	jmp    8010661c <alltraps>

801071f2 <vector146>:
.globl vector146
vector146:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $146
801071f4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071f9:	e9 1e f4 ff ff       	jmp    8010661c <alltraps>

801071fe <vector147>:
.globl vector147
vector147:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $147
80107200:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107205:	e9 12 f4 ff ff       	jmp    8010661c <alltraps>

8010720a <vector148>:
.globl vector148
vector148:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $148
8010720c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107211:	e9 06 f4 ff ff       	jmp    8010661c <alltraps>

80107216 <vector149>:
.globl vector149
vector149:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $149
80107218:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010721d:	e9 fa f3 ff ff       	jmp    8010661c <alltraps>

80107222 <vector150>:
.globl vector150
vector150:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $150
80107224:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107229:	e9 ee f3 ff ff       	jmp    8010661c <alltraps>

8010722e <vector151>:
.globl vector151
vector151:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $151
80107230:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107235:	e9 e2 f3 ff ff       	jmp    8010661c <alltraps>

8010723a <vector152>:
.globl vector152
vector152:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $152
8010723c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107241:	e9 d6 f3 ff ff       	jmp    8010661c <alltraps>

80107246 <vector153>:
.globl vector153
vector153:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $153
80107248:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010724d:	e9 ca f3 ff ff       	jmp    8010661c <alltraps>

80107252 <vector154>:
.globl vector154
vector154:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $154
80107254:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107259:	e9 be f3 ff ff       	jmp    8010661c <alltraps>

8010725e <vector155>:
.globl vector155
vector155:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $155
80107260:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107265:	e9 b2 f3 ff ff       	jmp    8010661c <alltraps>

8010726a <vector156>:
.globl vector156
vector156:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $156
8010726c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107271:	e9 a6 f3 ff ff       	jmp    8010661c <alltraps>

80107276 <vector157>:
.globl vector157
vector157:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $157
80107278:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010727d:	e9 9a f3 ff ff       	jmp    8010661c <alltraps>

80107282 <vector158>:
.globl vector158
vector158:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $158
80107284:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107289:	e9 8e f3 ff ff       	jmp    8010661c <alltraps>

8010728e <vector159>:
.globl vector159
vector159:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $159
80107290:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107295:	e9 82 f3 ff ff       	jmp    8010661c <alltraps>

8010729a <vector160>:
.globl vector160
vector160:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $160
8010729c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072a1:	e9 76 f3 ff ff       	jmp    8010661c <alltraps>

801072a6 <vector161>:
.globl vector161
vector161:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $161
801072a8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072ad:	e9 6a f3 ff ff       	jmp    8010661c <alltraps>

801072b2 <vector162>:
.globl vector162
vector162:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $162
801072b4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072b9:	e9 5e f3 ff ff       	jmp    8010661c <alltraps>

801072be <vector163>:
.globl vector163
vector163:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $163
801072c0:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072c5:	e9 52 f3 ff ff       	jmp    8010661c <alltraps>

801072ca <vector164>:
.globl vector164
vector164:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $164
801072cc:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072d1:	e9 46 f3 ff ff       	jmp    8010661c <alltraps>

801072d6 <vector165>:
.globl vector165
vector165:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $165
801072d8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072dd:	e9 3a f3 ff ff       	jmp    8010661c <alltraps>

801072e2 <vector166>:
.globl vector166
vector166:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $166
801072e4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072e9:	e9 2e f3 ff ff       	jmp    8010661c <alltraps>

801072ee <vector167>:
.globl vector167
vector167:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $167
801072f0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072f5:	e9 22 f3 ff ff       	jmp    8010661c <alltraps>

801072fa <vector168>:
.globl vector168
vector168:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $168
801072fc:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107301:	e9 16 f3 ff ff       	jmp    8010661c <alltraps>

80107306 <vector169>:
.globl vector169
vector169:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $169
80107308:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010730d:	e9 0a f3 ff ff       	jmp    8010661c <alltraps>

80107312 <vector170>:
.globl vector170
vector170:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $170
80107314:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107319:	e9 fe f2 ff ff       	jmp    8010661c <alltraps>

8010731e <vector171>:
.globl vector171
vector171:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $171
80107320:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107325:	e9 f2 f2 ff ff       	jmp    8010661c <alltraps>

8010732a <vector172>:
.globl vector172
vector172:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $172
8010732c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107331:	e9 e6 f2 ff ff       	jmp    8010661c <alltraps>

80107336 <vector173>:
.globl vector173
vector173:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $173
80107338:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010733d:	e9 da f2 ff ff       	jmp    8010661c <alltraps>

80107342 <vector174>:
.globl vector174
vector174:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $174
80107344:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107349:	e9 ce f2 ff ff       	jmp    8010661c <alltraps>

8010734e <vector175>:
.globl vector175
vector175:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $175
80107350:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107355:	e9 c2 f2 ff ff       	jmp    8010661c <alltraps>

8010735a <vector176>:
.globl vector176
vector176:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $176
8010735c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107361:	e9 b6 f2 ff ff       	jmp    8010661c <alltraps>

80107366 <vector177>:
.globl vector177
vector177:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $177
80107368:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010736d:	e9 aa f2 ff ff       	jmp    8010661c <alltraps>

80107372 <vector178>:
.globl vector178
vector178:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $178
80107374:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107379:	e9 9e f2 ff ff       	jmp    8010661c <alltraps>

8010737e <vector179>:
.globl vector179
vector179:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $179
80107380:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107385:	e9 92 f2 ff ff       	jmp    8010661c <alltraps>

8010738a <vector180>:
.globl vector180
vector180:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $180
8010738c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107391:	e9 86 f2 ff ff       	jmp    8010661c <alltraps>

80107396 <vector181>:
.globl vector181
vector181:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $181
80107398:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010739d:	e9 7a f2 ff ff       	jmp    8010661c <alltraps>

801073a2 <vector182>:
.globl vector182
vector182:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $182
801073a4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073a9:	e9 6e f2 ff ff       	jmp    8010661c <alltraps>

801073ae <vector183>:
.globl vector183
vector183:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $183
801073b0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073b5:	e9 62 f2 ff ff       	jmp    8010661c <alltraps>

801073ba <vector184>:
.globl vector184
vector184:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $184
801073bc:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073c1:	e9 56 f2 ff ff       	jmp    8010661c <alltraps>

801073c6 <vector185>:
.globl vector185
vector185:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $185
801073c8:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073cd:	e9 4a f2 ff ff       	jmp    8010661c <alltraps>

801073d2 <vector186>:
.globl vector186
vector186:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $186
801073d4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073d9:	e9 3e f2 ff ff       	jmp    8010661c <alltraps>

801073de <vector187>:
.globl vector187
vector187:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $187
801073e0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073e5:	e9 32 f2 ff ff       	jmp    8010661c <alltraps>

801073ea <vector188>:
.globl vector188
vector188:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $188
801073ec:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073f1:	e9 26 f2 ff ff       	jmp    8010661c <alltraps>

801073f6 <vector189>:
.globl vector189
vector189:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $189
801073f8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073fd:	e9 1a f2 ff ff       	jmp    8010661c <alltraps>

80107402 <vector190>:
.globl vector190
vector190:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $190
80107404:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107409:	e9 0e f2 ff ff       	jmp    8010661c <alltraps>

8010740e <vector191>:
.globl vector191
vector191:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $191
80107410:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107415:	e9 02 f2 ff ff       	jmp    8010661c <alltraps>

8010741a <vector192>:
.globl vector192
vector192:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $192
8010741c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107421:	e9 f6 f1 ff ff       	jmp    8010661c <alltraps>

80107426 <vector193>:
.globl vector193
vector193:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $193
80107428:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010742d:	e9 ea f1 ff ff       	jmp    8010661c <alltraps>

80107432 <vector194>:
.globl vector194
vector194:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $194
80107434:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107439:	e9 de f1 ff ff       	jmp    8010661c <alltraps>

8010743e <vector195>:
.globl vector195
vector195:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $195
80107440:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107445:	e9 d2 f1 ff ff       	jmp    8010661c <alltraps>

8010744a <vector196>:
.globl vector196
vector196:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $196
8010744c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107451:	e9 c6 f1 ff ff       	jmp    8010661c <alltraps>

80107456 <vector197>:
.globl vector197
vector197:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $197
80107458:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010745d:	e9 ba f1 ff ff       	jmp    8010661c <alltraps>

80107462 <vector198>:
.globl vector198
vector198:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $198
80107464:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107469:	e9 ae f1 ff ff       	jmp    8010661c <alltraps>

8010746e <vector199>:
.globl vector199
vector199:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $199
80107470:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107475:	e9 a2 f1 ff ff       	jmp    8010661c <alltraps>

8010747a <vector200>:
.globl vector200
vector200:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $200
8010747c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107481:	e9 96 f1 ff ff       	jmp    8010661c <alltraps>

80107486 <vector201>:
.globl vector201
vector201:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $201
80107488:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010748d:	e9 8a f1 ff ff       	jmp    8010661c <alltraps>

80107492 <vector202>:
.globl vector202
vector202:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $202
80107494:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107499:	e9 7e f1 ff ff       	jmp    8010661c <alltraps>

8010749e <vector203>:
.globl vector203
vector203:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $203
801074a0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074a5:	e9 72 f1 ff ff       	jmp    8010661c <alltraps>

801074aa <vector204>:
.globl vector204
vector204:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $204
801074ac:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074b1:	e9 66 f1 ff ff       	jmp    8010661c <alltraps>

801074b6 <vector205>:
.globl vector205
vector205:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $205
801074b8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074bd:	e9 5a f1 ff ff       	jmp    8010661c <alltraps>

801074c2 <vector206>:
.globl vector206
vector206:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $206
801074c4:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074c9:	e9 4e f1 ff ff       	jmp    8010661c <alltraps>

801074ce <vector207>:
.globl vector207
vector207:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $207
801074d0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074d5:	e9 42 f1 ff ff       	jmp    8010661c <alltraps>

801074da <vector208>:
.globl vector208
vector208:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $208
801074dc:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074e1:	e9 36 f1 ff ff       	jmp    8010661c <alltraps>

801074e6 <vector209>:
.globl vector209
vector209:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $209
801074e8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ed:	e9 2a f1 ff ff       	jmp    8010661c <alltraps>

801074f2 <vector210>:
.globl vector210
vector210:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $210
801074f4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074f9:	e9 1e f1 ff ff       	jmp    8010661c <alltraps>

801074fe <vector211>:
.globl vector211
vector211:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $211
80107500:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107505:	e9 12 f1 ff ff       	jmp    8010661c <alltraps>

8010750a <vector212>:
.globl vector212
vector212:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $212
8010750c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107511:	e9 06 f1 ff ff       	jmp    8010661c <alltraps>

80107516 <vector213>:
.globl vector213
vector213:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $213
80107518:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010751d:	e9 fa f0 ff ff       	jmp    8010661c <alltraps>

80107522 <vector214>:
.globl vector214
vector214:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $214
80107524:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107529:	e9 ee f0 ff ff       	jmp    8010661c <alltraps>

8010752e <vector215>:
.globl vector215
vector215:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $215
80107530:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107535:	e9 e2 f0 ff ff       	jmp    8010661c <alltraps>

8010753a <vector216>:
.globl vector216
vector216:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $216
8010753c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107541:	e9 d6 f0 ff ff       	jmp    8010661c <alltraps>

80107546 <vector217>:
.globl vector217
vector217:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $217
80107548:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010754d:	e9 ca f0 ff ff       	jmp    8010661c <alltraps>

80107552 <vector218>:
.globl vector218
vector218:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $218
80107554:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107559:	e9 be f0 ff ff       	jmp    8010661c <alltraps>

8010755e <vector219>:
.globl vector219
vector219:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $219
80107560:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107565:	e9 b2 f0 ff ff       	jmp    8010661c <alltraps>

8010756a <vector220>:
.globl vector220
vector220:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $220
8010756c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107571:	e9 a6 f0 ff ff       	jmp    8010661c <alltraps>

80107576 <vector221>:
.globl vector221
vector221:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $221
80107578:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010757d:	e9 9a f0 ff ff       	jmp    8010661c <alltraps>

80107582 <vector222>:
.globl vector222
vector222:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $222
80107584:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107589:	e9 8e f0 ff ff       	jmp    8010661c <alltraps>

8010758e <vector223>:
.globl vector223
vector223:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $223
80107590:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107595:	e9 82 f0 ff ff       	jmp    8010661c <alltraps>

8010759a <vector224>:
.globl vector224
vector224:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $224
8010759c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075a1:	e9 76 f0 ff ff       	jmp    8010661c <alltraps>

801075a6 <vector225>:
.globl vector225
vector225:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $225
801075a8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075ad:	e9 6a f0 ff ff       	jmp    8010661c <alltraps>

801075b2 <vector226>:
.globl vector226
vector226:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $226
801075b4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075b9:	e9 5e f0 ff ff       	jmp    8010661c <alltraps>

801075be <vector227>:
.globl vector227
vector227:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $227
801075c0:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075c5:	e9 52 f0 ff ff       	jmp    8010661c <alltraps>

801075ca <vector228>:
.globl vector228
vector228:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $228
801075cc:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075d1:	e9 46 f0 ff ff       	jmp    8010661c <alltraps>

801075d6 <vector229>:
.globl vector229
vector229:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $229
801075d8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075dd:	e9 3a f0 ff ff       	jmp    8010661c <alltraps>

801075e2 <vector230>:
.globl vector230
vector230:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $230
801075e4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075e9:	e9 2e f0 ff ff       	jmp    8010661c <alltraps>

801075ee <vector231>:
.globl vector231
vector231:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $231
801075f0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075f5:	e9 22 f0 ff ff       	jmp    8010661c <alltraps>

801075fa <vector232>:
.globl vector232
vector232:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $232
801075fc:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107601:	e9 16 f0 ff ff       	jmp    8010661c <alltraps>

80107606 <vector233>:
.globl vector233
vector233:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $233
80107608:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010760d:	e9 0a f0 ff ff       	jmp    8010661c <alltraps>

80107612 <vector234>:
.globl vector234
vector234:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $234
80107614:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107619:	e9 fe ef ff ff       	jmp    8010661c <alltraps>

8010761e <vector235>:
.globl vector235
vector235:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $235
80107620:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107625:	e9 f2 ef ff ff       	jmp    8010661c <alltraps>

8010762a <vector236>:
.globl vector236
vector236:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $236
8010762c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107631:	e9 e6 ef ff ff       	jmp    8010661c <alltraps>

80107636 <vector237>:
.globl vector237
vector237:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $237
80107638:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010763d:	e9 da ef ff ff       	jmp    8010661c <alltraps>

80107642 <vector238>:
.globl vector238
vector238:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $238
80107644:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107649:	e9 ce ef ff ff       	jmp    8010661c <alltraps>

8010764e <vector239>:
.globl vector239
vector239:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $239
80107650:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107655:	e9 c2 ef ff ff       	jmp    8010661c <alltraps>

8010765a <vector240>:
.globl vector240
vector240:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $240
8010765c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107661:	e9 b6 ef ff ff       	jmp    8010661c <alltraps>

80107666 <vector241>:
.globl vector241
vector241:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $241
80107668:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010766d:	e9 aa ef ff ff       	jmp    8010661c <alltraps>

80107672 <vector242>:
.globl vector242
vector242:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $242
80107674:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107679:	e9 9e ef ff ff       	jmp    8010661c <alltraps>

8010767e <vector243>:
.globl vector243
vector243:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $243
80107680:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107685:	e9 92 ef ff ff       	jmp    8010661c <alltraps>

8010768a <vector244>:
.globl vector244
vector244:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $244
8010768c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107691:	e9 86 ef ff ff       	jmp    8010661c <alltraps>

80107696 <vector245>:
.globl vector245
vector245:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $245
80107698:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010769d:	e9 7a ef ff ff       	jmp    8010661c <alltraps>

801076a2 <vector246>:
.globl vector246
vector246:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $246
801076a4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076a9:	e9 6e ef ff ff       	jmp    8010661c <alltraps>

801076ae <vector247>:
.globl vector247
vector247:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $247
801076b0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076b5:	e9 62 ef ff ff       	jmp    8010661c <alltraps>

801076ba <vector248>:
.globl vector248
vector248:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $248
801076bc:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076c1:	e9 56 ef ff ff       	jmp    8010661c <alltraps>

801076c6 <vector249>:
.globl vector249
vector249:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $249
801076c8:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076cd:	e9 4a ef ff ff       	jmp    8010661c <alltraps>

801076d2 <vector250>:
.globl vector250
vector250:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $250
801076d4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076d9:	e9 3e ef ff ff       	jmp    8010661c <alltraps>

801076de <vector251>:
.globl vector251
vector251:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $251
801076e0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076e5:	e9 32 ef ff ff       	jmp    8010661c <alltraps>

801076ea <vector252>:
.globl vector252
vector252:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $252
801076ec:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076f1:	e9 26 ef ff ff       	jmp    8010661c <alltraps>

801076f6 <vector253>:
.globl vector253
vector253:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $253
801076f8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076fd:	e9 1a ef ff ff       	jmp    8010661c <alltraps>

80107702 <vector254>:
.globl vector254
vector254:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $254
80107704:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107709:	e9 0e ef ff ff       	jmp    8010661c <alltraps>

8010770e <vector255>:
.globl vector255
vector255:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $255
80107710:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107715:	e9 02 ef ff ff       	jmp    8010661c <alltraps>
8010771a:	66 90                	xchg   %ax,%ax

8010771c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010771c:	55                   	push   %ebp
8010771d:	89 e5                	mov    %esp,%ebp
8010771f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107722:	8b 45 0c             	mov    0xc(%ebp),%eax
80107725:	48                   	dec    %eax
80107726:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010772a:	8b 45 08             	mov    0x8(%ebp),%eax
8010772d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107731:	8b 45 08             	mov    0x8(%ebp),%eax
80107734:	c1 e8 10             	shr    $0x10,%eax
80107737:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010773b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010773e:	0f 01 10             	lgdtl  (%eax)
}
80107741:	c9                   	leave  
80107742:	c3                   	ret    

80107743 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107743:	55                   	push   %ebp
80107744:	89 e5                	mov    %esp,%ebp
80107746:	83 ec 04             	sub    $0x4,%esp
80107749:	8b 45 08             	mov    0x8(%ebp),%eax
8010774c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107750:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107753:	0f 00 d8             	ltr    %ax
}
80107756:	c9                   	leave  
80107757:	c3                   	ret    

80107758 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107758:	55                   	push   %ebp
80107759:	89 e5                	mov    %esp,%ebp
8010775b:	83 ec 04             	sub    $0x4,%esp
8010775e:	8b 45 08             	mov    0x8(%ebp),%eax
80107761:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107765:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107768:	8e e8                	mov    %eax,%gs
}
8010776a:	c9                   	leave  
8010776b:	c3                   	ret    

8010776c <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010776c:	55                   	push   %ebp
8010776d:	89 e5                	mov    %esp,%ebp
8010776f:	53                   	push   %ebx
80107770:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107773:	0f 20 d3             	mov    %cr2,%ebx
80107776:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80107779:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010777c:	83 c4 10             	add    $0x10,%esp
8010777f:	5b                   	pop    %ebx
80107780:	5d                   	pop    %ebp
80107781:	c3                   	ret    

80107782 <lcr3>:

static inline void
lcr3(uint val) 
{
80107782:	55                   	push   %ebp
80107783:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107785:	8b 45 08             	mov    0x8(%ebp),%eax
80107788:	0f 22 d8             	mov    %eax,%cr3
}
8010778b:	5d                   	pop    %ebp
8010778c:	c3                   	ret    

8010778d <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010778d:	55                   	push   %ebp
8010778e:	89 e5                	mov    %esp,%ebp
80107790:	8b 45 08             	mov    0x8(%ebp),%eax
80107793:	05 00 00 00 80       	add    $0x80000000,%eax
80107798:	5d                   	pop    %ebp
80107799:	c3                   	ret    

8010779a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010779a:	55                   	push   %ebp
8010779b:	89 e5                	mov    %esp,%ebp
8010779d:	8b 45 08             	mov    0x8(%ebp),%eax
801077a0:	05 00 00 00 80       	add    $0x80000000,%eax
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    

801077a7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077a7:	55                   	push   %ebp
801077a8:	89 e5                	mov    %esp,%ebp
801077aa:	53                   	push   %ebx
801077ab:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801077ae:	e8 9c b6 ff ff       	call   80102e4f <cpunum>
801077b3:	89 c2                	mov    %eax,%edx
801077b5:	89 d0                	mov    %edx,%eax
801077b7:	d1 e0                	shl    %eax
801077b9:	01 d0                	add    %edx,%eax
801077bb:	c1 e0 04             	shl    $0x4,%eax
801077be:	29 d0                	sub    %edx,%eax
801077c0:	c1 e0 02             	shl    $0x2,%eax
801077c3:	05 40 09 11 80       	add    $0x80110940,%eax
801077c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077ce:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077d7:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077e0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801077e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077e7:	8a 50 7d             	mov    0x7d(%eax),%dl
801077ea:	83 e2 f0             	and    $0xfffffff0,%edx
801077ed:	83 ca 0a             	or     $0xa,%edx
801077f0:	88 50 7d             	mov    %dl,0x7d(%eax)
801077f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077f6:	8a 50 7d             	mov    0x7d(%eax),%dl
801077f9:	83 ca 10             	or     $0x10,%edx
801077fc:	88 50 7d             	mov    %dl,0x7d(%eax)
801077ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107802:	8a 50 7d             	mov    0x7d(%eax),%dl
80107805:	83 e2 9f             	and    $0xffffff9f,%edx
80107808:	88 50 7d             	mov    %dl,0x7d(%eax)
8010780b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010780e:	8a 50 7d             	mov    0x7d(%eax),%dl
80107811:	83 ca 80             	or     $0xffffff80,%edx
80107814:	88 50 7d             	mov    %dl,0x7d(%eax)
80107817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010781a:	8a 50 7e             	mov    0x7e(%eax),%dl
8010781d:	83 ca 0f             	or     $0xf,%edx
80107820:	88 50 7e             	mov    %dl,0x7e(%eax)
80107823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107826:	8a 50 7e             	mov    0x7e(%eax),%dl
80107829:	83 e2 ef             	and    $0xffffffef,%edx
8010782c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010782f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107832:	8a 50 7e             	mov    0x7e(%eax),%dl
80107835:	83 e2 df             	and    $0xffffffdf,%edx
80107838:	88 50 7e             	mov    %dl,0x7e(%eax)
8010783b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010783e:	8a 50 7e             	mov    0x7e(%eax),%dl
80107841:	83 ca 40             	or     $0x40,%edx
80107844:	88 50 7e             	mov    %dl,0x7e(%eax)
80107847:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010784a:	8a 50 7e             	mov    0x7e(%eax),%dl
8010784d:	83 ca 80             	or     $0xffffff80,%edx
80107850:	88 50 7e             	mov    %dl,0x7e(%eax)
80107853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107856:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010785a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010785d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107864:	ff ff 
80107866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107869:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107870:	00 00 
80107872:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107875:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010787c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010787f:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107885:	83 e2 f0             	and    $0xfffffff0,%edx
80107888:	83 ca 02             	or     $0x2,%edx
8010788b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107894:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010789a:	83 ca 10             	or     $0x10,%edx
8010789d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078a6:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801078ac:	83 e2 9f             	and    $0xffffff9f,%edx
801078af:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078b8:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801078be:	83 ca 80             	or     $0xffffff80,%edx
801078c1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ca:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801078d0:	83 ca 0f             	or     $0xf,%edx
801078d3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078dc:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801078e2:	83 e2 ef             	and    $0xffffffef,%edx
801078e5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ee:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801078f4:	83 e2 df             	and    $0xffffffdf,%edx
801078f7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107900:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107906:	83 ca 40             	or     $0x40,%edx
80107909:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010790f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107912:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107918:	83 ca 80             	or     $0xffffff80,%edx
8010791b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107924:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010792b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010792e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107935:	ff ff 
80107937:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010793a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107941:	00 00 
80107943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107946:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010794d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107950:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107956:	83 e2 f0             	and    $0xfffffff0,%edx
80107959:	83 ca 0a             	or     $0xa,%edx
8010795c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107962:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107965:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010796b:	83 ca 10             	or     $0x10,%edx
8010796e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107977:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010797d:	83 ca 60             	or     $0x60,%edx
80107980:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107989:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010798f:	83 ca 80             	or     $0xffffff80,%edx
80107992:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107998:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010799b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801079a1:	83 ca 0f             	or     $0xf,%edx
801079a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ad:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801079b3:	83 e2 ef             	and    $0xffffffef,%edx
801079b6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079bf:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801079c5:	83 e2 df             	and    $0xffffffdf,%edx
801079c8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079d1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801079d7:	83 ca 40             	or     $0x40,%edx
801079da:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079e3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801079e9:	83 ca 80             	or     $0xffffff80,%edx
801079ec:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079f5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ff:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107a06:	ff ff 
80107a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a0b:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a12:	00 00 
80107a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a17:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a21:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107a27:	83 e2 f0             	and    $0xfffffff0,%edx
80107a2a:	83 ca 02             	or     $0x2,%edx
80107a2d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a36:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107a3c:	83 ca 10             	or     $0x10,%edx
80107a3f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a48:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107a4e:	83 ca 60             	or     $0x60,%edx
80107a51:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a5a:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107a60:	83 ca 80             	or     $0xffffff80,%edx
80107a63:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a6c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107a72:	83 ca 0f             	or     $0xf,%edx
80107a75:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a7e:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107a84:	83 e2 ef             	and    $0xffffffef,%edx
80107a87:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a90:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107a96:	83 e2 df             	and    $0xffffffdf,%edx
80107a99:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aa2:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107aa8:	83 ca 40             	or     $0x40,%edx
80107aab:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ab4:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107aba:	83 ca 80             	or     $0xffffff80,%edx
80107abd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ac6:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ad0:	05 b4 00 00 00       	add    $0xb4,%eax
80107ad5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ad8:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107ade:	c1 ea 10             	shr    $0x10,%edx
80107ae1:	88 d1                	mov    %dl,%cl
80107ae3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ae6:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107aec:	c1 ea 18             	shr    $0x18,%edx
80107aef:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80107af2:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
80107af9:	00 00 
80107afb:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80107afe:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80107b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b08:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b11:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107b17:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b1a:	83 c9 02             	or     $0x2,%ecx
80107b1d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b26:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107b2c:	83 c9 10             	or     $0x10,%ecx
80107b2f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b38:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107b3e:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b41:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b4a:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107b50:	83 c9 80             	or     $0xffffff80,%ecx
80107b53:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b5c:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107b62:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b65:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b6e:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107b74:	83 e1 ef             	and    $0xffffffef,%ecx
80107b77:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b80:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107b86:	83 e1 df             	and    $0xffffffdf,%ecx
80107b89:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b92:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107b98:	83 c9 40             	or     $0x40,%ecx
80107b9b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ba4:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107baa:	83 c9 80             	or     $0xffffff80,%ecx
80107bad:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bb6:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bbf:	83 c0 70             	add    $0x70,%eax
80107bc2:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107bc9:	00 
80107bca:	89 04 24             	mov    %eax,(%esp)
80107bcd:	e8 4a fb ff ff       	call   8010771c <lgdt>
  loadgs(SEG_KCPU << 3);
80107bd2:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107bd9:	e8 7a fb ff ff       	call   80107758 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be1:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107be7:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107bee:	00 00 00 00 

  //3.4
  int i;
  initlock(&counterStruct.lock, "init_counter_lock"); // lock in counter struct
80107bf2:	c7 44 24 04 34 92 10 	movl   $0x80109234,0x4(%esp)
80107bf9:	80 
80107bfa:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80107c01:	e8 a0 d3 ff ff       	call   80104fa6 <initlock>

  for(i = 0; i < allPhysPageSize; i++) // init all array to zero pages 
80107c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c0d:	eb 14                	jmp    80107c23 <seginit+0x47c>
      counterStruct.pageCounter[i] = 0;
80107c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c12:	83 c0 0c             	add    $0xc,%eax
80107c15:	c7 04 85 24 37 11 80 	movl   $0x0,-0x7feec8dc(,%eax,4)
80107c1c:	00 00 00 00 

  //3.4
  int i;
  initlock(&counterStruct.lock, "init_counter_lock"); // lock in counter struct

  for(i = 0; i < allPhysPageSize; i++) // init all array to zero pages 
80107c20:	ff 45 f4             	incl   -0xc(%ebp)
80107c23:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107c28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107c2b:	7c e2                	jl     80107c0f <seginit+0x468>
      counterStruct.pageCounter[i] = 0;
}
80107c2d:	83 c4 24             	add    $0x24,%esp
80107c30:	5b                   	pop    %ebx
80107c31:	5d                   	pop    %ebp
80107c32:	c3                   	ret    

80107c33 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c33:	55                   	push   %ebp
80107c34:	89 e5                	mov    %esp,%ebp
80107c36:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c3c:	c1 e8 16             	shr    $0x16,%eax
80107c3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c46:	8b 45 08             	mov    0x8(%ebp),%eax
80107c49:	01 d0                	add    %edx,%eax
80107c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c51:	8b 00                	mov    (%eax),%eax
80107c53:	83 e0 01             	and    $0x1,%eax
80107c56:	85 c0                	test   %eax,%eax
80107c58:	74 17                	je     80107c71 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c5d:	8b 00                	mov    (%eax),%eax
80107c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c64:	89 04 24             	mov    %eax,(%esp)
80107c67:	e8 2e fb ff ff       	call   8010779a <p2v>
80107c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c6f:	eb 4b                	jmp    80107cbc <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c75:	74 0e                	je     80107c85 <walkpgdir+0x52>
80107c77:	e8 4b ae ff ff       	call   80102ac7 <kalloc>
80107c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c83:	75 07                	jne    80107c8c <walkpgdir+0x59>
      return 0;
80107c85:	b8 00 00 00 00       	mov    $0x0,%eax
80107c8a:	eb 47                	jmp    80107cd3 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c8c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c93:	00 
80107c94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c9b:	00 
80107c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9f:	89 04 24             	mov    %eax,(%esp)
80107ca2:	e8 73 d5 ff ff       	call   8010521a <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107caa:	89 04 24             	mov    %eax,(%esp)
80107cad:	e8 db fa ff ff       	call   8010778d <v2p>
80107cb2:	89 c2                	mov    %eax,%edx
80107cb4:	83 ca 07             	or     $0x7,%edx
80107cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cba:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cbf:	c1 e8 0c             	shr    $0xc,%eax
80107cc2:	25 ff 03 00 00       	and    $0x3ff,%eax
80107cc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd1:	01 d0                	add    %edx,%eax
}
80107cd3:	c9                   	leave  
80107cd4:	c3                   	ret    

80107cd5 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107cd5:	55                   	push   %ebp
80107cd6:	89 e5                	mov    %esp,%ebp
80107cd8:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ce9:	8b 45 10             	mov    0x10(%ebp),%eax
80107cec:	01 d0                	add    %edx,%eax
80107cee:	48                   	dec    %eax
80107cef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cf7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107cfe:	00 
80107cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d02:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d06:	8b 45 08             	mov    0x8(%ebp),%eax
80107d09:	89 04 24             	mov    %eax,(%esp)
80107d0c:	e8 22 ff ff ff       	call   80107c33 <walkpgdir>
80107d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d18:	75 07                	jne    80107d21 <mappages+0x4c>
      return -1;
80107d1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d1f:	eb 46                	jmp    80107d67 <mappages+0x92>
    if(*pte & PTE_P)
80107d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d24:	8b 00                	mov    (%eax),%eax
80107d26:	83 e0 01             	and    $0x1,%eax
80107d29:	85 c0                	test   %eax,%eax
80107d2b:	74 0c                	je     80107d39 <mappages+0x64>
      panic("remap");
80107d2d:	c7 04 24 46 92 10 80 	movl   $0x80109246,(%esp)
80107d34:	e8 fd 87 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
80107d39:	8b 45 18             	mov    0x18(%ebp),%eax
80107d3c:	0b 45 14             	or     0x14(%ebp),%eax
80107d3f:	89 c2                	mov    %eax,%edx
80107d41:	83 ca 01             	or     $0x1,%edx
80107d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d47:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d4f:	74 10                	je     80107d61 <mappages+0x8c>
      break;
    a += PGSIZE;
80107d51:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d58:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d5f:	eb 96                	jmp    80107cf7 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107d61:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d67:	c9                   	leave  
80107d68:	c3                   	ret    

80107d69 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80107d69:	55                   	push   %ebp
80107d6a:	89 e5                	mov    %esp,%ebp
80107d6c:	53                   	push   %ebx
80107d6d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d70:	e8 52 ad ff ff       	call   80102ac7 <kalloc>
80107d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d7c:	75 0a                	jne    80107d88 <setupkvm+0x1f>
    return 0;
80107d7e:	b8 00 00 00 00       	mov    $0x0,%eax
80107d83:	e9 98 00 00 00       	jmp    80107e20 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107d88:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d8f:	00 
80107d90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d97:	00 
80107d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9b:	89 04 24             	mov    %eax,(%esp)
80107d9e:	e8 77 d4 ff ff       	call   8010521a <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107da3:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107daa:	e8 eb f9 ff ff       	call   8010779a <p2v>
80107daf:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107db4:	76 0c                	jbe    80107dc2 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107db6:	c7 04 24 4c 92 10 80 	movl   $0x8010924c,(%esp)
80107dbd:	e8 74 87 ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dc2:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80107dc9:	eb 49                	jmp    80107e14 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107dce:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107dd4:	8b 50 04             	mov    0x4(%eax),%edx
80107dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dda:	8b 58 08             	mov    0x8(%eax),%ebx
80107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de0:	8b 40 04             	mov    0x4(%eax),%eax
80107de3:	29 c3                	sub    %eax,%ebx
80107de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de8:	8b 00                	mov    (%eax),%eax
80107dea:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107dee:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107df2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107df6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dfd:	89 04 24             	mov    %eax,(%esp)
80107e00:	e8 d0 fe ff ff       	call   80107cd5 <mappages>
80107e05:	85 c0                	test   %eax,%eax
80107e07:	79 07                	jns    80107e10 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107e09:	b8 00 00 00 00       	mov    $0x0,%eax
80107e0e:	eb 10                	jmp    80107e20 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e10:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107e14:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80107e1b:	72 ae                	jb     80107dcb <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107e20:	83 c4 34             	add    $0x34,%esp
80107e23:	5b                   	pop    %ebx
80107e24:	5d                   	pop    %ebp
80107e25:	c3                   	ret    

80107e26 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107e26:	55                   	push   %ebp
80107e27:	89 e5                	mov    %esp,%ebp
80107e29:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e2c:	e8 38 ff ff ff       	call   80107d69 <setupkvm>
80107e31:	a3 18 37 11 80       	mov    %eax,0x80113718
  switchkvm();
80107e36:	e8 02 00 00 00       	call   80107e3d <switchkvm>
}
80107e3b:	c9                   	leave  
80107e3c:	c3                   	ret    

80107e3d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e3d:	55                   	push   %ebp
80107e3e:	89 e5                	mov    %esp,%ebp
80107e40:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e43:	a1 18 37 11 80       	mov    0x80113718,%eax
80107e48:	89 04 24             	mov    %eax,(%esp)
80107e4b:	e8 3d f9 ff ff       	call   8010778d <v2p>
80107e50:	89 04 24             	mov    %eax,(%esp)
80107e53:	e8 2a f9 ff ff       	call   80107782 <lcr3>
}
80107e58:	c9                   	leave  
80107e59:	c3                   	ret    

80107e5a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e5a:	55                   	push   %ebp
80107e5b:	89 e5                	mov    %esp,%ebp
80107e5d:	53                   	push   %ebx
80107e5e:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107e61:	e8 b3 d2 ff ff       	call   80105119 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e6c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e73:	83 c2 08             	add    $0x8,%edx
80107e76:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107e7d:	83 c1 08             	add    $0x8,%ecx
80107e80:	c1 e9 10             	shr    $0x10,%ecx
80107e83:	88 cb                	mov    %cl,%bl
80107e85:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107e8c:	83 c1 08             	add    $0x8,%ecx
80107e8f:	c1 e9 18             	shr    $0x18,%ecx
80107e92:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107e99:	67 00 
80107e9b:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107ea2:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107ea8:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107eae:	83 e2 f0             	and    $0xfffffff0,%edx
80107eb1:	83 ca 09             	or     $0x9,%edx
80107eb4:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107eba:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107ec0:	83 ca 10             	or     $0x10,%edx
80107ec3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ec9:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107ecf:	83 e2 9f             	and    $0xffffff9f,%edx
80107ed2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ed8:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107ede:	83 ca 80             	or     $0xffffff80,%edx
80107ee1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ee7:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107eed:	83 e2 f0             	and    $0xfffffff0,%edx
80107ef0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ef6:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107efc:	83 e2 ef             	and    $0xffffffef,%edx
80107eff:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f05:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107f0b:	83 e2 df             	and    $0xffffffdf,%edx
80107f0e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f14:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107f1a:	83 ca 40             	or     $0x40,%edx
80107f1d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f23:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107f29:	83 e2 7f             	and    $0x7f,%edx
80107f2c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107f32:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f3e:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107f44:	83 e2 ef             	and    $0xffffffef,%edx
80107f47:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f4d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f53:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f59:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f5f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107f66:	8b 52 08             	mov    0x8(%edx),%edx
80107f69:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f6f:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f72:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107f79:	e8 c5 f7 ff ff       	call   80107743 <ltr>
  if(p->pgdir == 0)
80107f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f81:	8b 40 04             	mov    0x4(%eax),%eax
80107f84:	85 c0                	test   %eax,%eax
80107f86:	75 0c                	jne    80107f94 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80107f88:	c7 04 24 5d 92 10 80 	movl   $0x8010925d,(%esp)
80107f8f:	e8 a2 85 ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107f94:	8b 45 08             	mov    0x8(%ebp),%eax
80107f97:	8b 40 04             	mov    0x4(%eax),%eax
80107f9a:	89 04 24             	mov    %eax,(%esp)
80107f9d:	e8 eb f7 ff ff       	call   8010778d <v2p>
80107fa2:	89 04 24             	mov    %eax,(%esp)
80107fa5:	e8 d8 f7 ff ff       	call   80107782 <lcr3>
  popcli();
80107faa:	e8 b0 d1 ff ff       	call   8010515f <popcli>
}
80107faf:	83 c4 14             	add    $0x14,%esp
80107fb2:	5b                   	pop    %ebx
80107fb3:	5d                   	pop    %ebp
80107fb4:	c3                   	ret    

80107fb5 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107fb5:	55                   	push   %ebp
80107fb6:	89 e5                	mov    %esp,%ebp
80107fb8:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107fbb:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107fc2:	76 0c                	jbe    80107fd0 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107fc4:	c7 04 24 71 92 10 80 	movl   $0x80109271,(%esp)
80107fcb:	e8 66 85 ff ff       	call   80100536 <panic>
  mem = kalloc();
80107fd0:	e8 f2 aa ff ff       	call   80102ac7 <kalloc>
80107fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107fd8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fdf:	00 
80107fe0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fe7:	00 
80107fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107feb:	89 04 24             	mov    %eax,(%esp)
80107fee:	e8 27 d2 ff ff       	call   8010521a <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff6:	89 04 24             	mov    %eax,(%esp)
80107ff9:	e8 8f f7 ff ff       	call   8010778d <v2p>
80107ffe:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108005:	00 
80108006:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010800a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108011:	00 
80108012:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108019:	00 
8010801a:	8b 45 08             	mov    0x8(%ebp),%eax
8010801d:	89 04 24             	mov    %eax,(%esp)
80108020:	e8 b0 fc ff ff       	call   80107cd5 <mappages>
  memmove(mem, init, sz);
80108025:	8b 45 10             	mov    0x10(%ebp),%eax
80108028:	89 44 24 08          	mov    %eax,0x8(%esp)
8010802c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010802f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108036:	89 04 24             	mov    %eax,(%esp)
80108039:	e8 a8 d2 ff ff       	call   801052e6 <memmove>
}
8010803e:	c9                   	leave  
8010803f:	c3                   	ret    

80108040 <loaduvm>:
// and the pages from addr to addr+sz must already be mapped.
// 3.3
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, 
        uint sz,uint flagWriteELF) //
{
80108040:	55                   	push   %ebp
80108041:	89 e5                	mov    %esp,%ebp
80108043:	53                   	push   %ebx
80108044:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  for(i = 0; i < sz; i += PGSIZE){
80108047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010804e:	e9 e0 00 00 00       	jmp    80108133 <loaduvm+0xf3>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108056:	8b 55 0c             	mov    0xc(%ebp),%edx
80108059:	01 d0                	add    %edx,%eax
8010805b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108062:	00 
80108063:	89 44 24 04          	mov    %eax,0x4(%esp)
80108067:	8b 45 08             	mov    0x8(%ebp),%eax
8010806a:	89 04 24             	mov    %eax,(%esp)
8010806d:	e8 c1 fb ff ff       	call   80107c33 <walkpgdir>
80108072:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108075:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108079:	75 0c                	jne    80108087 <loaduvm+0x47>
      panic("loaduvm: address should exist");
8010807b:	c7 04 24 8b 92 10 80 	movl   $0x8010928b,(%esp)
80108082:	e8 af 84 ff ff       	call   80100536 <panic>
    
    if( flagWriteELF == 0 ) { //3.3
80108087:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
8010808b:	75 11                	jne    8010809e <loaduvm+0x5e>
    	*pte = *pte & ~PTE_W ; 
8010808d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108090:	8b 00                	mov    (%eax),%eax
80108092:	89 c2                	mov    %eax,%edx
80108094:	83 e2 fd             	and    $0xfffffffd,%edx
80108097:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010809a:	89 10                	mov    %edx,(%eax)
8010809c:	eb 0f                	jmp    801080ad <loaduvm+0x6d>
    } else {
        *pte = *pte | PTE_W ;
8010809e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080a1:	8b 00                	mov    (%eax),%eax
801080a3:	89 c2                	mov    %eax,%edx
801080a5:	83 ca 02             	or     $0x2,%edx
801080a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080ab:	89 10                	mov    %edx,(%eax)
    }

    pa = PTE_ADDR(*pte) + ((uint)addr % PGSIZE);
801080ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080b0:	8b 00                	mov    (%eax),%eax
801080b2:	89 c2                	mov    %eax,%edx
801080b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801080ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801080bd:	25 ff 0f 00 00       	and    $0xfff,%eax
801080c2:	01 d0                	add    %edx,%eax
801080c4:	89 45 e8             	mov    %eax,-0x18(%ebp)

    if(sz - i < PGSIZE)
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	8b 55 18             	mov    0x18(%ebp),%edx
801080cd:	89 d1                	mov    %edx,%ecx
801080cf:	29 c1                	sub    %eax,%ecx
801080d1:	89 c8                	mov    %ecx,%eax
801080d3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801080d8:	77 11                	ja     801080eb <loaduvm+0xab>
      n = sz - i;
801080da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dd:	8b 55 18             	mov    0x18(%ebp),%edx
801080e0:	89 d1                	mov    %edx,%ecx
801080e2:	29 c1                	sub    %eax,%ecx
801080e4:	89 c8                	mov    %ecx,%eax
801080e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080e9:	eb 07                	jmp    801080f2 <loaduvm+0xb2>
    else
      n = PGSIZE;
801080eb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801080f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f5:	8b 55 14             	mov    0x14(%ebp),%edx
801080f8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801080fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080fe:	89 04 24             	mov    %eax,(%esp)
80108101:	e8 94 f6 ff ff       	call   8010779a <p2v>
80108106:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108109:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010810d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108111:	89 44 24 04          	mov    %eax,0x4(%esp)
80108115:	8b 45 10             	mov    0x10(%ebp),%eax
80108118:	89 04 24             	mov    %eax,(%esp)
8010811b:	e8 31 9c ff ff       	call   80101d51 <readi>
80108120:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108123:	74 07                	je     8010812c <loaduvm+0xec>
      return -1;
80108125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010812a:	eb 18                	jmp    80108144 <loaduvm+0x104>
        uint sz,uint flagWriteELF) //
{
  uint i, pa, n;
  pte_t *pte;

  for(i = 0; i < sz; i += PGSIZE){
8010812c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108136:	3b 45 18             	cmp    0x18(%ebp),%eax
80108139:	0f 82 14 ff ff ff    	jb     80108053 <loaduvm+0x13>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010813f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108144:	83 c4 24             	add    $0x24,%esp
80108147:	5b                   	pop    %ebx
80108148:	5d                   	pop    %ebp
80108149:	c3                   	ret    

8010814a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010814a:	55                   	push   %ebp
8010814b:	89 e5                	mov    %esp,%ebp
8010814d:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108150:	8b 45 10             	mov    0x10(%ebp),%eax
80108153:	85 c0                	test   %eax,%eax
80108155:	79 0a                	jns    80108161 <allocuvm+0x17>
    return 0;
80108157:	b8 00 00 00 00       	mov    $0x0,%eax
8010815c:	e9 c1 00 00 00       	jmp    80108222 <allocuvm+0xd8>
  if(newsz < oldsz)
80108161:	8b 45 10             	mov    0x10(%ebp),%eax
80108164:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108167:	73 08                	jae    80108171 <allocuvm+0x27>
    return oldsz;
80108169:	8b 45 0c             	mov    0xc(%ebp),%eax
8010816c:	e9 b1 00 00 00       	jmp    80108222 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108171:	8b 45 0c             	mov    0xc(%ebp),%eax
80108174:	05 ff 0f 00 00       	add    $0xfff,%eax
80108179:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010817e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108181:	e9 8d 00 00 00       	jmp    80108213 <allocuvm+0xc9>
    mem = kalloc();
80108186:	e8 3c a9 ff ff       	call   80102ac7 <kalloc>
8010818b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010818e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108192:	75 2c                	jne    801081c0 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108194:	c7 04 24 a9 92 10 80 	movl   $0x801092a9,(%esp)
8010819b:	e8 01 82 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801081a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801081a7:	8b 45 10             	mov    0x10(%ebp),%eax
801081aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801081ae:	8b 45 08             	mov    0x8(%ebp),%eax
801081b1:	89 04 24             	mov    %eax,(%esp)
801081b4:	e8 6b 00 00 00       	call   80108224 <deallocuvm>
      return 0;
801081b9:	b8 00 00 00 00       	mov    $0x0,%eax
801081be:	eb 62                	jmp    80108222 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801081c0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081c7:	00 
801081c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081cf:	00 
801081d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081d3:	89 04 24             	mov    %eax,(%esp)
801081d6:	e8 3f d0 ff ff       	call   8010521a <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801081db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081de:	89 04 24             	mov    %eax,(%esp)
801081e1:	e8 a7 f5 ff ff       	call   8010778d <v2p>
801081e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081e9:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801081f0:	00 
801081f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801081f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081fc:	00 
801081fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80108201:	8b 45 08             	mov    0x8(%ebp),%eax
80108204:	89 04 24             	mov    %eax,(%esp)
80108207:	e8 c9 fa ff ff       	call   80107cd5 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010820c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108216:	3b 45 10             	cmp    0x10(%ebp),%eax
80108219:	0f 82 67 ff ff ff    	jb     80108186 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010821f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108222:	c9                   	leave  
80108223:	c3                   	ret    

80108224 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108224:	55                   	push   %ebp
80108225:	89 e5                	mov    %esp,%ebp
80108227:	83 ec 38             	sub    $0x38,%esp
    pte_t *pte;
    uint a, pa;

    if(newsz >= oldsz)
8010822a:	8b 45 10             	mov    0x10(%ebp),%eax
8010822d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108230:	72 08                	jb     8010823a <deallocuvm+0x16>
        return oldsz;
80108232:	8b 45 0c             	mov    0xc(%ebp),%eax
80108235:	e9 b2 01 00 00       	jmp    801083ec <deallocuvm+0x1c8>

    a = PGROUNDUP(newsz);
8010823a:	8b 45 10             	mov    0x10(%ebp),%eax
8010823d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108247:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; a  < oldsz; a += PGSIZE){
8010824a:	e9 8e 01 00 00       	jmp    801083dd <deallocuvm+0x1b9>
        pte = walkpgdir(pgdir, (char*)a, 0);
8010824f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108252:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108259:	00 
8010825a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010825e:	8b 45 08             	mov    0x8(%ebp),%eax
80108261:	89 04 24             	mov    %eax,(%esp)
80108264:	e8 ca f9 ff ff       	call   80107c33 <walkpgdir>
80108269:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(!pte)
8010826c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108270:	75 0c                	jne    8010827e <deallocuvm+0x5a>
            a += (NPTENTRIES - 1) * PGSIZE;
80108272:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108279:	e9 58 01 00 00       	jmp    801083d6 <deallocuvm+0x1b2>

        else if((*pte & PTE_P) != 0) {
8010827e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108281:	8b 00                	mov    (%eax),%eax
80108283:	83 e0 01             	and    $0x1,%eax
80108286:	85 c0                	test   %eax,%eax
80108288:	0f 84 48 01 00 00    	je     801083d6 <deallocuvm+0x1b2>
            pa = PTE_ADDR(*pte);
8010828e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108291:	8b 00                	mov    (%eax),%eax
80108293:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108298:	89 45 ec             	mov    %eax,-0x14(%ebp)

            acquire(&counterStruct.lock);
8010829b:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801082a2:	e8 20 cd ff ff       	call   80104fc7 <acquire>

            if(counterStruct.pageCounter[pa/PGSIZE] == 1) {
801082a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082aa:	c1 e8 0c             	shr    $0xc,%eax
801082ad:	83 c0 0c             	add    $0xc,%eax
801082b0:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
801082b7:	83 f8 01             	cmp    $0x1,%eax
801082ba:	75 59                	jne    80108315 <deallocuvm+0xf1>
                counterStruct.pageCounter[pa/PGSIZE] = 0;
801082bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082bf:	c1 e8 0c             	shr    $0xc,%eax
801082c2:	83 c0 0c             	add    $0xc,%eax
801082c5:	c7 04 85 24 37 11 80 	movl   $0x0,-0x7feec8dc(,%eax,4)
801082cc:	00 00 00 00 
                release(&counterStruct.lock);
801082d0:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801082d7:	e8 4d cd ff ff       	call   80105029 <release>
                if(pa == 0)
801082dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082e0:	75 0c                	jne    801082ee <deallocuvm+0xca>
                    panic("kfree");
801082e2:	c7 04 24 c1 92 10 80 	movl   $0x801092c1,(%esp)
801082e9:	e8 48 82 ff ff       	call   80100536 <panic>
                char *v = p2v(pa);
801082ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082f1:	89 04 24             	mov    %eax,(%esp)
801082f4:	e8 a1 f4 ff ff       	call   8010779a <p2v>
801082f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(v);
801082fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082ff:	89 04 24             	mov    %eax,(%esp)
80108302:	e8 27 a7 ff ff       	call   80102a2e <kfree>
                *pte = 0;
80108307:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010830a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108310:	e9 c1 00 00 00       	jmp    801083d6 <deallocuvm+0x1b2>
            } else {
                if(counterStruct.pageCounter[pa/PGSIZE] == 0) {
80108315:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108318:	c1 e8 0c             	shr    $0xc,%eax
8010831b:	83 c0 0c             	add    $0xc,%eax
8010831e:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108325:	85 c0                	test   %eax,%eax
80108327:	75 45                	jne    8010836e <deallocuvm+0x14a>
                    if(pa == 0)
80108329:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010832d:	75 0c                	jne    8010833b <deallocuvm+0x117>
                        panic("kfree");
8010832f:	c7 04 24 c1 92 10 80 	movl   $0x801092c1,(%esp)
80108336:	e8 fb 81 ff ff       	call   80100536 <panic>
                    char *v = p2v(pa);
8010833b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010833e:	89 04 24             	mov    %eax,(%esp)
80108341:	e8 54 f4 ff ff       	call   8010779a <p2v>
80108346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    kfree(v);
80108349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010834c:	89 04 24             	mov    %eax,(%esp)
8010834f:	e8 da a6 ff ff       	call   80102a2e <kfree>
                    *pte = 0;
80108354:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    release(&counterStruct.lock);
8010835d:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108364:	e8 c0 cc ff ff       	call   80105029 <release>
                    return newsz;
80108369:	8b 45 10             	mov    0x10(%ebp),%eax
8010836c:	eb 7e                	jmp    801083ec <deallocuvm+0x1c8>
                } else {
                    counterStruct.pageCounter[pa/PGSIZE]--;
8010836e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108371:	c1 e8 0c             	shr    $0xc,%eax
80108374:	8d 50 0c             	lea    0xc(%eax),%edx
80108377:	8b 14 95 24 37 11 80 	mov    -0x7feec8dc(,%edx,4),%edx
8010837e:	4a                   	dec    %edx
8010837f:	83 c0 0c             	add    $0xc,%eax
80108382:	89 14 85 24 37 11 80 	mov    %edx,-0x7feec8dc(,%eax,4)
                    if(counterStruct.pageCounter[pa/PGSIZE] == 1) {
80108389:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010838c:	c1 e8 0c             	shr    $0xc,%eax
8010838f:	83 c0 0c             	add    $0xc,%eax
80108392:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108399:	83 f8 01             	cmp    $0x1,%eax
8010839c:	75 2c                	jne    801083ca <deallocuvm+0x1a6>
                        if((*pte & PTE_SHARED) != 0) {
8010839e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083a1:	8b 00                	mov    (%eax),%eax
801083a3:	25 00 02 00 00       	and    $0x200,%eax
801083a8:	85 c0                	test   %eax,%eax
801083aa:	74 1e                	je     801083ca <deallocuvm+0x1a6>
                            *pte = *pte & ~PTE_SHARED;
801083ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083af:	8b 00                	mov    (%eax),%eax
801083b1:	89 c2                	mov    %eax,%edx
801083b3:	80 e6 fd             	and    $0xfd,%dh
801083b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083b9:	89 10                	mov    %edx,(%eax)
                            *pte = *pte | PTE_W ;
801083bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083be:	8b 00                	mov    (%eax),%eax
801083c0:	89 c2                	mov    %eax,%edx
801083c2:	83 ca 02             	or     $0x2,%edx
801083c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c8:	89 10                	mov    %edx,(%eax)
                        }
                    }
                }
                    release(&counterStruct.lock);
801083ca:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801083d1:	e8 53 cc ff ff       	call   80105029 <release>

    if(newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
    for(; a  < oldsz; a += PGSIZE){
801083d6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083e3:	0f 82 66 fe ff ff    	jb     8010824f <deallocuvm+0x2b>
                kfree(v);
                *pte = 0;
            }*/
        }
    }
    return newsz;
801083e9:	8b 45 10             	mov    0x10(%ebp),%eax
}
801083ec:	c9                   	leave  
801083ed:	c3                   	ret    

801083ee <removePageFromCounter>:

// 3.4 get pa in remove from page counter struct
// True - only onw page in counter
int 
removePageFromCounter(uint pa,pte_t* pte)
{
801083ee:	55                   	push   %ebp
801083ef:	89 e5                	mov    %esp,%ebp
801083f1:	83 ec 28             	sub    $0x28,%esp
    acquire(&counterStruct.lock);
801083f4:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801083fb:	e8 c7 cb ff ff       	call   80104fc7 <acquire>

    int pageIndex = pa / PGSIZE;
80108400:	8b 45 08             	mov    0x8(%ebp),%eax
80108403:	c1 e8 0c             	shr    $0xc,%eax
80108406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *pce = &(counterStruct.pageCounter[pageIndex]);
80108409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840c:	83 c0 0c             	add    $0xc,%eax
8010840f:	c1 e0 02             	shl    $0x2,%eax
80108412:	05 20 37 11 80       	add    $0x80113720,%eax
80108417:	83 c0 04             	add    $0x4,%eax
8010841a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    switch((*pce)) {
8010841d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108420:	8b 00                	mov    (%eax),%eax
80108422:	83 f8 01             	cmp    $0x1,%eax
80108425:	74 15                	je     8010843c <removePageFromCounter+0x4e>
80108427:	83 f8 02             	cmp    $0x2,%eax
8010842a:	74 2c                	je     80108458 <removePageFromCounter+0x6a>
8010842c:	85 c0                	test   %eax,%eax
8010842e:	75 77                	jne    801084a7 <removePageFromCounter+0xb9>

        case 0: 
            panic("Error: removePageFromCounter(); counter entry is 0"); 
80108430:	c7 04 24 c8 92 10 80 	movl   $0x801092c8,(%esp)
80108437:	e8 fa 80 ff ff       	call   80100536 <panic>
            release(&counterStruct.lock);
            break;
        
        case 1:  // will kfree page for shizel!
            (*pce) = 0;
8010843c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010843f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            release(&counterStruct.lock);
80108445:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010844c:	e8 d8 cb ff ff       	call   80105029 <release>
            return 1;
80108451:	b8 01 00 00 00       	mov    $0x1,%eax
80108456:	eb 6d                	jmp    801084c5 <removePageFromCounter+0xd7>
            break;

        case 2: 
            (*pce) = (*pce) - 1;
80108458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010845b:	8b 00                	mov    (%eax),%eax
8010845d:	8d 50 ff             	lea    -0x1(%eax),%edx
80108460:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108463:	89 10                	mov    %edx,(%eax)
            if((*pte & PTE_SHARED) != 0) {
80108465:	8b 45 0c             	mov    0xc(%ebp),%eax
80108468:	8b 00                	mov    (%eax),%eax
8010846a:	25 00 02 00 00       	and    $0x200,%eax
8010846f:	85 c0                	test   %eax,%eax
80108471:	74 21                	je     80108494 <removePageFromCounter+0xa6>
                (*pte) = (*pte) & PTE_SHARED; //TODO
80108473:	8b 45 0c             	mov    0xc(%ebp),%eax
80108476:	8b 00                	mov    (%eax),%eax
80108478:	89 c2                	mov    %eax,%edx
8010847a:	81 e2 00 02 00 00    	and    $0x200,%edx
80108480:	8b 45 0c             	mov    0xc(%ebp),%eax
80108483:	89 10                	mov    %edx,(%eax)
                (*pte) = (*pte) | PTE_W;
80108485:	8b 45 0c             	mov    0xc(%ebp),%eax
80108488:	8b 00                	mov    (%eax),%eax
8010848a:	89 c2                	mov    %eax,%edx
8010848c:	83 ca 02             	or     $0x2,%edx
8010848f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108492:	89 10                	mov    %edx,(%eax)
            }
            release(&counterStruct.lock);
80108494:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010849b:	e8 89 cb ff ff       	call   80105029 <release>
            return 0;
801084a0:	b8 00 00 00 00       	mov    $0x0,%eax
801084a5:	eb 1e                	jmp    801084c5 <removePageFromCounter+0xd7>
            break;

        default:
            (*pce) = (*pce) - 1;
801084a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084aa:	8b 00                	mov    (%eax),%eax
801084ac:	8d 50 ff             	lea    -0x1(%eax),%edx
801084af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084b2:	89 10                	mov    %edx,(%eax)
            release(&counterStruct.lock);
801084b4:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801084bb:	e8 69 cb ff ff       	call   80105029 <release>
            return 0;
801084c0:	b8 00 00 00 00       	mov    $0x0,%eax
            break;
    }
    return 0;
}
801084c5:	c9                   	leave  
801084c6:	c3                   	ret    

801084c7 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801084c7:	55                   	push   %ebp
801084c8:	89 e5                	mov    %esp,%ebp
801084ca:	83 ec 28             	sub    $0x28,%esp
    uint i;

    if(pgdir == 0)
801084cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801084d1:	75 0c                	jne    801084df <freevm+0x18>
        panic("freevm: no pgdir");
801084d3:	c7 04 24 fb 92 10 80 	movl   $0x801092fb,(%esp)
801084da:	e8 57 80 ff ff       	call   80100536 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801084df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084e6:	00 
801084e7:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801084ee:	80 
801084ef:	8b 45 08             	mov    0x8(%ebp),%eax
801084f2:	89 04 24             	mov    %eax,(%esp)
801084f5:	e8 2a fd ff ff       	call   80108224 <deallocuvm>
    for(i = 0; i < NPDENTRIES; i++){
801084fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108501:	eb 47                	jmp    8010854a <freevm+0x83>
        if(pgdir[i] & PTE_P){
80108503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010850d:	8b 45 08             	mov    0x8(%ebp),%eax
80108510:	01 d0                	add    %edx,%eax
80108512:	8b 00                	mov    (%eax),%eax
80108514:	83 e0 01             	and    $0x1,%eax
80108517:	85 c0                	test   %eax,%eax
80108519:	74 2c                	je     80108547 <freevm+0x80>
            char * v = p2v(PTE_ADDR(pgdir[i]));
8010851b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108525:	8b 45 08             	mov    0x8(%ebp),%eax
80108528:	01 d0                	add    %edx,%eax
8010852a:	8b 00                	mov    (%eax),%eax
8010852c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108531:	89 04 24             	mov    %eax,(%esp)
80108534:	e8 61 f2 ff ff       	call   8010779a <p2v>
80108539:	89 45 f0             	mov    %eax,-0x10(%ebp)
            kfree(v);
8010853c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010853f:	89 04 24             	mov    %eax,(%esp)
80108542:	e8 e7 a4 ff ff       	call   80102a2e <kfree>
    uint i;

    if(pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for(i = 0; i < NPDENTRIES; i++){
80108547:	ff 45 f4             	incl   -0xc(%ebp)
8010854a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108551:	76 b0                	jbe    80108503 <freevm+0x3c>
        if(pgdir[i] & PTE_P){
            char * v = p2v(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char*)pgdir);
80108553:	8b 45 08             	mov    0x8(%ebp),%eax
80108556:	89 04 24             	mov    %eax,(%esp)
80108559:	e8 d0 a4 ff ff       	call   80102a2e <kfree>
}
8010855e:	c9                   	leave  
8010855f:	c3                   	ret    

80108560 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108560:	55                   	push   %ebp
80108561:	89 e5                	mov    %esp,%ebp
80108563:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108566:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010856d:	00 
8010856e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108571:	89 44 24 04          	mov    %eax,0x4(%esp)
80108575:	8b 45 08             	mov    0x8(%ebp),%eax
80108578:	89 04 24             	mov    %eax,(%esp)
8010857b:	e8 b3 f6 ff ff       	call   80107c33 <walkpgdir>
80108580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108587:	75 0c                	jne    80108595 <clearpteu+0x35>
    panic("clearpteu");
80108589:	c7 04 24 0c 93 10 80 	movl   $0x8010930c,(%esp)
80108590:	e8 a1 7f ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108598:	8b 00                	mov    (%eax),%eax
8010859a:	89 c2                	mov    %eax,%edx
8010859c:	83 e2 fb             	and    $0xfffffffb,%edx
8010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a2:	89 10                	mov    %edx,(%eax)
}
801085a4:	c9                   	leave  
801085a5:	c3                   	ret    

801085a6 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085a6:	55                   	push   %ebp
801085a7:	89 e5                	mov    %esp,%ebp
801085a9:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
801085ac:	e8 b8 f7 ff ff       	call   80107d69 <setupkvm>
801085b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085b8:	75 0a                	jne    801085c4 <copyuvm+0x1e>
    return 0;
801085ba:	b8 00 00 00 00       	mov    $0x0,%eax
801085bf:	e9 38 01 00 00       	jmp    801086fc <copyuvm+0x156>
  for(i = PGSIZE; i < sz; i += PGSIZE){
801085c4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
801085cb:	e9 07 01 00 00       	jmp    801086d7 <copyuvm+0x131>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801085d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085da:	00 
801085db:	89 44 24 04          	mov    %eax,0x4(%esp)
801085df:	8b 45 08             	mov    0x8(%ebp),%eax
801085e2:	89 04 24             	mov    %eax,(%esp)
801085e5:	e8 49 f6 ff ff       	call   80107c33 <walkpgdir>
801085ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801085f1:	75 0c                	jne    801085ff <copyuvm+0x59>
      panic("copyuvm: pte should exist");
801085f3:	c7 04 24 16 93 10 80 	movl   $0x80109316,(%esp)
801085fa:	e8 37 7f ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
801085ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108602:	8b 00                	mov    (%eax),%eax
80108604:	83 e0 01             	and    $0x1,%eax
80108607:	85 c0                	test   %eax,%eax
80108609:	75 0c                	jne    80108617 <copyuvm+0x71>
      panic("copyuvm: page not present");
8010860b:	c7 04 24 30 93 10 80 	movl   $0x80109330,(%esp)
80108612:	e8 1f 7f ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108617:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010861a:	8b 00                	mov    (%eax),%eax
8010861c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108621:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108624:	e8 9e a4 ff ff       	call   80102ac7 <kalloc>
80108629:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010862c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108630:	0f 84 b2 00 00 00    	je     801086e8 <copyuvm+0x142>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108636:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108639:	89 04 24             	mov    %eax,(%esp)
8010863c:	e8 59 f1 ff ff       	call   8010779a <p2v>
80108641:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108648:	00 
80108649:	89 44 24 04          	mov    %eax,0x4(%esp)
8010864d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108650:	89 04 24             	mov    %eax,(%esp)
80108653:	e8 8e cc ff ff       	call   801052e6 <memmove>
   //3.3 
    if( (*pte & PTE_W )!= 0 ) {
80108658:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010865b:	8b 00                	mov    (%eax),%eax
8010865d:	83 e0 02             	and    $0x2,%eax
80108660:	85 c0                	test   %eax,%eax
80108662:	74 37                	je     8010869b <copyuvm+0xf5>
    	if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108667:	89 04 24             	mov    %eax,(%esp)
8010866a:	e8 1e f1 ff ff       	call   8010778d <v2p>
8010866f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108672:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108679:	00 
8010867a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010867e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108685:	00 
80108686:	89 54 24 04          	mov    %edx,0x4(%esp)
8010868a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010868d:	89 04 24             	mov    %eax,(%esp)
80108690:	e8 40 f6 ff ff       	call   80107cd5 <mappages>
80108695:	85 c0                	test   %eax,%eax
80108697:	79 37                	jns    801086d0 <copyuvm+0x12a>
    		goto bad;
80108699:	eb 51                	jmp    801086ec <copyuvm+0x146>
    } else {
        if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_U) < 0)
8010869b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010869e:	89 04 24             	mov    %eax,(%esp)
801086a1:	e8 e7 f0 ff ff       	call   8010778d <v2p>
801086a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801086a9:	c7 44 24 10 04 00 00 	movl   $0x4,0x10(%esp)
801086b0:	00 
801086b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801086b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086bc:	00 
801086bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801086c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086c4:	89 04 24             	mov    %eax,(%esp)
801086c7:	e8 09 f6 ff ff       	call   80107cd5 <mappages>
801086cc:	85 c0                	test   %eax,%eax
801086ce:	78 1b                	js     801086eb <copyuvm+0x145>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
801086d0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086da:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086dd:	0f 82 ed fe ff ff    	jb     801085d0 <copyuvm+0x2a>
    } else {
        if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_U) < 0)
        	goto bad;
    }
  }
  return d;
801086e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e6:	eb 14                	jmp    801086fc <copyuvm+0x156>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801086e8:	90                   	nop
801086e9:	eb 01                	jmp    801086ec <copyuvm+0x146>
    if( (*pte & PTE_W )!= 0 ) {
    	if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
    		goto bad;
    } else {
        if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_U) < 0)
        	goto bad;
801086eb:	90                   	nop
    }
  }
  return d;

bad:
  freevm(d);
801086ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ef:	89 04 24             	mov    %eax,(%esp)
801086f2:	e8 d0 fd ff ff       	call   801084c7 <freevm>
  return 0;
801086f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086fc:	c9                   	leave  
801086fd:	c3                   	ret    

801086fe <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801086fe:	55                   	push   %ebp
801086ff:	89 e5                	mov    %esp,%ebp
80108701:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108704:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010870b:	00 
8010870c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010870f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108713:	8b 45 08             	mov    0x8(%ebp),%eax
80108716:	89 04 24             	mov    %eax,(%esp)
80108719:	e8 15 f5 ff ff       	call   80107c33 <walkpgdir>
8010871e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108724:	8b 00                	mov    (%eax),%eax
80108726:	83 e0 01             	and    $0x1,%eax
80108729:	85 c0                	test   %eax,%eax
8010872b:	75 07                	jne    80108734 <uva2ka+0x36>
    return 0;
8010872d:	b8 00 00 00 00       	mov    $0x0,%eax
80108732:	eb 25                	jmp    80108759 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108737:	8b 00                	mov    (%eax),%eax
80108739:	83 e0 04             	and    $0x4,%eax
8010873c:	85 c0                	test   %eax,%eax
8010873e:	75 07                	jne    80108747 <uva2ka+0x49>
    return 0;
80108740:	b8 00 00 00 00       	mov    $0x0,%eax
80108745:	eb 12                	jmp    80108759 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874a:	8b 00                	mov    (%eax),%eax
8010874c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108751:	89 04 24             	mov    %eax,(%esp)
80108754:	e8 41 f0 ff ff       	call   8010779a <p2v>
}
80108759:	c9                   	leave  
8010875a:	c3                   	ret    

8010875b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010875b:	55                   	push   %ebp
8010875c:	89 e5                	mov    %esp,%ebp
8010875e:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108761:	8b 45 10             	mov    0x10(%ebp),%eax
80108764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108767:	e9 89 00 00 00       	jmp    801087f5 <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
8010876c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010876f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108774:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108777:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010877a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010877e:	8b 45 08             	mov    0x8(%ebp),%eax
80108781:	89 04 24             	mov    %eax,(%esp)
80108784:	e8 75 ff ff ff       	call   801086fe <uva2ka>
80108789:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010878c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108790:	75 07                	jne    80108799 <copyout+0x3e>
      return -1;
80108792:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108797:	eb 6b                	jmp    80108804 <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108799:	8b 45 0c             	mov    0xc(%ebp),%eax
8010879c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010879f:	89 d1                	mov    %edx,%ecx
801087a1:	29 c1                	sub    %eax,%ecx
801087a3:	89 c8                	mov    %ecx,%eax
801087a5:	05 00 10 00 00       	add    $0x1000,%eax
801087aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801087ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087b0:	3b 45 14             	cmp    0x14(%ebp),%eax
801087b3:	76 06                	jbe    801087bb <copyout+0x60>
      n = len;
801087b5:	8b 45 14             	mov    0x14(%ebp),%eax
801087b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801087bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087be:	8b 55 0c             	mov    0xc(%ebp),%edx
801087c1:	29 c2                	sub    %eax,%edx
801087c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801087c6:	01 c2                	add    %eax,%edx
801087c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801087cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801087d6:	89 14 24             	mov    %edx,(%esp)
801087d9:	e8 08 cb ff ff       	call   801052e6 <memmove>
    len -= n;
801087de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087e1:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801087e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087e7:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801087ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087ed:	05 00 10 00 00       	add    $0x1000,%eax
801087f2:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801087f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801087f9:	0f 85 6d ff ff ff    	jne    8010876c <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801087ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108804:	c9                   	leave  
80108805:	c3                   	ret    

80108806 <copyuvm_cow>:

// 3.4
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80108806:	55                   	push   %ebp
80108807:	89 e5                	mov    %esp,%ebp
80108809:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;

  if((d = setupkvm()) == 0)
8010880c:	e8 58 f5 ff ff       	call   80107d69 <setupkvm>
80108811:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108814:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108818:	75 0a                	jne    80108824 <copyuvm_cow+0x1e>
    return 0;
8010881a:	b8 00 00 00 00       	mov    $0x0,%eax
8010881f:	e9 89 01 00 00       	jmp    801089ad <copyuvm_cow+0x1a7>

  for(i = PGSIZE; i < sz; i += PGSIZE) {
80108824:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
8010882b:	e9 52 01 00 00       	jmp    80108982 <copyuvm_cow+0x17c>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108833:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010883a:	00 
8010883b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010883f:	8b 45 08             	mov    0x8(%ebp),%eax
80108842:	89 04 24             	mov    %eax,(%esp)
80108845:	e8 e9 f3 ff ff       	call   80107c33 <walkpgdir>
8010884a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010884d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108851:	75 0c                	jne    8010885f <copyuvm_cow+0x59>
      panic("cowcopyuvm: pte should exist");
80108853:	c7 04 24 4a 93 10 80 	movl   $0x8010934a,(%esp)
8010885a:	e8 d7 7c ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
8010885f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108862:	8b 00                	mov    (%eax),%eax
80108864:	83 e0 01             	and    $0x1,%eax
80108867:	85 c0                	test   %eax,%eax
80108869:	75 0c                	jne    80108877 <copyuvm_cow+0x71>
      panic("cowcopyuvm: page not present");
8010886b:	c7 04 24 67 93 10 80 	movl   $0x80109367,(%esp)
80108872:	e8 bf 7c ff ff       	call   80100536 <panic>

    pa = PTE_ADDR(*pte);
80108877:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010887a:	8b 00                	mov    (%eax),%eax
8010887c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108881:	89 45 e8             	mov    %eax,-0x18(%ebp)
    *pte = *pte | PTE_PCOUNT; // 3.4 indicate page belong to counter 
80108884:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108887:	8b 00                	mov    (%eax),%eax
80108889:	89 c2                	mov    %eax,%edx
8010888b:	80 ce 04             	or     $0x4,%dh
8010888e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108891:	89 10                	mov    %edx,(%eax)

	if((*pte & PTE_W) || (*pte & PTE_SHARED)) {
80108893:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108896:	8b 00                	mov    (%eax),%eax
80108898:	83 e0 02             	and    $0x2,%eax
8010889b:	85 c0                	test   %eax,%eax
8010889d:	75 0e                	jne    801088ad <copyuvm_cow+0xa7>
8010889f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a2:	8b 00                	mov    (%eax),%eax
801088a4:	25 00 02 00 00       	and    $0x200,%eax
801088a9:	85 c0                	test   %eax,%eax
801088ab:	74 51                	je     801088fe <copyuvm_cow+0xf8>
		if( mappages(d, (void*)i, PGSIZE, pa, PTE_SHARED | PTE_U) < 0 ) // insure page to be read only
801088ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b0:	c7 44 24 10 04 02 00 	movl   $0x204,0x10(%esp)
801088b7:	00 
801088b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801088bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
801088bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088c6:	00 
801088c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801088cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ce:	89 04 24             	mov    %eax,(%esp)
801088d1:	e8 ff f3 ff ff       	call   80107cd5 <mappages>
801088d6:	85 c0                	test   %eax,%eax
801088d8:	0f 88 bb 00 00 00    	js     80108999 <copyuvm_cow+0x193>
			goto bad;
		*pte = *pte & ~PTE_W ; 
801088de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088e1:	8b 00                	mov    (%eax),%eax
801088e3:	89 c2                	mov    %eax,%edx
801088e5:	83 e2 fd             	and    $0xfffffffd,%edx
801088e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088eb:	89 10                	mov    %edx,(%eax)
        *pte = *pte | PTE_SHARED;
801088ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088f0:	8b 00                	mov    (%eax),%eax
801088f2:	89 c2                	mov    %eax,%edx
801088f4:	80 ce 02             	or     $0x2,%dh
801088f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088fa:	89 10                	mov    %edx,(%eax)
801088fc:	eb 2d                	jmp    8010892b <copyuvm_cow+0x125>
        

    } else { // page is already read only
		if(mappages(d, (void*)i, PGSIZE, pa , PTE_RONLY | PTE_U) < 0)
801088fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108901:	c7 44 24 10 04 08 00 	movl   $0x804,0x10(%esp)
80108908:	00 
80108909:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010890c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108910:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108917:	00 
80108918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010891c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010891f:	89 04 24             	mov    %eax,(%esp)
80108922:	e8 ae f3 ff ff       	call   80107cd5 <mappages>
80108927:	85 c0                	test   %eax,%eax
80108929:	78 71                	js     8010899c <copyuvm_cow+0x196>
			goto bad;
    }
        //////////////////////////////////
        // updating counter struct with new pointed page
        acquire(&counterStruct.lock);
8010892b:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108932:	e8 90 c6 ff ff       	call   80104fc7 <acquire>
        int *pce = &(counterStruct.pageCounter[pa/PGSIZE]); // Page Counter Enry \m/
80108937:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010893a:	c1 e8 0c             	shr    $0xc,%eax
8010893d:	83 c0 0c             	add    $0xc,%eax
80108940:	c1 e0 02             	shl    $0x2,%eax
80108943:	05 20 37 11 80       	add    $0x80113720,%eax
80108948:	83 c0 04             	add    $0x4,%eax
8010894b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

            if( (*pce) == 0) {
8010894e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108951:	8b 00                	mov    (%eax),%eax
80108953:	85 c0                	test   %eax,%eax
80108955:	75 0b                	jne    80108962 <copyuvm_cow+0x15c>
                *pce = 2; // first Initialize father and son pointing to page
80108957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010895a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
80108960:	eb 0d                	jmp    8010896f <copyuvm_cow+0x169>
            } else {
                (*pce) = (*pce) + 1;
80108962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108965:	8b 00                	mov    (%eax),%eax
80108967:	8d 50 01             	lea    0x1(%eax),%edx
8010896a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010896d:	89 10                	mov    %edx,(%eax)
            }
        release(&counterStruct.lock);
8010896f:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108976:	e8 ae c6 ff ff       	call   80105029 <release>
  uint pa, i;

  if((d = setupkvm()) == 0)
    return 0;

  for(i = PGSIZE; i < sz; i += PGSIZE) {
8010897b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108985:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108988:	0f 82 a2 fe ff ff    	jb     80108830 <copyuvm_cow+0x2a>
            }
        release(&counterStruct.lock);
        ///////////////////////////////////
        
  }
	asm("movl %cr3,%eax");
8010898e:	0f 20 d8             	mov    %cr3,%eax
	asm("movl %eax,%cr3");
80108991:	0f 22 d8             	mov    %eax,%cr3
    return d;
80108994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108997:	eb 14                	jmp    801089ad <copyuvm_cow+0x1a7>
    pa = PTE_ADDR(*pte);
    *pte = *pte | PTE_PCOUNT; // 3.4 indicate page belong to counter 

	if((*pte & PTE_W) || (*pte & PTE_SHARED)) {
		if( mappages(d, (void*)i, PGSIZE, pa, PTE_SHARED | PTE_U) < 0 ) // insure page to be read only
			goto bad;
80108999:	90                   	nop
8010899a:	eb 01                	jmp    8010899d <copyuvm_cow+0x197>
        *pte = *pte | PTE_SHARED;
        

    } else { // page is already read only
		if(mappages(d, (void*)i, PGSIZE, pa , PTE_RONLY | PTE_U) < 0)
			goto bad;
8010899c:	90                   	nop
	asm("movl %cr3,%eax");
	asm("movl %eax,%cr3");
    return d;

bad:
  freevm(d);
8010899d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089a0:	89 04 24             	mov    %eax,(%esp)
801089a3:	e8 1f fb ff ff       	call   801084c7 <freevm>
  return 0;
801089a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089ad:	c9                   	leave  
801089ae:	c3                   	ret    

801089af <handler_pgflt>:

int
handler_pgflt() 
{
801089af:	55                   	push   %ebp
801089b0:	89 e5                	mov    %esp,%ebp
801089b2:	83 ec 38             	sub    $0x38,%esp
	pte_t *pte ;
	char* mem;
	uint pa;
	void* fault_addr = (void*)rcr2();
801089b5:	e8 b2 ed ff ff       	call   8010776c <rcr2>
801089ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if((pte = walkpgdir(proc->pgdir, (void *) fault_addr , 0)) == 0)
801089bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801089c3:	8b 40 04             	mov    0x4(%eax),%eax
801089c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089cd:	00 
801089ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801089d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801089d5:	89 04 24             	mov    %eax,(%esp)
801089d8:	e8 56 f2 ff ff       	call   80107c33 <walkpgdir>
801089dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089e4:	75 0c                	jne    801089f2 <handler_pgflt+0x43>
    	panic("pageFaultHandler: pte should exist");
801089e6:	c7 04 24 84 93 10 80 	movl   $0x80109384,(%esp)
801089ed:	e8 44 7b ff ff       	call   80100536 <panic>

    if(( (*pte & PTE_RONLY) != 0) ) {
801089f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f5:	8b 00                	mov    (%eax),%eax
801089f7:	25 00 08 00 00       	and    $0x800,%eax
801089fc:	85 c0                	test   %eax,%eax
801089fe:	74 0c                	je     80108a0c <handler_pgflt+0x5d>
        panic("try to write to READ ONLY");
80108a00:	c7 04 24 a7 93 10 80 	movl   $0x801093a7,(%esp)
80108a07:	e8 2a 7b ff ff       	call   80100536 <panic>
        return 0;
    }

    if(((*pte & PTE_SHARED) != 0)) { 
80108a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a0f:	8b 00                	mov    (%eax),%eax
80108a11:	25 00 02 00 00       	and    $0x200,%eax
80108a16:	85 c0                	test   %eax,%eax
80108a18:	0f 84 cf 00 00 00    	je     80108aed <handler_pgflt+0x13e>

		pa = PTE_ADDR(*pte);
80108a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a21:	8b 00                	mov    (%eax),%eax
80108a23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a28:	89 45 ec             	mov    %eax,-0x14(%ebp)

        acquire(&counterStruct.lock);
80108a2b:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108a32:	e8 90 c5 ff ff       	call   80104fc7 <acquire>
        int *pce = &(counterStruct.pageCounter[pa/PGSIZE]);
80108a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a3a:	c1 e8 0c             	shr    $0xc,%eax
80108a3d:	83 c0 0c             	add    $0xc,%eax
80108a40:	c1 e0 02             	shl    $0x2,%eax
80108a43:	05 20 37 11 80       	add    $0x80113720,%eax
80108a48:	83 c0 04             	add    $0x4,%eax
80108a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)

        (*pce) = (*pce) - 1;
80108a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a51:	8b 00                	mov    (%eax),%eax
80108a53:	8d 50 ff             	lea    -0x1(%eax),%edx
80108a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a59:	89 10                	mov    %edx,(%eax)
        if((*pce) == 1) {
80108a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a5e:	8b 00                	mov    (%eax),%eax
80108a60:	83 f8 01             	cmp    $0x1,%eax
80108a63:	75 1e                	jne    80108a83 <handler_pgflt+0xd4>
            *pte = *pte & ~PTE_SHARED;
80108a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a68:	8b 00                	mov    (%eax),%eax
80108a6a:	89 c2                	mov    %eax,%edx
80108a6c:	80 e6 fd             	and    $0xfd,%dh
80108a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a72:	89 10                	mov    %edx,(%eax)
            *pte = *pte | PTE_W;
80108a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a77:	8b 00                	mov    (%eax),%eax
80108a79:	89 c2                	mov    %eax,%edx
80108a7b:	83 ca 02             	or     $0x2,%edx
80108a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a81:	89 10                	mov    %edx,(%eax)
        } 
        release(&counterStruct.lock);
80108a83:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80108a8a:	e8 9a c5 ff ff       	call   80105029 <release>

        if((mem = kalloc()) == 0)
80108a8f:	e8 33 a0 ff ff       	call   80102ac7 <kalloc>
80108a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108a97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108a9b:	75 0c                	jne    80108aa9 <handler_pgflt+0xfa>
            panic("pageFaultHandler: can't kalloc mem\n");
80108a9d:	c7 04 24 c4 93 10 80 	movl   $0x801093c4,(%esp)
80108aa4:	e8 8d 7a ff ff       	call   80100536 <panic>

		memmove(mem, (char*)p2v(pa), PGSIZE);
80108aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aac:	89 04 24             	mov    %eax,(%esp)
80108aaf:	e8 e6 ec ff ff       	call   8010779a <p2v>
80108ab4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108abb:	00 
80108abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ac3:	89 04 24             	mov    %eax,(%esp)
80108ac6:	e8 1b c8 ff ff       	call   801052e6 <memmove>

		*pte = v2p(mem) | PTE_W | PTE_P | PTE_U; 
80108acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ace:	89 04 24             	mov    %eax,(%esp)
80108ad1:	e8 b7 ec ff ff       	call   8010778d <v2p>
80108ad6:	89 c2                	mov    %eax,%edx
80108ad8:	83 ca 07             	or     $0x7,%edx
80108adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ade:	89 10                	mov    %edx,(%eax)

		asm("movl %cr3,%eax");
80108ae0:	0f 20 d8             	mov    %cr3,%eax
		asm("movl %eax,%cr3");
80108ae3:	0f 22 d8             	mov    %eax,%cr3

		return 1;
80108ae6:	b8 01 00 00 00       	mov    $0x1,%eax
80108aeb:	eb 05                	jmp    80108af2 <handler_pgflt+0x143>

    } else {
    	return 0;
80108aed:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80108af2:	c9                   	leave  
80108af3:	c3                   	ret    

80108af4 <printCounter>:

void
printCounter() 
{
80108af4:	55                   	push   %ebp
80108af5:	89 e5                	mov    %esp,%ebp
80108af7:	83 ec 28             	sub    $0x28,%esp
    int i; 
    for(i = 0 ; i < allPhysPageSize ; i++) {
80108afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b01:	eb 3b                	jmp    80108b3e <printCounter+0x4a>
        if(counterStruct.pageCounter[i] == 0)
80108b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b06:	83 c0 0c             	add    $0xc,%eax
80108b09:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108b10:	85 c0                	test   %eax,%eax
80108b12:	74 26                	je     80108b3a <printCounter+0x46>
            continue;
        cprintf("pageCounter[%d] = %d\n",i,counterStruct.pageCounter[i]);
80108b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b17:	83 c0 0c             	add    $0xc,%eax
80108b1a:	8b 04 85 24 37 11 80 	mov    -0x7feec8dc(,%eax,4),%eax
80108b21:	89 44 24 08          	mov    %eax,0x8(%esp)
80108b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b28:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b2c:	c7 04 24 e8 93 10 80 	movl   $0x801093e8,(%esp)
80108b33:	e8 69 78 ff ff       	call   801003a1 <cprintf>
80108b38:	eb 01                	jmp    80108b3b <printCounter+0x47>
printCounter() 
{
    int i; 
    for(i = 0 ; i < allPhysPageSize ; i++) {
        if(counterStruct.pageCounter[i] == 0)
            continue;
80108b3a:	90                   	nop

void
printCounter() 
{
    int i; 
    for(i = 0 ; i < allPhysPageSize ; i++) {
80108b3b:	ff 45 f4             	incl   -0xc(%ebp)
80108b3e:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80108b43:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80108b46:	7c bb                	jl     80108b03 <printCounter+0xf>
        if(counterStruct.pageCounter[i] == 0)
            continue;
        cprintf("pageCounter[%d] = %d\n",i,counterStruct.pageCounter[i]);
    }
}
80108b48:	c9                   	leave  
80108b49:	c3                   	ret    
