cwlVersion: v1.0
class: CommandLineTool
baseCommand: [singularity, exec, docker://kernsuite/prefactor, python, /usr/lib/prefactor/scripts/amplitudes_losoto_3.py]

inputs:
  globaldbname:
    type: File
    doc: "input h5 parm file"
    inputBinding:
      position: 1

  n_chan:
    type: int?
    doc: "number of channels solved for per subband (i.e., number of solutions along frequencies axis of MS)"
    default: 4
    inputBinding:
      position: 3

  bad_sblist:
    type: int[]?
    inputBinding:
      position: 4

arguments:
 # calsource
 - valueFrom: "fitclock"
   position: 2

outputs:
  amplitude_array:
    type: File
    outputBinding:
      glob: "fitclock_amplitude_array.npy"


$namespaces:
  s: http://schema.org/
$schemas:
- https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"
