# GROMACS trajectory and polymer-interface analysis

Legacy Fortran and shell tools for post-processing molecular-dynamics trajectories, with emphasis on polymer exposure at liquid interfaces.

## Functions and engineering applications

| Source | Observed function / inputs and outputs | Inferred engineering application |
|---|---|---|
| `AnalyzeGro4annotated.f` | Reads concatenated GRO frames from `md.gro` and a residue label from standard input; classifies target atoms as exposed above/below overlapping atoms and writes five ratios to `r.dat` | Comparing polymer surface exposure across cosolvent compositions [1] |
| `Downstream_TRJCONV.sh`, `Downstream_TRJCONV_DensityCalcu.sh` | Trajectory conversion and density-analysis commands | Preparing interfacial density profiles |
| `Downstream_MultipleCalculations.sh`, `Downstream_MultipleCalculations2.sh` | Calls legacy GROMACS tools for RDF, density, MSD, gyration, and energy | Comparing solvation, mobility, chain dimensions, and equilibration [2] |
| `Downstream_Hbond.sh`, `Downstream_GEnergyComputations.sh` | Hydrogen-bond and energy extraction wrappers | Relating association and energetic changes to composition |

These applications are interpretations of the code, not demonstrated performance claims. Atom exposure is not directly a surface tension, adsorption free energy, or solvent-accessible surface area.

## Example calls

Prerequisites: a fixed-form Fortran compiler, a compatible GROMACS environment, and simulation files generated separately. Build from source rather than relying on the archived executables:

```bash
gfortran -std=legacy -ffixed-line-length-none -fcheck=all \
  'AnalyzeGro4annotated.f' -o analyze_gro
# In a working directory containing md.gro, run interactively:
./analyze_gro
```

Enter the exact target residue identifier when prompted. The inspected source expects **10 frames**, at most **22,000 atoms**, and a four-character residue field. Adjust these source assumptions for other datasets before compilation. Output columns are cumulative maximum-side/total, cumulative top/total, cumulative bottom/total, current top/total, and current bottom/total.

For a legacy GROMACS 4.x installation, representative calls extracted from the workflow are:

```bash
g_density -f md_concat.trr -s md1.tpr -o density_z.xvg -dens mass -symm -d Z
g_msd -f md_concat.trr -s md1.tpr -o msd.xvg
```

Choose the intended molecular group interactively. The named inputs are external prerequisites. These calls were checked against the scripts but were not executed with trajectories in this review.

## Reproducibility and limitations

The scripts contain historical absolute paths, module names, numeric group selections, and ambiguous shell expansions such as `$XOH`; adapt these explicitly. Modern GROMACS CLI names and options differ. GRO coordinates normally use nm, while the Fortran radii include values such as 1.52 and 1.70 without conversion: resolve the unit convention before interpreting exposure ratios. The code applies x/y periodic images, modifies some z coordinates, and can divide by zero if the target is absent. Validate against hand-constructed frames, not only smooth-looking plots. No trajectory data or end-to-end reproduction is supplied here.

## Review scope and software citation

Documentation reviewed on 2026-10-08 against source commit [`382760ba805f`](https://github.com/gmongell/GromacsAnalyses/tree/382760ba805f5e2a78c59ecd5e5df11b79e2d6ec). “Observed” means supported by source inspection; engineering applications are reasoned possibilities unless explicitly demonstrated. Scholarly references provide methodological context and do not certify these implementations. Runtime validation is stated separately above.

For software attribution, cite Guy Francis Mongelli, *GromacsAnalyses*, the [repository](https://github.com/gmongell/GromacsAnalyses), the exact commit used, and your access date. Also cite the relevant method publications and any original third-party contributors. No unverified software DOI or release version is assigned by this documentation.

## Scholarly references

1. “The surface activity of polymers in cosolvated systems determined from computational simulation.” *Polymer* (2016). [DOI: 10.1016/j.polymer.2015.11.003](https://doi.org/10.1016/j.polymer.2015.11.003). Related polymer/cosolvent surface-activity research. The publisher indexes the journal publication as 2016; the DOI contains 2015. Exact reproduction requires the original inputs and analysis conventions.

2. M. J. Abraham et al. (2015). “GROMACS: High performance molecular simulations through multi-level parallelism from laptops to supercomputers.” *SoftwareX* 1–2, 19–25. [DOI: 10.1016/j.softx.2015.06.001](https://doi.org/10.1016/j.softx.2015.06.001). Background for the simulation and analysis ecosystem; this does not establish compatibility with the legacy scripts.

## Ownership and existing license notices

Copyright (c) 2025 Guy Francis Mongelli

The existing project notice declares Apache License 2.0 for project code. Documentation, prose, and figures are declared CC BY 4.0; notebook code cells are Apache-2.0 and narrative/figures CC BY 4.0. Preserve all file-level and third-party notices. This README update does not change ownership or licensing terms.
