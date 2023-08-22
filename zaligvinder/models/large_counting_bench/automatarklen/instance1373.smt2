(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]{9})([a-h,A-H,j-n,J-N,p,P,r-t,R-T,v-z,V-Z,0-9])([a-h,A-H,j-n,J-N,p-z,P-Z,0-9])(\d{6}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9"))) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (str.to_re "p") (str.to_re "P") (re.range "r" "t") (re.range "R" "T") (re.range "v" "z") (re.range "V" "Z") (re.range "0" "9")) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9")))))
; Filtered\s+Yeah\!\d+HXDownloadasdbiz\x2EbizUser-Agent\x3Awww\x2Eezula\x2EcomUser-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (re.++ (str.to_re "Filtered") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Yeah!") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.bizUser-Agent:www.ezula.comUser-Agent:etbuviaebe/eqv.bvv\u{0a}")))))
; /^\u{2f}[a-z\u{2d}\u{5f}]{90,97}\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 90 97) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (str.to_re ".php/U\u{0a}"))))
; /filename=[^\n]*\u{2e}xlsx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xlsx/i\u{0a}")))))
; ^(((\\\\([^\\/:\*\?"\|<>\. ]+))|([a-zA-Z]:\\))(([^\\/:\*\?"\|<>\. ]*)([\\]*))*)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "\u{5c}\u{5c}") (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re ".") (str.to_re " ")))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}"))) (re.* (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re ".") (str.to_re " "))) (re.* (str.to_re "\u{5c}"))))))))
(assert (< 200 (str.len X)))
(check-sat)
