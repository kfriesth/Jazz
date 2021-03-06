\name{get_block_as_string}
\alias{get_block_as_string}

\title{
Get a data block as an R string
}

\description{
Converts a data block into an R string with an sprintf compatible format string controlling
the precise output format.
}

\usage{
get_block_as_string(source, block_key, fmt, host = .host.)
}

\arguments{
  \item{source}{
The Jazz source. Jazz persistence is organized in sources. All sources except 'sys' and 'www'
are user defined. Sources are 15 char long alphanumeric or underscore.
}
  \item{block_key}{
The key identifying the block. Keys are 15 alphanumeric or underscore characters. They can
be user defined or created by new_key(). Also, meshes use block keys internally.
}
  \item{fmt}{
The (sprintf() compatible) format to convert the data as strings. Note: Newlines are NOT
added automatically, use \\n to add a newline where necessary.
}
  \item{host}{
(Optional) the name of the jazz server host (including the port). Usually set just once via
set_jazz_host().
}
}

\value{
The output string or raises an error on failure.
}

\examples{
\dontrun{
create_source('demo_types')

# Write a text file as a block.
txt <- c('Hi all,', '', 'This is a file.', '', 'bye,', 'me')
str <- paste(txt, collapse = '\n')
cat(str)

put_raw_block('demo_types', 'blk_1', str)

# The block is raw (not interpreted as data by the server) and can be converted to any raw type.
set_compatible_data_type('demo_types', 'blk_1', type_const[['BLOCKTYPE_RAW_MIME_TXT']])

# curl 127.0.0.1:8888//demo_types.blk_1 (or open in a in a browser)

get_block_attributes('demo_types', 'blk_1')

# The attribute flags is writable by the user.
put_block_flags('demo_types', 'blk_1', 123000444)

get_block_attributes('demo_types', 'blk_1')

# Unlike the previous block, this block is a data block.
put_R_block('demo_types', 'blk_2', 3:6)

# This trivial block can also be created by the server as..
create_block_seq('demo_types', 'blk_2', 3L, 6)

get_block_attributes('demo_types', 'blk_2')

# The block is interpreted as data by the server, it is an integer and can be converted to
any integer type.
set_compatible_data_type('demo_types', 'blk_2', type_const[['BLOCKTYPE_C_R_GRADE']])

get_block_attributes('demo_types', 'blk_2')

# This returns all the rows in a single string
get_block_as_string('demo_types', 'blk_2', '%d')

# With some help of R functions, the result of get_block_as_string() can be made integer again.
any(3:6 != as.integer(strsplit(get_block_as_string('demo_types', 'blk_2', '%d\\n'), '\n')[[1]]))

rs <- c('1', '2.7', '3.14')

# Creating strings into numeric data. (The parse(.., collapse = '\n') is automatic.)
put_strings_as_block('demo_types', 'blk_3', rs, type_const[['BLOCKTYPE_C_R_REAL']])

get_block_attributes('demo_types', 'blk_3')

any(as.numeric(rs) != get_R_block('demo_types', 'blk_3'))

delete_source('demo_types')
}
}
