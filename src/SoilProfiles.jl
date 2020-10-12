module SoilProfiles

    greet() = print("SoilProfiles v0.1.0")

    using DataFrames
    import Base.show, Base.length, DataFrames.nrow

    # define SoilProfileCollection type
    mutable struct SoilProfileCollection
        pidname::String
        site::DataFrame
        layer::DataFrame
    end

    # empty constructor
    SoilProfileCollection() = SoilProfileCollection("pid",
                                                    DataFrame(pid = Int64[]),
                                                    DataFrame(pid = Int64[],
                                                              top = Int64[],
                                                              bot = Int64[]))
    # site and layer accessor methods
    site(p::SoilProfileCollection) = p.site
    layer(p::SoilProfileCollection) = p.layer

    # profile ID name and profile ID vector accessors
    pidname(p::SoilProfileCollection) = p.pidname
    profile_id(p::SoilProfileCollection) = p.site[!, p.pidname]

    # basic DataFrame-like methods
    length(p::SoilProfileCollection) = nrow(p.site)
    nrow(p::SoilProfileCollection) = nrow(p.layer)

    # show method
    Base.show(io::IO, p::SoilProfileCollection) =
        print(io, "Profile ID: ", p.pidname,"; # of Profiles: ", nrow(p.site),
                  "\nSite data:\n", p.site,
                  "\n---\nLayer data:\n", p.layer,"\n")

    # extraction method
    function extract(p::SoilProfileCollection, i::Any, j::Any)
        pid = pidname(p)
        lyr = layer(p)
        sitesub = DataFrame(site(p)[i, :])
        jj = in.(lyr[!,pid], Ref(sitesub[!,pid]))
        gdf = combine(groupby(lyr[jj, :], pid)) do ldf
            ldf[in.(1:nrow(ldf), Ref(j)), :]
        end
        SoilProfileCollection(pid, sitesub, gdf)
    end

    # validity method (all layers must have a site)
    function isValid(p::SoilProfileCollection)
        pid = pidname(p)
        sum(.!in.(p.layer[!, pid], Ref(p.site[!, pid]))) == 0
    end

    # sites without layers are possible
    function sitesWithoutLayers(p::SoilProfileCollection)
        pid = pidname(p)
        sit = site(p)
        ii = .!in.(sit[!,pid], Ref(layer(p)[!,pid]))
        DataFrame(sit[ii,:])[!,pid]
    end

    # integrity method (site order matches horizon order)
    function checkIntegrity(p::SoilProfileCollection)

    end

    # topology method (no overlaps or gaps when top-depth sorted)
    function checkTopology(p::SoilProfileCollection)

    end

    # re-order sites (force horizon order to match [new] site order)
    function reorderSites(p::SoilProfileCollection)

    end

    export SoilProfileCollection, site, layer, pidname, profile_id, length, nrow,
           extract, isValid, sitesWithoutLayers


end # module
