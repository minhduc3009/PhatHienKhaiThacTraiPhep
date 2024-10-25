import '../../../constants/image_constant.dart';

class Article {
  final String title;
  final String subtitle;
  final String image;
  final String sumber;

  const Article({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.sumber,
  });
}

List<Article> informasi = const [
  Article(
    title: 'Leaf spot disease', //Bệnh đốm lá
    subtitle: '',
    image: ImageConstant.benhdomlaoi,
    sumber:
        'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-om-la-oi.html',
  ),
  Article(
    title: 'Dry shoot disease', //'Bệnh khô đọt',
    subtitle: '',
    image: ImageConstant.benhkhodot,
    sumber: 'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-kho-ot.html',
  ),
  Article(
    title: 'Leaf rust disease', //'Bệnh rỉ sắt',
    subtitle: '',
    image: ImageConstant.benhriset,
    sumber:
        'https://bacsinongnghiep360.blogspot.com/2024/01/benh-ri-sat-do-nam-puccinia-psidii.html',
  ),
  Article(
    title: 'leaf anthracnose disease', //'Bệnh thán thư',
    subtitle: '',
    image: ImageConstant.benhthanthu,
    sumber:
        'https://bacsinongnghiep360.blogspot.com/2024/01/21-benh-than-thu-do-nam-glomerella.html',
  ),
  Article(
    title: 'Healthy Plants', //'Cây khỏe mạnh',
    subtitle: 'Giới Thiệu',
    image: 'assets/images/article_image1.jpeg',
    sumber: 'https://bacsinongnghiep360.blogspot.com/p/gioi-thieu_25.html',
  ),
  Article(
    title: 'Aphid disease', //'Bệnh rầy mềm',
    subtitle: '',
    image: ImageConstant.benhraymem,
    sumber:
        'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-ray-mem-cay-oi.html',
  ),
  Article(
    title: 'Powdery mildew disease', //'Bệnh rệp phấn trắng',
    subtitle: '',
    image: ImageConstant.benhrepphantrangoi,
    sumber:
        'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-rep-phan-trang-oi.html',
  ),
  Article(
    title: 'Leaf fly disease', //'Bệnh ruồi đục lá',
    subtitle: '',
    image: ImageConstant.benhruoiduc,
    sumber:
        'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-ruoi-uc-trai-oi.html',
  ),
  Article(
    title: 'Fruit fly disease', // Bệnh ruồi đục quả
    subtitle: '',
    image: ImageConstant.benhruoiduc,
    sumber:
        'https://bacsinongnghiep-en.blogspot.com/2023/10/benh-ruoi-uc-trai-oi.html',
  ),
];
