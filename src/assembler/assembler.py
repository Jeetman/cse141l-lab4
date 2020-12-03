import argparse
import lut

def assembly_to_machine(line):
    """Converts a line of $NAME assembly code to 9-bit machine instruction"""

    opcode = '0000'

    # Grab the first 3 chars of the line, and use LUT to generate opcode
    inst_name= line[:3]
    # TODO: remove space here
    opcode = lut.LUT[inst_name] 

    # Store space-delimited elements of the instruction
    elements = line.split()

    # only the halt instruction has no operands
    if len(elements) == 1:
        return '111111111'

    # immediate instruction: use 5 bits of numerical constant
    if inst_name in lut.IMM:

        # Check that no registers are specified. Assumes base 10
        #if "$" not in elements[1]:
        immval = int(elements[1])
        tail = format(immval, '05b')
        return opcode + tail
    # register instruction: uses 4 bits of register + 0 bit on tail
    else:

        # Check that no immediate value is specified. Assumes base 10
        #if "$r" in elements[1]:
        regval = int(elements[1])
        tail = format(regval, '04b')
        return opcode + tail + '0'


def main():
    """ Drives the program. """

    parser = argparse.ArgumentParser(description='Convert $NAME assembly to' \
            + ' machine code.')
    parser.add_argument('file_in', metavar='in', type=str, help='name of input' \
            + ' file containing $NAME assembly code')
    parser.add_argument('file_out', metavar='outfile', type=str, help='name of'\
            + ' output file to write machine instructions')

    results = parser.parse_args()
    
    with open(results.file_in, 'r') as fi, open(results.file_out, 'w') as fo:
        lines = [line.rstrip() for line in fi]

        # TODO: determine whether or not to include newlines (currently we
        # don't)
        for inst in lines:
            fo.write(assembly_to_machine(inst))
            fo.write('\n')

        print(f'Wrote {len(lines)} instructions to {results.file_out}.\n')


if __name__ == "__main__":
    main()


