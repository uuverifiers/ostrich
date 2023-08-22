(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}jpeg([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpeg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((\+)?(\d{2})[-])?(([\(])?((\d){3,5})([\)])?[-])|(\d{3,5})(\d{5,8}){1}?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (str.to_re "-")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) ((_ re.loop 1 1) ((_ re.loop 5 8) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^((AL)|(AK)|(AS)|(AZ)|(AR)|(CA)|(CO)|(CT)|(DE)|(DC)|(FM)|(FL)|(GA)|(GU)|(HI)|(ID)|(IL)|(IN)|(IA)|(KS)|(KY)|(LA)|(ME)|(MH)|(MD)|(MA)|(MI)|(MN)|(MS)|(MO)|(MT)|(NE)|(NV)|(NH)|(NJ)|(NM)|(NY)|(NC)|(ND)|(MP)|(OH)|(OK)|(OR)|(PW)|(PA)|(PR)|(RI)|(SC)|(SD)|(TN)|(TX)|(UT)|(VT)|(VI)|(VA)|(WA)|(WV)|(WI)|(WY))$
(assert (str.in_re X (re.++ (re.union (str.to_re "AL") (str.to_re "AK") (str.to_re "AS") (str.to_re "AZ") (str.to_re "AR") (str.to_re "CA") (str.to_re "CO") (str.to_re "CT") (str.to_re "DE") (str.to_re "DC") (str.to_re "FM") (str.to_re "FL") (str.to_re "GA") (str.to_re "GU") (str.to_re "HI") (str.to_re "ID") (str.to_re "IL") (str.to_re "IN") (str.to_re "IA") (str.to_re "KS") (str.to_re "KY") (str.to_re "LA") (str.to_re "ME") (str.to_re "MH") (str.to_re "MD") (str.to_re "MA") (str.to_re "MI") (str.to_re "MN") (str.to_re "MS") (str.to_re "MO") (str.to_re "MT") (str.to_re "NE") (str.to_re "NV") (str.to_re "NH") (str.to_re "NJ") (str.to_re "NM") (str.to_re "NY") (str.to_re "NC") (str.to_re "ND") (str.to_re "MP") (str.to_re "OH") (str.to_re "OK") (str.to_re "OR") (str.to_re "PW") (str.to_re "PA") (str.to_re "PR") (str.to_re "RI") (str.to_re "SC") (str.to_re "SD") (str.to_re "TN") (str.to_re "TX") (str.to_re "UT") (str.to_re "VT") (str.to_re "VI") (str.to_re "VA") (str.to_re "WA") (str.to_re "WV") (str.to_re "WI") (str.to_re "WY")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
