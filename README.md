<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use..
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- [![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url] -->

<!-- PROJECT LOGO -->
 <!-- ![ProServelogo](images/aws_logo.png "proservelogo") -->
<div align="center">
<br />
<h3 align="center">CI/CD pipeline for terraform</h3>

  <p align="center">
     A CI/CD pipeline for validating terraform code,testing against aws and cis best practices,and deploying the code.Built using terraform
    <br />
  </p>
</div>

![Infrastructure Diagram2](images/diagram2.png "Infrastructure Diagram2")

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- GETTING STARTED -->
### Resources created 

1. CodePipeline role, policy and policy attachment
2. Role, policy and policy attachment for each CodeBuild stage
3. KMS key
4. S3 Bucket for logging/Block public access
5. S3 Bucket for pipeline artifacts/Block public access
6. CodeBuild stage for terraform plan
7. CodeBuild stage for security check using checkov
8. Manual Approval stage
9. CodeBuild deploy stage using terraform apply
10. CodeStar connection to GitHub repo

### Getting started

Create a user in your aws account that has permissions to create the infrastructure resources.

### Prerequisites

1. You have terraform installed on your local machine
2. You have an AWS account and user with access to perform the provisioning of infrastructrue
3. You have  AWSCLI tools installed


### Installation

1. update ./aws/config and ./aws/credentials with the user and access keys needed to acces your aws account
   ```sh
   aws configure
   ```

   Enter the information for user created in your aws account that will be used to deploy terraform.

   ```sh
   AWS Access Key ID [****************XXXX]: 
   AWS Secret Access Key [****************XXXX]: 
   Default region name [us-east-1]: 
   Default output format [json]:
   ```
2. Clone the repo
   ```sh
   git clone https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git
   ```
3. set your repository information in main.tf
   ```sh
   full_repo_name = "GitHubUsername/RepositoryName"
   git_hub_url = "https://github.com/Username/RepositoryName.git"
   ```
4. set the region variable to your desired region in variables.tf
   ```sh
   variable "region", default = "us-west-2'
   ```
5. initialize terraform
   ```sh
    terraform init
   ```
6. apply terraform
   ```sh
    terraform apply
   ```

### Important

Note that after the enviroment is built you need to go to CodePipeline ->  Settings -> Connections -> Update Pending Connection in order to run the pipeline with your GitHub repo.

<p align="right">(<a href="#top">back to top</a>)</p>

See the [open issues](https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution/-/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>





<!-- LICENSE -->
## License

 See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Austin Miller -  ausmillr@amazon.com

Project Link: [https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git](https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/GitHub-account-username/CI_CD-solution-with-terrafrom.svg?style=for-the-badge
[contributors-url]: https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/GitHub-account-username/CI_CD-solution-with-terrafrom.svg?style=for-the-badge
[forks-url]: https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution/-/network/members
[stars-shield]: https://img.shields.io/github/stars/GitHub-account-username/CI_CD-solution-with-terrafrom.svg?style=for-the-badge
[stars-url]: https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git/-/stargazers
[issues-shield]: https://img.shields.io/github/issues/GitHub-account-username/CI_CD-solution-with-terrafrom.svg?style=for-the-badge
[issues-url]: https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution/-/issues
[license-shield]: https://img.shields.io/github/license/GitHub-account-username/CI_CD-solution-with-terrafrom.svg?style=for-the-badge
[license-url]: https://gitlab.aws.dev/ausmillr/ci-cd-pipeline-terraform-solution.git/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/austin-miller-064b45128
[product-screenshot]: images/screenshot.png
