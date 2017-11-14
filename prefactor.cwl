cwlVersion: v1.0
class: Workflow

cwlVersion: v1.0
requirements:
  ScatterFeatureRequirement: {}

inputs:
  ms_array: Directory[]
  reference_station: string
  avg.freqstep: int
  avg.timestep: int
  flag.baseline: string

outputs:
  phase_xx_yy_offset:
    type: File
    outputSource: phase/phase_xx_yy_offset

  freqs_for_phase_array:
    type: File
    outputSource: phase/freqs_for_phase_array

  phase_array:
    type: File
    outputSource: phase/phase_array

  station_names:
    type: File
    outputSource: phase/station_names

  polXX_dirpointing:
    type: File
    outputSource: plot_cal_phases/polXX_dirpointing

  polYY_dirpointing:
    type: File
    outputSource: plot_cal_phases/polYY_dirpointing


  dtec_allsols:
    type: File
    outputSource: plot/dtec_allsols

  dclock_allsols:
    type: File
    outputSource: plot/dclock_allsols

  amp_allsols:
    type: File
    outputSource: plot/amp_allsols

steps:
  ndppp_prep_cal:
    run: steps/ndppp_prep_cal.cwl
    in:
      msin: ms_array
      avg.freqstep: avg.freqstep
      avg.timestep: avg.timestep
      flag.baseline: flag.baseline
    scatter: msin
    out:
        [msout]

  sky_cal:
    run: steps/sky_cal.cwl
    in:
      ms: ndppp_prep_cal/msout
    scatter: ms
    out:
      [skymodel]

  calib_cal:
    run: steps/calib_cal.cwl
    in:
      observation: ndppp_prep_cal/msout
      catalog: sky_cal/skymodel
    scatter:
      - observation
      - catalog
    scatterMethod: dotproduct
    out:
      [mscalib]

  h5imp_cal:
    run: steps/h5imp_cal.cwl
    in:
      ms_array: calib_cal/mscalib
    out:
      [losoto_h5]

  fitclock:
    run: steps/fitclock.cwl
    in:
      globaldbname: h5imp_cal/losoto_h5
    out:
      [dTEC_1st, dTEC_1st.sm, dclock_1st, dclock_1st.sm]

  ampl:
    run: steps/ampl.cwl
    in:
      globaldbname: h5imp_cal/losoto_h5
    out:
      [amplitude_array]

  plot:
    run: steps/plots.cwl
    in:
      amplitude_array: ampl/amplitude_array
      dclock_1st: fitclock/dclock_1st
      dclock_1st.sm: fitclock/dclock_1st.sm
      dtec_1st.sm: fitclock/dTEC_1st.sm
    out:
       [dtec_allsols, dclock_allsols, amp_allsols]

  phase:
    run: steps/phase.cwl
    in:
      losoto: h5imp_cal/losoto_h5
    out:
      - freqs_for_phase_array
      - phase_array
      - station_names
      - phase_xx_yy_offset

  plot_cal_phases:
    run: steps/plot_cal_phases.cwl
    in:
      h5parm: h5imp_cal/losoto_h5
      reference_station: reference_station
    out:
      [polXX_dirpointing, polYY_dirpointing]


$namespaces:
  s: http://schema.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"


