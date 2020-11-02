; function globUnescape (s) {
;   return s.replace(/\\(.)/g, '$1')
; }
(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg_all x 
    (re.++ (re.charrange (char.from-int 92) (char.from-int 92)) ((_ re.capture 1) re.allchar))
    (_ re.reference 1))))

(assert (str.in.re x (re.++ 
    (re.charrange (char.from-int 92) (char.from-int 92)) 
    (re.+ re.allchar))))

(assert (str.in.re y (re.++
    re.all
    (re.charrange (char.from-int 92) (char.from-int 92)) 
    re.all)))

(check-sat)
(get-model)
