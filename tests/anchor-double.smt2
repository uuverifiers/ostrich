(set-option :produce-models true)
(set-option :inline-size-limit 10000)

(declare-const var0 String)
(assert (str.in.re
          (str.replace_cg_all var0
                              (re.++
                                re.begin-anchor
                                re.begin-anchor
                                (re.opt
                                  ((_ re.capture 1)
                                   (re.range "a" "a")))
                                (re.range "a" "a")
                                re.end-anchor
                                re.end-anchor)
                              (_ re.reference 1))
          (re.range "a" "a")))

(check-sat)
(get-model)
