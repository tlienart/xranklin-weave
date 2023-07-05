using Weave

function hfun_insert_weave(ps)
    weave_rpath = first(ps)
    weave_fpath = joinpath(path(:folder), weave_rpath)
    if !(isfile(weave_fpath) & endswith(weave_fpath, ".jmd"))
        return ""
    end

    # keep track of changes in the file.
    attach(weave_rpath)

    # Calling weave in a temp dir
    print("Weaving... ")
    t = tempname()
    weave(weave_fpath, out_path=t)
    weave_file_name = splitext(splitpath(weave_fpath)[end])[1]
    gen_content = read(joinpath(t, weave_file_name * ".html"), String)
    println("✓ [done].")

    # extract body
    start  = nextind(gen_content, last(findfirst("<BODY>", gen_content)))
    finish = prevind(gen_content, first(findfirst("</BODY>", gen_content)))
    return gen_content[start:finish]
  end
