#!/usr/local/bin/perl
=pod

=head1 NAME 

get_NCBI_genome.pl

=head1 SYNOPSIS  
      perl bin/Perl/get_NCBI_genome.pl -a <accesion_id> -t <taxid> -s <species_taxid> -o <organism_name> -i <infraespecif_name> -r <[ all | major ]> --only_show --execute -f <fna|

#  Mostrar en pantalla el path para descargar un genoma a partir de su accesion_id:
      perl bin/Perl/get_NCBI_genome.pl -a GCF_001078055.1 --only_show
#  Descargar un genoma a partir de su nombre de organismo y cepa  y mostrarlo en pantalla
      perl bin/Perl/get_NCBI_genome.pl -o "Rufibacter" -i DG31D --only_show --execute
#  Mostrar en pantalla los genomas disponibles de humano a partir del taxid:
      perl bin/Perl/get_NCBI_genome.pl -t 9606 -r all --only_show
#  Mostrar la ayuda
      perl bin/Perl/get_NCBI_genome.pl -h
#  Descargar los genomas de Salmonella YU15:
      perl bin/Perl/get_NCBI_genome.pl -o "Salmonella" -i YU15 --execute --only_show
#################################33
      
=head2 PARAMETERS
Esto son los parametros de ejecusion del programa
perl /home/illumina/bin/Perl/get_NCBI_genome.pl -a <accesion_id> -t <taxid> -s <species_taxid> -o <organism_name> -i <infraespecif_name> -r <[ all | major ]> --only_show --execute -f <fna|

=head3 Search parameters
			-a|--accesion <accesion_id>	Busqueda por accesion_id (Ejemplo: -a GCF_000001215.4) 
            -t <taxid>			Busqueda por taxid (Ejemplo: -t 441960)
  			--species <species_taxid> 	Busqueda por specie_taxid ( Ejemplo: -s 1379910)
			-o|--organism <organism_name> 	Busqueda por nombre de Organismo	(-o "Homo" -o "Rufibacter DG31D")
			-i|--subespecie <infraespecif_name>  Busqueda por nombre de subespecie, (-i DG31D) de preferencia esta opcion debe ir acompañada de la opcion -o

=head3 output parameters
		--release <all | major > all:  regresa todos los resultados que cumplen las opciones de busqueda introducidas por el usuario
                                 major: regresa solo los resultados para organismos con Genoma Completo, que son genoma de referencia en su especie y 
                                            tienen una liberacion de tipo "Major" (Default: all).  
                                            Puede no regresar resultados si el organismo solicitado, todavía no esta completamente secuenciado              
  	  	--only_show  		Hace que este programa muestre los genomas a descargar o resultados obtenidos en pantalla
  	  	--no_show  			Hace que se deshabilite mostrar los genomas a descargar o resultados obtenidos en pantalla
  	  	--execute  			Ejecuta la descarga de los genomas.  
		-f|--file_type <file_type>  	[fna |  gff ]  Especifica el tipo de formato del archivo que se desea descargar. Default:  se descargan los dos. 
        --output_path <path>  	path de salida de los archivos.  Si no existe lo crea. Si no esta definido, toma el lugar donde estamos parados
=head3 others parameters
        -h|--help			Despliega esta ayuda
=head3 Notes
    Debe existir al menos un parametro de busqueda definido.
    Todos los parametros de salida, tienen un valor por default y por lo tanto no es obligatorio definir ninguno.
#####
=head DESCRIPTION
   Este programa verifica la fecha del archivo archivo   ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt  y si no es la de hoy, la descarga
   En este archivo busca el accesion_id, taxid, organism name o intraespecific name de interes.  
   
   Si la opcion --result all  es declarada,  se reportan todos los registros que cumplen con los parametros de entradas introducidos en el punto anterior
   si no,  solo se despliega la referencia(s) con  refse_category igual a "reference genome",  con un nivel de ensamblado de "Complete Genome"  y una liberacion tipo Major
        
   La opcion --only_show : despliga los resulados en pantalla
   La opcion -- execute  ejecuta via ftp la descarga de los genomas
   
   Si no se expecifica la opcion --file_type,  se descaga tanto el fna  como el gff     
   por default,  los genomas se descargan en el path X,  a menos que se indique lo contrario con la opcion:  --output_path
#
=head2 CREATE

1.Marzo.2016

=head1 AUTHOR
	 Veronica Jimenez Jacinto (email: vjimenez \@ ibt.unam.mx)
=head2  TODO

#           -a|--accesion <accesion_id>		(Ex: -a GCF_000001215.4) (column 1) --Un solo resultado esperado-- Es la unica condicion de busqueda
#           -t <taxid>				(-t 441960)                (column 6) --Puede haber muchos resultados--  
#  			-s|--species <species_taxid> 		(-s 1379910)       (Columna 7) -- Puede haber muchos resultados --
#			--organism|-o <organism_name> 		(-o "Homo sapiens" -o "Rufibacter sp. DG31D")   (Column 8)  -- Puede haber muchos resultados -- 
#			-i <infraespecif_name> 	(-i DG31D)                   (columna 9)	 -- Puede haber muchos resultados --
#           --release| -r <all | major >		default -r all    -- regresar todos los valor---
#                   Si la opcion "major"   esta definida, Solo regresa el path de aquel genoma que sea "genome reference" t este completamente secuenciado 
#                   con una liberacion de tipo "Major"
#					toma los siguientes pareametros por default:
#					 	refseq_category ~ "reference genome" (column 5)
#						assembly_level ~ "Complete Genome" (columna 12)
#				    	release_type ~ "Major"  (columna 13)
#  		  --only_show  hace que este programa muestre los genomas a descargar o resultados obtenidos en pantalla
#         --no_show    deshabilita imprimir a pantalla
#  		  --execute  ejecuta la descarga de los genomas.  
#         --file_type|-f <file_type>  [fna |  gff ]   Si no se especifica ninguno,  se descargan los dos. 
#         --output_path <path>  path de salida de los archivos
#####
#   perl bin/Perl/get_NCBI_genome.pl -t 10090 --execute --only_show -f gff
#   perl bin/Perl/get_NCBI_genome.pl -o "musculus" --execute --only_show -f gff 
#   perl bin/Perl/get_NCBI_genome.pl -o "Salmonella" -i 33676 --execute --only_show
#   perl bin/Perl/get_NCBI_genome.pl -o "Salmonella" -i YU15 --execute --only_show
#   
############
=cut
use strict;
use Getopt::Long;
use Pod::Usage;

my ($accesionid, $taxid, $specie, $organism, $subspecie, $release, $only_show, $execute,$file_type,$output_path,$help, $no_show);
$no_show=0;
my $ok= GetOptions( 'a|accesion:s'   => \$accesionid,
            't|taxid:s'     => \$taxid, 
            'h|help'    => \$help,
            's|species:s' => \$specie,
            'o|organism:s'=> \$organism,
            'i:s'=> \$subspecie,
            'r|result:s'=> \$release,
            'only_show'   => \$only_show,
            'no_show'  => \$no_show,
            'execute' => \$execute,
            'f|file_type:s' => \$file_type,
            'output_path:s' => \$output_path);

#pod2usage(2) if $help || !$ok;
help() if $help || !$ok;

$only_show=!$no_show;
if( !$accesionid && !$taxid && !$specie && !$organism){
    print "accesionid: -$accesionid-\n";
	print "Debe especificar al menos un valor de busqueda (accesionid, taxid, specie_taxid u organims) \n";
	print "Ejecute:\n";
	print "perl get_NCBI_genome.pl -h\n";
	pod2usage(2);
	help();
}

if( !$output_path ){
  chomp($output_path =`pwd`);
}else{
  if( !( -d $output_path ) ){
  	   print "El subdirectorio de salida -$output_path-no existe y sera creado...\n";
       system("mkdir -p $output_path");
  }
}

my $summary_refseq="$output_path/assembly_summary_refseq.txt";
#my $current_date = `date +"%Y/%b/%d"`;
my $current_date = `date +"%Y-%m-%d"`;
chomp($current_date);
my $file_info=`ls --full-time $summary_refseq`; 
#print "file info: $file_info\n";
my @file_date=split(/\s/,$file_info);
if($file_info !~ /ls: cannot/){
	print "Fecha Actual: ${current_date}\nFecha del archivo assembly_summary_refseq.txt: $file_date[5]\n";
}	
if ( $current_date ne $file_date[5])
	{
   		print "Descargamos la version mas actulizada del compendio de genomas:\n";
  # system("wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt -O /share/Illumina/Genomes/NCBI/assembly_summary_refseq.txt");
   		system("wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt -O $summary_refseq");
	}
busqueda();


sub busqueda(){
open(IN, "$summary_refseq")|| die "No se pudo abrir el archivo $summary_refseq\n";
my @summary=<IN>;
my $busca;

my @res;
if(lc($release) eq "major"){
      @res=grep("reference genome",grep(/Complete Genome/,grep(/major/,@summary)));
      $busca .="reference genome, Complete Genome major, ";
      if($#res < 0){
          print " No existe ninguna version con genoma de referencia, con genoma completo y liberacion majo.  Sugerencia.  Ejecute con --result all";
          exit;
      }
    }
if($accesionid){
  if(@res){
         @res=grep(/$accesionid/,@res);
  }else{
         @res=grep(/$accesionid/,@summary);
  }
  $busca .= "Accesion Id: -$accesionid-";
}else{
	if($taxid){
	  if(@res){
	 	   @res=grep(/$taxid/,@res);
	  }else{
	   	   @res=grep(/$taxid/,@summary);
	   }	   
	   $busca .= "taxid: -$taxid-";
    }
    if($specie){
    	if(@res){
	 	   @res=grep(/$specie/,@res);
	    }else{
	       @res=grep(/$specie/,@summary);  
	    }
	    $busca .= "$specie: -$specie-";	
    }
    if($organism){
    	if(@res){
    		@res=grep(/$organism/,@res);
    	}else{
    	    @res=grep(/$organism/,@summary);  
    	}
    	$busca .= "organism: -$organism-";
    }
    if($subspecie){
    	if(@res){
    		@res=grep(/$subspecie/,@res);
    	}else{
    	    @res=grep(/$subspecie/,@summary);  
    	}
    	$busca .= "subspecie: -$subspecie-";
    }
  }
#print "buscando: $busca\n";
#print "elementos encontrados: $#res\n";
resultados($busca,@res);
print "Resultados en $output_path\n"
}  




sub resultados{
my $cadena=shift;
my @res=@_;
if($only_show){
  print "AccesionId\tcategory\ttaxid\tspecies_taxid\tOrganism name\tsubspecie\tassembly level\trelease\tpath\n"; 
}
my $cuenta=0;
my $bandera;
for my $re (@res){
     #print $re;
     $bandera=1;
     chomp($re);
     my @field=split("\t",$re);
     if(!$accesionid){
    	 if($taxid  && ($field[5] ne $taxid)){
    #	    print "-$taxid-  ne $field[5] \n";
     		$bandera=0;
     	}elsif($specie  && ($field[6] ne $specie)){
     		$bandera=0;
     	}elsif($organism  && ($field[7] !~ /$organism/)){
     	    print "$organism !~ /$field[7]/\n";
     		$bandera=0;	
        }elsif($subspecie  && ($field[8] !~ /$subspecie/)){
     		$bandera=0;
        }
     }
   if($bandera){
     my $command="cd $output_path \n";
     $field[0]=~s/\[|\(|\#|\)|\]/_/g;
     $field[15]=~s/\[|\(|\#|\)|\]/_/g;
     my $file_name1="${field[0]}_${field[15]}_genomic.fna.gz";
     my $file_name2="${field[0]}_${field[15]}_genomic.gff.gz";
     my $file_name3="${field[0]}_${field[15]}_rna.fna.gz";
     if($only_show){
        print "$field[0]\t$field[3]\t$field[4]\t$field[5]\t$field[6]\t$field[7]\t$field[11]\t$field[12]\t$field[19]/${file_name1}\n"
     }
     if($execute){
       my ($salida1,$salida2,$salida3);
#       if($output_path){
 #         $salida1=" -O ${file_name1}";
  #        $salida2=" -O ${file_name2}";
   #       $salida3=" -O ${file_name3}";
    #   }
       if(!$file_type){
       		$command.="wget $field[19]/${file_name1} ${salida1}\nwget $field[19]/${file_name2} ${salida2}\nwget $field[19]/${file_name3} ${salida3}";
      }elsif($file_type eq 'fna'){
           $command.="wget $field[19]/${file_name1} ${salida1}";
      }elsif($file_type eq 'gff'){ 
      	   $command.="wget $field[19]/${file_name2} ${salida2}";	
      }
      print "$command\n";
      system($command);
    }
    $cuenta++;
   } 
  }
  if(!$cuenta){
      print  "Ningun registro cumple para la busqueda: $cadena\n";
  }  
}
#Procedimiento de la ayuda del programa
sub help{
#### display full help message #####
        open HELP, "| more";
        print HELP <<End_short_help;
NOMBRE

get_NCBI_genome.pl

SYNOPSIS  
      perl bin/Perl/get_NCBI_genome.pl -a <accesion_id> -t <taxid> -s <species_taxid> -o <organism_name> -i <infraespecif_name> -r <[ all | major ]> --only_show --execute -f <fna|

EJEMPLOS DE USO
#  Mostrar en pantalla el path para descargar un genoma a partir de su accesion_id:
      perl bin/Perl/get_NCBI_genome.pl -a GCF_001078055.1 --only_show
#  Descargar un genoma a partir de su nombre de organismo y cepa  y mostrarlo en pantalla
      perl bin/Perl/get_NCBI_genome.pl -o "Rufibacter" -i DG31D --only_show --execute
#  Mostrar en pantalla los genomas disponibles de humano a partir del taxid:
      perl bin/Perl/get_NCBI_genome.pl -t 9606 -r all --only_show
#  Descargar los genomas de Salmonella YU15
    perl bin/Perl/get_NCBI_genome.pl -o "Salmonella" -i YU15 --execute --only_show
#  Mostrar la ayuda
      perl bin/Perl/get_NCBI_genome.pl -h
#################################33
      
PARAMETROS

ESto son los parametros de ejecusion del programa
perl bin/Perl/get_NCBI_genome.pl -a <accesion_id> -t <taxid> -s <species_taxid> -o <organism_name> -i <infraespecif_name> -r <[ all | major ]> --only_show --execute -f <fna|

PARAMETROS DE BUSQUEDA:
			-a|--accesion <accesion_id>		Busqueda por accesion_id (Ex: -a GCF_000001215.4) 
            -t <taxid>						Busqueda por taxid (Ex. -t 441960)
  			--species <species_taxid> 		Busqueda por specie_taxid (-s 1379910)
			-o|--organism <organism_name> 	Busqueda por nombre de Organismo	(-o "Homo sapiens" -o "Rufibacter sp. DG31D")
			-i|--subespecie <infraespecif_name> 	(-i DG31D)  Busqueda por nombre de subespecie,  de preferencia esta opcion debe ir acompañada de la opcion -o

PARAMETROS DE LA SALIDA
           -t|--result <all | major >		all:  regresa todos los resultados que cumplen las opciones de busqueda introducidas por el usuario
                                            major: regresa solo los resultados para organismo con Genoma Compelto, que son genoma de referencia en su especie y 
                                            tienen una liberacion de tipo "Major" (Default: major).  
                                            Puede no regresar resultados si el organismo solicitado, todavía no esta completamente secuenciado              
  		  --only_show  			Hace que este programa muestre los genomas a descargar o resultados obtenidos en pantalla
  		  --no_show  			Hace que se deshabilite muestrar los genomas a descargar o resultados obtenidos en pantalla
  		  --execute  			Ejecuta la descarga de los genomas.  
          -f|--file_type <file_type>  [fna |  gff ]  Especifica el tipo de formato del archivo que se desea descargar. Default:  se descargan los dos. 
          --output_path <path>  path de salida de los archivos
OTROS PARAMETROS
           -h|--help			Despliega esta ayuda
NOTAS
    Debe existir al menos un parametro de busqueda definido.
    Todos los parametros de salida, tienen un valor por default y por lo tanto no es obligatorio, definir ninguno.
####################################
DESCRIPTION
   Este programa descarga de NCBI el archivo del genoma completo en formato fasta y/o gff. 
   Este programa verificar la fecha del archivo archivo   ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt  y si no es la de hoy, la descarga.
   En este archivo busca el accesion_id, taxid, organism name o intraespecific name que al usuario le interesa descargar  
   
   Si la opcion --result all  es declarada,  se reportan todos los registros que cumplen con los parametros de entradas introducidos en el punto anterior
        si no,  solo se despliega la referencia(s) con  refseq_category igual a "reference genome",  con un nivel de ensamblado de "Complete Genome"  y una liberacion(release) tipo Major
        
   La opcion --only_show : despliga los resulados en pantalla
   La opcion -- execute  ejecuta via ftp la descarga de los genomas
   
   Si no se expecifica la opcion --file_type,  se descaga tanto el fna  como el gff     
   por default,  los genomas se descargan en el path X,  a menos que se indique lo contrario con la opcion:  --output_path
#
CREATE

1.Marzo.2016

AUTHOR
	 Veronica Jimenez Jacinto (email: vjimenez \@ ibt.unam.mx)
End_short_help
close HELP;
exit;
}

