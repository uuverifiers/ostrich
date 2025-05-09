(declare-const var0 String)
(declare-const re0 RegLan)
(declare-const cap String)

(assert (= re0 ((_ re.capture 1)
                (re.++
                  (str.to.re "<")
                  (re.*?
                    ((_ re.capture 2)
                     (re.union
                       (re.range "\x01" "\xff")
                       (str.to.re "\u{0a}"))))
                  (str.to.re ">")))))
(assert (= cap ((_ str.extract 2) var0
                (re.++
                  (re.*? re.allchar) re0 re.all))))

(assert (str.in.re var0 (re.* (re.range "\x01" "\xff"))))
(assert (str.in.re var0 (re.++ (re.*? re.allchar) re0 re.all)))
; match!==null
(assert (not (str.in.re cap (str.to.re "\x00"))))
;match[1]!==null
(assert (str.in.re cap (re.++ re.all (re.+ (re.range "a" "z")) re.all)))
;/[a-z]+/.test(match[1]) == true
(check-sat)
